<%@page contentType="text/html" pageEncoding="UTF-8" errorPage="/error.jsp"%>
<%@page import="com.business.beans.Portal"%>
<%@page import="com.business.beans.PortalTexto"%>
<%@page import="com.business.beans.PortalTabla"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Hashtable"%>

<%
Portal oProd = (Portal) request.getAttribute("producto");
LinkedList lTextos = oProd.getlTextos();

if (oProd.getcodRama() == 9 ) {
    response.sendRedirect( Param.getAplicacion() + "portal/productoCaucion.jsp");
}
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
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta name="description" content="">
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;">
<meta name="keywords" content="">
<meta name="author" content="">
<meta name="robots" content="index,follow">
<meta name="copyright" content="">

<!-- Facebook's Open graph starts -->

<meta property="og:title" content="Productos | <%= oProd.getdescRama() %>">
<meta property="og:type" content="website">
<meta property="og:url" content="https://www.beneficioweb.com.ar">
<meta property="og:image" content="<%= Param.getAplicacion()%>portal/img/avatar.png">
<meta property="og:site_name" content="Beneficio SA - Compañia de Seguros">
<meta property="fb:admins" content="100004514563818">
<meta property="og:description" content="BENEFICIO S.A. Compañía de Seguros fue formada el 01 de julio de 1995,
con las más recientes características establecidas por la Superintendencia de Seguros de la Nación para empresas que desarrollan los ramos Vida, Salud, Sepelio Y Accidentes Personales,
que son ramos específicos de los seguros sobre las personas. A partir de mayo 2011 estamos autorizados por la SSN a comercializar Seguros de Caucion">

<!--! Facebook's Open graph ends -->

<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon">

<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/normalize.css" media="screen">
<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/skeleton.css" media="screen">
<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/main.css" media="screen">
<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/print.css" media="print">
<link rel="canonical" href="https://www.beneficioweb.com.ar/url.html">
<script src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
<script type="text/javascript" language="javascript">
    function Ir () {
        document.form2.submit();
        return true;
    }
</script>
</head>

<body class="loading">
<form method="post" action="<%= Param.getAplicacion()%>portal/contacto.jsp" name='form2' id='form2'>
    <input type="hidden" name="asunto" id="asunto" value="<%= oProd.gettitulo() %>">
    <input type="hidden" name="email" id="email" value="<%= (oProd.getemail() != null ? oProd.getemail() : "produccion@beneficio.com.ar") %>">
    <input type="hidden" name="cod_motivo" id="cod_motivo" value="1">
</form>
<div id="fb-root"></div>
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "https://connect.facebook.net/es_LA/all.js#xfbml=1";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>
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
	<h2 class="h-page"><%= (oProd.getcodRama() == 9 ? "seguros de caucion" :
        (oProd.getcodRama() == 999 ? "beneficio compañia de seguros" : "seguros de personas"))%></h2>
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
<%      if (oProd.getpdf() != null ) {
    %>
    <a href="<%= Param.getAplicacion() %>portal/<%= oProd.getpdf() %>" target="_blank" title="descargar pdf" class="ic_t pdf">Descargar PDF</a>
<%      }
    %>
            </div>

            </div>

        <div class="img-producto">
        	<hgroup>
                <h3><%= oProd.gettitulo() %></h3>
<%         if (oProd.getsubtitulo() != null) {
    %>
                <h4><%= oProd.getsubtitulo() %></h4>
<%        }
    %>
<%         if (oProd.getdescRama() != null && oProd.getcodRama() != 999 ) {
    %>
                <h5>+&nbsp;<%= oProd.getdescRama()%></h5>
<%         }
    %>
            </hgroup>
<%     if (oProd.getimagen() != null) {
    %>
            <figure><img src="<%= Param.getAplicacion()%>portal/img/<%= oProd.getimagen() %>" width="691" height="574" alt="<%= oProd.gettitulo() %>"></figure>
<%      }
    %>
       </div>
<%      if (oProd.gettexto() != null ) {
    %>
    <p><%= oProd.gettexto() %></p>
<%      }
    %>
<% if (lTextos != null && lTextos.size() > 0 ) {
        for (int i=0;i< lTextos.size();i++ ) {
            PortalTexto oTexto = (PortalTexto) lTextos.get(i);
    %>
       <p>
<% if (oTexto.gettitulo() != null ) {
    %>
        <b><%= oTexto.gettitulo() %></b><br>
<%  }
    if (oTexto.gettexto() != null ) {
    %>
        <%= oTexto.gettexto()%><br><br>
<%  }
    %>
        </p>
<% }
        }
    %>

<%--        <ul>
            <li>Cláusula de accidente - Indemnización adicional por muerte accidental.</li>
            <li>Cláusula de accidente - Indemnizaciones adicionales por muerte, desmembración o pérdida de la vista a consecuencia de accidente.</li>
            <li>Cláusula de invalidez total y permanente - Liquidación del capital asegurado.</li>
        </ul>
