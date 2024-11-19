#!/system/bin/sh

MODDIR="/data/adb/modules/susfs4ksu"
SUSFS_BIN="/data/adb/ksu/bin/ksu_susfs"

source "${MODDIR}/utils.sh"

# Detect SuSFS status
if [ -f /debug_ramdisk/susfs_active ]; then
    # Toggle SuSFS logging
    if [ -f "${MODDIR}/susfs_log_enable" ]; then
        ${SUSFS_BIN} enable_log 1
        description="description=status: active ✅ | logging: enabled ✅"
    else
        ${SUSFS_BIN} enable_log 0
        description="description=status: active ✅ | logging: disabled ❌"
    fi
else
    description="description=status: failed 💢 - Make sure you're on a SuSFS-patched kernel!"
    # Disable the module
    touch "${MODDIR}/disable"
    # Disable action usage (optional)
    # rm "${MODDIR}/action.sh"
fi

# Update module description
sed -i "s/^description=.*/$description/g" "${MODDIR}/module.prop"

# Hide ReVanced-related packages
count=0
max_attempts=15

# Wait until the desired apps are mounted
until grep "youtube" /proc/self/mounts || [ $count -ge $max_attempts ]; do
    sleep 1
    ((count++))
done

# List of packages to hide
packages=(
    "com.google.android.youtube"
    "com.google.android.apps.youtube.music"
)

# Function to hide apps
hide_app() {
    for path in $(pm path "$1" | cut -d: -f2); do
        ${SUSFS_BIN} add_sus_mount "$path"
        ${SUSFS_BIN} add_try_umount "$path" 1
    done
}

# Apply hiding logic for each package
for package in "${packages[@]}"; do
    hide_app "$package"
done