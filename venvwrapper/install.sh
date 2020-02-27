INSTALL_DIR=${HOME}/monarch-venvwrapper
URLBASE=https://raw.githubusercontent.com/simonbowly/MonARCH-Utils/master/venvwrapper

mkdir -p ${INSTALL_DIR}
for fname in activate.patch mkvirtualenv venvwrapper.sh; do
    curl -sSf ${URLBASE}/${fname} --output ${INSTALL_DIR}/${fname}
done

chmod +x ${INSTALL_DIR}/mkvirtualenv

echo "Done! Scripts installed to ${INSTALL_DIR}."
echo
echo "Run 'source ${INSTALL_DIR}/venvwrapper.sh' from your shell"
echo "to start using the scripts now, or add to your .bashrc to load on login."
echo
echo "Usage:"
echo "    # Create a Python3.7 virtualenv"
echo "    mkvirtualenv --python=3.7 myVenv"
echo "    # Create a Python3.7 virtualenv and make gurobipy available in it"
echo "    mkvirtualenv --python=3.7 --gurobi=9 myGurobiVenv"
echo "    # Activate a virtualenv (either will work"
echo "    workon myVenv     # OR"
echo "    source ~/virtualenvs/myVenv/bin/activate"
echo "    # Delete a virtualenv"
echo "    rmvirtualenv myVenv"
