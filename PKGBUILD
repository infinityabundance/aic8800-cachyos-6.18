# Maintainer: infinityabundance
pkgname=aic8800-cachyos-6.18-git
pkgver=1.0.r120.g14320f9
pkgrel=1
pkgdesc="Patched AIC8800DC driver - Clean Flat Build"
arch=('x86_64')
url="https://github.com/infinityabundance/aic8800-cachyos-6.18"
license=('GPL')
depends=('dkms' 'linux-cachyos-headers')
makedepends=('git' 'base-devel')
provides=('aic8800-cachyos')
conflicts=('aic8800-cachyos')
source=("git+${url}.git")
sha256sums=('SKIP')

pkgver() {
  cd "${srcdir}/aic8800-cachyos-6.18"
  printf "1.0.r%s.g%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

prepare() {
  cd "${srcdir}/aic8800-cachyos-6.18"

  # 1. Flatten the directory: Move all driver source files to the root
  find drivers/aic8800/aic8800_fdrv/ -maxdepth 1 -type f -exec mv {} . \;

  # 2. Create a fresh, working Makefile from scratch
  # This avoids all the 'recipe commences before first target' issues.
  cat << 'EOF' > Makefile
obj-m += aic8800_fdrv.o
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

# Set necessary compiler flags
ccflags-y += -I$(src)
ccflags-y += -DCONFIG_AIC8800_WLAN_SUPPORT
ccflags-y += -DCONFIG_RWNX_FULLMAC
ccflags-y += -DCONFIG_AIC_FW_PATH=\"/usr/lib/firmware/aic8800\"

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
EOF

  # 3. Create the dkms.conf
  cat << EOF > dkms.conf
PACKAGE_NAME="aic8800-cachyos"
PACKAGE_VERSION="${pkgver}"
BUILT_MODULE_NAME[0]="aic8800_fdrv"
DEST_MODULE_LOCATION[0]="/kernel/drivers/net/wireless/"
AUTOINSTALL="yes"
EOF
}

package() {
  cd "${srcdir}/aic8800-cachyos-6.18"
  install -dm755 "${pkgdir}/usr/lib/firmware/aic8800"
  install -m644 fw/aic8800DC/*.bin "${pkgdir}/usr/lib/firmware/aic8800/"
  
  _destdir="${pkgdir}/usr/src/aic8800-cachyos-${pkgver}"
  install -dm755 "${_destdir}"
  cp -r . "${_destdir}"
  rm -rf "${_destdir}/.git"
  install -m644 dkms.conf "${_destdir}/dkms.conf"
  install -Dm644 aic8800.rules "${pkgdir}/usr/lib/udev/rules.d/aic8800.rules"
}
