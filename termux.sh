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
pkg install dos2unix make autoconf automake libtool pkg-config openssl libcurl zlib git clang -y 

echo -e "\n\n\n\n\e[32m======================== Build CCMINER (CPU ONLY) ========================\e[0m\n\n\n\n"
cd $HOME
git clone https://github.com/Oink70/ccminer-verus.git
cd ccminer-verus

export CC=clang
export CXX=clang++
export CFLAGS="-O3 -march=native"
export CXXFLAGS="-O3 -march=native"


./autogen.sh

export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig

./configure \
  --disable-cuda \
  --disable-opencl \
  --with-crypto \
  --with-curl \
  CPPFLAGS="-I$PREFIX/include" \
  LDFLAGS="-L$PREFIX/lib" \
  --prefix=$PREFIX

make -j$(nproc)

echo "=== BUILD RESULT ==="
file ccminer
./ccminer --help || true

echo "✅ CCMINER BUILD SUCCESS"
