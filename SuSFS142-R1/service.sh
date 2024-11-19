#!/system/bin/sh

# Define module and SUSFS binary paths
MODDIR="/data/adb/modules/susfs4ksu"
SUSFS_BIN="/data/adb/ksu/bin/ksu_susfs"

# Source utilities
source "${MODDIR}/utils.sh"

## Function: Enable sus_su ##
enable_sus_su() {
    # Define overlay folder
    SYSTEM_OL="${MODDIR}/overlay"
    rm -rf "${SYSTEM_OL}" 2>/dev/null
    mkdir -p "${SYSTEM_OL}/system_bin" 2>/dev/null

    # Enable sus_su
    ${SUSFS_BIN} sus_su 1

    # Copy generated sus_su files to overlay directory
    cp -f /data/adb/ksu/bin/sus_su "${SYSTEM_OL}/system_bin/su"
    cp -f /data/adb/ksu/bin/sus_su_drv_path "${SYSTEM_OL}/system_bin/sus_su_drv_path"

    # Clone permissions
    susfs_clone_perm "${SYSTEM_OL}/system_bin" /system/bin
    susfs_clone_perm "${SYSTEM_OL}/system_bin/su" /system/bin/sh
    susfs_clone_perm "${SYSTEM_OL}/system_bin/sus_su_drv_path" /system/bin/sh

    # Mount overlay
    mount -t overlay KSU -o "lowerdir=${SYSTEM_OL}/system_bin:/system/bin" /system/bin

    # Hide the mountpoint and add unmount for no-root-granted processes
    ${SUSFS_BIN} add_sus_mount /system/bin
    ${SUSFS_BIN} add_try_umount /system/bin 1
}

# Enable sus_su (Uncomment if using KernelSU with kprobe hooks)
enable_sus_su

# Disable SUSFS kernel logging (optional)
# ${SUSFS_BIN} enable_log 0

# Set boot_completed to 0
resetprop -w sys.boot_completed 0

# Reset system properties for hiding traces
check_reset_prop "ro.boot.vbmeta.device_state" "locked"
check_reset_prop "ro.boot.verifiedbootstate" "green"
check_reset_prop "ro.boot.flash.locked" "1"
check_reset_prop "ro.boot.veritymode" "enforcing"
check_reset_prop "ro.boot.warranty_bit" "0"
check_reset_prop "ro.warranty_bit" "0"
check_reset_prop "ro.debuggable" "0"
check_reset_prop "ro.force.debuggable" "0"
check_reset_prop "ro.secure" "1"
check_reset_prop "ro.adb.secure" "1"
check_reset_prop "ro.build.type" "user"
check_reset_prop "ro.build.tags" "release-keys"
check_reset_prop "ro.vendor.boot.warranty_bit" "0"
check_reset_prop "ro.vendor.warranty_bit" "0"
check_reset_prop "vendor.boot.vbmeta.device_state" "locked"
check_reset_prop "vendor.boot.verifiedbootstate" "green"
check_reset_prop "sys.oem_unlock_allowed" "0"

# MIUI-specific properties
check_reset_prop "ro.secureboot.lockstate" "locked"

# Realme-specific properties
check_reset_prop "ro.boot.realmebootstate" "green"
check_reset_prop "ro.boot.realme.lockstate" "1"

# Hide recovery boot traces
contains_reset_prop "ro.bootmode" "recovery" "unknown"
contains_reset_prop "ro.boot.bootmode" "recovery" "unknown"
contains_reset_prop "vendor.boot.bootmode" "recovery" "unknown"

# Debugging log (optional)
# echo "susfs4ksu/service: running" >> /dev/kmsg