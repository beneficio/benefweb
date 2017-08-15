<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.LinkedList"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.beans.Alerta"%>
<%@page import="com.business.util.*"%>
<%
    LinkedList lAlerta = new LinkedList();
    Connection dbCon = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

try {
       dbCon = db.getConnection();
	String SQL = " SELECT  \"COD_ALERTA\", ";
	SQL = SQL +  " 		\"TITULO\", ";
	SQL = SQL +  " 		\"FECHA_TRABAJO\", ";
	SQL = SQL +  " 		\"FECHA_DESDE\", ";
	SQL = SQL +  " 		\"FECHA_HASTA\", ";
	SQL = SQL +  " 		\"MCA_PUBLICA\", ";
	SQL = SQL +  " 		\"TIPO_USUARIO\", ";
        SQL = SQL +  " 		\"USERID\" ";
	SQL = SQL +  " FROM \"BENEF\".\"ALERTAS\" ";
	SQL = SQL +  " ORDER BY \"FECHA_DESDE\"  DESC ";

	pstmt = dbCon.prepareStatement(SQL);
        rs = pstmt.executeQuery();
        
        if (rs != null) {
            while (rs.next()) {
                Alerta oAlert = new Alerta ();
                oAlert.setcodAlerta(rs.getInt ("COD_ALERTA"));
                oAlert.settitulo(rs.getString ("TITULO"));
                oAlert.setmcaPublica(rs.getString ("MCA_PUBLICA"));
                oAlert.setfechaDesde(rs.getDate ("FECHA_DESDE"));
                oAlert.setfechaHasta(rs.getDate ("FECHA_HASTA"));
                switch ( rs.getInt ("TIPO_USUARIO") ) {
                    case 1: 
                        oAlert.setsBody("Productor");
                        break;
                    case 2: 
                        oAlert.setsBody("Ciente");
                        break;
                    case 0: 
                        oAlert.setsBody ("Interno");
                        break;
                   default: 
                        oAlert.setsBody ("Todos");
                }
                lAlerta.add(oAlert);
            }
        }
 } catch (SQLException se) {
   throw new SurException (se.getMessage());
 } catch (Exception e) {
    throw new SurException (e.getMessage());
 } finally {
   if (rs != null) {
        rs.close();
   }
   if (pstmt != null) {
        pstmt.close();
   }
   db.cerrar(dbCon);
 }

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<script type='text/javascript' src='<%=Param.getAplicacion()%>script/popUp.js'></script>
<script type='text/javascript'>
function Nueva () {
	document.getElementById('Noticias').codAlerta.value = "0";       
	document.getElementById('Noticias').action = "<%= Param.getAplicacion()%>publicador/formAlerta.jsp";
	document.getElementById('Noticias').submit();
        return true;
}

function Salir(){
	document.getElementById('Noticias').action = "<%= Param.getAplicacion()%>index.jsp";
	document.getElementById('Noticias').submit();
        return true;
}

function Alerta ( codAlerta ) {
    var sUrl = "<%= Param.getAplicacion()%>usuarios/alerta.jsp?codAlerta=" + codAlerta;
    var W = 650;
    var H = 450;

    AbrirPopUp (sUrl, W, H);
    return true;
}
function borrar( file ){
    if (confirm ("Esta usted seguro que desea eliminar la publicación ? ")) {
	document.getElementById('Noticias').action = "<%= Param.getAplicacion()%>publicador/borrarPublicacion.jsp";
	document.getElementById('Noticias').file.value = file;
	document.getElementById('Noticias').submit();
        return true;
    } else{
        return false;
    }
}

function Modificar( codAlerta ){
	document.getElementById('Noticias').action = "<%= Param.getAplicacion()%>publicador/formAlerta.jsp";
	document.getElementById('Noticias').codAlerta.value = codAlerta;
	document.getElementById('Noticias').submit();
        return true;
}

