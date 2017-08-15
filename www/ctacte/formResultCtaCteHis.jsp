<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.CtaCteHis"%>
<%@page import="com.business.beans.CtaCteFac"%>
<%@page import="com.business.beans.Generico"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.*"%>
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>
<%@ taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg" %>
<%       
    CtaCteFac oFac = (CtaCteFac) request.getAttribute("ctaCteFac");
    Date dFechaUltCierre = (Date) request.getAttribute("fechaMaxCtaCteHis");
    LinkedList ctasCtesHis = (LinkedList) request.getAttribute("ctasCtesHis");
    Diccionario oDicc   = (Diccionario) session.getAttribute("Diccionario");
    Usuario usu = (Usuario) session.getAttribute("user");
    int iSize        = (ctasCtesHis == null ? 0 : ctasCtesHis.size());
    String sPri      = oDicc.getString(request,"cc_pri","S");
    int iCodProd     = oDicc.getInt (request, "cc_cod_prod");
    int iFechaDesde  = oDicc.getInt (request, "cc_fecha_desde");
    int iFechaHasta  = oDicc.getInt (request, "cc_fecha_hasta");
    String sCodProdDesc  = oDicc.getString(request,"cc_prod_desc");
    oDicc.add("cc_pri", sPri );
    oDicc.add("cc_cod_prod", String.valueOf(iCodProd));
    oDicc.add("cc_fecha_desde", String.valueOf (iFechaDesde));
    oDicc.add("cc_fecha_hasta", String.valueOf (iFechaHasta));
    oDicc.add("cc_prod_desc", String.valueOf (sCodProdDesc));
    session.setAttribute("Diccionario", oDicc);
    String sPath            = "&cc_pri=N" +
                              "&cc_cod_prod="+iCodProd+
                              "&cc_fecha_desde=" + iFechaDesde +
                              "&cc_fecha_hasta=" + iFechaHasta  +
                              "&cc_prod_desc=" + sCodProdDesc  +
                              "&opcion=getCtasCtesHIS";

    double iTotalPrima      = 0;
    double iTotalPremio     = 0;
    HtmlBuilder ohtml      = new HtmlBuilder();
    Tablas oTabla = new Tablas ();
    LinkedList lTabla = new LinkedList ();
    String fechaDesde = "";
    String fechaHasta = "";
    LinkedList lTotales = new LinkedList();
    if (iSize>1)  {
        CtaCteHis oCCHis = (CtaCteHis) ctasCtesHis.get(0);
        if (oCCHis.getOrdene() == 1) {            
            String _anioMes = String.valueOf( oCCHis.getAnioMes() );
            String _anio    = _anioMes.substring(0,4);
            String _mes     = _anioMes.substring(4,_anioMes.length());           
            fechaDesde =    "01/" + _mes + "/" + _anio;            
        }
        
        int ultimo = iSize -1;      
        oCCHis = (CtaCteHis) ctasCtesHis.get(ultimo);
          if (oCCHis.getOrdene() == 99) {            
            String _anioMes = String.valueOf( oCCHis.getAnioMes() );
            String _anio    = _anioMes.substring(0,4);
            String _mes     = _anioMes.substring(4,_anioMes.length());
            GregorianCalendar gc = new GregorianCalendar();
            gc.set(GregorianCalendar.YEAR, Integer.parseInt(_anio));
            gc.set(GregorianCalendar.MONTH, Integer.parseInt(_mes)-1);
            gc.set(GregorianCalendar.DATE, 1);
            int _ultimoDia = gc.getActualMaximum( GregorianCalendar.DAY_OF_MONTH );
            fechaHasta =  _ultimoDia + "/" + _mes + "/" + _anio;
            lTotales.add("TOTAL PRIMA&nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;$&nbsp;" + Formatos.lpad (Dbl.DbltoStr(oCCHis.getImpPrima(),2),"&nbsp;",8));
            lTotales.add("TOTAL PREMIO : $ "  + Formatos.lpad (Dbl.DbltoStr(oCCHis.getImpPremio(),2),"&nbsp;",8));
            lTotales.add("SALDO FINAL&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;$&nbsp;" + Formatos.lpad (Dbl.DbltoStr(oCCHis.getSaldo(),2),"&nbsp;",8));
        }
    }
    LinkedList lFormaPago = new  LinkedList();
    Hashtable hFormaPagoDesCorta = new Hashtable();
    Tablas tablaFormaPagoDescCorta = new Tablas();
    LinkedList lFormaDePagoDescCorta = tablaFormaPagoDescCorta.getDatosOrderByDesc ("CTACTE_TIPOIN_CORTO");
    for (int index1=0; index1 < lFormaDePagoDescCorta.size(); index1++) {
        Generico oFormaDePagoDescCorta = (Generico) lFormaDePagoDescCorta.get(index1);
        hFormaPagoDesCorta.put(oFormaDePagoDescCorta.getsCodigo(), oFormaDePagoDescCorta.getDescripcion()) ;
    }
    Tablas tablaFormaPago = new Tablas();
    LinkedList lFormaDePago = tablaFormaPago.getDatosOrderByDesc ("CTACTE_TIPOIN_LARGO");
    for (int index=0; index < lFormaDePago.size(); index++) {
        Generico oFormaDePago = (Generico) lFormaDePago.get(index);
        lFormaPago.add(hFormaPagoDesCorta.get(oFormaDePago.getsCodigo())+" - "+ oFormaDePago.getDescripcion());
    }
    %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
    <script type="text/javascript" language="javascript">
    
  
    function Salir () {
        window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }
    function Buscar() {
        document.form1.action = "<%= Param.getAplicacion()%>servlet/CtaCteServlet";
        document.form1.opcion.value  = 'selectCtaCte';
        document.form1.submit();        
    }
    function VisualizarCertificado (sFechaMov, codProdDC ){
        document.form2.action = "<%= Param.getAplicacion() %>certificado/IBSS/printCertifIBSS.jsp";
        document.form2.opcion.value    = "getCertificadoIBSS";
        document.form2.ce_origen.value = "formResultCtaCteHis";
        document.form2.ce_fecha_mov.value = sFechaMov ;
        document.form2.ce_cod_prod.value = codProdDC;
        document.form2.submit();
    }

    function VerCtaCteFacturacion (){
        document.form2.action = "<%= Param.getAplicacion() %>servlet/CtaCteServlet";
        document.form2.opcion.value    = "getCtaCteFac";
        document.form2.ce_origen.value = "formResultCtaCteHis";
        document.form2.submit();
    }

    function Visualizar ( formato ) {
        if (formato == 'PDF') {
            document.form2.action = "<%= Param.getAplicacion() %>ctacte/printPreview.jsp";
        } else {
            document.form2.action = "<%= Param.getAplicacion()%>servlet/CtaCteServlet";
        }
        document.form2.opcion.value = "printCtaCteHIS";
        document.form2.formato.value = formato;
        document.form2.submit();
        return true;
    }

    function PrintPreview ( formato) {       
        document.form2.action = "<%= Param.getAplicacion() %>ctacte/printPreview.jsp";
        document.form2.formato.value = formato;
        document.form2.submit();
        return true;
    }

    function Submitir (param) {

        document.form2.action = "<%= Param.getAplicacion()%>servlet/ConsultaServlet";
        document.form2.opcion.value      = "getCopiaLiq";
        document.getElementById('cod_prod').value    = param.cod_prod.value;
        document.getElementById('email').value       = param.email.value;
        document.getElementById('fecha_hasta').value = param.fecha_hasta.value;
        document.getElementById('liquidacion').value = param.liquidacion.value;
        document.form2.submit();
        return true;
    }

    function VisualizarLiquidacion ( fecha, liq ) {

        var popup =  'consulta/PopUpCopiaLiquidacion.jsp?fecha_hasta=' + fecha + '&liquidacion=' + liq +
             '&cod_prod=' + document.getElementById('cc_cod_prod').value;

        var sUrl = "<%= Param.getAplicacion()%>" + popup ;

        var W = 500;
        var H = 300;

        AbrirPopUp (sUrl, W, H);
        return true;
    }

    </script>
