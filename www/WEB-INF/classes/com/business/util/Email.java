/*
 * Email.java
 *
 * Created on 19 de mayo de 2005, 22:14
 */     
   
package com.business.util;
        
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;
import java.io.*;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;

import com.business.db.*;
import com.business.beans.Persona;
/**
 *
 * @author Rolando Elisii
 */
public class Email
{
/**
* Algunas constantes
*/
static public int SIMPLE = 0;
static public int MULTIPART = 1;
/**
* Algunos mensajes de error
*/
public static String ERROR_01_LOADFILE = "Error al cargar el fichero";
public static String ERROR_02_SENDMAIL = "Error al enviar el mail";

 private String mailHost; // Host de correo.
 private String source;  // Dirección del remitente.
 private String destination; // Dirección de envio.
 private String cco; // con copia oculta.
 private String cc;
 private String content;  // Contenido del mail.
 private String subject;  // Asunto del mail.
 private String user        = "";
 private String password    = "";
 private String auth        = "";
 private String port        = "";
 private Properties properties=new Properties();
 private String sMensError    = new String();
 private int  iNumError       = 0;

/**
* MultiPart para crear mensajes compuestos
*/   
Multipart multipart = new MimeMultipart("related");


    public Email() {
        mailHost  = Param.getMailHost();
        user      = Param.getMailUser();
        password  = Param.getMailPassword();
        auth      = Param.getMailAuth();
        source    = Param.getMailSource(); // "webmaster@beneficioweb.com.ar"; //
        port      = Param.getMailPort ();


        properties.put("mail.transport.protocol", "smtp");
        properties.put("mail.smtp.localhost",mailHost);
        properties.put("mail.smtp.port", port );
        properties.put("mail.from",source);
        properties.put("mail.smtp.auth", auth);


/* configuracion para google
        properties.put("mail.smtp.user", user);
        properties.put("mail.smtp.host", mailHost);
        properties.put("mail.smtp.socketFactory.port", port);
        properties.put("mail.smtp.socketFactory.class",	"javax.net.ssl.SSLSocketFactory");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.port", port);
*/
        destination="";
        content="";
    }


 public void setUser (String param)
 {
  this.user = param;
  properties.put("mail.smtp.user", user);
 }
 public void setPassword (String param)
 {
  this.password = param;
 }
    
 public void setSource(String source)
 {
  this.source=source;
 }

 public void setDestination(String destination)
 {
  this.destination=destination;
 }

 public void setCCO (String cco)
 {
  this.cco = cco;
 }

 public void setCC (String cc)
 {
  this.cc = cc;
 }

 public void setContent(String content)
 {
  this.content=content;
 }

 public void setSubject(String subject)
 {
  this.subject=subject;
 }

 public String getMailHost()
 {
  return mailHost;
 }

 public String getSource()
 {
  return source;
 }

 public String getDestination()
 {
  return destination;
 }

 public String getCCO()
 {
  return cco;
 }

 public String getContent()
 {
  return content;
 }

 public String getSubject()
 {
  return subject;
 }

    public String getsMensError  () {
        return this.sMensError ;
    }
    public void setsMensError  (String psMensError ) {
        this.sMensError  = psMensError ;
    }

    public int getiNumError  () {
        return this.iNumError ;
    }
    
    public void setiNumError  (int piNumError ) {
        this.iNumError  = piNumError;
    }
 
    public void sendMessage() throws SurException {
    try {
        Session session = Session.getDefaultInstance(properties);
                 /*,
			new javax.mail.Authenticator() {
				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(user, password);
				}
			});
                  *
                  */

        Message message=new MimeMessage(session);            
//        InternetAddress[] address = { new InternetAddress(destination)};
        InternetAddress[] address = InternetAddress.parse( destination);

        message.setRecipients(Message.RecipientType.TO, address);
        if (cco != null) {
            InternetAddress[] addressBCC = InternetAddress.parse( cco);
            message.setRecipients(Message.RecipientType.BCC , addressBCC);
        }

        if (cc != null) {
            InternetAddress[] addressCC = InternetAddress.parse( cc);
            message.setRecipients(Message.RecipientType.CC , addressCC);
        }

        message.setFrom(new InternetAddress(source));
        message.setSubject(subject);

        message.setText(content);
        message.setSentDate(new Date());

        Transport transport = session.getTransport(address[0]);
        transport.connect(mailHost, user, password);

        transport.sendMessage(message, message.getAllRecipients());
        transport.close();
    } catch(Exception e) {
        throw new SurException (e.getMessage());
    }
    }

    public void sendMessage(String format) throws SurException {

    try {
        Session session = Session.getDefaultInstance(properties);
        /* esta configuracion es para google, es el 2do. parametro de Session.getDef...
               ,
			new javax.mail.Authenticator() {
				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(user, password);
				}
			});
*/
        Message message=new MimeMessage(session);
        InternetAddress[] address = InternetAddress.parse( destination);

        message.setRecipients(Message.RecipientType.TO, address);
        message.setFrom(new InternetAddress(source));
        if (cco != null) {
            InternetAddress[] addressBCC = InternetAddress.parse( cco);
            message.setRecipients(Message.RecipientType.BCC , addressBCC);
        }

        if (cc != null) {
            InternetAddress[] addressCC = InternetAddress.parse( cc);
            message.setRecipients(Message.RecipientType.CC , addressCC);
        }

        message.setSubject(subject);
        message.setContent(content,format);
        message.setSentDate(new Date());
        Transport transport = session.getTransport(address[0]);
        transport.connect(mailHost, user, password);
        transport.sendMessage(message, message.getAllRecipients());
        transport.close();
    } catch(Exception e) {
        throw new SurException (e.getMessage());
    }
    }

