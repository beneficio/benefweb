/*
 * IntCotizador.java
 *
 * Created on 30 de mayo de 2006, 09:46
 */

package com.business.beans;

import java.io.*;
import java.util.Date;

import com.business.util.*;
import com.business.db.*;
import com.business.interfaces.*;
import com.ibm.as400.access.*;   
/**
 *
 * @author Rolando Elisii
 */
public class IntPolizas {

    /** Creates a new instance of IntCotizador */
    public IntPolizas() {
    }
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args)  throws Exception {
        
        AS400 servidor = null;   
        
        try {
            System.out.println ("entro en ele programa ");
           
            String pServidor = "192.168.1.10";
            String pUsuario  = "BENEWEB";
            String pPassword = "BENEWEB";
            String pLibreria = "BENEWEB";
            String pTipoProg = "PGM";
            String pPrograma = "ACTPPROC";
            
            servidor = new AS400(pServidor, pUsuario, pPassword);            
            
            String c = "/QSYS.LIB/" + pLibreria + ".LIB/" + pPrograma + "." + pTipoProg;            
            
            ProgramCall cmd = new ProgramCall (servidor);
            cmd.setProgram(c);

             if (cmd.run() != true) {
// Reporte de las fallas
// muestra mensajes de error
                AS400Message[] messagelist = cmd.getMessageList();
                for (int j = 0; j < messagelist.length; ++j) {
                    System.out.println(messagelist[j]);
                }
            } else {
                System.out.println ("ok !!!!!!!!!!!!!!!!!!!");
            }
            
            cmd = null;
            
        } catch (Exception e) {
            System.out.println (e.getMessage());
        } finally {
            if (servidor != null) {
                servidor = null;
            }
        }
    }
}
