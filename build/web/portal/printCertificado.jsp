<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.*"%>
<%
   String numCert   = request.getParameter("numCert");
   String sUrl=  Param.getAplicacion() + "servlet/CertificadoServlet?opcion=getPrintCert&tipo_cert=PZ&numCert=" + numCert + "&tipo=pdf";
    try { 
        sUrl =  java.net.URLEncoder.encode(sUrl,"UTF-8");

    } catch (java.io.UnsupportedEncodingException e) 
        { 
             System.out.println(e.getMessage()); 
        } 

%>
<html xmlns="https://www.w3.org/1999/xhtml">
<head>
    <title>Impresion de Certificado</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <LINK rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css">	
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <SCRIPT language="javascript">
     volver = '-1';

     function Salir () {

        if ( volver == '-1' ) {
             if ( BrowserDetect.browser == 'Explorer') {
                 window.history.go(-1);
             } else {
                window.history.back(-1);
             }
        }

     }
    </SCRIPT>
</head>
<body  leftMargin=0 topMargin=5 marginheight="0" marginwidth="0">
<table cellSpacing="0" cellPadding="0" width="740"  height="600" align="center" border="0">
    <tr>
        <td valign="top" align="center" width='100%' height='100%'>
        <jsp:include page="/include/mostrarReporte.jsp" flush="true">
            <jsp:param name="url" value="<%= sUrl %>"/>
        </jsp:include>
        </td>
    </tr>
    <tr valign="bottom" >
        <td width="100%" align="center" valign="middle">
            <input type="button" name="cmdSalir"  value="  Salir  "  height="20px" class="boton" onClick="Salir ();">
        </td>
    </tr>
</table>
</body>

