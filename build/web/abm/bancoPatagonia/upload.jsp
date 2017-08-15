<%@page contentType ="text/html" errorPage= "/error.jsp"%>
<%@page import="java.sql.*"%>
<%@page import="com.jspsmart.upload.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.util.Random"%>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<%
  // Variables
    int count=0;        

    // Initialization
    mySmartUpload.initialize(pageContext);

    // Only allow txt or htm files
    mySmartUpload.setAllowedFilesList("780");

    // DeniedFilesList can also be used :
    mySmartUpload.setDeniedFilesList("exe,bat,jsp,bmp,tif,txt");

    // Deny physical path
    mySmartUpload.setForcePhysicalPath(false);

    // Only allow files smaller than 50000 bytes
//    mySmartUpload.setMaxFileSize(500000);

    // Upload	
    try {
    mySmartUpload.upload();
    } catch (Exception e ) {
        throw new SurException("Error en el mySmartUpload.upload() -->" + e.getMessage());
    }

    // Save the files with their original names in a virtual path of the web server
     //Request requestSmart = mySmartUpload.getRequest();


   String nameFile = "";
    try {
        com.jspsmart.upload.File myFile = mySmartUpload.getFiles().getFile(0);
	// Save it only if this file exists
	if (!myFile.isMissing()) {
            nameFile = myFile.getFileName() ; 
	    // Save the files with its original names in a virtual path of the web server       
   	    myFile.saveAs ( "/files/trans/" + myFile.getFileName() , mySmartUpload.SAVE_VIRTUAL);
	    // myFile.saveAs("/upload/" + myFile.getFileName(), mySmartUpload.SAVE_PHYSICAL);

        } else {
            System.out.println ("myFile.isMissing() --> BANCO PATAGONIA"  );
        }
       
    } catch (Exception e){
        throw new SurException("Error al enviar el archivo" + e.getMessage());
    }

   String url = Param.getAplicacion() + "servlet/BancoPatagoniaServlet?opcion=procesarRespuesta&file=" + nameFile;

   response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
   response.setHeader( "Location", url);
%>

