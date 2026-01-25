#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

export HOME=/data/data/com.termux/files/home
export PREFIX=/data/data/com.termux/files/usr
export PATH=$PREFIX/bin:$PATH

echo "=== TERMUX ENV ==="
whoami
id
uname -a

if [ "$(id -u)" = "0" ]; then
  echo "❌ ERROR: running as root"
  exit 1
fi

echo "=== Update & upgrade ==="
yes | pkg update && pkg upgrade -y



echo "=== install git ==="  
yes | pkg install git -y

echo "=== install clang ==="  
yes | pkg install clang -y

echo "=== install make ==="  
yes | pkg install make -y

echo "=== install autoconf ==="  
yes | pkg install autoconf -y 

echo "=== install automake ==="  
yes | pkg install automake -y

echo "=== install libtool ==="  
yes | pkg install libtool -y

echo "=== install pkg-config==="  
yes | pkg install pkg-config -y

echo "=== install openssl ==="  
yes | pkg install openssl -y

echo "=== install libcurl ==="  
yes | pkg install libcurl -y

echo "=== install zlib ==="  
yes | pkg install zlib -y

echo "=== Build CCMINER (CPU ONLY) ==="

cd $HOME
git clone https://github.com/Oink70/ccminer.git
cd ccminer

export CC=clang
export CXX=clang++
export CFLAGS="-O2"
export LDFLAGS=""

./autogen.sh

export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig

./configure \
  --disable-cuda \
  --disable-opencl \
  --with-crypto \
  CPPFLAGS="-I$PREFIX/include" \
  LDFLAGS="-L$PREFIX/lib" \
  --prefix=$PREFIX

make -j$(nproc)

echo "=== BUILD RESULT ==="
file ccminer
./ccminer --help || true

echo "✅ CCMINER BUILD SUCCESS"
