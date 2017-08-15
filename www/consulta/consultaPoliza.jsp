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
<%@page import="com.business.beans.Premio"%>
<%@page import="com.business.beans.Cuota"%>
<%@page import="com.business.beans.NoGestionar"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.sql.Connection"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<% Usuario usu = (Usuario) session.getAttribute("user"); 
   Poliza oPol = (Poliza) request.getAttribute("poliza");
   PersonaPoliza oPers = (PersonaPoliza) request.getAttribute("tomador");
   UbicacionRiesgo oUbic = (UbicacionRiesgo) request.getAttribute("ubicacion");
   String sMoneda = oPol.getsSignoMoneda();
   boolean bTieneCobertura = false;

   if (oPol.getestado().equals("VIGENTE") && 
       ( usu.getusuario().equals("EUROP") || usu.getiCodTipoUsuario() == 0 )) { 
        Connection dbCon = null;
        try {
            dbCon = db.getConnection();
            bTieneCobertura = oPol.getDBCoberturaFinanciera (dbCon, "AS");
        } catch (Exception e) {
            throw new SurException(e.getMessage());
        } finally {
             db.cerrar(dbCon);
        }

    }

   String sVolver = (request.getParameter("volver") == null ? "filtrarPolizas" : request.getParameter("volver"));
    %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
