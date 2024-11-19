#!/system/bin/sh

# Define module and SUSFS binary paths
MODDIR="/data/adb/modules/susfs4ksu"
SUSFS_BIN="/data/adb/ksu/bin/ksu_susfs"

# Source utilities (if needed)
source "${MODDIR}/utils.sh"

# Check if SuSFS kernel is active
if [ ! -f /debug_ramdisk/susfs_active ]; then
    # Update module description to indicate failure
    sed -i 's/^description=.*/description=status: failed 💢 - Make sure you\'re on a SuSFS-patched kernel!/g' "$MODDIR/module.prop"
    
    # Disable module if SuSFS kernel not found
    touch "${MODDIR}/disable"
    echo "susfs4ksu/action: SuSFS kernel not found 💢"
    echo "susfs4ksu/action: Module disabled ❌"
    sleep 10
    exit 1
fi

# Toggle logging state
if [ -f "${MODDIR}/susfs_log_enable" ]; then
    # Disable logging
    rm "${MODDIR}/susfs_log_enable"
    ${SUSFS_BIN} enable_log 0
    echo "susfs4ksu/action: Logging disabled ❌"
    description="description=status: active ✅ | logging: disabled ❌"
else
    # Enable logging
    touch "${MODDIR}/susfs_log_enable"
    ${SUSFS_BIN} enable_log 1
    echo "susfs4ksu/action: Logging enabled ✅"
    description="description=status: active ✅ | logging: enabled ✅"
fi

# Update module description
sed -i "s/^description=.*/$description/g" "$MODDIR/module.prop"

# Wait for a few seconds before exiting
sleep 5
exit 1