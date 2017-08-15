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
# verifica  si la interface esta bloqueada o no
#---------------------------------------------------------------
cd /home/adrian/enviar
if [ -e bloq.flag ]; then
    echo "INTERFACE BLOQUEADA"
else
   echo "INTERFACE ACTIVA"
  echo date > bloq.flag
#---------------------------------------------------------------
# EJECUTAR PROGRAMA JAVA QUE ENVIA PROPUESTAS
#---------------------------------------------------------------
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.IntPropuestas OL
#---------------------------------------------------------------
#  FTP DEL ENVIO DE PROPUESTAS
#---------------------------------------------------------------
cd /home/adrian/enviar
/root/pinoftpprop.sh
#---------------------------------------------------------------
# RESGUARDAR ARCHIVOS DE PROPUESTAS
#---------------------------------------------------------------
mkdir `date +%Y%m%d`
mv  PRO*.* `date +%Y%m%d`
#---------------------------------------------------------------
# EJECUTO EL PROGRAMA EN DC QUE GRABA LAS PROPUESTAS
#---------------------------------------------------------------
/root/gpolpino.sh
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
cd /home/adrian/enviar
rm bloq.flag
fi



































