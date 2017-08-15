<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.business.util.*"%>
<%
    String urlExtranet = config.getServletContext().getInitParameter ("urlExtranet");
    String aplicPortal = config.getServletContext().getInitParameter ("aplic_portal");
    if (urlExtranet == null) { urlExtranet = "https://www.beneficioweb.com.ar/"; }
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
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<meta name="author" content="">
<meta name="robots" content="noindex,nofollow">
<meta name="copyright" content="">

<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon">

<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/normalize.css">
<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/extranet.css">
<script type="text/javascript" src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
<script type="text/javascript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript">
function validate(){

    document.form2.browser.value = BrowserDetect.browser;
    document.form2.version.value = BrowserDetect.version;
    document.form2.OS.value = BrowserDetect.OS;

    if ( document.form2.browser.value != 'Explorer' &&
         document.form2.browser.value != 'Firefox'  &&
         document.form2.browser.value != 'Chrome' &&
         document.form2.browser.value != 'Safari' &&
         document.form2.browser.value != 'Opera' &&
         document.form2.browser.value != 'Mozilla' &&
         document.form2.browser.value != 'Netscape') {
        alert ("NAVEGADOR INVALIDO,\n\
 Este sitio web esta optimizado para Explorer, Firefox, Chrome, Safari y Netscape. \n\
  Su navegador es: " + document.form2.browser.value );
        return false;
    }

   if( document.form2.usuario.value == "" ||
       document.form2.usuario.value == "Usuario"  )
   {
     alert( "Por favor, ingrese un usuario válido !" );
     document.form2.usuario.focus() ;
     return false;
   }

   if( document.form2.usuario.value.length > 20 )
   {
     alert( "El usuario no puede tener más de 20 caracteres" );
     document.form2.usuario.focus() ;
     return false;
   }

    if( document.form2.password.value == "" ||
        document.form2.password.value == "Contraseña") {
     alert( "Ingrese la password" );
     document.form2.password.focus() ;
     return false;
    }

    if( document.form2.password.value.length > 20) {
     alert( "La longitud de la password no debe superar los 20 caracteres" );
     document.form2.password.focus() ;
     return false;
    }

    document.form2.usuario.value = document.form2.usuario.value.toUpperCase();
    document.form2.password.value = document.form2.password.value.toUpperCase();
    return (true);
}

    function Submitir(evt) {

           var nkeyCode;
           if (document.all) {
                 nkeyCode = evt.keyCode;
           }else
             if (evt) {
                nkeyCode = evt.which;
           }

          if (nkeyCode==13) {
            document.form2.submit();
          }
    }

</script>
</head>
<body>

<!-- cuerpo principal -->
<div id="container" role="main">

    <header>
    	<hgroup>
        <h1><a href="./" title="Home"><img src="<%= Param.getAplicacion()%>portal/img/beneficio_marca.png" width="325" height="102" alt="Beneficio-SA"></a></h1>
        <h2>Extranet - Acceso a Productores y Clientes registrados</h2>
        </hgroup>
    </header>

    <div id="body">

    <p class="info-top">
    Estimado colaborador, recuerde que el usuario de acceso a nuestra web es su código de
    productor en BENEFICIO. Para acceder por primera vez ingrese como usuario y clave su c&oacute;digo de productor.<br>
    Si tiene problemas para ingresar    o no recuerda la contraseña&nbsp;<a href="<%= aplicPortal %>portal/registracionForm.jsp">haga clik aquí</a>.
    Si usted a&uacute;n no es productor de BENEFICIO y desea registrarse <a href="<%= aplicPortal %>portal/cvForm.jsp">haga clik aquí</a>&nbsp;y
    un representante comercial se contactara con usted. Muchas gracias<br>
    </p>

    <div class="form-wrap">
        <h3>Formulario de Acceso</h3>
        <div class="data">
            <form action="<%= Param.getAplicacion()%>servlet/setAccess" method="post" id="form2" name="form2"
                  onsubmit="return(validate());" novalidate>
                <input type="hidden" id="opcion" name="opcion" value="LOGNEW" >
                <input type="hidden" id="browser" name="browser">
                <input type="hidden" id="version" name="version">
                <input type="hidden" id="siguiente" name="siguiente" value="portal/extranet.jsp">
                <input type="hidden" id="OS" name="OS">
                <div class="form-file usr">
                    <input type="text" value="" name="usuario" id="usuario" placeholder="Usuario" tabindex="1"  autofocus title="Ingrese usuario">
                </div>
                <div class="form-file pass">
                    <input type="password" value="" name="password" id="password" placeholder="Contraseña" tabindex="2" title="Ingrese password" onkeypress="Submitir( event);">
                </div>
                <input type="submit" value="Ingresar" name="ingresar" id="ingresar" class="bt-extranet" tabindex="3">
                <a href="<%= aplicPortal %>portal/registracionForm.jsp" class="lost-p" title="si perdió su contraseña haga clic aqui">Perdió su contraseña?</a>
            </form>
            </div>
    </div>

    </div>

    <footer>
        <p class="info left">
        Casa Central
        Leandro N. Alem N° 584 piso 12 (1001) Capital Federal
        Tel.Fax- 011 5236 4300 | casacentral@beneficio.com.ar
        </p>

        <p class="info right">
        &copy; 2010-2012 Todos los derechos reservados - Beneficio S.A.
        </p>
    </footer>

</div><!--! container -->

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js"></script>
<script>window.jQuery || document.write('<script src="<%= Param.getAplicacion()%>portal/js/vendor/jquery-1.8.0.min.js"><\/script>')</script>

<script src="<%= Param.getAplicacion()%>portal/js/plugins.js"></script>
<script src="<%= Param.getAplicacion()%>portal/js/main.js"></script>
</body>
</html>