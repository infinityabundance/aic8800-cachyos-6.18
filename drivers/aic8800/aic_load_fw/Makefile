# Module Configuration
CONFIG_AIC_LOADFW_SUPPORT = m
MODULE_NAME = aic_load_fw
CONFIG_USB_SUPPORT = y
CONFIG_RFTEST = y
CONFIG_USB_BT = y
CONFIG_USB_MSG_EP = y
CONFIG_LINK_DET_5G = y
CONFIG_PREALLOC_TXQ = y

# Feature Flags
ccflags-y += -DAICWF_USB_SUPPORT -DCONFIG_RFTEST -DCONFIG_USB_BT
ccflags-y += -DCONFIG_USB_MSG_EP -DCONFIG_LINK_DET_5G -DCONFIG_PREALLOC_TXQ
ccflags-$(CONFIG_PLATFORM_PC) += -DCONFIG_PLATFORM_PC

# Source Files
obj-$(CONFIG_AIC_LOADFW_SUPPORT) := $(MODULE_NAME).o
$(MODULE_NAME)-y := aic_bluetooth_main.o \
                    aicbluetooth.o \
                    aicwf_usb.o \
                    aic_txrxif.o \
                    aicbluetooth_cmds.o \
                    aic_compat_8800d80.o \
                    md5.o \
                    aicwf_txq_prealloc.o

# Platform Setup (CachyOS / PC)
KDIR  := /lib/modules/$(shell uname -r)/build
PWD   := $(shell pwd)
KVER  := $(shell uname -r)
MODDESTDIR := /lib/modules/$(KVER)/kernel/drivers/net/wireless/aic8800
SUBARCH = $(shell uname -m | sed -e s/i.86/i386/ -e s/armv.l/arm/ -e s/aarch64/arm64/)
ARCH ?= $(SUBARCH)

all: modules

modules:
	$(MAKE) -C $(KDIR) M=$(PWD) ARCH=$(ARCH) modules

install:
	mkdir -p $(MODDESTDIR)
	install -p -m 644 $(MODULE_NAME).ko $(MODDESTDIR)/
	/sbin/depmod -a ${KVER}

uninstall:
	rm -rfv $(MODDESTDIR)/$(MODULE_NAME).ko
	/sbin/depmod -a ${KVER}

clean:
	rm -rf *.o *.ko *.mod.* modules.* Module.* .tmp* .cache.mk
