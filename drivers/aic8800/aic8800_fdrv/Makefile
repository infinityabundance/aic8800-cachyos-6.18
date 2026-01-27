RWNX_VERS_NUM := 6.4.3.0
CONFIG_AIC8800_WLAN_SUPPORT = m
MODULE_NAME = aic8800_fdrv
CONFIG_COUNTRY_CODE = "00"

# Driver Features
CONFIG_START_FROM_BOOTROM = y
CONFIG_VRF_DCDC_MODE = y
CONFIG_ROM_PATCH_EN ?= y
CONFIG_RWNX_FULLMAC ?= y
CONFIG_USB_SUPPORT = y
CONFIG_RX_REORDER ?= y
CONFIG_ARP_OFFLOAD = y
CONFIG_USE_5G ?= y
CONFIG_USB_BT = y
CONFIG_COEX = y

# Driver Source Files
$(MODULE_NAME)-y := \
	rwnx_msg_tx.o rwnx_msg_rx.o rwnx_utils.o rwnx_cmds.o \
	rwnx_irqs.o rwnx_cfgfile.o rwnx_strs.o rwnx_rx.o \
	rwnx_tx.o rwnx_txq.o rwnx_main.o rwnx_mod_params.o \
	rwnx_mesh.o rwnx_platform.o rwnx_pci.o rwnx_dini.o \
	rwnx_v7.o ipc_host.o rwnx_tdls.o regdb.o md5.o \
	aic_vendor.o aicwf_compat_8800dc.o aicwf_compat_8800d80.o \
	usb_host.o aicwf_txrxif.o aicwf_usb.o

# Build Flags
ccflags-y += -I$(src)/. -DCONFIG_RWNX_FULLMAC -DAICWF_USB_SUPPORT
ccflags-y += -DNX_VIRT_DEV_MAX=4 -DNX_REMOTE_STA_MAX=32 -DNX_MU_GROUP_MAX=62
ccflags-y += -DCONFIG_START_FROM_BOOTROM -DCONFIG_VRF_DCDC_MODE -DCONFIG_ROM_PATCH_EN
ccflags-y += -DCONFIG_COEX -DAICWF_RX_REORDER -DAICWF_ARP_OFFLOAD -DUSE_5G
ccflags-y += -DDEFAULT_COUNTRY_CODE="\"$(CONFIG_COUNTRY_CODE)\""

# Platform Setup
CONFIG_PLATFORM_UBUNTU ?= y

ifeq ($(CONFIG_PLATFORM_UBUNTU), y)
KDIR  ?= /lib/modules/$(shell uname -r)/build
PWD   ?= $(shell pwd)
KVER  ?= $(shell uname -r)
MODDESTDIR ?= /lib/modules/$(KVER)/kernel/drivers/net/wireless/aic8800
SUBARCH = $(shell uname -m | sed -e s/i.86/i386/ -e s/armv.l/arm/ -e s/aarch64/arm64/)
ARCH ?= $(SUBARCH)
endif

all:
	$(MAKE) -C $(KDIR) M=$(PWD) ARCH=$(ARCH) modules

clean:
	rm -rf *.o *.ko *.mod.* modules.* Module.* .tmp* .cache.mk
