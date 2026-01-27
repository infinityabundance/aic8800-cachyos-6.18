all:
	$(MAKE) -C drivers/aic8800/aic8800_fdrv
	$(MAKE) -C drivers/aic8800/aic8800_btlpm

clean:
	$(MAKE) -C drivers/aic8800/aic8800_fdrv clean
	$(MAKE) -C drivers/aic8800/aic8800_btlpm clean
prepare() {
  cd "$srcdir/aic8800-cachyos-6.18"
  # Flatten source files into root
  cp -v drivers/aic8800/aic8800_fdrv/*.[ch] .

  # Create a Makefile that uses $(PWD) to find itself
  cat << 'EOF' > Makefile
obj-m += aic8800_fdrv.o

# We use $(obj)/ to ensure the kernel knows these files are in the local build dir
aic8800_fdrv-y := \
	aic8800_fdrv_main.o \
	aic_bsp_main.o \
	aic_bsp_pwrctl.o \
	aic_bsp_fw.o \
	aic_bsp_sdiow3.o \
	aic_bsp_txrx.o \
	aic_bsp_driver.o \
	rwnx_main.o \
	rwnx_msg_tx.o \
	rwnx_msg_rx.o \
	rwnx_utils.o \
	rwnx_v7.o \
	rwnx_txq.o \
	rwnx_tx.o \
	rwnx_config.o \
	rwnx_maclist.o \
	rwnx_vendor.o

ccflags-y += -I$(src)
ccflags-y += -DCONFIG_AIC8800_WLAN_SUPPORT -DCONFIG_RWNX_FULLMAC
ccflags-y += -DCONFIG_AIC_FW_PATH=\"/usr/lib/firmware/aic8800\"
ccflags-y += -Wno-implicit-fallthrough -Wno-int-conversion -Wno-incompatible-pointer-types
EOF
}
