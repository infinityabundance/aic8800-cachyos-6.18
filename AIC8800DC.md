# AICSEMI AIC8800DC

The AIC8800DC is a highly integrated single-chip solution featuring 2.4GHz Wi-Fi 6 and Bluetooth 5.2. It is designed for wireless and IoT applications, offering a compact 4mm x 4mm QFN36 package.
Key Specifications
## Wi-Fi 6 Features

Protocol Support: Fully integrated RF, Modem, and MAC supporting 2.4GHz Wi-Fi 6.

Data Rates: Reaches up to 286.8 Mbps (TX) and 229.4 Mbps (RX) with 20/40MHz bandwidth.

Performance:

TX Power: Up to 20dBm in 11b mode; 18dBm in HT/VHT/HE40 MCS7 modes.

RX Sensitivity: -98dBm in 11b 1M mode.

Advanced Features: Supports MU-MIMO, OFDMA, TWT (Target Wake Time), STBC, beamforming, and LDPC.

Security: Comprehensive support including WPA3-SAE Personal, WPA2, WPA, WEP, and MFP.

Operating Modes: STA, AP, and Wi-Fi Direct modes can run concurrently.

## Bluetooth 5.2 Features

Compatibility: Supports all mandatory and optional features for Bluetooth 2.1+EDR, 3.0, 4.x, and 5.2.

Topologies: Supports advanced master and slave topologies.

Enhancements: Uses soft-bit cascading for gfsk header demodulation (3dB enhancement) and an optimized channel quality assessment for AFH enhancement.

## Platform & Interfaces

Host Interfaces: Supports USB 2.0, SDIO, HCI_UART, and PCM interfaces.

Integrated Components: Includes a WLAN CPU, security accelerator, DMA, PMU, and integrated RAM/ROM.

Other Tools: Features a low-power timer, watchdog, and 512-bit eFuse.

## Electrical & Physical

Voltage Supply (VBAT): Recommended 3.3V (range of 2.97V to 3.63V).

Ambient Temperature: Operates between -20°C and +80°C.

Packaging: Compact QFN36 package measuring 4mm x 4mm x 0.85mm.



 CMOS single‐chip fully‐integrated RF, Modemand MAC


 Support STA, AP, Wi‐Fi Direct modes concurrently
 Support STBC, beamforming
 Support Wi‐Fi6 TWT
 Support Two NAV, Buffer Report, Spatial reuse, Multi‐BSSID, intra‐PPDU power save
 Support LDPC
 SupportMU‐MIMO,OFDMA
 Support DCM, Mid‐amble, UORA
 Support WEP/WPA/WPA2/WPA3‐SAE Personal, MFP
1.2 BTDM5.2 Features   
 Supports allthemandatory and optionalfeatures of Bluetooth 2.1+EDR/3.0/4.x/5.2
 Supports advanced master and slave topologies
 Use soft‐bit cascading algorithm for demodulating gfsk header, 3db enhancement
 Use an optimization method to assess channel quality, AFH enhancement
1.3 Other Features
 Supports SDIO/USB2.0/HCI_UART/PCMinterface
 Integrated low powertimer and watchdog
 512 bits eFuse

Compact profile package：4mm×4mm×0.85mm QFN36

Applications:
 IoT device
 Wireless device

### Electrical Characteristics

**Table 3-1 DC Electrical Specification (Recommended Operation Conditions):**

| SYMBOL | DESCRIPTION | MIN | TYP | MAX | UNIT |
| :--- | :--- | :--- | :--- | :--- | :--- |
| VBAT | Supply Voltage from battery or LDO | 2.97 | 3.3 | 3.63 | V |
| Tamb | Ambient Temperature | -20 | 27 | +80 | ℃ |
| VIL | CMOS Low Level Input Voltage | 0 | | 0.3*VIO | V |
| VIH | CMOS High Level Input Voltage | 0.7*VIO | | VIO | V |
| VTH | CMOS Threshold Voltage | | 0.5*VIO | | V |


## 2. Platform Description

### Figure 2-1 AIC8800DC Block Diagram

