<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Hits"%>
<%@page import="com.business.beans.Poliza"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>   
<%@ taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg" %>
<%  
    Usuario usu = (Usuario) session.getAttribute("user");

    String sPri            = request.getParameter ("pri");
    String sFechaDesde     = request.getParameter ("fecha_desde");
    String sFechaHasta     = request.getParameter ("fecha_hasta");
    int iCodProd           = (request.getParameter ("cod_prod") == null ? 0 :
                              Integer.parseInt (request.getParameter ("cod_prod")));
    String sError          = null;
    String sArchivoZIP     = null;
    String sSistema        = (String) request.getParameter ("sistema");
    String sTipo           = (String) request.getParameter ("tipo");

    if (sSistema != null && sSistema.equals ("PRODIGAL")) {
        if (sPri != null && sPri.equals ("N")) {
            sError  = (String) request.getAttribute("error");
            sArchivoZIP     = (String) request.getAttribute("archivo");
        }
    }

    int iRegistrosEmi = 0;
    int iRegistrosCob = 0;

    String sArchivoOperaciones = "";
    String sArchivoItems       = "";
    String sArchivoNomina      = "";
    String sArchivoCoberturas  = "";
    String sArchivoCuotas      = "";
    String sArchivoCobranza    = "";

    if (sSistema != null && sSistema.equals ("KIMN")) {
        iRegistrosEmi = ( Integer ) request.getAttribute("registros_emi");
        iRegistrosCob = ( Integer ) request.getAttribute("registros_cob");

        sArchivoOperaciones = (String) request.getAttribute("operaciones");
        sArchivoItems       = (String) request.getAttribute("items");
        sArchivoNomina      = (String) request.getAttribute("nomina");
        sArchivoCoberturas  = (String) request.getAttribute("coberturas");
        sArchivoCuotas      = (String) request.getAttribute("cuotas");
        sArchivoCobranza    = (String) request.getAttribute("cobranza");
   } else if (sSistema != null && sSistema.equals ("GS")) {
        iRegistrosEmi = ( Integer ) request.getAttribute("registros_emi");
        iRegistrosCob = ( Integer ) request.getAttribute("registros_cob");

        sArchivoOperaciones = (String) request.getAttribute("operaciones");
        sArchivoNomina      = (String) request.getAttribute("nomina");
        sArchivoCoberturas  = (String) request.getAttribute("coberturas");
        sArchivoCuotas      = (String) request.getAttribute("cuotas");
        sArchivoCobranza    = (String) request.getAttribute("cobranza");
   }

    LinkedList lTabla   = new LinkedList ();
