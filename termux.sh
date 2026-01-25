#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

# Setup Path
export HOME=/data/data/com.termux/files/home
export PREFIX=/data/data/com.termux/files/usr
export PATH=$PREFIX/bin:$PATH
export TMPDIR=$PREFIX/tmp
mkdir -p $TMPDIR

cd $HOME

# PENTING: Klik "Allow" pada popup yang muncul setelah perintah ini
termux-setup-storage

# Update & Install Dependensi Lengkap
pkg update && pkg upgrade -y -o Dpkg::Options::="--force-confold"
pkg install -y automake build-essential curl git gnupg openssl wget libjansson zlib

# Clone Repo (Hapus folder lama jika ada agar tidak bentrok)
rm -rf ccminer
lscpu
git clone  --single-branch -b CLANG_android https://github.com/Mr-Bossman/ccminer.git
cd ccminer

# Fix Obsolete Macros
sed -i 's/AC_PROG_CC_C99/AC_PROG_CC/g' configure.ac
sed -i 's/AC_HEADER_STDC//g' configure.ac
sed -i 's/AC_CANONICAL_SYSTEM/AC_CANONICAL_TARGET/g' configure.ac
sed -i 's/AC_PROG_GCC_TRADITIONAL//g' configure.ac
# Update config.guess & config.sub (Link diperbaiki agar mengunduh file asli)


#wget -O config.guess 'https://git.savannah.gnu.org'
#wget -O config.sub 'https://git.savannah.gnu.org'

# PENTING: Beri izin eksekusi pada file yang baru diunduh

echo "START AUTOGEN"
chmod +x autogen.sh
./autogen.sh

# 3. Jalankan Configure dengan Bash eksplisit jika perlu
echo "START CONFIGURE"
#bash ./configure --build=x86_64-unknown-linux-android --host=x86_64-unknown-linux-android CC=clang CXX=clang++ CFLAGS="-O3 -fPIE" CXXFLAGS="-O3 -fPIE" LDFLAGS="-pie"
./configure.sh

# Compile dengan semua core tersedia
echo "START MAKE"
make
#make -j$(nproc)

# Test run
./ccminer --help
