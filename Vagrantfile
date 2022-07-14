# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  #config.vm.box = "generic/ubuntu2010"
  config.vm.box = "skaary/LinuxMint20.3"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.customize ["modifyvm", :id, "--vram", "12"]
    vb.memory = "2048"
  end

config.vm.provision "file", source: ".", destination: "~/Desktop/vagrant"

config.vm.provision "shell", privileged: false, inline: <<-SHELL
  cd ~/Desktop/vagrant
  sudo apt-get update -qq
  # " sh bootstrap.sh desktop_mint"
  # "bootstrap.sh desktop_mint"
  # "/usr/bin/bash ~/Desktop/vagrant/bootstrap.sh"
    sudo apt-get install --no-install-recommends --no-install-suggests -y make
    sudo make deploy-init
    make deploy-virtualenv
    make deploy-import-roles
    # make deploy-tools PROFILE=#{ENV['PROFILE']}
    make deploy-tools
  SHELL
end

#   config.vm.provision "shell", inline: <<-SHELL
#     apt-get update
#     apt-get install -y python-is-python3 ansible git
#     # ansible-galaxy install -r requirements.yml -p roles
#   SHELL

#   # config.vm.provision "file", source: "~/Software/development/ansible/ubuntu", destination: "/tmp/provisioning"
#   config.vm.synced_folder ".", "/tmp/provisioning"
#   # config.vm.provision "file", source: "~/dotfiles", destination: "/home/vagrant/dotfiles"
#   # config.vm.provision "file", source: "~/Documents/backup/desktop", destination: "/home/vagrant/backup"
#   config.vm.synced_folder "~/Software/development/ansible/roles", "/tmp/roles"

#   # config.vm.provision "ansible_local" do |ansible|
#   #   ansible.extra_vars = { ansible_ssh_user: 'vagrant', vagrant: true, user: 'vagrant', user_home: '/home/vagrant'}
#   #   ansible.become = false
#   #   ansible.playbook = "playbook.yml"
#   #   ansible.provisioning_path = "/tmp/provisioning"
#   #   ansible.inventory_path = "/tmp/provisioning/inventory"
#   #   # ansible.inventory_path = "inventory"
#   #   # ansible.limit = '127.0.0.1'
#   #   ansible.limit = 'desktop'
#   #   ansible.verbose = false

#   # end

# end