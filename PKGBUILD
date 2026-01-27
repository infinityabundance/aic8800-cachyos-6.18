# Maintainer: infinityabundance
pkgname=aic8800-cachyos-6.18-git
pkgver=1.0.r124.g4b52d5d
pkgrel=1
pkgdesc="Patched AIC8800DC driver - Explicit Path Build"
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

  # 1. DO NOT move files. Keep them where they are.
  _src_path="drivers/aic8800/aic8800_fdrv"

  # 2. Create the Makefile in the ROOT
  # We use the $(src) variable which is the absolute path to the build dir provided by Kbuild
  cat << EOF > Makefile
obj-m += aic8800_fdrv.o
aic8800_fdrv-y := \\
	\$(src)/\${_src_path}/aic8800_fdrv_main.o \\
	\$(src)/\${_src_path}/aic_bsp_main.o \\
	\$(src)/\${_src_path}/aic_bsp_pwrctl.o \\
	\$(src)/\${_src_path}/aic_bsp_fw.o \\
	\$(src)/\${_src_path}/aic_bsp_sdiow3.o \\
	\$(src)/\${_src_path}/aic_bsp_txrx.o \\
	\$(src)/\${_src_path}/aic_bsp_driver.o \\
	\$(src)/\${_src_path}/rwnx_main.o \\
	\$(src)/\${_src_path}/rwnx_msg_tx.o \\
	\$(src)/\${_src_path}/rwnx_msg_rx.o \\
	\$(src)/\${_src_path}/rwnx_utils.o \\
	\$(src)/\${_src_path}/rwnx_v7.o \\
	\$(src)/\${_src_path}/rwnx_txq.o \\
	\$(src)/\${_src_path}/rwnx_tx.o \\
	\$(src)/\${_src_path}/rwnx_config.o \\
	\$(src)/\${_src_path}/rwnx_maclist.o \\
	\$(src)/\${_src_path}/rwnx_vendor.o

ccflags-y += -I\$(src)/\${_src_path}
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
