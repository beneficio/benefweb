<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.GestionTexto"%>
<%@page import="com.business.beans.CabeceraGestion"%>
<%@page import="com.business.beans.GestionCabDetalle"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.TemplateTabla"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="/tld/menu.tld" prefix="menu"%>   
<%  
    Usuario oUsuario  = (Usuario) session.getAttribute("user"); 
    String sTitulo = "";
    int codGestion = (request.getParameter("cod_gestion") == null ? 0 : 
                     Integer. parseInt (request.getParameter("cod_gestion")));
    int codTemplate= (request.getParameter("cod_template") == null ? 3 :
                     Integer. parseInt (request.getParameter("cod_template")));
    String tipoProceso = ( request.getParameter ("tipo_proceso") == null ? "M" :
                        request.getParameter ("tipo_proceso") );

System.out.println ("en la jsp tipo_proceso");
System.out.println (tipoProceso);

    CabeceraGestion  oCab  = (CabeceraGestion)request.getAttribute ("ultimaGestion");
    LinkedList  lTextos = (LinkedList) request.getAttribute("listAllTexto");
    LinkedList  lCampos = (LinkedList) request.getAttribute("listaCampos");

    if (oCab != null) {
        sTitulo = oCab.gettitulo();
    } else {
        oCab = new CabeceraGestion ();
    }

   if ((sTitulo == null || sTitulo.length() == 0 ) &&
        lTextos != null && lTextos.size() > 0 ) {
        sTitulo = ((GestionTexto) lTextos.get(0)).gettitulo();
    }

    
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <TITLE>M&oacute;dulo de Gesti&oacute;n</TITLE>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
    <style type="text/css" >
    .textoLargo {
    width: 890px;
    height: 140px;
    overflow: inherit;
    }
    /* con esto ajustamos el texto a 300 píxeles */
    .ajustar {
        width: 890px;
        height: 250px;
        float: left;
        font:11px Tahoma, Arial, Helvetica, sans-serif;color:#4D4D4D;vertical-align:middle;
        white-space: pre; /* CSS 2.0 */
        white-space: pre-wrap; /* CSS 2.1 */
        white-space: pre-line; /* CSS 3.0 */
        white-space: -pre-wrap; /* Opera 4-6 */
        white-space: -o-pre-wrap; /* Opera 7 */
        white-space: -moz-pre-wrap; /* Mozilla */
        white-space: -hp-pre-wrap; /* HP */
        word-wrap: break-word; /* IE 5+ */
        }
    </style>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/fechas.js"></script>
<script type="" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script type="text/javascript" language="javascript">
    function OpenEspere (){
        document.getElementById("mascara").style.display="block";
        document.getElementById("ventanita").style.display ="block";
    }

    function EnviarArchivo (cod_gestion) {

        if (document.formEnvioArchivo.FILE1.value === "") {
            alert ("INGRESE ARCHIVO");
            return false;
        }

       if (parseInt (document.formEnvioArchivo.cod_texto.value) === 0 ){
            var i;
            var existe = false;
            for (i=0;i< document.formEnvioArchivo.radio_texto.length;i++){
            if (document.formEnvioArchivo.radio_texto[i].checked) {
                existe = true;
                break;
            }
            
            }
            if (existe == false) {
                alert ("Seleccione un texto a enviar ");
                return false;
            } else {
                document.formEnvioArchivo.cod_texto.value = document.formEnvioArchivo.radio_texto[i].value;
            }
        }
        document.formEnvioArchivo.cod_gestion.value = cod_gestion;
        document.formEnvioArchivo.submit();
        OpenEspere ();
        return true;
    }

    function ProcesarGestion (cod_gestion, opcion) {

    if (document.formEnvioMail.cod_gestion === cod_gestion &&
     cod_gestion !== '0' && document.formEnvioMail.est_gestion  === '2') {
        cod_gestion = '0';
    }
    
    if (opcion === 'N' && ! confirm ("Usted esta seguro que desea procesar el envío") ) {
        return false;
    } else {
        document.formEnvioMail.prueba.value = opcion;
        document.formEnvioMail.cod_gestion.value = cod_gestion;
        document.formEnvioMail.submit();
        if (opcion === 'N') { 
            document.getElementById("cmdProcesar").value = "Enviando...";
            document.getElementById("cmdProcesar").disabled = true;
        } else { 
            document.getElementById("cmdPrueba").value = "Enviando...";
            document.getElementById("cmdPrueba").disabled = true;
        }
        cmdPrueba
        OpenEspere ();
        return true;
}
  }

  function isArray(testObject) {
    return testObject && !(testObject.propertyIsEnumerable('length')) && typeof testObject === 'object' && typeof testObject.length === 'number';
}

    function ProcesarAutomat () {

        if ( isArray(document.formEnvioArchivo.radio_texto) ) {
           if (parseInt (document.form1.cod_texto.value) === 0 ){
                var i;
                var existe = false;
                for (i=0;i< document.formEnvioArchivo.radio_texto.length;i++){
                if (document.formEnvioArchivo.radio_texto[i].checked) {
                    existe = true;
                    break;
                }

                }
                if (existe === false) {
                    alert ("Seleccione un texto a enviar ");
                    return false;
                } else {
                    document.form1.cod_texto.value = document.formEnvioArchivo.radio_texto[i].value;
                }
            }
        } else {
            document.form1.cod_texto.value = document.formEnvioArchivo.radio_texto.value;
        }


    document.form1.opcion.value = "procAutomat";
    document.form1.submit();
    document.getElementById("cmd_procesar").value = "Enviando...";
    document.getElementById("cmd_procesar").disabled = true;
    OpenEspere ();
    return true;
  }

