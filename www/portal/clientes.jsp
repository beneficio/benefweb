<%@page import="ar.com.beneficio.tokens.BeneficioTokens"%>
<%@page import="java.util.LinkedList"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page contentType="text/html" pageEncoding="UTF-8" errorPage="/error.jsp"%>
<%@page import="com.business.beans.Portal"%>
<%@page import="com.business.beans.PortalTexto"%>
<%@page import="com.business.beans.PortalTabla"%>
<%@page import="com.business.db.db"%>	
<%@page import="com.business.util.*"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.Connection"%>
<%  String certError   = (String) request.getAttribute("error_cert");
    String poliza_mens = (String) request.getAttribute("poliza_mens");
    String urlExtranet = config.getServletContext().getInitParameter ("urlExtranet");
    if (urlExtranet == null) { urlExtranet = "http://www.beneficioweb.com.ar/"; }
    HtmlBuilder ohtml = new HtmlBuilder();
    Tablas oTabla = new Tablas ();
    LinkedList lTabla = new LinkedList ();
    
    String sMercadoPago = "N";

    Connection dbCon = null;
    try {
        dbCon = db.getConnection();
        dbCon.setAutoCommit(false);

        Parametro oParam = new Parametro ();
        oParam.setsCodigo("ESTADO_MERCADOPAGO_PORTAL");

        sMercadoPago = oParam.getDBValor(dbCon);

    } catch (Exception se) {
            throw new SurException (se.getMessage());
    } finally {
            db.cerrar(dbCon);
    }
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="es-419"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="es-419"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="es-419"> <![endif]-->
<!--[if IE 9]>         <html class="no-js lt-ie10" lang="es-419"> <![endif]-->
<!--[if gt IE 9]><!--> <html class="no-js" lang="es-419"> <!--<![endif]-->
<head>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title></title>
<meta name="description" content="">
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;">
<meta name="keywords" content="">
<meta name="author" content="">
<meta name="robots" content="index,follow">
<meta name="copyright" content="">

<!-- Facebook's Open graph starts -->

<meta property="og:title" content="Clientes">
<meta property="og:type" content="website">
<meta property="og:url" content="<%= urlExtranet %>">
<meta property="og:image" content="<%= Param.getAplicacion()%>portal/img/avatar.png">
<meta property="og:site_name" content="Beneficio SA - Compañia de Seguros">
<meta property="fb:admins" content="100004514563818">
<meta property="og:description" content="BENEFICIO S.A. Compa&ntilde;&iacute;a de Seguros fue formada el 01 de julio de 1995,
      con las m&aacute;s recientes caracter&iacute;sticas establecidas por la Superintendencia de Seguros de la Naci&oacute;n para empresas que desarrollan los ramos Vida, Salud, Sepelio Y Accidentes Personales,
      que son ramos espec&iacute;ficos de los seguros sobre las personas. A partir de mayo 2011 estamos autorizados por la SSN a comercializar Seguros de Caucion">

<!--! Facebook's Open graph ends -->

<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon">

<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/normalize.css">
<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/spinner.css">
<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/skeleton.css">
<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/main.css">
<link rel="canonical" href="<%= urlExtranet %>/url.html">

<!-- <link rel="stylesheet" type="text/css" href="https://a248.e.akamai.net/secure.mlstatic.com/org-img/ch/ui/0.11.1/chico-mesh.min.css">
<link rel="stylesheet" type="text/css" href="https://www.mercadopago.com/mla/credit_card_promos.resource.css/main"> -->

<script src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js"></script>

<script type="text/javascript" language="javascript">

	var mercadoPago = "<%= sMercadoPago %>";
    function Ir () {
        document.form3.submit();
        return true;
    }
    
    $(function() {
    	
    	
    });

    $('#loadingDiv')
    	.hide()
	    .ajaxStart(function() {
	        $(this).show();
	    })
	    .ajaxStop(function() {
	        $(this).hide();
	    });
    
</script>

