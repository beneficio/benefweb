<%-- 
    Document   : cvForm
    Created on : 07/11/2012, 14:59:19
    Author     : relisii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.business.util.*"%>
<% String sOk = request.getParameter("ok");
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
<SCRIPT type="text/javascript" language='javascript'>
<!--
function validateEmail(){

   var emailID = document.form2.email.value;
   atpos = emailID.indexOf("@");
   dotpos = emailID.lastIndexOf(".");
   if (atpos < 1 || ( dotpos - atpos < 2 ))
   {
       alert("Por favor, escriba bien su dirección de correo")
       document.form2.email.focus() ;
       return false;
   }
   return( true );
}

function validate(){
   if( document.form2.nombre.value == "" )
   {
     alert( "Por favor, ingrese un nombre válido!" );
     document.form2.nombre.focus() ;
     return false;
   }

   if( document.form2.provincia.value == "0" )
   {
     alert( "Por favor, seleccione una provincia" );
     document.form2.provincia.focus() ;
     return false;
   }

   if( document.form2.localidad.value == "" )
   {
     alert( "Por favor, ingrese la localidad!" );
     document.form2.localidad.focus() ;
     return false;
   }

    if( document.form2.telefono1.value == "" &&
        document.form2.telefono2.value == "" &&
        document.form2.email.value == "" ) {
     alert( "Por favor, ingrese un número de teléfono o email donde podamos contactarlo!" );
     document.form2.telefono1.focus() ;
     return false;
   }

   if( document.form2.email.value != "" ) {
     // Put extra check for data format
     var ret = validateEmail();
     if( ret == false ) {
        return false;
     }
   }

    if( document.form2.postula.value == "0" )
   {
     alert( "Por favor, seleccione a que puesto se postula !" );
     document.form2.postula.focus() ;
     return false;
   }

   var extensiones_permitidas = new Array(".DOC", ".PDF", ".doc", ".pdf");
   var mierror = "";
   var archivo = document.form2.FILE1.value;
   if (!archivo) {
      //Si no tengo archivo, es que no se ha seleccionado un archivo en el formulario
//       mierror = "No has seleccionado ningún archivo";
     alert( " No has seleccionado ningún archivo !" );
     document.form2.FILE1.focus() ;
     return false;
   }else{
  //recupero la extensión de este nombre de archivo
       extension = (archivo.substring(archivo.lastIndexOf("."))).toLowerCase();
          //alert (extension);
          //compruebo si la extensión está entre las permitidas
       permitida = false;
       for (var i = 0; i < extensiones_permitidas.length; i++) {
        if (extensiones_permitidas[i] == extension) {
         permitida = true;
         break;
         }
      }
      if (!permitida) {
         mierror = "Curriculum VItae inválido. \nSólo se pueden subir archivos con extensiones: " + extensiones_permitidas.join();
         alert( mierror);
         document.form2.FILE1.focus() ;
         return false;
       }
  }

   if( document.form2.captcha.value != 5 )
   {
     alert( "Captcha incorrecto! Compruebe que es humano, ingrese la respuesta para suma correctamente" );
     document.form2.captcha.focus() ;
     return false;
   }

   return( true );
}
//-->
</SCRIPT>
</head>

<body class="loading">
<jsp:include page="/portal/header.jsp">
    <jsp:param name="page" value="home" />
</jsp:include>
<!-- cuerpo principal -->
<div class="container" role="main">

<div class="row">
	<div class="sixteen columns alpha tpage">
	<h2 class="h-page">ingreso de curriculum vitae</h2>
    </div>
</div>

<div class="row">
	<!-- left -->
    <div class="eleven columns alpha">

    <section id="form-sn">
    <p class="info-form">
    En Beneficio S.A brindamos atención personalizada
    a todos nuestros colaboradores, asesorándolos y
    facilitándoles la gestión administrativa.
    Para lograrlo, establecemos contacto con profesionales, técnicos, estudiantes próximos a graduarse de todas las áreas vinculadas al ámbito del Seguro.

    Si estás interesado en sumarte a nuestro equipo,
    envianos tu currículum vitae, completando el formulario con tus datos. Una vez que recepcionemos tu CV automáticamente, serás incorporado en nuestra base de datos de postulantes.
    </p>
        <!-- mensaje del formulario -->
