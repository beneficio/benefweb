<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.LoteEmision"%>
<%@page import="com.business.beans.Grupo"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<%@taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg"  %>
<%
    LinkedList lLotes = (LinkedList) request.getAttribute("lotes");
    Diccionario oDicc   = (Diccionario) session.getAttribute("Diccionario");
    Usuario usu = (Usuario) session.getAttribute("user");

    int iSize           = (lLotes == null ? 0 : lLotes.size());
    String sPri         = oDicc.getString(request,"F1pri","S");
    String sTitulo      = oDicc.getString (request, "F3titulo");
    int iNumLoteEmision      = oDicc.getInt (request, "F1num_LoteEmision");
    int iCodRama        = oDicc.getInt (request, "F1cod_rama");
    int iNumLoteSelec   = oDicc.getInt (request, "F3lote_sel");
    Date dFechaDesde    = oDicc.getDate(request, "F3fecha_desde");
    Date dFechaHasta    = oDicc.getDate(request, "F3fecha_hasta");
    int iCurrentPageNumber = oDicc.getInt (request,"pager.offset");
    String sNumDocTom   = oDicc.getString (request, "F3num_doc_tom");
    int iLote           = oDicc.getInt  (request, "F3lote");
    int iNumLoteEmisionAnt   = oDicc.getInt  (request, "F3LoteEmision_anterior");
    int iNumPropuesta   = oDicc.getInt (request, "F3num_propuesta");


    oDicc.add("F1pri", sPri );
    oDicc.add("F3titulo", sTitulo);
    oDicc.add("F1num_LoteEmision", String.valueOf (iNumLoteEmision));
    oDicc.add("F1cod_rama", String.valueOf (iCodRama));
    oDicc.add("F3lote_sel", String.valueOf (iNumLoteSelec));
    oDicc.add("F3fecha_desde", (dFechaDesde == null ? null : Fecha.showFechaForm(dFechaDesde)));
    oDicc.add("F3fecha_hasta", (dFechaHasta == null ? null : Fecha.showFechaForm(dFechaHasta)));
    oDicc.add("F3num_doc_tom", sNumDocTom );
    oDicc.add("F3lote", String.valueOf (iLote));
    oDicc.add("F3LoteEmision_anterior", String.valueOf (iNumLoteEmisionAnt));
    oDicc.add("F3num_propuesta", String.valueOf (iNumPropuesta));
    oDicc.add("pager.offset", String.valueOf(iCurrentPageNumber));

    session.setAttribute("Diccionario", oDicc);

