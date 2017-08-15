/*
 * Conectar.java
 *
 * Created on 1 de julio de 2003, 10:48 AM
 */

package com.business.util;

/**
 *
 * @author  surprogra
 */
import org.jconfig.handler.XMLFileHandler;
import org.jconfig.Configuration;
import org.jconfig.ConfigurationManager;
import org.jconfig.ConfigurationManagerException;
import java.io.File;

public class Param {
         private static String sAplicacion  = null;
         private static String sRealPath    = null;
         private static String mailHost     = "192.168.2.178"; // Host de correo.
         private static String user         = "webmaster@beneficio.com.ar";
         private static String password     = "pino3916";
         private static String auth         = "true";
         private static String source       = "webmaster@beneficio.com.ar";
         private static String port         = "25";
        private Param() {
	 }
        
	public static String getAplicacion () {
           ConfigurationManager configurationManager = null;
           File configurationFile        = null;
           XMLFileHandler xmlFileHandler = null;
           Configuration configuration   = null;
           
           try {
               if (sAplicacion == null ) {
                    configurationManager = ConfigurationManager.getInstance();
                    
                    configurationFile = new File( sRealPath ); 

                    xmlFileHandler = new XMLFileHandler(); 
                    xmlFileHandler.setFile(configurationFile);
                    try {
                        configurationManager.load(xmlFileHandler, "general");
                    } catch(ConfigurationManagerException e) { 
                        e.printStackTrace();
                    }

                    configuration = configurationManager.getConfiguration("general"); 
                    sAplicacion  = configuration.getProperty("aplicacion", null, "general");
                    mailHost     = configuration.getProperty("mailhost", null, "general");
                    user         = configuration.getProperty("mailuser", null, "general");
                    password     = configuration.getProperty("mailpass", null, "general");
                    auth         = configuration.getProperty("mailauth", null, "general");
                    source       = configuration.getProperty("mailsource", null, "general");
                    port         = configuration.getProperty("mailport", null, "general");

               }
            } catch (Exception Exc) {
                    System.err.println(Exc);
            } finally {
                return  (sAplicacion == null ? "/benef/" : sAplicacion);               
            }
        }
        
	public static String resetAplicacion () {
           ConfigurationManager configurationManager = null;
           File configurationFile        = null;
           XMLFileHandler xmlFileHandler = null;
           Configuration configuration   = null;

           try {    
                configurationManager = ConfigurationManager.getInstance();

                configurationFile = new File( sRealPath );

                xmlFileHandler = new XMLFileHandler();
                xmlFileHandler.setFile(configurationFile);
                try {
                    configurationManager.load(xmlFileHandler, "general");
                } catch(ConfigurationManagerException e) {
                    e.printStackTrace();
                }

                configuration = configurationManager.getConfiguration("general");
                sAplicacion  = configuration.getProperty("aplicacion", null, "general");
                mailHost     = configuration.getProperty("mailhost", null, "general");
                user         = configuration.getProperty("mailuser", null, "general");
                password     = configuration.getProperty("mailpass", null, "general");
                auth         = configuration.getProperty("mailauth", null, "general");
                source       = configuration.getProperty("mailsource", null, "general");
                port         = configuration.getProperty("mailport", null, "general");

            } catch (Exception Exc) {
                    System.err.println(Exc);
            } finally {
                return  (sAplicacion == null ? "/benef/" : sAplicacion);
            }
        }
        
    public static String getMailHost () {
           ConfigurationManager configurationManager = null;
           File configurationFile        = null;
           XMLFileHandler xmlFileHandler = null;
           Configuration configuration   = null;
           
           try {
               if (mailHost == null ) {
                    configurationManager = ConfigurationManager.getInstance();
                    configurationFile = new File( sRealPath ); 
                    xmlFileHandler = new XMLFileHandler(); 
                    xmlFileHandler.setFile(configurationFile);
                    try {
                        configurationManager.load(xmlFileHandler, "general");
                    } catch(ConfigurationManagerException e) { 
                        e.printStackTrace();
                    }

                    configuration = configurationManager.getConfiguration("general"); 
                    mailHost     = configuration.getProperty("mailhost", null, "general");
                    user         = configuration.getProperty("mailuser", null, "general");
                    password     = configuration.getProperty("mailpass", null, "general");
                    auth         = configuration.getProperty("mailauth", null, "general");
                    source       = configuration.getProperty("mailsource", null, "general");
                    port         = configuration.getProperty("mailport", null, "general");

               }
           } catch (Exception Exc) {
                    System.err.println(Exc);
           } finally {
                return  (mailHost == null ? "smtp.gmail.com" : mailHost);
           }
     }

    public static String getMailUser () {
        return  (user == null ? "webmaster@beneficio.com.ar" : user);
     }
 
   public static String getMailPassword () {
        return  (password == null ? "pino3916" : password);
     }
    public static String getMailAuth () {
        return  (auth == null ? "true" : auth);
     }

    public static String getMailSource () {
        return  (source == null ? "webmaster@beneficio.com.ar" : source);
     }

    public static String getMailPort () {
        return  (port == null ? "25" : port);
     }
    
     public static String getParam(String param) {
           ConfigurationManager configurationManager = null;
           File configurationFile        = null;
           XMLFileHandler xmlFileHandler = null;
           Configuration configuration   = null;
           
           try {
               if (param != null ) {
                    configurationManager = ConfigurationManager.getInstance();
                    configurationFile = new File( sRealPath ); 
                    xmlFileHandler = new XMLFileHandler(); 
                    xmlFileHandler.setFile(configurationFile);
                    try {
                        configurationManager.load(xmlFileHandler, "general");
                    } catch(ConfigurationManagerException e) { 
                        e.printStackTrace();
                    }

                    configuration = configurationManager.getConfiguration("general"); 
                    
                    param   = configuration.getProperty(param, null, "general");
               }
            } catch (Exception Exc) {
                    System.err.println(Exc);
            }
            return  param;               
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
}

