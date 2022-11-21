#!/bin/sh

# Change the IP address in the resolv.conf
# This step is not required if DNS server is working properly in RPI3
sed -i -e 's/127.0.0.53/192.168.100.1/g' /etc/resolv.conf 

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
