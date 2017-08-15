!#/bin/bash
#---------------------------------------------------------------
# CREA UN DIRECTORIO DE RESGUARDO Y MUEVE LOS ARCHIVOS
#---------------------------------------------------------------
cd /home/adrian
mkdir `date +%Y%m%d`
mv  *.TXT `date +%Y%m%d`
rm *.TXT
