# Maintainer: infinityabundance
pkgname=aic8800-cachyos-git
pkgver=1.0.r0.g0
pkgrel=1
pkgdesc="Patched AIC8800DC driver for CachyOS 6.18. Optimized for Zen kernels."
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

package() {
  cd "${srcdir}/aic8800-cachyos-6.18"

  # 1. Install Firmware to the standard path the driver expects
  install -dm755 "${pkgdir}/usr/lib/firmware/aic8800"
  install -m644 firmware/*.bin "${pkgdir}/usr/lib/firmware/aic8800/"

  # 2. Setup DKMS Source Tree
  _destdir="${pkgdir}/usr/src/aic8800-cachyos-${pkgver}"
  install -dm755 "${_destdir}"
  cp -r . "${_destdir}"

  # 3. Clean up and deploy configuration
  rm -rf "${_destdir}/.git"
  install -m644 dkms.conf "${_destdir}/dkms.conf"
  
  # 4. Install Udev Rules
  install -Dm644 aic8800.rules "${pkgdir}/usr/lib/udev/rules.d/aic8800.rules"
}
