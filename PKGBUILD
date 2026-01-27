package() {
  cd "${srcdir}/${pkgname%-git}"

  # 1. Firmware
  install -dm755 "${pkgdir}/usr/lib/firmware/aic8800DC"
  install -m644 firmware/*.bin "${pkgdir}/usr/lib/firmware/aic8800DC/"

  # 2. DKMS
  _destdir="${pkgdir}/usr/src/${pkgname%-git}-${pkgver}"
  install -dm755 "${_destdir}"
  cp -r . "${_destdir}"
  rm -rf "${_destdir}/.git"

  # 3. Udev Rules (Matching your ACTUAL filename)
  install -Dm644 aic8800.rules "${pkgdir}/usr/lib/udev/rules.d/aic8800.rules"
}
