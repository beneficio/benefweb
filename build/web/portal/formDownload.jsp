<%--
    Document   : redProductores
    Created on : 07/11/2012, 11:59:11
    Author     : relisii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.LinkedList"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Manual"%>
<% LinkedList lArchivos = (LinkedList) request.getAttribute ("archivos");
   String pathManuales  =  Param.getAplicacion() + "files/manuales/";

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

<meta property="og:title" content="Descargar documentos | Beneficio SA">
<meta property="og:type" content="website">
<meta property="og:url" content="https://www.beneficioweb.com.ar">
<meta property="og:image" content="<%= Param.getAplicacion()%>portal/img/avatar.png">
<meta property="og:site_name" content="Beneficio SA - Compa&ntilde;a de Seguros">
<meta property="fb:admins" content="100004514563818">
<meta property="og:description" content="BENEFICIO S.A. Compa&ntilde;a de Seguros fue formada el 01 de julio de 1995,
      con las m&aacute;s recientes caracter&iacute;sticas establecidas por la Superintendencia de Seguros de la Naci&oacute;n para empresas que desarrollan los ramos Vida, Salud, Sepelio y Accidentes Personales
      que son ramos espec&iacute;ficos de los seguros sobre las personas. A partir de mayo 2011 estamos autorizados por la SSN a comercializar Seguros de Cauci&oacute;n">

<link rel="icon" href="favicon.ico" type="image/x-icon" />

<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/normalize.css">
<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/skeleton.css">
<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/main.css">
<script src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
<script type="text/javascript">
    function Ir () {
        document.form2.submit();
        return true;
    }
</script>
</head>

<body class="loading">
<form method="post" action="<%= Param.getAplicacion()%>portal/contacto.jsp" name='form2' id='form2'>
    <input type="hidden" name="asunto" id="asunto" value="DESCARGA DE DOCUMENTOS">
    <input type="hidden" name="email" id="email" value="produccion@beneficio.com.ar">
    <input type="hidden" name="cod_motivo" id="cod_motivo" value="1">
</form>
<jsp:include page="/portal/header.jsp">
    <jsp:param name="page" value="home" />
</jsp:include>
<!-- cuerpo principal -->
<div class="container" role="main">

<div class="row">
	<div class="sixteen columns alpha tpage">
	<h2 class="h-page">Descarga de formularios</h2>
    </div>
</div>

<div class="row">
	<!-- left -->
    <div class="eleven columns alpha">

    <section id="forms">


   <div class="action-bar">

            <!-- social buttons -->
            <div class="social-wrap">

            <!-- <div class="fb-like" data-send="false" data-width="120" data-show-faces="false" data-font="arial"></div> -->

            <a href="https://twitter.com/share" class="twitter-share-button" data-via="beneficioweb" data-lang="es" data-related="beneficioweb" data-hashtags="seguros" data-dnt="true">Twittear</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="https://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>

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
<!--
            <div class="toolbar">
                <a href="#" title="imprimir" class="ic_t print">Imprimir</a>
                <a href="#" title="descargar pdf" class="ic_t pdf">Descargar PDF</a>
            </div>
-->
            </div>

<!--    <h3 class="sub-title">Lorem ipsum dolor sit amet, consectetur adipiscing elit. </h3>
-->
    <p class="info-page">
    Como queremos que nuestra web sea un area de servicio tanto para el cliente como para el productor
    asesor, ponemos a su disposición documentación que puede ser útil durante su relación comercial con
    nuestra compañ&iacute;a.<br>
    De todas forma si la información que usted esta buscando no existe en esta sección la puede solicitar desde el botón Contactar Asesor.
    </p>

    <div class="downloads">

<% if (lArchivos == null ) {
    %>
         <span class="dl-doc">
         <a href="<%= Param.getAplicacion()%>PortalServlet?opcion=descargas" title="Listado de documentos">
         Haga clic aqui para obtener el listado de documentos
         </a>
         </span>

<%  } else {
       for (int i=0; i< lArchivos.size(); i++) {
            Manual oM = (Manual) lArchivos.get(i);
    %>
         <span class="dl-doc">
         <a href="<%= pathManuales %><%= oM.getlink() %>" title="<%= oM.gettitulo() %>"  target='_blank'>
         <strong><%= oM.gettitulo() %></strong><br>
         <%= oM.getmensaje() %>
         </a>
         </span>
<%      }
    }
    %>
    </div>

    <span class="line-break"></span>

    </section>

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