/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.business.batch;

import com.business.beans.GestionTexto;
import com.business.beans.Persona;
import com.business.db.db;
import com.business.util.Email;
import com.business.util.SurException;
import java.io.File;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;

/**
 *
 * @author Rolando Elisii
 */
public class ProbarMail {
    
    public static void main(String[] args) throws Exception {
        String  _file ="/opt/tomcat/webapps/benef/propiedades/config.xml";
        StringBuilder sMensaje = new StringBuilder();
        boolean _serverMailGmail = false;
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
                System.out.println("*********************************************************************** ") ;
                System.out.println("* Se recupero informacion del archivo config.xml") ;
                System.out.println("*********************************************************************** ") ;
            }

            Email mail = new Email();
            mail.setSource("webmaster@beneficio.com.ar");
            mail.setUser("webmaster@beneficio.com.ar");
            mail.setPassword("pino3916");
            mail.setDestination("relisii@beneficio.com.ar");
            mail.setSubject("PRUEBA  DE ENVIO" );
            mail.addContent("Esto es una prueba");

            try {
                mail.sendMultipart(); //Message("text/html");
                System.out.println ("MAIL ENVIADO OK" );
            } catch ( Exception eMail) {
                System.out.println ("ERROR " + eMail.getMessage());
            }
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        }
    }
}
