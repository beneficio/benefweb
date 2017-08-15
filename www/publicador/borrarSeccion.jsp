<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="java.sql.*"%>
<%@page import="com.business.db.*"%>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<%
Usuario usu = (Usuario) session.getAttribute("user"); 

    if (usu.getiCodTipoUsuario() != 0) {
        request.setAttribute("javax.servlet.jsp.jspException", new SurException ("acceso denegado"));
        getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
        
    }
   	Connection dbCon = null;
        dbCon           = db.getConnection();
        CallableStatement cons = null;    
	String nameNovedad = null;
        try {
            cons = dbCon.prepareCall(db.getSettingCall("PUB_DEL_SECCION(?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt (2, Integer.valueOf(request.getParameter ("codigo")));
            cons.execute();
        }  catch (SQLException se) {
			throw new SurException("Error al SQL - BORRAR SECCION: " + se.getMessage());
        }  catch (Exception e) {
			throw new SurException("Error al BORRAR SECCION" + e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
 	db.cerrar(dbCon);
        response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
        response.setHeader("Location","/benef/publicador/viewManuales.jsp");
%>
