<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%> 
<%@page import="com.business.beans.Propuesta"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.CallableStatement"%>
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>
<%@ taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg" %>
<%
     Usuario usu = (Usuario) session.getAttribute("user"); 
     String sParam = "";  

    Connection        dbCon = null;
    ResultSet rs            = null;
    CallableStatement cons  = null;
    LinkedList        lProp  = new LinkedList();

    try {  
        dbCon = db.getConnection();                                
        dbCon.setAutoCommit(false);            
        cons = dbCon.prepareCall(db.getSettingCall("CE_GET_PROPUESTAS_CERTIFICADO(?, ?, ?, ?, ?)"));            
        cons.registerOutParameter(1, java.sql.Types.OTHER);
        cons.setString  (2, usu.getusuario());
        cons.setInt     (3, usu.getiCodTipoUsuario());
        cons.setInt     (4, usu.getiCodProd ());
        cons.setInt     (5, usu.getoficina());
        cons.setInt     (6, usu.getzona());
        
         
        cons.execute();
            
       rs = (ResultSet) cons.getObject(1);
        if (rs != null) {
            while (rs.next()) {
                Propuesta oProp = new Propuesta();
                oProp.setDescRama       (rs.getString ("DESC_RAMA"));
                oProp.setNumPropuesta   (rs.getInt("NUM_PROPUESTA"));
                oProp.setNumSecuCot     (rs.getInt("NUM_SECU_COT"));
                oProp.setFechaTrabajo   (rs.getDate("FECHA_TRABAJO"));
                oProp.setCodEstado      (rs.getInt("COD_ESTADO")); 
                oProp.setNumPoliza      (rs.getInt ("NUM_POLIZA"));
                oProp.setDescError      (rs.getString("DESC_ERROR"));
                oProp.setdescEstado     (rs.getString("DESCRIPCION")); // DESCRIPCION ESTADO                  
                oProp.setdescProd       (rs.getString("DESC_PROD"));
                oProp.setTipoPropuesta  (rs.getString("TIPO_PROPUESTA"));
                oProp.setCodRama        (rs.getInt ("COD_RAMA")); 
                oProp.setNumCertificado (rs.getInt("NUM_CERTIFICADO"));
                oProp.setTomadorRazon   (rs.getString ("TOMADOR"));
                lProp.add(oProp);
                
            }
            rs.close ();
        }
    } catch (Exception e) {
        throw new SurException (e.getMessage());
    } finally {
        try {
            if (rs != null) rs.close ();
            if (cons != null) cons.close ();
        } catch (SQLException se) {
            throw new SurException (se.getMessage());
        }
        db.cerrar(dbCon);
    }
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>Listado de propuestas - certificado </title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
<script type="text/javascript" language="JavaScript">
    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

    function addCertif ( numProp, numCertif, codRama, tipoProp) {
        nombre = prompt('Ingrese ante quien será presentado el certificado', ''); 
        document.form1.presentar.value     = nombre;       
        document.form1.num_propuesta.value = numProp;
        document.form1.numCert.value       = numCertif;
        document.form1.cod_rama.value      = codRama;
        if (tipoProp == 'E') {
            document.form1.tipo_cert.value = 'EN';
        }
        document.form1.action              = "<%= Param.getAplicacion() %>servlet/CertificadoServlet";
        document.form1.opcion.value        = "addCertificadoProp"; 
        document.form1.submit();
    }

    function PrintCertif ( numCertif, tipo, tipoProp  ) {
        document.form1.action = "<%= Param.getAplicacion() %>certificado/printCertificado.jsp";
        document.form1.opcion.value     = "getPrintCert";        
        document.form1.numCert.value    = numCertif;
        document.form1.tipo.value       = tipo;      
        if (tipoProp == 'E') {
            document.form1.tipo_cert.value = 'EN';
        }
        document.form1.submit();
    }
</script>
</head>
<body>
<FORM action='<%= Param.getAplicacion()%>servlet/CertificadoServlet' id="form1" name="form1"  method="POST">
    <input type="hidden" name="opcion"          id="opcion"          value=""/>
    <input type="hidden" name="num_propuesta"   id="num_propuesta"   value="0"/>
    <input type="hidden" name="numCert"         id="numCert"         value="0"/>
    <input type="hidden" name="cod_rama"        id="cod_rama"        value="0"/>
    <input type="hidden" name="tipo"            id="tipo"            value="0"/>
    <input type="hidden" name="presentar"       id="presentar"/>
    <input type="hidden" name="tipo_cert"       id="tipo_cert"       value="PR"/>
    <input type="hidden" name="volver" id="volver" value="-1"/>
</FORM>
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
                <TR>
                    <TD height='30px'  valign="middle" class='titulo' align="center">PROPUESTAS PENDIENTES DE EMISION (generadas desde Internet)</td>
                </TR>
                <tr>
                    <td height='30px' valign="middle" class="subtitulo" align="left">
                        Si desea visualizar los certificados de propuestas emitidos, ingrese desde Certificados -> Consulta o haga&nbsp;
                        <a href='/benef/servlet/CertificadoServlet?opcion=getAllCert' class='link'>click aqui</A>
                    </td>
                </tr>    
                <TR>
                    <TD valign="middle" height='25' class='text' align="left"><b>Referencias:</b></td>
                </TR>
                <tr>
                    <td class='text' height='25' valign="middle">
