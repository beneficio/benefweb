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

<meta property="og:title" content="Datos Personales">
<meta property="og:type" content="website">
<meta property="og:url" content="https://www.beneficioweb.com.ar">
<meta property="og:image" content="<%= Param.getAplicacion()%>portal/img/avatar.png">
<meta property="og:site_name" content="Beneficio SA - Compa&ntilde;ia de Seguros">
<meta property="fb:admins" content="100004514563818">
<meta property="og:description" content="BENEFICIO S.A. Compa&ntilde;&iacute;a de Seguros fue formada el 01 de julio de 1995,
con las m&aacute;s recientes caracter&iacute;sticas establecidas por la Superintendencia de Seguros de la Naci&oacute;n para empresas que desarrollan los ramos Vida, Salud, Sepelio Y Accidentes Personales,
que son ramos espec&iacute;ficos de los seguros sobre las personas. A partir de mayo 2011 estamos autorizados por la SSN a comercializar Seguros de Caucion">

<!--! Facebook's Open graph ends -->

<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon" />

<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/normalize.css">
<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/skeleton.css">
<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/main.css">
<script type="text/javascript" src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
</head>

<body class="loading">
<jsp:include page="/portal/header.jsp">
    <jsp:param name="page" value="home" />
</jsp:include>
<!-- cuerpo principal -->
<div class="container" role="main">

<div class="row">
    <div class="sixteen columns alpha tpage">
	<h2 class="h-page">procedimiento para modificaci&oacute;n de datos personales</h2>
    </div>
</div>

<div class="row">
	<!-- left -->
    <div class="eleven columns alpha">

    <section id="product-detail">

            <div class="action-bar">

            <!-- social buttons -->
            <div class="social-wrap">

            <!-- <div class="fb-like" data-send="false" data-width="120" data-show-faces="false" data-font="arial"></div> -->

            <a href="https://twitter.com/share" class="twitter-share-button" data-via="beneficioweb" data-lang="es" data-related="beneficioweb" data-hashtags="seguros" data-dnt="true">Twittear</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="https://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>

            <div class="g-plusone" data-size="medium"></div>
            <script type="text/javascript">
              window.___gcfg = {lang: 'es-419'};

              (function() {
                var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
                po.src = 'https://apis.google.com/js/plusone.js';
                var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
              })();
            </script>

            </div>
            <!--! social buttons -->

            <div class="toolbar">
                <a href="javascript:window.print()" title="imprimir" class="ic_t print">Imprimir</a>
<!--                <a href="#" title="descargar pdf" class="ic_t pdf">Descargar PDF</a>
-->
            </div>

            </div>
        <p>
<b>Procedimiento</b><br><br>
El titular de los datos tiene derecho a solicitar a BENEFICIO S.A. COMPA&Ntilde;&iacute;A DE SEGUROS  le brinde la informaci&oacute;n que tiene almacenada.<br>
A efectos poder corroborar la validez del destinatario de los datos, esta solicitud debe ser dirigida al Gerente de Administraci&oacute;n y Finanzas a trav&eacute;s de nota firmada (original y copia) por el titular o en caso de persona jur&iacute;dica por apoderado.<br>
En el caso de las personas f&iacute;sicas, deber&aacute; adjuntar fotocopia de un documento que
acredite identidad y en el caso de personas jur&iacute;dicas, deber&aacute; adjuntar poder que acredite la personer&iacute;a.<br>
Una vez que el titular haya entregado en la Compa&ntilde;&iacute;a la nota antes mencionada, la
misma deber&aacute; ser sellada y entrega copia al titular.<br>
El Gerente de Administraci&oacute;n y Finanzas cursara dicho pedido al departamento de
Sistemas, quien proceder&aacute; operativamente a responder la informaci&oacute;n solicitada en base a la informaci&oacute;n que obre en la base de datos de la Cia.<br>
La Compa&ntilde;&iacute;a tiene un plazo de diez d&iacute;as corridos para contestar el requerimiento.<br>
La informaci&oacute;n que debe brindar debe ser clara, completa y acompa&ntilde;ada de una
explicaci&oacute;n en lenguaje accesible al conocimiento medio de la poblaci&oacute;n, amplia y
comprensiva de la totalidad del registro que obre sobre el titular de los datos.<br>
La respuesta deber&aacute; realizarse a trav&eacute;s de nota escrita y firmada por el Gerente de
Administraci&oacute;n y Finanzas con los datos obtenidos de la base de datos de la Cia.<br>
En el supuesto de que la informaci&oacute;n existente en nuestros registros sea incompleta o
falsa, el titular de los datos tiene derecho a proceder a su rectificaci&oacute;n y, de
corresponder, su eliminaci&oacute;n. BENEFICIO S.A. COMPA&Ntilde;&iacute;A DE SEGUROS  tiene obligaci&oacute;n de realizar las correcciones necesarias.<br>
Las correcciones deber&aacute;n realizarse dentro de los 5 d&iacute;as h&aacute;biles de recibida la
rectificaci&oacute;n o solicitud de baja, indicada expresamente por el Gerente de Administraci&oacute;n y Finanzas a las &aacute;reas que corresponda seg&uacute;n párrafo anterior de la presente.<br>
Si la Compa&ntilde;&iacute;a no cumpliera con esta solicitud el due&ntilde;o de los datos tiene habilitada la
v&iacute;a judicial para realizar un Habeas Data, tendiente a que se informe, rectifique y, en su caso, elimine la informaci&oacute;n referente a la persona.<br>
      </p>
    </section>

    </div><!--! left -->

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