!#/bin/bash
VARIABLE=/opt/jakarta-tomcat-4.1.31/webapps/benef/WEB-INF/classes:/opt/jakarta-tomcat-4.1.31/webapps/benef/WEB-INF/lib/pg74[2].216.jdbc2.jar
unset CLASSPATH
CLASSPATH="."
JAVA_HOME=/usr/java/jdk1.5.0_04
export JAVA_HOME
#export CLASSPATH="$CLASSPATH:/root:/opt/jakarta-tomcat-4.1.31/webapps/benef/WEB-INF/classes"
PATH="$PATH:$JAVA_HOME/bin:."
export PATH
#---------------------------------------------------------------
# EJECUTAR PROGRAMA JAVA QUE LEVANTA LOS ARCHIVOS
#---------------------------------------------------------------
/usr/java/jdk1.5.0_04/bin/java -classpath $VARIABLE com.business.util.SimpleFTP 192.168.1.10 WEBMPROD.TXT BENEWEB BENEWEB
