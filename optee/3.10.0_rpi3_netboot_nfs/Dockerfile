FROM aistcpsec/tee-dev:optee-3.10.0_rpi3_netboot_nfs as optee_rootfs_tar

#######################################################################
FROM aistcpsec/taref-dev:optee AS build
# TO trasioteam/teep-dev:optee


###############################
###  CLONE TEEP-DEVICE    #####
###############################
# Make sure the following command run as build-user
USER build-user

# For fetching teep-device.git
ARG CI_JOB_TOKEN=
RUN git config --global user.name gitlab-ci-token
RUN git config --global http.sslVerify false
RUN git config --global credential.helper 'store --file ~/.git-credentials'
RUN echo https://gitlab-ci-token:${CI_JOB_TOKEN}@192.168.100.100:443 >> ~/.git-credentials
RUN echo https://gitlab-ci-token:${CI_JOB_TOKEN}@192.168.100.100 >> ~/.git-credentials


# Set TEEP_DEV_DIR dir
ENV TEEP_DEV_DIR=${USER_DIR}/teep-device

# Set the work directory
WORKDIR $USER_DIR

# Clone the teep-device and the given branch
ARG BRANCH=
RUN git clone https://gitlab-ci-token:${CI_JOB_TOKEN}@192.168.100.100/rinkai/teep-device.git
WORKDIR $TEEP_DEV_DIR
RUN git checkout ${BRANCH}
RUN git submodule sync --recursive && git submodule update --init --recursive

# Set the workdir
WORKDIR $TEEP_DEV_DIR

# Must provide the IP address of tamproto before the make
ARG TAMIP=
ENV TAM_URL="http://$TAMIP:8888"

# Build the teep device
RUN make

###############################
###  CLONE TAMPROTO    #####
###############################

# Set the work directory
WORKDIR $USER_DIR

# Set TAMPROTO_DIR dir
ENV TAMPROTO_DIR=${USER_DIR}/tamproto

# Clone the tamproto and checkout the given branch
RUN git clone https://gitlab-ci-token:${CI_JOB_TOKEN}@192.168.100.100/rinkai/tamproto.git
WORKDIR $TAMPROTO_DIR
# Temporary roll back to old tamproto, since teep-device is behind supporting
# new cipher suite
RUN git checkout fb1961bc964857384c9ed8696c0d5fc0a76a319d

# By this time, we have tamproto, ta-ref and teep-device inside /home/user directory
# Lets perform the rootfs operation

# Set the work directory
WORKDIR $USER_DIR

# Create a rootfs extraction directory to extract and zip it again
ENV ROOTFS_EXT_DIR=${USER_DIR}/arm64-20.04-rootfs

# Copy the Rootfs tar file from the builder
COPY --from=optee_rootfs_tar /arm64-20.04-rootfs-optee.tar.xz ${USER_DIR}/

# Unzip the tar file to the rootfs extension directory
RUN sudo tar -xf arm64-20.04-rootfs-optee.tar.xz -C ${USER_DIR}

# Removed the existing tar file
RUN rm -rf arm64-20.04-rootfs-optee.tar.xz

# Copy ta-ref, teep-device and tamproto into root directory
RUN sudo mkdir -p ${ROOTFS_EXT_DIR}/root/teep-device && \
	sudo mkdir -p ${ROOTFS_EXT_DIR}/root/ta-ref && \
	sudo mkdir -p ${ROOTFS_EXT_DIR}/root/tamproto

# Copy ta-ref, teep-device and tamproto to rootfs
RUN sudo cp -r ${USER_DIR}/tamproto ${ROOTFS_EXT_DIR}/root/tamproto && \
	sudo cp -r ${USER_DIR}/ta-ref ${ROOTFS_EXT_DIR}/root/ta-ref && \
    sudo cp -r ${USER_DIR}/teep-device ${ROOTFS_EXT_DIR}/root/teep-device

# Create a new tar file and move to root directory
RUN sudo tar -cJf arm64-20.04-rootfs-teep-device.tar.xz --exclude="dev,proc,sys" \
	arm64-20.04-rootfs && sudo mv arm64-20.04-rootfs-teep-device.tar.xz /
