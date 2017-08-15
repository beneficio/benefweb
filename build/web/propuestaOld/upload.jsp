<%@page contentType ="text/html" errorPage   = "/error.jsp"%>
<%@page import="java.sql.*"%>
<%@page import="com.jspsmart.upload.*"%>
<%@page import="com.business.util.*"%>

<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Hashtable"%>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<%
    // Variables
    int count=0;        
    String nameNomina = null;

    // Initialization
    mySmartUpload.initialize(pageContext);

    // Only allow txt or htm files
    mySmartUpload.setAllowedFilesList("xls");

    // DeniedFilesList can also be used :
    mySmartUpload.setDeniedFilesList("exe,bat,jsp,bmp,tif");

    // Deny physical path
    mySmartUpload.setForcePhysicalPath(false);

    // Only allow files smaller than 50000 bytes
    mySmartUpload.setMaxFileSize(500000);

    // Upload	
    mySmartUpload.upload();

    // Save the files with their original names in a virtual path of the web server
    // Request requestSmart = mySmartUpload.getRequest();

    String sNumProp  = request.getParameter("num_propuesta") ;

    int cantVidas = 0;
    if ( request.getParameter ("prop_cantVidas") != null && 
        !request.getParameter ("prop_cantVidas").equals("") ) {
           cantVidas  = Integer.parseInt( request.getParameter ("prop_cantVidas") );
    }        
    int codRama = 0;                                    
    if ( request.getParameter ("prop_rama") != null && 
         !request.getParameter ("prop_rama").equals("") ) {                 
         codRama  = Integer.parseInt( request.getParameter ("prop_rama") );    
    }        

    try {
        com.jspsmart.upload.File myFile = mySmartUpload.getFiles().getFile(0);

       

	// Save it only if this file exists
          
	if (!myFile.isMissing()) {
            
            
            nameNomina = "/files/nominas/" + sNumProp  +"@" + "nomina.xls";
	    // Save the files with its original names in a virtual path of the web server       
   	    myFile.saveAs( nameNomina , mySmartUpload.SAVE_VIRTUAL);
	    // myFile.saveAs("/upload/" + myFile.getFileName(), mySmartUpload.SAVE_PHYSICAL);
        }
        // count = mySmartUpload.save("/files/nominas", mySmartUpload.SAVE_VIRTUAL);	  
         
    } catch (Exception e){

        throw new SurException("Error al enviar el archivo" + e.getMessage());

    }

   // Propuesta VO -SUP  15-11-2006 (Rama=21)
   // Propuesta VC -SUP  21-10-2007 (Rama=22) >>>>>>>>>>
   String url;
   // if (codRama == 21) {
   if ( codRama == 21 || codRama == 22 ) {
   // Propuesta VC -SUP  21-10-2007 >>>>>>>>>>
       url = "/benef/servlet/PropuestaServlet?opcion=getNominaXls&num_propuesta="+sNumProp+"&path="+nameNomina + "&prop_cantVidas="+cantVidas + "&prop_rama=" + codRama;
       
   } else {
       url = "/benef/servlet/PropuestaServlet?opcion=getPropuestaXls&num_propuesta="+sNumProp+"&path="+nameNomina + "&prop_cantVidas="+cantVidas;
   }   
   /* ---------------------------------------------------------------*/

   response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
   response.setHeader( "Location", url);


%>

