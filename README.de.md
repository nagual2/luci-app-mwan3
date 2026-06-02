# luci-app-mwan3 (nagual2 Fork)

[English](README.md) | [Русский](README.ru.md) | **Deutsch**

LuCI-Weboberfläche für [nagual2/mwan3](https://github.com/nagual2/mwan3) — IPv6 Multi-WAN mit **Fork-Optionen in der GUI**.

Repository: https://github.com/nagual2/luci-app-mwan3

Upstream-Basis: [openwrt/luci luci-app-mwan3](https://github.com/openwrt/luci/tree/master/applications/luci-app-mwan3)

## nagual2 GUI-Erweiterungen (1.0.0)

| Bereich | Option / Aktion |
|---------|-----------------|
| **Netzwerk → MWAN → Globals** | `track_host_routes` — Host-/128-Routen für `track_ip` |
| **Globals** | `connected_ipv6_min_prefixlen` — `::/1` aus connected ipset filtern |
| **Interfaces** (Modal) | Pro-Schnittstelle `track_host_routes` überschreiben |
| **Status → Diagnostics** | **Sync track host routes**, **Flush conntrack** |

Erfordert **[mwan3 >= 2.12.1-3](https://github.com/nagual2/mwan3)** auf dem Router.

## Installation (OpenWrt 25.12+ / apk)

**Empfohlen** — Installationsskript (setzt World-Pin automatisch):

```bash
make -f Makefile.build apk
./scripts/install-apk.sh 192.168.1.1
./scripts/verify-apk-pins.sh 192.168.1.1
```

Manuell (gleiches Pin-Verhalten):

```bash
scp dist/luci-app-mwan3-1.0.0-r1.apk root@192.168.1.1:/tmp/
ssh root@192.168.1.1 'apk add --allow-untrusted /tmp/luci-app-mwan3-1.0.0-r1.apk'
```

OpenWrt 23.x (opkg):

```bash
opkg install ./luci-app-mwan3_1.0.0-1_all.ipk
/etc/init.d/rpcd restart
```

## Fork pinnen (apk)

In OpenWrt **25.12+** liefern die Feeds **Stock**-`luci-app-mwan3`. Ohne Pin kann `apk upgrade` oder der LuCI-Paketmanager den Fork ersetzen.

### Pin-Mechanismus

`apk add --allow-untrusted ./package.apk` schreibt in `/etc/apk/world`:

```text
luci-app-mwan3><Q1nHRY/ED5OC6j6o49PBlZhqDdhRs=
```

`><` fixiert die **exakte nagual2-Datei**, nicht die Feed-Version. Ohne `><` gilt: „Version aus Feeds“.

Gleiches für **[mwan3](https://github.com/nagual2/mwan3)**, **[mwan6-npt](https://github.com/nagual2/mwan6-npt)**, **[luci-app-mwan6-npt](https://github.com/nagual2/mwan6-npt-luci)** bei `apk add --allow-untrusted`.

### Prüfen

```bash
grep -E '^(mwan3|mwan6-npt|luci-app-mwan3|luci-app-mwan6-npt)><' /etc/apk/world
apk policy luci-app-mwan3
./scripts/verify-apk-pins.sh 192.168.1.1
```

### Fork bewusst upgraden

```bash
scp dist/luci-app-mwan3-NEW.apk root@192.168.1.1:/tmp/
ssh root@192.168.1.1 'apk add --allow-untrusted /tmp/luci-app-mwan3-NEW.apk'
```

### Kein `apk del luci-app-mwan3`

Wegen **`luci-i18n-mwan3-ru`** wird sofort **Stock** aus den Feeds installiert.

### Russische Übersetzung (nagual2)

Feeds-**`luci-i18n-mwan3-ru`** enthält keine nagual2-Strings. **[luci-i18n-mwan3-ru](https://github.com/nagual2/luci-i18n-mwan3-ru)** nach `luci-app-mwan3` installieren.

### Optional: lokaler apk-Feed

```bash
./scripts/setup-local-apk-feed.sh 192.168.1.1
```

APK + `packages.adb` unter `/www/nagual2/`. Weiterhin **`--allow-untrusted`** und Pin prüfen.

## Standalone bauen

```bash
make -f Makefile.build ipk PROJECT_VERSION=1.0.0
./scripts/build-apk-mkpkg.sh
make -f Makefile.build test
ls dist/
```

Deploy: `./scripts/install-apk.sh 192.168.1.1` (empfohlen). Legacy-Tarball: `./scripts/install-tarball.sh` (nur Dev, kein apk-Pin).

## OpenWrt SDK

Symlink oder Kopie in den LuCI-Feed, dann:

```bash
make package/luci-app-mwan3/compile LUCI_DIR=/path/to/luci
```

## Verwandte Pakete

| Paket | Repository |
|-------|------------|
| mwan3 (Fork) | [nagual2/mwan3](https://github.com/nagual2/mwan3) |
| mwan6-npt | [nagual2/mwan6-npt](https://github.com/nagual2/mwan6-npt) |
| luci mwan6-npt | [nagual2/mwan6-npt-luci](https://github.com/nagual2/mwan6-npt-luci) |

## Dokumentation

Dreisprachige README unter `/usr/share/doc/luci-app-mwan3/` (`README.en.md`, `README.ru.md`, `README.de.md`).

## Lizenz

GPL-2.0 (wie upstream LuCI). Siehe `LICENSE` und `NOTICE`.
