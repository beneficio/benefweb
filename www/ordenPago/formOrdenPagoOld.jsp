<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.OrdenPago"%>
<%@page import="com.business.beans.CtaCteFac"%>
<%@page import="com.business.beans.CtaCteHis"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Generico"%>
<%@page import="com.business.beans.OrdenPagoDet"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>
<%
    String urlExtranet = config.getServletContext().getInitParameter ("urlExtranet");
   
    Usuario usu = (Usuario) session.getAttribute("user");
    Usuario   oProd = (Usuario) request.getAttribute("productor");
    boolean bCuitValido = true;
    if (oProd != null ) {
        bCuitValido = oProd.getcuitValido(); 
    }
       
    String volver   = (String) request.getAttribute("volver"); 
    OrdenPago oP    = (OrdenPago) request.getAttribute("orden_pago");
    LinkedList <OrdenPagoDet> lDet = (LinkedList) request.getAttribute("orden_pago_det");
    LinkedList <CtaCteHis> lCtaCte = (LinkedList) request.getAttribute("ctactehis");

    CtaCteFac oUltFac = null;
    double totalNeto = 0;
    double totalIva  = 0;
    String minFecha = null;
    Date dMinFecha  = null;
    String maxFecha = Fecha.showFechaForm(new java.util.Date ());
    
    String fechaFactura  = "";
    Date dFechaFactura  = null;
    
    if ( oP.getNumSecuOp() == 0) { 
        oUltFac = (CtaCteFac) request.getAttribute("ult_fact_ctacte");
        if (oUltFac != null ) {
            oP.settipoFactura( oUltFac.gettipoComprob());
            if ( oUltFac.getFechaMov() != null) {
                minFecha = Fecha.showFechaForm(oUltFac.getFechaMov());
                dMinFecha = oUltFac.getFechaMov(); 
            }
        }
        
        
        if (usu.getfacturaElectronica() != null && ! usu.getfacturaElectronica().equals("")) { 
            oP.setmcaFacturaFisica(usu.getfacturaElectronica().equals("S") ? null : "X" );
        }
    } else {         
        fechaFactura = Fecha.showFechaForm(oP.getfechaFactura());
        dFechaFactura = oP.getfechaFactura();
        if (oP.getcodEstado() == 1 || oP.getcodEstado() == 5 ) {
            if ( ( oProd.getCodCondIVA() == 1 && oP.getimpIvaCierre() == 0 ) || 
                 ( oProd.getCodCondIVA() != 1 && oP.getimpIvaCierre() != 0 )  ) { 
                if (oProd.getCodCondIVA() == 1) {
                    oP.setimpIvaCierre(oP.getimpNeto() * 0.21 );
                    oP.setimpFactura(oP.getimpNeto() + oP.getimpIvaCierre());
                } else { 
                    oP.setimpIvaCierre( 0 );
                    oP.setimpFactura(oP.getimpNeto());
                }                  
            }
        }
    }

    if (oP.gettipoFactura() == null || oP.gettipoFactura().equals("")) { 
        if (oProd.getCodCondIVA() == 1)
           oP.settipoFactura("FA");
        else 
           oP.settipoFactura("FC");
    }

    String readonly = "";
    if ( (usu.getiCodTipoUsuario() == 1 && oP.getcodEstado() != 0) || 
         (usu.getiCodTipoUsuario() == 0 && oP.getcodEstado() == 3) ) {   
        readonly  = "readonly";
    }
    %>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>BENEFICIO S.A. - Formulario de Orden de Pago</title>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos-cot.css"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/tablasNew.css"/>

<!-- libreria jquery desde el cdn de google o fallback local -->
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>script/jquery-ui-1.10.3/themes/base/jquery.ui.all.css"/>
    <script src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
    <script src="<%= Param.getAplicacion()%>portal/js/vendor/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/chosen.jquery.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/prism.js" charset="utf-8"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/jquery-ui-1.10.3/ui/jquery.ui.core.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/jquery-ui-1.10.3/ui/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/jquery-ui-1.10.3/ui/jquery.ui.datepicker.js"></script>
