#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

# 1. Pastikan folder sys ada sebelum copy header
mkdir -p /data/data/com.termux/files/usr/include/sys
cp /data/data/com.termux/files/usr/include/linux/sysctl.h /data/data/com.termux/files/usr/include/sys/ 2>/dev/null || true

echo -e "\n\e[32m======================== Update & Install Dependencies ========================\e[0m\n"

pkg update && pkg upgrade -y -o Dpkg::Options::="--force-confold"
# Menambahkan automake, autoconf, dan zlib yang sering dibutuhkan Darktron
pkg install libjansson build-essential clang binutils git dos2unix automake autoconf libcurl zlib -y

echo -e "\n\e[32m======================== Build CCMINER (Darktron) ========================\e[0m\n"
cd $HOME
rm -rf ccminer # Bersihkan folder lama jika ada
git clone https://github.com/Darktron/ccminer.git
cd ccminer

# 2. Perbaiki format file
dos2unix build.sh configure.sh autogen.sh
chmod +x build.sh configure.sh autogen.sh

# 3. Jalankan Build dengan Compiler Clang
# Repo Darktron biasanya memerlukan ./configure manual jika build.sh gagal
CXX=clang++ CC=clang ./build.sh

echo -e "\n\e[32m=== BUILD RESULT ===\e[0m\n"
if [ -f "./ccminer" ]; then
    file ccminer
    ./ccminer --version || true
    echo -e "\n\e[32m✅ CCMINER BUILD SUCCESS\e[0m"
else
    echo -e "\n\e[31m❌ BUILD FAILED: Executable ccminer not found\e[0m"
    exit 1
fi
