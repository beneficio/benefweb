/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
        
package com.business.beans;     

import com.business.db.db;
import com.business.util.ControlEnvioMail;
import com.business.util.Criptografia;
import com.business.util.Email;
import com.business.util.SurException;
import java.io.File;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;


public class IntEnviarEncuesta {

    public static void main(String[] args) throws Exception{
        Connection dbCon = null;
        // Configuracion Local        
        String _urlServlet = "/benef/servlet/EncuestaServlet?opcion=viewEncuesta&token=";
        String _BASE = "BENEF";
        String  _localhost  =  "http://www.beneficioweb.com.ar"; // "http://201.216.219.9:9090";
        String  _file ="/opt/tomcat/webapps/benef/propiedades/config.xml";
        boolean _serverMailGmail = false;
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
                String _driver = "org.postgresql.Driver";
                String _jdbc = "jdbc:postgresql://192.168.2.169:5432/BENEF";
                String _user = "postgres";
                String _pwd = "pino3916";
                System.out.println(" jdbc  :" + _jdbc ) ;
                System.out.println(" user  :" + _user ) ;
                Class.forName(_driver);
                String url = _jdbc;
                dbCon = DriverManager.getConnection ( url , _user, _pwd);
            } else {
                db.realPath(config.getAbsolutePath()) ;
                dbCon = db.getConnection();
                System.out.println("*********************************************************************** ") ;
                System.out.println("* Se recupero informacion del archivo config.xml") ;
                System.out.println("*********************************************************************** ") ;
            }
            int cantAvisoMail = 0;
            int cantDirMailRepetidos = 0;
            int cantAvisoEnviados = 0;
            int cantErrorGrabarArchivoControl = 0;
            int cantErrorSendMail = 0;
            //
            Date fechaProceso = new Date();           
            Encuesta encuesta =Encuesta.getDBbyProcessDate(dbCon,_BASE, fechaProceso ) ;
            if (encuesta.getiNumError() == 0) {                
                if (encuesta.getTemplate() == null ||  encuesta.getTemplate().trim().equals("") ) {
                    System.out.println(" No tiene Template asociado la encuesta  ");
                    throw new SurException (" No tiene Template asociado la encuesta " );
                }              
                Encuesta.getDBUserSendMailList(dbCon, _BASE, encuesta );                                
                if (encuesta.getiNumError() == 0) {
                    cantAvisoMail = encuesta.getLUsuariosAvisoMail().size();
                    HashMap hashMail = new HashMap();
                    for (int i=0; i < encuesta.getLUsuariosAvisoMail().size();i++) {
                        Usuario oUsuario = (Usuario) encuesta.getLUsuariosAvisoMail().get(i);
                        String usuarioListAviso = (String) hashMail.get(oUsuario.getEmail());                                                
                        if ( usuarioListAviso == null) {
                            StringBuffer stbMd5 = new StringBuffer(oUsuario.getEmail());
                            stbMd5.append( String.valueOf(encuesta.getNumEncuesta()));
                            String md5 = Criptografia.toMD5(stbMd5.toString());                            
                            String link = IntEnviarEncuesta.armarLinks(md5, encuesta.getNumEncuesta(), _localhost, _urlServlet);
                            //
                            HashMap hm = new HashMap();
                            hm.put("@@URL@@", _localhost);
                            hm.put("@@DESCRIPCION@@", encuesta.getDescripcion());
                            hm.put("@@TITULO@@", encuesta.getTitulo());
                            hm.put("@@LINK@@", link);

                            String replaceTemplate =  IntEnviarEncuesta.replaceValueTemplate(hm, encuesta.getTemplate());
                            try {
                                // -----------
                                // Enviar Mail
                                // -----------
                                Email mail = new Email();
                                // ------------------------------
                                // Configuracion Local mail Gmail                              
                                if (_serverMailGmail) {
                                    mail.setEnableStarttls(true);
                                }
                    mail.setSource      ("webmaster@beneficiosa.com.ar");
                    mail.setDestination (oUsuario.getEmail());
                    mail.setSubject     (encuesta.getTitulo());
                    mail.addContent     (replaceTemplate);
                    mail.addCID         ("cidimage01", "/opt/tomcat/webapps/benef/images/template/tem44.jpg");
                    mail.sendMultipart(); //Message("text/html");

                                Thread.sleep(1000);

                                // Grabar en send_mail.
                                ControlEnvioMail cem = new ControlEnvioMail();
                                cem.setCodEnvio(encuesta.getNumEncuesta());
                                cem.setUsuarioDestino(oUsuario.getUsuario());
                                cem.setMailDestino(oUsuario.getEmail());
                                cem.setMD5(md5);
                                cem.insertDB(dbCon, _BASE);
                                //
                                if ( cem.getiNumError()!=0) {
                                    System.out.println("* (*1) Error ,se envio el mail pero no se pudo grabar archivo de control . Usuario : " + oUsuario.getUsuario()  + " Mail : " + oUsuario.getEmail() + " Msg.Error = " + cem.getsMensError()) ;
                                    hashMail.put(oUsuario.getEmail(),oUsuario.getUsuario());
                                    cantAvisoEnviados++;
                                    cantErrorGrabarArchivoControl++;
                                } else {
                                    System.out.println("* Encuesta enviada " + IntEnviarEncuesta.getDateTime() + " , al Usuario : " + oUsuario.getUsuario()  + " Mail : " + oUsuario.getEmail()) ;
                                    hashMail.put(oUsuario.getEmail(),oUsuario.getUsuario());
                                    cantAvisoEnviados++;
                                }
                            } catch (Exception eMail ) {
                                System.out.println("(*2) Error En el Envio Mail. Usuario : " + oUsuario.getUsuario() + " , mail : " + oUsuario.getEmail() + ", mensaje:  " + eMail.getMessage());
                                cantErrorSendMail++;
                            }
                        } else {                            
                            System.out.println("* (*a) La encuesta del usuario: " + oUsuario.getUsuario() +  " ya fue enviada a esta direccion de mail  : " +  oUsuario.getEmail() + " (Usuario : " +  usuarioListAviso + " )") ;
                            cantDirMailRepetidos++;
                        }
                    }
                    System.out.println();
                    System.out.println("* --------------------------------------------------------------------------------- " );
                    System.out.println("* Cantida Avisos de Encuesta : " + cantAvisoMail ) ;
                    System.out.println("* Encuestas Enviadas : " + cantAvisoEnviados );
                    System.out.println("* ---------------------------------------------------------------------------------" );
                    System.out.println("* (*a) Direcciones de mail repetidas (no enviadas) : " + cantDirMailRepetidos ) ;
                    
                    System.out.println("* (*1) Error Encuestas  - Grabar Archivo de Control  : " + cantErrorGrabarArchivoControl );
                    System.out.println("* (*2) Error Encuestas  - Enviar Mail  : " + cantErrorSendMail );
                } else {
                    throw new SurException (encuesta.getsMensError());
                }
            } else {
                throw new SurException (encuesta.getsMensError());
            }

