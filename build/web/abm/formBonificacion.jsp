<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.*"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<% Usuario usu = (Usuario) session.getAttribute("user"); 
   String sMensaje  = (String) request.getAttribute ("mensaje");

    if (usu.getiCodTipoUsuario() != 0) {
        request.setAttribute("javax.servlet.jsp.jspException", new SurException ("acceso denegado"));
        getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
        
    }
   
    java.util.Date fecha    = new Date ();
    HtmlBuilder ohtml       = new HtmlBuilder();
    LinkedList lLista = (LinkedList) request.getAttribute("bonificaciones"); 
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
</head>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
<style>
.error{color:red;font-size:9px;font-family:verdana;}
</style>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/fechas.js"></script>
<script language='javascript'>
    var sAuxValorAnterior="";
    var bHuboCambios = false;
    function InputDoFocus(oInput){
        //guardo el valor que tiene el input para detectar posibles cambios
        sAuxValorAnterior = oInput.value;
    }    
    function InputDoBlur(oInput){
        //verifico si cambio el valor
        bHuboCambios = sAuxValorAnterior != oInput.value;
        //Valido on the fly que el campo no este vacio
        oErrMsg = document.getElementById("tdError");
        if ( oInput.value == "" ){
            oErrMsg.innerHTML="Por favor ingrese un valor para el campo anterior.";
        }else{
            oErrMsg.innerHTML="&nbsp;";
        }
    }

    function CantPersonasHastaDoBlur(nTramo){
      var c = parseInt(document.form1.cant_bonificacion.value);
      var oHasta = document.getElementById("CANT_PERSONAS_HASTA_" + nTramo);
      var oDesde = document.getElementById("CANT_PERSONAS_DESDE_" + nTramo);

      if (oHasta.value != "" && !isNaN(oHasta.value)){
          //Valido on the fly que el "valor hasta" no sea menor al "valor desde"
          oErrMsg = document.getElementById("tdError");
          if ( parseInt(oHasta.value) <= parseInt(oDesde.value) ){
             oErrMsg.innerHTML="Atencion: El \"valor hasta\" tiene que ser mayor al \"valor desde\".";
             return false;
          }else{
             oErrMsg.innerHTML="&nbsp;";
          }

          //si NO es el ultimo tramo 
          if (parseInt(nTramo)+1 < c) {
              //copio el valor hasta de este tramo al valor desde del proximo
              nTramo++; //paso al siguiente tramo
              oDesde = document.getElementById("CANT_PERSONAS_DESDE_" + nTramo);
              oDesde.value = parseInt(oHasta.value)+1;
          }
      }
      
    }


    function Validar(){
      var i;
      var c = parseInt(document.form1.cant_bonificacion.value);
      var antHasta=0;
      for (i=0;i<c;i++){
           var oHasta = document.getElementById("CANT_PERSONAS_HASTA_" + i);
           var oDesde = document.getElementById("CANT_PERSONAS_DESDE_" + i);
           var oBonificacion  = document.getElementById("BONIFICACION_" + i);

           if ( oDesde.value == oHasta.value){
                alert("Los valores desde y hasta no pueden ser iguales.");  
                 oHasta.focus();
                 return false;  
            }  
            if ( oHasta.value == "" || isNaN(oHasta.value) ){
               alert("Por favor ingrese un valor numerico en este campo");
               oHasta.focus();
               return false; 
            }  
            if ( parseInt(oDesde.value) > parseInt(oHasta.value) ){
                alert("El valor hasta debe ser mayor al valor desde.");  
                oHasta.focus();
                return false;  
            }
            if ( parseInt(antHasta) >= parseInt(oHasta.value) ){
                alert("El valor hasta de este rango debe ser mayor al valor hasta del anterior.");  
                oHasta.focus();
                return false;  
            }
            if ( oBonificacion.value == "" || isNaN(oBonificacion.value) ){
               alert("Por favor ingrese un valor numerico en este campo");
               oBonificacion.focus();
               return false; 
            }

            antHasta = oHasta.value;
       }

       //Valido que la fecha de validez sea mayor o igual al dia de hoy 
       var oFechaDesde = document.getElementById("FECHA_DESDE");
       var d = new Date();
       var hoy =  d.getDate()+ "/" + (d.getMonth()+1) + "/" + d.getFullYear();
       if (oFechaDesde.value.length == 0){
           alert("Por favor ingrese la fecha desde cuando tendran validez los tramos.");  
           oFechaDesde.focus();
           return false;  
       }
       var aAux = oFechaDesde.value.split("/");
       var dia  = aAux[0] * 1;
       var mes  = aAux[1] * 1;
       var anio = aAux[2] * 1;
       if ( dateDiff("d",new Date(anio,mes-1,dia),new Date() ) > 0 ){
           alert("Por favor ingrese una fecha mayor o igual al dia de hoy.");  
           oFechaDesde.focus();
           return false;  
       }

       bHuboCambios = false; //pongo la bandera en false para grabar
       return true;
    }
      
    function PasarAProduccion () {
        if (confirm("Estos valores entraran en vigencia a partir del dia "+ document.getElementById("FECHA_DESDE").value +".\n¿Esta usted seguro que desea pasar a produccion estos valores?")) {
            bHuboCambios = false; //pongo la bandera en false para grabar
            document.form1.opcion.value = "addProdBonificacion";
            if (Validar()){
               document.form1.submit();
            }
            return true;
        } else {
            return false;
        }
    }

    function Volver () {
           window.location.replace("<%= Param.getAplicacion()%>abm/formAbmIndex.jsp");
    }
    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

    window.onunload= function(){
        if ( bHuboCambios ){
           if ( window.confirm("ATENCION se detectaron cambios.\n¿Desea guardar los cambios?.") ){
              document.form1.submit();
           }
           return false;
        }
    }

    window.onload=function(){
<% if ( sMensaje != null){%>
      alert(" <%=sMensaje%> ");
<% }%>
    }

