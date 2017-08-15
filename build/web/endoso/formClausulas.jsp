<%@page import="java.awt.image.BufferStrategy"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Propuesta"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.beans.Clausula"%>
<%@page import="com.business.beans.Generico"%> 
<%@page import="com.business.beans.Tablas"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.sql.Connection"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>
<% 
    Usuario usu = (Usuario) session.getAttribute("user");
    
    Propuesta oProp = (Propuesta) request.getAttribute("propuesta");
    
    LinkedList <Clausula> lClau = oProp.getAllClausulas();
    String sVolver  = ( request.getParameter ("volver") == null ? "formEndosar" : request.getParameter ("volver") );    
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
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>portal/css/bootstrap.min.css"/>

<style>
	#content{
		position: relative;
		min-height: 50%;
		width: 60%;
		top: 20%;
		left: 5%;
	}
        
	selected{
		cursor: pointer;
	}

        selected:hover{
		background-color: #0585C0;
		color: white;
                
	}
	seleccionada{
		background-color: #0585C0;
		color: white;
	}
        
        .celda {
        text-align:left;
	font:600 0.938em "Open Sans", Arial, Helvetica, Sans-serif;
	color:#333;            
        }
        
</style>

    
    <script type="text/javascript" src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>portal/js/vendor/jquery-1.8.0.min.js"></script>    
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <script type="text/javascript">window.jQuery || document.write('<script src="<%= Param.getAplicacion()%>portal/js/vendor/jquery-1.8.3.min.js"><\/script>')</script>    
    <script src="<%= Param.getAplicacion()%>portal/js/bootstrap.min.js"></script>
    <script src="<%= Param.getAplicacion()%>portal/js/bootstrap.min.custom.js"></script>
   
<script type="text/javascript">

