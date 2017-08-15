<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.CertificadoIBSS"%>
<%@page import="com.business.beans.Generico"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.*"%>
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>
<%@ taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg" %>
<%     
    LinkedList certificadoIBSS = (LinkedList) request.getAttribute("certificadoIBSS");
    Diccionario oDicc   = (Diccionario) session.getAttribute("Diccionario");
    int iSize        = (certificadoIBSS == null ? 0 : certificadoIBSS.size());
    String sPri      = oDicc.getString(request,"ce_pri","S");
    int iCodProd     = oDicc.getInt   (request,"ce_cod_prod");
    Usuario usu = (Usuario) session.getAttribute("user");
    oDicc.add("ce_pri", sPri );
    oDicc.add("ce_cod_prod", String.valueOf(iCodProd));
    session.setAttribute("Diccionario", oDicc);
    String sPath  = "&ce_pri=N" +
                    "&ce_cod_prod="+iCodProd+
                    "&opcion=getAllCertIBSS";    
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Certif. de Ret.IB y Servicios Sociales</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <script type="text/javascript" language="javascript">
    function Salir () {
        window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }   
    function Buscar() {
        document.form1.action = "<%= Param.getAplicacion()%>servlet/CertificadoServlet";
        document.form1.opcion.value  = 'getAllCertIBSS';
        document.form1.submit();
    }
    function ViewCertificadoIBSS ( pNumCertificado ) {
        document.form1.action = "<%= Param.getAplicacion() %>certificado/IBSS/printCertifIBSS.jsp";
        document.form1.opcion.value    = "getCertificadoIBSS";
        document.form1.ce_origen.value = "filtrarCertificadoIBSS";
        document.form1.ce_num_certificado.value = pNumCertificado;
        document.form1.submit();
    }
