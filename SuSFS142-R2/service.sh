#!/system/bin/sh
MODDIR=/data/adb/modules/susfs4ksu
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs

source "${MODDIR}/utils.sh"

## sus_su ##
enable_sus_su() {
    # Create an 'overlay' folder in module root directory for storing the 'su' and sus_su_drv_path in /system/bin/
    SYSTEM_OL=${MODDIR}/overlay
    rm -rf "${SYSTEM_OL}" 2>/dev/null
    mkdir -p "${SYSTEM_OL}/system_bin" 2>/dev/null
    
    # Enable sus_su or abort the function if sus_su is not supported
    if ! "${SUSFS_BIN}" sus_su 1; then
        return
    fi
    
    # Copy the new generated sus_su_drv_path and 'sus_su' to /system/bin/ and rename 'sus_su' to 'su'
    cp -f /data/adb/ksu/bin/sus_su "${SYSTEM_OL}/system_bin/su"
    cp -f /data/adb/ksu/bin/sus_su_drv_path "${SYSTEM_OL}/system_bin/sus_su_drv_path"
    
    # Setup permissions
    susfs_clone_perm "${SYSTEM_OL}/system_bin" /system/bin
    susfs_clone_perm "${SYSTEM_OL}/system_bin/su" /system/bin/sh
    susfs_clone_perm "${SYSTEM_OL}/system_bin/sus_su_drv_path" /system/bin/sh
    
    # Mount the overlay
    mount -t overlay KSU -o "lowerdir=${SYSTEM_OL}/system_bin:/system/bin" /system/bin
    
    # Hide the mountpoint
    "${SUSFS_BIN}" add_sus_mount /system/bin
    
    # Umount it for no root granted process
    "${SUSFS_BIN}" add_try_umount /system/bin 1
}

# Enable sus_su
# Uncomment this if you are using kprobe hooks ksu, make sure CONFIG_KSU_SUSFS_SUS_SU config is enabled when compiling kernel
enable_sus_su

# Disable susfs kernel log
# "${SUSFS_BIN}" enable_log 0

## Props ##
resetprop -w sys.boot_completed 0

# Standard props reset
props_to_reset="ro.boot.vbmeta.device_state:locked
ro.boot.verifiedbootstate:green
ro.boot.flash.locked:1
ro.boot.veritymode:enforcing
ro.boot.warranty_bit:0
ro.warranty_bit:0
ro.debuggable:0
ro.force.debuggable:0
ro.secure:1
ro.adb.secure:1
ro.build.type:user
ro.build.tags:release-keys
ro.vendor.boot.warranty_bit:0
ro.vendor.warranty_bit:0
vendor.boot.vbmeta.device_state:locked
vendor.boot.verifiedbootstate:green
sys.oem_unlock_allowed:0
ro.secureboot.lockstate:locked
ro.boot.realmebootstate:green
ro.boot.realme.lockstate:1"

for prop in $props_to_reset; do
    key=${prop%%:*}
    value=${prop##*:}
    check_reset_prop "$key" "$value"
done

# Hide that we booted from recovery when magisk is in recovery mode
recovery_props="ro.bootmode:recovery:unknown
ro.boot.bootmode:recovery:unknown
vendor.boot.bootmode:recovery:unknown"

for prop in $recovery_props; do
    key=${prop%%:*}
    current=${prop%:*}; current=${current##*:}
    target=${prop##*:}
    contains_reset_prop "$key" "$current" "$target"
done

# Holmes 1.5+ Futile Trace Hide
# Look for a loop that has a journal
for device in $(ls -Ld /proc/fs/jbd2/loop*8 2>/dev/null | sed 's|/proc/fs/jbd2/||; s|-8||'); do
    "${SUSFS_BIN}" add_sus_path "/proc/fs/jbd2/${device}-8"
    "${SUSFS_BIN}" add_sus_path "/proc/fs/ext4/${device}"
done

# Clean vendor sepolicy
# Evades reveny's native detector and native test (10)
if grep -q lineage /vendor/etc/selinux/vendor_sepolicy.cil; then
    # Create a copy without "lineage" references
    grep -v "lineage" /vendor/etc/selinux/vendor_sepolicy.cil > /debug_ramdisk/vendor_sepolicy.cil
    
    # Add to susfs kernel statistics
    ${SUSFS_BIN} add_sus_kstat /vendor/etc/selinux/vendor_sepolicy.cil
    
    # Clone permissions to the new copy
    susfs_clone_perm /debug_ramdisk/vendor_sepolicy.cil /vendor/etc/selinux/vendor_sepolicy.cil
    
    # Use bind mount to replace the original file
    mount --bind /debug_ramdisk/vendor_sepolicy.cil /vendor/etc/selinux/vendor_sepolicy.cil
    
    # Update susfs kernel statistics
    ${SUSFS_BIN} update_sus_kstat /vendor/etc/selinux/vendor_sepolicy.cil
    
    # Add the file to susfs mount list
    ${SUSFS_BIN} add_sus_mount /vendor/etc/selinux/vendor_sepolicy.cil
fi