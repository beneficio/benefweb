<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
   Usuario usu = (Usuario) session.getAttribute("user");
    // Variables
    int count=0;        

    // Initialization
    mySmartUpload.initialize(pageContext);

    // Only allow txt or htm files
    mySmartUpload.setAllowedFilesList("xls");

    // DeniedFilesList can also be used :
    mySmartUpload.setDeniedFilesList("exe,bat,jsp,bmp,tif");

    // Deny physical path
    mySmartUpload.setForcePhysicalPath(false);

    // Only allow files smaller than 50000 bytes
//    mySmartUpload.setMaxFileSize(500000);

    // Upload	
    mySmartUpload.upload();

    // Save the files with their original names in a virtual path of the web server
     //Request requestSmart = mySmartUpload.getRequest();

   
   String[] cod_textos   = mySmartUpload.getRequest().getParameterValues("cod_texto");
   String[] cod_gestion  = mySmartUpload.getRequest().getParameterValues("cod_gestion");
   String[] cod_template = mySmartUpload.getRequest().getParameterValues("cod_template");

    Random r;
    r=new Random();
    r.setSeed(new Date().getTime());
    String sFile = usu.getusuario() + "@" + r.nextInt(10000) + ".xls";
    System.out.println( sFile);

   String url = Param.getAplicacion() + "servlet/GestionCobServlet?opcion=setImportarExcel&cod_gestion="+
           cod_gestion [0] + "&cod_texto=" + cod_textos [0] + "&name_file=" + sFile + "&cod_template=" + cod_template[0];

    try {
        com.jspsmart.upload.File myFile = mySmartUpload.getFiles().getFile(0);
	// Save it only if this file exists
          
	if (!myFile.isMissing()) {
            String nameFile = "/files/gestionCob/" + sFile;
	    // Save the files with its original names in a virtual path of the web server       
   	    myFile.saveAs (nameFile , mySmartUpload.SAVE_VIRTUAL);
	    // myFile.saveAs("/upload/" + myFile.getFileName(), mySmartUpload.SAVE_PHYSICAL);
        }
        // count = mySmartUpload.save("/files/nominas", mySmartUpload.SAVE_VIRTUAL);

        
    } catch (Exception e){
        throw new SurException("Error al enviar el archivo" + e.getMessage());
    }

   response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
   response.setHeader( "Location", url);
%>

