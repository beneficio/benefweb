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
<%@page import="com.business.beans.AsegCobertura"%>
<%@page import="com.business.beans.NoGestionar"%>
<%@page import="java.util.LinkedList"%>  
<%@page import="com.business.beans.Cuota"%>
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
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
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
    function SolicitarCopia ( endoso ) {
     //   if (document.form1.estado.value == "FINALIZADA" || document.form1.estado.value == "ANULADA") {
     //       alert ( " Operaci�n disponible solo para p�lizas vigentes ");
     //       return false;
     //   } else {

            var sUrl = "<%= Param.getAplicacion()%>consulta/PopUpCopiaPoliza.jsp?F1num_poliza_sel=" +
                document.form1.F1num_poliza_sel.value + "&F1cod_rama_sel=" + document.form1.F1cod_rama_sel.value + 
                "&endoso=" + endoso ;
            var W = 400;
            var H = 240;

            AbrirPopUp (sUrl, W, H);
            return true;
     //  }
    }
    
    function VisualizarAseguradoAfip ( endoso ) {
        /*
        if (document.form2.estado.value == "FINALIZADA" || document.form2.estado.value == "ANULADA") {
            alert ( " Consulta disponible solo para p�lizas vigentes ");
            return false;
        } else { 
            if (tipo != "EXCEL") {
                document.form2.action = "<%= Param.getAplicacion()%>consulta/printNomina.jsp";
            }*/
            document.form2.action = "<%= Param.getAplicacion()%>consulta/printNominaAfip.jsp";
            document.form2.opcion.value = "getNomina";
            document.form2.formato.value = "HTML";           
            document.form2.endosoAfip.value = endoso;
            document.form2.submit();
            return true;
        /*}*/
    }

    function Submitir (param) {
        document.form1.opcion.value = "getCopia";
        document.form1.endoso.value  = param.endoso.value;
        document.form1.email.value  = param.email.value;
        document.form1.submit();
        return true;
    }
    function SolicitarCertificado (tipo , num, item ) {
 
        var nombre = prompt('Ingrese ante quien ser� presentado el certificado', '');

        document.form2.tipo_doc.value = tipo;
        document.form2.num_doc.value  = num;
        document.form2.item.value  = item;
        document.form2.presentar.value = nombre;
        document.form2.submit();
        return true;
    }

    function EliminarNoGestionar ( endoso ) {
            document.form1.opcion.value = "DelNoGestionar";
            document.form1.endoso.value = endoso;
            document.form1.submit();
            return true;
    }

    function NoGestionar ( endoso ) {
            document.form1.opcion.value = "AddNoGestionar";
            document.form1.endoso.value = endoso;
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
<FORM name="form2" id="form2" method="post" action="<%= Param.getAplicacion()%>servlet/CertificadoServlet">
    <input type="hidden" name="num_poliza" id="num_poliza" value="<%= oPol.getnumPoliza ()%>"/>
    <input type="hidden" name="cod_rama" id="cod_rama"     value="<%= oPol.getcodRama()%>"/>
    <input type="hidden" name='modo_visual' value="1"/>
    <input type="hidden" name='tipo_doc'/>
    <input type="hidden" name='num_doc'/>
    <input type="hidden" name='item'/>
    <input type="hidden" name="opcion" value="addCertAseg"/>
    <input type="hidden" name="numCertificado" value="0"/>
    <input type="hidden" name='estado' value="0"/>
    <input type="hidden" name='presentar' value=""/>
    <input type="hidden" name='formato' id='formato' value="HTML"/>
    <input type="hidden" name='endosoAfip' id='endosoAfip' value="0"/>
</FORM>
            <form method="post" action="<%= Param.getAplicacion()%>servlet/ConsultaServlet" name='form1' id='form1'>
            <input type="hidden" name="opcion" id="opcion" value="getNomina"/>
            <input type="hidden" name="solapa" id="solapa" value="endosos"/>
            <input type="hidden" name="F1num_poliza_sel" id="F1num_poliza_sel" value="<%= oPol.getnumPoliza ()%>"/>
            <input type="hidden" name="F1cod_rama_sel" id="F1cod_rama_sel" value="<%= oPol.getcodRama()%>"/>
            <input type="hidden" name="endoso" id="endoso" value="0"/>
            <input type="hidden" name="email" id="email" value=""/>
            <input type="hidden" name="estado" id="estado" value="<%= oPol.getestado() %>"/>
            <input type="hidden" name="volver" id="volver"  value="<%= sVolver %>"/>
            <input type="hidden" name="nivel_exclusion" value="2"/>
            <!-- JUSTTABS TOP OPEN -->
            <table cellpadding="0" cellspacing="0" border="0" ALIGN="CENTER" width="100%" bgcolor="#FFFFFF" style='margin-top:10;'>
                <tr height="1">
                    <td colspan="1" width="10">&nbsp;</td>
                    <td rowspan="2" width="347"><a href="#" onclick="Continuar ( document.form1, 'getPol');"><img src="<%= Param.getAplicacion()%>images/solapas/poliza0_ia.GIF" width="82" height="25" hspace="0" vspace="0" border="0" alt="Consulta de p�liza"></a><a href="#" onclick="Continuar ( document.form1, 'getAllEnd');"><img src="<%= Param.getAplicacion()%>images/solapas/endosos1_a.GIF" width="83" height="25" hspace="0" vspace="0" border="0" alt="Consulta de endosos"></a><a href="#" onclick="Continuar ( document.form1, 'getAllCob');"><img src="<%= Param.getAplicacion()%>images/solapas/cobranza2_ia.GIF" width="89" height="25" hspace="0" vspace="0" border="0" alt="consulta de Cobranza" description=""></a><a href="#" onclick="Continuar ( document.form1, 'getAllSegui');"><img src="<%= Param.getAplicacion()%>images/solapas/seguimiento1_ia.GIF" width="93" height="25" hspace="0" vspace="0" border="0" alt="Seguimiento de propuestas" description=""/></a></td>
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
                        <table border="0" cellpadding='1' cellspacing='1'>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td class='tituloSolapa'  width='100' align="left" valign="top">Rama:&nbsp;</td>
                                <td class='tituloSolapa' width='200' align="left" valign="top"><%= oPol.getdescRama() %></td>
                                <td class='tituloSolapa'>Poliza N�:&nbsp;</td>
                                <td class='tituloSolapa'><%= Formatos.showNumPoliza(oPol.getnumPoliza ()) %></td>
                            </tr>
<%
                            if (lEndosos.size() != 0) {
   %>
<%                              for (int i=0; i < lEndosos.size();i++) {
                                Poliza  oEnd = (Poliza) lEndosos.get(i);
    %>
                            <tr>
                                <td colspan="5" class='titulo'><img src="<%= Param.getAplicacion()%>images/nuevoE.gif" border="0">&nbsp;Endoso N�&nbsp;<%= (oEnd.getnumEndoso () == 999999 ? "PENDIENTE DE FACTURACION" : ( String.valueOf(oEnd.getnumEndoso ()) + " - " + oEnd.getsDescTipoEndoso() )) %></td>
                            </tr>
<%                        if (oEnd.getcantVidas() > 0 && oEnd.getcodRama() == 21 ) {
        %>
                            <tr><td>&nbsp;</td></tr>
                            <tr>
                               <td>&nbsp;</td>
                                <td colspan="4"><img src="<%= Param.getAplicacion()%>images/productores.gif" width="14" height="19" border="0">&nbsp;La n&oacute;mina declarada en la AFIP tiene <%=oEnd.getcantVidas()%> asegurados. Por favor ingrese desde  <a href="#" onclick="VisualizarAseguradoAfip ( '<%= oEnd.getnumEndoso()%>' ) ;" class="link1">aqu&iacute;</a> para verificar las diferencias.<br/>
                                </td>
                            </tr>
                            <tr><td>&nbsp;</td></tr>
<%
                            }
    %>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa'  align="left" nowrap>Propuesta N�:&nbsp;</td>
                                <td class='tituloSolapa' colspan='3' align="left"><%= (oEnd.getboca () == null ? "no informado" :  ( oEnd.getboca () + " - " + oEnd.getnumPropuesta () )) %></td>
                            </tr>
<%                            if (oEnd.getnumEndoso () != 999999) {
    %>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa' align="left">Fecha Emisi�n:</td>
                                <td class='textSolapa' align="left"><%= Fecha.showFechaForm (oEnd.getfechaEmision ()) %></td>
                                <td class='tituloSolapa' align="left">Vigencia:</td>
                                <td class='textSolapa' align="left"><%= Fecha.showFechaForm (oEnd.getfechaInicioVigencia ()) %>&nbsp;al&nbsp;<%= (oEnd.getfechaFinVigencia () == null ? "sin fin de vigencia" : Fecha.showFechaForm (oEnd.getfechaFinVigencia ())) %></td>
                            </tr>
<%                          if ( usu.getiCodTipoUsuario() == 0 ) {
                                if (oEnd.getoNoGestionar() != null) {
                                    NoGestionar oNoGes = oEnd.getoNoGestionar();
%>
                            <tr>
                                <td>&nbsp;</td>
                                <td colspan="4" class="subtitulo" height="30" valign="middle" >
                                    <img  alt="No gestionar" src="/benef/images/ok.gif"  border="0"  hspace="0" vspace="0" align="bottom"/>&nbsp;
                                    No gestionar hasta&nbsp;<%= (oNoGes.getfechaHasta() == null ? "indefinido" : Fecha.showFechaForm(oNoGes.getfechaHasta())) %>&nbsp;&nbsp;
                                    <a href="#"  onclick="javascript:EliminarNoGestionar (<%= oEnd.getnumEndoso() %>);" >
                                        <img onClick="javascript:EliminarNoGestionar (<%= oEnd.getnumEndoso() %>);"  alt="Eliminar no gestionar" src="/benef/images/nook.gif"  border="0"  hspace="0" vspace="0"
                                             align="bottom" style="cursor: hand;"/>&nbsp;Eliminar</a>
                                    &nbsp;&nbsp;Usuario:&nbsp;<%= oNoGes.getuserId() %>&nbsp;&nbsp;Fecha:&nbsp;<%= Fecha.showFechaForm(oNoGes.getfechaTrabajo()) %>
                                </td>
                            </tr>
<%                                  } else {
%>
                            <tr>
                                <td>&nbsp;</td>
                                <td class="subtitulo" nowrap colspan="2" >NO GESTIONAR EL ENDOSO HASTA&nbsp;
                                    <input name="fecha_hasta" id="fecha_hasta" size="10" onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value=""/>&nbsp;(dd/mm/yyyy)
                                </td>
                                <td colspan="2">
                                    <input type="button" name="cmdNoGestionar"  value=" ENVIAR " height="20px" class="boton"
                                           onClick="javascript:NoGestionar (<%= oEnd.getnumEndoso() %>);"/>
                                </td>

                            </tr>

<%
                                    }
                                }
%>

                            <tr>
                                <td colspan="5" class='tituloSolapa'>Datos del Premio</td>
                            </tr>
<%--                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa'>SUMA ASEGURADA:</td>
                                <td class='textSolapa' colspan="3"><%= sMoneda %>&nbsp;<%= oPol.getS %></td>
                            </tr>
--%>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa' align="left">PRIMA:</td>
                                <td class='textSolapa' colspan="3" align="left"><%= sMoneda %>&nbsp;<%= Dbl.DbltoStr (oEnd.getPremio().getimpPrima() +
                                                                                             oEnd.getPremio().getimpDerEmi () +
                                                                                             oEnd.getPremio().getimpRecAdm()+
                                                                                             oEnd.getPremio().getimpRecFin (), 2) %></td>
<%--                                <td class='tituloSolapa'>IVA:</td>
                                <td class='textSolapa'><%= sMoneda %>&nbsp;<%= Dbl.DbltoStr(oEnd.getPremio().getimpIVA () , 2) %></td>
--%>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa' align="left">PREMIO:</td>
                                <td class='textSolapa' colspan="3" align="left"><b><%= sMoneda %>&nbsp;<%= Dbl.DbltoStr(oEnd.getPremio().getMpremio () , 2) %></b></td>
<%--                                <td class='tituloSolapa'>Sellados:</td>
                                <td class='textSolapa'><%= sMoneda %>&nbsp;<%=  Dbl.DbltoStr(oEnd.getPremio().getimpSellados () , 2) %></td>
--%>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa' align="left" nowrap>Plan de Pagos:</td>
                                <td class='tituloSolapa' colspan='3' align="left">Cuota&nbsp;&nbsp;&nbsp;Vence&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Importe&nbsp;&nbsp;&nbsp;&nbsp;Aplicado</td>
                            </tr>
<%                      LinkedList lCuotas = oEnd.getCuotas ();
                        double impCobrado = Math.abs(oEnd.getPremio().getMpremio()) -  Math.abs(oEnd.getimpSaldoPoliza());
                        double impCobrado2 = impCobrado;
                        if (lCuotas != null ) {
                            for (int ii = 0; ii < lCuotas.size();ii++) {
                                Cuota oCuo = (Cuota) lCuotas.get(ii);
%>
                            <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td class='textSolapa' colspan='3' align="left">&nbsp;&nbsp;&nbsp;<%= oCuo.getiNumCuota () %>&nbsp;&nbsp;&nbsp;&nbsp;
                                    <%= (oCuo.getdFechaVencimiento () == null ? " " : Fecha.showFechaForm( oCuo.getdFechaVencimiento ()))%>&nbsp;&nbsp;&nbsp;<%= sMoneda%>&nbsp;<%= Dbl.DbltoStr(oCuo.getiImporte (),2) %>
<%                              if (impCobrado > 0  ) {
                                    if (oEnd.getPremio().getMpremio() > 0 ) {
    %>
                                        &nbsp;&nbsp;&nbsp;<span style="color:green"><%= sMoneda%>&nbsp;<%=(impCobrado > Math.abs(oCuo.getiImporte ()) ? Dbl.DbltoStr(oCuo.getiImporte (),2): Dbl.DbltoStr(impCobrado,2)) %></span>
<%                                  } else {
    %>
                                        &nbsp;&nbsp;&nbsp;<span style="color:red"><%= sMoneda%>&nbsp;<%=(impCobrado > Math.abs(oCuo.getiImporte ()) ? Dbl.DbltoStr(oCuo.getiImporte (),2): Dbl.DbltoStr((-1) * impCobrado,2)) %></span>
<%                                  }
                                 }
    %>
                                </td>
                            </tr>
<%                              impCobrado = impCobrado - Math.abs(oCuo.getiImporte());
                            }
    %>
                            <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa' colspan='3' align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    &nbsp;&nbsp;&nbsp;Total Imputado:
                                        &nbsp;&nbsp;&nbsp;<span style="color:green"><%= sMoneda%>&nbsp;<%= Dbl.DbltoStr(impCobrado2,2) %></span>
                                </td>
                            </tr>
<%
                        }
                    }
                    if (oPol.getcodRama() != 9 ) {
                                LinkedList lAseg = oEnd.getAsegurados ();
                                if (lAseg.size () == 0) {
    %>
                            <tr>
                                <td>&nbsp;</td>
                                <td colspan="4" class='tituloSolapa' align="left">El endoso no tiene n�mina de asegurados asociada.</td>
                            </tr>
                                
<%                              } else {
    %>
                            <tr>
                                <td>&nbsp;</td>
                                <td colspan="4" class='tituloSolapa'>N�mina de Asegurados del Endoso</td>
                            </tr>
                            <tr>
                                <td colspan='2'>&nbsp;</td>
                                <td colspan="3" >Haga click en el icono&nbsp;<img src="<%= Param.getAplicacion()%>images/certificado3.gif" border="0"  width='21' height='22'>&nbsp;para obtener un certificado de cobertura individual para el asegurado.</td>
                            </tr>
                            <tr>
                                <td colspan='5' align="center">
                                    <table border='1' align="center" width='99%' cellpadding='0' cellspacing='0' class="TablasBody">
                                        <tr>
                                            <th width='20' class='textSolapa' align="center">Item</th>
                                            <th width='300' class='textSolapa' align="center"><b>Asegurado<br/>Cobertura</b></th>
                                            <th width='80' class='textSolapa' align="center"><b>Documento<br/>Suma Aseg.</b></th>
                                            <th width='75' class='textSolapa' align="center"><b>Fecha Alta</b></th>
                                            <th width='75' class='textSolapa' align="center"><b>Fecha Baja</b></th>
                                            <th  class='textSolapa' align="center" nowrap><b>Certificado<br/>Cobertura</b></th>
                                        </tr>
<%                              for (int j=0; j < lAseg.size();j++) {
                                    Asegurado oAseg  = (Asegurado) lAseg.get(j);
                                    LinkedList lCob  = null;
                                    if (oAseg.getendosoAlta () == oEnd.getnumEndoso()) {
                                        lCob = oAseg.getCoberturas  ();
                                    }
    %>
                                        <tr>  
                                            <td align="right" class="textSolapa" nowrap><%= oAseg.getcertificado() %>.<%= oAseg.getsubCertificado() %></td>
                                            <td align="left" class='textSolapa' nowrap
                                            <%= (oAseg.getestado ().equals("ACT") ? " style='color:green;' " : " style='color:red;' ")%>>&nbsp;<%= (oAseg.getestado ().equals("ACT") ? "Alta: " : "Baja: ")%>&nbsp;<%= oAseg.getnombre()%></td>
                                            <td align="center" class='textSolapa' nowrap>&nbsp;<%= (oAseg.getdescTipoDoc () + " " + oAseg.getnumDoc ())%></td>
                                            <td align="center" class='textSolapa' nowrap>&nbsp;<%= (oAseg.getfechaAltaCob () == null ? " " : Fecha.showFechaForm(oAseg.getfechaAltaCob ())) %></td>
                                            <td align="center" class='textSolapa' nowrap>&nbsp;<%= (oAseg.getfechaBaja    () == null ? " " : Fecha.showFechaForm(oAseg.getfechaBaja    ())) %></td>
                                            <td align="center" class='textSolapa' nowrap>&nbsp;
<%                                      if ( (( oPol.getestado().equals ("VIGENTE") || oPol.getestado().equals ("NO VIGENTE"))  && oAseg.getsVigente() != null && oAseg.getsVigente().equals("S")) || oPol.getnumTomador() == 65637 || oPol.getnumTomador() == 132401 ) {
    %>
                                            <img src="<%= Param.getAplicacion()%>images/certificado2.gif" border="0" width='19' height='19' 
                                                 onclick="SolicitarCertificado ('<%= oAseg.gettipoDoc ()%>','<%= oAseg.getnumDoc ()%>','<%= oAseg.getcertificado() %>');"  style="cursor: hand;"/>
<%                                      } 
    %>
                                            </td>
                                        </tr>
<%                                  if (lCob != null) {
    %>
<%                                      for (int c=0; c< lCob.size();c++) {
                                            AsegCobertura  oCob = (AsegCobertura) lCob.get(c);
    %>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td align="left" nowrap>&nbsp;&nbsp;&nbsp;&nbsp;<%= oCob.getcodCob() %>&nbsp;-&nbsp;<%= (oCob.getdescCob() == null ? " " : oCob.getdescCob())%></td>
                                            <td align="right" nowrap>&nbsp;<%= Dbl.DbltoStr(oCob.getimpSumaRiesgo () ,2)%></td>
                                            <td colspan='3'>&nbsp;</td>
                                        </tr>
<%                                      }
    %>
<%                                   }
    %>

<%                                  }
    %>
                                    </table>
                                </td>
                            </tr>
<%                                  }
    %>
                            <tr>
                                <td colspan='2'>&nbsp;</td>
<%                            if (oEnd.getnumEndoso () == 999999) {
    %>
                                <td colspan='3'>&nbsp;<HR style='color:#009BE6;'></td>
<%                            } else {
    %>
                                <td colspan="3" >&nbsp;<img src="<%= Param.getAplicacion()%>images/enviar.gif" border="0">&nbsp;Haga clik <a href="#" onclick="SolicitarCopia ('<%= oEnd.getnumEndoso()%>');" class="link1">aqu&iacute;</a> para solicitar una copia del endoso via mail.<br/>
                                    <HR style='color:#009BE6;'>
                                </td>
<%                            }
    %>
                            </tr>
<%
                                }

                            }
                  } // fin del if cod_rama != 9
    %>
                            <tr>
                                <td class='text' colspan='5'><b>NOTA:</b> la informaci�n de la p�liza se encuentra actualizada al&nbsp;<%= Fecha.showFechaForm (oPol.getfechaFTP ()) %>.
                                </td>
                            </tr>
                            <TR>
                                <TD align="center"  colspan='5'>
                                <%--<input type="button" name="cmdSalir"  value="  Salir  "  height="20px" class="boton" onClick="Salir ();">&nbsp;&nbsp;&nbsp;&nbsp;
                                --%>
                                <input type="button" name="cmdGrabar" value='<%= (sVolver.equals ("filtrarPolizas") ? "Volver a la consulta de P&oacute;liza":"Volver al filtro de renovaciones")%>'  height="20px" class="boton" onClick="Volver ();"/>
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

