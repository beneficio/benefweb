/*
 * IntCotizador.java
 *
 * Created on 30 de mayo de 2006, 09:46
 */

package com.business.beans;

import java.io.*;
import java.net.URLConnection;
import java.util.LinkedList;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import com.business.util.*;
import com.business.db.*;

/**
 *
 * @author Rolando Elisii
 */
public class IntPropuestasPhpDC {

    /** Creates a new instance of IntCotizador */
    public IntPropuestasPhpDC() {
    }
    
    /**
     * @param args the command line arguments
     */
    
    public int intPropuestasManual (Connection dbCon) throws SurException {
        int lote = 0;
        int cant = 0;
        try {
          int iOk = actualizarTablaInterfases (dbCon, "INI", cant);

          if ( iOk == 0 ) {
                lote = intIniPropuestas(dbCon, "OL");
                if (lote > 0) {
                    intPropuesta  (dbCon, lote);

                    intTomador    (dbCon, lote);

                    intAsegurado  (dbCon, lote);

                    intCobertura (dbCon, lote);

                    intUbicacionRiesgo (dbCon, lote);

                    intEmpresasClausulas(dbCon, lote);
               }
            }
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            return lote;
        }
    }
    
    public int intActividadManual (Connection dbCon) throws SurException {
        int lote = 0;
        try {
            lote = intIniActividad(dbCon);
            
            intActividadCategoria (dbCon, lote);
        
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            return lote;
        }
    }

    public void intFinInterfaceManual (int lote, Connection dbCon) throws SurException {
        int cant = 0;
        try {
            cant = intFinPropuestas (dbCon, lote);
            
            int iOk = actualizarTablaInterfases (dbCon, "FIN", cant);
        
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } 
    }
    
    private static int intIniPropuestas (Connection dbCon, String sTipoEmision) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       int lote  = 0;
       try {
           
           dbCon.setAutoCommit(true);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_PRO_IDA_INICIO_NEW\" (?)}");
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setString (2, sTipoEmision);
           cons.execute();
        
