<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Poliza"%>
<%@page import="com.business.beans.Pago"%>
<%@page import="java.util.LinkedList"%>  
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<% Usuario usu = (Usuario) session.getAttribute("user"); 
   Poliza oPol = (Poliza) request.getAttribute("poliza");
   LinkedList lEndosos = (LinkedList) request.getAttribute("endosos");
   String sMoneda = oPol.getsSignoMoneda();

   String sVolver = (request.getParameter("volver") == null ? "filtrarPolizas" : request.getParameter("volver"));

    %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
</head>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<script type="" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script language='javascript'>
    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

    function Volver () {
        document.form1.opcion.value = 'getAllPol';
        if (document.getElementById('volver').value == "filtrarPolizas") {
            document.form1.action = "<%= Param.getAplicacion()%>servlet/ConsultaServlet";
        } else {
            document.form1.action = "<%= Param.getAplicacion()%>servlet/RenuevaServlet";
        }
        document.form1.submit();
    }

    function Continuar ( form1, siguiente) {

            form1.opcion.value = siguiente;
            form1.submit();
            return true;
    }
    function SolicitarCopia ( endoso, opcion ) {
        var sUrl = "<%= Param.getAplicacion()%>consulta/PopUpCopiaPoliza.jsp?F1num_poliza_sel=" +
            document.form1.F1num_poliza_sel.value + "&F1cod_rama_sel=" + document.form1.F1cod_rama_sel.value + 
            "&endoso=" + endoso + "&opcion=" + opcion ;
        var W = 400;
        var H = 240;

        AbrirPopUp (sUrl, W, H);
        return true;
    }

    function Submitir (param) {
        if (param.opcion.value == 'cupon') {
            document.form1.opcion.value = "getCupon";
        } else {
            document.form1.opcion.value = "getCopia";
        }
        document.form1.endoso.value  = param.endoso.value;
        document.form1.email.value  = param.email.value;
        document.form1.submit();
        return true;
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
        <td align="center">
            <form method="post" action="<%= Param.getAplicacion()%>servlet/ConsultaServlet" name='form1' id='form1'>
            <input type="hidden" name="opcion" id="opcion" value="getAllCob"/>
            <input type="hidden" name="solapa" id="solapa" value="cobranza"/>
            <input type="hidden" name="F1num_poliza_sel" id="F1num_poliza_sel" value="<%= oPol.getnumPoliza ()%>"/>
            <input type="hidden" name="F1cod_rama_sel" id="F1cod_rama_sel" value="<%= oPol.getcodRama()%>"/>
            <input type="hidden" name="endoso" id="endoso" value="0"/>
            <input type="hidden" name="email" id="email" value=""/>
            <input type="hidden" name="volver" id="volver"  value="<%= sVolver %>"/>
            <!-- JUSTTABS TOP OPEN -->
            <table cellpadding="0" cellspacing="0" border="0" ALIGN="CENTER" width="100%" bgcolor="#FFFFFF" style='margin-top:10;'>
                <tr height="1">
                    <td colspan="1" width="10">&nbsp;</td>
                    <td rowspan="2" width="347"><a href="#" onclick="Continuar ( document.form1, 'getPol');"><img src="<%= Param.getAplicacion()%>images/solapas/poliza0_ia.GIF" width="82" height="25" hspace="0" vspace="0" border="0" alt="Consulta de póliza"></a><a href="#" onclick="Continuar ( document.form1, 'getAllEnd');"><img src="<%= Param.getAplicacion()%>images/solapas/endosos1_ia.GIF" width="83" height="25" hspace="0" vspace="0" border="0" alt="Consulta de endosos"></a><a href="#" onclick="Continuar ( document.form1, 'getAllCob');"><img src="<%= Param.getAplicacion()%>images/solapas/cobranza2_a.GIF" width="89" height="25" hspace="0" vspace="0" border="0" alt="consulta de Cobranza" description=""></a><a href="#" onclick="Continuar ( document.form1, 'getAllSegui');"><img src="<%= Param.getAplicacion()%>images/solapas/seguimiento1_ia.GIF" width="93" height="25" hspace="0" vspace="0" border="0" alt="Seguimiento de propuesta" description=""></a></td>
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
                                <td class='tituloSolapa'  width='10' align="left" valign="top">Rama:&nbsp;</td>
                                <td class='tituloSolapa' width='200' align="left" valign="top"><%= oPol.getdescRama() %></td>
                                <td class='tituloSolapa' align="left">Poliza N°:&nbsp;</td>
                                <td class='tituloSolapa' align="left"><%= Formatos.showNumPoliza(oPol.getnumPoliza ()) %></td>
                            </tr>
<%                  if (oPol.getcodRama() != 9 ) {
    %>
                            <tr>
                                <td colspan="5" class='titulo'>Cuponera de póliza</td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td class='tituloSolapa' colspan='4'><img src="<%= Param.getAplicacion()%>images/enviar.gif" border="0">&nbsp;Solicite desde <a href="#" onclick="SolicitarCopia('0', 'cupon');" class="link1">aqu&iacute;</a> la cuponera actualizada de póliza vía mail.
                                </td>
                            </tr>
<%                  }
                            if (lEndosos.size() != 0) {
   %>
<%                              for (int i=0; i < lEndosos.size();i++) {
                                Poliza  oEnd = (Poliza) lEndosos.get(i);
                                    if (oEnd.getnumEndoso() != 999999 ) {
    %>
                            <tr>
                                <td colspan="5" class='titulo' align="left"><img src="<%= Param.getAplicacion()%>images/nuevoS.gif" border="0">&nbsp;Endoso N°&nbsp;<%= ( oEnd.getnumEndoso () == 0 ? "0 (Poliza) " : Formatos.showNumPoliza(oEnd.getnumEndoso ())) %></td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa' align="left" nowrap>Total Facturado:</td>
                                <td class='textSolapa' colspan='3' align="left"><%= sMoneda %>&nbsp;<%= Dbl.DbltoStr(oEnd.getimpTotalFacturado(),2) %></td>
                            </tr>
<%                      if (oEnd.getimpTotalFacturado() != 0) {
    %>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa' align="left" nowrap>Saldo del endoso:</td>
                                <td class='textSolapa' colspan='3' align="left" ><%= sMoneda %>&nbsp;<%= Dbl.DbltoStr(oEnd.getimpSaldoPoliza(),2) %></td>
                            </tr>
<%                              LinkedList lCob = oEnd.getCobranza ();
                                if (lCob.size () == 0) {
    %>
                            <tr>
                                <td>&nbsp;</td>
                                <td colspan="4" class='tituloSolapa'>No existe información referida a pagos ni reducciones del endoso.</td>
                            </tr>
                                
<%                              } else {
    %>
                            <tr>
                                <td>&nbsp;</td>
                                <td colspan="4" class='tituloSolapa'>Detalle de Pagos y Reducciones</td>
                            </tr>
                           <tr>
                                <td>&nbsp;</td>
                                <td colspan='4' align="center">
                                    <table border='1' align="center" width='100%' cellpadding='0' cellspacing='0' class="TablasBody">
                                        <tr>
                                            <th width='70' class='textSolapa' align="center"><b>Fecha</b></th>
                                            <th width='160' class='textSolapa' align="center"><b>Movimiento</b></th>
                                            <th width='90' class='textSolapa' align="center"><b>Comprobante</b></th>
                                            <th width='95' class='textSolapa' align="center"><b>Importe ($)</b></th>
                                        </tr>
<%                              double iTotal = 0;
                                for (int j=0; j < lCob.size();j++) {
                                    Pago oPago  = (Pago) lCob.get(j);
                                    iTotal = iTotal + oPago.getiImporte ();
    %>
                                        <tr>
                                            <td width='70' align="center" class='textSolapa'><%= (oPago.getFechaCobro() == null ? " " : Fecha.showFechaForm(oPago.getFechaCobro())) %></td>
                                            <td width='160' align="left" class='textSolapa'><%= oPago.getdescMovimiento() %></td>
<%                                  if (oPago.getcodMovimiento() == 12 ) {
    %>
                                            <td width='90' align="left" class='textSolapa'><a href="#" onclick="SolicitarCopia ('<%= oPago.getcomprobante () %>','copia');" class="link1"><%= oPago.getcomprobante () %>&nbsp;&nbsp;<img src="<%= Param.getAplicacion()%>images/enviar.gif" border="0" alt='Haga click aqui o en el comprobante para obtener una copia via mail de la Nota de Crédito'></a></td>
<%                                  } else {
    %>
                                            <td width='90' align="left" class='textSolapa'><%= oPago.getcomprobante () %></td>
<%                                  }
    %>
                                            <td width='95' align="center" class='textSolapa' style="color:<%= (oPago.getiImporte () > 0 ? "green" : "red")%>"><%= oPago.getiImporte () %></td>
                                        </tr>
<%                              }
    %>
                                        <tr>
                                            <td colspan="2">&nbsp;</td>
                                            <td class='textSolapa' align="right"><b>Total&nbsp;&nbsp;</b></td>
                                            <td class='textSolapa' align="center"style="color:<%= (iTotal > 0 ? "green" : "red")%>"><b><%= Dbl.DbltoStr(iTotal,2) %></b></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
<%                                }
                                }
                                }
                               }
                            }
    %>
<%--                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td colspan="4" class='textSolapa' height='20' valign="middle"><spam class='titulo'>Referencia:</spam><b>&nbsp;Haga clik en la imagen <img src="<%= Param.getAplicacion()%>images/enviar.gif" border="0">&nbsp;para solicitar una copia de la Nota de Cr&eacute;dito v&iacute;a mail.</b></td>
                            </tr>
--%>
                            <tr>
                                <td class='text' colspan='5'><b>NOTA:</b> la información de la póliza se encuentra actualizada al&nbsp;<%= Fecha.showFechaForm (oPol.getfechaFTP ()) %>.
                                </td>
                            </tr>
                            <TR>
                                <TD align="center"  colspan='5'>
                                <%--<input type="button" name="cmdSalir"  value="  Salir  "  height="20px" class="boton" onClick="Salir ();">&nbsp;&nbsp;&nbsp;&nbsp;
                                --%>
                                <input type="button" name="cmdGrabar"
                                       value='<%= (sVolver.equals ("filtrarPolizas") ? "Volver a la consulta de P&oacute;liza":"Volver al filtro de renovaciones")%>'  height="20px" class="boton" onClick="Volver ();">
                                </TD>
                            </TR>
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
