/*
 * IntCotizador.java
 *
 * Created on 30 de mayo de 2006, 09:46
 */

package com.business.beans;

import java.io.*;
import java.util.Date;
import java.util.LinkedList;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.nio.charset.*;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;

import com.business.util.*;
import com.business.db.*;
import com.business.interfaces.*;
/**
 *
 * @author Rolando Elisii
 */
public class IntTest {

    /** Creates a new instance of IntCotizador */
    public IntTest() {
    }
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args)  throws Exception{
        
        Connection dbCon = null;
        int lote = 0;
        int cant = 0;
        try {
            Class.forName("org.postgresql.Driver");

            String url = "jdbc:postgresql://localhost:5432/BENEF";
            dbCon = DriverManager.getConnection ( url , "postgres", "pino");
/*            
            actualizarTablaInterfases (dbCon, "INI", cant);
            
            lote = intIniPropuestas(dbCon);
            
           intPropuesta  (dbCon, lote);
            
            intTomador    (dbCon, lote);
            
            intAsegurado  (dbCon, lote);            
            
            intCobertura (dbCon, lote); 
  
            cant = intFinPropuestas (dbCon, lote);
            
            actualizarTablaInterfases (dbCon, "FIN", cant);
  */          
            intActividadCategoria (dbCon);
            
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
    
    private static int intIniPropuestas (Connection dbCon) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       int lote  = 0;
       try {
           
           dbCon.setAutoCommit(true);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_PRO_IDA_INICIO\" ()}");
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
           FileWriter fw = new FileWriter( getPathFile(dbCon,"FLAG"));
           BufferedWriter bw = new BufferedWriter(fw);
           PrintWriter  salida = new PrintWriter(bw);

           salida.println(String.valueOf (lote));
            
           salida.close();
           
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
    
    private static void actualizarTablaInterfases  (Connection dbCon, String secuencia, int cant) throws SurException {
       CallableStatement cons  = null;    
       try {
           dbCon.setAutoCommit(true);           
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"SET_TABLA_INTERFASE\" (?, ? ,? ,? ,?)}");
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           
           cons.setString (2, "PROPUESTAS");
           cons.setNull   (3, java.sql.Types.DATE);
           cons.setString (4, secuencia);
           cons.setInt    (5, cant);
           cons.setString (6, "TABLAS DE PROPUESTAS"); 
           
           cons.execute();
           
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
    
    private static void intPropuesta (Connection dbCon, int lote) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       try {
           FileWriter fw = new FileWriter( getPathFile(dbCon,"PROPUESTA"));
           BufferedWriter bw = new BufferedWriter(fw);
           PrintWriter  salida = new PrintWriter(bw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_PRO_IDA_PROPUESTA\" (?)}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, lote);
           cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
           if (rs != null) {
                while (rs.next()) {
                    salida.println(rs.getString ("CAMPO"));
                }
                rs.close();
            }
            
           salida.close();
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
           FileWriter fw = new FileWriter( getPathFile(dbCon,"TOMADOR"));
           BufferedWriter bw = new BufferedWriter(fw);
           PrintWriter  salida = new PrintWriter(bw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_PRO_IDA_TOMADOR\" (?)}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, lote);
           cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
           if (rs != null) {
                while (rs.next()) {
                    salida.println(rs.getString ("CAMPO"));
                }
                rs.close();
            }
            
           salida.close();
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
           FileWriter fw = new FileWriter( getPathFile(dbCon,"ASEGURADO"));
           BufferedWriter bw = new BufferedWriter(fw);
           PrintWriter  salida = new PrintWriter(bw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_PRO_IDA_ASEGURADO\" (?)}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, lote);
           cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
           if (rs != null) {
                while (rs.next()) {
                    salida.println(rs.getString ("CAMPO"));
                }
                rs.close();
            }
            
           salida.close();
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
           FileWriter fw = new FileWriter( getPathFile(dbCon,"COBERTURAS"));
           BufferedWriter bw = new BufferedWriter(fw);
           PrintWriter  salida = new PrintWriter(bw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_PRO_IDA_COBERTURAS\" (?)}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, lote);
           cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
           if (rs != null) {
                while (rs.next()) {
                    salida.println(rs.getString ("CAMPO"));
                }
                rs.close();
            }
            
           salida.close();
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
    
    private static void intActividadCategoria (Connection dbCon) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
//       Charset charset = Charset.forName("ISO-8859-1");
//       CharsetDecoder decoder = charset.newDecoder();
//       CharsetEncoder encoder = charset.newEncoder();
       try {
//           FileWriter fw = new FileWriter( getPathFile(dbCon,"TEST"));
//           BufferedWriter bw = new BufferedWriter(fw);
//           PrintWriter  salida = new PrintWriter(bw);

           FileOutputStream fos = new FileOutputStream (getPathFile(dbCon,"TEST"));
           OutputStreamWriter osw = new OutputStreamWriter (fos, "8859_1");
           BufferedWriter bw = new BufferedWriter (osw);
           System.out.println("INFO: Using " + osw.getEncoding());
        
           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_COT_ACTIVIDAD_CATEGORIA\" ()}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.execute();
           int fila = 1;
           rs = (ResultSet) cons.getObject(1);
           
           if (rs != null) {
                while (rs.next()) {
                    
//                    System.out.println("fila " + fila + ":" + rs.getString ("CAMPO"));
                    
 //                   ByteBuffer bytes = ByteBuffer.wrap(rs.getString ("CAMPO").getBytes("ISO-Latin-1"));

//                    ByteBuffer bytes = ByteBuffer.wrap(rs.getBytes("CAMPO"));
//                    CharBuffer charBuffer = decoder.decode(bytes);
//                    salida.println(charBuffer.toString());
//                    System.out.println ("fila " + fila + ":" +rs.getBytes("CAMPO"));
//                   System.out.println (charBuffer.toString());

                    bw.write(rs.getString("CAMPO"));

//                   bw.write(charBuffer.array());
 /*

                    ByteBuffer bbuf = encoder.encode(CharBuffer.wrap(rs.getString ("CAMPO")));
                    CharBuffer cbuf = decoder.decode(bbuf);
                    salida.println(cbuf.toString());
                    System.out.println (cbuf.toString());
  */                

                    
//                    System.out.println ("-----------------------------------------------");
                    fila += 1;
                }
                rs.close();
            }
            
   //        salida.close();
                bw.flush();
		bw.close();
		osw.close();
		fos.close();
                
        } catch (CharacterCodingException ce) {
            throw new SurException (ce.getMessage());            
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
