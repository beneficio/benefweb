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

<meta property="og:title" content="Condiciones generales de uso">
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
        <h2 class="h-page">Condiciones generales de uso del sitio Web de Beneficio S.A. Compa&ntilde;&iacute;a de Seguros</h2>
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
Estimado usuario: <br><br>
<b>Bienvenido a nuestro sitio web, terminolog&iacute;a.</b> Su visita es muy importante para nosotros. Beneficio S.A. Compa&ntilde;&iacute;a de Seguros., (desde ahora “Beneficio”) es titular de este sitio, <a href="https://www.beneficioweb.com.ar" target=”_blank”> www.beneficioweb.com.ar</a> , (desde ahora “el Sitio”)  y responsable, de acuerdo a la Ley argentina, de los archivos generados con los datos de car&aacute;cter personal suministrados por los usuarios a trav&eacute;s de este Sitio. Su visita se encuentra sujeta a las condiciones que se detallan a continuaci&oacute;n. Si est&aacute; en desacuerdo con ellas, le rogamos terminar con su visita. Si contin&uacute;a, Ud. ha expresado inequ&iacute;vocamente su conformidad y adquirido la condici&oacute;n de “usuario”. Es que la utilizaci&oacute;n del Sitio, su visita y navegaci&oacute;n otorga autom&aacute;ticamente la condici&oacute;n de usuario y la aceptaci&oacute;n  plena y sin reservas de ning&uacute;n tipo del usuario de las Condiciones Generales en la versi&oacute;n publicada por Beneficio S.A. Compa&ntilde;&iacute;a de Seguros, cuando el usuario acceda al Sitio. Por ello, los usuarios son responsables por el acceso a nuestra p&aacute;gina web y a su contenido. <br><br>
<b>Condiciones del servicio.</b>  Beneficio S.A. Compa&ntilde;&iacute;a de Seguros contrata su acceso a Internet con un tercero proveedor del mismo. Por causas ajenas a Beneficio S.A. Compa&ntilde;&iacute;a de Seguros , puede que el Sitio no est&eacute;  disponible, debido a dificultades t&eacute;cnicas o fallas de Internet, del proveedor, o por cualquier otro motivo  que no se puede imputar a Beneficio S.A. Compa&ntilde;&iacute;a de Seguros. Por ello, Beneficio S.A. Compa&ntilde;&iacute;a de Seguros  no garantiza la disponibilidad y continuidad del funcionamiento del Sitio, ni su utilidad  para la realizaci&oacute;n de ninguna actividad en particular, ni su infalibilidad y, en particular, aunque no de modo exclusivo, que los usuarios, tal como se los define  debajo,  puedan utilizar el Sitio y acceder a sus contenidos. <br><br>
<b>Exenci&oacute;n de responsabilidad.</b> Expresamente, Beneficio S.A. Compa&ntilde;&iacute;a de Seguros no es responsable por los da&ntilde;os y perjuicios de cualquier naturaleza derivado de  la interrupci&oacute;n, suspensi&oacute;n, finalizaci&oacute;n, falta de disponibilidad o de continuidad del funcionamiento del Sitio, por la defraudaci&oacute;n de la utilidad que los usuarios hubieren podido atribuir al Sitio, a sus fallas t&eacute;cnicas no imputables a Beneficio S.A. Compa&ntilde;&iacute;a de Seguros. Expl&iacute;citamente, Beneficio S.A. Compa&ntilde;&iacute;a de Seguros no ser&aacute;  responsabilizada por da&ntilde;os o perjuicios derivados del uso o la imposibilidad de acceder al Sitio o porque el usuario se haya basado en su contenido. Tampoco se responsabiliza Beneficio S.A. Compa&ntilde;&iacute;a de Seguros por cualquier da&ntilde;o en el equipo o documentos digitales del usuario originado por fallas en el sistema, servidor o en Internet. Beneficio S.A. Compa&ntilde;&iacute;a de Seguros  no asume responsabilidad de ninguna &iacute;ndole, si en raz&oacute;n del acceso o uso del Sitio, el equipo del usuario se viese atacado por alg&uacute;n virus inform&aacute;tico. En este sentido, Beneficio S.A. Compa&ntilde;&iacute;a de Seguros, en especial,  no garantiza que la informaci&oacute;n, el software o el material al que el usuario pudiere acceder a trav&eacute;s del Sitio se encuentre libres de virus de cualquier naturaleza, como, por ejemplo, los virus generalmente designados como  "gusanos", "Troyanos", "Hoax"  que pudieren causar perjuicios  a los usuarios del Sitio o a su propiedad. Tampoco se responsabiliza del da&ntilde;o que pudiere derivar para el usuario de la navegaci&oacute;n del Sitio,  descarga de informaci&oacute;n, textos, planillas e im&aacute;genes, &oacute; consulta a sus “ventanas” . <br><br>
<b>Administraci&oacute;n del Sitio.</b> Beneficio S.A. Compa&ntilde;&iacute;a de Seguros  ha desarrollado este sitio y lo administra, reserv&aacute;ndose el derecho a discontinuarlo o modificarlo. Ese derecho  se extiende a la posibilidad de modificar sin previo aviso sus contenidos. <br><br>
<b>Contenidos.</b> Dado el continuo desarrollo de nuestra actividad y la naturaleza innovadora de nuestra actividad,  la veracidad o complejidad del  contenido del Sitio no se avala o garantiza irrestrictamente, en particular debido a que podr&iacute;a no estar absolutamente actualizado. Por esta raz&oacute;n, el usuario  debe revisar la informaci&oacute;n obtenida del Sitio antes de utilizarla. Siguiendo este criterio, el Sitio puede contener afirmaciones prospectivas basadas en las circunstancias actuales. Sin embargo, los hechos reales, futuros, el desarrollo y el funcionamiento de Beneficio S.A. Compa&ntilde;&iacute;a de Seguros   pueden diferir de estas estimaciones, como resultado de diversos factores tales, por ejemplo,  riesgos conocidos o desconocidos, incertidumbres, fuerza mayor., modificaciones en la pol&iacute;tica econ&oacute;mica de las autoridades argentinas, tipo de cambio, etc. Por otra parte, la informaci&oacute;n contenida en el Sitio, a&uacute;n  con nuestro mejor esfuerzo para prevenirlo,  puede contener imprecisiones t&eacute;cnicas, errores tipogr&aacute;ficos, referencias a productos o servicios discontinuados o no disponibles, por lo que Beneficio S.A. Compa&ntilde;&iacute;a de Seguros  no garantiza que ello no pueda ocurrir. <br><br>
<b>Uso de contenidos.</b> Sobre esta base, el  usuario acepta y entiende que el uso y o interpretaci&oacute;n de la informaci&oacute;n brindada en todas las p&aacute;ginas del Sitio y las decisiones que  tome en raz&oacute;n de las mismas, son realizadas enteramente bajo su propio criterio y exclusivo riesgo. Beneficio S.A. Compa&ntilde;&iacute;a de Seguros entiende que es de responsabilidad del usuario evaluar la utilidad, alcance, significado y aplicabilidad de la informaci&oacute;n contenida en el Sitio.  En ning&uacute;n caso se entiende que las recomendaciones o sugerencias realizadas pueden excluir, ni tornar innecesarias o prudentes las consultas con un profesional de la especialidad.  En este sentido, la informaci&oacute;n contenida en el Sitio no puede ser considerada asesoramiento legal, fiscal &oacute; profesional, ni implica una posici&oacute;n u opini&oacute;n por parte de Beneficio S.A. Compa&ntilde;&iacute;a de Seguros. A los fines de obtener una &oacute; ambas, el usuario debe, como qued&oacute; aclarado antes, consultar un profesional de la especialidad. <br><br>
<b>Menores de edad.</b> Los menores de edad, definidos seg&uacute;n las disposiciones del C&oacute;digo Civil de la Rep&uacute;blica Argentina, que accedan a los servicios que presta Beneficio S.A. Compa&ntilde;&iacute;a de Seguros a trav&eacute;s del Sitio lo har&aacute;n con el debido consentimiento de su representante legal absteni&eacute;ndose, en todo momento, los menores que no obtengan dicho consentimiento, de navegar por este el Sitio. Beneficio S.A. Compa&ntilde;&iacute;a de Seguros  no es responsable si el usuario es menor de edad y, a pesar de ello, navega por el Sitio sin la autorizaci&oacute;n de su representante legal. Beneficio S.A. Compa&ntilde;&iacute;a de Seguros, compartiendo la preocupaci&oacute;n comunitaria en este tema, insta a los padres a ejercitar una activa supervisi&oacute;n del uso de Internet por parte de sus hijos menores. <br><br>
<b>Acceso.</b> Por &uacute;ltimo, Beneficio S.A. Compa&ntilde;&iacute;a de Seguros  se reserva el derecho, en cualquier momento y sin necesidad de darle notificaci&oacute;n previa, de rechazar el acceso o retirar el acceso al Sitio, dando por terminada la condici&oacute;n de usuario, por infracci&oacute;n a  estas Condiciones. <br><br>
<b>Ley aplicable y competencia.</b> Cualquier controversia judicial &oacute; extrajudicial a que de lugar la aplicaci&oacute;n o interpretaci&oacute;n de estas Condiciones generales de Uso, se rige por las leyes de la Rep&uacute;blica Argentina, con exclusi&oacute;n de las normas de derecho internacional privado y para entender en ella es competente la Justicia Nacional Ordinaria de la Ciudad de Buenos Aires. Asimismo, la nulidad de una disposici&oacute;n de este documento  no generar&aacute; la nulidad de todo el texto, sino solamente de la disposici&oacute;n cuestionada. <br><br>
<b>Domicilio legal.</b> Beneficio S.A. Compa&ntilde;&iacute;a de Seguros  constituye domicilio legal en la Avenida Leandro N. Alem 530, Piso 1, de la Ciudad Aut&oacute;noma de Buenos Aires (1047), donde deben cursarse todas las notificaciones legales que se le cursen. <br><br>
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