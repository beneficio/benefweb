<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.util.*"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css">
    <link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>css/Tablas.css">
</head>
<body>
<table border="0" cellspacing="0" cellpadding="0"  height="100%" width='720'>
    <TR>
        <TD height="100%" valign="top" width='100%'>
            <TABLE class="fondoForm" align="center" width='95%' cellpadding='2' cellspacing='2' border='0'>
                <TR>
                    <TD valign="top" align="center" class='subtitulo' colspan='4' height='30'>Vista Previa</TD>
                </TR>
                <TR>
                    <TD class="text">T&iacute;tulo:</TD>
                    <TD class="text" colspan='3'>
                        <%=request.getParameter("titulo")%>
                    </TD>
                </TR>
                <TR>
                    <TD class="text">Tipo de usuario:</TD>
                    <TD class="text" colspan='3' >
                        <%=request.getParameter("tipoUsuarioDesc")%>
                    </TD>
                </TR>
                <TR>
                    <TD nowrap  width='120' class="text" align="left">Fecha de Publicación:</TD>
                    <TD width='200' class="text" align="left">
                        <%=request.getParameter("fecha")%>
                    </TD>
                    <TD nowrap width='120' class="text" align="left">Vencimiento:</TD>
                    <TD class="text"  align="left" width='25%'>
                        <%=request.getParameter("vencimiento")%>
                    </TD>
                </TR>
                <tr>
                    <td colspan="4" valign="middle" height='300px'>
                       <div id="editor" style="overflow:auto;background-color:white;width:100%;height:300px"><%=request.getParameter("html")%></div>
                    </td>
               </tr>
            </TABLE>
        </TD>
    </TR>
</table>
    </body>
</html>
