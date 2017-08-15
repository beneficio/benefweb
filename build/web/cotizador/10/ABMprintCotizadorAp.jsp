<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.*"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>
<%
   Usuario usu = (Usuario) session.getAttribute("user"); 
   String numCot   = request.getParameter("numCotizacion");
   String sTipo    = (request.getParameter("tipo") == null ? "html" : request.getParameter("tipo"));
   String sOrigen  = (request.getParameter("origen") == null ? "" : request.getParameter("origen"));
   String sUrl=  Param.getAplicacion() + "servlet/CotizadorApServlet?opcion=getPrintCot&numCotizacion=" + numCot + "&tipo=" + sTipo; 
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
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/alttxt.js"></script>
<SCRIPT type="text/javascript" language="javascript">
     function Salir () {
      window.location.replace("<%= Param.getAplicacion()%>index.jsp");
     }
     function Print () {
        document.oFramePoliza.focus ();
        document.oFramePoliza.print ();
     }

    function Volver ( numCotizacion ) {
  
      <% if (sOrigen.equals("cotizacion")){%>
            var sUrl= "<%= Param.getAplicacion() %>servlet/CotizadorApServlet";
            sUrl += "?opcion=getCot";
            sUrl += "&tipo=html";
            sUrl += "&numCotizacion=<%=numCot%>";
            window.location.replace( sUrl );
        <% }else{%>
            window.history.back();
        <% }%>
    }
    </SCRIPT>
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
<% if ( sTipo.equals ("html")) {
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
            <input type="button" name="cmdSalir"  value="  Salir  "  height="20px" class="boton" onClick="Salir ();">&nbsp;&nbsp;&nbsp;
            <input type="button" name="cmdVolver" value="  Volver "  height="20px" class="boton" onClick="Volver();">&nbsp;&nbsp;&nbsp;
            <input type="button" name="cmdPrint"  value=" Imprimir "  height="20px" class="boton" onClick="Print ();">
        </td>
    </tr>
     <TR>
        <TD valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
    </tr>
</table>
<div id="navtxt" 
     class="navtext"
     style="visibility:hidden; position:absolute; top:0px; left:-400px;z-index:10000; padding:10px">
</div>
</body>

