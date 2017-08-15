<%@page contentType="text/html" errorPage="/benef/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>
<%
 Usuario oUsuario = (Usuario) session.getAttribute ("user");
%> 
<SCRIPT language="javascript">
	function publicar(){

            if (document.getElementById('fecha').value == "" ) {
                alert ("Debe ingresar la fecha de publicación");
                document.getElementById('fecha').focus();
                return false; 
            }

            if (document.getElementById('titulo').value == "" ) {
                alert ("Debe ingresar el titulo");
                document.getElementById('titulo').focus();
                return false; 
            }

            if (document.getElementById('detalle').value == "" ) {
                alert ("Debe ingresar el detalle");
                document.getElementById('detalle').focus();
                return false; 
            }

//            if (document.getElementById('FILE1').value == "" ) {
//                alert ("Debe ingresar el el archivo a publicar");
//                document.getElementById('FILE1').focus();
//                return false; 
//            }

		document.getElementById('Novedades').submit();
	}
</SCRIPT>
<FORM id='Novedades' METHOD="POST" ACTION="/benef/publicador/publicarNovedad.jsp" ENCTYPE="multipart/form-data">
<input name="vigencia" id="vigencia" type="Hidden" value="<%=request.getParameter("vigencia")%>">
<TABLE  class="fondoForm" align="center" width="100%">
    <TR>
        <TD valign="top"  class='subtitulo' height="30px">PUBLICACION DE NOVEDADES</TD>
    </TR>
    <TR>
        <TD  class="subtitulo" height="30px">Llene por favor el formulario, con todos sus datos.     </TD>
    </TR>
    <tr>
        <TD>
            <TABLE  align="center" width="100%">
                <TR>
                    <TD nowrap   class="text">Fecha de Publicación:</TD>
                    <TD width="100%"  class="text">
                        <input name="fecha" id="fecha" onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" maxlength="10" size="10" value="<%=  Fecha.getFechaActual()%>">
                    </TD>
        	</TR>
		<TR>
                    <TD nowrap  class="text">Fecha de Vencimiento:</TD>
                    <TD width="100%"  class="text">
                            <input name="vencimiento" id="vencimiento" onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" maxlength="10" size="10">
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
                    <TD nowrap  class="text">Título de la Novedad:</TD>
                    <TD  class="text">
                        <INPUT type="text" name="titulo" id="titulo" value="" size="50" maxlengh="50">
                    </TD>
                </TR>
                <TR>
                    <TD nowrap  class="text">Detalle:</TD>
                    <TD  class="text"><textarea cols="50" rows="4" name="detalle" id="detalle"></textarea></TD>
                </TR>
                <TR>
                    <TD colspan="2">&nbsp;</TD>
                </TR>
                <TR>
                    <TD colspan="2"  class="text">Seleccione el archivo a publicar. Este archivo será
                                                enviado al servidor Web y estará<bR> disponible en
                                                    el link de la Novedad.
                    </TD>
                </TR>
                <TR>
                <TD nowrap  class="text">Archivo a Publicar:</TD>
                <TD  class="text">
                            <INPUT TYPE="FILE" NAME="FILE1" id="FILE1" SIZE="50"><BR>
                    </TD>
                </TR>
                <TR>
                <TD colspan="2" height="50px">&nbsp;</TD>
                </TR>
                <TR>
                    <TD>&nbsp;</TD>
                    <TD>
                        <input class="Boton" type="button" name="cmdSalir" value="Cancelar" onClick="javascript:history.back();">
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <input class="Boton"  type="button" name="cmdAceptar" value="Publicar" onClick="publicar();">
                    </TD>
                </TR>
                </TABLE>
                </TD>
          </tr>
</TABLE>
</FORM>
<script>
	CloseEspere();
</script>