</head>
<body>
<form method="post" action="<%= Param.getAplicacion()%>servlet/CtaCteServlet" name='form2' id='form2'>
    <input type="hidden" name="opcion" id="opcion" value="printCtaCteHIS"/>
    <input type="hidden" name="formato" id="formato" value=""/>
    <input type="hidden" name="cc_cod_prod" id="cc_cod_prod" value="<%= iCodProd %>"/>
    <input type="hidden" name="cc_fecha_desde" id="cc_fecha_desde" value="<%= iFechaDesde %>"/>
    <input type="hidden" name="cc_fecha_hasta" id="cc_fecha_hasta" value="<%= iFechaHasta %>"/>
    <input type="hidden" name="cod_prod"    id="cod_prod" value="<%= iCodProd %>"/>
    <input type="hidden" name="email"       id="email" value=""/>
    <input type="hidden" name="fecha_hasta" id="fecha_hasta" value=""/>
    <input type="hidden" name="liquidacion" id="liquidacion" value=""/>
    <input type="hidden" name="ce_origen" id="ce_origen" value="formResultCtaCteHis"/>
    <input type="hidden" name="ce_fecha_mov" id="ce_fecha_mov" value=""/>
    <input type="hidden" name="ce_cod_prod" id="ce_cod_prod" value=""/>
