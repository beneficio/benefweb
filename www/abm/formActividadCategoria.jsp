<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.*"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<% Usuario usu = (Usuario) session.getAttribute("user"); 

    if (usu.getiCodTipoUsuario() != 0) {
        request.setAttribute("javax.servlet.jsp.jspException", new SurException ("acceso denegado"));
        getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
        
    }

    HtmlBuilder ohtml       = new HtmlBuilder();
    Tablas oTabla = new Tablas ();
    LinkedList lTabla =  ConsultaMaestros.getAllActividadesCategorias ();

//    ActividadCategoria oAct = (ActividadCategoria) request.getAttribute ("actividad");
    int codActividad = (request.getParameter ("cod_actividad") == null ? 0 :
                        Integer.parseInt (request.getParameter ("cod_actividad") ) );

    String codRama = request.getParameter("COD_RAMA");
    if (codRama == null){
        codRama = "10";
    }
    String codSubRama = "2"; 

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
<link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos-cot.css"/>
<!-- libreria jquery desde el cdn de google o fallback local -->
<script type="text/javascript" src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
<script type="text/javascript" src="<%= Param.getAplicacion()%>portal/js/vendor/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%= Param.getAplicacion()%>script/chosen.jquery.js"></script>
<script type="text/javascript" src="<%= Param.getAplicacion()%>script/prism.js" charset="utf-8"></script>
<script type="text/javascript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>

<!--[if lt IE 9]>
	<script src="http://css3-mediaqueries-js.googlecode.com/svn/trunk/css3-mediaqueries.js"></script>
<![endif]-->