```mermaid
graph TD
    subgraph AIC8800DC ["AIC8800DC"]
        direction TB
        
        %% Column 1
        BTDM["BTDM5.2"]
        WIFI6["WIFI6"]
        PMU["PMU"]
        
        %% Column 2
        ROM["ROM"]
        WLAN["WLAN CPU"]
        SEC["Security Acc"]
        DMA["DMA"]
        SRAM["SRAM"]
        
        %% Column 3
        USB["USB2.0"]
        SDIO["SDIO"]
        UART["UART"]
        ADC["ADC"]
        GPIO["GPIO"]

        %% Define Layout/Alignment
        BTDM --- ROM --- USB
        WIFI6 --- WLAN --- SDIO
        WIFI6 --- SEC --- UART
        WIFI6 --- DMA --- ADC
        PMU --- SRAM --- GPIO
    end

    %% Style for Blue Blocks
    style BTDM fill:#5B9BD5,color:#fff,stroke:#2F5597
    style WIFI6 fill:#5B9BD5,color:#fff,stroke:#2F5597
    style PMU fill:#5B9BD5,color:#fff,stroke:#2F5597
    style ROM fill:#5B9BD5,color:#fff,stroke:#2F5597
    style WLAN fill:#5B9BD5,color:#fff,stroke:#2F5597
    style SEC fill:#5B9BD5,color:#fff,stroke:#2F5597
    style DMA fill:#5B9BD5,color:#fff,stroke:#2F5597
    style SRAM fill:#5B9BD5,color:#fff,stroke:#2F5597
    style USB fill:#5B9BD5,color:#fff,stroke:#2F5597
    style SDIO fill:#5B9BD5,color:#fff,stroke:#2F5597
    style UART fill:#5B9BD5,color:#fff,stroke:#2F5597
    style ADC fill:#5B9BD5,color:#fff,stroke:#2F5597
    style GPIO fill:#5B9BD5,color:#fff,stroke:#2F5597
```
```mermaid
graph TD
    %% Define Top Pins (Pin 36 to 26)
    subgraph TopRow ["Top Pins"]
        direction LR
        P36[36: RF_ANT] --- P35[35: PWRKEY] --- P34[34: GPIOA9] --- P33[33: VDD33_PA] --- P32[32: AVDD] --- P31[31: V_RF] --- P30[30: GPIOA8] --- P29[29: SW1] --- P28[28: SW2] --- P27[27: VDD33] --- P26[26: GPIOB2]
    end

    %% Left Column (Pin 1 to 7)
    subgraph LeftSide ["Left Pins"]
        direction TB
        P1[01: RF_IND] --- P2[02: GPIOA7] --- P3[03: GPIOA0] --- P4[04: GPIOA1] --- P5[05: GPIOA2] --- P6[06: GPIOA3] --- P7[07: GPIOA4]
    end

    %% Center Die
    EPAD((EPAD / GND))

    %% Right Column (Pin 25 to 19)
    subgraph RightSide ["Right Pins"]
        direction TB
        P25[25: V_CORE] --- P24[24: VIO] --- P23[23: GPIOA10] --- P22[22: GPIOA11] --- P21[21: GPIOA12] --- P20[20: GPIOA13] --- P19[19: GPIOA14]
    end

    %% Bottom Row (Pin 8 to 18)
    subgraph BottomRow ["Bottom Pins"]
        direction LR
        P8[08: GPIOA5] --- P9[09: GPIOA6] --- P10[10: XTAL1] --- P11[11: XTAL2] --- P12[12: AVDD18] --- P13[13: GPIOB3] --- P14[14: GPIOB0] --- P15[15: GPIOB1] --- P16[16: USB_DM] --- P17[17: USB_DP] --- P18[18: GPIOA15]
    end

    %% Layout Constraints to force the square shape
    TopRow --- LeftSide
    TopRow --- RightSide
    LeftSide --- BottomRow
    RightSide --- BottomRow
    TopRow --- EPAD --- BottomRow

    %% Styling
    style EPAD fill:#BDD7EE,stroke:#2F5597,stroke-dasharray: 5 5
    style TopRow fill:none,stroke:none
    style BottomRow fill:none,stroke:none
    style LeftSide fill:none,stroke:none
    style RightSide fill:none,stroke:none
    
    classDef pin fill:#fff,stroke:#333,stroke-width:1px,font-size:10px;
    class P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29,P30,P31,P32,P33,P34,P35,P36 pin;
```