            if (dbCon != null) dbCon.close();

        }  catch (SQLException se) {            
            throw new SurException ("Error [main] :  " + se.getMessage());
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

    private static String getDateTime() {
        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        Date date = new Date();
        return dateFormat.format(date);
    }

    private static String armarLinks( String md5 ,
                                      int pNumEncuesta , 
                                      String pLocalhost , 
                                      String pUrlServlet) throws SurException {
        try {
            StringBuffer token = new StringBuffer(String.valueOf(pNumEncuesta));
            token.append("@");            
            token.append(md5);            
            StringBuffer link = new StringBuffer(pLocalhost) ;
            link.append(pUrlServlet);
            link.append(token);            
            return link.toString();        
        } catch (Exception e)  {
            throw new SurException (e.getMessage());
        }                
    }

    private static String replaceValueTemplate ( HashMap valueToReplace , String template )
        throws Exception
    {
        try {
            StringBuffer templateStb = new StringBuffer (template) ;
            Set set = valueToReplace.entrySet();
            Iterator i = set.iterator();
            while(i.hasNext()){
                Map.Entry me = (Map.Entry)i.next();                
                String dato = (String) me.getKey();
                int index = templateStb.indexOf(dato);
                while (index != -1 ) {                    
                    templateStb.replace(index , index + dato.length() , (String)me.getValue());
                    index = templateStb.indexOf(dato);
                }
            }
            return templateStb.toString();
        } catch (Exception e)  {
            throw new SurException (e.getMessage());
        }
    }
}