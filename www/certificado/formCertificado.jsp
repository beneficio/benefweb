<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Certificado"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Clausula"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<% Usuario usu = (Usuario) session.getAttribute("user"); 
    HtmlBuilder ohtml       = new HtmlBuilder();
    Tablas oTabla = new Tablas ();
    LinkedList lTabla = new LinkedList ();
    Certificado oCert = (Certificado) request.getAttribute ("certificado");
    if (oCert == null) {
        oCert = new Certificado ();
    }
    oCert.setcantMaxClausulas ( Integer.parseInt(Dbl.DbltoStr(ConsultaMaestros.getParametro( 10 , 9),0)));

    %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<script type="text/javascript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script type="text/javascript">
    function Grabar () {

        var poliza    = LTrim(Trim(document.form1.num_poliza.value));

        if ( poliza == "" || poliza == 0) {
            alert ("Número de póliza invalido ");
            return false;
        }
        permitidos=/[^0-9.]/;
        if(permitidos.test(poliza)){
            alert("En la celda número de póliza hay caracteres que no son números, por favor verifique");
            return document.form1.num_poliza.focus();
        }

        document.form1.num_poliza.value = poliza;
        document.form1.opcion.value = "addCertificado";
        document.form1.descEnvio.value = 'No deseo recibirlo';
        document.form1.submit();
        return true;
    }

    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }
    function VerificarPoliza () {
        var poliza    = LTrim(Trim(document.form1.num_poliza.value));

        if ( poliza == "" || poliza == 0) {
            alert ("Número de póliza invalido ");
            return false;
        }
        permitidos=/[^0-9.]/;
        if(permitidos.test(poliza)){
            alert("En la celda número de póliza hay caracteres que no son números, por favor verifique");
            return document.form1.num_poliza.focus();
        }

        document.form1.num_poliza.value = poliza;

        var sUrl = "<%= Param.getAplicacion()%>certificado/PopUpPoliza.jsp?num_poliza=" +
            document.form1.num_poliza.value + "&cod_rama=" + document.form1.cod_rama.value ;
        var W = 550;
        var H = 450;

        AbrirPopUp (sUrl, W, H);
        return true;
    }

    function ModificarClausulas () {
        var poliza    = LTrim(Trim(document.form1.num_poliza.value));

        if ( poliza == "" || poliza == 0) {
            alert ("Número de póliza invalido ");
            return false;
        }
        permitidos=/[^0-9.]/;
        if(permitidos.test(poliza)){
            alert("En la celda número de póliza hay caracteres que no son números, por favor verifique");
            return document.form1.num_poliza.focus();
        }

        document.form1.num_poliza.value = poliza;

        if (document.form1.cod_rama.value !== "10") {
            alert ("La actualización de clausulas es solo para las ramas Accidentes Personales ");
            return false;
        }

        var sUrl = "<%= Param.getAplicacion()%>certificado/PopUpClausulas.jsp?num_poliza=" +
            document.form1.num_poliza.value + "&cod_rama=" + document.form1.cod_rama.value ;
        var W = 620;
        var H = 550;

        AbrirPopUp (sUrl, W, H);
        return true;
    }

    function CargarClausulas ( form2 ) {
         document.getElementById ('cla_no_repeticion').value  = form2.cla_no_repeticion.value;
         document.getElementById ('cla_subrogacion').value    = form2.cla_subrogacion.value;
         document.getElementById ('actualiza_cla').value      = form2.actualiza_cla.value;
         document.getElementById ('cant_max_clausulas').value = form2.cant_max_clausulas.value;
         for (var i = 0; i < form2.elements.length; i++) {
            var obj = form2.elements.item(i);
            if ((typeof(obj) == "object") && 
            ( obj.name.match(/^CLA_DESCRIPCION./) || obj.name.match(/^CLA_ITEM./) || obj.name.match(/^CLA_CUIT./) || obj.name.match(/^cla_./)) 
             && Trim (obj.value).length > 0 ) {
                document.getElementById ( obj.name ).value = obj.value;
            }
          }
        return true;
    }

    function CargarClausulas2 ( form2 ) {
         document.getElementById ('cla_no_repeticion').value  = form2.cla_no_repeticion.value;
         document.getElementById ('cla_subrogacion').value    = form2.cla_subrogacion.value;
         document.getElementById ('actualiza_cla').value      = form2.actualiza_cla.value;
         document.getElementById ('cant_max_clausulas').value = form2.cant_max_clausulas.value;
         for (var i = 0; i < form2.elements.length; i++) {
            var obj = form2.elements.item(i);
            if ((typeof(obj) === "object") && 
            ( obj.name.match(/^descripcion./) || obj.name.match(/^cuit./) )
             && Trim (obj.value).length > 0 ) {
                document.getElementById ( obj.name ).value = obj.value;
            }
          }
        return true;
    }

</script>
</head>
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
        <td align="center" valign="top" width='100%' height='330'>
            <table width='90%' cellpadding='0' cellspacing='1' border='0' align="center" class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                <tr>
                    <td width='100%' height='30' align="center" class='titulo'>CERTIFICADO DE COBERTURA</td>
                </tr>
