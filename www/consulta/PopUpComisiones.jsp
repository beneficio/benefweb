<%@ page contentType="text/html" errorPage="/error.jsp" session="true"%>
<%@page import="java.util.*, com.business.beans.Usuario, com.business.util.*" %>
<%@include file="/include/no-cache.jsp"%>    
<% 
    Usuario usu = (Usuario) session.getAttribute("user");
  
    %>
<html>
<head>
    <title>Comisiones</title>
    <LINK rel="stylesheet" type="text/css" href="<%= Param.getAplicacion() %>css/estilos.css">	
   <SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <script language='javascript'>
        function Volver() {
            window.close ();
        }
        
        function Aceptar () {
 
               if ( document.form1.email.value == "" ) {
                    alert ("Debe ingresar una cuenta de mail válida !! ");
                    return false;
                }

           if ( document.form1.fecha_hasta.value == "" ) {
                alert ("Debe ingresar la fecha hasta  !! ");
                return false;
            }
            
            if (confirm ("Esta usted seguro que desea recibir el informe via mail ? ")) {
                if (window.opener) {
                    window.opener.Submitir ( document.form1 );
                }
                window.close ();
                return true;
            } else {
                return false;
            }
        }
    </script>
</head>
  
<BODY leftmargin="2" topmargin="2" >
<form name='form1'>
<input type="hidden" value="getComisiones" name="opcion" id="opcion">
<table border='0'  width='100%' height='100%' cellpadding='2' cellspacing='2' class='fondoForm'>
    <tr>
        <td width='100%' height='30' valign="top" class='titulo' align="center" >SOLICITUD DE RESUMEN DE COMISIONES A FACTURAR</td>
    </tr>
<%      if (usu.getiCodTipoUsuario() == 0 || usu.getiCodProd () >= 80000) {
    %>
    <tr>
        <td align="left" class="text">
            Debe seleccionar un productor:
        </td>
    </tr>
    <tr>
        <td align="left" class="text" >Productor:&nbsp;
            <select class='select' name="cod_prod" id="cod_prod">
<%               LinkedList lProd = (LinkedList) session.getAttribute("Productores");
                 for (int i= 0; i < lProd.size (); i++) {
                    Usuario oProd = (Usuario) lProd.get(i);
                    out.print("<option value='" + oProd.getsCodProdDC() + "' " + (oProd.getiCodProd() == usu.getiCodProd () ? "selected" : " ") + ">" + oProd.getsDesPersona() + " (" + oProd.getiCodProd() + ")</option>");
                 }
%>
             </select>
        </td>
    </tr>
<%      } else {
    %>
<tr><td >&nbsp;</td></TR>
<tr><td >&nbsp;</td></TR>
<input type="hidden" name="cod_prod" id="cod_prod" value="<%= usu.getsCodProdDC() %>" >

<%      }
    %>
<tr><td >&nbsp;</td></TR>
    <tr>
        <td align="left"  class="text">Fecha de cierre:&nbsp;<input name="fecha_hasta" id="fecha_hasta" size="10"
        onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value="">&nbsp;(dd/mm/yyyy)</td>
    </tr>
    <tr><td >&nbsp;</td></TR>
    <tr>
        <td align="left" valign="middle" class='textonegro' height='50'>
        Verifique la casilla de correo destino, y en caso que la misma no sea la correcta puede modificarla.<br>Luego presione el botón Aceptar.
        <br><br>
        </td>
    </tr>
    <tr>
        <td align="center"  valign="top"><input type="text" name="email" id="email" size='45' maxlength='60' value=<%= (usu.getEmail () == null ? "" : usu.getEmail ()) %>><br></td>
    </tr>
    <tr valign="bottom" >
        <TD align="center" height='25'>
            <input type="button" name="cmdSalir" value=" Cerrar " height="20px" class="boton" onClick="Volver();">&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="button" name="cmdAceptar" value=" Aceptar " height="20px" class="boton" onClick="Aceptar ();">
        </td>
    </tr>
</table>
</form>
</body>
</html>