function AddElement(obj){
   //obtengo la cantidad de rangos
   var nCant = parseInt(document.form1.cant_bonificacion.value);
   
  //Creo los elementos usados dentro de la tabla
   var eTr  = document.createElement('tr');
   var eTd1 = document.createElement('td');
   var eTd2 = document.createElement ('td');
   var eTd3 = document.createElement('td');

   eTd1.className = eTd2.className = eTd2.className = "text";

   eTd3.width="80%";
   eTd3.align="right";

   //Creo los elementos INPUT 
   var eInput1 = document.createElement('input');
   var eInput2 = document.createElement('input');
   var eInput3 = document.createElement('input');

   //Asigno las propiedades de los elementos INPUT
   eInput1.className = eInput2.className = eInput3.className = "inputTextNumeric";
   eInput1.type  = eInput2.type  = eInput3.type  = "text";
   eInput1.value = eInput2.value = eInput3.value = "0";
   eInput1.size = eInput2.size = "4";
   eInput3.size = "3";
   eInput2.maxlength = "5";
   eInput3.maxlength = "6";

   eInput2.onfocus = eInput3.onfocus = function(){InputDoFocus(this)};
   eInput3.onblur  = function(){InputDoBlur(this)};
   eInput2.onblur  = function(){InputDoBlur(this);CantPersonasHastaDoBlur(nCant);}

   eInput1.style.color="gray";
   eInput1.tabindex="999";   
   eInput1.readOnly=true;

   eInput1.name = eInput1.id = "CANT_PERSONAS_DESDE_"+nCant;
   eInput2.name = eInput2.id = "CANT_PERSONAS_HASTA_"+nCant;
   eInput3.name = eInput3.id = "BONIFICACION_"+nCant;
   
   eTd1.appendChild(eInput1);
   eTd2.appendChild(eInput2);
   eTd3.appendChild(eInput3);
   
   eTr.appendChild(eTd1);
   eTr.appendChild(eTd2);
   eTr.appendChild(eTd3);
   
   obj.appendChild(eTr);

   //Incremento en uno la cantidad de rangos guardado en cant_bonificacion
   document.form1.cant_bonificacion.value = parseInt(nCant)+1;
  
   //pongo el "valor desde" del nuevo tramo basandome en el "valor hasta" del anterior
   CantPersonasHastaDoBlur(parseInt(nCant)-1);
}

