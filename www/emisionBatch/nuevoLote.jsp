<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Hits"%>
<%@page import="com.business.beans.Poliza"%>
<%@page import="com.business.beans.LoteEmision"%>
<%@page import="com.business.beans.LoteEmisionDetalle"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>   
<%@ taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg" %>
<%  

System.out.println ( this.getServletContext().getRealPath("/files/trans/renovar/") );

    Usuario usu = (Usuario) session.getAttribute("user");
    Diccionario oDicc   = (Diccionario) session.getAttribute("Diccionario");
    int iNumLote        = oDicc.getInt (request, "F3lote_sel");
    LoteEmision oLote   = (LoteEmision) request.getAttribute("lote");
    LinkedList lDetalle = (LinkedList) request.getAttribute("detalle");

    if (oLote != null && oLote.getnumLote() > 0 ) {
        iNumLote = oLote.getnumLote();
    }
    oDicc.add("F3lote_sel", String.valueOf (iNumLote));
    String sTitulo      = (oLote != null ? oLote.gettitulo() : "");
    String tipoEmision  = (oLote != null ? oLote.gettipoLote() : "R");

    if (usu.getiCodTipoUsuario() != 0) {
        request.setAttribute("javax.servlet.jsp.jspException", new SurException ("acceso denegado"));
        getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
    }
  
%>  
<html xmlns="https://www.w3.org/1999/xhtml">
    <head><title>JSP Page</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <script language="javascript">
    if(history.forward(1)){
        history.replace(history.forward(1));
    }

        function OpenEspere (){
            document.getElementById("mascara").style.display="block";
            document.getElementById("ventanita").style.display ="block";
        }
    </script>
</head>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <script type="text/javascript" language="javascript">
    function GenerarReporte () {
        
        if ( document.form1 ) {
            document.form1.action = "<%= Param.getAplicacion()%>servlet/EmisionBatchServlet";
            document.form1.submit(); 
            return true;
        } else {
            return false;
        }
    }

    function Volver () {

        if ( document.form2 ) {
            document.form2.action = "<%= Param.getAplicacion()%>servlet/EmisionBatchServlet";
            document.form2.opcion.value = "getAllLotes";
            document.form2.submit();
            return true;
        } else {
            return false;
        }
    }

    function Salir () {
        window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }


    function EnviarArchivo () {

        if (document.formEnvioArchivo.titulo.value == "") {
            alert ("INGRESE TITULO");
            return false;
        }

        opciones = document.getElementsByName("tipo_emision");

        var seleccionado = false;
        for(var i=0; i<opciones.length; i++) {
          if(opciones[i].checked) {
            seleccionado = true;
            break;
          }
        }

        if(!seleccionado) {
            alert ("INGRESE TIPO DE EMISION");
            return false;
        }
        if (document.formEnvioArchivo.FILE1.value == "") {
            alert ("INGRESE ARCHIVO");
            return false;
        }

        document.formEnvioArchivo.submit();
        return true;
    }

    function ProcesarLote () {

        document.form2.action = "<%= Param.getAplicacion()%>servlet/EmisionBatchServlet";
        document.form2.opcion.value = "procesarLote";
        document.form2.submit();
        return true;
    }

    function DetalleLote () {

        document.form2.action = "<%= Param.getAplicacion()%>servlet/EmisionBatchServlet";
        document.form2.volver.value = "nuevoLote";
        document.form2.opcion.value = "getAllDetalle";
        document.form2.submit();
        return true;
    }
function checkSubmit() {
    document.getElementById("cmdGrabar1").value = "Enviando...";
    document.getElementById("cmdGrabar1").disabled = true;
    return true;
}

    </script>
