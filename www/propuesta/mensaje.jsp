<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Propuesta"%>
<%@page import="com.business.util.*"%>
<% Usuario usu = (Usuario) session.getAttribute("user"); 
   String sMensaje  = (String) request.getAttribute ("mensaje");
   String sVolver   = (String) request.getAttribute ("volver");
   Propuesta  oProp = (Propuesta) request.getAttribute("propuesta");

   if (sVolver == null) {
    sVolver = Param.getAplicacion() + "index.jsp";
   }
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<script src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
<script src="<%= Param.getAplicacion()%>portal/js/vendor/jquery-1.8.0.min.js"></script>
<script type="text/javascript">
function volver(){
  if (document.getElementById('volver').value === "history.back()" ||
      document.getElementById('volver').value === "-1") {
    window.history.back(-1);
 }else{    
    // window.location.replace (document.getElementById('volver').value);
    document.form10.action = document.getElementById('volver').value;
    document.form10.submit();
 } 
}

    function  MercadoPago ( rama, poliza ) {

        var mensaje = '';

        $.post('<%= Param.getAplicacion()%>portal/authority.html', { 
            numDoc: '', 
            polizaNumber: poliza, 
            ramaCode: rama, 
            origen: 'PROPUESTA', 
            backPage: $('#volver').val(), 
            idtransaction: '3' }, 
        function(result) {
        
        if(result.success === true) {
            window.location.href = "<%= Param.getAplicacion()%>" + result.redirect;
        }else{ 
            if(result.message !== null || result.message !== '') {
 //               $('#msg_payment').html(result.message);
                mensaje = result.message;
            } else {
//                $('#msg_payment').html('Por favor, intente nuevamente.');
                mensaje = 'Por favor, intente nuevamente.';
            }
//            $('#msg_payment').show();
              alert (mensaje);
            }
        }, 'json');
    
    return true;
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
                                                                     alt='Respuesta del sistema a la petición realizada'/></td>
                    <td  valign='top' align='left' width='100%'>
                    <span style="color: #747474; font-family:  Arial, Helvetica, sans-serif; font-size:16px;text-decoration:none;padding: 5px">
                        
<%                  if (  sMensaje != null && sMensaje.length() > 1  ) {
    %>
                        <%=sMensaje%>
<%                  } else {
                        if (oProp.getCodEstado() == 5 && oProp.getNumPoliza() > 0 ) {
                            if (oProp.getTipoPropuesta().equals("P") || oProp.getTipoPropuesta().equals("R")) {
     %>
La propuesta N&deg;&nbsp;<strong> <%= oProp.getNumPropuesta() %></strong>&nbsp;ha sido <strong>EMITIDA con el Nro. de p&oacute;liza&nbsp; <%= oProp.getNumPoliza() %></strong>.<br/><br/>
Si usted tiene env&iacute;o de p&oacute;lizas v&iacute;a mail estar&aacute; recibiendo la copia de su p&oacute;liza de forma inmediata en su cuenta de mail.<br/><br/>
En unos minutos podr&aacute; consultar la p&oacute;liza a trav&eacute;s de nuestra web desde Cartera --> P&oacute;lizas."
<%                          } else {
    %>                            
    La propuesta de endoso N&deg;&nbsp;<strong> <%= oProp.getNumPropuesta() %></strong>&nbsp;de la p&oacute;liza&nbsp;<%= oProp.getNumPoliza() %>&nbsp;ha sido <strong>EMITIDA con el Nro. de endoso&nbsp; <%= oProp.getnumEndoso()%></strong>.<br/><br/>
Si usted tiene env&iacute;o de p&oacute;lizas v&iacute;a mail estar&aacute; recibiendo la copia del endoso de forma inmediata en su cuenta de mail.<br/><br/>
En unos minutos podr&aacute; consultar el endoso  a trav&eacute;s de nuestra web desde Cartera --> P&oacute;lizas."
                                
<%                            }
                        } else {
    %>
    La propuesta N&deg;&nbsp;<strong>&nbsp;<%= oProp.getNumPropuesta() %></strong>&nbsp;ha sido enviada con exito ! 
<%                      }
                   }
    %>

                    <br/>
                    <br/>
                    <br/>
<%                 if (oProp.getCodEstado() == 5 && oProp.getNumPoliza() > 0 && oProp.getCodFormaPago() == 8 ) {
    %>
    <strong>Haga clic en el siguiente bot&oacute;n para pagar la p&oacute;liza&nbsp;</strong>
    <a href="#" name="MP-Checkout" class="lightblue-L-Rn-ArOn" mp-mode="modal" onclick="javascript:MercadoPago(<%= oProp.getCodRama() %>,<%= oProp.getNumPoliza() %> );">Pagar</a>

<%                 }
    %>
                        </span>
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
<!-- Pega este código antes de cerrar la etiqueta </body> -->
<script type="text/javascript">
    (function(){function $MPC_load(){window.$MPC_loaded !== true && (function(){var s = document.createElement("script");s.type = "text/javascript";s.async = true;
    s.src = document.location.protocol+"//resources.mlstatic.com/mptools/render.js";
    var x = document.getElementsByTagName('script')[0];x.parentNode.insertBefore(s, x);window.$MPC_loaded = true;})();}
    window.$MPC_loaded !== true ? (window.attachEvent ? window.attachEvent('onload', $MPC_load) : window.addEventListener('load', $MPC_load, false)) : null;})();
</script>
</body>
</html>