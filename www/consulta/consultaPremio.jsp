<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Poliza"%>
<%@page import="com.business.beans.PersonaPoliza"%>
<%@page import="com.business.beans.UbicacionRiesgo"%>
<%@page import="com.business.beans.TextoPoliza"%>
<%@page import="com.business.beans.Asegurado"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<% Usuario usu = (Usuario) session.getAttribute("user"); 
   Poliza oPol = (Poliza) request.getAttribute("poliza");
   LinkedList lEndosos = (LinkedList) request.getAttribute("endosos");
    %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css">
<script type="" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script language='javascript'>
    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
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
        <td align="center">
            <form method="post" action="<%= Param.getAplicacion()%>servlet/ConsultaServlet" name='form1' id='form1'>
            <input type="hidden" name="opcion" id="opcion" value="getAllPremio">
            <input type="hidden" name="solapa" id="solapa" value="premio">
            <input type="hidden" name="F1num_poliza_sel" id="F1num_poliza_sel" value="<%= oPol.getnumPoliza ()%>">
            <input type="hidden" name="F1cod_rama_sel" id="F1cod_rama_sel" value="<%= oPol.getcodRama()%>">
<!-- JUSTTABS TOP OPEN -->
            <table cellpadding="0" cellspacing="0" border="0" ALIGN="CENTER" width="100%" bgcolor="#FFFFFF" style='margin-top:10;'>
                <tr height="1">
                    <td colspan="1" width="10">&nbsp;</td>
                    <td rowspan="2" width="517"><a href="pol1.htm"><img src="<%= Param.getAplicacion()%>images/solapas/poliza0_ia.GIF" width="73" height="25" hspace="0" vspace="0" border="0" alt="New ALT Text" description=""></a><a href="pol2.htm"><img src="<%= Param.getAplicacion()%>images/solapas/endosos1_a.GIF" width="80" height="25" hspace="0" vspace="0" border="0" alt="New ALT Text" description=""></a><a href="Sol5.htm"><img src="<%= Param.getAplicacion()%>images/solapas/premio4_ia.GIF" width="90" height="25" hspace="0" vspace="0" border="0" alt="New ALT Text" description=""></a><a href="pol3.htm"><img src="<%= Param.getAplicacion()%>images/solapas/cobranza2_ia.GIF" width="89" height="25" hspace="0" vspace="0" border="0" alt="New ALT Text" description=""></a><a href="pol4.htm"><img src="<%= Param.getAplicacion()%>images/solapas/siniestros3_ia.GIF" width="91" height="25" hspace="0" vspace="0" border="0" alt="New ALT Text" description=""></a><a href="Sol6.htm"><img src="<%= Param.getAplicacion()%>images/solapas/5_ia.GIF" width="94" height="25" hspace="0" vspace="0" border="0" alt="New ALT Text" description=""></a></td>
                    <td colspan="1" >&nbsp;</td>
                </tr>
                <tr height="1">
                    <td bgcolor="#009BE6" colspan="1" height="1"><img src=pixel.gif width="1" height="1"></td>
                    <td bgcolor="#009BE6" colspan="1" height="1"><img src=pixel.gif width="1" height="1"></td>
                </tr>
            </table>
            <table cellpadding="0" cellspacing="0" border="0" ALIGN="CENTER" width="100%" bgcolor="#FFFFFF">
                <tr >
                    <td  width="1" bgcolor="#009BE6"><img src=pixel.gif width="1" height="1"></td>
                    <td colspan=3 bgcolor="#F3F3F3">
                        <table border="0" cellpadding='2' cellspacing='2'>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td class='tituloSolapa'  width='60' align="left" valign="top">Rama:&nbsp;</td>
                                <td class='tituloSolapa' width='200' align="left" valign="top"><%= oPol.getdescRama() %></td>
                                <td class='tituloSolapa'>Poliza N°:&nbsp;</td>
                                <td class='tituloSolapa'><%= Formatos.showNumPoliza(oPol.getnumPoliza ()) %></td>
                            </tr>
<%
                            if (lEndosos.size() != 0) {
   %>
<%                              for (int i=0; i < lEndosos.size();i++) {
                                Poliza  oEnd = (Poliza) lEndosos.get(i);
    %>
                            <tr>
                                <td colspan="5" class='titulo'>Endoso N°&nbsp;<%= ( oEnd.getnumEndoso () == 0 ? "0 (Poliza) " : Formatos.showNumPoliza(oEnd.getnumEndoso ())) %></td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa'>Fecha Emisión:</td>
                                <td class='textSolapa'><%= Fecha.showFechaForm (oEnd.getfechaEmision ()) %></td>
                                <td class='tituloSolapa'>Vigencia:</td>
                                <td class='textSolapa'><%= Fecha.showFechaForm (oEnd.getfechaInicioVigencia ()) %>&nbsp;al&nbsp;<%= (oEnd.getfechaFinVigencia () == null ? "sin fin de vigencia" : Fecha.showFechaForm (oEnd.getfechaFinVigencia ())) %></td>
                            </tr>
<%                              LinkedList lAseg = oEnd.getAsegurados ();
                                if (lAseg.size () == 0) {
    %>
                            <tr>
                                <td>&nbsp;</td>
                                <td colspan="4" class='tituloSolapa'>El endoso no tiene nómina de asegurados asociada.</td>
                            </tr>
                                
<%                              } else {
    %>
                            <tr>
                                <td>&nbsp;</td>
                                <td colspan="4" class='tituloSolapa'>Nómina de Asegurados del Endoso</td>
                            </tr>

<%                              }
                                for (int j=0; j < lAseg.size();j++) {
                                    Asegurado oAseg  = (Asegurado) lAseg.get(j);
    %>
                            <tr>
                                <td>&nbsp;</td>
                                <td colspan='4'>
                                    <table border='0' align="center" width='95%' cellpadding='2' cellspacing='0'>

                                        <tr>
                                            <td width='200' align="left" class='textSolapa'><%= (oAseg.getendosoAlta () == oEnd.getnumEndoso() ? "Alta: " : "Baja: ")%>&nbsp;<%= oAseg.getnombre()%></td>
                                            <td width='80' align="right" class='textSolapa'><%= (oAseg.getdescTipoDoc () + " " + oAseg.getnumDoc ())%></td>
                                            <td width='90' align="left" class='textSolapa'><%= oAseg.getfechaAltaCob () %>&nbsp;(*)</td>
                                            <td width='95' align="left" class='textSolapa'><%= oAseg.getfechaBaja    () %>&nbsp;(**)</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
<%                                  }
                                }
                            }
    %>
                            <tr>
                                <td class='text' colspan='5'><b>NOTA:</b> la información de la póliza se encuentra actualizada al&nbsp;<%= Fecha.showFechaForm (oPol.getfechaFTP ()) %>.<br>
                                (*):  Fecha de alta de cobertura.
                                (**): Fecha de baja de cobertura. 
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td  width="1" bgcolor="#009BE6"><img src=pixel.gif width="1" height="1"></td>
                </tr>
                <tr bgcolor="#009BE6" height="1">
                    <td colspan=5><img src=pixel.gif width="1" height="1"></td>
                </tr>
            </table>
<!-- JUSTTABS BOTTOM CLOSE -->
            </form>
        </td>
    </tr>
    <tr>
        <td width='100%' valign="bottom">
            <jsp:include flush="true" page="/bottom.jsp"/>
        </td>
    </tr>
</table>
<script>
CloseEspere();
</script>
</body>
</html>
