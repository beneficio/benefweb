<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.*"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %> 
<% Usuario usu = (Usuario) session.getAttribute("user");
   String sTipo        = (request.getParameter("formato") == null ? "HTML" : request.getParameter("formato"));
   String numPropuesta = request.getParameter("numPropuesta");
   String sVolver = ( request.getParameter("volver") == null ? "" :  request.getParameter("volver")); 
   String sUrl=  Param.getAplicacion() + "servlet/PropuestaServlet?opcion=printPropuesta&formato=" + request.getParameter("formato") +  
   "&cod_rama=" + request.getParameter("cod_rama") + "&numPropuesta=" + numPropuesta; 
   
  try { 
      sUrl =  java.net.URLEncoder.encode(sUrl,"UTF-8");

  } catch (java.io.UnsupportedEncodingException e)   { 
      System.out.println(e.getMessage()); 
  } 

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Impresion de Propuesta</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <script type="text/javascript" language="javascript">
    function Salir () {

        if ( document.getElementById('volver').value == "-1" ) {
                 window.history.back(-1);
         } else {
            if (document.getElementById('volver').value == "filtrarPropuestas") {
                document.form1.action = "<%= Param.getAplicacion()%>propuesta/filtrarPropuestas.jsp";
            } else {
                document.getElementById('opcion').value = "getAllPol";
                document.form1.action = "<%= Param.getAplicacion()%>servlet/RenuevaServlet";
            }
            document.form1.submit();
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
<form name="form1" method="post" action="/servlet/ ">
    <input type="hidden" name="opcion" id="opcion" value="getAllProp"/>
    <input type="hidden" name="volver" id="volver" value="<%= sVolver%>"/>
</form>
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

