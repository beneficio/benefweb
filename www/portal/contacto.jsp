<%-- 
    Document   : contacto
    Created on : 24/10/2012, 16:13:51
    Author     : relisii
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.business.util.*"%>
<%  String emailDestino = (request.getParameter ("email") == null ? "veficovich@beneficio.com.ar" : request.getParameter ("email") );

    String asunto   = (request.getParameter ("asunto") == null ? "" : request.getParameter ("asunto") );
    int   codMotivo = (request.getParameter ("cod_motivo") == null ? 0 : Integer.parseInt (request.getParameter ("cod_motivo")) );
    String ok       = (String) request.getAttribute("enviado");
    %>
<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="es-419" xmlns:og="http://ogp.me/ns#"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="es-419" xmlns:og="http://ogp.me/ns#"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="es-419" xmlns:og="http://ogp.me/ns#"> <![endif]-->
<!--[if IE 9]>         <html class="no-js lt-ie10" lang="es-419" xmlns:og="http://ogp.me/ns#"> <![endif]-->
<!--[if gt IE 9]><!--> <html class="no-js" lang="es-419" xmlns:og="http://ogp.me/ns#"> <!--<![endif]-->
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

<meta property="og:latitude" content="-34.601563">
<meta property="og:longitude" content="-58.373108">
<meta property="og:street-address" content="Leandro N. Alem N° 530 piso 1">
<meta property="og:locality" content="Capital Federal">
<meta property="og:region" content="BS AS">
<meta property="og:postal-code" content="1047">
<meta property="og:country-name" content="Argentina">

<meta property="og:email" content="buenosaires@beneficio.com.ar">
<meta property="og:phone_number" content="+54 (011) 5236-4300">
<meta property="og:fax_number" content="+54 (011) 5236-4300">
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon" />

<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/normalize.css">
<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/skeleton.css">
<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/main.css">

<script src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
<!-- se agregaron estas 3 dependencias -->
<script type="text/javascript" src="https://maps.google.com/maps/api/js?v=3.5&sensor=false"></script>
<script src="<%= Param.getAplicacion()%>portal/js/vendor/markermanager.js"></script>
<script src="<%= Param.getAplicacion()%>portal/js/vendor/StyledMarker.js"></script>
<script type="text/javascript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript">

<!--
function validateEmail(){

   var emailID = document.cform.email.value;
   atpos = emailID.indexOf("@");
   dotpos = emailID.lastIndexOf(".");
   if (atpos < 1 || ( dotpos - atpos < 2 ))
   {
       alert("Por favor, escriba bien su dirección de correo")
       document.cform.email.focus() ;
       return false;
   }
   return( true );
}

function validate(){
   if( document.cform.nombre.value == "" )
   {
     alert( "Por favor, ingrese un nombre válido!" );
     document.cform.nombre.focus() ;
     return false;
   }

   if( document.cform.provincia.value == "0" )
   {
     alert( "Por favor, seleccione una provincia" );
     document.cform.provincia.focus() ;
     return false;
   }

   if( document.cform.localidad.value == "" )
   {
     alert( "Por favor, ingrese la localidad!" );
     document.cform.localidad.focus() ;
     return false;
   }

    if( document.cform.telefono.value == "" &&
        document.cform.email.value == "" ) {
     alert( "Por favor, ingrese un número de teléfono o email donde podamos contactarlo!" );
     document.cform.telefono.focus() ;
     return false;
   }

   if( document.cform.email.value != "" ) {
     // Put extra check for data format
     var ret = validateEmail();
     if( ret == false ) {
        return false;
     }
   }

    if( document.cform.motivo.value == "0" )
   {
     alert( "Por favor, seleccione un motivo!" );
     document.cform.motivo.focus() ;
     return false;
   }

   if( document.cform.consulta.value == "" )
   {
     alert( "Por favor, ingrese su consulta!" );
     document.cform.consulta.focus() ;
     return false;
   }

   if( document.cform.captcha.value != 5 )
   {
     alert( "Captcha incorrecto! Compruebe que es humano, ingrese la respuesta para suma correctamente" );
     document.cform.captcha.focus() ;
     return false;
   }

   return( true );
}
//-->
</script>
</head>

<body class="loading">
<!--[if lt IE 7]>
            <p class="chromeframe">Estas usando un explorador obsoleto. <a href="http://browsehappy.com/">Actualiza ahora</a> o <a href="http://www.google.com/chromeframe/?redirect=true">instala Google Chrome Frame</a> para una mejor experiencia en el sitio.</p>
<![endif]-->
<jsp:include page="/portal/header.jsp">
    <jsp:param name="page" value="home" />
