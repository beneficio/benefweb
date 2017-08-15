<%@page contentType="text/html"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.*"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.LinkedList"%>
<%  Usuario oUser               = (Usuario) session.getAttribute("user");
    Certificado oCert           = (Certificado) request.getAttribute("certificado");
    PersonaCertificado oTomador = (PersonaCertificado) request.getAttribute("tomador");
    LinkedList lAsegurados      = (LinkedList) request.getAttribute("asegurados");
    LinkedList lCoberturas      = (LinkedList) request.getAttribute("coberturas");
//    LinkedList lTextoFijo       = (LinkedList) request.getAttribute("textoFijo");
    LinkedList lTextoVar        = (LinkedList) request.getAttribute("textoVar");
    %>
<html>
    <head>
        <title>Certificado de Cobertura</title>
        <link rel="STYLESHEET" type="text/css" href="<%= Param.getAplicacion()%>css/reports.css">
    </head>
<body leftmargin=0 topmargin=0 style="margin-top: 0; margin-right: 0; margin-left: 0; margin-bottom: 0; padding-bottom: 0; padding-left: 0; padding-right: 0; padding-top: 0; top: 0; vertical-align: top;">
    <TABLE align="center" width='700' border='1' cellpadding='0' cellspacing='6' >
        <TR>
            <td width='100%' height='60'>
                <table border='0' cellpadding='2' cellspacing='2' width='100%'>
                    <tr>
                        <td width='25%' valign="top" align="left"><img src="<%= Param.getAplicacion()%>images/logos/logo_beneficiosa.jpg" width='154'  height='34'  border='0'></td>
                        <td width='75%' valign="top" align="center" class="Titulos"><%= (oCert.gettipoCertificado().equals ("PR") ? "Certificado de cobertura" : "Constancia de movimientos de asegurados" )%></STRONG></td>
                    </tr>
                    <tr>
                        <td valign="middle" align="left" class='valor'><%= oCert.getdescRama() %></strong></td>
                        <td valign="middle" align="right" class='valor'>Nro. Certificado:&nbsp;<%= oCert.getnumCertificado()%></strong></td>
                    </tr>
                </table>
            </td>
        </tr>
        <TR>
            <td width='100%'>
                <table border='0' cellpadding='0' cellspacing='4' width='100%'>
                    <tr>
                        <td width='100%' valign="middle" align="left" class='valor' height='25'>PARA SER PRESENTADO ANTE:&nbsp;<%= (oCert.getpresentar () == null ? " " : oCert.getpresentar ())%></td>
                    </tr>
                    <tr>
                        <td width='100%' valign="middle" align="center" class='SubTitulos'>Datos del Asegurado y/o Tomador</td>
                    </tr>
                    <tr>
                        <td width='100%'>
                            <table border='0' cellspacing='0' cellpadding='2' width='100%'>
                                <tr>
                                    <td align="left" width='50' class='campo'>Tomador:</td>
                                    <td align="left" width='300' class='valor'><%= oTomador.getrazonSocial ()%></td>
                                    <td align="left" width='50' class='campo'>C.U.I.T.:</td>
                                    <td align="left" width='300' class='valor'><%= (oTomador.getnumDoc() == null ? " " : oTomador.getnumDoc())%></td>
                                </tr>
                                <tr>
                                    <td align="left" class='campo'>Domicilio:</td>
                                    <td align="left" colspan='3' class='valor'><%= (oTomador.getdomicilio () == null ? " " : oTomador.getdomicilio ())%></td>
                                </tr>
                                <tr>
                                    <td align="left" class='campo'>Localidad:</td>
                                    <td align="left" colspan='3' class='valor'><%= (oTomador.getlocalidad () == null ? " " : oTomador.getlocalidad ()) %>&nbsp;(<%= (oTomador.getcodPostal() == null ? " " : oTomador.getcodPostal())%>)&nbsp;<%= (oTomador.getprovincia () == null ? " " : oTomador.getprovincia ())%></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td width='100%' valign="middle" align="center" class='SubTitulos'>Datos generales del certificado</td>
                    </tr>
                    <tr>
                        <td width='100%'>
                            <table border='0' cellspacing='0' cellpadding='2' width='100%'>
                                <tr>
                                    <td align="left" width='50' nowrap class='campo'>Vigencia:</td>
                                    <td align="left" width='100%' class='valor'>&nbsp;<%= (oCert.getfechaInicioSuceso () == null ? " " : Fecha.showFechaForm(oCert.getfechaInicioSuceso ()))%>&nbsp;al&nbsp;<%= (oCert.getfechaFinSuceso () == null ? "" : Fecha.showFechaForm(oCert.getfechaFinSuceso ()))%></td>
                                </tr>
                                <tr>
                                    <td align="left" class='campo'>Cobertura:</td>
                                    <td align="left" class='valor'><%= oCert.getdescSubRama ()%></td>
                                </tr>
                                <tr>
                                    <td align="left" colspan='2' class='valor'>Rosario, <%= ( oCert.getfechaTrabajo () == null  ? Fecha.getFechaActual() : Fecha.showFechaForm(oCert.getfechaTrabajo ()))%>. 
    Validez del certificado&nbsp;<%= ( oCert.getcodProd() == 16381 ? "30" :  "15" ) %>&nbsp;d&iacute;as.</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td width='100%'>
                <table border='0' width='100%' cellpadding='2' cellspacing='4'>
                    <tr>
                        <td align="left" width='100%' class='campo'><STRONG>IMPORTANTE:&nbsp;</STRONG>La presente certificación no implica renuncia a 
