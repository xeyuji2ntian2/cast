#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
dos2unix "$0" 2>/dev/null || true

export HOME=/data/data/com.termux/files/home
export PREFIX=/data/data/com.termux/files/usr
export PATH=$PREFIX/bin:$PATH

echo "=== TERMUX ENV ==="
whoami
id
uname -a
