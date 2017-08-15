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

<meta property="og:title" content="Prevenci&oacute;n de Fraude">
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
        <h2 class="h-page">Prevenci&oacute;n de Fraude</h2>
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
De acuerdo a lo establecido por la Resoluci&oacute;n Nro. 34.877 de la SSN, sobre pol&iacute;ticas procedimientos y controles internos para combatir el fraude, 
comunicamos a nuestros asegurados, productores asesores de seguros y auxiliares de la actividad, que nuestra compa&ntilde;&iacute;a <b>Beneficio S.A. Compa&ntilde;&iacute;a de Seguros</b> 
se adhiere a las medidas a tener en cuenta para prevenir y detectar el fraude, dando as&iacute; cumplimiento a la normativa vigente.<br>
El fraude que se dirige contra el asegurador causa da&ntilde;os a toda la comunidad, incide en los costos de las primas, y ocurre cuando la gente enga&ntilde;a a la compa&ntilde;&iacute;a (y/o al productor asesor de seguros) 
para cobrar dinero u obtener alguna otra ventaja a la que no tiene derecho.<br>
El fraude que afecta al asegurador es un delito. La variaci&oacute;n, simulaci&oacute;n o tergiversaci&oacute;n de circunstancias personales, temporales, objetivas, de causalidad, de lugar, y la provocaci&oacute;n deliberada, 
o la simulaci&oacute;n total o parcial del acaecimiento del siniestro, son algunas de las formas de fraudes m&aacute;s comunes, lo que lleva a admitirlo como natural, sin comprender la gravedad que conlleva.<br>
<br><b>Dec&aacute;logo de Desaf&iacute;os &eacute;ticos</b><br><br>
Esta aseguradora asume el compromiso de adecuarse al documento “Dec&aacute;logo de Desaf&iacute;os Éticos” que se expone a continuaci&oacute;n:
<br><br>
    Lineamientos generales para el establecimiento de BUENAS PRACTICAS:
<br><br>
Las buenas pr&aacute;cticas, la debida diligencia, el trato justo y la buena fe deben verificarse en los distintos procesos, a saber:<br>
<ol type="A">
    <li>En el proceso de comercializaci&oacute;n o venta.</li>
    <li>Durante la vigencia de la cobertura.</li>
    <li>En el proceso de liquidaci&oacute;n de siniestros.</li>
    <li>En el proceso de pago de indemnizaciones o sumas aseguradas.</li>
    <li>En la atenci&oacute;n de las denuncias o reclamaciones de tomadores, asegurados, beneficiarios, o terceros damnificados.</li>
</ol>
<ol>
    <li>Esta aseguradora adoptar&aacute; pol&iacute;ticas y procedimientos para garantizar una adecuada informaci&oacute;n a los tomadores, con especial &eacute;nfasis:
        <ol type="I">
            <li>En los alcances reales de la cobertura, otras alternativas y sus costos.</li>
            <li>En los &iacute;tems, riesgos o conceptos no cubiertos, procurando que el usuario comprenda claramente limitaciones, v.gr., en virtud de franquicias o por la adopci&oacute;n de sistemas personalizados, usualmente conocidos “de scoring”, en los que la prima se define acorde a mediciones estad&iacute;sticas respecto de la siniestralidad, dependiendo de distintas variables personales, del bien asegurado, de su uso y geogr&aacute;ficas.</li>
            <li>En explicaciones que permitan comprender coberturas complejas.</li>
            <li>En la erradicaci&oacute;n de campa&ntilde;as comerciales agresivas.</li>
            <li>En que las p&oacute;lizas deben adecuarse a toda la normativa legal y reglamentaria vigente, y muy especialmente reflejar una redacci&oacute;n clara, simple, y que no disimule cl&aacute;usulas que limiten o modifiquen los alcances de la cobertura.</li>
            <li>En brindar informaci&oacute;n integral y no parcializada, estableciendo medidas adecuadas para resolver posibles conflictos de intereses entre las partes y/o con intermediarios o agentes.</li>
            <li>En la pormenorizaci&oacute;n destacada de las obligaciones y derechos b&aacute;sicos de los asegurados.</li>
            <li>En la explicitaci&oacute;n de las consecuencias devenidas de la omisi&oacute;n del pago de la prima y/o el incumplimiento de cualquiera de las cargas establecidas en cabeza del asegurado.</li>
        </ol>
    </li>
    <li>Promover la difusi&oacute;n de una cultura aseguradora que le permita comprender al tomador o asegurado que hay una relaci&oacute;n t&eacute;cnica b&aacute;sica entre PRIMA - RIESGO - SUMA ASEGURADA. A veces los asegurables tienen una expectativa en orden a que con primas muy bajas es posible contar con coberturas extraordinarias y ello implica un error que las entidades no deben explotar, siendo deseable que aclaren la naturaleza, vigencia, costo y alcance de las que contraten los usuarios.</li>
    <li>Las entidades no deben colocar el producto que el asegurado NO desea (procurando ajustarse a las especificaciones de la propuesta), o que manifiestamente no le servir&aacute; (y que en general aparece enmascarado por otro similar), o que le impondr&aacute; efectuar gastos o esfuerzos desmesurados en proporci&oacute;n a los beneficios, sin que aqu&eacute;l sea debidamente prevenido al respecto. Tampoco deber&aacute;n concertar coberturas que —de producirse el siniestro— no conllevar&aacute;n responsabilidad del asegurador. </li>
    <li>Las entidades deben facilitar la efectividad de las notificaciones, especialmente si se trata de distractos; y que el asegurado pueda cumplir con sus CARGAS y OBLIGACIONES, indicando claramente el detalle de la documentaci&oacute;n que deber&aacute; aportar. Deber&aacute;n abstenerse de incurrir en abusos respecto de la facultad de solicitar informaci&oacute;n o instrumental complementaria, acorde a un principio de razonabilidad.</li>
    <li>Las entidades deben facilitar la intervenci&oacute;n y control del asegurado en la liquidaci&oacute;n del siniestro.</li>
    <li>Las entidades deben facilitar que los asegurados o beneficiarios cobren las indemnizaciones o sumas aseguradas.</li>
    <li>En seguros de vida, deben procurar una clara identificaci&oacute;n del beneficiario y la peri&oacute;dica actualizaci&oacute;n de sus datos. Al conocer el fallecimiento del asegurado, deben notificar fehacientemente al beneficiario en orden a sus derechos.</li>
    <li>Los folletos y art&iacute;culos de publicidad de las entidades deben adecuarse a toda la normativa vigente para la materia, individualizar con claridad la aseguradora interviniente, incluso si opera a trav&eacute;s de un intermediador o agente; y muy especialmente facilitar que el asegurado entienda el costo, el riesgo cubierto, las limitaciones (temporal, espacial, causal y objetiva) de la cobertura y sus reales alcances.</li>
    <li>Si las funciones de esclarecimiento (en los aspectos de asesoramiento) se delegan en Productores Asesores de Seguros o Sociedades de Productores, o agentes institorios, la entidad debe proporcionar un instructivo b&aacute;sico para asegurar estas buenas pr&aacute;cticas.</li>
    <li>Las entidades deber&aacute;n comunicar al organismo de control la recepci&oacute;n de reclamos o denuncias vinculadas a coberturas falsas que les son atribuidas o que manifiestamente correspondan al accionar de comercializadores no autorizados.</li>
</ol>
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