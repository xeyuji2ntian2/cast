#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

# Setup Path
export HOME=/data/data/com.termux/files/home
export PREFIX=/data/data/com.termux/files/usr
export PATH=$PREFIX/bin:$PATH

# FIX: TMPDIR must be exec-capable
export TMPDIR=$HOME/tmp
mkdir -p $TMPDIR
chmod 700 $TMPDIR

export CONFIG_SHELL=$PREFIX/bin/bash

cd $HOME

pkg update && pkg upgrade -y -o Dpkg::Options::="--force-confold"
pkg install -y \
  curl \
  pkg-config \
  libtool \
  autoconf \
  automake \
  libjansson \
  libcurl \
  libgmp \
  openssl \
  clang \
  binutils \
  make \
  git

echo -e "\e[1;4;32m START BUILD cpuminer-opt \e[0m"

git clone https://github.com/JayDDee/cpuminer-opt.git
cd cpuminer-opt

export CC=clang
export CXX=clang++
export LD=ld.lld
export CFLAGS="-O3"
export CXXFLAGS="-O3"

echo 'int main(){return 0;}' > test.c
clang test.c -o test
./test && echo OK

./build.sh
