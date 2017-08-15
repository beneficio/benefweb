<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.db.db"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.LinkedList"%>
<html>
<head><title>Cotizador AP</title></head>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css">
<link href="<%=Param.getAplicacion()%>css/Tablas.css" rel="stylesheet" type="text/css">
<SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<SCRIPT type="text/javascript" language="JavaScript">
    function Validar ( num) {
        if ( parseInt (num) > parseInt (document.formCob.MAX_GASTOS_ADQUISICION.value)) {
            alert ("La comisión debe ser menor o igual a la maxima");
            document.formCob.GASTOS_ADQUISICION.value = document.formCob.MAX_GASTOS_ADQUISICION.value;
            document.formCob.GASTOS_ADQUISICION.focus ();
            return false;
        }
    }
</script>
<body style="background-color:#F4F4F4;">
     <form name="formCob" id="formCob"  method="POST">
        <input type="hidden" name="MAX_GASTOS_ADQUISICION" id="MAX_GASTOS_ADQUISICION" value="<%= 25.34 %>" >
        <input type="text" name="GASTOS_ADQUISICION" ID="GASTOS_ADQUISICION"  value="<%= 25.34 %>"   class="inputTextNumeric" maxlength='5' size='5' onchange='Validar (this.value);' readonly>%
      </form>
</body>
</html>