
# TL;DR

* The `module` system for using Python on MonARCH clashes with virtualenvs and makes installing/upgrading packages tricky (especially gurobipy)
* These `venvwrapper` scripts create virtualenvs that also load the required modules and fix import paths so things don't break (and they're pure bash scripts that don't depend on libraries missing from MonARCH's python installations)

```
curl -sSf https://raw.githubusercontent.com/simonbowly/MonARCH-Utils/master/venvwrapper/install.sh | bash
```

# Python virtualenvs

These can be kind of annoying as a result of the module system used on the cluster.
When you `module load python/*` it sets 3 variables:
* `PATH` - to find the python executable
* `LD_LIBRARY_PATH` - to load the python shared/dynamic library
* `PYTHONPATH` - to find python packages (unfortunately this is configured badly; it add's two paths, one of which is checked by default if you use the interpreter on `PATH`, and a second which doesn't exist). So really this variable shouldn't be set by the module system.

The `PYTHONPATH` issue causes problems because if you make a virtualenv you're likely to end up with conflicting packages between the system and your local.
A workflow that does work to set up the virtualenv is this:

    # Create a virtualenv in venv_dir
    module load python/3.7.2-gcc6
    unset PYTHONPATH
    python3 -m venv ./venv_dir
    source ./venv_dir/bin/activate
    pip install pip --upgrade           # Probably a wise idea

Then when using the virtualenv you should run:

    module load python/3.7.2-gcc6
    unset PYTHONPATH
    source ./venv_dir/bin/activate
    # do python or pip operations

# `gurobipy` in a virtualenv

Another issue we've run into: getting gurobipy to work with a virtualenv.
There's a Gurobi python executable that you can use directly, but if you want to install other packages alongside it, you'll run into problems.
Create a virtualenv as above, then to use it successfully with gurobipy, run the following:

    # Use whichever versions you need here
    module load gurobi/9.0.0 python/3.7.2-gcc6
    source ./venv_dir/bin/activate

    # Make sure the python major version below matches the module you loaded
    export PYTHONPATH="$GUROBI_HOME/lib/python3.7_utf32"

    # Test
    python -c "import gurobipy; gurobipy.Env()"

# Wrapper scripts

I wrote some wrapper scripts to handle all of this, including loading the required modules.
They use the mkvirtualenv/workon/rmvirtualenv workflow from virtualenvwrapper (which isn't installed on MonARCH so won't work).

Create a virtualenv:

    # Finds a 3.7 module to load, creates a venv under ~/virtualenvs/myVenv
    mkvirtualenv --python=3.7 myVenv

    # Be more specific about your modules if you like ...
    mkvirtualenv --python=3.7.2-gcc myVenv

Activate a virtualenv (from login node or on a job script):

    # Activate a virtualenv (the required modules are loaded automatically)
    workon myVenv

    # This does the same thing (but workon has autocomplete for interactive shells)
    source ~/virtualenvs/myVenv/bin/activate

Delete a virtualenv:

    # Destroy your virtualenv (just deletes the directory, but has autocomplete)
    rmvirtualenv myVenv

# Trick for young players

When you request Gurobi access on MonARCH, you'll likely be able to `module load gurobi/..` and run it in fairly short order (a few hours) on the login nodes, but **the necessary permissions to use it on the job nodes don't propagate for a day or so**.
Try not to waste a day (like we did) speculating why it works from `monarch-login2` but fails in an `sbatch` job ... just wait it out.
