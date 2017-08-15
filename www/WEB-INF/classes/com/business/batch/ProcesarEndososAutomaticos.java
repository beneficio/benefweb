/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.business.batch;

import com.business.db.db;
import com.business.util.*;
import java.io.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import com.business.beans.Persona;
import com.business.beans.ProcesarReportes;
import java.util.LinkedList;

/**
 *
 * @author Rolando Elisii
 */
public class ProcesarEndososAutomaticos {
        
    public static void main(String[] args) throws Exception{
        Connection dbCon = null;
        String  _file ="/opt/tomcat/webapps/benef/propiedades/config.xml";//"./www/propiedades/config.xml";
        String  nomFile = "endososCambioCondComercial.zip";
        String _path_file = "/opt/tomcat/webapps/benef/files/trans";
        String  _file_afip = _path_file + "/" + nomFile;
        StringBuilder sMensaje = new StringBuilder();
        CallableStatement cons  = null;
        boolean bExisteError    = false;
        String sTipoMens  = "";
        boolean _serverMailGmail = false;
        int numLote        = 198;
        int cantProcesados = 0;
        int cantEmitidas   = 0;
        int cantOk         = 0;
        int cantError      = 0;
        
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

            try { 
                dbCon.setAutoCommit(true);
                cons = dbCon.prepareCall ( "{ call \"BENEF\".\"EMI_BATCH_SET_ENDOSOS_1304\" (?,?,?,?,?,?)}");
                cons.setString (1, "P");                
                cons.registerOutParameter(2, java.sql.Types.INTEGER);
                cons.registerOutParameter(3, java.sql.Types.INTEGER);
                cons.registerOutParameter(4, java.sql.Types.INTEGER);
                cons.registerOutParameter(5, java.sql.Types.INTEGER);
                cons.registerOutParameter(6, java.sql.Types.INTEGER);
                
                cons.execute();

                numLote = cons.getInt(2);
                cantProcesados = cons.getInt(3);
                cantEmitidas   = cons.getInt(4);
                cantOk         = cons.getInt(5);
                cantError      = cons.getInt(6);

                System.out.println ("NUM_LOTE : " + cons.getInt(2));
                System.out.println ("CANT_PROCESADOS : " + cons.getInt(3));
                System.out.println ("CANT_PROP_EMITIDAS: " + cons.getInt(4));
                System.out.println ("CANT_PROP_OK: " + cons.getInt(5));
                System.out.println ("CANT_PROP_ERROR: " + cons.getInt(6));

            } catch (SQLException se ) {
                throw new Exception(se.getMessage());
            } finally {
                cons.close ();
            }

            if (numLote > 0 ) {
                LinkedList lReportes = ProcesarReportes.getAllReportes (dbCon, 114 , "D","BATCH");

                if (lReportes.size() > 0) {
                   ProcesarReportes.ProcesarReporte(dbCon, lReportes);
                }
                
                String from     = "webmaster@beneficio.com.ar";
                boolean debug   = false;
                Email mail = new Email();

                // ------------------------------
                // Configuracion Local mail Gmail
                if ( _serverMailGmail ) {
                    mail.setEnableStarttls(true);
                }
                mail.setSource      (from);
                String subject  = "Beneficio Web - EMISION BATCH DE ENDOSOS DE CAMBIO DE CONDICIONES COMERCIALES";

                sMensaje.delete(0, sMensaje.length());
                sMensaje.append("Se proceso la emision batch de propuestas de endosos de cambio de condiciones comerciales.  <br/><br/>");
                sMensaje.append("Fecha de Proceso: " ).append(Fecha.showFechaForm(new java.util.Date())).append("<br/><br/>");
                sMensaje.append ("Numero de Lote:     " + numLote).append("<br/>");
                sMensaje.append ("Polizas procesadas: " + cantProcesados).append("<br/>");
                sMensaje.append ("Propuestas emitidas:" + cantEmitidas).append("<br/>");
                sMensaje.append ("Propuestas OK:      " + cantOk).append("<br/>");
                sMensaje.append ("Propuestas  ERROR:  " + cantError ).append("<br/><br/>");

                sMensaje.append ("Se dispar&oacute; un mail con el lote de propuestas emitidas.<br/>");
                sMensaje.append ("El archivo es compartido/Reportes/lote_emision_batch_lll_ddmmyyy.csv donde lll es el lote y ddmmyyyy es la fecha de proceso.<br/>");
                sMensaje.append ("Controlar desde el m&oacute;dulo de Emisi&oacute;n Batch ingresando con el n&uacute;mero de lote.<br/>");
                sMensaje.append ("Las propuestas est&aacute;n enviadas, por lo tanto se emitir&aacute;n autom&aacute;ticamente a la noche<br/>");
                
                mail.setSubject     (subject);
                mail.addContent     (sMensaje.toString());
                LinkedList lDest = mail.getDBDestinos(dbCon, 0, "ENDOSOS_BATCH");            
                for (int i=0; i < lDest.size();i++) {
                    Persona oPers = (Persona) lDest.get(i);
                    mail.setDestination(oPers.getEmail());
                    mail.sendMultipart(); //Message("text/html");
                }
            }
        } catch (SQLException e ) {
            throw new Exception(e.getMessage());
        }
    }
}
