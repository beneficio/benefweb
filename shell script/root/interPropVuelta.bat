#!/bin/bash
#---------------------------------------------------------------
# SETEAR VARIABLES DE ENTORNO PARA EJECUTAR JAVA
#---------------------------------------------------------------
VARIABLE=/opt/tomcat/webapps/benef/WEB-INF/classes:/opt/tomcat/webapps/benef/WEB-INF/lib/postgresql-8.2-510.jdbc2.jar:/opt/tomcat/webapps/benef/WEB-INF/lib/mail.jar:/opt/tomcat/webapps/benef/WEB-INF/lib/jconfig.jar:/opt/tomcat/webapps/benef/WEB-INF/lib/activation.jar:/opt/tomcat/webapps/benef/WEB-INF/lib/jcommon-0.9.1.jar
unset CLASSPATH
CLASSPATH="."
JAVA_HOME=/usr/lib/jdk
export JAVA_HOME
export CLASSPATH="$CLASSPATH:/root:/opt/tomcat/webapps/benef/WEB-INF/classes"
PATH="$PATH:$JAVA_HOME/bin:."
export PATH
#---------------------------------------------------------------
# FTP DE ARCHIVOS PROVPROP.TXT
#---------------------------------------------------------------
cd /home/adrian
/root/pinoftpprop2.sh
#---------------------------------------------------------------
# COPIAR LOS ARCHIVOS AL DIRECTORIO DEL PROYECTO
#---------------------------------------------------------------
cd /opt/tomcat/webapps/benef/files/as400
cd /home/adrian
cp PROVPROP.TXT /opt/tomcat/webapps/benef/files/as400/
cp PROERROR.TXT /opt/tomcat/webapps/benef/files/as400/
#---------------------------------------------------------------
# INSERCION DE TABLAS
#---------------------------------------------------------------
su - postgres -c /var/lib/pgsql/pinoProp.sh
#---------------------------------------------------------------
# CREA UN DIRECTORIO DE RESGUARDO
#---------------------------------------------------------------
cd /home/adrian
mkdir `date +%Y%m%d`
mv  PROVPROP.TXT `date +%Y%m%d`
mv  PROERROR.TXT `date +%Y%m%d`



































