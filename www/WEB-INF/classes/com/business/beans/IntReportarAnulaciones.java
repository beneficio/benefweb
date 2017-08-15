/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.business.beans;

import com.business.db.db;
import com.business.util.*;
import java.io.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.util.LinkedList;

/**
 *
 * @author Rolando Elisii
 */
public class IntReportarAnulaciones {

    public static void main(String[] args) throws Exception{
        Connection dbCon = null;
        String  _file ="/opt/tomcat/webapps/benef/propiedades/config.xml";//"./www/propiedades/config.xml";
        StringBuilder sMensaje = new StringBuilder();
        LinkedList lReg = null;
        CallableStatement cons  = null;
        ResultSet rs = null;
        boolean bExiste   = false;

        try {
            File config=new File(_file);
            if(!config.exists()){
                // ------------------------------------------------------------
                // En caso que si no toma los datos del config.xml
                // Configurar los Datos de conexion.
                // ------------------------------------------------------------

                System.out.println(" ********************************** ") ;
                System.out.println(" No se encontro el archivo config.xml") ;
                System.out.println(" ********************************** ") ;
                throw new SurException("NO SE ENCONTRO EL ARCHIVO config.xml");
            } else {
                db.realPath(config.getAbsolutePath()) ;
                dbCon = db.getConnection();
                System.out.println("*********************************************************************** ") ;
                System.out.println("* Se recupero informacion del archivo config.xml") ;
                System.out.println("*********************************************************************** ") ;
            }

            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("INT_CONTROLAR_ANULACIONES()"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.execute();

            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                sMensaje.append("Detalle de inconsistencias producidas en el proceso de carga masiva de la web. Este mensaje se ejecuta una vez por día.\n");
                int numPreliqAnt = 0;
                while (rs.next()) {
                    bExiste = true;
                    if (numPreliqAnt != rs.getInt ("NUM_PRELIQ")) {
                        sMensaje.append("---------------------------------------");
                        sMensaje.append("---------------------------------------\n\n");
                        numPreliqAnt = rs.getInt ("NUM_PRELIQ");
                    }
                    sMensaje.append ("Preliquidación N° ");
                    sMensaje.append (rs.getInt ("NUM_PRELIQ")).append (" - ESTADO: ").append(rs.getString("ESTADO")).append("\n");
                    sMensaje.append ("Productor: " ).append(rs.getString ("RAZON_SOCIAL")).append(" (").append(rs.getInt("COD_PROD")).append(") - ");
                    sMensaje.append (rs.getString("EMAIL") != null ? rs.getString("EMAIL") : " ");
                    sMensaje.append (" - Tel.: ").append(rs.getString ("TELEFONO1")).append(" - Oficina: ").append(rs.getString("DESC_OFICINA")).append("\n");
                    sMensaje.append ("SE ANULO LA POLIZA ").append(rs.getInt("COD_RAMA")).append("/").append(rs.getInt("NUM_POLIZA")).append(" Y TIENE COBRANZA RENDIDA DE LA CUOTA " );
                    sMensaje.append(rs.getInt("NUM_CUOTA")).append(" --> $ ").append(rs.getDouble("IMP_PREMIO_PESOS")).append("\n");
                }

                rs.close();
            }
            cons.close();

            if (bExiste) {
                sMensaje.append("Este es un mensaje automático generado por BENEFICIO WEB.\n");
                sMensaje.append("Cualquier duda o consulta puede comunicarse por este medio a relisii@beneficiosa.com.ar\n");

                Email oEmail = new Email ();

                oEmail.setSubject("PRELIQUIDACION WEB - INCONSISTENCIAS ");
                oEmail.setContent(sMensaje.toString());

                LinkedList lDest = oEmail.getDBDestinos(dbCon, 0, "PRELIQUIDACION_WEB");

                for (int i=0; i < lDest.size();i++) {
                    Persona oPers = (Persona) lDest.get(i);
                    oEmail.setDestination(oPers.getEmail());
                    oEmail.sendMessageBatch();
                }
            }


        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null ) dbCon.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            dbCon.close();;
        }
    }
}
