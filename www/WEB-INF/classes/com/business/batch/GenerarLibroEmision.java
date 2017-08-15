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
import com.business.beans.ProcesarReportes;

/**
 *
 * @author Rolando Elisii
 */
public class GenerarLibroEmision {

  
    private static void CreateFile (Connection dbCon,
                                  String sOperacion,
                                  LinkedList lParams,
                                  String sFile )
            throws SurException {
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
        String sCommand =  "/root/convertFile.bat";


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

            String mesAnio  =  "";

            if (args.length != 0) {
                mesAnio = args [0];
            }

            System.out.println ("ANIO MES A PROCESAR: " + mesAnio);

            String sFileEmision = "/opt/tomcat/webapps/benef/files/trans/EMI" + mesAnio + ".TXT";
            String sFileOblig   = "/opt/tomcat/webapps/benef/files/trans/EMIOBLI" + mesAnio + ".TXT";

            // Execute a command with an argument that contains a space
            String[] commands = new String[]{sCommand , sFileEmision };

            Process child = Runtime.getRuntime().exec(commands);

            // Se obtiene el stream de salida del programa
            InputStream is = child.getInputStream();

            // Se prepara un bufferedReader para poder leer la salida más comodamente.
            BufferedReader br = new BufferedReader (new InputStreamReader (is));

            // Se lee la primera linea
System.out.println (br.readLine());

            // Execute a command with an argument that contains a space
            String[] commands2 = new String[]{sCommand , sFileOblig };

            Process child2 = Runtime.getRuntime().exec(commands2);

            // Se obtiene el stream de salida del programa
            InputStream is2 = child2.getInputStream();

            // Se prepara un bufferedReader para poder leer la salida más comodamente.
            BufferedReader br2 = new BufferedReader (new InputStreamReader (is2));

            // Se lee la primera linea
System.out.println (br2.readLine());

            try {
                dbCon.setAutoCommit(true);
                cons = dbCon.prepareCall(db.getSettingCall("BORRADOR_CARGAR_EMISION_MENSUAL (?, ?)"));
                cons.registerOutParameter(1, java.sql.Types.INTEGER);
                cons.setInt  (2, Integer.parseInt (mesAnio));
                cons.setInt (3, 99 );  // procesa todas las ramas menos Obligatorio

                cons.execute();
                int insertados99  = cons.getInt(1);
                
                System.out.println ("Insertados todas las ramas: " + insertados99 );
                
                if (insertados99 > 0 ) {
                   LinkedList lReportes = ProcesarReportes.getAllReportes (dbCon, 16, "S", "BATCH");
                   if (lReportes.size() > 0) {
                       ProcesarReportes.ProcesarReporte (dbCon, lReportes);
                    }
                   lReportes = ProcesarReportes.getAllReportes (dbCon, 17, "S", "BATCH");
                   if (lReportes.size() > 0) {
                       ProcesarReportes.ProcesarReporte (dbCon, lReportes);
                    }
                }

            } catch (Exception e ) {
                System.out.println ("Error en el proceso de Todas las ramas" + e.getMessage() );
            } finally {
                cons.close ();
            }

            try {
                dbCon.setAutoCommit(true);
                cons = dbCon.prepareCall(db.getSettingCall("BORRADOR_CARGAR_EMISION_MENSUAL (?, ?)"));
                cons.registerOutParameter(1, java.sql.Types.INTEGER);
                cons.setInt  (2, Integer.parseInt (mesAnio));
                cons.setInt (3, 21 );  // procesa  Obligatorio

                cons.execute();
                int insertados21  = cons.getInt(1);

                System.out.println ("Insertados Vida obligatorio: " + insertados21 );

                if (insertados21 > 0 ) {
                   LinkedList lReportes = ProcesarReportes.getAllReportes (dbCon, 18, "S", "BATCH");
                   if (lReportes.size() > 0) {
                       ProcesarReportes.ProcesarReporte (dbCon, lReportes);
                    }
                   lReportes = ProcesarReportes.getAllReportes (dbCon, 19, "S", "BATCH");
                   if (lReportes.size() > 0) {
                       ProcesarReportes.ProcesarReporte (dbCon, lReportes);
                    }
                }


            } catch (Exception e ) {
                System.out.println ("Error en procesar Vida Obligatorio " + e.getMessage() );
            }

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