</jsp:include>

<!-- cuerpo principal -->
<div class="container" role="main">
<div class="row">

    <section id="form-maplocation" class="sixteen columns alpha cs">
        <h2>contacto</h2>
        <p class="info-section">
            Esta es una secci&oacute;n donde podés realizar consultas, transmitirnos inquietudes, solicitar información, efectuar sugerencias, comentarios, pedir la cotizaci&oacute;n del seguro que usted necesita, ver nuestras sucursales
        y diferentes medios de comunicación, entre otros...
        </p>
        <!-- mensaje del formulario -->
<%       if (ok != null && ok.equals ("ok")) {
    %>
        <!-- si estÃ¡ bien -->
        <span class="result ok">El mensaje ha sido enviado con exito, pronto un representante se contactar&aacute; con usted. Muchas Gracias</span>
<%     }
    %>
        <!-- si da error -->
        <!-- <span class="result error">Mensaje de error si hubo un problema con el envio y/o validaciÃ³n</span> -->

        <!--! mensaje del formulario -->

        <div class="contact-form">
        <!-- formulario -->
        <form id="cform" name="cform" action="<%= Param.getAplicacion()%>PortalServlet"   method="post"
              onsubmit="return(validate());" novalidate>
            <input type="hidden" name="email_destino" id="email_destino" value="<%= emailDestino%>">
            <input type="hidden" name="asunto" id="asunto" value="<%= asunto %>">
            <input type="hidden" name="opcion" id="opcion" value="setContacto">
          <div class="form-file">
              <input id="nombre" name="nombre" type="text" class="name-surname" placeholder="Nombre y Apellido" tabindex="1" title="Nombre y apellido">
          </div>
          <div class="form-file">

          <select id="provincia" name="provincia" class="provincia" tabindex="2">
          	  <option value="0" class="selected" selected="">Seleccione Provincia</option>
                  <option value="BUENOS_AIRES">Buenos Aires</option>
                  <option value="CAPITAL_FEDERAL">Capital Federal</option>
          	  <option value="CATAMARCA">Catamarca</option>
          	  <option value="CHACO" >Chaco</option>
          	  <option value="CHUBUT" >Chubut</option>
                  <option value="CORDOBA" >C&oacute;rdoba</option>
          	  <option value="CORRIENTES" >Corrientes</option>
          	  <option value="ENTRE RIOS" >Entre Rios</option>
          	  <option value="FORMOSA" >Formosa</option>
          	  <option value="JUJUY" >Jujuy</option>
          	  <option value="LA_PAMPA" >La Pampa</option>
          	  <option value="LA_RIOJA" >la Rioja</option>
          	  <option value="MENDOZA" >Mendoza</option>
          	  <option value="MISIONES" >Misiones</option>
          	  <option value="NEUQUEN" >Neuquen</option>
          	  <option value="RIO_NEGRO" >Rio Negro</option>
          	  <option value="SALTA" >Salta</option>
          	  <option value="SAN_JUAN" >San Juan</option>
          	  <option value="SAN_LUIS" >San Luis</option>
          	  <option value="SANTA_CRUZ" >Santa Cruz</option>
          	  <option value="SANTA_FE" >Santa Fe</option>
          	  <option value="SANTIAGO_DEL_ESTERO" >Santiago del Estero</option>
          	  <option value="TIERRA_DEL_FUEGO" >Tierra del Fuego</option>
                  <option value="TUCUMAN" >Tucum&aacute;n</option>
          </select>
              <input id="localidad" name="localidad" type="text" class="city" placeholder="Localidad" tabindex="1" title="Localidad">
            </div>
            <div class="form-file">
            <input id="telefono" name="telefono" type="tel" class="tel" placeholder="Teléfono" tabindex="2">
            </div>
            <div class="form-file">
            <input id="email" name="email" type="email" class="email" placeholder="E-mail" tabindex="3">
            </div>
            <div class="form-file">
            <select id="motivo" name="motivo" tabindex="4">
          	  <option value="0" <%= (codMotivo == 0 ? "class='selected' selected" : " ") %>>Tipo de consulta</option>
                  <option value="COMERCIAL" <%= (codMotivo == 1 ? "class='selected' selected" : " ") %>>Comercial</option>
                  <option value="ADMINISTRATIVO" <%= (codMotivo == 2 ? "class='selected' selected" : " ") %>>Administrativo</option>
                  <option value="SUGERENCIA/RECLAMO" <%= (codMotivo == 3 ? "class='selected' selected" : " ") %>>Sugerencia o Reclamo</option>
                  <option value="CONSULTA" <%= (codMotivo == 4 ? "class='selected' selected" : " ") %>>Consulta</option>
          </select>
          </div>
          <div class="form-file">
          <textarea id="consulta" name="consulta" class="message" placeholder="Consulta" tabindex="5"></textarea>
          </div>
          <div class="form-file">
          <div class="captcha">
          <label for="captcha">Cuanto es 1 + 4 ?</label> <input id="captcha" name="captcha" value="" type="text" class="answer" tabindex="8">
          </div>
          <input type="submit" value="Enviar Formulario" id="" name="" class="send-form" tabindex="9">
       	  </div>
       </form>
        <!-- /.formulario -->
        </div>

        <div class="google-maps">

        	<!-- maps, agregar esto -->

     		<div id="map"></div>

            <div id="map-side-bar">

              <div class="map-location" data-jmapping="{id: 1, point: {lat: -34.6016273, lng: -58.3706741}, category: 'Casa Central'}">
                <a href="#" class="map-link">Casa Central</a>
                <div class="info-box">
                    <p>Beneficio S.A. Casa Central<br>Direcci&oacute;n:<br>Av. Leandro N. Alem 584 -
                        Buenos Aires, Ciudad Aut&oacute;noma de Buenos Aires<br>
                   <a href="https://maps.google.com.ar/maps?hl=es-419&q=Leandro+N.+Alem+N%C2%B0+584,+Buenos+Aires&ie=UTF8&hq=&hnear=Av+Leandro+N.+Alem+584,+San+Nicol%C3%A1s,+Buenos+Aires&gl=ar&t=m&z=14&vpsrc=0&iwloc=A&f=d&daddr=Av+Leandro+N.+Alem+584,+Buenos+Aires,+Ciudad+Aut%C3%B3noma+de+Buenos+Aires&geocode=%3BCaRLtMVqR2xqFdIF8P0dlFaF_CkrLAAjMzWjlTEM7BIoWpP9gw" target="_blank">¿Como llegar?</a></p>
                </div>
              </div>

              <div class="map-location" data-jmapping="{id: 2, point: {lat: -32.9468269, lng: -60.636985}, category: 'Sucursal 1'}">
                <a href="#" class="map-link">Rosario</a>
                <div class="info-box">
                    <p>Sede Adm. Rosario<br>Direcci&oacute;n:<br>Av. C&oacute;rdoba 1015 - Rosario, Santa Fe<br>
                  <a href="https://maps.google.com.ar/maps?hl=es-419&q=C%C3%B3rdoba+1015,+Rosario+Santa+fe&ie=UTF8&hq=&hnear=Av+C%C3%B3rdoba+1015,+Centro,+Rosario,+Santa+Fe&gl=ar&t=m&ll=-32.940403,-60.641785&spn=0.027012,0.03828&z=14&vpsrc=6&iwloc=A&f=d&daddr=Av+C%C3%B3rdoba+1015,+Rosario,+Santa+Fe&geocode=%3BCU3r7wJ5DlroFQFGCf4dusBi_CkzIJmhGau3lTH5ifN8KoiFkQ" target="_blank">¿Como llegar?</a></p>
                </div>
              </div>