<body  onload="Javascript:history.go(1);" onunload="Javascript:history.go(1);">
 <table id="tabla_general" cellSpacing="0" cellPadding="0" width="960" align="center" border="0">
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
        <td height="350" valign="top">
            <form name="form2" id="form2" METHOD="post" onsubmit="return checkSubmit();">
                <input type="hidden" name="opcion" id="opcion" value="procesarLote" />
                <input type="hidden" name="F3lote_sel" id="F3lote_sel" value="<%= iNumLote %>" />
                <input type="hidden" name="volver" id="volver" value="-1" />
            </form>
            <form name="formEnvioArchivo" id="formEnvioArchivo" METHOD="POST"
                  action="<%=Param.getAplicacion()%>emisionBatch/upload.jsp" ENCTYPE="multipart/form-data">
                <input type="hidden" name="opcion" id="opcion" value="validar" />
                <table width="100%" border="0" align="center" cellspacing="5" cellpadding="2" class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                    <tr>
                        <td height="30px" valign="middle" align="center" class='titulo' colspan="2">EMISION BATCH</td>
                    </tr>
                    <tr>
                        <td align="left" class="text" width="130px" nowrap>N&uacute;mero de lote:&nbsp;</td>
                        <td align="left" class="text">
                            <input type="text" name="F3lote_sel" id="F3lote_sel" size="30" value="<%= iNumLote %>" readonly  />
                        </td>
                    </tr>
                    <tr>
                        <td align="left" class="text" width="130px" nowrap>T&iacute;tulo del lote:&nbsp;</td>
                        <td align="left" class="text">
                            <input type="text" name="titulo" id="titulo" size="75" maxlength="500" value="<%= (sTitulo == null ? "" : sTitulo) %>"/>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" class="text">Que desea emitir:&nbsp;</td>
                        <td align="left" class="text">
                            <input type="radio" name="tipo_emision" id="tipo_emision_R" value="R" <%= (tipoEmision != null && tipoEmision.equals ("R") ? " checked " :  "" ) %> />&nbsp;Renovaciones masivas de VCO y AP (archivo renovar.csv)<br/>
                            <input type="radio" name="tipo_emision" id="tipo_emision_P" value="P" <%= (tipoEmision != null && tipoEmision.equals ("P") ? " checked " :  "" ) %>/>&nbsp;Emisi&oacute;n vida+salud/planes especiales (archivo emitir.csv)<br/>
                            <input type="radio" name="tipo_emision" id="tipo_emision_E1" value="E1" <%= (tipoEmision != null && tipoEmision.equals ("E1") ? " checked " :  "" ) %> />&nbsp;Renovaciones masivas de VCO y AP (archivo renovar.csv)<br/>
                        </td>
                    </tr>
                    <tr>
                        <td class="subtitulo" align="left" nowrap>Ingrese archivo de emisión:&nbsp;</td>
                        <td align="left" class="text">
                            <input type="FILE"   name= "FILE1"    id="FILE1" SIZE="50"/>&nbsp;&nbsp;
                            <input type="button" name="cmdGrabar" id="cmdGrabar"  value="Enviar lote"  height="20px" class="boton" onClick="javascript: EnviarArchivo ();"/>
                        </td>
                    </tr>
                </table>
