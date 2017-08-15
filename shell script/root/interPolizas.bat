#!/bin/bash
if [ -e /root/bloq.flag ]; then
    echo "INTERFACE BLOQUEADA"
else
   echo "INTERFACE ACTIVA"
  echo date > /root/bloq.flag
#---------------------------------------------------------------
# EJECUTO LA GENERACION DE NOVEDADES DE POLIZAS
#---------------------------------------------------------------
/usr/bin/dcclient /root/dactweb.txt dc_server
#---------------------------------------------------------------
# FTP DE ARCHIVOS ACT*.TXT
#---------------------------------------------------------------
cd /opt/tomcat/webapps/benef/files/ftppino/
chmod 666 ACT*.TXT
###cd /home/adrian
###/root/pinoftpact.sh
#---------------------------------------------------------------
# COPIAR LOS ARCHIVOS AL DIRECTORIO DEL PROYECTO
#---------------------------------------------------------------
###cd /home/adrian
###cp ACT*.TXT /opt/tomcat/webapps/benef/files/as400/
#---------------------------------------------------------------
# INSERCION DE TABLAS
#---------------------------------------------------------------
su - postgres -c /var/lib/pgsql/pinoact.sh
#---------------------------------------------------------------
# CREA UN DIRECTORIO DE RESGUARDO
#---------------------------------------------------------------
###cd /home/adrian
###mkdir `date +%Y%m%d`
###mv  ACT*.TXT `date +%Y%m%d`
cp ACT*.TXT /home/adrian/`date +%Y%m%d`
cd /root
rm bloq.flag
fi
