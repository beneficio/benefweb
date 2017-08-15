
#!/bin/bash

cd /home/adrian/backup/
#gzip -d /home/adrian/backup/back_mig_10012010.tar.gz
#tar -xvf /home/adrian/backup/back_mig_10012010.tar
#mv /home/adrian/backup/home/adrian/temp/*.backup ./

#pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "ACTIVIDAD_CATEGORIA" -v "/home/adrian/backup/ACTIVIDAD_CATEGORIA.backup"
#pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "ACTIVIDAD_COBERTURA" -v "/home/adrian/backup/ACTIVIDAD_COBERTURA.backup"
##pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "ALERTAS" -v "/home/adrian/backup/ALERTAS.backup"
#pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "BANCOS" -v "/home/adrian/backup/BANCOS.backup"
#pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "BONIFICACION" -v "/home/adrian/backup/BONIFICACION.backup"
#pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "BONIFICACION_ABM" -v "/home/adrian/backup/BONIFICACION_ABM.backup"
#pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "COMISIONES" -v "/home/adrian/backup/COMISIONES.backup"
##pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "COT_COTIZACIONES" -v "/home/adrian/backup/COT_COTIZACIONES.backup"
##pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "C_ASEGURADO" -v "/home/adrian/backup/C_ASEGURADO.backup"
##pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "C_ASEG_BENEF" -v "/home/adrian/backup/C_ASEG_BENEF.backup"
##pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "C_ASEG_COB" -v "/home/adrian/backup/C_ASEG_COB.backup"
##pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "C_CERTIFICADO" -v "/home/adrian/backup/C_CERTIFICADO.backup"
##pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "C_COB_SUMAS" -v "/home/adrian/backup/C_COB_SUMAS.backup"
##pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "C_TEXTO_VAR" -v "/home/adrian/backup/C_TEXTO_VAR.backup"
##pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "C_TOMADOR" -v "/home/adrian/backup/C_TOMADOR.backup"
##pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "C_CLAUSULA_BENEF" -v "/home/adrian/backup/C_CLAUSULA_BENEF.backup"
##pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "ERROR" -v "/home/adrian/backup/ERROR.backup"
#pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "IMPUESTOS" -v "/home/adrian/backup/IMPUESTOS.backup"
#pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "IMPUESTOS_ABM" -v "/home/adrian/backup/IMPUESTOS_ABM.backup"
##pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "MAIL" -v "/home/adrian/backup/MAIL.backup"
##pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "MANUALES" -v "/home/adrian/backup/MANUALES.backup"
#pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "MENU" -v "/home/adrian/backup/MENU.backup"
##pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "NOVEDADES" -v "/home/adrian/backup/NOVEDADES.backup"
##pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "PRODUCTOR_CUOTAS" -v "/home/adrian/backup/PRODUCTOR_CUOTAS.backup"
##pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "PROCEDENCIAS" -v "/home/adrian/backup/PROCEDENCIAS.backup"
pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "PRODUCTOR_COBERTURA" -v "/home/adrian/backup/PRODUCTOR_COBERTURA.backup"
#pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "PRODUCTOR_POR_ORG" -v "/home/adrian/backup/PRODUCTOR_POR_ORG.backup"
pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "PRODUCTOR_SETEOS" -v "/home/adrian/backup/PRODUCTOR_SETEOS.backup"
pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "S_ASEGURADO" -v "/home/adrian/backup/S_ASEGURADO.backup"
pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "S_COBERTURAS" -v "/home/adrian/backup/S_COBERTURAS.backup"
pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "S_ERRORES" -v "/home/adrian/backup/S_ERRORES.backup"
pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "S_PROPUESTA" -v "/home/adrian/backup/S_PROPUESTA.backup"
pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "S_TOMADOR" -v "/home/adrian/backup/S_TOMADOR.backup"
pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "S_UBICACION_RIESGO" -v "/home/adrian/backup/S_UBICACION_RIESGO.backup"
pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "S_CLAUSULA_BENEF" -v "/home/adrian/backup/S_CLAUSULA_BENEF.backup"
#pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "TASA_MENSUAL" -v "/home/adrian/backup/TASA_MENSUAL.backup"
#pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "TASA_MENSUAL_ABM" -v "/home/adrian/backup/TASA_MENSUAL_ABM.backup"
#pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "TASA_PROVINCIAL" -v "/home/adrian/backup/TASA_PROVINCIAL.backup"
#pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "TASA_PROVINCIAL_ABM" -v "/home/adrian/backup/TASA_PROVINCIAL_ABM.backup"
#pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "TRAMO" -v "/home/adrian/backup/TRAMO.backup"
#pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "TRAMO_ABM" -v "/home/adrian/backup/TRAMO_ABM.backup"
##pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "USUARIOS" -v "/home/adrian/backup/USUARIOS.backup"
#pg_restore -i -h localhost -p 5432 -U postgres -d "BENEF" -a -t "P_SEGUIMIENTO" -v "/home/adrian/backup/P_SEGUIMIENTO.backup"







