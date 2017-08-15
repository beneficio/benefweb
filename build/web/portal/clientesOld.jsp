<%@page contentType="text/html" pageEncoding="UTF-8" errorPage="/error.jsp"%>
<%@page import="com.business.beans.Portal"%>
<%@page import="com.business.beans.PortalTexto"%>
<%@page import="com.business.beans.PortalTabla"%>
<%@page import="com.business.util.*"%>
<%  String certError   = (String) request.getAttribute("error_cert");
    String poliza_mens = (String) request.getAttribute("poliza_mens");
    String urlExtranet = config.getServletContext().getInitParameter ("urlExtranet");
    if (urlExtranet == null) { urlExtranet = "http://www.beneficioweb.com.ar/"; }

    %>

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
<meta property="og:url" content="http://www.beneficioweb.com.ar">
<meta property="og:image" content="http://www.beneficioweb.com.ar/portal/img/avatar.png">
<meta property="og:site_name" content="Beneficio SA - Compañia de Seguros">
<meta property="fb:admins" content="100004514563818">
<meta property="og:description" content="BENEFICIO S.A. Compañía de Seguros fue formada el 01 de julio de 1995,
con las más recientes características establecidas por la Superintendencia de Seguros de la Nación para empresas que desarrollan los ramos Vida, Salud, Sepelio Y Accidentes Personales,
que son ramos específicos de los seguros sobre las personas. A partir de mayo 2011 estamos autorizados por la SSN a comercializar Seguros de Caucion">

<!--! Facebook's Open graph ends -->

<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon">

<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/normalize.css">
<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/skeleton.css">
<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/main.css">
<link rel="canonical" href="https://www.beneficioweb.com.ar/url.html">
<script src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
<script type="text/javascript" language="javascript">
    function Ir () {
        document.form3.submit();
        return true;
    }
<!--
function validateEmail(){

   var emailID = document.cform.email.value;
   atpos = emailID.indexOf("@");
   dotpos = emailID.lastIndexOf(".");
   if (atpos < 1 || ( dotpos - atpos < 2 ))
   {
       alert("Por favor, escriba bien su dirección de correo")
       document.form5.email.focus() ;
       return false;
   }
   return( true );
}

function validate2(){
   if (!/^([0-9])*$/.test(document.form5.dni.value ) )
   {
     alert( "Por favor, ingrese el dni o cuit que se haya emitido la poliza !" );
     document.form4.dni.focus() ;
     return false;
   }

   if (!/^([0-9])*$/.test( document.form5.poliza.value))
   {
     alert( "Por favor, ingrese el numero de póliza " );
     document.form4.poliza.focus() ;
     return false;
   }

    if( document.form5.email.value == "" ) {
     alert( "Por favor, ingrese un email donde podamos enviarle la poliza !" );
     document.form5.email.focus() ;
     return false;
   }

   if( document.form5.email.value != "" ) {
     // Put extra check for data format
     var ret = validateEmail();
     if( ret == false ) {
        return false;
     }
   }

   return( true );
}

function validate1 (){

   if (!/^([0-9])*$/.test(document.form4.dni.value ) )
   {
     alert( "Por favor, ingrese el dni o cuit que se haya emitido la poliza !" );
     document.form4.dni.focus() ;
     return false;
   }

   if (!/^([0-9])*$/.test( document.form4.poliza.value)) 
   {
     alert( "Por favor, ingrese el numero de póliza " );
     document.form4.poliza.focus() ;
     return false;
   }

   return( true );
}

