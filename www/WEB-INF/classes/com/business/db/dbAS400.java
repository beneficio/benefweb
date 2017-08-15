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
import com.ibm.as400.access.*;
import java.util.*;
import com.business.util.SurException;

public class dbAS400 {
        private static String _DRIVER   = null;
        private static String _BASE     = null;
	private static String _URLBASE  = null;
        
        private static String _USER     = "PINO";
	private static String _PASS     = "PINO";
        private static String _SERVER   = "192.168.1.10";

        private dbAS400() {
	 }
        
	public static AS400 getConnection() {
           AS400 sys = null;
           
           try {
               
               sys = new AS400( _SERVER , _USER, _PASS );

            } catch (Exception Exc) {
                    System.err.println(Exc);
            }
            return  sys;               
        }
        
        
        public static void cerrar(AS400 sys)
        throws SurException{
            try {
                if (sys != null) {
                    sys.disconnectService(AS400.COMMAND);
                }
            } catch (Exception SQLEx) {
                    throw new SurException ("Error al cerarr la Seccion" + SQLEx);
            }
        }
        
        public static boolean commandCall (AS400 sys, String comando )
        throws SurException {
            try {
                CommandCall cmd = new CommandCall(sys);            
                
                 if (cmd.run(comando) != true) {
                     AS400Message[] messageList = cmd.getMessageList();
                     throw new SurException ( messageList.toString ());
                 } else {
                    return true;
                 }
                
            } catch (Exception SQLEx) {
                    throw new SurException ("Error al cerarr la Seccion" + SQLEx);
            } 
        }
        
}
