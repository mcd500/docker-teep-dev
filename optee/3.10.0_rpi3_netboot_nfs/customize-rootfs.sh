#!/bin/bash -xue

USER_DIR=/home/user
ROOTFS_EXT_DIR=${USER_DIR}/arm64-20.04-rootfs

# Update lib cache for installed optee library
chroot ${ROOTFS_EXT_DIR} /bin/bash -c 'apt-get update'
chroot ${ROOTFS_EXT_DIR} /bin/bash -c 'apt-get install -y npm'
chroot ${ROOTFS_EXT_DIR} /bin/bash -c 'curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash'
chroot ${ROOTFS_EXT_DIR} /bin/bash -c 'source ~/.nvm/nvm.sh'
chroot ${ROOTFS_EXT_DIR} /bin/bash -c 'nvm install --lts'
chroot ${ROOTFS_EXT_DIR} /bin/bash -c 'nvm use --lts'

# Booting tee-supplicant on power
chroot ${ROOTFS_EXT_DIR} /bin/bash -c 'echo nameserver 8.8.8.8 > /etc/resolv.conf'

# Update rootfs tar file
cd ${USER_DIR}
tar -cJf arm64-20.04-rootfs-optee.tar.xz --exclude="dev,proc,sys" arm64-20.04-rootfs && sudo mv arm64-20.04-rootfs-optee.tar.xz /
