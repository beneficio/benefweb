<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*, com.business.beans.Usuario, com.business.util.*, com.business.beans.GestionTexto" %>
<%@include file="/include/no-cache.jsp"%>    
<%  
    GestionTexto oGT = (GestionTexto) request.getAttribute("gestionTexto");
    Usuario usu     = (Usuario) session.getAttribute("user");
    %>
<html>
<head>
    <LINK rel="stylesheet" type="text/css" href="<%= Param.getAplicacion() %>css/estilos.css">	
    <script language='javascript'>
        function Volver() {
            window.close ();
        }
    </script>
</head>
  
<BODY leftmargin=2 topmargin=2 >
<table border='0'  width='100%' height='100%' cellpadding='2' cellspacing='2'>
    <tr>
        <td width='100%' valign="top" class='subtitulo' align="left" ><%= oGT.getTexto() %></td>
    </tr>
    <tr valign="bottom" >
        <td align="center" height='25'>
            <input type="button" name="cmdSalir" value=" Cerrar " height="20px" class="boton" onClick="Volver();">
        </td>
    </tr>
</table>
</body>
</html>
