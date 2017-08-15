<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>
<% Usuario usu = (Usuario) session.getAttribute("user"); 

    if (usu.getiCodTipoUsuario() != 0) {
        request.setAttribute("javax.servlet.jsp.jspException", new SurException ("acceso denegado"));
        getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
        
    }
%> 
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css">
    <LINK rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>css/Tablas.css">	
    <script type="" language="JavaScript" src="<%=Param.getAplicacion()%>script/formatos.js"></script>
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
        <TR>
            <TD width="100%" align="center" class='titulo' height="30" valign="middle">ADMINISTRACION DE PUBLICACIONES<HR></TD>
        </TR>
        <TR>
            <td height="100%" valign="top">
                <table align="center" border="0" width="100%">
                    <tr>
                        <td valign="top">
                            <jsp:include page="left.html"></jsp:include>
                        </td>
                        <td height="100%" valign="top">
                            <jsp:include page="viewNovedadesBody.jsp"></jsp:include>
                        </td>
                    <tr>
                </table>
            </td>
        </TR>
        <tr>
            <td width='100%'>
                <jsp:include flush="true" page="/bottom.jsp"/>
            </td>
        </tr>
    </table>
</body>
</html>