#!/data/data/com.termux/files/usr/bin/bash

set -e

echo "scrip termux.sh di gihub action -> docker android emulator -> termux"
echo "build cpuminer-opt"
echo "jangan ada yg di hapus # nya itu dari chatgpt yg error"
echo "wajib di setting"

export HOME=/data/data/com.termux/files/home
export PREFIX=/data/data/com.termux/files/usr
export PATH=$PREFIX/bin:$PATH

# TMPDIR exec-capable
export TMPDIR=$HOME/tmp
mkdir -p $TMPDIR
chmod 700 $TMPDIR
export CONFIG_SHELL=$PREFIX/bin/bash

echo "[1/4] Update Termux di github action"
echo "setingan ini bisa jalan"
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
  dos2unix \
  binutils


echo "dari sini mungkin dan pasti akan ada gagal"
echo "[2/4] Clone miner"
cd $HOME
rm -rf termux-miner
git clone https://github.com/JayDDee/cpuminer-opt.git
cd cpuminer-opt

echo "[3/4] Build (native clang + lld)"
dos2unix *.sh || true
chmod +x *.sh || true


# export CFLAGS="-O2 -fPIC"
# export CFLAGS="-O2 -fPIC -include unistd.h"
#export CFLAGS="-O2 -fPIC -include unistd.h -DNO_AFFINITY"
export CC=clang
export CXX=clang++
export LD=ld.lld
export AR=llvm-ar
export RANLIB=llvm-ranlib
export STRIP=llvm-strip

export LDFLAGS=""
export CFLAGS="-O2 -fPIC -U__linux__ -D__ANDROID__ -include unistd.h -DNO_AFFINITY"

./autogen.sh || true

./configure \
  --disable-assembly

echo "[PATCH] Disable CPU affinity (hard kill for Android)"

CPU_FILE="cpu-miner.c"

if grep -q "cpu_set_t" "$CPU_FILE"; then
  echo "patching affinity block in $CPU_FILE"
  sed -i '
    /cpu_set_t/{
      i #if 0 /* ANDROID: disable cpu affinity */
      :a
      n
      /}/!ba
      a #endif
    }
  ' "$CPU_FILE"
else
  echo "⚠️ cpu_set_t not found, skip"
fi

make -j$(nproc)

echo "[4/4] Test"
file cpuminer
./cpuminer -h || true

echo "✅ BUILD SUCCESS (Termux native, GA-safe)"
