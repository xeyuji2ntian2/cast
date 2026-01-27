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
  ndk-sysroot \
  git

echo -e "\e[1;4;32m START BUILD cpuminer-opt \e[0m"
sleep 10

rm -rf termux-miner
cd $HOME
git clone https://github.com/wong-fi-hung/termux-miner
cd termux-miner
# cari skrip build Android 
./build-android.sh   # atau instruksi dari repo
# setelah selesai: hasil binarinya bisa kamu jalankan
./cpuminer -h

