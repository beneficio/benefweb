<%@page contentType="text/html" %>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Persona"%>
<%@page import="com.business.db.*"%>
<%@page import="java.sql.*"%>
<%@page import="com.jspsmart.upload.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="javax.mail.*"%>
<%@page import="javax.mail.internet.*"%>
<%@page import="javax.activation.*"%>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<%
        // Variables
       String ok = "ok";
       boolean enviar = false;
        int    count=0;
        String attachment = null;
        String nameFile = null;
        StringBuilder sMensaje = new StringBuilder();
        boolean _serverMailGmail = false;
        Connection dbCon = null;

    try {
        // Initialization
        mySmartUpload.initialize(pageContext);
        // Only allow txt or htm files
        mySmartUpload.setAllowedFilesList("ppt, PPT, DOC,doc,pdf,PDF,,");
        // DeniedFilesList can also be used :
        mySmartUpload.setDeniedFilesList("gif,jpg,jpeg,xls,exe,bat,jsp,bmp,tif");
        // Deny physical path
        mySmartUpload.setForcePhysicalPath(false);
        // Only allow files smaller than 100000 bytes
        mySmartUpload.setMaxFileSize(1000000);
        // Deny upload if the total fila size is greater than 200000 bytes
        // mySmartUpload.setTotalMaxFileSize(200000);

        // Upload
        mySmartUpload.upload();
        // Save the files with their original names in a virtual path of the web server

        Request requestSmart = mySmartUpload.getRequest();

        String sNombre      = requestSmart.getParameter("nombre");
  //      String sEdad        = requestSmart.getParameter("edad");
        String sDomicilio   =  requestSmart.getParameter("domicilio");
        String sLocalidad   =  requestSmart.getParameter("localidad");
        String sEmail       =  requestSmart.getParameter("email");
        String sTelefono1   =  requestSmart.getParameter("telefono1");
        String sTelefono2   =  requestSmart.getParameter("telefono2");
        String sProvincia   =  requestSmart.getParameter("provincia");
        String sPostula     =  requestSmart.getParameter("postula");
        String sExperiencia =  requestSmart.getParameter("experiencia");


        sMensaje.append("INGRESO UN NUEVO CURRICULUM DESDE BENEFICIO WEB.<br><br>");
        sMensaje.append("FECHA      : ").append(Fecha.getFechaActual()).append("<br><br>");
        sMensaje.append("NOMBRE     : ").append(sNombre).append("<br><br>");
        sMensaje.append("SECTOR AL QUE SE POSTULA: ").append(sPostula ).append("<br><br>");
//        sMensaje.append("EDAD       : " + sEdad + "<br>");
        sMensaje.append("DOMICILIO  : ").append(sDomicilio).append("<br>");
        sMensaje.append("LOCALIDAD  : ").append(sLocalidad).append("<br>");
        sMensaje.append("PROVINCIA  : ").append(sProvincia).append("<br>");
        sMensaje.append("TELEFONOS  : ").append(sTelefono1).append("   " + sTelefono2 + "<br>");
        sMensaje.append("EMAIL      : ").append(sEmail).append("<br>");
        sMensaje.append("EXPERIENCIA: ").append(sExperiencia ).append("<br>");

        int iSizeArchivo = 0;
        com.jspsmart.upload.File myFile = mySmartUpload.getFiles().getFile(0);
        
        if ( myFile != null ) {
    //Cuanto pesa el archivo?
            iSizeArchivo = myFile.getSize();
        // Save it only if this file exists
            nameFile  = myFile.getFileName();
            attachment = myFile.getFileName();

            attachment = "/files/curriculum/" + nameFile;

            myFile.saveAs(attachment); 

            enviar = true;
        }
    } catch ( SmartUploadException e ) { 
        ok = "Error al recibir el Curriculum:" + e.getMessage();
    } catch (Exception se) {
        ok = se.getMessage();
    } finally {

	// create some properties and get the default Session

        String from     = "webmaster@beneficio.com.ar";
	String subject  = "Beneficio Web - Aviso de recepción de Curriculum Vitae";
        String msgText1 = sMensaje.toString();
        if (enviar == false) {
            msgText1 = ok;
        }
        boolean debug   = false;

	try {
            if (Param.getRealPath() == null) {
                Param.realPath (getServletContext().getRealPath("/propiedades/config.xml"));
                db.realPath (getServletConfig().getServletContext ().getRealPath("/propiedades/config.xml"));
            }


            dbCon = db.getConnection();
	    // create a message

            Email mail = new Email();
            // ------------------------------
            // Configuracion Local mail Gmail
            if ( _serverMailGmail ) {
                mail.setEnableStarttls(true);
            }
            mail.setSource      (from);
            mail.setSubject     (subject);
            mail.addContent     (sMensaje.toString());

            if (enviar == true ) {
                mail.addAttach(session.getServletContext().getRealPath( attachment ));
            }
            LinkedList lDest = mail.getDBDestinos(dbCon, 0, "CURRICULUM");
            for (int i=0; i < lDest.size();i++) {
                Persona oPers = (Persona) lDest.get(i);
                mail.setDestination(oPers.getEmail());
                mail.sendMultipart(); //Message("text/html");
            }
	    
	} catch (MessagingException mex) {
            ok = mex.getMessage();
	} finally {
            db.cerrar(dbCon);
            }
        }
     response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
     response.setHeader( "Location", Param.getAplicacion() + "portal/cvForm.jsp?ok=" + ok);

%>
 
