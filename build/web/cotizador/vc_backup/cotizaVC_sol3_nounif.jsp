<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Cotizacion"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Generico"%>
<%@page import="java.util.LinkedList"%>
<%
    Cotizacion oCot = (Cotizacion) request.getAttribute("cotizacion");

    %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <script type="text/javascript" language="javascript">
        function Ir (sigte) {
            document.getElementById("siguiente").value = sigte;
            document.form1.submit();
        }
    </script>
    <body>
        <h1>SOLAPA 3 NO UNIFICADA</h1>
        <form name="form1" id="form1" method="post"  action="<%= Param.getAplicacion()%>servlet/CotizadorVCServlet">           
            <input type="hidden" name="opcion"      id="opcion"     value="cotizador"/>
            <input type="hidden" name="siguiente"     id="siguiente"  value="solapa3"/>
            <input type="hidden" name="origen"        id="origen"     value="solapa3"/>
            <input type="hidden" name="COD_RAMA"      id="COD_RAMA"   value="<%= oCot.getcodRama() %>"/>
            <input type="hidden" name="COD_SUB_RAMA"  id="COD_SUB_RAMA"    value="<%= oCot.getcodSubRama() %>"/>
            <input type="text"   name="COD_PRODUCTO"  id="COD_PRODUCTO"  value="<%= oCot.getcodProducto() %>"/>
            <input type="hidden" name="COD_PROVINCIA" id="COD_PROVINCIA" value="<%= oCot.getcodProvincia() %>"/>
            <input type="hidden" name="COD_VIGENCIA"  id="COD_VIGENCIA"  value="<%= oCot.getcodVigencia() %>"/>
            <input type="hidden" name="TOMADOR_APE"   id="TOMADOR_APE"   value="<%= oCot.gettomadorApe() %>"/>
            <input type="hidden" name="COD_PROD"   id="COD_PROD"   value="<%= oCot.getcodProd() %>"/>
            <input type="button" name="atras" id="atras" value="Atras" onclick="javascript:Ir ('solapa2');"/>
            <input type="button" name="recotizar" id="recotizar" value="Recotizar" onclick="javascript:Ir ('solapa3');"/>
        </form>

    </body>
</html>
