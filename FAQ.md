# Frequently Asked Questions
## 1. The Challenge - why do we accept it ?
Setup and maintain Data Guard installations in development and productive environments was and still is a challenging task, which comprises creating Physical or Logical Standby Databases, Redo Transport Services, Apply Services, Role Transitions, etc. - after all very complex configurations. To get familiar with the conecpts see [Dataguard Concepts](ocs.oracle.com/database/121/SBYDB/toc.htm) 

We will come back to Concepts and details later.

Considering this, it is clear that we cannot simply create one Dockerfile and that's it, but rather are compelled to play with different images and different containers simultaneously. In this project, at the end there shall emerge one single image of a Physical Standby Database, which can serve as a fully productive template for arbitrary databases.

We are not quite sure, if we can achieve all this. But even the approximation would have multiple benefits for developers, database administrators and above all for students, because it happens inside Docker images and containers, which can be thrown away in case of errors, or saved and combined one with another rather arbitrarily. After all, we want to enable people to train Data Guard on affordable platforms.

## 2. How to work with different Dockerfiles

NOTE the branch **develop** where we try to get around with the basic steps. 

### Step 1:
docker build -f DF_Oracle12c -t oraclelinux:oracle12c . | tee DF_Oracle12c.log

### Step 2:
docker build -f DF_CreatePrimary -t oraclelinux:primary . | tee DF_CreatePrimary.log

### Step 3:
docker build -f DF_CreateStandby -t oraclelinux:oracle12c . | tee DF_CreateStandby.log

## 3. Permissions on scripts
Consider these lines in  the dockerfile DF_Oracle12

	ADD ./install/* /tmp/
	RUN cd /tmp && ./oracle12c-install.sh

The docker server copies the contents of the **subdirectory ./install**  to /tmp and tries to execute the scripts **oracle12c-install.sh** Remember: docker only obeys to his master's voice which is root.

The docker client is run by another user - here named hwk. See the contents of the subdirectory:

	hwk@Thinkpad4:~/git/train.docker.dataguard/build/install$ ll
	total 2625116
	drwxrwxr-x 2 hwk hwk       4096 Feb  1 18:55 ./
	drwxrwxr-x 5 hwk hwk       4096 Feb  1 19:25 ../
	-rw-rw-r-- 1 hwk hwk        441 Feb  1 18:24 bash_profile
	-rw-rw-r-- 1 hwk hwk        388 Feb  1 18:24 bashrc
	-rw-rw-r-- 1 hwk hwk          7 Feb  1 18:24 .gitignore
	-rw-r--r-- 1 hwk hwk 1673544724 Jan 27 22:10 linuxamd64_12102_database_1of2.zip
	-rw-r--r-- 1 hwk hwk 1014530602 Jan 27 22:11 linuxamd64_12102_database_2of2.zip
	-rw-rw-r-x 1 hwk hwk       1559 Feb  1 18:55 oracle12c-install.sh*
	-rw-rw-r-- 1 hwk hwk       2414 Feb  1 18:24 oracle12c.rsp
	hwk@Thinkpad4:~/git/train.docker.dataguard/build/install$ 

**NOTE -rw-rw-r-x 1 hwk hwk       1559 Feb  1 18:55 oracle12c-install.sh*** 

## 4. The file **.dockerignore**

	./docker.session
	./*.log
	#./install/*
	
The last line is commented, otherwise the docker server would not take notice of the **subdirectory install** After the installation of the Oracle software we do not need it anymore, we uncomment it then.  If we would drop this line at all, then the docker client would send the complete subdirectory install to the docker server - some 3 GB compressed - in every next build process. Our images wil grow unnecessarily.  See here the sizes of of uncompressed Orace software.

	REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
	oraclelinux         oracle12c           d6915659544b        45 minutes ago      8.955 GB
	oraclelinux         7.2                 0e739c7463a3        8 weeks ago         206 MB


This is a bit clumpsy due to docker's actual philisophy, assuming that there is only **the one Dockerfile**, consequently **only one .dockerignore.** 


