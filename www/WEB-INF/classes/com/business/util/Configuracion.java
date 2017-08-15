package com.business.util;


import org.jconfig.handler.XMLFileHandler;
import org.jconfig.Configuration;
import org.jconfig.ConfigurationManager;
import org.jconfig.ConfigurationManagerException;
import java.io.File;

public class Configuracion {
    
    public Configuracion () {
    }
    
   public static void getVariables () {
      ConfigurationManager configurationManager = ConfigurationManager.getInstance();

      System.out.println ( "paso 1 " );
      
      File configurationFile = new File("C:\\surweb\\www\\propiedades\\config.xml");
      
      System.out.println ( "paso 2 " );
      
      XMLFileHandler xmlFileHandler = new XMLFileHandler();
      
      System.out.println ( "paso 3 " );
      
      xmlFileHandler.setFile(configurationFile);

      try {
          System.out.println ( "paso 33  ");
         
          configurationManager.load(xmlFileHandler, "Configuracion de Ejemplo");
         
          System.out.println ( "paso 4 " );
      
      } catch(ConfigurationManagerException e) {
         e.printStackTrace();
      }

      Configuration configuration = configurationManager.getConfiguration("Configuracion de Ejemplo");
      
      System.out.println ( "paso 5 " );
      
      System.out.println("\nGENERAL\n");
      System.out.println("Max Row " + configuration.getProperty("maxrow"));
      System.out.println("Max Cotizacion " + configuration.getProperty("maxcotizacion"));

      System.out.println("\nCATEGORIA JDBC\n");
      System.out.println("url: " + configuration.getProperty("urlbase", null, "jdbc"));
      System.out.println("user: " + configuration.getProperty("user", null, "jdbc"));
      System.out.println("password: " + configuration.getProperty("pass", null, "jdbc"));
      System.out.println("driver: " + configuration.getProperty("driver", null, "jdbc"));

   }
}
