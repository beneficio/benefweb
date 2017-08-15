<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Plan"%>
<%@page import="com.business.beans.Grupo"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<%@taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg"  %>
<%
    LinkedList lPlanes = (LinkedList) request.getAttribute("planes");
    Diccionario oDicc   = (Diccionario) session.getAttribute("Diccionario");
    Usuario usu = (Usuario) session.getAttribute("user");

    if (usu.getiCodTipoUsuario() != 0) {
        request.setAttribute("javax.servlet.jsp.jspException", new SurException ("acceso denegado"));
        getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);

    }

    int iSize           = (lPlanes == null ? 0 : lPlanes.size());
    String sPri         = oDicc.getString(request,"F1pri","S");
    int iCodProd        = oDicc.getInt (request, "F1cod_prod");
    String sDescPlan      = oDicc.getString (request, "F1desc_plan");

    int iNumPlan      = oDicc.getInt (request, "F1cod_plan");
    int iCodRama        = oDicc.getInt (request, "F1cod_rama");
    int iNumPlanSelec = oDicc.getInt (request, "F1cod_plan_sel");
    int iCurrentPageNumber =  oDicc.getInt (request,"pager.offset");
      

    oDicc.add("F1pri", sPri );
    oDicc.add("F1desc_plan", sDescPlan);
    oDicc.add("F1cod_prod", String.valueOf(iCodProd));
    oDicc.add("F1cod_plan", String.valueOf (iNumPlan));
    oDicc.add("F1cod_rama", String.valueOf (iCodRama));
    oDicc.add("F1cod_plan_sel", String.valueOf (iNumPlanSelec));
    oDicc.add("pager.offset", String.valueOf(iCurrentPageNumber));
    
    session.setAttribute("Diccionario", oDicc);

