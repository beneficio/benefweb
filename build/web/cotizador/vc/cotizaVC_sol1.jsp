<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Cotizacion"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Generico"%>
<%@page import="com.business.beans.CotizadorSumas"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>
<% 
 Usuario usu = (Usuario) session.getAttribute("user");
    HtmlBuilder ohtml       = new HtmlBuilder();
    Tablas oTabla = new Tablas ();
    LinkedList lTabla = new LinkedList ();
    Cotizacion oCot = (Cotizacion) request.getAttribute("cotizacion");
    if (oCot == null) {
        oCot = new Cotizacion();
        oCot.setcodProvincia (1);
        oCot.setcodProd(39071);
        oCot.setcodRama(22);
        oCot.setcodSubRama(1);
        oCot.setcodProducto(1);
        oCot.setcodVigencia(6);
    } 
    %>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>BENEFICIO S.A. - Cotizador Vida Colectivo</title>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos-cot.css"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>

<!-- libreria jquery desde el cdn de google o fallback local -->

    <script src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
    <script src="<%= Param.getAplicacion()%>portal/js/vendor/jquery-1.8.0.min.js"></script>

<!--[if lt IE 9]>
	<script src="https://css3-mediaqueries-js.googlecode.com/svn/trunk/css3-mediaqueries.js"></script>
<![endif]-->

    <script type="text/javascript">

    $(function() {
            // Esto será ejecutado luego de cargarse la página.

         cargarProductos();
         cargarVigencias();

    });

    function cargarProductos () {
            // Elimino los datos actuales de los combos.
            $('#COD_PRODUCTO option').remove();
            $('#COD_VIGENCIA option').remove();

            // Obtenemos el productor seleccionado actualmente.
            var cod_prod = $('#COD_PROD').val();
            if (cod_prod == null || cod_prod == '')
                    return;

            // Obtenemos la subrama  seleccionada actualmente.
            var cod_sub_rama = $('#COD_SUB_RAMA').val();
            if (cod_sub_rama == null || cod_sub_rama == '')
                    return;

            var usuario     = $('#usuario').val();
            var cod_rama    = $('#COD_RAMA').val();

            // Hacemos un request AJAX para pedir los datos de paises.
            // Esperamos recibir la respuesta en formato JSON.
            var url = "<%= Param.getAplicacion()%>rest/cotizaService/productos/?cod_prod=" + cod_prod +
                      "&cod_sub_rama=" + cod_sub_rama +
                      "&usuario=" + usuario +
                      "&cod_rama=" + cod_rama;
            $.getJSON(url, function(data){
                    // Este es el handler que se ejecutara al recibirse la respuesta, si hay éxito.

                    // Cargo los nuevos datos para el combo de paises:
                    $("<option value=''>Seleccione un producto de la subrama</option>").appendTo("#COD_PRODUCTO");
                    // Recorro los datos recibidos, que es un array de paises.
                    $(data).each(function(index, producto) {
                            // Agrego una opcion al select, por cada pais.

                            $("<option value='" + producto.codProducto + "'>" + producto.descProducto + "</option>").appendTo("#COD_PRODUCTO");
                    });

                    var valor = $("#cod_producto_ini").val ();
                    if ( parseInt (valor) > 0 && $("#COD_PRODUCTO").val() == '') {
                        $("#COD_PRODUCTO option[value=" + valor + "]").attr("selected",true);
                        $("#cod_producto_ini").attr("value", "0")

                        var vig   = $("#cod_vigencia_ini").val ();

                        if ( parseInt(vig) > 0 && $("#COD_VIGENCIA").val() == null ) {
                            cargarVigencias ();
                            $("#COD_VIGENCIA option[value=" + vig + "]").attr("selected",true);
                            $("#cod_vigencia_ini").attr("value", "0")
                        }
                    }
            });
    }


    function cargarVigencias () {
            // Elimino los datos actuales de los combos.
            $('#COD_VIGENCIA option').remove();

            // Obtenemos el productor seleccionado actualmente.
            var cod_prod = $('#COD_PROD').val();
            if (cod_prod == null || cod_prod == '')
                    return;

            // Obtenemos la subrama  seleccionada actualmente.
            var cod_sub_rama = $('#COD_SUB_RAMA').val();
            if (cod_sub_rama == null || cod_sub_rama == '')
                    return;

            // Obtenemos el productor seleccionado actualmente.
            var cod_producto = $('#COD_PRODUCTO').val();
            if (cod_producto == null || cod_producto == '')
                    return;


            // Hacemos un request AJAX para pedir los datos de paises.
            // Esperamos recibir la respuesta en formato JSON.
            var url = "<%= Param.getAplicacion()%>rest/cotizaService/vigencias/?cod_rama=22&cod_prod=" + cod_prod + "&cod_sub_rama=" + cod_sub_rama + "&cod_producto=" + cod_producto;
            $.getJSON(url, function(data){

                    // Recorro los datos recibidos, que es un array de ciudades.
                    $(data).each(function(index, vigencia) {
                            // Agrego una opcion al select, por cada ciudad.
                            $("<option value='" + vigencia.codVigencia + "'>" + vigencia.descVigencia + "</option>").appendTo("#COD_VIGENCIA");
                    });
            });
    }

   function Validar () {

    var cod_prod      = $('#COD_PROD').val();
    var cod_sub_rama  = $('#COD_SUB_RAMA').val();
    var cod_producto  = $('#COD_PRODUCTO').val();
    var cod_provincia = $('#COD_PROVINCIA').val ();
    var cod_vigencia  = $('#COD_VIGENCIA').val ();

    if ( parseInt (cod_prod) <= 0 ) {
        $('#mensaje_error').text("- ERROR: debe ingresar el productor") ;
        $('#mensaje_error2').text("Debe ingresar el productor") ;
        $('#COD_PROD').focus();
        return false;
    }

    if ( parseInt (cod_provincia) <= 0 ) {
        $('#mensaje_error').text("- ERROR: Seleccione la provincia del riesgo") ;
        $('#mensaje_error3').text("Seleccione la provincia del riesgo") ;
        $('#COD_PROVINCIA').focus();
        return false;
    }
    if ( cod_sub_rama == null || cod_sub_rama == '' || parseInt (cod_sub_rama) <= 0 ) {
        $('#mensaje_error').text("- ERROR: Seleccione la subrama") ;
        $('#mensaje_error4').text("Seleccione la subrama") ;
        $('#COD_SUB_RAMA').focus();
        return false;
    }

    if ( cod_producto == null ||cod_producto == '' || parseInt (cod_producto) <= 0 ) {
        $('#mensaje_error').text("- ERROR: Seleccione un producto ") ;
        $('#mensaje_error5').text("Seleccione un producto ") ;
        $('#COD_PRODUCTO').focus();
        return false;
    }

    if ( cod_vigencia == null || cod_vigencia == '' || parseInt (cod_vigencia) <= 0 ) {
        $('#mensaje_error').text("- ERROR: Seleccione una vigencia para el seguro ") ;
        $('#mensaje_error6').text("Seleccione vigencia  ") ;
        $('#COD_VIGENCIA').focus();
        return false;
    }

   return true;
   }

   function Ir (sigte) {       
    $("#COD_SUB_RAMA_DESC").val($( "#COD_SUB_RAMA option:selected" ).text().split('-')[1]) ;
    if (sigte == 'salir') {
        document.form1.action = "<%= Param.getAplicacion()%>index.jsp";
    } else {
        if (Validar () ) {
            if (sigte == 'solapa3' && eval($('#CANT_VIDAS').val()) == 0 ) {
                document.getElementById("siguiente").value = 'solapa2';
                document.form1.submit();
                return true;
            } else {
                document.getElementById("siguiente").value = sigte;
                document.form1.submit();
                return true;
            }
            } else  return false;
        }
    }

    </script>

