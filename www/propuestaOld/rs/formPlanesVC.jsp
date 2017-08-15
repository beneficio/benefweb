<%@page contentType="text/html" errorPage="/error.jsp"%>
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
    HtmlBuilder ohtml = new HtmlBuilder();

   int codRama    = (request.getParameter("cod_rama")     == null ? -1 : Integer.parseInt (request.getParameter("cod_rama"))); 
   int codSubRama = (request.getParameter("cod_sub_rama") == null ? -1 : Integer.parseInt (request.getParameter("cod_sub_rama"))); 
   int codPlan    = (request.getParameter("cod_plan")     == null ? -1 : Integer.parseInt (request.getParameter("cod_plan"))); 
   int codProd =    (request.getParameter("cod_prod")     == null ? -1 : Integer.parseInt (request.getParameter("cod_prod"))); 
   int iCodVigencia = (request.getParameter("prop_vig")   == null ? 6 : Integer.parseInt (request.getParameter("prop_vig")));
   int iCodProducto = (request.getParameter("prop_cod_producto")   == null ? 0 : Integer.parseInt (request.getParameter("prop_cod_producto")));

   String sCond = "";
   String sMed = "";
   int iCantCuotas = 1;
   LinkedList  lTabla = new LinkedList ();
   Tablas      oTabla = new Tablas ();
   %>
<head>
<LINK rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/main.css">
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<SCRIPT  language="javascript">
    var navegador = navigator.appCodeName;
    var cod_rama = <%= codRama %>;
     
    function DoChangePlanes() {
        cod_plan     = document.formPlan.prop_plan.options[ document.formPlan.prop_plan.selectedIndex ].value; 
        document.getElementById ('prop_condiciones').value = document.getElementById ('hidden_cond' + cod_plan ).value;
        document.getElementById ('prop_seguridad').value   = document.getElementById ('hidden_med' + cod_plan ).value;
        document.getElementById ('prop_vig').value         = document.getElementById ('hidden_vig' + cod_plan  ).value;
        document.getElementById ('prop_cant_cuotas').value = document.getElementById ('hidden_cuotas' + cod_plan  ).value;
        document.getElementById ('prop_cod_producto').value = document.getElementById ('hidden_producto' + cod_plan  ).value;
        
        doChangeCobertura ();
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
<table border='0' align='left' class="fondoForm" width='100%' height="100%" >
    <tr>
        <TD width='11' >&nbsp;</TD>
        <TD align="left"  class="text" valign="top" nowrap width="150px" >Seleccione un Plan:</TD>
        <td align="left"  class="text" valign="top" width='700px'>
            <SELECT name="prop_plan" id="prop_plan" style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size:11px;font-weight:normal;text-decoration: none;width:350px;height:18px"
            ONCHANGE="javascript:DoChangePlanes();" onkeydown="javascript:DoChangePlanes();" onkeyup="javascript:DoChangePlanes();">

<% 
   try {
        String sMens = ""; 
        LinkedList lPlanes = oTabla.getPlanes(codRama,codSubRama,codProd, usu.getusuario());
        if (lPlanes.size () == 0) {
            if (codProd == 0)  {
                sMens = "Debe seleccionar un productor";
            } else if (codSubRama == -1) {
                        sMens = "Debe seleccionar una sub Rama";
                    } else if (codPlan == -1) {
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
                }
     %>
              <option value="<%= oPlan.getcodPlan()%>" <%= (oPlan.getcodPlan () == codPlan ? "selected" : " ")%> ><%= oPlan.getdescripcion()%></option>
<%
            }
   %>
            <input type="hidden" name="hidden_cond-1" id="hidden_cond-1" value=" ">  
            <input type="hidden" name="hidden_med-1" id="hidden_med-1" value=" ">  
            <input type="hidden" name="hidden_vig-1" id="hidden_vig-1" value="6">  
            <input type="hidden" name="hidden_cuotas-1" id="hidden_cuotas-1" value="1">
            <input type="hidden" name="hidden_producto-1" id="hidden_producto-1" value="0">

<%          for (int ii =0; ii < lPlanes.size (); ii++) {
                Plan oPlan = (Plan) lPlanes.get(ii);
     %>
            <input type="hidden" name="hidden_cond<%= oPlan.getcodPlan()%>" id="hidden_cond<%= oPlan.getcodPlan()%>" value="<%= oPlan.getcondiciones()%>">  
            <input type="hidden" name="hidden_med<%= oPlan.getcodPlan()%>" id="hidden_med<%= oPlan.getcodPlan()%>" value="<%= oPlan.getmedidaSeg()%>">  
            <input type="hidden" name="hidden_vig<%= oPlan.getcodPlan()%>" id="hidden_vig<%= oPlan.getcodPlan()%>" value="<%= oPlan.getcodVigencia()%>">  
            <input type="hidden" name="hidden_cuotas<%= oPlan.getcodPlan()%>" id="hidden_cuotas<%= oPlan.getcodPlan()%>" value="<%= oPlan.getcantMaxCuotas()%>">
            <input type="hidden" name="hidden_producto<%= oPlan.getcodPlan()%>" id="hidden_producto<%= oPlan.getcodPlan()%>" value="<%= oPlan.getcodProducto()%>">

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
            <TD align="left"  class="text" valign="top" >Condiciones del plan:&nbsp;</TD>
            <TD align="left"  class="text" valign="top">
                <TEXTAREA cols='100' rows='4' name="prop_condiciones" id="prop_condiciones" class="text" readonly><%= sCond%></TEXTAREA>
            </TD>   
        </tr>
        <tr>
            <TD width='15'>&nbsp;</TD>
            <TD align="left"  class="text" valign="top" >Medidas de seguridad:</TD>
            <TD align="left"  class="text" valign="top">
                <TEXTAREA cols='100' rows='12' name="prop_seguridad" id="prop_seguridad" class="text" readonly><%= sMed %></TEXTAREA>
            </TD>   
        </tr>
        <TR>
            <td width='15'>&nbsp;</td>
            <TD align="left" class='text'>Periodo de Vigencia:</TD>
            <TD align="left" class='text'>
                <SELECT name="prop_vig" id="prop_vig" class="select" STYLE="WIDTH:120px" disabled>
                    <option value='7' <%= (iCodVigencia == 7 ? "selected" : "  ") %>>Periodo corto</option>
<%         
                      lTabla = oTabla.getDatosOrderByDesc ("VIGENCIA");
                      out.println(ohtml.armarSelectTAG(lTabla,  String.valueOf(iCodVigencia)));
    %>
                </SELECT>
            </TD>    
         </TR>

    </table>
    <input type="hidden" name="prop_cod_producto" id="prop_cod_producto"  value="<%= iCodProducto %>">
    <input type="hidden" name="prop_cant_cuotas" id="prop_cant_cuotas"  value="<%= iCantCuotas %>">
</form>
</body>
<script>
   doChangeCobertura ();
</script>
