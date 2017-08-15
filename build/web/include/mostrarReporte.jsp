<%@page contentType="text/html" errorPage="/benef/error.jsp"%>
<%@page import="java.util.*, java.text.*,com.business.util.*"%>
<%
String sURL ="";
try {
sURL = java.net.URLDecoder.decode(request.getParameter ("url"),"UTF-8");
} catch (java.io.UnsupportedEncodingException e) { 
         System.out.println(e.getMessage()); 
 }
   %>     
<LINK rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css">
<SCRIPT language="JavaScript">
    var nombre = navigator.appName
    var url    = "";
    if (nombre == "Microsoft Internet Explorer") {
           document.write("<OBJECT id='pdf' width='100%' height='100%' classid='CLSID:CA8A9780-280D-11CF-A24D-444553540000' >");   
           document.write("<PARAM name='_Version' value='327680'>");   
           document.write("<PARAM name='_ExtentX' value='2646'>");   
           document.write("<PARAM name='_ExtentY' value='1323'>");   
           document.write("<PARAM name='_StockProps' value='0'>");   
           document.write("<PARAM name='SRC' value='<%= sURL %>'>"); 
           document.write("</OBJECT>");
    } else {
       document.write(" <iframe marginheight='0' frameborder='1' marginwidth='0' id='oFramePoliza' name='oFramePoliza' width='100%' height='425' src='<%= sURL %>'></IFRAME>"); 
    }
    </script>