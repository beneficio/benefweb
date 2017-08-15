<%@ page contentType="text/html" errorPage="/error.jsp" session="true"%>
<%@ page import="com.business.beans.Usuario" %>
<%@ page import="com.business.util.*" %>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>
<% Usuario oUsuario = (Usuario) session.getAttribute ("user");
   String sValor    = (oUsuario == null ? " " : oUsuario.getusuario());   
   String sMensaje  = (String) request.getAttribute ("mensaje");
   String sVolver   = (String) request.getAttribute ("volver");
   if (sVolver == null) {
    sVolver = Param.getAplicacion() + "index.jsp";  
   }
    %>
<html>
<head>
    <title>mensaje del servidor</title>
    <LINK rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css">
</head>
<BODY leftmargin="0" topmargin="0" onload="noBack();" onunload="noBack();" >
<menu:renderMenuFromDB  aplicacion="1"  userLogon="<%=  sValor %>" />
<form name="form1" id="form1"  method="post" action="">
    <input type="hidden" name="volver" id="volver" value="<%= sVolver %>">
</form>
<script>
    alert ("<%= sMensaje %>");
  if (document.getElementById('volver').value == "history.back()" ||
      document.getElementById('volver').value == "-1") {
    history.go(-1);
 }else{
    // window.location.replace (document.getElementById('volver').value);
    document.form1.action = document.getElementById('volver').value;
    document.form1.submit();
 }
</script>
</body>
</html>