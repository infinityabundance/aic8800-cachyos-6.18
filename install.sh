#!/bin/bash

# Dynamically set the base directory to wherever the script is located
BASE_DIR=$(pwd)
FW_SRC="$BASE_DIR/fw/aic8800DC"
DRV_DIR="$BASE_DIR/drivers/aic8800"
TEST_DIR="$BASE_DIR/aicrf_test"

echo "Step 1: Configuring Udev rules..."
cp "$BASE_DIR/aic.rules" /etc/udev/rules.d/ 2>/dev/null
udevadm control --reload && udevadm trigger

# Handle the virtual disk if it exists
if [ -L /dev/aicudisk ]; then
    eject /dev/aicudisk
fi

echo "Step 2: Installing Firmware..."
mkdir -p /lib/firmware/aic8800DC
cp -rf "$FW_SRC/"* /lib/firmware/aic8800DC/

echo "Step 3: Building and Installing Drivers..."
cd "$DRV_DIR"
make && make install
if [ $? -ne 0 ]; then
    echo "Driver build failed."
    exit 1
fi

# Load dependencies and modules
modprobe cfg80211
# Use modprobe first, fallback to relative insmod if not yet in depmod path
modprobe aic_load_fw 2>/dev/null || insmod "$DRV_DIR/aic_load_fw/aic_load_fw.ko"
modprobe aic8800_fdrv 2>/dev/null || insmod "$DRV_DIR/aic8800_fdrv/aic8800_fdrv.ko"

echo "Step 4: Building RF Test tools..."
cd "$TEST_DIR"
make && make install

echo "Installation complete!"
exit 0
