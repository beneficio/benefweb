<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.*"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<% Usuario usu = (Usuario) session.getAttribute("user"); 
    HtmlBuilder ohtml       = new HtmlBuilder();
    LinkedList lLista = (LinkedList) request.getAttribute("vigencias"); 
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
</head>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script language='javascript'>
      var lastError=null;
      function Submitir () {
            return true;
      }

    function Grabar () {
        if (confirm("Esta usted seguro que desea solicitar el certificado de cobertura ")) {
            document.form1.opcion.value = "addCotizacion";
            document.form1.submit();
            return true;
        } else {
            return false;
        }
    }

    function Volver () {
           window.location.replace("<%= Param.getAplicacion()%>abm/formAbmIndex.jsp");
    }

    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

</script>
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
        <td align="center" valign="top" width='100%'>
           <form name="formImpuesto" id="formImpuesto" method="POST" action="<%= Param.getAplicacion()%>servlet/VigenciaServlet">
            <input type="hidden" name="opcion" id="opcion" value="addVigencia">
            <input type="hidden" name="cant_vigencia" id="cant_vigencia" value="<%=lLista.size()%>">
            <table width='200' cellpadding='0' cellspacing='0' border='0' align="center" class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                <tr>
                    <td colspan="2" width='100%' height='30' align="center" class='titulo'>VIGENCIAS</td>
                </tr>
                <tr>
                <td align="center">
                <table width='180' cellpadding='0' cellspacing='0' border='0'> 
                    <th align="left">
                    Vigencia
                    </th>  
                    <th align="left">
                    Cuotas
                    </th>  
<%              if (lLista.size() == 0){%>
                    <tr>
                        <td colspan="2">No existen vigencias a listar</td>
                    </tr>
<%              }  
                for (int i=0; i < lLista.size (); i++) {
                     Vigencia oVigencia = (Vigencia) lLista.get (i);
%>                       
                  <tr>
                    <td class='text'>
                    <%= oVigencia.getdescVigencia() %>
                    </td>
                    <td class='text'>
                    <input class="inputTextNumeric" type="text" size="5" name="CANT_CUOTAS_<%=i%>" id="CANT_CUOTAS_<%=i%>" value="<%= oVigencia.getcantCuotas() %>">   
                    <input type="hidden" name="COD_RAMA_<%=i%>" id="COD_RAMA_<%=i%>" value="<%= oVigencia.getcodRama() %>">
                    <input type="hidden" name="COD_VIGENCIA_<%=i%>" id="COD_VIGENCIA_<%=i%>" value="<%= oVigencia.getcodVigencia() %>">
                    </td>
                  </tr>
<%              }%> 
                <tr>
                    <td align="center" colspan="2">  
                        <br>  
                        <input type="button" name="cmdSalir" value=" Salir " height="20px" class="boton" onClick="Salir();">&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button" name="cmdVolver" value=" Volver " height="20px" class="boton" onClick="Volver();">&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="submit" name="cmdGrabar" value=" Enviar " height="20px" class="boton">
                    </td>
                </tr>
            </table>
            </td>
            </tr>
            </table>   
            </form>
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
