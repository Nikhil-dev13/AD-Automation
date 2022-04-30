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
    # Winrm configuration
    config.vm.communicator = "winrm"
    config.winrm.transport = :plaintext
    config.winrm.basic_auth_only = true

  config.vm.define "dc" do |subconfig|
    ## VirtualBox Configuration
    subconfig.vm.provider "virtualbox" do |vb, override|
      vb.gui = true
      vb.name = "MachineA-WINServer"
      vb.customize ["modifyvm", :id, "--memory", 2048]
      vb.customize ["modifyvm", :id, "--cpus", 2]
      vb.customize ["modifyvm", :id, "--vram", "58"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end

    # Box configuration
    subconfig.vm.box = "gusztavvargadr/windows-server"
    subconfig.vm.box_version = "2102.0.2204"
    # Network Configuration
    subconfig.vm.network :private_network, ip: $domain_ip_address 

    ## Domain Controller Provisioning
    subconfig.vm.provision :shell, path: "scripts/change_hostname.ps1", privileged: true, args: "-password vagrant -user vagrant -hostname aurordc"
    subconfig.vm.provision :shell, reboot: true
    subconfig.vm.provision :shell,  path: "scripts/provision_dc.ps1"
    subconfig.vm.provision "shell", reboot: true
    
  end

  config.vm.define "machineb" do |subconfig|

    ## Virtual Box Configuration
    subconfig.vm.provider "virtualbox" do |vb, override|
      vb.gui = true
      vb.name = "MachineB-WIN10"
      vb.customize ["modifyvm", :id, "--memory", 2048]
      vb.customize ["modifyvm", :id, "--cpus", 2]
      vb.customize ["modifyvm", :id, "--vram", "58"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end
    
    # Box Configuration
    subconfig.vm.box = "gusztavvargadr/windows-10"
    subconfig.vm.box_version = "2102.0.2204"

    # Network Configuration
    
    subconfig.vm.network :private_network, ip: $machine_B_ip_address


    ## Machine B Provisioning
    subconfig.vm.provision :shell,  path: "scripts/provision_machine_b.ps1", args: "-domain_ip #{$domain_ip_address} -domain_name #{$domain}"
    subconfig.vm.provision :shell, reboot: true
    subconfig.vm.provision :shell,  path: "scripts/install_chocolatey.ps1"
    subconfig.vm.provision :shell,  inline: "choco install -y googlechrome"
  end
end