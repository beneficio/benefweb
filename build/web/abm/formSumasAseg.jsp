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
    int codRama = (request.getParameter ("cod_rama") == null ? 10 : Integer.parseInt (request.getParameter ("cod_rama")));
    int codSubRama = 999;
    int iCodProd = Integer.parseInt (request.getParameter ("cod_prod") == null ? "99999999" :
                                     request.getParameter ("cod_prod"));

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
</head>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script language='javascript'>
     var lastError=null;

    function Volver () {
           window.location.replace("<%= Param.getAplicacion()%>abm/formAbmIndex.jsp");
    }

    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }


    function DoChangeCoberturas () {
       var sUrl = "<%= Param.getAplicacion()%>abm/rs/selectSumas.jsp"
       if ( document.getElementById('CODRAMA') ){
           sUrl = sUrl + "?cod_rama=" + document.formProd.CODRAMA.options[document.formProd.CODRAMA.selectedIndex].value  +
                         "&cod_sub_rama=999" + "&cod_prod=" + document.formProd.cod_prod.options[document.formProd.cod_prod.selectedIndex].value;
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
            oFrameCoberturas.document.form1.submit(); 
        }	 
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
                DoChangeCoberturas ();
                return true;
            } else {
                alert (" Código inexistente  !! ");
                accDir.value = "";
                return false;
            }
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
        <td align="center" valign="top" width='100%'>
           <form name="formProd" id="formProd" method="post" action="<%= Param.getAplicacion()%>servlet/setAccess">
           <input type="hidden" name="opcion" id="opcion" value=""/>
           <input type="hidden" name="cod_rama" id="cod_rama" value="<%=codRama%>"/>
           
           <table width='100%' cellpadding='0' cellspacing='0' border='0' align="center" class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                <tr>
                    <td width='100%' height='30' align="center" class='titulo'>SETEO DE SUMAS ASEGURADAS</td>
                </tr>
                <tr>
                    <td class="subTitulo" align="left">Los valores de sumas aseguradas seteados desde aqu&iacute; tendr&aacute;n efecto en cotizadores y propuestas.</td>
                </tr>
                <tr>
                    <td align="center" width="100%">
                        <table border="0" cellpadding="2" cellspacing="2" align="center" width="100%">
                            <tr>
                                <td align="left"  class="text" valign="top" >Rama:&nbsp;
                                    <select name="CODRAMA" id="CODRAMA" class="select" onchange="DoChangeCoberturas ();">
            <%                          lTabla = oTabla.getRamas ();
                                    out.println(ohtml.armarSelectTAG (lTabla, codRama));
            %>
                                    </select>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                </td>
                                    <td align="left" class="text" height="40px" valign="middle">Productor:&nbsp;
                                        <select class='select' name="cod_prod" id="cod_prod" onchange="DoChangeCoberturas ();">
                                            <option value="99999999">Todos los productores</option>
                <%
                             LinkedList lProd = (LinkedList) session.getAttribute("Productores");
                             for (int i= 0; i < lProd.size (); i++) {
                                 Usuario oProd = (Usuario) lProd.get(i);
                                 out.print("<option value='" + oProd.getiCodProd() + "' " + (oProd.getiCodProd() == iCodProd ? "selected" : " ") +
                                                            ">" + oProd.getsDesPersona() + " (" + oProd.getiCodProd() + ")</option>");
                             }
                %>
                                        </select>
                                    &nbsp;
                                    <LABEL>Cod : </LABEL>
                                    &nbsp;
                                    <INPUT name="prod_dir" id="prod_dir" value='0' size='10' maxlength='10'
                                           class='inputTextNumeric' onchange='CambiarSelectProd ( this );' onkeypress="" />
                                    </td>
                                </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height='355' valign="top">  
                        <iframe src="<%= Param.getAplicacion()%>abm/rs/selectSumas.jsp?cod_rama=<%= codRama %>&cod_sub_rama=999&cod_prod=<%= iCodProd %>"
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
