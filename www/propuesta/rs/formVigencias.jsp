<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.beans.Vigencia"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.sql.Connection"%>
<% 
    LinkedList lVig  = new LinkedList ();
    int cantVidas    = (request.getParameter ("cantVidas")   == null ? 0 : Integer.parseInt(request.getParameter ("cantVidas")));
    int codRama      = (request.getParameter ("cod_rama")    == null ? 10 : Integer.parseInt (request.getParameter ("cod_rama")));
    int codSubRama   = (request.getParameter ("cod_sub_rama")== null ? 2 : Integer.parseInt (request.getParameter ("cod_sub_rama")));
    int codPlan      = (request.getParameter ("cod_plan")    == null ? -1 : Integer.parseInt(request.getParameter ("cod_plan")));
    int codProducto  = (request.getParameter ("cod_producto")== null ? 0 : Integer.parseInt(request.getParameter ("cod_producto")));
    String tipoNomina   = (request.getParameter ("tipo_nomina") == null ? "S" : request.getParameter ("tipo_nomina"));
    int iCodVigencia  = (request.getParameter ("vig")        == null ? 0 : request.getParameter ("vig").equals ("") ? 0 : Integer.parseInt (request.getParameter ("vig")));
    int iNumCot      = (request.getParameter ("nro_cot")     == null ? 0 : Integer.parseInt(request.getParameter ("nro_cot")));

    Connection dbCon = null;
    if (codSubRama > 0 && codProducto > 0)  {     
        try {

            dbCon = db.getConnection();
            lVig  = ConsultaMaestros.getAllVigencias(dbCon, codRama, codSubRama, codProducto, codPlan);

          //  System.out.println ("vigencia size " + lVig.size());

        } catch (Exception e) {
            throw new SurException(e.getMessage());
        } finally {
             db.cerrar(dbCon);
        }
    }
   %>
<head>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css">
<link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>css/Tablas.css">
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript">
    var navegador =  BrowserDetect.browser;
    var codPlan    = <%= codPlan %>;

    function SetearVigencia () {

            document.getElementById ('prop_cant_cuotas_vig').value =
            document.getElementById ('prop_cant_cuotas_vig' + document.getElementById ('prop_vig').value ).value;

            if (navegador == 'Mozilla' || navegador == 'Firefox') {
              window.parent.DoChangeVigencia ();
            } else {
               window.parent.DoChangeVigencia (document.getElementById ('formFact'));
            }
            return true;
    }
</script>
</head>
<table border='0' width="100%" cellpadding="0" cellspacing="0" >
<form name="formFact" id="formFact"  method="post">
    <input type="hidden" name="prop_tipo_nomina" id="prop_tipo_nomina" value="<%= tipoNomina%>">
    <input type="hidden" name="prop_cant_cuotas_vig" id="prop_cant_cuotas_vig" value="0">
    <input type="hidden" name="prop_nro_cot" id="prop_nro_cot" value="<%= iNumCot %>">
<%      if(tipoNomina.equals ("S")) {
    %>
        <tr>
            <td class="text" align="left" width="125">&nbsp;Cantidad de asegurados:</td>
            <td class="text" align="left">
                <input type="text" name="prop_cantVidas" id="prop_cantVidas"
                       value="<%= cantVidas %>" size="5" maxlength="3"
                       onKeyPress="return Mascara('D',event);"
                       class="inputTextNumeric"
                       onchange="javascript:SetearVigencia ();" <%= (iNumCot > 0 ? "readonly" : " ") %>>
            </td>
        </tr>
<%      } else {
    %>
        <input type="hidden" name="prop_cantVidas" id="prop_cantVidas" value="0">
<%      }
    %>
        <TR>
            <TD align="left" class='text' width="125" nowrap>&nbsp;Periodo Vigencia:</TD>
            <TD align="left" class='text'>
                <SELECT name="prop_vig" id="prop_vig" class="select" style="width:350px;" onchange="javascript:SetearVigencia ();"
                        <%= (iNumCot > 0 ? "readonly" : " ") %>>
<%                        for (int i=0; i<lVig.size(); i++){
                            Vigencia oVig = (Vigencia) lVig.get(i);
    %>
                        <option value="<%= oVig.getcodVigencia() %>" <%= (iCodVigencia == oVig.getcodVigencia() ? "selected" : " ") %>><%= oVig.getdescVigencia() %></option>
<%                        }
    %>
                </SELECT>
            </TD>
         </TR>
<% if (lVig.size() > 0 ) {
    for (int ii=0; ii<lVig.size(); ii++){
      Vigencia oVig = (Vigencia) lVig.get(ii);
    //  System.out.println ("cantidad max. de cuotas:" + oVig.getcantCuotas() );
    %>
    <input type="hidden" name="prop_cant_cuotas_vig<%= oVig.getcodVigencia() %>" id="prop_cant_cuotas_vig<%= oVig.getcodVigencia() %>" value="<%= oVig.getcantCuotas() %>">
<% } } else {
    %>
        <input type="hidden" name="prop_cant_cuotas_vig0" id="prop_cant_cuotas_vig0" value="0">
<%   }
    %>
</form>
</table>
<script>
<% if (lVig.size() > 0 ) {
    %>
    SetearVigencia ();
<% }
    %>
</script>