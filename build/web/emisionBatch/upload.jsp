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
Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
  // Variables
    int count=0;        

    // Initialization
    mySmartUpload.initialize(pageContext);

    // Only allow txt or htm files
    mySmartUpload.setAllowedFilesList("csv");

    // DeniedFilesList can also be used :
    mySmartUpload.setDeniedFilesList("exe,bat,jsp,bmp,tif,txt");

    // Deny physical path
    mySmartUpload.setForcePhysicalPath(false);

    // Only allow files smaller than 50000 bytes
    //    mySmartUpload.setMaxFileSize(500000);
    // Upload	
    mySmartUpload.upload();


    // Save the files with their original names in a virtual path of the web server
        Request requestSmart = mySmartUpload.getRequest();

        String sTitulo      = requestSmart.getParameter("titulo");
        String sTipoEmision = requestSmart.getParameter("tipo_emision");
        String sNumLote     = requestSmart.getParameter ("F3lote_sel");
       String nameFile = "";
    try {

        com.jspsmart.upload.File myFile = mySmartUpload.getFiles().getFile(0);
	// Save it only if this file exists
	if (!myFile.isMissing()) {
            nameFile = myFile.getFileName() ;

            if ( sTipoEmision != null && ( ( sTipoEmision.equals ("R") && ! nameFile.equals("renovar.csv") ) ||
                                           ( sTipoEmision.equals ("E") && ! nameFile.equals("emitir.csv") ) ) ) {
                throw new SurException(" NOMBRE DE ARCHIVO INCORRECTO");
            }

            String osName = System.getProperty("os.name" );

            if ( osName.contains("Windows")) {
                if ( sTipoEmision != null && sTipoEmision.equals ("R") ) {
                    myFile.saveAs ( "C:\\benefweb\\www\\files\\trans\\renovar\\renovar_" + (sNumLote.equals("0") ? oUser.getusuario() : sNumLote) + ".csv"  , mySmartUpload.SAVE_PHYSICAL);
                } else {
                    myFile.saveAs ( "C:\\benefweb\\www\\files\\trans\\emitir\\" + myFile.getFileName() , mySmartUpload.SAVE_PHYSICAL);
                }
            } else {
                if ( sTipoEmision != null && sTipoEmision.equals ("R") ) {
                    myFile.saveAs ( "/opt/tomcat/webapps/benef/files/trans/renovar/renovar_" + (sNumLote.equals("0") ? oUser.getusuario() : sNumLote) + ".csv" , mySmartUpload.SAVE_PHYSICAL);
                } else {
                    myFile.saveAs ( "/files/trans/emitir/" + myFile.getFileName() , mySmartUpload.SAVE_VIRTUAL);
                }
            }
        }
       
    } catch (Exception e){
        throw new SurException("Error al enviar el archivo" + e.getMessage());
    }

   String sUrl = Param.getAplicacion() + "servlet/EmisionBatchServlet?opcion=validar&file=" + nameFile +
           "&titulo=" + sTitulo + "&tipo_emision=" + sTipoEmision + "&F3lote_sel=" + sNumLote;

//    try {
//        sUrl =  java.net.URLEncoder.encode(sUrl,"UTF-8");

//    } catch (java.io.UnsupportedEncodingException e)
//        {
//             System.out.println(e.getMessage());
//        }


   response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
   response.setHeader( "Location", sUrl);
%>

