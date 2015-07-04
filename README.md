# train.docker.dataguard
An experiment using Vagrant's Docker provisioner to create an Oracle Standby Database in a Docker container. Crossplatform Linux-Window is intended.s

## Notes on using Windows

On Windows, there is no native Docker support. In this case, Vagrant automatically spins up a proxy VM, defaulting to [boot2docker](https://github.com/mitchellh/boot2docker-vagrant-box). However, this default VM lacks support for synced folders, except `rsync`. We therefore customized the proxy VM to [phusion/ubuntu-14.04-amd64](https://atlas.hashicorp.com/phusion/boxes/ubuntu-14.04-amd64).

After docker is installed on the proxy VM you may get an error

	dial unix /var/run/docker.sock: permission denied.
	Are you trying to connect to a TLS-enabled daemon without TLS?"

Just reboot the host and try again. To reboot the docker host, change into the `host` subdirectory and do a vagrant reload

	cd host
    vagrant reload

If you want to you can automate the reboot using the reboot plugin as discussed in [How to Reboot a Vagrant Guest VM During Provisioning](https://www.exratione.com/2014/06/how-to-reboot-a-vagrant-guest-vm-during-provisioning/)