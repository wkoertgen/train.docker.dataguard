# setup.sh controls the process of
# preinstall 
# install Oracle SW
# creating databases
# postinstall
# the scripts log into /vagrant/logs/

# preinstall
/vagrant/scripts/preinstall.sh
if [[ $? != "0" ]]; then echo "ERROR in preinstall.sh - aborting setup"; exit; fi

# Oracle12 install
/vagrant/scripts/oracle12c-install.sh
if [[ $? != "0" ]]; then echo "ERROR in oracle12c-install.sh - aborting setup"; exit; fi

# create a database
/vagrant/scripts/DEMO111.sh
#if [[ $? != "0" ]]; then echo "ERROR in DEMO111.sh - aborting setup"; exit; fi

# postinstall
/vagrant/scripts/postinstall.sh
if [[ $? != "0" ]]; then echo "ERROR in postinstall.sh - aborting setup"; exit; fi
