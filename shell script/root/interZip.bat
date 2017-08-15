#!/bin/bash

echo "Comienzo del script"
cd /home/adrian/
#---------------------------------------------------------------
# HAGO EL FTP AL AS400
#---------------------------------------------------------------
#/root/pinoftpzip.sh 
#---------------------------------------------------------------
# DESCOMPRESION DE ARCHIVOS
#---------------------------------------------------------------
ls *.GZ | while read arc
do
   /usr/bin/gunzip $arc
done
[ $? -ne 0 ] &&
{
   echo "$0: Error al descomprimir los archivos.\n"
   exit 2
}
#---------------------------------------------------------------
# COPIAR LOS ARCHIVOS AL DIRECTORIO DEL PROYECTO
#---------------------------------------------------------------
#rm -f /opt/tomcat/webapps/benef/files/as400/*.TXT
#cp *.TXT /opt/tomcat/webapps/benef/files/as400/
#---------------------------------------------------------------
# INSERCION DE TABLAS
#---------------------------------------------------------------
#su - postgres -c /var/lib/pgsql/pino.sh
#---------------------------------------------------------------
# CREA UN DIRECTORIO DE RESGUARDO
#---------------------------------------------------------------
#cd /home/adrian
#mkdir `date +%Y%m%d`
#mv  *.TXT `date +%Y%m%d`