<%          if (usu.getiCodTipoUsuario() != 0) {
    %>
                <tr>
                    <td width='100%' align="left" class='subtitulo'>
                    Sr. productor, si el certificado solicitado es de una p&oacute;liza vigente 
                    podrá visualizarlo/imprimirlo en forma On Line por éste medio.<br/>
                    En cambio si el mismo es de una propuesta, será enviado como usted lo requiera en la solicitud.<br/>
                    Desde el menu de navegación, opción "Certificados" -> "Mis Certificados" podrá visualizar/imprimir las veces que usted quiera
                    los certificados ingresados.
                    </td>
                </tr>
<%          }
    %>
                <tr>
                    <td align="center" valign="top">
                        <form method="post" action="<%= Param.getAplicacion()%>servlet/CertificadoServlet" name='form1' id='form1'>
                        <input type="hidden" name="opcion" id="opcion" value="addCertificado"/>
                        <input type="hidden" name="numCertificado" id="numCertificado" value="<%= oCert.getnumCertificado () %>"/>
                        <input type="hidden" name="descEnvio" id="descEnvio" value="sin informar"/>
                        <input type="hidden" name="recibir_original" id="recibir_original"  value="1"/>
                        <input type="hidden" name="cant_max_clausulas"  id="cant_max_clausulas"  value="0" />
                        <input type="hidden" name="tipo_cert" id="tipo_cert" value='PZ'/>
                        <input type="hidden" value="" name='cla_no_repeticion'  id='cla_no_repeticion'/>
                        <input type="hidden" value="" name='cla_subrogacion'  id='cla_subrogacion'/>
                        <input type="hidden" value="N" name='actualiza_cla'  id='actualiza_cla'/>

                        <table border='0' align="center" cellpadding='1' cellspacing='1'>
                            <tr> 
                                <td colspan='2' height='120' align="left" valign="top" width='100%'>
                                    <table border='0' align="top" cellpadding='1' cellspacing='0' height="120" width='100%'>
                                        <tr>
                                            <td align="left"  class="text" valign="top" >Rama:&nbsp;</td>
                                            <td align="left"  class="text">
                                                <select name="cod_rama" id="cod_rama"   class="select">
<%                                               lTabla = oTabla.getRamas ();
                                             out.println(ohtml.armarSelectTAG(lTabla, 10));
%>
                                                </select>
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td align="left"  class="text" valign="top" height="40">&nbsp;&nbsp;P&oacute;liza:&nbsp;</td>
                                            <td align="left"  class="text"><input name="num_poliza" id="num_poliza"  size='12' maxlength='12'  value="<%= oCert.getnumPoliza ()%>"  onkeypress="return Mascara('D',event);" class="inputTextNumeric">
                                                &nbsp;&nbsp;&nbsp;
                                                <input type="button" name="cmdVerificar" value="Consultar póliza" class="boton" onClick="VerificarPoliza ();" />
                                                <br/><span style="color:red">ATENCI&Oacute;N:</span> Ingrese el n&uacute;mero de p&oacute;liza sin el digito verificador
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="left"  class="text" colspan='4'>Para ser presentado ante:&nbsp;
                                            <input name="presentar" id="presentar" size='47' maxlength='250' />
                                            </td>
                                        </tr>
                        <%--
                                        <tr>
                                            <td align="left"  class="text" colspan='4'>Modo de visualización:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                <select name="modo_visual" id="modo_visual"  value="<%= oCert.getmodoVisualizacion ()%>"  class="select">
                                                    <option value='2'>Acrobat Reader (PDF)</option>

                                             LinkedList lTabla2 = oTabla.getDatos ("MODO_VISUAL");
                                             out.println(ohtml.armarSelectTAG(lTabla2, String.valueOf(oCert.getmodoVisualizacion ())));
                                                </select>
                                            </td>
                                        </tr>
                        --%>
                        <input type="hidden" name="modo_visual" id="modo_visual" value="2"/>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan='2'>
                                    <table border='1' cellpadding='2' cellspacing='2' width='90%' align="center" style="margin-top:10;margin-bottom:10">
                                        <tr>
                                            <td align="center"  width='100%'  class="text"><b/><span style="color:red">IMPORTANTE:&nbsp;</span>
                                <b><a href="#" onclick="javascript:ModificarClausulas();" >Haga click aqui</a> para consultar, modificar y/o agregar informaci&oacute;n referente a cl&aacute;usulas y
                                empresas asociadas a las mismas.</b>
                                            </td>
                                       </tr>
                                    </table>
                                </td>
                            </tr>
                     
<%                      for (int ii = 1; ii <= oCert.getcantMaxClausulas () ;ii++) {
    %>
                            <input type="hidden" name="CLA_ITEM_<%= ii %>" id="CLA_ITEM_<%= ii %>"/>
                            <input type="hidden" name="CLA_CUIT_<%= ii %>" id="CLA_CUIT_<%= ii %>"/>
                            <input type="hidden" name="CLA_DESCRIPCION_<%= ii %>" id="CLA_DESCRIPCION_<%= ii %>"/>
<%                     }
    %>
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
