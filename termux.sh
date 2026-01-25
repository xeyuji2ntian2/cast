#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
dos2unix "$0" 2>/dev/null || true

export HOME=/data/data/com.termux/files/home
export PREFIX=/data/data/com.termux/files/usr
export PATH=$PREFIX/bin:$PATH
cd $HOME
echo "=== TERMUX ENV ==="
whoami
id
uname -a

apt update -y 
apt install libcurl openssl libjansson automake build-essential screen git -y
git clone --single-branch -b ARM https://github.com/monkins1010/ccminer.git
cd ccminer
chmod +x build.sh
chmod +x configure.sh
chmod +x autogen.sh
./build.sh
