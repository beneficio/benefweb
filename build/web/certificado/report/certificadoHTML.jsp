<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.*"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.LinkedList"%>
<%  Usuario oUser               = (Usuario) session.getAttribute("user");
    Certificado oCert           = (Certificado) request.getAttribute("certificado");
    PersonaCertificado oTomador = (PersonaCertificado) request.getAttribute("tomador");
    LinkedList lAsegurados      = (LinkedList) request.getAttribute("asegurados");
    LinkedList lCoberturas      = (LinkedList) request.getAttribute("coberturas");
    LinkedList lCla             = (LinkedList) request.getAttribute("clausulas");
    LinkedList lTextoVar        = (LinkedList) request.getAttribute("textoVar");
    %>
<html>
    <head>
        <title>Certificado de Cobertura</title>
        <link rel="STYLESHEET" type="text/css" href="<%= Param.getAplicacion()%>css/reports.css">
    </head>
<body leftmargin=0 topmargin=0 style="margin-top: 0; margin-right: 0; margin-left: 0; margin-bottom: 0; padding-bottom: 0; padding-left: 0; padding-right: 0; padding-top: 0; top: 0; vertical-align: top;">
    <table align="center" width='700' border='1' cellpadding='0' cellspacing='6' >
        <tr>
            <td width='100%' height='60'>
                <table border='0' cellpadding='2' cellspacing='0' width='100%'>
                    <tr>
                        <td width='25%' valign="top" align="left"><img src="<%= Param.getAplicacion()%>images/logos/logo_beneficiosa.jpg" width='154'  height='34'  border='0'></td>
                        <td width='75%' valign="top" align="center" class="Titulos"><strong>CERTIFICADO DE COBERTURA</strong></td>
                    </tr>
                    <tr>
                        <td  valign="middle" align="left" class='valor'><strong><%= oCert.getdescRama() %></strong></td>
                        <td  valign="middle" align="right" class='valor'><strong>P&oacute;liza:<%= Formatos.showNumPoliza(oCert.getnumPoliza()) %></strong></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td width='100%'>
                <table border='0' cellpadding='0' cellspacing='4' width='100%'>
                    <tr>
                        <td width='100%' valign="middle" align="left" class='valor' height='25'>PARA SER PRESENTADO ANTE:&nbsp;<%= (oCert.getpresentar () == null ? "" : oCert.getpresentar ())%></td>
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
                                    <td align="left" width='300' class='valor'><%= (oTomador.getcuit () == null ? " " : oTomador.getcuit ())%></td>
                                </tr>
                                <tr>
                                    <td align="left" class='campo'>Domicilio:</td>
                                    <td align="left" colspan='3' class='valor'><%= (oTomador.getdomicilio () == null ? " " : oTomador.getdomicilio ())%></td>
                                </tr>
                                <tr>
                                    <td align="left" class='campo'>Localidad:</td>
                                    <td align="left" colspan='3' class='valor'><%= (oTomador.getlocalidad () == null ? " " : oTomador.getlocalidad ()) %>&nbsp;
                                        (<%= (oTomador.getcodPostal() == null ? " " : oTomador.getcodPostal())%>)&nbsp;
                                        <%= (oTomador.getprovincia () == null ? " " : oTomador.getprovincia ())%></td>
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
                                    <td align="left" width='100%' class='valor'>hasta el&nbsp;<%= (oCert.getfechaFinSuceso () == null ? "" : Fecha.showFechaForm(oCert.getfechaFinSuceso ()))%></td>
                                </tr>
                                <tr>
                                    <td align="left" class='campo'>Cobertura:</td>
                                    <td align="left" class='valor'><%= oCert.getdescSubRama ()%></td>
                                </tr>
                                <tr>
                                    <td align="left" colspan='2' class='valor'>Rosario, <%= ( oCert.getfechaTrabajo () == null  ? Fecha.getFechaActual() : Fecha.showFechaForm(oCert.getfechaTrabajo ()))%>.</td>
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
generales de póliza.
                        </td>
                    </tr>
<%          if (lAsegurados != null && lAsegurados.size () == 1 && 
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
<%                      for (int i=0; i < lAsegurados.size (); i++) {
                            PersonaCertificado oAseg = (PersonaCertificado) lAsegurados.get(i);
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
<%            if (oCert.getclaNoRepeticion().equals("S") || oCert.getclaSubrogacion().equals("S")) {
    %>
                    <tr>
                        <td align="center" width='100%' class='SubTitulos'>Clausulas:&nbsp;</td>
                    </tr>
  
                    <tr>
                        <td align="left" width='100%' class='valor'><%= (oCert.getclaNoRepeticion().equals ("N") ? " " : "NO REPETICION") %>&nbsp;-&nbsp;
                                                                      <%= (oCert.getclaSubrogacion().equals ("N") ? " " : "SUBROGACION") %></td>
                    </tr>
                    <tr>
                        <td align="left" width='100%' class='valor'>Empresas beneficiarias:</td>
                    </tr>
                    <tr>
                        <td align="left" width='100%'>
                            <table width="100%" border="0" cellspacing="0" cellpadding="2">                     
<%                      for (int i=0; i < lCla.size (); i++) {
                            Clausula oCla = (Clausula) lCla.get(i);
    %>

                                <tr>
                                    <td align="left"  class='campo'>&nbsp;&nbsp;<%= oCla.getdescEmpresa() + ( oCla.getcuitEmpresa() == null || oCla.getcuitEmpresa().equals ("") ? " " :  ( " - Cuit " + oCla.getcuitEmpresa() ))  %></td>
                                </tr>
<%                            }
                    %>
                            </table>

                        </td>
                    </tr>
<%              }
    %>
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
                                                <td align="left"  class='campo'><%= (oTexto.gettexto() == null ? "" : oTexto.gettexto())%></td>
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
<%              if (oCert.getcodRama() == 21 ) {
    %>
                    <tr>
                        <td width='100%' class='campo'>
                            El presente certificado carece de validez si el personal informado en el mismo no se encuentra
                            declarado en la &uacute;ltima n&oacute;mina presentada en el S.U.S.S (sistema &uacute;nico de la seguridad
                            social) o no posee alta temprana.

                        </td>
                    </tr>
<%          }
    %>
                </table>
            </td>
        </tr>
   </table>
</body>
</html>