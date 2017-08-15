<%@ page contentType="text/html" errorPage="/error.jsp" session="true"%>
<%@page import="java.util.*, com.business.beans.Usuario, com.business.beans.HtmlBuilder, com.business.beans.Tablas,com.business.util.*" %>
<%@include file="/include/no-cache.jsp"%>    
<% Usuario usu = (Usuario) session.getAttribute("user");
    int iCodActSec = (request.getParameter ("cod_actividad_sec") == null ? 0 : 
                      Integer.parseInt (request.getParameter ("cod_actividad_sec")));
    HtmlBuilder ohtml       = new HtmlBuilder();
    Tablas oTabla = new Tablas ();
    LinkedList lTabla = new LinkedList ();
    %>
<html>
<head>
    <title>Actividad secundaria</title>
    <LINK rel="stylesheet" type="text/css" href="<%= Param.getAplicacion() %>css/estilos.css">	
    <script language='javascript'>
    function Volver() {
        window.close ();
    }

    function ChangeActividad (actividad) {

        document.getElementById ('desc_actividad').value = document.getElementById('cod_actividad_sec').options [ document.getElementById ('cod_actividad_sec').selectedIndex].text;
        return true;
    }

    function Aceptar () {
 
        if (window.opener) {
            window.opener.GrabarActividadSecundaria  ( document.form1 );
        }
        window.close ();
        return true;
    }

    </script>
</head>
  <SCRIPT type="" language="JavaScript" src="<%= Param.getAplicacion() %>script/Botones.js"></script>	
<BODY leftmargin=2 topmargin=2 >
<form name='form1'>
<table border='0'  width='100%' height='100%' cellpadding='2' cellspacing='2' class='fondoForm'>
    <tr>
        <td width='100%' height='30' valign="top" class='titulo' align="center" >Actividad secundaria</td>
    </tr>
    <tr>
        <td align="left" width='100%' height='190' valign="top">
            <table width='100%' cellpadding='1' cellspacing='1' align="center" style='margin-left:15;'>
                  <tr> 
                    <td class="text" >Seleccione una actividad (entre par&eacute;ntesis la categoria)&nbsp;:</td>
                  </tr>
                  <tr>
                    <td class='text' >
                      <select name="cod_actividad_sec"  id="cod_actividad_sec" class="select" style="width:500" onkeydown="ChangeActividad (this.options[this.selectedIndex].value);" onkeyup="ChangeActividad (this.options[this.selectedIndex].value);" onchange="ChangeActividad (this.options[this.selectedIndex].value);">
                            <option value="-1" >Seleccione una actividad</option>
        <%                  lTabla = oTabla.getActividades ("COTIZADOR");
                            out.println(ohtml.armarSelectTAG(lTabla,iCodActSec)); 
        %>
                      </select>
                    </td>
                  </tr>
                  <tr>
                    <td align="left"><TEXTAREA  rows='3' cols='95' name='desc_actividad' id='desc_actividad'  class='text' readonly></TEXTAREA>
                    </td>
                  </tr>
            </table>
        </td>
    </tr>
    <tr valign="bottom" >
        <TD align="center" height='30'>
            <input type="button" name="cmdSalir" value=" Cerrar " height="20px" class="boton" onClick="Volver ();">&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="button" name="cmdAceptar" value=" Aceptar " height="20px" class="boton" onClick="Aceptar ();">
        </td>
    </tr>
</table>
</form>
</body>
</html>