<style type="text/css">

	/*.ch-modal, .ch-transition {
	    background-color: #fff;
	    background-image: none;
	    overflow: auto;
	    width: 500px;
	    -webkit-box-shadow: 2px 2px 2px rgba(100,100,100,.1);
	    box-shadow: 2px 2px 2px rgba(100,100,100,.1);
	}
	
	.ch-box {
	    box-shadow: 1px 1px 3px #CCC;
	    border-radius: 15px;
	    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#EEEEEE', endColorstr='#FFFFFF');
	}*/
	
</style>

</head>

<body class="loading">
<form method="post" action="<%= Param.getAplicacion()%>portal/contacto.jsp" name='form3' id='form3'>
    <input type="hidden" name="asunto" id="asunto" value="Beneficio On Line (Clientes)">
    <input type="hidden" name="email" id="email" value="produccion@beneficio.com.ar">
    <input type="hidden" name="cod_motivo" id="cod_motivo" value="2">
</form>
<!--[if lt IE 7]>
            <p class="chromeframe">Estas usando un explorador obsoleto. <a href="http://browsehappy.com/">Actualiza ahora</a> o <a href="http://www.google.com/chromeframe/?redirect=true">instala Google Chrome Frame</a> para una mejor experiencia en el sitio.</p>
<![endif]-->

<div id="loadingDiv" class="spinner" style="display: none;">
</div>

<!-- modal #1 -->
<div id="overlay">
     <div class="form">
     	  <a href="#" title="cerrar ventana" class="close" onclick="overlay(); return false;">x</a>
          <h1>Solicitud de certificado de cobertura</h1>
          <form method="post" action="<%= Param.getAplicacion()%>PortalServlet" name="form4" id="form4"
                 onsubmit="return(validate1 ());" novalidate>
              <input type="hidden" id="opcion" name="opcion" value="getCertificado">
              <input id="dni" name="dni" type="text" class="cuit" placeholder="Cuit/Dni Nro." tabindex="1" autofocus
                     title="Ingrese documento o cuit con el que se emiti&oacute; la p&oacute;liza">
              <input id="poliza" name="poliza" type="text" class="poliza" placeholder="Poliza Nro." tabindex="2"
                     title="Ingrese n&uacute;mero de p&oacute;liza">
              <span class="separator"></span>
              <input id="enviar" name="enviar" type="submit" value="Generar" class="generate" tabindex="3">
          </form>
<!--          <a href="#" title="Descargue el certificado generado en pdf" class="generated-downlaod">Certificado generado xxxxxxxxxxxx.pdf</a>
-->
<%    if (certError != null && ! certError.equals("ok")) {
    %>
     <span class="result error"><%= certError %></span>
<%  }
    %>
     </div>
</div>
<!--! modal #1 -->

<!-- modal #2 -->
<div id="overlay2">
     <div class="form">
     	  <a href="#" title="cerrar ventana" class="close" onclick="overlay2(); return false;">x</a>
          <h1>Solicitud de env&iacute;o de p&oacute;liza</h1>
          <form method="post" action="<%= Param.getAplicacion()%>PortalServlet" name="form5" id="form5"
                 onsubmit="return(validate2());" novalidate>
              <input type="hidden" id="opcion" name="opcion" value="getCopiaPoliza">
              <input id="dni" name="dni" type="text" class="cuit" placeholder="Cuit/Dni Nro." tabindex="1" autofocus
                     title="Ingrese documento o cuit con el que se emiti&oacute; la p&oacute;liza">
              <input id="poliza" name="poliza" type="text" class="poliza" placeholder="Poliza Nro." tabindex="2"
                     title="Ingrese n&uacute;mero de p&oacute;liza">
              <span class="separator"></span>
              <input id="enviar" name="enviar"  type="submit" value="Enviar" class="generate" tabindex="4">
              <input id="email" name="email" type="email" class="email" placeholder="E-mail" tabindex="3"
                     title="Ingrese email donde desea recibir la p&oacute;liza">
          </form>
<%      if ( poliza_mens != null) {
            if ( poliza_mens.equals("ok"))  {
    %>
        <p class="info-pol">La copia de p&oacute;liza fue enviada exitosamente  al correo ingresado.</p>
<%          } else {
    %>
        <span class="result error"><%= poliza_mens %></span>
<%          }
        }
    %>
     </div>
</div>
<!--! modal #2 -->

