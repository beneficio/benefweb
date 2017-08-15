/*
 * IntCotizador.java
 *
 * Created on 30 de mayo de 2006, 09:46
 */

package com.business.beans;

import java.io.*;
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
public class IntPropuestas {

    /** Creates a new instance of IntCotizador */
    public IntPropuestas() {
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
                intPropuesta  (dbCon, lote);

                intTomador    (dbCon, lote);

                intAsegurado  (dbCon, lote);

                intCobertura (dbCon, lote);

                intUbicacionRiesgo (dbCon, lote);

                intEmpresasClausulas(dbCon, lote);
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
    
    public static void main(String[] args)  throws Exception{
        
        Connection dbCon = null;
        int lote = 0;
        int cant = 0;   
        String  _file = "/opt/tomcat/webapps/benef/propiedades/config.xml";
        String sTipoEmision = "OL";
        try {
            if (Param.getRealPath () == null) {
                Param.realPath (_file);
            }


           db.realPath (_file);

            dbCon = db.getConnection();

            System.out.println ("se conecto a la base:" + dbCon);

            if (args.length != 0) {
                sTipoEmision = args [0];
                if (sTipoEmision.equals ("BA")) {
                    cambiarEstado (dbCon, "ESTADO_INTERFACE", "N", "AUTOMAT");
                }
            }

           int iOk = actualizarTablaInterfases (dbCon, "INI", cant);

           System.out.println ("despues de actualizarTablaInterfases" + iOk);

           if (iOk == 0 ) {
                lote = intIniPropuestas(dbCon, sTipoEmision);
                if (lote > 0) {
                    intPropuesta  (dbCon, lote);
                    intTomador    (dbCon, lote);
                    intAsegurado  (dbCon, lote);
                    intCobertura  (dbCon, lote);
                    intUbicacionRiesgo (dbCon, lote);
                    intEmpresasClausulas(dbCon, lote);
                    cant = intFinPropuestas (dbCon, lote);
               }
                FileWriter fw = new FileWriter( getPathFile(dbCon,"FLAG") ); // + String.valueOf(lote));
                BufferedWriter bw = new BufferedWriter(fw);
                PrintWriter  salida = new PrintWriter(bw);
                if (cant > 0){
                    salida.println ("1");
                }
                salida.close();
                bw.close();
                fw.close();

               System.out.println ("cantidad de propuestas enviadas: " + cant );

               iOk = actualizarTablaInterfases (dbCon, "FIN", cant);
            }
           
  //          intActividadCategoria (dbCon, lote);
            
           if (sTipoEmision.equals ("BA")) {
                cambiarEstado (dbCon, "ESTADO_INTERFACE", "S", "AUTOMAT");
            }
            
        } catch (Exception e) {
            System.out.println (e.getMessage());
        } finally {
            try {
                if (dbCon != null) dbCon.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
        
    }
    
    private static int intIniPropuestas (Connection dbCon, String sTipoEmision) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       int lote  = 0;
       try {
           
           dbCon.setAutoCommit(true);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_PRO_IDA_INICIO\" (?)}");
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setString (2, sTipoEmision);
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
            throw new SurException (e.getMessage());
           
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
            throw new SurException (e.getMessage());
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
           FileOutputStream fos = new FileOutputStream (getPathFile(dbCon,"PROPUESTA")+ String.valueOf(lote) );
           OutputStreamWriter osw = new OutputStreamWriter (fos); //, "8859_1");
           BufferedWriter bw = new BufferedWriter (osw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_PRO_IDA_PROPUESTA\" (?)}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, lote);
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

    private static void intTomador (Connection dbCon, int lote) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       try {
           FileOutputStream fos = new FileOutputStream (getPathFile(dbCon,"TOMADOR")+ String.valueOf(lote));
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
                    System.out.println (rs.getString ("CAMPO"));
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

    private static void intAsegurado (Connection dbCon, int lote) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       try {
           FileOutputStream fos = new FileOutputStream (getPathFile(dbCon,"ASEGURADO")+ String.valueOf(lote));
           OutputStreamWriter osw = new OutputStreamWriter (fos); // "8859_1");
           BufferedWriter bw = new BufferedWriter (osw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_PRO_IDA_ASEGURADO\" (?)}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, lote);
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

    private static void intUbicacionRiesgo (Connection dbCon, int lote) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       try {
           FileOutputStream fos = new FileOutputStream (getPathFile(dbCon,"UBICACION")+ String.valueOf(lote));
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
                    System.out.println (rs.getString ("CAMPO"));
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


    private static void intCobertura (Connection dbCon, int lote) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       try {
           FileOutputStream fos = new FileOutputStream (getPathFile(dbCon,"COBERTURAS")+ String.valueOf(lote));
           OutputStreamWriter osw = new OutputStreamWriter (fos); //, "8859_1");
           BufferedWriter bw = new BufferedWriter (osw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_PRO_IDA_COBERTURAS\" (?)}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, lote);
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
    
    private static void intEmpresasClausulas (Connection dbCon, int lote) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       try {
           FileOutputStream fos = new FileOutputStream (getPathFile(dbCon,"EMPRESAS")+ String.valueOf(lote));
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
                    System.out.println (rs.getString ("CAMPO"));
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

    private static String getPathFile (Connection dbCon, String tabla) throws SurException {
       CallableStatement cons  = null;    

       try {
           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"GET_TABLAS_DESCRIPCION\" (? , ?)}");
           cons.registerOutParameter(1, java.sql.Types.VARCHAR);
           cons.setString (2, "INT_PROPUESTA_PATH");
           cons.setString (3, tabla);
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
            throw new SurException (e.getMessage());
        } 
    }

   
    private static void intActividadCategoria (Connection dbCon, int lote) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       try {
           FileOutputStream fos = new FileOutputStream (getPathFile(dbCon,"ACTIVIDAD_CATEGORIA")+ String.valueOf(lote));
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
}
