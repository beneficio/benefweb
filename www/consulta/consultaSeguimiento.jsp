<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Poliza"%>
<%@page import="com.business.beans.Seguimiento"%>
<%@page import="java.util.LinkedList"%>  
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<% Usuario usu = (Usuario) session.getAttribute("user"); 
   Poliza oPol = (Poliza) request.getAttribute("poliza");
   LinkedList lEndosos = (LinkedList) request.getAttribute("endosos");

   String sVolver = (request.getParameter("volver") == null ? "filtrarPolizas" : request.getParameter("volver"));
    %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title></head>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css">
<script type="" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script language='javascript'>
    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

    function Volver () {
        document.form1.opcion.value = 'getAllPol';
        if (document.getElementById('volver').value == "filtrarPolizas") {
            document.form1.action = "<%= Param.getAplicacion()%>servlet/ConsultaServlet";
        } else {
            document.form1.action = "<%= Param.getAplicacion()%>servlet/RenuevaServlet";
        }
        document.form1.submit();
    }

    function Continuar ( form1, siguiente) {

            form1.opcion.value = siguiente;
            form1.submit();
            return true;
    }

    function Ver ( numProp, tipo ) {
        
        document.form1.numPropuesta.value = numProp;
        
        if (tipo == 'P') {
            document.form1.action = "<%= Param.getAplicacion() %>propuesta/printPropuesta.jsp";
            document.form1.opcion.value = "printPropuesta";
         } else {
            document.form1.action = "<%= Param.getAplicacion() %>propuesta/printEndoso.jsp";
            document.form1.opcion.value = "printEndoso";
         }
        document.form1.submit();
    }
</script>
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
        <td align="center">
            <form method="post" action="<%= Param.getAplicacion()%>servlet/ConsultaServlet"
                  name='form1' id='form1'>
            <input type="hidden" name="opcion" id="opcion" value="getAllCob">
            <input type="hidden" name="solapa" id="solapa" value="cobranza">
            <input type="hidden" name="F1num_poliza_sel" id="F1num_poliza_sel" value="<%= oPol.getnumPoliza ()%>">
            <input type="hidden" name="F1cod_rama_sel" id="F1cod_rama_sel" value="<%= oPol.getcodRama()%>">
            <input type="hidden" name="endoso" id="endoso" value="0">
            <input type="hidden" name="email" id="email" value="">
            <INPUT type="hidden" name="numPropuesta" id="numPropuesta" value="">
            <input type="hidden" name="volver" id="volver"  value="<%= sVolver %>">
<!-- JUSTTABS TOP OPEN -->
            <table cellpadding="0" cellspacing="0" border="0" ALIGN="CENTER" width="100%" bgcolor="#FFFFFF" style='margin-top:10;'>
                <tr height="1">
                    <td colspan="1" width="10">&nbsp;</td>
                    <td rowspan="2" width="347"><a href="#" onclick="Continuar ( document.form1, 'getPol');"><img src="<%= Param.getAplicacion()%>images/solapas/poliza0_ia.GIF" width="82" height="25" hspace="0" vspace="0" border="0" alt="Consulta de póliza"></a><a href="#" onclick="Continuar ( document.form1, 'getAllEnd');"><img src="<%= Param.getAplicacion()%>images/solapas/endosos1_ia.GIF" width="83" height="25" hspace="0" vspace="0" border="0" alt="Consulta de endosos"></a><a href="#" onclick="Continuar ( document.form1, 'getAllCob');"><img src="<%= Param.getAplicacion()%>images/solapas/cobranza2_ia.GIF" width="89" height="25" hspace="0" vspace="0" border="0" alt="consulta de Cobranza" description=""></a><a href="#" onclick="Continuar ( document.form1, 'getAllSegui');"><img src="<%= Param.getAplicacion()%>images/solapas/seguimiento1_a.GIF" width="93" height="25" hspace="0" vspace="0" border="0" alt="Seguimiento de propuestas" description=""></a></td>
                    <td colspan="1" >&nbsp;</td>
                </tr>
                <tr height="1">
                    <td bgcolor="#009BE6" colspan="1" height="1"><img src=pixel.gif width="1" height="1"></td>
                    <td bgcolor="#009BE6" colspan="1" height="1"><img src=pixel.gif width="1" height="1"></td>
                </tr>
            </table>
            <table cellpadding="0" cellspacing="0" border="0" ALIGN="CENTER" width="100%" bgcolor="#FFFFFF">
                <tr >
                    <td  width="1" bgcolor="#009BE6"><img src=pixel.gif width="1" height="1"></td>
                    <td colspan=3 bgcolor="#F3F3F3">
                        <table border="0" cellpadding='2' cellspacing='2'>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td class='tituloSolapa'  width='60' align="left" valign="top">Rama:&nbsp;</td>
                                <td class='tituloSolapa' width='200' align="left" valign="top"><%= oPol.getdescRama() %></td>
                                <td class='tituloSolapa'>Poliza N°:&nbsp;</td>
                                <td class='tituloSolapa'><%= Formatos.showNumPoliza(oPol.getnumPoliza ()) %></td>
                            </tr>
