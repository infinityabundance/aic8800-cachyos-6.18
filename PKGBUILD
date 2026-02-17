# Maintainer: infinityabundance
pkgname=aic8800-cachyos-dkms
pkgver=1.0.r132.g213d94c
pkgrel=1
pkgdesc="AIC8800DC/DW DKMS driver for CachyOS"
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
  cd "$srcdir/aic8800-cachyos-6.18"
  printf "1.0.r%s.g%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

package() {
  cd "$srcdir/aic8800-cachyos-6.18"

  # 1. Firmware
  install -dm755 "$pkgdir/usr/lib/firmware/aic8800DC"
  install -m644 fw/aic8800DC/*.bin "$pkgdir/usr/lib/firmware/aic8800DC/"

  # 2. DKMS Source
  local _fullver=$(pkgver)
  local _destdir="$pkgdir/usr/src/aic8800-cachyos-$_fullver"
  install -dm755 "$_destdir"
  cp -a . "$_destdir/"
  rm -rf "$_destdir/.git"

  # 3. DKMS Config
  install -m644 dkms.conf "$_destdir/dkms.conf"

  # 4. Udev rules
  install -Dm644 aic8800.rules "$pkgdir/usr/lib/udev/rules.d/aic8800.rules"
  install -Dm644 aic.rules "$pkgdir/usr/lib/udev/rules.d/aic.rules"
}
