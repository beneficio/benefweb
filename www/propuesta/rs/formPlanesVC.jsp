<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Plan"%>
<%@page import="java.util.LinkedList"%>   

<%
   Usuario usu = (Usuario) session.getAttribute("user");     
   int codRama    = (request.getParameter("cod_rama")     == null ? -1 : Integer.parseInt (request.getParameter("cod_rama"))); 
   int codSubRama = (request.getParameter("cod_sub_rama") == null ? -1 : Integer.parseInt (request.getParameter("cod_sub_rama"))); 
   int codPlan    = (request.getParameter("cod_plan")     == null ? -1 : Integer.parseInt (request.getParameter("cod_plan"))); 
   int codProd =    (request.getParameter("cod_prod")     == null ? -1 : Integer.parseInt (request.getParameter("cod_prod"))); 
   int iCodVigencia = (request.getParameter("prop_vig")   == null ? 6 : Integer.parseInt (request.getParameter("prop_vig")));
   int iCodProducto = (request.getParameter("prop_cod_producto")   == null ? 0 : Integer.parseInt (request.getParameter("prop_cod_producto")));

   String sCond = "";
   String sMed = "";
   int codAmbito = 0;
   int iCantCuotas = 1;
   Tablas      oTabla = new Tablas ();
   %>
<head>
<LINK rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/main.css">
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<SCRIPT type="text/javascript" language="JavaScript" >
    var navegador =  BrowserDetect.browser;
    var cod_rama = <%= codRama %>;
     
    function DoChangePlanes() {
        cod_plan     = document.formPlan.prop_plan.options[ document.formPlan.prop_plan.selectedIndex ].value; 
        document.getElementById ('prop_condiciones').value = "Condiciones del Plan: " + document.getElementById ('hidden_cond' + cod_plan ).value +
            "\n" + "\n" + "Medidas de Seguridad: " + document.getElementById ('hidden_med' + cod_plan ).value;
//        document.getElementById ('prop_seguridad').value   = document.getElementById ('hidden_med' + cod_plan ).value;
//        document.getElementById ('prop_vig').value         = document.getElementById ('hidden_vig' + cod_plan  ).value;
//        document.getElementById ('prop_cant_cuotas').value = document.getElementById ('hidden_cuotas' + cod_plan  ).value;
        document.getElementById ('prop_cod_producto').value = document.getElementById ('hidden_producto' + cod_plan  ).value;
        document.getElementById ('prop_subrama').value = document.getElementById ('hidden_subrama' + cod_plan  ).value;
        document.getElementById ('prop_cod_ambito').value = document.getElementById ('hidden_cod_ambito' + cod_plan  ).value;

        if (navegador == 'Mozilla' || navegador == 'Firefox') {
          window.parent.DoChangeCoberturasByPlan ();

        } else {
           window.parent.DoChangeCoberturasByPlan (document.getElementById ('formPlan'));
        }

//        doChangeCobertura ();
    }

    function doChangeCobertura () {
        if (navegador == 'Mozilla') {
          window.parent.DoChangeCoberturasByPlan ();

        } else {
           window.parent.DoChangeCoberturasByPlan (document.getElementById ('formPlan'));
        }
    }

</SCRIPT>
</head>
<body >
<form name="formPlan" id="formPlan"  method="POST">
<table border='0' align='left' class="fondoForm" width='100%'>
    <tr>
        <TD width='10' >&nbsp;</TD>
        <TD align="left"  class="text" valign="middle" nowrap width="110" height="30">Seleccione un Plan:</TD>
        <td align="left"  class="text" valign="middle" >&nbsp;
            <SELECT name="prop_plan" id="prop_plan" style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size:11px;font-weight:normal;text-decoration: none;width:530px;height:22px"
                    onchange="javascript:DoChangePlanes();" onkeydown="javascript:DoChangePlanes();" onkeyup="javascript:DoChangePlanes();">

