# FAQ for branch develop
## Steps to build 

### Step 1: 
docker build -f DF_Oracle12c -t oraclelinux:oracle12c . | tee DF_Oracle12c.log

### Step 2: 
docker build -f DF_CreatePrimary -t oraclelinux:primary . | tee DF_CreatePrimary.log

### Step 3:
docker build -f DF_CreateStandby -t oraclelinux:oracle12c . | tee DF_CreateStandby.log
