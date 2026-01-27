# aic8800-cachyos-6.18
AIC8800 Wi-Fi Driver for CachyOS &amp; Arch Linux

# AIC8800 Wi-Fi Driver for CachyOS & Arch Linux
![Kernel Version](https://img.shields.io/badge/Kernel-6.18+-blueviolet)
![Distro](https://img.shields.io/badge/Tested%20On-CachyOS-orange)

High-performance Linux driver for the **AIC8800DC/DW** chipset, specifically patched and verified for **Linux Kernel 6.18-cachyos** and newer.

This repository solves the common "Firmware not found" and "USB Mass Storage" issues associated with these inexpensive Wi-Fi 6 dongles.

## ✨ Key Features
- **Kernel 6.18+ Support**: Fixed API incompatibilities found in older driver versions.
- **CachyOS Optimized**: Tested with `linux-cachyos` headers for maximum stability.
- **Firmware Path Fix**: Hardcoded to look for firmware in `/aic8800DC/` to avoid common load errors.
- **Automated Mode Switching**: Instructions included for bypassing the "Aic MSC" CD-ROM mode.

---

## 🛠 Prerequisites

Ensure you have your kernel headers and the `usb_modeswitch` utility installed:

```
sudo pacman -S base-devel linux-cachyos-headers usb_modeswitch
```

---

## 🚀 Full Installation Workflow

Copy and paste the following block to set up the firmware, build the driver, install the kernel module, and configure the automatic USB mode-switch rule:

### 1. Setup Firmware Directory
```
sudo mkdir -p /aic8800DC
sudo cp fw/* /aic8800DC/
```

### 2. Build the Driver
```
cd drivers/aic8800/aic8800_fdrv
make -j$(nproc)
```
### 3. Install Module and Update Dependencies
```
sudo make install
sudo depmod -a
```

### 4. Create Udev Rule for Automatic Mode Switching (CD-ROM to Wi-Fi)

```
echo 'ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="a69c", ATTR{idProduct}=="5721", RUN+="/usr/bin/usb_modeswitch -v a69c -p 5721 -K"' | sudo tee /etc/udev/rules.d/99-aic8800.rules
```
### 5. Load the Driver
```
sudo modprobe aic8800_fdrv
```
---

## 🚦 Post-Installation
Check Interface Status

If your Wi-Fi doesn't turn on immediately, it might be soft-blocked by the kernel:
```
sudo rfkill unblock wifi
ip link set wlan0 up
```
Automatic Loading

To ensure the driver loads automatically on every boot, run:
```
echo 'aic8800_fdrv' | sudo tee /etc/modules-load.d/aic8800.conf
```
---

## ⚠️ Notes

    Hardware IDs: This driver targets Vendor a69c with Products 5721 (Storage) and 88dc (Wi-Fi).

    Secure Boot: If Secure Boot is enabled, you must sign the resulting aic8800_fdrv.ko module or the kernel will reject it.

    CachyOS: This was built using gcc and linux-cachyos-headers. Compatibility with other optimized kernels (like Zen or XanMod) is likely but untested.

---

## 📜 License

This project is licensed under the GPL-2.0 License—consistent with the Linux Kernel module requirements.

