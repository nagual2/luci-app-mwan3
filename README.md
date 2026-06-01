# luci-app-mwan3 (nagual2 fork)

**English** | [Русский](README.ru.md)

LuCI web interface for [nagual2/mwan3](https://github.com/nagual2/mwan3) — IPv6 multi-WAN with **fork options in the GUI**.

Repository: https://github.com/nagual2/luci-app-mwan3

Upstream base: [openwrt/luci `luci-app-mwan3`](https://github.com/openwrt/luci/tree/master/applications/luci-app-mwan3)

## nagual2 GUI additions (1.0.0)

| Location | Option / action |
|----------|-----------------|
| **Network → MWAN → Globals** | `track_host_routes` — host `/128` routes for `track_ip` |
| **Globals** | `connected_ipv6_min_prefixlen` — filter `::/1` from connected ipset |
| **Interfaces** (modal) | Per-iface override `track_host_routes` |
| **Status → Diagnostics** | **Sync track host routes**, **Flush conntrack** |

Requires **[mwan3 >= 2.12.1-3](https://github.com/nagual2/mwan3)** on the router.

## Install from release

```bash
# OpenWrt 25.12+ (apk) — install nagual2/mwan3 first
apk add --allow-untrusted ./luci-app-mwan3-1.0.0-r1.apk
/etc/init.d/rpcd restart

# OpenWrt 23.x (opkg)
opkg install ./luci-app-mwan3_1.0.0-1_all.ipk
/etc/init.d/rpcd restart
```

## Build standalone

```bash
make -f Makefile.build ipk PROJECT_VERSION=1.0.0
./scripts/build-apk-mkpkg.sh
make -f Makefile.build test
ls dist/
```

Deploy tarball: `./scripts/install-tarball.sh 192.168.1.1`

## OpenWrt SDK

Symlink or copy this tree into `package/` or LuCI feed, then:

```bash
make package/luci-app-mwan3/compile LUCI_DIR=/path/to/luci
```

## Related packages

| Package | Repository |
|---------|------------|
| mwan3 (fork) | [nagual2/mwan3](https://github.com/nagual2/mwan3) |
| mwan6-npt | [nagual2/mwan6-npt](https://github.com/nagual2/mwan6-npt) |
| luci mwan6-npt | [nagual2/mwan6-npt-luci](https://github.com/nagual2/mwan6-npt-luci) |
