INSTALL_DIR=${HOME}/monarch-venvwrapper
URLBASE=https://raw.githubusercontent.com/simonbowly/MonARCH-Utils/master/venvwrapper

mkdir -p ${INSTALL_DIR}
for fname in activate.patch mkvirtualenv venvwrapper.sh; do
    curl -sSf ${URLBASE}/${fname} --output ${INSTALL_DIR}/${fname}
done

echo "Done! Scripts installed to ${INSTALL_DIR}."
echo "Run 'source ${INSTALL_DIR}/venvwrapper.sh' from your shell"
echo "to start using the scripts now, or add to your .bashrc to load on login"
