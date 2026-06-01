#!/bin/sh
# Install luci-app-mwan3 IPK on OpenWrt via tarball (25.x fallback).
# Usage: ./scripts/install-tarball.sh <router_host>

set -e

PKG_DIR="$(cd "$(dirname "$0")/.." && pwd)"
HOST="${1:?Usage: $0 <router_host>}"
IPK="${PKG_DIR}/dist/luci-app-mwan3_"*"_all.ipk"
SSH_KEY="${SSH_KEY:-${HOME}/.ssh/id_ed25519}"
STAGING="/tmp/luci-mwan3-install-$$"

IPK_FILE=$(ls -1 $IPK 2>/dev/null | tail -1)
[ -n "$IPK_FILE" ] || { echo "Build IPK first: make -f Makefile.build ipk"; exit 1; }

mkdir -p "$STAGING"
cd "$STAGING"
ar x "$IPK_FILE"
tar -xzf data.tar.gz
tar czf luci-app-mwan3.tar.gz www usr etc

scp -O -i "$SSH_KEY" luci-app-mwan3.tar.gz "root@${HOST}:/tmp/"
ssh -i "$SSH_KEY" "root@${HOST}" '
    set -e
    cd /
    tar -xzf /tmp/luci-app-mwan3.tar.gz
    [ -x /etc/uci-defaults/60_luci-mwan3 ] && /etc/uci-defaults/60_luci-mwan3 || true
    rm -f /tmp/luci-indexcache.*
    rm -rf /tmp/luci-modulecache/
    /etc/init.d/rpcd reload
    /etc/init.d/uhttpd restart
    echo "LuCI mwan3 (nagual2) installed"
'

rm -rf "$STAGING"
echo "Installed on $HOST"
