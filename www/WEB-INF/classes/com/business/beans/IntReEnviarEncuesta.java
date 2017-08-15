/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
     
package com.business.beans;     
    
import com.business.db.db;
import com.business.util.ControlEnvioMail;
import com.business.util.Criptografia;
import com.business.util.Email;
import com.business.util.Fecha;
import com.business.util.SurException;
import java.io.File;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.Map;
import java.util.Set;


public class IntReEnviarEncuesta {

    public static void main(String[] args) throws Exception{
        Connection dbCon = null;
        // Configuracion Local        
        String  _urlServlet = "/benef/servlet/EncuestaServlet?opcion=viewEncuesta&token=";
        String  _BASE = "BENEF";
        String  _localhost  =  "http://www.beneficioweb.com.ar"; // "http://192.168.2.169:8080";
        String  _file = "/opt/tomcat/webapps/benef/propiedades/config.xml";//"./www/propiedades/config.xml";
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
            Encuesta encuesta =Encuesta.getDBbyProcessDate(dbCon,_BASE, fechaProceso) ;
            
            if (encuesta.getiNumError() == 0) {                
                if (encuesta.getTemplate() == null ||  encuesta.getTemplate().trim().equals("") ) {
                    System.out.println(" No tiene Template asociado la encuesta  ");
                    throw new SurException (" No tiene Template asociado la encuesta " );
                }
                //Cambio envia con CodEnvio = R
                IntReEnviarEncuesta.getDBUserSendMailList(dbCon, _BASE, encuesta,"R" );

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
                            String link = IntReEnviarEncuesta.armarLinks(md5, encuesta.getNumEncuesta(), _localhost, _urlServlet);
                            //
                            HashMap hm = new HashMap();
                            hm.put("@@URL@@", _localhost);
                            hm.put("@@DESCRIPCION@@", encuesta.getDescripcion());
                            hm.put("@@TITULO@@", encuesta.getTitulo());
                            hm.put("@@LINK@@", link);

                            String replaceTemplate =  IntReEnviarEncuesta.replaceValueTemplate(hm, encuesta.getTemplate());                            

                            try {
                                // -----------
                                // Enviar Mail
                                // -----------
                                
                                Email mail = new Email();
                                // ------------------------------
                                // Configuracion Local mail Gmail                              
                                if (_serverMailGmail) {
                                    mail.setEnableStarttls(false);
                                }
                                //
                    mail.setSource      ("webmaster@beneficiosa.com.ar");
                    mail.setDestination (oUsuario.getEmail());
                    mail.setSubject     (encuesta.getTitulo());
                    mail.addContent     (replaceTemplate);
                    mail.addCID         ("cidimage01", "/opt/tomcat/webapps/benef/images/template/tem44.jpg");
                    mail.sendMultipart(); //Message("text/html");
/*
                                mail.setDestination(oUsuario.getEmail());
                                mail.setContent(replaceTemplate);
                                mail.setSubject(encuesta.getTitulo());
                                mail.sendMessage("text/html");
 * */

                                Thread.sleep(500);
                                
                                System.out.println("* Encuesta enviada " + IntReEnviarEncuesta.getDateTime() + " , al Usuario : " + oUsuario.getUsuario()  + " Mail : " + oUsuario.getEmail()) ;
                                hashMail.put(oUsuario.getEmail(),oUsuario.getUsuario());
                                cantAvisoEnviados++;
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

    /**/

    // Se usa en el main IntEnviarEncuesta con codigo de envio
    public  static void getDBUserSendMailList ( Connection dbCon ,String _BASE, Encuesta encuesta, String codEnvio) throws SurException {
        ResultSet rs = null;
        CallableStatement cons = null;
        LinkedList lUsuario = new LinkedList();
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("ENC_GET_ALL_DESTINOS (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt(2, encuesta.getNumEncuesta());
            cons.setString(3,codEnvio);

            cons.execute();
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    Usuario usuario = new Usuario();
                    usuario.setUsuario( rs.getString("USUARIO"));
                    usuario.setiCodTipoUsuario( rs.getInt("TIPO_USUARIO"));
                    usuario.setRazonSoc(rs.getString("RAZON_SOCIAL"));
                    usuario.setEmail(rs.getString("EMAIL"));
                    lUsuario.add(usuario);
                }
            }
            // throw new SurException ("Error al obtener destino ...." );
        }  catch (SQLException se) {
                encuesta.setiNumError (-1);
                encuesta.setsMensError (se.getMessage());
                throw new SurException ("Error al obtener destino " + se.getMessage());
        } catch (Exception e) {
                encuesta.setiNumError (-1);
                encuesta.setsMensError (e.getMessage());
                throw new SurException (e.getMessage());
        } finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                encuesta.setiNumError (-1);
                encuesta.setsMensError (see.getMessage());
                throw new SurException (see.getMessage());
            }
            encuesta.setLUsuariosAvisoMail(lUsuario);
            
        }
    } //getDBUserSendMailList

    // ------------------------------------------------------------------------
   public static void CEMupdateDB ( Connection dbCon ,
                                    String _BASE,
                                    ControlEnvioMail cem) throws SurException {
       CallableStatement proc = null;
       try {
            dbCon.setAutoCommit(true);
            if (_BASE.equals("")) {
                proc = dbCon.prepareCall(db.getSettingCall("MAIL_VALID_UPDATE (?,?,?,?,?,?)"));
            } else {
                proc = dbCon.prepareCall ( "{ ? = call \"" + _BASE + "\".\"MAIL_VALID_UPDATE\" (?,?,?,?,?,?)}");
            }
            proc.registerOutParameter   (1, java.sql.Types.INTEGER);
            proc.setInt   (2, cem.getCodEnvio());
            proc.setString(3, cem.getMD5()) ;
            proc.setString(4, cem.getMcaRespuesta()) ;
            proc.setString(5, cem.getBrowser()) ;
            proc.setString(6, cem.getVersion()) ;
            proc.setString(7, cem.getOS()) ;
            proc.execute();

            cem.setCodEnvio( proc.getInt(1));
            proc.close();

       }  catch (SQLException se) {
		throw new SurException("Se detecto un problema en la actualización del control de datos : "+ se.getMessage());
        } catch (Exception e) {
		throw new SurException("Se detecto un problema en la actualización del control de datos : " + e.getMessage());
        } finally {
            try{
                if (proc != null) proc.close ();
            } catch (SQLException see) {
                cem.setiNumError(-1);
                cem.setsMensError("Se detecto un problema en la actualización del control de datos : " + see.getMessage());
                throw new SurException (see.getMessage());
            }
            //return this;
        }
    }


}