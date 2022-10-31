#! /bin/bash
set -e

BOOTLOADER_BIN="$1"
ROOTFS_BIN="$2"

cat "$BOOTLOADER_BIN" | sudo tee "$LOOPDEV"p1 > /dev/null
