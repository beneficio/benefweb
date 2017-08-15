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
            mySmartUpload.setAllowedFilesList("zip,htm,html,ppt,doc,txt,pdf,xls,jpg,ZIP,HTML,HTM,PPT,DOC,TXT,PDF,XLS,JPG");

	// DeniedFilesList can also be used :
            mySmartUpload.setDeniedFilesList("exe,bat,jsp,EXE,BAT,JSP");

	// Deny physical path
            mySmartUpload.setForcePhysicalPath(true);

	// Only allow files smaller than 50000 bytes
            mySmartUpload.setMaxFileSize(5097152);

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
            if (iSizeArchivo > 0) {
                nameFile  = myFile.getFileName();
                attachment = myFile.getFileName();

                attachment = "/files/manuales/" + nameFile;

                myFile.saveAs(attachment);
            }
        }
    } catch ( SmartUploadException e ) { 
        throw new SurException("Error al enviar el archivo" + e.getMessage());
    }

   	Connection dbCon = null;
        dbCon           = db.getConnection();
        CallableStatement cons = null;    
	String nameNovedad = null;
        try {
            cons = dbCon.prepareCall(db.getSettingCall("PUB_SET_MANUAL(?, ?, ?, ?, ?,?, ?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setString  (2, requestSmart.getParameter("titulo"));
            cons.setString  (3, requestSmart.getParameter("categoria"));
            cons.setInt     (4, Integer.parseInt(requestSmart.getParameter("cod_compania")));
            cons.setString  (5, requestSmart.getParameter("detalle"));
            cons.setString  (6, nameFile );
            cons.setInt     (7, Integer.parseInt(requestSmart.getParameter("orden")));
            cons.setInt     (8, Integer.parseInt(requestSmart.getParameter("tipoUsuario")));
            cons.setInt     (9, Integer.parseInt(requestSmart.getParameter("seccion")));

            cons.execute();

        }  catch (SQLException se) {
		throw new SurException("SQLException: grabar el Manual: " + se.getMessage());
        }  catch (Exception e) {
		throw new SurException("Exception: grabar el Manual" + e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
	// Save the files with their original names in a virtual path of the web server
 response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
 response.setHeader("Location","/benef/publicador/viewManuales.jsp");

%>