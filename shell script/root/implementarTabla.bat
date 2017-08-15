#!/usr/bin/env bash
echo "Comienzo de implementarTabla"
if [ $# == 0 ]
  then
  echo "Ingrese la tabla a implementar como parametro..."
   exit;
  else
   export TABLA=$1
fi
pg_dump -h localhost -p 5432 -o -v -f benef.$TABLA.dump -U postgres -a -t "\"$TABLA\"" BENEF
scp -c arcfour /root/benef.$TABLA.dump root@192.168.2.175:/var/lib/pgsql/backups/
ssh root@192.168.2.175 "./UploadTabla.bat $TABLA"
rm /root/benef.$TABLA.dump
echo date
echo "fin de implementarTabla"

