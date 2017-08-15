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

import com.business.util.*;
import com.business.db.*;
import com.business.interfaces.*;
/**
 *
 * @author Rolando Elisii
 */
public class IntCotizador {

    /** Creates a new instance of IntCotizador */
    public IntCotizador() {
    }
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args)  throws Exception{
        
        Connection dbCon = null;
        try {
            Class.forName("org.postgresql.Driver");

            String url = "jdbc:postgresql://localhost:5432/BENEF";
            dbCon = DriverManager.getConnection ( url , "postgres", "pino");
            
            actualizarTablaInterfases (dbCon, "INI");
            
            intActividad(dbCon);
            intBonificacion(dbCon);
            intImpuestos(dbCon);
            intTasaMensual(dbCon);
            intTasaProvincial(dbCon);
            intTramo(dbCon);
            intVigencia(dbCon);

            actualizarTablaInterfases (dbCon, "FIN");
            
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
    
    private static void intActividad (Connection dbCon) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       try {
           
           FileWriter fw = new FileWriter( getPathFile(dbCon,"ACTIVIDAD"));
           BufferedWriter bw = new BufferedWriter(fw);
           PrintWriter  salida = new PrintWriter(bw);
           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_COT_ACTIVIDAD\" ()}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
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

    private static void actualizarTablaInterfases  (Connection dbCon, String secuencia) throws SurException {
       CallableStatement cons  = null;    
       try {
           dbCon.setAutoCommit(true);           
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"SET_TABLA_INTERFASE\" (?, ? ,? ,? ,?)}");
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           
           cons.setString (2, "COTIZADOR_AP");
           cons.setNull   (3, java.sql.Types.DATE);
           cons.setString (4, secuencia);
           cons.setInt    (5, 0);
           cons.setString (6, "TABLAS DEL COTIZADOR"); 
           
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
    

    private static void intBonificacion (Connection dbCon) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       try {
           FileWriter fw = new FileWriter( getPathFile(dbCon,"BONIFICACION"));
           BufferedWriter bw = new BufferedWriter(fw);
           PrintWriter  salida = new PrintWriter(bw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_COT_BONIFICACION\" ()}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
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

    private static void intImpuestos (Connection dbCon) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       try {
           FileWriter fw = new FileWriter( getPathFile(dbCon,"IMPUESTOS"));
           BufferedWriter bw = new BufferedWriter(fw);
           PrintWriter  salida = new PrintWriter(bw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_COT_IMPUESTOS\" ()}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
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

    private static void intTasaMensual (Connection dbCon) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       try {
           FileWriter fw = new FileWriter( getPathFile(dbCon,"TASA_MENSUAL"));
           BufferedWriter bw = new BufferedWriter(fw);
           PrintWriter  salida = new PrintWriter(bw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_COT_TASA_MENSUAL\" ()}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
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

    private static void intTasaProvincial (Connection dbCon) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       try {
           FileWriter fw = new FileWriter( getPathFile(dbCon,"TASA_PROVINCIAL"));
           BufferedWriter bw = new BufferedWriter(fw);
           PrintWriter  salida = new PrintWriter(bw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_COT_TASA_PROVINCIAL\" ()}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
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

    private static void intTramo (Connection dbCon) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       try {
           FileWriter fw = new FileWriter( getPathFile(dbCon,"TRAMO"));
           BufferedWriter bw = new BufferedWriter(fw);
           PrintWriter  salida = new PrintWriter(bw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_COT_TRAMO\" ()}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
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

    private static void intVigencia (Connection dbCon) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       try {
           FileWriter fw = new FileWriter( getPathFile(dbCon,"VIGENCIA"));
           BufferedWriter bw = new BufferedWriter(fw);
           PrintWriter  salida = new PrintWriter(bw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"INT_COT_VIGENCIA\" ()}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
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
           cons.setString (2, "INT_COTIZADOR_PATH");
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
}
