<%@ page contentType="text/html" errorPage="/error.jsp" session="true"%>
<%@page import="java.util.*"%>
<%@page import="com.business.beans.Hits"%>
<%@page import="com.business.util.*" %>
<%@include file="/include/no-cache.jsp"%>    
<%@ taglib uri="http://jsptags.com/tags/navigation/pager" prefix="pg" %>
<%
LinkedList lHits = (LinkedList) request.getAttribute("hits");

String sPath = 
    "&usuario=" + request.getParameter("usuario") + "&opcion=getDetalle" +
    "&fecha=" + request.getParameter("fecha");
%>
<HTML>
<HEAD>
<style type="text/css">

</style>
    <TITLE>Detalle de accesos en el dia</TITLE>
    <LINK rel="stylesheet" type="text/css" href="<%= Param.getAplicacion() %>css/estilos.css">	
    <SCRIPT language='javascript'>
        function Volver() {
            window.close ();
        }   
     
    </SCRIPT>
</HEAD>

<BODY>
<TABLE border='0' align='center' >
    <TR>
        <TD height="30px" valign="middle" align="center" class='titulo' colspan='2'>Detalle de accesos</TD>
    </TR>
    <TR valign='top' align='center'>
            <td valign="top"  width='100%'>
                <pg:pager  maxPageItems="18" items="<%= lHits.size()%>" url="/benef/servlet/EstadisServlet" 
                maxIndexPages="20" export="currentPageNumber=pageNumber">
                <pg:param name="keywords"/>
       
            <TABLE border="0" cellspacing="0" cellpadding="2" align="center" style="margin-left:5px;" class='TablasBody'>
                <THEAD>
                    <TH width='55' nowrap>Fecha</TH>
                    <TH width='20' nowrap>Hora</TH>
                    <TH width='45' nowrap>Usuario</TH>
                    <TH width='200'>Nombre</TH>
                    <TH width='70'>Tipo usuario</TH>
                    <TH width='150'>Operacion</TH>
                </THEAD>
<%
    
    if (lHits.size()==0) {
%>
                <TR>
                    <TD colspan='6'> No existe información para la consulta realizada</TD>
                </TR>
<%
    } else {
        for (int i=0; i < lHits.size() ; i++ ) {
        Hits oHits = (Hits) lHits.get(i) ;
%>
                <pg:item>              
                <TR>
                    <TD> <%=Fecha.showFechaForm(oHits.getfechaAcceso ())%> </TD>
                    <TD> <%=oHits.gethoraAcceso ()%></TD>
                    <TD> <%=oHits.getusuario()%></TD>
                    <TD> <%=oHits.getdescUsuario()%></TD>
                    <TD> <%=oHits.gettipoUsuario()%></TD>
                    <TD> <%=oHits.getoperacion()%></TD>
                </TR>
                </pg:item>
<%
    }
  }
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
        </TD>
    </TR>
    <TR valign="bottom" >
        <TD align="center" height='25'>
            <INPUT type="button" name="cmdSalir"   value=" Volver "  height="20px" class="boton" onClick="Volver();">       
        </td>
    </TR>
</TABLE>



</BODY>
</HTML>
