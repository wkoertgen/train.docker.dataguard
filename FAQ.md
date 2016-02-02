# Frequently Asked Questions
## 1. The Challenge - why do we accept it ?
Setup and maintain Data Guard installations in development and productive environments was and still is a challenging task, which comprises creating Physical or Logical Standby Databases, Redo Transport Services, Apply Services, Role Transitions, etc. - very complex configurations, after all. To get familiar with the concepts see [Data Guard Concepts](http://docs.oracle.com/database/121/SBYDB/toc.htm) 

We will come back to concepts and details later.

Considering this, it is clear that we cannot simply create one Dockerfile and that's it, but rather are compelled to play with different images and different containers simultaneously. In this project, at the end, there shall emerge one single image of a Physical Standby Database, which can serve as a fully productive template for arbitrary productive primary databases.

We are not quite sure, if we can achieve all this. But even the approximation would have multiple benefits for developers, database administrators and above all for students, because it happens inside Docker images and containers, which can be thrown away in case of errors, or saved and combined one with another rather arbitrarily. After all, we want to enable people to train Data Guard on affordable platforms.

## 2. How to work with different Dockerfiles

NOTE the branch **develop** where we try to get around with the basic steps. 

#### Step 1:
docker build -f DF_Oracle12c -t oraclelinux:oracle12c . | tee DF_Oracle12c.log

####Step 2:
docker build -f DF_CreatePrimary -t oraclelinux:primary . | tee DF_CreatePrimary.log

#### Step 3:
docker build -f DF_CreateStandby -t oraclelinux:standby . | tee DF_CreateStandby.log

## 3. Permissions on scripts
Consider these lines in  the dockerfile DF_Oracle12

	ADD ./install/* /tmp/
	RUN cd /tmp && ./oracle12c-install.sh

The ADD instruction tells the docker server to copy the contents of the **subdirectory ./install**  to /tmp of the image to be built just now.  The RUN instruction tries to execute the script **oracle12c-install.sh.** Remember, that docker only obeys to his master's voice, which is root.

Unfortunately the docker client is run by another user - here named hwk. See the contents of the subdirectory:

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
	
The last line is commented, otherwise the docker server would not take notice of the **subdirectory install.** After the installation of the Oracle software, we do not need it anymore, we uncomment it then.  If we would drop this line at all, then the docker client would **send the complete subdirectory install** to the docker server - some 3 GB compressed - in every next build process. Our images would grow unnecessarily.  See here the sizes of the images. NOTE: oraclelinux + packages required for the installation of Oracle software comes to 758 MB, the rest is used for Oracle12c R1 Enterprise Eidtion.

	REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
	oraclelinux         oracle12c           d6915659544b        45 minutes ago      8.955 GB
	oraclelinux         7.2                 0e739c7463a3        8 weeks ago         206 MB


This handling of the .dockerignore is a bit clumpsy due to docker's actual philisophy assuming, that there is only **the one Dockerfile**, consequently **only one .dockerignore.** 

## 5. Handling Oracle Network during the build process
Consider the our **listener.ora** or  **tnsnames.ora**

	LISTENER_DEMO =
	  (DESCRIPTION =
	    (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))
	  )
	
	SID_LIST_LISTENER_DEMO =
	  (SID_LIST =
	    (SID_DESC =
	      (GLOBAL_DBNAME = demo_DGMGRL )
	      (ORACLE_HOME = /oracle/product/12.1.0)
	      (SID_NAME = demo)
	    )
	  )
	
	ADR_BASE_LISTENER = /oracle

Guess what the docker server does when it resolves **localhost.** Bingo, it takes the **container name.** 
Look here the logfile:

	Starting /u01/app/oracle/product/12.1.0/bin/tnslsnr: please wait...
	
	TNSLSNR for Linux: Version 12.1.0.2.0 - Production
	System parameter file is /u01/app/oracle/product/12.1.0/network/admin/listener.ora
	Log messages written to /oracle/diag/tnslsnr/54be4c00b8ab/listener/alert/log.xml
	Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=54be4c00b8ab)(PORT=1521)))
	
	Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
	STATUS of the LISTENER
	------------------------
	Alias                     listener
	Version                   TNSLSNR for Linux: Version 12.1.0.2.0 - Production
	Start Date                02-FEB-2016 09:45:05
	Uptime                    0 days 0 hr. 0 min. 6 sec
	Trace Level               off
	Security                  ON: Local OS Authentication
	SNMP                      OFF
	Listener Parameter File   /u01/app/oracle/product/12.1.0/network/admin/listener.ora
	Listener Log File         /oracle/diag/tnslsnr/54be4c00b8ab/listener/alert/log.xml
	Listening Endpoints Summary...
	  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=54be4c00b8ab)(PORT=1521)))
	The listener supports no services
	The command completed successfully
	postinstall finished Tue Feb 2 09:45:06 UTC 2016
	 ---> a18e727fc5d4
	Removing intermediate container 9e79e1a462fa

Keep in mind, that docker adds a **filesystem layer** every time when it finds instructions like ADD, RUN or CMD  in the dockerfile. For the execution it starts an **intermediate container** and updates the **/etc/hosts.**

Very smart. See question 7.

## 6. Handling Oracle Network in arbitrary containers
What happens, when we start a container with the newly created image ...

	REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
	oraclelinux         primary             a18e727fc5d4        20 minutes ago      11.01 GB

by typing 
	 docker run --rm -it a18e727fc5d4 su - oracle

Of course the same smart replacement of localhost to the container's name:

	Starting /u01/app/oracle/product/12.1.0/bin/tnslsnr: please wait...
	TNSLSNR for Linux: Version 12.1.0.2.0 - Production
	System parameter file is /u01/app/oracle/product/12.1.0/network/admin/listener.ora
	Log messages written to /oracle/diag/tnslsnr/ee4c15a3d5ee/listener/alert/log.xml
	Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=ee4c15a3d5ee)(PORT=1521)))
	
	Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
	STATUS of the LISTENER
	------------------------
	Alias                     LISTENER
	Version                   TNSLSNR for Linux: Version 12.1.0.2.0 - Production
	Start Date                02-FEB-2016 10:08:02
	Uptime                    0 days 0 hr. 0 min. 4 sec
	Trace Level               off
	Security                  ON: Local OS Authentication
	SNMP                      OFF
	Listener Parameter File   /u01/app/oracle/product/12.1.0/network/admin/listener.ora
	Listener Log File         /oracle/diag/tnslsnr/ee4c15a3d5ee/listener/alert/log.xml
	Listening Endpoints Summary...
	  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=ee4c15a3d5ee)(PORT=1521)))
	The listener supports no services
	The command completed successfully

## 7. The /etc/hosts in docker containers
Look at the /etc/hosts of the container **ee4c15a3d5ee**

	172.17.0.2	ee4c15a3d5ee
	127.0.0.1	localhost
	::1	localhost ip6-localhost ip6-loopback
	fe00::0	ip6-localnet
	ff00::0	ip6-mcastprefix
	ff02::1	ip6-allnodes
	ff02::2	ip6-allrouters


The container's name is the hostname. Try it out with commands like *hostname* or *uname -a*, when you run another container.

We will come back to it when we go to link the containers together.








