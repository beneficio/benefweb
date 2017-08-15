<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp" session="true"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Plan"%>
<%@page import="com.business.beans.Certificado"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.LinkedList"%>   
<%@page import="java.util.Vector"%>
<%@ taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg" %>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<% Usuario usu = (Usuario) session.getAttribute("user"); 
    LinkedList lPlan = (LinkedList) request.getAttribute("planes"); 
    String sParam = "&opcion=getAllPlan";  
    %>    
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
<script language="JavaScript">
    function Salir () {
        document.form1.action = "<%= Param.getAplicacion() %>index.jsp";
        document.form1.submit();
    }

    function AltaPlan () {
        document.form1.action     = "<%= Param.getAplicacion() %>abm/planes/formPlan.jsp";
        document.form1.abm.value  = "ALTA";
        document.form1.submit();
    }

    function ExportarExcel () {
        document.form1.action = "<%= Param.getAplicacion() %>servlet/PlanServlet";
        document.form1.opcion.value  = "generarExcel";
        document.form1.abm.value     = "CONSULTA";
        document.form1.submit();
    }

    function Editar ( codPlan ) {
        document.form1.action = "<%= Param.getAplicacion() %>servlet/PlanServlet";
        document.form1.opcion.value  = "getPlan";
        document.form1.cod_plan.value  = codPlan
        document.form1.abm.value     = "CONSULTA";
        document.form1.submit();
    }

    function Modificar ( codPlan ) {
        document.form1.action = "<%= Param.getAplicacion() %>servlet/PlanServlet";
        document.form1.opcion.value  = "getPlan";
        document.form1.cod_plan.value  = codPlan
        document.form1.abm.value  = "MODIFICACION";
        document.form1.submit();
    }

    function CambiarEstado(codPlan , publicadoActual) {
       // alert ( "COD.: " + codPlan + " ESTA " + publicadoActual); 

       var titulo           = "Publicar";
       var newMcaPublica  = "X" ;
       if ( publicadoActual == 'SI') {
           titulo = "Despublicar"; 
           newMcaPublica  = "" ;
       }

       if( confirm ("Esta usted seguro que desea " + titulo + " el plan  ? ")) {
           document.form1.action = "<%= Param.getAplicacion() %>servlet/PlanServlet";
           document.form1.opcion.value         = "cambiarMcaPublicacion";
           document.form1.cod_plan.value        = codPlan
           document.form1.new_mca_publica.value  = newMcaPublica;
           document.form1.submit();
           return true;
       } else {
           return false;
       }

    }
 
</script>
</head>
<body>
<form  action='<%= Param.getAplicacion() %>servlet/CertificadoServlet' id="form1" name="form1"  method="POST">
    <input type="hidden" name="opcion"            id="opcion"           value="">
    <input type="hidden" name="cod_plan"          id="cod_plan"         value="">
    <input type="hidden" name="abm"               id="abm"              value="CONSULTA">
    <input type="hidden" name="new_mca_publica" id="new_mca_publica"   value="">

