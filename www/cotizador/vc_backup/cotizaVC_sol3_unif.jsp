<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Producto"%>
<%@page import="com.business.beans.Cotizacion"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Generico"%>
<%@page import="com.business.beans.CotizadorSumas"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>
<%
     Usuario usu = (Usuario) session.getAttribute("user");
     Cotizacion oCot = (Cotizacion) request.getAttribute("cotizacion");
     Producto   oProd = (Producto) request.getAttribute("producto");
    %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>BENEFICIO S.A. - Cotizador Vida Colectivo</title>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos-cot.css" media="screen"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"  media="screen"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/print_cotizador.css"  media="print"/>

<!-- libreria jquery desde el cdn de google o fallback local -->

    <script src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
    <script src="<%= Param.getAplicacion()%>portal/js/vendor/jquery-1.8.0.min.js"></script>
    <script src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<!--[if lt IE 9]>
	<script src="http://css3-mediaqueries-js.googlecode.com/svn/trunk/css3-mediaqueries.js"></script>
<![endif]-->

<script type="text/javascript">

    function overlay() {
            el = document.getElementById("overlay");
            el.style.visibility = (el.style.visibility == "visible") ? "hidden" : "visible";
            el = document.getElementById("dest").focus();
    }
    function Ir (sigte) {
        document.getElementById("siguiente").value = sigte;
        document.form1.submit();
    }

    function Recotizar () {

        var prima      =  parseFloat ($('#IMP_PRIMA').val());
        var primaOrig  =  parseFloat ($('#IMP_PRIMA_ORIG').val());
        var premio     =  parseFloat ($('#IMP_PREMIO').val());
        var premioOrig =  parseFloat ($('#IMP_PREMIO_ORIG').val());
        var comision   =  parseFloat ($('#COMISION').val());
        var comisionOrig  =  parseFloat ($('#COMISION_ORIG').val());

        if ( premio == premioOrig && comision  == comisionOrig) {
            $('#mensaje_error').text("- ERROR: Para recotizar modifique Premio o Comisión. ") ;
            $('#IMP_PREMIO').focus();
            return false;
        }

        if ( premio != premioOrig &&
             comision  != comisionOrig) {
            $('#mensaje_error').text("- ERROR: solo puede ajustar Premio O Comisión, no ambos ") ;
            $('#IMP_PREMIO').val($('#IMP_PREMIO_ORIG').val());
            $('#COMISION').val($('#COMISION_ORIG').val());
            $('#IMP_PREMIO').focus();
            return false;
        }

        var cotiz = $('#num_cotizacion').val();
        // Hacemos un request AJAX para pedir los datos de paises.
        // Esperamos recibir la respuesta en formato JSON.
        var url = "<%= Param.getAplicacion()%>rest/cotizaService/recotizarVC/?num_cotizacion=" + cotiz +
                  "&premio=" + premio + "&premio_orig=" + premioOrig +
                  "&prima=" + prima + "&prima_orig=" + primaOrig +
                  "&comision=" + comision + "&comision_orig=" + comisionOrig;

        $.getJSON(url, function(data){
                $(data).each(function(index, oCot ) {
                    if (oCot.iNumError == 0 ) {
                        $('input[name=IMP_PRIMA]').attr('value', oCot.primaTar );
                        $('input[name=IMP_PREMIO]').attr('value',oCot.premio );
                        $('input[name=COMISION]').attr('value', oCot.gastosAdquisicion );
                    } else {
                        $('#mensaje_error').text("- ERROR: el ajuste supera el máximo permitido para la tasa de prima del producto ") ;
                    }
                });
        });

    }

</script>
</head>

<!--[if IE 7]>         <body class="ie ie7 oldie"> <![endif]-->
<!--[if IE 8]>         <body class="ie ie8"> <![endif]-->
<!--[if IE 9]>         <body class="ie ie9"> <![endif]-->
<!--[if gt IE 9]><!--> <body>         <!--<![endif]-->

