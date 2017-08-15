/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.business.batch;

import com.business.beans.Persona;
import com.business.db.db;
import com.business.util.*;
import java.io.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.util.LinkedList;
import java.text.SimpleDateFormat;

/**
 *
 * @author Rolando Elisii
 */
public class ProcesarCuitAfip {
        
    public static void main(String[] args) throws Exception{
        Connection dbCon = null;
        String  _file ="/opt/tomcat/webapps/benef/propiedades/config.xml";//"./www/propiedades/config.xml";
        String  nomFile = "sinapellidonombredenominacion.zip";
        String _path_file = "/opt/tomcat/webapps/benef/files/trans";
        String  _file_afip = _path_file + "/" + nomFile;
        String  _dir_descompactado = "/opt/tomcat/webapps/benef/files/trans/utlfile/padr";
        String  _file_descompactado = "/opt/tomcat/webapps/benef/files/trans/utlfile/padr/nominaafip.txt";
        StringBuilder sMensaje = new StringBuilder();
        CallableStatement cons  = null;
        CallableStatement cons2  = null;
        boolean bExisteError    = false;
        String sTipoMens  = "";
        boolean _serverMailGmail = false;
        int retorno = 0;
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

            File afip=new File(_file_afip);
            String ultModif = "";
            if(!afip.exists()){
                bExisteError = true;
                sTipoMens = "NO EXISTE EL ARCHIVO " + nomFile + " en  DOSDISK/trans";
            } else { 
                if ( ! afip.isFile()) {
                    bExisteError = true;
                    sTipoMens = nomFile + " NO ES UN ARCHIVO en  DOSDISK/trans";                    
                } else { 
                    System.out.println ("utlima modificacion : " + afip.lastModified());
                    SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");

                    System.out.println("After Format : " + sdf.format(afip.lastModified()));
                    ultModif = sdf.format(afip.lastModified());
                }
            }
            
            if ( bExisteError == false ) { 
                dbCon.setAutoCommit(false);
                cons = dbCon.prepareCall(db.getSettingCall("AFIP_VALIDAR_FECHA (?)"));
                cons.registerOutParameter(1, java.sql.Types.INTEGER);
                cons.setString   (2, ultModif );

                cons.execute();
                retorno = cons.getInt(1);

                cons.close ();

                if ( retorno > 0) {  // el archivo fue modificado, se tiene que cargar
                    System.out.println ("ENTRO A CARGAR EL ARCHIVO");
                    // DESCOMPACTAR
                    UnzipUtility unzip = new UnzipUtility();
                    unzip.unzip(_file_afip, _path_file);
                    
                    File f = new File(_dir_descompactado);
                    File[] ficheros = f.listFiles();
                    for (int x=0; x<ficheros.length; x++){
                      File archivo = ficheros[x];
                      archivo.renameTo(new File (_file_descompactado));
                    }
                    
                    try { 
                        dbCon.setAutoCommit(true);
                        cons2 = dbCon.prepareCall(db.getSettingCall("AFIP_CARGAR_ARCHIVO (?, ?)"));
                        cons2.registerOutParameter(1, java.sql.Types.INTEGER);
                        cons2.setString   (2, ultModif );
                        cons2.setString   (3, _file_descompactado);

                        cons2.execute();
                        int retorno2 = cons2.getInt(1);

                        if (retorno2 < 0) {
                            bExisteError = true;
                            sTipoMens = "EL ARCHIVO DOSDISK/trans NO EXISTE ";
                            if (retorno2 == -55 ) {
                                sTipoMens = "EL ARCHIVO DOSDISK/trans TIENE OTRO FORMATO AL ESPERADO";
                            }
                        }
                    } catch (SQLException se ) {
                        bExisteError = true;
                        sTipoMens = se.getMessage();
                    } finally {
                        cons2.close ();
                    }
                }
            }
            
            System.out.println ("MENSAJE: " + sTipoMens);
            
            String from     = "webmaster@beneficio.com.ar";
            boolean debug   = false;
            Email mail = new Email();

            // ------------------------------
            // Configuracion Local mail Gmail
            if ( _serverMailGmail ) {
                mail.setEnableStarttls(true);
            }
            mail.setSource      (from);
            String subject  = "";
            if (! sTipoMens.equals("")) { 
                    subject  = "Beneficio Web - ERROR EN EL PROCESO DE CARGA DEL ARCHIVO DE NOMINA DE CUIT DE AFIP";
            } else {
                if ( retorno > 0) { 
                    subject  = "Beneficio Web - HOY se cargo el archivo de la AFIP";
                } else { 
                   subject  = "Beneficio Web - " + "Hace " + ( retorno * -1) + " dias que no se carga el archivo de la AFIP"; 
                }
            }

            sMensaje.delete(0, sMensaje.length());
            sMensaje.append("Para bajar el archivo tiene que acceder a la afip, http://www.afip.gob.ar/genericos/cInscripcion/archivoCompleto.asp <br/>");
            sMensaje.append(" y hacer clic en el boton Archivo condici&oacute;n tributaria sin denominaci&oacute;n.<br/>");
            sMensaje.append("deber&aacute; dejar dicho archivo en el servidor DOSDISK/trans<br><br>");
            sMensaje.append("FECHA DE PROCESO: ").append(Fecha.showFechaForm( new java.util.Date()) ).append("<br><br><br>");
            if (! sTipoMens.equals("")) { 
                sMensaje.append("SE HA PRODUCIDO EL SIGUIENTE ERROR AL PROCESAR EL ARCHIVO: ");
                sMensaje.append(sTipoMens);
            }

            mail.setSubject     (subject);
            mail.addContent     (sMensaje.toString());
            LinkedList lDest = mail.getDBDestinos(dbCon, 0, "AFIP_CUIT_VALIDO");            
            for (int i=0; i < lDest.size();i++) {
                Persona oPers = (Persona) lDest.get(i);
                mail.setDestination(oPers.getEmail());
                mail.sendMultipart(); //Message("text/html");
            }
            }

        catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null ) cons.close();
                if (cons2 != null ) cons2.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            dbCon.close();;
        }
    }
}
