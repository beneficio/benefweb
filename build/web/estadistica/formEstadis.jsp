<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Hits"%>
<%@page import="com.business.beans.Poliza"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>   
<%@ taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg" %>
<%  
    LinkedList lHits = (LinkedList) request.getAttribute("hits");
    Usuario usu = (Usuario) session.getAttribute("user");
    if (usu.getiCodTipoUsuario() != 0) {
        request.setAttribute("javax.servlet.jsp.jspException", new SurException ("acceso denegado"));
        getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
    }
    String sOpcion       = (request.getParameter ("opcion") == null ? "" :request.getParameter ("opcion")) ;
    int iSize            = (lHits == null ? 0 : lHits.size());    
    String sPri          = request.getParameter ("pri");
    String sUsuario      = request.getParameter ("usuario");
    String sFechaDesde   =  (request.getParameter ("fecha_desde") == null ? null : request.getParameter ("fecha_desde"));
    String sFechaHasta   =  (request.getParameter ("fecha_hasta") == null ? null : request.getParameter ("fecha_hasta"));

String sPath = 
    "&pri=N&usuario=" + sUsuario + "&opcion=" + sOpcion +
    "&fecha_hasta=" + (sFechaHasta == null ? "" : sFechaHasta) + 
    "&fecha_desde=" + (sFechaDesde == null ? "" : sFechaDesde);
    %>  
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
    <script type="text/javascript" language="javascript">
    function Buscar ( opcion) { 
        
        if ( document.form1 ) {
            document.form1.action = "<%= Param.getAplicacion()%>servlet/EstadisServlet";
            document.form1.opcion.value  = opcion;
            document.form1.submit(); 
            return true;
        } else {
            return false;
        }
    }
    function Salir () {
        window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

    function verDetalle( fecha, usuario) {      

      var W = 600;
      var H = 450;      
                                              
      var sUrl = "<%= Param.getAplicacion()%>servlet/EstadisServlet?opcion=getDetalle&fecha=" + fecha + "&usuario=" + usuario;
      AbrirPopUp (sUrl, W, H);
      return true;    
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
            <form name="form1" id="form1" method="POST" action="<%= Param.getAplicacion()%>servlet/EstadisServlet">
                <input type="hidden" name="opcion" id="opcion" value="getUsoSistema">
                <input type="hidden" name="pri" id="pri" value="N">
                <table width="100%" border="0" align="center" cellspacing="2" cellpadding="2"  class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                    <TR>
                        <TD height="30px" valign="middle" align="center" class='titulo' colspan='2'>CONTROL DE ACCESOS</TD>
                    </TR>
                    <tr>
                        <td align="left"  class="text">Fecha Desde:</td>
                        <td align="left"  class="text"><input name="fecha_desde" id="fecha_desde" size="10" 
                        onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value="<%= (sFechaDesde == null ? "" : sFechaDesde) %>">&nbsp;(dd/mm/yyyy)</td>
                    </tr>
                    <tr>
                        <td align="left"  class="text">Fecha Hasta:</td>
                        <td align="left"  class="text"><input name="fecha_hasta" id="fecha_hasta" size="10" 
                        onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value="<%= (sFechaHasta == null  ? "" : sFechaHasta) %>">&nbsp;(dd/mm/yyyy)</td>
                    </tr>
                    <tr>
                        <td align="left"  class="text">Usuario:&nbsp;</td>
                        <td align="left"  class="text"><input name="usuario" id="usuario" size="15" maxlength='20' value="<%= (sUsuario == null ? "" : sUsuario) %>">&nbsp;Dejar vacio para visualizar todos los usuarios</td>
                    </tr>
                    <TR>
                        <TD valign="left" align="left" class='titulo' colspan='2'>Indice de consultas</TD>
                    </tr>
                    <tr>
                        <td><input type="button" name="cmdGrabar1" value="Consultar >>>"  height="20px" class="boton" onClick="Buscar ('getUsoSistema');"></td>
                        <td align="left"  class="text"><b>Accesos desde Internet agrupados por fecha, usuario y operación. Fecha desde vacia = 01/01/2005. 
                        Fecha hasta vacia = fecha actual, usuario vacio = todos.</b></td>
                    </tr>
                    <tr>
                        <td><input type="button" name="cmdGrabar2" value="Consultar >>>"  height="20px" class="boton" onClick="Buscar ('getOpMensuales');"></td>
                        <td align="left"  class="text"><b>Uso del sitio desde Internet agrupado por mes, operación. Fecha desde vacia = 11/2005. 
                        Fecha hasta vacia = mes actual, usuario vacio = todos. Solo productores y clientes.</b></td>
                    </tr>
                    <tr>
                        <td><input type="button" name="cmdGrabar3" value="Consultar >>>"  height="20px" class="boton" onClick="Buscar ('getRankingProp');"></td>
                        <td align="left"  class="text"><b>Ranking de propuestas emitidas. Sino informa fechas muestra desde el principio hasta la fecha de consulta. 
                        En usuario debe ingresar el código de productor o vacio para ver todos los productores.</b></td>
                    </tr>
                    <tr>
                        <TD align="center"  colspan='2'>
                        <input type="button" name="cmdSalir"  value="  Salir  "  height="20px" class="boton" onClick="Salir ();">&nbsp;&nbsp;&nbsp;&nbsp;
                        </TD>
                    </tr>
                 </table>
            </form>
        </td>
    </tr>
<%
    if (sPri != null && sPri.equals ("N") && sOpcion.equals ("getUsoSistema")) {
    %>

    <tr>
        <td>
            <TABLE border="0"  width='100%' cellPadding="0" cellSpacing="1" align="left" >
                <tr>
                    <td height="20" class='titulo' valign="bottom" align="left">Resultado de la consulta</td>
                </tr>
                <TR>
                    <td valign="top"  width='100%'>
                        <pg:pager  maxPageItems="20" items="<%= iSize %>" url="/benef/servlet/EstadisServlet" 
                        maxIndexPages="20" export="currentPageNumber=pageNumber">
                        <pg:param name="keywords"/>

                        <table  border="1" cellspacing="0" cellpadding="2" align="center" class="TablasBody" width='100%'>
                            <thead>
                                <th width='65'>Fecha acceso</th>
                                <th width='65'>Usuario</th>
                                <th width="150px">Descripción</th>
                                <th width="80px">Tipo Usuario</th>
                                <th width="150px">Operación</th>
                                <th width="40px" >Cantidad</th>
                            </thead>
                           <% if (iSize  == 0 ){%>
                            <tr>
                                <td colspan="6" height='25' valign="middle"><SPAN style='color:red'>No existen accesos para el filtro seleccionado</span></td>
                            </tr>
<%                         } 
                           for (int i=0; i < iSize; i++)  {
                                 Hits oHits = (Hits) lHits.get(i);
    %>
                          <pg:item>

                            <tr>
                                <td align="center"><a href='#' onclick="verDetalle ('<%= Fecha.showFechaForm( oHits.getfechaAcceso ())%>','');"><%= Fecha.showFechaForm( oHits.getfechaAcceso ())%></a></td>
                                <td align="left"><a href='#' onclick="verDetalle ('<%= Fecha.showFechaForm( oHits.getfechaAcceso ())%>','<%= oHits.getusuario () %>');"><%= oHits.getusuario () %></a></td>
                                <td align="left"><%= oHits.getdescUsuario () %></td>
                                <td align="left"><%=(oHits.gettipoUsuario () == null ? " " : oHits.gettipoUsuario () )  %></td>
                                <td align="left" ><%= oHits.getoperacion ()  %></td>
                                <td align="right"><%= oHits.getcantidad ()%></td>
                            </tr>
                        </pg:item> 
<%                          }  
    %>
                             <thead>
                                <th colspan="6">
                                    <pg:prev>
                                    <a class="rnavLink" href="<%= pageUrl %><%= sPath%>">[Anterior]</a>
                                    </pg:prev>
                                    <pg:pages>
                               <% if (pageNumber == currentPageNumber) { %>
                                    <b><%= pageNumber %></b>
                               <% } else { %>
                                    <a class="rnavLink" href="<%= pageUrl %><%= sPath %>"</a>										   
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
<%      }
%>
<%
    if (sPri != null && sPri.equals ("N") && sOpcion.equals ("getOpMensuales")) {
    %>

    <tr>
        <td>
            <TABLE border="0"  width='100%' cellPadding="0" cellSpacing="1" align="left" >
                <tr>
                    <td height="20" class='titulo' valign="bottom" align="left">Resultado de la consulta</td>
                </tr>
                <TR>
                    <td valign="top"  width='100%'>
                        <pg:pager  maxPageItems="20" items="<%= iSize %>" url="/benef/servlet/EstadisServlet" 
                        maxIndexPages="20" export="currentPageNumber=pageNumber">
                        <pg:param name="keywords"/>

                        <table  border="1" cellspacing="0" cellpadding="2" align="center" class="TablasBody">
                            <thead>
                                <th width='55'>Mes</th>
                                <th width='220'>Operaci&oacute;n</th>
                                <th width="55px" >Cantidad</th>
                            </thead>
                           <% if (iSize  == 0 ){%>
                            <tr>
                                <td colspan="6" height='25' valign="middle"><SPAN style='color:red'>No existen accesos para el filtro seleccionado</span></td>
                            </tr>
<%                         } 
                           for (int i=0; i < iSize; i++)  {
                                 Hits oHits = (Hits) lHits.get(i);
    %>
                          <pg:item>

                            <tr>
                                <td align="left" ><%= oHits.getmes ()  %></td>
                                <td align="left" ><%= oHits.getoperacion ()  %></td>
                                <td align="right"><%= oHits.getcantidad ()%></td>
                            </tr>
                        </pg:item> 
<%                          }  
    %>
                             <thead>
                                <th colspan="6">
                                    <pg:prev>
                                    <a class="rnavLink" href="<%= pageUrl %><%= sPath%>">[Anterior]</a>
                                    </pg:prev>
                                    <pg:pages>
                               <% if (pageNumber == currentPageNumber) { %>
                                    <b><%= pageNumber %></b>
                               <% } else { %>
                                    <a class="rnavLink" href="<%= pageUrl %><%= sPath %>"</a>										   
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
<%      }
%>
<%
    if (sPri != null && sPri.equals ("N") && sOpcion.equals ("getRankingProp")) {
    %>
<%--
    <tr>
        <td>
            <TABLE border="0"  width='100%' cellPadding="0" cellSpacing="1" align="left" >
                <tr>
                    <td height="20" class='titulo' valign="bottom" align="left">Resultado de la consulta</td>
                </tr>
                <TR>
                    <td valign="top"  width='100%'>
                        <pg:pager  maxPageItems="20" items="<%= iSize %>" url="/benef/servlet/EstadisServlet" 
                        maxIndexPages="20" export="currentPageNumber=pageNumber">
                        <pg:param name="keywords"/>

                        <table  border="1" cellspacing="0" cellpadding="2" align="center" class="TablasBody">
                            <thead>
                                <th width='55px'>Cod. Prod.</th>
                                <th width='220px'>Productor</th>
                                <th width="55px" >Cantidad</th>
                                <th width="55px" >Ult. Propuesta</th>
                            </thead>
                           <% if (iSize  == 0 ){%>
                            <tr>
                                <td colspan="6" height='25' valign="middle"><SPAN style='color:red'>No existen propuestas para la consulta realizada.</span></td>
                            </tr>
<%                         } 
                           for (int i=0; i < iSize; i++)  {
                                 Hits oHits = (Hits) lHits.get(i);
    %>
                          <pg:item>

                            <tr>
                                <td align="right" ><%= oHits.getusuario ()  %></td>
                                <td align="left" ><%= oHits.getdescUsuario ()  %></td>
                                <td align="right"><%= oHits.getcantidad ()%></td>
                                <td align="right"><%= Fecha.showFechaForm(oHits.getfechaAcceso())%></td>
                            </tr>
                        </pg:item> 
<%                          }  
    %>
                             <thead>
                                <th colspan="6">
                                    <pg:prev>
                                    <a class="rnavLink" href="<%= pageUrl %><%= sPath%>">[Anterior]</a>
                                    </pg:prev>
                                    <pg:pages>
                               <% if (pageNumber == currentPageNumber) { %>
                                    <b><%= pageNumber %></b>
                               <% } else { %>
                                    <a class="rnavLink" href="<%= pageUrl %><%= sPath %>"</a>										   
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
--%>
    <tr>
        <td>
            <TABLE border="0"  width='100%' cellPadding="0" cellSpacing="1" align="left" >
                <tr>
                    <td height="20" class='titulo' valign="bottom" align="left">Resultado de la consulta</td>
                </tr>
                <TR>
                    <td valign="top"  width='100%'>
                        <pg:pager  maxPageItems="20" items="<%= iSize %>" url="/benef/servlet/EstadisServlet"
                        maxIndexPages="20" export="currentPageNumber=pageNumber">
                        <pg:param name="keywords"/>

                        <table  border="1" cellspacing="0" cellpadding="2" align="center" class="TablasBody">
                            <thead>
                                <th width='55px'>&nbsp;</th>
                                <th width='160px'>&nbsp;</th>
                                <th width="55px" >&nbsp;</th>
                                <th colspan="6" align="center" >PROPUESTAS</th>
                            </thead>
                            <thead>
                                <th width='55px'>Cod. Prod.</th>
                                <th width='160px'>Productor</th>
                                <th width="55px" >Cotiz.AP</th>
                                <th width="55px" align="center">AP</th>
                                <th width="55px" align="center">VC</th>
                                <th width="55px" align="center">VO</th>
                                <th width="55px" align="center">CAUCION</th>
                                <th width="55px" align="center">ENDOSO</th>
                                <th width="55px" align="center" >OTRO</th>
                            </thead>
                           <% if (iSize  == 0 ){%>
                            <tr>
                                <td colspan="6" height='25' valign="middle"><SPAN style='color:red'>No existen propuestas para la consulta realizada.</span></td>
                            </tr>
<%                         }
                           int tot1 = 0;
                           int tot2 = 0;
                           int tot3 = 0;
                           int tot4 = 0;
                           int tot5 = 0;
                           int tot6 = 0;
                           int tot7 = 0;

                           for (int i=0; i < iSize; i++)  {
                                 Hits oHits = (Hits) lHits.get(i);
                                 tot1 += oHits.getcantCotiz();
                                 tot2 += oHits.getcantPropAP();
                                 tot3 += oHits.getcantPropVC();
                                 tot4 += oHits.getcantPropVO();
                                 tot5 += oHits.getcantPropCaucion();
                                 tot6 += oHits.getcantEndoso();
                                 tot7 += oHits.getcantOtros();
    %>
                          <pg:item>

                            <tr>
                                <td align="right" ><%= oHits.getusuario ()  %></td>
                                <td align="left" ><%= oHits.getdescUsuario ()  %></td>
                                <td align="right"><%= oHits.getcantCotiz()%></td>
                                <td align="right"><%= oHits.getcantPropAP()%></td>
                                <td align="right"><%= oHits.getcantPropVC()%></td>
                                <td align="right"><%= oHits.getcantPropVO()%></td>
                                <td align="right"><%= oHits.getcantPropCaucion()%></td>
                                <td align="right"><%= oHits.getcantEndoso()%></td>
                                <td align="right"><%= oHits.getcantOtros()%></td>
                            </tr>
                        </pg:item>
<%                          }
    %>
                            <thead>
                            <th width='55px'>&nbsp;</th>
                            <th width='160px'>&nbsp;</th>
                                <th width="55px" ><%= tot1 %></th>
                                <th width="55px" ><%= tot2 %></th>
                                <th width="55px" ><%= tot3 %></th>
                                <th width="55px" ><%= tot4 %></th>
                                <th width="55px" ><%= tot5 %></th>
                                <th width="55px" ><%= tot6 %></th>
                                <th width="55px" ><%= tot7 %></th>
                            </thead>
                             <thead>
                                <th colspan="9">
                                    <pg:prev>
                                    <a class="rnavLink" href="<%= pageUrl %><%= sPath%>">[Anterior]</a>
                                    </pg:prev>
                                    <pg:pages>
                               <% if (pageNumber == currentPageNumber) { %>
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
<%      }
%>
    <TR>
        <TD valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
   </tr>
</table>
<script>
     CloseEspere();
</script>
</body>
</HTML>
