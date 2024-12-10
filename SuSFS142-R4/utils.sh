#!/system/bin/sh

## Clone permissions from one file or directory to another
susfs_clone_perm() {
	TO=$1
	FROM=$2
	if [ -z "$TO" ] || [ -z "$FROM" ]; then
		return
	fi
	# Retrieve permissions, owner, group, and SELinux context from the source
	CLONED_PERM_STRING=$(stat -c "%a %U %G %C" "$FROM")
	set -- $CLONED_PERM_STRING
	chmod "$1" "$TO"
	chown "$2:$3" "$TO"
	chcon "$4" "$TO"
}

## Patch properties using hex values
susfs_hexpatch_props() {
	TARGET_PROP_NAME=$1
	SPOOFED_PROP_NAME=$2
	SPOOFED_PROP_VALUE=$3
	if [ -z "$TARGET_PROP_NAME" ] || [ -z "$SPOOFED_PROP_NAME" ] || [ -z "$SPOOFED_PROP_VALUE" ]; then
		return 1
	fi
	if [ "${#TARGET_PROP_NAME}" -ne "${#SPOOFED_PROP_NAME}" ]; then
		return 1
	fi
	# Update property value
	resetprop -n "$TARGET_PROP_NAME" "$SPOOFED_PROP_VALUE"
	# Hex patch property name
	magiskboot hexpatch "/dev/__properties__/$(resetprop -Z "$TARGET_PROP_NAME")" \
		"$(echo -n "$TARGET_PROP_NAME" | xxd -p | tr '[:lower:]' '[:upper:]')" \
		"$(echo -n "$SPOOFED_PROP_NAME" | xxd -p | tr '[:lower:]' '[:upper:]')"
}

## Check if a property value matches, reset if not
check_reset_prop() {
	NAME=$1
	EXPECTED=$2
	VALUE=$(resetprop "$NAME")
	if [ -n "$VALUE" ] && [ "$VALUE" != "$EXPECTED" ]; then
		resetprop "$NAME" "$EXPECTED"
	fi
}

## Check if a property value contains a specific string, and replace it if true
contains_reset_prop() {
	NAME=$1
	CONTAINS=$2
	NEWVAL=$3
	VALUE=$(resetprop "$NAME")
	if [[ "$VALUE" == *"$CONTAINS"* ]]; then
		resetprop "$NAME" "$NEWVAL"
	fi
}