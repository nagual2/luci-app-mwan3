#
# Copyright (C) 2017 Dan Luedtke <mail@danrl.com>
# nagual2 fork: LuCI for mwan3 with IPv6 multi-WAN options
#
# Licensed under the GPL-2.0 (same as upstream LuCI app).

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for MWAN3 (nagual2 IPv6 multi-WAN)
LUCI_DEPENDS:=+luci-base +mwan3
PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=LICENSE NOTICE
PKG_MAINTAINER:=nagual2
PKG_VERSION?=1.0.0
PKG_RELEASE?=1

# When outside the luci feed tree:
#   make package/luci-app-mwan3/compile LUCI_DIR=/path/to/luci
LUCI_DIR ?= $(TOPDIR)/feeds/luci

include $(LUCI_DIR)/luci.mk

# call BuildPackage - OpenWrt buildroot signature