oponer la suspensión o caducidad de la cobertura por falta de pago del premio correspondiente de acuerdo a las respectivas condiciones 
generales de póliza.-
                        </td>
                    </tr>
<%          if ( oCert.gettipoCertificado().equals ("PR") && lAsegurados != null && lAsegurados.size () == 1 && 
                 lCoberturas != null && lCoberturas.size () > 0) {
    %>
                    <tr>
                        <td align="center" width='100%' class='SubTitulos'>Sumas aseguradas por coberturas:</td>
                    </tr>
                    <tr>
                        <td align="left" width='100%'>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">                     
<%
                            for (int j=0; j < (lCoberturas == null ? 0 : lCoberturas.size ());j++) {
                                AsegCobertura oCob = (AsegCobertura) lCoberturas.get(j);
    %>
                                <tr>
                                    <td align="left"  class='campo'><%= oCob.getdescCob()%></td>
                                    <td align="left"  class='campo' colspan='2'><%= oCert.getsimboloMoneda()%>&nbsp;<%= Dbl.DbltoStr(oCob.getimpSumaRiesgo (),2)%></td>
                                </tr>
                <%          }
                    %>
                            </table>

                        </td>
                    </tr>
<%                  }
    %>
                    <tr>
                        <td align="center" width='100%' class='SubTitulos'>Asegurado/s:&nbsp;</td>
                    </tr>
                    <tr>
                        <td align="left" width='100%'>
                            <table width="100%" border="0" cellspacing="0" cellpadding="2">                     
<%                      String sEstadoAnt = "";
                        for (int i=0; i < lAsegurados.size (); i++) {
                            PersonaCertificado oAseg = (PersonaCertificado) lAsegurados.get(i);
                            if (oCert.gettipoPropuesta ().equals ("E") 
                                && oAseg.getestado().equals ("A") 
                                &&  ! oAseg.getestado().equals (sEstadoAnt) ) {
                                    sEstadoAnt = oAseg.getestado();
    %>
                                <tr>
                                    <td align="left"  colspan="3" class='subtitulo'>Asegurados dados de Alta</td>
                                </tr>
<%                          }
                            if (oCert.gettipoPropuesta ().equals ("E") 
                                && oAseg.getestado().equals ("B") 
                                &&  ! oAseg.getestado().equals (sEstadoAnt) ) {
                                    sEstadoAnt = oAseg.getestado();
    %>
                                <tr>
                                    <td align="left"  colspan="3" class='subtitulo'>Asegurados dados de Baja</td>
                                </tr>
<%                          }
    %>
                                <tr>
                                    <td align="left" width='375' class='campo'><%= oAseg.getrazonSocial()%></td>
                                    <td align="left" width='75' class='campo'>&nbsp;</td>
                                    <td align="left" width='300' class='campo'><%= oAseg.getdescTipoDoc ()%>&nbsp;&nbsp;&nbsp;<%= oAseg.getnumDoc ()%></td>
                                </tr>
<%                          if ( lAsegurados.size () > 1) {
                                LinkedList lCob = oAseg.getlCoberturas ();
                                for (int j=0; j < (lCob == null ? 0 : lCob.size ());j++) {
                                    AsegCobertura oCob = (AsegCobertura) lCob.get(j);
    %>
                                <tr>
                                    <td align="left"  class='campo'>&nbsp;&nbsp;<%= oCob.getdescCob()%></td>
                                    <td align="left"  class='campo' colspan='2'>$&nbsp;<%= Dbl.DbltoStr(oCob.getimpSumaRiesgo (),2)%></td>
                                </tr>
                <%              }
                            }
                        }
                    %>
                            </table>

                        </td>
                    </tr>
                    <tr>
                        <td width='100%'>
                            <table width='100%' border='0' cellpadding='1' cellspacing='0' style="margin-top:10;margin-top:20;">
                                <tr>
                                    <td width='100'>&nbsp;</td>
                                    <td width='500' align="left">
                                        <table width='100%' cellpadding='2' cellspacing='0' border='0'>
<%                            for (int j=0; j < (lTextoVar == null ? 0 : lTextoVar.size ());j++) {
                                TextoCertificado oTexto = (TextoCertificado) lTextoVar.get(j);
    %>
                                            <tr>
                                                <td align="left"  class='campo'><%= oTexto.gettexto()%></td>
                                            </tr>
                <%          }
                    %>
                                        </table>
                                    </td>
                                    <td width='100'>&nbsp;</td>
                                </tr>
                                <tr>
                                    <td  colspan='2' height='40'>&nbsp;</td>
                                    <td >&nbsp;</td>
                                </tr>
                                <tr>
                                    <td  colspan='2' height='100' valign="bottom" align="right"><img src='<%= Param.getAplicacion()%>images/firmaBenef.jpg' border='0'></td>
                                    <td width='100'>&nbsp;</td>
                                </tr>

                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
   </table>
</body>
</html>