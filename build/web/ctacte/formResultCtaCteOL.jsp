<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.CtaCteOL"%>
<%@page import="com.business.beans.Generico"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.*"%>
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>
<%@ taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg" %>
<%  
    LinkedList ctasCtesOL = (LinkedList) request.getAttribute("ctasCtesOL");
    Diccionario oDicc   = (Diccionario) session.getAttribute("Diccionario");
    Usuario usu = (Usuario) session.getAttribute("user");
    int iSize    = (ctasCtesOL == null ? 0 : ctasCtesOL.size());
    String sPri  = oDicc.getString(request,"cc_pri","S");
    int iCodProd = oDicc.getInt (request, "cc_cod_prod");
    int iFecha   = oDicc.getInt (request, "cc_fecha_ol_yyyymm");
    String sCodProdDesc  = oDicc.getString(request,"cc_prod_desc");
    String sFechaOL  = oDicc.getString(request,"cc_fecha_ol");
    oDicc.add("cc_pri", sPri );
    oDicc.add("cc_cod_prod", String.valueOf(iCodProd));
    oDicc.add("cc_fecha_ol_yyyymm", String.valueOf (iFecha));
    oDicc.add("cc_prod_desc", sCodProdDesc);
    oDicc.add("cc_fecha_ol", sFechaOL);
    session.setAttribute("Diccionario", oDicc);
    String sPath = "&cc_pri=N" +
                   "&cc_cod_prod="+iCodProd+
                   "&cc_fecha_ol_yyyymm=" + iFecha  +
                   "&cc_fecha_ol=" + sFechaOL  +
                   "&cc_prod_desc=" + sCodProdDesc  +
                   "&opcion=getCtasCtesOL";
    HtmlBuilder ohtml       = new HtmlBuilder();
    Tablas oTabla = new Tablas ();
    LinkedList lTabla = new LinkedList ();

    String fechaDesde = "";    
    String _anioMes = String.valueOf( iFecha );
   
    String _anio    = _anioMes.substring(0,4);
    String _mes     = _anioMes.substring(4,_anioMes.length());    
    fechaDesde =    "01/" + _mes + "/" + _anio;
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
    <SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <SCRIPT language="javascript">  
  
    function Salir () {
        window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }
    function Buscar() {
        document.form1.action = "<%= Param.getAplicacion()%>servlet/CtaCteServlet";
        document.form1.opcion.value  = 'selectCtaCte';
        document.form1.submit();        
    }
    function VisualizarCertificado (){
        alert("Certificado");
    }
    function Visualizar ( formato ) {

        alert("formato " + formato );
        document.form2.action = "<%= Param.getAplicacion()%>servlet/CtaCteServlet";
        document.form2.opcion.value = "printCtaCteOL";
        document.form2.formato.value = formato;
        document.form2.submit();
        return true;
    }

    </SCRIPT>
</head>
<body>
<form method="post" action="<%= Param.getAplicacion()%>servlet/CtaCteServlet" name='form2' id='form2'>
    <input type="hidden" name="opcion" id="opcion" value="printCtaCteHIS"/>
    <input type="hidden" name="formato" id="formato" value=""/>
    <input type="hidden" name="cc_cod_prod" id="cc_cod_prod" value="<%= iCodProd %>"/>
    <input type="hidden" name="cc_fecha_ol_yyyymm" id="cc_fecha_ol_yyyymm" value="<%= iFecha %>"/>

</form>
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
        <td>
            <TABLE border="0"  width="95%" cellPadding="0" cellSpacing="1" align="center" >
<%--
                           if (iSize  > 1 ){
%>
                <tr><td>&nbsp;</td></tr>
                <tr>
                    <td class='tituloSolapa' colspan='4'align="center"  >
                        <a href="#" onclick="Visualizar('PDF');"><img src='<%=Param.getAplicacion()%>images/PDF.gif' border='0'>&nbsp;Bajar a PDF</a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <a href="#" onclick="Visualizar('EXCEL');"><img src='<%=Param.getAplicacion()%>images/XLS.gif' border='0'>&nbsp;Bajar a Excel </a>
                     </td>
                </tr>
                <tr><td>&nbsp;</td></tr>
<%
                           }
--%>

              
                <tr>
                    <td>
                        <table border="0" width="100%">
                            <tr>
                                <td colspan='0' height="20px" valign="middle" align="center" class='titulo'>CUENTAS CORRIENTES ON LINE AL <%=sFechaOL%></td>
                            </tr>
                             <tr>
                                <td colspan='0' height="20px" valign="middle" align="left" class='subTitulo'>PRODUCTOR&nbsp;:&nbsp;&nbsp;&nbsp;<%=sCodProdDesc %>&nbsp;&nbsp; &nbsp;&nbsp;PERIODO&nbsp;:&nbsp;<%=fechaDesde%>&nbsp;AL&nbsp;<%=sFechaOL%></td>
                            </tr>
                        </table>
                    </td>
                </tr>

               <tr><td>&nbsp;</td></tr>
                <TR>
                    <td valign="top"  width='100%'>
                        <pg:pager  maxPageItems="20" items="<%= iSize %>" url="/benef/servlet/CtaCteServlet"
                        maxIndexPages="20" export="currentPageNumber=pageNumber">
                        <pg:param name="keywords"/>

                        <table  border="0" cellspacing="0" cellpadding="2" align="center" class="TablasBody" width='100%'>
                            <thead>
                                <th width='75px' nowrap>Fecha Mov.</th>
                                <th width="85px">Movimiento</th>
                                <th width="285px">Concepto</th>
                                <th width="50px">Debe</th>
                                <th width="50px">Haber</th>
                                <th width="80px">Serv.Soc.</th>
                                <th width="35px" >I.B. 1</th>
                                <th width="35px" >I.B. 2</th>
                                
                            </thead>
