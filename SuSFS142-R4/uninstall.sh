#!/system/bin/sh

# Paths to the files
SUSFS_BIN_PATH="/data/adb/ksu/bin/ksu_susfs"
SUS_SU_PATH="/data/adb/ksu/bin/sus_su"

# Remove the files
rm -f "$SUSFS_BIN_PATH" "$SUS_SU_PATH"