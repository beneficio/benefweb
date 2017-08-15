/*
 * IntCotizador.java
 *
 * Created on 30 de mayo de 2006, 09:46
 */

package com.business.beans;

import java.io.*;
import java.io.FileFilter;

import com.business.util.*;
/**
 *
 * @author Rolando Elisii
 */
public class EnviarMail {

    /** Creates a new instance of IntCotizador */
    public EnviarMail() {
    }
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args)  throws Exception {
        String pathDirectoryRoot = "/opt/tomcat/webapps/benef/files/mensajes";
        try {
        Email oEmail = new Email();
        File fMessage = new File(pathDirectoryRoot);

        FileFilter filtroJava = new FileFilter(){
            public boolean accept(File fMessage){
            return fMessage.getName().toLowerCase().endsWith(".txt");

            } };
    
        File[] listFile = fMessage.listFiles( filtroJava );

        for(int i=0; i<listFile.length; i++){
//            String nameFile = listFile[i];
//            File iFile = new File(fMessage +"/"+ nameFile);
            File iFile = listFile[i];
            String nameFile   = iFile.getName();

            if (!iFile.isDirectory()) {
                BufferedReader br = new BufferedReader(new FileReader(iFile));
                String line = null;
                boolean bFirst = true;
                boolean bError = false;
                StringBuilder sBody = new StringBuilder();
                while ((line = br.readLine()) != null) {
                    if (bFirst) {
                        bFirst = false;
                        String[] aMessage = line.split("&&");
                        oEmail.setSubject   (aMessage[4]);
                        oEmail.setDestination(aMessage[1]);

                        oEmail.setSource    ("webmaster@beneficio.com.ar"); //aMessage[0]);
                        if (aMessage[3] != null && ! aMessage[3].equals ("null") ) {
                            oEmail.setCC(aMessage[3]);
                        }
                        if (aMessage[2] != null && ! aMessage[2].equals ("null") ) {
                            oEmail.setCCO (aMessage[2]);
                        }
                        sBody.append(aMessage[5]).append("\n");;
                    } else {
                        sBody.append(line).append("\n");;
                    }
                }     
                oEmail.setContent(sBody.toString());
                try {
                    oEmail.sendMessage();
                } catch ( SurException se ) {
                    bError = true;
                    System.out.println ("Error:" + se.getMessage());
                    iFile.renameTo ( new File (fMessage +"/"+ nameFile + ".ERROR"));
                } finally {
                    br.close();
                }
                if (!bError) {
                    iFile.delete();
                }
            }
        }
        } catch (Exception e) {
            System.out.println (e.getMessage());
        }
    }
}