String sPath  =
    "&F1pri=N&F1desc_plan=" + sDescPlan + "&F1cod_prod=" + iCodProd  +
    "&F1cod_plan=" + iNumPlan + "&F1cod_plan_sel=0&F1cod_rama=" + iCodRama +
    "&opcion=getAllPlanes" ;

    HtmlBuilder ohtml       = new HtmlBuilder();
    Tablas oTabla = new Tablas ();
    LinkedList lTabla = new LinkedList ();
    %>  
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js" defer="defer"></script>
    <script language="javascript">
    function AltaPlan () {
        document.form1.action     = "<%= Param.getAplicacion() %>servlet/PlanServlet?opcion=getPlan";
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
    function Salir () {
        window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }
    function Submitir(evt) {
           var nkeyCode;
           if (document.all) {
                 nkeyCode = evt.keyCode;
           }else
             if (evt) {
                nkeyCode = evt.which;
           }

          if (nkeyCode==13) {
            Buscar ();
          }
    }
    function CambiarSelectProd ( accDir ) {
        var       i = 0;
        var bExiste = false;

        if ( (accDir.value == "" || accDir.value == "0")) {
            if (document.getElementById ('F1cod_prod').value != "0") {
                document.getElementById ('F1cod_prod').value = "0";
            }
            return true;
        } else {
            for (i = 0; i < document.getElementById ('F1cod_prod').length; i++) {
                if (document.getElementById ('F1cod_prod').options [i].value == accDir.value) {
                    bExiste = true;
                    break;
                }
            }
            if ( bExiste ) {
                document.getElementById ('F1cod_prod').value = accDir.value;
                return true;
            } else {
                alert (" Código inexistente  !! ");
                accDir.value = "";
                return false;
            }
        }
    }

    function Buscar () {

        if (document.form1.F1cod_plan.value == "") {
            document.form1.F1cod_plan.value    = 0;
        }
        if ( document.form1 ) {
            document.form1.action = "<%= Param.getAplicacion()%>servlet/PlanServlet";
            document.form1.opcion.value  = 'getAllPlanes';
            document.form1.submit();
            return true;
       } else {
            return false;
       }
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
        <td valign="top" align="center" width="100%">
            <form name="form1" id="form1" method="POST" action="<%= Param.getAplicacion()%>servlet/PlanServlet">
                <input type="hidden" name="opcion"   id="opcion" value="getAllPlanes">
                <input type="hidden" name="F1pri"    id="F1pri"  value="N">
                <input type="hidden" name="volver"   id="volver" value='filtrarPlanes'>
                <input type="hidden" name="cod_plan" id="cod_plan" value="0">
                <input type="hidden" name="pager.offset" id="pager.offset" value="<%= iCurrentPageNumber %>">
                <input type="hidden" name="abm"      id="abm"     value="CONSULTA">
                <input type="hidden" name="new_mca_publica" id="new_mca_publica"   value="">
                <table width="100%" border="0" align="center" cellspacing="2" cellpadding="2"
                       class="fondoForm" style="margin-top:1;margin-bottom:1;">
                    <TR>
                        <TD valign="middle" align="center" class='titulo' height="30" >PLANES ESPECIALES</TD>
                    </TR>
                <tr>
                    <td align="left" class="text">Productor:&nbsp;
                        <select class='select' name="F1cod_prod" id="F1cod_prod">
                            <option value='0' >SELECIONE PRODUCTOR</option>
                            <option value='99999999' <%= (iCodProd == 99999999 ? "selected" : " ") %> >PARA TODOS LOS PRODUCTORES</option>
<%                   LinkedList lProd = (LinkedList) session.getAttribute("Productores");
                     for (int i= 0; i < lProd.size (); i++) {
                            Usuario oProd = (Usuario) lProd.get(i);
                            out.print("<option value='" + String.valueOf (oProd.getiCodProd()) + "' " + (oProd.getiCodProd() == iCodProd ? "selected" : " ") + ">" +
                                    oProd.getsDesPersona() + " (" + oProd.getiCodProd() + ")</option>");
                     }
%>
                        </select>
                        &nbsp;
                        <LABEL>Cod : </LABEL>
                        &nbsp;
                        <INPUT name="prod_dir" id="prod_dir" value='0' size='10' maxlength='10'
                               class='inputTextNumeric' onchange='CambiarSelectProd ( this );' onkeypress="" >
                        </td>
                    </td>
                </tr>
                <tr>
                    <td align="left" valign="top">
                        <table border='0' align="left" cellpadding='1' cellspacing='2'>
                            <tr>
                                <td align="left"  class="text" valign="top" width="230" >Rama:&nbsp;
                                    <select name="F1cod_rama" id="F1cod_rama"   class="select">
                                        <option value='0' >Todas las rama</option>
    <%                           lTabla = oTabla.getRamas ();
                                 out.println(ohtml.armarSelectTAG(lTabla, iCodRama )); 
    %>
                                    </select>
                                </td>
                                <td align="left" class='text'>
                                    Código de Plan&nbsp;<input name="F1cod_plan" id="F1cod_plan"  size='12' maxlength='5'
                                                        value="<%= iNumPlan %>"  onkeypress="return Mascara('D',event);"
                                                        class="inputTextNumeric">
                                </td>
                            </tr>
                            <tr>
                                <td align="left"  class="text"  >(*)descripci&oacute;n del plan:</td>
                                <td align="left"  class="text"><input name="F1desc_plan" id="F1desc_plan" size='45' value="<%= sDescPlan %>"></td>
                            </tr>
                            </table>
                        </td>
                    </tr>
                    <TR>
                        <TD valign="middle" align="left" class='text' >(*) Puede ingresar el valor parcialmente.&nbsp;
                            Por ej: ingresando Oscar, visualizar&aacute; todas las p&oacute;lizas en la que el cliente contenga Oscar<br>
                        </TD>
                    </TR>
                    <TR>
                        <TD align="center" >
                        <input type="button" name="cmdSalir"  value="  Salir  "  height="20px" class="boton" onClick="javascript:Salir ();">&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button" name="cmdGrabar" value="  Buscar  "  height="20px" class="boton" onClick="javascript:Buscar ('getAllPlanes');">&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button" name="cmdExcel" value="Exportar a Excel" width="100px" height="20px" class="boton" onClick="javascript:ExportarExcel();">
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button" name="cmdNuevo" value="ALta de Plan" width="100px" height="20px" class="boton" onClick="javascript:AltaPlan();">
                        </TD>
                    </TR>
                 </table>
            </form>
        </td>
    </tr>
<%
    if (sPri != null && sPri.equals ("N")) {
    %>

    <tr>
        <td>
            <table border="0"  width='100%' cellPadding="0" cellSpacing="1" align="left" >
                <tr>
                    <td height="30" class='titulo' width="95%" valign="middle" align="center">Resultado de la busqueda</td>
                </tr>
                <tr> 
                    <td valign="top"  width='100%'>
                        <pg:pager maxPageItems="20" items="<%= iSize %>" 
                                  url="/benef/servlet/PlanServlet"
                                  maxIndexPages="20"
                                  export="currentPageNumber=pageNumber">
                        <pg:param name="keywords" />
                        <table border="0" cellspacing="0" cellpadding="2" align="center" style="margin-left:0px;" class='TablasBody'>
                            <thead>
                                <th align="center" nowrap>Rama</th>
                                <th align="center" nowrap>Sub Rama</th>
                                <th align="center" width='600'>Plan/Producto/Cobertura/Descripci&oacute;n</th>
                                <th align="center" width='70'>Premio</th>
                                <th align="center"  nowrap>Edit</th>
                                <th align="center" width='60'>Publicado</th>
                            </thead>
<%                              if (lPlanes.size() == 0){%>
                                <tr>
                                    <td colspan="4">No existen Plan >>>> </td>
                                </tr>
<%                              }
                                for (int i=0; i < lPlanes.size (); i++) {
                                    Plan oPlan = (Plan) lPlanes.get (i);
%>
                                      <pg:item>
                                            <tr>
                                                <td align="left" nowrap>&nbsp;<%=(oPlan.getdescRama())%></td>
                                                <td align="left" nowrap>&nbsp;<%=(oPlan.getdescSubRama())%></td>
                                                <td align="left">&nbsp;<%=oPlan.getcodPlan()%>/<%=oPlan.getcodProducto()%>/<%=oPlan.getcodAgrupCobertura()%>&nbsp;-&nbsp;
                                                <%= (oPlan.getdescripcion())%></td>
                                                <td align="right"><%= Dbl.DbltoStr(oPlan.getminPremio(),2)%></td>
                                                <td nowrap  align="center">
                                                    <span><img onClick="Editar('<%= oPlan.getcodPlan()%>');"  alt="Consultar plan " src="<%= Param.getAplicacion() %>images/buscar.gif"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;"/>
                                                            &nbsp;&nbsp;<img onClick="Modificar('<%= oPlan.getcodPlan()%>');"  alt="Editar plan " src="<%= Param.getAplicacion() %>images/editdocument.gif"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;"/>
                                                    </span>
                                                </td>

                                               <td align="center"><%=(oPlan.getmcaPublica().equals("X"))?"SI":"NO"%><span><IMG onClick="CambiarEstado('<%= oPlan.getcodPlan()%>','<%=(oPlan.getmcaPublica().equals("X"))?"SI":"NO"%>');"  alt="Cambiar estado Publicado /Despublicado" src="<%= Param.getAplicacion() %>images/<%= (oPlan.getmcaPublica().equals("X") ? "ok.gif" : "nook.gif") %>"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;"></span></td>

                                            </tr>
                                        </pg:item>
            <%                              }
                %>
                            <thead>
                                <th colspan="9">
                                    <pg:prev>
                                    <a class="rnavLink" href="<%= pageUrl %><%= sPath%>">[Anterior]</a>
                                    </pg:prev>
                                    <pg:pages  >
                               <% if (pageNumber == currentPageNumber ) { %>
                                    <b><%= pageNumber %></b>
                               <% } else { %>
                                    <a class="rnavLink" href="<%= pageUrl %><%= sPath %>"><%= pageNumber %></a>
                               <% } %>
                                    </pg:pages>
                                    <pg:next>
                                    <a class="rnavLink" href="<%= pageUrl %><%= sPath %>">[Siguiente]</a>
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
<%   
    }
%>
   <tr>
        <td valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
   </tr>
</table>
<script>
     CloseEspere();
</script>
</body>
</HTML>
