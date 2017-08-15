#!/bin/bash

echo "Proceso de Backup del esquema de la BD " > /home/adrian/pino.log
date >> /home/adrian/pino.log
cd /home/adrian

pg_dump -h localhost -s -U postgres BENEF > /home/adrian/back_postgres_esquema.out

gzip -9 /home/adrian/back_postgres_esquema.out
mv  /home/adrian/back_postgres_esquema.out.gz /mnt/part/
rm /home/adrian/back_postgres_esquema.out

echo "fin backup esquema" >> /home/adrian/pino.log
date >> /home/adrian/pino.log
#para restaurar gzip -d fichero.gz   tar -xvf archivo.tar
#psql -h 127.0.0.1 -f benef.PRUEBAS.dump BENEF postgres
#
echo "Proceso de Bacup completo de la BD " >> /home/adrian/pino.log 
#
pg_dump -h localhost -U postgres BENEF > /home/adrian/back_postgres_completo.out

gzip -9 /home/adrian/back_postgres_completo.out
mv  /home/adrian/back_postgres_completo.out.gz /mnt/part/
rm /home/adrian/back_postgres_completo.out
date >> /home/adrian/pino.log
