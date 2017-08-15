#!/bin/bash
echo "Comienzo de Interface"
#-------------------------------------
# HAGO EL FTP AL AS400
#-------------------------------------
#  COPIAR LOS ARCHIVOS AL DIR DEL PROYECTO
#-----------------------------------------
cd /opt/tomcat/webapps/benef/files/ftppino
cp CTACTEOL.TXT WEBCTACTEOL.TXT
cp CTACTEFP.TXT WEBCTACTEFP.TXT
chmod 666 WEB*.TXT
echo date > /root/bloq.flag
echo date > /opt/tomcat/webapps/benef/files/ftppino/web_ctl.bloq
sleep 5m
#-----------------------------------------
#  bajar el servidor
##-----------------------------------------
##/opt/tomcat/bin/shutdown.sh
###-----------------------------------------
#  INSERCION DE TABLAS
#-----------------------------------------
su - postgres -c /var/lib/pgsql/pino.sh
#-----------------------------------------
#  EJECTAR VACUUM 
#-----------------------------------------
#vacuumdb -h localhost -p 5432 -U postgres -d BENEF -v
#-----------------------------------------
#  subir el servidor
#-----------------------------------------
rm /opt/tomcat/webapps/benef/files/ftppino/web_ctl.bloq
#---------------------------------------------------------------
# DESBLOQUEAR LA INTEFFACE DE ACTUALIZACION
#---------------------------------------------------------------
rm /root/bloq.flag
##/opt/tomcat/bin/startup.sh
#-----------------------------------------
#  CREA EL DIR DE RESGUARDO
#-----------------------------------------
cd /home/adrian/
mkdir `date +%Y%m%d`
###mv *.TXT `date +%Y%m%d`
cp /opt/tomcat/webapps/benef/files/ftppino/WEB*.TXT `date +%Y%m%d`
#---------------------------------------------------------------
# ENVIAR MAIL CON AVISOS
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
# PROGRAMA JAVA QUE ENVIA MAIL CON EL RESULTADO DE LAS INTERFACES
#---------------------------------------------------------------
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.IntEnviarAviso
#---------------------------------------------------------------
# PROGRAMA QUE AVISA POR MAIL QUE SE ANULO UNA POLIZA CON COBRANZA PEND.
#    ANULADA LA EJECUCION DESDE 19/02/2014 
#---------------------------------------------------------------
#/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.IntReportarAnulaciones
#---------------------------------------------------------------
# EJECUTAR PROGRAMA JAVA QUE ENVIA LOS AVISOS DE EMISION A PRODUCTORES
#---------------------------------------------------------------
