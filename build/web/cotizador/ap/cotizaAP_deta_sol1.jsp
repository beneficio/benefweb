<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Cotizacion"%>
<%@page import="com.business.beans.Provincia"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Generico"%>
<%@page import="com.business.beans.CotizadorSumas"%>
<%@page import="com.business.beans.Rubro"%>
<%@page import="com.business.beans.ActividadCategoria"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>
<% 
 Usuario usu = (Usuario) session.getAttribute("user");
    HtmlBuilder ohtml       = new HtmlBuilder();
    Tablas oTabla = new Tablas ();
    LinkedList lTabla = new LinkedList ();
    Cotizacion oCot = (Cotizacion) request.getAttribute("cotizacion");
    boolean bPrimeraVez = false;
    if (oCot == null ) {
        oCot = new Cotizacion ();
        oCot.setcodRama(10);
        oCot.setcodSubRama(2);
        oCot.setcodProducto(1);
        bPrimeraVez = true;
        }
    
    int iCapitalMuerte     = (int) oCot.getcapitalMuerte();
    int iCapitalInvalidez  = (int) oCot.getcapitalInvalidez();
    int iCapitalAsistencia = (int) oCot.getcapitalAsistencia();
    int iFranquicia        = (int) oCot.getfranquicia();
    
//    LinkedList lr = ConsultaMaestros.getAllRubros(oCot.getcodRama());

    LinkedList lAct = ConsultaMaestros.getAllActividades(oCot.getcodRama());
    LinkedList lProv = ConsultaMaestros.getAllProvincias();
    %>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>BENEFICIO S.A. - Cotizador de Accidentes Personales</title>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos-cot.css"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>

<!-- libreria jquery desde el cdn de google o fallback local -->

    <script src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
    <script src="<%= Param.getAplicacion()%>portal/js/vendor/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/chosen.jquery.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/prism.js" charset="utf-8"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>

<!--[if lt IE 9]>
	<script src="https://css3-mediaqueries-js.googlecode.com/svn/trunk/css3-mediaqueries.js"></script>
<![endif]-->

 <script type="text/javascript">

    var usuarios = ["VEFICOVICH","GLUCERO","PINO","AGLANC" ];
    var provConvenio = new Array(); 
