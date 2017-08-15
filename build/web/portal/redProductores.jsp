<%-- 
    Document   : redProductores
    Created on : 07/11/2012, 11:59:11
    Author     : relisii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.LinkedList"%>
<%@page import="com.business.beans.Usuario"%>
<% LinkedList lProd = (LinkedList) request.getAttribute ("productores");
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

<meta property="og:title" content="Red de Productores | Beneficio SA">
<meta property="og:type" content="website">
<meta property="og:url" content="https://www.beneficioweb.com.ar">
<meta property="og:image" content="<%= Param.getAplicacion()%>portal/img/avatar.png">
<meta property="og:site_name" content="Beneficio SA - Compa&ntilde;a de Seguros">
<meta property="fb:admins" content="100004514563818">
<meta property="og:description" content="BENEFICIO S.A. Compa&ntilde;a de Seguros fue formada el 01 de julio de 1995,
      con las m&aacute;s recientes caracter&iacute;sticas establecidas por la Superintendencia de Seguros de la Naci&oacute;n para empresas que desarrollan los ramos Vida, Salud, Sepelio y Accidentes Personales
      que son ramos espec&iacute;ficos de los seguros sobre las personas. A partir de mayo 2011 estamos autorizados por la SSN a comercializar Seguros de Cauci&oacute;n">

<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon">

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
    <input type="hidden" name="asunto" id="asunto" value="RED DE PRODUCTORES">
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
	<h2 class="h-page">red de productores</h2>
    </div>
</div>

<div class="row">
	<!-- left -->
    <div class="eleven columns alpha">

    <section id="red_productores">


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
                <a href="javascript:window.print()" title="imprimir" class="ic_t print">Imprimir</a>
                <a href="#" title="descargar pdf" class="ic_t pdf">Descargar PDF</a>
            </div>
-->
            </div>
    <h3 class="sub-title">nuestra red de productores asesores de seguros</h3>
    <p class="info-page">
    Contamos con una amplia red de productores que nos acompaña día a día, tanto en las principales localidades, como en ciudades de menor envergadura.
    </p>
    <div class="table_list">

    <div class="table_head">
    	 <span class="prov">Provincia</span>
         <span class="loc">Localidad</span>
         <span class="ca">Cantidad de Asesores</span>
    </div>

    <div class="table_body">
<%      String sProvAnt = "";
        for (int i=0; i< lProd.size();i++) {
            Usuario oProd = (Usuario) lProd.get(i);
            if ( ! oProd.getsDesProvincia().equals(sProvAnt) ) {
                sProvAnt = oProd.getsDesProvincia();
    %>
    	 <!-- 1 -->
         <div class="row control">
             <span class="prov"><%= oProd.getsDesProvincia() %></span>
         </div>
<%          }
    %>

         <div class="row">
         <span class="prov"></span>
         <span class="loc"><%= oProd.getLocalidad() %></span>
         <span class="ca"><%= oProd.getiNumSecuUsu() %></span>
         </div>
         <!--! 1 -->
<%      }
    %>

    </div>

    </div>
    <!--! table list -->

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