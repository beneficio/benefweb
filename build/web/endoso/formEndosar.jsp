<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.OrdenPago"%>
<%@page import="com.business.beans.CtaCteFac"%>
<%@page import="com.business.beans.CtaCteHis"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Generico"%>
<%@page import="com.business.beans.OrdenPagoDet"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>
<%
    String urlExtranet = config.getServletContext().getInitParameter ("urlExtranet");
   
    Usuario usu = (Usuario) session.getAttribute("user");
    %>
<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="es-419"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="es-419"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="es-419"> <![endif]-->
<!--[if IE 9]>         <html class="no-js lt-ie10" lang="es-419"> <![endif]-->
<!--[if gt IE 9]><!--> <html class="no-js" lang="es-419"> <!--<![endif]-->
    <head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>BENEFICIO S.A. - Formulario de Endosos</title>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos-cot.css"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/tablasNew.css"/>

<!-- libreria jquery desde el cdn de google o fallback local -->
        <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>script/jquery-ui-1.10.3/themes/base/jquery.ui.all.css"/>
        
    <script src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
    <script src="<%= Param.getAplicacion()%>portal/js/vendor/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/chosen.jquery.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/prism.js" charset="utf-8"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/jquery-ui-1.10.3/ui/jquery.ui.core.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/jquery-ui-1.10.3/ui/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/jquery-ui-1.10.3/ui/jquery.ui.datepicker.js"></script>

<!--[if lt IE 9]>
	<script src="https://css3-mediaqueries-js.googlecode.com/svn/trunk/css3-mediaqueries.js"></script>
<![endif]-->

<script type="text/javascript">
    var usuarios = ["VEFICOVICH","GLUCERO","PINO","AGLANC" ];
    var aForm = new Array ();
    var aNivel = new Array ();
    
    $(document).ready(function(){

           $("#salir").click(function(){
               $('#form1').action ("<%= Param.getAplicacion() %>index.jsp");
               $('#form1').submit();
                return true;
            });

           $("#enviar").click(function(){
//                $('#mensaje_error').text("") ;
                var codRama     = parseInt ($('#cod_rama').val());
                var numPoliza   = parseInt ( $('#num_poliza').val());
                var tipoEndoso = parseInt ($('#TIPO_ENDOSO').val());
                if (isNaN(numPoliza)) numPoliza = 0;

                if (codRama === -1 ) {
                    $('#mensaje_error').text("ERROR: INGRESE LA RAMA") ;
                    $('#cod_rama').focus();
                    return false;
               }

                if (numPoliza === 0 ) {
                    $('#mensaje_error').text("ERROR: INGRESE NUMERO DE POLIZA ") ;
                    $('#num_poliza').focus();
                    return false;
                } 
               
                if ( tipoEndoso === -1 || tipoEndoso === 0  ) {
                    $('#mensaje_error').text("ERROR: SELECCIONE TIPO DE ENDOSO") ;
                    $('#TIPO_ENDOSO').focus();
                    return false;
                }
                
                var codError = $('#cod_error').val ();
                
                if ( codError === "0" )  {
                    $('#formulario').val (aForm[tipoEndoso]);
                    $('#nivel').val (aNivel[tipoEndoso]);

                    $('#form1').submit();
                    return true;
                } else { 
                    alert ($('#mensaje_error').text());
                    return false;
                }
            });

    });
    

</script>
</head>

<!--[if IE 7]>         <body class="ie ie7 oldie"> <![endif]-->
<!--[if IE 8]>         <body class="ie ie8"> <![endif]-->
<!--[if IE 9]>         <body class="ie ie9"> <![endif]-->
<!--[if gt IE 9]><!--> <body>         <!--<![endif]-->

<!--[if lt IE 7]><div class="browser_old" id="aviso">Ã‚Â¡Tu navegador es muy viejo! <a href="http://browsehappy.com/?locale=es" target="_blank">Actualizalo a uno mÃƒÂ¡s moderno</a> para tener una mejor experiencia y velocidad en la aplicacion.
<a href="#" class="close_message" title="cerrar aviso" onclick="document.getElementById('aviso').style.display='none';return false"></a>
</div><![endif]-->