<% 
   try {
        String sMens = ""; 
        LinkedList lPlanes = oTabla.getPlanes(codRama,codSubRama,codProd, usu.getusuario());
        if (lPlanes.size () == 0) {
            if (codProd == 0)  {
                sMens = "Debe seleccionar un productor";
            } else  if (codPlan == -1) {
                                sMens = "Lista de planes especiales"; 
                            } else { sMens = "No existen planes especiales"; }
%>
              <option value="-1"><%= sMens %></option>
<%      } else {
  %>
              <option value="-1">Planes especiales de la sub rama</option>
<%           for (int i =0; i < lPlanes.size (); i++) {
                Plan oPlan = (Plan) lPlanes.get(i);
                if (oPlan.getcodPlan () == codPlan) {
                    sCond        = oPlan.getcondiciones();
                    sMed         = oPlan.getmedidaSeg();
                    iCodVigencia = oPlan.getcodVigencia();
                    iCantCuotas  = oPlan.getcantMaxCuotas();
                    codAmbito    = oPlan.getcodAmbito();

                }
     %>
              <option value="<%= oPlan.getcodPlan()%>" <%= (oPlan.getcodPlan () == codPlan ? "selected" : " ")%> ><%= oPlan.getdescripcion()%></option>
<%
            }
   %>
            <input type="hidden" name="hidden_cond-1" id="hidden_cond-1" value=" ">  
            <input type="hidden" name="hidden_med-1" id="hidden_med-1" value=" ">  
            <input type="hidden" name="hidden_vig-1" id="hidden_vig-1" value="6">  
            <input type="hidden" name="hidden_producto-1" id="hidden_producto-1" value="0">
            <input type="hidden" name="hidden_subrama-1" id="hidden_subrama-1" value="0">
            <input type="hidden" name="hidden_cod_ambito-1" id="hidden_cod_ambito-1" value="0">

<%          for (int ii =0; ii < lPlanes.size (); ii++) {
                Plan oPlan = (Plan) lPlanes.get(ii);
     %>
            <input type="hidden" name="hidden_cond<%= oPlan.getcodPlan()%>" id="hidden_cond<%= oPlan.getcodPlan()%>" value="<%= oPlan.getcondiciones()%>">  
            <input type="hidden" name="hidden_med<%= oPlan.getcodPlan()%>" id="hidden_med<%= oPlan.getcodPlan()%>" value="<%= oPlan.getmedidaSeg()%>">  
            <input type="hidden" name="hidden_vig<%= oPlan.getcodPlan()%>" id="hidden_vig<%= oPlan.getcodPlan()%>" value="<%= oPlan.getcodVigencia()%>">  
            <input type="hidden" name="hidden_producto<%= oPlan.getcodPlan()%>" id="hidden_producto<%= oPlan.getcodPlan()%>" value="<%= oPlan.getcodProducto()%>">
            <input type="hidden" name="hidden_subrama<%= oPlan.getcodPlan()%>" id="hidden_subrama<%= oPlan.getcodPlan()%>" value="<%= oPlan.getcodSubRama()%>">
            <input type="hidden" name="hidden_cod_ambito<%= oPlan.getcodPlan()%>" id="hidden_cod_ambito<%= oPlan.getcodPlan() %>" value="<%= oPlan.getcodAmbito() %>">

<%
            }
        }        
    } catch (Exception e) { 
        response.sendRedirect("/error.jsp");
    }
%>
                </SELECT>
            </td>
        </tr>
        <tr>
            <TD width='15'>&nbsp;</TD>
            <TD align="left"  class="text" valign="top" colspan="2">
                <TEXTAREA cols='126' rows='12' name="prop_condiciones" id="prop_condiciones" class="text" readonly>
Condiciones del plan: <%= sCond%>
Medidas de seguridad: <%= sMed %>
                </TEXTAREA>
            </TD>
        </tr>           
    </table>
    <input type="hidden" name="prop_subrama" id="prop_subrama"  value="<%= codSubRama %>">
    <input type="hidden" name="prop_cod_producto" id="prop_cod_producto"  value="<%= iCodProducto %>">
    <input type="hidden" name="prop_cod_ambito" id="prop_cod_ambito"  value="<%= codAmbito %>">
</form>
</body>
<%--<script>
   doChangeCobertura ();
</script>
--%>
