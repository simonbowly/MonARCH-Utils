
# TL;DR

* The module system for using Python on MonARCH clashes with virtualenvs and makes installing/upgrading packages tricky (especially gurobipy)
* These `venvwrapper` scripts create virtualenvs that also load the required modules and fix import paths so things don't break (and they're pure bash scripts that don't depend on libraries missing from MonARCH's python installations)

Run this from your MonARCH login node to set it up (and add the `source` command it suggests to your `.bashrc`):

```
curl -sSf https://raw.githubusercontent.com/simonbowly/MonARCH-Utils/master/venvwrapper/install.sh | bash
```

## Tricks for young players

When you request Gurobi access on MonARCH, you'll likely be able to `module load gurobi/..` and run it in fairly short order (a few hours) on the login nodes, but **the necessary permissions to use it on the job nodes don't propagate for a day or two**.
So you might find that while you can test scripts from the login node, an `sbatch` job will fail ... just wait it out.

## venvwrapper usage

These scripts handle loading modules and setting paths in the right order so that the virtualenv starts up properly.
They use the mkvirtualenv/workon/rmvirtualenv workflow from virtualenvwrapper (which isn't installed on MonARCH so won't work without significant fiddling).

Create a virtualenv:

    # Finds a Python3.7 module to load, creates a virtualenv under ~/virtualenvs/myVenv
    mkvirtualenv --python=3.7 myVenv

    # Create a Python3.7 virtualenv and make gurobipy available in it
    mkvirtualenv --python=3.7 --gurobi=9 myGurobiVenv

    # Create a virtualenv from a local python interpreter (specify compiler used for build)
    mkvirtualenv --python=~/python/bin/python3.8 --gcc=8 py38_local

Activate a virtualenv (the required python/gurobi modules are loaded automatically):

    # If you've loaded venvwrapper in your shell (has autocomplete for interactive shells)
    workon myVenv

    # Does the same thing without needing to load venvwrapper
    source ~/virtualenvs/myVenv/bin/activate

Delete a virtualenv:

    rmvirtualenv myVenv

# Long Version

If you're interested in how paths and modules work against each other and what these scripts do to fix them, see below.

## Python virtualenvs

These can be kind of annoying as a result of the module system used on the cluster.
When you `module load python/*` it sets 3 variables:
* `PATH` - to find the python executable,
* `LD_LIBRARY_PATH` - to load the python shared library, and
* `PYTHONPATH` - to find python packages. Unfortunately this is configured badly: it adds two paths, one of which is checked by default if you use the interpreter on `PATH`, and a second which doesn't exist.

The `PYTHONPATH` issue causes problems because if you make a virtualenv you're likely to end up with conflicting packages between the system and your local install.
As a result making a virtualenv and installing new packages tends to break:

```
module load python/3.7.2-gcc6
python3 -m venv my_venv
source my_venv/bin/activate
pip install pip --upgrade       # Installs a newer pip in the virtualenv
pip list                        # Crashes due to path confusion
```

A workflow that does work to set up the virtualenv is this:

```
module load python/3.7.2-gcc6
unset PYTHONPATH
python3 -m venv venv_dir
source venv_dir/bin/activate
pip install pip --upgrade
```

Then to use the virtualenv you need to run:

```
module load python/3.7.2-gcc6
unset PYTHONPATH
source venv_dir/bin/activate
# python and pip now work normally
```

## gurobipy in a virtualenv

Another problematic task is getting gurobipy to work with a virtualenv.
There's a Gurobi python executable that you can use directly, but if you want to install other packages alongside it, you'll run into problems (mostly since Gurobi's python is missing a good portion of the standard library).
Create a virtualenv as above, then to use it successfully with gurobipy, run the following:

    # Use whichever versions you need here
    module load gurobi/9.0.0 python/3.7.2-gcc6
    source venv_dir/bin/activate

    # Make sure the python major version below matches the module you loaded
    export PYTHONPATH="$GUROBI_HOME/lib/python3.7_utf32"

    # Test
    python -c "import gurobipy; gurobipy.Env()"
