<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.LoteEmision"%>
<%@page import="com.business.beans.LoteEmisionDetalle"%>
<%@page import="com.business.beans.Grupo"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<%@taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg"  %>
<%
    String sVolver      = (String) request.getAttribute("volver");
    LinkedList lDetalle = (LinkedList) request.getAttribute("detalle");
    LoteEmision oLote = (LoteEmision) request.getAttribute ("lote");
    Diccionario oDicc   = (Diccionario) session.getAttribute("Diccionario");
    Usuario usu = (Usuario) session.getAttribute("user");

    int iSize      = (lDetalle == null ? 0 : lDetalle.size());
    int iNumLote   = oDicc.getInt (request, "F3lote_sel");
    oDicc.add("F3lote_sel", String.valueOf (iNumLote));

//   String nomArchivo = this.getServletContext().getRealPath("/files/trans/renovar/renovar_log_" + iNumLote + ".csv");
       String nomArchivo = Param.getAplicacion() + "files/trans/renovar/renovar_log_" + iNumLote + ".csv";

    session.setAttribute("Diccionario", oDicc);
    %>  
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>Emisión batch</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
</head>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js" defer="defer"></script>
    <script language="javascript" type="text/javascript">

    function Salir () {
        var volver = document.getElementById ("volver").value;

        if (volver == "-1") {
             window.history(-1);
        } else {
            if (volver == "nuevoLote") {
                document.form1.opcion.value = "agregarLote";
                document.form1.submit ();
            } else {
                document.form1.opcion.value = "getAllLotes";
                document.form1.submit ();
            }

        }
    }
    function Eliminar ( prop) {

        if (confirm ("Esta seguro que desea eliminar la propuesta " + prop + " ? ")) {
            document.form1.opcion.value  = "anularProp";
            document.form1.propuesta.value = prop;
            document.form1.submit ();
            return true;
        } else {
            return false;
        }
    }

    function EmitirOnLine ( prop) {

        if (confirm ("Esta seguro que desea emitir la propuesta " + prop + " ? ")) {
            document.form1.opcion.value  = "emitirPropOnLine";
            document.form1.propuesta.value = prop;
            document.form1.submit ();
            return true;
        } else {
            return false;
        }
    }

    function Actualizar () {

        document.form1.opcion.value  = "actualizarLog";
        document.form1.submit ();
        return true;
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
        <td valign="top" align="center" width="100%">
            <form name="form1" id="form1" method="POST" action="<%= Param.getAplicacion()%>servlet/EmisionBatchServlet">
                <input type="hidden" name="opcion" id="opcion" value="getAllDetalle"/>
                <input type="hidden" name="propuesta" id="propuesta"/>
                <input type="hidden" name="volver" id="volver" value="<%= sVolver %>"/>
                <input type="hidden" name="F3lote_sel" id="F3lote_sel" value="<%= iNumLote %>"/>
                <table width="100%" border="0" align="center" cellspacing="4" cellpadding="4" class="fondoForm" style="margin-top:1;margin-bottom:1;">
                    <tr>
                        <td valign="middle" align="center" class='titulo' height="30" >DETALLE DEL LOTE</td>
                    </tr>
                    <tr>
                        <td valign="middle" align="left" class='subtitulo'>N&uacute;mero de lote:&nbsp;<%= oLote.getnumLote() %></td>
                    </tr>
                    <tr>
                        <td align="left" valign="top">
                            <table border='0' align="left" cellpadding='2' cellspacing='3' width="100%">
                                <tr>
                                    <td align="left"  class="subtitulo" width="150px" nowrap>Estado del lote:</td>
                                    <td align="left"  class="subtitulo" width="500px" ><%= oLote.getdescEstadoLote() %></td>
                                </tr>

                                <tr>
                                    <td align="left" class="subtitulo" nowrap>Fecha de proceso:&nbsp;</td>
                                    <td align="left" class="subtitulo" nowrap><%=(oLote.getfechaTrabajo() == null ? "" :  Fecha.showFechaForm(oLote.getfechaTrabajo()))%></td>
                                </tr>
                                <tr>
                                    <td align="left"  class="subtitulo" nowrap  >Titulo del lote:</td>
                                    <td align="left"  class="subtitulo" nowrap><%= oLote.gettitulo() %></td>
                                </tr>
                                <tr>
                                    <td align="left"  class="subtitulo" nowrap >Registros leidos:</td>
                                    <td align="left"  class="subtitulo" nowrap><%= oLote.getcantRegistros() %></td>
                                </tr>

                                <tr>
                                    <td align="left"  class="subtitulo" nowrap >Registros procesados:</td>
                                    <td align="left"  class="subtitulo" nowrap><%= oLote.getcantProcesados() %></td>
                                </tr>
                                <tr>
                                    <td align="left"  class="subtitulo"  >Registros rechazados:</td>
                                    <td align="left"  class="subtitulo"><%= oLote.getcantErrores() %></td>
                                </tr>
<%                      if (oLote.gettipoLote().equals("R") && oLote.getcantProcesados() > 0 ) {
    %>
                                <tr>
                                    <td align="left"  class="subtitulo"  >Archivo de log del proceso:</td>
                                    <td align="left"  class="subtitulo">
                                        <a href="<%= nomArchivo %>" target='_blank' onmouseover="this.style.textDecoration='underline';"
                                           onmouseout="this.style.textDecoration='none';">
                                            <img src="<%= Param.getAplicacion() %>images/csv.png" border="0"/>&nbsp;
                                            Ver log de renovaciones
                                        </a>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                        <input type="button" name="cmdAct"  value="actualizar"
                                               height="20px" class="boton" onClick="javascript:Actualizar ();"/>
                                    </td>
                                </tr>
<%                      }
    %>
                            </table>
                        </td>
                    </tr>
                 </table>
            </form>
        </td>
    </tr>
    <tr>
        <td>
            <table border="0"  width='100%' cellPadding="0" cellSpacing="1" align="left" >
                <tr>
                    <td valign="top"  width='100%'>
                        <table  border="1" cellspacing="0" cellpadding="2" align="center" class="TablasBody">
                            <thead>
                                <th width="50px" nowrap>Rama</th>
                                <th width="60px">Poliza<br/>Anterior</th>
                                <th  width="60px">Poliza</th>
                                <th  width="60px">Propuesta</th>
                                <th  width="60px">Doc.Tomador</th>
                                <th  width="120px">Estado</th>
                                <th  width="300px">Observaciones</th>
                                <th  width="20px">&nbsp;</th>
                            </thead>
                           <% if (iSize  == 0 ){%>
                            <tr>
                                <td colspan="7" height='25' valign="middle">
                                    <span style="color:red">No existen registros </span>
                                </td>
                            </tr>
<%                         } 
                           for (int i=0; i < iSize; i++)  {
                                 LoteEmisionDetalle oDet = (LoteEmisionDetalle) lDetalle.get(i);
    %>
                            <tr>
                                <td align="right"><%= oDet.getcodRama() %></td>
                                <td align="left"><%= oDet.getnumPolizaAnt() %></td>
                                <td align="right"><%= oDet.getnumPoliza() %></td>
                                <td align="right"><%= oDet.getnumPropuesta() %></td>
                                <td align="left"><%= oDet.getnumDocTom() %></td>
                                <td align="left"><%= oDet.getdescEstadoPropuesta() %></td>
                                <td align="left"><%= oDet.getobservacion() %></td>
                                <td align="left" nowrap>&nbsp;
                        <%  if ( (oDet.getestadoProp() == 0 ||
                                  oDet.getestadoProp() == 1 ||
                                  oDet.getestadoProp() == 4 ||
                                  oDet.getestadoProp() == 7 ) && oDet.getnumPropuesta() > 0  ) {
                        %>
                                    <input type="button" name="cmdEliminar" id="cmdEliminar" value="Eliminar"  height="20px" class="boton" onClick="javascript:Eliminar (<%= oDet.getnumPropuesta() %>);"/>
                                    &nbsp;&nbsp;
<%                          }
                            if (oDet.getestadoProp() == 0 && oDet.getnumPropuesta()> 0) {
    %>
                                    <input type="button" name="cmdEmitir" id="cmdEmitir" value="Emitir"  height="20px" class="boton" onClick="javascript:EmitirOnLine (<%= oDet.getnumPropuesta() %>);"/>
<%                          }
    %>
                                </td>
                            </tr>
<%                          }
   %>
                        </table>
                    </td>
               </tr>
                <tr>
                    <td align="center"  height="30px" valign="middle">
                    <input type="button" name="cmdSalir"  value="Volver"  height="20px" class="boton" onClick="javascript:Salir ();"/>
                    </td>
                </tr>
            </table>
        </td>
   </tr>
   <tr>
        <td valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
   </tr>
</table>
<script>
     CloseEspere();
</script>
</body>
</html>
