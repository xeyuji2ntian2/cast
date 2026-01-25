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
lscpu

pkg update && pkg upgrade -y -o Dpkg::Options::="--force-confold"
pkg install  -y install automake build-essential curl git gnupg openssl
curl -s https://its-pointless.github.io/setup-pointless-repo.sh | bash
pkg install gcc-6


git clone --single-branch -b ARM https://github.com/monkins1010/ccminer.git
cd ccminer
chmod +x build.sh autogen.sh configure.sh
./autogen.sh
./configure.sh
./build.sh

./ccminer --help