<%  int ind = 0;
    for (int i=0; i<lProv.size();i++) {
        Provincia oP = (Provincia) lProv.get(i);
        if (oP.getConvMultilateral().equals("S")) { 
    %>
        provConvenio [<%=ind %>] = <%= oP.getCodigo() %>;
<%      ind++;
        }
    } 
    %>
    
    
    $(document).ready(function(){

            $("#actividad").change (function () {
                var cod_activ = $('#actividad').val();
                if (cod_activ !== null && cod_activ !== '' && parseInt (cod_activ) > 0 ) {
                    $('#mensaje_error').text("") ;
                    $('#mensaje_error7').text("") ;
                }
            });

            $("input[name=mca_prestacion]").click(function(){
                setearSumas  ();
            });

            $("#COD_PROVINCIA").change (function () {
                var cod = parseInt ($('#COD_PROVINCIA').val());
                if ( $.inArray( cod, provConvenio) === -1 ) {
                    $('#mensaje_error').text("NO ES POSIBLE COTIZAR EN LA PROVINCIA SELECCIONADA PORQUE ESTA FUERA DE CONVENIO") ;
                    $('#mensaje_error3').text("NO ES POSIBLE COTIZAR EN LA PROVINCIA SELECCIONADA PORQUE ESTA FUERA DE CONVENIO") ;
                } else { 
                    $('#mensaje_error').text(" ") ;
                    $('#mensaje_error3').text(" ") ;
                }
            });

            $("#COD_PROD").change (function () {
                var cod_prod = $('#COD_PROD').val();
                if ( cod_prod !== null && cod_prod !== '' && parseInt (cod_prod) > 0 ) {
                    $('#mensaje_error').text("") ;
                    $('#mensaje_error2').text("") ;
                }
            });

            $("#CAPITAL_MUERTE").change (function () {

                  $('#mensaje_error8').text("") ;

                  var min   = parseInt ( $("#CAPITAL_MUERTE").attr ("min"));
                  var max   = parseInt ( $("#CAPITAL_MUERTE").attr ("max"));
                  var valor = parseInt ( $("#CAPITAL_MUERTE").val());
                  if (isNaN(min)) min = 0;
                  if (isNaN(max)) max = 0;
                  if (isNaN(valor)) valor = 0;

                  if ( min === 0 && max === 0 ) {
                        validarProductor ();
                        validarActividad ();

                  } else {
                        if ( ( valor < min || valor > max) && $.inArray ($("#usuario").val(), usuarios) == -1 ) {
                            $('#mensaje_error8').text("Suma asegurada por muerte inválida. Debería ser entre " + min + " y " + max) ;
                            $('#CAPITAL_MUERTE').focus();
                             return false;
                        }
                  }
                  var valorIn = parseInt ( $("#CAPITAL_INVALIDEZ").val());
                  if (isNaN(valorIn )) valorIn = 0;

                  if (valorIn === 0 )  {
                      $("#CAPITAL_INVALIDEZ").val($('#CAPITAL_MUERTE').val() );
                  }
            });

            $("#CAPITAL_INVALIDEZ").change (function () {

                  $('#mensaje_error8').text("") ;

                  var min   = parseInt ( $("#CAPITAL_INVALIDEZ").attr ("min"));
                  var max   = parseInt ( $("#CAPITAL_INVALIDEZ").attr ("max"));
                  var valor = parseInt ( $("#CAPITAL_INVALIDEZ").val());
                  if (isNaN(min)) min = 0;
                  if (isNaN(max)) max = 0;
                  if (isNaN(valor)) valor = 0;

                  if ( min === 0 && max === 0 ) {
                        validarProductor ();
                        validarActividad ();

                  } else {
                        if ( ( valor < min || valor > max ) && $.inArray ($("#usuario").val(), usuarios) === -1 ) {
                            $('#mensaje_error8').text("Suma asegurada de invalidez inválida. Debería ser entre " + min + " y " + max) ;
                            $('#CAPITAL_INVALIDEZ').focus();
                             return false;
                        }
                  }
            });

            $("#CAPITAL_ASISTENCIA").change (function () {

                  $('#mensaje_error8').text("") ;

                  var min   = parseInt ( $("#CAPITAL_ASISTENCIA").attr ("min"));
                  var max   = parseInt ( $("#CAPITAL_ASISTENCIA").attr ("max"));
                  var valor = parseInt ( $("#CAPITAL_ASISTENCIA").val());
                  if (isNaN(min)) min = 0;
                  if (isNaN(max)) max = 0;
                  if (isNaN(valor)) valor = 0;

                  if ( min === 0 && max === 0 ) {
                        validarProductor ();
                        validarActividad ();

                  } else {
                        if ( ( valor < min || valor > max) && $.inArray ($("#usuario").val(), usuarios) === -1 ) {
                            $('#mensaje_error8').text("Suma de Asistencia es inválida. Debería ser entre " + min + " y " + max) ;
                            $('#CAPITAL_ASISTENCIA').focus();
                             return false;
                        }
                  }
            });

            $("#FRANQUICIA").change (function () {

                  $('#mensaje_error8').text("") ;

                  var min   = parseInt ( $("#FRANQUICIA").attr ("min"));
                  var max   = parseInt ( $("#FRANQUICIA").attr ("max"));
                  var valor = parseInt ( $("#FRANQUICIA").val());
                  if (isNaN(min)) min = 0;
                  if (isNaN(max)) max = 0;
                  if (isNaN(valor)) valor = 0;

                  if ( min === 0 && max === 0 ) {
                        validarProductor ();
                        validarActividad ();

                  } else {
                        if ( ( valor < min || valor > max) && $.inArray ($("#usuario").val(), usuarios) === -1 ) {
                            $('#mensaje_error8').text("La franquicia es inválida. Debería ser entre " + min + " y " + max) ;
                            $('#FRANQUICIA').focus();
                             return false;
                        }
                  }
            });

		$("#COD_VIGENCIA").on( "change", function() {
                    if ( $('#COD_VIGENCIA').val() === '7') {
			$('#cantDias').show(200); //muestro mediante id
                    } else { 
                        $('#cantDias').hide(200); //muestro mediante id
                    } 
                    $('#mensaje_error').text("");
                    $('#mensaje_error5').text("") ;
		 });
	});        

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

         <h1 class="title-section hcotizadores">cotizador de accidentes personales detallado</h1>

         <!-- tabs -->

         <div class="tabs-container">

            <form name="form1" id="form1" method="post"  action="<%= Param.getAplicacion()%>servlet/CotizadorApServlet">
            <input type="hidden" name="opcion"      id="opcion"    value="cotizador"/>
            <input type="hidden" name="siguiente"   id="siguiente" value="solapa2"/>
            <input type="hidden" name="primera"   id="primera" value="<%= (bPrimeraVez == true ? "S" : "N") %>"/>
            <input type="hidden" name="tipo_cotizacion" id="tipo_cotizacion"    value="APD"/>
            <input type="hidden" name="COD_RAMA"    id="COD_RAMA"  value="10"/>
            <input type="hidden" name="COD_SUB_RAMA"id="COD_SUB_RAMA"  value="<%= oCot.getcodSubRama() %>"/>
            <input type="hidden" name="COD_PRODUCTO"id="COD_PRODUCTO"  value="<%= oCot.getcodProducto() %>"/>
            <input type="hidden" name="usuario"     id="usuario"   value="<%= usu.getusuario() %>"/>
            <input type="hidden" name="num_cotizacion" id="num_cotizacion" value="<%= oCot.getnumCotizacion() %>"/>
            <input type="hidden" name="tipo_usuario"   id="tipo_usuario"   value="<%= usu.getiCodTipoUsuario() %>"/>

            <ul class="tabs">
                <li class="active"><span class="step">1</span><a href="#tab1" title="datos generales">Datos Generales</a></li>
                <li><span class="step">2</span><a href="#" onclick="Ir ('solapa2');" title="cotizacion" class="last">Cotizaci&oacute;n</a></li>
            </ul>

            <!-- -->
            <div id="tab1" class="tab-content form">
            <div class="form-wrap">

            <div class="form-file">
                 <div class="wrap-elements w50">
                 <label for="">Cotizado por:</label>
