<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Poliza"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>   
<% Usuario usu = (Usuario) session.getAttribute("user"); 
    %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
    <script language="javascript">
    function Salir () {
        window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

    function Mensaje ( opcion ) {
        if (opcion == 'getCtaCte') {
            alert ("Ingrese desde el menú de Cobranza y allí encontrara la información que esta buscando ");
        } else if (opcion == 'getRenoPend' ) {
            alert ("Ingrese desde Cartera --> Renovaciones y consulte las pólizas pendientes de renovación ")
        }
        return true;
    }

    function EnviarConsulta ( opcion ) {
        
        var popup = '';
        var W = 600;
        var H = 300;
        
        if ( opcion == 'getCopiaPoliza' ) {  
            popup = 'consulta/PopUpCopiaPoliza2.jsp';
        } else if ( opcion == 'getPreLiq') {  
            popup = 'consulta/PopUpPreliquidacion.jsp';
        } else if ( opcion == 'getCtaCte') {  
            popup = 'consulta/PopUpCtaCteProd.jsp';
        } else if ( opcion == 'getCopiaLiq') {  
            popup = 'consulta/PopUpCopiaLiquidacion.jsp';
        } else if ( opcion == 'getRenoPend') {  
            popup = 'consulta/PopUpRenovaciones.jsp';
        } else if ( opcion == 'getComisiones') {  
            popup = 'consulta/PopUpComisiones.jsp';
        } else if ( opcion == 'getCuponPoliza') {  
            popup = 'consulta/PopUpCopiaPoliza2.jsp?opcion=getCuponPoliza';
            H = 275;
        }

        var sUrl = "<%= Param.getAplicacion()%>" + popup ;

        AbrirPopUp (sUrl, W, H);
        return true;
    }
    
    function Submitir (param) {

        document.form1.opcion.value      = param.opcion.value;
        document.form1.email.value       = param.email.value;

        if (param.opcion.value == 'getCtaCte') {
                document.form1.cod_prod.value    = param.cod_prod.value;
//                document.form1.fecha_desde.value = param.fecha_desde.value;
                document.form1.fecha_hasta.value = param.fecha_hasta.value;
        }

        if ( param.opcion.value == 'getPreLiq') { 
                document.form1.cod_prod.value       = param.cod_prod.value;
        } 

        if (param.opcion.value == 'getCopiaPoliza' || param.opcion.value == 'getCuponPoliza') {
                document.form1.cod_rama.value    = param.cod_rama.value;
                document.form1.num_poliza.value  = param.num_poliza.value;
                document.form1.endoso.value      = param.endoso.value;
                document.form1.nomina.value      = param.nomina.value;
        }
        
        if (param.opcion.value == 'getComisiones') {
                document.form1.cod_prod.value   = param.cod_prod.value;
                document.form1.fecha_hasta.value = param.fecha_hasta.value;
        }

        if ( param.opcion.value == 'getRenoPend') { 
                document.form1.cod_prod.value       = param.cod_prod.value;
                document.form1.fecha_hasta.value    = param.fecha_hasta.value;
        } 

        if (param.opcion.value == 'getCopiaLiq') {
                document.form1.cod_prod.value    = param.cod_prod.value;
                document.form1.fecha_hasta.value = param.fecha_hasta.value;
                document.form1.liquidacion.value = param.liquidacion.value;
        }

        document.form1.submit();
        return true;
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
        <td valign="top" align="center" width="100%">
            <form name="form1" id="form1" method="POST" action="<%= Param.getAplicacion()%>servlet/ConsultaServlet">
                <input type="hidden" name="opcion"      id="opcion" value=""/>
                <input type="hidden" name="num_poliza"  id="num_poliza" value=""/>
                <input type="hidden" name="endoso"      id="endoso" value=""/>
                <input type="hidden" name="cod_prod"    id="cod_prod" value="<%= usu.getiCodProd () %>"/>
                <input type="hidden" name="cod_rama"    id="cod_rama" value=""/>
                <input type="hidden" name="email"       id="email" value=""/>
                <input type="hidden" name="fecha_desde" id="fecha_desde" value=""/>
                <input type="hidden" name="fecha_hasta" id="fecha_hasta" value=""/>
                <input type="hidden" name="mes"         id="mes" value=""/>
                <input type="hidden" name="anio"        id="anio" value=""/>
                <input type="hidden" name="liquidacion" id="liquidacion" value=""/>
                <input type="hidden" name="nomina"      id="nomina" value="S"/>                

                <table width="100%" border="0" align="center" cellspacing="2" cellpadding="4"  class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                    <TR>
                        <TD height="30px" valign="middle" align="center" class='titulo' colspan='2'>SERVICIO DE ENVIO DE MAIL</TD>
                    </TR>
                    <TR>
                        <TD height="30px" valign="middle" align="left" class='subtitulo' colspan='2'>
                        Seleccione la informaci&oacute;n que desea obtener y recibir&aacute; un mail inmediatamente con la misma:
                        </TD>
                    </TR>
                    <tr>
                        <td align="left"  width='130'>
                            <input type="button" name="cmdGrabar1" style='width:270px;' value="Copia de P&oacute;liza/Endoso >>>"
                                   height="24px" class="boton" onClick="EnviarConsulta ('getCopiaPoliza');">
                        </td>
                        <td align="left" class='text'>Ingresando rama, n&uacute;mero de p&oacute;liza y endoso le enviaremos una copia a su casilla de mail</td>
                    </tr>
                    <tr>
                        <td align="left">
                            <input type="button" name="cmdGrabar1"  style='width:270px;' value="Cuponera actualizada >>>        "  height="20px"
                                   class="boton" onClick="EnviarConsulta ('getCuponPoliza');">
                        </td>
                        <td align="left" class='text'>Cuponera actualiza de p&oacute;liza, incluye acreditaciones y d&eacute;bitos.</td>
                    </tr>
<%    if( usu.getiCodTipoUsuario () != 2) {
              if (usu.getiCodTipoUsuario() == 0 ) {
    %>
                    <tr>
                        <td align="left"><input type="button" name="cmdGrabar2" style='width:270px;' value="Preliquidaci&oacute;n >>>       "  height="20px" class="boton" onClick="EnviarConsulta ('getPreLiq');"></td>
                        <td align="left" class='text'>Se refiere a la preliquidaci&oacute;n correspondiente al pr&oacute;ximo vencimiento</td>
                    </tr>
<%              } else {
    %>
                    <tr>
                        <td align="left"><input type="button" name="cmdGrabar2" style='width:270px;' value="Preliquidaci&oacute;n >>>       "  height="20px" class="boton" onClick="Mensaje ('getPreLiq');"></td>
                        <td align="left" colspan="2" class='subtitulo'>
                            &nbsp;Ingrese desde el men&uacute;&nbsp;<span style="color:blue;">Cobranza --> Preliquidaci&oacute;n</span>.
                        </td>
                    </tr>

<%            }
              if (usu.getiCodTipoUsuario() == 0 ) {
    %>
                    <tr>
                        <td align="left">
                            <input type="button" name="cmdGrabar3"  style='width:270px;'              value="Cuenta corriente >>>            "
                                   height="20px" class="boton" onClick="EnviarConsulta ('getCtaCte');"></td>
                        <td align="left" class='text'>Desde aqui obtendr&aacute; el estado de su cuenta corriente en un periodo determinado.</td>
                    </tr>
                    <tr>
                        <td align="left"><input type="button" name="cmdGrabar5"  style='width:270px;' value="Renovaciones pendientes >>>     "  height="20px" class="boton" onClick="EnviarConsulta ('getRenoPend');"></td>
                        <td align="left" class='text'>Resumen de Renovaciones Pendientes</td>
                    </tr>
<%              } else {
    %>
                   <tr>
                        <td align="left">
                            <input type="button" name="cmdGrabar3"  style='width:270px;' value="Cuenta corriente >>>            "
                                   height="20px" class="boton" onClick="Mensaje ('getCtaCte');"></td>
                       <td align="left" colspan="2" class='subtitulo'>
                           &nbsp;Consulte su Cuenta Corriente ingresando desde&nbsp;<span style="color:blue;">Cobranza --> Cuenta Corriente</span>.
                           Tambi&eacute;n podr&aacute; emitir una copia del certificado de retenciones y liquidaci&oacute;n de cobranza.
                        </td>
                    </tr>
                    <tr>
                        <td align="left"><input type="button" name="cmdGrabar5"  style='width:270px;' value="Renovaciones pendientes >>>    "  height="20px" class="boton" onClick="Mensaje ('getRenoPend');"></td>
                        <td align="left" colspan="2" class='subtitulo'>
                            &nbsp;Consulte sus p&oacute;lizas a renovar desde&nbsp;<span style="color:blue;">Cartera --> Renovaciones</span>.
                        </td>
                    </tr>

<%             }
    %>
                    <tr>
                        <td align="left"><input type="button" name="cmdGrabar4"  style='width:270px;' value="Copia de liquidaci&oacute;n   >>>      "  height="20px" class="boton" onClick="EnviarConsulta ('getCopiaLiq');"></td>
                        <td align="left" class='text'>Para recibir este informe debera ingresar el n&uacute;mero de liquidaci&oacute;n</td>
                    </tr>
                    <tr>
                        <td align="left"><input type="button" name="cmdGrabar6"  style='width:270px;' value="Comisiones a facturar  >>>      "  height="20px" class="boton" onClick="Mensaje ('getComisiones');"></td>
                       <td align="left" colspan="2" class='subtitulo'>
                            &nbsp;Ingrese desde <span style="color:blue;">Cobranza --> Comisiones a Fact.</span> y podr&aacute; consultar todas
                            las comisiones a cobrar y facturas emitidas desde Dic. 2010.
                        </td>
<%--                        <td align="left" width='70%' class='text'>Resumen de Comisiones a facturar</td>
--%>
                    </tr>
<%
     } 
    %>
                    <tr>
                        <td align="center"  colspan='2'>
                        <input type="button" name="cmdSalir"  value="  Salir  "  height="20px" class="boton" onClick="Salir ();">
                        </td>
                    </tr>
                 </table>
            </form>
        </td>
    </tr>
    <tr>
        <td valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
   </tr>
</table>
<script>
     CloseEspere();
</script>
</body>
</HTML>
