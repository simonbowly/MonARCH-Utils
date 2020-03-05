set -e

WORK_DIR=${HOME}/packages
INSTALL_DIR=${HOME}/python
PY_VERSION=3.8.2
MD5_HASH=e9d6ebc92183a177b8e8a58cad5b8d67

# Download and extract Python source
mkdir -p ${WORK_DIR} && cd ${WORK_DIR}
FILE_NAME="Python-${PY_VERSION}.tar.xz"
rm -f ${FILE_NAME}
wget https://www.python.org/ftp/python/${PY_VERSION}/${FILE_NAME}
echo "${MD5_HASH}  ${FILE_NAME}" > MD5SUMS
md5sum --check MD5SUMS
tar xf ${FILE_NAME}

# Configure, build, install
cd Python-${PY_VERSION}
module load libffi/3.2.1 gcc/6.1.0
./configure --prefix=${INSTALL_DIR} --with-system-ffi --enable-optimizations
sed -i "s|L/usr/local/libffi/3.2.1/lib |L/usr/local/libffi/3.2.1/lib64 |g" Makefile
make
make install

echo "DONE"
