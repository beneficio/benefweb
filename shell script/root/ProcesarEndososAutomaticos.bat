#!/bin/bash
#---------------------------------------------------------------
# SETEAR VARIABLES DE ENTORNO PARA EJECUTAR JAVA
#---------------------------------------------------------------
VARIABLE=/opt/tomcat/webapps/benef/WEB-INF/classes:/opt/tomcat/webapps/benef/WEB-INF/lib/postgresql-9.4-1200.jdbc4.jar:/opt/tomcat/webapps/benef/WEB-INF/lib/mail.jar:/opt/tomcat/webapps/benef/WEB-INF/lib/jconfig.jar:/opt/tomcat/webapps/benef/WEB-INF/lib/activation.jar:/opt/tomcat/webapps/benef/WEB-INF/lib/jcommon-0.9.1.jar:/opt/tomcat/webapps/benef/WEB-INF/lib/commons-vfs2-2.0.jar:/opt/tomcat/webapps/benef/WEB-INF/lib/jsch-0.1.53.jar:/opt/tomcat/webapps/benef/WEB-INF/lib/commons-logging-1.1.jar:/opt/tomcat/webapps/benef/WEB-INF/lib/commons-net-3.3.jar
unset CLASSPATH
CLASSPATH="."
JAVA_HOME=/usr/lib/jdk
export JAVA_HOME
export CLASSPATH="$CLASSPATH:/root:/opt/tomcat/webapps/benef/WEB-INF/classes"
PATH="$PATH:$JAVA_HOME/bin:."
export PATH
#---------------------------------------------------------------
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.batch.ProcesarEndososAutomaticos 


