<!--[if lt IE 7]><div class="browser_old" id="aviso">Â¡Tu navegador es muy viejo! <a href="http://browsehappy.com/?locale=es" target="_blank">Actualizalo a uno mÃ¡s moderno</a> para tener una mejor experiencia y velocidad en la aplicaciÃ³n.
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

         <img class="bnf_logo_print" src="<%= Param.getAplicacion() %>images/logo_beneficio_new.jpg" alt="bnflogo" />
         <h1 class="title-section hcotizadores">cotizador de vida colectivo</h1>

         <!-- tabs -->

         <div class="tabs-container">

        <form name="form1" id="form1" method="post"  action="<%= Param.getAplicacion()%>servlet/CotizadorVCServlet">
                <input type="hidden" name="opcion"      id="opcion"     value="cotizador"/>
                <input type="hidden" name="siguiente"     id="siguiente"  value="solapa3"/>
                <input type="hidden" name="origen"        id="origen"     value="solapa3"/>
                <input type="hidden"   name="COD_RAMA"    id="COD_RAMA"   value="<%= oCot.getcodRama() %>"/>
                <input type="hidden"   name="COD_SUB_RAMA"id="COD_SUB_RAMA"    value="<%= oCot.getcodSubRama() %>"/>
                <input type="hidden"   name="COD_PRODUCTO"  id="COD_PRODUCTO"  value="<%= oCot.getcodProducto() %>"/>
                <input type="hidden"   name="COD_PROVINCIA" id="COD_PROVINCIA" value="<%= oCot.getcodProvincia() %>"/>
                <input type="hidden"   name="COD_VIGENCIA"  id="COD_VIGENCIA"  value="<%= oCot.getcodVigencia() %>"/>
                <input type="hidden"   name="TOMADOR_APE"   id="TOMADOR_APE"   value="<%= oCot.gettomadorApe() %>"/>
                <input type="hidden"   name="COD_PROD"   id="COD_PROD"   value="<%= oCot.getcodProd() %>"/>
                <input type="hidden" name="usuario"     id="usuario"   value="<%= usu.getusuario() %>"/>
                <input type="hidden" name="num_cotizacion" id="num_cotizacion"   value="<%= oCot.getnumCotizacion() %>"/>
                <input type="hidden" name="MUERTE_ACCIDENTAL" value="<%= (oCot.getmcaMuerteAccidental() == null ? "" :
                                                                          oCot.getmcaMuerteAccidental()) %>"/>
                <input type="hidden" name="IMP_PRIMA_ORIG" id="IMP_PRIMA_ORIG" value="<%= oCot.getprimaTar() %>"/>
                <input type="hidden" name="IMP_PREMIO_ORIG" id="IMP_PREMIO_ORIG" value="<%= oCot.getpremio() %>"/>
                <input type="hidden" name="COMISION_ORIG" id="COMISION_ORIG" value="<%= oCot.getgastosAdquisicion() %>"/>

                <ul class="tabs">
                <li><span class="step">1</span><a href="#" onclick="Ir ('solapa1');" title="datos generales">Datos Generales</a></li>
                <li><span class="step">2</span><a href="#" onclick="Ir ('solapa2');" title="datos de asegurados">Datos de Asegurados</a></li>
                <li class="active"><span class="step">3</span><a href="#" title="cotizacion" class="last">Cotizaci&oacute;n</a></li>
            </ul>

            <!-- -->
            <div id="tab2" class="tab-content form">
            	 <span class="anchor" id="top"></span>
            <div class="form-wrap">

            <div class="form-file">
                 <div class="wrap-elements w20">
                    <span class="item">Cotizado por:</span>
                    <span class="item">Provincia riesgo:</span>
                 </div>
                 <div class="wrap-elements w30">
                     <span class="item-result"><%= oCot.getdescProd() %>&nbsp;(<%= oCot.getcodProd() %>)</span>
                    <span class="item-result"><%= oCot.getdescProvincia() %></span>
                 </div>
                 <div class="wrap-elements w20">
                 	<span class="item">Cliente:</span>
                 </div>
                 <div class="wrap-elements w30">
                 	<span class="item-result"><%= oCot.gettomadorApe()  %></span>
                 </div>
            </div>

            <div class="form-file">
                 <div class="wrap-elements w20">
                    <span class="item">Subrama:</span>
                    <span class="item">Vigencia:</span>
                 </div>
                 <div class="wrap-elements w30">
                 	<span class="item-result"><%= oCot.getdescSubRama() %></span>
                    <span class="item-result"><%= oCot.getdescVigencia() %></span>
                 </div>
                 <div class="wrap-elements w20">
                     <span class="item">Producto:</span>
                     <span class="item">Asegurados:</span>
                 </div>
                 <div class="wrap-elements w30">
                 	<span class="item-result"><%= oCot.getdescProducto()  %></span>
                        <span class="item-result"><%= oCot.getcantPersonas() %></span>
                 </div>
            </div>


            <!-- Table markup-->
            <table width="100%" cellpadding="10" cellspacing="0" id="table-results" class="table1" summary="Cotizaci&oa&oacute;n de Asegurados">
                <thead>
                    <tr>
                        <th scope="col" class="a" width="12%">Edad</th>
                        <th scope="col" class="b" width="20%" nowrap>Cantidad Asegurados</th>
                        <th scope="col" class="c" width="30%" nowrap>Suma Aseg. Muerte</th>
                        <th scope="col" class="d" width="30%" nowrap>Suma Aseg. Invalid&eacute;z</th>
                    </tr>
                </thead>
                 <tbody>