--%>
<% if (oProd.getmcaTabla() != null &&
       oProd.getmcaTabla().equals("X") && 
       oProd.getlTabla() != null && 
       oProd.getlTabla().size()> 0 ) {
       int maxFilas = 0;
       int maxCol   = 0;
       int maxColT1 = 0;
       String [][] vTabla = new String [20][20];
       String [] vTit = new String [20];

       for (int i=0; i< oProd.getlTabla().size();i++) {
            PortalTabla oPT = (PortalTabla) oProd.getlTabla().get(i);
            maxFilas   = oPT.getfila();
            maxColT1   = oPT.getcolumna();
            maxCol     = oPT.getcolumna();
            vTabla [oPT.getcolumna()] [oPT.getfila () ] = oPT.gettexto();
            if (oPT.getfila() == 1) {
                vTit [oPT.getcolumna()] = oPT.gettexto();
            }
       }

       if (maxColT1 > 7) { maxColT1 = 7;}

    %>

       <div class="table_wrap">
<%      for (int ii=1; ii <= maxColT1;ii++) {
            if (ii == 1) {
    %>
            <div class="<%= (ii == 1 ? "cl_left" : "cl_rigth")%>">
<%          }
            if (ii == 2) {
    %>
            </div>
            <div class="<%= (ii == 1 ? "cl_left" : "cl_rigth")%>">
<%          }
    %>


<%          if ( ii == 1 ) {
    %>
               <div class="c0 t_head"></div>
               <div class="c0 t_head line_b"><%=  vTit [1] %></div>

<%          } if (ii == 2 ) {
    %>
                <div class="c0 t_head">Sumas Aseguradas por Cobertura</div>
                <div class="c0 t_head line_b">
<%              for (int tt=2; tt <= maxColT1; tt++ ) {
    %>
                    <span  class="a1"><%=  vTit [tt] %></span>
<%              }
    %>
                </div>

<%          }
    %>
                <div class="cl c<%= ii %>">
<%          for (int jj=2; jj <= maxFilas; jj++) {
    %>
                    <div class="t_file"><%= vTabla[ii][jj]%></div>

<%         }
    %>
                </div>

<%       }
    %>
           </div>
        </div>
<!-- SI LA CANT. DE COLUMNAS ES MAYOR A 7 ENTONCES ARMO OTRA TABLA CON EL RESTO
-->
<%  if (maxCol > 7) {
    %>
       <div class="table_wrap">
<%      for (int ii=1; ii <= maxCol;ii++) {
            if (ii == 1) {
    %>
            <div class="<%= (ii == 1 ? "cl_left" : "cl_rigth")%>">
<%          }
            if (ii == 2) {
    %>
            </div>
            <div class="<%= (ii == 1 ? "cl_left" : "cl_rigth")%>">
<%          }
    %>


<%          if ( ii == 1 ) {
    %>
               <div class="c0 t_head"></div>
               <div class="c0 t_head line_b"><%=  vTit [1] %></div>

<%          } if (ii == 2 ) {
    %>
                <div class="c0 t_head">Sumas Aseguradas por Cobertura</div>
                <div class="c0 t_head line_b">
<%              for (int tt=2; tt <= maxCol; tt++ ) {
                    if (tt > 7) {
    %>
                    <span  class="a1"><%=  vTit [tt] %></span>
<%                  }
                }
    %>
                </div>

<%          }
            if (ii == 1 || ii > 7 ) {
    %>
                <div class="cl c<%= (ii == 1 ? ii : ii - 7) %>">
<%              for (int jj=2; jj <= maxFilas; jj++) {
    %>
                    <div class="t_file iz"><%= vTabla[ii][jj]%></div>

<%              }
    %>
                </div>

<%          }
        }
    %>
           </div>
        </div>
<%  }
    }
    %>
       

<% if (oProd.geticoAMF() != null || oProd.geticoRentaDiaria() != null ||
       oProd.geticoAmbito() != null || oProd.geticoSepelio() != null ||
       oProd.getico0800() != null) { 
    %>
        <div class="info-prod">
            <span class="top"></span>
<%      if ( oProd.geticoAMF() != null ) {
    %>
            <div class="file">
                <span class="ic af"></span><span><%= oProd.geticoAMF() %></span>
            </div>
<%      }
        if ( oProd.geticoRentaDiaria() != null ) {
    %>
            <div class="file">
                <span class="ic rd"></span><span><%= oProd.geticoRentaDiaria() %></span>
            </div>
<%      }
        if ( oProd.geticoAmbito() != null ) {
    %>
            <div class="file">
                <span class="ic am"></span><span><%= oProd.geticoAmbito() %></span>
            </div>
<%      }
        if ( oProd.geticoSepelio() != null ) {
    %>
            <div class="file">
                <span class="ic sp"></span><span><%= oProd.geticoSepelio() %></span>
            </div>
<%      }
        if ( oProd.getico0800() != null ) {
    %>
            <div class="file">
                <span class="ic as"></span><span><%= oProd.getico0800() %></span>
            </div>
<%      }
    %>
        </div>

<%  }
    %>
    </section>
    <span class="line-break"></span>
    <a href="#" title="Contactar un asesor de Beneficio SA" class="bt-contact" onclick="javascript:Ir();">Contactar Asesor</a>

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

<!-- Google Analytics: change UA-XXXXX-X to be your's ID. -->
<script>
    //var _gaq=[['_setAccount','UA-XXXXX-X'],['_trackPageview']];
    //(function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];
    //g.src=('https:'==location.protocol?'//ssl':'//www')+'.google-analytics.com/ga.js';
    //s.parentNode.insertBefore(g,s)}(document,'script'));
</script>
</body>
</html>