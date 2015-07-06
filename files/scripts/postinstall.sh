RUNTIME=$(date +%y%m%d%H%M)
LOGFILE=/vagrant/logs/postinstall_$RUNTIME.log

echo postinstall in process $(date) | tee $LOGFILE
echo Logfile is $LOGFILE
echo "wait for postinstall to finish ..."

# listener.ora & tnsnames.ora
echo Installing listener.ora and tnsnames.ora >> $LOGFILE 2>&1
sudo mkdir -p /var/opt/oracle >> $LOGFILE 2>&1
sudo chown oracle:oinstall /var/opt/oracle >> $LOGFILE 2>&1
sudo chmod 766 /var/opt/oracle >> $LOGFILE 2>&1
sudo cp /vagrant/env/listener.ora /var/opt/oracle >> $LOGFILE 2>&1
sudo cp /vagrant/env/tnsnames.ora /var/opt/oracle >> $LOGFILE 2>&1
sudo chown oracle:oinstall /var/opt/oracle/listener.ora >> $LOGFILE 2>&1
sudo chown oracle:oinstall /var/opt/oracle/tnsnames.ora >> $LOGFILE 2>&1

# start listener
echo Starting listener >> $LOGFILE 2>&1
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/12.1.0
export TNS_ADMIN=/var/opt/oracle
export ORACLE_HOSTNAME=oracle12c.localdomain
sudo -Eu oracle $ORACLE_HOME/bin/lsnrctl start listener >> $LOGFILE 2>&1

echo postinstall finished $(date) | tee -a $LOGFILE
