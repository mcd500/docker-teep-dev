#!/bin/bash -xue

USER_DIR=/home/user
ROOTFS_EXT_DIR=${USER_DIR}/arm64-20.04-rootfs

# Start the service to enable network
# Must be before and network access
cp /mnt/20-wired.network ${ROOTFS_EXT_DIR}/etc/systemd/network/
chmod 644 ${ROOTFS_EXT_DIR}/etc/systemd/network/20-wired.network

chroot ${ROOTFS_EXT_DIR} /bin/bash -c 'systemctl enable systemd-networkd'
# chroot ${ROOTFS_EXT_DIR} /bin/bash -c 'echo nameserver 8.8.8.8 >  ${ROOTFS_EXT_DIR}/etc/resolv.conf' && 'chattr +i ${ROOTFS_EXT_DIR}/etc/resolv.conf'

# Update rootfs tar file
cd ${USER_DIR}
tar -cJf arm64-20.04-rootfs-teep-device.tar.xz --exclude="dev,proc,sys" arm64-20.04-rootfs && sudo mv arm64-20.04-rootfs-teep-device.tar.xz /
