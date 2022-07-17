DIR = .
FILE = Dockerfile
IMAGE = skaary/ansible-ubuntu
TAG = latest

# Ansible variables
VERBOSE=
PROFILE=desktop_mint
ARG=
# ROLE=

# Phony
.PHONY: help test-vagrant deploy-init deploy-virtualenv deploy-import-roles deploy-tools diff-tools

#--------------------------------------------------------------------------------------------------
# Help
#--------------------------------------------------------------------------------------------------

help:
	@echo "################################################################################"
	@echo "#                                                                              #"
	@echo "#    Linux Mint / Ubuntu provisioning with Ansible                                          #"
	@echo "#                                                                              #"
	@echo "################################################################################"
	@echo
	@echo
	@echo "------------------------------------------------------------"
	@echo " Run tests in Docker"
	@echo "------------------------------------------------------------"
	@echo
	@echo "build-docker                 Build the testing Docker image (happens automatically during tests)"
	@echo
	@echo "test-docker-docker-full      Run a full test in a Docker (requires PROFILE)"
	@echo "test-docker-docker-random    Run a full randomized test in a Docker (requires PROFILE)"
	@echo "test-docker-docker-single    Run the test on a single role in a Docker (requires PROFILE and ROLE)"
	@echo
	@echo "itest-docker-docker-full     Interactive version of test-docker-full (requires PROFILE)"
	@echo "itest-docker-docker-random   Interactive version of test-docker-random (requires PROFILE)"
	@echo "itest-docker-docker-single   Interactive version of test-docker-single (requires PROFILE and ROLE)"
	@echo
	@echo
	@echo "------------------------------------------------------------"
	@echo " Run tests in Vagrant"
	@echo "------------------------------------------------------------"
	@echo
	@echo "test-vagrant					Test your profile with Vagrant"
	@echo
	@echo "------------------------------------------------------------"
	@echo " Deploy your host system"
	@echo "------------------------------------------------------------"
	@echo
	@echo "deploy-init"
	@echo
	@echo "deploy-virtualenv"
	@echo
	@echo "deploy-import-roles"
	@echo
	@echo "deploy-tools"
	@echo
	@echo "diff-tools"
	@echo
#--------------------------------------------------------------------------------------------------
# Tests with Docker
#--------------------------------------------------------------------------------------------------

build-docker:
	docker image build -t $(IMAGE) -f $(DIR)/$(FILE) $(DIR)

# Automated tests
test-docker-full: build-docker
	docker run --rm -e MY_HOST=$(PROFILE) -e verbose=$(VERBOSE) -t $(IMAGE)

test-docker-random: build-docker
	docker run --rm -e MY_HOST=$(PROFILE) -e verbose=$(VERBOSE) -e random=1 -t $(IMAGE)

test-docker-single: build-docker
	docker run --rm -e MY_HOST=$(PROFILE) -e verbose=$(VERBOSE) -e tag=$(ROLE) -t $(IMAGE)

# # Interactive tests
# # Inside the container execute the following command: ./run-tests.sh
itest-docker-full: build-docker
	docker run -it --rm --entrypoint=bash -e MY_HOST=$(PROFILE) -e verbose=$(VERBOSE) -t $(IMAGE)

itest-docker-random: build-docker
	docker run -it --rm --entrypoint=bash -e MY_HOST=$(PROFILE) -e verbose=$(VERBOSE) -e random=1 -t $(IMAGE)

itest-docker-single: build-docker
	docker run -it --rm --entrypoint=bash -e MY_HOST=$(PROFILE) -e verbose=$(VERBOSE) -e tag=$(ROLE) -t $(IMAGE)

#--------------------------------------------------------------------------------------------------
# Tests with Vagrant
#--------------------------------------------------------------------------------------------------

# Test your profile with Vagrant
test-vagrant:
	PROFILE=$(PROFILE) vagrant up --provision

#--------------------------------------------------------------------------------------------------
# Deploy Targets
#--------------------------------------------------------------------------------------------------

# (Step 1/4) [requires root] Ensure required software is present
deploy-init:
ifneq ($(USER),root)
	$(error Target 'deploy-init' must be run as root or with sudo)
endif
	apt-get update -qq
	apt-get install -qq -q --no-install-recommends --no-install-suggests \
		python3 \
		python3-venv \
		python3-pip \
		git

# (Step 2/4) Sets up the python virtual environment for good separation of the system and installs ansible among other required packages via pip
deploy-virtualenv:
ifeq ($(USER),root)
	$(error Target 'deploy-virtualenv' must be run as normal user without sudo)
endif
	python3 -m venv .venv
#	. ./.venv/bin/activate 
#	python3 -m pip install -r requirements.txt
	.venv/bin/pip install -r requirements.txt 

# (Step 3/4) Install roles from the requiremetns file (imports roles from github or ansible galaxy)
deploy-import-roles:
ifeq ($(USER),root)
	$(error Target 'deploy-import-roles' must be run as normal user without sudo)
endif
	.venv/bin/ansible-galaxy install -r roles/requirements.yml -p ./roles

# (Step 4/4) Deploy your system
deploy-tools:
ifeq ($(USER),root)
	$(error Target 'deploy-tools' must be run as normal user without sudo)
endif
ifndef ROLE
	.venv/bin/ansible-playbook -i inventory playbook.yml --limit ${PROFILE} --diff --ask-become-pass $(ARG)
else
	.venv/bin/ansible-playbook -i inventory playbook.yml --limit ${PROFILE} --diff --ask-become-pass $(ARG) -t $(ROLE)
endif

# Checkmode to test against currently installed tools
diff-tools:
ifeq ($(USER),root)
	$(error Target 'diff-tools' must be run as normal user without sudo)
endif
ifndef ROLE
	.venv/bin/ansible-playbook -i inventory playbook.yml --limit ${PROFILE} --diff --check --ask-become-pass $(ARG)
else
	.venv/bin/ansible-playbook -i inventory playbook.yml --limit ${PROFILE} --diff --check --ask-become-pass $(ARG) -t $(ROLE)
endif
