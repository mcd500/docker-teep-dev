FROM trasioteam/taref-dev:keystone AS build
# TO trasioteam/teep-dev:keystone

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

# Clone the ta-ref and the given branch
ARG BRANCH=
RUN git clone https://gitlab-ci-token:${CI_JOB_TOKEN}@192.168.100.100/rinkai/teep-device.git
WORKDIR $TEEP_DEV_DIR
RUN git checkout ${BRANCH}
RUN git submodule sync --recursive && \
    git submodule update --init --recursive

# Set the workdir
WORKDIR $TEEP_DEV_DIR

ARG TAMIP=
ENV TAM_URL="http://$TAMIP:8888"

# Build the teep device
RUN make

# Run the teep device and talk to tamproto
# This step needs tamproto to be executed
SHELL ["/bin/bash", "-c"]
RUN set -eu -o pipefail; make run-sample-session | tr -d "\r"

