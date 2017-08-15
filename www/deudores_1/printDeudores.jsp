<%@page contentType="text/html" errorPage="/benef/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.*"%>
<%
    String sFuncion = "";
   String sTipo     = (request.getParameter("tipo") == null ? "HTML" : request.getParameter("tipo"));
   String sUrl=  Param.getAplicacion() + "servlet/DeudoresServlet?opcion=" + request.getParameter("opcion") +
   "&cod_prod=" + request.getParameter ("cod_prod") + "&tomador=" + request.getParameter ("tomador") + 
   "&fecha=" + request.getParameter ("fecha") + "&consolidado=" + request.getParameter ("consolidado") + 
   "&tipo=" + sTipo + "&min_deuda=" + request.getParameter ("min_deuda")+ "&num_poliza=" + request.getParameter ("num_poliza") +
    "&num_tomador=" + request.getParameter ("num_tomador");

    try { 
        sUrl =  java.net.URLEncoder.encode(sUrl,"UTF-8");

    } catch (java.io.UnsupportedEncodingException e) 
        { 
             System.out.println(e.getMessage()); 
        } 

%>
<html>
<head>
    <title>Impresion de Certificado</title>
    <LINK rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css">	
    <SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <SCRIPT language="javascript">
    
     function Salir () {
      window.location.replace("<%= Param.getAplicacion()%>deudores/formDeudores.jsp");
     }
     function Volver () {
         if ( BrowserDetect.browser == 'Explorer') {
             window.history.go(-1);
         } else {
            window.back();
         }
     }

     function Print () {
<%      if (sTipo.equals ("HTML") && request.getParameter ("consolidado").equals ("S")) { 
    %>
        alert ("En el consolidado debe setear la impresora para imprimir con orientación = horizontal ");
<%      }
    %>
          if ( BrowserDetect.browser == 'Explorer') {
            document.oFramePoliza.focus ();
            document.oFramePoliza.print ();
          } else {
            window.frames['oFramePoliza'].focus(); 
            window.frames['oFramePoliza'].print(); 
          }
     }
    </SCRIPT>
</head>
<body  leftMargin=0 topMargin=5 marginheight="0" marginwidth="0">
<TABLE cellSpacing=0 cellPadding=0 width=720  height="445" align=center border=0>
    <tr>
        <td align="center" valign="top">
            <jsp:include flush="true" page="/topPrint.jsp"/>
        </td>
    </tr>
    <tr>
        <td valign="top" align="center" width='100%' height='100%'>
<% if ( sTipo.equals ("HTML")) {
    %>
       <jsp:include page="/include/preview.jsp" flush="true">
            <jsp:param name="url" value="<%= sUrl %>"/>
        </jsp:include>
<% } else {
    %>
        <jsp:include page="/include/mostrarReporte.jsp" flush="true">
            <jsp:param name="url" value="<%= sUrl %>"/>
        </jsp:include>
<%  }
    %>
        </td>
    </tr>
    <tr valign="bottom" >
        <td width="100%" align="center" valign="middle">
            <input type="button" name="cmdSalir"  value="  Volver  "  height="20px" class="boton" onClick="Volver ();">&nbsp;&nbsp;&nbsp;
<%      if (sTipo.equals ("HTML")) {
    %>
            <input type="button" name="cmdPrint"  value=" Imprimir "  height="20px" class="boton" onClick="Print ();">
<%      }
    %>
        </td>
    </tr>
     <TR>
        <TD valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
    </tr>
</table>
</body>

