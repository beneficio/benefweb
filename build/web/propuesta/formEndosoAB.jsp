<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Propuesta"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<% Usuario usu = (Usuario) session.getAttribute("user"); 
    HtmlBuilder ohtml       = new HtmlBuilder();
    Tablas oTabla = new Tablas ();
    LinkedList lTabla = new LinkedList ();
    Propuesta oProp = (Propuesta) request.getAttribute ("propuesta");
    if (oProp == null) {
        oProp = new Propuesta ();
    }
    %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
</head>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<SCRIPT type="" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script language='javascript'>
    function Grabar () {
            document.form1.opcion.value = "getPolEnd";
            document.form1.submit();
            return true;
    }

    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }
    function VerificarPoliza () {
        if (document.form1.num_poliza.value == "" ||
            document.form1.num_poliza.value == 0) {
            alert ("Número de póliza invalido ");
            return false;
        }

        var sUrl = "<%= Param.getAplicacion()%>certificado/PopUpPoliza.jsp?num_poliza=" +
            document.form1.num_poliza.value + "&cod_rama=" + document.form1.cod_rama.value ;
        var W = 400;
        var H = 260;

        AbrirPopUp (sUrl, W, H);
        return true;
    }

    function Buscar () {
        document.form1.submit();
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
        <td align="center" valign="top" width='100%' height='100%'>
            <table width='500' cellpadding='0' cellspacing='1' border='0' align="center" class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                <tr>
                    <td width='100%' height='30' align="center" class='titulo'>ENDOSOS DE ALTA Y BAJA DE ASEGURADOS</td>
                </tr>
                <tr>
                    <td width='100%' align="left" class='subtitulo'>
                    Sr. productor, ingrese la póliza a endosar. Recuerde que solo podrá hacer endosos de alta y baja de asegurados. 
                    </td>
                </tr>
                <tr>
                    <td align="center" valign="top">
                        <form method="post" action="<%= Param.getAplicacion()%>servlet/EndosoServlet" name='form1' id='form1'>
                        <input type="hidden" name="opcion" id="opcion" value="getPolEnd">
                        <input type="hidden" name="num_propuesta" id="num_propuesta" value="<%= oProp.getNumPropuesta () %>">
                        <table border='0' align="center" cellpadding='1' cellspacing='1'>
                            <tr> 
                                <td colspan='2' height='90' align="left" valign="top" width='100%'>
                                    <table border='0' align="top" cellpadding='1' cellspacing='0' height="90" width='100%'>
                                        <tr>
                                            <td align="left"  class="text" valign="top" >Rama:&nbsp;</td>
                                            <td align="left"  class="text">
                                                <SELECT name="cod_rama" id="cod_rama"   class="select">
<%                                               lTabla = oTabla.getRamas ();
                                             out.println(ohtml.armarSelectTAG(lTabla, oProp.getCodRama())); 
%>
                                                </select>
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td align="left"  class="text" valign="top">&nbsp;&nbsp;P&oacute;liza:&nbsp;</td>
                                            <td align="left"  class="text"><input name="num_poliza" id="num_poliza"  size='12' maxlength='12'  value="<%= oProp.getNumPoliza ()%>"  onkeypress="return Mascara('D',event);" class="inputTextNumeric">
                                            <SPAN style="color:red">ATENCI&Oacute;N:</span> Ingrese el n&uacute;mero de p&oacute;liza sin el digito verificador
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="center"  colspan='4' width='100%' height='25' valign="middle">
                                                <input type="button" name="cmdVerificar" value="Verificar si existe la p&oacute;liza" class="boton" onClick="VerificarPoliza ();" >
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        </form>
                    </td>
                </tr>
                <tr>
                    <td align="center">  
                        <input type="button" name="cmdSalir" value=" Salir " height="20px" class="boton" onClick="Salir();">&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button" name="cmdGrabar" value=" Enviar " height="20px" class="boton" onClick="Grabar();">
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td width='100%'>
            <jsp:include flush="true" page="/bottom.jsp"/>
        </td>
    </tr>
</table>
<script>
    CloseEspere();
</script>
</body>
</html>
