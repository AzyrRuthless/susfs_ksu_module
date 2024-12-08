#!/system/bin/sh

MODDIR=/data/adb/modules/susfs4ksu

SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs

source ${MODDIR}/utils.sh

# Custom ROM - Add paths to SUSFS
for PATH in /system/addon.d /vendor/bin/install-recovery.sh /system/bin/install-recovery.sh; do
    "${SUSFS_BIN}" add_sus_path "$PATH"
done

# LSPosed
while read -r line; do
  if [[ "$line" == *"dex2oa"* ]]; then
    mount=$(echo "$line" | awk '{print $2}')
    ${SUSFS_BIN} add_try_mount "$mount" 1
    ${SUSFS_BIN} add_sus_mount "$mount"
  fi
done < /proc/mounts