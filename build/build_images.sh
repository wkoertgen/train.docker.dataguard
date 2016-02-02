#docker build -f DF_test -t oraclelinux:step2 . | tee DF_test.log
docker build -f DF_Oracle12c -t oraclelinux:oracle12c . | tee DF_Oracle12c.log
docker build -f DF_CreatePrimary -t oraclelinux:primary . | tee DF_CreatePrimary.log
docker build -f DF_CreateStandby -t oraclelinux:standby . | tee DF_CreateStandby.log 