<div class="wrapper">

    <!-- container -->
    <div class="container">

        <jsp:include page="/header.jsp">
            <jsp:param name="aplicacion" value="<%= Param.getAplicacion() %>" />
            <jsp:param name="usuario" value="<%= usu.getusuario() %>" />
            <jsp:param name="descripcion" value="<%= usu.getRazonSoc() %>" />
        </jsp:include>
        <div class="menu">
            <menu:renderMenuFromDB    aplicacion="1"  userLogon="<%= usu.getusuario()%>" />
        </div>

         <h1 class="title-section hcotizadores">Formulario de ingreso de Endoso</h1>

         <!-- tabs -->

        <div class="tabs-container">
        <form method="post" action="<%= Param.getAplicacion()%>servlet/EndosoServlet" name="form1" id="form1">
            <input type="hidden" name="opcion"      id="opcion"    value="getFormEndoso"/>
            <input type="hidden" name="volver"      id="volver"    value="formEndosar"/>
            <input type="hidden" name="usuario"     id="usuario"   value="<%= usu.getusuario() %>"/>
            <input type="hidden" name="tipo_usuario"  id="tipo_usuario" value="<%= usu.getiCodTipoUsuario() %>"/>
            <input type="hidden" name="cod_sub_rama"  id="cod_sub_rama" value="0"/>
            <input type="hidden" name="cod_producto"  id="cod_producto" value="0"/>
            <input type="hidden" name="cod_prod"      id="cod_prod"     value="0"/>
            <input type="hidden" name="formulario"    id="formulario"   value=""/>
            <input type="hidden" name="nivel"    id="nivel"   value=""/>
            <input type="hidden" name="cod_error"      id="cod_error"   value="0"/>
            
            <!-- -->
            <div id="tab1" class="tab-content form">
            <div class="form-wrap">
            <div class="form-file">
                <div class="wrap-elements w50">
                    <label for="num_poliza">Ingrese la rama de la p&oacute;liza:&nbsp;</label>
                    <div class="styled-select">
                    <select id="cod_rama" name="cod_rama" tabindex="1" onchange="validarRama();">
                        <option value="-1"> Seleccione la rama </option>
                        <option value="10"> ACCIDENTES PERSONALES</option>
                        <option value="21"> VIDA COLEC. OBLIGATORIO</option>
                        <option value="22"> VIDA COLECTIVO</option>
                        <option value="25"> SALUD</option>
                        <option value="18"> SEPELIO COLETIVO</option>
                    </select>
                    </div>    
                </div>
                <div class="wrap-elements w50">
                    <label for="num_poliza">Ingrese el n&uacute;mero de p&oacute;liza:&nbsp;</label>
                    <input id="num_poliza" name="num_poliza" type="text" value="" tabindex="2" onchange="validar();"/>
                </div>
                <div class="wrap-elements w100">
                    <label for="TIPO_ENDOSO">Que modificaci&oacute;n quiere hacer en la p&oacute;liza:</label>
                    <div class="styled-select">
                    <select name="TIPO_ENDOSO" id="TIPO_ENDOSO">
                        <option value="-1">Seleccione la p&oacute;liza a endosar</option>
                    </select>
                    </div>
                </div>
            <div class="form-file">
                 <span id="mensaje_error" class="validation-message">&nbsp;</span>  
             </div>

            <!-- button section -->
            <div class="form-file button-container">
                <input type="button" name="salir" id="salir" value="Salir" class="bt exit"/> 
                <input type="button" name="enviar" id="enviar" value="Enviar" class="bt next"/>
            </div>
             <!--! button section -->
            </div>        
            </div>    
            </div>
                
            </form>
        </div>

        <!--! tabs -->

            <jsp:include flush="true" page="/bottom.jsp"/>

    </div>