function CambiarEstado( codAlerta , mca ){
    if (confirm ("Esta usted seguro que desea cambiar el estado de la publicación ? ")) {
	document.getElementById('Noticias').action = "<%= Param.getAplicacion()%>publicador/publicarAlerta.jsp";
	document.getElementById('Noticias').codAlerta.value = codAlerta;
	document.getElementById('Noticias').mca_publica.value = mca;
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
<INPUT type="hidden" value="" name="codAlerta" id="codAlerta" value="0">
<INPUT type="hidden" value="" name="mca_publica" id="mca_publica" value="">
<table class="home" align="left" width='100%' border="0" cellspacing="0" cellpadding="0" >
  <TR>
      <TD  class="titulo" align="center">Alertas</TD>
  </TR>
  <TR>
    <TD  class="not">
	  &nbsp;
	</TD>
  </TR> 
  <TR>
	<TD  width="100%">
            <table border="0" cellspacing="2" cellpadding="2" align="center" style="margin-left:0px;" class='tablasBody'>
                <thead>                                                
                    <th align="center" width='450'>Descripción</th>
                    <th align="center" width='40'>F.Desde</th>
                    <th align="center" width='40'>F.Hasta</th>
                    <th align="center" width='40'>Usuarios</th>
                    <th align="center" width='15'>Ver</th>
                    <th align="center" width='15'>Editar</th>
                    <th align="center" width='15'>Publicado</th>
                <thead>
<%                              if (lAlerta.size() == 0){%>
                <tr>
                    <td colspan="4">No existen alertas >>>> </td>
                </tr>
<%                              }  
                for (int i=0; i < lAlerta.size (); i++) {
                    Alerta oAlerta = (Alerta) lAlerta.get (i);
%>
                <tr>
                    <td align="left">&nbsp;<%= oAlerta.gettitulo()%></td>
                    <td align="left">&nbsp;<%=( oAlerta.getfechaDesde() == null ? "no informado" : Fecha.showFechaForm(oAlerta.getfechaDesde()))%></td>
                    <td align="left">&nbsp;<%=( oAlerta.getfechaHasta() == null ? "no informado" : Fecha.showFechaForm(oAlerta.getfechaHasta()))%></td>
                    <td align="left"><%= oAlerta.getsBody() %></td>
                    <td nowrap  align="center">
                        <span><IMG onClick="Alerta ('<%= oAlerta.getcodAlerta()%>');"  alt="Visualizar alerta" src="<%= Param.getAplicacion() %>images/HTML.gif"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;">
                        </span>
                    </td>
<%      if (oAlerta.getmcaPublica() == null || oAlerta.getmcaPublica().equals ("") ) {
    %>
                    <td nowrap  align="center">
                        <span><IMG onClick="Modificar('<%= oAlerta.getcodAlerta()%>');"  alt="Editar alerta" src="<%= Param.getAplicacion() %>images/editdocument.gif"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;">
                        </span>
                    </td>
<%      } else {
    %>
                    <td>&nbsp;</td>            
<%      }
    %>
                   <td align="center"><%=(oAlerta.getmcaPublica() == null || oAlerta.getmcaPublica().equals ("") ? "NO" : "SI")%>
                        <span>
                               <IMG onClick="CambiarEstado('<%= oAlerta.getcodAlerta()%>','<%=(oAlerta.getmcaPublica() == null || oAlerta.getmcaPublica().equals ("") ? "X" : "")%>');"  
                                 alt="Cambiar el estado de publicación" src="<%= Param.getAplicacion() %>images/<%= (oAlerta.getmcaPublica() == null || oAlerta.getmcaPublica().equals ("") ? "nook.gif" : "ok.gif") %>"  
                                 border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;">
                        </span>
                    </td>
                </tr>
<%                              }     
%>
        </table>	
	</TD>
  </TR>
  <TR vAlign="bottom">
    <td  align="center" height='30' valign="middle">
	<input class="Boton"  type="Button" name="cmdSalir" value=" Salir " onclick="Salir();" >
&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="Boton"  type="Button" name="cmdAceptar" value="Nueva alerta" onclick="Nueva();" >
	</td>
  </TR> 
</TABLE>
</form>
</body>
</html>