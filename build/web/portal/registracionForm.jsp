<%-- 
    Document   : registracionForm
    Created on : 30/10/2012, 14:40:32
    Author     : relisii
--%>
<%@page contentType="text/html" pageEncoding="UTF-8" errorPage="/error.jsp"%>
<%@ page import="net.tanesha.recaptcha.ReCaptcha" %>     
<%@ page import="net.tanesha.recaptcha.ReCaptchaFactory" %>
<%@page import="com.business.util.*"%>
<% String ok = (String) request.getAttribute("ok");
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

<meta property="og:title" content="Curriculum Vitae | Postulación">
<meta property="og:type" content="website">
<meta property="og:url" content="https://www.beneficioweb.com.ar">
<meta property="og:image" content="<%= Param.getAplicacion()%>portal/img/avatar.png">
<meta property="og:site_name" content="Beneficio SA - Compañia de Seguros">
<meta property="fb:admins" content="100004514563818">
<meta property="og:description" content="BENEFICIO S.A. Compañía de Seguros fue formada el 01 de julio de 1995,
con las más recientes características establecidas por la Superintendencia de Seguros de la Nación para empresas que desarrollan los ramos Vida, Salud, Sepelio Y Accidentes Personales,
que son ramos específicos de los seguros sobre las personas. A partir de mayo 2011 estamos autorizados por la SSN a comercializar Seguros de Caucion">

<!--! Facebook's Open graph ends -->

<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon" />

<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/normalize.css">
<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/skeleton.css">
<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/main.css">
<script type="text/javascript" src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
<script type="text/javascript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript">
var RecaptchaOptions = {
//    custom_translations : {
//        incorrect_try_again : "Incorrecto, vuelva a intentar"
//    },
    theme : 'white',
    lang : 'es'
 };


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
    alert (Recaptcha.get_response());
    
  var sUrl2 = "<%= Param.getAplicacion()%>portal/RecaptchaResponse.jsp?recaptcha_challenge_field="
      + encodeURIComponent( Recaptcha.get_challenge()) +
      "&recaptcha_response_field="  + encodeURIComponent(Recaptcha.get_response());

    if (oFrameCaptcha ) {
            oFrameCaptcha.location = sUrl2;

           if ( oFrameCaptcha.document.getElementById ('error')) {
               if ( oFrameCaptcha.document.getElementById ('error').value == 'false') {
  //                 Recaptcha.reload();
                   return false;
               }
           }
    }


   if( document.cform.numDoc.value == "" ||
       document.cform.numDoc.value == "0")
   {
     alert ("Ingrese el documento ");
     document.cform.numDoc.focus() ;
     return false;
   }

  if (!/^([0-9])*$/.test(document.cform.numDoc.value ) )   {
     alert( "Documento invalido, solo puede ingresar números !" );
     document.cform.numDoc.focus() ;
     return false;
   }

    if (document.cform.usuario.value == "" || document.cform.usuario.value == "0") {
        alert ("Debe ingresar un usuario de acceso válido");
        document.cform.usuario.focus();
     return false;
    }

    if (document.cform.nombre.value == "") {
        alert ("Ingrese el nombre");
        document.cform.nombre.focus();
     return false;
    }

    if ( document.cform.email.value == "" && document.cform.tel1.value == "" ) {
        alert ("Ingrese mail o teléfono ");
        document.cform.email.focus();
     return false;
    }
   if( document.cform.email.value != "" ) {
     // Put extra check for data format
     var ret = validateEmail();
     if( ret == false ) {
        return false;
     }
   }


   if (!/^([0-9])*$/.test(document.cform.matricula.value ) ) {
        document.cform.matricula.value = "0";
    }

   if ( Trim(document.cform.matricula.value) == "" ) {
        document.cform.matricula.value = "0";
    }

   if ( Trim(document.cform.matricula.value) == "Matricula" ) {
        document.cform.matricula.value = "0";
    }



//   if( document.cform.captcha.value != 5 )
//   {
//     alert( "Captcha incorrecto! Compruebe que es humano, ingrese la respuesta para suma correctamente" );
//     document.cform.captcha.focus() ;
//     return false;
//   }

 return( true );
}
-->
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
	<div class="sixteen columns alpha tpage">
	<h2 class="h-page">habilitación de cuenta</h2>
    </div>
</div>

