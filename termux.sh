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
pkg install -y automake build-essential curl git gnupg openssl wget libjansson zlib

# Clone Repo
git clone https://github.com/Mr-Bossman/ccminer.git
cd ccminer

# Fix Obsolete Macros
sed -i 's/AC_PROG_CC_C99/AC_PROG_CC/g' configure.ac
sed -i 's/AC_HEADER_STDC//g' configure.ac

# Update config.guess & config.sub (PENTING untuk x86_64)
wget -O config.guess 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD'
wget -O config.sub 'http://git.savannah.gnu.org'

echo "START AUTOGEN"
chmod +x autogen.sh
./autogen.sh

# Configure khusus x86_64 Android
echo "START CONFIGURE"
./configure \
  --build=x86_64-unknown-linux-android \
  --host=x86_64-unknown-linux-android \
  CC=clang CXX=clang++ \
  CFLAGS="-O3 -fPIE" CXXFLAGS="-O3 -fPIE" LDFLAGS="-pie"

# Compile dengan semua core tersedia
echo "START MAKE"
make -j$(nproc)

# Test run
./ccminer --help
