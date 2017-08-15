/*
 * Conectar.java
 *
 * Created on 1 de julio de 2003, 10:48 AM
 */

package com.business.db;

import com.business.util.SurException;

import org.jconfig.handler.XMLFileHandler;
import org.jconfig.Configuration;
import org.jconfig.ConfigurationManager;
import org.jconfig.ConfigurationManagerException;
import java.io.*;
import java.net.*;
import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.SQLException;
import com.business.util.Param;

public class phpDC {
    
        private static String _URL  = null;
        private static String _CUALDCRC     = null;
	private static String _TIMEOUT  = null;
        private static String _PROGRAMA = null;
        private static String sRealPath = null;
        private static String body      = null;
        private phpDC() {
	 }
        
	public static URLConnection getConnection(String archivo) {
           ConfigurationManager configurationManager = null;
           File configurationFile        = null;
           XMLFileHandler xmlFileHandler = null;
           Configuration configuration   = null;
            URL url;
            URLConnection urlConnection = null;
           
           try {
               if ( _URL == null ) {
                    configurationManager = ConfigurationManager.getInstance();
                    configurationFile = new File( sRealPath ); 
                    xmlFileHandler = new XMLFileHandler(); 
                    xmlFileHandler.setFile(configurationFile);
                    try {
                        configurationManager.load(xmlFileHandler, "phpDC");
                    } catch(ConfigurationManagerException e) { 
                        e.printStackTrace();
                    }

                    configuration = configurationManager.getConfiguration("phpDC");
                    
                    _URL   = configuration.getProperty("url", null, "phpDC");
                    _CUALDCRC     = configuration.getProperty("cualdcrc", null, "phpDC");
                    _TIMEOUT  = configuration.getProperty("timeout", null, "phpDC");
                    _PROGRAMA  = configuration.getProperty("programa", null, "phpDC");

               }

               body = "?cualdcrc=" +  URLEncoder.encode( _CUALDCRC , "UTF-8") +
                  "&cont_archivo=" +  URLEncoder.encode( archivo , "UTF-8");
        // Create connection
                url = new URL( _URL + body);

System.out.println ("url-->" + _URL + body );

                urlConnection = url.openConnection();

                ((HttpURLConnection)urlConnection).setRequestMethod("POST");
                urlConnection.setDoInput(true);
                urlConnection.setDoOutput(true);
                urlConnection.setUseCaches(false);
                urlConnection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
                urlConnection.setRequestProperty("Content-Length", ""+ body.length());
                urlConnection.setConnectTimeout( Integer.parseInt (_TIMEOUT) );

            } catch (Exception Exc) {
                    System.err.println(Exc);
            }
            return  urlConnection;
        }
        
        
        
   public static void resetear () {
        _URL        = null;
        _CUALDCRC   = null;
	_TIMEOUT    = null;
        _PROGRAMA   = null;
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

  public static String  getURL () throws SurException {
       try {
           return _URL;
       } catch (Exception e) {
           throw new SurException(e.getMessage());
       }

   }

    public static String getPrograma (Connection dbCon, String sOperacion )
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

   
   public static BufferedReader  sendRequest (URLConnection urlConnection ) throws SurException {
       BufferedReader  inStream = null;
       DataOutputStream outStream = null;
       try {
// Create I/O streams
        outStream = new DataOutputStream(urlConnection.getOutputStream());

        inStream = new BufferedReader
                (new InputStreamReader( urlConnection.getInputStream ()));


// Send request
        outStream.writeBytes(body);
        outStream.flush();
        outStream.close();

        return inStream;
       }  catch (Exception e) {
           throw new SurException(e.getMessage());
       }
   }
   
}
