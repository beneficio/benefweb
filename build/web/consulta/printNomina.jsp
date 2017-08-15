<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.*"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %> 
<% Usuario usu = (Usuario) session.getAttribute("user");
   String sTipo     = (request.getParameter("formato") == null ? "HTML" : request.getParameter("formato"));
   String sUrl=  Param.getAplicacion() + "servlet/ConsultaServlet?opcion=getNomina&formato=" + request.getParameter("formato") +  
    "&cod_rama=" + request.getParameter("cod_rama") + "&num_poliza=" + request.getParameter("num_poliza"); 
    try { 
        sUrl =  java.net.URLEncoder.encode(sUrl,"UTF-8");

    } catch (java.io.UnsupportedEncodingException e) 
        { 
             System.out.println(e.getMessage()); 
        } 

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <script type="text/javascript" language="JavaScript">
      
     function Salir () {
         if ( BrowserDetect.browser == 'Explorer') {
             window.history.go(-1);
         } else {
            window.history.back(-1);
         }
     }
     function Print () {
          if ( BrowserDetect.browser == 'Explorer') {
            document.oFramePoliza.focus ();
            document.oFramePoliza.print ();
          } else {
            window.frames['oFramePoliza'].focus(); 
            window.frames['oFramePoliza'].print(); 
          }
     }
    </script>
</head>
<body>
    <table cellSpacing="0" cellPadding="0" width="960" align="center" border="0">
        <tr>
            <td>
                <jsp:include page="/header.jsp">
                    <jsp:param name="aplicacion" value="<%= Param.getAplicacion() %>" />
                    <jsp:param name="usuario" value="<%= usu.getusuario() %>" />
                    <jsp:param name="descripcion" value="<%= usu.getRazonSoc() %>" />
                </jsp:include>
                <div class="menu">
                    <menu:renderMenuFromDB    aplicacion="1"  userLogon="<%= usu.getusuario()%>" />
                </div>
            </td>
        </tr>
    <tr>
        <td valign="top" align="center" width='100%' height='450'>
<% if ( sTipo.equals ("HTML")) {
    %>
       <jsp:include page="/include/preview.jsp" flush="true">
            <jsp:param name="url" value="<%= sUrl %>"/>
        </jsp:include>
<% } else {
    %>
        <jsp:include page="/include/mostrarReporte.jsp" flush="true">
            <jsp:param name="url" value="<%= sUrl %>"/>
        </jsp:include>
<%  }
    %>
        </td>
    </tr>
    <tr valign="bottom" >
        <td width="100%" align="center" valign="middle">
            <input type="button" name="cmdSalir"  value="  Salir  "  height="20px" class="boton" onClick="Salir ();"/>&nbsp;&nbsp;&nbsp;
            <input type="button" name="cmdPrint"  value=" Imprimir "  height="20px" class="boton" onClick="Print ();"/>
        </td>
    </tr>
     <tr>
        <td valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
    </tr>
</table>
</body>

