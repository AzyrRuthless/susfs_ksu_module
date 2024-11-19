#!/system/bin/sh

# Define destination binary directory
DEST_BIN_DIR="/data/adb/ksu/bin"

# Check if destination directory exists
if [ ! -d "${DEST_BIN_DIR}" ]; then
    ui_print "'${DEST_BIN_DIR}' does not exist. Installation aborted."
    rm -rf "${MODPATH}"
    exit 1
fi

# Extract files from the ZIP archive
unzip "${ZIPFILE}" -d "${TMPDIR}/susfs"

# Copy binaries based on architecture
case "${ARCH}" in
    "arm64")
        cp "${TMPDIR}/susfs/tools/ksu_susfs_arm64" "${DEST_BIN_DIR}/ksu_susfs"
        cp "${TMPDIR}/susfs/tools/sus_su_arm64" "${DEST_BIN_DIR}/sus_su"
        ;;
    "arm")
        cp "${TMPDIR}/susfs/tools/ksu_susfs_arm" "${DEST_BIN_DIR}/ksu_susfs"
        cp "${TMPDIR}/susfs/tools/sus_su_arm" "${DEST_BIN_DIR}/sus_su"
        ;;
esac

# Set appropriate permissions
chmod 755 "${DEST_BIN_DIR}/ksu_susfs" "${DEST_BIN_DIR}/sus_su"
chmod 644 "${MODPATH}/post-fs-data.sh" "${MODPATH}/service.sh" "${MODPATH}/uninstall.sh"

# Cleanup unnecessary files
rm -rf "${MODPATH}/tools"
rm -f "${MODPATH}/customize.sh" "${MODPATH}/README.md"