<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp" session="true"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.SeteoProd"%>
<%@page import="com.business.beans.Certificado"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.LinkedList"%>   
<%@page import="java.util.Vector"%>      
<%@ taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg" %>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<% Usuario usu = (Usuario) session.getAttribute("user"); 
    LinkedList lSeteoProd = (LinkedList) request.getAttribute("seteos");

    int iCodProd = Integer.parseInt (request.getParameter ("cod_prod") == null ? "0" :
                                     request.getParameter ("cod_prod"));
    String sParam = "&opcion=getAllSeteoProd&cod_prod=" + iCodProd;

    %>    
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
<script language="JavaScript">

    function Salir () {
        document.form1.action = "<%= Param.getAplicacion() %>abm/formAbmIndex.jsp";
        document.form1.submit();
    }

    function AltaSeteoProd () {
        document.form1.action     = "<%= Param.getAplicacion() %>abm/setProd/formSeteoProd.jsp";
        document.form1.abm.value  = "ALTA";
        document.form1.submit();
    }

    function Modificar ( codSeteo) {
        document.form1.action = "<%= Param.getAplicacion() %>servlet/SetProductorServlet";
        document.form1.opcion.value  = "getSeteoProd";
        document.form1.cod_seteo.value  = codSeteo;
        document.form1.abm.value  = "MODIFICACION";
        document.form1.submit();
    }

    function Buscar () {
        document.form1.action = "<%= Param.getAplicacion() %>servlet/SetProductorServlet";
        document.form1.opcion.value  = "getAllSeteoProd";
        document.form1.submit();
    }

    function Eliminar ( codSeteo) {

        if (confirm ("Esta usted seguro que desea eliminar el seteo del productor ? ") ) {
            document.form1.action = "<%= Param.getAplicacion() %>servlet/SetProductorServlet";
            document.form1.opcion.value  = "delSeteoProd";
            document.form1.cod_seteo.value  = codSeteo;
            document.form1.submit();
            return true;
        } else {
            return false;
        }
    }

    function CambiarSelectProd ( accDir ) {
        var       i = 0;
        var bExiste = false;

        if ( (accDir.value == "" || accDir.value == "0")) {
            if (document.getElementById ('cod_prod').value != "0") {
                document.getElementById ('cod_prod').value = "0";
            }
            return true;
        } else {
            for (i = 0; i < document.getElementById ('cod_prod').length; i++) {
                if (document.getElementById ('cod_prod').options [i].value == accDir.value) {
                    bExiste = true;
                    break;
                }
            }
            if ( bExiste ) {
                document.getElementById ('cod_prod').value = accDir.value;
                return true;
            } else {
                alert (" Código inexistente  !! ");
                accDir.value = "";
                return false;
            }
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
        <td align="center" valign="top" width='100%' height='100%'>
            <form id="form1" name="form1"  method="POST">
                <input type="hidden" name="opcion"    id="opcion"     value=""/>
                <input type="hidden" name="cod_seteo" id="cod_seteo"  value="0"/>
                <input type="hidden" name="abm"       id="abm"        value="CONSULTA"/>

            <table   width="100%"  border="0" cellspacing="2" cellpadding="2" align="center" >
                <tr>
                    <td height='30px'  valign="middle" class='titulo' align="center">CONSULTA DE SETEOS DE PRODUCTORES</td>
                </tr>
                <tr>
                    <td align="left" class="text" height="40px" valign="middle">Productor:&nbsp;
                        <select class='select' name="cod_prod" id="cod_prod">
<%
             LinkedList lProd = (LinkedList) session.getAttribute("Productores");
             for (int i= 0; i < lProd.size (); i++) {
                 Usuario oProd = (Usuario) lProd.get(i);
                 out.print("<option value='" + oProd.getiCodProd() + "' " + (oProd.getiCodProd() == iCodProd ? "selected" : " ") +
                                            ">" + oProd.getsDesPersona() + " (" + oProd.getiCodProd() + ")</option>");
             }
%>
                        </select>
                    &nbsp;
                    <LABEL>Cod : </LABEL>
                    &nbsp;
                    <INPUT name="prod_dir" id="prod_dir" value='0' size='10' maxlength='10'
                           class='inputTextNumeric' onchange='CambiarSelectProd ( this );' onkeypress="" />
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="button" name="cmdBuscar" value="  Buscar " width="100px" height="20px" class="boton" onClick="Buscar()"/>
                    </td>
                </tr>
                <tr>
                    <td height="100%"  valign="top">
                        <table border="0" cellPadding="0" cellSpacing="0" align="center" style="margin-top:0;margin-bottom:0;">
                            <tr>
                                <td valign="top" width='100%'> 
                                    <pg:pager  maxPageItems="30"  items="<%= lSeteoProd.size() %>" url="/benef/servlet/SetProductorServlet" maxIndexPages="20" export="currentPageNumber=pageNumber">
                                    <pg:param name="keywords"/>

                                        <table border="0" cellspacing="0" cellpadding="1" align="center"  style="margin-left:0px;" class='TablasBody'>
                                            <thead>                                                
                                                <th align="center" width='30'>Rama</th>
                                                <th align="center" width='80'>Sub Rama</th>
                                                <th align="center" width='150'>Productor</th>                                                
                                                <th align="center" width='50'>Prima<br/>minina</th>
                                                <th align="center" width='50'>Maxima<br/>comision</th>
                                                <th align="center" width='50'>Tope<br/>premio</th>
                                                <th align="center" width='50'>Porc.<br/>Retenido</th>
                                                <th align="center" width='50'>NO<br/>gestionar</th>
                                                <th align="center" width='50'>Mail<br/>gesti&oacute;n</th>
                                                <th align="center" nowrap>D&iacute;a<br/>D&eacute;bito</th>
                                                <th align="center" nowrap>Permiso<br/>Emisi&oacute;n</th>
                                                <th align="center" nowrap>Limite<br/>Emisi&oacute;n</th>
                                                <th align="center">Edit|Borrar</th>
                                           </thead>
            <%                              if (lSeteoProd.size() == 0){%>
                                            <tr>
                                                <td colspan="11">No existen Seteos de productores >>>> </td>
                                            </tr>
            <%                              }  
                                            for (int i=0; i < lSeteoProd.size (); i++) {
                                                SeteoProd oSeteo = (SeteoProd) lSeteoProd.get (i);
            %>
                                      <pg:item>
                                            <tr>
                                                <td align="left" nowrap>&nbsp;<%=(oSeteo.getdescRama() == null ? "TODOS" : oSeteo.getdescRama())%></td>
                                                <td align="left" nowrap>&nbsp;<%=(oSeteo.getdescSubRama() == null ? "TODAS" : oSeteo.getdescSubRama())%></td>
                                                <td align="left" nowrap>&nbsp;<%= (oSeteo.getdescProd())%>&nbsp;(<%=(oSeteo.getcodProd ())%>)</td>
                                                <td align="right"><%= (oSeteo.getminPrima() == 0 ? " " : Dbl.DbltoStr(oSeteo.getminPrima(),2))%></td>
                                                <td align="right"><%= (oSeteo.getmaxComisionCot() == 0 ? " " : oSeteo.getmaxComisionCot())%></td>
                                                <td align="right"><%= (oSeteo.getmaxTopePremioCot() == 0 ? " " : oSeteo.getmaxTopePremioCot())%></td>
                                                <td align="right"><%= (oSeteo.getporcRecargoRetenido() == 0 ? " " : oSeteo.getporcRecargoRetenido())%></td>
                                                <td align="right"><%= (oSeteo.getmcaNoGestionar() == null ? " " : oSeteo.getmcaNoGestionar())%></td>
                                                <td align="right"><%= (oSeteo.getmailGestionDeuda()== null ? " " : oSeteo.getmailGestionDeuda())%></td>
                                                <td align="right" nowrap><%= (oSeteo.getdiaDebito() == 0 ? " " : oSeteo.getdiaDebito())%></td>
                                                <td align="right" nowrap><%= (oSeteo.getpermisoEmision() == null ? " " : oSeteo.getpermisoEmision())%></td>
                                                <td align="right" nowrap><%= (oSeteo.getlimiteEmision() == 0 ? " " : oSeteo.getlimiteEmision())%></td>
                                                <td nowrap  align="center">
                                                    <img onClick="Modificar('<%= oSeteo.getcodSeteo()%>');"
                                                    alt="Modificar seteo de la rama/subrama/productor" src="<%= Param.getAplicacion() %>images/procesado/75.gif"  border="0"  
                                                    hspace="0" vspace="0" align="bottom" style="cursor: hand;"/>&nbsp;|&nbsp;
                                                    <img onClick="Eliminar ('<%= oSeteo.getcodSeteo()%>');"
                                                    alt="Elimina todos los seteo de la rama/subrama/productor" src="<%= Param.getAplicacion() %>images/delete.gif"  border="0"  
                                                    hspace="0" vspace="0" align="bottom" style="cursor: hand;"/>
                                                </td>                                            
                                              </tr>
                                        </pg:item> 
            <%                              }     
                %>
                                        <thead>
                                            <th colspan="13">
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
                            <tr>
                                <td align="center">
                                    <input type="button" name="cmdSalir" value="Salir" width="100px" height="20px" class="boton" onClick="Salir()">
                                    &nbsp;&nbsp;&nbsp;&nbsp;  
                                    <input type="button" name="cmdNuevo" value="ALta de Seteo" width="100px" height="20px" class="boton" onClick="AltaSeteoProd();">
                                </td>

                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            </form>
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

