#!/system/bin/sh

## Clone permissions from one file/directory to another
## Usage: susfs_clone_perm <file/or/dir/to/change> <file/or/dir/to/clone/from>
susfs_clone_perm() {
    TO=$1
    FROM=$2
    if [ -z "${TO}" ] || [ -z "${FROM}" ]; then
        return
    fi
    CLONED_PERM_STRING=$(stat -c "%a %U %G %C" ${FROM})
    set ${CLONED_PERM_STRING}
    chmod $1 ${TO}
    chown $2:$3 ${TO}
    chcon $4 ${TO}
}

## Hexpatch properties
## Usage: susfs_hexpatch_props <target_prop_name> <spoofed_prop_name> <spoofed_prop_value>
susfs_hexpatch_props() {
    TARGET_PROP_NAME=$1
    SPOOFED_PROP_NAME=$2
    SPOOFED_PROP_VALUE=$3
    if [ -z "${TARGET_PROP_NAME}" ] || [ -z "${SPOOFED_PROP_NAME}" ] || [ -z "${SPOOFED_PROP_VALUE}" ]; then
        return 1
    fi
    if [ "${#TARGET_PROP_NAME}" != "${#SPOOFED_PROP_NAME}" ]; then
        return 1
    fi
    resetprop -n ${TARGET_PROP_NAME} ${SPOOFED_PROP_VALUE}
    magiskboot hexpatch \
        /dev/__properties__/$(resetprop -Z ${TARGET_PROP_NAME}) \
        $(echo -n ${TARGET_PROP_NAME} | xxd -p | tr "[:lower:]" "[:upper:]") \
        $(echo -n ${SPOOFED_PROP_NAME} | xxd -p | tr "[:lower:]" "[:upper:]")
}

## Check and reset property if necessary
## Usage: check_reset_prop <prop_name> <expected_value>
check_reset_prop() {
    local NAME=$1
    local EXPECTED=$2
    local VALUE=$(resetprop $NAME)
    [ -z "$VALUE" ] || [ "$VALUE" = "$EXPECTED" ] || resetprop $NAME $EXPECTED
}

## Reset property if it contains a specific value
## Usage: contains_reset_prop <prop_name> <contains_value> <new_value>
contains_reset_prop() {
    local NAME=$1
    local CONTAINS=$2
    local NEWVAL=$3
    [[ "$(resetprop $NAME)" == *"$CONTAINS"* ]] && resetprop $NAME $NEWVAL
}