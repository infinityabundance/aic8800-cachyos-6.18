prepare() {
  cd "${srcdir}/aic8800-cachyos-6.18"

  # 1. Flatten the directory structure: Move driver source to root
  mv drivers/aic8800/aic8800_fdrv/* .

  # 2. Fix the Makefile backslashes in the now-local Makefile
  sed -i '45,55s/\.o/.o \\/' Makefile
  sed -i 's/\\ \\/\\/g' Makefile

  # 3. Create a clean dkms.conf for a flat directory
  cat << EOF > dkms.conf
PACKAGE_NAME="aic8800-cachyos"
PACKAGE_VERSION="${pkgver}"
BUILT_MODULE_NAME[0]="aic8800_fdrv"
DEST_MODULE_LOCATION[0]="/kernel/drivers/net/wireless/"
AUTOINSTALL="yes"
EOF
}
