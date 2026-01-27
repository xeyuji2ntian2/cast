#!/data/data/com.termux/files/usr/bin/bash
set -e

export HOME=/data/data/com.termux/files/home
export PREFIX=/data/data/com.termux/files/usr
export PATH=$PREFIX/bin:$PATH

echo "[1/4] Update Termux"
pkg update && pkg upgrade -y -o Dpkg::Options::="--force-confold"
pkg install -y \
  clang \
  make \
  automake \
  autoconf \
  libtool \
  pkg-config \
  git \
  libcurl \
  libjansson \
  openssl \
  dos2unix

echo "[2/4] Clone miner"
cd $HOME
rm -rf termux-miner
git clone https://github.com/wong-fi-hung/termux-miner.git
cd termux-miner

echo "[3/4] Build (native clang)"
dos2unix *.sh || true
chmod +x *.sh || true

export CC=clang
export CXX=clang++
export CFLAGS="-O2 -fPIC"
export LDFLAGS=""

# termux-miner biasanya sudah siap configure
./autogen.sh || true
./configure \
  --disable-assembly
  #--host=android \
  #--build=android

make -j$(nproc)

echo "[4/4] Test"
./cpuminer -h

echo "✅ BUILD SUCCESS (native termux)"
