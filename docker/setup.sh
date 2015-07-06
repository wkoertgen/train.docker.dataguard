# cf.: https://www.doag.org/formes/servlet/DocNavi?action=getFile&did=6939790&file=2015-03-News-Franck_Pachot-Data-virtualization-playing-with-Oracle-12c-on-Docker-containers.pdf

yum -y install oracle-rdbms-server-12cR1-preinstall unzip

mkdir -p /oracle/install
chown -R oracle:dba /oracle

unzip linuxamd64_12102_database_1of2.zip -d /oracle/install/linuxamd64_12102_database
unzip linuxamd64_12102_database_2of2.zip -d /oracle/install/linuxamd64_12102_database

cat > /oracle/db_install.rsp <<-'CAT'
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v12.1.0
oracle.install.option=INSTALL_DB_SWONLY
ORACLE_HOSTNAME=
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=/oracle/oraInventory
SELECTED_LANGUAGES=en
ORACLE_HOME=/oracle/product/12102
ORACLE_BASE=/oracle
oracle.install.db.InstallEdition=EE
oracle.install.db.DBA_GROUP=dba
oracle.install.db.OPER_GROUP=dba
oracle.install.db.BACKUPDBA_GROUP=dba
oracle.install.db.DGDBA_GROUP=dba
oracle.install.db.KMDBA_GROUP=dba
CAT

su - oracle -c "/oracle/install/linuxamd64_12102_database/database/runInstaller \
-waitforcompletion -ignoreSysPrereqs -ignorePrereq -silent -noconfig \
-responseFile /oracle/db_install.rsp"

/oracle/oraInventory/orainstRoot.sh
/oracle/product/12102/root.sh

rm -rf /var/cache/yum/x86_64 \
/oracle/install/linuxamd64_12102_database \
/oracle/product/12102/inventory/backup/* \
/oracle/product/12102/assistants/dbca/templates