FROM aistcpsec/tee-dev:optee-3.10.0_rpi3_netboot_nfs as optee_rootfs_tar

#######################################################################
FROM aistcpsec/teep-dev:optee-tftp AS build
# TO aistcpsec/teep-dev:rootfs_teep-device_rpi3_netboot_nfs


###############################
###  TEEP-DEVICE    #####
###############################
# Make sure the following command run as build-user
USER build-user

# Do not have to copy teep-device since it is in aistcpsec/teep-dev:optee

###############################
###  CLONE TAMPROTO    #####
###############################

# Set the work directory
WORKDIR $USER_DIR

# Adding credential for git clone
ARG CI_JOB_TOKEN=
RUN git config --global user.name gitlab-ci-token
RUN git config --global http.sslVerify false
RUN git config --global credential.helper 'store --file ~/.git-credentials'
RUN echo https://gitlab-ci-token:${CI_JOB_TOKEN}@192.168.100.100:443 >> ~/.git-credentials
RUN echo https://gitlab-ci-token:${CI_JOB_TOKEN}@192.168.100.100 >> ~/.git-credentials

# Set TAMPROTO_DIR dir
ENV TAMPROTO_DIR=${USER_DIR}/tamproto

# Clone the tamproto and checkout the given branch
RUN git clone https://gitlab-ci-token:${CI_JOB_TOKEN}@192.168.100.100/rinkai/tamproto.git
WORKDIR $TAMPROTO_DIR
# Temporary roll back to old tamproto, since teep-device is behind supporting
# new cipher suite
RUN git checkout fb1961bc964857384c9ed8696c0d5fc0a76a319d


# Set the work directory
WORKDIR $USER_DIR

# Create a rootfs extraction directory to extract and zip it again
ENV ROOTFS_EXT_DIR=${USER_DIR}/arm64-20.04-rootfs

# Copy the Rootfs tar file from the builder
COPY --from=optee_rootfs_tar /arm64-20.04-rootfs-optee.tar.xz ${USER_DIR}/

USER root

# Unzip the tar file to the rootfs extension directory
RUN tar -xf arm64-20.04-rootfs-optee.tar.xz -C ${USER_DIR}

# Removed the existing tar file
RUN rm -rf arm64-20.04-rootfs-optee.tar.xz

# Create /home/user directory inside rootfs 
RUN mkdir -p ${ROOTFS_EXT_DIR}/${USER_DIR}

# Copy ta-ref, teep-device and tamproto to rootfs
RUN cp -r ${USER_DIR}/tamproto ${ROOTFS_EXT_DIR}/${USER_DIR} && \
	cp -r ${USER_DIR}/ta-ref ${ROOTFS_EXT_DIR}/${USER_DIR} && \
    cp -r ${USER_DIR}/teep-device ${ROOTFS_EXT_DIR}/${USER_DIR}

# Copy the TA files into lib/optee_armtz
ENV OPTEE_BUILD_DIR=${ROOTFS_EXT_DIR}/${USER_DIR}/teep-device/build/optee
ENV TEEP_AGENT_TA=68373894-5bb3-403c-9eec-3114a1f5d3fc.ta
ENV HELLO_TEEP_TA=8d82573a-926d-4754-9353-32dc29997f74.ta
RUN cp ${OPTEE_BUILD_DIR}/agent/${TEEP_AGENT_TA} ${ROOTFS_EXT_DIR}/lib/optee_armtz/ && \
	cp ${OPTEE_BUILD_DIR}/hello-tc/${HELLO_TEEP_TA} ${ROOTFS_EXT_DIR}/lib/optee_armtz/

# Move the teep-broker-app directory to home folder
# Copy the teep-broker-app executable and get-ip.sh to the copied teep-broker-app folder
ENV TEEP_BROKER_DIR=teep-broker
RUN cp -r ${OPTEE_BUILD_DIR}/rootfs-ext/root/${TEEP_BROKER_DIR} ${ROOTFS_EXT_DIR}/${USER_DIR} && \
    cp ${OPTEE_BUILD_DIR}/broker/teep-broker-app ${ROOTFS_EXT_DIR}/${USER_DIR}/${TEEP_BROKER_DIR} && \
    cp ${OPTEE_BUILD_DIR}/scripts/get-ip.sh ${ROOTFS_EXT_DIR}/${USER_DIR}/${TEEP_BROKER_DIR} && \
    cp ${OPTEE_BUILD_DIR}/scripts/cp_ta_to_tamproto.sh ${ROOTFS_EXT_DIR}/${USER_DIR}/${TEEP_BROKER_DIR}


# Copy the install_node.sh file into home directory
COPY install_node.sh ${ROOTFS_EXT_DIR}/${USER_DIR}
RUN chmod a+x ${ROOTFS_EXT_DIR}/${USER_DIR}/install_node.sh

# # Create a new tar file and move to root directory
# RUN tar -cJf arm64-20.04-rootfs-teep-device.tar.xz --exclude="dev,proc,sys" \
# 	arm64-20.04-rootfs && mv arm64-20.04-rootfs-teep-device.tar.xz /
