/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.business.batch;

import com.business.db.db;
import com.business.util.*;
import com.business.beans.GestionTexto;
import com.business.beans.Persona;
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
public class IntAvisoNoRenovadas {

    public static void main(String[] args) throws Exception{
        Connection dbCon = null;
        String  _file ="/opt/tomcat/webapps/benef/propiedades/config.xml";//"./www/propiedades/config.xml";
        StringBuilder sMensaje = new StringBuilder();
        CallableStatement cons  = null;
        CallableStatement cons2 = null;
        ResultSet rs = null;
        boolean bExisteError    = false;      
        int codTextoGestion   = 0;
        boolean _serverMailGmail = false;
        String sUrl = "http://www.beneficioweb.com.ar";

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
            cons = dbCon.prepareCall(db.getSettingCall("GET_PARAMETRO (?)"));
            cons.registerOutParameter(1, java.sql.Types.VARCHAR);
            cons.setString (2, "COD_TEXTO_AVISO_NO_RENOVADA");
            cons.execute();
            if (cons.getString(1) != null) {
                codTextoGestion = Integer.parseInt (cons.getString(1));
             }
            cons.close();

            System.out.println ("parametro recuperado " + codTextoGestion);

            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall("INT_AVISOS_NO_RENOVADA_PROCESAR ()"));
            cons.registerOutParameter(1, java.sql.Types.DOUBLE);
            cons.execute();
            double lote = cons.getDouble (1);
            cons.close ();

            if (lote == 0 ) {
System.out.println ("NO PROCESAR, EL LOTE ES CERO ");
            } else {
System.out.println ("LOTE A PROCESAR: " + lote);

                 GestionTexto oCab = new GestionTexto();
                 oCab.setCodTexto( codTextoGestion);
                 oCab.getDB(dbCon);
                 if (oCab.getCodError() < 0) {
                     throw new SurException(oCab.getMensajeError());
                 }

                dbCon.setAutoCommit(false);
                cons = dbCon.prepareCall(db.getSettingCall("INT_AVISOS_NO_RENOVADA_ENVIO (?,?,?,?,?,?,?)"));
                cons.registerOutParameter(1, java.sql.Types.OTHER);
                cons.setInt    (2, oCab.getCodTexto());
                cons.setInt    (3, oCab.getCodTemplate());
                cons.setString (4, oCab.getTexto());
                cons.setString (5, oCab.getFirma());
                cons.setString (6, sUrl);
                cons.setString (7, oCab.gettitulo());
                cons.setDouble (8, lote);


                cons.execute();
                rs =  (ResultSet) cons.getObject(1);
                String sErrorEnvio;
                boolean bError = false;
                int cantMail = 0;

                if (rs != null ) {
                    while (rs.next()) {
                        sErrorEnvio  = null;
                        bError = false;
                        Email mail = new Email();

                        // ------------------------------
                        // Configuracion Local mail Gmail
        //                if (_serverMailGmail){
        //                    mail.setEnableStarttls(true);
        //                }

                        if (rs.getString ("EMAIL") == null || rs.getString ("BODY") == null ||
                            rs.getString("PRODUCTOR") == null  ) {
                            sErrorEnvio = " DATOS NULOS ";
                            bError = true;
                            bExisteError = true;
                        } else {
                            mail.setSource(oCab.getRemitente());
                            if (oCab.getuserMail() != null) {
                                mail.setUser(oCab.getuserMail());
                            }
                            if (oCab.getpassMail() != null) {
                                mail.setPassword(oCab.getpassMail());
                            }

                            mail.setDestination(rs.getString ("EMAIL"));

                            if (oCab.getCCO() != null ) {
                                mail.setCCO(oCab.getCCO());
                            }

                            mail.setSubject("BENEFICIO S.A. - " + oCab.gettitulo() + " - " + rs.getString("PRODUCTOR") + " (" + rs.getString("COD_PROD") + ")" );
                            mail.addContent(rs.getString ("BODY"));
                            mail.addCID("cidimage01", "/opt/tomcat/webapps/benef/images/template/tem44.jpg");

                            try {
                                mail.sendMultipart(); //Message("text/html");
                                cantMail = cantMail + 1;
                                System.out.println ("MAIL ENVIADO " + cantMail + " --> " + rs.getString ("EMAIL") );
                            } catch ( Exception eMail) {
                                bError = true;
                                sErrorEnvio  = eMail.getMessage();
                                bExisteError = true;
                                System.out.println ("ERROR " + cantMail + " --> " + eMail.getMessage());
                            }
                        }
                            try {
                                dbCon.setAutoCommit(true);
                                cons2 = dbCon.prepareCall(db.getSettingCall("INT_AVISOS_NO_RENOVADA_GRABAR (?,?,?,?)"));
                                cons2.registerOutParameter(1, java.sql.Types.INTEGER );
                                cons2.setDouble (2, lote);
                                cons2.setInt    (3,rs.getInt ("COD_PROD"));
                                cons2.setString (4, (bError == true ? "ERROR" : "OK"));
                                cons2.setString (5,sErrorEnvio);
                                cons2.execute();

                                cons2.close ();
                           } catch (SQLException se) {
                                throw new SurException("ERROR EN INT_AVISOS_NO_RENOVADA_GRABAR: " + se.getMessage());
                           }
                        }
                        rs.close ();
                    }

                System.out.println ("cantidad de mail enviados: " + cantMail);
                
                    cons.close ();

                    if (bExisteError) {
                        sMensaje.append("Este es un mensaje automático generado por BENEFICIO WEB.\n\n");

                        dbCon.setAutoCommit(false);
                        cons = dbCon.prepareCall(db.getSettingCall("INT_AVISOS_NO_RENOVADA_LISTAR (?)"));
                        cons.registerOutParameter(1, java.sql.Types.OTHER);
                        cons.setDouble (2, lote);


                        cons.execute();
                        rs =  (ResultSet) cons.getObject(1);
                        if (rs != null) {
                            sMensaje.append("RAMA\tPOLIZA\tENDOSO\tPRODUCTOR\tMAIL\tRECHAZO\n");
                            while (rs.next()){
                                sMensaje.append(rs.getString ("RAMA")).append("\t");
                                sMensaje.append(rs.getInt ("NUM_POLIZA")).append("\t");
                                sMensaje.append(rs.getInt ("ENDOSO")).append("\t");
                                sMensaje.append(rs.getString ("PRODUCTOR")).append("\t");
                                sMensaje.append(rs.getString ("EMAIL")).append("\t");
                                sMensaje.append(rs.getString ("OBSERVACIONES")).append("\n");
                            }
                            rs.close ();
                        }
                        cons.close ();

                        Email oEmail = new Email ();

                        oEmail.setSubject("AVISOS DE EMISION - RECHAZOS ");
                        oEmail.setContent(sMensaje.toString());

                        LinkedList lDest = oEmail.getDBDestinos(dbCon, 0, "AVISO_EMISION");

                        for (int i=0; i < lDest.size();i++) {
                            Persona oPers = (Persona) lDest.get(i);
                            oEmail.setDestination(oPers.getEmail());
                            oEmail.sendMessageBatch();
                            //oEmail.sendMessage ();
                        }
                    }
                 }
            }
            catch (Exception e) {
                throw new SurException (e.getMessage());
            } finally {
                try {
                    if (rs != null ) rs.close() ;
                    if (cons != null ) cons.close();
                } catch (SQLException se) {
                    throw new SurException (se.getMessage());
                }
                dbCon.close();;
            }
    }
}
