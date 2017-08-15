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
import java.sql.ResultSet;
import java.util.LinkedList;

/**
 *
 * @author Rolando Elisii
 */
public class EnviarCopiaPoliza {

  private static int getNumSecuInfo (Connection dbCon) throws SurException {
       CallableStatement cons  = null;
       int lote  = 0;
       try {

           dbCon.setAutoCommit(true);
           cons = dbCon.prepareCall(db.getSettingCall("GET_NUM_SECU_INFO ()"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.execute();

           lote = cons.getInt(1);

       } catch (Exception e) {
            throw new SurException (e.getMessage());

        } finally {
            try {
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            return lote;
        }
    }

    private static String getProgramaDC (Connection dbCon, String sOperacion )
            throws SurException {
       CallableStatement cons  = null;

       try {
           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall(db.getSettingCall("GET_TABLAS_DESCRIPCION (?, ?)"));
           cons.registerOutParameter(1, java.sql.Types.VARCHAR);
           cons.setString (2, "PROGRAMA_DC");
           cons.setString (3, sOperacion);
           cons.execute();

           return cons.getString (1);
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
    }

    private static void CreateFile (Connection dbCon,
                                  String sOperacion,
                                  LinkedList lParams,
                                  String sFile )
            throws SurException {

/* Operaciones posibles:
"POLIZA"
"CUPON"
"PRELIQ"
"CTACTE"
"LIQUI"
"RENOPEN"
"COMIS"
*/
        FileOutputStream fos = null;
        OutputStreamWriter osw = null;
        BufferedWriter bw = null;

        try {
           fos = new FileOutputStream ( sFile );
           osw = new OutputStreamWriter (fos, "8859_1");
           bw = new BufferedWriter (osw);

           for (int i=0; i < lParams.size();i++) {
                bw.write( (String) lParams.get(i) + "\n");
           }

            bw.flush();
            bw.close();
            osw.close();
            fos.close();
        } catch (Exception e) {
            throw new SurException ("CreateFile:" + e.getMessage());
        } finally {
            try {
                bw.close();
                osw.close();
                fos.close();
            } catch (IOException ee) {
                throw new SurException (ee.getMessage());
            }
        }
    }

    public static void main(String[] args) throws Exception{
        Connection dbCon = null;
        String  _file ="/opt/tomcat/webapps/benef/propiedades/config.xml";//"./www/propiedades/config.xml";
        StringBuilder sMensaje = new StringBuilder();
        CallableStatement cons  = null;
        CallableStatement cons2 = null;
        ResultSet rs = null;
        boolean bExisteError    = false;
        String sTipoMens  = "";
        String sTipoMens2 = "";
        String sMens      = "";
        String sMensa     = new String ();
        boolean _serverMailGmail = false;
        String sUrl = "http://www.beneficioweb.com.ar";
        double iLote = 0;
        String sFile    = "/opt/tomcat/webapps/benef/files/dc/";
        int cantMail    = 0;
        int cantErrores = 0;


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

            if (args.length != 0) {
                iLote = Double.parseDouble (args [0]);
            }

            System.out.println ("LOTE A PROCESAR: " + iLote);

            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("MAIL_GET_ALL_COPIA_POLIZA (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setDouble (2, iLote);

            cons.execute();
            rs =  (ResultSet) cons.getObject(1);
            String sErrorEnvio;
            boolean bError = false;

            if (rs != null ) {
                while (rs.next()) {
                    sErrorEnvio  = null;
                    Email mail = new Email();

                    // ------------------------------
                    // Configuracion Local mail Gmail
                    if (_serverMailGmail){
                        mail.setEnableStarttls(true);
                    }

                    if (rs.getString ("EMAIL") == null  ) {
                        sErrorEnvio = "NO EXISTE EMAIL ";
                        bError = true;
                        bExisteError = true;
                    } else {
                        try {
                            String sFileSec = sFile + "poliza." + getNumSecuInfo (dbCon);
                            LinkedList lParams = new LinkedList();

                            lParams.add ("PROGRAMA=" + getProgramaDC (dbCon, "POLIZA" ));
                            lParams.add ("COMPAN=16");

                            lParams.add ("SECION=" + rs.getInt ("COD_RAMA"));
                            lParams.add ("POLIZA=" + Formatos.formatearCeros(String.valueOf(rs.getInt ("NUM_POLIZA")),7)) ;
                            lParams.add ("OPERAC=1");
                            lParams.add ("ENDOSO=" + Formatos.formatearCeros(String.valueOf(rs.getInt ("ENDOSO")),6)) ;
                            lParams.add ("POLCUO=CP");
                            lParams.add ("EMAILS=" + rs.getString ("EMAIL"));

                            CreateFile(dbCon, "POLIZA", lParams, sFileSec  );

                            Parametro oParam = new Parametro();
                            oParam.setsCodigo("DC_CLIENT_COMANDO");
                            String sCommand = oParam.getDBValor(dbCon);
                            
                            oParam.setsCodigo("DC_CLIENT_SERVER");
                            String sServer = oParam.getDBValor(dbCon);
                            
                            // Execute a command with an argument that contains a space
                            String[] commands = new String[]{sCommand , sFileSec, sServer };

                            Thread.sleep(750);

                            Process child = Runtime.getRuntime().exec(commands);

                            // Se obtiene el stream de salida del programa
                            InputStream is = child.getInputStream();

                            /* Se prepara un bufferedReader para poder leer la salida más comodamente. */
                            BufferedReader br = new BufferedReader (new InputStreamReader (is));

                            // Se lee la primera linea
                            String aux = br.readLine();
                            sTipoMens =  aux.substring (0,2);
                            sTipoMens2 = aux.substring (0,8);
                            sMens     = aux.substring(3);
                        } catch (Exception e) {
                            sTipoMens = "ER";
                            sMens     = e.getMessage();
                        }

                        try {
                            dbCon.setAutoCommit(true);
                            cons2 = dbCon.prepareCall(db.getSettingCall("MAIL_UPD_COPIA_POLIZA (?,?,?,?,?,?,?)"));
                            cons2.registerOutParameter(1, java.sql.Types.DOUBLE );
                            cons2.setInt (2, rs.getInt ("COD_RAMA"));
                            cons2.setInt (3, rs.getInt ("NUM_POLIZA"));
                            cons2.setInt (4, rs.getInt ("ENDOSO"));
                            cons2.setDouble (5, rs.getDouble ("NUM_SECU_ENVIO_MAIL") );
                            cons2.setString (6, "CP");
                            cons2.setString (7, "BATCH");
                            if ( sTipoMens.equals("ER") || sTipoMens2.equals("MSGERROR") ){

                               System.out.println ("entro por error");

                                cantErrores = cantErrores + 1;
                                cons2.setString (8, sMens );
                            } else {
                                cantMail = cantMail + 1;
                                System.out.println ("entro por ok - lote : " + rs.getDouble ("NUM_SECU_ENVIO_MAIL"));
                                cons2.setNull (8, java.sql.Types.VARCHAR);
                            }

                            cons2.execute();

                            iLote = cons2.getDouble(1);

                            cons2.close ();
                       } catch (SQLException se) {
                            throw new SurException("ERROR EN INT_AVISOS_EMISION_GRABAR: " + se.getMessage());
                       }
                    }
                }

                rs.close ();
                System.out.println ("cantidad de mail enviados: " + cantMail);
                System.out.println ("cantidad de mail erroneoas: " + cantErrores);
/*
                if (bExisteError) {
                        sMensaje.append("Este es un mensaje automático generado por BENEFICIO WEB.\n\n");

                        dbCon.setAutoCommit(false);
                        cons = dbCon.prepareCall(db.getSettingCall("INT_AVISOS_EMISION_LISTAR (?)"));
                        cons.registerOutParameter(1, java.sql.Types.OTHER);
                        cons.setDouble (2, iLote);


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
               */
                 }

               cons.close ();

            }
            catch (Exception e) {
                throw new SurException (e.getMessage());
            } finally {
                try {
                    if (rs != null ) rs.close() ;
                    if (cons != null ) cons.close();
                    if (cons2 != null ) cons2.close();
                } catch (SQLException se) {
                    throw new SurException (se.getMessage());
                }
                dbCon.close();;
            }
    }
}
