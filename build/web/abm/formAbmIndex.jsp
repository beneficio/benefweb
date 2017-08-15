<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.*"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<% Usuario usu = (Usuario) session.getAttribute("user"); 
    if (usu.getiCodTipoUsuario() != 0) {
        request.setAttribute("javax.servlet.jsp.jspException", new SurException ("acceso denegado"));
        getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
    }
    HtmlBuilder ohtml       = new HtmlBuilder();
    Tablas oTabla = new Tablas ();
    LinkedList lTabla = new LinkedList ();
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
</head>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script language='javascript'>
      var lastError=null;
      function Submitir () {
         var sUrl = document.formAbm.COD_MENU.value;
         document.formAbm.action="<%= Param.getAplicacion()%>"+sUrl
         document.formAbm.submit()
      }

    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

    function Probar () {
           window.location.replace("<%= Param.getAplicacion()%>cotizador/10/ABMformCotizadorAp.jsp");
    }

    function Ir (opcion) {

        if (opcion == '1') {
            document.formAbm.action="<%= Param.getAplicacion()%>abm/formActividadCategoria.jsp";
        } 
        if (opcion == '2') {
            document.formAbm.action="<%= Param.getAplicacion()%>servlet/BonificacionServlet?opcion=getAllBonificacion";
        }
        if (opcion == '3') {
            document.formAbm.action="<%= Param.getAplicacion()%>servlet/ImpuestosServlet?opcion=getAllImpuestos";
        }
        if (opcion == '4') {
            document.formAbm.action="<%= Param.getAplicacion()%>servlet/TasaProvincialServlet?opcion=getAllTasaProvincial";
        }
        if (opcion == '5') {
            document.formAbm.action="<%= Param.getAplicacion()%>abm/ABMTasaMensual.jsp?cod_sub_rama=2";
        }
        if (opcion == '12') {
            document.formAbm.action="<%= Param.getAplicacion()%>abm/ABMTasaMensual.jsp?cod_sub_rama=1";
        }

        if (opcion == '6') {
            document.formAbm.action="<%= Param.getAplicacion()%>abm/ABMTramos.jsp";
        }
        if (opcion == '7') {
            document.formAbm.action="<%= Param.getAplicacion()%>servlet/VigenciaServlet?opcion=getAllVigencia&cod_rama=10";
        }

        if (opcion == '8') {
            document.formAbm.action="<%= Param.getAplicacion()%>abm/formSumasAseg.jsp";
        }

       if (opcion == '9') {
            document.formAbm.action="<%= Param.getAplicacion()%>servlet/SetProductorServlet?opcion=getAllSeteoProd";
        }

        if (opcion == '10') {
            document.formAbm.action="<%= Param.getAplicacion()%>abm/ABMTasaAMF.jsp?tipo_prestacion=P";
        }
        if (opcion == '11') {
            document.formAbm.action="<%= Param.getAplicacion()%>abm/ABMTasaAMF.jsp?tipo_prestacion=R";
        }

        document.formAbm.submit ();
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
        <td align="center" valign="top" width='100%'>
             <form name="formAbm" id="formAbm" method="POST">
             <table width='100%' cellpadding='4' cellspacing='4' border='0' align="center" class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                <tr>
                    <td width='100%' height='30' align="center" class='titulo'>ACTUALIZACION DE TABLAS DEL SISTEMA</td>
                </tr>
                <tr>
                    <td width='100%' align="left" class='link'>
                        <UL >
                            <li type='square' style="height: 25px;"><a href="#" onclick="Ir('1');">Actividad Categoria: actividades y categorias para el cotizador AP</a></li>
                            <li type='square' style="height: 25px;"><a href="#" onclick="Ir('2');">Bonificaciones: Bonificaciones por rango de cantidad de asegurados</a></li>
                            <li type='square' style="height: 25px;"><a href="#" onclick="Ir('3');">Parametros del sistema: impuestos y otros valores de cotizadores, propuestas y certificados</a></li>
                            <li type='square' style="height: 25px;"><a href="#" onclick="Ir('4');">Tasas Provinciales: tablas de cotizadores</a></li>
                            <li type='square' style="height: 25px;"><a href="#" onclick="Ir('12');">Tasas Anuales de AP (PLAN 1 : REINTEGRO) </a></li>
                            <li type='square' style="height: 25px;"><a href="#" onclick="Ir('5');">Tasas Anuales de AP (PLAN 2 : PRESTACIONAL) </a></li>
<%--                            
                            <li type='square' style="height: 25px;"><a href="#" onclick="Ir('6');">Tasas de Asistencia M&eacute;dico Farmace&uacute;tica (COTIZADOR VIEJO)</a></li>
--%>
                            <li type='square' style="height: 25px;"><a href="#" onclick="Ir('10');">Tasas AMF PRESTACIONAL (COTIZADOR AP NUEVO)</a></li>
                            <li type='square' style="height: 25px;"><a href="#" onclick="Ir('11');">Tasas AMF REINTEGRO (COTIZADOR AP NUEVO)</a></li>
<%--                            
                            <li type='square' style="height: 25px;"><a href="#" onclick="Ir('7');">Administración de cantidad de cuotas</a></li>
--%>
                            <li type='square' style="height: 25px;"><a href="#" onclick="Ir('8');">Seteo de sumas aseguradas m&aacute;ximas y m&iacute;nimas</a></li>
                            <li type='square' style="height: 25px;"><a href="#" onclick="Ir('9');">Seteo de productores (Prima m&iacute;nima, cant. m&aacute;xima de cuotas, etc)</a></li>
                        </UL>
                    </td>
                </tr>
                <tr> 
                    <td align="center" colspan="2" valign="bottom">  
                        <input type="button" name="cmdSalir"  value=" Salir " height="20px" class="boton" onClick="Salir();"/>
                    </td>
                 </tr>
            </table>   
            </form>
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
