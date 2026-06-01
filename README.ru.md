# luci-app-mwan3 (форк nagual2)

[English](README.md) | **Русский**

LuCI для [nagual2/mwan3](https://github.com/nagual2/mwan3) — управление **fork-опциями IPv6 multi-WAN** из веб-интерфейса.

Репозиторий: https://github.com/nagual2/luci-app-mwan3

## Что добавлено в GUI

| Раздел | Опция / действие |
|--------|------------------|
| **Network → MWAN → Globals** | `track_host_routes` — маршруты `/128` для `track_ip` |
| **Globals** | `connected_ipv6_min_prefixlen` — не добавлять `::/1` в connected ipset |
| **Interfaces** | Override `track_host_routes` на интерфейс |
| **Status → Diagnostics** | **Sync track host routes**, **Flush conntrack** |

На роутере нужен **[mwan3 >= 2.12.1-3](https://github.com/nagual2/mwan3)**.

## Сборка

```bash
make -f Makefile.build ipk PROJECT_VERSION=1.0.0
./scripts/build-apk-mkpkg.sh
make -f Makefile.build test
```

## Установка

```bash
opkg install ./dist/luci-app-mwan3_1.0.0-1_all.ipk   # 23.x
# или
apk add --allow-untrusted ./dist/luci-app-mwan3-1.0.0-r1.apk   # 25.12+
/etc/init.d/rpcd restart
```

## Связанные пакеты

- [mwan3](https://github.com/nagual2/mwan3) — ядро multi-WAN
- [mwan6-npt](https://github.com/nagual2/mwan6-npt) + [luci](https://github.com/nagual2/mwan6-npt-luci) — NPTv6
