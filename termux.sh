#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "scrip termux.sh di gihub action -> docker android emulator -> termux"
echo "build cpuminer-opt"

echo "wajib di setting" # <<< PENTING
export HOME=/data/data/com.termux/files/home
export PREFIX=/data/data/com.termux/files/usr
export PATH=$PREFIX/bin:$PATH

# TMPDIR exec-capable # <<< PENTING
export TMPDIR=$HOME/tmp
mkdir -p $TMPDIR
chmod 700 $TMPDIR
export CONFIG_SHELL=$PREFIX/bin/bash

echo "[1/4] Update Termux di github action"
echo"setingan ini bisa jalan"
pkg update && pkg upgrade -y -o Dpkg::Options::="--force-confold" # <<< PENTING

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
  dos2unix \
  binutils
  
echo "dari sini mungkin dan pasti akan ada gagal"

echo "[2/4] Clone miner"
cd $HOME
rm -rf termux-miner
git clone https://github.com/wong-fi-hung/termux-miner.git
cd termux-miner

echo "[3/4] Build (native clang + lld)"
dos2unix *.sh || true
chmod +x *.sh || true

export CC=clang
export CXX=clang++
export LD=ld.lld          # <<< FIX UTAMA
export AR=llvm-ar
export RANLIB=llvm-ranlib
export STRIP=llvm-strip

export CFLAGS="-O2 -fPIC"
export LDFLAGS=""

./autogen.sh || true

./configure \
  --disable-assembly

make -j$(nproc)

echo "[4/4] Test"
file cpuminer
./cpuminer -h || true

echo "✅ BUILD SUCCESS (Termux native, GA-safe)"

