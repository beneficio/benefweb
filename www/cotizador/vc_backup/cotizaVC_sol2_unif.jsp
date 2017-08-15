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
        int totalVidas = 0;
        double totalMuerte = 0;
        double totalInvalidez = 0;

    %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>BENEFICIO S.A. - Cotizador Vida Colectivo</title>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos-cot.css"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>

<!-- libreria jquery desde el cdn de google o fallback local -->

    <script src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
    <script src="<%= Param.getAplicacion()%>portal/js/vendor/jquery-1.8.0.min.js"></script>
    <script src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<!--[if lt IE 9]>
	<script src="http://css3-mediaqueries-js.googlecode.com/svn/trunk/css3-mediaqueries.js"></script>
<![endif]-->

    <script type="text/javascript">

        var SITE = SITE || {};

        SITE.fileInputs = function() {
          var $this = $(this),
              $val = $this.val(),
              valArray = $val.split('\\'),
              newVal = valArray[valArray.length-1],
              $button = $this.siblings('.button'),
              $fakeFile = $this.siblings('.file-holder');
          if(newVal !== '') {
            $button.text('Elegir Otro?');
            if($fakeFile.length === 0) {
              $button.after('<span class="file-holder">' + newVal + '</span>');
            } else {
              $fakeFile.text(newVal);
            }
          }
        };

        $(document).ready(function() {
          $('.file-wrapper input[type=file]').bind('change focus click', SITE.fileInputs);
        });

    function total_muerte () {
            importe_total = 0
            $(".suma_muerte").each(
                    function (index, value) {
                            var importe = eval($(this).val());
                            var max = eval ($(this).attr("max"));
                            var min = eval ($(this).attr("min"));
                            var rango = $(this).attr ("rango");
                            var vidas = 0;

                            if ( ! ( $('#VIDAS_' + rango).val() == null && $('#VIDAS_' + rango).val() == '0' ) ) {
                               vidas = eval ($('#VIDAS_' + rango).val());
                            }

                            if (vidas  != 0 && importe < min) {
                                alert ("Suma asegurada muerte menor que suma minima ( $ " + min + ")");
                                $(this).focus();
                                return false;
                            }
                            if (vidas != 0 && importe > max) {
                                alert ("Suma asegurada muerte mayor que suma minima ( $ " + min + ")");
                                $(this).focus();
                                return false;
                            }

                            importe_total = importe_total + ( importe * vidas);
                    }
            );
            $("#TOTAL_MUERTE").val(importe_total);
    }

    function total_invalidez () {
            importe_total = 0
            $(".suma_invalidez").each(
                    function (index, value) {
                            var importe = eval($(this).val());
                            var max = eval ($(this).attr("max"));
                            var min = eval ($(this).attr("min"));
                            var rango = $(this).attr ("rango");
                            var vidas = 0;

                            if ( ! ( $('#VIDAS_' + rango).val() == null && $('#VIDAS_' + rango).val() == '0' ) ) {
                               vidas = eval ($('#VIDAS_' + rango).val());
                            }

                            if (vidas  != 0 && importe < min) {
                                alert ("Suma asegurada invalidez menor que suma minima ( $ " + min + ")");
                                $(this).focus();
                                return false;
                            }
                            if (vidas != 0 && importe > max) {
                                alert ("Suma asegurada invalidez mayor que suma minima ( $ " + min + ")");
                                $(this).focus();
                                return false;
                            }

                            importe_total = importe_total + ( importe * vidas);
                    }
            );
            $("#TOTAL_INVALIDEZ").val(importe_total);
    }

    function total_vidas () {
            importe_total = 0
            $(".vidas").each(
                    function (index, value) {
                            importe_total = importe_total + eval($(this).val());
                    }
            );
            $("#TOTAL_VIDAS").val(importe_total);

            importe_muerte = 0
            $(".suma_muerte").each(
                    function (index, value) {
                            var importe = eval($(this).val());
                            var rango = $(this).attr ("rango");
                            var vidas = 0;

                            if ( ! ( $('#VIDAS_' + rango).val() == null && $('#VIDAS_' + rango).val() == '0' ) ) {
                               vidas = eval ($('#VIDAS_' + rango).val());
                            }

                            importe_muerte = importe_muerte + ( importe * vidas);
                    }
            );
            $("#TOTAL_MUERTE").val(importe_muerte);

            importe_invalidez = 0
            $(".suma_invalidez").each(
                    function (index, value) {
                            var importe = eval($(this).val());
                            var rango = $(this).attr ("rango");
                            var vidas = 0;

                            if ( ! ( $('#VIDAS_' + rango).val() == null && $('#VIDAS_' + rango).val() == '0' ) ) {
                               vidas = eval ($('#VIDAS_' + rango).val());
                            }

                            importe_invalidez = importe_invalidez + ( importe * vidas);
                    }
            );
            $("#TOTAL_INVALIDEZ").val(importe_invalidez);
    }

    function Ir (sigte) {
        
   var total_vidas  = $('#TOTAL_VIDAS').val ();

    if ( sigte == 'solapa3' && ( total_vidas == '' || total_vidas == '0')) {
        $('#mensaje_error').text("- ERROR: Debe ingresar la cantidad de asegurados en alguno de los rangos de edades ") ;
        return false;
    } else {
        if ($('input[name=MUERTE_ACCIDENTAL]').is(':checked') ) {
           $('input[name=MUERTE_ACCIDENTAL]').attr('value', 'X');
        } else {
           $('input[name=MUERTE_ACCIDENTAL]').attr('value', '');
        }
        document.getElementById("siguiente").value = sigte;
        document.form1.submit();
        return true;
    }
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

         <h1 class="title-section hcotizadores">cotizador de vida colectivo</h1>

         <!-- tabs -->

         <div class="tabs-container">

        <form name="form1" id="form1" method="post"  action="<%= Param.getAplicacion()%>servlet/CotizadorVCServlet">
            <input type="hidden" name="opcion"      id="opcion"     value="cotizador"/>
            <input type="hidden" name="siguiente"   id="siguiente"  value="solapa3"/>
            <input type="hidden" name="origen"      id="origen"     value="solapa2"/>
            <input type="hidden"   name="COD_RAMA"    id="COD_RAMA"   value="<%= oCot.getcodRama() %>"/>
            <input type="hidden"   name="COD_SUB_RAMA"id="COD_SUB_RAMA"    value="<%= oCot.getcodSubRama() %>"/>
            <input type="hidden"   name="COD_PRODUCTO"  id="COD_PRODUCTO"  value="<%= oCot.getcodProducto() %>"/>
            <input type="hidden"   name="COD_PROVINCIA" id="COD_PROVINCIA" value="<%= oCot.getcodProvincia() %>"/>
            <input type="hidden"   name="COD_VIGENCIA"  id="COD_VIGENCIA"  value="<%= oCot.getcodVigencia() %>"/>
            <input type="hidden"   name="TOMADOR_APE"   id="TOMADOR_APE"   value="<%= oCot.gettomadorApe() %>"/>
            <input type="hidden"   name="COD_PROD"   id="COD_PROD"   value="<%= oCot.getcodProd() %>"/>
            <input type="hidden" name="usuario"     id="usuario"   value="<%= usu.getusuario() %>"/>
            <input type="hidden" name="num_cotizacion" id="num_cotizacion"   value="<%= oCot.getnumCotizacion() %>"/>
            <input type="hidden" name="COD_SUB_RAMA_DESC" id="COD_SUB_RAMA_DESC"  value="<%= oCot.getdescSubRama () %>"/>


             <ul class="tabs">
                <li><span class="step">1</span><a href="#" onclick="Ir ('solapa1');" title="datos generales">Datos Generales</a></li>
                <li class="active"><span class="step">2</span><a href="#" title="datos de asegurados">Datos de Asegurados</a></li>
                <li><span class="step">3</span><a href="#" onclick="Ir ('solapa3');" title="cotizacion" class="last">Cotizaci&oacute;n</a></li>
            </ul>

            <!-- -->
            <div id="tab2" class="tab-content form">
            <div class="form-wrap">

            <h2>Usted puede elegir cotizar de una de estas 2 formas</h2>

            <h3>1) Utilizando nuestro excel para cargar la nomina</h3>

            <p>Si aun no lo bajo puede hacerlo haciendo <a href="#" title="">clic aqui.</a><br />
            Si ya lo tiene puede reutizarlo. Si lo acaba de bajar, grabe el archivo en su disco y copie la nomina en el mismo, luego ingrese el excel con la
            nomina desde aca y presione el boton enviar...
            </p>

            <div class="form-file">
                 <div class="wrap-elements w50">
                     <span class="file-wrapper">
                          <input type="file" name="photo" id="photo" />
                          <span class="file-holder"></span>
                          <span class="button">Elegir Archivo...</span>
                    </span>
                 </div>
                 <input type="button" name="" id="" value="Enviar Archivo" class="bt-form" />
            </div>

            <h3>2) Ingresando la cantidad de asegurados segun la edad:</h3>

            <!-- tcomponent -->

            <div class="t-component">

            <div class="form-file fhead">
                <div class="wrap-elements w10">
                     <label title="edad" class="txt-left">Edad</label>
                </div>
                <div class="wrap-elements w30">
                	 <label title="cantidad de asegurados">Cantidad de Asegurados</label>
                </div>
                 <div class="wrap-elements w30">
                    <label title="sumas aseguradas por muerte por asegurado">Sumas Aseguradas<br/>Muerte por asegurado</label>
                </div>
                 <div class="wrap-elements w30">
                     <label title="sumas aseguradas por invalidez por asegurado">Sumas Aseguradas<br/>Invalid&eacute;z por asegurado</label>
                </div>
            </div>
