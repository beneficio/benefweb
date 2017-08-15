<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.CotizadorAp"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Generico"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<% Usuario usu = (Usuario) session.getAttribute("user"); 
    HtmlBuilder ohtml       = new HtmlBuilder();
    Tablas oTabla = new Tablas ();
    LinkedList lTabla = new LinkedList ();
    CotizadorAp oCot = (CotizadorAp) request.getAttribute ("cotizador");
    if (oCot == null) {
        oCot = new CotizadorAp ();
        oCot.setgastosAdquisicion(-1);
        oCot.setcantCuotas(1);
    }
%>  
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
</head>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<link href="<%=Param.getAplicacion()%>css/Tablas.css" rel="stylesheet" type="text/css"/>
<style>
.TablasTit {
	BACKGROUND-COLOR: #6699cc;
	BORDER-BOTTOM: #3366cc 1px solid;
	BORDER-LEFT: #3366cc 1px solid;
	BORDER-RIGHT: #3366cc 1px solid;
	BORDER-TOP: #3366cc 1px solid;
        font-family: Verdana, Arial, Helvetica, sans-serif; color: #FFFFFF;
        font-size: 12px;
}
</style> 
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/alttxt.js"></script>
<script type="" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script language='javascript'>
      var lastError=null;

      function Submitir () {

          document.getElementById('CAPITAL_MUERTE').value =  oFrameCoberturas.document.getElementById ('CAPITAL_MUERTE').value; 
          document.getElementById('CAPITAL_INVALIDEZ').value = oFrameCoberturas.document.getElementById ('CAPITAL_INVALIDEZ').value; 
          document.getElementById('CAPITAL_ASISTENCIA').value = oFrameCoberturas.document.getElementById ('CAPITAL_ASISTENCIA').value; 
          document.getElementById('FRANQUICIA').value = oFrameCoberturas.document.getElementById ('FRANQUICIA').value;

//          if ( BrowserDetect.browser == 'Explorer') {
//              document.getElementById('CAPITAL_MUERTE').min =  oFrameCoberturas.document.getElementById ('CAPITAL_MUERTE').min;
//              document.getElementById('CAPITAL_INVALIDEZ').min = oFrameCoberturas.document.getElementById ('CAPITAL_INVALIDEZ').min;
//              document.getElementById('CAPITAL_ASISTENCIA').min = oFrameCoberturas.document.getElementById ('CAPITAL_ASISTENCIA').min;
//              document.getElementById('FRANQUICIA').min = oFrameCoberturas.document.getElementById ('FRANQUICIA').min;

//              document.getElementById('CAPITAL_MUERTE').max =  oFrameCoberturas.document.getElementById ('CAPITAL_MUERTE').max;
//              document.getElementById('CAPITAL_INVALIDEZ').max = oFrameCoberturas.document.getElementById ('CAPITAL_INVALIDEZ').max;
//              document.getElementById('CAPITAL_ASISTENCIA').max = oFrameCoberturas.document.getElementById ('CAPITAL_ASISTENCIA').max;
//              document.getElementById('FRANQUICIA').max = oFrameCoberturas.document.getElementById ('FRANQUICIA').max;
//           } else {
              document.getElementById('CAPITAL_MUERTE').min =  oFrameCoberturas.document.getElementById ('SUMA_MIN_1').value; 
              document.getElementById('CAPITAL_INVALIDEZ').min = oFrameCoberturas.document.getElementById ('SUMA_MIN_2').value; 
              document.getElementById('CAPITAL_ASISTENCIA').min = oFrameCoberturas.document.getElementById ('SUMA_MIN_4').value;  
              document.getElementById('FRANQUICIA').min = oFrameCoberturas.document.getElementById ('SUMA_MIN_5').value; 

              document.getElementById('CAPITAL_MUERTE').max =  oFrameCoberturas.document.getElementById ('SUMA_MAX_1').value; 
              document.getElementById('CAPITAL_INVALIDEZ').max = oFrameCoberturas.document.getElementById ('SUMA_MAX_2').value;  
              document.getElementById('CAPITAL_ASISTENCIA').max = oFrameCoberturas.document.getElementById ('SUMA_MAX_4').value; 
              document.getElementById('FRANQUICIA').max = oFrameCoberturas.document.getElementById('SUMA_MAX_5').value; 

 //          }
           
            document.getElementById('GASTOS_ADQUISICION').value     = oFrameGastos.document.getElementById ('GASTOS_ADQUISICION').value;
            document.getElementById('MAX_GASTOS_ADQUISICION').value = oFrameGastos.document.getElementById ('MAX_GASTOS_ADQUISICION').value;
            document.getElementById('cuotas').value                 =  oFrameVigencias.document.getElementById ('cuotas').value;
            document.getElementById('COD_VIGENCIA').value           =  oFrameVigencias.document.getElementById ('COD_VIGENCIA').value;
          
<%       if (usu.getiCodTipoUsuario() == 0 || usu.getiCodProd () >= 80000) {%>
            if (document.formCot.COD_PROD.value == "-1" ) {
                alert ("Por favor seleccione un productor.");
                document.formCot.COD_PROD.focus(); 
                return false;
            }
<%       }%>  
//            if (!validaCampo(document.formCot.TOMADOR_APE, "Por favor ingrese el Apellido, Nombre/Razon Social.")){
//                return false; 
//            }

            if (document.formCot.TOMADOR_COD_IVA.value == 6 || 
                document.formCot.TOMADOR_COD_IVA.value == 9) {
                alert ("Debe ingresar una condición de IVA válida");
                document.formCot.TOMADOR_COD_IVA.focus();
                return false; 
            }

           if ( document.formCot.COD_ACTIVIDAD.options[ document.formCot.COD_ACTIVIDAD.selectedIndex ].value == "-1" ) {
                alert ("Por favor seleccione una actividad válida ");
                document.formCot.COD_ACTIVIDAD.focus();
                return false; 
            }

            if (!validaCampo(document.formCot.CANT_PERSONAS,"Por favor ingrese la cantidad de personas.")){
                return false; 
            }

            if (document.formCot.COD_VIGENCIA.value == null ||
                document.formCot.COD_VIGENCIA.value == "0"){
                alert ("Por favor ingrese vigencia ! ");
                oFrameVigencias.document.getElementById ('COD_VIGENCIA').focus ();
                return false;
            }

            if (document.formCot.cuotas.value == "" || document.formCot.cuotas.value == "0"){
                alert ("Por favor ingrese cantidad de cuotas ! ");
                oFrameVigencias.document.getElementById ('cuotas').focus ();
                return false; 
            } 

            if (parseInt(document.formCot.cuotas.value) > parseInt (document.formCot.max_cuotas.value)) {
                alert ("La cantidad de cuotas supera el máximo para la vigencia: " +  document.formCot.max_cuotas.value );
                oFrameVigencias.document.getElementById ('cuotas').focus ();
                return false;
            }

//            if (!validaCampo(document.formCot.GASTOS_ADQUISICION,"Por favor ingrese el porcentaje de gastos de adquisicion.")){
//                return false;
//            }

            if ( parseInt(document.getElementById('GASTOS_ADQUISICION').value) >
                 parseInt(document.getElementById('MAX_GASTOS_ADQUISICION').value)) {
                 alert ("Los gastos de adquisición superan el máximo: " + document.getElementById('MAX_GASTOS_ADQUISICION').value );
                 oFrameGastos.document.getElementById ('GASTOS_ADQUISICION').value =
                 oFrameGastos.document.getElementById ('MAX_GASTOS_ADQUISICION').value;
                 oFrameGastos.document.getElementById ('GASTOS_ADQUISICION').focus();
                 return false;
            }

            if (!validaCampo(document.formCot.CAPITAL_MUERTE,"Por favor ingrese una suma para Muerte por accidente")){
                 oFrameCoberturas.document.getElementById ('CAPITAL_MUERTE').focus ();
                return false; 
            }
//Suma por invalidez no puede ser mayor al capital de muerte
            var capMuerte = parseFloat(document.formCot.CAPITAL_MUERTE.value);
            document.formCot.CAPITAL_INVALIDEZ.max = capMuerte;

            if (!validaCampo(document.formCot.CAPITAL_INVALIDEZ,"Por favor ingrese una suma para Invalidez permanente total y/o parcial")){
                 oFrameCoberturas.document.getElementById ('CAPITAL_INVALIDEZ').focus ();
                return false; 
            }
//          Asistencia medica no puede ser superior al 10% del capital de muerte y debe ser menor a 20000
//          capMuerte = parseFloat(document.formCot.CAPITAL_MUERTE.value)*0.1;
//          document.formCot.CAPITAL_ASISTENCIA.max = capMuerte>20000?20000:capMuerte;
            
 //           document.formCot.CAPITAL_ASISTENCIA.max = 20000;
            if (!validaCampo(document.formCot.CAPITAL_ASISTENCIA,"Por favor ingrese una suma ")){
                 oFrameCoberturas.document.getElementById ('CAPITAL_ASISTENCIA').focus();
                return false; 
            }
            if (!validaCampo(document.formCot.FRANQUICIA,"Por favor ingrese una suma ")){
                 oFrameCoberturas.document.getElementById ('FRANQUICIA').focus();
                return false; 
            }
            
            var asistencia = parseFloat(document.formCot.CAPITAL_ASISTENCIA.value);
            var franquicia = parseFloat(document.formCot.FRANQUICIA.value);
            if (franquicia > asistencia) {
                alert (" La franquicia debe ser menor a la Asistencia Médico Farmaceutica ");
                 oFrameCoberturas.document.getElementById ('FRANQUICIA').focus();
                return false;
            }

            var ambito       = parseFloat( document.formCot.COD_AMBITO.value );
            var ambitoOpcion = parseFloat( document.getElementById('cod_ambito_opcion').value );
            var opcion       = parseFloat( document.getElementById('cod_opcion').value );

            if ( opcion > 0 && ambito != ambitoOpcion) {
                alert (" El Ambito no es compatible con el Opcional seleccionado. ");
                 document.formCot.COD_AMBITO.focus();
                return false;
            }
            
            return true;
      }

    function validaCampo(obj,sMsg){
        //si el campo no esta vacio
        if ( obj.value != "" ){
           //si hay que validar rangos
           if ( typeof(obj.min) != "undefined" || typeof(obj.max) != "undefined" ){
              //le quito las posibles comas separadoras de mil
              obj.value = obj.value.replace(",","");
              obj.value = parseFloat(obj.value);
              if ( !isNaN(obj.value) ){
                  //si esta dentro de los rangos 
                  if (parseFloat(obj.min) <= obj.value  && obj.value<= parseFloat(obj.max) ){
                     return true; 
                  }else{
                     sMsg += " entre "+obj.min+" y "+obj.max;
                  }
              }  
           }else{
              return true;   
           }
        }else{
           //si se permite este campo vacio
           if (obj.notNull == "false"){
              obj.value=0;   
              return true;
           } 
        }
        alert ( sMsg );
   //     obj.focus(); 
        return false;
    } 

    function Ver ( numCotizacion, estadoCotizacion, tipo ) {
        window.location= "<%= Param.getAplicacion() %>cotizador/10/printCotizadorAp.jsp?opcion=getPrintCot&tipo=html&numCotizacion="+numCotizacion+"&estadoCotizacion="+estadoCotizacion;;
    }

    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

    function ChangeProd (prod) {


      var sUrlVigencias = "<%= Param.getAplicacion()%>cotizador/10/rs/formVigencia.jsp?cod_rama=10&cod_sub_rama=2" + 
        "&cod_prod=" + prod + "&COD_VIGENCIA=" +  document.formCot.COD_VIGENCIA.value +
        "&cuotas=" +  document.formCot.cuotas.value;

       if (oFrameVigencias ) {
            oFrameVigencias.location = sUrlVigencias;
       }      

      var sUrlGastos = "<%= Param.getAplicacion()%>cotizador/10/rs/formGastosAdquisicion.jsp?cod_rama=10&cod_sub_rama=2" + 
        "&cod_prod=" + prod + "&GASTOS_ADQUISICION=" +  document.formCot.GASTOS_ADQUISICION.value;

       if (oFrameGastos ) {
            oFrameGastos.location = sUrlGastos;
       }

      var sUrl2 = "<%= Param.getAplicacion()%>propuesta/rs/formOpcionesAjuste.jsp?cod_rama=10&cod_sub_rama=2&origen=PROD" + 
        "&cod_prod=" + prod +  "&cod_opcion=" +  document.formCot.cod_opcion.value;

       if (oFrameOpcionales ) {
            oFrameOpcionales.location = sUrl2;
       }

      var sUrl = "<%= Param.getAplicacion()%>cotizador/10/rs/formSumasCoberturas.jsp" +
         "?cod_rama=10&cod_sub_rama=2&cod_actividad=" + 
        document.formCot.COD_ACTIVIDAD.options[ document.formCot.COD_ACTIVIDAD.selectedIndex ].value + 
        "&cod_prod=" + prod + 
        "&muerte=" + oFrameCoberturas.document.getElementById ('CAPITAL_MUERTE').value + 
        "&invalidez=" + oFrameCoberturas.document.getElementById ('CAPITAL_INVALIDEZ').value + 
        "&asistencia=" + oFrameCoberturas.document.getElementById ('CAPITAL_ASISTENCIA').value + 
        "&franq=" + oFrameCoberturas.document.getElementById ('FRANQUICIA').value;
       
       if (oFrameCoberturas){
            oFrameCoberturas.location = sUrl;
       }
       
       return true;
    }

    function ChangeActividad (actividad) {

    document.getElementById ('desc_actividad').value = document.getElementById('COD_ACTIVIDAD').options [ document.getElementById ('COD_ACTIVIDAD').selectedIndex].text;
    var prod = '';

    if (document.getElementById ('tipo_usuario').value == "1" &&
        parseFloat (document.getElementById('cod_prod_usuario').value) < 80000) {
        prod = document.getElementById ('productor').value;
    } else {
        prod = document.formCot.COD_PROD.options[ document.formCot.COD_PROD.selectedIndex ].value;
    }

     var sUrl = "<%= Param.getAplicacion()%>cotizador/10/rs/formSumasCoberturas.jsp" +
         "?cod_rama=10&cod_sub_rama=2&cod_actividad=" + actividad +  
        "&cod_prod=" + prod + 
        "&muerte=" + oFrameCoberturas.document.getElementById ('CAPITAL_MUERTE').value + 
        "&invalidez=" + oFrameCoberturas.document.getElementById ('CAPITAL_INVALIDEZ').value + 
        "&asistencia=" + oFrameCoberturas.document.getElementById ('CAPITAL_ASISTENCIA').value + 
        "&franq=" + oFrameCoberturas.document.getElementById ('FRANQUICIA').value;
       
       if (oFrameCoberturas){
            oFrameCoberturas.location = sUrl;
       }
       
       return true;
    }

   function VerActividadSecundaria ( act ) {

        var sUrl = "<%= Param.getAplicacion()%>cotizador/10/PopUpActividad.jsp?cod_actividad_sec=" + act;
        var W = 550;
        var H = 260;

        AbrirPopUp (sUrl, W, H);
        return true;
    }

    function GrabarActividadSecundaria (param) {
        document.getElementById ('cod_actividad_sec').value  = param.cod_actividad_sec.value;
        document.getElementById ('desc_actividad_sec').value = param.desc_actividad.value;  
        return true;
    }

      function DoChangeOpciones () {
         if (oFrameOpcionales ) {
            document.getElementById('cod_opcion').value =  oFrameOpcionales.document.getElementById ('cod_opcion').value;
            document.getElementById('cod_ambito_opcion').value =  oFrameOpcionales.document.getElementById ('cod_ambito').value;
         }
       } 

      function DoChangeVigencia (maxCuotas) {
          document.getElementById('max_cuotas').value = maxCuotas;
         if (oFrameVigencias ) {
            document.getElementById('cuotas').value       =  oFrameVigencias.document.getElementById ('cuotas').value;
            document.getElementById('COD_VIGENCIA').value =  oFrameVigencias.document.getElementById ('COD_VIGENCIA').value;
         }
       }      
