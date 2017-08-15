#!/bin/sh
###
# $Rev:: 540           $:  Revision of last commit
# $Author:: rene       $:  Author of last commit
# $Date:: 2011-04-25 1#$:  Date of last commit
###


# arma un tarball con todo, lo comprime y lo copia a un dvd

BAKDIR=/divcen/dcbackup
TMPLOG=`mktemp /tmp/log.XXXXXX`
MAILSERVER=localhost
SMTPCLIENT=/usr/local/bin/smtpclient
REMITENTE=backup@dcsistemas.com.ar
DESTINATARIOS="backup@dcsistemas.com.ar"
NOMBRE=dcbackup_`date +%y%m%d.tgz`
EXCLUSIONES="^./divcen/migracion_bak/|^./tmp/|^./divcen/tmp|^./backup|^./divcen/ftppino|^./divcen/ftpprueba|^./divcen/dcbackup|^./divcen/logpdf"

cd /
(find . -mount | grep -v $BAKDIR | egrep -v $EXCLUSIONES | 
    cpio -o -H ustar | 
    gzip -cf >$BAKDIR/$NOMBRE) >>$TMPLOG 2>&1
if [ $? -ne 0 ]
then
    ASUNTO="ERROR en backup"
else
    ASUNTO="ok backup"
fi

chown backup:backup $BAKDIR/$NOMBRE

# borra los backups anteriores que hubiera
find $BAKDIR -name 'dcbackup_*' -mtime +1 -exec rm -f {} \;	>>$TMPLOG 2>&1


cat $TMPLOG | $SMTPCLIENT -s "Beneficio: $ASUNTO" \
	-f $REMITENTE -S $MAILSERVER $DESTINATARIOS

rm -f $TMPLOG
