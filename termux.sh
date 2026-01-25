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
ls
./ccminer --version
