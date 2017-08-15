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
#---------------------------------------------------------------
# EJECUTAR PROGRAMA JAVA QUE ENVIA PROPUESTAS
#---------------------------------------------------------------
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.IntPropuestas OL
#---------------------------------------------------------------
#  FTP DEL ENVIO DE PROPUESTAS
#---------------------------------------------------------------
cd /home/adrian/enviar
mv PROASEGU.TXT* PROASEGU.TXT
mv PROCOBER.TXT* PROCOBER.TXT
mv PROECLA.TXT* PROECLA.TXT
mv PROFLAG.TXT* PROFLAG.TXT
mv PROPROPU.TXT* PROPROPU.TXT
mv PROTOMAD.TXT* PROTOMAD.TXT
mv PROUBIC.TXT* PROUBIC.TXT
/root/pinoftpprop.sh
fi



































