#!/bin/bash

cd /home/adrian
#---------------------------------------------------------------
# HAGO EL FTP AL AS400
#---------------------------------------------------------------
/root/pinoftp.sh 
#---------------------------------------------------------------
# COPIAR LOS ARCHIVOS AL DIRECTORIO DEL PROYECTO
#---------------------------------------------------------------
cd /opt/tomcat/webapps/benef/files/as400
rm -f *.TXT
cd /home/adrian
cp *.TXT /opt/tomcat/webapps/benef/files/as400/
#---------------------------------------------------------------
# INSERCION DE TABLAS
#---------------------------------------------------------------
su - postgres -c /var/lib/pgsql/pino.sh
#---------------------------------------------------------------
# CREA UN DIRECTORIO DE RESGUARDO
#---------------------------------------------------------------
cd /home/adrian
mkdir `date +%Y%m%d`
mv  *.TXT `date +%Y%m%d`
#mv CTL/*.log `date +%Y%m%d`
#mv CTL/*.bad `date +%Y%m%d`

