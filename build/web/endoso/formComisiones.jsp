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
               
            $('#form1').submit ();
        });
 

    });
 
 function Validar () {

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

        <h1 class="title-section hcotizadores">Actualizaci&oacute;n de Comisiones de Mantenimiento</h1>

         <!-- tabs -->
         <div class="tabs-container"> 
            <form name="form1" id="form1" method="post"  action="<%= Param.getAplicacion()%>servlet/EndosoServlet">
            <input type="hidden" name="opcion"      id="opcion"      value="setFormComisiones"/>
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
                    <span class="item-result"><%= Fecha.showFechaForm(oProp.getFechaIniVigPol()) + " al " + ( oProp.getFechaFinVigPol() == null ? "Sin fin de vigencia" : (Fecha.showFechaForm(oProp.getFechaFinVigPol()).equals("01/01/1900") ? "sin fin vigencia" : Fecha.showFechaForm(oProp.getFechaFinVigPol()) )) %></span>
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
                           placeholder="Raz&oacute;n Social o Nombre y Apellido" tabindex="3" title="Raz&oacute;n Social o Nombre y Apellido"  disabled />
                </div>
                <h1 class="title-section hcotizadores">Datos de Comisiones Mantenimiento</h1>
                <div class="wrap-elements w25">
                     <label for="porc_comision_prod">Porc. de Comisiones Productor:</label>
                    <input id="porc_comision_prod" name="porc_comision_prod" type="text" 
                           value="<%=  Dbl.DbltoStr(oProp.getporcGDA(),2) %>" onKeyPress="return Mascara('N',event);" tabindex="4"/> 
                </div>
                <div class="wrap-elements w25">
                     <label for="porc_comision_org">Porc. de Comision Organizador:</label>
                    <input id="porc_comision_org" name="porc_comision_org" type="text" 
                           value="<%=  Dbl.DbltoStr(oProp.getporcComisionOrg(),2) %>" onKeyPress="return Mascara('N',event);" tabindex="5"/>
                </div>
                <div class="wrap-elements w25">
                     <label for="sub_seccion">Sub Secci&oacute;n:</label>
                    <input id="sub_seccion" name="sub_seccion" type="text" 
                            value="<%= oProp.getsubSeccion() %>" onKeyPress="return Mascara('D',event);" tabindex="6"/>
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


