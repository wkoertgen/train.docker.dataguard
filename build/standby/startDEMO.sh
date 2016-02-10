export ORACLE_BASE=/u01/app/oracle
ORACLE_HOME=/u01/app/oracle/product/12.1.0
$ORACLE_HOME/bin/lsnrctl start listener_demo
$ORACLE_HOME/bin/sqlplus -S / as sysdba <<EOF
startup
select * from v\$instance;
EOF
