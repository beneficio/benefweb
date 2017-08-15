<%@page import="java.awt.image.BufferStrategy"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Propuesta"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.beans.Generico"%> 
<%@page import="com.business.beans.Tablas"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.sql.Connection"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>
<% 
    Usuario usu = (Usuario) session.getAttribute("user");
    
    Propuesta oProp = (Propuesta) request.getAttribute("propuesta");

    String sVolver  = ( request.getParameter ("volver") == null ? "formEndosar" : request.getParameter ("volver") );

    Tablas      oTabla = new Tablas ();
    LinkedList  lTabla = oTabla.getDatos ("CONDICION_IVA");
    
    
//    Connection dbCon = null;
    
    %>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<!-- estilos css -->
    <title>BENEFICIO S.A. - Formulario de endosos No Nominativos</title>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos-cot.css" media="screen"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css" media="screen"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/tablasNew.css"/>

<!-- libreria jquery desde el cdn de google o fallback local -->
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>script/jquery-ui-1.10.3/themes/base/jquery.ui.all.css"/>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css"/>
<style>
	

.ui-autocomplete {
    max-height: 250px;
    overflow-y: auto;
/* prevent horizontal scrollbar */
    overflow-x: hidden;
    }
	
/* IE 6 doesn't support max-height
* we use height instead, but this forces the menu to always be this tall
*/
	
* html .ui-autocomplete {
    height: 250px;
}
	

</style>
    
    <script src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
    <script src="//code.jquery.com/jquery-1.10.2.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/chosen.jquery.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/prism.js" charset="utf-8"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/jquery-ui-1.10.3/ui/jquery-ui.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/jquery-ui-1.10.3/ui/jquery.ui.core.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/jquery-ui-1.10.3/ui/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/jquery-ui-1.10.3/ui/jquery.ui.datepicker.js"></script>
   
<script type="text/javascript">

var volver = '<%= sVolver %>';

function validateEmail( emailID ){
   atpos = emailID.indexOf("@");
   dotpos = emailID.lastIndexOf(".");
   if (atpos < 1 || ( dotpos - atpos < 2 ))
   {
       return false;
   }
   return( true );
}

    $(document).ready(function(){
	$(function() {
 		$("#search").autocomplete({
                    source : function(request, response) {
                            $.ajax({
                                    url : "<%= Param.getAplicacion()%>servlet/EndosoServlet",
                                    type : "POST",
                                    data : {
                                        term : request.term,
                                        opcion : "getLocalidad",
                                        cod_provincia : "99"
                                    },
                                    dataType : "json",
                                    success : function(data) {
                                        response( $.map( data, function( loc ) {
                                                
                                                return {
                                                    label: loc.localidad,
                                                    value: loc.localidad,
                                                    codLocalidad: loc.codLocalidad,
                                                    codProvincia: loc.codProvincia,
                                                    provincia: loc.provincia,
                                                    codPostal: loc.codPostal,
                                                    descLocalidad: loc.descLocalidad
                                                }
                                                }));
                                       },
                                    error: function (error) {
                                       alert('error: ' + error);
                                    }
                                    });
                                    },
                    minLength: 3,
                    focus: function( event, ui ) {
                      $( "#search" ).val( ui.item.value);
                      return false;
                    },                   
                    select: function( event, ui ) {
                      $( "#cod_postal" ).val( ui.item.codPostal );
                      $( "#cod_localidad" ).val( ui.item.codLocalidad );
                      $( "#provincia" ).val( ui.item.provincia );
                      $( "#cod_provincia" ).val( ui.item.codProvincia );
                      $( "#search" ).val( ui.item.descLocalidad );
                   //   getLocalidad ();
                      
                      return false;
                    }                                    
                    });
		});  

        $("#salir").click(function(){
		history.back();
		return false;
          });

        $("#emitir").click(function(){
            if ( Validar () ) {
                if( $('#ubic_igual_tomador').prop('checked') ) {
                    $('#ubic_igual_tomador').val('S');
                } else {
                    $('#ubic_igual_tomador').val('N');
                }
                
                $("#cod_postal").prop('disabled', false);
                
                $('#form1').submit ();
            }
        });
 });

  //function getLocalidad () {
  //  var url2 = "<%--= Param.getAplicacion()--%>rest/maestroService/getDescLocalidad/?cod_localidad=" + $( "#cod_localidad" ).val();
  //  $.getJSON(url2, function(data){

  //          $(data).each (function (index, oLoc ) {
  //              alert (oLoc.descLocalidad);
  //              $("#search").val (oLoc.descLocalidad);
  //          });

  //  });                      
 //   return true;
 // }
    
 function Validar () {
 
    if ( Trim($('#razon_social').val ()) === ""  ) {
        $('#mensaje_error').text("ERROR: INGRESE NOMBRE Y APELLIDO O RAZON SOCIAL ") ;
        $('#razon_social').focus();
        return false; 
    }
    
    if ( Trim($('#domicilio').val ()) === ""  ) {
        $('#mensaje_error').text("ERROR: EL DOMICILIO NO PUEDE ESTAR VACIO ") ;
        $('#domicilio').focus();
        return false; 
    }

    if ( parseInt($( "#cod_localidad" ).val()) === 0 && Trim( $( "#search" ).val()) !==  ""  ) {
        $('#mensaje_error').text("ERROR: TIENE QUE SELECCIONAR UNA LOCALIDAD VALIDA DE LA LISTA ") ;
        $('#search').focus();
        return false; 
    }
    return true;
 }

