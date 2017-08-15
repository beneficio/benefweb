<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.LinkedList"%>
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>   
<%@ taglib uri="http://jsptags.com/tags/navigation/pager" prefix="pg" %>
<% Usuario usu = (Usuario) session.getAttribute("user");
 LinkedList lUsuarios = (LinkedList) request.getAttribute ("usuarios");
    %>  
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
   <SCRIPT language="javascript">

    function  EditarUsuario ( numSecuUsu ) {
        
       document.form1.numSecuUsu.value = numSecuUsu;
       document.form1.opcion.value  = 'getUsuario';
       document.form1.submit(); 
       return true;
    }

    function  CambiarEstado ( numSecuUsu, estado ) {
       var titulo = "Habilitar";
       if ( estado == 'S') titulo = "Deshabilitar";

       if( confirm ("Esta usted seguro que desea " + titulo + " al usuario seleccionado ? ")) {
            document.form1.numSecuUsu.value = numSecuUsu;
            document.form1.opcion.value  = 'cambiarEstado';
            document.form1.submit(); 
            return true;
       } else {
            return false;
       }
    }

    function Salir () {
        window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }
    </SCRIPT>
</head>
 <body>

 <form action='<%= Param.getAplicacion()%>servlet/setAccess'  id="form1" name="form1"  method="POST">
    <INPUT type="hidden" name='opcion' id='opcion' value="getAllUsuarios">
    <INPUT type="hidden" name='numSecuUsu' id='numSecuUsu' value="-1">
    <INPUT type="hidden" name='estado' id='estado' value="<%= request.getParameter("estado")%>">
    <INPUT type="hidden" name='volver' id='volver' value="getAllUsuarios">
</form>
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
        <td valign="top" align="center">
<TABLE  width="100%" height="100%" border="0" cellspacing="0" cellpadding="2">
    <tr>
        <td height="30" class='titulo' valign="middle" align="center">Consulta de usuarios</td>
    </tr>
    <tr>
        <td   valign="top">
           <TABLE border="0"  width='100%' cellPadding="0" cellSpacing="0" align="left" >
                <TR>
                    <td valign="top" width='100%'>
                        <pg:pager  maxPageItems="30" items="<%= lUsuarios.size() %>" url="/benef/servlet/setAccess" maxIndexPages="20" export="currentPageNumber=pageNumber">
                        <pg:param name="keywords"/>

                        <table  border="1" cellspacing="0" cellpadding="0" align="center" class="TablasBody">
                            <thead>
                                <th >Num</th>
                                <th  width="49px">Estado</th>
                                <th  width="50px">Tipo</th>
                                <th  width="160px">Descripcion</th>
                                <th  width="80px">Documento</th>
                                <th  width="65px">Cod. Prod.</th>
                                <th  width="65px">Num. Cliente</th>
                                <th  width="150px">Observaciones</th>
                                <th >Editar</th>
                                <th >Cambiar<br>Estado</th>
                            </thead>
                           <% if (lUsuarios.size() == 0){%>
                            <tr>
                                <td colspan="10">&nbsp;</td>
                            </tr>
                          <% }  
                           for (int i = 0; i < lUsuarios.size (); i++) { %>
                          <pg:item>
                          <%    Usuario oUsuario = (Usuario) lUsuarios.get(i);
                                String tipo = "Interno";
                                if (oUsuario.getiCodTipoUsuario () == 1) { tipo = "Productor";}
                                if (oUsuario.getiCodTipoUsuario () == 2) { tipo = "Cliente";}
    %>
                            <tr>
                                <td align="right"><span><%= oUsuario.getiNumSecuUsu () %></span></td>
                                <td align="center" ><span style="color:<%= (oUsuario.getsHabilitado ().equals("S") ? "green" : "red") %>"><%= (oUsuario.getsHabilitado ().equals("S") ? "Habilitado" : "Deshabilitado") %></span></td>
                                <td ><span><%= tipo %></span></td>
                                <td ><span><%= oUsuario.getsDesPersona() %></span></td>
                                <td align="right"><span><%= oUsuario.getdescTipoDoc () %>&nbsp;<%= (oUsuario.getDoc () == null ? " " : oUsuario.getDoc ()) %></span></td>
                                <td align="right"><span><%= oUsuario.getiCodProd () %></span></td>
                                <td ><span><%= oUsuario.getiNumTomador () %></span></td>
                                <td ><span><%= (oUsuario.getsObservacion () == null ? "&nbsp;" : oUsuario.getsObservacion ()) %>&nbsp;</span></td>
                                <td align="center"><span><IMG onClick="EditarUsuario('<%= oUsuario.getiNumSecuUsu ()%>');"  alt="Ver datos del usuario" src="<%= Param.getAplicacion() %>images/nuevo.gif"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;"></span></td>
                                <td align="center"><span><IMG onClick="CambiarEstado('<%= oUsuario.getiNumSecuUsu ()%>','<%= oUsuario.getsHabilitado ()%>');"  alt="Habilitar/Deshabilitar usuario" src="<%= Param.getAplicacion() %>images/<%= (oUsuario.getsHabilitado ().equals("S") ? "nook.gif" : "ok.gif") %>"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;"></span></td>
                            </tr>
                            </pg:item> 
                            <%}  %>
                              <thead>
                                <th colspan="10">
                                    <pg:prev>
                                    <a class="rnavLink" href="<%= pageUrl %>&opcion=getAllUsuarios&estado=<%= (request.getParameter("estado") == null ? "A" : request.getParameter("estado")) %>">[Anterior]</a>
                                    </pg:prev>
                                    <pg:pages>
                               <% if (pageNumber == currentPageNumber) { %>
                                    <b><%= pageNumber %></b>
                               <% } else { %>
                                    <a class="rnavLink" href="<%= pageUrl %>&opcion=getAllUsuarios&estado=<%= (request.getParameter("estado") == null ? "A" : request.getParameter("estado")) %>"</a>										   
                               <% } %>
                                    </pg:pages>
                                    <pg:next>
                                    <a class="rnavLink" href="<%= pageUrl %>&opcion=getAllUsuarios&estado=<%= (request.getParameter("estado") == null ? "A" : request.getParameter("estado")) %>">[Siguiente]</a>
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
        <td width="100%" align="center">
            <TABLE  width='100%' border="0" cellspacing="0" cellpadding="0" height="30px" align="center" >
                <TR>
                    <TD align="center">
                        <input type="button" name="cmdSalir" value=" Salir "  height="20px" class="boton" onClick="Salir();">
                        <input type="button" name="cmdSalir" value=" Agregar nuevo usuario "  height="20px" class="boton" onClick="EditarUsuario( -1 );">
                    </TD>
                </TR>
            </TABLE>		
        </td>
    </tr>
   <TR>
        <TD valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
    </tr>
</table>
</body>
<script>
     CloseEspere();
</script>
