<%--
    Document   : contacto
    Created on : 24/10/2012, 16:13:51
    Author     : relisii
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.business.util.*"%>
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
   
<meta property="og:title" content="Acerca de Beneficio S.A.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://www.beneficioweb.com.ar">
<meta property="og:image" content="<%= Param.getAplicacion()%>portal/img/avatar.png">
<meta property="og:site_name" content="Beneficio SA - Compañia de Seguros">
<meta property="fb:admins" content="100004514563818">
<meta property="og:description" content="BENEFICIO S.A. Compañía de Seguros fue formada el 01 de julio de 1995,
con las más recientes características establecidas por la Superintendencia de Seguros de la Nación para empresas que desarrollan los ramos Vida, Salud, Sepelio Y Accidentes Personales,
que son ramos específicos de los seguros sobre las personas. A partir de mayo 2011 estamos autorizados por la SSN a comercializar Seguros de Caucion">

<!--! Facebook's Open graph ends -->

<link rel="icon" href="favicon.ico" type="image/x-icon">

<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/normalize.css">
<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/skeleton.css">
<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/main.css">
<script src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
<script src="<%= Param.getAplicacion()%>script/formatos.js"></script>
</head>

<body class="loading">
<jsp:include page="/portal/header.jsp">
    <jsp:param name="page" value="home" />
</jsp:include>
<!-- cuerpo principal -->
<div class="container" role="main">
<div class="row">

    <section id="acerca_de" class="sixteen columns alpha cs">
    <h2>acerca de beneficio</h2>

    <p class="info-section">   
        <b>BENEFICIO S.A. Compa&ntilde;&iacute;a de Seguros </b> es una empresa legalmente constituida en la República Argentina bajo el Nro 555 del Registro de la SSN.
        Inscrita en la IGJ con el Nro 1353 de fecha 12/04/1995, fue creada con las más recientes características establecidas por la Superintendencia de
        Seguros de la Nación para empresas que desarrollan los <b>ramos VIDA, SALUD, SEPELIO Y ACCIDENTES PERSONALES</b>, que son ramos específicos de los
        seguros sobre las personas.<br><br>
Su actividad se desenvuelve de acuerdo a lo establecido en el Código Civil, Código de Comercio y la Ley de Seguros No. 17.418 de la República Argentina y
bajo la supervisión y disposiciones de la Superintendencia de Seguros de la Nación (SSN).<br>
Las compañías de seguros, están sujetas a lo dispuesto en la Ley de Seguros de la República Argentina No 17.418 y su reglamentación.<br><br>
Las entidades aseguradoras tendrán como única limitación para la suscripción de este tipo de seguros, el contar con las garantías suficientes,
el adecuado respaldo de reaseguro y la autorización de la SSN.<br>
BENEFICIO S.A. solidifica su estructura avalada con la capacitación, orientación, experiencia, respaldo y reaseguro de reaseguradores líderes en el mercado
adecuenadonos a las nuevas normas respecto al reasegurador local.<br><br>
    </p>
    <!-- desplegable 1-->

    <!-- desplegable 2-->
    <div class="wrap_info">

        <div class="title_info"><a href="#" class="action" id="2">Soluciones en Personas</a></div>

        <div class="desplega" id="d1">
            <span class="t-list">De contrataci&oacute;n Obligatoria:</span>
        <ul>
                <li>SCVO</li>
                <li>Vida Convenio Mercantil</li>
                <li>Vida Empleado Rural</li>
        </ul>

        <span class="t-list">De Contrataci&oacute;n Optativa:</span>
        <ul>
                <li>Seguro de Vida de LCT</li>
                <li>Otros planes colectivos que pueden cubrir la vida, invalidez, trasplantes y enfermedades cr&iacute;ticas</li>
        </ul>

        <span class="t-list">ACCIDENTES PERSONALES:</span>
        <ul>
            <li>AP 24 hs</li>
            <li>AP Laboral: Puede incluir  in it&iacute;­nire</li>
            <li>AP mensajer&iacute;a o delivery</li>
            <li>AP Deportistas /AP Escolares</li>
            <li>AP Country</li>
            <li>Asistencia Medica Farmac&aacute;utica (Prestacional o por Reintegro)</li>
        </ul>

        <span class="t-list">PRESTAMOS:</span>
        <ul>
            <li>Seguro de Vida saldo Deudor: Para entidades financieras, bancarias, mutuales y otros similares</li>
        </ul>

        <span class="t-list">SALUD:</span>
        <ul>
            <li>Efectivo por intervenciones quirurgicas; transplantes de organos y enfermedades graves</li>
        </ul>

        <span class="t-list">SEPELIO:</span>
        <ul>
            <li>Planes que facilitan la vida de la familia al enfrentar un momento doloroso.</li>
        </ul>
        </div>

    </div>
    <!-- desplegable 2-->

    <!-- desplegable 3-->
