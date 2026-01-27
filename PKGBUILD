# Maintainer: infinityabundance
pkgname=aic8800-cachyos-6.18-git
pkgver=1.0.r128.g948a271
pkgrel=1
pkgdesc="AIC8800DC driver - Final Flat Source Fix"
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

  # 1. Physically move all files from the deep nested dir to the current root
  # This is more reliable than 'cp' during packaging
  cp -v drivers/aic8800/aic8800_fdrv/*.[ch] .

  # 2. Create a dead-simple Makefile in the SAME root directory
  cat << EOF > Makefile
obj-m += aic8800_fdrv.o
aic8800_fdrv-y := \\
	aic8800_fdrv_main.o \\
	aic_bsp_main.o \\
	aic_bsp_pwrctl.o \\
	aic_bsp_fw.o \\
	aic_bsp_sdiow3.o \\
	aic_bsp_txrx.o \\
	aic_bsp_driver.o \\
	rwnx_main.o \\
	rwnx_msg_tx.o \\
	rwnx_msg_rx.o \\
	rwnx_utils.o \\
	rwnx_v7.o \\
	rwnx_txq.o \\
	rwnx_tx.o \\
	rwnx_config.o \\
	rwnx_maclist.o \\
	rwnx_vendor.o

ccflags-y += -I\$(src)
ccflags-y += -DCONFIG_AIC8800_WLAN_SUPPORT -DCONFIG_RWNX_FULLMAC
ccflags-y += -DCONFIG_AIC_FW_PATH=\\\"/usr/lib/firmware/aic8800\\\"
ccflags-y += -Wno-implicit-fallthrough -Wno-int-conversion -Wno-incompatible-pointer-types
EOF

  # 3. Standard dkms.conf
  cat << EOF > dkms.conf
PACKAGE_NAME="aic8800-cachyos"
PACKAGE_VERSION="${pkgver}"
BUILT_MODULE_NAME[0]="aic8800_fdrv"
DEST_MODULE_LOCATION[0]="/kernel/drivers/net/wireless/"
AUTOINSTALL="yes"
EOF

  echo "--- DEBUG: Files in root build directory ---"
  ls -1 *.c
}

package() {
  cd "${srcdir}/aic8800-cachyos-6.18"
  
  # Install Firmware
  install -dm755 "${pkgdir}/usr/lib/firmware/aic8800"
  install -m644 fw/aic8800DC/*.bin "${pkgdir}/usr/lib/firmware/aic8800/"
  
  # Install DKMS Source (Everything we flattened in prepare)
  _destdir="${pkgdir}/usr/src/aic8800-cachyos-${pkgver}"
  install -dm755 "\${_destdir}"
  cp *.[ch] Makefile dkms.conf "\${_destdir}/"
  
  install -Dm644 aic8800.rules "${pkgdir}/usr/lib/udev/rules.d/aic8800.rules"
}
