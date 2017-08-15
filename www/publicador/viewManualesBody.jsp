<%@page contentType ="text/html" errorPage = "/error.jsp"%>
<%@page import="java.sql.*"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%
   String pathManuales  = "/benef/files/manuales/";

   	Connection dbCon = null;
        dbCon = db.getConnection();
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String SQL = " SELECT A.\"SECCION\", A.\"TITULO\" AS \"DESC_SECCION\", A.\"TIPO_USUARIO\" AS \"TIPO_USUARIO_SEC\",";
	SQL =  SQL + "B.\"TITULO\", B.\"CATEGORIA\", B.\"COD_COMPANIA\", B.\"MENSAJE\",";
	SQL =  SQL + "B.\"LINK\", B.\"TIPO_DOC\", B.\"MCA_BAJA\", COALESCE (B.\"ORDEN\",-10) AS \"ORDEN\",";
	SQL =  SQL + "B.\"CODIGO\", B.\"TIPO_USUARIO\", B.\"MCA_PORTAL\"";
	SQL =  SQL + " FROM \"MANUALES\" AS A  LEFT JOIN \"MANUALES\" AS B ON  ( ";
	SQL =  SQL + " B.\"SECCION\" = A.\"SECCION\" ";
	SQL =  SQL + " AND COALESCE (B.\"MCA_BAJA\",' ') <> 'X'";
	SQL =  SQL + " AND B.\"CATEGORIA\" <> 'S' ) ";
	SQL =  SQL + "WHERE A.\"CATEGORIA\" = 'S' " ;
	SQL =  SQL + " AND COALESCE (A.\"MCA_BAJA\",' ') <> 'X'";
	SQL =  SQL + " ORDER BY A.\"SECCION\", B.\"ORDEN\"; ";


        System.out.println (SQL);
        
	pstmt = dbCon.prepareStatement(SQL);
        rs = pstmt.executeQuery();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>Manuales</title>
<script>
function Nueva(){
	document.getElementById('Noticias').action = "<%= Param.getAplicacion()%>publicador/formManuales.jsp";
	document.getElementById('Noticias').submit();
}

function NuevaSeccion (){
	document.getElementById('Noticias').action = "<%= Param.getAplicacion()%>publicador/formSeccion.jsp";
	document.getElementById('Noticias').submit();
}

function Salir(){
	document.getElementById('Noticias').action = "<%= Param.getAplicacion()%>index.jsp";
	document.getElementById('Noticias').submit();
}

function borrar( file, codigo ){
    if (confirm ("Esta usted seguro que desea eliminar la publicación ? ")) {
	document.getElementById('Noticias').action = "<%= Param.getAplicacion()%>publicador/borrarPublicacion.jsp";
	document.getElementById('Noticias').file.value = file;
	document.getElementById('Noticias').codigo.value = codigo;

	document.getElementById('Noticias').submit();
        return true;
    } else{
        return false;
    }
}

function borrarSec( codigo ){
    if (confirm ("Esta usted seguro que desea eliminar la sección ? ")) {
	document.getElementById('Noticias').action = "<%= Param.getAplicacion()%>publicador/borrarSeccion.jsp";
	document.getElementById('Noticias').codigo.value = codigo;

	document.getElementById('Noticias').submit();
        return true;
    } else{
        return false;
    }
}

</script>
</head>

<body>
<form method="post" name="Noticias" id="Noticias" >
<INPUT type="hidden" value="" name="vigencia" id="vigencia">
<INPUT type="hidden" value="" name="file" id="file">
<INPUT type="hidden" value="" name="codigo" id="codigo">
<table class="home" align="left" width='600px' border="0" cellspacing="0" cellpadding="0" >
  <TR>
    <TD  class="titulo">Manuales y Formularios</TD>
  </TR>
  <TR>
    <TD  class="not">
	  &nbsp;
	</TD>
  </TR> 
