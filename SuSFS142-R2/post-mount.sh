#!/system/bin/sh

MODDIR=/data/adb/modules/susfs4ksu

SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs

source ${MODDIR}/utils.sh

# Modules for mounting directories
for PATH in /system /system_ext /system/etc /product /vendor; do
    "${SUSFS_BIN}" add_sus_mount "$PATH"
done