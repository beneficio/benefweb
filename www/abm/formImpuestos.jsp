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

    HtmlBuilder ohtml       = new HtmlBuilder();
    LinkedList lLista = (LinkedList) request.getAttribute("impuestos"); 

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
</head>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
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
    }

    function Validar () {
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
     
       bHuboCambios = false;//pongo el flag en false ya que voy a grabar

       return true;
    }
    
    function PasarAProduccion () {
        if (confirm("Estos valores entraran en vigencia a partir del dia "+ document.getElementById("FECHA_DESDE").value +".\n¿Esta usted seguro que desea pasar a produccion estos valores?")) {
            bHuboCambios = false; //pongo la bandera en false para grabar
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
           <form name="form1" id="form1" method="POST" action="<%= Param.getAplicacion()%>servlet/ImpuestosServlet" onsubmit='return Validar();'>
            <input type="hidden" name="opcion" id="opcion" value="addImpuestos"/>
            <input type="hidden" name="cant_impuestos" id="cant_impuestos" value="<%=lLista.size()%>"/>
            <table width='100%' cellpadding='0' cellspacing='0' border='0' align="center" class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                <tr>
                    <td colspan="2" width='100%' height='30' align="center" class='titulo'>PARAMETROS DEL SISTEMA (Impuestos y otros valores)</td>
                </tr>
                <tr>
                    <td align="center" class='subtitulo'>
                        <div style="width:80%;text-align:left;" >
                Ingrese los valores para cada campo y luego oprima el botón Grabar. <br/>
                <br/>IMPORTANTE: Si oprime el botón "Pasar a Producción" la modificación tendrá validez sobre el cotizador a partir de la fecha ingresada la cual debe ser igual o superior al día de hoy.
                        </div>
                    </td>
                </tr>
                <tr>
                    <td align="center">
                        <table cellpadding='0' cellspacing='0' border='0'>
                            <th align="center" width='30px' nowrap>Rama</th>
                            <th align="center" width='100px' nowrap>Subrama</th>
                            <th align="center" width='500px'>Tipo de parametro</th>
                            <th align='center'  width='100px'>Valor<br/>Testeo</th>
                            <th align='center'  width='100px'>Valor<br/>Producci&oacute;n</th>
<%              if (lLista.size() == 0){%>
                            <tr>
                                <td colspan="5">No existen valores a listar</td>
                            </tr>
<%              }  
                 java.util.Date fecha      = new Date ();
                 int codRamaAnt = 0;
                 for (int i=0; i < lLista.size (); i++) {
                     Impuestos oImpuesto = (Impuestos) lLista.get (i);
                     fecha = oImpuesto.getfechaDesde();
                     if (oImpuesto.getcodRama() != codRamaAnt) {
                        codRamaAnt = oImpuesto.getcodRama();
%>                       
                  <tr><td colspan='5'><hr/></td></tr>
<%                  }
    %>
                <input type="hidden" name="TIPO_VALOR_<%=i%>" id="TIPO_VALOR_<%=i%>" value="<%= oImpuesto.gettipoValor() %>"/>
                <input type="hidden" name="COD_RAMA_<%=i%>" id="COD_RAMA_<%=i%>" value="<%= oImpuesto.getcodRama() %>"/>
                <input type="hidden" name="COD_SUB_RAMA_<%=i%>" id="COD_SUB_RAMA_<%=i%>" value="<%= oImpuesto.getcodSubRama() %>"/>
                <input type="hidden" name="COD_IMPUESTO_<%=i%>" id="COD_IMPUESTO_<%=i%>" value="<%= oImpuesto.getcodImpuesto() %>"/>
                <input type="hidden" name="VALOR_ACT_<%=i%>" id="VALOR_ACT<%=i%>" value="<%= oImpuesto.getvalor() %>"/>
                 <tr>
                     <td class='text' align="left" nowrap><%= oImpuesto.getcodRama ()%>&nbsp;-&nbsp;<%= oImpuesto.getdescRama     () %></td>
                     <td class='text' align="left" nowrap><%= (oImpuesto.getcodSubRama () == 9999 ? "" : String.valueOf (oImpuesto.getcodSubRama ()))%>&nbsp;-&nbsp;<%= oImpuesto.getdescSubRama ()%></td>
                     <td class='text' align="left"><%= oImpuesto.getcodImpuesto ()%>&nbsp;-&nbsp;<%= oImpuesto.getdescImpuesto ()%></td>
                     <td class='text' align='right'><%= oImpuesto.gettipoValor() %>&nbsp;<input class="inputTextNumeric" type="text" size="10" maxlength='10' name="VALOR_<%=i%>" id="VALOR_<%=i%>" value="<%= oImpuesto.getvalor() %>" onkeypress="return Mascara('N',event);" onfocus='InputDoFocus(this)' onblur='InputDoBlur(this);'/></td>
                     <td class='text'><input class="inputTextNumeric" type="text" size="10" value="<%= oImpuesto.getvalorProduccion() %>" readonly/></td>
                  </tr>
<%              }%> 
                <tr>
                    <td class="text" align="left" colspan="5">
                    <br/>
                    Los cambios deberán ser válidos desde la fecha&nbsp;
                    <input class="inputText" size="10" type="text" name="FECHA_DESDE" id="FECHA_DESDE" value="<%= Fecha.showFechaForm(fecha) %>" onfocus='InputDoFocus(this)' onblur='InputDoBlur(this);validaFecha(this);' onkeypress="return Mascara('F',event);" />
                    <br/>
                    <br/>
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="5">  
                        <input type="button" name="cmdSalir" value=" Salir " height="20px" class="boton" onClick="Salir();"/>&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button" name="cmdVolver" value=" Volver " height="20px" class="boton" onClick="Volver();"/>&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="submit" name="cmdGrabar" value=" Grabar " height="20px" class="boton"/><BR/><BR/>
                        <input type="button" name="cmdProd"  value=" Pasar a Produccion " height="20px" class="boton" onclick="javascript:PasarAProduccion();"/>
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
