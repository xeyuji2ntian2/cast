#!/data/data/com.termux/files/usr/bin/bash
set -e

export HOME=/data/data/com.termux/files/home
export PREFIX=/data/data/com.termux/files/usr
export PATH=$PREFIX/bin:$PATH

# proot hard fix
export PROOT_DISABLE_SECCOMP=1
export PROOT_NO_SECCOMP=1
export LANG=C
export LC_ALL=C

cd $HOME

echo "[1/5] Update Termux"
pkg update -y
pkg install -y proot-distro git

echo "[2/5] Install Debian distro"
if ! proot-distro list | grep -q "^debian"; then
  proot-distro install debian
fi

echo "[3/5] Enter Debian & build miner"
proot-distro login debian -- env \
  PROOT_DISABLE_SECCOMP=1 \
  PROOT_NO_SECCOMP=1 \
  LANG=C \
  LC_ALL=C \
  bash <<'EOF'
set -e
export LANG=C
export LC_ALL=C

apt update -y
apt install -y \
  build-essential \
  automake \
  autoconf \
  libtool \
  pkg-config \
  libcurl4-openssl-dev \
  libjansson-dev \
  libssl-dev \
  git \
  dos2unix

git clone https://github.com/wong-fi-hung/termux-miner.git
cd termux-miner
dos2unix *.sh || true
chmod +x *.sh || true
bash build.sh
./cpuminer -h
EOF
echo "[5/5] ✅ BUILD SUCCESS"
