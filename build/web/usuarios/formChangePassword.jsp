<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" import="java.util.*, com.business.beans.Usuario,com.business.util.*" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%  Usuario oUser   = (Usuario) session.getAttribute("user");
    %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script language="JavaScript">
<!--
function validatePass(campo) {
    var RegExPattern = /(?!^[0-9]*$)(?!^[a-zA-Z]*$)^([a-zA-Z0-9]{6,10})$/;
    var errorMessage = 'Password Incorrecta, Debe tener entre 6 y 10 caracteres y por lo menos un digito y un alfanumérico';
    if ((campo.value.match(RegExPattern)) && (campo.value!='')) {
        return true;
    } else {
        alert(errorMessage);
        campo.focus();
        return false;
    }
}
//-->

          
         function Submitir () {
                 
                var pass = document.formPersona.password.value.replace (' ','');

                if ( pass.length == 0 || document.formPersona.password.value == '' ) {
                    alert ("Debe ingresar la clave actual ");
                    return false;
                }


                if ( document.formPersona.newPassword.value.toUpperCase () != document.formPersona.confPassword.value.toUpperCase () ) {
                    alert ("La nueva clave y la confirmación de la misma  deben coincidir ! ");
                    return false;
                }

                if ( document.formPersona.password.value.toUpperCase () == document.formPersona.newPassword.value.toUpperCase () ) {
                    alert ("La nueva clave debe ser distinta a la clave actual ! ");
                    return false;
                }


                if ( document.formPersona.newPassword.value.indexOf (' ') != -1 ) {
                    alert ("La nueva clave no debe contener espacios en blanco ! ");
                    return false;
                }
                
                if ( document.formPersona.newPassword.value.length < 4 ) {
                    alert ("La longitud de la clave debe ser mayor o igual a 4 ! ");
                    return false;
                }
                
                if ( validatePass(document.formPersona.newPassword)) {
                    document.formPersona.submit();
                    return true;
                }
          }

          function Salir () {

                document.formPersona.usuario.disabled = true;
                document.formPersona.action = "<%= Param.getAplicacion()%>portal/extranet.jsp";
                document.formPersona.submit();
                return true;
          }
            
</script>
</head>
<body>
    <table cellSpacing="0" cellPadding="0" width="960" align="center" border="0">
        <tr>
            <td>
                <jsp:include page="/header.jsp">
                    <jsp:param name="aplicacion" value="<%= Param.getAplicacion() %>" />
                    <jsp:param name="usuario" value="<%= oUser.getusuario() %>" />
                    <jsp:param name="descripcion" value="<%= oUser.getRazonSoc() %>" />
                </jsp:include>
                <div class="menu">
                    <menu:renderMenuFromDB    aplicacion="1"  userLogon="<%= oUser.getusuario()%>" />
                </div>
            </td>
        </tr>
    <tr>
        <td valign="top" align="center">
<!-- body del formulario  de Persona -->	
<form name="formPersona" id="formPersona" method="POST" action="<%= Param.getAplicacion()%>servlet/setAccess">
    <input type="hidden" name="opcion" id="opcion" value="changePass">
    <input type="hidden" name="siguiente" id="siguiente">
    <input type="hidden" name="numSecuUsu" id="numSecuUsu" value="<%= oUser.getiNumSecuUsu()%>">
    <TABLE width="720" border="0" cellspacing="0" cellpadding="0" >
        <TR>
            <TD height="30px" valign="middle" align="center" class='titulo'>CAMBIO DE CLAVE DE ACCESO</TD>
        </TR>
        <TR>
            <TD  valign="middle" align="left" class='subtitulo'>Estimado usuario, su clave de acceso a BeneficioWeb ha caducado.<br>
            Por favor, ingrese su nueva clave desde aqui:</TD>
        </TR>
        <tr>
            <td width='50%'>
                <TABLE   align="center" border='1' cellpadding='3' cellspacing='0' style='margin-top:15px;' >
                    <TR valign="top">
                        <TD width="50%"  class='text'>Usuario de acceso:</TD> 
                        <TD width="50%"  class='text'>
                            <INPUT type="text" name="usuario" id="usuario" value="<%= oUser.getusuario ()%>" size="20" maxlengh="20" disabled>
                        </TD>
                    </TR>
                    <TR valign="top">
                        <TD  class='text' nowrap>Ingrese la clave actual:</TD>
                        <TD class='text' ><INPUT type="password" name="password" id="password" size="20" maxlengh="20" value =""></TD>
                    </tr>
                    <TR valign="top">
                        <TD  class='text' nowrap>Ingrese la nueva clave:</TD>
                        <TD class='text' ><INPUT type="password" name="newPassword" id="newPassword" size="20" maxlengh="20"></TD>
                    </tr>
                    <tr>
                        <TD class='text' nowrap>Confirme la nueva clave:</TD>
                        <TD class='text' ><INPUT type="password" name="confPassword" id="confPassword" size='20' maxlengh="20"></TD>
                    </TR>
                </TABLE>
            </td>
        </tr>
        <tr valign="bottom" >
            <td width="100%" align="center" height='50'>
                <TABLE  width='100%' border="0" cellspacing="0" cellpadding="0" height="30px" align="center">
                    <TR>
                        <TD align="center">
                        <input type="button" name="cmdSalir"  value=" Salir "  height="20px" class="boton" onClick="Salir ();">&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button" name="cmdGrabar" value=" Cambiar Clave "  height="20px" class="boton" onClick="Submitir ();">
                        </TD>
                    </TR>
                </TABLE>		
            </td>
        </tr>
</form>

<!-- fin body del formulario   -->
        <TR>
            <TD valign="bottom" align="center">
                <jsp:include  flush="true" page="/bottom.jsp"/>
            </td>
        </tr>
    </table>
</body>
