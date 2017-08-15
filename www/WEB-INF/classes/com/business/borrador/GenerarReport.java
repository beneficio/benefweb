/*
 * IntCotizador.java
 *
 * Created on 30 de mayo de 2006, 09:46
 */

package com.business.borrador;

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
public class GenerarReport {

    /** Creates a new instance of IntCotizador */
    public GenerarReport() {
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
            
            getReport  (dbCon);
            
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
    
    
    private static void getReport (Connection dbCon) throws SurException {
       CallableStatement cons  = null;    
       ResultSet rs = null;
       try {
           FileOutputStream fos = new FileOutputStream (getPathFile(dbCon,"GET_REPORT_PATH"));
           OutputStreamWriter osw = new OutputStreamWriter (fos, "8859_1");
           BufferedWriter bw = new BufferedWriter (osw);
           
           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"BORRADOR_GET_REPORT\"()}");
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
           if (rs != null) {
                while (rs.next()) {
                    System.out.println (rs.getString ("CAMPO"));
                    bw.write(rs.getString ("CAMPO"));
                }
             rs.close ();   
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
           cons.setString (2, "INT_REPORT_PATH");
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
