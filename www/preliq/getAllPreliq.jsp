<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Poliza"%>
<%@page import="com.business.beans.Preliq"%>
<%@page import="com.business.beans.ErrorPreliq"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>
<%@ taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg" %> 
<%
    Usuario usu = (Usuario) session.getAttribute("user");
    int iCodProd    = Integer.parseInt(request.getParameter("cod_prod") == null ? "-1" : request.getParameter("cod_prod"));
    LinkedList lPreliq = (LinkedList) request.getAttribute("preliquidaciones");
    LinkedList lError  = (LinkedList) request.getAttribute("errores");
  
    
String sPath = "&cod_prod=" + iCodProd + "&opcion=getAllPreliq" ;

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<script  type="text/javascript">
    function OpenEspere (){
        document.getElementById("mascara").style.display="block";
        document.getElementById("ventanita").style.display ="block";
    }
</script>
</head>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script  type="text/javascript">
        function Salir () {
            window.location.replace("<%= Param.getAplicacion()%>index.jsp");
        }

        function Enviar () {

            document.form1.action = "<%= Param.getAplicacion()%>servlet/PreliquidacionServlet";
            document.form1.opcion.value = "getAllPreliq";
            document.form1.submit();
            OpenEspere ();
            return true;
        }

    function CambiarSelectProd ( accDir ) {
        var       i = 0;
        var bExiste = false;

        if ( (accDir.value == "" || accDir.value == "0")) {
            if (document.getElementById ('cod_prod').value != "0") {
                document.getElementById ('cod_prod').value = "0";
            }
            return true;
        } else {
            for (i = 0; i < document.getElementById ('cod_prod').length; i++) {
                if (document.getElementById ('cod_prod').options [i].value == accDir.value) {
                    bExiste = true;
                    break;
                }
            }
            if ( bExiste ) {
                document.getElementById ('cod_prod').value = accDir.value;
                return true;
            } else {
                alert (" Código inexistente  !! ");
                accDir.value = "";
                return false;
            }
        }
    }

    function VerPreliq (numPreliq) {
        // alert("formato " + formato );
        document.form1.action = "<%= Param.getAplicacion() %>preliq/printPreview.jsp";
        document.form1.opcion.value = "getPreliqPDF";
        document.form1.co_numPreliq.value = numPreliq;
        document.form1.submit();
        return true;
   }

    function EditarPreliq ( numPreliq ) {
        // alert("formato " + formato );
        document.form1.action = "<%= Param.getAplicacion() %>servlet/PreliquidacionServlet";
        document.form1.opcion.value = "getPreliquidacion";
        document.form1.co_numPreliq.value = numPreliq;
        document.form1.submit();
        return true;
   }
    function CambiarEstado ( numPreliq ) {
        document.form1.action = "<%= Param.getAplicacion() %>servlet/PreliquidacionServlet";
        document.form1.opcion.value = "cambiarEstado";
        document.form1.co_numPreliq.value = numPreliq;
        document.form1.submit();
        return true;
   }

</script>
<body>
    <table  id="tabla_general" cellSpacing="0" cellPadding="0" width="960" align="center" border="0">
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
            <form name="form1" id="form1" method="POST" action="<%= Param.getAplicacion()%>servlet/PreliquidacionServlet">
               <input type="hidden" name="opcion" id="opcion" value="getAllPreliq"/>
               <input type="hidden" name="volver" id="volver" value="getAllPreliq"/>
               <input type="hidden" name="co_numPreliq" id="co_numPreliq" value=""/>
                <input type="hidden"  name="tipo_usuario" id="tipo_usuario" value="<%= usu.getiCodTipoUsuario()%>"/>
               <input type="hidden"  name="cod_usuario"  id="cod_usuario" value="<%= usu.getiCodProd()%>"/>
                <table width="100%" border="0" align="center" cellspacing="4" cellpadding="2"
                       class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                    <tr>
                        <td height="30px" valign="middle" align="center" class='titulo'>PRELIQUIDACION WEB</td>
                    </tr>
                    <tr>
                        <td align="center" valign="top" width="100%">
                            <table border='0' align="center" cellpadding='2' cellspacing='2'>