&nbsp;&nbsp;&nbsp;<IMG src="<%= Param.getAplicacion() %>images/certificado3.gif"  border="0">&nbsp;Emitir el certificado de propuesta.
<%--&nbsp;&nbsp;&nbsp;<IMG  src="<%= Param.getAplicacion() %>images/PDF.gif"  border="0">&nbsp;Visualizar el certificado en formato PDF.<br>
&nbsp;&nbsp;&nbsp;<IMG  src="<%= Param.getAplicacion() %>images/HTML.gif"  border="0">&nbsp;Visualizar el certificado en formato web.
--%>                    </td>
                </tr>   
                <TR>
                    <td height="100%"  valign="top">
                        <TABLE border="0" cellPadding="0" cellSpacing="0" align="center" style="margin-top:10;margin-bottom:10;">
                            <TR>
                                <td valign="top" width='100%'> 
                                    <pg:pager  maxPageItems="25"  items="<%= lProp.size() %>" url="/benef/certificado/propuesta/formAllCertificadoProp.jsp"
                                               maxIndexPages="20" export="currentPageNumber=pageNumber">
                                    <pg:param name="keywords"/>
                                        <table border="1" cellspacing="0" cellpadding="2" align="center" style="margin-left:5px;" class='TablasBody'>
                                            <thead>
                                                <th align="center" width='40' nowrap>Tipo</th>
                                                <th align="center" width='100' nowrap>Rama</th>
                                                <th align="center" width='60'>Propuesta</th>                                                
                                                <th align="center" width='150'>Asegurado</th>                                                
                                                <th align="center" width='60'>Fecha ingreso</th>                                                                                                
                                                <th align="center" width='150'>Productor</th>  
                                                <th align="center" width='50'>Num.Cert.</th>                                                                                                 
  <%--                                              <th align="center" colspan='2'>Ver<br>cert.</th>
--%>
                                                <th align="center">Emitir<br/>certificado</th>
                                            </thead>
            <%                              if (lProp.size() == 0){%>
                                            <tr>
                                                <td colspan="8">No existen propuestas pendientes de emisión</td>
                                            </tr>
            <%                              }  
                                            for (int i=0; i < lProp.size (); i++) {
                                                Propuesta oProp = (Propuesta) lProp.get (i);
                                                // int       numCertif = ((Integer)lCertif.get (i)).intValue(); 
                                                int       numCertif = oProp.getNumCertificado();
                                                String sTipo = "P&oacute;liza";
                                                if (oProp.getTipoPropuesta().equals ("E")) {
                                                    sTipo = "Endoso";
                                                }
            %>
                                      <pg:item>
                                            <tr>                                             
                                                <td align="left" nowrap><%= sTipo %></td>
                                                <td align="left" nowrap><%= oProp.getDescRama ()%></td> 
                                                <td align="right"><%= oProp.getNumPropuesta()%></td>                                                     
                                                <td align="left"><%= (oProp.getTomadorRazon() == null ? "&nbsp;" : (oProp.getTomadorRazon().length () <= 19 ? oProp.getTomadorRazon() : oProp.getTomadorRazon().substring (0,19))) %></td> 
                                                <td align="right"><%= Fecha.showFechaForm(oProp.getFechaTrabajo())%></td>                                                                                                 
                                                <td align="left"><%= (oProp.getdescProd() == null ? "&nbsp;" : (oProp.getdescProd().length () <= 19 ? oProp.getdescProd() : oProp.getdescProd().substring (0,19))) %>&nbsp;</td>
                                                <td align="right"><%= numCertif%></td> 
                                                <td align="center"><span><IMG onClick="addCertif('<%= oProp.getNumPropuesta()%>','<%= numCertif %>','<%= oProp.getCodRama ()%>','<%= oProp.getTipoPropuesta ()%>' );"
                                                                              alt="Generar el Certificado" src="<%= Param.getAplicacion() %>images/certificado3.gif"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;">
                                                                   </span>
                                                </td>
<%--                                          if ( numCertif == 0 ) { %>
                                                <td>&nbsp;</td>                                                
                                                <td>&nbsp;</td>                                                
                                                <td align="center"><span><IMG onClick="addCertif('<%= oProp.getNumPropuesta()%>','<%= numCertif %>','<%= oProp.getCodRama ()%>','<%= oProp.getTipoPropuesta ()%>' );"  alt="Generar el Certificado" src="<%= Param.getAplicacion() %>images/certificado3.gif"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;"></span></td>
<%                                          } else {%>

                                                <td align="center"><span><IMG onClick="PrintCertif ('<%= numCertif %>','pdf','<%= oProp.getTipoPropuesta ()%>' );"  alt="Ver el certificado en formato PDF " src="<%= Param.getAplicacion() %>images/PDF.gif"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;"></span></td>       
                                         
                                                <td align="center"><span><IMG onClick="PrintCertif ('<%= numCertif %>','html','<%= oProp.getTipoPropuesta ()%>' );" alt="Ver el certificado en formato para imprimir" src="<%= Param.getAplicacion() %>images/HTML.gif"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;"></span></td>       
                                                <td>&nbsp;</td>
<%                                          } --%>                
                          
                                             </tr>                                            
                                        </pg:item> 
<%
                                            }     
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


