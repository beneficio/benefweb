<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp" session="true"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.CotizadorAp"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Vector"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<%@taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg" %>
<% Usuario usu = (Usuario) session.getAttribute("user"); 
    LinkedList lCotizaciones = (LinkedList) request.getAttribute("cotizaciones"); 
    String sParam = "&opcion=getAllCotizaciones";
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<script language="JavaScript">

    function VerNew (codRama,  numCotizacion, tipo ) {
  //      if (document.form1.tipo_usuario.value == "1") {
  //          document.form1.action = "<%--= Param.getAplicacion() --%>cotizador/10/printCotizadorAp.jsp";
  //          document.form1.opcion.value = "getPrintCot";
  //          document.form1.tipo.value = "html";
  //          document.form1.numCotizacion.value = numCotizacion;
  //          document.form1.submit();
  //      } else {
            document.form1.opcion.value = "getCotNew";
            if (codRama == 10 ) {
                document.form1.action = "<%= Param.getAplicacion() %>servlet/CotizadorApServlet";
            } else  {
                document.form1.action = "<%= Param.getAplicacion() %>servlet/CotizadorVCServlet";
            }
            document.form1.tipo.value = "html";
            document.form1.numCotizacion.value = numCotizacion;
            document.form1.num_cotizacion.value = numCotizacion;
            document.form1.siguiente.value = "solapa2";
            document.form1.submit();
    //   }
    }

    function Ver (codRama, numCotizacion, tipo ) {
        document.form1.action = "<%= Param.getAplicacion() %>cotizador/10/printCotizadorAp.jsp";
        document.form1.opcion.value = "getCot";
        document.form1.numCotizacion.value = numCotizacion;
        document.form1.submit();
    }

    function Editar (codRama,  numCotizacion ) {
        if (codRama == '10' ) {
            document.form1.action = "<%= Param.getAplicacion() %>servlet/CotizadorApServlet";
        } else {
            document.form1.action = "<%= Param.getAplicacion() %>servlet/CotizadorVCServlet";
        }
        document.form1.opcion.value = "getCot";
        document.form1.tipo.value = "html";
        document.form1.numCotizacion.value = numCotizacion;
        document.form1.submit();
    }

    function Salir () {
        document.form1.action = "<%= Param.getAplicacion() %>index.jsp";
        document.form1.submit();
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
        <td valign="top" align="center" width="755">
            <TABLE height="100%"   width="100%"  border="0" cellspacing="0" cellpadding="0" align="center" >
                <tr>
                    <td height='30px'  valign="middle" class='titulo' align="center">COTIZACIONES</td>
                </tr> 
                <tr>
                    <td height="100%"  valign="top">
                        <form  action='<%= Param.getAplicacion() %>servlet/CotizadorApServlet' id="form1" name="form1"  method="POST">
                            <input type="hidden" name="tipo" id="tipo" value="html"/>
                            <input type="hidden" name="opcion" id="opcion" value="getCotizacion"/>
                            <input type="hidden" name="numCotizacion" id="numCotizacion" value="0"/>
                            <input type="hidden" name="num_cotizacion" id="num_cotizacion" value="0"/>
                            <input type="hidden" name="siguiente" id="siguiente" value="solapa1"/>
                            <input type="hidden" name="tipo_usuario" id="tipo_usuario" value="<%= usu.getiCodTipoUsuario() %>"/>

                        </form>
                        <table border="0" cellPadding="0" cellSpacing="0" align="center" style="margin-top:10;margin-bottom:10;">
                            <tr>
                                <td valign="top" width='100%'> 
                                    <pg:pager  maxPageItems="35"  items="<%= lCotizaciones.size() %>" url="/benef/servlet/CotizadorApServlet" maxIndexPages="20" export="currentPageNumber=pageNumber">
                                    <pg:param name="keywords"/>

                                        <table border="1" cellspacing="0" cellpadding="2" align="center" style="margin-left:5px;" class='TablasBody'>
                                            <thead>
                                                <th align="center" width='50'>Operaci&oacute;n</th>
                                                <th align="center" width='50'>Tipo</th>
                                                <th align="center" width='65'>Fecha</th>
                                                <th align="center" width='40'>Hora</th>
                                                <th align="center" width='65'>Estado</th>
                                                <th align="center" width='220'>Cliente</th>
                                                <th align="center" width='220'>Solicitado por</th>
                                                <th align="center" width='45' >Cotizar</th>
                                                <th align="center" width='45' >Ver</th>
                                            </thead>
            <%                              if (lCotizaciones.size() == 0){%>
                                            <tr>
                                                <td colspan="8">No existen cotizaciones a listar</td>
                                            </tr>
            <%                              }  
                                            for (int i=0; i < lCotizaciones.size (); i++) {
                                                CotizadorAp oCot = (CotizadorAp) lCotizaciones.get (i);
                                                String sEstado = "TESTEO";
                                                if (oCot.getabm().equals("N")) {
                                                    switch (oCot.getestadoCotizacion()) {
                                                        case 0:
                                                            sEstado = "EN CARGA";
                                                            break;
                                                        case 1:
                                                            sEstado = "ENVIADA";
                                                            break;
                                                        case 2:
                                                            sEstado = "ACEPTADA";
                                                            break;
                                                        case 3:
                                                            sEstado = "RECHAZADA";
                                                            break;
                                                        default:
                                                            sEstado = "No informado";
                                                    }
                                                }
            %>
                                      <pg:item>
                                            <tr>
                                                <td align="right"><%= oCot.getnumCotizacion()%></td>
                                                <td align="right"><%= (oCot.gettipoPropuesta().equals("R") ? "Renovaci&oacute;n" : "P&oacute;liza" )%></td>
                                                <td align="center"><%= (oCot.getfechaCotizacion() == null ? "&nbsp;" : Fecha.showFechaForm(oCot.getfechaCotizacion()))%></td>
                                                <td align="center"><%= (oCot.gethoraCotizacion() == null ? "&nbsp;" : oCot.gethoraCotizacion())%></td>
                                                <td align="center"><%= sEstado %>&nbsp;</td>
                                                <td align="left"><%= oCot.gettomadorApe()%>&nbsp;</td>
                                                <td align="left"><%= ( oCot.getdescUsu() == null ? "&nbsp;" : (oCot.getdescUsu() + "  ("+ oCot.getcodProd() + ")") ) %>&nbsp;</td>
<%                                          if (oCot.getestadoCotizacion () == 0 && oCot.getsMcaBajaActividad ().equals (" ") ) {
    %>
                                                    <td nowrap  align="center"><span><IMG onClick="Editar(<%= oCot.getcodRama() %>,'<%= oCot.getnumCotizacion ()%>');"
                                                                                          alt="Editar la cotizacion" src="<%= Param.getAplicacion() %>images/nuevo.gif"
                                                                                          border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;"></span>
                                                    </td>
<%                                          } else {   
    %>
                                                <td>&nbsp;</td>
<%                                          }
    %>
                                                <td nowrap  align="center"><span><IMG onClick="VerNew(<%= oCot.getcodRama() %>, '<%= oCot.getnumCotizacion ()%>','html');"
                                                                                      alt="Ver la cotizacion" src="<%= Param.getAplicacion() %>images/ver_cotizacion.jpg"
                                                                                      border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;"></span>
                                                </td>
                                             </tr>
                                        </pg:item> 
            <%                              }     
                %>
                                        <thead>
                                            <th colspan="8">
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
                        <table width="100%" height="30px" border="0" cellspacing="0" cellpadding="0" align="center" >
                            <TR>
                                <td align="center">
                                    <input type="button" name="cmdSalir" value="Salir" width="100px" height="20px" class="boton" onClick="Salir()">
                                </TD>
                            </TR>
                        </TABLE>		
                    </td>
                </TR>
            </TABLE>
        </td>
    </tr>
    <tr>
        <td width='100%' align="center">
            <jsp:include flush="true" page="/bottom.jsp"/>
        </td>
    </tr>
</table>
<script>
CloseEspere();
</script>
</body>
</html>
