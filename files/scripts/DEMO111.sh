RUNTIME=$(date +%y%m%d%H%M)
LOGFILE=/vagrant/logs/DEMO111_$RUNTIME.log

echo Database DEMO111 creation in progress $(date) | tee $LOGFILE
echo Logfile is $LOGFILE
echo "This part generates a logfile of 20MB. We decided to lead it to /dev/null"
echo "Read the FAQ to know how to change this"
echo "wait for database creation to finish ..."

ORACLE_BASE=/u01/app/oracle
ORACLE_HOME=$ORACLE_BASE/product/12.1.0
ORACLE_SID=DEMO111
PATH=$ORACLE_HOME/bin:$PATH; 
export ORACLE_BASE ORACLE_HOME ORACLE_SID PATH

OLD_UMASK=`umask`
umask 0027
sudo -Eu oracle mkdir -p $ORACLE_BASE/admin/DEMO111/adump
sudo -Eu oracle mkdir -p $ORACLE_BASE/admin/DEMO111/dpdump
sudo -Eu oracle mkdir -p $ORACLE_BASE/cfgtoollogs/dbca/DEMO111
sudo -Eu oracle mkdir -p $ORACLE_BASE/oradata/DEMO111
sudo -Eu oracle mkdir -p $ORACLE_HOME/dbs
umask ${OLD_UMASK}
PERL5LIB=$ORACLE_HOME/rdbms/admin:$PERL5LIB; export PERL5LIB

sudo cp /vagrant/env/initDEMO111.ora $ORACLE_HOME/dbs
sudo chown oracle:oinstall $ORACLE_HOME/dbs/initDEMO111.ora
sudo chmod 644 $ORACLE_HOME/dbs/initDEMO111.ora
sudo cp /vagrant/env/glogin.sql $ORACLE_HOME/sqlplus/admin/glogin.sql

sudo -Eu oracle $ORACLE_HOME/bin/sqlplus /nolog @/vagrant/scripts/DEMO111.sql > /dev/null 2>&1
if [[ "$?" != "0" ]]; then exit 1; fi

echo Database DEMO111 creation finished $(date) | tee -a $LOGFILE





