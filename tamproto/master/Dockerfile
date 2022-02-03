# Copyright (c) 2020 SECOM CO., LTD. All Rights reserved.
# SPDX-License-Identifier: BSD-2-Clause
FROM node:10.18-alpine AS build
# TO trasioteam/teep-dev:tamproto

# For fetching teep-device.git
ARG CI_JOB_TOKEN=
RUN git config --global user.name gitlab-ci-token
RUN git config --global http.sslVerify false
RUN git config --global credential.helper 'store --file ~/.git-credentials'
RUN echo https://gitlab-ci-token:${CI_JOB_TOKEN}@192.168.100.100:443 >> ~/.git-credentials
RUN echo https://gitlab-ci-token:${CI_JOB_TOKEN}@192.168.100.100 >> ~/.git-credentials

# Set TAMPROTO_DIR dir
ENV TAMPROTO_DIR=tamproto

# Clone the ta-ref and the given branch
ARG BRANCH=
RUN git clone https://gitlab-ci-token:${CI_JOB_TOKEN}@192.168.100.100/rinkai/tamproto.git
WORKDIR $TAMPROTO_DIR
RUN git checkout ${BRANCH}

######################################################
# Perform the steps as per tamproto dockerfile below #
######################################################

WORKDIR /usr/src/app

ARG NODE_ENV
ENV NODE_ENV $NODE_ENV

COPY package.json /usr/src/app/
RUN apk add --no-cache --virtual .gyp python make g++ \
    && apk --no-cache add avahi-dev \
    && npm install \
    && apk del .gyp

COPY . /usr/src/app

ENV PORT 8888
EXPOSE $PORT
CMD [ "node", "app.js" ]