</script>

</head>

<!--[if lt IE 9]>
	<script src="https://css3-mediaqueries-js.googlecode.com/svn/trunk/css3-mediaqueries.js"></script>
<![endif]-->

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

         <h1 class="title-section hcotizadores">Actualizaci&oacute;n de datos del tomador</h1>

         <!-- tabs -->
         <div class="tabs-container"> 
            <form name="form1" id="form1" method="post"  action="<%= Param.getAplicacion()%>servlet/EndosoServlet">
            <input type="hidden" name="opcion"      id="opcion"      value="setFormTomador"/>
            <input type="hidden" name="cod_rama"    id="cod_rama" value="<%= oProp.getCodRama()%>"/>
            <input type="hidden" name="num_poliza"  id="num_poliza" value="<%= oProp.getNumPoliza() %>"/>
            <input type="hidden" name="num_propuesta" id="num_propuesta" value="<%= oProp.getNumPropuesta() %>"/>
            <input type="hidden" name="TIPO_ENDOSO" id="TIPO_ENDOSO" value="<%= oProp.gettipoEndoso() %>"/>
            <input type="hidden" name="nivel"       id="nivel" value="<%= request.getParameter ("nivel") %>"/>
            <input type="hidden" name="formulario"  id="formulario" value="<%= request.getParameter ("formulario") %>"/>
            <input type="hidden" name="usuario"     id="usuario"   value="<%= usu.getusuario() %>"/>
            <input type="hidden" name="cod_provincia" id="cod_provincia"   value="<%= oProp.getTomadorCodProv() %>"/>
            <input type="hidden" name="cod_localidad" id="cod_localidad"   value="<%= oProp.getTomadorCodLocalidad() %>"/>

            <div id="tab1" class="tab-content form">
            <div class="form-wrap">
                
            <div class="form-file">
                 <div class="wrap-elements w15">
                     <span class="item">Rama:</span>
                     <span class="item">P&oacute;liza N&deg;:</span>
                 </div>
                 <div class="wrap-elements w35">
                 	<span class="item-result"><%= oProp.getDescRama() %></span>
                        <span class="item-result"><%= oProp.getNumPoliza() %></span>
                 </div>
                 <div class="wrap-elements w10">
                     <span class="item">Productor:</span>
                    <span class="item">Vigencia</span>
                 </div>
                 <div class="wrap-elements w40">
                    <span class="item-result"><%= oProp.getdescProd() + " (" + oProp.getCodProd() + ")" %></span>
                    <span class="item-result"><%= Fecha.showFechaForm(oProp.getFechaIniVigPol()) + " al " + ( Fecha.showFechaForm(oProp.getFechaFinVigPol()).equals("01/01/1900") ? "sin fin vigencia" : Fecha.showFechaForm(oProp.getFechaFinVigPol()) ) %></span>
                 </div>
                <h1 class="title-section hcotizadores">Datos del tomador</h1>
                <div class="wrap-elements w15">
                    <label>Tipo</label>
                    <input id="tipo_doc" name="tipo_doc" type="text" value="<%= oProp.getTomadorDescTipoDoc() %>" tabindex="1"  disabled />
                </div>
                <div class="wrap-elements w35">
                    <label>Documento</label>
                    <input id="documento" name="documento" type="text" value="<%=  (oProp.getTomadorTipoDoc().equals("80") ? oProp.getTomadorCuit() : oProp.getTomadorNumDoc()) %>" tabindex="2" disabled/>
                </div>
                <div class="wrap-elements w50">
                    <label>Nom. y Apellido/Raz&oacute;n Social:&nbsp;</label>
                    <input id="razon_social" name="razon_social" type="text" value="<%= oProp.getTomadorRazon() %>" tabindex="3" size="50" maxlength="80" 
                           placeholder="Raz&oacute;n Social o Nombre y Apellido" tabindex="4" title="Raz&oacute;n Social o Nombre y Apellido" />
                </div>
                <div class="wrap-elements w50">
                    <label for="cond_iva">Condici&oacute;n de Iva:</label>
                    <div class="styled-select">
                    <select name="cond_iva" id="cond_iva">