<%       if (sOk != null) {
            if (sOk.equals("ok")) {
    %>
        <!-- si estÃ¡ bien -->
                <span class="result ok">El curriculum ha sido enviado con exito. Muchas Gracias</span>
<%          } else {
    %>
        <!-- si da error -->
                <span class="result error"><%= sOk %></span>

        <!--! mensaje del formulario -->
<%          }
        }
        %>

    <!-- formulario ingreso cv -->
      <form action="<%= Param.getAplicacion()%>portal/upload.jsp" method="post"
            enctype="multipart/form-data" name="form2" id="form2" onsubmit="return(validate());" novalidate>
          <div class="form-file">
          <input id="nombre" name="nombre" type="text" class="name-surname" placeholder="Nombre y Apellido" tabindex="1" >
          </div>
          <div class="form-file">
          <input id="domicilio" name="domicilio" type="text" maxlength="50" class="dir" placeholder="Dirección" tabindex="2">
          </div>
          <div class="form-file">
          <select id="provincia" name="provincia" class="provincia" tabindex="3">
          	  <option value="0" class="selected" selected="">Seleccione Provincia</option>
              <option value="BUENOS_AIRES">Buenos Aires</option>
              <option value="CAPITAL_FEDERAL">Capital Federal</option>
          	  <option value="CATAMARCA">Catamarca</option>
          	  <option value="CHACO">Chaco</option>
          	  <option value="CHUBUT">Chubut</option>
              <option value="CORDOBA">Córdoba</option>
          	  <option value="CORRIENTES">Corrientes</option>
          	  <option value="ENTRE RIOS">Entre Rios</option>
          	  <option value="FORMOSA">Formosa</option>
          	  <option value="JUJUY">Jujuy</option>
          	  <option value="LA_PAMPA">La Pampa</option>
          	  <option value="LA_RIOJA">la Rioja</option>
          	  <option value="MENDOZA">Mendoza</option>
          	  <option value="MISIONES">Misiones</option>
          	  <option value="NEUQUEN">Neuquen</option>
          	  <option value="RIO_NEGRO">Rio Negro</option>
          	  <option value="SALTA">Salta</option>
          	  <option value="SAN_JUAN">San Juan</option>
          	  <option value="SAN_LUIS">San Luis</option>
          	  <option value="SANTA_CRUZ">Santa Cruz</option>
          	  <option value="SANTA_FE">Santa Fe</option>
          	  <option value="SANTIAGO_DEL_ESTERO">Santiago del Estero</option>
          	  <option value="TIERRA_DEL_FUEGO">Tierra del Fuego</option>
              <option value="TUCUMAN">Tucumán</option>
          </select>
          <input id="localidad" name="localidad" type="text" maxlength="50" class="city" placeholder="Localidad" tabindex="4">
          </div>
          <div class="form-file">
          <input id="telefono1" name="telefono1" type="tel" class="tel1" placeholder="Teléfono Fijo" tabindex="5">
          <input id="telefono2" name="telefono2" type="tel" class="tel2" placeholder="Teléfono Celular" tabindex="6">
          </div>
          <div class="form-file">
          <input id="email" name="email" type="email" maxlength="50" class="email" placeholder="E-mail" tabindex="7">
          </div>
          <div class="form-file">
<!--          <input id="edad" name="edad" type="text" maxlength="3" class="age" placeholder="Edad" tabindex="8">
-->
          <select id="postula" name="postula" class="charge" tabindex="9">
                  <option value="0" class="selected" selected>Puesto al que se postula</option>
                  <option value="Administrativo" >Administrativo</option>
                  <option value="Comercial" >Comercial</option>
                  <option value="Productor" >Productor</option>
                  <option value="Otro" >Otro</option>
                  <!-- más opciones -->
          </select>
          </div>
          <div class="form-file">
          <input type="file"  name= "FILE1"   id="FILE1"  value="">
          </div>
          <div class="form-file">
          <textarea id="experiencia" name="experiencia" class="message" placeholder="Describa brevemente su experiencia" tabindex="10"></textarea>
          </div>
          <div class="form-file">
          <div class="captcha">
          <label for="captcha">Cuanto es 1 + 4 ?</label> <input id="captcha" name="captcha" type="text" class="answer" tabindex="11">
          </div>
              <input type="submit" value="Enviar Formulario" id="submitir" name="submitir" class="send-form" tabindex="12">
       	  </div>

       </form>
        <!-- /.formulario ingreso cv -->
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