<!-- modal #3 -->
<div id="overlay3">
	<div class="form">
		<a href="#" title="cerrar ventana" class="close" onclick="overlay3(); return false;">x</a>
		<h1>Ingrese los datos de la p&oacute;liza a pagar</h1>
		<div>
            <input id="dni_payment" name="dni_payment" type="text" class="cuit" placeholder="Cuit/Dni Nro." tabindex="1" autofocus title="Ingrese documento o cuit con el que se emiti&oacute; la p&oacute;liza" />
            <input id="poliza_payment" name="poliza_payment" type="text" class="poliza" placeholder="Poliza Nro." tabindex="2" title="Ingrese n&uacute;mero de p&oacute;liza" />
            <span class="separator"></span>
            <input id="buscar" name="buscar"  type="button" value="Buscar" class="generate" tabindex="4" onclick="payment();" />
            <!-- <input class="MP-common-orange-CDs" type="button" value="Pagar" tabindex="4" onclick="payment();"> -->
            <select id="rama" name="rama" tabindex="3" title="Seleccione una rama">
            	<option value="-1">SELECCIONE UNA RAMA</option>
		        <% lTabla = oTabla.getRamas ();
		           out.println(ohtml.armarSelectTAG(lTabla, -1 )); 
		        %>
            </select>
		</div>
		<p id="msg_payment" class="info-pol"></p>
	</div>
</div>
<!--! modal #3 -->

<jsp:include page="/portal/header.jsp">
    <jsp:param name="page" value="home" />
</jsp:include>
<!-- cuerpo principal -->
<div class="container" role="main">

<div class="row">
	<div class="sixteen columns alpha tpage">
	<h2 class="h-page">Beneficio On-line / Clientes</h2>
    </div>
</div>

<div class="row">
	<!-- left -->
    <div class="eleven columns alpha">
    <section id="clientes">

       <div class="action-bar">

            <!-- social buttons -->
            <div class="social-wrap">

            <!-- <div class="fb-like" data-send="false" data-width="120" data-show-faces="false" data-font="arial"></div> -->

            <a href="https://twitter.com/share" class="twitter-share-button" data-via="beneficioweb" data-lang="es" data-related="beneficioweb" data-hashtags="seguros" data-dnt="true">Twittear</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="http://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>

            <div class="g-plusone" data-size="medium"></div>
            <script>
              window.___gcfg = {lang: 'es-419'};

              (function() {
                var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
                po.src = 'https://apis.google.com/js/plusone.js';
                var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
              })();
            </script>

            </div>
            <!--! social buttons -->
<!--            <div class="toolbar">
                <a href="#" title="imprimir" class="ic_t print">Imprimir</a>
                <a href="#" title="descargar pdf" class="ic_t pdf">Descargar PDF</a>
            </div>
