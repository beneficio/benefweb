<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@page  import="com.business.util.*"%>
<%
Param.resetAplicacion();
%>
<script>
alert (" Aplicacion reseteada exitosamente ");
window.location.replace("/login.jsp");
</script>
