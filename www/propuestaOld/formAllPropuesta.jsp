<%@page contentType="text/html" errorPage="/error.jsp" session="true"%>
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
<%@ taglib uri="http://jsptags.com/tags/navigation/pager" prefix="pg" %>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
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
        cons = dbCon.prepareCall(db.getSettingCall("PRO_GET_ALL_PROPUESTAS(?, ?, ?, ?, ?)"));            
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


<html>
<head><title>Listado de propuestas de Pólizas y Endosos</title>
    <LINK rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css">	
<script language="JavaScript">

    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

    function Ver ( numProp, estado , tipo ) {
        
        document.form1.numPropuesta.value = numProp;
        document.form1.num_propuesta.value = numProp;
        
        if ( estado == 0 || estado == 4 ) {
            if (tipo == 'P') {
                document.form1.action = "<%= Param.getAplicacion() %>servlet/PropuestaServlet";
                document.form1.opcion.value = "getPropuestaBenef";
            } else {
                document.form1.action = "<%= Param.getAplicacion() %>servlet/EndosoServlet";
                document.form1.opcion.value = "editEndoso";
            }
        } else  {
            if (tipo == 'P') {
                document.form1.action = "<%= Param.getAplicacion() %>propuesta/printPropuesta.jsp";
                document.form1.opcion.value = "printPropuesta";
             } else {
                document.form1.action = "<%= Param.getAplicacion() %>propuesta/printEndoso.jsp";
                document.form1.opcion.value = "printEndoso";
             }
        }
        document.form1.submit();
    }

   function PrintCertif ( numCertif, tipo ) {
        // alert( "  certif " + numCertif + " tipo " + tipo);
        document.form1.action = "<%= Param.getAplicacion() %>certificado/printCertificado.jsp";
        document.form1.opcion.value     = "getPrintCert";        
        document.form1.numCert.value    = numCertif;
        document.form1.tipo.value       = tipo;      
        document.form1.submit();
    }


    function addCertif ( numProp, numCertif, codRama ) {
        // alert(" numProp " + numProp + "  certif " + numCertif + " cod Rama " + codRama);
        nombre = prompt('Ingrese ante quien será presentado el certificado', ''); 

        document.form1.presentar.value     = nombre;       

        document.form1.num_propuesta.value = numProp;
        document.form1.numCert.value       = numCertif;
        document.form1.cod_rama.value      = codRama;
        document.form1.action              = "<%= Param.getAplicacion() %>servlet/CertificadoServlet";
        document.form1.opcion.value        = "addCertificadoProp"; 


        document.form1.submit();
    }

</script>
</head>
<body leftMargin=20 topMargin=5 marginheight="0" marginwidth="0">
<menu:renderMenuFromDB  aplicacion="1" userLogon="<%= usu.getusuario()%>" />

<FORM action='<%= Param.getAplicacion()%>servlet/PropuestaServlet' id="form1" name="form1"  method="POST">
     
    <input type="hidden" name="formato"         id="formato"       value="HTML">
    <input type="hidden" name="opcion"          id="opcion"        value="getPropuestaBenef">
    <input type="hidden" name="numPropuesta"    id="numPropuesta"  value="0">    
    <input type="hidden" name="num_propuesta"   id="num_propuesta" value="0">    
    <input type="hidden" name="cod_rama"        id="cod_rama"      value="10">    
        
    <input type="hidden" name="numCert"         id="numCert"         value="0">
    <input type="hidden" name="tipo"            id="tipo"            value="0">    
    <input type="hidden" name="presentar"       id="presentar"       > 
    <input type="hidden" name="tipo_cert"       id="tipo_cert"       value="PR"> 
    <input type="hidden" name="volver" id="volver" value="-1">    

</FORM>
<TABLE  height="445" cellSpacing=0 cellPadding=0 width=720 align=left border=0>
    <TR>
        <TD valign="top" align="center">
            <jsp:include flush="true" page="/top.jsp"/>
        </td>
    </tr>  
    <tr>
        <td align="center" valign="top" width='100%' height='100%'>
            <TABLE height="100%"   width="100%"  border="0" cellspacing="0" cellpadding="0" align="center" >
                <TR>
                    <TD height='30px'  valign="middle" class='titulo' align="center">PROPUESTAS DE POLIZAS Y ENDOSOS (generadas desde Internet)</td>
                </TR>
                <TR>
                    <TD valign="middle" class='text' align="left"><b>Referencias:</b></td>
                </TR>
                <tr>
                    <td class='text' height='80' valign="middle">
