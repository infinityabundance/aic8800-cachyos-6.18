#!/bin/bash
# AIC8800 DKMS Auto-Installer for CachyOS

# 1. Check for DKMS and Headers dependency
if ! command -v dkms &> /dev/null; then
    echo "Error: DKMS is not installed."
    echo "Please run: sudo pacman -S dkms linux-cachyos-headers"
    echo "Note: If you use a different kernel, install the matching headers (e.g., linux-cachyos-lts-headers)"
    exit 1
fi

DRV_NAME="aic8800"
DRV_VERSION="1.0.0"

echo "------------------------------------------"
echo "Installing AIC8800 Driver v$DRV_VERSION"
echo "------------------------------------------"

# 2. Remove old version if it exists to prevent conflicts
sudo dkms remove -m ${DRV_NAME} -v ${DRV_VERSION} --all 2>/dev/null

# 3. Prepare the source directory in /usr/src
echo "Creating source directory at /usr/src/${DRV_NAME}-${DRV_VERSION}..."
sudo mkdir -p /usr/src/${DRV_NAME}-${DRV_VERSION}

# 4. Copy all files (using '.' to include hidden files and structure)
sudo cp -r . /usr/src/${DRV_NAME}-${DRV_VERSION}

# 5. Register, Build, and Install via DKMS
echo "Registering module with DKMS..."
sudo dkms add -m ${DRV_NAME} -v ${DRV_VERSION}

echo "Building module (this may take a minute)..."
sudo dkms build -m ${DRV_NAME} -v ${DRV_VERSION}

echo "Installing module..."
sudo dkms install -m ${DRV_NAME} -v ${DRV_VERSION}

echo "------------------------------------------"
echo "Installation complete!"
echo "The driver will now automatically rebuild on every kernel update."
echo "------------------------------------------"