<%          if (usu.getiCodTipoUsuario() == 0 || usu.getiCodProd () >= 80000) {
                if ( oCot.getcodProd () == 0) { oCot.setcodProd (usu.getiCodProd()); }
               LinkedList lProd = (LinkedList) session.getAttribute("Productores");
    %>
                     <select data-placeholder="Elije o busque un productor de la lista..." name="COD_PROD" id="COD_PROD" class="chosen-select" onchange="cargarOpcionales (); setearSumas ();" >
                     <option value=""></option>
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
                <div class="styled-select">
                <select name="COD_PROD" id="COD_PROD">
<%
                oCot.setcodProd (usu.getiCodProd());
    %>
                    <option value="<%= oCot.getcodProd() %>"><%= ( usu.getRazonSoc() + " (" + oCot.getcodProd() + ")" ) %></option>
                </select>
                 </div>
<%          }%>

                 <span id="mensaje_error2" class="error-message"></span>
                 </div>

                 <div class="wrap-elements w50">
                 <label for="">Cliente:</label>
                 <input type="text" name="TOMADOR_APE" id="TOMADOR_APE" value="<%= (oCot.gettomadorApe() == null ? " " : oCot.gettomadorApe()) %>" class="" />
                <label for="fisica">El cliente es persona&nbsp;
                    <input type="radio" name="categoria_persona" id="fisica" value="F" <%=( oCot.getcategoriaPersona() != null && oCot.getcategoriaPersona().equals("F") ? "checked" : " " ) %> />&nbsp;f&iacute;sica o&nbsp;
                    <input type="radio" name="categoria_persona" id="juridica" value="J"  <%=( oCot.getcategoriaPersona() != null && oCot.getcategoriaPersona().equals("J") ? "checked" : " " ) %> />&nbsp;jur&iacute;dica
                </label>
                <span id="mensaje_error11" class="error-message"></span>
                 </div>
            </div>
            <div class="form-file">
                 <div class="wrap-elements w50">
                 <label for="">Provincia del riesgo:</label>
                     <select data-placeholder="Elija la provincia de la lista..." name="COD_PROVINCIA" id="COD_PROVINCIA" class="chosen-select">
                     <option value=""></option>
<%              for (int i=0; i<lProv.size();i++) {
                    Provincia oP = (Provincia) lProv.get(i);
    %>
                     <option value="<%= oP.getCodigo() %>" <%= (oCot.getcodProvincia() == oP.getCodigo() ? "selected" : " ") %>><%= oP.getDescripcion() %></option>    
<%              }
    %>
                 </select>
                 <span id="mensaje_error3" class="error-message"></span>
                 </div>

                  <div class="wrap-elements w50">
                     <label for="">Cantidad de Personas:</label>
                        <input type="text" name="CANT_PERSONAS" ID="CANT_PERSONAS" value="<%= oCot.getcantPersonas()%>" min="1" 
                               max="<%= ( usu.getiCodTipoUsuario() == 0 ? "999999" : "500") %>"
                               maxlength="<%= ( usu.getiCodTipoUsuario() == 0 ? "6" : "3") %>" onKeyPress="return Mascara('D',event);"/>
                    <span id="mensaje_error4" class="error-message"></span>
                 </div>
           </div>


           <!-- separador -->
           <div class="form-file separador"></div>
           <!--! -->


           <div class="form-file">
                   <div class="wrap-elements w50">
                   <label for="">Vigencia:</label>
                         <div class="styled-select">  
                             <select name="COD_VIGENCIA" id="COD_VIGENCIA" >
                                    <option value='0' <%= (oCot.getcodVigencia() == 0 ? "selected" : " ") %>>Seleccione vigencia</option>
                                    <option value='7' <%= (oCot.getcodVigencia() == 7 ? "selected" : " ") %>>Periodo corto</option>
                                    <option value='1' <%= (oCot.getcodVigencia() == 1  ? "selected" : " ") %>>Mensual</option>
                                    <option value='2' <%= (oCot.getcodVigencia() == 2  ? "selected" : " ") %>>Bimestral</option>
                                    <option value='3' <%= (oCot.getcodVigencia() == 3  ? "selected" : " ") %>>Trimestral</option>
                                    <option value='4' <%= (oCot.getcodVigencia() == 4  ? "selected" : " ") %>>Cuatrimestral</option>
                                    <option value='5' <%= (oCot.getcodVigencia() == 5  ? "selected" : " ") %>>Semestral</option>
                                    <option value='9' <%= (oCot.getcodVigencia() == 9  ? "selected" : " ") %>>9 meses</option>
                                    <option value='6' <%= (oCot.getcodVigencia() == 6  ? "selected" : " ") %>>Anual</option>
                             </select>
                         </div>
                        <div class="form-file" id="cantDias">
                            <p>Cantidad de d&iacute;as del periodo corto:&nbsp;<input type="text" name="CANT_DIAS" id="CANT_DIAS" value="<%= oCot.getcantDias()%>" /></p>
                        </div>
                        <span id="mensaje_error5" class="error-message"></span>
                   </div>

                 <div class="wrap-elements w50">
                     <label for="">Ambito:</label>
                     <div class="styled-select">
                         <select name="COD_AMBITO" id="COD_AMBITO" onchange="cargarOpcionales ();">
                             <option value="0" >Seleccione el ambito del seguro</option>
                            <%
                                   lTabla = oTabla.getDatosOrderByDesc ("COT_AMBITO");
                                   out.println(ohtml.armarSelectTAG(lTabla,  String.valueOf(oCot.getcodAmbito())));
                                 %>
                          </select>
                     </div>
                    <span id="mensaje_error6" class="error-message"></span>
                 </div>
            </div>
                          
            <div class="form-file">
                 <div class="wrap-elements w100">
                     <label for="actividad">Actividad:</label>
                     <select data-placeholder="Elije o busca una de lista..." name="actividad" id="actividad" class="chosen-select" onchange="setearSumas();">
                         <option value=""></option>