</form>
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
<%      if (oFac.getImporte() > 0) {
    %>
   <tr>
        <td valign="top" align="center" >
            <table width="95%" border="0" align="center" cellspacing="0" cellpadding="0"
                   class="fondoForm"  style="margin-top:5;margin-bottom:5;">
                <tr>
                    <td class="titulo" height="30" valign="middle" align="center">COMISIONES A FACTURAR DEL ULTIMO PERIODO</td>
                </tr>
<%              if (oFac.getiNumError() == -100) {
    %>
                <tr>
                    <td class="subtitulo" height="30" valign="middle"><span style="color:red">Lamentablemente aún no tenemos disponble la información de comisiones a facturar del periodo. <br>
                   Por favor, intente nuevamente en otro momento. Gracias</span></td>
                </tr>
<%          } else  {
    %>
                <tr>
                    <td class="subtitulo" height="30" valign="middle" align="left">Estimado colaborador, nuestro último cierre comisionario fue el&nbsp;<%= Fecha.showFechaForm(dFechaUltCierre) %>.<br>
                        Usted deber&aacute; emitir una factura con los siguientes valores:</td>
                </tr>
                <tr>
                    <td>
                        <table align="left" border="0" cellpadding="2" cellspacing="2">
                            <tr>
                                <td width="20px">&nbsp;</td>
                                <td width="180px" class="subtitulo" align="left">Raz&oacute;n Social:</td>
                                <td width="400px" class="subtitulo" align="left"><b>BENEFICIO S.A.</b></td>
                            </tr>
                            <tr>
                                <td >&nbsp;</td>
                                <td class="subtitulo"  align="left">CUIT:</td>
                                <td class="subtitulo" align="left"><b>30-68082752/0</b></td>
                            </tr>
                            <tr>
                                <td >&nbsp;</td>
                                <td class="subtitulo"  align="left">Domicilio:</td>
                                <td class="subtitulo" align="left"><b>C&oacute;rdoba 1015 Piso 2 Of. 7 - Rosario CP 2000 (Santa Fe)</b></td>
                            </tr>
                            <tr>
                                <td >&nbsp;</td>
                                <td class="subtitulo"  align="left">Comisiones netas del periodo:</td>
                                <td class="subtitulo" align="left"><b>$&nbsp;<%=  Dbl.DbltoStr(oFac.getImporte(), 2) %></b></td>
                            </tr>
                            <tr>
                                <td >&nbsp;</td>
                                <td class="subtitulo"  align="left">IVA:</td>
                                <td class="subtitulo" align="left"><b>$&nbsp;<%=  Dbl.DbltoStr(oFac.getimpIva(), 2) %></b></td>
                            </tr>
                            <tr>
                                <td >&nbsp;</td>
                                <td class="textnegro"  align="left"><span style="color:red;">IMPORTE A FACTURAR:</span></td>
                                <td class="textnegro"  align="left"><span style="color:red;"><b>$&nbsp;<%=  Dbl.DbltoStr(oFac.getimpTotal(), 2) %></b></span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
<%          }

    %>
                <tr>
                    <td class="subtitulo" height="30" valign="middle">Si usted desea consultar comisiones a facturar de periodos anteriores y facturas emitidas
                        <a href="#" onclick="VerCtaCteFacturacion();">haga clic aqui</a></td>
                </tr>
            </table>
        </td>
    </tr>
<%     }
    %>
    <tr>
        <td>
            <table  width="100%" cellPadding="3" cellSpacing="1" border="0" CLASS="fondoForm1" align="center" >
                <tr>
                    <TD height="30px" valign="middle" align="center" class='titulo'>CUENTA CORRIENTE PRODUCTOR AL <%=fechaHasta%></TD>
                </tr>
                <tr>
                    <TD height="30px" valign="middle" align="left" class='subtitulo'>Productor:&nbsp;<%=sCodProdDesc %></TD>
                </tr>
                <tr>
                    <TD valign="middle" align="left" class='subtitulo'>PERIODO LIQUIDADO &nbsp;:&nbsp;<%=fechaDesde%>&nbsp;<strong>AL</strong>&nbsp;<%=fechaHasta%></TD>
                </tr>
