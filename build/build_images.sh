./updignore.sh install comment
docker build -f DF_Oracle12c -t oraclelinux:oracle12c . | tee DF_Oracle12c.log
./updignore.sh install uncomment
./updignore.sh primary comment
docker build -f DF_CreatePrimary -t oraclelinux:primary . | tee DF_CreatePrimary.log
./updignore.sh primary uncomment
./updignore.sh standby comment
docker build -f DF_CreateStandby -t oraclelinux:standby . | tee DF_CreateStandby.log 
./updignore.sh standby uncomment
