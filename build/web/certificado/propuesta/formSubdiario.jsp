<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.util.*"%> 
<%@page import="com.business.beans.Usuario"%>
<%@ taglib uri="http://jsptags.com/tags/navigation/pager" prefix="pg" %>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<%
     Usuario usu = (Usuario) session.getAttribute("user"); 
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE>Generar Archivo de Certificado de Propuesta </TITLE>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<LINK rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>css/Tablas.css"/>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<SCRIPT type="text/javascript" language="javascript">
     function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

    function GenerarArchivo () {        
        document.form1.submit ();
    }
 

</SCRIPT>
</HEAD>
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
        <TD align="center" valign="top" width='100%' height='450' >
            <TABLE width='100%' cellpadding='0' cellspacing='1' border='0' align="center" style='margin-top:5;margin-bottom:5;' class="fondoForm" >
                <FORM action='<%= Param.getAplicacion()%>servlet/CertificadoServlet' id="form1" name="form1"  method="POST">
                <input type="hidden" name="opcion" id="opcion" value="genArchivoCertifProp">
                <TR>
                    <TD width='100%' height='30' align="center"  valign="middle" class='titulo'>SUBDIARIO DE CERTIFICADOS DE PROPUESTAS WEB</TD>
                </TR>
<%      if (request.getAttribute("nameFile")== null) { %>
                <TR>
                    <td align="center" valign="top"   class="text" height='100%'>Ingrese el periodo a imprimir. Se generará un archivo de texto con certificados emitidos en el periodo seleccionado.</td>
                </tr>
                <tr>
                    <td align="left"  class="text">Fecha Desde:&nbsp;<input name="fecha_desde" id="fecha_desde" size="10" 
                    onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value="">&nbsp;(dd/mm/yyyy)</td>
                </tr>
                <tr>
                    <td align="left"  class="text">Fecha Hasta:&nbsp;<input name="fecha_hasta" id="fecha_hasta" size="10" 
                    onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value="">&nbsp;(dd/mm/yyyy)</td>
                </tr>
<%      } else { %>
                <TR>
                    <TD align="left" class="text" height='100%'>
                    El Archivo&nbsp;<STRONG>  <%=request.getAttribute("nameFile")%></STRONG>&nbsp;&nbsp;ha sido generado con exito !!.<BR><BR>   
                    Usted se lo puede bajar desde&nbsp;                   
                    <A href="<%= Param.getAplicacion()%>files/certificados/<%=request.getAttribute("nameFile")%>"  target='_blank' onmouseover="this.style.textDecoration='underline';" onmouseout="this.style.textDecoration='none';">&nbsp;aqui&nbsp;&nbsp;</A>                      
                    <A href="<%= Param.getAplicacion()%>files/certificados/<%=request.getAttribute("nameFile")%>"  target='_blank'>
                        <IMG src="/images/TXT.gif" height="20" width="20" border="0" alt="<%=request.getAttribute("nameFile")%>">
                    </A>   
                </TD>                                
            </TR>
<%      }  %>
                <TR>
                    <td align="center">
                        <input type="button" name="cmdSalir"  value=" Salir "  height="20px" class="boton" onClick="Salir();">&nbsp;&nbsp;&nbsp;&nbsp;
<%      if (request.getAttribute("nameFile")== null) { %>
                        <input type="button" name="cmdGrabar" value=" Enviar " height="20px" class="boton" onClick="GenerarArchivo();">
<%      }%>
                    </td>
                </TR>
            </form>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD width='100%'>
            <jsp:include flush="true" page="/bottom.jsp"/>
        </TD>
    </TR>
</TABLE>
<script>
CloseEspere();
</script>
</body>
</html>


