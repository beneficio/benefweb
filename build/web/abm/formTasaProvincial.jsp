<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.*"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<% Usuario usu = (Usuario) session.getAttribute("user"); 
   String sMensaje  = (String) request.getAttribute ("mensaje");

    if (usu.getiCodTipoUsuario() != 0) {
        request.setAttribute("javax.servlet.jsp.jspException", new SurException ("acceso denegado"));
        getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
        
    }

   java.util.Date fecha      = new Date ();
   HtmlBuilder ohtml       = new HtmlBuilder();
    LinkedList lTasaProvincial = (LinkedList) request.getAttribute("tasas"); 


%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
</head>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/fechas.js"></script>
<script type="text/javascript" language='javascript'>
    var sAuxValorAnterior="";
    var bHuboCambios = false;
    
    function InputDoFocus(oInput){
        //guardo el valor que tiene el input para detectar posibles cambios
        sAuxValorAnterior = oInput.value;
    }    
    function InputDoBlur(oInput){
        //verifico si cambio el valor
        bHuboCambios = sAuxValorAnterior != oInput.value;
    }

    function Validar(){
       //Valido que la fecha de validez sea mayor o igual al dia de hoy 
       var oFechaDesde = document.getElementById("fecha_desde");
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
        bHuboCambios = false;//pongo el flag en false ya que voy a grabar
       
       return true;
    }

    function PasarAProduccion () {
        if (confirm("Estos valores entraran en vigencia a partir del dia "+ document.getElementById("fecha_desde").value +".\n¿Esta usted seguro que desea pasar a produccion estos valores?")) {
            bHuboCambios = false;//pongo el flag en false ya que voy a grabar
            document.form1.opcion.value = "addProd";
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
              Grabar ();
           }
           return false;
        }
    }
    window.onload=function(){
<% if ( sMensaje != null){%>
      alert(" <%=sMensaje%> ");
<% }%>
    }

    function Grabar () {
        document.form1.submit();
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
           <form name="form1" id="form1" method="POST" action="<%= Param.getAplicacion()%>servlet/TasaProvincialServlet" onsubmit='return Validar();'>
            <input type="hidden" name="opcion" id="opcion" value="addTasaProvincial"/>
            <input type="hidden" name="cant_tasas" id="cant_tasas" value="<%=lTasaProvincial.size()%>"/>
            <table width='100%' cellpadding='0' cellspacing='0' border='0' align="center" class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                <tr>
                    <td width='100%' height='30' align="center" class='titulo'>TASAS PROVINCIALES</td>
                </tr>
                <tr>
                    <td width='100%' height='30' align="left" class='subtitulo'>Base de calculo: 'A','S': Prima de tarifa - 'O': Premio - 'C': Suma Asegurada</td>
                </tr>
                <tr>
                <td align="center">
                <table cellpadding='0' cellspacing='0' border='0'> 
                    <th align="left" width='150'>Provincia</th>
                    <th align="left" width='300'>Rama/Subrama/Producto</th>
                    <th align="left" width='120' >Tasa</th>
                    <th align="left" width='60'>Base<br/>Calculo</th>
                    <th width='120'>Minimo</th>
                    <th width='120'>Cat. Persona</th>
                    <th width='120'>Base m&iacute;nima</th>
<%              if (lTasaProvincial.size() == 0){%>
                    <tr>
                        <td colspan="6">No existen tasas provinciales a listar</td>
                    </tr>
<%              }  
                String sProvAnterior = "";
                for (int i=0; i < lTasaProvincial.size (); i++) {
                     TasaProvincial oTasa = (TasaProvincial) lTasaProvincial.get (i);
                     if ( ! sProvAnterior.equals(oTasa.getdescProvincia())) {
                        sProvAnterior = oTasa.getdescProvincia();
%>
                    <tr><td colspan="6"><hr/></td></tr>
<%                  }
    %>
                    <tr>
                        <input type="hidden" name="PROVINCIA<%= i%>" id="PROVINCIA<%= i%>" value="<%= oTasa.getcodProvincia() %>"/>
                        <input type="hidden" name="RAMA<%= i%>" id="RAMA<%= i%>" value="<%= oTasa.getcodRama() %>"/>
                        <input type="hidden" name="SUB_RAMA<%= i%>" id="SUB_RAMA<%= i%>" value="<%= oTasa.getcodSubRama() %>"/>
                        <input type="hidden" name="PRODUCTO<%= i%>" id="PRODUCTO<%= i%>" value="<%= oTasa.getcodProducto() %>"/>
                        <td class='text' align="left"> <%= oTasa.getdescProvincia() %></td>
                        <td class='text' align="left"> <%= oTasa.getdescProducto() %></td>
                        <td class='text'>
                        <input maxlength="7" class="inputTextNumeric" onkeypress="return Mascara('N',event);" onfocus="InputDoFocus(this)" onblur="InputDoBlur(this)"
                               type="text" size="7" name="TASA<%=i %>" id="TASA<%=i %>"
                               value="<%= Dbl.DbltoStr(oTasa.gettasa(), 4) %>"/>
                        </td>
                        <td class='text'>
                            <input maxlength='1' type="text" size="2" name="BASE<%=i %>" id="BASE<%=i %>"
                                   value="<%= oTasa.getbaseCalculo() %>"/>
                        </td>
                        <td class='text'>
                        <input maxlength="7" class="inputTextNumeric" onkeypress="return Mascara('N',event);" onfocus="InputDoFocus(this)" onblur="InputDoBlur(this)"
                               type="text" size="7" name="MINIMO<%=i %>" id="MINIMO<%=i %>"
                               value="<%= Dbl.DbltoStr(oTasa.getimpMinimo(), 2) %>"/>
                        </td>
                        <td class='text'>
                        <select  name="categoria_persona<%=i %>" id="categoria_persona<%=i %>">
                            <option value="ALL" <%= (oTasa.getcategoriaPersona() == null ? "selected" : "") %> >Todos </option>
                            <option value="J"   <%= (oTasa.getcategoriaPersona() != null && oTasa.getcategoriaPersona().equals ("J") ? "selected" : "") %> >Jurídica</option>
                            <option value="F"   <%= (oTasa.getcategoriaPersona() != null && oTasa.getcategoriaPersona().equals ("F") ? "selected" : "") %>>Física</option>
                        </select>
                        </td>
                        <td class='text'>
                        <input maxlength="7" class="inputTextNumeric" onkeypress="return Mascara('N',event);" onfocus="InputDoFocus(this)" onblur="InputDoBlur(this)"
                               type="text" size="7" name="BASE_MINIMO<%=i %>" id="BASE_MINIMO<%=i %>"
                               value="<%= Dbl.DbltoStr(oTasa.getbaseCalculoMin(), 2) %>"/>
                        </td>
                        
                  </tr>
<%              }%> 
            </table>
            </td>
            </tr>
            </table>   
            </form>
        </td>
    </tr>
    <tr>
        <td align="center" colspan="2">
            <input type="button" name="cmdSalir"  value=" Salir " height="20px" class="boton" onClick="Salir();"/>&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="button" name="cmdVolver" value=" Volver " height="20px" class="boton" onClick="Volver();"/>&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="submit" name="cmdGrabar" value=" Grabar " height="20px" class="boton" onclick="Grabar();"/>
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
