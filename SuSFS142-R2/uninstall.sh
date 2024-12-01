#!/system/bin/sh

# Paths to the files
SUSFS_BIN_PATH="/data/adb/ksu/bin/ksu_susfs"
SUS_SU_PATH="/data/adb/ksu/bin/sus_su"

# Function to safely remove a file if it exists
safe_remove() {
    FILE=$1
    [ -f "$FILE" ] && rm -f "$FILE"
}

# Remove the files
safe_remove "$SUSFS_BIN_PATH"
safe_remove "$SUS_SU_PATH"