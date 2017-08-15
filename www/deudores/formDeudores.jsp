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
    Tablas oTabla = new Tablas ();
    LinkedList lTabla = new LinkedList ();
    %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
</head>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script language='javascript'>
    function Grabar ( tipo ) {
        
<%         if (usu.getiCodTipoUsuario () == 0) {
%> 
          
            if ( document.getElementById('cod_prod2').options [ document.getElementById('cod_prod2').selectedIndex].value == "0"
            && document.getElementById('num_tomador2').options [ document.getElementById('num_tomador2').selectedIndex].value == "0") {
                alert ("Debe seleccionar un productor o un cliente");
                return false;
            }
            document.getElementById('cod_prod').value    = document.getElementById('cod_prod2').options [ document.getElementById('cod_prod2').selectedIndex].value;
            document.getElementById('num_tomador').value = document.getElementById('num_tomador2').options [ document.getElementById('num_tomador2').selectedIndex].value
<%
        } else {
            if (usu.getiCodTipoUsuario () != 0 && usu.getiCodProd () >= 80000 ) { 
 %>
                    if ( document.getElementById('cod_prod2').options [ document.getElementById('cod_prod2').selectedIndex].value == "0") {
                        alert ("Debe seleccionar un productor de la lista");
                        return false;
                    }
                    document.getElementById('cod_prod').value    = document.getElementById('cod_prod2').options [ document.getElementById('cod_prod2').selectedIndex].value;
                    document.getElementById('num_tomador').value = '0';
<%
            }
        }
%>
        if ( tipo == 'EXCEL' ) {
            document.form1.action = "<%= Param.getAplicacion()%>servlet/DeudoresServlet";
        } 
        
        document.form1.tipo.value = tipo;
        document.form1.submit();
        return true;
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
    <form method="post" action="<%= Param.getAplicacion()%>deudores/printDeudores.jsp" name='form1' id='form1'>
        <input type="hidden" name="opcion" id="opcion" value="getDeudores">
        <input type="hidden" name="tipo" id="tipo" value="HTML">
        <input type="hidden" name="cod_prod" id="cod_prod" value="<%= usu.getiCodProd() %>">
        <input type="hidden" name="num_tomador" id="num_tomador" value="<%= usu.getiNumTomador() %>">
        <input type="hidden" name="tipo_usuario" id="tipo_usuario" value="<%= usu.getiCodTipoUsuario () %>">

            <table width='100%' cellpadding='2' cellspacing='4' border='0' align="center" class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                <tr>
                    <td width='100%' height='30' align="center" class='titulo'>DEUDORES POR PREMIO</td>
                </tr>
<%          if (usu.getiCodTipoUsuario() != 0) {
    %>
                <tr>
                    <td width='100%' align="left" class='subtitulo'>
                    Si usted no ingresa nungún filtro, 
                    visualizará todas las pólizas. En cambio ingresando número de póliza o asegurado podrá 
                    ver solo las pólizas filtradas.
                    </td>
                </tr>
<%          }
    %>
                <tr>
                    <td align="center" valign="top">
                        <table border='0' align="center" cellpadding='1' cellspacing='1' width="100%">
<%                      if (usu.getiCodTipoUsuario() == 0 || usu.getiCodProd () >= 80000) {
    %>
                            <tr>
                                <td colspan='2' align="left" class="text" width="100%">
Debe seleccionar un productor o un cliente válido:
                                </td>
                            </tr>
                            <tr>
                                <td align="left"  width='100'  class="text">Productor:&nbsp;</td>
                                <td align="left" width='700'>
                                    <select class='select' name="cod_prod2" id="cod_prod2"  style="width: 300px;">
                                        <option value='0' >Seleccione productor</option>
<%                               LinkedList lProd = (LinkedList) session.getAttribute("Productores");
                                 for (int i= 0; i < lProd.size (); i++) {
                                        Usuario oProd = (Usuario) lProd.get(i);
                                        out.print("<option value='" + String.valueOf (oProd.getiCodProd()) + "'  >" + oProd.getsDesPersona() + " (" + oProd.getiCodProd() + ")</option>");
                                    }
    %>
                                    </select>
                                </td>
                            </tr>
<%                  }
                    if (usu.getiCodTipoUsuario() == 0) {
    %>
                            <tr>
                                <td align="left"  class="text">Cliente:&nbsp;</td>
                                <td align="left" >
                                    <select class='select' name="num_tomador2" id="num_tomador2" style="width: 300px;">
                                        <option value='0' >Seleccione cliente</option>
<%                                  LinkedList lClientes = (LinkedList) session.getAttribute("Clientes");
                                    for (int i= 0; i < lClientes.size (); i++) {
                                        Usuario oProd = (Usuario) lClientes.get(i);
                                        out.print("<option value='" + String.valueOf (oProd.getiNumTomador()) + "'>" + oProd.getsDesPersona() + " (" + oProd.getiNumTomador() + ")</option>");
                                    }
    %>
                                    </select>
                                </td>
                            </tr>

<%                      }
    %>
                            <tr>
                                <td align="left"  class="text">Asegurado:</td>
                                <td align="left"  class="text"><input name="tomador" id="tomador" size='45'></td>
                            </tr>
                            <tr>
                                <td align="left"  class="text" colspan='2'>Ver todos los deudores por premio con una deuda mayor a:&nbsp;
                                    <input name="min_deuda" id="min_deuda" size='12' maxlength='12' value="1.00" onkeypress="return Mascara('D',event);" class="inputTextNumeric">
                                    (ingresando cero (0) visualiza todos los clientes)
                                </td>
                            </tr>
  <%--                          <tr>
                                <td align="left"  class="text" colspan='2'>Imprime saldos negativos:&nbsp;
                                    <input type="checkbox" name="negativo" value='no' onclick='CambiarNegativos ( this );'>
                                </td>
                            </tr>

                            <tr>
                                <td align="left"  class="text">Deuda al:&nbsp;</td>
                                <td align="left"  class="text"><input name="fecha" id="fecha" size="10" onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value="<%= Fecha.getFechaActual()%>" readonly>
                                </td>
                            </tr>
  --%>
  <input type="hidden" name="fecha" id="fecha" value="<%= Fecha.getFechaActual()%>">
                            <tr>
                                <td align="left"  class="text">N&uacute;m. de P&oacute;liza:</td>
                                <td align="left" class="text"><input name="num_poliza" id="num_poliza"  size='12' maxlength='12'  onkeypress="return Mascara('D',event);" class="inputTextNumeric">
                                <SPAN style="color:red">ATENCI&Oacute;N:</span> Ingrese el n&uacute;mero de p&oacute;liza sin el digito verificador
                                </td>
                            </tr>
                            <input type="hidden" name="consolidado" id="consolidado" value="S">
<%--                            <tr>
                                <td align="left" class="text">Ver consolidado:&nbsp;</td>
                                <td align="left">
                                    <select class='select' name="consolidado" id="consolidado">
                                        <option value='S'>SI</option>
                                        <option value='N'>NO</option>
                                    </select>
                                </td>
                            </tr>
                           <tr>
                                <td align="left" class="text">Como desea visualizarlo:&nbsp;</td>
                                <td align="left">
                                    <select class='select' name="tipo" id="tipo">
                                        <option value='html'>Normal web (HTML)</option>
                                        <option value='pdf'>Acrobat Reader (PDF)</option>
                                    </select>
                                </td>
                            </tr>
--%>
                        </table>
                    </td>
                </tr>
                <tr>
                     <td align="left"  class="subtitulo" >Seleccione como desea visualizarlo:</td>
                </tr>
                <tr>
                    <td align="center" width="100%">
                        <table border='0' align="center" cellpadding='1' cellspacing='1'>
                            <tr>
                                <td width='34%' align="center"> 
                                    <IMG src='<%= Param.getAplicacion()%>images/HTML.gif' border='0' align="center">
                                </td>
                                <td width='33%' align="center">  
                                    <IMG src='<%= Param.getAplicacion()%>images/PDF.gif' border='0' align="botom">
                                </td>
                                <td width='34%' align="center">  
                                    <IMG src='<%= Param.getAplicacion()%>images/XLS.gif' border='0' align="botom">
                                </td>
                            </tr>
                            <tr>
                                <td align="center">
                                    <input type="button" name="cmdHTML" value="página web (HTML)" height="20px" class="boton" onclick="Grabar ('HTML');">
                                </td>
                                <td align="center">
                                    <input type="button" name="cmdPDF" value="acrobat reader (PDF)" height="20px" class="boton" onclick="Grabar ('PDF');">
                                </td>
                                <td align="center">
                                    <input type="button" name="cmdEXCEL" value="exportar a excel (XLS)" height="20px" class="boton" onclick="Grabar ('EXCEL');">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="center">  
                        <input type="button" name="cmdSalir" value=" Salir " height="20px" class="boton" onClick="Salir();">
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