<%  if ( oLote != null && iNumLote != 0  ) {
     %>
                <table width="100%" border="0" align="center" cellspacing="5" cellpadding="2" class="fondoForm" style='margin-top:5;margin-bottom:5;'>
<%            if ( oLote.getcodEstado() == 0 || oLote.getcodEstado() == 2 ) {
                  if (oLote.getcantRegistros() > 0 ) {
    %>
                    <tr>
                        <td valign="middle" align="left" width="100%" class="text" colspan="2" >
<%
                       if (oLote.getcantErrores() == 0) {
    %>
                            <span style="color:green;font-weight: bold;">La carga del archivo fue exitosa</span>
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            <span style="font-weight: bold;">Cantidad de registros leidos: <%= oLote.getcantRegistros() %></span>
                            <input type="button" name="cmdGrabar1" id="cmdGrabar1"  value="Procesar lote"  height="20px" class="boton"
                                  onClick="javascript:ProcesarLote ();"/>

<%                      } else {
    %>
                            <span style="color:red;font-weight: bold;">Formato del archivo erroneo</span>
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            <span style="font-weight: bold;">Cantidad de registros con errores: <%= oLote.getcantErrores() %></span>
                            <table border="1" cellpadding="2" cellspacing="2" align="center" width="100%">
<%
                            if (lDetalle != null) {
                                for (int i=0; i < lDetalle.size();i++) {
                                    LoteEmisionDetalle oDet = (LoteEmisionDetalle) lDetalle.get(i);
    %>
                                <tr>
                                    <td class="text" width="100%" align="left" nowrap><%= oDet.getobservacion() %></td>
                                </tr>
<%                                }
                            }
%>
                            </table>
<%                      }
    %>
                        </td>
                    </tr>
<%                }
              } else {
    %>
                    <tr>
                        <td valign="middle" align="left" width="150px">NUMERO DE LOTE:</td>
                        <td valign="middle" align="left" width="500px"><%= oLote.getnumLote() %>
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            <input type="button" name="cmddetalle1" value="Ver detalle"  height="20px" class="boton" onClick="javascript:DetalleLote ();"/>
                        </td>
                    </tr>
                    <tr>
                        <td valign="middle" align="left">ESTADO:</td>
                        <td valign="middle" align="left"><%= oLote.getdescEstadoLote() %></td>
                    </tr>
                    <tr>
                        <td valign="middle" align="left">PROCESADOS:</td>
                        <td valign="middle" align="left"><%= oLote.getcantRegistros() %></td>
                    </tr>
                    <tr>
                        <td valign="middle" align="left">CON ERRORES:</td>
                        <td valign="middle" align="left"><%= oLote.getcantErrores() %></td>
                    </tr>
<%          }
    %>
                </table>
<%     }
    %>
                <table width="100%" border="0" align="center" cellspacing="5" cellpadding="2" class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                    <tr>
                        <td align="left" class="subtitulo" colspan="2">Formato del archivo de Renovaciones:</td>
                        <td align="left" class="text">&nbsp;</td>
                    </tr>
                    <tr>
                        <td align="left" class="text" colspan="2">rama;poliza;cant.de vidas;cualquier cosa</td>
                    </tr>
                    <tr>
                        <td align="left" class="text" colspan="2">Por ejemplo:21;105118;1;0;CONSORCIO SAN ;1;V.C.O.  ;GARCIA RUBEN HO;28380;01/12/2013;30/11/2014;0;0</td>
                    </tr>
                    <tr>
                        <td align="left" class="text" colspan="2">El archivo se tiene que llamar renovar.csv y se encuentra ubicado en DOSDISK/trans/renovar.
                        Cuando el proceso finaliza renombra el archivo procesado como renovar.csv.ok y deja en la misma carpera otro archivo renovar.log con
                        el mismo registro ingresado y al final el numero de propuesta y estado de la renovación.</td>
                    </tr>
                    <tr>
                        <td align="left" class="subtitulo" colspan="2">Formato del archivo de Vida+Salud/Planes especiales:</td>
                        <td align="left" class="text">&nbsp;</td>
                    </tr>
                    <tr>
                        <td align="left" class="text" colspan="2">El archivo se tiene que llamar emitir.csv y se encuentra ubicado en DOSDISK/trans/emitir.
                        Cuando el proceso finaliza renombra el archivo procesado como emitir.csv.ok y deja en la misma carpera otro archivo emitir.log con
                        la propuesta emitida y los errores de proceso.</td>
                    </tr>
                    <tr>
                        <td align="left" class="text" colspan="2">
