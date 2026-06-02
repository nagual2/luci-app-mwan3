#!/usr/bin/env bash
# Publish nagual2 .apk files as a local OpenWrt apk feed on the router (optional).
# Builds packages.adb on the build host, copies APKs + index to /www/nagual2/, adds custom feed.
#
# Usage: ./scripts/setup-local-apk-feed.sh <router_host> [web_root_url]
# Example: ./scripts/setup-local-apk-feed.sh 192.168.56.1 http://192.168.56.1/nagual2/packages.adb
set -euo pipefail

HOST="${1:?Usage: $0 <router_host> [packages.adb_url]}"
FEED_URL="${2:-http://${HOST}/nagual2/packages.adb}"
SSH_KEY="${SSH_KEY:-${HOME}/.ssh/id_ed25519}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SDK_DIR="${SDK_DIR:-$ROOT/build/sdk}"
APK_TOOL="${APK_TOOL:-$SDK_DIR/staging_dir/host/bin/apk}"
STAGING="$(mktemp -d)"
trap 'rm -rf "$STAGING"' EXIT

log() { printf '[setup-local-apk-feed] %s\n' "$*"; }

[ -x "$APK_TOOL" ] || {
	echo "Build SDK/apk tool first: make -f Makefile.build apk" >&2
	exit 1
}

shopt -s nullglob
APKS=("$ROOT"/dist/luci-app-mwan3-*.apk)
if [ ${#APKS[@]} -eq 0 ]; then
	echo "No APK in $ROOT/dist/ — run make -f Makefile.build apk" >&2
	exit 1
fi

cp "${APKS[@]}" "$STAGING/"
"$APK_TOOL" index -o "$STAGING/packages.adb" "$STAGING"/*.apk

log "Uploading to root@${HOST}:/www/nagual2/"
scp -O -i "$SSH_KEY" "$STAGING"/*.apk "$STAGING/packages.adb" "root@${HOST}:/tmp/nagual2-feed/"
ssh -i "$SSH_KEY" "root@${HOST}" "
	set -e
	mkdir -p /www/nagual2
	mv /tmp/nagual2-feed/* /www/nagual2/
	chmod 644 /www/nagual2/*
	grep -qF '${FEED_URL}' /etc/apk/repositories.d/customfeeds.list 2>/dev/null || \
		echo '${FEED_URL}' >> /etc/apk/repositories.d/customfeeds.list
	apk update
	echo 'Feed URL: ${FEED_URL}'
	echo 'Install/upgrade: apk add --allow-untrusted luci-app-mwan3'
"

log "Local feed ready. Pin still recommended — use verify-apk-pins.sh after apk add --allow-untrusted."