<%            LinkedList lSumas = oCot.getlRangosSumas();
              if (lSumas != null && lSumas.size() > 0 ) {
                  for (int i=0; i < lSumas.size(); i++) {
                      CotizadorSumas cs = (CotizadorSumas) lSumas.get(i);
    %>
             	 <input type="hidden" name="VIDAS_<%= cs.getedadDesde() %>_<%= cs.getedadHasta() %>"       value="<%= cs.getcantVidas() %>"/>
                 <input type="hidden" name="SUMA_MUERTE_<%= cs.getedadDesde() %>_<%= cs.getedadHasta() %>" value="<%= cs.getsumaAsegMuerte()%>" />
                 <input type="hidden" name="SUMA_INVALIDEZ_<%= cs.getedadDesde() %>_<%= cs.getedadHasta() %>" value="<%= cs.getsumaAsegInvalidez()%>"/>
                 <input type="hidden" name="EDAD_DESDE_<%= cs.getedadDesde() %>_<%= cs.getedadHasta() %>"  value="<%= cs.getedadDesde() %>"/>
                 <input type="hidden" name="EDAD_HASTA_<%= cs.getedadDesde() %>_<%= cs.getedadHasta() %>"  value="<%= cs.getedadHasta() %>"/>
                 <input type="hidden" name="SUMA_MUERTE_MAX_<%= cs.getedadDesde() %>_<%= cs.getedadHasta() %>" value="<%= cs.getmaxSumaAsegMuerte() %>"/>
                 <input type="hidden" name="SUMA_INVALIDEZ_MAX_<%= cs.getedadDesde() %>_<%= cs.getedadHasta() %>" value="<%= cs.getmaxSumaAsegInvalidez() %>"/>
                 <input type="hidden" name="SUMA_MUERTE_MIN_<%= cs.getedadDesde() %>_<%= cs.getedadHasta() %>" value="<%= cs.getminSumaAsegMuerte() %>"/>
                 <input type="hidden" name="SUMA_INVALIDEZ_MIN_<%= cs.getedadDesde() %>_<%= cs.getedadHasta() %>" value="<%= cs.getminSumaAsegInvalidez() %>"/>
                 <input type="hidden" name="TASA_MUERTE_<%= cs.getedadDesde() %>_<%= cs.getedadHasta() %>" value="<%= cs.gettasaMuerte() %>"/>
                 <input type="hidden" name="TASA_INVALIDEZ_<%= cs.getedadDesde() %>_<%= cs.getedadHasta() %>" value="<%= cs.gettasaInvalidez() %>"/>
<%                  if (cs.getcantVidas() != 0 ) {
    %>
                    <tr>
                        <td class="a" align="left" width="12%" ><%= cs.getedadDesde() %>&nbsp;a&nbsp;<%= cs.getedadHasta() %></td>
                        <td class="b" align="center" width="20%"><%= cs.getcantVidas() %></td>
                        <td class="c" align="center" width="30%"><%= Dbl.DbltoStr(cs.getsumaAsegMuerte(),2) %></td>
                        <td class="d" align="center" width="30%"><%= Dbl.DbltoStr(cs.getsumaAsegInvalidez(),2) %></td>
                    </tr>
<%                     }
                  }
              }
    %>

                </tbody>
            </table>
            <!--! Table markup-->

            <div class="form-file">
                 <div class="wrap-elements w35">
                    <span class="item-ma">Muerte accidental para todos los asegurados</span>
                 </div>
                 <div class="wrap-elements w15">
                    <span class="item-result"><%= ( oCot.getmcaMuerteAccidental() == null || oCot.getmcaMuerteAccidental() == "" ? "NO" : "SI" ) %></span>
                 </div>

            </div>

            <!-- prima, premio, tasas, recotizacion -->


             <div class="form-file cot1">
                    <div class="wrap-elements w25">
                         <label for="" class="lone">Prima: </label>
                         <input type="text" name="IMP_PRIMA" id="IMP_PRIMA" value="<%= Dbl.DbltoStr(oCot.getprimaTar(),2) %>"  readonly/>
                    </div>

                   <div class="wrap-elements w30">
                     <label class="ltwo">(*) Premio: </label>
                	 <input type="text" name="IMP_PREMIO" id="IMP_PREMIO" value="<%= Dbl.DbltoStr( oCot.getpremio(),2) %>" onkeypress="return Mascara('D',event);" maxlength="9"/>
                   </div>

                   <div class="wrap-elements w35">
                       <label class="lone">(*) Comisi&oacute;n:</label>
                       <input type="text" name="COMISION" id="COMISION" value="<%= Dbl.DbltoStr( oCot.getgastosAdquisicion(),2) %>" onkeypress="return Mascara('D',event);" maxlength="5"/>
                   </div>
            </div>

            <div class="form-file cot2">
                <div class="wrap-elements w25">
                     <label for="" class="lone">Tasa Prima:</label>
                     <input type="text" name="TASA_PRIMA" id="TASA_PRIMA" value="no informado" readonly/>
                </div>
               <div class="wrap-elements w30">
                    <label for="" class="ltwo">Tasa Premio:</label>
                    <input type="text" name="TASA_PREMIO" id="TASA_PREMIO" value="no informado" readonly/>
               </div>
            </div>


            <div class="cot-wrap">
                <span class="leyend">(*) Usted puede ajustar Premio o Comisi&oacute;n y luego haga clic en el bot&oacute;n recotizar ...</span>
                <input type="button" name="recotizar" id="recotizar" value="Recotizar" class="bt-form bt-recot" onclick="Recotizar ();" />
                <span id="mensaje_error" class="validation-message">&nbsp;</span>
            </div>

            </div><!-- form wrap -->

            <div class="options">
                <a href="#" onclick="Ir ('pdf');" class="opt-link a-pdf" title="generar y descargar pdf">Generar PDF</a>
                <a href="javascript:window.print();" class="opt-link a-printer" title="imprimir cotizacion">Imprimir</a>
                <a href="#" class="opt-link a-mail" title="enviar cotizacion por correo" onclick="overlay();">Enviar por e-mail</a>
            </div>

           </div>
           <!--! tab content .form-->

            <!-- button section -->
            <div class="form-file button-container">
                <input type="button" name="" id="" value="emitir propuesta" class="bt next" />
            </div>
            <!--! button section -->

            <div class="bottom_print">
                <span class="text_leyend">Esta cotizaci&oacute;n tendr&aacute; una valid&eacute;z de 15 d&iacute;as corridos a partir de la fecha de cotizaci&oacute;n</span>
                 <span class="firma">Firma</span>
           </div>

            </form>
            </div>
           <!--! tab content .form-->


        </div>

        <!--! tabs -->


         <!-- popup oculto para el envio de e-mail -->
            <div class="mail-overlay" id="overlay">

            	 <div class="mail-wrapp">

            	 	  <h3>Formulario de envio por e-mail</h3>

                      <div class="mail-form">
                      <form action="" method="post" enctype="multipart/form-data" name="form-email" id="form-email">

                          <div class="form-file">
                              <label for="dest">Destinatario</label>
                              <input type="text" name="dest" id="dest" value="<%= usu.getEmail() %>" onblur="if (this.value == &#39;&#39;) {this.value = &#39;e-mail@dominio.com&#39;;}" onfocus="if (this.value == &#39;e-mail@dominio.com&#39;) {this.value = &#39;&#39;;}" />
                          </div>

                          <div class="form-file">
                              <label for="title">Titulo</label>
                              <input type="text" name="title" id="title" value="Asunto del mensaje" onblur="if (this.value == &#39;&#39;) {this.value = &#39;Asunto del mensaje&#39;;}" onfocus="if (this.value == &#39;Asunto del mensaje&#39;) {this.value = &#39;&#39;;}" />
                          </div>

                          <div class="form-file">
                              <label for="message">Mensaje</label>
                              <textarea name="message" id="message" cols="6" rows="10">Introduzca su mensaje aqu&iacute;­...</textarea>
                          </div>

                          <div class="form-file">
                              <label for="message"><input type="checkbox" />Deseo incluir los gastos de adquisici&oacute;n en el e-mail</label>
                          </div>

                          <div class="form-file">
                               <input type="submit" value="Enviar Mensaje" name="send" id="send" class="bt bt-email" />
                               <span class="mseparator">&oacute;</span><a href="#" onclick="overlay(); return false;" class="cancel-link">cancelar</a>
                          </div>

                      </form>
                      </div>
            	</div>

            </div>
            <!-- -->

    </div>
   <!--! container -->

</body>
</html>
