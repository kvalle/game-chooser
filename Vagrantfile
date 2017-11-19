# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.hostname = "gamy"

  config.vm.provision "shell", inline: <<-SCRIPT
    sudo apt-get update
    sudo apt-get install inotify-tools -y
    sudo apt-get install python -y
    sudo apt-get install python-setuptools -y
    sudo easy_install pip
    sudo pip install virtualenv
SCRIPT
  config.vm.network "forwarded_port", guest: 7777, host: 7777
  config.vm.synced_folder "", "/home/ubuntu/gamy"
end
