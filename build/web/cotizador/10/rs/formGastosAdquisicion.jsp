<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.db.db"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.LinkedList"%>
<%
    Connection dbCon = null;
    double gastosMax = 0;
    int codRama      = 0; 
    int codSubRama   = 0;    
    int codProd      = 0;
    double gastosAd  = 0;
 try {
    codRama      = (request.getParameter ("cod_rama") == null ? 10 : Integer.parseInt (request.getParameter ("cod_rama"))); 
    codSubRama   = (request.getParameter ("cod_sub_rama") == null ? 2 : Integer.parseInt (request.getParameter ("cod_sub_rama")));    
    codProd      = (request.getParameter ("cod_prod") == null ? -1 : Integer.parseInt (request.getParameter ("cod_prod")));
    gastosAd  = (request.getParameter ("GASTOS_ADQUISICION") == null ? -1 : Double.parseDouble(request.getParameter ("GASTOS_ADQUISICION")));

    dbCon = db.getConnection();    

    if ( codProd != -1 ) {
        gastosMax = ConsultaMaestros.getPorcComisionProd(dbCon, codProd, codRama);
    }
//    if ( gastosMax == 0) {
//        gastosMax =  ConsultaMaestros.getParametro(dbCon,codRama, 12);
//    }
    if ( gastosAd == -1 || gastosAd > gastosMax ) {
        gastosAd = gastosMax;
    }
  } catch (Exception e) {
       throw new SurException (e.getMessage());
     } finally {
        db.cerrar(dbCon);
  }
   %>
<html>
<head><title>Cotizador AP</title></head>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css">
<link href="<%=Param.getAplicacion()%>css/Tablas.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript">
    function Validar ( num) {
        if ( parseInt (num) > parseInt (document.formCob.MAX_GASTOS_ADQUISICION.value)) {
            alert ("La comisión debe ser menor o igual a la maxima");
            document.formCob.GASTOS_ADQUISICION.value = document.formCob.MAX_GASTOS_ADQUISICION.value;
            document.formCob.GASTOS_ADQUISICION.focus ();
            return false;
        }
    }
</script>
<body style="background-color:#F4F4F4;" >
     <form name="formCob" id="formCob"  method="POST">
        <input type="hidden" name="MAX_GASTOS_ADQUISICION" id="MAX_GASTOS_ADQUISICION" value="<%= gastosMax %>" >
        <input type="text" name="GASTOS_ADQUISICION" ID="GASTOS_ADQUISICION"  value="<%= gastosAd %>"
               onKeyPress="return Mascara('P',event);" class="inputTextNumeric"
               maxlength='5' size='5' onchange='Validar (this.value);'>&nbsp;<span class="text">%&nbsp;+ 2% si emite la propuesta desde la web</span>
      </form>
</body>
</html>
