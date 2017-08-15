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
    String sFechaRendicion =  (request.getParameter ("fecha_rendicion") == null ? null : request.getParameter ("fecha_rendicion"));
    LinkedList lError      = new LinkedList ();
    String sNuevas         = "0";
    String sModif          = "0";
    String sUrl            = "";
    String importeTotal    = "0";

    if (sPri != null && sPri.equals ("N")) {
        lError  = (LinkedList) request.getAttribute("error");
        sNuevas = (String) request.getAttribute("nuevas");
        sModif  = (String) request.getAttribute("modif");
        importeTotal = (String) request.getAttribute("importeTotal");
        
        sUrl    =  Param.getAplicacion() + "abm/bancoNacion/printBancoNacion.jsp?fecha_rendicion=" + sFechaRendicion +
                    "&nuevas=" + sNuevas + "&modif=" + sModif + "&importeTotal=" + importeTotal;

  try {
      sUrl =  java.net.URLEncoder.encode(sUrl,"UTF-8");

  } catch (java.io.UnsupportedEncodingException e)   {
      System.out.println(e.getMessage());
  }

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
            document.form1.action = "<%= Param.getAplicacion()%>servlet/BancoNacionServlet";
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
        <td valign="top" align="center" width="100%" <%=(sPri == null  ? "height='400'" : "") %>>
            <form name="form1" id="form1" method="POST" action="<%= Param.getAplicacion()%>servlet/EstadisServlet">
                <input type="hidden" name="opcion" id="opcion" value="generarReporte">
                <input type="hidden" name="pri" id="pri" value="N">
                <table width="100%" border="0" align="center" cellspacing="2" cellpadding="2"  class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                    <TR>
                        <TD height="30px" valign="middle" align="center" class='titulo' colspan='3'>GENERACION DE REPORTE DE ENVIO AL BANCO NACION</TD>
                    </TR>
                    <tr>
                        <td align="left"  class="text">Fecha Rendici&oacute;n</td>
                        <td align="left"  class="text"><input name="fecha_rendicion" id="fecha_desde" size="10"
                        onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value="<%= (sFechaRendicion == null ? "" : sFechaRendicion) %>">&nbsp;(dd/mm/yyyy)</td>
                        <td><input type="button" name="cmdGrabar1" value="GENERAR REPORTE >>>"  height="20px" class="boton" onClick="javascript: GenerarReporte ();"></td>
                    </tr>
                 </table>
            </form>
        </td>
    </tr>
<%  if ( lError != null && lError.size () > 0 ) {
        for (int i=0;i < lError.size();i++) {
            String sError = (String) lError.get(i);
     %>
    <tr>
        <td valign="middle" align="left" width="100%" height="40">
            <span style="color: red;font-weight: bold;"><%= sError %></span>
        </td>
    </tr>
<%      }
    }
    if (sPri != null && sPri.equals("N")) {
    %>
    <tr>
        <td valign="top" align="center" width='100%' height='450'>
       <jsp:include page="/include/preview.jsp" flush="true">
            <jsp:param name="url" value="<%= sUrl %>"/>
        </jsp:include>
        </td>
   </tr>
<%  }
     %>
    <tr valign="bottom" >
        <td width="100%" align="center" valign="middle">
            <input type="button" name="cmdSalir"  value="  Salir  "  height="20px" class="boton" onClick="Salir ();"/>&nbsp;&nbsp;&nbsp;
            <input type="button" name="cmdPrint"  value=" Imprimir "  height="20px" class="boton" onClick="Print ();"/>
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