    public LinkedList getDBDestinos ( Connection dbCon, int oficina, String operacion) throws SurException {
        LinkedList lDest = new LinkedList();
        ResultSet rs = null;
        CallableStatement cons = null;
       try {
           
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("MAIL_GET_ALL_DESTINOS (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt    (2, oficina);
            cons.setString (3, operacion);

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
            cons.close ();
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Sql al obtener los destinos: " + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error al obtener los destinos: " + e.getMessage());
        } finally {
            try{
                if (cons != null)  cons.close ();
                if (rs != null)  rs.close ();
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return lDest;
        }
    }        

    /* Metodo setear Starttls = true con mailHost gmail */
    public void setEnableStarttls(Boolean enable) {        
        properties.setProperty("mail.smtp.starttls.enable", enable.toString());
    }

/**
* Añade el contenido base al multipart
* @throws Exception Excepcion levantada en caso de error
*/
public void addContentToMultipart() throws Exception {
// first part (the html)
    BodyPart messageBodyPart = new MimeBodyPart();
    String htmlText = this.getContent();
    messageBodyPart.setContent(htmlText, "text/html");
    this.multipart.addBodyPart(messageBodyPart);
    }
// -----
/**
* Añade el contenido base al multipart
* @param htmlText contenido html que se muestra en el mensaje de correo
* @throws Exception Excepcion levantada en caso de error
*/
public void addContent(String htmlText) throws Exception {
// first part (the html)
    BodyPart messageBodyPart = new MimeBodyPart();
    messageBodyPart.setContent(htmlText, "text/html");
    this.multipart.addBodyPart(messageBodyPart);
}
// -----
/**
* Añade al mensaje un cid:name utilizado para guardar las imagenes referenciadas
* en el HTML de la forma  <img src=cid:name />
* @param cidname identificador que se le da a la imagen. suele ser un string generado aleatoriamente.
* @param pathname ruta del fichero que almacena la imagen
* @throws Exception excepcion levantada en caso de error
*/
public void addCID(String cidname,String pathname) throws Exception {
    DataSource fds = new FileDataSource(pathname);
    BodyPart messageBodyPart = new MimeBodyPart();
    messageBodyPart.setDataHandler(new DataHandler(fds));
    messageBodyPart.setHeader("Content-ID","<"+cidname+">");
    this.multipart.addBodyPart(messageBodyPart);
}
// ----
/**
* Añade un attachement al mensaje de email
* @param pathname ruta del fichero
* @throws Exception excepcion levantada en caso de error
*/
public void addAttach(String pathname) throws Exception {
    File file = new File(pathname);
    BodyPart messageBodyPart = new MimeBodyPart();
    DataSource ds = new FileDataSource(file);
    messageBodyPart.setDataHandler(new DataHandler(ds));
    messageBodyPart.setFileName(file.getName());
    messageBodyPart.setDisposition(Part.ATTACHMENT);
    this.multipart.addBodyPart(messageBodyPart);
}

/**
* Envia un correo multipart
* @throws Exception Excepcion levantada en caso de error
*/
public void sendMultipart() throws Exception {

    try {
       Session mailSession = Session.getDefaultInstance(properties);
       /* esta configuracion e spara google, es el 2do. parametro de Session.getDefault...
         ,
			new javax.mail.Authenticator() {
				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(user, password);
				}
			});
        *
        */

        mailSession.setDebug(false);
        InternetAddress[] address = InternetAddress.parse( destination);

        MimeMessage message = new MimeMessage(mailSession);
        message.setSubject  (subject);

        Address fromAddr = new InternetAddress (source);
        message.setFrom (fromAddr);
        message.setRecipients(Message.RecipientType.TO, address);

        if (cco != null) {
            InternetAddress[] addressBCC = InternetAddress.parse( cco);
            message.setRecipients(Message.RecipientType.BCC , addressBCC);
        }

        if (cc != null) {
            InternetAddress[] addressCC = InternetAddress.parse( cc);
            message.setRecipients(Message.RecipientType.CC , addressCC);
        }

        // put everything together
        message.setContent(multipart);
        Transport transport = mailSession.getTransport(address[0]);

        transport.connect(mailHost, user, password);

        transport.sendMessage(message, message.getAllRecipients());

        transport.close();
    }   catch ( MessagingException mex) {
        throw new Exception (mex);
/*        mex.printStackTrace();
        Exception ex = null;
        if ((ex = mex.getNextException()) != null) {
            ex.printStackTrace();
       }
 *
 */
    }
 }
    
    public void sendMessageBatch () throws SurException {
       FileOutputStream fos = null;
       OutputStreamWriter osw = null;
       BufferedWriter bw = null;
        StringBuilder sb = new StringBuilder();
       try {
            Random r;
            r=new Random();
            r.setSeed(new Date().getTime());
            String _fileName = "/opt/tomcat/webapps/benef/files/mensajes/mensaje" + r.nextInt(10000) + ".txt";
            if ( System.getProperty("os.name" ).contains("Windows")) {
                _fileName = "C:\\benefweb\\www\\files\\mensajes\\mensaje" + r.nextInt(10000) + ".txt";
            }

           fos = new FileOutputStream ( _fileName );
           osw = new OutputStreamWriter (fos,"UTF-8");
           bw =  new BufferedWriter (osw);

           sb.append( source == null ? "sistemas@beneficio.com.ar" : source);
           sb.append("&&");
           sb.append(destination).append("&&");
           sb.append(cco == null ? "null" : cco).append("&&");
           sb.append(cc == null ? "null" : cc).append("&&");
           sb.append(subject).append("&&");
           sb.append(content);
           
           bw.write( sb.toString() );
           bw.flush();
           
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                bw.close();
                osw.close();
                fos.close();
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        }
        }
    }

}    