<script language='javascript'>
      var lastError=null;
      function Submitir () {   
            if ( document.formAct.DESCRIPCION.value =="" ){
               alert("Por favor ingrese una descripcion para la actividad");
               return false;  
            }
            if ( document.formAct.CATEGORIA.value =="" ){
               alert("Por favor ingrese una categoria para la actividad");
               return false;  
            }
            if ( isNaN(document.formAct.CATEGORIA.value)  ){
               alert("Por favor ingrese un numero de categoria valido");
               return false;  
            }
            if ( document.formAct.CATEGORIA.value < 1){
               alert("Categoria incorrecta. El numero de categoria debe ser mayor a 0 ");
               return false;  
            }

             
            return true;
      }

    function DoChange (oSelect) {

    var codigo = oSelect.options[oSelect.selectedIndex].value;
    var descripcion = oSelect.options[oSelect.selectedIndex].text;

    $('#DESCRIPCION').val (descripcion );
    $('#caracteres').val(descripcion.length );
    $('#CATEGORIA').val( $('#CATEGORIA_' + codigo).val() );
    if ( $('#MCA_BAJA_' + codigo).val() == "X"){
         $("#MCA_BAJA_RADIO").attr('checked', true);
    } else {
         $("#MCA_BAJA_RADIO").attr('checked', false);
    }
    if ( $('#MCA_PLANES_' + codigo).val() == "X") {
         $("#MCA_PLANES_RADIO").attr('checked', true);
    }else {
         $("#MCA_PLANES_RADIO").attr('checked', false);
    }
    if ( $('#MCA_COTIZADOR_' + codigo).val() == "X") {
         $("#MCA_COTIZADOR_RADIO").attr('checked', true);
    }else {
         $("#MCA_COTIZADOR_RADIO").attr('checked', false);
    }
    if ( $('#MCA_NO_RENOVAR_' + codigo).val() == "X") {
         $("#MCA_NO_RENOVAR_RADIO").attr('checked', true);
    }else {
         $("#MCA_NO_RENOVAR_RADIO").attr('checked', false);
    }
    if ( $('#MCA_24HORAS_' + codigo).val() == "X") {
         $("#MCA_24HORAS_RADIO").attr('checked', true);
    } else {
         $("#MCA_24HORAS_RADIO").attr('checked', false);
    }
    if ( $('#MCA_ITINERE_' + codigo).val() == "X") {
         $("#MCA_ITINERE_RADIO").attr('checked', true);
    } else {
         $("#MCA_ITINERE_RADIO").attr('checked', false);
    }
    
    if ( $('#MCA_LABORAL_' + codigo).val() == "X") {
         $("#MCA_LABORAL_RADIO").attr('checked', true);
    } else {
         $("#MCA_LABORAL_RADIO").attr('checked', false);
    }

    DoChangeActividad( 10, 2, codigo);

    }

    function Volver () {
           window.location.replace("<%= Param.getAplicacion()%>abm/formAbmIndex.jsp");
    }
   
    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }


    function DoChangeActividad( codRama, codSubRama, codActividad ){
       var sUrl = "<%= Param.getAplicacion()%>abm/rs/selectCoberturas.jsp"
       if ( codRama && codSubRama && codActividad ){
            sUrl = sUrl + "?cod_rama=" + codRama + "&cod_sub_rama=" + codSubRama + "&cod_actividad=" + codActividad;
       }
       if (oFrameCoberturas){
            oFrameCoberturas.location = sUrl;
       }
    }

     function Grabar () {
            if ( document.formAct.DESCRIPCION.value =="" ){
               alert("Por favor ingrese una descripcion para la actividad");
               return false;  
            }
            if ( document.formAct.CATEGORIA.value =="" ){
               alert("Por favor ingrese una categoria para la actividad");
               return false;  
            }
            if ( isNaN(document.formAct.CATEGORIA.value)  ){
               alert("Por favor ingrese un numero de categoria valido");
               return false;  
            }
            if ( parseInt (document.formAct.CATEGORIA.value) < 1){
               alert("Categoria incorrecta. El numero de categoria debe ser mayor a 0 ");
               return false;  
            }


        if (oFrameCoberturas){
            oFrameCoberturas.document.form1.opcion.value = "addActividadCategoria";
            oFrameCoberturas.document.form1.target = "_top";
            oFrameCoberturas.document.form1.action = "<%= Param.getAplicacion()%>servlet/ActividadCategoriaServlet";
            oFrameCoberturas.document.form1.CATEGORIA.value     = document.formAct.CATEGORIA.value;
            oFrameCoberturas.document.form1.DESCRIPCION.value   = document.formAct.DESCRIPCION.value;

            if ( $("input[name='MCA_BAJA_RADIO']:checkbox").is(':checked') == true ) {
                oFrameCoberturas.document.form1.MCA_BAJA.value    = "X";
            } else {
                oFrameCoberturas.document.form1.MCA_BAJA.value    = "";
            }

            if ( $("input[name='MCA_PLANES_RADIO']:checkbox").is(':checked') == true ) {
                oFrameCoberturas.document.form1.MCA_PLANES.value    = "X";
            } else {
                oFrameCoberturas.document.form1.MCA_PLANES.value    = "";
            }

            if ( $("input[name='MCA_COTIZADOR_RADIO']:checkbox").is(':checked') == true ) {
                oFrameCoberturas.document.form1.MCA_COTIZADOR.value    = "X";
            } else {
                oFrameCoberturas.document.form1.MCA_COTIZADOR.value    = "";
            }
            if ( $("input[name='MCA_NO_RENOVAR_RADIO']:checkbox").is(':checked') == true ) {
                oFrameCoberturas.document.form1.MCA_NO_RENOVAR.value    = "X";
            } else {
                oFrameCoberturas.document.form1.MCA_NO_RENOVAR.value    = "";
            }
            if ( $("input[name='MCA_24HORAS_RADIO']:checkbox").is(':checked') == true ) {
                oFrameCoberturas.document.form1.MCA_24HORAS.value    = "X";
            } else {
                oFrameCoberturas.document.form1.MCA_24HORAS.value    = "";
            }
            if ( $("input[name='MCA_ITINERE_RADIO']:checkbox").is(':checked') == true ) {
                oFrameCoberturas.document.form1.MCA_ITINERE.value    = "X";
            } else {
                oFrameCoberturas.document.form1.MCA_ITINERE.value    = "";
            }
            if ( $("input[name='MCA_LABORAL_RADIO']:checkbox").is(':checked') == true ) {
                oFrameCoberturas.document.form1.MCA_LABORAL.value    = "X";
            } else {
                oFrameCoberturas.document.form1.MCA_LABORAL.value    = "";
            }

            oFrameCoberturas.document.form1.submit(); 
        }	 
}

