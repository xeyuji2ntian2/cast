#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail


export HOME=/data/data/com.termux/files/home
export PREFIX=/data/data/com.termux/files/usr
export PATH=$PREFIX/bin:$PATH
export TMPDIR=$PREFIX/tmp
mkdir -p $TMPDIR

cd $HOME
echo "=== TERMUX ENV ==="
whoami
id
uname -a
lscpu

pkg update && pkg upgrade -y -o Dpkg::Options::="--force-confold"
pkg install  -y automake build-essential curl git gnupg openssl wget
curl -s https://its-pointless.github.io/setup-pointless-repo.sh | bash
pkg install -y gcc-6


git clone https://github.com/Mr-Bossman/ccminer.git
cd ccminer
sed -i 's/AC_PROG_CC_C99/AC_PROG_CC/g' configure.ac
sed -i 's/AC_HEADER_STDC//g' configure.ac

# 3. Update configuration scripts for modern architecture detection
wget -O config.guess 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD'
wget -O config.sub 'http://git.savannah.gnu.org'
chmod +x build.sh configure.sh autogen.sh
./autogen.sh
./configure \
  --build=x86_64-unknown-linux-android \
  --host=x86_64-unknown-linux-android \
  CC=clang CXX=clang++ \
  CFLAGS="-O3 -fPIE" CXXFLAGS="-O3 -fPIE" LDFLAGS="-pie"

# 6. Compile
make -j$(nproc)

./ccminer --help