<%
                                for (int i= 0; i< lAct.size(); i++) {
                                    ActividadCategoria ac = (ActividadCategoria) lAct.get(i);
    %>
                             <option value="<%= ac.getcodActividad() %>" <%= (ac.getcodActividad() == oCot.getcodActividad() ? "selected" : " ") %> ><%= ac.getdescripcion() %></option>
<%                               }
    %>
                      </select>
                </div>
                <span id="mensaje_error7" class="error-message"></span>
            </div>

            <div class="form-file">
                <p>Si cotiza con actividad secundaria, haga <a href="#" id="activity-open" title="desplegar actividad secundaria">click aqu&iacute;</a></p>
            </div>

            <!-- actividad secundaria, oculta -->

            <div class="form-file hide" id="activity">

                 <div class="wrap-elements w100">
                     <label for="">Actividad 2da.:</label>
                     <select name="actividad2" id="actividad2" data-placeholder="Elije o busca una de lista..." class="chosen-select" onchange="setearSumas ();">
                         <option value="0">SELECCIONE ACTIVIDAD SECUNDARIO </option>
                         <option value=""></option>
<%
                                for (int i= 0; i< lAct.size(); i++) {
                                    ActividadCategoria ac = (ActividadCategoria) lAct.get(i);
    %>
                             <option value="<%= ac.getcodActividad() %>" <%= (ac.getcodActividad() == oCot.getcodActividadSec() ? "selected" : " ") %> ><%= ac.getdescripcion() %></option>
<%                               }
    %>
                      </select>
                 </div>
            </div>
            <!--! -->

            <!-- remote script segun prodcutor que ingresÃ³ -->
             <div class="form-file">
                   <div class="wrap-elements w50">
                   <label for="">Opcionales:</label>
                         <div class="styled-select">
                         <select name="COD_OPCION" id="COD_OPCION">
                         </select>
                         </div>
                   </div>
            </div>
            <!--! -->

            <!-- separador -->
           <div class="form-file separador"></div>
           <!--! -->

           <div class="form-file sumas2">
<%--                  <div class="wrap-elements w25">
                      <label for="">Pr&oacute;tesis:</label>
                     <input type="text" name="PROTESIS" id="PROTESIS" value="<%= oCot.getcapitalProtesis() %>"  max="0" min="0"/>
                 </div>
                 <div class="wrap-elements w25">
                     <label for="">Sepelio:</label>
                     <input type="text" name="SEPELIO" id="SEPELIO" value="<%= oCot.getcapitalSepelio() %>"  max="0" min="0"/>
                 </div>
