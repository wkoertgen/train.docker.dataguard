# host is DEMO_SBY
# execute as oracle
# host DEMO must run

mkdir -p /u01/app/oracle/admin/demosby1/adump
mkdir /u01/app/oracle/oradata
mkdir /u01/app/oracle/fast_recovery_area

cp /tmp/orapwDEMO $ORACLE_HOME/dbs
cp /tmp/initdemosby1.ora $ORACLE_HOME/dbs
cp /tmp/listener.ora $ORACLE_HOME/network/admin
cp /tmp/tnsnames.ora $ORACLE_HOME/network/admin


