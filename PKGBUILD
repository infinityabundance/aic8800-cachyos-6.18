# Maintainer: infinityabundance
pkgname=aic8800-cachyos-6.18-git
pkgver=1.0.r119.g5f65c0c
pkgrel=1
pkgdesc="Patched AIC8800DC driver - Final Force Build"
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

  # 1. Flatten the directory
  mv drivers/aic8800/aic8800_fdrv/* .

  # 2. Force the obj-m target by overwriting the first 2 lines
  # This removes the conditional CONFIG check entirely.
  sed -i '1,2c\obj-m += aic8800_fdrv.o\naic8800_fdrv-y := \\' Makefile

  # 3. Clean up backslashes (ensure no trailing junk after .o)
  sed -i 's/\.o.*/.o \\/g' Makefile
  # Fix the very last object so it doesn't have a trailing backslash
  sed -i '/aic_vendor.o/s/\\//' Makefile

  # 4. Standard dkms.conf
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