<%                            if (lEndosos.size() != 0) {
   %>
<%                              for (int i=0; i < lEndosos.size();i++) {
                                Poliza  oEnd = (Poliza) lEndosos.get(i);
    %>
                            <tr>
                                <td colspan="5" class='titulo'><img src="<%= Param.getAplicacion()%>images/nuevoS.gif" border="0">&nbsp;Endoso N°&nbsp;<%= ( oEnd.getnumEndoso () == 0 ? "0 (Poliza) " : Formatos.showNumPoliza(oEnd.getnumEndoso ())) %></td>
                            </tr>
<%                              LinkedList lSeg = oEnd.getSeguimiento ();
                                if (lSeg == null || lSeg.size () == 0) {
    %>
                            <tr>
                                <td>&nbsp;</td>
                                <td colspan="4" class='tituloSolapa'>No existe información de seguimiento del endoso</td>
                            </tr>                                
<%                          } else {
    %>
                                </td>
                           </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td colspan='4' align="center">
                                    <table border='1' align="center" cellpadding='0' cellspacing='0' class="TablasBody">
                                        <tr>
                                            <th width='70' class='textSolapa' align="center"><b>Boca</b></th>
                                            <th width='70' class='textSolapa' align="center"><b>Propuesta</b></th>
                                            <th width='70' class='textSolapa' align="center"><b>Fecha</b></th>
                                            <th width='70' class='textSolapa' align="center"><b>Hora</b></th>
                                            <th width='200' class='textSolapa' align="center"><b>Estado</b></th>
                                        </tr>
<%                              
                                for (int j=0; j < lSeg.size();j++) {
                                    Seguimiento oSeg  = (Seguimiento) lSeg.get(j);
    %>
                                        <tr>
                                            <td align="center" class='textSolapa'><%= oSeg.getBoca() %></td>
                                            <td align="center" class='textSolapa'><%= oSeg.getNumPropuesta() %></td>
                                            <td align="center" class='textSolapa'><%= (oSeg.getFechaTrabajo() == null ? " " : Fecha.showFechaForm(oSeg.getFechaTrabajo())) %></td>
                                            <td align="center" class='textSolapa'><%= oSeg.getHoraTrabajo() %></td>
                                            <td align="left" class='textSolapa'><%= oSeg.getdescEstado () %></td>
                                        </tr>
<%                              }
    %>
                                    </table>
                                </td>
                            </tr>
<%                                }
                               }
                            }
    %>
                            <tr>
                                <td class='text' colspan='5'><b>NOTA:</b> la información de la póliza se encuentra actualizada al&nbsp;<%= Fecha.showFechaForm (oPol.getfechaFTP ()) %>.
                                </td>
                            </tr>
                            <TR>
                                <TD align="center"  colspan='5'>
                                <%--<input type="button" name="cmdSalir"  value="  Salir  "  height="20px" class="boton" onClick="Salir ();">&nbsp;&nbsp;&nbsp;&nbsp;
                                --%>
                                <input type="button" name="cmdGrabar"
                                       value='<%= (sVolver.equals ("filtrarPolizas") ? "Volver a la consulta de P&oacute;liza":"Volver al filtro de renovaciones")%>'  height="20px" class="boton" onClick="Volver ();">
                                </TD>
                            </TR>
                        </table>
                    </td>
                    <td  width="1" bgcolor="#009BE6"><img src=pixel.gif width="1" height="1"></td>
                </tr>
                <tr bgcolor="#009BE6" height="1">
                    <td colspan=5><img src=pixel.gif width="1" height="1"></td>
                </tr>
            </table>
<!-- JUSTTABS BOTTOM CLOSE -->
            </form>
        </td>
    </tr>
    <tr>
        <td width='100%' valign="bottom">
            <jsp:include flush="true" page="/bottom.jsp"/>
        </td>
    </tr>
</table>
<script>
CloseEspere();
</script>
</body>
</html>
