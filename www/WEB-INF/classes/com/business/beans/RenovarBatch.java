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
public class RenovarBatch {

    public static void main(String[] args) throws Exception{
        Connection dbCon = null;
        String  _file ="/opt/tomcat/webapps/benef/propiedades/config.xml";//"./www/propiedades/config.xml";
        String  _fileRenovar ="/opt/tomcat/webapps/benef/files/renovar/renovar.csv";
        String  _fileLog     ="/opt/tomcat/webapps/benef/files/renovar/renovar_log.csv";
        String  separador    = ";";
        StringBuilder sMensaje = new StringBuilder();
        LinkedList lReg = null;
        CallableStatement cons  = null;
        ResultSet rs = null;
        boolean bExiste   = false;
        FileWriter fw = null;
        BufferedWriter bw = null;
        PrintWriter  salida = null;
        FileReader fr = null;
        BufferedReader br = null;

        try {
           fw = new FileWriter( _fileLog );
           bw = new BufferedWriter(fw);
           salida = new PrintWriter(bw);

            File config=new File(_file);
            if(!config.exists()){
                // ------------------------------------------------------------
                // En caso que si no toma los datos del config.xml
                // Configurar los Datos de conexion.
                // ------------------------------------------------------------
                salida.println(" ********************************** ") ;
                salida.println(" No se encontro el archivo config.xml") ;
                salida.println(" ********************************** ") ;
                throw new SurException("NO SE ENCONTRO EL ARCHIVO config.xml");
            } else {
                db.realPath(config.getAbsolutePath()) ;
                dbCon = db.getConnection();
            }

            File fRenovar = new File(_fileRenovar );
            if(!fRenovar.isFile()){
                salida.println(" ************************************** ");
                salida.println(" No se encontro el archivo renovar.csv ");
                salida.println(" ************************************** ");
                throw new SurException("NO SE ENCONTRO EL ARCHIVO renovar.csv");
            }
            fr = new FileReader (fRenovar);
            br = new BufferedReader(fr);

         // Lectura del fichero
            String linea;
            int nLinea = 0;
            while((linea=br.readLine())!=null) {
                nLinea = nLinea + 1;
                String [] datos = linea.split (";") ;
                String sError = "OK";
                boolean bError =false;

                if (! datos[0].equals ("10") &&
                    ! datos[0].equals ("18") &&
                    ! datos[0].equals ("21") &&
                    ! datos[0].equals ("22") &&
                    ! datos[0].equals ("23") &&
                    ! datos[0].equals ("25")  ) {
                    if (nLinea == 1) {
                         salida.println (linea + separador + "NUM_PROPUESTA_ACTUAL" +
                                 separador + "PREMIO_ACTUAL" + separador +
                                 "FACT_ACTUAL" + separador + "CANT_CUOTAS_ACTUAL"+ separador + "CANT_VIDAS_ACTUAL" + separador + "ESTADO");
                        continue;
                    } else {
                        bError = true;
                        sError =  "LA PRIMERA COLUMNA NO ES UNA RAMA VALIDA";
                    }
                }

                int iNumPropuesta = 0;
                double premioActual = 0;
                int factActual = 0;
                int cantCuotasActual = 0;
                int cantVidasActual  = 0;
                try {
                    dbCon.setAutoCommit(true);
                    cons = dbCon.prepareCall(db.getSettingCall("REN_SET_RENOVACION  (?,?,?,?,?,?)"));
                    cons.registerOutParameter(1, java.sql.Types.INTEGER);
                    cons.setInt (2, Integer.parseInt (datos[0]));
                    cons.setInt (3, Integer.parseInt (datos[1]));
                    cons.setInt (4, Integer.parseInt (datos[2]));
                    cons.setInt (5, 0);
                    cons.setString (6, "BA");
                    cons.setString (7, "WEB");

                    cons.execute();
                    iNumPropuesta = cons.getInt(1);

                    cons.close();

                } catch (SQLException se){
                    bError = true;
                    sError =  se.getMessage();
                }

                if (!bError) {
                    if (iNumPropuesta > 0) {
                        // enviar propuesta
                        Propuesta oProp = new Propuesta ();
                        oProp.setNumPropuesta( iNumPropuesta);

                        oProp.getDB(dbCon);
                        premioActual = oProp.getImpPremio();
                        factActual = oProp.getCodFacturacion();
                        cantCuotasActual = oProp.getCantCuotas();
                        cantVidasActual  = oProp.getCantVidas();

                        oProp.setUserid      ("BATCH");
                        oProp.setCodEstado   ( 1 );

                        oProp.setDBEstado(dbCon);

                        if (oProp.getCodError() < 0) {
                            sError = ConsultaMaestros.getdescError(dbCon, oProp.getCodError(), "PROPUESTA");
                            if (sError == null || sError.equals ("")) {
                                sError = oProp.getDescError();
                            }
                            bError = true;
                        }
                    } else {
                        bError = true;
                        sError = ConsultaMaestros.getdescError(dbCon, iNumPropuesta, "RENOVACIONES");
                    }
                }
                 salida.println (linea + separador + iNumPropuesta + separador + premioActual + separador +
                         factActual + separador + cantCuotasActual + separador + cantVidasActual + separador + sError);
            }

            fr.close();
/*
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
*/
        // Renombramos el archivo de entrada.
        fRenovar.renameTo ( new File (_fileRenovar + ".OK"));

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            if (salida != null) salida.close();
            if (bw != null) bw.close();
            if (fw != null) fw.close();
            try {
                if (rs != null ) dbCon.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            dbCon.close();
        }
    }
}
