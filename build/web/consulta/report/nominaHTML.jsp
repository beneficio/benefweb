<%@page contentType="text/html"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.*"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%  Poliza oPol            = (Poliza) request.getAttribute("poliza");
    LinkedList lAsegurados = (LinkedList) request.getAttribute("asegurados");
    Date dFechaFTP         = oPol.getfechaFTP();
    %>
<html>
    <head>
        <title>Nomina actualizada de persona</title>
        <link rel="STYLESHEET" type="text/css" href="<%= Param.getAplicacion()%>css/reports.css">
    </head>
<body leftmargin=0 topmargin=0 style="margin-top: 0; margin-right: 0; margin-left: 0; margin-bottom: 0; padding-bottom: 0; padding-left: 0; padding-right: 0; padding-top: 0; top: 0; vertical-align: top;">
    <TABLE align="center" width='700' border='0' cellpadding='2' cellspacing='0' >
        <TR>
            <td width='100%' height='60'>
                <table border='0' cellpadding='2' cellspacing='0' width='100%'>
                    <tr>
                        <td width='20%' valign="top" align="left"><img src="<%= Param.getAplicacion()%>images/logos/logo_beneficio_new.jpg"  border='0'></td>
                        <td width='80%' valign="top" align="center" class="Titulos">Nomina actualizada de Asegurados</STRONG></td>
                    </tr>    
                </table>
            </td>
        </tr>
        <tr>
            <td width='100%' height='10'><th></td>
        </tr>
        <tr> 
            <td align="center" width='100%'>
                <table align="center"  border='0' cellpadding='2' cellspacing='0' width='100%'>
                    <tr>
                        <td width='20%' valign="middle" align="left" class='SubTitulos2'>P&oacute;liza:<strong><%= Formatos.showNumPoliza(oPol.getnumPoliza()) %></strong></td>
                        <td  width='40%' valign="middle" align="center" class='SubTitulos2'><strong><%= oPol.getdescRama() %></strong></td>
                        <td width='40%' valign="middle" align="right" class='SubTitulos2'>Cobertura:&nbsp;<strong><%= oPol.getdescSubRama() %></strong></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td width='100%'>
                <table border='0' width='100%' cellpadding='2' cellspacing='0'>
                    <tr>
                        <td align="left"  width='100%'>
                            <table border="0" cellspacing="0" cellpadding="2">
                                <tr>
                                    <td align="left" width='240' class='SubTitulos'>Asegurado</td>
                                    <td align="left" width='100' class='SubTitulos'>Documento</td>
                                    <td align="left" width='100' class='SubTitulos'>Nacimiento</td>
                                    <td align="left" width='80' class='SubTitulos'>Fecha alta</td>
                                    <td align="left" width='80' class='SubTitulos'>End. alta</td>
                                </tr>
<%                      if (lAsegurados.size () == 0) {
    %>
                                <tr><td align="left"  height='20' class='campo' colspan='5'>La póliza no tiene asegurados con cobertura</td></tr>
<%                      }
                        for (int i=0; i < lAsegurados.size (); i++) {
                            Asegurado oAseg = (Asegurado) lAsegurados.get(i);
                            StringBuilder oNom = new StringBuilder();
                            oNom.append(oAseg.getcertificado()).append(".").append(oAseg.getsubCertificado()).append(" - ").append(oAseg.getnombre());

                            dFechaFTP = oAseg.getfechaFTP();
    %>
                                <tr>
                                    <td align="left"  class='campo'><%= oNom.toString() %></td>
                                    <td align="left"  class='campo'><%= oAseg.getdescTipoDoc ()%>&nbsp;&nbsp;&nbsp;<%= oAseg.getnumDoc ()%></td>
                                    <td align="center"  class='campo'><%= oAseg.getdFechaNac() == null ? " " : Fecha.showFechaForm(oAseg.getdFechaNac()) %></td>
                                    <td align="center"  class='campo'><%= oAseg.getfechaAltaCob () == null ? " " : Fecha.showFechaForm(oAseg.getfechaAltaCob ()) %></td>
                                    <td align="right"  class='campo'><%= oAseg.getendosoAlta ()%></td>
                                </tr>
                <%      }
                    %>
                            </table>

                        </td>
                    </tr>
                    <tr>
                        <td align="left" valign="bottom" width='100%' height='60' class="campo" >
                        <b>Nota:</b> La información de este sitio se encuentra actualizada al&nbsp;<%= (dFechaFTP == null ? "no informado" : Fecha.showFechaForm(dFechaFTP))%> 
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
   </table>
</body>
</html>