%>  
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
</head>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
    <script type="text/javascript" language="javascript">
    function GenerarReporte () {
        
        if ( document.form1 ) {
            document.form1.action = "<%= Param.getAplicacion()%>servlet/InterfaceServlet";
            document.form1.submit();
            OpenEspere ();
            return true;
        } else {
            return false;
        }
    }
    function Salir () {
        window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

        function OpenEspere (){
            document.getElementById("mascara").style.display="block";
            document.getElementById("ventanita").style.display ="block";
        }

    </script>
<body>
    <table id="tabla_general"  cellSpacing="0" cellPadding="0" width="960" align="center" border="0">
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
        <td height="30px" valign="middle" align="center" class='titulo'>INTERFACES CON SISTEMAS DE GESTION</td>
    </tr>
    <tr>
        <td valign="top" align="center" width="100%" height="300px">
            <form name="form1" id="form1" method="POST" action="<%= Param.getAplicacion()%>servlet/InterfaceServlet">
                <input type="hidden" name="opcion" id="opcion" value="interGestion"/>
                <input type="hidden" name="pri" id="pri" value="N"/>
                <table width="100%" border="0" align="center" cellspacing="2" cellpadding="2" class="fondoForm" style='margin-top:5;margin-bottom:5;'>
<%          if (usu.getiCodTipoUsuario() != 0) {
                if (usu.getiCodTipoUsuario () == 1 && usu.getiCodProd () < 80000) {
    %>
                    <input type="hidden" name="cod_prod" value="<%= usu.getiCodProd () %>"/>
<%              }
            }
    %>
<%               if (usu.getiCodTipoUsuario() == 0 || usu.getiCodProd () >= 80000) {
    %>
                    <tr>
                        <td align="left" class="text" width="150">Productor:</td>
                        <td class="text" align="left" width='550'>
                            <select class="select" name="cod_prod" id="cod_prod" style="width: 350px;">
                                    <option value="<%= ( usu.getiCodProd () >= 80000 ? usu.getiCodProd () : 0 ) %>" >Todos los productores</option>
<%                                    LinkedList lProd = (LinkedList) session.getAttribute("Productores");
                              for (int i= 0; i < lProd.size (); i++) {
                                   Usuario oProd = (Usuario) lProd.get(i);
                                    out.print("<option value='" + String.valueOf (oProd.getiCodProd()) + "' " +
                                            (oProd.getiCodProd() == iCodProd ? "selected" : " ") + ">" + oProd.getsDesPersona() +
                                            " (" + oProd.getiCodProd() + ")</option>");
                             }
%>
                            </select>
                        </td>
                    </tr>

<%                      }
    %>

                    <tr>
                        <td  align="left"  valign="top" class="text" width="150">Sistema:&nbsp;</td>
                        <td align="left" valign="top" class="text" width="250">
                            <select name="sistema" id="sistema"  class='select' style="width: 350px;">
                                <option value="PRODIGAL" <%= (sSistema != null && sSistema.equals ("PRODIGAL") ? "selected" :  ( usu.getsSistGestion() != null && usu.getsSistGestion().equals("PRODIGAL") ? "selected" : " " ) ) %>>Prodigal</option>
                                <option value="KIMN" <%= (sSistema != null && sSistema.equals ("KIMN") ? "selected" :  ( usu.getsSistGestion() != null && usu.getsSistGestion().equals("KIMN") ? "selected" : " " ) ) %>>Kimn</option>
                                <option value="GS" <%= (sSistema != null && sSistema.equals ("GS") ? "selected" :  ( usu.getsSistGestion() != null && usu.getsSistGestion().equals("GS") ? "selected" : " " ) ) %>>GS</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td  align="left"  valign="top" class="text">fecha desde: (dd/mm/yyyy):&nbsp;</td>
                        <td  align="left"  valign="top" class="text">
                           <input type="text" name="fecha_desde" id="fecha_desde" size="10"
                           onblur="validaFecha(this);" onkeypress="return Mascara('F',event);"
                           value='<%=(sFechaDesde == null ? "" : sFechaDesde)%>'/>
                        </td>
                    </tr>
                    <tr>
                        <td  align="left"  valign="top" class="text">fecha hasta: (dd/mm/yyyy):&nbsp;</td>
                        <td  align="left"  valign="top" class="text">
                           <input type="text" name="fecha_hasta" id="fecha_hasta" size="10"
                           onblur="validaFecha(this);" onkeypress="return Mascara('F',event);"
                           value='<%=(sFechaHasta == null ? "" : sFechaHasta)%>'/>
                        </td>
                    </tr>
                    <tr>
                        <td  align="left"  valign="top" class="text">Para Kimn o GS ingrese opci&oacute;n:&nbsp;</td>
                        <td align="left" valign="top" class="text" width="250">
                            <select name="tipo" id="tipo"  class='select' style="width: 350px;">
                                <option value="ALL" <%= ( sTipo != null && sTipo.equals ("ALL") ? "selected" : "") %> >Emisi&oacute;n y Cobranza</option>
                                <option value="EMI" <%= ( sTipo != null && sTipo.equals ("EMI") ? "selected" : "") %> >Emisi&oacute;n </option>
                                <option value="COB" <%= ( sTipo != null && sTipo.equals ("COB") ? "selected" : "") %> >Cobranza </option>
                            </select>
                        </td>
                    </tr>
<%      if (sSistema != null && sSistema.equals ("PRODIGAL")) {
            if (sArchivoZIP != null && sError.equals("ok")) {
    %>
                    <tr>
                        <td valign="middle" align="center" width='100%' height="50px" colspan="2">
                            <img src="<%= Param.getAplicacion() %>images/ZIP.gif" alt="Archivo <%= sArchivoZIP %>" border="0"/>
                            <a href="<%= Param.getAplicacion() %>files/intGestion/<%= sArchivoZIP %>" target="_blank">
                            Ya puede bajar el archivo de datos
                            </a>
                        </td>
                   </tr>
<%              } else {
                    if (sError != null && ! sError.equals("ok")) {
    %>
                    <tr>
                        <td valign="middle" align="center" width='100%' height="50px" colspan="2">
                            <span style="color:red;font-weight: bold"><%= sError %></span>
                        </td>
                   </tr>

<%                  }
                }
            }
        if (sSistema != null && ( sSistema.equals ("KIMN") || sSistema.equals ("GS") ) ) {
            if (sTipo != null && ( sTipo.equals ("EMI") || sTipo.equals ("ALL") )) {
                if ( iRegistrosEmi > 0 ) {
    %>
                    <tr>
                        <td  align="left"  valign="top" class="subtitulo" colspan="2">Se procesaron <%= iRegistrosEmi %> registros de emisi&oacute;n. Haga clic en los archivos para bajarlos</td>
                    </tr>
                    <tr>
                        <td valign="middle" align="center" width='100%' colspan="2">
                            <table align="center" width="100%" border="0" cellpadding="4" cellspacing="2">
                                <tr>
                                    <td width="20%" class="subtitulo" align="center">OPERACIONES</td>
                                    <td width="20%" class="subtitulo" align="center">ITEMS</td>
                                    <td width="20%" class="subtitulo" align="center">NOMINA</td>
                                    <td width="20%" class="subtitulo" align="center">COBERTURAS</td>
                                    <td width="20%" class="subtitulo" align="center">CUOTAS</td>
                                </tr>
                                <tr>
                                    <td width="20%" class="text" align="center">
                                        <a href="<%= Param.getAplicacion()%>usuarios/mostrarTxt.jsp?path=/files/intGestion&nameFile=<%= sArchivoOperaciones %>"
                                           target='_blank' onmouseover="this.style.textDecoration='underline';"
                                           onmouseout="this.style.textDecoration='none';"><img src="<%= Param.getAplicacion() %>images/TXT.gif"  alt="Archivo de Operaciones" border="0"/>
                                        </a>
                                    </td>
<%                                  if (sSistema.equals ("KIMN")) {
    %>
                                    <td width="20%" class="text" align="center">
                                        <a href="<%= Param.getAplicacion()%>usuarios/mostrarTxt.jsp?path=/files/intGestion&nameFile=<%= sArchivoItems %>"
                                           target='_blank' onmouseover="this.style.textDecoration='underline';"
                                           onmouseout="this.style.textDecoration='none';"><img src="<%= Param.getAplicacion() %>images/TXT.gif"  alt="Archivo de items" border="0"/>
                                        </a>
                                    </td>
<%                                 } else {
    %>
                                    <td width="20%" class="text" align="center">No aplica</td>
<%                                 }
    %>
                                    <td width="20%" class="text" align="center">
                                        <a href="<%= Param.getAplicacion()%>usuarios/mostrarTxt.jsp?path=/files/intGestion&nameFile=<%= sArchivoNomina %>"
                                           target='_blank' onmouseover="this.style.textDecoration='underline';"
                                           onmouseout="this.style.textDecoration='none';"><img src="<%= Param.getAplicacion() %>images/TXT.gif"  alt="Archivo de Nomina" border="0"/>
                                        </a>
                                    </td>
                                    <td width="20%" class="text" align="center">
                                        <a href="<%= Param.getAplicacion()%>usuarios/mostrarTxt.jsp?path=/files/intGestion&nameFile=<%= sArchivoCoberturas %>"
                                           target='_blank' onmouseover="this.style.textDecoration='underline';"
                                           onmouseout="this.style.textDecoration='none';"><img src="<%= Param.getAplicacion() %>images/TXT.gif"  alt="Archivo de coberturas" border="0"/>
                                        </a>
                                    </td>
                                    <td width="20%" class="text" align="center">
                                        <a href="<%= Param.getAplicacion()%>usuarios/mostrarTxt.jsp?path=/files/intGestion&nameFile=<%= sArchivoCuotas %>"
                                           target='_blank' onmouseover="this.style.textDecoration='underline';"
                                           onmouseout="this.style.textDecoration='none';"><img src="<%= Param.getAplicacion() %>images/TXT.gif"  alt="Archivo de cuotas" border="0"/>
                                        </a>
                                    </td>
                                </tr>
                            </table>
                        </td>
                   </tr>
<%              } else {
    %>
                    <tr>
                        <td valign="middle" align="center" width='100%' height="50px" colspan="2">
                            <span style="color:red;font-weight: bold">No existen operaciones de emisi&oacute;n para el periodo seleccionado</span>
                        </td>
                   </tr>
<%                }
            }
            if (sTipo != null && ( sTipo.equals ("COB") || sTipo.equals ("ALL") )) {
                if (iRegistrosCob > 0 ) {
    %>
                    <tr>
                        <td  align="left"  valign="top" class="subtitulo" colspan="2">Se procesaron <%= iRegistrosCob %> registros de cobranza. Haga clic en los archivos para bajarlos</td>
                    </tr>
                    <tr>
                        <td valign="middle" align="center" width='100%' colspan="2">
                            <table align="center" width="100%" border="0" cellpadding="4" cellspacing="2">
                                <tr>
                                    <td width="20%" class="subtitulo" align="center">COBRANZA</td>
                                </tr>
                                <tr>
                                    <td width="20%" class="text" align="center">
                                        <a href="<%= Param.getAplicacion()%>usuarios/mostrarTxt.jsp?path=/files/intGestion&nameFile=<%= sArchivoCobranza %>"
                                           target='_blank' onmouseover="this.style.textDecoration='underline';"
                                           onmouseout="this.style.textDecoration='none';"><img src="<%= Param.getAplicacion() %>images/TXT.gif"  alt="Archivo de cobranzas" border="0"/>
                                        </a>
                                    </td>
                                </tr>
                            </table>
                        </td>
                   </tr>
<%              } else {
    %>
                    <tr>
                        <td valign="middle" align="center" width='100%' height="50px" colspan="2">
                            <span style="color:red;font-weight: bold">No existen operaciones de cobranza para el periodo seleccionado</span>
                        </td>
                   </tr>
<%                }
                }
            }
  %>
                 </table>
            </form>
        </td>
    </tr>
     <tr>
        <td width="100%" align="center" valign="middle">
            <input type="button" name="cmdSalir"  value="  Salir  "  height="20px" class="boton" onClick="Salir ();"/>
            &nbsp;&nbsp;&nbsp;&nbsp;
                <input type="button" name="cmdGenerar"  value=" Generar archivo  "  height="20px" class="boton" onClick="GenerarReporte ();"/>
            </td>
        </tr>

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
<div id="ventanita" style="display:none;position:absolute;top:50%;left :50%;width:400px;height:100%;margin-top: -30px;margin-left: -200px;z-index:4">
    <table width="100%" bgcolor="F5F7F7">
            <tr>
                <td  height="100%" valign="middle">
                    <img src="/benef/images/barraProgresion.gif"/>&nbsp;
                    <span style="font-family:  Arial, Helvetica, sans-serif; font-size:16px;font-weight:bold;text-decoration:none;padding: 5px">
                    Espere un momento por favor...</span>&nbsp;
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
