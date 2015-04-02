# -*- mode: ruby -*-
# vi: set ft=ruby :

app = ENV["APP"] || "ginger"
debug = ENV["DEBUG"] || false
zotonic_source = ENV["ZOTONIC_SOURCE"]
zotonic_version = ENV["ZOTONIC_VERSION"]
puppet_node = app + ENV['USER'] + ".dev"
puppet_master = "puppet.driebit.net"

VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.5.1"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "driebit/debian-7-x86_64"
  config.vm.hostname = app + ".dev"

  config.vm.network :private_network, ip: "192.168.33.10"
  config.vm.network "forwarded_port", guest: 8000, host: 8000
  config.vm.network "forwarded_port", guest: 35729, host: 35729

  config.vm.provider "virtualbox" do |v|
    v.memory = 1536
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  if Vagrant::Util::Platform.windows?
    config.vm.synced_folder ".", "/vagrant"
  else
    config.vm.synced_folder ".", "/vagrant", type: "nfs", mount_options: ["actimeo=1"]
  end

  # Remove old certificates
  config.vm.provision "shell", inline: 'curl --silent -k -X PUT -H "Content-Type: text/pson" --data "{\"desired_state\":\"revoked\"}" ' +
    'https://' + puppet_master + ':8140/production/certificate_status/' + puppet_node + ' && ' +
    'curl --silent -k -X DELETE -H "Accept: pson" https://' + puppet_master + ':8140/production/certificate_status/' + puppet_node

  config.vm.provision "puppet_server" do |puppet|
    puppet.puppet_server = puppet_master
    puppet.puppet_node   = puppet_node

    puppet.options << ' --environment production --test'
    puppet.facter = {
        "zotonic_source"  => zotonic_source,
        "zotonic_version"     => zotonic_version
    }

    if debug
      puppet.options << ' --debug --verbose'
    end
  end
end
