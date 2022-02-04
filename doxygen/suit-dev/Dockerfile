FROM trasioteam/taref-dev:doxygen AS build
# TO trasioteam/teep-dev:doxygen

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
RUN git submodule sync --recursive && git submodule update --init --recursive

# Set the workdir
WORKDIR $TEEP_DEV_DIR

# Build the teep device document
RUN make docs
