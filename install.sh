#!/bin/bash
# AIC8800 Universal Installer for CachyOS/Linux
BASE_DIR=$(pwd)

echo "Step 1: Configuring Udev rules..."
# Fixed: No longer looks in /usr/src/tenda/ [cite: 4, 13]
cp "$BASE_DIR/aic.rules" /etc/udev/rules.d/
udevadm control --reload
udevadm trigger

# Handle the virtual disk if it exists [cite: 5]
if [ -L /dev/aicudisk ]; then
    eject /dev/aicudisk
fi

echo "Step 2: Installing Firmware..."
# Fixed: Dynamic pathing to local 'fw' folder 
mkdir -p /lib/firmware/aic8800DC
cp -rf "$BASE_DIR/fw/aic8800DC/"* /lib/firmware/aic8800DC/

echo "Step 3: Building and Installing Drivers..."
cd "$BASE_DIR/drivers/aic8800/"
make && make install
if [ $? -ne 0 ]; then
    echo "Driver build failed. Check kernel headers."
    exit 1
fi

# Load modules [cite: 8, 9]
modprobe cfg80211
insmod "$BASE_DIR/drivers/aic8800/aic_load_fw/aic_load_fw.ko"
insmod "$BASE_DIR/drivers/aic8800/aic8800_fdrv/aic8800_fdrv.ko"

echo "Step 4: Building RF Test tools..."
cd "$BASE_DIR/aicrf_test/"
make && make install

echo "Installation complete!"
exit 0
