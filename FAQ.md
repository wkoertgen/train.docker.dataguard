# Frequently Asked Questions
## 1. The Challenge - why do we accept it ?
Data Guard provides a comprehensive set of services that create, maintain, manage, and monitor one or more standby databases to enable production Oracle databases to survive disasters and data corruptions. Data Guard maintains these standby databases as copies of the production database. Then, if the production database becomes unavailable because of a planned or an unplanned outage, Data Guard can switch any standby database to the production role, minimizing the downtime associated with the outage. Data Guard can be used with traditional backup, restoration, and cluster techniques to provide a high level of data protection and data availability.

With Data Guard, administrators can optionally improve production database performance by offloading resource-intensive backup and reporting operations to standby systems.

Setup and maintain Data Guard installations in development and productive environments was and still is a challenging task, which comprises creating Physical or Logical Standby Databases, Redo Transport Services, Apply Services, Role Transitions, etc. - after all very complex configurations. We will come back later to that.

Considering this, it is clear that we cannot simply create one Dockerfile and that's it, but rather are compelled to play with different images and different containers simultaneously. In this project, at the end there shall emerge one single image of a Physical Standby Database, which can serve as a fully productive template for arbitrary databases. 

We are not quite sure, if we can achieve all this. But even the approximation would have multiple benefits for developers, database administrators and above all for students, because it happens inside Docker images and containers, which can be thrown away in case of errors, or saved and combined one with another rather arbitrarily. After all, we want to enable people to train Data Guard on affordable platforms.

## 2. How to work with different Dockerfiles 

NOTE the branch **develop** where we try to get around with this:

### Step 1:
docker build -f DF_Oracle12c -t oraclelinux:oracle12c . | tee DF_Oracle12c.log

### Step 2:
docker build -f DF_CreatePrimary -t oraclelinux:primary . | tee DF_CreatePrimary.log

### Step 3:
docker build -f DF_CreateStandby -t oraclelinux:oracle12c . | tee DF_CreateStandby.log


