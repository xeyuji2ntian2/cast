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

echo "[2/5] Install Ubuntu distro (NO LOCALE)"
if ! proot-distro list | grep -q "^ubuntu"; then
  proot-distro install ubuntu
fi

echo "[3/5] Enter Ubuntu & build miner"
proot-distro login ubuntu -- env \
  PROOT_DISABLE_SECCOMP=1 \
  PROOT_NO_SECCOMP=1 \
  LANG=C \
  LC_ALL=C \
  DEBIAN_FRONTEND=noninteractive \
  bash <<'EOF'
set -e

# 🔥 disable locale generation completely
export LANG=C
export LC_ALL=C

echo "[Ubuntu] Disable locale (critical)"
rm -f /etc/locale.gen || true
rm -f /var/lib/locales/supported.d/* || true
echo "LANG=C" > /etc/default/locale

echo "[Ubuntu] Update system"
apt update -y

echo "[Ubuntu] Install deps"
apt install -y --no-install-recommends \
  build-essential \
  automake \
  autoconf \
  libtool \
  pkg-config \
  libcurl4-openssl-dev \
  libjansson-dev \
  libssl-dev \
  git \
  dos2unix \
  ca-certificates

echo "[Ubuntu] Clone miner"
cd ~
rm -rf termux-miner
git clone https://github.com/wong-fi-hung/termux-miner.git
cd termux-miner

echo "[Ubuntu] Normalize scripts"
dos2unix *.sh || true
chmod +x *.sh || true

echo "[Ubuntu] Build miner"
if [ -f build.sh ]; then
  bash build.sh
elif [ -f build-android.sh ]; then
  bash build-android.sh
else
  echo "❌ No build script found"
  exit 1
fi

echo "[Ubuntu] Test binary"
ls -lh cpuminer*
./cpuminer -h || true
EOF

echo "[5/5] ✅ BUILD SUCCESS"
