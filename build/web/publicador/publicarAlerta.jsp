<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Alerta"%>
<%
    Usuario usu = (Usuario) session.getAttribute("user");
    if (usu.getiCodTipoUsuario() != 0) {
        request.setAttribute("javax.servlet.jsp.jspException", new SurException ("acceso denegado"));
        getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
    } 
    
    Alerta alerta = new Alerta();
    alerta.setcodAlerta   ( Integer.parseInt (request.getParameter ("codAlerta")));
   
    if (request.getParameter ("mca_publica") == null ) { 
        alerta.settitulo      ( request.getParameter("titulo"));
        alerta.settipoUsuario ( Integer.parseInt (request.getParameter("tipoUsuario")));
        alerta.setfechaDesde  ( request.getParameter("fecha").equals ("") ? null : Fecha.strToDate (request.getParameter("fecha")));
        alerta.setfechaHasta  ( request.getParameter("vencimiento").equals ("") ? null : Fecha.strToDate (request.getParameter("vencimiento")));
        alerta.setsBody       ( request.getParameter("html"));
        alerta.setalto        ( Integer.parseInt(request.getParameter ("alto")));
        alerta.setancho       ( Integer.parseInt(request.getParameter ("ancho")));
    } else {
        alerta.setmcaPublica   (request.getParameter ("mca_publica"));
    }
    alerta.setuserId      ( usu.getusuario());

   Connection dbCon = null;
try {
    dbCon = db.getConnection();

    if (request.getParameter ("mca_publica") == null ) { 
        alerta.setDB(dbCon);
    } else {
        alerta.setDBcambiarMcaPublica(dbCon);
    }
    if (alerta.getiNumError() < 0) { 
        throw new SurException (alerta.getsMensError());
    }
} catch (Exception e) {
    throw new SurException (e.getMessage());
} finally {
    db.cerrar(dbCon);
}
 // Save the files with their original names in a virtual path of the web server
 response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
 response.setHeader("Location","/benef/publicador/viewAlertas.jsp");
    %>