<!--
    <div class="wrap_info">
        <div class="title_info"><a href="#" class="action" id="3">Soluciones en Cauci&oacute;n</a></div>
        <div class="desplega" id="d2">
            <ul>
            <li>Garant&iacute;a de alquileres particulares y comerciales</li>
            <li>Garant&iacute;a de Administradores de Sociedades</li>
            <li>Garant&iacute;as Contractuales (para Obras y Servicios, tanto P&uacute;blicos como Privados)</li>
            <li>Cauciones Aduaneras</li>
            <li>Cauciones para Actividad o Profesi&oacute;n</li>
            <li>Cauciones Para empresas de Viajes y Turismo</li>
            <li>Cauciones de pago de Cr&eacute;dito Garantizado con Hipoteca</li>
            <li>Cauciones para Actividad o Profesi&oacute;n (CUCICBA, Martilleros, CNRT, Procuradores, etc)</li>
            </ul>
        </div>
    </div>
-->
    <!-- desplegable 3-->
    
    <div class="bnf_facil">
        <h3>¡ Beneficio lo hace fácil !</h3>
        <p class="p1">Servicio 24 hs: Beneficoweb da a los productores la libertad de emitir pólizas y realizar consultas desde todo el país. Incluso puede delegar al empleador gestionar altas y bajas. </p>
        <p class="p2">Calidez y calidad: Nuestros expertos acompañan a productores y asegurados a través de un asesoramiento profesional, brindar la cobertura mas conveniente a sus necesidades y posibilidades.<br><br>
        Agilidad: Muchas veces el trabajo de nuestros productores y asegurados depende de nuestra respuesta, por eso estamos organizados para cumplir con sus expectativas.<br>
        En cuestión de minutos, puede recibir la póliza en su email. </p>
    </div>

     <div class="bnf_vp">
     	  <h4>Beneficio el valor de la palabra...</h4>
          <p>Nuestros productores y clientes son los mejores referentes. Además, contamos con excelentes indicadores  económicos que nos sitúan en un lugar de privilegio en cuanto a solvencia patrimonial y financiera
           <br><br>Le recomendamos consultar en www.ssn.gov.ar</p>
     </div>

     <div class="porcentajes">
         <h5>Créditos sobre activos</h5>
         <p><b>Créditos / Activos:</b> cuanto menor es su valor, mejor se considera el activo de la aseguradora, ya que no es
             conveniente que gran parte del mismo se encuentre en manos de terceros (deudores de la entidad).
         </p>
         <span>51%</span>
         <h5>Solvencia Líquida</h5>
         <p><b>(Disponibilidades + Inversiones)/Deudas con asegurados * 100: </b>
             A mayor resultado, mayor liquidez de la aseguradora, lo que supone una mejor posición para enfrentar el pago de deudas pendientes.
         </p>
         <span>833%</span>
         <h5>Cobertura</h5>
         <p><b>(Disponibilidad + Inversiones + Total de inmuebles) / Deudas con asegurados + Compromisos técnicos * 100:</b>
             A mayor resultado, mayor fortaleza de la aseguradora, lo que supone una mejor posición para enfrentar el pago
             de compromisos de todo tipo.
         </p>
         <span>184%</span>
     </div>

    <div class="info-snn">*Fuente SSN, Balance al 30 de Junio de 2013</div>
    </section>
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
