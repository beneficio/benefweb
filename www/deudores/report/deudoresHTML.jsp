<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.*"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%  Usuario oUser  = (Usuario) session.getAttribute("user");
    Usuario oProd  = (Usuario) request.getAttribute ("productor");
    Date fechaMov  = (Date)    request.getAttribute ("fechaMov");
    Date fechaPago = (Date)    request.getAttribute ("fechaPago");

    LinkedList lPagos      = (LinkedList) request.getAttribute("pagos");
    %>
<html>
    <head>
        <title>Deudores por Premio</title>
        <link rel="STYLESHEET" type="text/css" href="<%= Param.getAplicacion()%>css/reports.css">
    </head>
<body leftmargin=0 topmargin=0 style="width:720; margin-top: 0; margin-right: 0; margin-left: 0; margin-bottom: 0; padding-bottom: 0; padding-left: 0; padding-right: 0; padding-top: 0; top: 0; vertical-align: top;">
    <TABLE align="center" width='720' border='0' cellpadding='2' cellspacing='4' >
        <TR>
            <td width='100%' height='60'>
                <table border='0' cellpadding='2' cellspacing='0' width='100%'>
                    <tr>
                        <td valign="top" align="left" height='60'><img src="<%= Param.getAplicacion()%>images/logos/logo_beneficiosa.jpg" border='0'></td>
                        <td width='100%' align="middle">
                            <table align="center" width='100%' border='0' cellpadding='2' cellspacing='0'>
                                <tr>
                                    <td width='100%' valign="middle" align="Center" class="Titulos"><strong>Deudores por Premio</STRONG></td>
                                </tr>
<%                  if (oProd.getiCodProd () != 0) {
    %>
                                <tr>
                                    <td valign="middle" align="center" class="campo">Productor:&nbsp;<%= oProd.getsDesPersona() %>&nbsp;(<%= oProd.getiCodProd() %>)</td>
                                </tr>
<%                  } else {
    %>
                                <tr>
                                    <td valign="middle" align="center" class="campo">Cliente:&nbsp;<%= oProd.getsDesPersona() %>&nbsp;(<%= oProd.getiNumTomador () %>)</td>
                                </tr>
<%                  }
    %>
                                <tr>
                                    <td valign="middle" align="center" class="campo">F. de Análisis:&nbsp;<%= request.getParameter ("fecha") %></td>
                                </tr>
                            </table>
                        </td>

                    </tr>
                </table>
            </td>
        </tr>
        <tr>
           <td width='100%'><HR></td></tr>
        <TR>
            <td width='100%'>
                <table border='0' cellpadding='0' cellspacing='2' width='100%'>
                    <tr>
                        <td align="left" width='100%'>
                            <table width="100%" border="0" cellspacing="0" cellpadding="1">   
                                <tr>
                                    <td align="center" width='60'>P&oacute;liza</td>
                                    <td align="center" width='50'>Endoso</td>
                                    <td align="center" width='180'>Asegurado</td>
                                    <td align="center" width='110'>Vigencia</td>
                                    <td align="center" width='25'>Cuot.</td>
                                    <td align="center" width='65'>Fecha</td>
                                    <td align="center" width='120'>Movimiento</td>
                                    <td align="center" width='65'>Importe</td>
                                 </tr>

