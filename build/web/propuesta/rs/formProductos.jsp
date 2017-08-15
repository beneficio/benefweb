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
   int codRama      = (request.getParameter("cod_rama")     == null ? -1 : Integer.parseInt (request.getParameter("cod_rama"))); 
   int codSubRama   = (request.getParameter("cod_sub_rama") == null ? -1 : Integer.parseInt (request.getParameter("cod_sub_rama"))); 
   int codProducto  = (request.getParameter("cod_producto") == null ? -1 : Integer.parseInt (request.getParameter("cod_producto")));
   int codProd      = (request.getParameter("cod_prod")     == null ? 0  : Integer.parseInt (request.getParameter("cod_prod"))); 
   LinkedList lProductos = new LinkedList ();
   Tablas      oTabla   = new Tablas ();

 //  System.out.println ("formProductos:" + codRama +  " " + codSubRama +  " " + codProducto +  " " + codProd );

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
   <input type="hidden" name="prod_tipo_nomina_-1" id="prod_tipo_nomina_-1" value="S">
   <input type="hidden" name="prod_nivel_cob_-1" id="prod_nivel_cob_-1" value=" ">
   <input type="hidden" name="prod_existe_subseccion_-1" id="prod_existe_subseccion_-1" value="S">
   <input type="hidden" name="prod_tipo_nomina_0" id="prod_tipo_nomina_0" value="S">
   <input type="hidden" name="prod_nivel_cob_0" id="prod_nivel_cob_0" value=" ">
   <input type="hidden" name="prod_existe_subseccion_0" id="prod_existe_subseccion_0" value="S">

    <SELECT name="cod_producto" id="cod_producto" onchange="javascript:DoChangeProductos();"
            style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size:11px;font-weight:normal;text-decoration: none; width:350; height:20;"
     onkeydown="javascript:DoChangeProductos();" onkeyup="javascript:DoChangeProductos();">

<% 
   try {
        String sMens = ""; 
        lProductos = oTabla.getProductos (codRama, codSubRama, codProd, usu.getusuario());
        if (lProductos.size () == 0) {
            if (codProd == 0)  {
                sMens = "Debe seleccionar un productor";
            } else if (codSubRama == -1) {
                        sMens = "Debe seleccionar una subrama";
                    } else if (codProducto == -1) {
                                sMens = "Lista de productos";
                            } else { sMens = "No existen productos para la rama/subrama"; }
%>
              <option value="-1"><%= sMens %></option>
<%      } else {
            if (lProductos.size () > 1) {
  %>
              <option value="-1">Seleccione Producto </option>
<%          }
            for (int i =0; i < lProductos.size (); i++) {
                Producto oProducto = (Producto) lProductos.get(i);
     %>
              <option value="<%= oProducto.getcodProducto()%>" <%= (oProducto.getcodProducto () == codProducto ? "selected" : " ")%> ><%= oProducto.getdescProducto()%></option>

<%
            }
            for (int ii =0; ii < lProductos.size (); ii++) {
                Producto oProducto = (Producto) lProductos.get(ii);
     %>
        <input type="hidden" name="prod_tipo_nomina_<%= oProducto.getcodProducto() %>" id="prod_tipo_nomina_<%= oProducto.getcodProducto() %>"
               value="<%= oProducto.gettipoNomina() %>">
        <input type="hidden" name="prod_nivel_cob_<%= oProducto.getcodProducto() %>" id="prod_nivel_cob_<%= oProducto.getcodProducto() %>"
               value="<%= oProducto.getNivelCob() %>">
        <input type="hidden" name="prod_existe_subseccion_<%= oProducto.getcodProducto() %>" id="prod_existe_subseccion_<%= oProducto.getcodProducto() %>"
               value="<%= oProducto.getexisteSubSeccion() %>">
        
<%         }
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