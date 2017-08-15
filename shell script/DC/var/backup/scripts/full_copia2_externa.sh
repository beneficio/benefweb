#### Correr de martes a sabado #####

DATE=`/bin/date +%y%m%d --date=yesterday`
NUMSEM=`/bin/date +%W`
DIASEMANA=`/bin/date +%a --date=yesterday`
PARIDADSEMANA=`expr $NUMSEM % 2`

##########################################################
#### Desmontar y montar disco externo                #####
##########################################################

/bin/umount /dev/sdc1
/bin/sleep 10
/bin/mount /dev/sdc1 /mnt/sdc1
/bin/sleep 15

###########################################
#### Copia de Backup en disco externo: ####
#### (copia a la madrugada el ultimo   ####
#### archivo que encuentra en          ####
#### /divcen/dcbackup con el nombre    ####
#### del dia de la semana del dia      ####
#### anterior)                         #### 
###########################################

ARCH=`/bin/ls -rt /divcen/dcbackup | /usr/bin/tail -1`

/bin/cp -f /divcen/dcbackup/$ARCH /mnt/sdc1/servidordc/$PARIDADSEMANA/dcbackup_$DIASEMANA.full.tar.gz

##########################################################
#### Desmontar disco externo                         #####
##########################################################

/bin/umount /dev/sdc1
