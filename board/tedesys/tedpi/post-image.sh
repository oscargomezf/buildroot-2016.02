#!/bin/sh

BOARD_DIR="$(dirname $0)"
case "${2}" in
	"tedpi-cm")
		BOARD_NAME="tedpi-cm"
		;;
	"tedpi-1b")
		BOARD_NAME="tedpi-1b"
		;;
	"tedpi-2b"|"tedpi-2b-flea3")
		BOARD_NAME="tedpi-2b"
		;;
	"tedpi-3b"|"tedpi-3b-flea3")
		BOARD_NAME="tedpi-3b"
		;;
	*)
		exit 1
		;;
esac
GENIMAGE_CFG="${BOARD_DIR}/genimage-${BOARD_NAME}.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

# Mark the kernel as DT-enabled
mkdir -p "${BINARIES_DIR}/kernel-marked"
${HOST_DIR}/usr/bin/mkknlimg "${BINARIES_DIR}/zImage" \
	"${BINARIES_DIR}/kernel-marked/zImage"

rm -rf "${GENIMAGE_TMP}"

genimage                           \
	--rootpath "${TARGET_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

exit $?
