# drivers/aic8800/aic8800_fdrv/Makefile

RWNX_VERS_NUM := 6.4.3.0
MODULE_NAME = aic8800_fdrv

# Feature Toggles
CONFIG_AIC8800_WLAN_SUPPORT = m
CONFIG_RWNX_FULLMAC = y
CONFIG_ROM_PATCH_EN = y
CONFIG_USE_5G = y
CONFIG_BR_SUPPORT = y

# Set the correct firmware path for CachyOS
ccflags-y += -DCONFIG_AIC_FW_PATH=\"/lib/firmware/aic8800DC/\"

# Compiler Warnings Suppression
ccflags-y += -Wno-implicit-fallthrough -Wno-attribute-warning -Wno-unused-function

# Object Files
$(MODULE_NAME)-y := \
    rwnx_main.o \
    aic_rx_fill.o \
    rwnx_msg_tx.o \
    rwnx_msg_rx.o \
    rwnx_utils.o \
    rwnx_v7.o \
    rwnx_txq.o \
    rwnx_tx.o \
    rwnx_rx.o \
    rwnx_irqs.o \
    rwnx_pci.o \
    rwnx_p2p.o \
    rwnx_mesh.o \
    rwnx_extrc.o \
    rwnx_tdls.o \
    rwnx_cfg80211.o \
    rwnx_vendor_cmd.o \
    rwnx_bfmer.o \
    rwnx_radar.o \
    aic_br_ext.o

# Search paths for headers
ccflags-y += -I$(src) -I$(src)/../aic_load_fw

# Kernel Build Logic
KDIR  := /lib/modules/$(shell uname -r)/build
PWD   := $(shell pwd)

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
