# -*- mode: ruby -*-
# vi: set ft=ruby :

# Specify Vagrant version and Vagrant API version
Vagrant.require_version ">= 1.6.0"
VAGRANTFILE_API_VERSION = "2"

# cf.: http://blog.scottlowe.org/2015/02/10/using-docker-with-vagrant/
# set docker as the default provider
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'

Vagrant.configure(2) do |config|

  config.vm.define "train.docker.dataguard"
  
  # Configure the Docker provider for Vagrant
  config.vm.provider "docker" do |d|
   
    # The standard boot2docker VM does not support synced folders on Windows.
		# So we use a customized one that sets off oel66
    d.vagrant_vagrantfile = "host/Vagrantfile"

    # Specify the Docker image to use
    #d.image = "breed85/oracle-12c"
    d.build_dir = "."    

    # Specify port mappings
    # If omitted, no ports are mapped!
    d.ports = ['1521:1521']

    # Specify a friendly name for the Docker container
    d.name = 'oracle12c-container'
  end
end