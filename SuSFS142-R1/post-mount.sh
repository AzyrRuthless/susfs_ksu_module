#!/system/bin/sh

# Define module and SUSFS binary paths
MODDIR="/data/adb/modules/susfs4ksu"
SUSFS_BIN="/data/adb/ksu/bin/ksu_susfs"

# Source utilities (if needed)
source "${MODDIR}/utils.sh"

# Mount system directories
${SUSFS_BIN} add_sus_mount /system
${SUSFS_BIN} add_sus_mount /system/etc
${SUSFS_BIN} add_sus_mount /system_ext
${SUSFS_BIN} add_sus_mount /product
${SUSFS_BIN} add_sus_mount /vendor

# Debugging log (optional)
# echo "susfs4ksu/post-mount: running" >> /dev/kmsg