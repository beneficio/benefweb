#!/bin/bash

cd /home/adrian

pg_dump -h localhost -p 5432 -o -v -f benef.ACTIVIDAD_CATEGORIA.dump -U postgres -t ACTIVIDAD_CATEGORIA BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.ACTIVIDAD_COBERTURA.dump -U postgres -t ACTIVIDAD_COBERTURA BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.ALERTAS.dump -U postgres -t ALERTAS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.BANCOS.dump -U postgres -t BANCOS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.BANCO_NACION.dump -U postgres -t BANCO_NACION BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.BANCO_PATAGONIA.dump -U postgres -t BANCO_PATAGONIA BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.BANCOS_CONVENIO.dump -U postgres -t BANCOS_CONVENIO BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.BONIFICACION.dump -U postgres -t BONIFICACION BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.BONIFICACION_ABM.dump -U postgres -t BONIFICACION_ABM BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.COBERTURAS.dump -U postgres -t COBERTURAS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.COBERTURAS_AGRUP.dump -U postgres -t COBERTURAS_AGRUP BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.COBERTURAS_OPCION.dump -U postgres -t COBERTURAS_OPCION BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.CODIGOS.dump -U postgres -t CODIGOS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.COMISIONES.dump -U postgres -t COMISIONES BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.COMISIONES_EXT.dump -U postgres -t COMISIONES_EXT BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.COND_FACTURACION.dump -U postgres -t COND_FACTURACION BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.COT_COTIZACIONES.dump -U postgres -t COT_COTIZACIONES BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.CO_CTACTE_FA.dump -U postgres -t CO_CTACTE_FA BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.CO_GESTION.dump -U postgres -t CO_GESTION BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.CO_GESTION_DET.dump -U postgres -t CO_GESTION_DET BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.CO_GESTION_TEXTOS.dump -U postgres -t CO_GESTION_TEXTOS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.CO_PRELIQ.dump -U postgres -t CO_PRELIQ BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.CO_PRELIQ_DET.dump -U postgres -t CO_PRELIQ_DET BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.CO_PRELIQ_ESTADO.dump -U postgres -t CO_PRELIQ_ESTADO BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.CO_PRELIQ_RESP.dump -U postgres -t CO_PRELIQ_RESP BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.C_ASEGURADO.dump -U postgres -t C_ASEGURADO BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.C_ASEG_BENEF.dump -U postgres -t C_ASEG_BENEF BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.C_ASEG_COB.dump -U postgres -t C_ASEG_COB BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.C_CERTIFICADO.dump -U postgres -t C_CERTIFICADO BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.C_COB_SUMAS.dump -U postgres -t C_COB_SUMAS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.C_CONCEPTO.dump -U postgres -t C_CONCEPTO BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.C_TEXTO_VAR.dump -U postgres -t C_TEXTO_VAR BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.C_TOMADOR.dump -U postgres -t C_TOMADOR BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.C_CLAUSULA_BENEF.dump -U postgres -t C_CLAUSULA_BENEF BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.EMITIR_AUTOMAT.dump -U postgres -t EMITIR_AUTOMAT BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.EMITIR_BUZON.dump -U postgres -t EMITIR_BUZON BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.ENCUESTA.dump -U postgres -t ENCUESTA BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.ENCUESTA_OPC.dump -U postgres -t ENCUESTA_OPC BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.ENCUESTA_PREG.dump -U postgres -t ENCUESTA_PREG BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.ENCUESTA_RESP.dump -U postgres -t ENCUESTA_RESP BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.ENCUESTA_STAND.dump -U postgres -t ENCUESTA_STAND BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.ERROR.dump -U postgres -t ERROR BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.ESTADOS.dump -U postgres -t ESTADOS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.FERIADOS.dump -U postgres -t FERIADOS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.IMPUESTOS.dump -U postgres -t IMPUESTOS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.IMPUESTOS_ABM.dump -U postgres -t IMPUESTOS_ABM BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.INTERFASES.dump -U postgres -t INTERFASES BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.INTERFASE_MANUAL.dump -U postgres -t INTERFASE_MANUAL BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.LIBRO_AS400.dump -U postgres -t LIBRO_AS400 BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.MAIL.dump -U postgres -t MAIL BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.MAIL_AVISO_EMISION.dump -U postgres -t MAIL_AVISO_EMISION BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.MAIL_EMISION.dump -U postgres -t MAIL_EMISION BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.MAIL_RENUEVA.dump -U postgres -t MAIL_RENUEVA BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.MAIL_VALID.dump -U postgres -t MAIL_VALID BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.MANUALES.dump -U postgres -t MANUALES BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.MENU.dump -U postgres -t MENU BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.MONEDAS.dump -U postgres -t MONEDAS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.M_CTACTE.dump -U postgres -t M_CTACTE BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.NOVEDADES.dump -U postgres -t NOVEDADES BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.OPCION_AJUSTE.dump -U postgres -t OPCION_AJUSTE BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.OPCION_AJUSTE_DET.dump -U postgres -t OPCION_AJUSTE_DET BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.ORGANIZADORES.dump -U postgres -t ORGANIZADORES BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.PANEL.dump -U postgres -t PANEL BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.PARAMETROS.dump -U postgres -t PARAMETROS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.PERSONAS.dump -U postgres -t PERSONAS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.PLAN.dump -U postgres -t PLAN BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.PLAN_COSTO.dump -U postgres -t PLAN_COSTO BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.PLAN_PRODUCTOR.dump -U postgres -t PLAN_PRODUCTOR BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.PLAN_SUMAS.dump -U postgres -t PLAN_SUMAS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.PLAN_VIGENCIA.dump -U postgres -t PLAN_VIGENCIA BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.PROCEDENCIAS.dump -U postgres -t PROCEDENCIAS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.PRODUCTOS.dump -U postgres -t PRODUCTOS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.PRODUCTOR_COBERTURA.dump -U postgres -t PRODUCTOR_COBERTURA BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.PRODUCTOR_POR_ORG.dump -U postgres -t PRODUCTOR_POR_ORG BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.PRODUCTOR_CUOTAS.dump -U postgres -t PRODUCTOR_CUOTAS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.PRODUCTOR_MAIL.dump -U postgres -t PRODUCTOR_MAIL BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.PRODUCTOR_SETEOS.dump -U postgres -t PRODUCTOR_SETEOS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.PRODUCTOS_COB.dump -U postgres -t PRODUCTOS_COB BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.PRUEBAS.dump -U postgres -t PRUEBAS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.P_GRUPO.dump -U postgres -t P_GRUPO BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.RAMAS.dump -U postgres -t RAMAS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.RPT_PARAMETROS.dump -U postgres -t RPT_PARAMETROS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.RPT_REPORTES.dump -U postgres -t RPT_REPORTES BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.SUB_RAMAS.dump -U postgres -t SUB_RAMAS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.S_ASEGURADO.dump -U postgres -t S_ASEGURADO BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.S_BENEFICIARIOS.dump -U postgres -t S_BENEFICIARIOS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.S_COBERTURAS.dump -U postgres -t S_COBERTURAS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.S_ERRORES.dump -U postgres -t S_ERRORES BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.S_PROPUESTA.dump -U postgres -t S_PROPUESTA BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.S_TOMADOR.dump -U postgres -t S_TOMADOR BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.S_UBICACION_RIESGO.dump -U postgres -t S_UBICACION_RIESGO BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.S_CLAUSULA_BENEF.dump -U postgres -t S_CLAUSULA_BENEF BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.TABLAS.dump -U postgres -t TABLAS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.TARJETAS.dump -U postgres -t TARJETAS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.TASAS_CAUCION.dump -U postgres -t TASAS_CAUCION BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.TASA_MENSUAL.dump -U postgres -t TASA_MENSUAL BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.TASA_MENSUAL_ABM.dump -U postgres -t TASA_MENSUAL_ABM BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.TASA_PROVINCIAL.dump -U postgres -t TASA_PROVINCIAL BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.TASA_PROVINCIAL_ABM.dump -U postgres -t TASA_PROVINCIAL_ABM BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.TEMPLATE.dump -U postgres -t TEMPLATE BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.TEMPLATE_TABLA.dump -U postgres -t TEMPLATE_TABLA BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.TIPOS_ENDOSO.dump -U postgres -t TIPOS_ENDOSO BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.TIPOS_FORMA_PAGO.dump -U postgres -t TIPOS_FORMA_PAGO BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.TIPOS_MOVIMIENTO.dump -U postgres -t TIPOS_MOVIMIENTO BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.TRAMO.dump -U postgres -t TRAMO BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.TRAMO_ABM.dump -U postgres -t TRAMO_ABM BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.USUARIOS.dump -U postgres -t USUARIOS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.VIGENCIA.dump -U postgres -t VIGENCIA BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.VIGENCIA_DETALLE.dump -U postgres -t VIGENCIA_DETALLE BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.ZONAS.dump -U postgres -t ZONAS BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.Z_PROPUESTA_ENVIAR.dump -U postgres -t Z_PROPUESTA_ENVIAR BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.Z_PROPUESTA_RECIBIR.dump -U postgres -t Z_PROPUESTA_RECIBIR BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.Z_EMISION_BATCH.dump -U postgres -t Z_EMISION_BATCH BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.Z_EMISION_CONTROL.dump -U postgres -t Z_EMISION_CONTROL BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.Z_ERRORES_DET.dump -U postgres -t Z_ERRORES_DET BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.Z_PRELIQ.dump -U postgres -t Z_PRELIQ BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.Z_PRELIQ_BACK.dump -U postgres -t Z_PRELIQ_BACK BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.Z_PRELIQ_ERRORES.dump -U postgres -t Z_PRELIQ_ERRORES BENEF
pg_dump -h localhost -p 5432 -o -v -f benef.emision_mensual.dump -U postgres -t emision_mensual BENEF


tar -cvf back_postgres.tar /home/adrian/*.dump
gzip -9 back_postgres.tar
mv  back_postgres.tar.gz /mnt/part/
rm /home/adrian/*.dump

#para restaurar gzip -d fichero.gz   tar -xvf archivo.tar
#psql -h 127.0.0.1 -f benef.PRUEBAS.dump BENEF postgres
