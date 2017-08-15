<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@page import="java.util.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%
 Usuario oUsuario = (Usuario) session.getAttribute ("user");
%> 
<SCRIPT language="javascript">
	function Enviar(){

            if (document.getElementById('titulo').value == "" ) {
                alert ("Debe ingresar el titulo");
                document.getElementById('titulo').focus();
                return false; 
            }

	
            document.getElementById('Publicacion').submit();

	}
</SCRIPT>
<FORM id='Publicacion' method="post" action="<%=Param.getAplicacion()%>publicador/insertarSeccion.jsp" >
<input name="cod_compania" id="cod_compania" type="Hidden" value="1">
<TABLE  class="fondoForm" align="center" cellpadding="2" cellspacing="2" width="100%">
    <TR>
        <TD valign="top" class="subtitulo" height="30px" align="center">ALTA DE SECCION DE MANUALES Y FORMULARIOS</TD>
    </TR>
    <TR>
        <TD class='text'>Llene por favor el formulario, con todos sus datos.</TD>
    </TR>
    <tr>
        <TD>
            <TABLE  align="center" width="100%" border="0" cellpadding="4" cellspacing="2"  >
                <TR>
                    <TD nowrap class='text'>Nombre de la secci&oacute;n:</TD>
                    <TD class='text'>
                        <INPUT type="text" name="titulo" id="titulo" value="" size="53" maxlengh="50">
                    </TD>
                </TR>
                <TR>
                    <TD class="text">Tipo de usuario:</TD>
                    <TD class="text" class='select'>
                        <select name="tipoUsuario" id="tipoUsuario">
                            <option value="99999999">Todos los usuarios</option>
                            <option value="0" >Internos</option>
                            <option value="1" >Productores</option>
                            <option value="2" >Clientes</option>
                        </select>
                    </TD>
                </TR>
                <TR>
                    <TD colspan="2" align="center" height="30px">
                        <input class="Boton" style="width: 120px;" type="button" name="cmdSalir" value="Cancelar" onClick="javascript:history.back();">
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <input class="Boton" style="width: 120px;" type="button" name="cmdAceptar" value="Enviar" onClick="Enviar();">
                    </TD>
                </TR>
            </TABLE>
    </TD>
    </tr>
</TABLE>
</FORM>