</head>

<!--[if IE 7]>         <body class="ie ie7 oldie"> <![endif]-->
<!--[if IE 8]>         <body class="ie ie8"> <![endif]-->
<!--[if IE 9]>         <body class="ie ie9"> <![endif]-->
<!--[if gt IE 9]><!--> <body>         <!--<![endif]-->

<!--[if lt IE 7]><div class="browser_old" id="aviso">Â¡Tu navegador es muy viejo! <a href="http://browsehappy.com/?locale=es" target="_blank">Actualizalo a uno mÃ¡s moderno</a> para tener una mejor experiencia y velocidad en la aplicacion.
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

         <h1 class="title-section hcotizadores">cotizador de vida colectivo</h1>

         <!-- tabs -->

         <div class="tabs-container">

            <form name="form1" id="form1" method="post"  action="<%= Param.getAplicacion()%>servlet/CotizadorVCServlet">
            <input type="hidden" name="opcion"      id="opcion"    value="cotizador"/>
            <input type="hidden" name="siguiente"   id="siguiente" value="solapa2"/>
            <input type="hidden" name="origen"      id="origen"    value="solapa1"/>
            <input type="hidden" name="COD_RAMA"    id="COD_RAMA"  value="<%= oCot.getcodRama () %>"/>
            <input type="hidden" name="usuario"     id="usuario"   value="<%= usu.getusuario() %>"/>
            <input type="hidden" name="cod_producto_ini" id="cod_producto_ini"   value="<%= oCot.getcodProducto() %>"/>
            <input type="hidden" name="cod_vigencia_ini" id="cod_vigencia_ini"   value="<%= oCot.getcodVigencia() %>"/>
            <input type="hidden" name="num_cotizacion" id="num_cotizacion"   value="<%= oCot.getnumCotizacion() %>"/>
            <input type="hidden" name="MUERTE_ACCIDENTAL" value="<%= (oCot.getmcaMuerteAccidental() == null ? "" : oCot.getmcaMuerteAccidental()) %>"/>
            <input type="hidden" name="COD_SUB_RAMA_DESC" id="COD_SUB_RAMA_DESC"  value="<%= oCot.getdescSubRama () %>"/>

            <input type="hidden" name="MCA_NOMINA_EXCEL" id="MCA_NOMINA_EXCEL"  value="<%= (oCot.getmcaNominaExcel()==null)?"":oCot.getmcaNominaExcel() %>"/>

