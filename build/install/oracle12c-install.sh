chmod 777 /tmp # wg. smonitor.ksh  as oracle

#RUNTIME=$(date +%y%m%d%H%M)
#LOGFILE=/vagrant/logs/oracle12c-install_$RUNTIME.log
#echo Oracle12c installation in progress $(date) | tee $LOGFILE
#echo Logfile is $LOGFILE
#echo "wait for Oracle12c installation to finish ..."

export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/12.1.0
export ORACLE_SID=DEMO

mkdir -p /oracle/install
chown -R oracle:dba /oracle
mkdir -p /u01/app
chown -R oracle:oinstall /u01

su - oracle -c "cp /tmp/oracle12c.rsp /oracle"

unzip /tmp/linuxamd64_12102_database_1of2.zip -d /oracle/install/linuxamd64_12102_database
unzip /tmp/linuxamd64_12102_database_2of2.zip -d /oracle/install/linuxamd64_12102_database




#run oracle installer
su - oracle -c "/oracle/install/linuxamd64_12102_database/database/runInstaller \
-silent -ignoreSysPrereqs -ignorePrereq -noconfig \
-showProgress -waitforcompletion -responseFile /oracle/oracle12c.rsp"

/u01/app/oraInventory/orainstRoot.sh
/u01/app/oracle/product/12.1.0/root.sh

errorlevel=$?

if [ "$errorlevel" != "0" ] && [ "$errorlevel" != "6" ]; then
  echo "There was an error preventing script from continuing"
  exit 1
else echo Oracle12c installation finished
fi

# environment
cp /tmp/bash_profile /home/oracle/.bash_profile
cp /tmp/bashrc /home/oracle/.bashrc
chown oracle:dba /home/oracle/.*

if [ "$errorlevel" != "0" ] && [ "$errorlevel" != "6" ]; then
  echo "There was an error in setting up environment"
else echo "Setting up environment successful"
fi

# cleanup
rm -Rf /oracle/install
rm -Rf /tmp/*
