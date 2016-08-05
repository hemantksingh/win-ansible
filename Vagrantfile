# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  config.vm.define "control" do |ctl|
  	ctl.vm.box = "ubuntu/trusty64"
  	ctl.vm.hostname = "ubuntu-control"
  	ctl.vm.network "private_network", ip: "192.168.57.2"
  	ctl.vm.provider "virtualbox" do |vb|
  		vb.memory = 1024
  	end
    ctl.vm.provision:shell, :inline =>
      "apt-get install software-properties-common &&
      apt-add-repository ppa:ansible/ansible &&
      apt-get update &&
      apt-get --ignore-missing -y install tree ansible sshpass &&
      easy_install pip &&
      pip install http://github.com/diyan/pywinrm/archive/master.zip#egg=pywinrm"
  end

  config.vm.define "winserver" do |ws|
  	ws.vm.box = "jptoto/Windows2012R2"
  	ws.vm.hostname = "windows-webserver"
  	ws.vm.communicator = "winrm"
  	ws.winrm.username = "vagrant"
  	ws.winrm.password = "vagrant"
  	ws.vm.network "private_network", ip: "192.168.57.3"
  	ws.vm.provider "virtualbox" do |vb|
  		vb.memory = 2048
  		vb.cpus = 2
  	end
  end

end