<%  LinkedList lsumas = oCot.getlRangosSumas();

    if (lsumas.size() == 0) {
    %>

    <h3>Rangos de edades no definidos para el producto. Envíe un mail a produccion@beneficiosa.com.ar avisando del problema. Gracias</h3>

<%  } else {
        for (int i=0; i<lsumas.size();i++ ) {
            CotizadorSumas oCS = (CotizadorSumas) lsumas.get(i);
            totalVidas += oCS.getcantVidas();
            totalMuerte += oCS.getsumaAsegMuerte();
            totalInvalidez += oCS.getsumaAsegInvalidez();

    %>
            <div class="form-file">
                <div class="wrap-elements w10">
                    <label for=""><%= oCS.getedadDesde() %>&nbsp;a&nbsp; <%= oCS.getedadHasta() %></label>
                </div>
                <div class="wrap-elements w30">
                	 <input type="text" name="VIDAS_<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>" 
                            id="VIDAS_<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>" value="<%= oCS.getcantVidas() %>" class="quantity vidas"
                            maxlength="3" onKeyPress="return Mascara('D',event);" onchange="total_vidas ();"/>
                         <input type="hidden" name="EDAD_DESDE_<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>" value="<%= oCS.getedadDesde() %>"/>
                         <input type="hidden" name="EDAD_HASTA_<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>" value="<%= oCS.getedadHasta() %>"/>
                         <input type="hidden" name="SUMA_MUERTE_MAX_<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>" value="<%= oCS.getmaxSumaAsegMuerte() %>"/>
                         <input type="hidden" name="SUMA_INVALIDEZ_MAX_<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>" value="<%= oCS.getmaxSumaAsegInvalidez() %>"/>
                         <input type="hidden" name="SUMA_MUERTE_MIN_<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>" value="<%= oCS.getminSumaAsegMuerte() %>"/>
                         <input type="hidden" name="SUMA_INVALIDEZ_MIN_<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>" value="<%= oCS.getminSumaAsegInvalidez() %>"/>
                         <input type="hidden" name="TASA_MUERTE_<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>" value="<%= oCS.gettasaMuerte() %>"/>
                         <input type="hidden" name="TASA_INVALIDEZ_<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>" value="<%= oCS.gettasaInvalidez() %>"/>
                </div>
                <div class="wrap-elements w30">
                    <input type="text" name="SUMA_MUERTE_<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>" class="quantity suma_muerte"
                            id="SUMA_MUERTE" value="<%= (oCS.getsumaAsegMuerte() > 0 ? oCS.getsumaAsegMuerte() :
                                (oCS.getmaxSumaAsegMuerte() == oCS.getminSumaAsegMuerte() ? oCS.getminSumaAsegMuerte()  : 0 ) ) %>" max="<%= oCS.getmaxSumaAsegMuerte() %>"
                            min="<%= oCS.getminSumaAsegMuerte() %>" rango="<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>"
                            onkeypress="return Mascara('N',event);" onchange="total_muerte ();" maxlength="9"
                             <%= (oCS.getmaxSumaAsegMuerte() == oCS.getminSumaAsegMuerte() ? "readonly" : " ") %>/>
                </div>
                 <div class="wrap-elements w30">
                    <input type="text" name="SUMA_INVALIDEZ_<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>" class="quantity suma_invalidez"
                            id="SUMA_INVALIDEZ" value="<%= (oCS.getsumaAsegInvalidez() > 0 ? oCS.getsumaAsegInvalidez(): 
                                (oCS.getmaxSumaAsegInvalidez() == oCS.getminSumaAsegInvalidez() ? oCS.getminSumaAsegInvalidez() : 0 ) ) %>"
                             max="<%= oCS.getmaxSumaAsegInvalidez() %>"  min="<%= oCS.getminSumaAsegInvalidez() %>"
                             rango="<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>"
                            onkeypress="return Mascara('N',event);" onchange="total_invalidez ();" maxlength="9"
                             <%= (oCS.getmaxSumaAsegInvalidez()== oCS.getminSumaAsegInvalidez() ? "readonly" : " ") %>/>
                </div>
            </div>
