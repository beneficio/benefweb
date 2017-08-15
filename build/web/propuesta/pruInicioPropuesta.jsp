<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.*"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<HTML>
<head>
    <title>Imicio </title>
</head>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css">
<SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<SCRIPT type="" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script language='javascript'>
    function Enviar (){        
        form1.submit();
        return true;
    }
</script >

<body>
<form method="post" action="<%= Param.getAplicacion()%>servlet/PropuestaServlet" name='form1' id='form1'>
    <input type="hidden" name="opcion" id="opcion" value="generarPropuesta">
    <TABLE  border='1'>        
        <TR>                   
            <TD align="left" class='text'>Nro. Propuesta:</TD>
            <TD align="left" class='text'><INPUT type="text" name="numCotizacion" id="numCotizacion" value="" size="20" maxlengh="20"></TD>
        </TR>            
        <TD align="center">
           <input type="button" name="cmdEnviar"  value="  ENVIAR >>>>  "  height="20px" class="boton" onClick="Enviar();">
        </TD>

        </TR>        
    </TABLE>
<FORM>
</body>
</HTML>
