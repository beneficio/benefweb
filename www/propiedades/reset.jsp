<%@page contentType="text/html"%>
<%@page  import="java.sql.Connection"%>
<%@page  import="com.business.db.*"%>
<% 
        Connection dbCon = db.getConnection();
        db.resetear();
        db.cerrar(dbCon);
%>
<script>
alert (" Conexi�n reseteada exitosamente ");
window.location.replace("/login.jsp");
</script>
