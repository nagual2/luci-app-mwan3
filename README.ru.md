# luci-app-mwan3 (форк nagual2)

[English](README.md) | **Русский** | [Deutsch](README.de.md)

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

## Установка (OpenWrt 25.12+ / apk)

**Рекомендуется** — скрипт установки (pin в `/etc/apk/world` создаётся автоматически):

```bash
make -f Makefile.build apk
./scripts/install-apk.sh 192.168.1.1
./scripts/verify-apk-pins.sh 192.168.1.1
```

Вручную (тот же pin):

```bash
scp dist/luci-app-mwan3-1.0.0-r1.apk root@192.168.1.1:/tmp/
ssh root@192.168.1.1 'apk add --allow-untrusted /tmp/luci-app-mwan3-1.0.0-r1.apk'
```

OpenWrt 23.x (opkg):

```bash
opkg install ./dist/luci-app-mwan3_1.0.0-1_all.ipk
/etc/init.d/rpcd restart
```

## Закрепление fork (pin, apk)

В официальных feeds OpenWrt **25.12+** лежит **stock** `luci-app-mwan3`. Без pin команда `apk upgrade` или LuCI Package Manager может заменить fork на stock.

### Как работает pin

При `apk add --allow-untrusted ./package.apk` в `/etc/apk/world` появляется строка с **идентичностью пакета**:

```text
luci-app-mwan3><Q1nHRY/ED5OC6j6o49PBlZhqDdhRs=
```

Суффикс `><` фиксирует **именно nagual2-сборку**, а не версию из feeds. Строка `luci-app-mwan3` без `><` означает «брать из feeds».

То же для **[mwan3](https://github.com/nagual2/mwan3)**, **[mwan6-npt](https://github.com/nagual2/mwan6-npt)**, **[luci-app-mwan6-npt](https://github.com/nagual2/mwan6-npt-luci)** при установке через `apk add --allow-untrusted`.

### Проверка

```bash
grep -E '^(mwan3|mwan6-npt|luci-app-mwan3|luci-app-mwan6-npt)><' /etc/apk/world
apk policy luci-app-mwan3
./scripts/verify-apk-pins.sh 192.168.1.1
```

### Обновление fork

```bash
scp dist/luci-app-mwan3-NEW.apk root@192.168.1.1:/tmp/
ssh root@192.168.1.1 'apk add --allow-untrusted /tmp/luci-app-mwan3-NEW.apk'
```

Pin обновится на новый hash.

### Не делайте `apk del luci-app-mwan3`

Из‑за зависимости **`luci-i18n-mwan3-ru`** удаление сразу подтянет **stock** из feeds.

### Русская локализация (nagual2)

Feeds **`luci-i18n-mwan3-ru`** не переводит строки nagual2. Используйте **[luci-i18n-mwan3-ru](https://github.com/nagual2/luci-i18n-mwan3-ru)** (upstream + дельта форка). Ставьте **после** `luci-app-mwan3`:

```bash
apk add --allow-untrusted ./luci-i18n-mwan3-ru-*.apk
```

### Локальный apk-feed (несколько роутеров)

```bash
./scripts/setup-local-apk-feed.sh 192.168.1.1
```

Публикует APK и `packages.adb` в `/www/nagual2/`. Установка по-прежнему с **`--allow-untrusted`**; после установки проверьте pin.

## Связанные пакеты

- [mwan3](https://github.com/nagual2/mwan3) — ядро multi-WAN
- [mwan6-npt](https://github.com/nagual2/mwan6-npt) + [luci](https://github.com/nagual2/mwan6-npt-luci) — NPTv6
- [luci-i18n-mwan3-ru](https://github.com/nagual2/luci-i18n-mwan3-ru) — русский UI (nagual2)

## Документация

Триязычные README: `/usr/share/doc/luci-app-mwan3/` (`README.en.md`, `README.ru.md`, `README.de.md`).