</script>
</head>
<body>
    <form name="form1" id="form1" METHOD="POST" action="<%=Param.getAplicacion()%>servlet/GestionCobServlet">
        <input type="hidden" name="cod_gestion" id="cod_gestion" value="<%= (oCab != null ? oCab.getCodGestion() : codGestion) %>"/>
        <input type="hidden" name="cod_template" id="cod_template" value="<%= (oCab != null ? oCab.getCodTemplate() : codTemplate) %>"/>
        <input type="hidden" name="est_gestion" id="est_gestion" value="<%= oCab.getCodEstado() %>"/>
        <input type="hidden" name="cod_texto" id="cod_texto" value="0"/>
        <input type="hidden" name="opcion" id="opcion" value=""/>
    </form>

    <table id="tabla_general"  cellSpacing="0" cellPadding="0" width="960" align="center" border="0">
        <tr>
            <td>
                <jsp:include page="/header.jsp">
                    <jsp:param name="aplicacion" value="<%= Param.getAplicacion() %>" />
                    <jsp:param name="usuario" value="<%= oUsuario.getusuario() %>" />
                    <jsp:param name="descripcion" value="<%= oUsuario.getRazonSoc() %>" />
                </jsp:include>
                <div class="menu">
                    <menu:renderMenuFromDB    aplicacion="1"  userLogon="<%= oUsuario.getusuario()%>" />
                </div>
            </td>
        </tr>
    <tr>
        <td class="titulo" align="center" height="35" valign="middle"><%= sTitulo %></td>
    </tr>
<%  if ( tipoProceso.equals ("A")) {
    %>
    <tr>
        <td class="subtitulo" align="center" height="35" valign="middle">
            <input type="button" name="cmd_procesar" id="cmd_procesar"  value="<%= (oCab != null && ( oCab.getCodEstado() == 0 || oCab.getCodEstado() == 1) ? "REPROCESAR GESTION" : "PROCESAR GESTION")%>"  
                   height="20px" class="boton" onClick="javascript:ProcesarAutomat ();"/>
        </td>
    </tr>
<%  }
    %>
    <tr>
        <td class="subtitulo" align="left" height="35">Ultima gestión ingresada:</td>
    </tr>
