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
    Usuario oProd = (Usuario) request.getAttribute ("productor");

    HtmlBuilder ohtml       = new HtmlBuilder();
    Tablas oTabla = new Tablas ();
    LinkedList lTabla = new LinkedList ();
    int codRama = (request.getParameter ("cod_rama") == null ? 10 : Integer.parseInt (request.getParameter ("cod_rama")));
    int codSubRama = 999;
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script language='javascript'>
     var lastError=null;

    function Volver () {
           window.location.replace("<%= Param.getAplicacion()%>usuarios/filtrarUsuarios.jsp");
    }

    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

    function DoChangeCoberturas () {
       var sUrl = "<%= Param.getAplicacion()%>abm/rs/selectSumas.jsp"
       if ( document.getElementById('CODRAMA') ){
           sUrl = sUrl + "?cod_rama=" + document.formProd.CODRAMA.options[document.formProd.CODRAMA.selectedIndex].value  +
                         "&cod_sub_rama=999" + "&cod_prod=" + document.formProd.cod_prod.value;
       }
       if (oFrameCoberturas){
            oFrameCoberturas.location = sUrl;
       }
    }

    function DoChangeRama ( codRama  ){
       var sUrl = "<%= Param.getAplicacion()%>usuarios/rs/selectCoberturas.jsp"
       if ( codRama ){
            sUrl = sUrl + "?cod_rama=" +  codRama.options[codRama.selectedIndex].value + "&cod_sub_rama=999" + "&cod_prod=<%= oProd.getiCodProd() %>";
       }
       if (oFrameCoberturas){
            oFrameCoberturas.location = sUrl;
       }
    }

     function Grabar () {

        if (oFrameCoberturas){
            oFrameCoberturas.document.form1.opcion.value = "addSumas";
            oFrameCoberturas.document.form1.target = "_top";
            oFrameCoberturas.document.form1.action = "<%= Param.getAplicacion()%>servlet/setAccess";
            oFrameCoberturas.document.form1.usuario.value = document.formProd.usuario.value;
            oFrameCoberturas.document.form1.submit();
        }
}

//     function Grabar () {

//        if (oFrameCoberturas){
//            oFrameCoberturas.document.form1.opcion.value = "addProdCob";
//            oFrameCoberturas.document.form1.target = "_top";
//            oFrameCoberturas.document.form1.action = "/benef/servlet/setAccess";
//            oFrameCoberturas.document.form1.numSecuUsu.value = document.formProd.numSecuUsu.value;
//            oFrameCoberturas.document.form1.submit();
//        }
//   }
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
        <td align="center" valign="top" width='100%'>
           <form name="formProd" id="formProd" method="post" action="<%= Param.getAplicacion()%>servlet/setAccess">
           <input type="hidden" name="opcion" id="opcion" value="addProdCob"/>
           <input type="hidden" name="cod_prod" id="cod_prod" value="<%= oProd.getiCodProd() %>"/>
           <input type="hidden" name="usuario" id="usuario" value="<%= oProd.getusuario() %>"/>
           <input type="hidden" name="cod_rama" id="cod_rama" value="<%=codRama%>"/>
           
           <table width='100%' cellpadding='0' cellspacing='0' border='0' align="center" class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                <tr>
                    <td width='100%' height='30' align="center" class='titulo'>VALIDACIÓN DE SUMAS A ASEGURAR POR PRODUCTOR</td>
                </tr>
                <tr>
                    <td class="subTitulo" align="left">Productor:&nbsp;<%= oProd.getsDesPersona() + " (" + oProd.getiCodProd() + ")" %></td>
                </tr>
                <tr>
                    <td align="left"  class="text" valign="top" >Rama:&nbsp;
                        <select name="CODRAMA" id="CODRAMA" class="select" onchange="DoChangeCoberturas ();">
<%                      lTabla = oTabla.getRamas ();
                        out.println(ohtml.armarSelectTAG (lTabla, codRama)); 
%>
                        </select>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                </tr>
                <tr>
                    <td height='355' valign="top">
<%--
                        <iframe src="<%= Param.getAplicacion()%>usuarios/rs/selectCoberturas.jsp?cod_rama=<%= codRama %>&cod_sub_rama=999&cod_prod=<%= oProd.getiCodProd() %>" 
                               name="oFrameCoberturas" id="oFrameCoberturas" width="600px" height="100%" marginwidth="0" marginheight="0" 
                              align="top" frameborder="0">
                        </iframe>
--%>
                        <iframe src="<%= Param.getAplicacion()%>abm/rs/selectSumas.jsp?cod_rama=<%= codRama %>&cod_sub_rama=999&cod_prod=<%= oProd.getiCodProd()%>&usuario=<%=  oProd.getusuario() %>"
                                name="oFrameCoberturas" id="oFrameCoberturas" width="900px" height="100%" marginwidth="0" marginheight="0" align="top" frameborder="0"></iframe>

                    </td>
                </tr>
                <tr>
                    <td align="center">  
                    <input type="button" name="cmdSalir" value=" Salir " height="20px" class="boton" onClick="Salir();"/>&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="button" name="cmdGrabar" value="Grabar" height="20px" class="boton" onclick="Grabar();"/>
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