<%                      int iCodRamaAnt = -1;
                        int iNumPolAnt  = -1;
                        int iEndosoAnt  = -1;
                        double saldoAnt = 0;
                        double deudaAnt = 0;
                        double totalDeudaPol = 0;
                        String sVencida = "NO";

                        for (int i=0; i < lPagos.size (); i++) {
                            Pago oPago = (Pago) lPagos.get(i);
                            if (oPago.getcodRama() != iCodRamaAnt ||
                                oPago.getnumPoliza() != iNumPolAnt || 
                                oPago.getendoso()    != iEndosoAnt) {
                                if (iCodRamaAnt != -1) {
    %>
                               <tr>
                                    <td align="center" class='campo'>&nbsp;</td>
                                    <td align="right" class='campo'>&nbsp;</td>
<%                                  if (sVencida.equals ("SI")) {
    %>
                                    <td align="right" class='campo' height='15' valign="middle"><b>Vencida:&nbsp;<%= Dbl.DbltoStr(deudaAnt ,2)%></b></td>
                                    <td align="center" class='campo'>&nbsp;</td>
<%                                  } else {
    %>
                                    <td align="center" class='campo'>&nbsp;</td>
                                    <td align="right" class='campo' height='15' valign="middle"><b>Atraso:&nbsp;<%= Dbl.DbltoStr(deudaAnt ,2)%></b></td>
<%                                  }
    %>
                                    <td align="center" class='campo'>&nbsp;</td>
                                    <td align="center" class='campo'>&nbsp;</td>
                                    <td align="right" class='campo'><b>Saldo</b></td>
                                    <td align="right" class='campo' valign="middle"><b><%= Dbl.DbltoStr(saldoAnt ,2)  %></b></td>
                                </tr>
<%                              if (oPago.getendoso()  == 0) {
    %>
                                <tr>   
                                    <td colspan='2'>&nbsp;</td>
                                    <td align="left" class='campo'><b>TOTAL POLIZA:&nbsp;<%= Dbl.DbltoStr(totalDeudaPol ,2)  %></b></td>
                                    <td colspan='5'>&nbsp;</td>
                                </tr>
                                <tr>
                                    <td colspan='8' align="center">
---------------------------------------------------------------------------------------------------------------
                                    </td>
                                </tr>
<%                                  totalDeudaPol = 0;
                                    }
                               }
    %>
                                <tr>
                                    <td nowrap align="center" class='campo' valign="top"><%= oPago.getcodRama()%>&nbsp;<%= Formatos.showNumPoliza(oPago.getnumPoliza())%></td>
                                    <td nowrap align="right" class='campo' valign="top"><%= Formatos.showNumPoliza(oPago.getendoso ())%></td>
                                    <td align="left" class='campo' valign="top"><%= oPago.getasegurado()%></td>
                                    <td nowrap align="center" class='campo' valign="top"><%= (oPago.getFechaIniVig() == null ? "" : Fecha.showFechaForm(oPago.getFechaIniVig()))%>&nbsp;
                                    <%= (oPago.getFechaFinVig() == null ? "" : Fecha.showFechaForm(oPago.getFechaFinVig())) %></td>
                                    <td nowrap align="center" class='campo' valign="top"><%= oPago.getiNumCuota ()%></td>
                                    <td nowrap align="center" class='campo' valign="top"><%= (oPago.getFechaEmision() == null ? "" : Fecha.showFechaForm(oPago.getFechaEmision ()))%></td>
                                    <td nowrap align="left" class='campo' valign="top"><%= (oPago.getendoso () == 0 ? "Poliza" : "Endoso") %></td>
                                    <td nowrap align="right" class='campo' valign="top"><%= Dbl.DbltoStr(oPago.getimpTotalFact (),2)  %></td>
                                </tr>
<%                          if (oPago.getiImporte () != 0) {
    %>
                                <tr>
                                    <td align="center" class='campo' colspan='5' valign="top">&nbsp;</td>
                                    <td nowrap align="center" class='campo' valign="top"><%= (oPago.getFechaCobro () == null ? "" : Fecha.showFechaForm(oPago.getFechaCobro ()))%></td>
                                    <td nowrap align="left" class='campo' valign="top"><%= (oPago.getdescMovimiento () == null ? " " :  (oPago.getdescMovimiento ().length () < 6 ? oPago.getdescMovimiento () : oPago.getdescMovimiento ().substring(0, 5))) %>&nbsp;<%= (oPago.getcomprobante () == null ? " " : (oPago.getcomprobante ().equals ("0") ? " " : oPago.getcomprobante ())) %></td>
                                    <td nowrap align="right" class='campo' valign="top"><%= Dbl.DbltoStr(oPago.getiImporte (),2)  %></td>
                                </tr>
<%                           }
                                  iCodRamaAnt = oPago.getcodRama();
                                  iNumPolAnt  = oPago.getnumPoliza();
                                  iEndosoAnt  = oPago.getendoso();
                                  saldoAnt    = oPago.getimpSaldo ();
                                  deudaAnt    = oPago.getimpDeuda ();
                                  totalDeudaPol += oPago.getimpDeuda ();
                                  sVencida    = oPago.getsVencida ();
                              } else {
    %>
                                <tr>
                                    <td nowrap align="center" class='campo' colspan='5'>&nbsp;</td>
                                    <td nowrap align="center" class='campo'><%= (oPago.getFechaCobro () == null ? "" : Fecha.showFechaForm(oPago.getFechaCobro ()))%></td>
                                    <td nowrap align="left" class='campo'><%= (oPago.getdescMovimiento () == null ? " " :  (oPago.getdescMovimiento ().length () < 6 ? oPago.getdescMovimiento () : oPago.getdescMovimiento ().substring(0, 5))) %>&nbsp;<%=(oPago.getcomprobante () == null ? " " : (oPago.getcomprobante ().equals ("0") ? " " : oPago.getcomprobante ())) %></td>
                                    <td nowrap align="right" class='campo'><%= Dbl.DbltoStr(oPago.getiImporte (),2)  %></td>
                                </tr>
                <%                      }
                            }
                        if (iCodRamaAnt != -1) {
    %>
                               <tr>
                                    <td align="center" colspan='2'>&nbsp;</td>
<%                                  if (sVencida.equals ("SI")) {
    %>
                                    <td align="right" class='campo' height='15' valign="middle"><b>Vencida:&nbsp;<%= Dbl.DbltoStr(deudaAnt ,2)%></b></td>
                                    <td align="center" class='campo'>&nbsp;</td>
<%                                  } else {
    %>
                                    <td align="center" class='campo'>&nbsp;</td>
                                    <td align="right" class='campo' height='15' valign="middle"><b>Atraso:&nbsp;<%= Dbl.DbltoStr(deudaAnt ,2)%></b></td>
<%                                  }
    %>
                                    <td align="center" colspan='2'>&nbsp;</td>
                                    <td align="right" class='campo'><b>Saldo</b></td>
                                    <td align="right" class='campo' valign="middle"><b><%= Dbl.DbltoStr(saldoAnt ,2)  %></b></td>
                                </tr>
                                <tr>   
                                    <td colspan='2'>&nbsp;</td>
                                    <td align="left" class='campo'><b>TOTAL POLIZA:&nbsp;<%= Dbl.DbltoStr(totalDeudaPol ,2)  %></b></td>
                                    <td colspan='5'>&nbsp;</td>
                                </tr>

<%                             }
    %>
                            </table>

                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <TR>
            <td width='100%' height='20' valign="bottom" class='campoBold'>IMPORTANTE: La información de pólizas de éste sitio se encuentra actualizada al&nbsp;
                <%= (fechaMov == null ? "" : Fecha.showFechaForm (fechaMov))%>. La información referida a pagos al&nbsp;
                <%= (fechaPago == null ? "" : Fecha.showFechaForm (fechaPago))%>
            </td>
        </tr>
   </table>
</body>
</html>