<!--[if lt IE 9]>
	<script src="https://css3-mediaqueries-js.googlecode.com/svn/trunk/css3-mediaqueries.js"></script>
<![endif]-->

<script type="text/javascript">
    var volver   = "<%= volver %>";
    var usuarios = ["JGIL","JCENTENO","VSNEIBRUN","VNERONI","VERONICA" ];
 
    $(function(){
   //     if(!Modernizr.inputtypes.date) {
            $.datepicker.regional['es'] = { 
            closeText: 'Cerrar', 
            prevText: '<Ant', 
            nextText: 'Sig>', 
            currentText: 'Hoy', 
            monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'], 
            monthNamesShort: ['Ene','Feb','Mar','Abr', 'May','Jun','Jul','Ago','Sep', 'Oct','Nov','Dic'], 
            dayNames: ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'], 
            dayNamesShort: ['Dom','Lun','Mar','Mié','Juv','Vie','Sáb'], 
            dayNamesMin: ['Do','Lu','Ma','Mi','Ju','Vi','Sá'], 
            weekHeader: 'Sm', 
            dateFormat: 'dd/mm/yy', 
            firstDay: 1, 
            isRTL: false, 
            showMonthAfterYear: false, 
            yearSuffix: '' }; 

        $.datepicker.setDefaults($.datepicker.regional['es']);

        $(function () { $("#fecha_factura").datepicker();  
            
            $( "#fecha_factura" ).datepicker( "setDate", "<%= fechaFactura %>" );
            $( "#fecha_factura" ).datepicker( "option", "minDate", "<%= minFecha == null ? "" : minFecha %>" );                
            $( "#fecha_factura" ).datepicker( "option", "maxDate", "<%= maxFecha %>" );                

            if ( "<%= readonly %>"  === "readonly") {
                    $( "#fecha_factura" ).datepicker( "option", "disabled", true );
                }

            });
    });


    $(document).ready(function(){

            $("#tipo_factura").change (function () {
    // A o M responsable inscripto - C monotributo 
    
                var tipo_fac = $('#tipo_factura').val();
                var totalNeto = parseFloat ($('#total_neto').val());
                var impIva    = parseFloat ($('#total_iva').val());
                var totalBruto = parseFloat ($('#total_factura').val());
                var porcIva = 0;
    
                if ( tipo_fac === "FA" || tipo_fac === "FM") { 
                    porcIva = 21;
                } 
                
                if ( (porcIva > 0 && impIva === 0) || 
                     (porcIva === 0 && impIva > 0) ) {
                 
                    impIva  = Math.round ( ((totalNeto * porcIva ) / 100) * 100 ) / 100  ;
                    totalBruto = (impIva + totalNeto) * 100 / 100;
                    $('#td_total_iva').text ( String (impIva) );
                    $('#td_total_factura').text ( String (totalBruto) );
                    $('#total_iva').val(String(impIva));
                    $('#total_factura').val(String ( totalBruto));
                }   
            });

            $("#num_factura").change (function () {
                $('#mensaje_error').text("") ;
                $('#mensaje_error3').text("") ;
                
                var numFactura = parseInt ($("#num_factura").val());
                if (isNaN (numFactura)) { 
                    numFactura = 0;
                }

                if (numFactura === 0) { 
                    $('#mensaje_error').text("- ERROR: Ingrese el Numero de factura") ;
                    $('#mensaje_error3').text("Ingrese el Numero de factura") ;
                    $('#num_factura').focus();
                    return false;
                } 
            });

            $("#salir").click(function(){
                 var codProd = $("#cod_prod").val();

                 if ( volver === "ctactefa" ) { 
                     $(location).attr("href","<%= Param.getAplicacion()%>servlet/CtaCteServlet?opcion=getCtaCteFac&cod_prod=" + codProd) ;
                 } else {  
                    history.back();
                    return false;        
                 }
            });

    });
    

</script>
</head>

<!--[if IE 7]>         <body class="ie ie7 oldie"> <![endif]-->
<!--[if IE 8]>         <body class="ie ie8"> <![endif]-->
<!--[if IE 9]>         <body class="ie ie9"> <![endif]-->
<!--[if gt IE 9]><!--> <body>         <!--<![endif]-->

