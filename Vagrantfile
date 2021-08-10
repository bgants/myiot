# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Every Vagrant development environment requires a box. 
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "hashicorp/bionic64"

  # Disable automatic box update checking. 
  config.vm.box_check_update = false

  config.vm.provider "virtualbox" do |vb|
     vb.gui = false
     vb.memory = "24576"
     vb.cpus = 2
  end

  config.vm.synced_folder ".", "/projects", type: "virtualbox"

  config.vm.hostname = "default"
  config.vm.network "private_network", ip: "192.168.10.109"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  config.vm.network "forwarded_port", guest: 8080, host: 8080, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 8085, host: 8085, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 80, host: 80, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 8161, host: 8161, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 61616, host: 61616, host_ip: "127.0.0.1"

  config.vm.provision "shell", privileged: true, inline: "/projects/vagrant/provision.sh"
end