<%      LinkedList lSumas = oCot.getlRangosSumas();
        int cantVidas = 0;
        if (lSumas != null) {
            for (int i=0; i< lSumas.size();i++) {
            CotizadorSumas oCS = (CotizadorSumas) lSumas.get(i);
            cantVidas += oCS.getcantVidas();
    %>
         	 <input type="hidden" name="VIDAS_<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>"       value="<%= oCS.getcantVidas() %>"/>
                 <input type="hidden" name="SUMA_MUERTE_<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>" value="<%= oCS.getsumaAsegMuerte()%>" />
                 <input type="hidden" name="SUMA_INVALIDEZ_<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>" value="<%= oCS.getsumaAsegInvalidez()%>"/>
                 <input type="hidden" name="EDAD_DESDE_<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>"  value="<%= oCS.getedadDesde() %>"/>
                 <input type="hidden" name="EDAD_HASTA_<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>"  value="<%= oCS.getedadHasta() %>"/>
                 <input type="hidden" name="SUMA_MUERTE_MAX_<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>" value="<%= oCS.getmaxSumaAsegMuerte() %>"/>
                 <input type="hidden" name="SUMA_INVALIDEZ_MAX_<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>" value="<%= oCS.getmaxSumaAsegInvalidez() %>"/>
                 <input type="hidden" name="SUMA_MUERTE_MIN_<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>" value="<%= oCS.getminSumaAsegMuerte() %>"/>
                 <input type="hidden" name="SUMA_INVALIDEZ_MIN_<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>" value="<%= oCS.getminSumaAsegInvalidez() %>"/>
                 <input type="hidden" name="TASA_MUERTE_<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>" value="<%= oCS.gettasaMuerte() %>"/>
                 <input type="hidden" name="TASA_INVALIDEZ_<%= oCS.getedadDesde() %>_<%= oCS.getedadHasta() %>" value="<%= oCS.gettasaInvalidez() %>"/>
<%          }
        }
    %>
           <input type="hidden" name="CANT_VIDAS" id="CANT_VIDAS" value="<%= cantVidas %>" />
            <ul class="tabs">
                <li class="active"><span class="step">1</span><a href="#tab1" title="datos generales">Datos Generales</a></li>
                <li><span class="step">2</span><a href="#" onclick="Ir ('solapa2');" title="datos de asegurados">Datos de Asegurados</a></li>
                <li><span class="step">3</span><a href="#" onclick="Ir ('solapa3');" title="cotizacion" class="last">Cotizaci&oacute;n</a></li>
            </ul>

            <!-- -->
            <div id="tab1" class="tab-content form">
            <div class="form-wrap">

            <div class="form-file">
                 <div class="wrap-elements w50">
                 <label for="">Cotizado por:</label>
                 <div class="styled-select">