<!--[if lt IE 7]><div class="browser_old" id="aviso">Â¡Tu navegador es muy viejo! <a href="http://browsehappy.com/?locale=es" target="_blank">Actualizalo a uno mÃ¡s moderno</a> para tener una mejor experiencia y velocidad en la aplicacion.
<a href="#" class="close_message" title="cerrar aviso" onclick="document.getElementById('aviso').style.display='none';return false"></a>
</div><![endif]-->

<div class="wrapper">

    <!-- container -->
    <div class="container">

        <jsp:include page="/header.jsp">
            <jsp:param name="aplicacion" value="<%= Param.getAplicacion() %>" />
            <jsp:param name="usuario" value="<%= usu.getusuario() %>" />
            <jsp:param name="descripcion" value="<%= usu.getRazonSoc() %>" />
        </jsp:include>
        <div class="menu">
            <menu:renderMenuFromDB    aplicacion="1"  userLogon="<%= usu.getusuario()%>" />
        </div>
                  
         <h1 class="title-section hcotizadores">Formulario de ingreso de Factura Web</h1>

         <!-- tabs -->

        <div class="tabs-container">
        <form action="<%= Param.getAplicacion()%>servlet/OrdenPagoServlet" method="post"
            enctype="multipart/form-data" name="form1" id="form1" >
            <input type="hidden" name="opcion"      id="opcion"    value="uploadOP"/>
            <input type="hidden" name="volver"      id="volver"    value="<%= request.getParameter ("volver") %>"/>
            <input type="hidden" name="usuario"     id="usuario"   value="<%= usu.getusuario() %>"/>
            <input type="hidden" name="num_secu_op" id="num_secu_op" value="<%= oP.getNumSecuOp() %>"/>
            <input type="hidden" name="tipo_usuario"   id="tipo_usuario"   value="<%= usu.getiCodTipoUsuario() %>"/>
            <input type="hidden" name="cod_prod_dc"   id="cod_prod_dc" value="<%= oProd.getsCodProdDC() %>"/>
            <input type="hidden" name="tipo_orden"   id="tipo_orden" value="<%= oP.gettipoOrden() %>"/>            
            <input type="hidden" name="ult_suc_cc"   id="ult_suc_cc" value="<%= (oUltFac == null ? "" :  oUltFac.getnumComprob1()) %>"/>                        
            <input type="hidden" name="ult_fac_cc"   id="ult_fac_cc" value="<%= (oUltFac == null ? "" :  oUltFac.getnumComprob2()) %>"/>                        
            <input type="hidden" name="cant_item"   id="cant_item" value="<%= lDet.size() %>"/>                        
            <input type="hidden" name="total_neto"  id="total_neto"      value="<%= oP.getimpNeto() %>"/>  
            <input type="hidden" name="total_iva_cierre"  id="total_iva_cierre" value="<%= oP.getimpIvaCierre()%>"/>  
            <input type="hidden" name="total_iva"   id="total_iva"       value="<%= oP.getimpIvaCierre() %>"/>                        
            <input type="hidden" name="total_factura" id="total_factura" value="<%= oP.getimpFactura() %>"/>
            <input type="hidden" name="cuit_valido" id="cuit_valido" value="<%= (bCuitValido == true ? "S" : "N" ) %>"/>
            <input type="hidden" name="nom_archivo" id="nom_archivo" value="<%= oP.getnomArchivoFactura() == null ? "" : oP.getnomArchivoFactura() %>"/>
            <input type="hidden" name="cod_prod" id="cod_prod" value="<%= ( oP.getCodProd() == 0 ? oP.getCodOrg() : oP.getCodProd()) %>"/>
             <input type="hidden" name="factura_elect_prod" id="factura_elect_prod" value="<%= (usu.getfacturaElectronica() == null ? "": usu.getfacturaElectronica()) %>"/>
            <input type="hidden" name="readonly" id="readonly" value="<%= readonly %>"/> 
            <input type="hidden" name="existe_factura" id="existe_factura" value="-1"/> 

            <!-- -->
            <div id="tab1" class="tab-content form">
                
            <div class="form-wrap">
