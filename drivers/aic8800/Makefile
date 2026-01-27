# AIC8800 Master Makefile for Linux/CachyOS
CONFIG_AIC_LOADFW_SUPPORT := m
CONFIG_AIC8800_WLAN_SUPPORT := m

# Compile both the loader and the main driver
obj-$(CONFIG_AIC_LOADFW_SUPPORT)    += aic_load_fw/
obj-$(CONFIG_AIC8800_WLAN_SUPPORT) += aic8800_fdrv/

# Default to Ubuntu/Generic Linux logic
CONFIG_PLATFORM_UBUNTU ?= y

# Parallel build optimization
MAKEFLAGS += -j$(shell nproc)

ifeq ($(CONFIG_PLATFORM_UBUNTU), y)
KDIR  := /lib/modules/$(shell uname -r)/build
PWD   := $(shell pwd)
KVER  := $(shell uname -r)
# Standard path for wireless drivers on Linux
MODDESTDIR := /lib/modules/$(KVER)/kernel/drivers/net/wireless/aic8800
SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/armv.l/arm/ -e s/aarch64/arm64/)
ARCH ?= $(SUBARCH)
CROSS_COMPILE ?=
endif

all:
	$(MAKE) -C $(KDIR) M=$(PWD) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules

install:
	mkdir -p $(MODDESTDIR)
	install -p -m 644 aic_load_fw/aic_load_fw.ko $(MODDESTDIR)/
	install -p -m 644 aic8800_fdrv/aic8800_fdrv.ko $(MODDESTDIR)/
	/sbin/depmod -a ${KVER}

uninstall:
	rm -rf $(MODDESTDIR)
	/sbin/depmod -a ${KVER}

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
	rm -rf modules.order Module.symvers
