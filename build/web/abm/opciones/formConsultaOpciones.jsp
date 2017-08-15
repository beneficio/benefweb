<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.OpcionAjuste"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.LinkedList"%>   
<%@page import="java.util.Vector"%>      
<%@ taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg" %>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<% Usuario usu = (Usuario) session.getAttribute("user"); 
    LinkedList lOpciones = (LinkedList) request.getAttribute("opciones"); 
    if (lOpciones == null) {
        lOpciones = new LinkedList ();
    }
    String sParam = "&opcion=getAllOpciones";  
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

    function AltaOpcion () {
        document.form1.action     = "<%= Param.getAplicacion() %>abm/opciones/formOpciones.jsp";
        document.form1.abm.value  = "ALTA";
        document.form1.submit();
    }

    function Editar ( codOpcion ) {
        document.form1.action = "<%= Param.getAplicacion() %>servlet/OpcionesServlet";
        document.form1.opcion.value  = "getOpcion";
        document.form1.cod_opcion.value  = codOpcion
        document.form1.abm.value     = "CONSULTA";
        document.form1.submit();
    }

    function Modificar ( codOpcion ) {
        document.form1.action = "<%= Param.getAplicacion() %>servlet/OpcionesServlet";
        document.form1.opcion.value  = "getOpcion";
        document.form1.cod_opcion.value  = codOpcion
        document.form1.abm.value  = "MODIFICACION";
        document.form1.submit();
    }

    function CambiarEstado(codOpcion , publicadoActual) {
       // alert ( "COD.: " + codOpcion + " ESTA " + publicadoActual); 

       var titulo           = "Publicar";
       var newMcaPublica  = "X" ;
       if ( publicadoActual == 'SI') {
           titulo = "Despublicar"; 
           newMcaPublica  = "" ;
       }

       if( confirm ("Esta usted seguro que desea " + titulo + " el opcion  ? ")) {
           document.form1.action = "<%= Param.getAplicacion() %>servlet/OpcionesServlet";
           document.form1.opcion.value         = "cambiarMcaPublicacion";
           document.form1.cod_opcion.value        = codOpcion
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
                <form  action='<%= Param.getAplicacion() %>servlet/OpcionesServlet' id="form1" name="form1"  method="POST">
                    <input type="hidden" name="opcion"            id="opcion"           value="">       
                    <input type="hidden" name="cod_opcion"        id="cod_opcion"         value="">       
                    <input type="hidden" name="abm"               id="abm"              value="CONSULTA"> 
                    <input type="hidden" name="new_mca_publica" id="new_mca_publica"   value=""> 
                </form>
                <tr>
                    <td height='30px'  valign="middle" class='titulo' align="center">CONSULTA DE OPCIONES de AJUSTE</td>
                </tr> 
                <tr>
                    <td height="100%"  valign="top">
                        <TABLE border="0" width="100%" cellPadding="0" cellSpacing="0" align="center" style="margin-top:0;margin-bottom:0;">
                            <TR>
                                <td valign="top" width='100%'> 
                                    <pg:pager  maxPageItems="30"  items="<%= lOpciones.size() %>" url="/benef/servlet/OpcionesServlet" maxIndexPages="20" export="currentPageNumber=pageNumber">
                                    <pg:param name="keywords"/>

                                        <table border="0" cellspacing="0" cellpadding="2" align="center"  width='100%' style="margin-left:0px;" class='TablasBody'>
                                            <thead>                                                
                                            <th align="center" width='250' nowrap>Opci&oacute;n de ajuste</th>
                                                <th align="center" width='120'>Rama</th>
                                                <th align="center" width='120'>Subrama</th>
                                                <th align="center" width='45'>Ajuste</th>
                                                <th align="center" width="45">Rebaja</th>
                                                <th align="center" width="50">Recargo</th>
                                                <th align="center" width='30'>Cons&nbsp;|&nbsp;Modif</th>
                                                <th align="center" width='30'>Publicado</th>
                                            <thead>
            <%                              if (lOpciones.size() == 0){%>
                                            <tr>
                                                <td colspan="8">No existen opciones de ajuste  >>>> </td>
                                            </tr>
            <%                              }  
                                            for (int i=0; i < lOpciones.size (); i++) {
                                                OpcionAjuste oOpcion = (OpcionAjuste) lOpciones.get (i);
            %>
                                      <pg:item>
                                            <tr>
                                                <td align="left">&nbsp;<%=(oOpcion.getcodOpcion())%>&nbsp;-&nbsp;
                                                <%= (oOpcion.getdescripcion())%></td>
                                                <td align="left">&nbsp;<%= oOpcion.getdescRama() %></td>
                                                <td align="left">&nbsp;<%= oOpcion.getdescSubRama() %></td>
                                                <td align="right">&nbsp;<%= Dbl.DbltoStr(oOpcion.getporcAjuste (), 2) %></td>
                                                <td align="right">&nbsp;<%= oOpcion.getcodRebaja() %></td>
                                                <td align="right">&nbsp;<%= oOpcion.getcodRecargo()%></td>
                                                <td nowrap  align="left">&nbsp;&nbsp;
                                                    <span><IMG onClick="Editar('<%= oOpcion.getcodOpcion()%>');"  alt="Editar opcion " src="<%= Param.getAplicacion() %>images/editdocument.gif"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;">
                                                    </span>
                                      <%        if ( oOpcion.getmcaPublica().trim().equals("X")   ){ %>
                                      &nbsp;
                                      <%        }else { %>
                                      <span>&nbsp;&nbsp;&nbsp;<IMG onClick="Modificar('<%= oOpcion.getcodOpcion()%>');"  alt="Modificar opción de ajuste " src="<%= Param.getAplicacion() %>images/procesado/75.gif"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;">
                                                </td>
                                      <%        } %>
                                               <td align="center"><%=(oOpcion.getmcaPublica().equals("X"))?"SI":"NO"%><span>
                                                   <IMG onClick="CambiarEstado('<%= oOpcion.getcodOpcion()%>','<%=(oOpcion.getmcaPublica().equals("X"))?"SI":"NO"%>');"  alt="Publicar opci&oacute;n de ajuste" src="<%= Param.getAplicacion() %>images/<%= (oOpcion.getmcaPublica().equals("X") ? "ok.gif" : "nook.gif") %>"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;"></span>
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
                        <table width="60%" height="30px" border="0" cellspacing="0" cellpadding="0" align="center" >
                            <TR>
                                <td align="center">
                                    <input type="button" name="cmdSalir" value="Salir" width="100px" height="20px" class="boton" onClick="Salir()">
                                    &nbsp;&nbsp;&nbsp;&nbsp;  
                                    <input type="button" name="cmdNuevo" value="ALta de opción de ajuste" width="100px" height="20px" class="boton" onClick="AltaOpcion()">
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