<%          if (oProd != null && bCuitValido == false) { 
    %>                
            <div class="form-file">    
                <div class="wrap-elements w100">
                    <span id="mensaje_error0" class="error-message">
                        IMPORTANTE:&nbsp;Usted podr&aacute; ingresar la orden de pago desde aqu&iacute; pero la misma permanecer&aacute; pendiente 
                        hasta que regularice la situaci&oacute;n de su CUIT con AFIP 
                    </span>
                </div>
            </div>           
<%          } 
            if (oP.getcodEstado() == 9 ) {
    %>                  
            <div class="form-file">    
                <div class="wrap-elements w100">
                    <span id="mensaje_error0" class="error-message">
                        ORDEN DE PAGO ANULADA 
                    </span>
                </div>
            </div>           
<%          }
    %>
                  
    
            <div class="form-file">
                <div class="wrap-elements w50">
                    <label for="beneficiario">Beneficiario:&nbsp;</label>
                    <input id="beneficiario" name="beneficiario" type="text" value="<%= oP.getbeneficiario() %>" <%= readonly %> tabindex="2" />
                    <span id="mensaje_error1" class="error-message"></span>                    
                </div>
                <div class="wrap-elements w50">
                    <label for="cuit_benef">Cuit:&nbsp;</label>
                    <input id="cuit_benef" name="cuit_benef" type="text" maxlength="50"  placeholder="Cuit" 
                           value="<%= oP.getcuit() %>"  readonly tabindex="3" />
                    <span id="mensaje_error2" class="error-message"></span>
                </div>
            </div>
            <div class="form-file">
                <div class="wrap-elements w25">
                    <label for="tipo_factura">Comprobante:&nbsp;</label>
                    <select class="select" id="tipo_factura" name="tipo_factura" tabindex="4"  <%= readonly %> >  
                        <option value=""   <%= oP.gettipoFactura().equals("")   ? "selected  class=\"selected\"" : "" %> >Seleccione </option>
                        <option value="FA" <%= oP.gettipoFactura().equals("FA") ? "selected  class=\"selected\"" : "" %>>Factura A&nbsp;</option>
                        <option value="FC" <%= oP.gettipoFactura().equals("FC") ? "selected  class=\"selected\"" : "" %>>Factura C&nbsp;</option>
                        <option value="RE" <%= oP.gettipoFactura().equals("RE") ? "selected  class=\"selected\"" : "" %>>Recibo&nbsp;</option>
                    </select>
                <span id="mensaje_error3" class="error-message"></span>
                </div>
                <div class="wrap-elements w10">
                    <label for="num_suc">Nro.</label>
                    <input id="num_suc" name="num_suc"  value="<%= oP.getnumSuc() %>"  size="4" maxlength="4" tabindex="5" align="right" 
                           onKeyPress="return Mascara('D',event);"  <%= readonly %>  />
                </div>
                <div class="wrap-elements w15">
                    <label for="num_factura">Comprobante</label>
                    <input id="num_factura" name="num_factura"  value="<%= oP.getnumFactura()%>" size="8" maxlength="7" tabindex="6"
                           onKeyPress="return Mascara('D',event);"   <%= readonly %> /> 
                </div>
                
                <div class="wrap-elements w50">
                    <label for="fecha_factura">Fecha factura:&nbsp;</label>
                    <input type="text" id="fecha_factura" name="fecha_factura" value="<%= (fechaFactura == null ? "" : fechaFactura) %>"   
                           size="10" tabindex="7"  <%= readonly %>  /> 
                    <span id="mensaje_error1" class="error-message"></span>                    
                </div>
            </div>
            <div class="form-file">                    
                <div class="wrap-elements w100">
                    <span id="mensaje_error4" class="error-message"></span>
                </div>
            </div>
            <div class="form-file">   
                <table class="width200">
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Periodo</th>
                        <th>Concepto</th>
                        <th>Importe</th>
                    </tr>
                    </thead>
                    <tbody>
