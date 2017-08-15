<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.util.Diccionario"%>
<%@page import="java.util.*"%>
<%  Usuario usu = (Usuario) session.getAttribute("user");
    String opcion = request.getParameter ("opcion");
    String origen = request.getParameter ("ce_origen");
    String sUrl   =  Param.getAplicacion() + "servlet/CertificadoServlet?opcion="+opcion;
    if (origen.equals("filtrarCertificadoIBSS")) {        
        String  numCertif =  request.getParameter ("ce_num_certificado");        
        sUrl = sUrl + "&ce_origen=" + origen + "&ce_num_certificado=" +numCertif;        
    } else if (origen.equals("formResultCtaCteHis")){
        String    sCodProd   = request.getParameter("ce_cod_prod");
        String sFechaEmision = request.getParameter("ce_fecha_mov");
        sUrl=  sUrl + "&ce_origen="    + origen +
                      "&ce_cod_prod="  + sCodProd +
                      "&ce_fecha_mov=" + sFechaEmision;
    }
    
    try {
        sUrl =  java.net.URLEncoder.encode(sUrl,"UTF-8");
    } catch (java.io.UnsupportedEncodingException e) {
        System.out.println(e.getMessage());
    }
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Preview </title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
    <LINK rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <SCRIPT language="javascript">

     function Volver () {
        if ( BrowserDetect.browser == 'Explorer') {
            window.history.go(-1);
        } else {
            window.history.back(-1);
        }
        return true;
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
            </td>
        </tr>
        <tr>
            <td valign="top" align="center" width='100%' height='450'>
                <jsp:include page="/include/mostrarReporte.jsp" flush="true">
                    <jsp:param name="url" value="<%= sUrl %>"/>
                </jsp:include>
            </td>
        </tr>
        <tr><td>&nbsp;</td></tr>
        <tr valign="bottom" >

            <td width="100%" align="center" valign="middle">
                <input type="button" name="cmdSalir"  value="  Volver "  height="20px" class="boton" onClick="Volver ();"/>
            </td>
        </tr>
        <tr>
            <td valign="bottom" align="center">
                <jsp:include  flush="true" page="/bottom.jsp"/>
            </td>
        </tr>
    </table>


</body>