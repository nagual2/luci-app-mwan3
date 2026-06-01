# Sync from openwrt/luci

This tree mirrors `applications/luci-app-mwan3` from https://github.com/openwrt/luci.

## Refresh upstream (WSL)

```bash
./scripts/sync-from-upstream.sh
```

After sync, **re-apply nagual2 patches** manually or from git:

- `htdocs/.../network/globals.js` — `track_host_routes`, `connected_ipv6_min_prefixlen`
- `htdocs/.../network/interface.js` — per-interface `track_host_routes`
- `htdocs/.../status/diagnostics.js` — `sync-track-routes`, `flush-conntrack`
- `root/usr/share/rpcd/acl.d/luci-app-mwan3.json` — exec permissions

Update this file with upstream commit hash printed by the sync script.

## Version bump

Increment `PKG_VERSION` / `PKG_RELEASE` in `Makefile` and tag `vX.Y.Z` for releases.