function NuevaActividad () {
        if (oFrameCoberturas){
           oFrameCoberturas.document.form1.COD_ACTIVIDAD.value   = 0; 
        }
    $('#DESCRIPCION').val ("");
    $('#CATEGORIA').val ("");
    $('#caracteres').val("0");
    $("#MCA_BAJA_RADIO").attr('checked', false);
    $("#MCA_PLANES_RADIO").attr('checked', false);
    $("#MCA_COTIZADOR_RADIO").attr('checked', false);
    $("#MCA_NO_RENOVAR_RADIO").attr('checked', false);
    $("#MCA_24HORAS_RADIO").attr('checked', false);
    $("#MCA_ITINERE_RADIO").attr('checked', false);
    $("#MCA_LABORAL_RADIO").attr('checked', false);

    return true;
}

function calcLong(txt, dst, formul, maximo) {
    var largo;
    largo = formul[txt].value.length;
    if (largo > maximo) {
        formul[txt].value = formul[txt].value.substring(0,maximo);
    }
     formul[dst].value = formul[txt].value.length;
}

</script>
<!--[if IE 7]>         <body class="ie ie7 oldie"> <![endif]-->
<!--[if IE 8]>         <body class="ie ie8"> <![endif]-->
<!--[if IE 9]>         <body class="ie ie9"> <![endif]-->
<!--[if gt IE 9]><!--> <body>         <!--<![endif]-->

<!--[if lt IE 7]><div class="browser_old" id="aviso">Â¡Tu navegador es muy viejo! <a href="http://browsehappy.com/?locale=es" target="_blank">Actualizalo a uno mÃ¡s moderno</a> para tener una mejor experiencia y velocidad en la aplicacion.
<a href="#" class="close_message" title="cerrar aviso" onclick="document.getElementById('aviso').style.display='none';return false"></a>
</div><![endif]-->
<table cellSpacing="0" cellPadding="0" width="960" align="center" border="0">
    <tr>
        <td>
            <jsp:include page="/header.jsp">
                <jsp:param name="aplicacion" value="<%= Param.getAplicacion() %>" />
                <jsp:param name="usuario" value="<%= usu.getusuario() %>" />
                <jsp:param name="descripcion" value="<%= usu.getRazonSoc() %>" />
            </jsp:include>
            <div class="menu">
                <menu:renderMenuFromDB    aplicacion="1"  userLogon="<%= usu.getusuario()%>" />
            </div>
        </td>
    </tr>
    <tr>
        <td align="left" valign="top">
            <table width='100%' cellpadding='2' cellspacing='3' border='0' align="center" class="fondoForm" style="margin-left:5;margin-top:5;margin-bottom:5;">
                <form name="formAct" id="formAct" method="POST" action="<%= Param.getAplicacion()%>servlet/ActividadCategoriaServlet" onKeyUp="calcLong('DESCRIPCION', 'caracteres',this, 300);" >
                    <input type="hidden" name="opcion" id="opcion" value="addActividadCategoria"/>
                    <input type="hidden" name="COD_RAMA" id="COD_RAMA" value="<%=codRama%>"/>