<%--              <div class="map-location" data-jmapping="{id: 3, point: {lat: -24.7868881, lng: -65.413726}, category: 'Sucursal 2'}">
                <a href="#" class="map-link">Salta</a>
                <div class="info-box">
                    <p>Oficina Salta<br>Direcci&oacute;n:<br>20 de Febrero 789 Local 6 - Salta<br><a href="https://maps.google.com.ar/maps?f=d&source=s_q&hl=es-419&geocode=%3BCe15bWgsQWgjFW7Hhf4d8N0Z_CkZovJausMblDF8FRf1tSsEBg&q=Belgrano+808,+Salta&aq=&sll=-32.946687,-60.636998&sspn=0.015468,0.027874&gl=ar&ie=UTF8&hq=&hnear=Av+Belgrano+808,+Salta&t=m&ll=-24.767642,-65.41852&spn=0.029226,0.03828&z=14&vpsrc=6&iwloc=A&daddr=Av+Belgrano+808,+Salta" target="_blank">¿Como llegar?</a></p>
                </div>
--%>
              <div class="map-location" data-jmapping="{id: 3, point: {lat: -24.7847873, lng: -65.4131389}, category: 'Sucursal 2'}">
                <a href="#" class="map-link">Salta</a>
                <div class="info-box">
                    <p>Oficina Salta<br>Direcci&oacute;n:<br>20 de febrero 388 local 6 - Salta<br>
                        <a href="https://www.google.com.ar/maps/place/Calle+20+de+febrero+388,+Salta/@-24.7847873,-65.4131389,17z/data=!3m1!4b1!4m2!3m1!1s0x941bc3bbd68383ef:0xc5767c3e81ae823" target="_blank">¿Como llegar?</a></p>
                </div>
              </div>
              <div class="map-location" data-jmapping="{id: 5, point: {lat: -31.4184636, lng: -64.1913705}, category: 'Sucursal 4'}">
                  <a href="#" class="map-link">C&oacute;rdoba</a>
                <div class="info-box">
                    <p>Oficina C&oacute;rdoba<br>Direcci&oacute;n:<br>Ayacucho 341 3B, C&oacute;rdoba<br>
                        <a href="https://www.google.com/maps/place/Ayacucho+341,+X5000JUG+C%C3%B3rdoba,+Argentina/@-31.418539,-64.1911331,17z/data=!3m1!4b1!4m2!3m1!1s0x9432a2813ab23c45:0x51960471294fabf0" target="_blank">¿Como llegar?</a></p>
                </div>
              </div>
              <div class="map-location" data-jmapping="{id: 6, point: {lat: -24.1825892, lng: -65.305701}, category: 'Sucursal 6'}">
                  <a href="#" class="map-link">Jujuy</a>
                <div class="info-box">
                    <p>Oficina Jujuy<br>Direcci&oacute;n:<br>Gral. Balcarce 537, Local 2 4600 San Salvador de Jujuy<br>
                        <a href="https://www.google.com/maps?q=Gral.+Balcarce+537,+Y4600ECK+San+Salvador+de+Jujuy,+Jujuy,+Argentina&ftid=0x941b0f6a7084e525:0x16a436f060f55fd6" target="_blank">¿Como llegar?</a></p>
                </div>
              </div>
            </div>
            <!--! maps, hasta acÃ¡ -->

       </div>

    </section>

    <section id="contact-information" class="sixteen columns alpha cs">
    <p class="info-section">
    Hemos incorporado nuevos números telefónicos, con los cuales haciendo una llamada local desde Rosario, Salta o Buenos Aires usted podrá comunicarse con cualquiera de nuestras oficinas. Si usted no reside en estas ciudades,
    podrá seleccionar el teléfono que más le convenga según su cercanía. Este nuevo servicio le permitirá una mejor calidad y administración en sus costos de comunicación:
    </p>

    <div class="contact-left">
    <!-- hcard bs as -->
     <address id="buenos-aires" class="vcard body">
    		<span class="fn">Casa Central</span>
    		<span class="adr">
            	<span class="street-address">Leandro N. Alem N° 584 piso 12</span>
            	<span class="postal-code">(1001)</span>
                <span class="locality">Capital Federal</span>
            </span>
            <span class="tel">
                 <span class="type">Tel/Fax: </span>
                 <span class="value">+54 (011) 5236-4300</span>
            </span>
            <span class="email">
                 <span class="value">casacentral@beneficio.com.ar</span>
            </span>
    </address>

    <!-- hcard sede admin. rosario -->
     <address id="rosario" class="vcard body">
    		<span class="fn">Sede Administrativa - Rosario</span>
    		<span class="adr">
            	<span class="street-address">Córdoba 1015, Galería Victoria Mall, Piso 2º oficina 7</span>
            	<span class="postal-code">(2000)</span>
                <span class="locality">Rosario</span>
            </span>
            <span class="tel">
                 <span class="type">Tel/Fax: </span>
                 <span class="value">+54 (0341) 527-1071</span>
            </span>
            <span class="email">
                 <span class="value">beneficio@beneficio.com.ar</span>
            </span>
    </address>

    <!-- hcard agencia salta -->
     <address id="salta" class="vcard body">
    		<span class="fn">Oficina Salta</span>
    		<span class="adr">
            	<span class="street-address">Santiago del Estero 789 Local 6</span>
            	<span class="postal-code">(4400)</span>
                <span class="locality">Salta</span>
            </span>
            <span class="tel">
                 <span class="type">Tel/Fax: </span>
                 <span class="value">+54 (0387) 480-0830</span>
            </span>
            <span class="email">
                 <span class="value">salta@beneficio.com.ar</span>
            </span>
    </address>

    <!-- hcard agencia Cordoba -->
     <address id="cordoba" class="vcard body">
            <span class="fn">Oficina C&oacute;rdoba</span>
    		<span class="adr">
            	<span class="street-address">Ayacucho 341 - 5 A </span>
            	<span class="postal-code">(5000)</span>
                <span class="locality">C&oacute;rdoba</span>
            </span>
            <span class="tel">
                 <span class="type">Tel/Fax: </span>
                 <span class="value">+54 (0351) 568-1000</span>
            </span>
            <span class="email">
                 <span class="value">cordoba@beneficio.com.ar</span>
            </span>
    </address>

    <!-- hcard Jujuy -->
     <address id="jujuy" class="vcard body">
            <span class="fn">Oficina Jujuy</span>
    		<span class="adr">
            	<span class="street-address">Balcarce 537 - Local 2</span>
            	<span class="postal-code">(4600)</span>
                <span class="locality">San Salvador de Jujuy</span>
            </span>
            <span class="tel">
                 <span class="type">Tel/Fax: </span>
                 <span class="value">+54 (0387) 480-5061</span>
            </span>
            <span class="email">
                 <span class="value">jujuy@beneficio.com.ar</span>
            </span>
    </address>

    <!-- hcard agencia Mendoza -->
