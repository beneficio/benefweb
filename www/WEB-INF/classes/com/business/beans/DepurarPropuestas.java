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
public class DepurarPropuestas {

    /** Creates a new instance of IntCotizador */
    public DepurarPropuestas() {
    }
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args)  throws Exception{
        
        Connection dbCon = null;
        CallableStatement cons  = null;    
        try {
            Class.forName("org.postgresql.Driver");

            String url = "jdbc:postgresql://localhost:5432/BENEF";
            dbCon = DriverManager.getConnection ( url , "postgres", "pino3916");

            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"PRO_DEPURAR_PROPUESTAS\" ()}");
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.execute();
            
            System.out.println ("Ejecución exitosa ");

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
}