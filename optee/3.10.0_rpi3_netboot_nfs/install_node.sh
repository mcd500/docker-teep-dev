#!/bin/sh

# Install nvm, Source the nvm scripts and set nvm latest version
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

# Source the nvm file and install the latest nvm
. $HOME/.nvm/nvm.sh

# Install node and npm
nvm install --lts 

# Use the node and npm latest version
nvm use --lts

exec bash
# Source it
. ~/.bashrc
