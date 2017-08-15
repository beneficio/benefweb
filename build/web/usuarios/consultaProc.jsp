<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.*"%>
<%@page import="java.sql.*"%>
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>   
<% 
 Usuario usu = (Usuario) session.getAttribute("user"); 
Connection dbCon = db.getConnection();
dbCon.setAutoCommit(false);
// Procedure call.
CallableStatement proc = dbCon.prepareCall(db.getSettingCall("INT_GET_ALL_INTERFASES()"));
proc.registerOutParameter(1, java.sql.Types.OTHER);
proc.execute();
ResultSet rs = (ResultSet) proc.getObject(1);
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
   <SCRIPT language="javascript">
    function Salir () {
        window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }
    </SCRIPT>
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
        <td valign="top" align="center">
<TABLE  width="100%" border="0" cellspacing="0" cellpadding="2">
    <tr>
        <td height="30" class='titulo' valign="middle" align="center">Consulta de Interfases</td>
    </tr>
    <tr>
        <td   valign="top">
            <table  border="1" cellspacing="0" cellpadding="0" align="center" class="TablasBody">
                <thead>
                    <th  width="500px">Dato</th>
                    <th  width="65px">Inicio/fin</th>
                    <th  width="65px">Fecha interfase</th>
                    <th  width="65px">Fecha AS400</th>
                    <th  width="65px">Hora</th>
                    <th  width="65px">Cantidad</th>
                </thead>
<%          if (rs == null ){%>
                <tr>
                    <td colspan="5">&nbsp;No existe información de interfases</td>
                </tr>
<%          } else { 
                String sTablaAnt = ""; 
                while (rs.next ()) { 
    %>
                <tr>
<%                  if ( ! sTablaAnt.equals (rs.getString("DESCRIPCION"))) {
                        sTablaAnt = rs.getString("DESCRIPCION");
    %>
                    <td align="left"><span><%= rs.getString("DESCRIPCION") %>&nbsp;</span></td>
<%                  } else {
    %>
                    <td>&nbsp;</td>
<%                  }
    %>
                    <td align="center" ><span style="color:<%= (rs.getString("SECUENCIA").equals("INI") ? "green" : "red") %>"><%= (rs.getString("SECUENCIA").equals("INI") ? "Inicio" : "Final") %></span>&nbsp;</td>
                    <td ><span><%= (rs.getDate ("FECHA_TRABAJO") == null ? " " : Fecha.showFechaForm (rs.getDate ("FECHA_TRABAJO"))) %></span>&nbsp;</td>
                    <td ><span><%= (rs.getDate ("FECHA_FTP") == null ? " " : Fecha.showFechaForm (rs.getDate ("FECHA_FTP"))) %></span>&nbsp;</td>
                    <td ><span><%= (rs.getTime ("HORA_TRABAJO")) %></span>&nbsp;</td>
                    <td align="right" ><span><%= rs.getInt ("FILAS") %></span>&nbsp;</td>
                </tr>
<%              }  
            }%>
            </table>	
        </td>
    </tr>
    <tr valign="bottom" >
        <td width="100%" align="center">
            <input type="button" name="cmdSalir" value=" Salir "  height="20px" class="boton" onClick="Salir();">
        </td>
    </tr>
   <TR>
        <TD valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
    </tr>
</table>
<%      if (rs != null)  rs.close ();
        if (proc != null)  proc.close ();
        db.cerrar(dbCon);
    %>
</body>
</html>
<script>
     CloseEspere();
</script>
