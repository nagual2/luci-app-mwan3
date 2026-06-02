#!/bin/sh
# Verify nagual2 fork packages are pinned in /etc/apk/world (OpenWrt 25.12+ apk).
# Pin format: luci-app-mwan3><Q1base64hash=
# Usage: ./scripts/verify-apk-pins.sh [router_host]
set -eu

PKGS="mwan3 mwan6-npt luci-app-mwan3 luci-app-mwan6-npt"
HOST="${1:-}"
SSH_KEY="${SSH_KEY:-${HOME}/.ssh/id_ed25519}"

REMOTE_SCRIPT='
PKGS="mwan3 mwan6-npt luci-app-mwan3 luci-app-mwan6-npt"
MISS=0
for pkg in $PKGS; do
	if grep -q "^${pkg}><" /etc/apk/world 2>/dev/null; then
		printf "OK   %s pinned in /etc/apk/world\n" "$pkg"
	elif apk info -e "$pkg" >/dev/null 2>&1; then
		printf "WARN %s installed but NOT pinned (feeds may replace on upgrade)\n" "$pkg"
		MISS=1
	else
		printf "SKIP %s not installed\n" "$pkg"
	fi
done
echo "--- apk policy ---"
apk policy $PKGS 2>&1 | grep -v "^WARNING:" || true
exit $MISS
'

if [ -n "$HOST" ]; then
	ssh -i "$SSH_KEY" "root@${HOST}" "$REMOTE_SCRIPT"
else
	eval "$REMOTE_SCRIPT"
fi
