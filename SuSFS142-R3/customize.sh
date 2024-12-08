#!/system/bin/sh

DEST_BIN_DIR=/data/adb/ksu/bin

# Check if destination directory exists
if [ ! -d "${DEST_BIN_DIR}" ]; then
    ui_print "'${DEST_BIN_DIR}' does not exist, installation aborted."
    rm -rf "${MODPATH}"
    exit 1
fi

# Unzip the package to temporary directory
unzip "${ZIPFILE}" -d "${TMPDIR}/susfs"

# Copy appropriate binary files based on architecture
if [ "${ARCH}" = "arm64" ]; then
    cp "${TMPDIR}/susfs/tools/ksu_susfs_arm64" "${DEST_BIN_DIR}/ksu_susfs"
    cp "${TMPDIR}/susfs/tools/sus_su_arm64" "${DEST_BIN_DIR}/sus_su"
elif [ "${ARCH}" = "arm" ]; then
    cp "${TMPDIR}/susfs/tools/ksu_susfs_arm" "${DEST_BIN_DIR}/ksu_susfs"
    cp "${TMPDIR}/susfs/tools/sus_su_arm" "${DEST_BIN_DIR}/sus_su"
fi

# Set file permissions
chmod 755 "${DEST_BIN_DIR}/ksu_susfs" "${DEST_BIN_DIR}/sus_su"
chmod 644 "${MODPATH}/post-fs-data.sh" "${MODPATH}/service.sh" "${MODPATH}/uninstall.sh"

# Clean up unnecessary files
rm -rf "${MODPATH}/tools"
rm "${MODPATH}/customize.sh"