</form>
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
            <TABLE height="100%"   width="100%"  border="0" cellspacing="0" cellpadding="0" align="center" >
                <tr>
                    <td height='30px'  valign="middle" class='titulo' align="center">CONSULTA DE PLANES</td>
                </tr> 
                <tr>
                    <td height="100%"  valign="top">
                        <TABLE border="0" cellPadding="0" cellSpacing="0" align="center" style="margin-top:0;margin-bottom:0;">
                            <TR>
                                <td valign="top" width='100%'> 
                                    <pg:pager  maxPageItems="30"  items="<%= lPlan.size() %>" url="/benef/servlet/PlanServlet" maxIndexPages="20" export="currentPageNumber=pageNumber">
                                    <pg:param name="keywords"/>

                                        <table border="0" cellspacing="0" cellpadding="2" align="center"  width='100%' style="margin-left:0px;" class='TablasBody'>
                                            <thead>                                                
                                            <th align="center" width='230'>Plan/Producto/Cobertura/Descripci&oacute;n</th>
                                                <th align="center" width='110'>Rama</th>
                                                <th align="center" width='130'>Sub Rama</th>
                                                <th align="center" width='50'>Premio</th>
                                                <th align="center" width='20'>Edit</th>
                                                <th align="center" width='60'>Publicado</th>
                                            <thead>
            <%                              if (lPlan.size() == 0){%>
                                            <tr>
                                                <td colspan="4">No existen Plan >>>> </td>
                                            </tr>
            <%                              }  
                                            for (int i=0; i < lPlan.size (); i++) {
                                                Plan oPlan = (Plan) lPlan.get (i);
            %>
                                      <pg:item>
                                            <tr>
                                                <td align="left">&nbsp;<%=oPlan.getcodPlan()%>/<%=oPlan.getcodProducto()%>/<%=oPlan.getcodAgrupCobertura()%>&nbsp;-&nbsp;
                                                <%= (oPlan.getdescripcion())%></td>
                                                <td align="left"">&nbsp;<%=(oPlan.getdescRama())%></td>
                                                <td align="left"">&nbsp;<%=(oPlan.getdescSubRama())%></td>
                                                <td align="right"><%= Dbl.DbltoStr(oPlan.getminPremio(),2)%></td>
                                                <td nowrap  align="center">
                                                    <span><IMG onClick="Editar('<%= oPlan.getcodPlan()%>');"  alt="Consultar plan " src="<%= Param.getAplicacion() %>images/editdocument.gif"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;">
                                                    </span>
                                      <%        if ( oPlan.getmcaPublica().trim().equals("X")   ){ %>
                                                &nbsp;
                                      <%        }else { %>
                                                &nbsp;
                                                    <span><IMG onClick="Modificar('<%= oPlan.getcodPlan()%>');"  alt="Editar plan " src="<%= Param.getAplicacion() %>images/procesado/75.gif"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;">
                                                    </span>
                                      <%        } %>
                                                </td>

                                               <td align="center"><%=(oPlan.getmcaPublica().equals("X"))?"SI":"NO"%><span><IMG onClick="CambiarEstado('<%= oPlan.getcodPlan()%>','<%=(oPlan.getmcaPublica().equals("X"))?"SI":"NO"%>');"  alt="Cambiar estado Publicado /Despublicado" src="<%= Param.getAplicacion() %>images/<%= (oPlan.getmcaPublica().equals("X") ? "ok.gif" : "nook.gif") %>"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;"></span></td>

                                            </tr>
                                        </pg:item> 
            <%                              }     
                %>
                                        <thead>
                                            <th colspan="9">
                                                <pg:prev>
                                                <a class="rnavLink" href="<%= pageUrl %><%= sParam %>">[Anterior]</a>
                                                </pg:prev>
                                                <pg:pages>
                                           <% if (pageNumber == currentPageNumber) { %>
                                                <b><%= pageNumber %></b>
                                           <% } else { %>
                                                <a class="rnavLink" href="<%= pageUrl %><%= sParam %>"><%= pageNumber %></a>										   
                                           <% } %>
                                                </pg:pages>
                                                <pg:next>
                                                <a class="rnavLink" href="<%= pageUrl %><%= sParam %>">[Siguiente]</a>
                                                </pg:next>
                                            </th>
                                        </thead>
                                    </table>	
                           </pg:pager>  
                                </td>   
                            </tr>
                        </table>
                    </td>

                </tr>


                <tr valign="bottom" >
                    <td width="100%"  >
                        <table width="60%" height="30px" border="0" cellspacing="0" cellpadding="0" align="center" >
                            <TR>
                                <td align="center">
                                    <input type="button" name="cmdSalir" value="Salir" width="100px" height="20px" class="boton" onClick="javascript:Salir();">
                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                    <input type="button" name="cmdExcel" value="Exportar a Excel" width="100px" height="20px" class="boton" onClick="javascript:ExportarExcel();">
                                    &nbsp;&nbsp;&nbsp;&nbsp;  
                                    <input type="button" name="cmdNuevo" value="ALta de Plan" width="100px" height="20px" class="boton" onClick="javascript:AltaPlan();">
                                </TD>
                            </TR>
                        </TABLE>		
                    </td>
                </TR>
            </TABLE>
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

