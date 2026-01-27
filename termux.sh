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
  pkg-config \
  libtool \
  autoconf  \
  automake \
  libjansson \
  libcurl \
  libcurl-dev \
  libgmp \
  openssl \
  openssl-dev \
  build-essential \
  clang binutils \
  clang \
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
./build.sh
#./autogen.sh 
#./configure CFLAGS="-O3" --with-curl 
#make