</head>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css">
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script language='javascript'>
    function Continuar ( form1, siguiente) {

            form1.opcion.value = siguiente;
            form1.submit();
            return true;
    }
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

    function SolicitarCopia ( endoso ) {

//        if (document.form2.estado.value == "FINALIZADA" || document.form2.estado.value == "ANULADA") {
//            alert ( " Operación disponible solo para pólizas vigentes ");
//            return false;
//        } else {
            var sUrl = "<%= Param.getAplicacion()%>consulta/PopUpCopiaPoliza.jsp?F1num_poliza_sel=" +
                document.form1.F1num_poliza_sel.value + "&F1cod_rama_sel=" + document.form1.F1cod_rama_sel.value + 
                "&endoso=" + endoso ;

            var W = 600;
            var H = 270;

            AbrirPopUp (sUrl, W, H);
            return true;
  //      }
    }
    function Submitir (param) {
        document.form1.opcion.value = "getCopia";
        document.form1.endoso.value = param.endoso.value;
        document.form1.email.value  = param.email.value;
        document.form1.nomina.value = param.nomina.value;
        document.form1.submit();
        return true;
    }

    function Visualizar ( tipo ) {
        if (document.form2.estado.value == "FINALIZADA" ||
            document.form2.estado.value == "ANULADA") {
            alert ( " Consulta disponible solo para pólizas vigentes ");
            return false;
        } else {
            if (tipo != "EXCEL") {
                document.form2.action = "<%= Param.getAplicacion()%>consulta/printNomina.jsp";
            } 
            document.form2.opcion.value = "getNomina";
            document.form2.formato.value = tipo;
            document.form2.submit();
            return true;
        }
    }


    function EliminarNoGestionar ( nivel ) {
        document.form1.nivel_exclusion.value = nivel;
        document.form1.opcion.value = "DelNoGestionar";
        document.form1.submit();
        return true;
    }

    function NoGestionar ( nivel ) {
        document.form1.nivel_exclusion.value = nivel;
        document.form1.opcion.value = "AddNoGestionar";
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
<form method="post" action="<%= Param.getAplicacion()%>servlet/ConsultaServlet" name='form2' id='form2'>
    <input type="hidden" name="opcion" id="opcion" value="getNomina"/>
    <input type="hidden" name="formato" id="formato" value="HTML"/>
    <input type="hidden" name="estado" id="estado" value="<%= oPol.getestado() %>"/>
    <input type="hidden" name="cod_rama" value="<%= oPol.getcodRama() %>"/>
    <input type="hidden" name="num_poliza" value="<%= oPol.getnumPoliza ()%>"/>
</form>
            <form method="post" action="<%= Param.getAplicacion()%>servlet/ConsultaServlet" name='form1' id='form1'>
            <input type="hidden" name="opcion" id="opcion" value="getPol"/>
            <input type="hidden" name="solapa" id="solapa" value="poliza"/>
            <input type="hidden" name="F1num_poliza_sel" id="F1num_poliza_sel" value="<%= oPol.getnumPoliza ()%>"/>
            <input type="hidden" name="F1cod_rama_sel" id="F1cod_rama_sel" value="<%= oPol.getcodRama()%>"/>
            <input type="hidden" name="endoso" id="endoso" value="0"/>
            <input type="hidden" name="email" id="email" value=""/>
            <input type="hidden" name="volver" id="volver"  value="<%= sVolver %>"/>
            <input type="hidden" name="nivel_exclusion" value="1"/>
            <input type="hidden" name="num_tomador" id="num_tomador" value="<%= oPers.getnumTomador () %>"/>
            <input type="hidden" name="nomina" id="nomina" value ="S"/>

            <table cellpadding="0" cellspacing="0" border="0" ALIGN="CENTER" width="100%" bgcolor="#FFFFFF" style='margin-top:10;'>
                <tr  height="1">
                    <td colspan="1" width="10">&nbsp;</td>
                    <td width="347"><a href="#" onclick="Continuar ( document.form1, 'getPol');"><img src="<%= Param.getAplicacion()%>images/solapas/poliza0_a.GIF" width="82" height="25" hspace="0" vspace="0" border="0" alt="Consulta de póliza"></a><a href="#" onclick="Continuar ( document.form1, 'getAllEnd');"><img src="<%= Param.getAplicacion()%>images/solapas/endosos1_ia.GIF" width="83" height="25" hspace="0" vspace="0" border="0" alt="consulta de endosos"></a><a href="#" onclick="Continuar ( document.form1, 'getAllCob');"><img src="<%= Param.getAplicacion()%>images/solapas/cobranza2_ia.GIF" width="89" height="25" hspace="0" vspace="0" border="0" alt="consulta de Cobranza" description=""></a><a href="#" onclick="Continuar ( document.form1, 'getAllSegui');"><img src="<%= Param.getAplicacion()%>images/solapas/seguimiento1_ia.GIF" width="93" height="25" hspace="0" vspace="0" border="0" alt="Seguimiento de propuestas" description=""/></a></td>
                    <td colspan="1" >&nbsp;</td>
                </tr>
                <tr height="1">
                    <td bgcolor="#009BE6" colspan="1" height="1"><img src=pixel.gif width="1" height="1"/></td>
                    <td bgcolor="#F3F3F3" colspan="1" height="1"><img src=pixel.gif width="1" height="1"/></td>
                    <td bgcolor="#009BE6" colspan="1" height="1"><img src=pixel.gif width="1" height="1"/></td>
                </tr>
            </table>
            <table cellpadding="0" cellspacing="0" border="0" ALIGN="CENTER" width="100%" bgcolor="#FFFFFF">
                <tr >
                    <td  width="1" bgcolor="#009BE6"><img src=pixel.gif width="1" height="1"/></td>
                    <td colspan=3 bgcolor="#F3F3F3">
                        <table border="0" cellpadding='1' cellspacing='1'>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td class='tituloSolapa'  width='105' align="left" valign="top" nowrap>Rama:&nbsp;</td>
                                <td class='tituloSolapa'  width="250" align="left" valign="top" colspan="3"><%= oPol.getdescRama() %>&nbsp;-&nbsp;<%= oPol.getdescSubRama() %></td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td class='tituloSolapa' width="105" align="left">Poliza N°:&nbsp;</td>
                                <td class='tituloSolapa' width="250" align="left"><%= Formatos.showNumPoliza(oPol.getnumPoliza ()) %></td>
                                <td class='tituloSolapa' width="100" align="left">Propuesta N°:&nbsp;</td>
<%                      if (oPol.getboca () != null) {
    %>
                                <td class="tituloSolapa" width="220" align="left"><%= oPol.getboca () %>&nbsp;-&nbsp;<%= oPol.getnumPropuesta () %></td>
<%                      } else {
    %>
                                <td class="tituloSolapa" width="220" align="left">no informado</td>
<%                      }
    %>
                            </tr>
<%                      if (oPol.getiPolizaGrupo() > 0) {
    %>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa' align="left">Grupo N°:&nbsp;</td>
                                <td class='textSolapa' align="left" colspan="3">Grupo N°:&nbsp;<%= oPol.getiPolizaGrupo() %>&nbsp;-&nbsp;<%=oPol.getsDescPolizaGrupo()%></td>
                            </tr>
   <%                   }
    %>
<%                          if ( usu.getiCodTipoUsuario() == 0 ) {
                                if (oPol.getoNoGestionar() != null) {
                                    NoGestionar oNoGes = oPol.getoNoGestionar();
%>
                            <tr>
                                <td>&nbsp;</td>
                                <td colspan="3" class="subtitulo" height="30" valign="top" align="left" >
                                    <img  alt="No gestionar" src="/benef/images/ok.gif"  border="0"  hspace="0" vspace="0" align="bottom"/>&nbsp;
                                    No gestionar hasta&nbsp;<%= (oNoGes.getfechaHasta() == null ? "indefinido" : Fecha.showFechaForm(oNoGes.getfechaHasta())) %>
                                    &nbsp;&nbsp;(<%= oNoGes.getuserId() %>,&nbsp;<%= Fecha.showFechaForm(oNoGes.getfechaTrabajo()) %>)&nbsp;
                                    <a href="#"  onclick="javascript:EliminarNoGestionar ( 1 );" ><img onClick="javascript:EliminarNoGestionar ( 1 );"  alt="Eliminar no gestionar" src="/benef/images/nook.gif"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;"/>&nbsp;Eliminar</a>
                                </td>
                                <td class="subtitulo" align="left" valign="top" >Motivo:&nbsp;<%= oNoGes.getmotivo() %></td>
                            </tr>
<%                                  } else {
%>
                            <tr>
                                <td>&nbsp;</td>
                                <td class="subtitulo" nowrap colspan="2" valign="top" >No gestionar la p&oacute;liza hasta&nbsp;
                                    <input name="fecha_hasta" id="fecha_hasta" size="10" onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value=""/>&nbsp;(dd/mm/yyyy)
                                </td>
                                <td align="left" valign="top" colspan="2">
                                    <input type="button" name="cmdNoGestionar"  value=" ENVIAR " height="20px" class="boton"
                                           onClick="javascript:NoGestionar ( 1 );"/>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td class="subtitulo" valign="top" >Motivo:</td>
                                <td class="subtitulo" colspan="3" valign="top" >
                                    <textarea cols="50" rows="2" name="motivo" id="motivo"></textarea>
                                </td>
                            </tr>
<%
                                    }
                                }
%>

                            <tr>
                                <td colspan="5" align="left" class='titulo'>Datos del Tomador</td>
                            </tr>
                            <tr>
                                <td width="15">&nbsp;</td>
                                <td class='tituloSolapa' align="left" width="105">Descripci&oacute;n:&nbsp;</td>
                                <td class='textSolapa' align="left" width="300"><%= oPers.getrazonSocial() %></td>
                                <td class='tituloSolapa' align="left" width="100" >Cliente N°:&nbsp;</td>
                                <td class='textSolapa' align="left" width="300"><%= oPers.getnumTomador () %></td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa' align="left">Domicilio:</td>
                                <td class='textSolapa' align="left" colspan='3'><%= (oPers.getdomicilio() + " - " + oPers.getlocalidad () + " (" + oPers.getcodPostal() + ") - " + oPers.getdescProvincia())  %></td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa' align="left">Cuit:&nbsp;</td>
                                <td class='textSolapa' align="left"><%= oPers.getcuit() %></td>
                                <td class='tituloSolapa' align="left">Cond. IVA:&nbsp;</td>
                                <td class='textSolapa' align="left"><%= oPers.getdescIVA () %></td>
                            </tr>
<%                          if ( usu.getiCodTipoUsuario() == 0 ) {
                                if (oPers.getnoGestionar() != null) {
                                    NoGestionar oNoGesTom = oPers.getnoGestionar();
%>
                            <tr>
                                <td>&nbsp;</td>
                                <td colspan="3" class="subtitulo" height="30" valign="top" >
                                    <img  alt="No gestionar" src="/benef/images/ok.gif"  border="0"  hspace="0" vspace="0" align="bottom"/>&nbsp;
                                    No gestionar al tomador hasta&nbsp;<%= (oNoGesTom.getfechaHasta() == null ? "indefinido" : Fecha.showFechaForm(oNoGesTom.getfechaHasta())) %>
                                    &nbsp;&nbsp;(<%= oNoGesTom.getuserId() %>,&nbsp;<%= Fecha.showFechaForm(oNoGesTom.getfechaTrabajo()) %>)&nbsp;
                                    <a href="#"  onclick="javascript:EliminarNoGestionar ( 4 );" ><img onClick="javascript:EliminarNoGestionar ( 4 );"
                                                                                                       alt="Eliminar no gestionar" src="/benef/images/nook.gif"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;"/>&nbsp;Eliminar</a>
                                </td>
                                <td class="subtitulo" align="left" valign="top" >Motivo:&nbsp;<%= oNoGesTom.getmotivo() %></td>
                            </tr>
<%                                  } else {
%>
                            <tr>
                                <td>&nbsp;</td>
                                <td class="subtitulo" nowrap colspan="2" valign="top" >No gestionar tomador hasta&nbsp;
                                    <input name="fecha_hasta_4" id="fecha_hasta_4" size="10" onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value=""/>&nbsp;(dd/mm/yyyy)
                                </td>
                                <td align="left" valign="top" colspan="2">
                                    <input type="button" name="cmdNoGestionar"  value=" ENVIAR " height="20px" class="boton"
                                           onClick="javascript:NoGestionar ( 4 );"/>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td class="subtitulo" valign="top" >Motivo:</td>
                                <td class="subtitulo" colspan="3" valign="top" >
                                    <textarea cols="50" rows="2" name="motivo_4" id="motivo_4"></textarea>
                                </td>
                            </tr>
<%
                                    }
                                }
%>

                            <tr>
                                <td colspan="5"  class='titulo'>Datos de la P&oacute;liza</td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa' align="left">Fecha Emisi&oacute;n:</td>
                                <td class='textSolapa' align="left"><%= (oPol.getfechaEmision () == null ? "no informado" : Fecha.showFechaForm (oPol.getfechaEmision ())) %></td>
                                <td class='tituloSolapa' align="left">Estado:</td>
                                <td class='textSolapa' align="left"><%= oPol.getestado () %></td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa' align="left">Fechas Vigencia:</td>
                                <td class='textSolapa' align="left"><%= (oPol.getfechaInicioVigencia () == null ? "no informado" : Fecha.showFechaForm (oPol.getfechaInicioVigencia ())) %>&nbsp;al&nbsp;<%= (oPol.getfechaFinVigencia () == null ? "sin fin de vigencia" : Fecha.showFechaForm (oPol.getfechaFinVigencia ())) %></td>
<%                  if (oPol.getestado().equals("VIGENTE") && ( usu.getusuario().equals("EUROP") || usu.getiCodTipoUsuario() == 0 )  ) {
    %>
                                <td class='tituloSolapa' align="left">&nbsp;</td>
<%                          if ( ! bTieneCobertura ) {
    %>
                                <td class='textSolapa' align="left"><span style="color:red;font-weight:bold">SIN COBERTURA FINANCIERA</span></td>
<%                            } else {
    %>
                                <td class='textSolapa' align="left"><span style="color:green;font-weight:bold">CON COBERTURA FINANCIERA</span></td>
 <%                         }
                    } else {
   %>
                                <td class='tituloSolapa' valign="top" align="left">P&oacute;liza Anterior:</td>
                                <td class='textSolapa' valign="top" align="left"><%= (oPol.getnumPolizaAnt () == 0 ? "no existe" : ( String.valueOf(oPol.getnumPolizaAnt ()) + " - Saldo: $ " + Dbl.DbltoStr( oPol.getimpSaldoPolizaAnt (),2))) %></td>
<%                 }
    %>
                            </tr>
<%                 if (oPol.getcodRama() == 10 ) {
    %>
                            <tr>         
                                <td>&nbsp;</td>  
                                <td class='tituloSolapa' align="left">Ubicaci&oacute;n Riesgo:</td>
                                <td class='textSolapa'  colspan="3" align="left"><%= (oUbic.getdomicilio() + " - " + oUbic.getlocalidad () + " (" + oUbic.getcodPostal() + ") - " + oUbic.getdescProvincia())  %></td>
                            </tr>
                            <tr>         
                                <td>&nbsp;</td>  
                                <td class='tituloSolapa' align="left">Actividad:</td>
                                <td class='textSolapa' colspan='3' align="left"><%= (oPol.getdescActividad () == null ? "no informado" : oPol.getdescActividad ()) %></td>
                            </tr>
<%                }
    %>
                            <tr>
                                <td colspan="5" class='titulo'>Datos del Premio</td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa' colspan='3' align="left">Moneda de la p&oacute;liza:&nbsp;<span class='textSolapa'><%= oPol.getsDescMoneda() %></span></td>
                           </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa' align="left" nowrap>Meses de facturaci&oacute;n:</td>
                                <td class='textSolapa' align="left"><%= oPol.getperiodoFact () %></td>
                                <td class='tituloSolapa' align="left">Forma de Pago:</td>
                                <td class='textSolapa' align="left"><%= oPol.getPremio().getsDescFormaPago() %></td>
                           </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa'  align="left">PRIMA:</td>
                                <td class='textSolapa' colspan="3"  align="left"><%= sMoneda %>&nbsp;<%= Dbl.DbltoStr (oPol.getPremio().getimpPrima() +
                                                                                             oPol.getPremio().getimpDerEmi () +
                                                                                             oPol.getPremio().getimpRecAdm()+
                                                                                             oPol.getPremio().getimpRecFin (), 2) %></td>
<%--                                <td class='tituloSolapa'>IVA:</td>
                                <td class='textSolapa'><%= sMoneda %>&nbsp;<%= Dbl.DbltoStr(oPol.getPremio().getimpIVA () , 2) %></td>
--%>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa' align="left">PREMIO:</td>
                                <td class='textSolapa' colspan="3" align="left"><b><%= sMoneda %>&nbsp;<%= Dbl.DbltoStr(oPol.getPremio().getMpremio () , 2) %></b></td>
<%--                                <td class='tituloSolapa'>Sellados:</td>
                                <td class='textSolapa'><%= sMoneda %>&nbsp;<%=  Dbl.DbltoStr(oPol.getPremio().getimpSellados () , 2) %></td>
--%>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa' align="left">Plan de Pagos:</td>
                                <td class='tituloSolapa' colspan='3' align="left">Cuota&nbsp;&nbsp;&nbsp;Vence&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Importe</td>
                            </tr>
<%                      LinkedList lCuotas = oPol.getCuotas ();
                        if (lCuotas != null ) {
                            for (int i =0; i < lCuotas.size();i++) {
                                Cuota oCuo = (Cuota) lCuotas.get(i);
%>
                            <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td class='textSolapa' colspan='3' align="left">&nbsp;&nbsp;&nbsp;<%= oCuo.getiNumCuota () %>&nbsp;&nbsp;&nbsp;&nbsp;<%= (oCuo.getdFechaVencimiento () == null ? " " : Fecha.showFechaForm( oCuo.getdFechaVencimiento ()))%>&nbsp;&nbsp;&nbsp;<%= sMoneda%>&nbsp;<%= Dbl.DbltoStr(oCuo.getiImporte (),2) %></td>
                            </tr>
<%                          }
                        }
    %>
<%--
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa' align="left">Comisiones:</td>
                                <td class='tituloSolapa' colspan='3' align="left">&nbsp;</td>
                            </tr>
<%                 if (usu.getiCodTipoUsuario () == 0 || usu.getiCodTipoUsuario () == 1) {  
    %>

<%                      if (usu.getiCodTipoUsuario () == 0 || ( usu.getiCodTipoUsuario () == 1 && usu.getiCodProd () >= 80000) ) {  
    %>                            
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa' align="left">&nbsp;</td>
                                <td class='tituloSolapa' align="left">Porc. de Comisión s/Prima Organizador:</td>
                                <td class='textSolapa' colspan='2' align="left"><%= oPol.getPremio().getporcComisionPrimaOrg  () %>&nbsp;%</td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa' align="left">&nbsp;</td>
                                <td class='tituloSolapa' align="left">Porc. de Comisión Cobranza Organizador:</td>
                                <td class='textSolapa' colspan='2' align="left"><%= oPol.getPremio().getporcComisionPremioOrg  () %>&nbsp;%</td>
                            </tr>
<%                      }
    %>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa' align="left">&nbsp;</td>
                                <td class='tituloSolapa' align="left">Porc. de Comisión s/Prima Productor:</td>
                                <td class='textSolapa' colspan='2' align="left"><%= oPol.getPremio().getporcComisionPrimaProd  ()%>&nbsp;%</td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa' align="left">&nbsp;</td>
                                <td class='tituloSolapa' align="left">Porc. de Comisión Cobranza Productor:</td>
                                <td class='textSolapa' colspan='2' align="left"><%= oPol.getPremio().getporcComisionPremioProd  ()%>&nbsp;%</td>
                            </tr>

<%                      }
    %>
--%>
<%
                            LinkedList lTextos = (LinkedList) request.getAttribute("textos");
                            if (lTextos.size() != 0) {
   %>
                            <tr>
                                <td colspan="5" class='titulo'>Información adicional</td>
                            </tr>
<%                              for (int i=0; i < lTextos.size();i++) {
                                TextoPoliza  oText = (TextoPoliza) lTextos.get(i);
    %>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='textSolapa' colspan='4' align="left"><%= oText.gettexto() %></td>
                            </tr>
<%                              }
                            }
                            if (oPol.getcodRama() != 9 ) {
    %>
                            <tr>
                                <td colspan="5" class='titulo'>N&oacute;mina actualizada de asegurados</td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='tituloSolapa' height="30" valign="middle" align="left" colspan="4">Cantidad de asegurados vigentes:
                                    &nbsp;&nbsp;<%= oPol.getcantVidas() %>
                                </td>
                           </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td class='tituloSolapa' colspan='4'>
                                    <a href="#" onclick="Visualizar('HTML');"><img src='<%=Param.getAplicacion()%>images/HTML.gif' border='0'>&nbsp;página web (HTML)</a>&nbsp;&nbsp;&nbsp;&nbsp;
                                    <a href="#" onclick="Visualizar('PDF');"><img src='<%=Param.getAplicacion()%>images/PDF.gif' border='0'>&nbsp;acrobat reader (PDF)</a>&nbsp;&nbsp;&nbsp;&nbsp;
                                    <a href="#" onclick="Visualizar('EXCEL');"><img src='<%=Param.getAplicacion()%>images/XLS.gif' border='0'>&nbsp;exportar a excel (XLS)</a>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td class='subtitulo' align="left" valign="top" colspan='4'><span class="tituloSolapa">ACLARACION:&nbsp;</SPAN>
                                    <span class='textSolapa' valign="top">La n&oacute;mina actualizada es la lista de asegurados con cobertura. Si la póliza esta Anulada o fuera de vigencia la nómina de asegurados es vacia.<br>
                                    Si usted desea consultar altas y bajas de asegurados haga clik en la solapa de Endosos<span>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="5" class='titulo'>Copia de Póliza</td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td class='tituloSolapa' colspan='4'><img src="<%= Param.getAplicacion()%>images/enviar.gif" border="0">&nbsp;Obtenga desde <a href="#" onclick="SolicitarCopia ('0');" class="link1">aqu&iacute;</a> una solicitud de copia de póliza vía mail.
                                </td>
                            </tr>
<%                              }
    %>
                            <tr>
                                <td class='text' colspan='5'><b>NOTA:</b> la información de la póliza se encuentra actualizada al&nbsp;<%= Fecha.showFechaForm (oPol.getfechaFTP ()) %>.</td>
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
