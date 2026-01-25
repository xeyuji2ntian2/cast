#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail


export HOME=/data/data/com.termux/files/home
export PREFIX=/data/data/com.termux/files/usr
export PATH=$PREFIX/bin:$PATH
cd $HOME
echo "=== TERMUX ENV ==="
whoami
id
uname -a
ls

pkg update && pkg upgrade -y -o Dpkg::Options::="--force-confold"
pkg install  -y curl xz-utils wget libsodium
curl -L https://github.com/hellcatz/hminer/releases/download/v0.59.1/hellminer_linux64.tar.gz -o hellminer.tar.gz
mkdir hellminer
tar -xf hellminer.tar.gz -C hellminer
cd hellminer
ls
./hellminer --help

