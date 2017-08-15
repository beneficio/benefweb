<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Propuesta"%>
<%@page import="com.business.beans.Clausula"%>
<%@page import="com.business.beans.UbicacionRiesgo"%>
<%@page import="com.business.beans.AseguradoPropuesta"%>
<%@page import="com.business.beans.AsegCobertura"%>
<%@page import="java.util.*"%>
<%@page import="java.util.LinkedList"%>
<%  

    Usuario usu = (Usuario) session.getAttribute("user");
    String sFechaRendicion =  (request.getParameter ("fecha_rendicion") == null ? null : request.getParameter ("fecha_rendicion"));
    String sNuevas         = request.getParameter ("nuevas");
    String sModif          = request.getParameter ("modif");
    String importeTotal    = request.getParameter ("importeTotal");

%>
<HTML> 
<head><title>Impresión de reporte para el Banco Nación</title></head>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css">
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script language='javascript'>

    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

</script>
<body leftmargin=0 topmargin=0 style="margin-top: 0; margin-right: 0; margin-left: 0; margin-bottom: 0; padding-bottom: 0; padding-left: 0; padding-right: 0; padding-top: 0; top: 0; vertical-align: top;">
    <TABLE align="center" width='100%' border='0' cellpadding='0' cellspacing='6' >
        <TR>
            <td width='100%' height='60'>
                <table border='0' cellpadding='2' cellspacing='0' width='100%'>
                    <tr>
                        <td width='10%' valign="top" align="right"><img src="<%= Param.getAplicacion()%>images/logos/logo_beneficio_new.jpg"  border='0'></td>
                        <td width='90%' valign="top" align="center" class="titulo"><strong>PRESENTACION DEBITO INTELIGENTE</strong></td>
                    </tr>
                </table>
            </td>
        </TR>
        <tr>
            <td align="left" valign="middle" width='100%'  height="45" >
                Sres. Banco Naci&oacute;n, por la presente solicito procesar el archivo presentado.
            </td>
        </tr>
        <tr>
            <td>
                <TABLE border='0' width='50%' align="left" cellpadding="4">
                    <tr>
                        <td width="20">&nbsp;</td>
                        <td align="left" width="80" class="textonegro12" nowrap>EMPRESA:</td>
                        <td align="left" class="textoazulbold12">BENEFICIO S.A.</td>
                    </tr>
                    <tr>
                        <td width="20">&nbsp;</td>
                        <td align="left" class="textonegro12" nowrap>CUIT:</td>
                        <td  align="left" class="textoazulbold12">30-68082752-0</td>
                    </tr>
                    <tr>
                        <td width="20">&nbsp;</td>
                        <td align="left" class="textonegro12" nowrap>CANTIDAD DE ALTAS:</td>
                        <td align="left" class="textoazulbold12"><%= sNuevas %></td>
                    </tr>
                    <tr>
                        <td width="20">&nbsp;</td>
                        <td align="left" class="textonegro12" nowrap>CANTIDAD DE MODIFICACIONES:</td>
                        <td align="left" class="textoazulbold12"><%= sModif %></td>
                    </tr>
                    <tr>
                        <td width="20">&nbsp;</td>
                        <td align="left" class="textonegro12" nowrap>FECHA TOPE DE RENDICION:</td>
                        <td align="left" class="textoazulbold12"><%= sFechaRendicion %></td>
                    </tr>
                    <tr>
                        <td width="20">&nbsp;</td>
                        <td align="left" class="textonegro12" nowrap>IMPORTE A DEBITAR:</td>
                        <td align="left" class="textoazulbold12"><%= importeTotal %></td>
                    </tr>
                </TABLE>
            </td>
        </tr>
    </TABLE>
</body>
</html>
