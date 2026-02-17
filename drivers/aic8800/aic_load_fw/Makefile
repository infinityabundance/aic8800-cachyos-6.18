# AIC8800 Load FW Makefile - Finalized for CachyOS
MODULE_NAME = aic_load_fw
obj-m := $(MODULE_NAME).o

# All object files required for the loader
$(MODULE_NAME)-y := aic_bluetooth_main.o \
                    aicbluetooth.o \
                    aicbluetooth_cmds.o \
                    aicwf_usb.o \
                    aic_txrxif.o \
                    aic_compat_8800d80.o \
                    md5.o \
                    aicwf_rx_prealloc.o \
                    aicwf_txq_prealloc.o

# Fixed: Added -DCONFIG_USE_FW_REQUEST if you want the driver 
# to use the standard Linux firmware loading API
ccflags-y += -I$(src)/ -DAICWF_USB_SUPPORT -DCONFIG_PLATFORM_UBUNTU -DCONFIG_USE_FW_REQUEST -DCONFIG_PREALLOC_RX_SKB -DCONFIG_PREALLOC_TXQ

KDIR  := /lib/modules/$(shell uname -r)/build
PWD   := $(shell pwd)

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
