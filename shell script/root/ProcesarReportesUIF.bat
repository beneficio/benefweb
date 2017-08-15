#!/bin/bash
echo "Comienzo de ProcesarReportes"
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
# EJECUTAR PROGRAMA JAVA QUE LEVANTA LOS ARCHIVOS
#---------------------------------------------------------------
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 24
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 25 
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 26
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 27
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 28
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 29
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 30
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 31
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 32
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 33
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 34
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 35
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 36
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 37
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 38
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 39
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 40
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 41
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 42
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 43
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 44
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 45
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 46
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 47
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 48
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 49
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 50
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 51
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 52
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 53
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 54
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 55
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 56
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 57
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 58
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 59
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 60
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 61
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 62
/usr/lib/jdk/bin/java -classpath $VARIABLE com.business.beans.ProcesarReportes S 63
echo "fin de ProcesarReportes"