<%                  double totalOP = 0;
                    double maxOP   = 0; 
                    double saldoFinal = 0;
                    for (int i=0;i<lDet.size();i++) { 
                    OrdenPagoDet opDet = (OrdenPagoDet) lDet.get(i); 
                    double totalOPDet  = opDet.getimpNeto();
                    double maxOPDet    = opDet.getimpNeto();
System.out.println ("loop exterior -------------------------------");
System.out.println ("totalOPDet --> " + totalOPDet);
System.out.println ("maxOPDet --> " + maxOPDet);


    %>
                    <tr>
                        <td><%= opDet.getnumItem() %></td>
                        <td class="left"><%= opDet.getanioMes() %></td>                        
                        <td class="left"><%= opDet.getitem() %>
                           <br>
<%                  if (lCtaCte != null && lCtaCte.size() > 0) {
    %>                         
                            <table style="border: 0;width: 100%;">
                                <tbody>
<%                      for (int ii=0;ii<lCtaCte.size();ii++) { 
                            CtaCteHis oCC = (CtaCteHis) lCtaCte.get(ii);
                            if (oCC.getAnioMes() == opDet.getanioMes() ) {
                                if (oCC.getOrdene() == 9 ) { 
                                    saldoFinal = oCC.getImporte();
                                } else {
                                    totalOPDet = (totalOPDet + oCC.getImporte()) * 100 / 100;
                                    if (oCC.getOrdene() > 1 &&  ! oCC.getConcepto().startsWith("PAGO COMISION")) { 
                                        maxOPDet = Math.round( (maxOPDet + oCC.getImporte()) * 100) / 100;
                                    }
                                }
                                
    %>
                                    <tr>
                                        <td style="width: 10%;font-size: small;text-align: left;"><%= Fecha.showFechaForm ( oCC.getFechaMov() )%></td>                                        
                                        <td style="width: 60%;font-size: small;text-align: left;"><%= oCC.getMovimiento() %>&nbsp;-&nbsp;<%= oCC.getConcepto()%></td>
                                        <td style="width: 30%;font-size: small;font-style: italic;font-weight: bold;text-align: right;"><%= Dbl.DbltoStr(oCC.getImporte(),2)%></td>
                                    </tr>
<%                          }
                            
System.out.println ("---------------------- loop interior -----------------------");
System.out.println ("oCC.getConcepto() -->" + oCC.getConcepto());
System.out.println ("saldoFinal --> " + saldoFinal);
System.out.println ("totalOPDet --> " + totalOPDet);
System.out.println ("maxOPDet --> " + maxOPDet);
                        }
                        
                                if ( oP.getcodEstado() != 3 ) { 
    %>
                                    <tr>
                                        <td >&nbsp;</td>
                                        <td style="font-size: small;font-style: italic;font-weight: bold; text-align: right;">Total de la Orden de Pago del periodo</td>
                                        <td style="font-size: small;font-style: italic;font-weight: bold; text-align: right;"><%= Dbl.DbltoStr(totalOPDet,2)%></td>
                                    </tr>
<%                              }
    %>
                                </tbody>
                            </table>

<%                      totalOP = Math.round( (totalOP + totalOPDet) * 100) / 100;
                        maxOP   = Math.round((maxOP + maxOPDet) * 100) / 100;
                    } 
    %>

                        </td>
                        <td class="right"><%= Dbl.DbltoStrPadRight (opDet.getimpNeto() , 2, 9)%></td>
                    </tr>
                    <input type="hidden" name="aniomes_<%= opDet.getnumItem() %>" id="aniomes_<%= opDet.getnumItem() %>" value="<%= opDet.getanioMes() %>"/>
                    <input type="hidden" name="codproddc_<%= opDet.getnumItem() %>" id="codproddc_<%= opDet.getnumItem() %>" value="<%= opDet.getcodProdDC()%>"/>
                    <input type="hidden" name="impneto_<%= opDet.getnumItem() %>" id="impneto_<%= opDet.getnumItem() %>" value="<%= Dbl.DbltoStr(opDet.getimpNeto(),2) %>"/>
                    <input type="hidden" name="impOP_<%= opDet.getnumItem() %>" id="impOP_<%= opDet.getnumItem() %>" value="<%= Dbl.DbltoStr(totalOPDet,2) %>">
<%              }
                if (oP.getimpOrdenPago() == 0) {
                    if (totalOP > maxOP) {
                        totalOP = maxOP;
                    }
                    if (totalOP > saldoFinal ) {
                        totalOP = saldoFinal; 
                    }
                    oP.setimpOrdenPago(totalOP);
               }   
                System.out.println ("FUERA DEL LOOP maxOP --> " + maxOP + " - saldoFinal -->" + saldoFinal);                                                                 
                System.out.println ("FUERA DEL LOOP totalOP --> " + totalOP + " - IMPORTE NETO -->" + oP.getimpOrdenPago());                                             
                System.out.println ("oP.getimpOrdenPago() --> " + oP.getimpOrdenPago());
    %>
                   </tbody>
                    <tfoot>
                        <tr>
                            <th colspan="3" align="right">Total Neto de comisiones:</th>
                            <th><%= Dbl.DbltoStrPadRight (oP.getimpNeto() , 2, 9)%></th>
                        </tr>
