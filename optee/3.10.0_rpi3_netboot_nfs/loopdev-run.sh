#! /bin/bash
if test $# -lt 2
then
    echo "usage: $0 IMAGE_FILE SETUP_SCRIPT [ARGS...]" 1>&2
    exit 1
fi
IMAGE_FILE="$1"
shift

set -e

# Acquire loop device while signals disabled
trap '' 1 2 3 15
export LOOPDEV=$(sudo losetup --show -P -f "$IMAGE_FILE")
test -b "$LOOPDEV"
echo "Running on loop device: $LOOPDEV" 1>&2

# Release loop device when interrupted
trap 'sync; sudo losetup -d '"$LOOPDEV"'; exit 1' 1 2 3 15

# Run command with `LOOPDEV' variable exported
"$@"

# Release loop device while signals disabled
trap '' 1 2 3 15
sync
sudo losetup -d "$LOOPDEV"

# Exit (restoring default trap handler)
trap 1
trap 2
trap 3
trap 15
exit 0
