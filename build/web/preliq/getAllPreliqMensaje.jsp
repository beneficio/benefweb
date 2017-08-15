<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Poliza"%>
<%@page import="com.business.beans.Preliq"%>
<%@page import="com.business.beans.ErrorPreliq"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>
<%@ taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg" %>
<%
    Usuario usu = (Usuario) session.getAttribute("user");
    int iCodProd    = Integer.parseInt(request.getParameter("cod_prod") == null ? "-1" : request.getParameter("cod_prod"));
    LinkedList lPreliq = (LinkedList) request.getAttribute("preliquidaciones");
    LinkedList lError  = (LinkedList) request.getAttribute("errores");


String sPath = "&cod_prod=" + iCodProd + "&opcion=getAllPreliq" ;

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<script  type="text/javascript">
    function OpenEspere (){
        document.getElementById("mascara").style.display="block";
        document.getElementById("ventanita").style.display ="block";
    }

    function Enviar () {

        document.form1.action = "<%= Param.getAplicacion()%>servlet/PreliquidacionServlet";
        document.form1.opcion.value = "getAllPreliq";
        document.form1.submit();
        OpenEspere ();
        return true;
    }
</script>
</head>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<body>
    <table  id="tabla_general" cellSpacing="0" cellPadding="0" width="960" align="center" border="0">
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
        <td valign="top" align="center" width="100%">
            <form name="form1" id="form1" method="POST" action="<%= Param.getAplicacion()%>servlet/PreliquidacionServlet">
               <input type="hidden" name="opcion" id="opcion" value="getAllPreliq"/>
               <input type="hidden" name="volver" id="volver" value="getAllPreliq"/>
                <table width="100%" border="0" align="center" cellspacing="4" cellpadding="2"
                       class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                    <tr>
                        <td height="30px" valign="middle" align="center" class='titulo'>PRELIQUIDACION WEB</td>
                    </tr>
                    <tr>
                        <td align="center" valign="top" width="100%" height="400px">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <input type="button" name="cmdSalir" value=" Salir " height="20px" class="boton" onClick="Salir();"/>&nbsp;&nbsp;&nbsp;&nbsp;
                            <input type="button" name="cmdGrabar" value=" Enviar " height="20px" class="boton" onClick="Enviar();"/>
                        </td>
                    </tr>
               </table>
            </form>
        </td>
    </tr>
    <tr>
        <td valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
   </tr>
</table>
<script language="javascript">
var divHeight;
var obj = document.getElementById('tabla_general');

if(obj.offsetHeight)          {divHeight=obj.offsetHeight;}
else if(obj.style.pixelHeight){divHeight=obj.style.pixelHeight;}
document.write('<div id="mascara" style="width:100%;height:' + divHeight + 'px;position:absolute;top:0;left:0;' +
               'background-color:#F5F7F7;z-index:3;opacity:.6;-moz-opacity:.6;-khtml-opacity:.6;filter:alpha(opacity=60);display:none"></div>' );
</script>
<!--<div id="mascara" style="position:fixed;top:0;left:0; width:100%;height:100%; background-color:#F5F7F7; z-index:3;opacity:.6;-moz-opacity:.6;-khtml-opacity:.6;filter:alpha(opacity=60);display:none"></div>
-->
<div id="ventanita" style="display:none;position:absolute;top:50%;left :50%;width:760px;height:100%;margin-top: -30px;margin-left: -400px;z-index:4">
    <table width="100%" bgcolor="F5F7F7">
            <tr>
                <td  height="100%" valign="middle">
                    <img src="/benef/images/barraProgresion.gif"/>&nbsp;
                    <span style="font-family:  Arial, Helvetica, sans-serif; font-size:16px;font-weight:bold;text-decoration:none;padding: 5px">
                        Por favor, espere un momento que se esta actualizando la preliquidaci&oacute;n...</span>&nbsp;
                    <img src="/benef/images/barraProgresion.gif"/>
                </td>
            </tr>
    </table>
</div>
<script>
    CloseEspere();
    Enviar ()
</script>
</body>
</html>