-->
            </div>

    <h3 class="sub-title">Beneficio On Line - Servicios al cliente </h3>
    <p>       
        Estimado cliente, usted desde aqu&iacute; podr&aacute;:
        <UL type = disk >
			<LI>Obtener un certificado de cobertura de su p&oacute;liza.</LI>
			<LI>Solicitar v&iacute;a email una copia de p&oacute;liza, la misma le llegar&aacute; inmediatamente a la cuenta de email que ingrese.</LI>
			<LI>Pagar el saldo de sus p&oacute;lizas en cuotas y sin inter&eacute;s aprovechando las
                            &nbsp;<a href="https://www.mercadopago.com/mla/credit_card_promos.htm" target="_blank">promociones de MercadoPago</a>.</LI>
		</UL>
        Le recordamos que si usted es un productor o un cliente registrado puede administrar su propia cartera <a  href="<%= urlExtranet %>portal/extranet.jsp" target="_blank">haciendo clik aqu&iacute;.</a>
        En todos los casos, cuando se le solicite un Cuit o DNI deber&aacute; ingresar el mismo con el cual se haya emitido la p&oacute;liza. 
    </p>
    <div class="downloads">
	    <a href="#" id="cert" class="document cert" title="" onclick="overlay(); return false;"></a>
	    <a href="#" id="pol" class="document pol" title="" onclick="overlay2(); return false;"></a>
	    <span class="help">Seleccione lo que desea descargar</span>
    </div>

    <span class="line-break"></span>

	<div class="divmp">
	    <a href="#" id="payment" title="Pago de P&oacute;liza" onclick="overlay3(); return false;" class="bannermp"></a>
	    
	    
	    <span class="helpmp">
	    	Seleccione la p&oacute;liza a pagar <!-- con el bot&oacute;n
	    	<input class="MP-common-orange-CDs" type="button" value="Pagar"> -->
	    </span>
	    <!-- <a href="#" name="MP-Checkout" class="red-M-Rn-Ar" mp-mode="modal" >Pagar</a> -->
    </div>
    
    <a href="https://www.mercadopago.com/mla/credit_card_promos.htm" target="_blank">Ver promociones</a>
    <a class="promociones" href="https://www.mercadopago.com.ar/ayuda/costos-financiacion_621" target="_blank">Ver financiaci&oacute;n</a>
    
    <a href="#" title="Contactar un asesor de Beneficio SA" class="bt-contact" onclick="javascript:Ir();">Contactar Asesor</a>

    </section>

    </div>
    <!--! left -->
    <!-- right -->
    <jsp:include page="/portal/right.jsp">
        <jsp:param name="page" value="home" />
    </jsp:include>
    
    <div style="display:none"><div id="legals"><h1>Condiciones generales</h1><ul><li> <span class="bank">Banco Provincia: </span>Costo Financiero Total (CFT) Nominal Anual 1,48% por gesti&oacute;n de contrataci&oacute;n de cobertura de seguro de vida sobre saldo deudor (en caso de corresponder). Inter&eacute;s: Tasa Nominal Anual 0,00%. Tasa Efectiva Anual 0,00%. Promoci&oacute;n v&aacute;lida para compras realizadas en hasta 18 cuotas sin inter&eacute;s desde el 01/08/2015 al 09/08/2015 con las tarjetas de cr&eacute;dito Mastercard y Visa emitidas por el Banco Provincia de Buenos Aires. (Ejemplo representativo: en una compra de $1.000 en 18 cuotas sin inter&eacute;s, el cliente abonar&aacute; 18 cuotas de $55,55 cada una). Promoci&oacute;n v&aacute;lida &uacute;nicamente para la Rep&uacute;blica Argentina. No combinable con otras promociones. Banco de la Provincia de Buenos Aires. Cuit 33-99924210-9. Calle 7 Nº 726 La Plata.</li><li> <span class="bank">Banco Hipotecario: </span>Promoci&oacute;n v&aacute;lida en Argentina desde el 06/08/2015 hasta el 13/08/2015 para consumos con tarjetas de cr&eacute;dito Visa del Banco Hipotecario que no registren mora. No acumulable con otras promociones. (1) Costo Financiero Total Nominal Anual (CFTNA) 3,89%. Planes de hasta 12 cuotas con TNA/TEA 0.00%. El Costo Financiero Total Nominal Anual (CFTNA) incluye el costo total por contrataci&oacute;n y administraci&oacute;n de seguro de vida. Banco Hipotecario S.A. CUIT 30-50001107-2, Reconquista 151, Ciudad Aut&oacute;noma de Buenos Aires.</li><li> <span class="bank">Tarjeta Shopping: </span>Oferta v&aacute;lida desde el 03/08/2015 hasta el 31/08/2015 inclusive, comprando con tarjeta Tarjeta Shopping y Visa sin inter&eacute;s: exclusivamente en 6 cuotas en todos los productos en MercadoLibre; Raz&oacute;n social: MERCADO LIBRE S.R.L CUIT: 30-70308853-4. Domicilio: Arias 3751 P7 C.A.B.A. | Cuotas sin inter&eacute;s: (El monto incluye el capital, el inter&eacute;s, el seguro de vida y el IVA correspondiente a la primera cuota): Tasa Efectiva Mensual: 0%, Tasa Nominal Anual: 0%, Tasa Efectiva Anual: 0%, Costo Financiero Total (con IVA): CFT: 3.89%. Incluye cobertura de seguro de vida de 0,32 por cien; Costo Financiero Total (sin IVA): CFT: 3.89%. Incluye cobertura de seguro de vida de 0,32 por cien. | TARSHOP S.A., CUIT: 30-68523167-7, Suipacha 664, 2º Piso, C.A.B.A. CFTNA: 3.89%</li><li> <span class="bank">Macro: </span>Costo financiero total nominal anual: 2,10% - Promoci&oacute;n para compras con tarjeta de cr&eacute;dito Mastercard, American Express y Visa de los Bancos de Grupo Macro en mercadolibre.com.ar. V&aacute;lida desde el 05/08/2015 hasta el 16/08/2015 inclusive. Hasta 6 cuotas sin inter&eacute;s. TNA (Tasa Nominal Anual) 0%, TEA (Tasa Efectiva Anual) 0%, C.F.T.N.A (Costo Financiero Total Nominal Anual) 2,10% (IVA no alcanzado, incluye seguro de vida sobre saldos). No v&aacute;lido para tarjetas de cr&eacute;dito empresa y/o agro. No aplica a productos del rubro Electro. Los establecimientos, los productos y/o servicios que comercializan o la calidad de los mismos no son promocionados ni garantizados por los Bancos del Grupo Macro, como as&iacute; tampoco se responsabilizan por los cupones presentados fuera de t&eacute;rmino por los comercios. Promoci&oacute;n no acumulable con otras promociones. Banco Macro S.A., Sarmiento 447 Cap. Fed., CUIT Nro. 30-50001008-4. Consulte bases, condiciones, alcances de la promoci&oacute;n y toda informaci&oacute;n adicional en beneficiosmacro.com.ar o al 0810-888-3300 o en la sucursal m&aacute;s cercana a tu domicilio.</li><li> <span class="bank">Nativa Mastercard: </span>COSTO FINANCIERO TOTAL: 3,58% - Promoci&oacute;n v&aacute;lida del 01/08/2015 hasta 31/08/2015 para compras con tarjeta de cr&eacute;dito Mastercard de Nativa Mastercard. TNA (Tasa Nominal Anual): 0% - TEA (Tasa Efectiva Anual): 0% - CFT (Costo Financiero Total): 3,58% por gesti&oacute;n de contrataci&oacute;n de Seguro de Vida sobre saldo deudor. Consulta los detalles de esta promoci&oacute;n en www.nativanacion.com.ar</li><li> <span class="bank">Cencosud: </span>Costo Financiero Total: 7,30% - Promoci&oacute;n v&aacute;lida desde el 01/08/2015 al 31/08/2015 pagando con tarjetas Mastercard de Cencosud en www.mercadolibre.com. (1) Exclusivamente pagando con tarjetas Cencosud en hasta 6 cuotas fijas mensuales sin inter&eacute;s en toda la compra. Plan 6: Tasa Nominal Anual: 0%; Tasa Efectiva Anual: 0%; Costo Financiero Total (CFT): 7,30% (*) El CFT incluye el costo de seguro de vida seg&uacute;n compañ&iacute;a de seguros contratada. El CFT no incluye cargos mensuales de administrac&iacute;on de cuenta y costos asociados al mantenimiento de la tarjeta. Consulte cargos vigentes asociados a su cuenta al 0810-9999-627. CENCOSUD S.A., CUIT 30-59036076-3, Suipacha 1111, Piso 18, CABA (Dom. No Comercial). (*) CFT: 7,30%.</li><li> <span class="bank">Banco Nacion: </span>COSTO FINANCIERO TOTAL: 3,58% - Promoci&oacute;n v&aacute;lida desde el 01/08/2015 hasta el 31/08/2015, ambas fechas inclusive con tarjetas Mastercard y Visa del Banco Naci&oacute;n. No v&aacute;lido para tarjetas Nativa del BNA. (*) TNA (Tasa Nominal Anual): 0% - TEA (Tasa Efectiva Anual): 0% - CFT (Costo Financiero Total): 3,58% por gesti&oacute;n de contrataci&oacute;n de Seguro de Vida sobre saldo deudor. Consulta los comercios adheridos exclusivamente a esta promoci&oacute;n en www.bna.com.ar</li><li> <span class="bank">Diners: </span>Promoci&oacute;n v&aacute;lida desde el 01/08/2015 hasta el 31/08/2015 abonando hasta 6 cuotas sin inter&eacute;s exclusivamente con tarjetas Diners Club International emitidas en Argentina. No acumulable con otras promociones. No incluye tarjetas corporativas. S&oacute;lo v&aacute;lido para aquellos clientes que se encuentran al d&iacute;a en sus productos. *TNA: 0% TASA NOMINAL ANUAL. TEA: 0% TASA EFECTIVA ANUAL. COSTO FINANCIERO TOTAL CFT: 2.63% (6 CUOTAS)</li><li> <span class="bank">Banco Patagonia: </span>Costo Financiero Total Nominal Anual 3,67% (Tasa Nominal Anual:0%, Tasa Efectiva Anual:0% y costo de seguro de vida sobre saldo deudor 0,35%). Promoci&oacute;n v&aacute;lida en la Rep&uacute;blica Argentina desde el 01/08/2015 hasta el 31/08/2015. Comprando con las tarjetas Visa, Mastercard y American Express de Banco Patagonia recibir&aacute; una financi&oacute;n de hasta 3 cuotas sin inter&eacute;s. Promoci&oacute;n no acumulable con otras promociones.</li><li> <span class="bank">Banco Comafi: </span>Costo Financiero Total: 3,89% - Promoci&oacute;n v&aacute;lida desde el 01/08/2015 hasta el 31/08/2015, ambas fechas inclusive. V&aacute;lido para consumos realizados hasta en 6 cuotas &uacute;nicamente con tarjeta de cr&eacute;dito Visa y Mastercard del Banco Comafi (no incluye tarjeta Provencred y Dinosaurio). Promoci&oacute;n no v&aacute;lida para tarjetas corporativas. *TNA: 0% Tasa Nominal Anual: TEA: 0% Tasa Efectiva Anual.</li><li> <span class="bank">ICBC: </span>Propuesta v&aacute;lida del 01/08/2015 al 31/08/2015 exclusivo compras con tarjetas de cr&eacute;dito Visa y Mastercard del ICBC. No v&aacute;lido para compras mayoristas, ni tarjetas purchasing, agro, corporate. (*) Planes en cuotas indicados tienen costo financiero total (CFT): 3,90%, tasa nominal anual: 0,00%, tasa efectiva anual: 0,00%, costo seguro de vida s/deudor: 0,315%. Industrial and Commercial Bank of China (Argentina) S.A. Es una sociedad an&oacute;nima bajo la ley argentina. Sus accionistas limitan su responsabilidad al capital aportado (ley 25738).</li><li> <span class="bank">HSBC: </span>Promoci&oacute;n v&aacute;lida desde el 01/08/2015 y hasta el 31/08/2015 para las compras que sean abonadas en MercadoLibre con las tarjetas de cr&eacute;dito Mastercard, Visa y American Express emitidas por HSBC Bank Argentina S.A. (en adelante, HSBC). La promoci&oacute;n aplica para las compras realizadas en hasta 3 cuotas sin inter&eacute;s. Promoci&oacute;n v&aacute;lida &uacute;nicamente para la Rep&uacute;blica Argentina. Quedan excluidos de la presente promoci&oacute;n aquellos clientes que registren mora con HSBC. Promoci&oacute;n no v&aacute;lida para Tarjetas de Cr&eacute;dito Corporativas, Empresa, Business, Puchasing, Cuenta Central, C&amp;A, Bonesi y Tarjetas de D&eacute;bito. Promoci&oacute;n no acumulable con otras promociones vigentes. HSBC no promueve los bienes y/o servicios ni al proveedor de los mismos. Los bienes y/o servicios aqu&iacute; mencionados se ofrecen bajo responsabilidad exclusiva del establecimiento o proveedor de los bienes y/o servicios. Ley 25.738 (art. 1°): HSBC Bank Argentina S.A., es una sociedad an&oacute;nima constituida bajo las leyes de la Rep&uacute;blica Argentina. Sus operaciones son independientes de otras compañ&iacute;as del Grupo HSBC. Los accionistas limitan su responsabilidad al capital aportado.</li><li> <span class="bank">Banco Industrial: </span>Costo Financiero Total: 5,40% - CFT incluye gesti&oacute;n y contrataci&oacute;n de seguro de vida. V&aacute;lido del 01/08/2015 al 31/08/2015. Tasa Nominal Anual (TNA) 0%, Tasa Efectiva Anual (TEA) 0%. Promoci&oacute;n v&aacute;lida en toda la Rep&uacute;blica Argentina abonando con tarjetas de cr&eacute;dito Visa de Banco Industrial. V&aacute;lido para consumos hasta en 12 cuotas</li><li> <span class="bank">Cabal: </span>Vigente desde 01/08/2015 hasta 31/08/2015, para el pago de consumos con Tarjeta de Cr&eacute;dito Cabal emitidas en la Rep&uacute;blica Argentina, excepto AgroCabal y Cabal Mayorista. 3 cuotas sin inter&eacute;s: consulte CFT en la entidad emisora de su tarjeta.</li><li> <span class="bank">Provencred: </span>Costo Financiero Total Nominal Anual 3,67% (Tasa Nominal Anual:0%, Tasa Efectiva Anual:0% y costo de seguro de vida sobre saldo deudor 0,35%). Promoci&oacute;n v&aacute;lida en la Rep&uacute;blica Argentina desde el 03/08/2015 hasta el 31/08/2015. Comprando con las tarjetas Visa de Provencred recibir&aacute; una financi&oacute;n de hasta 6 cuotas sin inter&eacute;s. Promoci&oacute;n no acumulable con otras promociones.</li><li> <span class="bank">Tucuman: </span>Promoci&oacute;n para compras con tarjetas de cr&eacute;dito Visa y Mastercard de los Bancos de Grupo Macro enmercadolibre.com.ar. Valida desde el 05/08/2015 hasta el 16/08/2015 inclusive. Hasta 6 cuotas sin inter&eacute;s. TNA (Tasa Nominal Anual) 0%, TEA (Tasa Efectiva Anual) 0%, CFTNA (Costo Financiero Total) 2.10% (incluye seguro de vida sobre saldos). No v&aacute;lido  tarjetas de cr&eacute;dito Empresa y/o Agro. No aplica a productos del Rubro Electro. No acumulable con otras promociones. Los establecimientos, los productos y/o servicios que comercializan o la calidad de los mismos no son promocionados ni garantizados por los Bancos del Grupo Macro, como as&iacute; tampoco se responsabilizan por los cupones presentados fuera de t&eacute;rmino por los comercios. Promoci&oacute;n no acumulable con otras promociones.  MercadoLibre S.R.L., CUIT 30-70308853-4, Domicilio: Arias 3751, CABA.  Consulte bases, condiciones, alcances de la promoci&oacute;n, y toda informaci&oacute;n adicional en  beneficiosmacro.com.ar o al 0810-888-3300 o en la sucursal mas cercana a tu domicilio.</li><li> <span class="bank">Banco de La Pampa: </span>Promoci&oacute;n v&aacute;lida desde el 01/08/2015 hasta el 31/08/2015 para las compras que sean abonadas en MercadoLibre con las tarjetas de cr&eacute;dito Mastercard y Visa emitidas por el Banco de La Pampa. La promoci&oacute;n aplica para las compras realizadas en hasta 6 cuotas sin inter&eacute;s. Promoci&oacute;n no v&aacute;lida para Tarjetas de Cr&eacute;dito Corporativas, Empresa o Tarjetas de D&eacute;bito. Quedan excluidas las cuentas en mora y/o bloqueadas por motivos administrativos. El Banco de La Pampa no promueve los bienes y/o servicios ni al proveedor de los mismos. Los bienes y/o servicios aqu&iacute; mencionados se ofrecen bajo responsabilidad exclusiva del establecimiento o proveedor de los bienes y/o servicios. Tasa Nominal Anual 0%, Tasa Efectiva Anual 0%, Costo Financiero Total: a) 3,59% (incluye seguro de vida sobre saldo deudor para menores de 65 años) - b) 4,76% (incluye seguro de vida sobre saldo deudor para mayores de 65 años).</li></ul></div></div>

