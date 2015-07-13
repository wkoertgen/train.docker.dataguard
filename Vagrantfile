# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.6.0"
VAGRANTFILE_API_VERSION = "2"

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'

Vagrant.configure(2) do |config|

  config.vm.define "train.docker.dataguard"

  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider "docker" do |d|
    d.name = 'oracle12c-container'
    d.vagrant_vagrantfile = "host/Vagrantfile"

    d.image = "oraclelinux:7.1"
    d.volumes = [__dir__+"/install:/tmp"]
    d.create_args = ["-w", "/tmp"]
    d.cmd = ["/bin/bash", "-ci", "./setup.sh"]
    d.name = "oracle12c"
    d.ports = ['1521:1521']
  end
end