--%>
                 <div class="wrap-elements w25">
                 <label for="prestacional">Prestacional:</label>
                 <input name="mca_prestacion" id="mca_prestacion_P" type="radio" value="P" <%= ( oCot.getmcaPrestacion() != null && oCot.getmcaPrestacion().equals("P") ? "checked" : " ") %> />
                 </div>
                 <div class="wrap-elements w25">
                 <label for="reintegro">Reintegro:</label>
                 <input name="mca_prestacion" id="mca_prestacion_R" type="radio" value="R" <%= ( oCot.getmcaPrestacion() != null && oCot.getmcaPrestacion().equals("R") ? "checked" : " ") %> />
                 </div>
                 <div class="wrap-elements w50">
                     &nbsp;
                 </div>
                <span id="mensaje_error10" class="error-message"></span>
           </div>

           <div class="form-file sumas">
                  <div class="wrap-elements w25">
                     <label for="">Muerte por accidente:</label>
                     <input type="text" name="CAPITAL_MUERTE" id="CAPITAL_MUERTE" value="<%= iCapitalMuerte %>" max="0" min="0"  onkeypress="return Mascara('D',event);" maxlength="8"/>
                 </div>
                 <div class="wrap-elements w25">
                     <label for="">Invalidez permanente, <br />total y/o parcial:</label>
                     <input type="text" name="CAPITAL_INVALIDEZ" id="CAPITAL_INVALIDEZ" value="<%= iCapitalInvalidez %>" max="0" min="0"  onkeypress="return Mascara('D',event);" maxlength="8"/>
                 </div>
                 <div class="wrap-elements w25">
                     <label for="">Asistencia m&eacute;dica farmac&eacute;utica:</label>
                     <input type="text" name="CAPITAL_ASISTENCIA" id="CAPITAL_ASISTENCIA" value="<%= iCapitalAsistencia %>" max="0" min="0"  onkeypress="return Mascara('D',event);" maxlength="8"/>
                 </div>
                 <div class="wrap-elements w25">
                     <label for="">Franquicia:</label>
                     <input type="text" name="FRANQUICIA" id="FRANQUICIA" value="<%= iFranquicia %>" max="0" min="0"  onkeypress="return Mascara('D',event);" maxlength="8"/>
                 </div>
                <span id="mensaje_error8" class="error-message"></span>
           </div>



            </div><!-- form wrap -->


            </div>
           <!--! tab content .form-->


           <!-- button section -->
            <div class="form-file button-container">
                <span id="mensaje_error" class="validation-message">&nbsp;</span>
           <!--  <span class="validation-message">&mdash; Hubo errores en el formulario, verifique los campos ...</span>
                 <input type="button" name="" id="" value="salir" class="bt exit" /> -->
                <input type="button" name="cotizar" id="cotizar" value="cotizar" class="bt next" onclick="Ir ('solapa2');" />
            </div>
            <!--! button section -->

            </form>
        </div>

        <!--! tabs -->

            <jsp:include flush="true" page="/bottom.jsp"/>

    </div>
<!--! container -->
</div> <!--! wrapper -->