function RemoveElement(obj){
   var nCant = parseInt(document.form1.cant_bonificacion.value)-1;
alert(nCant);
    var children = obj.childNodes;
   for (var i = 0; i < children.length; i++) 
   {
   alert(children[i].tagName);
   };

   if (nCant > 0){
      obj.removeChild(obj.lastChild);     
      document.form1.cant_bonificacion.value = nCant;
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
        <td align="center" valign="top" width='100%'>
           <form name="form1" id="form1" method="POST" action="<%= Param.getAplicacion()%>servlet/BonificacionServlet" onsubmit='return Validar()'>
            <input type="hidden" name="opcion" id="opcion" value="addBonificacion">
            <input type="hidden" name="cant_bonificacion" id="cant_bonificacion" value="<%=lLista.size()%>">
            <table width='400' cellpadding='0' cellspacing='0' border='0' align="center" class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                <tr>
                    <td colspan="2" width='100%' height='30' align="center" class='titulo'>BONIFICACIONES</td>
                </tr>
                <tr>
                <td align="center" class='subtitulo'>
                <div style="width:90%;text-align:left;" >
                Ingrese los valores de bonificación para cada rango.<br>
                Los valores se pueden cambiar y volver a modificar tantas veces como lo desee oprimiendo el bot&oacute;n "Grabar".<br>  
                <br>IMPORTANTE: Si oprime el bot&oacute;n "Pasar a Producci&oacute;n" la modificaci&oacute;n tendr&aacute; validez 
                sobre el cotizador a partir de la fecha ingresada (debe ser mayor o igual a la actual).
                <br>Los botones "Quitar rango" y "Agregar rango" borran y agregan respectivamente del rango mayor al menor.
                </div> 
                </TD>
                </TR> 
                <tr>
                <td align='center'>
                     <input type="button" class='boton' value="(-) Quitar rango"  onclick="RemoveElement(document.getElementById('tbl'))">
                     <input type="button" class='boton' value="(+) Agregar rango" onclick="AddElement(document.getElementById('tbl'))">
                </td>
                </tr>    

                <tr>
                <td align="center">
                <table width='180' cellpadding='0' cellspacing='0' border='0'> 
                    <th align="center" colspan="2">
                    Rangos
                    </th>  
                    <th align="right">
                    Bonificacion
                    </th>  
                    <tr>
                        <td class='text' align='center'>Desde</td>
                        <td class='text' align='center'>Hasta</td>
                        <td class='text' width='50'>&nbsp;</td>
                    </tr>
                    <tr> 
                    <td colspan='3'>
                    <table border='0' width='100%'> 
                    <TBODY name="tbl" id="tbl"> 
<%              if (lLista.size() == 0){%>
                    <tr>
                        <td colspan="2">No existen bonificacioens a listar</td>
                    </tr>
<%              }  
                for (int i=0; i < lLista.size (); i++) {
                     Bonificacion oBonificacion = (Bonificacion) lLista.get (i);
                     fecha = oBonificacion.getfechaDesde();
%>                       
                  <tr>
                    <td class='text'>
                    <input class="inputTextNumeric" type="text" size="4" name="CANT_PERSONAS_DESDE_<%=i%>" id="CANT_PERSONAS_DESDE_<%=i%>" value="<%= oBonificacion.getcantPersonasDesde() %>" onkeypress="return Mascara('N',event);" class="inputTextNumeric"  onfocus='InputDoFocus(this)' onblur='InputDoBlur(this);' <%if (i>0){%> readonly style='color:gray' tabindex='999'<%}%>>
                    </td> 
                    <td class='text'>
                    <input class="inputTextNumeric" type="text" size="4" maxlength = "5" name="CANT_PERSONAS_HASTA_<%=i%>" id="CANT_PERSONAS_HASTA_<%=i%>" value="<%= oBonificacion.getcantPersonasHasta() %>" onkeypress="return Mascara('N',event);" class="inputTextNumeric"  onfocus='InputDoFocus(this)' onblur='InputDoBlur(this);CantPersonasHastaDoBlur(<%=i%>)'>
                    </td>
                    <td class='text' align='right' width='80%'>
                    <input class="inputTextNumeric" type="text" size="3" maxlength = "6" name="BONIFICACION_<%=i%>" id="BONIFICACION_<%=i%>" value="<%= oBonificacion.getbonificacion() %>" onkeypress="return Mascara('N',event);" class="inputTextNumeric"  onfocus='InputDoFocus(this)' onblur='InputDoBlur(this);' >
                    </td>
                  </tr>
<%              }%> 
                  </tbody>
                </table>
                </td>
                </tr>
                <tr>
                    <td class="text" align="right" colspan="3">
                    <br>   
                    Fecha Desde
                    <input class="inputText" type="text" name="FECHA_DESDE" id="FECHA_DESDE" size='10' maxlength='10'  onfocus='InputDoFocus(this)' onblur='InputDoBlur(this);validaFecha(this);' onkeypress="return Mascara('F',event);" value="<%= Fecha.showFechaForm(fecha) %>">
                    <br>   
                    <br>   
                    </td>
                </tr>
            </table>
            <table>
                <tr>
                    <td class="error" align="right" colspan="3" id="tdError" name="tdError">&nbsp;
                    </td>
                </tr>    
                <tr>
                    <td align="center" colspan="3">  
                        <br>  
                        <input type="button" name="cmdSalir" value=" Salir " height="20px" class="boton" onClick="Salir();">&nbsp;
                        <input type="button" name="cmdVolver" value=" Volver " height="20px" class="boton" onClick="Volver();">&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="submit" name="cmdGrabar" value=" Grabar " height="20px" class="boton"><br><br>
                        <input type="button" name="cmdProd"  value=" Pasar a Produccion " height="20px" class="boton" onclick="PasarAProduccion()">
                    </td>
                </tr>
            </table>
            </td>
            </tr>
            </table>   
            </form>
        </td>
    </tr>
    <tr>
        <td width='100%'>
            <jsp:include flush="true" page="/bottom.jsp"/>
        </td>
    </tr>
</table>
<script>
CloseEspere();
</script>
</body>
</html>
