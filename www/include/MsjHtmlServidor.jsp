<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.util.*"%>
<% Usuario usu = (Usuario) session.getAttribute("user"); 
   String sMensaje  = (String) request.getAttribute ("mensaje");
   String sVolver   = (String) request.getAttribute ("volver");
   if (sVolver == null) {
    sVolver = Param.getAplicacion() + "index.jsp";
   }
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<script type="text/javascript">
function volver(){
  if (document.getElementById('volver').value == "history.back()" ||
      document.getElementById('volver').value == "-1") {
    window.history.back(-1);
 }else{    
    // window.location.replace (document.getElementById('volver').value);
    document.form10.action = document.getElementById('volver').value;
    document.form10.submit();
 } 
}
</script>
</head>
<body>
    <form name="form10" id="form10"  method="post" action="">
        <input type="hidden" name="volver" id="volver" value="<%= sVolver %>"/>
    </form>
 <table id="tabla_general" cellSpacing="0" cellPadding="0" width="960" align="center" border="0">
        <tr>
            <td>
                <jsp:include page="/header.jsp">
                    <jsp:param name="aplicacion" value="<%= Param.getAplicacion() %>" />
                    <jsp:param name="usuario" value="<%= usu.getusuario() %>" />
                    <jsp:param name="descripcion" value="<%= usu.getRazonSoc() %>" />
                </jsp:include>
            </td>
        </tr>
    <tr>
        <td width='100%' height='50' valign="middle" align="center" colspan='2'><font color='#ff0000' size='3'><B>RESULTADO DE LA OPERACION</B></font> </td>
    </tr>
    <tr>
        <TD width="80%" valign="top" align="center" height='400px'>
            <table width="80%" align="center"  cellspacing="2" cellpadding="5" border='0'  style="border-top:2pt solid #FF0000 ; border-left:1pt solid #FF0000 ;">
                <tr>
                    <td width='70' valign="top" align="center" ><img src='<%=Param.getAplicacion()%>images/procesado.gif'
                                                                     alt='Respuesta del sistema a la petición realizada'></td>
                    <td  valign='top' align='left' width='100%'>
                    <span style="color: #747474; font-family:  Arial, Helvetica, sans-serif; font-size:16px;text-decoration:none;padding: 5px">
                        <%=sMensaje%>
                    </span>
                    <br/>
                    <br/>
                    </td>
                </tr>
                <tr>
                    <td height='50' valign="middle" align="center" colspan='2'>
                    <input type="button" onClick="javascript:volver();" name="cmdSalir" value=" Volver " width="80px" height="20px" class="boton"/>
                    </td>
                </tr>
            </table>
        </TD>
    </tr>
    <TR>
        <TD width='100%'>
            <jsp:include flush="true" page="/bottom.jsp"/>
        </TD>
    </TR>
</table>
</body>
</html>