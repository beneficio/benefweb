<%@page contentType="text/html" errorPage="error.jsp"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<% Usuario usu = (Usuario) session.getAttribute("user");
    %>   
<%--<html>
<head><title>top page</title>
<LINK href="/benef/css/estilos.css" type="text/css" rel="stylesheet">
<script>
var IE5 = (document.all && document.getElementById) ? true : false;
function get_fecha(){
    dias=new Array("Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado")
    meses=new Array("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Setiembre", "Octubre", "Noviembre", "Diciembre");
    nmeses=new Array("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12");
    ndia=new Array("00","01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22","23", "24", "25", "26", "27", "28", "29", "30", "31");
    fecha=new Date();
    if (IE5) {
        var sfecha = dias[fecha.getDay()]+" "+fecha.getDate()+" de "+meses[fecha.getMonth()]+" " +fecha.getYear();
    }else{
		var sfecha = dias[fecha.getDay()]+" "+fecha.getDate()+" de "+meses[fecha.getMonth()]+" " +(fecha.getYear()+1900);
    }
  return sfecha;
}
 function salir () {
   document.formTop.submit();
 }
</script>
</head>
<body>
<form name="formTop" action='/benef/servlet/setAccess?opcion=LOGOUT' method="post">
</form>
    <TABLE cellSpacing=0 cellPadding=0 width="730px" border="0" align="center">
     <tr>
         <td  valign="top" id="cg3_top" width="100%">
             <div id="cg3_top" >
             <div class="c1a_top">&nbsp;</div>
             <div class="c1b_top" style="height:66;">
                <table width="100%"  border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td align="left" valign="top" width="30%" height='100%'>
                            <IMG border='0' align="left" vspace='2' src='/benef/images/logo_nuevo.gif' >
                        </td>
				 
<%      if (usu != null) {
    %>
	                <TD align="right" valign="top">
                            <a  href="/benef/servlet/setAccess?opcion=getUsuario&usuario=<%= usu.getusuario()%>&estado=A" ><SPAN class="textogris">Mis Datos</A></SPAN>&nbsp;|
                            <A href="mailto:info@beneficiosa.com.ar" target=_blank><SPAN class="textogris">Contacto</A></SPAN>&nbsp;|
                            <A href="#" onclick='javascript:salir();'><SPAN class="textogris">Salir</A></SPAN><br><br>
                            <span class="fecha" width='100%' align="right" valign="bottom"><script type="text/javascript">document.write(get_fecha());</script></span>
	                </TD>
<%      } else {
    %>
	                    <TD align="right" valign="top">
	                        <A  href="/benef/registracion.html"><SPAN class="textogris">Registrese</A></SPAN>&nbsp;|
							<A href="mailto:info@beneficiosa.com.ar" target=_blank><SPAN class="textogris">Contacto</A></SPAN>
	                    </TD>
<%      }
    %>			
							
			</tr>
                    </table> 
		 </div>
             <div class="c1c_top">&nbsp;</div>
             </div>
         </td>
     </tr>
    <TR>
        <TD height='1'><HR width="100%" color="#0468cd" noShade>
        </TD>
    </TR>
<%      if (usu != null) {
    %>
     <TR>
        <TD width="100%" bgcolor="#6699CC" height='22'>&nbsp;</td>
    </TR>
<%      }
    %>
</TABLE>
</body>
</html>
--%>
<%  String sAplicacion = Param.getAplicacion();;
    String sUsuario    = usu.getusuario();
    String sDescripcion = usu.getRazonSoc();
    %>

<script type="text/javascript">
     function salir () {
       document.formTop.submit();
     }
</script>
<table cellSpacing=0 cellPadding=0 width="100%" border="0" align="center" style="border-top:2px solid #d54536;">
     <tr>
         <td width="100%" height="140">
         <img src="<%=sAplicacion %>images/logos/bnf_web_logo.png" width="326" height="88" alt="logo" class="logo" />
         </td>
         <td>
             <div class="user-info">
                <span class="name">Bienvenido <a href="/benef/servlet/setAccess?opcion=getUsuario&usuario=<%= sUsuario  %>&estado=A" title="ver perfil"><%= sDescripcion %></a></span>
                <span class="sesion"><a href="/benef/servlet/setAccess?opcion=LOGOUT" title="cerrar sesi&oacute;n">log out</a></span>
             </div>
         </td>
     </tr>
</table>

