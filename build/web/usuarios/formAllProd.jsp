<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp" session="true"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%> 
<%@page import="com.business.beans.Propuesta"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.CallableStatement"%>
<%@ taglib uri="http://jsptags.com/tags/navigation/pager" prefix="pg" %>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<%
Usuario usu = (Usuario) session.getAttribute("user"); 
String sParam = "";  

    Connection        dbCon = null;
    ResultSet rs            = null;
    CallableStatement cons  = null;
    LinkedList        lProp  = new LinkedList();
    LinkedList        lCertif = new LinkedList();

    try {  
        dbCon = db.getConnection();                                
        dbCon.setAutoCommit(false);            
        cons = dbCon.prepareCall(db.getSettingCall("US_GET_ALL_PRODUCTORES_POR_ORG (?)"));            
        cons.registerOutParameter(1, java.sql.Types.OTHER);
        cons.setInt (2, Integer.parseInt (request.getParameter ("cod_org")));

        cons.execute();

       rs = (ResultSet) cons.getObject(1);
    %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
<script language="JavaScript">

    function Salir () {
         history.back();
    }
</script>
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
        <td align="center" valign="top" width='100%' height='100%'>
            <TABLE height="100%"   width="100%"  border="0" cellspacing="0" cellpadding="0" align="center" >
                <TR>
                    <TD height='30px'  valign="middle" class='titulo' align="center">LISTADO DE PRODUCTORES - Organizador N° <%= request.getParameter ("cod_org") %></td>
                </TR>
                <TR>
                    <td height="100%"  valign="top">
                        <table border="1" cellspacing="0" cellpadding="2" align="center" style="margin-left:5px;" class='TablasBody'>
                            <thead>
                                <th align="center" width='250' nowrap>Productor</th>
                                <th align="center" width='100' nowrap>Código</th>
                                <th align="center" width='65'>Estado</th>
                            <thead>
<%                      if (rs != null) {
                            while (rs.next()) {
            %>
                                <tr> 
                                    <td align="left" nowrap><%= rs.getString ("DESCRIPCION") %></td> 
                                    <td align="right" nowrap><%= rs.getInt ("COD_PROD")%></td> 
                                    <td align="center" style="color:<%= (rs.getString ("ESTADO").equals ("S") ? "green" : "red") %>"><%= ( rs.getString ("ESTADO").equals ("S") ? "Habilitado" : "Deshabilitado") %></td> 
                                 </tr>
<%
                                }
                                rs.close ();
                            }
%>                                            
                        </table>
                    </td>
                </tr>
                <tr valign="bottom" >
                    <td width="100%"  >
                        <table width="100%" height="30px" border="0" cellspacing="0" cellpadding="0" align="center" >
                            <TR>
                                <td align="center">
                                    <input type="button" name="cmdSalir" value="Salir" width="100px" height="20px" class="boton" onClick="Salir()">
                                </TD>
                            </TR>
                        </TABLE>		
                    </td>
                </TR>
            </TABLE>
        </td>
    </tr>
    <tr>
        <td width='100%'>
            <jsp:include flush="true" page="/bottom.jsp"/>
        </td>
    </tr>
</table>
<script>
CloseEspere();
</script>
</body>
</html>
<%    } catch (Exception e) {
        throw new SurException (e.getMessage());
    } finally {
        try {
            if (rs != null) rs.close ();
            if (cons != null) cons.close ();
        } catch (SQLException se) {
            throw new SurException (se.getMessage());
        }
        db.cerrar(dbCon);
    }
%>


