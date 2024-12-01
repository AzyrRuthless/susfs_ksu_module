#!/system/bin/sh

MODDIR=/data/adb/modules/susfs4ksu

SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs

source ${MODDIR}/utils.sh

# KernelSU
"${SUSFS_BIN}" add_sus_mount /data/adb/modules
"${SUSFS_BIN}" add_sus_mount /debug_ramdisk

# LSPosed
for PATH in $(grep "dex2oa" /proc/mounts | cut -f2 -d " "); do
    "${SUSFS_BIN}" add_try_mount "$PATH" 1
    "${SUSFS_BIN}" add_sus_mount "$PATH"
done

# Modules for mounting system
"${SUSFS_BIN}" add_sus_mount /system