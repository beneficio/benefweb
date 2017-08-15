#!/bin/bash

pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/ACTIVIDAD_CATEGORIA.dump" -U postgres -t ACTIVIDAD_CATEGORIA BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/ACTIVIDAD_COBERTURA.dump" -U postgres -t ACTIVIDAD_COBERTURA BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/AJUSTE_TARIFA_PROD.dump" -U postgres -t AJUSTE_TARIFA_PROD BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/AJUSTE_TARIFA_ZONA.dump" -U postgres -t AJUSTE_TARIFA_ZONA BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/ALERTAS.dump" -U postgres -t ALERTAS BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/BANCOS.dump" -U postgres -t BANCOS BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/BONIFICACION.dump" -U postgres -t BONIFICACION BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/BONIFICACION_ABM.dump" -U postgres -t BONIFICACION_ABM BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/COBERTURAS.dump" -U postgres -t COBERTURAS BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/CODIGOS.dump" -U postgres -t CODIGOS BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/COND_FACTURACION.dump" -U postgres -t COND_FACTURACION BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/COMISIONES.dump" -U postgres -t COMISIONES BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/COT_COTIZACIONES.dump" -U postgres -t COT_COTIZACIONES BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/C_ASEGURADO.dump" -U postgres -t C_ASEGURADO BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/C_ASEG_BENEF.dump" -U postgres -t C_ASEG_BENEF BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/C_ASEG_COB.dump" -U postgres -t C_ASEG_COB BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/C_CERTIFICADO.dump" -U postgres -t C_CERTIFICADO BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/C_COB_SUMAS.dump" -U postgres -t C_COB_SUMAS BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/C_TEXTO_FIJO.dump" -U postgres -t C_TEXTO_FIJO BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/C_TEXTO_VAR.dump" -U postgres -t C_TEXTO_VAR BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/C_TOMADOR.dump" -U postgres -t C_TOMADOR BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/C_CLAUSULA_BENEF.dump" -U postgres -t C_CLAUSULA_BENEF BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/ERROR.dump" -U postgres -t ERROR BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/ESTADOS.dump" -U postgres -t ESTADOS BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/IMPUESTOS.dump" -U postgres -t IMPUESTOS BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/IMPUESTOS_ABM.dump" -U postgres -t IMPUESTOS_ABM BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/INTERFASES.dump" -U postgres -t INTERFASES BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/INTERFASE_MANUAL.dump" -U postgres -t INTERFASE_MANUAL BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/MAIL.dump" -U postgres -t MAIL BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/MANUALES.dump" -U postgres -t MANUALES BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/MENU.dump" -U postgres -t MENU BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/MONEDAS.dump" -U postgres -t MONEDAS BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/NOVEDADES.dump" -U postgres -t NOVEDADES BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/OPCION_AJUSTE.dump" -U postgres -t OPCION_AJUSTE BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/OPCION_AJUSTE_DET.dump" -U postgres -t OPCION_AJUSTE_DET BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/ORGANIZADORES.dump" -U postgres -t ORGANIZADORES BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/PERSONAS.dump" -U postgres -t PERSONAS BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/PLAN.dump" -U postgres -t PLAN BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/PLAN_COSTO.dump" -U postgres -t PLAN_COSTO BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/PLAN_PRODUCTOR.dump" -U postgres -t PLAN_PRODUCTOR BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/PLAN_SUMAS.dump" -U postgres -t PLAN_SUMAS BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/PROCEDENCIAS.dump" -U postgres -t PROCEDENCIAS BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/PRODUCTOS.dump" -U postgres -t PRODUCTOS BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/PRODUCTOR_COBERTURA.dump" -U postgres -t PRODUCTOR_COBERTURA BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/PRODUCTOR_CUOTAS.dump" -U postgres -t PRODUCTOR_CUOTAS BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/PRODUCTOR_POR_ORG.dump" -U postgres -t PRODUCTOR_POR_ORG BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/PRODUCTOR_SETEOS.dump" -U postgres -t PRODUCTOR_SETEOS BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/PRUEBAS.dump" -U postgres -t PRUEBAS BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/RAMAS.dump" -U postgres -t RAMAS BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/SUB_RAMAS.dump" -U postgres -t SUB_RAMAS BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/S_ASEGURADO.dump" -U postgres -t S_ASEGURADO BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/S_COBERTURAS.dump" -U postgres -t S_COBERTURAS BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/S_ERRORES.dump" -U postgres -t S_ERRORES BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/S_PROPUESTA.dump" -U postgres -t S_PROPUESTA BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/S_TOMADOR.dump" -U postgres -t S_TOMADOR BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/S_UBICACION_RIESGO.dump" -U postgres -t S_UBICACION_RIESGO BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/S_CLAUSULA_BENEF.dump" -U postgres -t S_CLAUSULA_BENEF BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/TABLAS.dump" -U postgres -t TABLAS BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/TARJETAS.dump" -U postgres -t TARJETAS BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/TASA_MENSUAL.dump" -U postgres -t TASA_MENSUAL BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/TASA_MENSUAL_ABM.dump" -U postgres -t TASA_MENSUAL_ABM BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/TASA_PROVINCIAL.dump" -U postgres -t TASA_PROVINCIAL BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/TASA_PROVINCIAL_ABM.dump" -U postgres -t TASA_PROVINCIAL_ABM BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/TIPOS_FORMA_PAGO.dump" -U postgres -t TIPOS_FORMA_PAGO BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/TIPOS_MOVIMIENTO.dump" -U postgres -t TIPOS_MOVIMIENTO BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/TRAMO.dump" -U postgres -t TRAMO BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/TRAMO_ABM.dump" -U postgres -t TRAMO_ABM BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/USUARIOS.dump" -U postgres -t USUARIOS BENEF
pg_dump -i -h localhost -p 5432 -F c -v -f "/home/adrian/temp/VIGENCIA.dump" -U postgres -t VIGENCIA BENEF

tar -cvf back_nuevo.tar /home/adrian/temp/*.dump
gzip -9 back_nuevo.tar

#para restaurar gzip -d fichero.gz   tar -xvf archivo.tar
#psql -h 127.0.0.1 -f "/home/adrian/temp/PRUEBAS.dump" BENEF postgres
