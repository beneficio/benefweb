<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Portal"%>
<%@page import="java.util.LinkedList"%>
<% LinkedList lProd = (LinkedList) request.getAttribute ("productos");

    %>
<!DOCTYPE html>
<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="es-419"> <![endif]-->
<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="es-419"> <![endif]-->
<!--[if IE 8]>    <html class="no-js lt-ie9" lang="es-419"> <![endif]-->
<!--[if IE 9]>    <html class="no-js lt-ie10" lang="es-419"> <![endif]-->
<!--[if gt IE 9]><!--> <html class="no-js" lang="es-419"> <!--<![endif]-->
<head>

<meta charset="utf-8">
<title></title>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="description" content="">
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;">
<meta name="keywords" content="">
<meta name="author" content="">
<meta name="robots" content="index,follow">
<meta name="copyright" content="">

<!-- Facebook's Open graph starts -->

<meta property="og:title" content="Beneficio S.A. | Home">
<meta property="og:type" content="website">
<meta property="og:url" content="https://www.beneficioweb.com.ar">
<meta property="og:image" content="<%= Param.getAplicacion()%>portal/img/avatar.png">
<meta property="og:site_name" content="Beneficio SA - Compa&ntilde;a de Seguros">
<meta property="fb:admins" content="100004514563818">
<meta property="og:description" content="BENEFICIO S.A. Compa&ntilde;a de Seguros fue formada el 01 de julio de 1995,
      con las m&aacute;s recientes caracter&iacute;sticas establecidas por la Superintendencia de Seguros de la Naci&oacute;n para empresas que desarrollan los ramos Vida, Salud, Sepelio y Accidentes Personales
      que son ramos espec&iacute;ficos de los seguros sobre las personas. A partir de mayo 2011 estamos autorizados por la SSN a comercializar Seguros de Cauci&oacute;n">

<!--! Facebook's Open graph ends -->

<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon" />

<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/normalize.css">
<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/skeleton.css">
<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/main.css">
<script type="text/javascript" src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
<%--<script type="application/javascript" src="http://script2.chat-robot.com"></script>
--%>
<script type="text/javascript" language="javascript">
    function Ver ( codPortal, longTexto ) {
        if (longTexto >  0) {
            document.getElementById('cod_portal').value = codPortal;
            document.form2.submit();
        }
        return true;
    }
</script>
</head>
<body class="loading">
<form method="get" action="<%= Param.getAplicacion()%>PortalServlet" name='form2' id='form2'>
    <input type="hidden" name="opcion" id="opcion" value="productoDetalle">
    <input type="hidden" name="cod_portal" id="cod_portal" value="999">
</form>
<!--[if lt IE 7]>
            <p class="chromeframe">Estas usando un explorador obsoleto. <a href="http://browsehappy.com/">Actualiza ahora</a> o <a href="http://www.google.com/chromeframe/?redirect=true">instala Google Chrome Frame</a> para una mejor experiencia en el sitio.</p>
<![endif]-->
<jsp:include page="/portal/header.jsp">
    <jsp:param name="page" value="home" />
</jsp:include>
<!-- cuerpo principal -->
<div class="container" role="main">
<div class="row">
	<!-- left -->
    <div class="eleven columns alpha">
    <!-- slider section -->
    <section class="slider" id="featured">
          <ul class="slides" id="slides">
<%              for (int i=0;i< lProd.size();i++) {
                    Portal oP = (Portal) lProd.get(i);
                    if ( oP.getsubNivel() == 1 ) {
    %>
  	    		<li>
  	    	    <a  href="#"  onclick="javascript:Ver(<%= oP.getcodPortal() %>, 10 );">
                        <img src="<%= Param.getAplicacion()%>portal/img/<%= oP.getimagenSlider() %>" />
                    </a>
                <span class="caption">
                <h1><%= oP.gettitulo() %></h1>
                <p><%= oP.getsubtitulo() %></p>
                </span>

  	    		</li>
<%                  }
                }
    %>
          </ul>
    </section>
    <!--! slider section -->

    <section id="content" class="body">

    <h1 class="news">Novedades Beneficio <span class="line"></span></h1>

    <!-- news -->


<%  int cont = 1;
    for (int ii=0;ii< lProd.size();ii++) {
        Portal oP = (Portal) lProd.get(ii);
        if ( oP.getsubNivel() == 2 ) {
    %>
    <!-- novedad -->
    <article class="<%= (cont % 2 == 0 ? "hentry last" : "hentry" ) %>">
    <header>
    <h2 class="entry-title"><a href="#"  onclick="javascript:Ver(<%= oP.getcodPortal() %>, <%= (oP.gettexto() == null ? 0 : oP.gettexto().length()) %>);"
                               rel="bookmark" title="<%= oP.gettitulo() %>"><%= oP.gettitulo() %></a></h2>
    </header>

    <div class="entry-content">
<%      if (oP.getimagenMin() != null) {
    %>
    <figure><img src="<%= Param.getAplicacion()%>portal/img/<%= oP.getimagenMin() %>" /></figure>
<%      }
    %>
<%   if (oP.getsubtitulo() != null) {
    %>
    <p><%= oP.getsubtitulo() %></p>
<%   } else {
    %>
    <p><%= (oP.gettexto()== null ? "" :  (oP.gettexto().length() < 150 ? oP.gettexto() : (oP.gettexto().substring(0, 150) + "..."))) %></p>
<%   }
    %>
    </div>
    <!-- entry-content -->
    <div class="post-info">
        <abbr class="published" title="<%=(oP.getfechaDesde() == null ? Fecha.getFechaActual() : Fecha.showFechaForm( oP.getfechaDesde() )) %>">
            <%=(oP.getfechaDesde() == null ? Fecha.getFechaActual() : Fecha.showFechaForm( oP.getfechaDesde() )) %></abbr>
<%      if (oP.getlTextos() != null || oP.gettexto() != null ) {
    %>
            <a class="url-entry"  onclick="javascript:Ver(<%= oP.getcodPortal() %>, <%= (oP.getlTextos() == null ? (oP.gettexto() == null ? 0 : oP.gettexto().length() ) : oP.getlTextos().size()) %> );">Leer más</a>
<%     }
    %>
    </div>

    </article>
    <!--! /.novedad -->
<%       cont +=1;
        }
    }
    %>

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

<script defer src="<%= Param.getAplicacion()%>portal/js/vendor/responsiveslides.min.js"></script>
<script>
$(function () {
   $("#slides").responsiveSlides({
        auto: true,
        pager: true,
		pause: true,
        speed: 1600,
		timeout: 5000,
        nav: false
      });

});
</script>

<script src="<%= Param.getAplicacion()%>portal/js/plugins.js"></script>
<script src="<%= Param.getAplicacion()%>portal/js/main.js"></script>

<!-- Google Analytics: change UA-XXXXX-X to be your's ID. -->
<script>
    //var _gaq=[['_setAccount','UA-XXXXX-X'],['_trackPageview']];
    //(function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];
    //g.src=('https:'==location.protocol?'//ssl':'//www')+'.google-analytics.com/ga.js';
   // s.parentNode.insertBefore(g,s)}(document,'script'));
</script>
</body>
</html>