<%                  for (int i=0; i< lTabla.size ();i++) { 
                        Generico oDat = (Generico) lTabla.get(i);
    %>                   
    <option value="<%= oDat.getsCodigo() %>" <%= (String.valueOf(oProp.getTomadorCondIva()).equals(oDat.getsCodigo()) ?  "selected" : "") %>><%= oDat.getDescripcion() %></option>
<%                  }
    %>
                    </select>
                    </div>
                </div>                           
                <div class="wrap-elements w50">
                    <label>Tel&eacute;fono:&nbsp;</label>
                    <input id="telefono" name="telefono" type="text" value="<%= (oProp.getTomadorTE() == null ? "" : oProp.getTomadorTE()) %>" tabindex="3" size="50" maxlength="30" 
                           placeholder="Ingrese tel&eacute;fono" tabindex="4" title="Telefono" />
                </div>
                <div class="wrap-elements w50">
                    <label>Email:&nbsp;</label>
                    <input id="email" name="email" type="text" value="<%= (oProp.getTomadorEmail() == null ? "" : oProp.getTomadorEmail() )%>" tabindex="3" size="50" maxlength="50" 
                           placeholder="Ingrese email" tabindex="4" title="Email" />
                </div>
                <h1 class="title-section hcotizadores">Domicilio</h1>
                <div class="wrap-elements w15">
                     <span class="item">Domicilio:</span>
                     <span class="item">Cod.Postal:</span>
                </div>
                <div class="wrap-elements w35">
                    <span class="item-result"><%= oProp.getTomadorDom() %></span>
                    <span class="item-result"><%= oProp.getTomadorCP()%></span>
                </div>
                <div class="wrap-elements w15">
                     <span class="item">Localidad:</span>
                     <span class="item">Provincia:</span>
                </div>
                <div class="wrap-elements w35">
                    <span class="item-result"><%= oProp.getTomadorLoc() %></span>
                    <span class="item-result"><%= oProp.getTomadorDescProv() %></span>
                </div>
                <div class="wrap-elements w50">
                    <label>Ingrese el nuevo domicilio:</label>
                    <input id="domicilio" name="domicilio" type="text" value="<%= oProp.getTomadorDom () %>" 
                            placeholder="domicilio" tabindex="4" title="domicilio"  size="50" maxlength="80" />
                </div>
                <div class="wrap-elements w50">
                    <label>Ingrese localidad o Cod. Postal:</label>
                    <div class="search-container">
                            <div class="ui-widget">
                                    <input type="text" id="search" name="localidad" class="search" 
                                            placeholder="Ingrese al menos 3 letras de la localidad o cod. postal" tabindex="5" title="Ingrese al menos 3 letras de la localidad o cod. postal" />
                            </div>
                    </div>
                </div>
                <div class="wrap-elements w50">
                    <label>Cod. Postal:</label>
                    <input id="cod_postal" name="cod_postal" type="text" tabindex="6" disabled />
                </div>
                <div class="wrap-elements w50">
                    <label>Provincia:</label>
                    <input type="text" id="provincia" name="provincia"  tabindex="7" disabled />
                </div>
                    
                <h1 class="title-section hcotizadores">
                    <input type="checkbox" name="ubic_igual_tomador" id="ubic_igual_tomador" value="N" />
                    &nbsp;&nbsp;Tilde aqui si la ubicaci&oacute;n del riesgo es igual a la del tomador
                </h1>                            
                <span id="mensaje_error" class="validation-message">&nbsp;</span>
            </div>
            </div>    
            </div>    
            </form>
            
           <!--! tab content .form-->
            <div class="form-file button-container">
                <input type="button" name="salir"  id="salir" value=" Salir " class="bt" />
                <input type="button" name="emitir" id="emitir" value="emitir propuesta" class="bt next" />
            </div>


           <!--! tab content .form-->
        </div>
        
         <jsp:include flush="true" page="/bottom.jsp"/>
    
    </div>
   <!--! container -->
    </div>

</body>
</html>


