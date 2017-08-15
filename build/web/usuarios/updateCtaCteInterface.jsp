<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.db.db"%>
<%@page import="com.business.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.Date"%>
<%@page import="java.io.*"%>
<%  
    Usuario usu = (Usuario) session.getAttribute("user");
    if (usu.getiCodTipoUsuario() != 0) {
        request.setAttribute("javax.servlet.jsp.jspException", new SurException ("acceso denegado"));
        getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
    }

    System.out.println ("ingreso en cuentacorriente interface");    
    
    Connection dbCon = null; 
   
    try {

        dbCon = db.getConnection();

        Proceso oProc = new Proceso ();
        oProc.getDBUltimaCtaCte(dbCon, 0); // ultima cuenta corriente para usuarios internos

System.out.println ("ultima interface prod " + oProc.getdFechaFTP() );

        String sFecha = SimpleDateFormat("yyyy-MM-dd").format(oProc.getdFechaFTP());

System.out.println ("ultima interface prod  string " + sFecha  );        

        Parametro oParam = new Parametro ();

        oParam.setsCodigo("MAX_CIERRE_CTACTE_PROD");
        oParam.setsValor (sFecha);
        oParam.setsUserid (usu.getusuario());
        oParam.setDB (dbCon);

    } catch (Exception e) {
        throw new SurException (e.getMessage()); 
    }

    response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
    response.setHeader( "Location",  Param.getAplicacion() + "usuarios/formInterfaces.jsp");
%>