<%
                           if (iSize  > 1 ){
%>

                <tr>
                    <td align="right"  >
                        <a href="#" onclick="Visualizar('PDF');"><img src='<%=Param.getAplicacion()%>images/PDF.gif' alt="Bajar datos a PDF" border='0'></a>
                        &nbsp;&nbsp;&nbsp;
                        <a href="#" onclick="Visualizar('EXCEL');"><img src='<%=Param.getAplicacion()%>images/XLS.gif' alt="Exportar datos a Excel" border='0'></a>
                        &nbsp;&nbsp;&nbsp;
                     </td>
                </tr>
<%
                           }
%>
                <tr>
                    <td valign="top"  width='100%'>
                        <pg:pager  maxPageItems="30" items="<%= iSize %>" url="/benef/servlet/CtaCteServlet"
                        maxIndexPages="30" export="currentPageNumber=pageNumber">
                        <pg:param name="keywords"/>

                        <table border="1" cellspacing="0" cellpadding="2" align="center" class='TablasBody'>
                            <thead>
                                <th width='45px' nowrap>Fecha</th>
                                <th width='100px' nowrap>Item</th>
                                <th width="300px" nowrap >Concepto</th>
                                <th width="50px" nowrap>Comp.</th>
                                <th width="10px" >(*)</th>
                                <th width="70px">Prima</th>
                                <th  width="70px">Premio</th>
                                <th  width="70px">Debe</th>
                                <th  width="70px">Haber</th>
                            </thead>
