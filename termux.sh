#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

export HOME=/data/data/com.termux/files/home
export PREFIX=/data/data/com.termux/files/usr
export PATH=$PREFIX/bin:$PATH

echo "=== TERMUX ENV ==="
whoami
id
uname -a

if [ "$(id -u)" = "0" ]; then
  echo "❌ ERROR: running as root"
  exit 1
fi

echo -e "\n\n\n\n\e[32m======================== Update & upgrade ========================\e[0m\n\n\n\n"

pkg update && pkg upgrade -y -o Dpkg::Options::="--force-confold"
pkg install libjansson build-essential clang binutils git -y


echo -e "\n\n\n\n\e[32m======================== Build CCMINER (CPU ONLY) ========================\e[0m\n\n\n\n"
cd $HOME
cp /data/data/com.termux/files/usr/include/linux/sysctl.h /data/data/com.termux/files/usr/include/sys
git clone https://github.com/Darktron/ccminer.git
cd ccminer
dos2unix build.sh configure.sh autogen.sh start.sh
chmod +x build.sh configure.sh autogen.sh start.sh

CXX=clang++ CC=clang ./build.sh

echo "=== BUILD RESULT ==="
file ccminer
./ccminer --help || true

echo "✅ CCMINER BUILD SUCCESS"
