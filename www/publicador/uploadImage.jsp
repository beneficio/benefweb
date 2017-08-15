<%@page contentType ="text/html" errorPage   = "/error.jsp"%>
<%@page import="java.sql.*"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.jspsmart.upload.*"%>
<%@page import="java.util.Date"%>
<%@page import="com.jspsmart.upload.*"%>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<%
	// Variables
            int    count, iSizeArchivo =0;                
            String attachment = "";
            String nameFile = "";

	// Initialization
            mySmartUpload.initialize(pageContext);

	// Only allow txt or htm files
            mySmartUpload.setAllowedFilesList("gif,bmp,jpg,png,GIF,BMP,JPG,PNG");

	// DeniedFilesList can also be used :
            mySmartUpload.setDeniedFilesList("exe,bat,jsp,EXE,BAT,JSP");

	// Deny physical path
            mySmartUpload.setForcePhysicalPath(true);

	// Only allow files smaller than 50000 bytes
            mySmartUpload.setMaxFileSize(1500000);

	// Deny upload if the total fila size is greater than 200000 bytes
	// mySmartUpload.setTotalMaxFileSize(200000);

	// Upload	
	   mySmartUpload.upload();

       Request requestSmart = mySmartUpload.getRequest();

    try {
        com.jspsmart.upload.File myFile = mySmartUpload.getFiles().getFile(0);
        
        if ( myFile != null ) {
            //Cuanto pesa el archivo?
            iSizeArchivo = myFile.getSize();
            // Save it only if this file exists
            nameFile  = myFile.getFileName();
            attachment = myFile.getFileName();

            attachment = "/publicador/upload/img/" + nameFile;

            myFile.saveAs(attachment); 
        }
    } catch ( SmartUploadException e ) { 
        throw new SurException("Error al enviar el archivo" + e.getMessage());
    }

 // Save the files with their original names in a virtual path of the web server
 response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
 response.setHeader("Location","/benef/publicador/imageBrowser.jsp");

%>