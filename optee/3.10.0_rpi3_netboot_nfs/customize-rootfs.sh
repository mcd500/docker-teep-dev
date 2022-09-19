#!/bin/bash -xue

USER_DIR=/home/user
ROOTFS_EXT_DIR=${USER_DIR}/arm64-20.04-rootfs

# Start the service to enable network
# Must be before and network access
cp /mnt/20-wired.network ${ROOTFS_EXT_DIR}/etc/systemd/network/
chmod 644 ${ROOTFS_EXT_DIR}/etc/systemd/network/20-wired.network

chroot ${ROOTFS_EXT_DIR} /bin/bash -c 'systemctl enable systemd-networkd'
# chroot ${ROOTFS_EXT_DIR} /bin/bash -c 'echo nameserver 8.8.8.8 > /etc/resolv.conf'

# Tamproto requires newer npm and nodejs
# chroot ${ROOTFS_EXT_DIR} /bin/bash -c 'apt-get update && apt-get install -y npm'
chroot ${ROOTFS_EXT_DIR} /bin/bash -c 'apt-get update && curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash'
chroot ${ROOTFS_EXT_DIR} /bin/bash -c 'source $HOME/.nvm/nvm.sh && nvm install --lts && nvm use --lts'
# chroot ${ROOTFS_EXT_DIR} /bin/bash -c 'nvm install --lts'
# chroot ${ROOTFS_EXT_DIR} /bin/bash -c 'nvm use --lts'

# Update rootfs tar file
cd ${USER_DIR}
tar -cJf arm64-20.04-rootfs-optee.tar.xz --exclude="dev,proc,sys" arm64-20.04-rootfs && sudo mv arm64-20.04-rootfs-optee.tar.xz /
