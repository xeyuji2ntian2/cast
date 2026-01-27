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
wget "https://github.com/Oink70/Android-Mining/releases/download/v3.8.3-4/ccminer-3.8.3-4_ARM" -O ccminer
chmod +x ccminer
./ccminer --help