<div class="row">
	<!-- left -->
    <div class="eleven columns alpha">

    <section id="form-sn">
    <p class="info-form">
    Estimado colaborador, recuerde que el usuario de acceso a nuestra web es su código de
    productor en BENEFICIO.<br>
    Si usted tiene problemas para ingresar, por favor, complete el formulario con sus datos y le enviaremos la clave de acceso.<br>
    Para ello, el documento, matr&iacute;cula y email deberían coincidir con los datos registrados en nuestro sistema.
    Si usted a&uacute;n no es productor de BENEFICIO y desea registrarse <a href="<%= Param.getAplicacion()%>/portal/cvForm.jsp">haga clik aquí</a>&nbsp;y
    un representante comercial se contactara con usted. Muchas gracias<br>
    </p>
        <!-- mensaje del formulario -->
<%       if (ok != null && ! ok.equals("captcha_invalido")) {
    %>
        <!-- si estÃ¡ bien -->
        <span class="result ok"><%= ok %></span>
<%     }
    %>

    <!-- formulario habilitación de cuenta -->
    <form name="cform" id="cform" method="post" action="<%= Param.getAplicacion()%>PortalServlet"
              onsubmit="return(validate());" novalidate>
    <input type="hidden" name="opcion" id="opcion" value="registrar">
        <div class="form-file">
           <select id="tipoDoc" name="tipoDoc" class="selec-dni" tabindex="1">
                   <option value="80"  selected>CUIT</option>
                   <option value="96">DNI</option>
           </select>
           <input id="numDoc" name="numDoc" type="text" class="dni" placeholder="Número de Documento" tabindex="2">
           <input id="usuario" name="usuario" type="text" class="cod" placeholder="Usuario de acceso" tabindex="3">
           </div>
          <div class="form-file">
          <input id="nombre" name="nombre" type="text" maxlength="50" class="name-surname" placeholder="Nombre y Apellido" tabindex="5">
          </div>
          <div class="form-file">
          <input id="email" name="email" type="email" maxlength="50" class="email" placeholder="E-mail" tabindex="6">
          </div>
          <div class="form-file">
              <input id="matricula" name="matricula" type="tel" class="tel1" placeholder="Matricula" tabindex="7" maxlength="6">
          <input id="tel1" name="tel1" type="tel" class="tel2" placeholder="Teléfono de contacto" tabindex="8">
          </div>
          <div class="form-file">
          <textarea id="comentarios" name="comentarios" class="message" placeholder="Ingrese sus comentarios" tabindex="9"></textarea>
          </div>
          <div class="form-file">
        <!-- si estÃ¡ bien -->
              <div class="captcha">
<%--              <label for="captcha">Cuanto es 1 + 4 ?</label> <input id="captcha" name="captcha" type="text" class="answer" tabindex="11">
--%>
<%
              ReCaptcha c = ReCaptchaFactory.newReCaptcha("6LcIJvISAAAAAGtrqj2PtnUd_zUnBjWzxKfIrMMB", "6LcIJvISAAAAAJ_wuDUld3vTjsPQcKOI_VpqywoU", false);
              out.print(c.createRecaptchaHtml(null, null));
    %>
            <iframe  name="oFrameCaptcha" id="oFrameCaptcha" marginheight="0" marginwidth="0" marginheight="0" align="top"  frameborder="0"  scrolling="no"
            src="<%= Param.getAplicacion()%>portal/RecaptchaResponse.jsp">
            </iframe>
            </div>
              <input type="submit" value="Enviar Formulario" id="" name="" class="send-form" tabindex="12">
       	  </div>

       </form>
        <!-- /.formulario habilitación de cuenta -->
    </section>

    </div>
    <!--! left -->

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

<script src="<%= Param.getAplicacion()%>portal/js/plugins.js"></script>
<script src="<%= Param.getAplicacion()%>portal/js/main.js"></script>

<script>
$("input[type=file]").filestyle({
     imageheight : 29,
     imagewidth : 148,
     width : 400
 });
</script>

<!-- Google Analytics: change UA-XXXXX-X to be your's ID. -->
<script>
    //var _gaq=[['_setAccount','UA-XXXXX-X'],['_trackPageview']];
    //(function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];
    //g.src=('https:'==location.protocol?'//ssl':'//www')+'.google-analytics.com/ga.js';
    //s.parentNode.insertBefore(g,s)}(document,'script'));
</script>
</body>
</html>