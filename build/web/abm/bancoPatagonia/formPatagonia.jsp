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
    if (usu.getiCodTipoUsuario() != 0) {
        request.setAttribute("javax.servlet.jsp.jspException", new SurException ("acceso denegado"));
        getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
    }
    String sPri            = request.getParameter ("pri");
    String sOpcion         = request.getParameter ("opcion");
    String sNombreArchivo  = request.getParameter ("archivo");
    String sMesProceso     = request.getParameter ("mes_proceso");
    String sError          = "";
    String sArchivoCSV     = "";
    String sArchivo780     = "";

    if (sPri != null && sPri.equals ("N")) {
        sError  = (String) request.getAttribute("error");
        sArchivoCSV     = (String) request.getAttribute("archivo_csv");
        sArchivo780     = (String) request.getAttribute("archivo_780");
    }

%>  
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
</head>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <script type="text/javascript" language="javascript">
    function GenerarReporte () {
        
        if ( document.form1 ) {
            document.form1.action = "<%= Param.getAplicacion()%>servlet/BancoPatagoniaServlet";
            document.form1.submit(); 
            return true;
        } else {
            return false;
        }
    }
    function Salir () {
        window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

     function Print () {
          if ( BrowserDetect.browser == 'Explorer') {
            document.oFramePoliza.focus ();
            document.oFramePoliza.print ();
          } else {
            window.frames['oFramePoliza'].focus();
            window.frames['oFramePoliza'].print();
          }
     }

        function ValidarFecha (input){
            var nSeparador = input.value.indexOf( "/", 0 )
            var fechaReturn;
            if (nSeparador == -1) {
                input.value = '01'+ input.value
            } else {
                input.value = '01/'+ input.value
            }
            var ret = validaFecha(input);
            fechaReturn = ret.substring(3, ret.length) ;
            document.getElementById ('mes_proceso').value =fechaReturn;
        }

    function EnviarArchivo () {

        if (document.formEnvioArchivo.FILE1.value == "") {
            alert ("INGRESE ARCHIVO");
            return false;
        }

        document.formEnvioArchivo.submit();
        return true;
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
        <td height="30px" valign="middle" align="center" class='titulo'>DEBITO DIRECTO - BANCO PATAGONIA</td>
    </tr>
    <tr>
        <td height="30px" valign="middle" align="left" class='subtitulo'>PROCESAR ENVIO AL BANCO</td>
    </tr>
    <tr>
        <td valign="top" align="center" width="100%" height="155px">
            <form name="form1" id="form1" method="POST" action="<%= Param.getAplicacion()%>servlet/BancoPatagoniaServlet">
                <input type="hidden" name="opcion" id="opcion" value="procesar"/>
                <input type="hidden" name="pri" id="pri" value="N"/>
                <table width="100%" border="0" align="center" cellspacing="2" cellpadding="2" class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                    <tr>
                        <td  align="left"  valign="top" class="text">Mes a procesar (mm/yyyy):&nbsp;
                            <input name="mes_proceso" id="mes_proceso" size="7" maxlength="7"
                             onblur="ValidarFecha( this );" onkeypress="return Mascara('F',event);" value="<%= (sMesProceso == null ? "" : sMesProceso)%>" />
                        </td>
                    </tr>
                    <tr>
                        <td align="left"  class="text">Nombre del Archivo:&nbsp;&nbsp;
                        <input name="archivo" id="archivo" size="50"
                               value="<%= (sNombreArchivo == null ? "" : sNombreArchivo) %>"/>&nbsp;&nbsp;
                        <input type="button" name="cmdGrabar1" value="PROCESAR ENVIO  >>>"  height="20px" class="boton" onClick="javascript: GenerarReporte ();"/>
                        </td>
                    </tr>
                    <%  if (sError != null && ! sError.equals("") && ! sError.equals("OK") && sOpcion != null && sOpcion.equals("procesar")) {
     %>
                    <tr>
                        <td valign="middle" align="left" width="100%" height="40">
                            <span style="color: red;font-weight: bold;"><%= sError %></span>
                        </td>
                    </tr>
<%  } else {
        if (sPri != null && sPri.equals("N") && sOpcion != null && sOpcion.equals("procesar")) {
    %>
                    <tr>
                        <td valign="middle" align="center" width='100%' height="50px">
                            <img src="<%= Param.getAplicacion() %>images/XLS.gif" alt="<%= sNombreArchivo%>.csv" border="0"/>
                            <a href="<%= Param.getAplicacion() %>files/trans/<%= sArchivoCSV%>" target="_blank">
                            Listado para ver con excel
                            </a>
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <a href="<%= Param.getAplicacion() %>files/trans/<%= sArchivo780 %>" target="_blank">
                                <img src="<%= Param.getAplicacion() %>images/TXT.gif" alt="<%= sNombreArchivo%>.new" border="0"/>
                            Archivo para enviar al Banco Patagonia
                            </a>
                        </td>
                   </tr>
    <% }
        %>
<%      }
%>

                 </table>
            </form>
        </td>
    </tr>
    <tr>
        <td height="30px" valign="middle" align="left" class='subtitulo'>PROCESAR RESPUESTA</td>
    </tr>
    <tr>
        <td>
            <form name="formEnvioArchivo" id="formEnvioArchivo" METHOD="POST"
                  action="<%=Param.getAplicacion()%>abm/bancoPatagonia/upload.jsp" ENCTYPE="multipart/form-data">
                <table width="100%" border="0" align="center" cellspacing="2" cellpadding="2" class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                    <tr>
                        <td class="subtitulo" align="left">Seleccione el archivo de cobranza:&nbsp;</td>
                    </tr>
                    <tr>
                        <td align="left" class="text">
                            <input type="FILE"   name= "FILE1"    id="FILE1" SIZE="50"/>&nbsp;&nbsp;
                            <input type="button" name="cmdGrabar1" value="PROCESAR RESPUESTA  <<<"  height="20px" class="boton" onClick="javascript: EnviarArchivo ();"/>
                        </td>
                    </tr>
<%  if (sError != null && ! sError.equals("") && sOpcion != null && ! sOpcion.equals("procesar")) {
     %>
                    <tr>
                        <td valign="middle" align="left" width="100%" height="40">
                            <span style="color: <%= (sError.equals("OK") ? "green" : "red") %>;font-weight: bold;"><%= (sError.equals ("OK") ? "PROCESO DE RESPUESTA PROCESADO CORRECTAMENTE": sError)%></span>
                        </td>
                    </tr>
                    <tr>
                        <td valign="middle" align="center" width='100%' height="50px">
                            <img src="<%= Param.getAplicacion() %>images/XLS.gif" alt="<%= sNombreArchivo%>.csv" border="0"/>
                            <a href="<%= Param.getAplicacion() %>files/trans/<%= sArchivoCSV%>" target="_blank">
                            Listado para ver con excel
                            </a>
                        </td>
                   </tr>

<%  }
    %>
                </table>
            </form>
        </td>
    </tr>
     <tr>
        <td width="100%" align="center" valign="middle">
            <input type="button" name="cmdSalir"  value="  Salir  "  height="20px" class="boton" onClick="Salir ();"/>
        </td>
     </tr>
    <tr>
        <td valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
   </tr>
</table>
<script>
     CloseEspere();
</script>
</body>
</HTML>