<%                            if (iSize  <= 1 ){
%>
                            <tr>
                                <td colspan="9" height='25' valign="middle"><span style='color:red'>No existen cuentas corrientes para la consulta realizada</span></td>
                            </tr>
<%                         }
                           else {

                           for (int i=0; i < iSize; i++)  {
                                 CtaCteHis oCCHis = (CtaCteHis) ctasCtesHis.get(i);
%>
                          <pg:item>
<%
                              if (oCCHis.getOrdene() == 1  ||oCCHis.getOrdene() ==99 ) {
                                  if (oCCHis.getOrdene() == 1) {                                      
%>
                             <tr>
                                 <td>&nbsp;</td>
                                 <td nowrap colspan="5" height="40"  align="left" valign="middle"><strong><label style=" font-size:11 ; ">Saldo acumulado del Cod:&nbsp;<%= oCCHis.getCodProddDc().substring(0,5) %>.
<%= oCCHis.getCodProddDc().substring(5,10) %>&nbsp;al&nbsp;<%= (oCCHis.getFechaMov() == null ? " " : Fecha.showFechaForm(oCCHis.getFechaMov()))%></label></strong></td>
                                 <td align="right"><strong><label style="font-size:11;"><%=(oCCHis.getSaldo() < 0 ? Dbl.DbltoStr(oCCHis.getSaldo(),2) : "&nbsp;")%></label></strong></td>
                                 <td align="right"><strong><label style="font-size:11;"><%=(oCCHis.getSaldo() < 0 ? "&nbsp;" : Dbl.DbltoStr(oCCHis.getSaldo(),2))%></label></strong></td>
                             </tr>                          
<%
                                  } else {
                                      String _anioMes = String.valueOf( oCCHis.getAnioMes() );
                                      String _anio    = _anioMes.substring(0,4);
                                      String _mes     = _anioMes.substring(4,_anioMes.length());
                                      GregorianCalendar gc = new GregorianCalendar();
                                      gc.set(GregorianCalendar.YEAR, Integer.parseInt(_anio));
                                      gc.set(GregorianCalendar.MONTH, Integer.parseInt(_mes)-1);
                                      gc.set(GregorianCalendar.DATE, 1);
                                      int _ultimoDia = gc.getActualMaximum( GregorianCalendar.DAY_OF_MONTH );
                                      String _fechaSaldo = _ultimoDia + "/" + _mes + "/" + _anio;
%>
                             <tr class="fondoForm" >
                                 <td>&nbsp;</td>
                                 <td nowrap colspan="4" height="40"  align="left" valign="middle"><strong><label style=" font-size:11; ">TOTALES y SALDO AL&nbsp;<%=_fechaSaldo%></label></strong></td>
                                 <td align="right"><strong><label style="font-size:11;"><%= Dbl.DbltoStr(oCCHis.getImpPrima(),2)%></label></strong></td>
                                 <td align="right"><strong><label style="font-size:11;"><%= Dbl.DbltoStr(oCCHis.getImpPremio(),2)%></label></strong></td>
                                 <td align="right"><strong><label style="font-size:11;"><%=(oCCHis.getSaldo() < 0 ? Dbl.DbltoStr(oCCHis.getSaldo(),2) : "&nbsp;")%></label></strong></td>
                                 <td align="right"><strong><label style="font-size:11;"><%=(oCCHis.getSaldo() < 0 ? "&nbsp;" : Dbl.DbltoStr(oCCHis.getSaldo(),2))%></label></strong></td>
                             </tr>
<%
                                  } // 99
                              } else {
%>
                            <tr>
                                <td align="center"><%= (oCCHis.getFechaMov() == null ? " " : Fecha.showFechaForm(oCCHis.getFechaMov()))  %></td>
                                <td align="left">  <%= (oCCHis.getMovimiento() == null ? " " : oCCHis.getMovimiento())%></td>
<%
                                 if (oCCHis.getCodRama()>0 && oCCHis.getNumPoliza()>0) {
%>
                                <td align="left"><%=oCCHis.getCodRama()%>/<%=oCCHis.getNumPoliza()%>/<%=oCCHis.getEndoso()%>&nbsp;-&nbsp;<%=oCCHis.getConcepto()%></td>

<%
                                 } else {
%>
                                    <td align="left"><%= oCCHis.getConcepto()%>&nbsp;
<%
                                if (oCCHis.getOrdene() == 6  ||oCCHis.getOrdene() ==7 ) {
    %>
                                    <IMG height='16' width='16' onClick="javascript:VisualizarCertificado('<%= (oCCHis.getFechaMov() == null ? " " : Fecha.showFechaForm(oCCHis.getFechaMov()))%>','<%= oCCHis.getCodProddDc()%>');"
                                    alt="Visualizar certificado de Retención de Ing. Brutos y Serv. Sociales" src="<%= Param.getAplicacion() %>images/certificado3.gif"
                                    border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;"/>
<%
                                 }
    %>
                                 </td>
<%
                                 }
                                 if (oCCHis.getTipoIngreso() != null && oCCHis.getTipoIngreso().equals("CO") && oCCHis.getComprobante() != null) {
    %>
                                    <td align="center"><a href="#" onClick="javascript:VisualizarLiquidacion('<%=  Fecha.showFechaForm(oCCHis.getFechaMov()) %>','<%=oCCHis.getComprobante()%>');"
                                                          alt="Obtenga una copia de la liquidacion"><%= oCCHis.getComprobante()%></a>
                                    </td>
<%                              } else {
    %>
                                <td align="center"><%= oCCHis.getComprobante()%></td>
<%                              }
    %>
                                <td align="center"><%= (oCCHis.getTipoIngreso()==null?"&nbsp;":oCCHis.getTipoIngreso())%></td>
                                <td align="right"><%= Dbl.DbltoStr(oCCHis.getImpPrima(),2)  %></td>
                                <td align="right"><%= Dbl.DbltoStr(oCCHis.getImpPremio(),2)  %></td>
                                <td align="right"><%= Dbl.DbltoStr(oCCHis.getDebe(),2)%></td>
                                <td align="right"><%= Dbl.DbltoStr(oCCHis.getHaber(),2)%></td>
                            </tr>
<%
                              } //Ordene != 1 o 99
%>
                        </pg:item>
<%
                           } // for
                           } // if size