<% 
                           if (iSize  <= 1 ){
%>
                            <tr>
                                <td colspan="4" height='25' valign="middle"><SPAN style='color:red'>No existen cuentas corrientes para la consulta realizada</span></td>
                            </tr>
<%                         
                           } else {

                               for (int i=0; i < iSize; i++)  {
                                   CtaCteOL oCtaCteOL = (CtaCteOL) ctasCtesOL.get(i);
                                   if (oCtaCteOL.getOrdene() == 1  ||oCtaCteOL.getOrdene() ==9 ) {
                                       
%>
                             <tr>
                                 <td nowrap colspan="3" height="40"  align="center" valign="middle"><strong><label style=" font-size:11 ; "><%= (oCtaCteOL.getConcepto()   == null?" ": oCtaCteOL.getConcepto())%></label></strong></td>
                                 <td align="right"><strong><label style="font-size:11;"><%= Dbl.DbltoStr(oCtaCteOL.getDebe(),2) %></label></strong></td>
                                 <td align="right"><strong><label style="font-size:11;"><%= Dbl.DbltoStr(oCtaCteOL.getHaber(),2)%></label></strong></td>
                                 <td colspan="3">&nbsp;</td>
                             </tr>
<%
                                   } else {
%>


                            <pg:item>
                                <tr>
                                   <td align="center"><%= (oCtaCteOL.getFechaMov()   == null?" ": Fecha.showFechaForm(oCtaCteOL.getFechaMov()))  %></td>
                                   <td align="left">   <%= (oCtaCteOL.getMovimiento()   == null?" ": oCtaCteOL.getMovimiento())%></td>
                                   <td align="left">   <%= (oCtaCteOL.getConcepto()   == null?" ": oCtaCteOL.getConcepto())%></td>
                                   <td align="right">  <%= Dbl.DbltoStr(oCtaCteOL.getDebe(),2) %></td>
                                   <td align="right">  <%= Dbl.DbltoStr(oCtaCteOL.getHaber(),2) %></td>
                                   <td align="right">  <%= Dbl.DbltoStr(oCtaCteOL.getImpSoc(),2) %></td>
                                   <td align="right">  <%=  oCtaCteOL.getPring1()%></td>
                                   <td align="right">  <%=  oCtaCteOL.getPring2()%></td>
                                   <!--td align="right">  <%=  oCtaCteOL.getOrdene()%></td-->
                                </tr>
                            </pg:item>
<%
                                   } //if (oCtaCteOL.getOrdene() == 1  ||oCtaCteOL.getOrdene() ==99 ) {
%>

<%
                               } //for
%>
<%
                           } // if
%>
                             <thead>
                                <th colspan="8">
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

<%--
                           if (iSize  > 1 ){
%>

   <tr>
        <td valign="top" align="center" width="755">
            <table width="680" border="0" align="center" cellspacing="0" cellpadding="0"  class="fondoForm1" style='margin-top:5;margin-bottom:5;'>
                <tr>
                    <td class='tituloSolapa' colspan='4'align="center"  >
                        <a href="#" onclick="Visualizar('PDF');"><img src='<%=Param.getAplicacion()%>images/PDF.gif' border='0'>&nbsp;Bajar a PDF</a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <a href="#" onclick="Visualizar('EXCEL');"><img src='<%=Param.getAplicacion()%>images/XLS.gif' border='0'>&nbsp;Bajar a Excel </a>
                     </td>
                </tr>
                <tr><td>&nbsp;</td></tr>                                    
            </table>          
       </td>

   </tr>
<%
                           }
--%>
    <tr>
        <td valign="top" align="center" width="755">

            <form name="form1" id="form1"method="POST" action="<%= Param.getAplicacion()%>servlet/CtaCteServlet">

                <input type="hidden" name="opcion" id="opcion" value="getCtasCtesHis">
                <input type="hidden" name="cc_pri" id="cc_pri" value="S">
                <input type="hidden" name="volver" id="volver" value='formCtaCte'>
                
                <TABLE width="680" border="0" align="center" cellspacing="0" cellpadding="0"  class="fondoForm1" style='margin-top:5;margin-bottom:5;'>



                    <tr>
                        <td align="center" >
                        <input type="button" name="cmdSalir"  value="  Salir  "  height="20px" class="boton" onClick="Salir ();">&nbsp;&nbsp;&nbsp;&nbsp;                        
                        <input type="button" name="cmdBuscar" value="  Volver  "  height="20px" class="boton" onClick="Buscar ();">
                        </td>
                    </tr>
                 </table>
            </form>
        </td>
    </tr>
   <TR>
        <TD valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
   </tr>
</TABLE>
<script>
     CloseEspere();
</script>
</body>
</HTML>
