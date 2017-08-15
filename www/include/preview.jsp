<%@page contentType="text/html" errorPage="/error.jsp" import="java.util.*, java.text.* ,com.business.util.*"%>
<%
String sURL ="";
try {
sURL = java.net.URLDecoder.decode(request.getParameter ("url"),"UTF-8");
} catch (java.io.UnsupportedEncodingException e) { 
         System.out.println(e.getMessage()); 
 }
   %>     
<LINK rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css">	
<script language="JavaScript">
    var nombre = navigator.appName
    var url    = "";
    document.write(" <iframe marginheight='0' frameborder='1' marginwidth='0' id='oFramePoliza' name='oFramePoliza' width='100%' height='100%' src='<%= sURL %>'></IFRAME>"); 
</script>