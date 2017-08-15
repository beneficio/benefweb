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
    double impDeuda15 = 0;
    double impDeuda30 = 0; 
    double impDeuda60 = 0; 
    double impDeuda365 = 0; 
    double impTotalDeuda = 0;
    %>
<html>
    <head>
        <title>Deudores por Premio Consolidado</title>
        <link rel="STYLESHEET" type="text/css" href="<%= Param.getAplicacion()%>css/reports.css">
    </head>
<body leftmargin=0 topmargin=0 style="width:890; margin-top: 0; margin-right: 0; margin-left: 0; margin-bottom: 0; padding-bottom: 0; padding-left: 0; padding-right: 0; padding-top: 0; top: 0; vertical-align: top;">
    <TABLE align="center" width='820' border='0' cellpadding='0' cellspacing='2' >
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
                                    <td valign="middle" align="center" class="campo">Fecha de Análisis:&nbsp;<%= request.getParameter ("fecha") %></td>
                                </tr>
                            </table>
                        </td>

                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td width='100%'><HR></td>
        </tr>
        <TR>
            <td width='100%'>
                <table border='0' cellpadding='0' cellspacing='2' width='100%'>
                    <tr>
                        <td align="left" width='100%'>
                            <table width="100%" border="0" cellspacing="0" cellpadding="2">   
                                <tr>
                                    <td align="center" width='70'>P ó l i z a</td>
                                    <td align="center" width='140'>A s e g u r a d o</td>
                                    <td align="center" width='110'>Vigencia</td>
                                    <td align="center" width='75'>Ult.Pago</td>
                                    <td nowrap  align="center" width='75'>Pza.yAmp.</td>
                                    <td align="center" width='75'>Reducciones</td>
                                    <td align="center" width='75'>Pagos</td>
                                    <td align="center" width='75'>Saldo</td>
                                    <td align="center" width='75'>Deuda</td>
                                 </tr>

<%                      boolean bIsFirst   = true;
                        for (int i=0; i < lPagos.size (); i++) {
                            Pago oPago = (Pago) lPagos.get(i);
                            impDeuda15  += oPago.getimpDeuda15();
                            impDeuda30  += oPago.getimpDeuda30();
                            impDeuda60  += oPago.getimpDeuda60();
                            impDeuda365 += oPago.getimpDeuda365();
                            impTotalDeuda += oPago.getimpDeuda();
    %>
                                <tr>
                                    <td nowrap align="left" class='campo' valign="top"><%= oPago.getcodRama()%>&nbsp;<%= Formatos.showNumPoliza(oPago.getnumPoliza())%></td>
                                    <td align="left" class='campo' valign="top"><%= oPago.getasegurado()%></td>
                                    <td nowrap align="center" class='campo' valign="top"><%= (oPago.getFechaIniVig() == null ? "" : Fecha.showFechaForm(oPago.getFechaIniVig()))%>&nbsp;
                                    <%= (oPago.getFechaFinVig() == null ? "" : Fecha.showFechaForm(oPago.getFechaFinVig())) %></td>
                                    <td nowrap align="center" class='campo' valign="top"><%= (oPago.getFechaCobro () == null ? "" : Fecha.showFechaForm (oPago.getFechaCobro ()))%></td>
                                    <td nowrap align="right" class='campo' valign="top"><%= Dbl.DbltoStr(oPago.getimpTotalFact (),2)  %></td>
                                    <td nowrap align="right" class='campoBold' valign="top"><%= Dbl.DbltoStr(oPago.getimpTotalReduc(),2)  %></td>
                                    <td nowrap align="right" class='campoBold' valign="top"><%= Dbl.DbltoStr(oPago.getimpTotalPagos(),2)  %></td>
                                    <td nowrap align="right" class='campoBold' valign="top"><%= Dbl.DbltoStr(oPago.getimpSaldo () ,2)  %></td>
                                    <td nowrap align="right" class='campoBold' valign="top"><%= Dbl.DbltoStr(oPago.getimpDeuda () ,2)  %></td>
                                </tr>
<%                          }
    %>
                                <tr>
                                    <td nowrap align="left" class='campoBold' valign="top" colspan='8'>Total Prod. $</td>
                                    <td nowrap align="right" class='campoBold' valign="top"><%= Dbl.DbltoStr(impTotalDeuda  ,2)  %></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <TR>
            <td width='100%' height='20' valign="bottom" class='campoBold'>Composición del deudores por premio</td>
        </tr>
        <TR>
            <td>
                <table border='0' cellpadding='0' cellspacing='2' >
                    <tr>
                        <td align="left" nowrap class='campo'>Premios ATRASADOS:&nbsp;</td>
                        <td align="left" nowrap>&nbsp;</td>
                        <td align="left" class='campoBold'><%= Dbl.DbltoStr(impTotalDeuda,2) %></td>
                    </tr>
                    <tr>
                        <td align="left" nowrap class='campo'>Premios a Vencer&nbsp;</td>
                        <td align="left" nowrap class='campo'>1&nbsp;-&nbsp;15&nbsp;d&iacute;as:&nbsp;</td>
                        <td align="left" class='campoBold'><%= Dbl.DbltoStr(impDeuda15,2) %></td>
                    </tr>
                    <tr>
                        <td align="left" >&nbsp;</td>
                        <td align="left"  nowrap class='campo'>16&nbsp;-&nbsp;30&nbsp;d&iacute;as:&nbsp;</td>
                        <td align="left" class='campoBold'><%= Dbl.DbltoStr(impDeuda30,2) %></td>
                    </tr>
                    <tr>
                        <td align="left" >&nbsp;</td>
                        <td align="left" nowrap class='campo'>31&nbsp;-&nbsp;60&nbsp;d&iacute;as:&nbsp;</td>
                        <td align="left" class='campoBold'><%=  Dbl.DbltoStr(impDeuda60,2)  %></td>
                    </tr>
                    <tr>
                        <td align="left" >&nbsp;</td>
                        <td align="left" class='campo'>+ de 60 d&iacute;as:&nbsp;</td>
                        <td align="left" class='campoBold'><%=  Dbl.DbltoStr(impDeuda365,2)  %></td>
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