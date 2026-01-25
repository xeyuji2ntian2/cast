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
pkg install  -y dos2unix git build-essential cmake libjansson automake autoconf openssl libcurl 

git clone https://github.com/monkins1010/ccminer.git
cd ccminer
find . -name "*.sh" -exec dos2unix {} +
termux-fix-shebang build.sh configure.sh autogen.sh
chmod +x build.sh configure.sh autogen.sh
bash build.sh