</div>
<!--! cuerpo principal -->

</div><!--! container -->

<jsp:include page="/portal/footer.jsp">
    <jsp:param name="page" value="home" />
</jsp:include>

<script>window.jQuery || document.write('<script src="<%= Param.getAplicacion()%>portal/js/vendor/jquery-1.8.0.min.js"><\/script>')</script>

<script src="https://a248.e.akamai.net/secure.mlstatic.com/org-img/ch/ui/0.11.1/chico-jquery.min.js"></script>

<script>
	function overlay() {
		el = document.getElementById("overlay");
		el.style.visibility = (el.style.visibility == "visible") ? "hidden" : "visible";
	}
	function overlay2() {
		el = document.getElementById("overlay2");
		el.style.visibility = (el.style.visibility == "visible") ? "hidden" : "visible";
	}
	<%      if ( poliza_mens != null )  {
	    %>
		el = document.getElementById("overlay2");
		el.style.visibility = "visible";
	<%   }
	        if ( certError != null ) {
	    %>
		el = document.getElementById("overlay");
		el.style.visibility = "visible";
	<%   }
	    %>
    
    function payment() {
    	
    	// Validation fields
    	var dni = $('#dni_payment');
    	var poliza = $('#poliza_payment');
    	var rama = jQuery("select[name=rama]");
    	
    	if(dni!=null && dni.val().length == 0){
    		$('#msg_payment').html("Por favor, ingrese un Cuit/Dni.");
    		$('#msg_payment').show();
    		return false;
    	}
		if(poliza!=null && poliza.val().length == 0){
			$('#msg_payment').html("Por favor, ingrese una p&oacute;liza.");
    		$('#msg_payment').show();
    		return false;
		}
		if(rama!=null && rama.val() == -1) {
			$('#msg_payment').html("Por favor, seleccione una rama.");
    		$('#msg_payment').show();
    		return false;
		}
		
		var origencode = '<%= BeneficioTokens.procedencia_portal%>';
		var backcode = '<%= BeneficioTokens.client_page%>';
		var transactioncode = '<%=BeneficioTokens.idpaymentboth %>';
		
		$.post('<%= Param.getAplicacion()%>portal/authority.html', { numDoc: dni.val(), polizaNumber: poliza.val(), ramaCode: rama.val(), origen: origencode, backPage: backcode, idtransaction: transactioncode }, function(result) {
			if(result.success == true) {
				window.location.href = "<%= Param.getAplicacion()%>" + result.redirect;
			}else{				
				if(result.message != null || result.message != '') {
					$('#msg_payment').html(result.message);
				} else {
					$('#msg_payment').html('Por favor, intente nuevamente.');
				}
				
				$('#msg_payment').show();
			}
		}, 'json');
    	
    	return true;
    }
    
    function overlay3() {
    	
    	if ( mercadoPago == "N" ) {
            alert ("Por el momento no es posible pagar a trav&eacute;s de MercadoPago. Disculpe las molestias. Gracias ")
            return false;
        }
    	
    	$('#dni_payment').val('');
    	$('#poliza_payment').val('');
    	$('#msg_payment').html('');
    	$('#rama').prop('selectedIndex', 0);
    	el = document.getElementById("overlay3");
    	el.style.visibility = (el.style.visibility == "visible") ? "hidden" : "visible";
    }
    
    var $loading = $('#loadingDiv').hide();
    $(document)
      .ajaxStart(function () {
        $loading.show();
      })
      .ajaxStop(function () {
        $loading.hide();
      });
    
    var conditionsModal = $("#conditions").modal({
        content: "#legals",
        width: 800,
        height: 500
	});
    
</script>

<script src="<%= Param.getAplicacion()%>portal/js/plugins.js"></script>
<script src="<%= Param.getAplicacion()%>portal/js/main.js"></script>

<!-- Google Analytics: change UA-XXXXX-X to be your's ID. -->
<script>
    //var _gaq=[['_setAccount','UA-XXXXX-X'],['_trackPageview']];
    //(function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];
    //g.src=('https:'==location.protocol?'//ssl':'//www')+'.google-analytics.com/ga.js';
    //s.parentNode.insertBefore(g,s)}(document,'script'));
</script>
</body>
</html>
