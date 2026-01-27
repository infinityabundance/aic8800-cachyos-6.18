# Maintainer: infinityabundance
pkgname=aic8800-cachyos-6.18-git
pkgver=1.0.r115.g928b219
pkgrel=1
pkgdesc="Patched AIC8800DC driver for CachyOS 6.18."
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

  # 1. Fix root Makefile
  echo -e "all:\n\t\$(MAKE) -C drivers/aic8800/aic8800_fdrv\n\nclean:\n\t\$(MAKE) -C drivers/aic8800/aic8800_fdrv clean" > Makefile

  # 2. Fix nested Makefile backslashes
  sed -i '45,55s/\.o/.o \\/' drivers/aic8800/aic8800_fdrv/Makefile
  sed -i 's/\\ \\/\\/g' drivers/aic8800/aic8800_fdrv/Makefile

  # 3. Write a fresh, explicit dkms.conf
  # This avoids all path and array index confusion.
  cat << EOF > dkms.conf
PACKAGE_NAME="aic8800-cachyos"
PACKAGE_VERSION="${pkgver}"
BUILT_MODULE_NAME[0]="aic8800_fdrv"
BUILT_MODULE_LOCATION[0]="drivers/aic8800/aic8800_fdrv/"
DEST_MODULE_LOCATION[0]="/kernel/drivers/net/wireless/"
AUTOINSTALL="yes"
EOF
}

package() {
  cd "${srcdir}/aic8800-cachyos-6.18"

  # Install Firmware
  install -dm755 "${pkgdir}/usr/lib/firmware/aic8800"
  install -m644 fw/aic8800DC/*.bin "${pkgdir}/usr/lib/firmware/aic8800/"

  # Setup DKMS Source Tree
  _destdir="${pkgdir}/usr/src/aic8800-cachyos-${pkgver}"
  install -dm755 "${_destdir}"
  cp -r . "${_destdir}"

  # Clean up and deploy configuration
  rm -rf "${_destdir}/.git"
  install -m644 dkms.conf "${_destdir}/dkms.conf"
  install -Dm644 aic8800.rules "${pkgdir}/usr/lib/udev/rules.d/aic8800.rules"
}
