#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

# Setup Path
export HOME=/data/data/com.termux/files/home
export PREFIX=/data/data/com.termux/files/usr
export PATH=$PREFIX/bin:$PATH


# FIX: TMPDIR must be exec-capable
export TMPDIR=$HOME/tmp
mkdir -p $TMPDIR
chmod 700 $TMPDIR

export CONFIG_SHELL=$PREFIX/bin/bash

cd $HOME

echo "[1/5] Update Termux & install proot-distro..."
pkg update -y
pkg install -y proot-distro git

echo "[2/5] Install Ubuntu (jika belum ada)..."
if ! proot-distro list | grep -q ubuntu; then
  proot-distro install ubuntu
else
  echo "Ubuntu already installed."
fi

echo "[3/5] Masuk Ubuntu & setup environment..."

proot-distro login ubuntu -- bash <<'EOF'
set -e

echo "[Ubuntu] Update system..."
apt update

echo "[Ubuntu] Install build dependencies..."
apt install -y \
  build-essential \
  automake \
  autoconf \
  libtool \
  libcurl4-openssl-dev \
  libjansson-dev \
  libssl-dev \
  git

echo "[Ubuntu] Clone termux-miner..."
if [ ! -d termux-miner ]; then
  git clone https://github.com/wong-fi-hung/termux-miner.git
fi

cd termux-miner

echo "[Ubuntu] Build miner..."
chmod +x build.sh
./build.sh

echo "[Ubuntu] Build DONE"
EOF
