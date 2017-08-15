<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.*"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<% Usuario usu = (Usuario) session.getAttribute("user"); 
    HtmlBuilder ohtml       = new HtmlBuilder();
    Tablas oTabla = new Tablas ();
    LinkedList lTabla = new LinkedList ();
    %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
</head>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script language='javascript'>
    function Visualizar ( tipo ) {
        if (tipo != "EXCEL") {
            document.form1.action = "<%= Param.getAplicacion()%>consulta/printNomina.jsp";
        }

        document.form1.num_poliza.value = Trim(LTrim(document.form1.num_poliza.value));

        permitidos=/[^0-9.]/;
        if(permitidos.test(document.form1.num_poliza.value)){
            alert("En el número de póliza hay caracteres que no son números, por favor verifique");
            return document.form1.num_poliza.focus();
        }

        document.form1.opcion.value = "getNomina";
        document.form1.formato.value = tipo;
        document.form1.submit();
        return true;
    }

    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

    function VerificarPoliza () {

        document.form1.num_poliza.value = Trim(LTrim(document.form1.num_poliza.value));

        if (document.form1.num_poliza.value == "" ||
            document.form1.num_poliza.value == 0) {
            alert ("Número de póliza invalido ");
            return false;
        }

        permitidos=/[^0-9.]/;
        if(permitidos.test(document.form1.num_poliza.value)){
            alert("En el número de póliza hay caracteres que no son números, por favor verifique");
            return document.form1.num_poliza.focus();
        }

        var sUrl = "<%= Param.getAplicacion()%>certificado/PopUpPoliza.jsp?num_poliza=" +
            document.form1.num_poliza.value + "&cod_rama=" + document.form1.cod_rama.value ;
        var W = 400;
        var H = 260;

        AbrirPopUp (sUrl, W, H);
        return true;
    }

</script>
<body>
    <table cellSpacing="0" cellPadding="0" width="960" align="center" border="0">
        <tr>
            <td>
                <jsp:include page="/header.jsp">
                    <jsp:param name="aplicacion" value="<%= Param.getAplicacion() %>" />
                    <jsp:param name="usuario" value="<%= usu.getusuario() %>" />
                    <jsp:param name="descripcion" value="<%= usu.getRazonSoc() %>" />
                </jsp:include>
                <div class="menu">
                    <menu:renderMenuFromDB    aplicacion="1"  userLogon="<%= usu.getusuario()%>" />
                </div>
            </td>
        </tr>
    <tr>
        <td align="center" valign="top" width='100%'>
            <form method="post" action="<%= Param.getAplicacion()%>servlet/ConsultaServlet" name='form1' id='form1'>
            <input type="hidden" name="opcion" id="opcion" value="getNomina">
            <input type="hidden" name="formato" id="formato" value="HTML">
            <table width='500' cellpadding='0' cellspacing='1' border='0' align="center" class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                <tr>
                    <td width='100%' height='30' align="center" class='titulo'>CONSULTA DE NOMINA DE POLIZA</td>
                </tr>
<%          if (usu.getiCodTipoUsuario() != 0) {
    %>
                <tr>
                    <td width='100%' align="left" class='subtitulo'>
                    Sr. productor, ingrese la póliza la cual desea consultar la nómina.<br>
                    Recuerde que si la misma regsitra deuda no podrá consultarla.
                    </td>
                </tr>
<%          }
    %>
                <tr>
                    <td align="center" valign="top">
                        <table border='0' align="center" cellpadding='1' cellspacing='1'>
                            <tr> 
                                <td align="left"  class="text" valign="top" >Rama:&nbsp;</td>
                                <td align="left"  class="text">
                                    <SELECT name="cod_rama" id="cod_rama"   class="select">
    <%                                  lTabla = oTabla.getRamas ();
                                        out.println(ohtml.armarSelectTAG(lTabla)); 
    %>
                                    </select>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <input type="button" name="cmdVerificar" value="Verificar si existe la p&oacute;liza" class="boton" onClick="VerificarPoliza ();" >
                                </td>
                             </tr>
                             <tr>
                                <td align="left"  class="text" valign="top">&nbsp;&nbsp;P&oacute;liza:&nbsp;<br></td>
                                <td align="left"  class="text"><input name="num_poliza" id="num_poliza"  size='12' maxlength='12'  value=""  onkeypress="return Mascara('D',event);" class="inputTextNumeric">
                                    <SPAN style="color:red">ATENCI&Oacute;N:</span> Ingrese el n&uacute;mero de p&oacute;liza sin el digito verificador
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                     <td align="left"  class="subtitulo" >Seleccione como desea visualizar la nómina:</td>
                </tr>
                <tr>
                    <td align="center">
                        <table border='0' align="center" cellpadding='1' cellspacing='1'>
                            <tr>
                                <td width='34%' align="center"> 
                                    <IMG src='<%= Param.getAplicacion()%>images/HTML.gif' border='0' align="center">
                                </td>
                                <td width='33%' align="center">  
                                    <IMG src='<%= Param.getAplicacion()%>images/PDF.gif' border='0' align="botom">
                                </td>
                                <td width='34%' align="center">  
                                    <IMG src='<%= Param.getAplicacion()%>images/XLS.gif' border='0' align="botom">
                                </td>
                            </tr>
                            <tr>
                                <td align="center">
                                    <input type="button" name="cmdHTML" value="página web (HTML)" height="20px" class="boton" onclick="Visualizar('HTML');">
                                </td>
                                <td align="center">
                                    <input type="button" name="cmdHTML" value="acrobat reader (PDF)" height="20px" class="boton" onclick="Visualizar('PDF');">
                                </td>
                                <td align="center">
                                    <input type="button" name="cmdHTML" value="exportar a excel (XLS)" height="20px" class="boton" onclick="Visualizar('EXCEL');">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="center">  
                        <input type="button" name="cmdSalir" value=" Salir " height="20px" class="boton" onClick="Salir();">
                    </td>
                </tr>
            </table>
            </form>
        </td>
    </tr>
    <tr><td height='100%'>&nbsp;</td></tr>
    <tr>
        <td width='100%' valign="bottom">
            <jsp:include flush="true" page="/bottom.jsp"/>
        </td>
    </tr>
</table>
<script>
CloseEspere();
</script>
</body>
</html>
