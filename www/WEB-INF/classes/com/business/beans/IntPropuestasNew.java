/*
 * IntCotizador.java
 *
 * Created on 30 de mayo de 2006, 09:46
 */

package com.business.beans;

import java.io.*;
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
public class IntPropuestasNew {

    /** Creates a new instance of IntCotizador */
    public IntPropuestasNew() {
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
           FileOutputStream fos = new FileOutputStream (getPathFile(dbCon,"PROPUESTA"));//+ String.valueOf(lote) );
           OutputStreamWriter osw = new OutputStreamWriter (fos); //, "8859_1");
           BufferedWriter bw = new BufferedWriter (osw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_PRO_IDA_PROPUESTA_NEW\" (?)}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, lote);
           cons.execute();
           
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
           FileOutputStream fos = new FileOutputStream (getPathFile(dbCon,"TOMADOR"));//+ String.valueOf(lote) );
           OutputStreamWriter osw = new OutputStreamWriter (fos); //, "8859_1");
           BufferedWriter bw = new BufferedWriter (osw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_PRO_IDA_TOMADOR\" (?)}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, lote);
           cons.execute();
           
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
           FileOutputStream fos = new FileOutputStream (getPathFile(dbCon,"ASEGURADO"));//+ String.valueOf(lote) );
           OutputStreamWriter osw = new OutputStreamWriter (fos); // "8859_1");
           BufferedWriter bw = new BufferedWriter (osw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_PRO_IDA_ASEGURADO_NEW\" (?)}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, lote);
           cons.execute();
           
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
           FileOutputStream fos = new FileOutputStream (getPathFile(dbCon,"UBICACION"));//+ String.valueOf(lote) );
           OutputStreamWriter osw = new OutputStreamWriter (fos); // "8859_1");
           BufferedWriter bw = new BufferedWriter (osw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_PRO_IDA_UBICACION_RIESGO\" (?)}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, lote);
           cons.execute();
           
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
           FileOutputStream fos = new FileOutputStream (getPathFile(dbCon,"COBERTURAS"));//+ String.valueOf(lote) );
           OutputStreamWriter osw = new OutputStreamWriter (fos); //, "8859_1");
           BufferedWriter bw = new BufferedWriter (osw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_PRO_IDA_COBERTURAS_NEW\" (?)}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, lote);
           cons.execute();
           
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
           FileOutputStream fos = new FileOutputStream (getPathFile(dbCon,"EMPRESAS"));//+ String.valueOf(lote) );
           OutputStreamWriter osw = new OutputStreamWriter (fos); //, "8859_1");
           BufferedWriter bw = new BufferedWriter (osw);
           
           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_PRO_IDA_CLAUSULAS\" (?)}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, lote);
           cons.execute();
          
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
       String  _flag = "/home/adrian/enviar/bloq.flag";
       String  _flagBatch = "/home/adrian/enviar/bloq_batch.flag";
       boolean bCambiar = true;
       try {
         Parametro oParam = new Parametro ();

        if (tipoEmision.equals("ESTADO_INTERFACE") && userid.equals("AUTOMAT")) {
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
                    FileOutputStream fos = new FileOutputStream (tipoEmision.equals("ESTADO_INTERFACE") ? _flag : _flagBatch );
                    OutputStreamWriter osw = new OutputStreamWriter (fos);
                    BufferedWriter bw = new BufferedWriter (osw);
                    bw.write(Fecha.getFechaActual());
                    bw.flush();
                    bw.close();
                    osw.close();
                    fos.close();
                } else {
                    // desbloqear
                    File file = new File(tipoEmision.equals("ESTADO_INTERFACE") ? _flag : _flagBatch );
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

            File fRespVprop = new File(sRespVprop ); //+ lote );

            BufferedReader di = new BufferedReader(new FileReader( fRespVprop));
            String linea;
            /***** Lee línea a línea el  archivo ... ****/
            int numFila = 0;
            do {
                linea = di.readLine();
                if (linea == null) {
                    break;
                }  else {
//193726|3|0|EMITIDA: 10/0167237/086518|2013-02-15|2013-05-14|2013-02-15|2013-02-15
                    String [] aLinea = linea.split("|");
                    System.out.println (aLinea [0]);
                    System.out.println (aLinea [1]);
                    System.out.println (aLinea [2]);
                    System.out.println (aLinea [3]);
                    System.out.println (aLinea [4]);

                    Propuesta oProp = new Propuesta ();
                    oProp.setNumPropuesta( Integer.parseInt (aLinea [0]));
                    oProp.setCodEstado   ( Integer.parseInt (aLinea [1]));
                    oProp.setCodError    ( Integer.parseInt (aLinea [2]));

                    oProp.setDBRetornoDC(dbCon, aLinea [3], aLinea [4]);
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
        String sFile    = "/opt/tomcat/webapps/benef/files/dc/";

        try {
            if (Param.getRealPath () == null) {
                Param.realPath (_file);
            }

           db.realPath (_file);
           dbCon = db.getConnection();
           if (args.length != 0) {
                sTipoEmision = args [0];
           // volver cuando se implemente
           //     if (sTipoEmision.equals ("BA")) {
           //         cambiarEstado (dbCon, "ESTADO_INTERFACE", "N", "AUTOMAT");
           //     }
            }


//           System.out.println ("despues de actualizarTablaInterfases" + iOk);

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

                String sFileSec = sFile + "gpolpinot." + lote;

                LinkedList lParams = new LinkedList();

                lParams.add ("PROGRAMA=" + getProgramaDC (dbCon, "EMITE_PROPUESTA" ));

                lParams.add ("COMPAN=16");
 //                lParams.add ("LOTE=" + lote);

                CreateFile(lParams, sFileSec  );

                Process child = null;

                try {
                    Parametro oParam = new Parametro ();
                    oParam.setsCodigo("DC_CLIENT_COMANDO");
                    String sCommand = oParam.getDBValor(dbCon);

                    oParam.setsCodigo("DC_CLIENT_SERVER");
                    String sServer = oParam.getDBValor(dbCon);
                    
                    // Execute a command with an argument that contains a space
                    String[] commands = new String[]{sCommand , sFileSec, sServer };
                    child = Runtime.getRuntime().exec(commands);

                    // Se obtiene el stream de salida del programa
                    InputStream is = child.getInputStream();
                    // Se prepara un bufferedReader para poder leer la salida más comodamente.
                    BufferedReader br = new BufferedReader (new InputStreamReader (is));
                    // Se lee la primera linea
                    String aux = br.readLine();

                    System.out.println ("stream de salida:" + aux);
                } catch (IOException ioe) {
                        InputStream er = child.getErrorStream();
                        // Se prepara un bufferedReader para poder leer la salida más comodamente.
                        BufferedReader berr = new BufferedReader (new InputStreamReader (er));
                        // Se lee la primera linea
                        System.out.println ("stream error: " + berr.readLine());
                        System.out.println ("ioException: " + ioe.getMessage());
                        System.exit(-1);
                }

// PROCESAR RESPUESTA
                procesarVuelta (dbCon, lote);

                iOk = actualizarTablaInterfases (dbCon, "FIN", cant);
            }

  //          intActividadCategoria (dbCon, lote);

           // volver cuando se implemente
           //if (sTipoEmision.equals ("BA")) {
           //     cambiarEstado (dbCon, "ESTADO_INTERFACE", "S", "AUTOMAT");
           // }

        } catch (Exception e) {
            System.exit (-1);
        } finally {
            db.cerrar(dbCon);
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
