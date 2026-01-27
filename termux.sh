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
pkg install -y \
  curl \
  libtool \
  automake \
  libjansson \
  libcurl \
  libgmp \
  openssl \
  build-essential \
  clang binutils \
  git
git clone https://github.com/JayDDee/cpuminer-opt.git
cd cpuminer-opt
./build.sh