<%          if (usu.getiCodTipoUsuario() == 0 || usu.getiCodProd () >= 80000) {
                if ( oCot.getcodProd () == 0) { oCot.setcodProd (usu.getiCodProd()); }
               LinkedList lProd = (LinkedList) session.getAttribute("Productores");%>
                   <select name="COD_PROD" id="COD_PROD"  onchange="cargarProductos(); cargarVigencias();" >
                    <option value='-1'>Seleccione un productor</option>
<%             for (int i= 0; i < lProd.size (); i++) {
                    Usuario oProd = (Usuario) lProd.get(i);
                    if (oProd.getiCodProd() < 80000) {
                        out.print("<option value='" + String.valueOf (oProd.getiCodProd()) + "'"+
                                (oProd.getiCodProd()==oCot.getcodProd()?"selected":"")  +">" + oProd.getsDesPersona() + " (" +
                                oProd.getiCodProd() + ")</option>");
                    }
               }
%>
                   </select>

<%          }else{
    %>
                <select name="COD_PROD" id="COD_PROD">
<%
                oCot.setcodProd (usu.getiCodProd());
    %>
                    <option value="<%= oCot.getcodProd() %>"><%= ( usu.getRazonSoc() + " (" + oCot.getcodProd() + ")" ) %></option>
                </select>
<%          }%>
                 </div>
                 <span id="mensaje_error2" class="error-message"></span>
                 </div>

                 <div class="wrap-elements w50">
                 <label for="">Cliente:</label>
                 <input type="text" name="TOMADOR_APE" id="" value="<%= (oCot.gettomadorApe() == null ? " " : oCot.gettomadorApe()) %>" class="" />
                 </div>
            </div>

            <div class="form-file">
                 <div class="wrap-elements w50">
                 <label for="">Provincia del riesgo:</label>
                 <div class="styled-select">
                 <select name="COD_PROVINCIA" id="COD_PROVINCIA">
                     <option value="-1" >Seleccione provincia del riesgo</option>

        <%
                lTabla = oTabla.getDatosOrderByDesc ("PROVINCIA");
                out.println(ohtml.armarSelectTAG(lTabla, String.valueOf(oCot.getcodProvincia())));
            %>
                 </select>
                 </div>
                 <span id="mensaje_error3" class="error-message"></span>
                 </div>

                 <div class="wrap-elements w50">
                 <label for="">Subrama:</label>
                 <div class="styled-select">
                 <select name="COD_SUB_RAMA" id="COD_SUB_RAMA" onchange="cargarProductos(); cargarVigencias();">
                    <option value=''>Seleccione subrama</option>
<%
                    lTabla = oTabla.getSubRamasProductos( oCot.getcodRama(), usu.getusuario(), "C");
                    for (int ii = 0; ii < lTabla.size(); ii++) {
                        Generico oObj = (Generico) lTabla.get(ii);
    %>
                     <option value='<%= oObj.getCodigo()%>' <%= (oObj.getCodigo() == oCot.getcodSubRama() ? "selected" : " ")%>><%= oObj.getDescripcion()%></option>
<%          }

    %>
                 </select>
                 </div>
                 <span id="mensaje_error4" class="error-message"></span>
                 </div>
            </div>

            <div class="form-file">
                 <div class="wrap-elements w50">
                 <label for="">Producto:</label>
                 <div class="styled-select">
                 <select name="COD_PRODUCTO" id="COD_PRODUCTO" onchange="cargarVigencias ();">
                     <option value="" >Seleccione un producto de la subrama</option>
                 </select>
                 </div>
                 <span id="mensaje_error5" class="error-message"></span>
                 </div>

                 <div class="wrap-elements w50">
                 <label for="">Vigencia:</label>
                 <div class="styled-select">
                 <select name="COD_VIGENCIA"  id="COD_VIGENCIA">
                     <option value="" >Seleccione la vigencia del seguro </option>
                 </select>
                 </div>
                 <span id="mensaje_error6" class="error-message"></span>
                 </div>
            </div>

            </div><!-- form wrap -->


            </div>
           <!--! tab content .form-->


           <!-- button section -->
            <div class="form-file button-container">
                <span id="mensaje_error" class="validation-message">&nbsp;</span>
                <!-- <input type="button" name="" id="" value="salir" class="bt exit" /> -->
                <input type="button" name="continuar" id="continuar" value="continuar &rarr;" class="bt next" onclick="Ir ('solapa2');"/>
            </div>
            <!--! button section -->

            </form>
        </div>

        <!--! tabs -->

            <jsp:include flush="true" page="/bottom.jsp"/>

    </div>
<!--! container -->

</div> <!--! wrapper -->

</body>
</html>

<%--
            <input type="text"   name="COD_RAMA"      id="COD_RAMA"      value="22"/>
            <input type="text"   name="COD_SUB_RAMA"  id="COD_SUB_RAMA"  value="2"/>
            <input type="text"   name="COD_PRODUCTO"  id="COD_PRODUCTO"  value="2"/>
            <input type="text"   name="COD_PROVINCIA" id="COD_PROVINCIA" value="1"/>
            <input type="text"   name="COD_VIGENCIA"  id="COD_VIGENCIA"  value="6"/>
            <input type="text"   name="TOMADOR_APE"   id="TOMADOR_APE"   value=""/>
            <input type="button" name="salir" id="salir" value="Salir" onclick="javascript:Ir ('salir');"/>
            <input type="button" name="continuar" id="continuar" value="Continuar" onclick="javascript:Ir ('solapa2');"/>
--%>