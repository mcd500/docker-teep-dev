#!/bin/bash -xue

# Update repository and install npm
sudo apt-get update && sudo apt-get install -y npm

# Install nvm
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
