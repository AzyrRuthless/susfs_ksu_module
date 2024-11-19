#!/system/bin/sh

# Define module and SUSFS binary paths
MODDIR="/data/adb/modules/susfs4ksu"
SUSFS_BIN="/data/adb/ksu/bin/ksu_susfs"

# Source utilities (if needed)
source "${MODDIR}/utils.sh"

# Debugging log (optional)
# echo "susfs4ksu/post-fs-data: running" >> /dev/kmsg

# Do not delete! SUSFS activation check
if dmesg | grep -q "susfs_init"; then
    touch /debug_ramdisk/susfs_active
fi

# Hide Custom ROM traces
${SUSFS_BIN} add_sus_path /vendor/bin/install-recovery.sh
${SUSFS_BIN} add_sus_path /system/vendor/bin/install-recovery.sh
${SUSFS_BIN} add_sus_path /system/addon.d
${SUSFS_BIN} add_sus_path /system/bin/install-recovery.sh

# Hide KernelSU traces
${SUSFS_BIN} add_sus_mount /data/adb/modules
${SUSFS_BIN} add_sus_mount /debug_ramdisk

# Optional: Hide LSPosed traces (auto if kernel supports it)
# Uncomment and enable if necessary
# for path in $(grep "dex2oa" /proc/mounts | cut -f2 -d " "); do
#     ${SUSFS_BIN} add_try_mount "$path" 1
#     ${SUSFS_BIN} add_sus_mount "$path"
# done

# Mount modules for system
${SUSFS_BIN} add_sus_mount /system

# WARNING: Do With Your Own Risk (DWYOR)
# The following script hides LineageOS, crDroid, and similar traces from your system.
# Use cautiously, as it might break some system functionality.

# Hide LineageOS traces (Disabled by default)
# To enable hiding LineageOS traces:
# 1. Uncomment the relevant lines below.
# 2. Understand the risks (e.g., breaking features or behavior).
# 3. Revert by commenting the lines again if issues occur.

# for path in $(find /system /vendor /system_ext /product -name "*lineage*" -o -name "*crdroid*" -o -name "*Gapps*" -o -name "*gapps*"); do
#     ${SUSFS_BIN} add_sus_path "$path"
# done

# Hide Lineage traces from SELinux policy (Disabled by default)
# SEPOLICY_PATH="/vendor/etc/selinux/vendor_sepolicy.cil"
# if grep -q "lineage" "$SEPOLICY_PATH"; then
#     ${SUSFS_BIN} add_sus_path "$SEPOLICY_PATH"
# fi