function CambiarSelectProd ( accDir ) {
        var       i = 0;
        var bExiste = false;

        if ( (accDir.value == "" || accDir.value == "0")) {
            if (document.getElementById ('ce_cod_prod').value != "0") {
                document.getElementById ('ce_cod_prod').value = "0";
            }
            return true;
        } else {
            for (i = 0; i < document.getElementById ('ce_cod_prod').length; i++) {
                if (document.getElementById ('ce_cod_prod').options [i].value == accDir.value) {
                    bExiste = true;
                    break;
                }
            }
            if ( bExiste ) {
                document.getElementById ('ce_cod_prod').value = accDir.value;
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
        <td valign="top" align="center" width="755">
            <form name="form1" id="form1" method="POST" action="<%= Param.getAplicacion()%>servlet/CertificadoServlet">
               <input type="hidden" name="opcion" id="opcion" value="getAllCertIBSS">
               <input type="hidden" name="ce_pri" id="ce_pri" value="N">
               <input type="hidden" name="ce_num_certificado" id="ce_num_certificado" value="">
               <input type="hidden" name="ce_origen"          id="ce_origen" value="filtrarCertificadoIBSS">
                <table width="680" border="0" align="center" cellspacing="0" cellpadding="0"  class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                    <tr>
                        <td height="30px" valign="middle" align="center" class='titulo'>CERTIFICADOS RETENCION DE INGRESOS BRUTOS Y SERVICIOS SOCIALES</td>
                    </tr>
                    <tr>
                        <td align="center" valign="top" width="100%">
                            <table border='0' align="center" cellpadding='2' cellspacing='2'>

<%
    if (usu.getiCodTipoUsuario() == 0 || usu.getiCodProd () >= 80000) {
%>
                                <tr>
                                    <td align="left" class="text"  >Productor:&nbsp;
                                        <select class='select' name="ce_cod_prod" id="ce_cod_prod">
<%
         LinkedList lProd = (LinkedList) session.getAttribute("Productores");
         for (int i= 0; i < lProd.size (); i++) {
             Usuario oProd = (Usuario) lProd.get(i);
             out.print("<option value='" + oProd.getiCodProd() + "' " + (oProd.getiCodProd() == usu.getiCodProd () ? "selected" : " ") + ">" + oProd.getsDesPersona() + " (" + oProd.getiCodProd() + ")</option>");
         }
%>
                                        </select>
                                    &nbsp;
                                    <LABEL>Cod : </LABEL>
                                    &nbsp;
                                    <INPUT name="prod_dir" id="prod_dir" value='0' size='10' maxlength='10'
                                           class='inputTextNumeric' onchange='CambiarSelectProd ( this );' onkeypress="" >
                                    </td>
                                </tr>
<%    } else {
    %>
                                <input type="hidden" name="ce_cod_prod" id="ce_cod_prod" value="<%= usu.getiCodProd() %>" >
<%
    }
%>
                                <tr><td></td></tr>
                            </table>
                        </td>
                    </tr>
<% if ( usu.getiCodProd()  == 0 || usu.getiCodProd() > 79999 ) {
    %>
                <tr>
                    <td align="center">
                        <input type="button" name="cmdSalir" value=" Salir " height="20px" class="boton" onClick="Salir();">&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button" name="cmdGrabar" value=" Buscar " height="20px" class="boton" onClick="Buscar();">
                    </td>
                </tr>
<%  }
    %>
                </table>
            </form>
        </td>
    </tr>
<%
    if (sPri != null && sPri.equals ("N")) {
%>
    <tr>
        <td>
            <table border="0"  width="95%" cellPadding="0" cellSpacing="1" align="center" >
                <tr>
                    <td colspan='5' height="30px" valign="middle" align="center" class='titulo'>Resultado de la consulta:</TD>
                </tr>               
                <tr>
                    <td valign="top"  width='100%'>
                        <pg:pager  maxPageItems="20" items="<%= iSize %>" url="/benef/servlet/CertificadoServlet"
                        maxIndexPages="20" export="currentPageNumber=pageNumber">
                        <pg:param name="keywords"/>
                        <table  border="0" cellspacing="0" cellpadding="2" align="center" class="TablasBody" width='85%'>
                            <thead>                                
                                <th width='50px' align="center" >Certificado</th>
                                <th width="80px" align="center">Cod.Prod.</th>
                                <th  width="180px" align="center" nowrap>Razón social</th>
                                <th width="50px" align="center">F.Emisión</th>
                                <th  width="110px" align="center" nowrap>Periodo</th>
                                <th  width="10px" align="center">&nbsp;</th>
                            </thead>
<%
                           if (iSize == 0 ){
%>
                            <tr>
                                <td colspan="6" height='25' valign="middle"><SPAN style='color:red'>No existen certificados Ret.I.B. y Servicios Sociales para la consulta realizada</span></td>
                            </tr>
<%                         } else {
                               for (int i=0; i < iSize; i++)  {
                                    CertificadoIBSS oCertifIBSS = (CertificadoIBSS) certificadoIBSS.get(i);
%>
                          <pg:item>
                            <tr>                                
                                <td align="right" class="subtitulo"><%=oCertifIBSS.getNumCertificado()%></td>
                                <td align="right" class="text"> <%=(oCertifIBSS.getCodProdDC()==null?"":oCertifIBSS.getCodProdDC())%></td>
                                <td align="left" class="text"><%=(oCertifIBSS.getRazonSocial()==null?"":oCertifIBSS.getRazonSocial())%></td>
                                <td align="center" class="text"><%= (oCertifIBSS.getFechaEmision() == null ? " " : Fecha.showFechaForm(oCertifIBSS.getFechaEmision()))%></td>
                                <td align="center" class="text"><%=(oCertifIBSS.getPeriodo()==null?"":oCertifIBSS.getPeriodo())%></td>
                                <td align="center">
                                    <span>
                                        <IMG height='16'onClick="ViewCertificadoIBSS('<%= oCertifIBSS.getNumCertificado()%>' );"
                                        width='16' onClick="javascript:VisualizarCertificado()"
                                        alt="Certificado de retención de IB y Ser. Sociales" src="<%= Param.getAplicacion() %>images/certificado3.gif"
                                        border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;"/>
                                    </span>
                                </td>
                            </tr>
                        </pg:item>
<%
                               } // for
                           } // end if. size
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

               <tr>
                    <td class="subtitulo" height="30" valign="middle">
                        <IMG height='16' width='16' alt="Visualizar certificado de Retención de Ing. Brutos y Serv. Sociales"
                            src="<%= Param.getAplicacion() %>images/certificado3.gif" border="0"  hspace="0" vspace="0"/>
                            &nbsp;&nbsp;Haga click en el icono para visualizar el certificado de retención
                    </td>
               </tr>

            </table>
        </td>
    </tr>

<%
    } //sPri=="N"
%>
    <tr><td>&nbsp;</td></tr>
    <tr><td>&nbsp;</td></tr>
    <tr>
        <td valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
   </tr>
</table>
<script>
     CloseEspere();
<% if (usu.getiCodTipoUsuario() == 1 && usu.getiCodProd() < 80000 && ( sPri == null || sPri.equals ("S"))) {
    %>
        Buscar();
<% }
    %>
</script>
</body>
</HTML>
