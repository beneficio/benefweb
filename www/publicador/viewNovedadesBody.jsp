<%@page contentType ="text/html" errorPage = "/error.jsp"%>
<%@page import="java.sql.*"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%
   String pathNovedades = "/benef/files/novedades/";

  	Connection dbCon = null;
        dbCon = db.getConnection();
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String vigencia = null;
	String SQL = " SELECT  \"FECHA\", ";
	SQL = SQL +  " 		\"VENCIMIENTO\", ";
	SQL = SQL +  " 		\"TITULO\", ";
	SQL = SQL +  " 		\"MENSAJE\", ";
	SQL = SQL +  " 		\"LINK\", ";
        SQL = SQL +  " 		\"COD_COMPANIA\", ";
        SQL = SQL +  " 		\"TIPO_DOC\", ";
        SQL = SQL +  " 		\"TIPO_USUARIO\", ";
        SQL = SQL +  "  COALESCE(\"CODIGO\",0) AS \"CODIGO\" ";
	SQL = SQL +  " FROM \"BENEF\".\"NOVEDADES\"";
	if (request.getParameter("vigencia")==null){
		SQL = SQL +  " WHERE \"FECHA\" <= CURRENT_DATE";
		SQL = SQL +  "   AND COALESCE (\"VENCIMIENTO\", CURRENT_DATE) >= CURRENT_DATE";
		vigencia=Fecha.getFechaActual();
	}else{
		SQL = SQL +  " WHERE \"FECHA\" <=  to_date ('" + request.getParameter("vigencia") + "','dd/mm/yyyy')";
		SQL = SQL +  "   AND COALESCE (\"VENCIMIENTO\", to_date('" + request.getParameter("vigencia") + "','dd/mm/yyyy')) >= to_date('" + request.getParameter("vigencia") + "','dd/mm/yyyy')";
		vigencia=request.getParameter("vigencia");
	}
	SQL = SQL +  " ORDER BY \"FECHA\" DESC";
	pstmt = dbCon.prepareStatement(SQL);
    rs = pstmt.executeQuery();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>Publicador</title>
<script>
function ver(){
	document.getElementById('Novedades').action = "/benef/publicador/viewNovedades.jsp";
	document.getElementById('Novedades').submit();
}
function Nueva(){
	document.getElementById('Novedades').action = "/benef/publicador/formNovedades.jsp";
	document.getElementById('Novedades').submit();
}

function borrar(file, codigo ){

    if (confirm ("Esta usted seguro que desea eliminar la publicación ? ")) {
        document.getElementById('Novedades').action = "<%= Param.getAplicacion()%>publicador/borrarNovedad.jsp";
	document.getElementById('Novedades').file.value = file;
	document.getElementById('Novedades').codigo.value = codigo;

	document.getElementById('Novedades').submit();
        return true;
    } else{
        return false;
    }
}

function Salir(){
	document.getElementById('Novedades').action = "<%= Param.getAplicacion()%>index.jsp";
	document.getElementById('Novedades').submit();
}

</script>
</head>

<body>
	<form method="post" name="Novedades" id="Novedades" >
            <INPUT type="hidden" value="" name="file" id="file">
            <INPUT type="hidden" value="" name="codigo" id="codigo">
<table class="home" align="left" width='600px' border="0" cellspacing="0" cellpadding="0" >
  <TR>
    <TD colspan="2" class="titulo">Novedades</TD>
  </TR>
  <TR>
    <TD colSpan=2 class="not">
	  &nbsp;
	</TD>
  </TR> 
  <TR>
    <td nowrap class='textonegro'>
	Novedades vigentes al &nbsp;&nbsp;
	<input name="vigencia" value="<%=vigencia%>" onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" maxlength="11" size="11">
	&nbsp;&nbsp;
	</td>
    <td>
	<input class="Boton" style="width: 120px;" type="button" name="cmdAceptar" value="Ver Novedades" onclick="ver();">
	</td>
  </TR>
<% while (rs.next ()) {
    String sTipoUsuario = "";
    switch ( rs.getInt("TIPO_USUARIO")) {
        case 0: sTipoUsuario = "(Solo usuarios internos)";
             break;
        case 1: sTipoUsuario = "(Solo productores)";
             break;
        case 2: sTipoUsuario = "(Solo clientes)";
             break;
        default : sTipoUsuario = "(Todos los usuarios)";
             break;
        } %>
  <TR>
    <TD colSpan=2 class="not" nowrap>
	  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
    </TD>
  </TR>
  <TR>
	<TD colspan="2" width="100%">
		<table >
			<tr>
				<td>&nbsp;
<%                  if ( rs.getString("LINK") != null && ! rs.getString ("LINK").equals ("") ) {
    %>
                    <IMG src='<%= Param.getAplicacion()%>images/<%= rs.getString ("TIPO_DOC")%>.gif' border='0' align="left">
<%                  }
    %>
				</td>
				<td class='textonegro'>&nbsp;Vigencia:&nbsp;<%=Fecha.showFechaForm(rs.getDate("FECHA"))%>&nbsp;
                                    al&nbsp;<%= (rs.getDate("VENCIMIENTO") == null ? "sin vencimiento" : Fecha.showFechaForm(rs.getDate("VENCIMIENTO")))%>
                                    &nbsp;-&nbsp;<%= sTipoUsuario%>
                                </td>
                        </tr>
                        <tr>
                            <td colspan='2'>
<%                  if ( rs.getString("LINK") != null && ! rs.getString ("LINK").equals ("") ) {
    %>
					<A class="textoazul" target='_blank' href='<%= pathNovedades %><%=(rs.getString("LINK")==null?"#":rs.getString("LINK"))%>'>
          			<b><%=rs.getString("TITULO")%></b>&nbsp;
					</A>&nbsp;&nbsp;
<%                 } else { 
    %>
          			<b><%=rs.getString("TITULO")%></b>&nbsp;
<%                  }
    %>
                                        <img src="<%= Param.getAplicacion()%>images/delete.gif" width="19" height="18" border="0" 
                                        onclick="borrar ('<%=(rs.getString("LINK")==null?"#":rs.getString("LINK"))%>','<%= rs.getInt ("CODIGO")%>');" alt="Eliminar Publicación">  
				</td>
			</tr>
			<tr>
				<td colspan="2"  class='textonegro'><%=rs.getString("MENSAJE")%></td>
			</tr>			
		</table>          
	</TD>
  </TR>
<% } %>
  <TR>
    <TD colSpan=2 class="not">
	  &nbsp;
	</TD>
  </TR>
  <TR>
    <TD colSpan=2 class="not" nowrap>
	  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
    </TD>
  </TR>
  <TR vAlign=center>
    <td colspan="2" align="left">
	<input class="Boton"  type="Button" name="cmdSalir" value=" Salir " onclick="Salir();" >
        &nbsp;&nbsp;&nbsp;&nbsp;
		<input class="Boton" style="width: 120px;" type="Button" name="cmdAceptar" value="Nueva Novedad" onclick="Nueva();" >

	</td>
  </TR> 
</TABLE>
</form>
</body>
</html>
<% 
 rs.close();
 pstmt.close();
 db.cerrar(dbCon);
%>
<script>
	CloseEspere();
</script>


