# AIC8800 Load FW Makefile
MODULE_NAME = aic_load_fw
obj-m := $(MODULE_NAME).o

# Fixed: Explicitly include all shared source files
$(MODULE_NAME)-y := aic_bluetooth_main.o \
                    aic_bluetooth_cmds.o \
                    aicwf_usb.o \
                    aic_txrxif.o \
                    aic_compat_8800d80.o \
                    md5.o \
                    aicwf_txq_prealloc.o

# Fixed: Use relative include paths for better portability
ccflags-y += -I$(src)/ -DAICWF_USB_SUPPORT -DCONFIG_PLATFORM_UBUNTU -DCONFIG_PREALLOC_TXQ

KDIR  := /lib/modules/$(shell uname -r)/build
PWD   := $(shell pwd)

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