<%      }
    }
    %>
            <div class="form-file">
                <div class="wrap-elements w10">
                     <label>Totales</label>
                </div>
                <div class="wrap-elements w30">
                    <input type="text" name="TOTAL_VIDAS" id="TOTAL_VIDAS" value="<%= totalVidas  %>" class="quantity" readonly />
                </div>
                 <div class="wrap-elements w30">
                     <input type="text" name="TOTAL_MUERTE" id="TOTAL_MUERTE" value="<%= totalMuerte  %>" class="quantity" readonly/>
                </div>
                 <div class="wrap-elements w30">
                     <input type="text" name="TOTAL_INVALIDEZ" id="TOTAL_INVALIDEZ" value="<%= totalInvalidez  %>" class="quantity" readonly />
                </div>
            </div>

            </div>

            <!-- tcomponent -->

            <div class="form-file">
                 <div class="wrap-elements">
                     <label><input type="checkbox" class="maccid-all" id="MUERTE_ACCIDENTAL" name="MUERTE_ACCIDENTAL"
                                   value="<%= (oCot.getmcaMuerteAccidental() == null  ? "" : oCot.getmcaMuerteAccidental()) %>"
                                    <%= (oCot.getmcaMuerteAccidental() == null || oCot.getmcaMuerteAccidental().equals ("")  ? "" : "checked") %> /> Muerte accidental para todos los asegurados</label>
                 </div>

            </div>

            </div><!-- form wrap -->


            </div>
           <!--! tab content .form-->

            <!-- button section -->
            <div class="form-file button-container">
                <span id="mensaje_error" class="validation-message">&nbsp;</span>
                <input type="button" name="COTIZAR" id="COTIZAR"  value="cotizar" class="bt next" onclick="Ir ('solapa3');"/>
            </div>
            <!--! button section -->
        </form>
        </div>

        <!--! tabs -->


    </div>
    <!--! container -->

</div> <!--! wrapper -->

</body>
</html>