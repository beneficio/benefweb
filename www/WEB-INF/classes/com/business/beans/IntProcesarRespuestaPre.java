/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.business.beans;

import com.business.db.db;
import com.business.util.*;
import java.io.*;
import java.sql.Connection;
import java.sql.SQLException;

/**
 *
 * @author Rolando Elisii
 */
public class IntProcesarRespuestaPre {

    public static void main(String[] args) throws Exception{
        Connection dbCon = null;
        String _BASE = "BENEF";
        String  _file ="/opt/tomcat/webapps/benef/propiedades/config.xml";//"./www/propiedades/config.xml";
        //
        try {
            File config=new File(_file);
            if(!config.exists()){
                // ------------------------------------------------------------
                // En caso que si no toma los datos del config.xml
                // Configurar los Datos de conexion.
                // ------------------------------------------------------------

                System.out.println(" ********************************** ") ;
                System.out.println(" No se encontro el archivo config.xml") ;
                System.out.println(" ********************************** ") ;
                throw new SurException("NO SE ENCONTRO EL ARCHIVO config.xml");
            } else {
                db.realPath(config.getAbsolutePath()) ;
                dbCon = db.getConnection();
                System.out.println("*********************************************************************** ") ;
                System.out.println("* Se recupero informacion del archivo config.xml") ;
                System.out.println("*********************************************************************** ") ;
            }

        String _preliqFile = "/opt/tomcat/webapps/benef/files/preliq/res";
        File fichero = new File(_preliqFile);

        FileFilter filtroJava = new FileFilter(){
            public boolean accept(File fMessage){
            return fMessage.getName().endsWith(".ERRORES");
            } };

        File [] listFile = fichero.listFiles(filtroJava);
        int numPreLiq  = 0;   

        for(int i=0; i< listFile.length; i++){
            File iFile = listFile [i];
            String nameFile = iFile.getName();
            if ( !iFile.isDirectory() && iFile.length() > 0 ) {
                numPreLiq  = Integer.parseInt(nameFile.substring(3,11));

                BufferedReader di = new BufferedReader(new FileReader( iFile));
		String linea;
                /***** Lee línea a línea el  archivo ... ****/
                int numFila = 0;
                do {
                    linea = di.readLine();
                    if (linea == null) {
                        break;
                    }  else {
                        PreliqResp oResp = new PreliqResp(numPreLiq, linea.toString(), "WEB" );
                        oResp.setDB(dbCon, numFila);
                        if (oResp.getiNumError() < 0) {
                            throw new SurException(oResp.getsMensError());
                        }

                    }
                    numFila += 1;
                } while ( true );
                di.close();

                Preliq oPreliq = new Preliq();
                oPreliq.setNumPreliq(numPreLiq);
                oPreliq.setDBRespuesta (dbCon);
                if (oPreliq.getiNumError() < 0 ){
                    throw new SurException(oPreliq.getsMensError());
                }

                iFile.renameTo ( new File (_preliqFile +"/"+ nameFile + ".OK"));

            }
        }
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (dbCon != null) dbCon.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
    }
}
