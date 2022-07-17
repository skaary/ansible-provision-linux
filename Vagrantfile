# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
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
    sudo apt-get install --no-install-recommends --no-install-suggests -y make
    sudo make deploy-init
    make deploy-virtualenv
    make deploy-import-roles
    # make deploy-tools PROFILE=#{ENV['PROFILE']}
    make deploy-tools
  SHELL
end