<%
    if (oCab == null || (oCab != null &&  oCab.getCodGestion() == 0 ) ) {
    %>
    <tr>
        <td class="subtitulo" align="left" height="35"><span style="color:red">No existe informaci&oacute;n de gestiones.</span></td> 
    </tr>
<%   } else { 
    %> 
    <tr>
        <td align="center">
            <table  border="1" cellspacing="0" cellpadding="2" align="center" class="TablasBody" width="90%" >
                <tr>
                    <th width="60" nowrap align="center">Gestion</th>
                    <th width="60" nowrap align="center">Proceso</th>
                    <th width="60" nowrap align="center">Estado</th>
                    <th width="60" nowrap align="center">Fecha Carga</th>
                    <th width="60" nowrap align="center">Fecha Envio</th>
                    <th width="120" nowrap align="center">Filas cargadas</th>
                    <th width="120" nowrap align="center">Mail Enviados</th>
                    <th width="20" align="center">&nbsp;</th>
                    <th width="250"  nowrap>&nbsp;</th>
                </tr>
                <tr>
                    <td nowrap class="text"><%= oCab.getCodGestion()%></td>
                    <td nowrap class="text"><%=(oCab.gettipoProceso() != null && oCab.gettipoProceso().equals ("M") ? "Excel" : "Autom&aacute;tico")%></td>
                    <td nowrap class="text"><%= oCab.getDescEstado()%></td>
                    <td nowrap class="text" align="center"><%= Fecha.showFechaForm(oCab.getFecTrabajo())%></td>
                    <td nowrap class="text" align="center"><%= (oCab.getFecEnvio() == null ? "&nbsp;" : Fecha.showFechaForm(oCab.getFecEnvio())) %></td>
                    <td nowrap class="text" align="center"><%= oCab.getFilaArchivo()%></td>
                    <td nowrap class="text" align="center"><%= oCab.getMailsEnviados()%></td>
                    <td valign="middle" align="center" class="text">
                        <a class="link" target="_blank" href="<%= Param.getAplicacion()%><%= (oCab.gettipoProceso() != null && oCab.gettipoProceso().equals("A") ? "files/reportes/" : "files/gestionCob/")%><%= oCab.getArchivo() %>">
                            <img src="<%= Param.getAplicacion()%>images/XLS.gif" border="0" align="left"/>
                        </a>
                    </td>
<%
    if (oCab.getCodEstado() == 0 ) {
    %>
                    <td nowrap align="center"  valign="middle" >
                        <form name="formEnvioMail" id="formEnvioMail" METHOD="POST" 
                              action="<%=Param.getAplicacion()%>servlet/GestionCobServlet">
                            <input type="hidden" name="cod_gestion" id="cod_gestion" value="<%= oCab.getCodGestion() %>"/>
                            <input type="hidden" name="cod_template" id="cod_template" value="<%= oCab.getCodTemplate() %>"/>
                            <input type="hidden" name="est_gestion" id="est_gestion" value="<%= oCab.getCodEstado() %>"/>
                            <input type="hidden" name="opcion" id="opcion" value="setProcesarEnvios"/>
                             <input type="hidden" name="prueba" id="prueba" value="N"/>
                            <input type="button" name="cmdProcesar" id="cmdProcesar" value="Enviar avisos" class="boton" onClick="ProcesarGestion (<%= oCab.getCodGestion()%>, 'N');"/>&nbsp;&nbsp;
                            <input type="button" name="cmdPrueba" id="cmdPrueba" value="PROBAR" class="boton" onClick="ProcesarGestion (<%= oCab.getCodGestion() %>, 'S');"/>
                        </form>
                    </td>
<% } else {
    %>
                     <td>&nbsp;</td>
<%  }
    %>
                </tr>
            </table>
        </td>
    </tr>
<%   }
    %>
    <tr>
        <td valign="top" align="center" width="100%">
            <form name="formEnvioArchivo" id="formEnvioArchivo" METHOD="POST"
                  action="<%=Param.getAplicacion()%>gestionCob/upload.jsp" ENCTYPE="multipart/form-data">
                 <input type="hidden" name="cod_gestion" id="cod_gestion" value="<%= codGestion %>"/>
                 <input type="hidden" name="cod_template" id="cod_template" value="<%= codTemplate %>"/>
                 <table width="100%" align="left" class="tablaForm" border="0" cellpadding="2" cellspacing="2">
                    <tr>
                        <td class="subtitulo" align="left">Seleccione el texto a enviar:&nbsp;</td>
                    </tr>
                    <tr>
                        <td width="100%">
                            <table align="left"  width="100%" border="1" cellpadding="2" cellspacing="2">
<%                          int iCodTexto = 0;
                            for (int i=0; i < lTextos.size(); i++)  {
                                GestionTexto oGT = (GestionTexto) lTextos.get(i);
                                iCodTexto = oGT.getCodTexto();
    %>
                                <tr>
                                    <td width="10" valign="top" align="center">
                                        <input TYPE="RADIO" name="radio_texto" id="radio_texto" value="<%= oGT.getCodTexto()%>"
                                           <%= (oGT.getMcaDefault() != null && oGT.getMcaDefault().equals("X") ? "checked" : " ") %> />
                                    </td>
                                    <td align="left" width="95%">
                                        <table border="0">
                                            <tr><td align="center"><span class="subtitulo"><%= oGT.gettitulo() %></span></td></tr>
                                            <tr><td align="left" class="text"><%= oGT.getTexto() %></td></tr>
                                        </table>
                                    </td>
                                </tr>
<%                          }
    %>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="subtitulo" align="left" height="35">Seleccione el archivo a enviar:</td>
                    </tr>
                    <tr>
                        <td align="left" class="text">
                            <input type="FILE"   name= "FILE1"    id="FILE1" SIZE="50"/>&nbsp;&nbsp;
                             <input type="button" name="cmdImportar"  value="Importar archivo"  height="20px" class="boton" onClick="EnviarArchivo(<%= codGestion %>);"/>
                        </td>
                    </tr>