String sPath  =
    "&F1pri=N&F3titulo=" + sTitulo +  "&F3lote=" + iLote +
    "&F3LoteEmision_anterior=" + iNumLoteEmisionAnt  + "&F3num_propuesta=" + iNumPropuesta +
    (dFechaDesde == null ? "" : "&F3fecha_desde=" + Fecha.showFechaForm(dFechaDesde)) +
    (dFechaHasta == null ? "" : "&F3fecha_hasta=" + Fecha.showFechaForm(dFechaHasta)) +
    "&F1num_LoteEmision=" + iNumLoteEmision + "&F1cod_rama=" + iCodRama + "&opcion=getAllLotes" ;

    HtmlBuilder ohtml       = new HtmlBuilder();
    Tablas oTabla = new Tablas ();
    LinkedList lTabla = new LinkedList ();
    %>  
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>Emisión batch</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
</head>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js" defer="defer"></script>
    <script language="javascript">

    function Ir  ( opcion , numLote  ) {
        var mensaje = "";
        if (opcion == "procesarLote") {
            mensaje = " Esta seguro que desea EMITIR las propuestas del lote ?  ";
        } else if (opcion == "anular") {
            mensaje = " Esta seguro que desea ANULAR el lote ?  ";
        } else if (opcion == "enviarLote") {
            mensaje = " Esta seguro que desea ENVIAR las propuestas del lote ?  ";
        }

        if (mensaje == "" || (mensaje != "" && confirm (mensaje )  )) {
                document.form1.action = "<%= Param.getAplicacion()%>servlet/EmisionBatchServlet";
                document.form1.opcion.value = opcion ;
                document.form1.F3lote_sel.value = numLote ;
                document.form1.submit();
                return true;
         } else  {
                return false;
         }
    }

    function Buscar () {
        
        if (document.form1.F1num_LoteEmision.value == "") {
            document.form1.F1num_LoteEmision.value  = 0;
        }

        if (document.form1.F3LoteEmision_anterior.value == "") {
            document.form1.F3LoteEmision_anterior.value = 0;
        }

        if (document.form1.F3num_propuesta.value == "") {
            document.form1.F3num_propuesta.value  = 0;
        }

        if ( document.form1 ) {
            document.form1.opcion.value = "getAllLotes";
            document.form1.action = "<%= Param.getAplicacion()%>servlet/EmisionBatchServlet";
            document.form1.submit(); 
            return true;
        }
    }

    function Salir () {
        window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

    function Submitir(evt) {
           var nkeyCode;
           if (document.all) {
                 nkeyCode = evt.keyCode;
           }else
             if (evt) {
                nkeyCode = evt.which;
           }

          if (nkeyCode==13) {
            Buscar ();
          }
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
                <input type="hidden" name="opcion" id="opcion" value="getAllLotes"/>
                <input type="hidden" name="F1pri" id="F1pri" value="N"/>
                <input type="hidden" name="volver" id="volver" value='filtrarLotes'/>
                <input type="hidden" name="F3lote_sel" id="F3lote_sel" value="0"/>
                <input type="hidden" name="pager.offset" id="pager.offset" value="<%= iCurrentPageNumber %>"/>
                <table width="100%" border="0" align="center" cellspacing="4" cellpadding="4" class="fondoForm" style="margin-top:1;margin-bottom:1;">
                    <tr>
                        <td valign="middle" align="center" class='titulo' height="30" >EMISION BATCH</td>
                    </tr>
                    <tr>
                        <td valign="middle" align="left" class='subtitulo' height="30" >Desde este módulo se podrá
                        administrar la emisión de propuestas Batch de propuestas nuevas, renovaciones.
                        Solo se va generar la propuesta, la emisión de la misma se hace automáticamente a la noche mediante un proceso batch.
                        Este proceso batch lo puede bloquear desde Admin --> Interfaces --> Ejecutar --> Emisión batch.
                        </td>
                    </tr>
                <tr>
                    <td align="left" valign="top">
                        <table border='0' align="left" cellpadding='2' cellspacing='3'>
                            <tr>
                                <td align="left" class="text">Fecha de proceso desde:&nbsp;
                                    <input type="text" name="F3fecha_desde" id="F3fecha_desde" size="10"
                                           onblur="validaFecha(this);" onkeypress="return Mascara('F',event);"
                                           value='<%=(dFechaDesde == null ? "" : Fecha.showFechaForm(dFechaDesde))%>'/>
                                </td>
                                <td align="left" class="text" colspan="2">Hasta:&nbsp;
                                    <input type="text" name="F3fecha_hasta" id="F3fecha_hasta" size="10"
                                           onblur="validaFecha(this);" onkeypress="return Mascara('F',event);"
                                           value='<%=(dFechaHasta == null ? "" :  Fecha.showFechaForm(dFechaHasta))%>'/>
                                </td>
                            </tr>
                            <tr>
                                <td align="left"  class="text" valign="top" width="230" >Rama:&nbsp;
                                    <select name="F1cod_rama" id="F1cod_rama"   class="select">
                                        <option value='0' >Todas las rama</option>
    <%                           lTabla = oTabla.getRamas ();
                                 out.println(ohtml.armarSelectTAG(lTabla, iCodRama )); 
    %>
                                    </select>
                                </td>
                                <td align="left" class='text'>
                                N&uacute;mero P&oacute;liza:&nbsp;<input name="F1num_LoteEmision" id="F1num_LoteEmision"  size='12' maxlength='7'
                                                                              value="<%= iNumLoteEmision %>"  onkeypress="return Mascara('D',event);"
                                                                              class="inputTextNumeric"/>
                                </td>
                            </tr>
                            <tr>
                                <td align="left"  class="text"  >(*) Titulo del lote:</td>
                                <td align="left"  class="text"><input name="F3titulo" id="F3titulo" size='45' value="<%= sTitulo %>"/></td>
                            </tr>
                            <tr>
                                <td align="left"  class="text"  >Número de lote:</td>
                                <td align="left"  class="text"><input name="F3lote" id="F3lote" size='12' value="<%= iLote %>"/></td>
                            </tr>
                            <tr>
                                <td align="left"  class="text"  >LoteEmision anterior :</td>
                                <td align="left"  class="text"><input name="F3LoteEmision_anterior" id="F3LoteEmision_anterior" size='12' maxlength="7" value="<%= iNumLoteEmisionAnt %>"/></td>
                            </tr>
                            <tr>
                                <td align="left"  class="text"  >Número de propuesta :</td>
                                <td align="left"  class="text"><input name="F3num_propuesta" id="F3num_propuesta" size='12' maxlength="7" value="<%= iNumPropuesta %>"/></td>
                            </tr>
                            <tr>
                                <td align="left"  class="text"  >Número de Documento :</td>
                                <td align="left"  class="text"><input name="F3num_doc_tom" id="F3num_doc_tom" size='12' maxlength="12" value="<%= sNumDocTom %>"/></td>
                            </tr>

                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td valign="middle" align="left" class='text' >(*) Puede ingresar el valor parcialmente.&nbsp;
                            Por ej: ingresando Oscar, visualizar&aacute; todas las p&oacute;lizas en la que el cliente contenga Oscar
                        </td>
                    </tr>
                    <tr>
                        <td align="center" >
                        <input type="button" name="cmdSalir"  value="  Salir  "  height="20px" class="boton" onClick="javascript:Salir ();"/>&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button" name="cmdNuevo"  value="Nuevo lote"  height="20px" class="boton" onClick="javascript:Ir ('agregarLote', 0 );"/>&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button" name="cmdGrabar" value="  Buscar  "  height="20px" class="boton" onClick="javascript:Buscar ();"/>
                        </td>
                    </tr>
                 </table>
            </form>
        </td>
    </tr>
<%
    if (sPri != null && sPri.equals ("N")) {
    %>

    <tr>
        <td>
            <table border="0"  width='100%' cellPadding="0" cellSpacing="1" align="left" >
                <tr>
                    <td height="30" class='titulo' width="70%" valign="middle" align="center">Resultado de la busqueda</td>
                </tr>
                <tr>
                    <td valign="top"  width='100%'>
                        <pg:pager maxPageItems="20" items="<%= iSize %>" 
                                  url="/benef/servlet/EmisionBatchServlet"
                                  maxIndexPages="20"
                                  export="currentPageNumber=pageNumber">
                        <pg:param name="keywords" />
                        <table  border="1" cellspacing="0" cellpadding="2" align="center" class="TablasBody">
                            <thead>
                                <th nowrap>&nbsp;&nbsp;Lote&nbsp;&nbsp;</th>
                                <th width="200px" nowrap>Titulo</th>
                                <th  width="50px">Leidos<br/>Procesados<br/>Erroneos</th>
                                <th  width="50px">Fecha</th>
                                <th  width="50px">Estado</th>
                                <th  width="200px">Observaciones</th>
                                <th  width="75px" nowrap>Propuesta</th>
                                <th  width="75px" nowrap>Poliza Ant.</th>
                                <th  width="75px" nowrap>Poliza</th>
                                <th  width="75px" nowrap>Doc.Tomador</th>
                                <th  width="200px" nowrap>Acciones</th>
                            </thead>
                           <% if (iSize  == 0 ){%>
                            <tr>
                                <td colspan="11" height='25' valign="middle">
                                    <span style="color:red">No existen lotes para la consulta </span>
                                </td>
                            </tr>
<%                         } 
                           for (int i=0; i < iSize; i++)  {
                                 LoteEmision oLote = (LoteEmision) lLotes.get(i);
    %>
                          <pg:item>
                            <tr>
                                <td align="right"><%= oLote.getnumLote() %></td>
                                <td align="left"><%= oLote.gettitulo() %></td>
                                <td align="center"><%= oLote.getcantRegistros() %><br/><%= oLote.getcantProcesados() %><br/><%= oLote.getcantErrores() %></td>
                                <td align="center" nowrap><%= (oLote.getfechaTrabajo() == null ? "no informado" : Fecha.showFechaForm(oLote.getfechaTrabajo())) %></td>
                                <td align="left"><%= oLote.getdescEstadoLote() %></td>
                                <td align="left"><%= oLote.getobservacion() %></td>
                                <td align="left"><%= oLote.getminNumPropuesta() %>&nbsp;..&nbsp;<%= oLote.getnumPropuesta() %></td>
                                <td align="left"><%= oLote.getminNumPolizaAnt() %>&nbsp;..&nbsp;<%= oLote.getnumPolizaAnt() %></td>
                                <td align="left"><%= oLote.getminNumPoliza () %>&nbsp;..&nbsp;<%= oLote.getnumPoliza () %></td>
                                <td align="left"><%= (oLote.getminNumDocTom() == null ? " " : oLote.getminNumDocTom()) %></td>
                                <td align="left" nowrap>
<%                            if (oLote.getcodEstado() == 0 ) {
    %>
                                    <a href="#" onclick="javascript:Ir ('procesarLote', <%= oLote.getnumLote() %>);">Emitir propuestas</a><br/>
                                    <a href="#" onclick="javascript:Ir ('anular', <%= oLote.getnumLote() %>);">Anular lote</a><br/>
                                    <a href="#" onclick="javascript:Ir ('agregarLote', <%= oLote.getnumLote() %>);">Recargar archivo</a>
<%                            } else if (oLote.getcodEstado() == 1 ||
                                          oLote.getcodEstado() == 3) {
    %>

                                    <a href="#" onclick="javascript:Ir ('ver', <%= oLote.getnumLote() %>);">Ver registros</a><br/>
                                    <a href="#" onclick="javascript:Ir ('enviarLote', <%= oLote.getnumLote() %>);">Enviar Lote</a><br/>
<%                                  } else if (oLote.getcodEstado() == 2 ) {
    %>
                                    <a href="#" onclick="javascript:Ir ('agregarLote', <%= oLote.getnumLote() %>);">Recargar archivo</a>
<%                                         }
    %>

                                </td>
                            </tr>
                        </pg:item> 
<%                          }
   %>
                            <thead>
                                <th colspan="11">
                                    <pg:prev>
                                    <a class="rnavLink" href="<%= pageUrl %><%= sPath%>">[Anterior]</a>
                                    </pg:prev>
                                    <pg:pages  >
                               <% if (pageNumber == currentPageNumber ) { %>
                                    <b><%= pageNumber %></b>
                               <% } else { %> 
                                    <a class="rnavLink" href="<%= pageUrl %><%= sPath %>"><%= pageNumber %></a>
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
<%   
    }    
%>
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
