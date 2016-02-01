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
