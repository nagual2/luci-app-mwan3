#!/bin/sh
# Install or upgrade luci-app-mwan3 (nagual2) via apk on OpenWrt 25.12+.
# Removes stock/manual overlay and installs from local .apk with post-install hooks.
# Usage: ./scripts/install-apk.sh <router_host>
set -eu

PKG_DIR="$(cd "$(dirname "$0")/.." && pwd)"
HOST="${1:?Usage: $0 <router_host>}"
SSH_KEY="${SSH_KEY:-${HOME}/.ssh/id_ed25519}"
APK_FILE="$(ls -1 "$PKG_DIR"/dist/luci-app-mwan3-*.apk 2>/dev/null | tail -1)"

[ -n "$APK_FILE" ] || {
	echo "Build APK first: make -f Makefile.build apk" >&2
	exit 1
}

BASENAME="$(basename "$APK_FILE")"
REMOTE="/tmp/$BASENAME"

echo "Backing up UCI on $HOST..."
ssh -i "$SSH_KEY" "root@${HOST}" '
	set -e
	B="/root/backup/apk-install-$(date +%Y%m%d-%H%M%S)"
	mkdir -p "$B"
	[ -f /etc/config/mwan3 ] && cp -a /etc/config/mwan3 "$B/"
	uci export mwan3 >"$B/mwan3.uci-export" 2>/dev/null || true
	echo "Backup: $B"
'

echo "Removing manual overlays (keep apk DB; do not apk del — i18n would pull stock)..."
ssh -i "$SSH_KEY" "root@${HOST}" '
	set -e
	rm -rf /usr/share/doc/luci-app-mwan3
	chown -R root:root /www/luci-static/resources/view/mwan3 2>/dev/null || true
'

echo "Installing $BASENAME via apk..."
scp -O -i "$SSH_KEY" "$APK_FILE" "root@${HOST}:${REMOTE}"
ssh -i "$SSH_KEY" "root@${HOST}" "
	set -e
	apk add --allow-untrusted '${REMOTE}'
	rm -f '${REMOTE}'
	rm -f /tmp/luci-indexcache.*
	rm -rf /tmp/luci-modulecache/
	/etc/init.d/rpcd reload
	/etc/init.d/uhttpd restart
	apk info -e luci-app-mwan3
	ls -la /etc/uci-defaults/60_luci-mwan3
	head -1 /www/luci-static/resources/view/mwan3/status/diagnostics.js
	find /www/luci-static/resources/view/mwan3 -user 1000 2>/dev/null | head -3 || echo 'OK: no uid 1000 under mwan3 views'
"

echo "Installed luci-app-mwan3 on $HOST"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -x "$SCRIPT_DIR/verify-apk-pins.sh" ]; then
	"$SCRIPT_DIR/verify-apk-pins.sh" "$HOST" || true
fi