</script>
<body>
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
            <td align="center" width="100%" valign="top">
                <table border="0" width="100%" cellpadding="2" cellspacing="3">
               <% if (oCot.getnumCotizacion()== 0) {%>
                    <tr>
                        <td colspan="2" width='100%' height='30' align="center" class='titulo'  valign="middle">COTIZADOR DE ACCIDENTES PERSONALES</td>
                    </tr>
             <% }else{%>
                    <tr>
                        <td colspan="2" width='100%' height='30' align="center" class='titulo'  valign="middle">Cotización N°&nbsp;<%=oCot.getnumCotizacion()%></td>
                    </tr>
             <% } %>
                    <tr>
                        <td colspan="2" class="subtitulo" align="left" height="30" valign="middle">
            Estimado/a Productor/a:&nbsp;Si esta operaci&oacute;n se concreta v&iacute;a web su comisi&oacute;n se
            incrementa en dos puntos.
                        </td>
                    </tr>
                    <tr>
                        <td align="center" valign="top">
                            <form name="formCot" id="formCot" onsubmit='return Submitir()' method="POST" action="<%= Param.getAplicacion()%>servlet/CotizadorApServlet">
                                <input type="hidden" name="opcion" id="opcion" value="addCotizacion"/>
                                <input type="hidden" name="COD_RAMA" id="COD_RAMA" value="10"/>
                                <input type="hidden" name="COD_SUB_RAMA" id="COD_SUB_RAMA" value="2"/>
                                <input type="hidden" name="numCotizacion" id="numCotizacion" value="<%= oCot.getnumCotizacion () %>"/>
                                <input type="hidden" name="CAPITAL_MUERTE" id="CAPITAL_MUERTE" min="0" max="0" value="<%= oCot.getcapitalMuerte () %>"/>
                                <input type="hidden" name="CAPITAL_INVALIDEZ" id="CAPITAL_INVALIDEZ"  min="0" max="0" value="<%= oCot.getcapitalInvalidez () %>"/>
                                <input type="hidden" name="CAPITAL_ASISTENCIA" id="CAPITAL_ASISTENCIA"  min="0" max="0" value="<%= oCot.getcapitalAsistencia () %>"/>
                                <input type="hidden" name="FRANQUICIA" id="FRANQUICIA"  min="0" max="0" value="<%= oCot.getfranquicia () %>"/>
                                <input type="hidden" name="tipo_usuario" id="tipo_usuario" value="<%= usu.getiCodTipoUsuario() %>"/>
                                <input type="hidden" name="cod_prod_usuario" id="cod_prod_usuario" value="<%= usu.getiCodProd() %>"/>
                                <input type="hidden" name="cod_actividad_sec" id="cod_actividad_sec" value="<%= oCot.getcodActividadSec () %>"/>
                                <input type="hidden" name="GASTOS_ADQUISICION" id="GASTOS_ADQUISICION" value="<%= oCot.getgastosAdquisicion()%>" />
                                <input type="hidden" name="MAX_GASTOS_ADQUISICION" id="MAX_GASTOS_ADQUISICION" value="0" />
                                <input type="hidden" name="cod_opcion" id="cod_opcion" value="<%= (oCot==null || oCot.getcodOpcion () == 0 ) ? -1 : oCot.getcodOpcion() %>" />
                                <input type="hidden" name="cod_ambito_opcion" id="cod_ambito_opcion" value="<%= (oCot.getnumCotizacion () == 0 ? 0 : ( oCot.getcodOpcion() == 0 || oCot.getcodOpcion () == -1 ? 0 : oCot.getcodAmbito() ) ) %>" />
                                <input type="hidden" name="COD_VIGENCIA" id="COD_VIGENCIA" value="<%= oCot.getcodVigencia()%>" />
                                <input type="hidden" name="cuotas" id="cuotas" value="<%= oCot.getcantCuotas()%>" />
                                <input type="hidden" name="max_cuotas" id="max_cuotas" value="<%= 1 %>" />
                            <table width='685' border='0' align="center" cellpadding='3' cellspacing='3' class="fondoForm" style='margin-top:5;margin-bottom:5;padding: 1px 1px 1px 1px;'>
                                <col width="150"> <col width="535">
                                <tr class="text" >
                                    <td width="150"></td>
                                    <td width="535"></td>
                                </tr>
                                <tr align="center">
                                    <td colspan="2" class='TablasTit' height="30" valign="middle" >Datos de la Cotizaci&oacute;n</td>
                                </tr>
                                <tr>
                                    <td  class='text' align="left"> N&uacute;mero de cotizaci&oacute;n </td>
                                    <td  align="left"><input readonly type="text" STYLE="WIDTH:27%" value="<%= oCot.getnumCotizacion()==0?"sin asignar":oCot.getnumCotizacion() %>" class="inputTextNumeric"/></td>
                                </tr>
                                  <tr>
                                    <td  class='text' align="left"> Fecha Cotizaci&oacute;n </td>
                                    <td  align="left">
                                      <input readonly type="text" name="FECHA_COTIZ" STYLE="WIDTH:27%" value="<%= oCot.getfechaCotizacion()==null?Fecha.getFechaActual():Fecha.showFechaForm(oCot.getfechaCotizacion()) %>" class="inputTextNumeric">
                                    </td>
                                  </tr>
                                  <tr>
                                    <td  class='text' align="left"> Cotizado por </td>
                                    <td  align="left">
                                      <input class="inputText" readonly type="text" STYLE="WIDTH:97%" value="<%= ( oCot.getdescUsu() == "" ? usu.getsDesPersona() : oCot.getdescUsu() ) %>">
                                    </td>
                                  </tr>
                                  <tr>
                                    <td  class='text' align="left"> Productor </td>
                                    <td  align="left">
                        <%          if (usu.getiCodTipoUsuario() == 0 || usu.getiCodProd () >= 80000) {
                                        if ( oCot.getcodProd () == 0) { oCot.setcodProd (usu.getiCodProd()); }
                                       LinkedList lProd = (LinkedList) session.getAttribute("Productores");%>
                                       <select class='select' name="COD_PROD" id="COD_PROD" STYLE="WIDTH:97%" onchange="ChangeProd (this.options[this.selectedIndex].value);">
                                        <option value='-1'>Seleccione un productor</option>
                        <%             for (int i= 0; i < lProd.size (); i++) {
                                            Usuario oProd = (Usuario) lProd.get(i);
                                            if (oProd.getiCodProd() < 80000) {
                                                out.print("<option value='" + String.valueOf (oProd.getiCodProd()) + "'"+ (oProd.getiCodProd()==oCot.getcodProd()?"selected":"")  +">" + oProd.getsDesPersona() + " (" + oProd.getiCodProd() + ")</option>");
                                            }
                                       }
                        %>             </select>
                        <%          }else{
                                        oCot.setcodProd (usu.getiCodProd());
                            %>
                                      <input class="inputText" name="productor" id="productor" readonly type="text" STYLE="WIDTH:97%" value="<%= oCot.getcodProd ()  %>">
                        <%          }%>
                                    </td>
                                  </tr>
                                  <tr align="center">
                                    <td colspan="2" class='TablasTit'  height="30" valign="middle">Tomador</td>
                                  </tr>
                                  <tr>
                                    <td  class='text' align="left">Apellido, Nombre/Raz&oacute;n Social</td>
                                    <td align="left">
                                      <input  type="text" name="TOMADOR_APE" STYLE="WIDTH:97%" value="<%= oCot.gettomadorApe() %>"  class="inputText" maxlength='30'>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td class="text"  align="left" >Tel&eacute;fono </td>
                                    <td align="left">
                                      <input type="text" name="TOMADOR_TEL" STYLE="WIDTH:97%" value="<%= oCot.gettomadorTel() %>"  class="inputText" maxlength='30'>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td class="text"  align="left"> Condici&oacute;n de I.V.A</td>
                                    <td align="left">
                                      <select name="TOMADOR_COD_IVA" class="select" STYLE="WIDTH:97%">
                                        <%  lTabla = oTabla.getDatosOrderByDesc ("CONDICION_IVA");
                                                out.println(ohtml.armarSelectTAG(lTabla, String.valueOf(oCot.gettomadorCodIva())));
                                            %>
                                      </select>
                                    </td>
                                  </tr>
                                  <tr align="center">
                                    <td colspan="2" class='TablasTit' height="30" valign="middle">Plan de Seguro</td>
                                  </tr>
                                  <tr>
                                    <td class="text" colspan="2" align="left" >Seleccione una actividad (entre par&eacute;ntesis la categoria)&nbsp;:</td>
                                  </tr>
                                  <tr>
                                    <td class='text' colspan='2' align="left">
                                      <select name="COD_ACTIVIDAD"  id="COD_ACTIVIDAD" class="select" style="width:670px"
                                              onkeydown="ChangeActividad (this.options[this.selectedIndex].value);"
                                              onkeyup="ChangeActividad (this.options[this.selectedIndex].value);"
                                              onchange="ChangeActividad (this.options[this.selectedIndex].value);">
                                            <option value="-1" >Seleccione una actividad</option>
                        <%                  lTabla = oTabla.getActividades ("COTIZADOR");
                                            out.println(ohtml.armarSelectTAG(lTabla, oCot.getcodActividad ()));
                        %>
                                      </select>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td  colspan='2' align="left"><TEXTAREA  rows='3' cols='130' name='desc_actividad' id='desc_actividad'  class='text' readonly></TEXTAREA>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td  colspan='2' align="center"><a href='#' onclick='VerActividadSecundaria(<%= oCot.getcodActividadSec () %>);'>Haga click aqui para ingresar una actividad secundaria</a><BR>
                                    <b>Nota:</b>&nbsp;se cotiza por la mayor categoria entre ambas actividades.</td>
                                  </tr>
                                  <tr>
                                    <td  colspan='2' align="left"><TEXTAREA  rows='3' cols='130' name='desc_actividad_sec' id='desc_actividad_sec'  class='text' readonly><%= (oCot.getdescActividadSec () == null ? "" : oCot.getdescActividadSec ())%></TEXTAREA>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td class="text"  align="left" > Ubicación del Tomador: </td>
                                    <td align="left">
                                      <select name="COD_PROVINCIA" class="select" STYLE="WIDTH:50%">
                                        <%
                                                lTabla = oTabla.getDatosOrderByDesc ("PROVINCIA");
                                                out.println(ohtml.armarSelectTAG(lTabla, String.valueOf(oCot.getcodProvincia())));
                                            %>
                                      </select>
                                    </td>
                                  </tr>
                                <tr>
                                    <td colspan="2" class="text" height="100%" align="left">
                                        <iframe src="<%= Param.getAplicacion()%>cotizador/10/rs/formVigencia.jsp?cod_rama=10&cod_sub_rama=<%= (oCot.getcodSubRama() == 0 ? 2 :  oCot.getcodSubRama()) %>&COD_VIGENCIA=<%= oCot.getcodVigencia() %>&cod_prod=<%= (oCot.getcodProd() == 0 ? (usu.getiCodProd () == 0 ? -1 : usu.getiCodProd() ) : oCot.getcodProd())%>&cuotas=<%=oCot.getcantCuotas()%>"
                                        name="oFrameVigencias" id="oFrameVigencias" width="100%" style="height: 105px;" marginwidth="0" marginheight="0" align="top" frameborder="0">
                                        </iframe>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="text"  align="left" > Cobertura </td>
                                    <td align="left">
                                      <select name="COD_AMBITO" class="select" STYLE="WIDTH:50%">
                                        <%
                                               lTabla = oTabla.getDatosOrderByDesc ("COT_AMBITO");
                                               out.println(ohtml.armarSelectTAG(lTabla,  String.valueOf(oCot.getcodAmbito())));
                                             %>
                                      </select>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td class="text" align="left">Cantidad de personas </td>
                                    <td class="text" align="left">
                                        <input type="text" name="CANT_PERSONAS" value="<%= oCot.getcantPersonas()%>" min="1" max="250" size="25"
                                               maxlength="3" onKeyPress="return Mascara('D',event);" class="inputTextNumeric">
                                    </td>
                                  </tr>
                                  <tr>
                                    <td class="text" align="left"> Gastos adquisici&oacute;n </td>
                                    <td class="text" align="left">
                                        <iframe src="<%= Param.getAplicacion()%>cotizador/10/rs/formGastosAdquisicion.jsp?cod_rama=10&cod_sub_rama=<%= (oCot.getcodSubRama() == 0 ? 2 :  oCot.getcodSubRama()) %>&cod_prod=<%= (oCot.getcodProd() == 0 ? (usu.getiCodProd () == 0 ? -1 : usu.getiCodProd() ) : oCot.getcodProd())%>&GASTOS_ADQUISICION=<%= oCot.getgastosAdquisicion()%>"
                                        name="oFrameGastos" id="oFrameGastos" width="300"  height='25'  marginwidth="0" marginheight="0" align="top" frameborder="0"></iframe>
                                    </td>
                                  </tr>
                                  <tr align="center">
                                    <td colspan="2" class='TablasTit' height="30" valign="middle">Opcionales</td>
                                  </tr>
                                <TR>
                                    <td class="text" valign="middle"> Opcionales:&nbsp;</td>
                                    <td class="text"  width='284' valign="middle">
                                    <iframe  name="oFrameOpcionales" id="oFrameOpcionales" width="100%"  height='25' marginheight="0" marginwidth="0" marginheight="0" align="top"  frameborder="0"  scrolling="no"
                                   src="<%= Param.getAplicacion()%>propuesta/rs/formOpcionesAjuste.jsp?cod_rama=10&cod_sub_rama=2&origen=PROD&cod_opcion=<%= (oCot==null || oCot.getcodOpcion () == 0 ) ? -1 : oCot.getcodOpcion()%>&cod_prod=<%= (oCot == null || oCot.getcodProd() == 0 ? (usu.getiCodProd () == 0 ? 0 : usu.getiCodProd() ) : oCot.getcodProd()) %>">
                                    </iframe>
                                    </td>
                                </TR>
                                <tr>
                                    <td colspan="2" class="text" >
                                        <iframe src="<%= Param.getAplicacion()%>cotizador/10/rs/formSumasCoberturas.jsp?cod_rama=10&cod_sub_rama=<%= (oCot.getcodSubRama() == 0 ? 2 :  oCot.getcodSubRama()) %>&cod_actividad=<%= oCot.getcodActividad () %>&cod_prod=<%= (oCot.getcodProd() == 0 ? (usu.getiCodProd () == 0 ? -1 : usu.getiCodProd() ) : oCot.getcodProd())%>&muerte=<%=oCot.getcapitalMuerte()  %>&invalidez=<%= oCot.getcapitalInvalidez()%>&asistencia=<%= oCot.getcapitalAsistencia()%>&franq=<%= oCot.getfranquicia()%>"
                                        name="oFrameCoberturas" id="oFrameCoberturas" width="100%"
                                         height="140px" marginwidth="0" marginheight="0" align="top" frameborder="0"></iframe>
                                    </td>
                                  </tr>
                                  <tr class="textoazulbold12" align="center">
                                    <td colspan="2" align="center"  height="30" valign="middle">
                                      <input type="button" name="cmdSalir" value=" Salir " class="boton" onClick="Salir();">
                                      &nbsp;&nbsp;&nbsp;&nbsp;
                                      <% if (oCot.getnumCotizacion()!=0){%>
                         <%--             <input type="button" name="cmdVer" value=" Ver Cotizacion " height="20px" class="boton" onClick="Ver(<%=oCot.getnumCotizacion()%>,<%=oCot.getestadoCotizacion()%> ,'html');">
                                      &nbsp;&nbsp;&nbsp;&nbsp;
                          --%>              <% if ( usu.getusuario().compareTo(oCot.getuserId())== 0) {%>
                                         <input type="submit" name="cmdGrabar" value=" Recotizar " class="boton">
                                        <% }    %>
                                      <%}else{%>
                                         <input type="submit" name="cmdGrabar" value=" Cotizar " class="boton">
                                    <% }    %>
                                    </td>
                                  </tr>
                                </table>
                              </form>
                            </td>
                            <td align="center" valign="top" >
                                <table width="234" border="0" cellpadding='3' cellspacing='3'>
                                    <tr>
                                        <td width="234" valign="top" ><img src="<%=Param.getAplicacion()%>images/521562.JPG" width="234" height="183"></td>
                                    </tr>
                                    <tr>
                                        <td valign="top" class="titulosProductos">Accidentes <br>Personales </td>
                                    </tr>
                                </table>
                            </td>
                          </tr>
                        </table>
                    </td>
        </tr>
        <tr>
            <td width='100%'>
                <jsp:include flush="true" page="/bottom.jsp"/>
            </td>
        </tr>
</table>

<%--<a name='presupu'>
--%>
<div id="navtxt" 
     class="navtext"
     style="visibility:hidden; position:absolute; top:0px; left:-400px;z-index:10000; padding:10px">
</div>

<div id="divInfo" 
     name="div_info"
     class="navtext"
     style="visibility:hidden; position:absolute;top:0px; left:-400px;z-index:10000; padding:10px">
</div>

<script>
    document.getElementById ('desc_actividad').value = document.getElementById('COD_ACTIVIDAD').options [ document.getElementById ('COD_ACTIVIDAD').selectedIndex].text;
    CloseEspere(); 
</script>
</body>
</html>

