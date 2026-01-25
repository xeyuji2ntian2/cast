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

echo -e "\n\n\n\n\e[32m======================== Update & upgrade ========================\e[0m\n\n\n\n"

pkg update && pkg upgrade -y -o Dpkg::Options::="--force-confold"




echo -e "\n\n\n\n\e[32m======================== install make ========================\e[0m\n\n\n\n"  
pkg install make -y

echo -e "\n\n\n\n\e[32m======================== install autoconf ========================\e[0m\n\n\n\n"  
pkg install autoconf -y 

echo -e "\n\n\n\n\e[32m======================== install automake ========================\e[0m\n\n\n\n"  
pkg install automake -y

echo -e "\n\n\n\n\e[32m======================== install libtool ========================\e[0m\n\n\n\n"  
pkg install libtool -y

echo -e "\n\n\n\n\e[32m======================== install pkg-config========================\e[0m\n\n\n\n"  
pkg install pkg-config -y

echo -e "\n\n\n\n\e[32m======================== install openssl ========================\e[0m\n\n\n\n"  
pkg install openssl -y

echo -e "\n\n\n\n\e[32m======================== install libcurl ========================\e[0m\n\n\n\n"  
pkg install libcurl -y

echo -e "\n\n\n\n\e[32m======================== install zlib ========================\e[0m\n\n\n\n"  
pkg install zlib -y

echo -e "\n\n\n\n\e[32m======================== install git ========================\e[0m\n\n\n\n"  
pkg install git -y

echo -e "\n\n\n\n\e[32m======================== install clang ========================\e[0m\n\n\n\n"  
pkg install clang -y

echo -e "\n\n\n\n\e[32m======================== Build CCMINER (CPU ONLY) ========================\e[0m\n\n\n\n"
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