           lote = cons.getInt(1);

       } catch (Exception e) {
            throw new SurException ("PINCHO EN intIniPropuestas: " + e.getMessage());
           
        } finally {
            try {
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            return lote;
        }
    }

    private static int intIniActividad (Connection dbCon) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       int lote  = 0;
       try {
           
           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_NUM_LOTE_ENVIO\" ()}");
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
    
    private static int intFinPropuestas (Connection dbCon, int lote) throws SurException {
       CallableStatement cons  = null;
       int retorno = 0;
       try {
           dbCon.setAutoCommit(true);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_PRO_IDA_FINAL\" (?)}");
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt (2, lote);
           
           cons.execute();
        
           retorno = cons.getInt (1);
           
       } catch (Exception e) {
            throw new SurException ( "PINCHO EN intFinPropuestas: " + e.getMessage());
           
        } finally {
            try {
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            return retorno;
        }
    }
    
    private static int actualizarTablaInterfases  (Connection dbCon, String secuencia, int cant)
       throws SurException {
       CallableStatement cons  = null;
       int retorno = 0;
       try {

           dbCon.setAutoCommit(true);           
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_SET_TABLA_INTERFASE\" (?, ? ,? ,? ,?)}");
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           
           cons.setString (2, "PROPUESTAS");
           cons.setNull   (3, java.sql.Types.DATE);
           cons.setString (4, secuencia);
           cons.setInt    (5, cant);
           cons.setString (6, "PROPUESTAS (WEB --> AS400)"); 

           cons.execute();
          
           retorno = cons.getInt(1);

        } catch (Exception e) {
            throw new SurException ("PINCHO EN actualizarTablaInterfases: " + e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
        return retorno;
    }
    
    private static void intPropuesta (Connection dbCon, int lote) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       try {
           FileOutputStream fos = new FileOutputStream (getPathFile(dbCon,"PROPUESTA") + Formatos.formatearCeros(String.valueOf(lote), 6) );
           OutputStreamWriter osw = new OutputStreamWriter (fos); //, "8859_1");
           BufferedWriter bw = new BufferedWriter (osw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_PRO_IDA_PROPUESTA_NEW\" (?, ?)}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt (2, lote);
           cons.setInt (3, 0);
           cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
           if (rs != null) {
                while (rs.next()) {
                    bw.write(rs.getString ("CAMPO"));
                    System.out.println (rs.getString ("CAMPO"));
                }
                rs.close();
            }
            
            bw.flush();
            bw.close();
            osw.close();
            fos.close();
        } catch (Exception e) {
            throw new SurException ("PINCHO EN intPropuesta: " + e.getMessage());
           
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
    }

    private static void intTomador (Connection dbCon, int lote) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       try {
           FileOutputStream fos = new FileOutputStream (getPathFile(dbCon,"TOMADOR") +
                   Formatos.formatearCeros(String.valueOf(lote), 6) );
           OutputStreamWriter osw = new OutputStreamWriter (fos); //, "8859_1");
           BufferedWriter bw = new BufferedWriter (osw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_PRO_IDA_TOMADOR_NEW\" (?,?)}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, lote);
           cons.setInt (3, 0);
           cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
           if (rs != null) {
                while (rs.next()) {
                    bw.write(rs.getString ("CAMPO"));
                    System.out.println (rs.getString ("CAMPO"));
                }
                rs.close();
            }
            
            bw.flush();
            bw.close();
            osw.close();
            fos.close();
        } catch (Exception e) {
            throw new SurException ("PINCHO EN intTomador: " + e.getMessage());
           
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
    }

    private static void intAsegurado (Connection dbCon, int lote) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       try {
           FileOutputStream fos = new FileOutputStream (getPathFile(dbCon,"ASEGURADO") +
                   Formatos.formatearCeros(String.valueOf(lote), 6));
           OutputStreamWriter osw = new OutputStreamWriter (fos); // "8859_1");
           BufferedWriter bw = new BufferedWriter (osw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_PRO_IDA_ASEGURADO_NEW\" (?,?)}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, lote);
           cons.setInt (3, 0);
           cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
           if (rs != null) {
                while (rs.next()) {
                    bw.write(rs.getString ("CAMPO"));
                    System.out.println (rs.getString ("CAMPO"));
                }
                rs.close();
            }
            
            bw.flush();
            bw.close();
            osw.close();
            fos.close();
        } catch (Exception e) {
            throw new SurException ("PINCHO EN intAsegurado: " + e.getMessage());
           
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
    }

    private static void intUbicacionRiesgo (Connection dbCon, int lote) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       try {
           FileOutputStream fos = new FileOutputStream (getPathFile(dbCon,"UBICACION") +
                   Formatos.formatearCeros(String.valueOf(lote), 6) );
           OutputStreamWriter osw = new OutputStreamWriter (fos); // "8859_1");
           BufferedWriter bw = new BufferedWriter (osw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_PRO_IDA_UBICACION_RIESGO_NEW\" (?,?)}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, lote);
           cons.setInt (3, 0);
           cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
           if (rs != null) {
                while (rs.next()) {
                    bw.write(rs.getString ("CAMPO"));
                    System.out.println (rs.getString ("CAMPO"));
                }
                rs.close();
            }
            
            bw.flush();
            bw.close();
            osw.close();
            fos.close();
        } catch (Exception e) {
            throw new SurException ("PINCHO EN intUbicacionRiesgo: " + e.getMessage());
           
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
    }


    private static void intCobertura (Connection dbCon, int lote) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       try {
           FileOutputStream fos = new FileOutputStream (getPathFile(dbCon,"COBERTURAS") +
                   Formatos.formatearCeros(String.valueOf(lote), 6) );
           OutputStreamWriter osw = new OutputStreamWriter (fos); //, "8859_1");
           BufferedWriter bw = new BufferedWriter (osw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_PRO_IDA_COBERTURAS_NEW\" (?,?)}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, lote);
           cons.setInt (3, 0);
           cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
           if (rs != null) {
                while (rs.next()) {
                    bw.write(rs.getString ("CAMPO"));
                    System.out.println (rs.getString ("CAMPO"));
                }
                rs.close();
            }
            
            bw.flush();
            bw.close();
            osw.close();
            fos.close();
        } catch (Exception e) {
            throw new SurException ("Pincho en IntCoberturas: " +  e.getMessage());
           
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
    }
    
    private static void intEmpresasClausulas (Connection dbCon, int lote) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       try {
           FileOutputStream fos = new FileOutputStream (getPathFile(dbCon,"EMPRESAS") +
                   Formatos.formatearCeros(String.valueOf(lote), 6) );
           OutputStreamWriter osw = new OutputStreamWriter (fos); //, "8859_1");
           BufferedWriter bw = new BufferedWriter (osw);
           
           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_PRO_IDA_CLAUSULAS_NEW\" (?,?)}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, lote);
           cons.setInt (3, 0);
           cons.execute();
          
           rs = (ResultSet) cons.getObject(1);           
           if (rs != null) {
                while (rs.next()) {
                    bw.write(rs.getString ("CAMPO"));
                    System.out.println (rs.getString ("CAMPO"));
                }
                rs.close();
            }   
                    
            bw.flush();
            bw.close();
            osw.close();
            fos.close();
        } catch (Exception e) {
            throw new SurException ("PINCHO EN intEmpresasClausulas: " + e.getMessage());
           
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
    }

    private static String getPathFile (Connection dbCon, String tabla) throws SurException {
       CallableStatement cons  = null;    

       try {
           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"GET_TABLAS_DESCRIPCION\" (? , ?)}");
           cons.registerOutParameter(1, java.sql.Types.VARCHAR);
           cons.setString (2, "INT_PROPUESTA_PATH_NEW");
           cons.setString (3, tabla);
           cons.execute();

           return cons.getString (1);
        } catch (Exception e) {
            throw new SurException ("PINCHO EN getPathFile: " + e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
    }

    public static void cambiarEstado (Connection dbCon, String tipoEmision, String sEstado, String userid) throws SurException {
       String  _flag = "/home/adrian/enviar/bloq_new.flag";
       String  _flagBatch = "/home/adrian/enviar/bloq_batch.flag";
       boolean bCambiar = true;
       try {
         Parametro oParam = new Parametro ();

        if (tipoEmision.equals("ESTADO_INTERFACE_ONLINE") && userid.equals("AUTOMAT")) {
            oParam.setsCodigo(tipoEmision);

            bCambiar = ( oParam.getDBValor(dbCon).equals(sEstado) ? false : true );
        }

        if (bCambiar) {
            oParam.setsCodigo(tipoEmision);
            oParam.setsValor(sEstado);
            oParam.setsUserid(userid);
            oParam.setDB(dbCon);

            if (oParam.getiNumError() == 0) {
                if (sEstado.equals ("N")) {
                    // bloquear
                    FileOutputStream fos = new FileOutputStream (tipoEmision.equals("ESTADO_INTERFACE_ONLINE") ? _flag : _flagBatch );
                    OutputStreamWriter osw = new OutputStreamWriter (fos);
                    BufferedWriter bw = new BufferedWriter (osw);
                    bw.write(Fecha.getFechaActual());
                    bw.flush();
                    bw.close();
                    osw.close();
                    fos.close();
                } else {
                    // desbloqear
                    File file = new File(tipoEmision.equals("ESTADO_INTERFACE_ONLINE") ? _flag : _flagBatch );
                    file.delete ();
                }
            }
        }

        } catch (Exception e) {
            throw new SurException ("PINCHO EN cambiarEstado: " + e.getMessage());
        } 
    }

   
    private static void intActividadCategoria (Connection dbCon, int lote) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       try {
           FileOutputStream fos = new FileOutputStream (getPathFile(dbCon,"ACTIVIDAD_CATEGORIA"));//+ String.valueOf(lote) );
           OutputStreamWriter osw = new OutputStreamWriter (fos); //, "8859_1");
           BufferedWriter bw = new BufferedWriter (osw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_COT_ACTIVIDAD_CATEGORIA\" ()}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.execute();
           int fila = 1;
           rs = (ResultSet) cons.getObject(1);
           
           if (rs != null) {
                while (rs.next()) {
                    bw.write(rs.getString ("CAMPO"));
                }
                rs.close();
            }
            
            bw.flush();
            bw.close();
            osw.close();
            fos.close();
        } catch (Exception e) {
            throw new SurException (e.getMessage());
           
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
    }    

    private static void procesarVuelta (Connection dbCon, int lote) throws SurException {
        String sRespVprop = "/opt/tomcat/webapps/benef/files/ftppino/SOLVPROP.TXT";
       try {
// PROCESAR RESPUESTA

            File fRespVprop = new File(sRespVprop + Formatos.formatearCeros(String.valueOf(lote), 6) );

            BufferedReader di = new BufferedReader(new FileReader( fRespVprop));
            String linea;
            /***** Lee línea a línea el  archivo ... ****/
            int numFila = 0;
            do {
                linea = di.readLine();
                if (linea == null) {
                    break;
                }  else {
                    String delims = "[|]";
                    String [] aLin = linea.split(delims);

                    Propuesta oProp = new Propuesta ();
                    oProp.setNumPropuesta( Integer.parseInt (aLin [0]));
                    oProp.setCodEstado   ( Integer.parseInt (aLin [1]));
                    oProp.setCodError    ( Integer.parseInt (aLin [2]));

                    oProp.setDBRetornoDC(dbCon, aLin [3], aLin [4]);
                    if (oProp.getCodError() < 0) {
                        throw new SurException( oProp.getDescError() );
                    }

                }
                numFila += 1;
            } while ( true );
            di.close();
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        }
    }

    public static void main(String[] args)  throws Exception{

        Connection dbCon = null;
        int lote = 0;
        int cant = 0;
        String  _file = "/opt/tomcat/webapps/benef/propiedades/config.xml";
        String sTipoEmision = "OL";
        String sFile    = "/opt/tomcat/webapps/benef/files/ftppino/";
        String repositorio = "/opt/tomcat/webapps/benef/files/ftppino/bk";
        URLConnection urlConnection = null;
        boolean bProcesarRetorno = true;

        try {
            if ( System.getProperty("os.name" ).contains("Windows") ) {
                _file = "C:\\benefweb\\www\\propiedades\\config.xml";
                sFile    = "C:\\benefweb\\www\\files\\ftppino\\";
                repositorio = "C:\\opt\\tomcat\\webapps\\benef\\files\\ftppino\\bk";
            }


            if (Param.getRealPath () == null) {
                Param.realPath (_file);
            }

           db.realPath (_file);
           dbCon = db.getConnection();
           if (args.length != 0) {
                sTipoEmision = args [0];
     //           if (sTipoEmision.equals ("BA")) {
     //               cambiarEstado (dbCon, "ESTADO_INTERFACE_ONLINE", "N", "AUTOMAT");
     //           }
            }

            lote = intIniPropuestas(dbCon, sTipoEmision);

            if (lote > 0) {

                int iOk = actualizarTablaInterfases (dbCon, "INI", cant);

                intPropuesta  (dbCon, lote);
                intTomador    (dbCon, lote);
                intAsegurado  (dbCon, lote);
                intCobertura  (dbCon, lote);
                intUbicacionRiesgo (dbCon, lote);
                intEmpresasClausulas(dbCon, lote);

                cant = intFinPropuestas (dbCon, lote);

                try {
                    phpDC.realPath (_file);
                    StringBuilder sb = new StringBuilder ();
                    sb.append("PROGRAMA=").append( phpDC.getPrograma(dbCon, "PHP_EMITE_ONLINE") ).append("\n");
                    sb.append("NROLOT=").append(Formatos.formatearCeros(String.valueOf(lote), 6)).append("\n");

                    urlConnection = phpDC.getConnection(sb.toString());

                    BufferedReader inStream =  phpDC.sendRequest(urlConnection);

                    StringBuilder buffer = new StringBuilder();
                    String linea;
                    while((linea = inStream.readLine() ) != null) {

                        buffer.append(linea);
                    }

                    if (buffer == null || ! buffer.toString().endsWith("FIN-PROCESO")) {
                        bProcesarRetorno = false;
                        throw new Exception ("Salida incorrecta:" + (buffer == null ? "nula" : buffer.toString() ));
                    }
                } catch (Exception ioe) {
                        Email oEmail = new Email ();

                        oEmail.setSubject("ERROR EN PROPUESTA BATCH - LOTE Nº " + lote);
                        oEmail.setContent(ioe.getMessage());

                        LinkedList lDest = oEmail.getDBDestinos(dbCon, 0, "ERROR_INTERFACE");

                        for (int i=0; i < lDest.size();i++) {
                            Persona oPers = (Persona) lDest.get(i);
                            oEmail.setDestination(oPers.getEmail());
                            oEmail.sendMessageBatch();
                        }
                        bProcesarRetorno = false;
                }

                if (bProcesarRetorno) {
// PROCESAR RESPUESTA
                    procesarVuelta (dbCon, lote);
                }

// MOVER ARCHIVOS AL REPOSITORIO
                RenameFile (repositorio, sFile, lote);

                iOk = actualizarTablaInterfases (dbCon, "FIN", cant);
            }

  //          intActividadCategoria (dbCon, lote);

           // volver cuando se implemente
   //        if (sTipoEmision.equals ("BA")) {
   //             cambiarEstado (dbCon, "ESTADO_INTERFACE_ONLINE", "S", "AUTOMAT");
   //        }

        } catch (Exception e) {
            System.exit (-1);
        } finally {
            db.cerrar(dbCon);
        }

    }

    private static void RenameFile (String repositorio , String sFile, int lote )
            throws SurException {

    try {

     //       String DATE_FORMAT = "yyyyMMdd";
    //        SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
    //        Calendar c1 = Calendar.getInstance();
     //       repositorio = repositorio + sdf.format(c1.getTime());
       //     File fDirRepositorio = new File(repositorio);
       //     if( !fDirRepositorio.exists() && !fDirRepositorio.isDirectory() ){
            // crear el directorio del repositorio
        //        fDirRepositorio.mkdir();
       //     }

        String sLote = Formatos.formatearCeros ( String.valueOf (lote), 6);

        File fichero1 = new File(sFile + "SOLASEGU.TXT" + sLote );
        File fichero2 = new File(sFile + "SOLCOBER.TXT" + sLote );
        File fichero3 = new File(sFile + "SOLECLA.TXT"  + sLote );
        File fichero4 = new File(sFile + "SOLERROR.TXT" + sLote );
        File fichero5 = new File(sFile + "SOLPROPU.TXT" + sLote );
        File fichero6 = new File(sFile + "SOLTOMAD.TXT" + sLote );
        File fichero7 = new File(sFile + "SOLUBIC.TXT"  + sLote );
        File fichero8 = new File(sFile + "SOLVPROP.TXT" + sLote );

        String sBarra = "/";

        if ( System.getProperty("os.name" ).contains("Windows") ) {
            sBarra = "\\";
        }
        File newFichero1 = new File(repositorio + sBarra + "SOLASEGU.TXT" + sLote );
        File newFichero2 = new File(repositorio + sBarra + "SOLCOBER.TXT" + sLote );
        File newFichero3 = new File(repositorio + sBarra + "SOLECLA.TXT" + sLote );
        File newFichero5 = new File(repositorio + sBarra + "SOLPROPU.TXT" + sLote );
        File newFichero6 = new File(repositorio + sBarra + "SOLTOMAD.TXT" + sLote );
        File newFichero7 = new File(repositorio + sBarra + "SOLUBIC.TXT" + sLote );
        File newFichero8 = new File(repositorio + sBarra + "SOLVPROP.TXT" + sLote );
        File newFichero4 = new File(repositorio + sBarra + "SOLERROR.TXT" + sLote );

        fichero1.renameTo(newFichero1);
        fichero2.renameTo(newFichero2);
        fichero3.renameTo(newFichero3);
        fichero4.renameTo(newFichero4);
        fichero5.renameTo(newFichero5);
        fichero6.renameTo(newFichero6);
        fichero7.renameTo(newFichero7);
        fichero8.renameTo(newFichero8);
    } catch (Exception e) {
            throw new SurException ("CreateFile:" + e.getMessage());
        }
    }
    private static void CreateFile (LinkedList lParams, String sFile )
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
}
