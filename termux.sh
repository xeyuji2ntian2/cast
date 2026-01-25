#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
dos2unix "$0" 2>/dev/null || true

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
pkg install libjansson build-essential clang binutils git dos2unix automake autoconf libcurl zlib -y


mkdir -p $PREFIX/include/sys
cp $PREFIX/include/linux/sysctl.h $PREFIX/include/sys/ 2>/dev/null || true

echo -e "\n\n\n\n\e[32m======================== Build CCMINER (CPU ONLY) ========================\e[0m\n\n\n\n"
cd $HOME
cp /data/data/com.termux/files/usr/include/linux/sysctl.h /data/data/com.termux/files/usr/include/sys
git clone https://github.com/Darktron/ccminer.git
cd ccminer
dos2unix build.sh configure.sh autogen.sh start.sh
chmod +x build.sh configure.sh autogen.sh start.sh

CXX=clang++ CC=clang bash build.sh

echo -e "\n\e[32m=== BUILD RESULT ===\e[0m\n"
if [ -f "./ccminer" ]; then
    ./ccminer --help || true
    echo -e "\n✅ CCMINER BUILD SUCCESS"
else
    echo -e "\n❌ BUILD FAILED: Executable not found"
    exit 1
fi
echo "✅ CCMINER BUILD SUCCESS"