var volver = '<%= sVolver %>';
var cont= 0; 
var id_fila_selected=[];

    $(document).ready(function(){
        
        $("#salir").click(function(){
		history.back();
		return false;
          });

        $("#emitir").click(function(){
            if ( Validar () ) {               
                if( $('#cla_no_repeticion').prop('checked')) {
                    $('#cla_no_repeticion').val('S');
                } 
                if( $('#cla_subrogacion').prop('checked')) {
                    $('#cla_subrogacion').val ('S');
                } 
                
                
                $('#form1').submit ();
            }
        });
        
	$('#addmore').click(function(){
            cont=$('#tabla >tbody >tr').length;
            agregar();
        });
        
        $('tr button').live('click', function () {
            $(this).closest('tr').remove();
            reordenar();
        });


    });
 
	function agregar(){
            cont++;
            var fila='<tr class="selected" id="fila' + cont + '" onclick="seleccionar(this.id);"><td>' + cont + '</td><td><input name="cuit'
                    +cont+
                    '" id="cuit'
                    +cont+
                    '" size="11" maxlength="11" class="celda" onchange="ValidoCuitEmpresa(this);"/></td><td><input name="descripcion' 
                    +cont+
                    '" id="descripcion'
                    +cont+
                    '" size="60" maxlength="100" class="celda"/></td><td><button type="button" class="bt-addrmv" id="rmvbtn">Eliminar</button></td></tr>';

            $('#tabla').append(fila);
            reordenar();
	}

	function seleccionar(id_fila){
		if($('#'+id_fila).hasClass('seleccionada')){
			$('#'+id_fila).removeClass('seleccionada');
		}
		else{
			$('#'+id_fila).addClass('seleccionada');
		}
		//2702id_fila_selected=id_fila;
		id_fila_selected.push(id_fila);
	}

	function reordenar(){
            var num=1;
            $('#tabla tbody tr').each(function(){
		$(this).find('td').eq(0).text(num);
		num++;
            });
	}

 function Validar () {

    if( ! $('#cla_no_repeticion').prop('checked') &&  
        ! $('#cla_subrogacion').prop('checked') ) {
        $('#mensaje_error').text("ERROR: TIENE QUE SELECCIONAR UNA CLAUSULA VALIDA ") ;
        $('#cla_no_repeticion').focus();
        return false; 
    } 
        
    var cantidad = $('#tabla >tbody >tr').length;
    
    if ( cantidad === 0 ) { 
        $('#mensaje_error').text("ERROR: TIENE QUE INGRESAR AL MENOS UNA CLAUSULA VALIDA HACIENDO CLIC EN EL BOTON AGREGAR ") ;
        $('#addmore').focus();
        return false; 
    }
     return true;
 }
 
    function ValidoCuitEmpresa (empresa) {
        
        var nombre = empresa.name;
        var cuit = parseInt (empresa.value );
        if (isNaN(cuit)) {
            cuit = 0;
            empresa.value = "0";
        }
  
        if ( cuit !== "" && cuit !== 0 ) {
            if ( ! ValidoCuit ( Trim (empresa.value)) ) {
                   alert ("CUIT INVALIDO")
                    return empresa.focus();
            }
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

        <h1 class="title-section hcotizadores">Actualizaci&oacute;n de Cl&aacute;usulas</h1>

         <!-- tabs -->
         <div class="tabs-container"> 
            <form name="form1" id="form1" method="post"  action="<%= Param.getAplicacion()%>servlet/EndosoServlet">
            <input type="hidden" name="opcion"      id="opcion"      value="setFormClausulas"/>
            <input type="hidden" name="cod_rama"    id="cod_rama" value="<%= oProp.getCodRama()%>"/>
            <input type="hidden" name="num_poliza"  id="num_poliza" value="<%= oProp.getNumPoliza() %>"/>
            <input type="hidden" name="num_propuesta" id="num_propuesta" value="<%= oProp.getNumPropuesta() %>"/>
            <input type="hidden" name="TIPO_ENDOSO" id="TIPO_ENDOSO" value="<%= oProp.gettipoEndoso() %>"/>
            <input type="hidden" name="nivel"       id="nivel" value="<%= request.getParameter ("nivel") %>"/>
            <input type="hidden" name="formulario"  id="formulario" value="<%= request.getParameter ("formulario") %>"/>
            <input type="hidden" name="usuario"     id="usuario"   value="<%= usu.getusuario() %>"/>

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
                           placeholder="Raz&oacute;n Social o Nombre y Apellido" tabindex="4" title="Raz&oacute;n Social o Nombre y Apellido"  disabled />
                </div>
                <h1 class="title-section hcotizadores">Ingrese cl&aacute;usulas</h1>
                 <div class="wrap-elements w25">
                     <label for="no_repeticion">De repetici&oacute;n:</label>
                     <input type="checkbox" value="<%= oProp.getclaNoRepeticion() %>" name="cla_no_repeticion"  id="cla_no_repeticion"  <%= (oProp.getclaNoRepeticion().equals ("S") ? "checked" : " ") %> />
                 </div>
                 <div class="wrap-elements w25">
                     <label for="subrogacion">De subrogaci&oacute;n:</label>
                     <input type="checkbox" value="<%= oProp.getclaSubrogacion() %>" name="cla_subrogacion"  id="cla_subrogacion"   <%= (oProp.getclaSubrogacion().equals ("S") ? "checked" : " ") %> />
                 </div>
    <div class="wrap-elements w100">            
	<div id="content">
		<table id="tabla" class="table table-bordered">
		<thead>
                    <tr>
                        <td width="30">#</td>
                        <td width="50">Cuit</td>
                        <td width="200">Descripci&oacute;n</td>
                        <td width="50">Eliminar</td>
                    </tr>
		</thead>
                <tbody>
 <%                  int cant = 0;
                if (lClau.size() > 0 ) { 
                    for (int i=0; i < lClau.size(); i++) {    
                        Clausula oClau = (Clausula) lClau.get(i);
                        cant += 1;
                        
    %>
                    <tr class="selected" id="fila<%= i %>" onclick="seleccionar(this.id);">
                            <td><%= cant %></td>
                            <td><input name="cuit<%= i %>" id="cuit<%= i %>" size="11" maxlength="11" value="<%= oClau.getcuitEmpresa() %>" class="celda"
                                       onkeypress="return Mascara('D',event);" onchange="ValidoCuitEmpresa(this);" /></td>
                            <td><input name="descripcion<%= i %>" id="descripcion<%= i %>" value="<%= oClau.getdescEmpresa() %>" size="60" maxlength="30" class="celda"/></td>
                            <td><button type="button" class="bt-addrmv" id="rmvbtn">Eliminar</button></td>
                    </tr>
<%                  }
                }
    %>
                </tbody>    
	</table>
        <button type="button" class="bt-addrmv" id="addmore" >Agregar</button>
                
	</div>
    </div>            
                                       
                <span id="mensaje_error" class="validation-message">&nbsp;</span>
            </div>
            </div>    
            </div>    
            </form>
            
           <!--! tab content .form-->
            <div class="form-file button-container">
                <input type="button" name="salir"  id="salir" value=" Salir " class="bt exit" />
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