<%
    if (usu.getiCodTipoUsuario() == 0 || usu.getiCodProd () >= 80000) { 
%>
                                <tr>                                
                                    <td align="left" class="text"  >Productor:&nbsp;
                                        <select class='select' name="cod_prod" id="cod_prod">
<%
         LinkedList lProd = (LinkedList) session.getAttribute("Productores");
         for (int i= 0; i < lProd.size (); i++) {
             Usuario oProd = (Usuario) lProd.get(i);
             if (oProd.getiCodProd() < 80000) {
                 if (iCodProd > 0 ) {
                     out.print("<option value='" + oProd.getiCodProd() + "' " + (oProd.getiCodProd() == iCodProd ? "selected" : " ") + 
                                                ">" + oProd.getsDesPersona() + " (" + oProd.getiCodProd() + ")</option>");
                 } else {
                     out.print("<option value='" + oProd.getiCodProd() + "' " + (oProd.getiCodProd() == usu.getiCodProd () ? "selected" : " ") +
                                                ">" + oProd.getsDesPersona() + " (" + oProd.getiCodProd() + ")</option>");
                 }
              }
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
                                <input type="hidden" name="cod_prod" id="cod_prod" value="<%= (iCodProd > 0 ? iCodProd : usu.getiCodProd()) %>" />
<%
    }
%>
                            </table>
                        </td>
                    </tr>
<%          if (lError != null && lError.size() > 0) {
            for (int i=0 ; i < lError.size(); i++  ){
                ErrorPreliq error = (ErrorPreliq)lError.get(i);
                if (error.getCodError() == -55 ||
                    error.getCodError() == -50 ||
                    error.getCodError() == -200 ) {
    %>
                <tr><td class="subtitulo">
                        <span style="color:red">Se produjo el siguiente ERROR al procesar la Preliquidación Nº&nbsp;<%= error.getNumPreliq() %>:<br/>
                            [<%= error.getCodError() %>]&nbsp;<%= error.getDescError()%><br/>
                            Por favor, tome nota del error y comuniquese a la compa&ntilde;&iacute;a asi podemos ayudarlo.
                        </span>
                    </td>
                </tr>

<%                }
            }
          }
    %>
<%          if (lPreliq == null || lPreliq.size() == 0) {
                if (iCodProd > 0 ) {
    %>
                <tr>
                    <td class="subtitulo">
                        <span style="color:red">No existen preliquidaciones del productor. <br/>
        Por favor, envíe un mail solicitando la generación de una preliquidación a&nbsp;<a href="mailto:cobranzas@beneficiosa.com.ar">cobranzas@beneficiosa.com.ar</a>
        <br/>Sepa disculpar las molestias.</span>
                    </td>
                </tr>
<%              }
            } else {
    %>
                <tr>
                    <td valign="top"  width='100%'>
                        <pg:pager maxPageItems="20" items="<%= lPreliq.size() %>" url="/benef/servlet/PreliquidacionServlet"
                        maxIndexPages="20" export="currentPageNumber=pageNumber">
                        <pg:param name="keywords"/>

                        <table  border="1" cellspacing="0" cellpadding="2" align="center" class="TablasBody">
                            <thead>
                                <th width='60px'>Cod.Prod</th>
                                <th width='60px'>Num.Preliq</th>
                                <th  width="60px" nowrap>Fecha Carga</th>
                                <th  width="100px" nowrap>Estado</th>
                                <th  width="60px" nowrap>Fecha Envio</th>
                                <th nowrap>&nbsp;&nbsp;&nbsp;</th>
                            </thead>
                           <% if (lPreliq.size()  == 0 ){%>
                            <tr>
                                <td colspan="6" height='25' valign="middle"><span style="color:red">No existen preliquidaciones para el productor</span></td>
                            </tr>
<%                         }
                           boolean bPrimero = true;
                           for (int i=0; i < lPreliq.size(); i++)  {
                               Preliq oPre = (Preliq) lPreliq.get(i);
                               String color = "";
                               switch ( oPre.getCodEstado() ) {
                                   case 0:
                                       color = "black"; // en carga
                                       break;
                                   case 1:
                                       color = "green"; // enviada
                                       break;
                                   case 2:
                                       color = "red"; // error en carga
                                       break;
                                   case 3:
                                       color = "red"; // reemplaza
                                       break;
                                   case 4:
                                       color = "red"; // anulada
                                       break;
                                   case 5:
                                       color = "blue"; // procesada
                                       break;
                                   case 6:
                                       color = "red"; // error en proceso
                                       break;
                                   default:
                                       color = "red"; // 7 vencida
                                   }
    %>
                          <pg:item>
                            <tr>
                                <td align="right"><%= oPre.getCodProdDc() %></td>
                                <td align="right"><%= oPre.getNumPreliq() %></td>
                                <td align="center"><%= (oPre.getFechaTrabajo() == null ? "&nbsp;" : Fecha.showFechaForm(oPre.getFechaTrabajo())) %></td>
                                <td align="center"><span class="subtitulo" style="color:<%=  color %>">
                                        <%= oPre.getsDescEstado() %></span></td>
                                <td align="center"><%= (oPre.getFechaEnvioProd() == null ? "&nbsp;" :  Fecha.showFechaForm(oPre.getFechaEnvioProd())) %></td>
                                <td align="center" nowrap>
<%                                  if (oPre.getCodEstado() == 0) {
%>                                        <img src="<%= Param.getAplicacion()%>images/editdocument.gif" border='0'  style="cursor: hand;" 
                                         onclick="EditarPreliq ('<%= oPre.getNumPreliq() %>');" alt="Editar preliquidación"/>
<%                                  }
                                if (oPre.getCodEstado() != 0) {
%>                                        <img src="<%= Param.getAplicacion()%>images/PDF.gif"  style="cursor: hand;"
                                         onclick="VerPreliq ('<%= oPre.getNumPreliq() %>');"  alt="Bajar preliquidación"/>
<%                                  }
                                if (bPrimero && usu.getiCodTipoUsuario() == 0 && (oPre.getCodEstado() == 1 ||
                                                                                  oPre.getCodEstado() == 2 ||
                                                                                  oPre.getCodEstado() == 4 ||
                                                                                  oPre.getCodEstado() == 5 ||
                                                                                  oPre.getCodEstado() == 6 ) ) {
%>                                        <img src="<%= Param.getAplicacion()%>images/finalizar.gif"  style="cursor: hand;"
                                         onclick="CambiarEstado ('<%= oPre.getNumPreliq() %>');"  alt="Cambiar estado de la preliquidación"/>

<%                                  }
%>
                                </td>
                            </tr>
                        </pg:item>

<%                         bPrimero = false;
                           }
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
               <tr>
                    <td align="left" class='texto'>
                        <span style="color:red;">Referencia:</span>&nbsp;
                        <br/>
                        <ol type="i">
                            <li><span class='subtitulo' style="color:black">EN CARGA:</span>&nbsp;Preliquidaci&oacute;n habilitada para rendir cobranza. Luego de finalizar con la carga haga clic en Cerrar Preliquidaci&oacute;n y la misma va quedar en estado "ENVIADA".-</li>
                            <li><span class="subtitulo" style="color:green">ENVIADA:</span>&nbsp;la preliquidaci&oacute;n ya fue cerrada. NO puede asentar más cobranza.
                                Cualquier modificaci&oacute;n la tiene que hacer en la compañ&iacute;a.-</li>
                            <li><span class="subtitulo" style="color:red">REEMPLAZADA:</span>&nbsp;Es cuando a&uacute;n estaba en estado "EN CARGA" y se gener&oacute; una nueva preliquidaci&oacute;n.<br>
                                Las cuotas rendidas que a&uacute;n est&aacute;n impagas se actualizan autom&aacute;ticamente en la nueva preliquidaci&oacute;n.</li>
                            <li><span class="subtitulo" style="color:red">VENCIDA:</span>&nbsp;La preliquidaci&oacute;n pertenece a convenios anteriores.
                            Si usted necesita rendir cuotas pendientes y no tiene ninguna preliquidaci&oacute;n EN CARGA haga el reclamo al sector de cobranza</li>
                            <li><span class="subtitulo" style="color:red">ANULADA:</span>&nbsp;Alguna p&oacute;liza de la preliquidaci&oacute;n que usted marc&oacute; como cobrada
                                fue modificada en la empresa. Comuniquese a la compa&ntilde;ia para rehabilitar la preliquidaci&oacute;n y desmarcar la cuota inconsistente.</li>
                            <li><span class="subtitulo" style="color:blue">PROCESADA:</span>&nbsp;la preliquidaci&oacute;n ya fue procesada por la compañ&iacute;a y la cobranza imputada.</li>
                        </ol>
                    </td>
                </tr>

<%      }
%>
                <tr>
                    <td align="center">
                        <input type="button" name="cmdSalir" value=" Salir " height="20px" class="boton" onClick="Salir();"/>&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button" name="cmdGrabar" value=" Enviar " height="20px" class="boton" onClick="Enviar();"/>
                    </td>
                </tr>
               </table>
            </form>
        </td>
    </tr>
    <tr>
        <td valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
   </tr>
</table>
<script language="javascript">
var divHeight;
var obj = document.getElementById('tabla_general');

if(obj.offsetHeight)          {divHeight=obj.offsetHeight;}
else if(obj.style.pixelHeight){divHeight=obj.style.pixelHeight;}
document.write('<div id="mascara" style="width:100%;height:' + divHeight + 'px;position:absolute;top:0;left:0;' +
               'background-color:#F5F7F7;z-index:3;opacity:.6;-moz-opacity:.6;-khtml-opacity:.6;filter:alpha(opacity=60);display:none"></div>' );
</script>
<!--<div id="mascara" style="position:fixed;top:0;left:0; width:100%;height:100%; background-color:#F5F7F7; z-index:3;opacity:.6;-moz-opacity:.6;-khtml-opacity:.6;filter:alpha(opacity=60);display:none"></div>
-->
<div id="ventanita" style="display:none;position:absolute;top:50%;left :50%;width:760px;height:100%;margin-top: -30px;margin-left: -400px;z-index:4">
    <table width="100%" bgcolor="F5F7F7">
            <tr>
                <td  height="100%" valign="middle">
                    <img src="/benef/images/barraProgresion.gif"/>&nbsp;
                    <span style="font-family:  Arial, Helvetica, sans-serif; font-size:16px;font-weight:bold;text-decoration:none;padding: 5px">
                        Por favor, espere un momento que se esta actualizando la preliquidaci&oacute;n...</span>&nbsp;
                    <img src="/benef/images/barraProgresion.gif"/>
                </td>
            </tr>
    </table>
</div>
<script>
CloseEspere();
</script>
</body>
</html>
