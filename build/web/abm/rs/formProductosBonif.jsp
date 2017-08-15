<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Producto"%>
<%@page import="java.util.LinkedList"%>

<%
   Usuario usu = (Usuario) session.getAttribute("user");
   int codRama      = (request.getParameter("cod_rama")     == null ? 10 : Integer.parseInt (request.getParameter("cod_rama"))); 
   int codSubRama   = (request.getParameter("cod_sub_rama") == null ? -1 : Integer.parseInt (request.getParameter("cod_sub_rama"))); 
   int codProducto  = (request.getParameter("cod_producto") == null ? -1 : Integer.parseInt (request.getParameter("cod_producto")));
   LinkedList lProductos = new LinkedList ();
   Tablas      oTabla   = new Tablas ();
   
   System.out.println ("codProducto --> " + codProducto); 
%>
<head>
<LINK rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/main.css">
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<SCRIPT  language="javascript">
    var navegador =  BrowserDetect.browser;
    function DoChangeProductos () {
        if (navegador === 'Mozilla' || navegador === 'Firefox') {
            window.parent.DoChangeProductos ();
        } else {
            window.parent.DoChangeProductos (document.getElementById ('formProducto'));
        }
    }
</SCRIPT>
</head>
<body >
<FORM name="formProducto" id="formProducto"  method="POST">
    <SELECT name="cod_producto" id="cod_producto" onchange="javascript:DoChangeProductos();"
            style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size:11px;font-weight:normal;text-decoration: none; width:500; height:20;"
     onkeydown="javascript:DoChangeProductos();" onkeyup="javascript:DoChangeProductos();">
        <option value="-1" <%= (codSubRama == -1 || codProducto == -1 ? "selected" : "" ) %>><%= (codSubRama == -1 ? "Seleccione Sub Rama" : "Seleccione producto" )%></option>           
        <option value='999' <%= ( codProducto == 999 ? "selected" : "" ) %> >TODOS LOS PRODUCTOS</option> 
<% 
   try { 
        lProductos = oTabla.getProductosAbm (codRama, codSubRama, usu.getusuario());
        if (lProductos.size () != 0) {
            for (int i =0; i < lProductos.size (); i++) {
                Producto oProducto = (Producto) lProductos.get(i);
     %>
            <option value="<%= oProducto.getcodProducto()%>" <%= (oProducto.getcodProducto () == codProducto ? "selected" : " ")%> ><%= oProducto.getdescProducto()%></option>

<%
            }
        }
    } catch (Exception e) { 
        response.sendRedirect("/error.jsp");
    }
%>
     </SELECT>
</FORM>
</body>
<script>
    DoChangeProductos ();
</script>