<%@page contentType ="text/html" errorPage   = "/error.jsp"%>
<%@page import="java.sql.*"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.jspsmart.upload.*"%>
<%@page import="java.util.Date"%>
<%
   	Connection dbCon = null;
        dbCon           = db.getConnection();
        CallableStatement cons = null;    
	String nameNovedad = null;
        try {
            cons = dbCon.prepareCall(db.getSettingCall("PUB_SET_SECCION(?, ?, ?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setString  (2, request.getParameter("titulo"));
            cons.setInt     (3, Integer.parseInt(request.getParameter("cod_compania")));
            cons.setInt     (4, 0);
            cons.setInt     (5, Integer.parseInt(request.getParameter("tipoUsuario")));
            cons.execute();

        }  catch (SQLException se) {
		throw new SurException("SQLException: grabar LA SECCION: " + se.getMessage());
        }  catch (Exception e) {
		throw new SurException("Exception: grabar LA SECCION" + e.getMessage());
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