<script type="text/javascript">
// cargarOpcionales();setearSumas ();actividadSec();
 if ( window.addEventListener ) {
     window.addEventListener( "load", cargarOpcionales, false );
     window.addEventListener( "load", setearSumas, false );
     window.addEventListener( "load", actividadSec, false );
     window.addEventListener( "load", cantDias, false );
  }
  else
     if ( window.attachEvent ) {
        window.attachEvent( "onload", cargarOpcionales );
        window.attachEvent( "onload", setearSumas );
        window.attachEvent( "onload", actividadSec );
        window.attachEvent( "onload", cantDias );
  } else
        if ( window.onLoad ) {
           window.onload = cargarOpcionales;
           window.onload = setearSumas;
           window.onload = actividadSec;
           window.onload = cantDias;
  }

    var config = {
      '.chosen-select' : {},
      '.chosen-select' : {allow_single_deselect:true},
      '.chosen-select' : {disable_search_threshold:10},
      '.chosen-select' : {no_results_text:'Oops, no se encontro nada!'}
    }
    for (var selector in config) {
      $(selector).chosen(config[selector]);
    }

    $(document).ready(function(){
		 $( "#activity-open" ).click(function() {
			  $( "#activity" ).toggleClass("show");
			  return false;
		  });
    });

    function validarProductor () {
        var cod_prod = $('#COD_PROD').val();
        if (cod_prod == null || cod_prod == '' || cod_prod == '-1') {
            $('#mensaje_error').text("- ERROR: debe ingresar el productor") ;
            $('#mensaje_error2').text("Debe ingresar el productor") ;
            $('#COD_PROD').focus();
             return false;
        }
    }

    function validarActividad () {
        var cod_activ = $('#actividad').val();

        if (cod_activ == null || cod_activ == '' || cod_activ == '0') {
            $('#mensaje_error').text("- ERROR: debe ingresar la actividad") ;
            $('#mensaje_error7').text("Debe ingresar la actividad") ;
            $('#actividad').focus();
             return false;
        }
    }

   function Validar () {

    var cod_prod      = $('#COD_PROD').val();
    var cod_provincia = $('#COD_PROVINCIA').val ();
    var cod_vigencia  = $('#COD_VIGENCIA').val ();
    var cantPersonas  = $('#CANT_PERSONAS').val ();
    var cod_ambito    = $('#COD_AMBITO').val ();

    $('#mensaje_error').text("") ;
    $('#mensaje_error2').text("") ;
    $('#mensaje_error3').text("") ;
    $('#mensaje_error4').text("") ;
    $('#mensaje_error5').text("") ;
    $('#mensaje_error6').text("") ;
    $('#mensaje_error7').text("") ;
    $('#mensaje_error8').text("") ;
    $('#mensaje_error10').text("") ;
    $('#mensaje_error11').text("") ;

    if (  $('#COD_PROD').val() === "" || parseInt (cod_prod) <= 0 ) {
        $('#mensaje_error').text("- ERROR: debe ingresar el productor") ;
        $('#mensaje_error2').text("Debe ingresar el productor") ;
        $('#COD_PROD').focus();
        return false;
    }

   //Se verifica si alguno de los radios esta seleccionado
    if ( ! $('input[name="categoria_persona"]').is(':checked')) {
        $('#mensaje_error').text("- ERROR: Seleccione si el tomador es persona física o jurídica") ;
        $('#mensaje_error11').text("Seleccione si el tomador es persona física o jurídica") ;
        $('#fisica').focus();
        return false;
    }
    
    if (  $('#COD_PROVINCIA').val() === "" ||  parseInt (cod_provincia) <= 0 ) {
        $('#mensaje_error').text("- ERROR: Seleccione la provincia del riesgo") ;
        $('#mensaje_error3').text("Seleccione la provincia del riesgo") ;
        $('#COD_PROVINCIA').focus();
        return false;
    }

    if ( $.inArray( parseInt ($('#COD_PROVINCIA').val()), provConvenio) === -1 ) {
        $('#mensaje_error').text("NO ES POSIBLE COTIZAR EN LA PROVINCIA SELECCIONADA PORQUE ESTA FUERA DE CONVENIO") ;
        $('#mensaje_error3').text("NO ES POSIBLE COTIZAR EN LA PROVINCIA SELECCIONADA PORQUE ESTA FUERA DE CONVENIO") ;
    } 

    if ( parseInt (cantPersonas) === 0 ) {
        $('#mensaje_error').text("- ERROR: Ingrese la cantidad de personas a cotizar") ;
        $('#mensaje_error4').text("Ingrese cantidad de personas") ;
        $('#CANT_PERSONAS').focus();
        return false;
    }

    if ( cod_vigencia === null || cod_vigencia === '' || parseInt (cod_vigencia) <= 0 ) {
        $('#mensaje_error').text("- ERROR: Seleccione una vigencia para el seguro ") ;
        $('#mensaje_error5').text("Seleccione vigencia  ") ;
        $('#COD_VIGENCIA').focus();
        return false;
    }
    
    if ( cod_vigencia !== null && parseInt (cod_vigencia) === 7 ) {
        var cantDias = $('#CANT_DIAS').val();
        if ( cantDias === null || cantDias === '' || parseInt (cantDias) <= 0 || parseInt (cantDias) > 30 ) {
            $('#mensaje_error').text("- ERROR: Seleccione cantidad de días entre 1 y 30 ");
            $('#mensaje_error5').text("Seleccione cant. de días válido  ") ;
            $('#CANT_DIAS').focus();
            return false;
        }
    }

    if ( cod_ambito === null || cod_ambito === '' || parseInt (cod_ambito) <= 0 ) {
        $('#mensaje_error').text("- ERROR: Seleccione ambito del seguro ") ;
        $('#mensaje_error6').text("Seleccione ambito  ") ;
        $('#COD_AMBITO').focus();
        return false;
    }

        validarActividad ();

//        if ( $("input[name='mca_prestacion']:radio").is(':checked') == false  ) {
//                $('#mensaje_error10').text("Seleccione \"Prestacional\" o \"Reintegro\"  ") ;
//                $('#mensaje_error').text("- ERROR: Seleccione \"Prestacional\" o \"Reintegro\"") ;
//                 return false;
//         }

        var min   = parseInt ( $("#CAPITAL_MUERTE").attr ("min"));
        var max   = parseInt ( $("#CAPITAL_MUERTE").attr ("max"));
        var valor = parseInt ( $("#CAPITAL_MUERTE").val());
        if (isNaN(min)) min = 0;
        if (isNaN(max)) max = 0;
        if (isNaN(valor)) valor = 0;
        if ( ( valor < min || valor > max ) && $.inArray ($("#usuario").val(), usuarios) === -1 ) {
            $('#mensaje_error8').text("Suma asegurada por muerte inválida. Debería ser entre " + min + " y " + max) ;
            $('#CAPITAL_MUERTE').focus();
             return false;
        }

        if ( valor > min && valor % 10000 !== 0 && $('#tipo_usuario').val() === "1" ) {
            $('#mensaje_error8').text("Suma asegurada por muerte inválida. Debería ser multiplo de $ 10.000" ) ;
            $('#CAPITAL_MUERTE').focus();
             return false;
        }

        min   = parseInt ( $("#CAPITAL_INVALIDEZ").attr ("min"));
        max   = parseInt ( $("#CAPITAL_INVALIDEZ").attr ("max"));
        valor = parseInt ( $("#CAPITAL_INVALIDEZ").val());
        if (isNaN(min)) min = 0;
        if (isNaN(max)) max = 0;
        if (isNaN(valor)) valor = 0;
        if ( ( valor < min || valor > max ) && $.inArray ($("#usuario").val(), usuarios) === -1 ) {
            $('#mensaje_error8').text("Suma asegurada por invalidez  inválida. Debería ser entre " + min + " y " + max) ;
            $('#CAPITAL_INVALIDEZ').focus();
             return false;
        }
        if ( valor > min && valor % 10000 !== 0 && $('#tipo_usuario').val() === "1" ) {
            $('#mensaje_error8').text("Suma asegurada por invalidez inválida. Debería ser multiplo de $ 10.000" ) ;
            $('#CAPITAL_INVALIDEZ').focus();
             return false;
        }

        min   = parseInt ( $("#CAPITAL_ASISTENCIA").attr ("min"));
        max   = parseInt ( $("#CAPITAL_ASISTENCIA").attr ("max"));
        valorAsist = parseInt ( $("#CAPITAL_ASISTENCIA").val());
        if (isNaN(min)) min = 0;
        if (isNaN(max)) max = 0;
        if (isNaN(valorAsist)) valorAsist = 0;
        if ( ( valorAsist < min || valorAsist > max ) && $.inArray ($("#usuario").val(), usuarios) === -1  ) {
            if (min === max) {
                $('#mensaje_error8').text("Suma asegurada por asistencia medica inválida. Debería ser " + max) ;
            } else {
                $('#mensaje_error8').text("Suma asegurada por asistencia medica inválida. Debería ser entre " + min + " y " + max) ;
            }
            $('#CAPITAL_ASISTENCIA').focus();
             return false;
        }

        if ( valorAsist > 0 && $('#tipo_usuario').val() === "1" ) {
            if (min !== 0 &&  valorAsist % 10000 !== 0 ) {
                $('#mensaje_error8').text("Suma asegurada por asistencia tiene que ser multiplo de $ 10.000" ) ;
                $('#CAPITAL_ASISTENCIA').focus();
                 return false;
            }
        }
//
        min   = parseInt ( $("#FRANQUICIA").attr ("min"));
        max   = parseInt ( $("#FRANQUICIA").attr ("max"));
        var valorFranquicia = parseInt ( $("#FRANQUICIA").val());
        if (isNaN(min)) min = 0;
        if (isNaN(max)) max = 0;
        if (isNaN(valorFranquicia)) valor = 0;
        if ( max > 0 && ( valorFranquicia < min || valorFranquicia > max) &&
               $.inArray ($("#usuario").val(), usuarios) === -1  ) {
            if (min === max) {
                $('#mensaje_error8').text("Franquicia inválida. Debería ser " + max) ;
            } else {
                $('#mensaje_error8').text("Franquicia inválida. Debería ser entre " + min + " y " + max) ;
            }
            $('#FRANQUICIA').focus();
             return false;
        }

        if ( valorFranquicia  >  valorAsist ) {
            $('#mensaje_error8').text("Franquicia inválida, debería ser menor que la asistencia") ;
            $('#FRANQUICIA').focus();
             return false;
        }

        if( ( $("input[name='mca_prestacion']:radio").is(':checked') === false  ||
              ( $("input[name='mca_prestacion']:radio").is(':checked') === true &&
                $("input[name='mca_prestacion']:checked").val() === 'P'
               )
            ) && valorFranquicia > 0 ) {
            $('#mensaje_error8').text("Si selecciona PRESTACIONAL la franquicia tiene que ser cero ") ;
            $('#FRANQUICIA').focus();
             return false;
        }

        if ( valorAsist > 0 ) {
            if( $("input[name='mca_prestacion']:radio").is(':checked') == false ) {
                $('#mensaje_error').text("- ERROR: Seleccione el tipo de prestación deseada: PRESTACIONAL O REINTEGRO  ") ;
                $('#mensaje_error10').text("Seleccione PRESTACIONAL o REINTEGRO  ") ;
                $('#mca_prestacion').focus();
                return false;
            }
        }

        if( $("input[name='mca_prestacion']:radio").is(':checked') === true &&
            $("input[name='mca_prestacion']:checked").val() === 'P' &&
            valorAsist == 0 &&  $('#primera').val() === "S" ) {
            $('#mensaje_error8').text("Si elige PRESTACIONAL debería ingresar una Suma asegurada por asistencia médica.") ;
            $('#CAPITAL_ASISTENCIA').focus();
             return false;
        }

        if( $("input[name='mca_prestacion']:radio").is(':checked') === false &&  valorAsist === 0 ) {
            $("#mca_prestacion_R").attr('checked', true);
             $("#mca_prestacion_R").val ("R");
            document.getElementById("COD_SUB_RAMA").value = "1" ;
        }
   return true;
   }

   function Ir (sigte) {

    if (sigte === 'salir') {
        document.form1.action = "<%= Param.getAplicacion()%>index.jsp";
    } else {
        if (Validar () ) {
                document.getElementById("COD_SUB_RAMA").value = "2" ;

                if ($("input[name='mca_prestacion']:checked").val() === 'R') {
                    document.getElementById("COD_SUB_RAMA").value = "1" ;
                }

                document.getElementById("COD_PRODUCTO").value =
                    document.getElementById("COD_AMBITO").value;

                var valor = parseInt ( $("#CAPITAL_ASISTENCIA").val());
                if (isNaN (valor)) $("#CAPITAL_ASISTENCIA").val('0');
                var valor2 = parseInt ( $("#FRANQUICIA").val());
                if (isNaN(valor2)) $("#FRANQUICIA").val('0');
                
                
                document.getElementById("siguiente").value = sigte;
                document.form1.submit();
                return true;
        }  else  return false;
     }
  }

    function cargarOpcionales () {

            // Elimino los datos actuales de los combos.
            var  codOpcionSelected = <%= oCot.getcodOpcion() %>;
            if (codOpcionSelected === 0 ) {
                codOpcionSelected = -1;
            }

            $('#COD_OPCION option').remove();

            // Obtenemos el productor seleccionado actualmente.
            var cod_prod = $('#COD_PROD').val();
            if (cod_prod === null || cod_prod === '' || cod_prod === '-1')
                    return;

            var cod_ambito = $('#COD_AMBITO').val();
            if (cod_ambito === null || cod_ambito === '' || cod_ambito === '0')
                    return;

            var cod_sub_rama = $('#COD_SUB_RAMA').val();
            var cod_rama    = $('#COD_RAMA').val();

            // Hacemos un request AJAX para pedir los datos de paises.
            // Esperamos recibir la respuesta en formato JSON.
            var url = "<%= Param.getAplicacion()%>rest/cotizaService/opciones/?cod_rama=" + cod_rama +
                      "&cod_prod=" + cod_prod + "&cod_sub_rama=" + cod_sub_rama + "&usuario=PROD" +
                      "&cod_ambito=" + cod_ambito;

            $.getJSON(url, function(data){
                    // Este es el handler que se ejecutara al recibirse la respuesta, si hay éxito.

                    // Cargo los nuevos datos para el combo de paises:
                    $("<option value='-1'>Seleccione una opcional</option>").appendTo("#COD_OPCION");
                    // Recorro los datos recibidos, que es un array de paises.
                    $(data).each(function(index, opcion) {
                            // Agrego una opcion al select, por cada pais.

                            $("<option value='" +opcion.codOpcion + "' >" + opcion.descripcion + "</option>").appendTo("#COD_OPCION");
                    });

                    $("#COD_OPCION").val( codOpcionSelected );

            });
    }


    function setearSumas  () {

            var cod_rama     = $('#COD_RAMA').val();
            var cod_producto = $('#COD_AMBITO').val();
            $('#mensaje_error8').text("") ;


            if ( $("input[name='mca_prestacion']:radio").is(':checked') === false  ) {
                $('#COD_SUB_RAMA').val('1');
            } else {
                if ( $("input[name='mca_prestacion']:checked").val() === 'R') {
                    $('#COD_SUB_RAMA').val('1');
                } else {
                    $('#COD_SUB_RAMA').val('2');
                }
            }

            var cod_sub_rama = $('#COD_SUB_RAMA').val();

            if(cod_producto === undefined)  cod_producto = 1;

            // Obtenemos el productor seleccionado actualmente.
            var cod_prod = $('#COD_PROD').val();
            if (cod_prod === null || cod_prod === '' || cod_prod === '-1')
                    return;

            // Obtenemos el productor seleccionado actualmente.
            var cod_activ = $('#actividad').val();
            if (cod_activ === null || cod_activ === '')
                    return;

            // Hacemos un request AJAX para pedir los datos de paises.
            // Esperamos recibir la respuesta en formato JSON.
            var url = "<%= Param.getAplicacion()%>rest/cotizaService/get_sumas_ap/?cod_rama=" + cod_rama +
                      "&cod_prod=" + cod_prod + "&cod_sub_rama=" + cod_sub_rama + "&cod_producto=" + cod_producto +
                      "&cod_actividad=" + cod_activ;

            $.getJSON(url, function(data){

                    $(data).each (function (index, sumas ) {
                        switch ( sumas.codCob ) {
                            case 1 :
                                $("#CAPITAL_MUERTE").attr ("min", sumas.sumaMinima);
                                $("#CAPITAL_MUERTE").attr ("max", sumas.sumaMaxima);
                                break;

                            case 2 :
                                $("#CAPITAL_INVALIDEZ").attr ("min", sumas.sumaMinima);
                                $("#CAPITAL_INVALIDEZ").attr ("max", sumas.sumaMaxima);
                                break;

                            case 4 :
                                $("#CAPITAL_ASISTENCIA").attr ("min", sumas.sumaMinima);
                                $("#CAPITAL_ASISTENCIA").attr ("max", sumas.sumaMaxima);
                                break;

                            default :  0;
                        }
                    });

            });
    }

    function actividadSec () {
        var actividadSec = '<%= oCot.getcodActividadSec() %>';
        if ( actividadSec !==   '0' ) {
             $( "#activity" ).toggleClass("show");
        }
    return;
    }

    function cantDias () {
        var vigencia = '<%= oCot.getcodVigencia() %>';
        if ( vigencia !== null &&  vigencia ===   '7' ) {
            $( "#cantDias" ).show ();
        } else {
            $( "#cantDias" ).hide();            
        }
    return;
    }

</script>
</body>
</html>

