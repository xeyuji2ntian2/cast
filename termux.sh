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
pkg install -y libjansson wget
wget https://raw.githubusercontent.com/tempatbloger/Mining-verus-termux/refs/heads/branchname/ccminer
chmod +x ccminer
bash ccminer --help
