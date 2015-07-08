# train.docker.dataguard
An experiment on building a docker image for an Oracle Standby Database using Vagrant & Docker.

## Prerequisites

You should have installed

- [Vagrant](https://www.vagrantup.com/)
- [Docker](https://www.docker.com/)

If you are on Windows or want to use a proxy VM for the Docker host, additionally have [VirtualBox](https://www.virtualbox.org/) installed

### Oracle 12cR1

- Download [Database Install files (1 and 2)](http://www.oracle.com/technetwork/database/enterprise-edition/downloads/database12c-linux-download-1959253.html)
    - `linuxamd64_12102_database_1of2.zip` (1.5G)
    - `linuxamd64_12102_database_2of2.zip` (967.5M)
- Place the zip archives in directory `./install/`

## How to build

1. Start a local http server in `./install` for the downloaded Oracle installation archives, e.g. using [Python](http://stackoverflow.com/questions/26692708/how-to-add-a-file-to-an-image-in-dockerfile-without-using-the-add-or-copy-direct) or

2. Modify `./docker/Dockerfile` to match your host IP

3. Then, on the command line type `vagrant up`

### Notes on using Windows

On Windows, there is no native Docker support. In this case, Vagrant automatically spins up a proxy VM, defaulting to [boot2docker](https://github.com/mitchellh/boot2docker-vagrant-box). However, this default VM lacks support for synced folders, except `rsync`. We therefore customized the proxy VM to [phusion/ubuntu-14.04-amd64](https://atlas.hashicorp.com/phusion/boxes/ubuntu-14.04-amd64).

After docker is installed on the proxy VM you may get an error

	dial unix /var/run/docker.sock: permission denied.
	Are you trying to connect to a TLS-enabled daemon without TLS?"

Just reboot the host and try again. To reboot the docker host, change into the `host` subdirectory and do a vagrant reload

	cd host
  vagrant reload

If you want to you can automate the reboot using the reboot plugin as discussed in [How to Reboot a Vagrant Guest VM During Provisioning](https://www.exratione.com/2014/06/how-to-reboot-a-vagrant-guest-vm-during-provisioning/)
