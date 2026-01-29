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


