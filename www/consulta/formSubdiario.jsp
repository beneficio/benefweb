<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp" session="true"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="java.util.LinkedList"%>
<%@page import="com.business.util.*"%> 
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@ taglib uri="http://jsptags.com/tags/navigation/pager" prefix="pg" %>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<%
     Usuario usu = (Usuario) session.getAttribute("user"); 
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
</head>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>css/Tablas.css"/>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script language="javascript">
     function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

    function GenerarArchivo () {
        if (document.form1.fecha_desde.value == "") {
            alert ("Ingrese fecha desde !! ");
            return false;
        }
        if (document.form1.fecha_hasta.value == "") {
            alert ("Ingrese fecha hasta !! ");
            return false;
        }

        document.form1.submit ();
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
    <TR>
        <TD align="center" valign="top" width='100%' height='450' >
            <TABLE width='100%' cellpadding='0' cellspacing='1' border='0' align="center" style='margin-top:5;margin-bottom:5;' class="fondoForm" >
                <form action='<%= Param.getAplicacion()%>servlet/ConsultaServlet' id="form1" name="form1"  method="POST">
                <input type="hidden" name="opcion" id="opcion" value="getLibroEmision">
<%
    if (usu.getiCodTipoUsuario() == 0 || usu.getiCodProd () >= 80000) {
%>
                <tr>
                    <td align="left" class="text">Productor:&nbsp;
                        <select class='select' name="cod_prod" id="cod_prod">
<%
                    LinkedList lProd = (LinkedList) session.getAttribute("Productores");
                    for (int i= 0; i < lProd.size (); i++) {
                        Usuario oProd = (Usuario) lProd.get(i);
                        if (oProd.getiCodProd() < 80000 ) {
                         out.print("<option value='" + oProd.getiCodProd() + "'>" + oProd.getsDesPersona() + " (" + oProd.getiCodProd() + ")</option>");
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
                <input type="hidden" name="cod_prod" id="cod_prod" value="<%= usu.getiCodProd()%>" >
<%
}
%>

                <tr>
                    <TD width='100%' height='30' align="center"  valign="middle" class='titulo'>LIBRO DE EMISION </TD>
                </tr>
                <tr>
                    <td align="center" valign="top"   class="subtitulo" height='100%'>Ingrese el periodo a consultar. Se generará un archivo .csv separado por tabulador para abrir con excel.</td>
                </tr>
                <tr>
                    <td align="left"  class="text">Fecha Desde:&nbsp;<input name="fecha_desde" id="fecha_desde" size="10" 
                    onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value="">&nbsp;(dd/mm/yyyy)</td>
                </tr>
                <tr>
                    <td align="left"  class="text">Fecha Hasta:&nbsp;<input name="fecha_hasta" id="fecha_hasta" size="10" 
                    onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value="">&nbsp;(dd/mm/yyyy)</td>
                </tr>
                <TR>
                    <td align="center">
                        <input type="button" name="cmdSalir"  value=" Salir "  height="20px" class="boton" onClick="Salir();">&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button" name="cmdGrabar" value=" Enviar " height="20px" class="boton" onClick="GenerarArchivo();">
                    </td>
                </TR>

<%      if (request.getAttribute("nameFile") != null) {
         %>
               <TR>
                    <TD align="left" class="text" height='100%'>
                    El Archivo&nbsp;<STRONG>  <%=request.getAttribute("nameFile")%></STRONG>&nbsp;&nbsp;ha sido generado con exito !!.<BR><BR>   
                    Usted se lo puede bajar desde&nbsp;
                    <A href="<%= Param.getAplicacion()%>consulta/mostrarTxt.jsp?path=/files/libros&nameFile=<%=request.getAttribute("nameFile")%>"
                       target='_blank' onmouseover="this.style.textDecoration='underline';"
                       onmouseout="this.style.textDecoration='none';">&nbsp;aqui&nbsp;&nbsp;</A>
                    <A href="<%= Param.getAplicacion()%>consulta/mostrarTxt.jsp?path=/files/libros&nameFile=<%=request.getAttribute("nameFile")%>"  target='_blank'>
                        <IMG src="<%= Param.getAplicacion()%>images/TXT.gif" height="20" width="20" border="0" alt="<%=request.getAttribute("nameFile")%>">
                    </A>
                </TD>                                
            </TR>
<%      }  %>
            </form>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD width='100%'>
            <jsp:include flush="true" page="/bottom.jsp"/>
        </TD>
    </TR>
</TABLE>
<script>
CloseEspere();
</script>
</body>
</html>


