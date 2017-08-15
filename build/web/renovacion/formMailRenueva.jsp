<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Poliza"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>   
<% Usuario usu = (Usuario) session.getAttribute("user");
 
String sError = (String) request.getAttribute("mensaje"); 
if ( sError == null || sError.equals ("")) {
    sError = "hay un error en la cotizaci&oacute;n";
 }
System.out.println (sError);

/*
 switch ( iError) {
     case -600:
         sError = "la rama/producto no es renovable desde la web";
         break;
     case -800:
         sError = "la propuesta de la p&oacute;liza original no fue emitida desde la web";
         break;
     case -900:
         sError = "la p&oacute;liza no puede renovarse desde la web porque tiene asegurados con diferentes sumas aseguradas";
         break;
     case -1000:
         sError = "la p&oacute;liza no puede renovarse desde la web porque NO se puede obtener la suma asegurada de muerte";
         break;
     case -1100:
         sError = "la p&oacute;liza no puede renovarse desde la web porque NO tiene informada la actividad del asegurado";
         break;
     case -1200:
         sError = "la p&oacute;liza no puede renovarse desde la web porque NO tiene informado el &aacute;mbito";
         break;
     case -1300:
         sError = "la p&oacute;liza no puede renovarse desde la web porque es una p&oacute;liza grupo";
         break;
     case -1400:
         sError = "la p&oacute;liza no puede renovarse desde la web porque la actividad no esta registrada en la web";
         break;
     case -1500:
         sError = "la p&oacute;liza no puede renovarse desde la web porque la actividad NO es RENOVABLE";
         break;
     default:
         break;
     }
 */
 String sOrigen = request.getParameter ("origen");
 String sTitulo = " COTIZACION ";
 if (sOrigen.equals("renovar")) {
     sTitulo = " RENOVACION ";
     }
    %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <script language="javascript">
    function Salir () {
        window.location.replace("<%= Param.getAplicacion()%>servlet/RenuevaServlet?opcion=getAllPol");
    }
   
    function Enviar () {

            if (document.getElementById('email').value.length == 0) {
                alert ("Ingrese un mail de contacto válido");
            }

        document.form1.submit();
        return true;
    }
    function calcLong(txt, dst, formul, maximo) {
    var largo;
    largo = formul[txt].value.length;
    if (largo > maximo) {
        formul[txt].value = formul[txt].value.substring(0,maximo);
    }
     formul[dst].value = formul[txt].value.length;
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
        <td valign="top" align="center" width="100%">
            <form name="form1" id="form1" method="POST" action="<%= Param.getAplicacion()%>servlet/RenuevaServlet"
                  onKeyUp="calcLong('DESCRIPCION', 'caracteres',this, 1000)" >
                <input type="hidden" name="opcion"     id="opcion" value="enviarMail"/>
                <input type="hidden" name="num_poliza" id="num_poliza" value="<%=request.getParameter("num_poliza") %>"/>
                <input type="hidden" name="cod_rama"   id="cod_rama" value="<%= request.getParameter("cod_rama") %>"/>
                <input type="hidden" name="origen"     id="origen" value="<%= request.getParameter("origen") %>"/>
                <input type="hidden" name="error"      id="error" value="<%= sError %>"/>
                <table width="680" border="0" align="center" cellspacing="0" cellpadding="0"  class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                    <TR>
                        <TD height="30px" valign="middle" align="center" class='titulo'>SOLICITUD DE <%= sTitulo %> VIA MAIL</TD>
                    </TR>
                    <TR>
                        <TD height="45px" valign="middle" align="left" class='subtitulo' >
Estimado colaborador, <%= sError %>.<BR><BR>Por favor ingrese desde aqui las observaciones pertinentes y procederemos a dar curso a su solicitud de <%= sTitulo %> de forma manual.<br/>
                        </TD>
                    </TR>
                    <tr>
                        <td height="30px" valign="middle" align="left" class='text' >
                        <TEXTAREA cols='80' rows='12' class='inputText' name='DESCRIPCION' id="DESCRIPCION" >
<%= sTitulo%> DE POLIZA&nbsp;<%= request.getParameter("cod_rama") %>/<%= request.getParameter("num_poliza") %>
                        </TEXTAREA><br/>Cantidad de caracteres:&nbsp;
                        <input name="caracteres" type="text" id="caracteres" 
                               value="<%= ("RENOVAR POLIZA "+ request.getParameter("cod_rama") +"/"+request.getParameter("num_poliza")).length() %>" size="4"/>
                        &nbsp;(hasta 1.000 caracteres)
                        </td>
                    </tr>
                    <TR>
                        <TD height="30px" valign="middle" align="left" class='text' >Mail de contacto:&nbsp;
                            <input type="text" name="email" id="email" value="<%= usu.getEmail()%>" size="50" maxlength="150"/>
                        </TD>
                    </TR>
                    <tr>
                        <td align="center">
                            <input type="button" name="cmdSalir"  value="  Volver  "  height="20px" class="boton" onClick="Salir ();"/>
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            <input type="button" name="cmdGrabar" value="Solicitar la renovación de la póliza"
                                   height="20px" class="boton" onClick="Enviar();"/>
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
<script>
     CloseEspere();
</script>
</body>
</HTML>
