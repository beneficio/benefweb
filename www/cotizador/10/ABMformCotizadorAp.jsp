<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.*"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<% Usuario usu = (Usuario) session.getAttribute("user"); 
    HtmlBuilder ohtml       = new HtmlBuilder();
    Tablas oTabla = new Tablas ();
    LinkedList lTabla = new LinkedList ();
    CotizadorAp oCot = (CotizadorAp) request.getAttribute ("cotizador");
    if (oCot == null) {
        oCot = new CotizadorAp ();
        oCot.setgastosAdquisicion(20); 
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
<SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/alttxt.js"></SCRIPT>
<SCRIPT type="" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script language='javascript'>
      var lastError=null;
      function Submitir () {
       document.getElementById('CAPITAL_MUERTE').value =  oFrameCoberturas.document.getElementById ('CAPITAL_MUERTE').value; 
          document.getElementById('CAPITAL_INVALIDEZ').value = oFrameCoberturas.document.getElementById ('CAPITAL_INVALIDEZ').value; 
          document.getElementById('CAPITAL_ASISTENCIA').value = oFrameCoberturas.document.getElementById ('CAPITAL_ASISTENCIA').value; 
          document.getElementById('FRANQUICIA').value = oFrameCoberturas.document.getElementById ('FRANQUICIA').value;

          document.getElementById('CAPITAL_MUERTE').min =  oFrameCoberturas.document.getElementById ('CAPITAL_MUERTE').min; 
          document.getElementById('CAPITAL_INVALIDEZ').min = oFrameCoberturas.document.getElementById ('CAPITAL_INVALIDEZ').min; 
          document.getElementById('CAPITAL_ASISTENCIA').min = oFrameCoberturas.document.getElementById ('CAPITAL_ASISTENCIA').min; 
          document.getElementById('FRANQUICIA').min = oFrameCoberturas.document.getElementById ('FRANQUICIA').min;

          document.getElementById('CAPITAL_MUERTE').max =  oFrameCoberturas.document.getElementById ('CAPITAL_MUERTE').max; 
          document.getElementById('CAPITAL_INVALIDEZ').max = oFrameCoberturas.document.getElementById ('CAPITAL_INVALIDEZ').max; 
          document.getElementById('CAPITAL_ASISTENCIA').max = oFrameCoberturas.document.getElementById ('CAPITAL_ASISTENCIA').max; 
          document.getElementById('FRANQUICIA').max = oFrameCoberturas.document.getElementById ('FRANQUICIA').max;

           if ( document.formCot.COD_ACTIVIDAD.options[ document.formCot.COD_ACTIVIDAD.selectedIndex ].value == "-1" ) {
                alert ("Por favor seleccione una actividad válida ");
                document.formCot.COD_ACTIVIDAD.focus();
                return false; 
            }


            if (!validaCampo(document.formCot.CANT_PERSONAS,"Por favor ingrese la cantidad de personas.")){
                return false; 
            }

            if (!validaCampo(document.formCot.GASTOS_ADQUISICION,"Por favor ingrese el porcentaje de gastos de adquisicion.")){
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
           }     document.getElementById ('desc_actividad').value = document.getElementById('COD_ACTIVIDAD').options [ document.getElementById ('COD_ACTIVIDAD').selectedIndex].text;

        }
        alert ( sMsg );
  //      obj.focus(); 
        return false;
    } 

    function Ver ( numCotizacion, estadoCotizacion, tipo ) {
        window.location= "<%= Param.getAplicacion() %>cotizador/10/ABMprintCotizadorAp.jsp?opcion=getPrintCot&tipo=html&numCotizacion="+numCotizacion+"&estadoCotizacion="+estadoCotizacion;;
    }

    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

    function ModificarTablas() {
           window.location.replace("<%= Param.getAplicacion()%>abm/formAbmIndex.jsp");
    }
    function ChangeActividad (actividad) {

    document.getElementById ('desc_actividad').value = document.getElementById('COD_ACTIVIDAD').options [ document.getElementById ('COD_ACTIVIDAD').selectedIndex].text;
    var prod = '0';

//    if (document.getElementById ('tipo_usuario').value == "1") {
//        prod = document.getElementById ('productor').value;
//    } else {
//        prod = document.formCot.COD_PROD.options[ document.formCot.COD_PROD.selectedIndex ].value;
 //   }

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
 <% if (oCot.getnumCotizacion()== 0) {%>
  <tr> 
    <td colspan="2" width='100%' height='30' align="center" class='titulo'>COTIZADOR DE ACCIDENTES PERSONALES (PRUEBAS)</td>
  </tr>
 <% }else{%>
  <tr> 
    <td colspan="2" width='100%' height='30' align="center" class='titulo'>Cotización N°&nbsp;<%=oCot.getnumCotizacion()%></td>
  </tr>
 <% } %>
  <tr> 
    <td align="center" valign="top"> 
      <form name="formCot" id="formCot" onsubmit='return Submitir()' method="POST" action="<%= Param.getAplicacion()%>servlet/CotizadorApServlet">
        <input type="hidden" name="opcion" id="opcion" value="ABMaddCotizacion">
        <input type="hidden" name="COD_RAMA" id="COD_RAMA" value="10">
        <input type="hidden" name="COD_SUB_RAMA" id="COD_SUB_RAMA" value="2">
        <input type="hidden" name="numCotizacion" id="numCotizacion" value="<%= oCot.getnumCotizacion() %>">
        <input type="hidden" name="CAPITAL_MUERTE" id="CAPITAL_MUERTE" min="0" max="0" value="<%= oCot.getcapitalMuerte () %>">
        <input type="hidden" name="CAPITAL_INVALIDEZ" id="CAPITAL_INVALIDEZ"  min="0" max="0" value="<%= oCot.getcapitalInvalidez () %>">
        <input type="hidden" name="CAPITAL_ASISTENCIA" id="CAPITAL_ASISTENCIA"  min="0" max="0" value="<%= oCot.getcapitalAsistencia () %>">
        <input type="hidden" name="FRANQUICIA" id="FRANQUICIA"  min="0" max="0" value="<%= oCot.getfranquicia () %>">
        <input type="hidden" name="tipo_usuario" id="tipo_usuario" value="<%= usu.getiCodTipoUsuario() %>">
        <input type="hidden" name="cod_actividad_sec" id="cod_actividad_sec" value="<%= oCot.getcodActividadSec () %>">
        <input type="hidden" name="cod_opcion" id="cod_opcion" value="<%= (oCot==null || oCot.getcodOpcion () == 0 ) ? -1 : oCot.getcodOpcion() %>" >
        <table width='435' border='0' align="center" cellpadding='0' cellspacing='1' class="fondoForm" style='margin-top:5;margin-bottom:5;padding: 1px 1px 1px 1px;'>
          <col width="112"> <col width="73"> <col width="250"> 
          <tr class="text" > 
            <td width="112"></td>
            <td width="73"></td>
            <td ></td>
          </tr>
          <tr align="center"> 
            <td colspan="3" class='TablasTit'>Plan de Seguro</td>
          </tr>
          <tr> 
            <td class="text" colspan="3" >Seleccione una actividad (entre par&eacute;ntesis la categoria)&nbsp;:</td>
          </tr>
          <tr>
            <td class='text' colspan='3'>
              <select name="COD_ACTIVIDAD" id="COD_ACTIVIDAD" class="select" style="width:500" onkeydown="ChangeActividad (this.options[this.selectedIndex].value);" onkeyup="ChangeActividad (this.options[this.selectedIndex].value);" onchange="ChangeActividad (this.options[this.selectedIndex].value);">
<%                  lTabla = oTabla.getActividades ();
                    out.println(ohtml.armarSelectTAG(lTabla, oCot.getcodActividad ())); 
%>
              </select>
            </td>
          </tr>
          <tr>
            <td  colspan='3' align="center"><TEXTAREA  rows='3' cols='90' name='desc_actividad' id='desc_actividad'  class='text' readonly></TEXTAREA>
            </td>
          </tr>
          <tr>
            <td  colspan='3' align="center"><a href='#' onclick='VerActividadSecundaria(<%= oCot.getcodActividadSec () %>);'>Haga click aqui para ingresar una actividad secundaria</a><BR>
            <b>Nota:</b>&nbsp;se cotiza por la mayor categoria entre ambas actividades.</td>
          </tr>
          <tr>
            <td  colspan='3' align="center"><TEXTAREA  rows='3' cols='90' name='desc_actividad_sec' id='desc_actividad_sec'  class='text' readonly><%= (oCot.getdescActividadSec () == null ? "" : oCot.getdescActividadSec ())%></TEXTAREA>
            </td>
          </tr>
          <tr> 
            <td class="text" colspan="2" > Ubicaci&oacute;n Riesgo </td>
            <td> 
              <select name="COD_PROVINCIA" class="select" STYLE="WIDTH:50%">
                <%  
                        lTabla = oTabla.getDatosOrderByDesc ("PROVINCIA");
                        out.println(ohtml.armarSelectTAG(lTabla, String.valueOf(oCot.getcodProvincia()))); 
                    %>
              </select>
            </td>
          </tr>
          <tr> 
            <td class="text" colspan="2" > Vigencia (menores a un mes: mensual)</td>
            <td> 
              <select name="COD_VIGENCIA" class="select" STYLE="WIDTH:50%">
                <%  
                      lTabla = oTabla.getDatosOrderByDesc ("VIGENCIA");
                      out.println(ohtml.armarSelectTAG(lTabla,  String.valueOf(oCot.getcodVigencia()))); 
                     %>
              </select>
            </td>
          </tr>
          <tr> 
            <td class="text" colspan="2" > Cobertura </td>
            <td> 
              <select name="COD_AMBITO" class="select" STYLE="WIDTH:50%">
                <%  
                       lTabla = oTabla.getDatosOrderByDesc ("COT_AMBITO");
                       out.println(ohtml.armarSelectTAG(lTabla,  String.valueOf(oCot.getcodAmbito()))); 
                     %>
              </select>
            </td>
          </tr>
          <tr> 
            <td class="text" colspan="2" >Cantidad de personas </td>
            <td> 
              <input STYLE="WIDTH:50%" type="text" name="CANT_PERSONAS" value="<%= oCot.getcantPersonas()%>" min="1" max="250" onKeyPress="return Mascara('D',event);" class="inputTextNumeric">
            </td>
          </tr>
          <tr> 
            <td class="text" colspan="2" > Gastos adquisici&oacute;n </td>
            <td class="text"> 
              <input STYLE="WIDTH:50%" type="text" name="GASTOS_ADQUISICION" value="<%= oCot.getgastosAdquisicion()%>"  min="0" max="30" onKeyPress="return Mascara('P',event);" class="inputTextNumeric">%
            </td>
          </tr>
          <tr align="center"> 
            <td colspan="3" class='TablasTit'>Opcionales</td>
          </tr>
        <TR>
            <td class="text" valign="middle"> Opcionales:&nbsp;</td>
            <td class="text" valign="middle" colspan='2'> 
            <iframe  name="oFrameOpcionales" id="oFrameOpcionales" width="100%"  height='25' marginheight="0" marginwidth="0" marginheight="0" align="top"  frameborder="0"  scrolling="no"                                                                                                                         
           src="<%= Param.getAplicacion()%>propuesta/rs/formOpcionesAjuste.jsp?cod_rama=10&cod_sub_rama=2&origen=TEST&cod_opcion=<%= (oCot==null || oCot.getcodOpcion () == 0 ) ? -1 : oCot.getcodOpcion()%>&cod_prod=0">
            </IFRAME> 
            </td> 
        </TR>          
          <tr> 
            <td colspan="3" class="text" >		    	
                <iframe src="<%= Param.getAplicacion()%>cotizador/10/rs/formSumasCoberturas.jsp?cod_rama=10&cod_sub_rama=<%= (oCot.getcodSubRama() == 0 ? 2 :  oCot.getcodSubRama()) %>&cod_actividad=<%= oCot.getcodActividad () %>&cod_prod=0&muerte=<%=oCot.getcapitalMuerte()  %>&invalidez=<%= oCot.getcapitalInvalidez()%>&asistencia=<%= oCot.getcapitalAsistencia()%>&franq=<%= oCot.getfranquicia()%>" 
                name="oFrameCoberturas" id="oFrameCoberturas" width="100%" 
                 height="120px" marginwidth="0" marginheight="0" align="top" frameborder="0"></iframe>
            </td>
          </tr>
          <tr class="textoazulbold12" align="center"> 
            <td colspan="3" > 
              <input type="button" name="cmdSalir" value=" Salir " height="20px" class="boton" onClick="Salir();">
              &nbsp;&nbsp;&nbsp;&nbsp; 
              <% if (oCot.getnumCotizacion()!=0){%>
              <input type="button" name="cmdVer" value=" Ver Cotizacion " height="20px" class="boton" onClick="Ver(<%=oCot.getnumCotizacion()%>,<%=oCot.getestadoCotizacion()%> ,'html');">
              &nbsp;&nbsp;&nbsp;&nbsp; 
                <% if ( usu.getusuario().compareTo(oCot.getuserId())== 0) {%>
                 <input type="submit" name="cmdGrabar" value=" Recotizar " height="20px" class="boton">
                <% }    %>
              <%}else{%>  
                 <input type="submit" name="cmdGrabar" value=" Cotizar " height="20px" class="boton">
            <% }    %>
              &nbsp;&nbsp;&nbsp;&nbsp; 
              <input type="button" name="cmdVer" value=" Modificar Tablas " height="20px" class="boton" onClick="ModificarTablas();">
            </td>
          </tr>
        </table>
      </form>
    </td>
    <td align="center" valign="top" >
<!--
    <img src="<%--=Param.getAplicacion()--%>images/521562.JPG">
<br>
<br>
    <div class="titulos">Accidentes <br>Personales </div>
-->
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
  <tr> 
    <td width='100%' colspan="2"> 
      <jsp:include flush="true" page="/bottom.jsp"/>
    </td>
  </tr>
</table>
<a name='presupu'>
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