function validate(){

    document.form2.browser.value = BrowserDetect.browser;
    document.form2.version.value = BrowserDetect.version;
    document.form2.OS.value = BrowserDetect.OS;

    if ( document.form2.browser.value != 'Explorer' &&
         document.form2.browser.value != 'Firefox'  &&
         document.form2.browser.value != 'Chrome' &&
         document.form2.browser.value != 'Safari' &&
         document.form2.browser.value != 'Opera' &&
         document.form2.browser.value != 'Mozilla' &&
         document.form2.browser.value != 'Netscape') {
        alert ("NAVEGADOR INVALIDO,\n\
 Este sitio web esta optimizado para Explorer, Firefox, Chrome, Safari y Netscape. \n\
  Su navegador es: " + document.form2.browser.value );
        return false;
    }

   if( document.form2.usuario.value == "" ||
       document.form2.usuario.value == "Usuario"  )
   {
     alert( "Por favor, ingrese un usuario válido !" );
     document.form2.usuario.focus() ;
     return false;
   }

   if( document.form2.usuario.value.length > 20 )
   {
     alert( "El usuario no puede tener más de 20 caracteres" );
     document.form2.usuario.focus() ;
     return false;
   }

    if( document.form2.password.value == "" ||
        document.form2.password.value == "Contraseña") {
     alert( "Ingrese la password" );
     document.form2.password.focus() ;
     return false;
    }

    if( document.form2.password.value.length > 20) {
     alert( "La longitud de la password no debe superar los 20 caracteres" );
     document.form2.password.focus() ;
     return false;
    }

    document.form2.usuario.value = document.form2.usuario.value.toUpperCase();
    document.form2.password.value = document.form2.password.value.toUpperCase();
    return (true);
}

    function Submitir(evt) {

           var nkeyCode;
           if (document.all) {
                 nkeyCode = evt.keyCode;
           }else
             if (evt) {
                nkeyCode = evt.which;
           }

          if (nkeyCode==13) {
            document.form2.submit();
          }
    }

//-->

</script>
</head>

<body class="loading">
<form method="post" action="<%= Param.getAplicacion()%>portal/contacto.jsp" name='form3' id='form3'>
    <input type="hidden" name="asunto" id="asunto" value="Beneficio On Line (Clientes)">
    <input type="hidden" name="email" id="email" value="produccion@beneficiosa.com.ar">
    <input type="hidden" name="cod_motivo" id="cod_motivo" value="2">
</form>
<!--[if lt IE 7]>
            <p class="chromeframe">Estas usando un explorador obsoleto. <a href="http://browsehappy.com/">Actualiza ahora</a> o <a href="http://www.google.com/chromeframe/?redirect=true">instala Google Chrome Frame</a> para una mejor experiencia en el sitio.</p>
<![endif]-->

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
    <p class="info-page">
        Estimado cliente, usted desde aqui podr&aacute; obtener su certificado de cobertura o copia de p&oacute;liza.<br>
        Cuando se le solicite Cuit o DNI deber&aacute; ingresar el mismo con el cual se  haya emitido la p&oacute;liza.<br>
        En el caso de requerir una copia de p&oacute;liza la misma ser&aacute; enviada inmediatamente al mail que usted ingrese.<br><br>
        Si usted ya es un cliente registrado que administra su propia cartera,
        <a  href="<%= urlExtranet %>portal/extranet.jsp" target="_blank">haga clik aquí.</a>
    </p>
    <div class="downloads">
    <a href="#" id="cert" class="document cert" title="" onclick="overlay(); return false;"></a>
    <a href="#" id="pol" class="document pol" title="" onclick="overlay2(); return false;"></a>
    <span class="help">Seleccione lo que desea descargar</span>
    </div>

    <span class="line-break"></span>
    <a href="#" title="Contactar un asesor de Beneficio SA" class="bt-contact" onclick="javascript:Ir();">Contactar Asesor</a>

    </section>


    </div>
    <!--! left -->
    <!-- right -->
    <jsp:include page="/portal/right.jsp">
        <jsp:param name="page" value="home" />
    </jsp:include>

</div>
<!--! cuerpo principal -->

</div><!--! container -->

<jsp:include page="/portal/footer.jsp">
    <jsp:param name="page" value="home" />
</jsp:include>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js"></script>
<script>window.jQuery || document.write('<script src="<%= Param.getAplicacion()%>portal/js/vendor/jquery-1.8.0.min.js"><\/script>')</script>

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
