<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/benef/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.*"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>
<% Usuario usu = (Usuario) session.getAttribute("user");
   String sTipo        = (request.getParameter("formato") == null ? "HTML" : request.getParameter("formato"));
   String numPropuesta = request.getParameter("numPropuesta");
   String sVolver = ( request.getParameter("volver") == null ? "" :  request.getParameter("volver")); 
   String sUrl=  Param.getAplicacion() + "servlet/CaucionServlet?opcion=printCaucion&formato=" + request.getParameter("formato") +
   "&cod_rama=" + request.getParameter("cod_rama") + "&numPropuesta=" + numPropuesta; 
  
  try { 
      sUrl =  java.net.URLEncoder.encode(sUrl,"UTF-8");

  } catch (java.io.UnsupportedEncodingException e)   { 
      System.out.println(e.getMessage()); 
  } 

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<link rel="icon" href="http://www.beneficioweb.com.ar/favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
    <SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <SCRIPT language="javascript">
    function Salir () 
    {
    <% if (sVolver.equals ("-1")) {
    %>
//         if ( BrowserDetect.browser == 'Explorer') {
             window.history.back(-1);
//         } else {
//            window.back();
//         }
    <%} else {
    %>
//        if ( BrowserDetect.browser == 'Explorer') {
//            window.location =  "<%= Param.getAplicacion()%>servlet/PropuestaServlet?opcion=getAllProp";
//        } else {
            window.location =  "<%= Param.getAplicacion()%>servlet/PropuestaServlet?opcion=getAllProp";
//        }
    <%}
    %>
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
            <input type="button" name="cmdSalir"  value="  Salir  "  height="20px" class="boton" onClick="javascript:Salir ();">&nbsp;&nbsp;&nbsp;
            <input type="button" name="cmdPrint"  value=" Imprimir "  height="20px" class="boton" onClick="javascript:Print ();">
        </td>
    </tr>
     <TR>
        <TD valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
    </tr>
</table>
</body>

