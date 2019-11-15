#!/bin/bash
echo
echo "✅  Installing Dependencies"
echo
# run update
sudo apt-get update

# install build dependencies
sudo apt-get install -y git python gcc g++ make libx11-dev libxkbfile-dev fakeroot rpm libsecret-1-dev python2.7-dev python-pip python-setuptools jq curl libudev-dev

# install Node.JS - version >= 10.15.1, < 11.0.0
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs

# install requirements
pip install -r requirements.txt