&nbsp;&nbsp;&nbsp;<IMG  width='19' height='19' src="<%= Param.getAplicacion() %>images/consultasPol.jpg"  border="0">&nbsp;Editar la propuesta<br>
&nbsp;&nbsp;&nbsp;<IMG src="<%= Param.getAplicacion() %>images/imprimir.gif"  width='19' height='19' border="0">&nbsp;Visualizar/imprimir la propuesta<br>
&nbsp;&nbsp;&nbsp;<IMG height='21' width='21'  src="<%= Param.getAplicacion() %>images/certificado3.gif"  border="0">&nbsp;Emitir el certificado de propuesta<br>
&nbsp;&nbsp;&nbsp;<IMG src="<%= Param.getAplicacion() %>images/PDF.gif"  border="0">&nbsp;Visualizar el certificado en formato PDF<br>
&nbsp;&nbsp;&nbsp;<IMG src="<%= Param.getAplicacion() %>images/HTML.gif"  border="0">&nbsp;Visualizar el certificado en formato web
                    </td>
                </tr>

                <TR>
                    <td height="100%"  valign="top">
                        <TABLE border="0" cellPadding="0" cellSpacing="0" align="center" style="margin-top:10;margin-bottom:10;">
                            <TR>
                                <td valign="top" width='100%'> 
                                    <pg:pager  maxPageItems="35"  items="<%= lProp.size() %>" url="/benef/propuesta/formAllPropuesta.jsp" maxIndexPages="20" export="currentPageNumber=pageNumber">
                                    <pg:param name="keywords"/>

                                        <table border="1" cellspacing="0" cellpadding="2" align="center" style="margin-left:5px;" class='tablasBody'>
                                            <thead>
                                                <th align="center" width='65'>Propuesta</th>
                                                <th align="center">Tipo</th>
                                                <th align="center" width='100' nowrap>Rama</th>
                                                <th align="center" width='65'>Cotizacion</th>
                                                <th align="center" width='65'>Fecha Creaci&oacute;n</th>                                                
                                                <th align="center" width='145'>Estado</th> 
                                                <th align="center" width='65'>Póliza</th> 
                                                <th align="center" width='155'>Productor</th>  
                                                <th align="center" colspan='2' >&nbsp;</th>
                                                <th align="center">&nbsp;</th>
                                            <thead>
            <%                              if (lProp.size() == 0){%>
                                            <tr>
                                                <td colspan="11">No existen propuestas a listar</td>
                                            </tr>
            <%                              }  
                                            for (int i=0; i < lProp.size (); i++) {
                                                Propuesta oProp = (Propuesta) lProp.get (i); 
                                                String sColor = "";
                                                switch (oProp.getCodEstado()) {
                                                    case 4: sColor = "color:red;";
                                                            break;
                                                    case 5: sColor = "color:green;";
                                                            break;
                                                    default: sColor = "color:black;";
                                                }
            %>
                                      <pg:item>
                                            <tr> 
                                                <td align="right"><%= oProp.getNumPropuesta()%></td> 
                                                <td align="left" nowrap><%= ( oProp.getTipoPropuesta ().equals ("P") ? "Póliza" : "Endoso") %></td> 
                                                <td align="left" nowrap><%= oProp.getDescRama ()%></td> 
                                                <td align="right"><%= oProp.getNumSecuCot()%></td>                                                 
                                                <td align="right"><%= Fecha.showFechaForm(oProp.getFechaTrabajo())%></td>                                                 
<%                                          if (oProp.getCodEstado() == 4) {
    %>
                                                <td align="center"><SPAN style=<%= sColor %>><%= oProp.getdescEstado ()%>&nbsp;-Motivo:&nbsp;<%= (oProp.getDescError()==null)?"no informado" : oProp.getDescError()%></span></td>
<%                                          } else  {
    %>
                                                        <td align="center"><SPAN style=<%= sColor %>><%= oProp.getdescEstado ()%></span></td> 
<%                                                  }
    %>
                                                <td align="right"><b>&nbsp;<%= Formatos.showNumPoliza(oProp.getNumPoliza ())%></b></td>
                                                <td align="left"><%= (oProp.getdescProd() == null ? "&nbsp;" : (oProp.getdescProd().length () <= 15 ? oProp.getdescProd() : oProp.getdescProd().substring (0,15)    ) ) %></td> 
<%                                          if (oProp.getCodEstado() == 0 || oProp.getCodEstado() == 4) {
    %>
                                                <td nowrap  align="center"><span><IMG height='19' width='19' onClick="Ver('<%= oProp.getNumPropuesta()%>','<%= oProp.getCodEstado ()%>','<%= oProp.getTipoPropuesta ()%>');"  alt="Editar la propuesta" src="<%= Param.getAplicacion() %>images/consultasPol.jpg"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;"></span></td>
<%                                          } else {
    %>
                                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
<%                                          }
                                          if (oProp.getCodEstado() != 0) {
    %>
                                                <td nowrap  align="center"><span><IMG onClick="Ver('<%= oProp.getNumPropuesta()%>','<%= oProp.getCodEstado ()%>','<%= oProp.getTipoPropuesta ()%>');"  alt="Imprimir la propuesta" src="<%= Param.getAplicacion() %>images/imprimir.gif"  width='19' height='19' border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;"></span></td>
<%                                          } else {
    %>
                                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
<%                                          }
    %>
<%                                          if ( oProp.getNumCertificado() == 0 && (oProp.getCodEstado()== 1 || oProp.getCodEstado()== 2 || oProp.getCodEstado()== 3) &&
                                                 oProp.getTipoPropuesta ().equals ("P")  ) { 
    %>
                                                <td  align="center"><span><IMG height='21' width='21' onClick="javascript:addCertif('<%= oProp.getNumPropuesta()%>','<%= oProp.getNumCertificado() %>','<%= oProp.getCodRama ()%>');"  alt="Emitir Certificado de Propuesta" src="<%= Param.getAplicacion() %>images/certificado3.gif"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;"></span></td>                                                
<%                                          } else if ( oProp.getNumCertificado() != 0 ) { 
    %>
                                                <td nowrap  align="center"><IMG height='20' width='20' onClick="PrintCertif ('<%=oProp.getNumCertificado() %>','pdf');"  alt="Ver el certificado en formato PDF " src="<%= Param.getAplicacion() %>images/PDF.gif"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;">&nbsp;                                               
                                                    <IMG height='20' width='20' onClick="PrintCertif ('<%= oProp.getNumCertificado()%>','html');" alt="Ver el certificado en formato web" src="<%= Param.getAplicacion() %>images/HTML.gif"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;">
                                                </td>       
<%                                          } else {
    %>                
                                                <td>&nbsp;</td>
<%                                          }
    %>
                                             </tr>

                                        </pg:item> 
            <%                              }     
                %>
                                        <thead>
                                            <th colspan="11">
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
                <tr>
                    <td align="left" class='texto'>
                        Sr. Productor, los estados posibles de su propuesta son: 
                        <br>
                        <ol type="i">
                                <li><SPAN class='subtitulo'>EN CARGA:</span> significa que usted aún no completó la carga y no la ha enviado. 
                                Para enviarla complete el formulario ingresando desde el icono Editar y luego de cargar la nómina de asegurados 
                                presione el botón "Generar Propuesta".-</li>
                                <li><SPAN class='subtitulo'>ENVIADA PRODUCTOR:</span> la propuesta ya ha sido enviada a nuestro sector comercial.<br>
                                En un termino de 4 hs. usted recibirá la confirmación o rechazo de la misma. La podrá consultar desde "Propuestas --> Mis Propuestas".-</li>
                                <li><SPAN class='subtitulo'>RE-ENVIADA PRODUCTOR:</span> la propuesta fue re-enviada luego de haber sido rechazada por algún problema en la carga.-</li>
                                <li><SPAN class='subtitulo'>CONFIRMADA:</span> la propuesta ha sido controlada y aceptada por nuestro sector comercial.<br> La misma se encuentra en proceso de emisión.-</li>
                                <li><SPAN class='subtitulo'  style="color:red;">RECHAZADA:</span> en la columna de estado encontrará los motivos por los cuales se rechazó la propuesta.<br>
                                Usted puede corregirla y volver a enviarla  ingresando desde el icono Editar (siga los mismos pasos como si estuviera en estado "EN CARGA".- </li>
                                <li><SPAN class='subtitulo' style="color:green;">EMITIDA:</span> La propuesta se ha convertido en póliza. Usted puede consultarla desde "Consultas --> Consulta de Pólizas"</li>
                        </ol>
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