<%    for (int i=0; i< lTabla.size ();i++ ){
        ActividadCategoria oAC = (ActividadCategoria) lTabla.get(i);
    %>
        <input type="hidden" name="CATEGORIA_<%= oAC.getcodActividad()%>" id="CATEGORIA_<%= oAC.getcodActividad()%>" value="<%= oAC.getcategoria() %>"/>
        <input type="hidden" name="MCA_BAJA_<%= oAC.getcodActividad()%>" id="MCA_BAJA_<%= oAC.getcodActividad()%>" value="<%= (oAC.getmcaBaja() == null ? "" : oAC.getmcaBaja() )%>"/>
        <input type="hidden" name="MCA_PLANES_<%= oAC.getcodActividad()%>"    id="MCA_PLANES_<%= oAC.getcodActividad()%>" value="<%= (oAC.getmcaPlanes() == null ? "" : oAC.getmcaPlanes())%>"/>
        <input type="hidden" name="MCA_COTIZADOR_<%= oAC.getcodActividad()%>" id="MCA_COTIZADOR_<%= oAC.getcodActividad()%>" value="<%= (oAC.getmcaCotizador() == null ? "" : oAC.getmcaCotizador())%>"/>
        <input type="hidden" name="MCA_NO_RENOVAR_<%= oAC.getcodActividad()%>" id="MCA_NO_RENOVAR_<%= oAC.getcodActividad()%>" value="<%= (oAC.getmcaNoRenovar() == null ? "" : oAC.getmcaNoRenovar() )%>"/>
        <input type="hidden" name="MCA_24HORAS_<%= oAC.getcodActividad()%>" id="MCA_24HORAS_<%= oAC.getcodActividad()%>" value="<%= (oAC.getmca24Horas() == null ? "" : oAC.getmca24Horas())%>"/>
        <input type="hidden" name="MCA_ITINERE_<%= oAC.getcodActividad()%>" id="MCA_ITINERE_<%= oAC.getcodActividad()%>" value="<%= (oAC.getmcaItinere() == null ? "" : oAC.getmcaItinere())%>"/>
        <input type="hidden" name="MCA_LABORAL_<%= oAC.getcodActividad()%>" id="MCA_LABORAL_<%= oAC.getcodActividad()%>" value="<%= (oAC.getmcaLaboral() == null ? "" : oAC.getmcaLaboral() )%>"/>
<%    } %>

                <tr>
                    <td width='100%'  height='30' align="center" class='titulo'>ACTIVIDAD - CATEGORIA</td>
                </tr>
                <tr>
                    <td align="left" class='subtitulo'>
                        Seleccione una actividad para modificar o  haga click en el bot&oacute;n (+) para agregar una nueva.
                        <br/>Si hay un tilde en Activa, significa que la actividad esta vigente.
                        <br/>Luego, en ambos casos haga click en "Grabar".
                        <br/>IMPORTANTE: la modificación tendrá validez en forma inmediata sobre el cotizador.
                    </td>
                </tr>
                <tr>
                    <td align="left">
                         <select data-placeholder="Elije una actividad de la lista..." name="COD_ACTIVIDAD" id="COD_ACTIVIDAD" class="chosen-select" style="width: 860px;text-align: left;"  onchange="javascript:DoChange(this);">
                            <option value=""></option>
