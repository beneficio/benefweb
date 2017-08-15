<%@page contentType="text/html" %>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Persona"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.sql.Connection"%>
<%
    // Variables
    Connection dbCon    = null;
    String sNombre      = request.getParameter("nombre");
    String sEdad        = request.getParameter("edad");
    String sDomicilio   =  request.getParameter("domicilio");
    String sLocalidad   =  request.getParameter("localidad");
    String sEmail       =  request.getParameter("email");
    String sTelefono1   =  request.getParameter("telefono1");
    String sTelefono2   =  request.getParameter("telefono2");
    String sProvincia   =  request.getParameter("provincia");
    String sPostula     =  request.getParameter("postula");
    String sExperiencia =  request.getParameter("experiencia");

    StringBuffer sMensaje = new StringBuffer();
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
    sMensaje.append("EXPERIENCIA: " + sExperiencia + "\n\n");
    sMensaje.append("No hay archivo adjunto" + "\n");

	// create some properties and get the default Session
                Email oEmail = new Email ();
                oEmail.setSubject("Beneficio Web - Aviso de recepción de Curriculum Vitae" );

                oEmail.setContent(sMensaje.toString());
                
                dbCon = db.getConnection();
                LinkedList lDest = oEmail.getDBDestinos(dbCon, 0, "CURRICULUM");
                
                for (int i=0; i < lDest.size();i++) {
                    Persona oPers = (Persona) lDest.get(i);
                    oEmail.setDestination(oPers.getEmail());
                    oEmail.sendMessage();
                }

     response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
     response.setHeader( "Location", "/benef/ingreso_cv_ok.htm");

%>
 
