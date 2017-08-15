/*
 * IntCotizador.java
 *
 * Created on 30 de mayo de 2006, 09:46
 */

package com.business.beans;

import java.util.LinkedList;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import com.business.util.*;
import com.business.db.*;
/**
 *
 * @author Rolando Elisii
 */
public class IntEnviarAviso {

    /** Creates a new instance of IntCotizador */
    public IntEnviarAviso() {
    }
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args)  throws Exception{
        
        Connection dbCon = null;
        CallableStatement cons  = null;    
        
        int retorno = 0;
        int cant = 0;
        String  _file = "/opt/tomcat/webapps/benef/propiedades/config.xml";
        ResultSet rs = null;
        boolean bExiste  = false;
        boolean bExisteError = false;
        StringBuilder  sb = new StringBuilder ();

        try {
            if (Param.getRealPath () == null) {
                Param.realPath ("/opt/tomcat/webapps/benef/propiedades/config.xml");
            }

           db.realPath ("/opt/tomcat/webapps/benef/propiedades/config.xml");

           dbCon = db.getConnection();

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall(db.getSettingCall("INT_ALL_RESULTADO_INTERFASES ()"));
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.execute();
           rs = (ResultSet) cons.getObject(1);
           if (rs != null) {
                while (rs.next()) {
                    bExiste = true;
                    if (rs.getInt("FILAS") < 0 ) {
                        bExisteError = true;
                        sb.append(rs.getString ("HORA_TRABAJO"));
                        sb.append(" [");
                        sb.append(rs.getString("TABLA"));
                        sb.append("] :");
                        sb.append(rs.getString("DESCRIPCION"));
                        sb.append("\n");
                    }

                }
                rs.close();
            }
           cons.close();
           if (! bExiste) {
               sb.append("NO CORRIO LA INTERFACE DEL DIA.\n");
           }

           if (bExisteError || ! bExiste) {
                sendEmail(dbCon, sb.toString());
            }
        } catch (Exception e) {
            System.out.println (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
        
    }
    
   private static void sendEmail (Connection dbCon, String sMensError )
    throws  SurException {
        StringBuffer sMensaje = new StringBuffer();
        LinkedList lDest = new LinkedList();
        CallableStatement cons  = null;    
        ResultSet rs = null;
        try {
            sMensaje.append("FECHA: ");
            sMensaje.append(Fecha.getFechaActual());
            sMensaje.append(" \n");
            sMensaje.append("Se ha producido el siguiente error en la interface de inicialización de la web: ");
            sMensaje.append(" \n");            
            sMensaje.append(sMensError);
            sMensaje.append(" \n");                        
            sMensaje.append("Este es un mensaje automático generado por BENEFICIO WEB.\n");
            sMensaje.append("Cualquier duda o consulta puede comunicarse por este medio a webmaster@beneficiosa.com.ar\n");

            Email oEmail = new Email ();

            oEmail.setSubject("Beneficio Web - ERROR EN INTERFACE DC - WEB ");
            oEmail.setContent(sMensaje.toString());

//             lDest = oEmail.getDBDestinos(dbCon, 1 , "ERROR_INTERFACE");
            dbCon.setAutoCommit(false);            
            cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"MAIL_GET_ALL_DESTINOS\" (?,?)}");
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt    (2, 0);
            cons.setString (3, "ERROR_INTERFACE");

            cons.execute();
             
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    Persona oPers = new Persona ();
                    oPers.setRazonSoc(rs.getString ("NOMBRE"));
                    oPers.setEmail   (rs.getString ("EMAIL"));
                         
                    lDest.add(oPers); 
                }
                rs.close();
            }
                     
            for (int i=0; i < lDest.size();i++) {
                Persona oPers = (Persona) lDest.get(i);
                oEmail.setDestination(oPers.getEmail());
                    oEmail.sendMessageBatch();
            }
             
       }  catch (Exception e) {
   		throw new SurException("Error al obtener los destinos: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close ();
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
   }
}