<%                          for (int i=0; i< lTabla.size(); i++) {
                                ActividadCategoria oAC = (ActividadCategoria) lTabla.get(i);
   %>
                            <option value="<%= oAC.getcodActividad() %>" <%= ( codActividad != 0 && codActividad == oAC.getcodActividad() ? "selected" : " " ) %>><%= ( oAC.getdescripcion() + " ("+ oAC.getcodActividad() + ")" ) %></option>
<%                          }
                        %>
                        </select>
                    </td>
               </tr>
                <tr>
                    <td class='text' align="center">
                        <textarea  cols='65' rows='4' class='inputText' name="DESCRIPCION" id="DESCRIPCION" ></textarea><br/><br/>
                        <input name="caracteres" type="text" id="caracteres" value="0" size="4" readonly/>&nbsp;Max. 300 caracteres
                    </td>
                </tr>
               <tr>
                   <td width="100%">
                        <table width='100%' cellpadding='2' cellspacing='2' border='1'>
                            <tr>
                                <td align="center">Categ.</td>
                                <td align="center">Anular</td>
                                <td align="center">Planes</td>
                                <td align="center">Cotizador</td>
                                <td align="center">No<br/>renovar</td>
                                <td align="center">No<br/>24Horas</td>
                                <td align="center">No<br/>Itinere</td>
                                <td align="center">No<br/>Laboral</td>
                                <td align="center"> + </td>
                            </tr>
                            <tr>
                                <td align="center" class='text'>
                                    <input name="CATEGORIA" id="CATEGORIA" onkeypress="return Mascara('D',event);" class="inputTextNumeric" type="text" maxlength='1' size="3"/>
                                </td>
                                <td align="center" class='text'>
                                    <input name="MCA_BAJA_RADIO" id="MCA_BAJA_RADIO"  class="inputText" type="CHECKBOX"/>
                                </td>
                                <td align="center" class='text'>
                                    <input name="MCA_PLANES_RADIO" id="MCA_PLANES_RADIO" class="inputText" type="CHECKBOX" />
                                </td>
                                <td align="center" class='text'>
                                    <input name="MCA_COTIZADOR_RADIO" id="MCA_COTIZADOR_RADIO" class="inputText" type="CHECKBOX"/>
                                </td>
                                <td align="center" class='text'>
                                    <input name="MCA_NO_RENOVAR_RADIO" id="MCA_NO_RENOVAR_RADIO" class="inputText" type="CHECKBOX"/>
                                </td>
                                <td align="center" class='text'>
                                    <input name="MCA_24HORAS_RADIO" id="MCA_24HORAS_RADIO" class="inputText" type="CHECKBOX"/>
                                </td>
                                <td align="center" class='text'>
                                    <input name="MCA_ITINERE_RADIO" id="MCA_ITINERE_RADIO" class="inputText" type="CHECKBOX"/>
                                </td>
                                <td align="center">
                                    <input name="MCA_LABORAL_RADIO" id="MCA_LABORAL_RADIO" class="inputText" type="CHECKBOX"/>
                                </td>
                                <td>
                                    <input type="reset" alt="Agrega una nueva actividad" value=" + " height="20px;width:10" class="boton" onclick='NuevaActividad ();'/>
                                </td>
                            </tr>
                        </table>
                   </td>
               </tr>
               <tr valign="top" align="left">
                    <td height="100px" valign="top" align="center" >
                        <iframe src="<%= Param.getAplicacion()%>abm/rs/selectCoberturas.jsp?cod_rama=<%= codRama %>&cod_sub_rama=<%= codSubRama %>&cod_actividad=0"
                            name="oFrameCoberturas" id="oFrameCoberturas" width="600px" height="200px" marginwidth="0" marginheight="0" align="top" frameborder="0">
                        </iframe>
                    </td>
                </tr>
                <tr>
                    <td align="center">
                        <input type="button" name="cmdSalir" value=" Salir " height="20px" class="boton" onClick="Salir();"/>&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button" name="cmdGrabar" value="Grabar" height="20px" class="boton" onclick="Grabar();"/>
                    </td>
                </tr>
                </form>
            </table>   
        </td>
    </tr>
    <tr>
        <td width='100%'>
            <jsp:include flush="true" page="/bottom.jsp"/>
        </td>
    </tr>
</table>  
<script type="text/javascript">

    var config = {
      '.chosen-select' : {},
      '.chosen-select' : {allow_single_deselect:true},
      '.chosen-select' : {disable_search_threshold:10},
      '.chosen-select' : {no_results_text:'Oops, no se encontro nada!'}
    }
    for (var selector in config) {
      $(selector).chosen(config[selector]);
    }

<%  if (  codActividad != 0 ) {
    %>
         DoChange (document.getElementById ('COD_ACTIVIDAD'));
<%  }
    %>
CloseEspere();
</script>
</body>
</html>