<%              if ( usu.getiCodTipoUsuario() == 0 ) {
    
    System.out.println ("Total Neto Orden de Pago -->" + oP.getimpOrdenPago());
    
    %>
                        <tr>
                            <th colspan="3" align="right">Total Neto Orden de Pago:</th>
                            <th><%= Dbl.DbltoStrPadRight (oP.getimpOrdenPago() , 2, 9)%></th>
                        </tr>
<%              }
    %>
                        <tr>
                            <th colspan="3" align="right">Iva:</th>
                            <th id="td_total_iva"><%= Dbl.DbltoStrPadRight(oP.getimpIvaCierre(),2,9) %></th>
                        </tr>
                         <tr>
                            <th colspan="3">Total Factura:</th>
                            <th id="td_total_factura"><%= Dbl.DbltoStrPadRight(oP.getimpFactura(),2,9) %></th>
                         </tr>
                     </tfoot>                        
                </table>
            </div>
            <div class="form-file">                         
                <div class="wrap-elements w100">
                    <label for="factura_electronica">Usted esta adherido a factura electr&oacute;nica ? 
                        SI&nbsp;<input type="radio"  name="factura_electronica"   id="factura_electronica_S"  value="S" tabindex="14" 
                                       <%= oP.getmcaFacturaFisica() == null ? "checked" : "" %>  <%= readonly.equals("") ? "" : "disabled" %> />&nbsp;&nbsp;NO
                    <input type="radio"  name="factura_electronica"   id="factura_electronica_N"  value="N" tabindex="15" 
                                       <%= oP.getmcaFacturaFisica() == null ? " " : "checked" %>  <%= readonly.equals("") ? "" : "disabled" %> />
                    </label>
                    <span id="mensaje_error5" class="error-message"></span>
                </div>
            </div>
            <div class="form-file">                    
                <div class="wrap-elements w100">
<%              if ( oP.getnomArchivoFactura() != null && ( usu.getiCodTipoUsuario() == 0  || 
                     ( usu.getiCodTipoUsuario() == 1 && oP.getcodEstado() != 0 ) )  ) { 
    %>                  
                <iframe src="<%= Param.getAplicacion()%>files/factura/<%= oP.getnomArchivoFactura() %>" width="900" height="400">
                </iframe>
<%              } 
                if ( ( usu.getiCodTipoUsuario() == 1 && oP.getcodEstado() == 0 ) ||
                     ( usu.getiCodTipoUsuario() == 0 && oP.getcodEstado() != 3) )   {
    %>
                <label for="file">Adjuntar factura
                    &nbsp;<input type="file"  name= "FILE1"   id="FILE1"  value=" Adjunte la factura en formato pdf" tabindex="16"/>
                </label>
<%              }
    %>
                </div>
            </div>
            <div class="form-file">
                 <span id="mensaje_error" class="validation-message">&nbsp;</span>  
            </div>

            <!-- button section -->
            <div class="form-file button-container">
                <input type="button" name="salir" id="salir" value="Volver" class="bt exit" /> 
