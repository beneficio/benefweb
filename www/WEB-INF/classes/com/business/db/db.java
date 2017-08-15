/*
 * Conectar.java
 *
 * Created on 1 de julio de 2003, 10:48 AM
 */

package com.business.db;

/**
 *
 * @author  surprogra   
 */
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.util.*;
import com.business.util.SurException;

import org.jconfig.handler.XMLFileHandler;
import org.jconfig.Configuration;
import org.jconfig.ConfigurationManager;
import org.jconfig.ConfigurationManagerException;
import java.io.File;

import javax.servlet.*;
import javax.servlet.http.*;


public class db {
    
        private static String _DRIVER   = null;
        private static String _BASE     = null;
	private static String _URLBASE  = null;
        
        private static String _USER     = null;
	private static String _PASS     = null;
    
        private static String sRealPath = null;
        private db() {
	 }
        
	public static Connection getConnection() {
           Connection conn               = null;
           ConfigurationManager configurationManager = null;
           File configurationFile        = null;
           XMLFileHandler xmlFileHandler = null;
           Configuration configuration   = null;
           
           try {
               if ( _DRIVER == null ) {
                    configurationManager = ConfigurationManager.getInstance();
                    configurationFile = new File( sRealPath ); 
                    xmlFileHandler = new XMLFileHandler(); 
                    xmlFileHandler.setFile(configurationFile);
                    try {
                        configurationManager.load(xmlFileHandler, "Configuracion JDBC");
                    } catch(ConfigurationManagerException e) { 
                        e.printStackTrace();
                    }

                    configuration = configurationManager.getConfiguration("Configuracion JDBC"); 
                    
                    _DRIVER   = configuration.getProperty("driver", null, "jdbc");
                    _BASE     = configuration.getProperty("base", null, "jdbc");
                    _URLBASE  = configuration.getProperty("urlbase", null, "jdbc");
                    _USER     = configuration.getProperty("user", null, "jdbc");
                    _PASS     = configuration.getProperty("pass", null, "jdbc");
               }
                Class.forName(_DRIVER);
                String url = _URLBASE + _BASE;
                
                Properties props = new Properties();
                props.setProperty("user", _USER);
                props.setProperty("password", _PASS);
                props.setProperty("allowEncodingChanges","true");

                // conn = DriverManager.getConnection(url, _USER , _PASS);
                conn = DriverManager.getConnection(url, props);
                
            } catch (ClassNotFoundException CNFExc) {
                    System.err.println(CNFExc);
            } catch (SQLException SQLExc) {
                    System.err.println(SQLExc);
            } catch (Exception Exc) {
                    System.err.println(Exc);
            }
            return  conn;               
        }
        
        
        public static void cerrar(Connection dbCon)
        throws SurException{
            try {
                if (dbCon != null) {
                    dbCon.close();
                }
            } catch (SQLException SQLEx) {
                    throw new SurException ("Error al cerarr la Seccion" + SQLEx);
            }
        }
        
   public static void resetear () {
        _DRIVER = null; 
        _BASE= null; 
        _URLBASE= null; 
        _USER= null; 
        _PASS = null;
   }        

   public static void  realPath (String param ) throws SurException {
       try {
           
           sRealPath = param;
       } catch (Exception e) {
           throw new SurException(e.getMessage());
       }
   }

   public static String  getRealPath () throws SurException {
       String rpDevuelto = "";
       try {
           
           rpDevuelto = sRealPath;
           return rpDevuelto;
       } catch (Exception e) {
           throw new SurException(e.getMessage());
       }
    }

  public static String  getBase () throws SurException {
       try {
           return _BASE;
       } catch (Exception e) {
           throw new SurException(e.getMessage());
       }

   }
   
   public static String  getSettingCall (String storeProcedure ) throws SurException {
       String stDevuelto = "{ ? = call \"" + _BASE + "\".\"";
       try {
           String proc  = storeProcedure.substring(0,storeProcedure.indexOf("(")).trim();
           String param = storeProcedure.substring(storeProcedure.indexOf("(")); 
          
           stDevuelto = stDevuelto + proc + "\"" + param + " }";
           
           return stDevuelto;
       } catch (Exception e) {
           throw new SurException(e.getMessage());
       }
   }

    public static String  getSettingCallProcedure (String storeProcedure ) throws SurException {
        String stDevuelto = "{ call \"" + _BASE + "\".\"";
        try {
            String proc  = storeProcedure.substring(0,storeProcedure.indexOf("(")).trim();
            String param = storeProcedure.substring(storeProcedure.indexOf("(")); 
          
            stDevuelto = stDevuelto + proc + "\"" + param + " }";
           
            return stDevuelto;
        } catch (Exception e) {
           throw new SurException(e.getMessage());
        }
    }
   
}