COD_RAMA    <br/>
NUM_POLIZA   si es poliza nueva va cero <br/>COD_SUB_RAMA    <br/>COD_MONEDA    <br/>
COD_PROD  solo las 5 cifras del codigo de productor  <br/>PERIODO_FACT    <br/>
FECHA_INI_VIG_POL  formato dd/mm/yyyy  <br/>
FECHA_FIN_VIG_POL  formato dd/mm/yyyy  <br/>
PREMIO  si viene informado se emite con este premio  <br/>
CANT_CUOTAS  en realidad busca segun la facturacion y vigencia con cuantas cuotas lo puede emitir  <br/>
FORMA_PAGO  'S' sobre - 'T' tarjeta - 'D'  debito por CBU - '1' cupon <br/>
PROD_COMISION comision del productor en porcentaje   <br/>
COD_AMBITO  para AP, si es un plan especial toma el ambito del plan  <br/>
COD_ACTIVIDAD  si es plan especial lo toma del plan  <br/>
CLA_NO_REPETICION  'S' O 'N'  <br/>
CLA_SUBROGACION  'S' O 'N'  <br/>
BENEF_HEREDEROS  'S' o 'N'  <br/>
BENEF_TOMADOR   'S' O 'N' <br/>
COD_PRODUCTO    <br/>POLIZA_GRUPO    <br/>COD_TARJETA    <br/>COD_BANCO    <br/>NUM_TARJETA    <br/>CBU    <br/>
CONVENIO    <br/>PLAN_WEB    <br/>
TIPO_MOV  1 POLIZA NUEVA - 2 RENOVACION  <br/>NUM_TOMADOR    <br/>
TIPO_DOC_TOM  tipo de doc. del tomador  <br/>
NUM_DOC_TOM   numero de doc. del tomador <br/>
RAZON_SOCIAL  razon social del tomador  <br/>
COD_CONDICION_IVA 1 Resp. Inscripto - 4 Exento - 5 Cons. Final - 6 Indefinido - 8 Monotributo
- 9 No Acredita - 3 No Responsable <br/>DOMICILIO_TOM    <br/>LOCALIDAD_TOM    <br/>COD_POSTAL_TOM    <br/>
PROVINCIA_TOM  Pedir codigos de provincia <br/>
CERTIFICADO  numero de item  <br/>
SUB_CERTIFICADO para polizas grupales -> 0 titular - 1 conyuge - 2 o mas hijos y adherentes <br/>
TIPO_DOC   tipo doc. del asegurado <br/>
NUM_DOC  num. doc. del asegurado  <br/>
NOMBRE  nombre del asegurado  <br/>
FECHA_NAC formato dd/mm/yyyy   <br/>
COD_AGRUP_COB  para vida colectivo, esta es la cobertura grande  <br/>
IMP_CAPITAL_MUERTE  suma de muerte para el titular   <br/>
IMP_PREMIO no se usa   <br/>
PARENTESCO no se usa   <br/>
COD_COB_OPCION  es el codigo de paquete seteado en la web, si viene cero lo busco segun rama/subrama/producto/cobertura grande<br/>
COD_VTO_CUOTA  0: fecha de vigencia + n días - 2:  la mayor de emisión o vigencia - 1: fecha de emision + n días. '0' medios de pagos
automaticos. '2' cupones<br/>
SUB_SECCION  default 1, para vida+salud 22/10/26 --> '3' <br/>
MCA_ENVIO_POLIZA   'M' mail - 'N' No se manda - 'S' se manda copia de poliza por correo</td>
                    </tr>
                    <tr>
                        <td align="left" class="text" colspan="2">Por ejemplo:10;0;9;0;46487;1;17/11/2014;17/12/2014;23;;;;;983;;;;;40;;;;;;;527;;;96;36843616;ABALOS RODOLFO MARTIN;5;AV.ALVEAR 3037;BENAVIDEZ;1621;2     ;0;0;96;36843616;ABALOS RODOLFO MARTIN;11-04-1992;0;0;0;1;0;2;2;M</td>
                    </tr>
                </table>
            </form>
        </td>
    </tr>
     <tr>
         <td width="100%" align="center" valign="middle" height="30px">
            <input type="button" name="cmdSalir"  value="  Salir  "  height="20px" class="boton" onClick="Salir ();"/>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <input type="button" name="cmdVolver"  value="  Volver  "  height="20px" class="boton" onClick="Volver ();"/>
        </td>
     </tr>
    <tr>
        <td valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
   </tr>
</table>
<script language="javascript">
var divHeight;
var obj = document.getElementById('tabla_general');

if(obj.offsetHeight)          {divHeight=obj.offsetHeight;}
else if(obj.style.pixelHeight){divHeight=obj.style.pixelHeight;}
document.write('<div id="mascara" style="width:100%;height:' + divHeight + 'px;position:absolute;top:0;left:0;' +
               'background-color:#F5F7F7;z-index:3;opacity:.6;-moz-opacity:.6;-khtml-opacity:.6;filter:alpha(opacity=60);display:none"></div>' );
</script>
<!--<div id="mascara" style="position:fixed;top:0;left:0; width:100%;height:100%; background-color:#F5F7F7; z-index:3;opacity:.6;-moz-opacity:.6;-khtml-opacity:.6;filter:alpha(opacity=60);display:none"></div>
-->
<div id="ventanita" style="display:none;position:absolute;top:50%;left :50%;width:600px;height:100%;margin-top: -30px;margin-left: -300px;z-index:4">
    <table width="100%" bgcolor="F5F7F7">
            <tr>
                <td  height="100%" valign="middle">
                    <img src="/benef/images/barraProgresion.gif"/>&nbsp;
                    <span style="font-family:  Arial, Helvetica, sans-serif; font-size:16px;font-weight:bold;text-decoration:none;padding: 5px">
                    Espere por favor que se estan emitiendo las propuestas...</span>&nbsp;
                    <img src="/benef/images/barraProgresion.gif"/>
                </td>
            </tr>
    </table>
</div>
<script>
     CloseEspere();
</script>
</body>
</html>