<%--     <address id="mendoza" class="vcard body">
            <span class="fn">Oficina Mendoza</span>
    		<span class="adr">
                    <span class="street-address">Av. Jos&eacute; Vicente Zapata 197</span>
            	<span class="postal-code">(5500)</span>
                <span class="locality">Mendoza</span>
            </span>
            <span class="tel">
                 <span class="type">Tel/Fax: </span>
                 <span class="value">+54 (0261) 476-2006</span>
            </span>
            <span class="email">
                 <span class="value">mendoza@beneficio.com.ar</span>
            </span>
    </address>
--%>
    </div>
    <div class="contact-right">

    		<span class="fn">Internos</span>
    		<span class="int">
            	<span class="col1">
                    <span class="dpto">Depto. Comercial</span>
                    <span class="dpto">Siniestros</span>
                    <span class="dpto">Cobranzas Buenos Aires</span>
                    <span class="dpto">Cobranzas Rosario</span>
                    <span class="dpto">Depto. Emisión</span>
                    <span class="dpto">Depto. Caución</span>
                    <span class="dpto">Agencia Buenos Aires</span>
                    <span class="dpto">Agencia Rosario</span>
                    <span class="dpto">Agencia Salta</span>
                    <span class="dpto">Operadora</span>
                </span>
                <span class="col2">
                    <span class="value">0</span>
                    <span class="value">1</span>
                    <span class="value">2</span>
                    <span class="value">3</span>
                    <span class="value">4</span>
                    <span class="value">5</span>
                    <span class="value">6</span>
                    <span class="value">7</span>
                    <span class="value">8</span>
                    <span class="value">9</span>
                </span>
     		</span>
    </div>

    <div class="bottom-emails">

            <span class="email col1">
                <span class="fn">webmail de beneficio s.a.</span>
                <span class="info">Ingrese desde aquí a su cuenta de mail de beneficiosa.com.ar</span>
                <span class="value"><a href="http://www.beneficiosa.com.ar:8080/webmail/src/login.php" title="Webmail de Beneficio S.A." target="_blank" >Webmail de Beneficio S.A.</a></span>
            </span>

            <span class="email col2">
                <span class="fn">contacto técnico</span>
                <span class="info">Consulte desde aqui cualquier error y/o información sobre el sitio</span>
                <span class="value"><a  href="mailto:webmaster@beneficio.com.ar" title="Comunicarse con un técnico">webmaster@beneficio.com.ar</a></span>
            </span>

    </div>

    </section>

</div>

<!--! cuerpo principal -->

</div><!--! container -->

<jsp:include page="/portal/footer.jsp">
    <jsp:param name="page" value="home" />
</jsp:include>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js"></script>
<script>window.jQuery || document.write('<script src="<%= Param.getAplicacion()%>portal/js/vendor/jquery-1.8.0.min.js"><\/script>')</script>

<script src="<%= Param.getAplicacion()%>portal/js/vendor/jquery.metadata.js"></script>
<script src="<%= Param.getAplicacion()%>portal/js/vendor/jquery.jmapping.js"></script>

<script src="<%= Param.getAplicacion()%>portal/js/plugins.js"></script>
<script src="<%= Param.getAplicacion()%>portal/js/main.js"></script>
<script src="<%= Param.getAplicacion()%>portal/js/contacto.js"></script>

<!-- Google Analytics: change UA-XXXXX-X to be your's ID. -->
<script>
    //var _gaq=[['_setAccount','UA-XXXXX-X'],['_trackPageview']];
    //(function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];
    //g.src=('https:'==location.protocol?'//ssl':'//www')+'.google-analytics.com/ga.js';
    //s.parentNode.insertBefore(g,s)}(document,'script'));
</script>
</body>
</html>