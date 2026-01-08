# Airoha AN7581/AN7583/EN7523 Kernel 6.18 Migration

## Overview
This document describes the migration from Linux kernel 6.12 to 6.18 for Airoha SoC platforms.

## Changes Made

### 1. Kernel Version Update
- Updated `KERNEL_PATCHVER` from 6.12 to 6.18 in `airoha/Makefile`

### 2. Patch Directory
- Created `patches-6.18` directory
- Removed patches already merged into mainline kernel (v6.13-v6.17)
- Retained 105 patches:
  - v6.18 patches (not yet in mainline)
  - v6.19 patches (future backports)
  - Custom/vendor patches (116-xxx, 220-xxx, 401-xxx, 600-xxx, 801-xxx, etc.)

### 3. Configuration Files
Created config-6.18 for all subtargets:
- `an7581/config-6.18` - AN7581/AN7566/AN7551 SoC configuration
- `an7583/config-6.18` - AN7583 SoC configuration  
- `en7523/config-6.18` - EN7523 SoC configuration

### 4. Key Features Enabled in 6.18

#### AN7581 Configuration Highlights:
- Airoha Ethernet driver with NPU offload support
- Hardware flow offloading and statistics
- PWM support (CONFIG_PWM_AIROHA=y)
- PCIe Gen3 support
- USB 3.0 PHY support
- Thermal management
- CPUFreq with SMCCC
- MT7530 DSA switch support
- SPI NAND with BMT support
- Audio (I2S/AFE) support

#### AN7583 Configuration Highlights:
- Similar to AN7581 but with:
  - MDIO_AIROHA enabled for AN7583 MDIO controller
  - PCS_AIROHA_AN7583 instead of AN7581
  - Crypto EIP-93 engine support
  - Different PHY configuration

## Patches Removed (Already in Mainline 6.18)

The following patch categories were removed as they are already merged:
- v6.13 patches: Basic driver fixes and initial support
- v6.14 patches: CPUFreq, PM domain, clock improvements
- v6.15 patches: Network driver enhancements, pinctrl fixes
- v6.16 patches: L2 acceleration, thermal driver
- v6.17 patches: PPPoE offload, bug fixes

## Patches Retained for 6.18

### Network Driver (v6.18-v6.19):
- NPU WiFi offload support
- WLAN flowtable TX offload
- PPE improvements and AN7583 support
- Out-of-order TX completion handling
- Loopback mode fixes

### Pinctrl (v6.19):
- AN7583 pin support
- PHY LED and PWM GPIO macros
- Function mismatch fixes

### SPI (v6.19):
- SNFI improvements
- Dual/Quad IO flash support
- Buffer handling fixes

### Clock (600-series):
- Regmap API conversion
- AN7583 clock support
- Reset controller support

### PHY (801-802-804):
- AS21xxx PHY driver improvements
- C45 operation fixes

### Custom Patches:
- BMT (Bad Block Management Table) support
- Crypto EIP-93 engine
- PCS driver for Airoha SoC
- Phylink support for GDM2-4

## Testing Recommendations

1. **Boot Test**: Verify all three subtargets boot successfully
2. **Network Test**: Test Ethernet, switch, and WiFi offload
3. **Storage Test**: Verify SPI NAND with BMT
4. **PCIe Test**: Check PCIe device enumeration
5. **USB Test**: Verify USB 3.0 functionality
6. **Thermal Test**: Monitor temperature sensors
7. **Audio Test**: Test I2S/AFE if applicable

## Known Issues

- Some v6.19 patches may need adjustment when 6.19 is released
- Custom patches (116-xxx, 220-xxx) may need review for API changes

## Build Instructions

```bash
# Standard OpenWrt build
make menuconfig
# Select Target System: Airoha ARM
# Select Subtarget: AN7581 / AN7583 / EN7523
make -j$(nproc)
```

## Rollback Instructions

If issues occur, revert to 6.12:
```bash
# In airoha/Makefile, change:
KERNEL_PATCHVER:=6.12
# Use config-6.12 files instead of config-6.18
```

---
**Migration Date**: January 8, 2026  
**Migrated By**: Kernel Maintainer  
**Kernel Version**: 6.12 → 6.18
