#!/bin/bash

# 1. Fix rwnx_rx.c Timer API
# Replaces the broken from_timer macro with a direct container_of call
sed -i 's/from_timer(preorder_ctrl, t, reord_timer)/container_of(t, struct reord_ctrl, reord_timer)/g' rwnx_rx.c

# 2. Fix rwnx_main.c P2P Timer API
sed -i 's/from_timer(rwnx_hw, t, p2p_alive_timer)/container_of(t, struct rwnx_hw, p2p_alive_timer)/g' rwnx_main.c

# 3. Fix rwnx_main.c Monitor Channel Designator
# Corrects the syntax by removing the (void *) cast and adding the '=' sign
sed -i 's/.set_monitor_channel (void \*)rwnx_cfg80211_set_monitor_channel/.set_monitor_channel = rwnx_cfg80211_set_monitor_channel/g' rwnx_main.c

# 4. Remove the VFS internal namespace import
# This namespace blocks out-of-tree drivers on modern kernels
sed -i '/MODULE_IMPORT_NS(VFS_internal_I_am_really_a_filesystem_and_am_NOT_a_driver);/d' rwnx_main.c

echo "Patches applied. Now run the make command with KCFLAGS to suppress warnings."
