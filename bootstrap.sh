#!/bin/bash

# set -eu

# # Default profile to use
# # Overwrite via command line argument
# PROFILE="${1:-desktop_mint}"

# if ! command -v sudo >/dev/null 2>&1; then
# 	>&2 echo "This script requires 'sudo' binary to be installed"
# 	exit 1
# fi

# if [ "$(id -u)" -eq "0" ]; then
# 	>&2 echo "This script must be run as normal user"
# 	exit 1
# fi

# Variables
#profile=$1
profile=desktop_mint
arg=$2

###
### Download GitHub repository
###
git clone https://github.com/skaary/ansible-provision
cd ansible-provision


# Install necessary packages
sudo apt-get update -qq
sudo apt-get install -qq -q --no-install-recommends --no-install-suggests \
    python3 \
    python3.8 \
    python3-venv \
    python3-pip \
    git

# Set up the virtual python env
python3 -m venv .venv
. ./.venv/bin/activate 
python3 -m pip install -r requirements.txt

# Install the ansible roles into the roles/ directory
ansible-galaxy install -r roles/requirements.yml -p ./roles

# Install the ansible playbook
#ansible-playbook -i inventory playbook.yml --limit "$profile" --diff --ask-become-pass "$arg"
ansible-playbook -i inventory playbook.yml --limit "$profile" --diff --become

# function deploy-init {
#     apt-get update -qq
# 	apt-get install -qq -q --no-install-recommends --no-install-suggests \
# 		python3 \
# 		python3.8 \
# 		python3-venv \
# 		python3-pip \
# 		git
# }

# function deploy-virtualenv {
#     python3 -m venv .venv
# 	. ./.venv/bin/activate 
# 	python3 -m pip install -r requirements.txt
# }

# function deploy-import-roles {
#     ansible-galaxy install -r roles/requirements.yml -p ./roles
# }

# function deploy-tools {
#     ansible-playbook -i inventory playbook.yml --limit ${PROFILE} --diff --ask-become-pass $(ARG)
# }

# echo "Init"
# deploy-init
# echo "virtualenv"
# deploy-virtualenv
# echo "import roles"
# deploy-import-roles