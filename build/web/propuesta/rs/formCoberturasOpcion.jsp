<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.CoberturaOpcion"%>
<%@page import="java.util.LinkedList"%>

<%
   Usuario usu = (Usuario) session.getAttribute("user");
   int codCobOpcion = (request.getParameter("cod_cob_opcion") == null ? 0 : Integer.parseInt (request.getParameter("cod_cob_opcion")));
   int codAgrupCob  = (request.getParameter("cod_agrup_cob") == null ? 0 : Integer.parseInt (request.getParameter("cod_agrup_cob")));
   int codRama      = (request.getParameter("cod_rama")     == null ? -1 : Integer.parseInt (request.getParameter("cod_rama"))); 
   int codSubRama   = (request.getParameter("cod_sub_rama") == null ? -1 : Integer.parseInt (request.getParameter("cod_sub_rama"))); 
   int codProducto  = (request.getParameter("cod_producto") == null ? -1 : Integer.parseInt (request.getParameter("cod_producto")));
   int codProd      = (request.getParameter("cod_prod")     == null ? 0  : Integer.parseInt (request.getParameter("cod_prod")));
   String parentesco= request.getParameter ("parentesco");
   int edad         = (request.getParameter("edad")         == null ? -1 : Integer.parseInt (request.getParameter("edad")));
   LinkedList lCob = new LinkedList ();
   Tablas      oTabla   = new Tablas ();

  // System.out.println ("formCob" + codCobOpcion + " " + codRama +  " " + codSubRama +  " " + codProducto +  " " + codProd );

%>
<head>
<LINK rel="stylesheet" type="text/css" href="/css/main.css">
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<SCRIPT  language="javascript">
    var navegador = navigator.appCodeName;

    function DoChangeCoberturas () {

        if (document.getElementById ('cod_cob').value !== '-1') {
            if (document.getElementById('parentesco').value === "TI") {
                if (navegador === 'Mozilla') {
                    window.parent.DoChangeCobTit ();
                } else {
                    window.parent.DoChangeCobTit (document.getElementById ('formCob'));
                }
            }

            if (document.getElementById('parentesco').value === "CO") {
                if (navegador === 'Mozilla') {
                    window.parent.DoChangeCobCony ();
                } else {
                    window.parent.DoChangeCobCony (document.getElementById ('formCob'));
                }
            }
        }
    }
</SCRIPT>
</head>
<body >
<FORM name="formCob" id="formCob"  method="POST">
    <input type="hidden" name="parentesco" id="parentesco" value="<%= parentesco%>">
    <SELECT name="cod_cob" id="cod_cob" ONCHANGE="javascript:DoChangeCoberturas();"
     style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size:11px;font-weight:normal;text-decoration: none;  height:28px;width: 260px;"
     onkeydown="javascript:DoChangeCoberturas();" onkeyup="javascript:DoChangeCoberturas();">

<% 
   try {
        String sMens = ""; 
        lCob = oTabla.getAllCoberturasOpcion (codCobOpcion, codRama, codSubRama, codProducto,
                codProd, parentesco, usu.getusuario(), edad); 
        if (lCob.size () == 0) {
                sMens = "No existen opciones";
%>
              <option value="-1"><%= sMens %></option>
<%      } else {
            if (lCob.size () > 1) {
  %>
              <option value="-1">Seleccione</option>
<%          }
            for (int i =0; i < lCob.size (); i++) {
                CoberturaOpcion oCob = (CoberturaOpcion) lCob.get(i);
     %>
              <option value="<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>"
                      <%= (oCob.getcodAgrupCob() == codAgrupCob && oCob.getcodCobOpcion() == codCobOpcion  ? "selected" : " ")%> ><%= oCob.getdescripcion()%></option>

<%
            }
            if (lCob.size () >0 ) {
                for (int ii =0; ii < lCob.size (); ii++) {
                    CoberturaOpcion oCob = (CoberturaOpcion) lCob.get(ii);
     %>
        <input type="hidden" name="imp_premio_anual_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>"
               id="imp_premio_anual_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>"
               value="<%= Dbl.DbltoStr(oCob.getimpPremioAnual(),2) %>"/>
        <input type="hidden" name="mca_hijos_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>"
               id="mca_hijos_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>"
               value="<%= oCob.getmcaHijos() %>"/>
        <input type="hidden" name="edad_min_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>"
               id="edad_min_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>" value="<%= oCob.getedadMin() %>"/>
        <input type="hidden" name="edad_max_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>"
               id="edad_max_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>" value="<%= oCob.getedadMax() %>"/>
        <input type="hidden" name="edad_permanencia_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>"
               id="edad_permanencia_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>" value="<%= oCob.getedadPermanencia() %>"/>
        <input type="hidden" name="edad_min_hi_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>"
               id="edad_min_hi_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>" value="<%= oCob.getedadMinHi()  %>"/>
        <input type="hidden" name="edad_max_hi_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>"
               id="edad_max_hi_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>" value="<%= oCob.getedadMaxHi() %>"/>
        <input type="hidden" name="edad_permanencia_hi_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>"
               id="edad_permanencia_hi_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>" value="<%= oCob.getedadPermanenciaHi() %>"/>
        <input type="hidden" name="edad_min_ad_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>"
               id="edad_min_ad_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>" value="<%= oCob.getedadMinAd()  %>"/>
        <input type="hidden" name="edad_max_ad_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>"
               id="edad_max_ad_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>" value="<%= oCob.getedadMaxAd() %>"/>
        <input type="hidden" name="edad_permanencia_ad_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>"
               id="edad_permanencia_ad_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>" value="<%= oCob.getedadPermanenciaAd() %>"/>
        <input type="hidden" name="mca_adherente_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>"
               id="mca_adherente_<%= oCob.getcodCobOpcion()%>|<%= oCob.getcodAgrupCob()%>"
               value="<%= oCob.getmcaAdherente() %>"/>


<%              }
            } else {
    %>
        <input type="hidden" name="imp_premio_anual_0|0" id="imp_premio_anual_0\|0"
               value="0">
        <input type="hidden" name="mca_hijos_0|0" id="mca_hijos_0\|0" value="N">
<%          }
       }
    } catch (Exception e) { 
        response.sendRedirect("/error.jsp");
    }
%>
     </SELECT>
</FORM>
     <script>
            DoChangeCoberturas();
     </script>
</body>