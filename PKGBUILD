# Maintainer: infinityabundance
pkgname=aic8800-cachyos-6.18-git
pkgver=1.0.r116.ge1f332b
pkgrel=1
pkgdesc="Patched AIC8800DC driver for CachyOS 6.18 - Flattened Build"
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

  # 1. Flatten the directory: Move driver source to root so DKMS sees it immediately
  # Using -n to prevent overwriting existing root files if they exist
  mv drivers/aic8800/aic8800_fdrv/* .

  # 2. Fix the Makefile backslashes in the now-local Makefile
  sed -i '45,55s/\.o/.o \\/' Makefile
  sed -i 's/\\ \\/\\/g' Makefile

  # 3. Create a clean, flat dkms.conf
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

  # Install Firmware to the standard location
  install -dm755 "${pkgdir}/usr/lib/firmware/aic8800"
  install -m644 fw/aic8800DC/*.bin "${pkgdir}/usr/lib/firmware/aic8800/"

  # Setup DKMS Source Tree
  _destdir="${pkgdir}/usr/src/aic8800-cachyos-${pkgver}"
  install -dm755 "${_destdir}"
  
  # Copy the flattened source (current directory) to the DKMS source folder
  cp -r . "${_destdir}"

  # Clean up and deploy configuration
  rm -rf "${_destdir}/.git"
  install -m644 dkms.conf "${_destdir}/dkms.conf"
  install -Dm644 aic8800.rules "${pkgdir}/usr/lib/udev/rules.d/aic8800.rules"
}
