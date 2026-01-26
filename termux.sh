#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

# Setup Path
export HOME=/data/data/com.termux/files/home
export PREFIX=/data/data/com.termux/files/usr
export PATH=$PREFIX/bin:$PATH
export TMPDIR=$PREFIX/tmp

mkdir -p $TMPDIR
cd $HOME

# Update & Install Dependensi Lengkap
pkg update && pkg upgrade -y -o Dpkg::Options::="--force-confold"
pkg install -y libjansson build-essential clang binutils git

SYSCTL_SRC="$PREFIX/include/linux/sysctl.h"
SYSCTL_DST="$PREFIX/include/linux/sys/sysctl.h"

if [ -f "$SYSCTL_SRC" ]; then
  mkdir -p "$(dirname "$SYSCTL_DST")"
  cp -f "$SYSCTL_SRC" "$SYSCTL_DST"
fi

# ===============================
# Clone CCMINER
# ===============================
if [ ! -d ccminer ]; then
  git clone --depth=1 https://github.com/Darktron/ccminer.git
fi

cd ccminer

chmod +x autogen.sh configure.sh build.sh start.sh

# ===============================
./autogen.sh

CFLAGS="-O2 -march=armv7-a -mfpu=neon -mfloat-abi=softfp" \
./configure --host=arm-linux-androideabi

make -j$(nproc)
