<%@page contentType="text/html" %>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.jspsmart.upload.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="javax.mail.*"%>
<%@page import="javax.mail.internet.*"%>
<%@page import="javax.activation.*"%>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />    
<%
    // Variables
    int    count=0;                
    String attachment , nameFile;
    StringBuffer sMensaje = new StringBuffer();
    // Initialization
    mySmartUpload.initialize(pageContext);
    // Only allow txt or htm files
    mySmartUpload.setAllowedFilesList("DOC,doc,,");
    // DeniedFilesList can also be used :
    mySmartUpload.setDeniedFilesList("gif,jpg,jpeg,xls,pdf,exe,bat,jsp,bmp,tif");
    // Deny physical path
    mySmartUpload.setForcePhysicalPath(false);
    // Only allow files smaller than 100000 bytes
    mySmartUpload.setMaxFileSize(100000); 
    // Deny upload if the total fila size is greater than 200000 bytes
    // mySmartUpload.setTotalMaxFileSize(200000);

    // Upload	
    mySmartUpload.upload();
    // Save the files with their original names in a virtual path of the web server

    attachment = null;
    nameFile = null;

    Request requestSmart = mySmartUpload.getRequest();

    String sNombre      = requestSmart.getParameter("nombre");
    String sEdad        = requestSmart.getParameter("edad");
    String sDomicilio   =  requestSmart.getParameter("domicilio");
    String sLocalidad   =  requestSmart.getParameter("localidad");
    String sEmail       =  requestSmart.getParameter("email");
    String sTelefono1   =  requestSmart.getParameter("telefono1");
    String sTelefono2   =  requestSmart.getParameter("telefono2");
    String sProvincia   =  requestSmart.getParameter("provincia");
    String sPostula     =  requestSmart.getParameter("postula");
    String sExperiencia =  requestSmart.getParameter("experiencia");


    sMensaje.append("INGRESO UN NUEVO CURRICULUM DESDE BENEFICIO WEB.\n\n");
    sMensaje.append("FECHA      : " + Fecha.getFechaActual() + "\n\n");
    sMensaje.append("NOMBRE     : " + sNombre + "\n\n");
    sMensaje.append("SECTOR AL QUE SE POSTULA: " +sPostula + "\n\n");
    sMensaje.append("EDAD       : " + sEdad + "\n");
    sMensaje.append("DOMICILIO  : " + sDomicilio + "\n");
    sMensaje.append("LOCALIDAD  : " + sLocalidad + "\n");
    sMensaje.append("PROVINCIA  : " + sProvincia + "\n");
    sMensaje.append("TELEFONOS  : " + sTelefono1 +  "   " + sTelefono2 + "\n");
    sMensaje.append("EMAIL      : " + sEmail + "\n");
    sMensaje.append("EXPERIENCIA: " + sExperiencia + "\n");

    int iSizeArchivo = 0;
    try {
        com.jspsmart.upload.File myFile = mySmartUpload.getFiles().getFile(0);
        
        if ( myFile != null ) {
    //Cuanto pesa el archivo?
            iSizeArchivo = myFile.getSize();
        // Save it only if this file exists
            nameFile  = myFile.getFileName();
            attachment = myFile.getFileName();

            attachment = "/files/curriculum/" + nameFile;

            myFile.saveAs(attachment); 
        }
    } catch ( SmartUploadException e ) { 
        throw new SurException("Error al enviar el archivo" + e.getMessage());
    }

	// create some properties and get the default Session
	Properties props = System.getProperties();
        props.put("mail.transport.protocol", "smtp");
        props.put("mail.smtp.host", "192.168.2.178");
        props.put("mail.smtp.port", "25");         

        String from     = "webmaster@beneficio.com.ar";
        String to       = "veficovich@beneficio.com.ar";
        String to2       = "webmaster@beneficio.com.ar";
	String subject  = "Beneficio Web - Aviso de recepción de Curriculum Vitae";
        String msgText1 = sMensaje.toString();
        boolean debug   = false;

	javax.mail.Session sesion = javax.mail.Session.getInstance(props, null);
	sesion.setDebug(debug);
	
	try {
	    // create a message
	    MimeMessage msg = new MimeMessage(sesion);
	    msg.setFrom(new InternetAddress(from));
	    InternetAddress[] address = {new InternetAddress(to),new InternetAddress(to2)};
	    msg.setRecipients(Message.RecipientType.TO, address);
	    msg.setSubject(subject);

	    // create and fill the first message part
	    MimeBodyPart mbp1 = new MimeBodyPart();
	    mbp1.setText(msgText1);

	    // create the Multipart and add its parts to it
	    Multipart mp = new MimeMultipart();
	    mp.addBodyPart(mbp1);

	    // create the second message part
            MimeBodyPart mbp2 = new MimeBodyPart();

            // attach the file to the message
            FileDataSource fds = new FileDataSource(session.getServletContext().getRealPath( attachment ));
            mbp2.setDataHandler(new DataHandler(fds));
            mbp2.setFileName(fds.getName());
            mp.addBodyPart(mbp2);
                // add the Multipart to the message
            msg.setContent(mp);

	    // set the Date: header
	    msg.setSentDate(new Date());
	    
	    // send the message
	    Transport.send(msg);
	    
	} catch (MessagingException mex) {
	    mex.printStackTrace();
	    Exception ex = null;
	    if ((ex = mex.getNextException()) != null) {
		ex.printStackTrace();
	    }
	}
     response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
     response.setHeader( "Location", "/benef/ingreso_cv_ok.htm");

%>
 
