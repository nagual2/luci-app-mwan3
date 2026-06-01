#!/bin/sh
# Sanity check for luci-app-mwan3 (nagual2 fork) package layout.

set -e

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"

required="
	Makefile
	Makefile.build
	LICENSE
	NOTICE
	README.md
	README.ru.md
	scripts/stage-docs.sh
	htdocs/luci-static/resources/view/mwan3/network/globals.js
	htdocs/luci-static/resources/view/mwan3/network/interface.js
	htdocs/luci-static/resources/view/mwan3/status/diagnostics.js
	root/usr/share/luci/menu.d/luci-app-mwan3.json
	root/usr/share/rpcd/acl.d/luci-app-mwan3.json
"

missing=0
for f in $required; do
	if [ ! -e "$ROOT/$f" ]; then
		echo "MISSING: $f"
		missing=1
	fi
done

grep -q 'track_host_routes' "$ROOT/htdocs/luci-static/resources/view/mwan3/network/globals.js" || {
	echo "globals.js: expected track_host_routes (nagual2)"
	missing=1
}

grep -q 'connected_ipv6_min_prefixlen' "$ROOT/htdocs/luci-static/resources/view/mwan3/network/globals.js" || {
	echo "globals.js: expected connected_ipv6_min_prefixlen"
	missing=1
}

grep -q 'sync-track-routes' "$ROOT/htdocs/luci-static/resources/view/mwan3/status/diagnostics.js" || {
	echo "diagnostics.js: expected sync-track-routes task"
	missing=1
}

grep -q 'sync-track-routes' "$ROOT/root/usr/share/rpcd/acl.d/luci-app-mwan3.json" || {
	echo "acl: expected sync-track-routes exec permission"
	missing=1
}

if [ "$missing" -ne 0 ]; then
	exit 1
fi

echo "OK: package structure (nagual2 fork options present)"
