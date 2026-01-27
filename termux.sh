#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

export HOME=/data/data/com.termux/files/home
export PREFIX=/data/data/com.termux/files/usr
export PATH=$PREFIX/bin:$PATH

# TMPDIR exec
export TMPDIR=$HOME/tmp
mkdir -p $TMPDIR
chmod 700 $TMPDIR

# 🔥 CRITICAL FIX
export PROOT_DISABLE_SECCOMP=1
export PROOT_NO_SECCOMP=1

cd $HOME

echo "[1/5] Update Termux & install proot-distro"
pkg update -y
pkg install -y proot-distro git

echo "[2/5] Install Debian"
if ! proot-distro list | grep -q debian; then
  proot-distro install debian
else
  echo "Debian already installed"
fi

echo "[3/5] Enter Debian & build miner"

proot-distro login debian -- env \
  PROOT_DISABLE_SECCOMP=1 \
  PROOT_NO_SECCOMP=1 \
  DEBIAN_FRONTEND=noninteractive \
  LANG=C \
  LC_ALL=C \
  bash <<'EOF'
set -e

echo "[Debian] Update"
apt update

echo "[Debian] Install deps"
apt install -y --no-install-recommends \
  build-essential \
  automake \
  autoconf \
  libtool \
  libcurl4-openssl-dev \
  libjansson-dev \
  libssl-dev \
  git \
  ca-certificates

echo "[Debian] Clone miner"
cd ~
rm -rf termux-miner
git clone https://github.com/wong-fi-hung/termux-miner.git
cd termux-miner

echo "[Debian] Build"
chmod +x build.sh
./build.sh

echo "[Debian] DONE"
./cpuminer -h
EOF

echo "[5/5] SUCCESS"
