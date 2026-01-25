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
pkg install -y automake build-essential curl clang binutils git gnupg openssl wget libjansson zlib
curl -s https://its-pointless.github.io/setup-pointless-repo.sh | bash
pkg install -y gcc-6

# Clone Repo (Hapus folder lama jika ada agar tidak bentrok)
rm -rf ccminer
lscpu
git clone  --single-branch -b cpuhashrate https://github.com/Mr-Bossman/ccminer.git
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
echo "START BUILD"
chmod +x build.sh configure.sh autogen.sh
bash build.sh

# Test run
./ccminer --help
