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

pkg update && pkg upgrade -y -o Dpkg::Options::="--force-confold"
pkg install  -y git build-essential cmake libjansson automake autoconf openssl
dos2unix "$0" 2>/dev/null || true

git clone https://github.com/monkins1010/ccminer.git
cd ccminer
chmod +x build.sh configure.sh autogen.sh
./build.sh
