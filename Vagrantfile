# -*- mode: ruby -*-
# vi: set ft=ruby :

app = ENV["APP"] || "ginger"
debug = ENV["DEBUG"] || false
puppet_node = app + ENV['USER'] + ".dev"
puppet_master = "puppet.driebit.net"

VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.5.1"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "driebit/debian-7-x86_64"
  config.vm.hostname = app + ".dev"

  config.vm.network :private_network, ip: "192.168.33.10"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 35729, host: 35729

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

    puppet.options << ' --environment production'

    if debug
      puppet.options << ' --debug --verbose'
    end
  end
end
