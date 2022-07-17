#!/bin/bash

set -eu

# # Default profile to use
# # Overwrite via command line argument
PROFILE="${1:-desktop_mint}"

if ! command -v sudo >/dev/null 2>&1; then
	>&2 echo "This script requires 'sudo' binary to be installed"
	exit 1
fi

if [ "$(id -u)" -eq "0" ]; then
	>&2 echo "This script must be run as normal user"
	exit 1
fi


###
### Install requirements to use this repository
###
sudo DEBIAN_FRONTEND=noninteractive apt update -qq
sudo apt-get install --no-install-recommends --no-install-suggests -y \
	git \
	make

###
### Download GitHub repository
###
git clone https://github.com/skaary/ansible-provision-linux
cd ansible-provision-linux

# (Step 1/4) [requires root] Ensure required software is present
sudo make deploy-init

# (Step 2/4) Sets up the python virtual environment for good separation of the system and installs ansible among other required packages via pip
make deploy-virtualenv

# (Step 3/4) Install roles from the requirements file (imports roles from github or ansible galaxy)
make deploy-import-roles

# (Step 4/4) Deploy your system
make deploy-tools PROFILE=${PROFILE}