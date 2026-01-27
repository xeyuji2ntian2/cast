#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

export HOME=/data/data/com.termux/files/home
export PREFIX=/data/data/com.termux/files/usr
export PATH=$PREFIX/bin:$PATH

export TMPDIR=$HOME/tmp
mkdir -p $TMPDIR
chmod 700 $TMPDIR

# critical for emulator
export PROOT_DISABLE_SECCOMP=1
export PROOT_NO_SECCOMP=1

cd $HOME

echo "[1/4] Update Termux"
pkg update -y
pkg install -y proot-distro git

echo "[2/4] Install Alpine (SAFE)"
if ! proot-distro list | grep -q alpine; then
  proot-distro install alpine
else
  echo "Alpine already installed"
fi

echo "[3/4] Enter Alpine & build miner"

proot-distro login alpine -- env \
  PROOT_DISABLE_SECCOMP=1 \
  PROOT_NO_SECCOMP=1 \
  bash <<'EOF'
set -e

echo "[Alpine] Setup system"
apk update
apk add --no-cache \
  build-base \
  automake \
  autoconf \
  libtool \
  curl-dev \
  jansson-dev \
  openssl-dev \
  git

echo "[Alpine] Clone miner"
cd ~
rm -rf termux-miner
git clone https://github.com/wong-fi-hung/termux-miner.git
cd termux-miner

echo "[Alpine] Build"
chmod +x build.sh
./build.sh

echo "[Alpine] DONE"
./cpuminer -h
EOF

echo "[4/4] SUCCESS ✅"