%>
                             <thead>
                                <th colspan="9">
                                    <pg:prev>
                                    <a class="rnavLink" href="<%= pageUrl %><%= sPath%>">[Anterior]</a>
                                    </pg:prev>
                                    <pg:pages>
                               <% if (pageNumber == currentPageNumber) { %>
                                    <b><%= pageNumber %></b>
                               <% } else { %>
                                    <a class="rnavLink" href="<%= pageUrl %><%= sPath %>"><%= pageNumber %></a>
                               <% } %>
                                    </pg:pages>
                                    <pg:next>
                                    <a class="rnavLink" href="<%= pageUrl %><%= sPath %>">[Siguiente]</a>
                                    </pg:next>
                                </th>
                            </thead>
                        </table>
                    </pg:pager>
                    </td>
               </tr>
<%
                           if (iSize  > 1 ){
%>

                <tr>
                    <td align="right"  >
                        <a href="#" onclick="Visualizar('PDF');"><img src='<%=Param.getAplicacion()%>images/PDF.gif' alt="Bajar datos a PDF" border='0'/></a>
                        &nbsp;&nbsp;&nbsp;
                        <a href="#" onclick="Visualizar('EXCEL');"><img src='<%=Param.getAplicacion()%>images/XLS.gif' alt="Exportar datos a Excel" border='0'/></a>
                        &nbsp;&nbsp;&nbsp;
                     </td>
                </tr>
<%
                           }
%>
            </table>
        </td>
    </tr>
<%  for (int i=0; i< lTotales.size(); i++) {
    %>
    <tr>
        <td class="subtitulo" align="left">&nbsp;&nbsp;&nbsp;<%= ((String) lTotales.get(i))%></td>
    </tr>
<%   }
    %>
    <tr>
        <td valign="top" align="center" >
            <table width="95%" border="0" align="center" cellspacing="0" cellpadding="0"  class="fondoForm1"  style="margin-top:5;margin-bottom:5;">
                <tr>
                    <td class="subtitulo" height="30" valign="middle" align="left"><span style="color:red">Importante:</span></td>
                </tr>
                <tr>
                    <td class="subtitulo" height="25" valign="middle"  align="left">&nbsp;&nbsp;-&nbsp;
                        <IMG height='16' width='16' alt="Visualizar certificado de Retención de Ing. Brutos y Serv. Sociales"
                             src="<%= Param.getAplicacion() %>images/certificado3.gif" border="0"  hspace="0" vspace="0"/>
                        &nbsp;&nbsp;Haga click en el icono para visualizar el certificado de retención
                    </td>
                </tr>
                <tr>
                    <td class="subtitulo" height="25" valign="middle"  align="left">&nbsp;&nbsp;-&nbsp;(*)&nbsp;&nbsp;Formas de cobro: Si la misma es "CO" puede solicitar una copia de liquidaci&oacute;n via mail&nbsp;
                        haciendo click en el n&uacute;mero de comprobante.
                    </td>
                </tr>   
                <tr>  
                    <td class="subtitulo" height="30" valign="middle"  align="left">(*)Referencia:</td>
                </tr>
<%
                for (int f=0; f < lFormaPago.size(); f++)  {
                    String formaPago = (String) lFormaPago.get(f);
%>
                <tr>
                    <td class="text"  align="left">&nbsp;&nbsp;&nbsp;<%=formaPago%></td>
                </tr>
<%
                }
%>
           </table>
        </td>
  </tr>
    <tr>
        <td valign="top" align="center" width="100%">
            <form name="form1" id="form1"method="POST" action="<%= Param.getAplicacion()%>servlet/CtaCteServlet">
                <input type="hidden" name="opcion" id="opcion" value="getCtasCtesHis"/>
                <input type="hidden" name="cc_pri" id="cc_pri" value="S"/>
                <input type="hidden" name="volver" id="volver" value='formCtaCte'/>
                <TABLE width="100%" border="0" align="center" cellspacing="0" cellpadding="0"  class="fondoForm1" style='margin-top:5;margin-bottom:5;'>
                    <tr>
                        <td align="center" >
                        <input type="button" name="cmdSalir"  value="  Salir  "  height="20px" class="boton" onClick="Salir ();">&nbsp;&nbsp;&nbsp;&nbsp;                        
                        <input type="button" name="cmdBuscar" value="  Volver  "  height="20px" class="boton" onClick="Buscar ();">
                        </td>
                    </tr>
                </TABLE>
            </form>
        </td>
    </tr>
   <tr>
        <td valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
   </tr>
</TABLE>
<script>
     CloseEspere();
</script>
</body>
</HTML>
