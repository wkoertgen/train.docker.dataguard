# train.docker.dataguard
An experiment on building a docker image for an Oracle Standby Database using Vagrant & Docker.

## Prerequisites

You should have installed [Docker](https://www.docker.com/) and optionally [Vagrant](https://www.vagrantup.com/)

If you are on Windows or want to use a proxy VM for the Docker host, additionally have [VirtualBox](https://www.virtualbox.org/) and/or [boot2docker](http://boot2docker.io/) installed.

### Oracle 12cR1

- Download [Database Install files (1 and 2)](http://www.oracle.com/technetwork/database/enterprise-edition/downloads/database12c-linux-download-1959253.html)
    - `linuxamd64_12102_database_1of2.zip` (1.5G)
    - `linuxamd64_12102_database_2of2.zip` (967.5M)
- Place the zip archives in directory `./install/`

## How to run

Using docker, simply run `./run.sh` (Linux) or `run.bat` (Windows).
Alternatively, using Vagrant, type `vagrant up` and `docker logs -f oracle12c` to follow the installation process.

## How to build

After running the container you could use `docker commit` to create a docker image.

Alternatively, use the `Dockerfile` way to build a docker image:

1. Start a local http server in `./install` for the downloaded Oracle installation archives, e.g. using [Python](http://stackoverflow.com/questions/26692708/how-to-add-a-file-to-an-image-in-dockerfile-without-using-the-add-or-copy-direct)

        python3 -m http.server --bind <address> 8000
        
	where `address` is your primary ip4. My favorite way to get the current ip scripted is

        ip route get 8.8.8.8 | awk '{print $NF; exit}
        
2. Adjust `BASEURL` in `./docker/Dockerfile` to match your host ip.

3. Then, on the command line, cd into `./build` and type

        docker build -t wkoertgen/train.docker.dataguard .
        
	Alternatively use Vagrant, e.g. `vagrant up`
