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
chmod +x build.sh configure.sh autogen.sh
./build.sh
