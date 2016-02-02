echo Database Creation started
ORACLE_BASE=/u01/app/oracle
ORACLE_HOME=$ORACLE_BASE/product/12.1.0
ORACLE_SID=DEMO
PATH=$ORACLE_HOME/bin:$ORACLE_HOME/perl/bin:$PATH;
export ORACLE_BASE ORACLE_HOME ORACLE_SID PATH


OLD_UMASK=`umask`
umask 0027
su - oracle -c "mkdir -p $ORACLE_BASE/admin/DEMO/adump"
su - oracle -c "mkdir -p $ORACLE_BASE/admin/DEMO/dpdump"
su - oracle -c "mkdir -p $ORACLE_BASE/oradata"
su - oracle -c "mkdir -p $ORACLE_BASE/fast_recovery_area"
su - oracle -c "mkdir -p $ORACLE_BASE/cfgtoollogs/dbca/DEMO"
su - oracle -c "mkdir -p $ORACLE_HOME/dbs"
su - oracle -c "cp /tmp/listener.ora $ORACLE_HOME/network/admin/listener.ora"
su - oracle -c "cp /tmp/tnsnames.ora $ORACLE_HOME/network/admin/tnsnames.ora"
su - oracle -c "cp /tmp/initDEMO.ora $ORACLE_HOME/dbs"
su - oracle -c "cd $ORACLE_HOME/dbs; orapwd file=orapwdemo password=oracle_4U"

su - oracle  -c "$ORACLE_HOME/bin/dbca \
-silent  \
-createDatabase \
-templateName General_Purpose.dbc  \
-gdbName DEMO \
-sid DEMO  \
-createAsContainerDatabase false  \
-SysPassword oracle  \
-SystemPassword oracle  \
-datafileDestination /u01/app/oracle/oradata \
-storageType FS  \
-characterSet AL32UTF8  \
-memoryPercentage 40 \
-listeners LISTENER " 
if [[ $? != "0" ]]; then echo "ERROR in demo.sh - aborting setup"; exit; fi

su oracle -c "$ORACLE_HOME/bin/sqlplus / as sysdba << EOF
alter user system identified by oracle_4U;
alter system set dg_broker_start = true scope=spfile;
shutdown immediate;
startup mount;
alter database archivelog;
alter database force logging;
alter database open;
EOF"

if [[ $? != "0" ]]; then echo "ERROR in demo.sh - aborting setup"; exit; fi

# /etc/oratab
cp -f /tmp/oratab /etc/oratab
chown oracle:oinstall /etc/oratab
chmod 0644 /etc/oratab


# start listener
echo Starting listener 
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/12.1.0
export TNS_ADMIN=/var/opt/oracle
su - oracle -c "$ORACLE_HOME/bin/lsnrctl start listener"

# implement oracle at boot time
SRC=/tmp/oracle
DEST=/etc/init.d/oracle
cp $SRC $DEST
chmod 0755 $DEST

chkconfig oracle on


if [[ $? != "0" ]]; then echo "ERROR in postinstall.sh - aborting setup"; exit; fi

echo postinstall finished $(date) | tee -a $LOGFILE
# ckech & cleanup
rm -rf /var/cache/yum/x86_64 \
/oracle/install/linuxamd64_12102_database \
/u01/app/oracle/product/12.1.0/inventory/backup/* \
/u01/app/oracle/product/12.1.0/assistants/dbca/templates