<%              if ( tipoProceso.equals("M")) {
    %>
                    <tr>
                        <td class="subtitulo" align="left" height="35">El formato del excel deberia ser el siguiente:</td>
                    </tr>
                    <tr>
                        <td>
                            <table align="center" border="1" cellpadding="2" cellspacing="2" class="TablasBody">
                                <thead>
                                    <th align="center">Orden</th>
                                    <th align="center" width="70">Campo</th>
                                    <th align="center">Obligatorio</th>
                                    <th align="center" width="200">Detalle</th>
                                </thead>
<%                             for (int i=0;i<lCampos.size();i++) {
                                    TemplateTabla tt = (TemplateTabla) lCampos.get(i);

    %>
                                <tr>
                                    <td align="center" class="text"><%= tt.getnumCampo() %></td>
                                    <td align="left" class="text"><%= tt.getdescripcion()%></td>
                                    <td align="center" class="text"><%= tt.getobligatorio() %></td>
                                    <td align="left" class="text" nowrap><%= tt.getdetalle() %></td>
                                </tr>
<%                              }
    %>
                            </table>
                        </td>
                    </tr>
<%            } else {
    %>
                    <tr>
                        <td class="subtitulo" align="left" height="35">Listado de NO Gestionar&nbsp;
                            <a class="link" target="_blank" href="<%= Param.getAplicacion()%>files/reportes/no_gestionar.csv">
                                <img src="<%= Param.getAplicacion()%>images/XLS.gif" border="0" align="left" />
                            </a>
                        </td>
                    </tr>
<%            }
    %>
                </table>
                <input type="hidden" name="cod_texto" id="cod_texto" value="<%=(lTextos.size() > 1 ? 0 : iCodTexto) %>"/>
            </form>   
        </td>
    </tr>
<%   LinkedList lErr = oCab.getDetalle();
    if (oCab.getCodGestion()> 0 && codGestion == oCab.getCodGestion() &&  lErr != null && lErr.size() > 0) {
    %>
    <tr>
        <td class="subtitulo" align="left">Detalle de errores:</td>
    </tr>
    <tr>
        <td>
            <table  border="1" cellspacing="0" cellpadding="2" align="center" class="TablasBody">
                <tr>
                    <th nowrap width="50">Fila</th>
                    <th nowrap width="200">Productor</th>
                    <th nowrap width="300">Poliza</th>
                    <th width="400">Error</th>
                </tr>
<%        
            for (int i=0; i < lErr.size(); i++)  {
               GestionCabDetalle oDet = (GestionCabDetalle) lErr.get(i);
   %>
                <tr>
                    <td><%= oDet.getFila()%></td>
                    <td><%= oDet.getdescProductor() + " (" + oDet.getCodProdDc() + ")"%></td>
                    <td><%= oDet.getCodRama()%> - <%= oDet.getNumPoliza()%> - <%= oDet.getEndoso()%> - <%= oDet.getNumCuota()%>/<%= oDet.getTotalCuotas()%></td>
                    <td><%= oDet.getDesEstado() %></td>
                </tr>
<%         }
    %>
            </table>
        </td>
     </tr>
<%  }
    %>
     <tr>
        <td width='100%'>
            <jsp:include flush="true" page="/bottom.jsp"/>
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
<div id="ventanita" style="display:none;position:absolute;top:80%;left :50%;width:600px;height:100%;margin-top: -30px;margin-left: -300px;z-index:4">
    <table width="100%" bgcolor="F5F7F7">
            <tr>
                <td  height="100%" valign="middle">
                    <img src="/benef/images/barraProgresion.gif"/>&nbsp;
                    <span style="font-family:  Arial, Helvetica, sans-serif; font-size:16px;font-weight:bold;text-decoration:none;padding: 5px">
                        Espere por favor que se esta procesando la opraci&oacute;n solicitada...</span>&nbsp;
                    <img src="/benef/images/barraProgresion.gif"/>
                </td>
            </tr>
    </table>
</div>
<script>
//document.getElementById('prop_mca_hijos').value = oFrameTit.document.getElementById ('mca_hijos_' +
//                                                  oFrameTit.document.getElementById ('cod_cob').value).value;
CloseEspere();
</script>
</body>
</html>