<!--! container -->
</div> <!--! wrapper -->
<script type="text/javascript">

    function validarRama () {
        $('#mensaje_error').text("") ;
        
        var codRama     = parseInt ($('#cod_rama').val());
        var numPoliza   = parseInt ($('#num_poliza').val());
        if (isNaN(numPoliza)) numPoliza = 0;
        
        if (codRama === -1 ) {
            $('#mensaje_error').text("ERROR: INGRESE LA RAMA") ;
            $('#cod_rama').focus();
            return false;
        } else {  
            if (numPoliza > 0 ) { 
                cargarEndosos ();
            } else {
                $('#num_poliza').focus();
                return true;
            }
        }

    }

    function validar () {
        $('#mensaje_error').text("") ;
        
        var codRama     = parseInt ($('#cod_rama').val());
        var numPoliza   = parseInt ( $('#num_poliza').val());
        var tipoEndoso = parseInt ($('#TIPO_ENDOSO').val());
        
        if (isNaN(numPoliza)) numPoliza = 0;
        
        if (codRama === -1 ) {
            $('#mensaje_error').text("ERROR: INGRESE LA RAMA") ;
            $('#cod_rama').focus();
            return false;
        }

        if (numPoliza === 0 ) {
            $('#mensaje_error').text("ERROR: INGRESE NUMERO DE POLIZA ") ;
            $('#num_poliza').focus();
            return false;
        }
        
        // Hacemos un request AJAX para pedir los datos de la poliza.
        // Esperamos recibir la respuesta en formato JSON.
        var url = "<%= Param.getAplicacion()%>rest/endosoService/validaPol/?cod_rama=" + codRama +
                  "&num_poliza=" + numPoliza + "&endoso=" + tipoEndoso + "&userid=" + $('#usuario').val();

        $.getJSON(url, function(data){

                $(data).each (function (index, pol ) {
                    $('#cod_error').val (pol.iNumError);
                    if ( pol.iNumError < 0 ) {
                        $('#mensaje_error').text(pol.sMensError) ;
                        $('#cod_rama').focus();
                    } else {
                        $('#cod_sub_rama').val (pol.codSubRama);
                        $('#cod_producto').val (pol.codProducto);
                        $('#cod_prod').val (pol.codProd);
                    }
                });

        });
        
        cargarEndosos ();
    }
  
    function cargarEndosos () {
        

        var codRama = $('#cod_rama').val();
        var codSubRama = $('#cod_sub_rama').val();
        var codProducto = $('#cod_producto').val();
        var codProd = $('#cod_prod').val();
        var codError = parseInt ( $('#cod_error').val());
        
        if ( codError === 0 ) { 
            $('#TIPO_ENDOSO option').remove();

            // Hacemos un request AJAX para pedir los datos de paises.
            // Esperamos recibir la respuesta en formato JSON.
            var url = "<%= Param.getAplicacion()%>rest/endosoService/getAllEndosos/?cod_rama=" + codRama +
                       "&cod_sub_rama=" + codSubRama + "&cod_producto=" + codProducto + 
                       "&cod_prod=" + codProd + "&userid="  + $('#usuario').val();

            $.getJSON(url, function(data){
                    // Este es el handler que se ejecutara al recibirse la respuesta, si hay éxito.

                    // Cargo los nuevos datos para el combo de paises:
                    $("<option value='-1'>Seleccione tipo de endoso</option>").appendTo("#TIPO_ENDOSO");
                    // Recorro los datos recibidos, que es un array de paises.
                    $(data).each(function(index, lTP) {
                            // Agrego una opcion al select, por cada pais.
                            aForm [lTP.codigo] = lTP.formulario;
                            aNivel[lTP.codigo] = lTP.nivel;
                            $("<option value='" + lTP.codigo + "' >" + lTP.descripcion + "</option>").appendTo("#TIPO_ENDOSO");
                    });

            });
        }
    }

</script>

</body>
</html>
