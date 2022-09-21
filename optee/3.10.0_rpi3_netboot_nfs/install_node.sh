#!/bin/bash -xue

# Install nvm
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

# Source the nvm scripts
source $HOME/.nvm/nvm.sh

#install NVM and set the latest version
nvm install --lts && nvm use --lts
