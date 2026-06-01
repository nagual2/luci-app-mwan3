#!/usr/bin/env bash
# Refresh htdocs/root from upstream openwrt/luci luci-app-mwan3 (sparse checkout).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORKDIR="${TMPDIR:-/tmp}/luci-app-mwan3-sync-$$"
trap 'rm -rf "$WORKDIR"' EXIT

mkdir -p "$WORKDIR"
cd "$WORKDIR"
git init -q
git remote add origin https://github.com/openwrt/luci.git
git config core.sparseCheckout true
mkdir -p .git/info
echo 'applications/luci-app-mwan3' > .git/info/sparse-checkout
git pull --depth=1 origin master

UPSTREAM_COMMIT=$(git rev-parse HEAD)
echo "Upstream luci commit: $UPSTREAM_COMMIT"

rsync -a --delete \
	--exclude 'Makefile' \
	"$WORKDIR/applications/luci-app-mwan3/htdocs/" "$ROOT/htdocs/"
rsync -a --delete \
	"$WORKDIR/applications/luci-app-mwan3/root/" "$ROOT/root/"

echo "Synced from openwrt/luci. Re-apply nagual2 patches (globals.js, interface.js, diagnostics.js, acl)."
echo "Update UPSTREAM.md with commit: $UPSTREAM_COMMIT"
