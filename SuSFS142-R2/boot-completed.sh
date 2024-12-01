#!/system/bin/sh

MODDIR=/data/adb/modules/susfs4ksu

SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs

source ${MODDIR}/utils.sh

if dmesg | grep -q "susfs:"; then
 description="description=status: ✅ SuS ඞ "
 else
 description="description=status: failed ❌ - Make sure you're on a SuSFS patched kernel!"
 touch ${MODDIR}/disable
fi

sed -i "s/^description=.*/$description/g" $MODDIR/module.prop

# Custom ROM - Add paths to SUSFS
for PATH in /system/addon.d /vendor/bin/install-recovery.sh /system/bin/install-recovery.sh; do
    "${SUSFS_BIN}" add_sus_path "$PATH"
done

# Hide Lineage and related custom ROM traces
for PATH in $(find /system /vendor /system_ext /product -iname '*lineage*' -o -name '*crdroid*'); do
    "${SUSFS_BIN}" add_sus_path "$PATH"
done

# Hide GApps installation traces
for PATH in $(find /system /vendor /system_ext /product -iname '*gapps*xml' -o -type d -iname '*gapps*'); do
    "${SUSFS_BIN}" add_sus_path "$PATH"
done

# Hide ReVanced
count=0
max_attempts=15

# Wait until "youtube" is found in /proc/self/mounts or max_attempts is reached
while ! grep -q "youtube" /proc/self/mounts && [ "$count" -lt "$max_attempts" ]; do
    sleep 1
    ((count++))
done

# Packages to hide
packages="com.google.android.youtube com.google.android.apps.youtube.music"

# Function to hide app paths
hide_app() {
    for path in $(pm path "$1" | cut -d: -f2); do
        "${SUSFS_BIN}" add_sus_mount "$path"
        "${SUSFS_BIN}" add_try_umount "$path" 1
    done
}

# Process each package
for package in $packages; do
    hide_app "$package"
done