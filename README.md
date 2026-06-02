# luci-app-mwan3 (nagual2 fork)

**English** | [Русский](README.ru.md) | [Deutsch](README.de.md)

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

## Install from release (OpenWrt 25.12+ / apk)

**Recommended** — use the install script (sets world pin automatically):

```bash
make -f Makefile.build apk
./scripts/install-apk.sh 192.168.1.1
./scripts/verify-apk-pins.sh 192.168.1.1
```

Manual install (same pin behaviour):

```bash
# Install nagual2/mwan3 first on the router
scp dist/luci-app-mwan3-1.0.0-r1.apk root@192.168.1.1:/tmp/
ssh root@192.168.1.1 'apk add --allow-untrusted /tmp/luci-app-mwan3-1.0.0-r1.apk'
```

OpenWrt 23.x (opkg):

```bash
opkg install ./luci-app-mwan3_1.0.0-1_all.ipk
/etc/init.d/rpcd restart
```

## Pinning the nagual2 fork (apk)

On OpenWrt **25.12+**, official feeds ship **stock** `luci-app-mwan3`. After `apk upgrade` or LuCI Package Manager updates, feeds can offer a newer stock build and replace the fork **unless the package is pinned**.

### How pinning works

When you install a local `.apk` with `apk add --allow-untrusted`, apk writes a **world constraint with package identity** into `/etc/apk/world`:

```text
luci-app-mwan3><Q1nHRY/ED5OC6j6o49PBlZhqDdhRs=
```

The `><` suffix locks the **exact nagual2 package**, not the version name from feeds. A plain line `luci-app-mwan3` (without `><`) means “take whatever feeds provide”.

The same applies to **[mwan3](https://github.com/nagual2/mwan3)**, **[mwan6-npt](https://github.com/nagual2/mwan6-npt)**, and **[luci-app-mwan6-npt](https://github.com/nagual2/mwan6-npt-luci)** when installed with `apk add --allow-untrusted`.

### Verify pins

```bash
grep -E '^(mwan3|mwan6-npt|luci-app-mwan3|luci-app-mwan6-npt)><' /etc/apk/world
apk policy luci-app-mwan3
./scripts/verify-apk-pins.sh 192.168.1.1
```

Expected: installed version shows `lib/apk/db/installed`; feeds may list a newer stock build, but apk keeps the pinned package.

### Upgrade nagual2 fork deliberately

```bash
scp dist/luci-app-mwan3-NEW.apk root@192.168.1.1:/tmp/
ssh root@192.168.1.1 'apk add --allow-untrusted /tmp/luci-app-mwan3-NEW.apk'
```

The world pin updates to the new package hash.

### Do not use `apk del` for luci-app-mwan3

`luci-i18n-mwan3-ru` depends on `luci-app-mwan3`. **`apk del luci-app-mwan3` immediately reinstalls stock from feeds.** To switch back to stock intentionally: remove the i18n package first, or edit `/etc/apk/world`.

### Russian translation (nagual2)

Feeds `luci-i18n-mwan3-ru` does **not** include nagual2-only UI strings. Use **[luci-i18n-mwan3-ru](https://github.com/nagual2/luci-i18n-mwan3-ru)** (merged upstream + fork delta). Install **after** this package:

```bash
apk add --allow-untrusted ./luci-i18n-mwan3-ru-*.apk
```

### Optional: local apk feed (several routers)

On the build host (after `make -f Makefile.build apk`):

```bash
./scripts/setup-local-apk-feed.sh 192.168.1.1
```

This publishes `dist/*.apk` and `packages.adb` under `/www/nagual2/` and adds a line to `/etc/apk/repositories.d/customfeeds.list`. You still install with **`apk add --allow-untrusted`** (unsigned packages) and should **verify pins** afterward.

## Build standalone

```bash
make -f Makefile.build ipk PROJECT_VERSION=1.0.0
./scripts/build-apk-mkpkg.sh
make -f Makefile.build test
ls dist/
```

Deploy: `./scripts/install-apk.sh 192.168.1.1` (recommended). Legacy tarball: `./scripts/install-tarball.sh` (dev only, no apk pin).

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
| luci-i18n-mwan3-ru | [nagual2/luci-i18n-mwan3-ru](https://github.com/nagual2/luci-i18n-mwan3-ru) |

## Documentation

Trilingual README files ship in `/usr/share/doc/luci-app-mwan3/` (`README.en.md`, `README.ru.md`, `README.de.md`).

## License
