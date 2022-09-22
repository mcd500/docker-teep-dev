#!/bin/bash -xue

# Install nvm, Source the nvm scripts and set nvm latest version
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash && source $HOME/.nvm/nvm.sh && nvm install --lts && nvm use --lts
