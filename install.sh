#!/bin/bash

# Use the current directory instead of hardcoded Tenda paths
BASE_DIR=$(pwd)

echo "Installing udev rules..."
# Copy from current repo location instead of /usr/src/tenda/
cp "$BASE_DIR/aic.rules" /etc/udev/rules.d/
udevadm control --reload
udevadm trigger

echo "Installing firmware..."
mkdir -p /lib/firmware/aic8800DC
cp -rf "$BASE_DIR/fw/aic8800DC/"* /lib/firmware/aic8800DC/

echo "Building drivers..."
cd "$BASE_DIR/drivers/aic8800/"
make && make install

# Load modules using the compiled files
modprobe cfg80211
insmod "$BASE_DIR/drivers/aic8800/aic_load_fw/aic_load_fw.ko"
insmod "$BASE_DIR/drivers/aic8800/aic8800_fdrv/aic8800_fdrv.ko"

echo "Building RF test tools..."
cd "$BASE_DIR/aicrf_test/"
make && make install

echo "Installation complete!"