<% int codSeccionAnt = -1;
   String sSeccionAnt = "";
   while (rs.next ()) {
   String sTipoUsuarioSec = "";
    switch ( rs.getInt("TIPO_USUARIO_SEC")) {
        case 0: sTipoUsuarioSec = "(Solo usuarios internos)";
             break;
        case 1: sTipoUsuarioSec = "(Solo productores)";
             break;
        case 2: sTipoUsuarioSec = "(Solo clientes)";
             break;
        default : sTipoUsuarioSec = "(Todos los usuarios)";
             break;
        }
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
        }

        if ( rs.getInt ("SECCION") != codSeccionAnt ) {
            if (codSeccionAnt != -1 ) {
    %>
                <TR>
                    <td width="100%"><hr></td>
                </TR>
<%         }
    %>

    <TR>
        <td width="100%" class="subtitulo" height="30px" align="center"> >>>> <%= rs.getString ("DESC_SECCION") %> <<<<<
            &nbsp;&nbsp;&nbsp;
<%    if (rs.getInt ("ORDEN") == -10) {
    %>
                                        <img src="<%=Param.getAplicacion()%>images/delete.gif" width="19" height="18" border="0" alt="Eliminar Sección"
                                        onclick="borrarSec ('<%= rs.getInt ("SECCION")%>');">
<%    }
    %>

            &nbsp;&nbsp;&nbsp;<span class='textogris'>&nbsp;-&nbsp;<%= sTipoUsuarioSec%></span>
        </td>
    </TR>
<%      codSeccionAnt = rs.getInt ("SECCION");
        sSeccionAnt   = rs.getString ("DESC_SECCION");
        }
    %>
  <TR>
<%    if (rs.getInt ("ORDEN") != -10 ) {
    %>
	<TD  width="100%">
		<table border='0' width='100%'>
                    <tr>
                        <td >
                            <span class='textogris'><b>-&nbsp;Orden N°&nbsp;<%=rs.getInt("ORDEN")%></b></span>&nbsp;&nbsp;
<%                  if ( rs.getString("LINK") != null && ! rs.getString ("LINK").equals ("") ) {
    %>
                            <a class="texttoazul" target='_blank' href='<%= pathManuales %><%=rs.getString("LINK")%>'>
                                <IMG src='<%= Param.getAplicacion()%>images/<%= rs.getString ("TIPO_DOC")%>.gif' border='0' align="left">
                                <b><%=rs.getString("TITULO")%></b>
                            </a>&nbsp;&nbsp;&nbsp;-&nbsp;&nbsp;
<%                  } else {
    %>
                                <b><%=rs.getString("TITULO")%></b>
                             &nbsp;&nbsp;&nbsp;-&nbsp;&nbsp;
<%                  }
    %>
                                        <img src="<%=Param.getAplicacion()%>images/delete.gif" width="19" height="18" border="0" alt="Eliminar Publicación"
                                        onclick="borrar ('<%=(rs.getString("LINK")==null?"#":rs.getString("LINK"))%>','<%= rs.getInt ("CODIGO")%>');">
                                        <span class='textogris'>&nbsp;-&nbsp;<%= sTipoUsuario%></span>
                        </td>
                    </tr>
                    <tr>
                        <td><span  class='textonegro'><%=rs.getString("MENSAJE")%></span></td>
                    </tr>			
                    <TR>
                        <td nowrap style="border-top-style: dotted; border-top-color: Gray; border-top-width: 1;">
                    &nbsp;
                        </td>
                    </TR>
		</table>          
	</TD>
<%   } else {
    %>

    <TD  width="100%">No existen publicaciones para la secci&oacute;n</TD>
<%   }
    %>
  </TR>
<% } %>
  <TR vAlign="bottom">
    <td  align="center">
	<input class="Boton"  type="Button" name="cmdSalir" value=" Salir " onclick="Salir();" >
&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="Boton"  type="Button" name="cmdAceptar" value="Nuevo Manual o Formulario" onclick="Nueva();" >
&nbsp;&nbsp;&nbsp;&nbsp;
<input class="Boton"  type="Button" name="cmdAceptar2" value="Nueva Secci&oacute;n" onclick="NuevaSeccion();" >
	</td>
  </TR> 
</table>
</form>
</body>
</html>
<% 
 rs.close();
 pstmt.close();
 db.cerrar(dbCon);
%>
