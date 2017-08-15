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

<meta property="og:title" content="Politica de privacidad">
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
        <h2 class="h-page">Pol&iacute;tica de privacidad de Beneficio S.A. Compa&ntilde;&iacute;a de Seguros</h2>
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
Estimado Usuario:<br><br>
<b>Bienvenido al sitio.</b> El que sigue es el documento de Pol&iacute;tica de Privacidad de Beneficio S.A. Compa&ntilde;&iacute;a de Seguros, bajo cuyos principios esta instituci&oacute;n trata y protege su informaci&oacute;n. Toda la informaci&oacute;n recopilada relacionada con la utilizaci&oacute;n que usted d&eacute; al mismo se conservar&aacute; seg&uacute;n la pol&iacute;tica de confidencialidad que expresa este documento. La navegaci&oacute;n de esta p&aacute;gina implica su conformidad expresa con sus contenidos y modificaciones. Si no est&aacute; de acuerdo, le rogamos que abandone su navegaci&oacute;n. <br><br>
<b>Reserva.</b> Beneficio S.A. Compa&ntilde;&iacute;a de Seguros, se reserva el derecho de modificar la presente Pol&iacute;tica de Privacidad para encuadrarla en  nuevos requerimientos legislativos, jurisprudenciales, t&eacute;cnicos o todos aquellos que le permitan brindar mejores servicios y contenidos. <br><br>
<b>Recolecci&oacute;n de datos.</b> Beneficio S.A. Compa&ntilde;&iacute;a de Seguros, no almacenar&aacute; o recolectar&aacute; informaci&oacute;n personal del usuario por medio del sitio sin su previa consentimiento o autorizaci&oacute;n. Si el usuario  provee voluntariamente  informaci&oacute;n personal, Beneficio S.A. Compa&ntilde;&iacute;a de Seguros, no vender&aacute;, divulgar&aacute; o transmitir&aacute; dicha informaci&oacute;n a terceros salvo que sea requerida legalmente, por orden judicial o administrativa o que hubiere una autorizaci&oacute;n expresa del usuario. A los fines de este documento,   "informaci&oacute;n personal" es la particular y distintiva de  cada persona, es decir su  nombre, domicilio, n&uacute;meros de documentos, n&uacute;mero de tarjeta de cr&eacute;dito y n&uacute;mero de tel&eacute;fono. Estos datos pueden incluir, aunque no necesariamente,  el nombre de su proveedor de servicio de Internet, el sitio web que usted ha usado para vincularse a nuestro sitio, los sitios que usted visita desde nuestro portal web y su direcci&oacute;n IP.
Ud. puede ingresar y utilizar el sitio sin divulgar su informaci&oacute;n personal. De hecho,  no se requiere que Usted proporcione esa informaci&oacute;n como condici&oacute;n para usar el sitio, excepto que sea necesario para proveerle un servicio o resultado, conforme a su petici&oacute;n. <br><br>
<b>Recolecci&oacute;n de datos, visitantes an&oacute;nimos:</b> Beneficio S.A. Compa&ntilde;&iacute;a de Seguros puede obtener informaci&oacute;n an&oacute;nima acerca de sus visitantes, lo que significa que dicha informaci&oacute;n no puede ser asociada a un usuario concreto e identificado. Los datos que se conservan son &uacute;nicamente:<br>
<ul><li value="a">La fecha y hora de acceso a nuestro Sitio para los links “on-line”. La raz&oacute;n por la que se efect&uacute;a es identificar las horas de mayor afluencia y realizar los ajustes necesarios para no tener inconvenientes en el acceso a la informaci&oacute;n.</li>
<li value="b">El n&uacute;mero de visitantes diarios de las secciones on-line. La raz&oacute;n por la que se efect&uacute;a Ello nos permite conocer la informaci&oacute;n de mayor inter&eacute;s y aumentar y mejorar su contenido, para beneficio del usuario. </li>
</ul>
<br><br><br>
<b>Informaci&oacute;n personal:</b> Con el fin de hacer consultas online, o recibir informaci&oacute;n como, por ejemplo, resultados o newsletters desde  nuestro sitio, el usuario puede enviar por la web informaci&oacute;n personal a Beneficio S.A. Compa&ntilde;&iacute;a de Seguros, a fin de registrarse con ese prop&oacute;sito. En estos casos:
La base de datos que conforme su informaci&oacute;n personal permanece en Beneficio S.A. Compa&ntilde;&iacute;a de Seguros, en sus procesadores de datos o servidores que act&uacute;an por su cuenta y son responsables ante la instituci&oacute;n. <br>
La informaci&oacute;n que obtiene por parte de sus usuarios es de car&aacute;cter confidencial. La informaci&oacute;n de car&aacute;cter econ&oacute;mico y comercial de los usuarios tambi&eacute;n reviste el car&aacute;cter de confidencial, por lo que su tratamiento deber&aacute; ser utilizado conforme  la pol&iacute;tica de Beneficio S.A. Compa&ntilde;&iacute;a de Seguros,  y las leyes vigentes. Toda documentaci&oacute;n que contenga informaci&oacute;n confidencial de un usuario, cualquiera sea el soporte en que se encuentre, ser&aacute;  tratada con cuidado y diligencia. Una vez utilizadas los mismos, deber&aacute;n ser guardadas en los soportes provistos por Beneficio S.A. Compa&ntilde;&iacute;a de Seguros. <br>
El uso de la informaci&oacute;n confidencial de los usuarios deber&aacute; efectuarse exclusivamente durante el desempe&ntilde;o de las tareas de Beneficio S.A. Compa&ntilde;&iacute;a de Seguros, dentro de su  &aacute;mbito laboral. <br>
El usuario puede revisar y corregir cualquier informaci&oacute;n personal almacenada en nuestro sistema, si considera que es incorrecta o desea actualizarla. Tambi&eacute;n a cancelar su autorizaci&oacute;n para el uso de su informaci&oacute;n  personal. A esos efectos, le rogamos enviar un correo electr&oacute;nico a la direcci&oacute;n que consta en nuestra papeler&iacute;a impresa. <br><br>
En este sentido, y en  cumplimiento de la Disposici&oacute;n 10/2008 de la Direcci&oacute;n Nacional de Protecci&oacute;n de Datos Personales se hace saber a los usuarios  que: <b>“El titular de los datos personales tiene la facultad de ejercer el derecho de acceso a los mismos en forma gratuita a intervalos no inferiores a seis meses, salvo que se acredite un inter&eacute;s leg&iacute;timo al efecto, conforme lo establecido en el art&iacute;culo 14, inciso 3 de la Ley Nº 25.326” .“La DIRECCI&oacute;N NACIONAL DE PROTECCI&oacute;N DE DATOS PERSONALES, &oacute;rgano de Control de la Ley Nº 25.326, tiene la atribuci&oacute;n de atender las denuncias y reclamos que se interpongan con relaci&oacute;n al incumplimiento de las normas sobre protecci&oacute;n de datos personales”</b><br>
Est&aacute; estrictamente prohibido brindar acceso a informaci&oacute;n de los usuarios a terceros ajenos a Beneficio S.A. Compa&ntilde;&iacute;a de Seguros, con excepci&oacute;n de aquellas solicitudes efectuadas por autoridad competente, legislativa, parlamentaria, administrativa o judicial. <br>
Beneficio S.A. Compa&ntilde;&iacute;a de Seguros,  est&aacute; facultada para  utilizar esta  informaci&oacute;n suministrada por los usuarios, para fines de marketing interno como externo, pudiendo a tal fin comunicarse directamente con el usuario del sitio. Sin embargo, Beneficio S.A. Compa&ntilde;&iacute;a de Seguros, no utilizar&aacute; o har&aacute; p&uacute;blica ninguna  informaci&oacute;n m&eacute;dica, incluyendo especialmente resultados de muestras de laboratorio personalizados, que permita relacionar a una persona con una condici&oacute;n de salud. En caso de intercambio v&iacute;a mail o correo electr&oacute;nico, Beneficio S.A. Compa&ntilde;&iacute;a de Seguros, podr&aacute; solicitar mayor informaci&oacute;n a los fines de garantizar la veracidad de la informaci&oacute;n enviada. <br><br>
<b>Cookies.</b> En algunos sitios web, los archivos llamados cookies pueden ser activados  por Beneficio S.A. Compa&ntilde;&iacute;a de Seguros, para mejorar la eficiencia de su uso individual del sitio web. Son archivos que residen en la unidad de disco duro de su equipo y que contienen informaci&oacute;n personal del usuario no identificable. Los cookies son entonces identificadores que nuestro servidor web podr&iacute;a enviar para identificar el computador que se est&aacute; usando por la duraci&oacute;n de la sesi&oacute;n. De modo que s&oacute;lo se identifica a la computadora del usuario, no a su informaci&oacute;n personal. En caso de utilizar cookies, Beneficio S.A. Compa&ntilde;&iacute;a de Seguros lo hace para  brindarle  un mejor servicio cuando vuelva a visitar el Sitio. As&iacute;,  podr&iacute;a ayudarle para no volver a introducir datos que nos haya proporcionado anteriormente.
La mayor&iacute;a de los navegadores se configuran para aceptar estos cookies de manera autom&aacute;tica, pero el usuario  puede desactivar el almacenamiento de cookies o ajustar su navegador para que le informe antes de que se almacene el cookie en su computador. Con ese fin,  defina las opciones de su explorador para que no acepte cookies. Hacerlo, no obstante, le impedir&aacute; obtener acceso a todas las funciones del sitio. <br><br>
<b>Enlaces.</b> El sitio puede contener enlaces a otros sitios en los que rigen sus propias pol&iacute;ticas de confidencialidad, de las que Beneficio S.A. Compa&ntilde;&iacute;a de Seguros, no se hace responsable. <br><br>
<b>Ley aplicable y competencia.</b> Cualquier controversia judicial &oacute; extrajudicial a que de lugar la aplicaci&oacute;n o interpretaci&oacute;n de esta Pol&iacute;tica de Privacidad, se rige por las leyes de la Rep&uacute;blica Argentina, con exclusi&oacute;n de las normas de derecho internacional privado y para entender en ella es competente la Justicia Nacional Ordinaria de la Ciudad de Buenos Aires. Asimismo, la nulidad de una disposici&oacute;n de este documento de Pol&iacute;tica de Privacidad, no generar&aacute; la nulidad de todo el texto, sino solamente de la disposici&oacute;n cuestionada. <br><br>
<b>Domicilio legal.</b> Beneficio S.A. Compa&ntilde;&iacute;a de Seguros, constituye domicilio legal en la Avenida Leandro N. Alem 530, Piso 1de la Ciudad Aut&oacute;noma de Buenos Aires (1047), donde deben cursarse todas las notificaciones legales que se le cursen. <br><br>
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