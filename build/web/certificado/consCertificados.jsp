<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Certificado"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.LinkedList"%>   
<%@page import="java.util.Vector"%>      
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>
<%@ taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg" %>
<% Usuario usu = (Usuario) session.getAttribute("user"); 
    LinkedList lCertificados = (LinkedList) request.getAttribute("certificados"); 
    String sParam = "&opcion=getAllCert";  
    %>    
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
    <script type="text/javascript" language="JavaScript">
    function Ver ( tipo_cert, numCert, tipo ) {
        if (tipo_cert == 'RE') {
            document.form1.action = "<%= Param.getAplicacion() %>certificado/IBSS/printCertifIBSS.jsp";
            document.form1.opcion.value    = "getCertificadoIBSS";
            document.form1.ce_origen.value = "filtrarCertificadoIBSS";
            document.form1.ce_num_certificado.value = numCert;
        } else {
            document.form1.action = "<%= Param.getAplicacion() %>certificado/printCertificado.jsp";
            document.form1.opcion.value = "getPrintCert";
            document.form1.numCert.value = numCert;
            document.form1.tipo.value = tipo;
            document.form1.tipo_cert.value = tipo_cert;
        }
        document.form1.submit();
    }


    function Editar ( tipo_cert, numCert ) {
        document.form1.action = "<%= Param.getAplicacion() %>servlet/CertificadoServlet";
        document.form1.opcion.value    = "getCert";
        document.form1.numCert.value   = numCert;
        document.form1.tipo_cert.value = tipo_cert;

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
        <td align="center" valign="top" width='100%' height='100%'>
            <form  action='<%= Param.getAplicacion() %>servlet/CertificadoServlet' id="form1" name="form1"  method="POST">
                <input type="hidden" name="opcion" id="opcion" value="getCert"/>
                <input type="hidden" name="numCert" id="numCert" value="0"/>
                <input type="hidden" name="tipo_cert" id="tipo_cert" value=""/>
                <input type="hidden" name="tipo" id="tipo" value="html"/>
                <input type="hidden" name="volver" id="volver" value="-1"/>
               <input type="hidden" name="ce_num_certificado" id="ce_num_certificado" value=""/>
               <input type="hidden" name="ce_origen"          id="ce_origen" value="filtrarCertificadoIBSS"/>
            </form>
            <table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center" >
                <tr>
                    <td height='30px'  valign="middle" class='titulo' align="center">LISTA DE CERTIFICADOS</td>
                </tr> 
                <tr>
                    <td height="100%"  valign="top">
                        <table border="0" cellPadding="0" cellSpacing="0" align="center" style="margin-top:10;margin-bottom:10;">
                            <tr>
                                <td valign="top" width='100%'> 
                                    <pg:pager  maxPageItems="35"  items="<%= lCertificados.size() %>" url="/benef/servlet/CertificadoServlet" maxIndexPages="20" export="currentPageNumber=pageNumber">
                                    <pg:param name="keywords"/>

                                        <table border="1" cellspacing="0" cellpadding="2" align="center"  class="TablasBody" style="margin-left:5px;">
                                            <thead>
                                                <th align="center" width='50'>Tipo</th>
                                                <th align="center" width='50'>Certificado</th>
                                                <th align="center" width='50'>Propuesta</th>
                                                <th align="center" width='50'>P&oacute;liza</th>
                                                <th align="center" width='65'>Fecha carga</th>
                                                <th align="center" width='65'>Hora carga</th>
                                                <th align="center" width='65'>Fecha emisi&oacute;n</th>
                                                <th align="center" width='160'>Solicitado por</th>
                                                <th align="center" width='25' nowrap>Ver</th>
                                        <!--        <th align="center" width='45' >Editar</th>
                                         -->
                                            </thead>
            <%                              if (lCertificados.size() == 0){%>
                                            <tr>
                                                <td colspan="9">No existen certificados de coberturas a listar</td>
                                            </tr>
            <%                              }  
                                            for (int i=0; i < lCertificados.size (); i++) {
                                                Certificado oCert = (Certificado) lCertificados.get (i);
                                                String sTipoCert = "Retención";
                                                if (oCert.gettipoCertificado().equals ("PZ")) {
                                                    sTipoCert = "P&oacute;liza";
                                                    } else if ( oCert.gettipoCertificado().equals ("EN") ) {
                                                         sTipoCert = "Endoso";
                                                         } else if ( oCert.gettipoCertificado().equals ("PR") ) {
                                                            sTipoCert = "Propuesta";
                                                            }
            %>
                                      <pg:item>
                                            <tr>
                                                <td align="center"><%=  sTipoCert %></td>
                                                <td align="right"><%= oCert.getnumCertificado()%></td>
                                                <td align="right">&nbsp;<%= oCert.getnumPropuesta ()%></td>
                                                <td align="right">&nbsp;<%= Formatos.showNumPoliza(oCert.getnumPoliza ())%></td>
                                                <td align="center"><%= (oCert.getfechaTrabajo() == null ? "&nbsp;" : Fecha.showFechaForm(oCert.getfechaTrabajo()))%>&nbsp;</td>
                                                <td align="center"><%= (oCert.gethoraOperacion() == null ? "&nbsp;" : oCert.gethoraOperacion())%>&nbsp;</td>
                                                <td align="center"><%= (oCert.getfechaEmision() == null ? "&nbsp;" : Fecha.showFechaForm(oCert.getfechaEmision()))%>&nbsp;</td>
                                                <td align="left"><%= ( oCert.getdescProd() == null ? "&nbsp;" : oCert.getdescProd() ) %>&nbsp;</td>
                                                <td nowrap  align="center">
                                                    <span><%--<IMG onClick="Ver('<%= oCert.gettipoCertificado ()%>','<%= oCert.getnumCertificado ()%>','html');"  alt="Ver certificado en formato HTML" src="<%= Param.getAplicacion() %>images/HTML.gif"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;">
                                                &nbsp;&nbsp; --%>
                                                        <IMG onClick="Ver('<%= oCert.gettipoCertificado ()%>','<%= oCert.getnumCertificado ()%>','pdf');"
                                                             alt="Ver certificado en formato PDF " src="<%= Param.getAplicacion() %>images/PDF.gif"
                                                             border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;">
                                                    </span>
                                                </td>
     
<%--                                        if(oCert.gettipoCertificado().equals ("PR") && usu.getiCodTipoUsuario() == 0 && oCert.getestadoCertificado () == 0) {
    %>
                                                <td nowrap  align="center"><span><IMG onClick="Editar('<%= oCert.gettipoCertificado ()%>','<%= oCert.getnumCertificado ()%>');"  alt="Ver la solicitud del certificado" src="<%= Param.getAplicacion() %>images/nuevo.gif"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;"></span></td>
<%                                      } else {
    %>
                                                <td nowrap  align="center">&nbsp;</td>

<%                                      }
   --%>
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
                        <table width="100%" height="30px" border="0" cellspacing="0" cellpadding="0" align="center" >
                            <TR>
                                <td align="center">
                                    <input type="button" name="cmdSalir" value="Salir" width="100px" height="20px" class="boton" onClick="Salir()"/>
                                </TD>
                            </TR>
                        </table>
                    </td>
                </tr>
            </table>
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
