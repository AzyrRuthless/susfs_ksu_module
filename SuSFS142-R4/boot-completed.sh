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

# Hide Lineage and related custom ROM traces
find /system /vendor /system_ext /product \( -iname "*lineage*" -o -name "*crdroid*" \) -exec ${SUSFS_BIN} add_sus_path {} \;

# Hide GApps installation traces
find /system /vendor /system_ext /product \( -iname "*gapps*xml" -o -type d -iname "*gapps*" \) -exec ${SUSFS_BIN} add_sus_path {} \;

# Hide ReVanced
count=0
max_attempts=15

while ! grep -q "youtube" /proc/self/mounts && [ $count -lt $max_attempts ]; do
    sleep 1
    ((count++))
done

packages="com.google.android.youtube com.google.android.apps.youtube.music"

hide_app() {
    pm path "$1" | cut -d: -f2 | while read -r path; do
        "${SUSFS_BIN}" add_sus_mount "$path"
        "${SUSFS_BIN}" add_try_umount "$path" 1
    done
}

for i in $packages; do
    hide_app "$i"
done