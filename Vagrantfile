# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

$domain = "auror.local"
$domain_ip_address = "10.10.11.9"
$machine_B_ip_address = "10.10.11.10"


Vagrant.configure("2") do |config|
  config.vm.define "dc" do |subconfig|

    subconfig.vm.provider "virtualbox" do |vb, override|
      vb.gui = true
      vb.customize ["modifyvm", :id, "--memory", 2048]
      vb.customize ["modifyvm", :id, "--cpus", 2]
      vb.customize ["modifyvm", :id, "--vram", "128"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end


    subconfig.vm.box = "gusztavvargadr/windows-server"
    subconfig.vm.hostname = "aurordc"

    subconfig.vm.communicator = "winrm"
    subconfig.winrm.transport = :plaintext
    subconfig.winrm.basic_auth_only = true

    subconfig.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
    subconfig.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", auto_correct: true
    subconfig.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true
    subconfig.vm.network :private_network, ip: $domain_ip_address 

    ## Domain Controller Provisioning
    subconfig.vm.provision :shell,  path: "scripts/provision_dc.ps1"
    subconfig.vm.provision "shell", reboot: true
    
  end

  config.vm.define "machineb" do |subconfig|
    subconfig.vm.provider "virtualbox" do |vb, override|
      vb.gui = true
      vb.customize ["modifyvm", :id, "--memory", 2048]
      vb.customize ["modifyvm", :id, "--cpus", 2]
      vb.customize ["modifyvm", :id, "--vram", "128"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end
    
    subconfig.vm.box = "gusztavvargadr/windows-server"
    subconfig.vm.hostname = "machineb"

    subconfig.vm.communicator = "winrm"
    subconfig.winrm.transport = :plaintext
    subconfig.winrm.basic_auth_only = true


    subconfig.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
    subconfig.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", auto_correct: true
    subconfig.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true
    subconfig.vm.network :private_network, ip: $machine_B_ip_address

    ## Machine B Provisioning
    subconfig.vm.provision :shell,  path: "scripts/provision_machine_b.ps1", args: "-domain_ip #{$domain_ip_address} -domain_name #{$domain}"
    subconfig.vm.provision :shell,  path: "scripts/install_chocolatey.ps1"
    subconfig.vm.provision :shell,  inline: "choco install -y googlechrome"
  end

end