<%          if ( ( usu.getiCodTipoUsuario() != 0 && oP.getcodEstado() == 0) || 
                 ( usu.getiCodTipoUsuario() == 0 && oP.getcodEstado() != 3)) {
                    if ( oP.getcodEstado() != 9 ) { 
    %>             
                <input type="button" name="enviar" id="enviar" value="Enviar" class="bt next" onclick="Ir ('uploadOP');" />
<%                  }
            }
    %>
            </div>
             <!--! button section -->
            </div>   
             
            </div>
            <input type="hidden" name="total_op"  id="total_op" value="<%= oP.getimpOrdenPago() %>"/>  
                
            </form>
        </div>

        <!--! tabs -->
            <jsp:include flush="true" page="/bottom.jsp"/>
    </div>
<!--! container -->
</div> <!--! wrapper -->
<script language="javascript">
  
    if ($("#readonly").val() === "readonly") {
        $( "#fecha_factura" ).datepicker( "option", "disabled", true );
    }

    if ($("#readonly").val() === "readonly"  || $("#tipo_usuario").val() === "1" ) {
        $("#tipo_factura").attr("readOnly", "true");
    }     
        
        
   function Validar () {
    var numFactura   = parseInt ($('#num_factura').val ());
    var numSuc       = parseInt ($('#num_suc').val ());
    var totalOP      = parseFloat ($('#total_op').val ());  
    var numSecuOp    = parseInt ($('#num_secu_op').val ());
    
    if (isNaN(numFactura)) numFactura = 0;
    if (isNaN(numSuc)) numSuc = 0;

    $('#mensaje_error').text("") ;
    $('#mensaje_error2').text("") ;
    $('#mensaje_error3').text("") ;    
    $('#mensaje_error4').text("") ;
    $('#mensaje_error5').text("") ;

    if ($('#tipo_usuario').val() === "0" && $.inArray ($("#usuario").val(), usuarios) === -1) {
        $('#mensaje_error').text("- ERROR: USUARIO NO HABILITADO ") ;
        return false;
    } 
    
    if (  $('#beneficiario').val() === "" ) {
        $('#mensaje_error').text("- ERROR: debe ingresar el beneficiario") ;
        $('#mensaje_error1').text("Ingrese beneficiario") ;
        $('#beneficiario').focus();
        return false;
    }
    
    var cuit = Trim($('#cuit_benef').val());
    
    if ( cuit === ""  ) {
        $('#mensaje_error').text("- ERROR: cuit invalido") ;
        $('#mensaje_error2').text("Cuit invalido") ;
        $('#cuit_benef').focus();
        return false;
    }

    if (  ! ValidoCuit (cuit)  ) {
        $('#mensaje_error').text("- ERROR: cuit invalido") ;
        $('#mensaje_error2').text("Cuit invalido") ;
        $('#cuit_benef').focus();
        return false;
    }

    if ( $('#tipo_factura').val() === ""  ) {
        $('#mensaje_error').text("- ERROR: Tipo de factura invalido") ;
        $('#mensaje_error3').text("Tipo de factura invalida") ;
        $('#tipo_factura').focus();
        return false;
    }
    if ( numSuc === 0 ) {
        $('#mensaje_error').text("- ERROR: Sucursal invalido") ;
        $('#mensaje_error3').text("Numero de Sucursal invalido") ;
        $('#num_suc').focus();
        return false;
    }

    if ( numFactura === 0 ) {
        $('#mensaje_error').text("- ERROR: Ingrese el Numero de factura") ;
        $('#mensaje_error3').text("Ingrese el Numero de factura") ;
        $('#num_factura').focus();
        return false;
    }
    
   
    var url = "<%= Param.getAplicacion()%>rest/opService/existeFactura/";
 
    var retorno = -1;
    
    $.ajax({
            url : url,
            type : "GET",
            data : {
                num_comprob1 : numSuc,
                num_comprob2 : numFactura,
                cuit : cuit,
                usuario : $('#usuario').val()
            },
            dataType : "json",
            async: false,             
            success : function(data) {
                $(data).each(function(index, occ ) {
                    retorno = occ.iNumError;
                });
               },
            error: function (error) {
               alert('error: ' + error);
            }
          });
          
    if ( retorno !== numSecuOp && retorno !== -100 ) {
  //      if ( confirm ("El comprobante ya existe, haga clic en Aceptar si continua o Cancelar para corregir ") === false) {
  //          $('#num_factura').focus();
  //          return false;
  //      }
        $('#mensaje_error').text("- ERROR: La factura ya existe para el mismo CUIT") ;
        $('#mensaje_error3').text("La factura ya existe para el mismo CUIT") ;
        $('#num_factura').focus();
        return false;
        
    }

//    $.getJSON(url, function(data){
//            $(data).each(function(index, occ ) {
//                $('#existe_factura').val(occ.iNumError);
//            });

//        if ( parseInt ( $('#existe_factura').val()) !== numSecuOp && 
//             parseInt ( $('#existe_factura').val()) !== -100 ) {
//            if ( confirm ("El comprobante ya existe, haga clic en Aceptar si continua o Cancelar para corregir ") === false) {
//                $('#num_factura').focus();
//                return false;
//            }
//        }
//    });    
    
   if ( $('#fecha_factura').val () === "" ) {
        $('#mensaje_error').text("- ERROR: FECHA FACTURA VACIA") ;
        $('#mensaje_error4').text("Ingrese la fecha de factura") ;
        $('#fecha_factura').focus();
        return false;
    }
 
    var minDate  = $("#fecha_factura").datepicker( "option", "minDate" );
    var maxDate  = $("#fecha_factura").datepicker( "option", "maxDate" );
    var fechaFac = $("#fecha_factura").datepicker("getDate");
 
    if ($("#fecha_factura").datepicker("getDate") < $.datepicker.parseDate('dd/mm/yy', minDate)) {
        $('#mensaje_error').text("- ERROR: FECHA FACTURA MENOR QUE FECHA DE ULTIMA FACTURA") ;
        $('#mensaje_error4').text("Ingrese fecha de factura mayor a " + minDate) ;
        $('#fecha_factura').focus();
        return false;
    }    
    if ($("#fecha_factura").datepicker("getDate") > $.datepicker.parseDate('dd/mm/yy', maxDate)) {
        $('#mensaje_error').text("- ERROR: FECHA FACTURA MAYOR  QUE FECHA DEL DIA") ;
        $('#mensaje_error4').text("Ingrese fecha de factura menor o igual a " + maxDate) ;
        $('#fecha_factura').focus();
        return false;
    }    

    if( $("input[name='factura_electronica']:radio").is(':checked') === false ) {
        $('#mensaje_error').text("- ERROR: seleccione si usted tiene factura eletrónica") ;
        $('#mensaje_error5').text("Seleccione si tiene factura eletrónica") ;
        $('#factura_electronica_S').focus();
        return false;
    } else {
        var fact = $('input:radio[name=factura_electronica]:checked').val();
        var factProd = $('#factura_elect_prod').val();
        
        if (factProd !== "" && factProd === "S" && fact === "N") {
            $('#mensaje_error').text("- ALERTA: verifique si es correcto que usted no tiene factura electronica");
        }
    }

    if ( $('#FILE1').val () === "" && $('#tipo_usuario').val () !== "0" ) {
        $('#mensaje_error').text("- ERROR: Ingrese la factura en formato PDF o JPG") ;
        $('#FILE1').focus();
        return false;
    }
    
    if ( totalOP < 0  && $('#tipo_usuario').val () === "0" ) {
        $('#total_op').val ("0");
//        $('#mensaje_error').text("- ERROR: LA ORDEN DE PAGO NO PUEDE SER NEGATIVA ") ;
//        return false;
    }
    return true;
   } 

  function Ir (sigte) {

    document.getElementById("form1").enctype = "multipart/form-data";
    
    if (Validar () ) {
            document.form1.submit();
            return true;
    }  else  return false;
  }

</script>

</body>
</html>
