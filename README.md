# aic8800-cachyos-6.18

<p align="center">
  <a href="https://github.com/infinityabundance/aic8800-cachyos-6.18">
    <img src="/assets/aic8800.png" alt="AIC8800" width="200">
  </a>
</p>

<h1 align="center">AIC8800 Driver (CachyOS Optimized)</h1>

AIC8800 Wi-Fi Driver for CachyOS &amp; Arch Linux

# AIC8800 Wi-Fi Driver for CachyOS & Arch Linux
![Kernel Version](https://img.shields.io/badge/Kernel-6.18+-blueviolet)
![Distro](https://img.shields.io/badge/Tested%20On-CachyOS-orange)

High-performance Linux driver for the **AIC8800DC/DW** chipset, specifically patched and verified for **Linux Kernel 6.18-cachyos** and newer.

The AIC8800 is often sold under the name Fenvi Wifi 6 AX286 USB, as well as many other names (COMFAST CF-940AX, Tenda W311MI V6, Tenda U11 V1, Tenda U2 v5, BrosTrend AX5, TP-LINK Archer TX1U Nano etc.)

[AIC8800-based WiFi 6 AX300 USB adapter sells for less than $3](https://www.cnx-software.com/2024/06/21/aic8800-cheap-wifi-6-ax300-usb-adapter/)

[https://wikidevi.wi-cat.ru/AIC](https://wikidevi.wi-cat.ru/AIC)

[Fenvi Wifi 6 AX286 USB](https://aliexpress.com/item/1005005698160651.html)

aliexpress.com/item/1005005698160651.html

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

## 🚀 Installation (DKMS)

### 1. Install Dependencies

Before installing the driver, you must ensure you have the kernel headers and DKMS installed. For CachyOS, run:

```
sudo pacman -S dkms linux-cachyos-headers
```
Note: If you are using a different kernel (like linux-cachyos-lts or linux-cachyos-bore), install the matching headers package (e.g., linux-cachyos-lts-headers).

### 2. Install the Driver

Use the provided automation script to register the driver with DKMS. This ensures the driver is automatically rebuilt whenever your kernel updates.

```
git clone https://github.com/infinityabundance/aic8800-cachyos-6.18.git
cd aic8800-cachyos-6.18
chmod +x install.sh
sudo ./install.sh
```

### 3. Load the Driver

After installation, you can load the module immediately without rebooting:

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

## 💿 USB Modeswitch (Storage Eject)

Many AIC8800 USB devices initially mount as a Virtual CD-ROM/Storage device. The driver will not load until the device is switched to Wi-Fi mode.

Manual Eject: If your device is plugged in but the Wi-Fi isn't showing up, find the "CD-ROM" in your file manager and click Eject, or run:
Bash

### Replace 'sr0' with your actual virtual CD-ROM device if different
```
sudo eject /dev/sr0
```
Automated Eject (Recommended): To handle this automatically every time you plug it in, install the usb_modeswitch package:

```
sudo pacman -S usb_modeswitch
```
Most modern distributions will then handle the switch automatically using udev rules.

---

## 🔍 Troubleshooting & USB Mode Switch

Many AIC8800 devices initially mount as a Virtual CD-ROM (Storage Mode) to provide Windows drivers. Linux will not see the Wi-Fi card until the device is "switched."

### Manual Mode Switch (SCSI Command)
If your device stays in storage mode and does not switch automatically, you can force the switch using the following command:

```
sudo sg_raw -v /dev/sdc 1b 00 00 00 01 00
```

Replace `/dev/sdc` with your actual device node (check with `lsblk`).
This command sends a SCSI Start Stop Unit to the device, triggering the mode switch to WiFi mode (`a69c:88dc`).

After running this command, check with `lsusb` to confirm the device now shows as `AIC8800DC` (WiFi mode).

You can then load the driver:
```
sudo modprobe aic8800_fdrv
```

And check for the WiFi interface:
```
ip link
iw dev
```
1. Identify the Mode

Check your Device ID by running:

```
lsusb | grep -iE "a69c|368b"
```
Mode	ID (VID:PID)	Status

Storage	a69c:5721	Stuck. Wi-Fi is hidden.

Wi-Fi	368b:8d81	Ready. Driver should load.

2. Manual Fix (Eject)

If stuck in Storage Mode, eject the virtual disk:

```
sudo eject /dev/sr0
```

3. Automated Fix (Recommended)

Create a udev rule to handle this automatically whenever you plug the device in:

```
echo 'ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="a69c", ATTR{idProduct}=="5721", RUN+="/usr/bin/eject %k"' | sudo tee /etc/udev/rules.d/99-aic8800.rules
sudo udevadm control --reload-rules && sudo udevadm trigger
```
4. Verify Firmware & Driver

Check the kernel logs to ensure the firmware loaded correctly:

```
dmesg | grep -i "aic8"
```
Success: Should show Firmware download success.

Error -2: Means you forgot to copy the files to /usr/lib/firmware/aic8800DC/.

---

## 📂 Module: `aic_load_fw`

Path: drivers/aic8800/aic_load_fw/

This module is the "Loader" for the AIC8800 series. Its primary purpose is to initialize the USB bus, verify the integrity of the firmware binaries, and upload the necessary patches and configurations to the chip's internal memory before the main Wi-Fi driver takes over.

### 🛠 Core Logic & Initialization

`aic_bluetooth_main.c`: The entry point for the kernel module. It handles module parameters (like debug levels), registers the USB driver with the kernel, and orchestrates the handover between Wi-Fi and Bluetooth initialization.

`aic_compat_8800d80.c` / .h: The hardware abstraction layer. It defines specific offsets, filenames, and register values that differ between chip revisions (e.g., 8800DC vs. 8800D80).

`rwnx_version_gen.h`: Automatically generated header containing the driver version, build date, and RivieraWaves (RW) stack revision.

### 📡 Bus & Communication Layer

`aicwf_usb.c` / .h: The physical transport layer. It manages USB Request Blocks (URBs), handles device plugging/unplugging (enumeration), and implements power management (suspend/resume) for the USB interface.

`aic_txrxif.c` / .h: The Bus Transmission/Reception Interface. It provides a generic API for sending management frames and data packets over the USB bus, including a priority-based frame queuing system.

`aicbluetooth_cmds.c` / .h: Implements the RivieraWaves command protocol. This is used to send low-level "Memory Write" and "Start App" requests to the chip's internal processor during the boot phase.

### ⚡ Performance & Memory Optimization

`aicwf_rx_prealloc.c` / .h: Implements a high-performance RX buffer pool. By pre-allocating memory for incoming packets at startup, it reduces CPU overhead and prevents dropped packets during high-speed data transfers.

`aicwf_txq_prealloc.c` / .h: Similar to the RX pool, this manages pre-allocated memory for the transmission queues to ensure consistent latency and system stability under heavy load.

### 🔍 Utilities & Diagnostics

`aicbluetooth.c` / .h: Contains the logic for parsing firmware "Patch Tables." It reads the .bin files from /lib/firmware/ and determines which specific segments need to be flashed to the hardware.

`md5.c` / .h: Provides MD5 checksum verification. It ensures that the firmware binaries loaded from the disk are not corrupted before they are pushed to the chip.

`aicwf_debug.h`: The diagnostic engine. It defines the AICWFDBG macros and various log levels (INFO, ERROR, TRACE) used to troubleshoot the driver via dmesg.

### 🏗 Integration

`Makefile`: The build script configured for generic Linux environments. It compiles the above files into aic_load_fw.ko.

`Kconfig`: The configuration menu file that allows the loader to be toggled as a module (<M>) or built into the kernel (<*>).

---

## 🛠️ Module: `aic8800_fdrv`

Path: drivers/aic8800/aic8800_fdrv/

The aic8800_fdrv directory contains the Full-MAC (fdrv) driver logic. This component acts as the primary interface between the Linux kernel's cfg80211 subsystem and the AIC8800 series hardware.
🚀 Key Features & Optimizations

Wi-Fi 6 Support: Full implementation of 802.11ax features, including MU-MIMO and VHT Beamforming via `rwnx_bfmer.c`.

Advanced Rate Control: Utilizes `rwnx_extrc.c` for dynamic MCS (Modulation and Coding Scheme) scaling, ensuring maximum throughput even in high-interference environments.

CachyOS Performance Tuning:

RX Pre-allocation: Uses `aicwf_rx_prealloc.c` and `aic_rx_fill.c` to maintain a high-speed buffer pool, reducing CPU overhead during gigabit-speed transfers.

Low Latency: Optimized IRQ handling via `rwnx_irqs.c` to minimize packet jitter.

Broad Compatibility: Includes specific hardware abstraction layers for both 8800DC and 8800D80 chip revisions.

### 🐧 Modern Kernel Compatibility (6.18+)

This version of the driver has been specifically patched to support changes in modern rolling-release kernels used by CachyOS:

`wireless_dev` Update: Patched to handle the relocation/renaming of the mtx member to ensure thread-safe locking.

Channel Switch Notification: Updated `cfg80211_ch_switch_notify` signatures to match the requirements of kernels 6.18.

### 📂 File Breakdown

Component	Responsibility
`rwnx_main.c`	Module entry/exit and core radio state management.
`rwnx_cfg80211.c`	Standardized interface for NetworkManager and wpa_supplicant.
`rwnx_utils.c`	Bus-agnostic utility functions (USB/SDIO detection).
`aicwf_compat_*.c`	Chip-specific calibration and firmware loading logic.
`rwnx_radar.c`	DFS (Dynamic Frequency Selection) for legal 5GHz operation.

### ⚙️ Build Options (Makefile)

You can toggle specific features within the Makefile to optimize the driver size:

CONFIG_PREALLOC_RX_SKB: Enables the high-performance RX buffer pool (Default: y).

CONFIG_BR_SUPPORT: Enables support for network bridging (Default: y).

CONFIG_AIC8800_SDIO_SUPPORT: Enable only for integrated SDIO chips (Default: n for USB).

---

## ⚠️ Notes

    Hardware IDs: This driver targets Vendor a69c with Products 5721 (Storage) and 88dc (Wi-Fi).

    Secure Boot: If Secure Boot is enabled, you must sign the resulting aic8800_fdrv.ko module or the kernel will reject it.

    CachyOS: This was built using gcc and linux-cachyos-headers. Compatibility with other optimized kernels (like Zen or XanMod) is likely but untested.

---

## 📜 License

This project is licensed under the GPL-2.0 License—consistent with the Linux Kernel module requirements.

---
## ⚠️ USB Mode Switch (Manual Required)

Many AIC8800 USB devices initially appear as a Virtual CD-ROM (storage mode) and must be switched to WiFi mode before the driver will load.

**Manual Mode Switch:**

If your device shows up as `a69c:5721` (Aic MSC) in `lsusb`, you must manually force a USB bus reset to switch it to WiFi mode:

1. Unplug and replug the device, or
2. Run the following script as root (replace `1-6.4.3` with your device's path if different):

```sh
echo '1-6.4.3' | sudo tee /sys/bus/usb/drivers/usb/unbind
sleep 2
echo '1-6.4.3' | sudo tee /sys/bus/usb/drivers/usb/bind
```

After this, the device should reappear as `a69c:88dc` (AIC8800DC) in `lsusb` and the driver will load.

**Note:**
- Do not use automatic scripts or udev rules for mode switching. Manual intervention is required and recommended for reliability.
- If you have issues, check `lsusb` and `dmesg` for device status.

