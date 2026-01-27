#!/bin/bash
# AIC8800 DKMS Auto-Installer for CachyOS
DRV_NAME="aic8800"
DRV_VERSION="1.0.0"

echo "Starting AIC8800 driver installation..."

# 1. Prepare the source directory
sudo mkdir -p /usr/src/${DRV_NAME}-${DRV_VERSION}

# 2. Copy all files (using . ensures everything is included)
sudo cp -r . /usr/src/${DRV_NAME}-${DRV_VERSION}

# 3. Register with DKMS
sudo dkms add -m ${DRV_NAME} -v ${DRV_VERSION}

# 4. Build and Install
sudo dkms build -m ${DRV_NAME} -v ${DRV_VERSION}
sudo dkms install -m ${DRV_NAME} -v ${DRV_VERSION}

echo "Installation complete. The driver will now automatically update with your kernel."
