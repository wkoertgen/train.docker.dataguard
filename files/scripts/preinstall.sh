

RUNTIME=$(date +%y%m%d%H%M)
LOGFILE=/vagrant/logs/preinstall_$RUNTIME.log

echo  preinstall in progress $(date) | tee $LOGFILE
echo Logfile is $LOGFILE 
echo "wait for preinstall to finish ..."

#prerequisites
# NOTE: docker runs as root - and
# most base images lack 'sudo' command
# (apt-get -y install sudo)
yum -y install oracle-rdbms-server-12cR1-preinstall # >> $LOGFILE 2>&1
yum -y install unzip #>> $LOGFILE

echo  preinstall finished $(date) | tee -a $LOGFILE
