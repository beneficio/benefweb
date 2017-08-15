<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Manual"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.LinkedList"%>
<%@ taglib uri="tld/menu.tld" prefix="menu" %>   
<% Usuario usu = (Usuario) session.getAttribute("user");

LinkedList lManuales  = (LinkedList) request.getAttribute("manuales");
LinkedList lNovedades = (LinkedList) request.getAttribute("novedades");
String sFecha         = (String)     request.getAttribute("ultima_interface");

   String pathNovedades = "/benef/files/novedades/";
   String pathManuales  = "/benef/files/manuales/";
   session.setAttribute("Diccionario", null);
   session.setAttribute("Diccionario", new Diccionario ());
   String sAlerta = (request.getParameter ("alerta") == null ? "N" : request.getParameter ("alerta"));
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
    <head>
        <TITLE>Beneficio Web</TITLE>
<link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>portal/css/estilos.css"/>
<script type='text/javascript' src='<%=Param.getAplicacion()%>script/popUp.js'></script>

<!-- libreria jquery desde el cdn de google o fallback local -->

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js"></script>
<script type="text/javascript">window.jQuery || document.write('<script src="<%=Param.getAplicacion()%>portal/js/vendor/jquery-1.8.0.min.js"><\/script>')</script>

<script type="text/javascript">

$(document).ready(function () {

	$("a#1").click(function () {
		 $("div#1d").slideToggle("fast");
		 $(this).toggleClass("down");
		 return false;
	});

	$("a#2").click(function () {
		 $("div#2d").slideToggle("fast");
		 $(this).toggleClass("down");
		 return false;
	});

	$("a#3").click(function () {
		 $("div#3d").slideToggle("fast");
		 $(this).toggleClass("down");
		 return false;
	});

	//la función se copia con nuevos id según el panel a desplegar, vasta con copiar y cambiar el id si hay nuevo panel

	$("a#4").click(function () {
		 $("div#4d").slideToggle("fast");
		 $(this).toggleClass("down");
		 return false;
	});

	$("a#5").click(function () {
		 $("div#5d").slideToggle("fast");
		 $(this).toggleClass("down");
		 return false;
	});
	$("a#6").click(function () {
		 $("div#6d").slideToggle("fast");
		 $(this).toggleClass("down");
		 return false;
	});
	$("a#7").click(function () {
		 $("div#7d").slideToggle("fast");
		 $(this).toggleClass("down");
		 return false;
	});
	$("a#8").click(function () {
		 $("div#8d").slideToggle("fast");
		 $(this).toggleClass("down");
		 return false;
	});
	$("a#9").click(function () {
		 $("div#9d").slideToggle("fast");
		 $(this).toggleClass("down");
		 return false;
	});
	$("a#10").click(function () {
		 $("div#10d").slideToggle("fast");
		 $(this).toggleClass("down");
		 return false;
	});

});

    function Alerta () {
        var sUrl = "<%= Param.getAplicacion()%>usuarios/alerta.jsp";
        var W = 650;
        var H = 450;

        AbrirPopUp (sUrl, W, H);
    }

    function Banner () {
        var sUrl = "<%= Param.getAplicacion()%>files/dic2007/bnf_tarjeta.htm";
        var W = 650;
        var H = 535;

        AbrirPopUp (sUrl, W, H);
    }
</script>
</head>
<body  leftMargin="20" topMargin="5" marginheight="0" marginwidth="0">
<menu:renderMenuFromDB    aplicacion="1"  userLogon="<%= usu.getusuario()%>" />
<TABLE cellSpacing="2" cellPadding="2" width="725px" align="LEFT" border="0">
    <tr>
        <td align="center" valign="top">
            <jsp:include flush="true" page="/top.jsp"/>
        </td>
    </tr>
    <tr>
        <td width='100%' height='30' valign="middle">
        <span  class="textonegro33"><B>Bienvenido&nbsp;</span><span  class="textorojo">
            <a  href="<%=Param.getAplicacion()%>servlet/setAccess?opcion=getUsuario&usuario=<%= usu.getusuario()%>"><%= usu.getsDesPersona()%></a>
.Ultima actualizaci�n de p�lizas y cobranza:&nbsp;<%= sFecha %></B></span>
        </td>
    </tr>
<%          if (lNovedades != null) {
    %>
    <tr>
        <td align="center" ><span class="titulo"><h2>NOVEDADES</h2></span></td>
    </tr>
    <tr>
        <td>
<%             for (int ii=0; ii< lNovedades.size(); ii++) {
                    Manual oMan = (Manual) lNovedades.get(ii);
    %>
            <div class="file <%= ( oMan.gettipoDoc()== null ? "txt" :  oMan.gettipoDoc().toLowerCase()) %>"> <!-- Acá de identefica el icono del archivo con un class, se decir el file + espacio y la extensión | opciones: zip, pdf, xls, doc, txt -->
                 <span class="fecha"><%= (oMan.getfechaPublicacion() == null ? " " : Fecha.showFechaForm(oMan.getfechaPublicacion())) %></span>
                  <a  href="<%= pathNovedades %><%=(oMan.getlink() == null?"#":oMan.getlink())%>" class="link-archivo"  target="_blank"><%= oMan.gettitulo() %></a>
                  <span class="descripcion-archivo"><%= oMan.getmensaje() %></span>
            </div>
<%              }
    %>
<%      }
    %>
        </td>
    </tr>
<%  if (lManuales != null && lManuales.size() > 0) {
    %>
    <tr>
        <td align="center">
           <span class="titulo"><h2>MANUALES Y FORMULARIOS</h2></span>
        </td>
    </tr>
    <tr>
        <td>

    <!-- copiar desde acá -->
    <div class="wrap-deslplegable">
        <!-- .archivos ... div loop -->
        <div class="archivos">

<%     int iSeccAnt = -1;
        int iID  = 0;
       for (int i=0; i< lManuales.size(); i++)  {
            Manual oMan = (Manual) lManuales.get(i);
            if ( iSeccAnt != oMan.getcodSeccion() ) {
                iSeccAnt = oMan.getcodSeccion();
                iID += 1;
                if (iID > 1) {
   %>
                    </div>
                    <!--! .desplega -->
<%              }
    %>
        <div class="toggle">
        	 <a href="#" title="click para abrir/cerrar" id="<%=iID %>">
        	 <span class="titulo"><%= (oMan.gettitulo()==null ? " " : oMan.gettitulo()) %></span>
             <span class="descripcion"><%= (oMan.getmensaje() == null ? " " : oMan.getmensaje()) %></span>
                </a>
        </div>
        <div class="desplega" id="<%=iID %>d">
<%           } if ( ! oMan.getcategoria().equals("S") ) {
    %>


             <div class="file <%= (oMan.gettipoDoc() == null ? "txt" : oMan.gettipoDoc().toLowerCase()) %>"> <!-- Acá de identefica el icono del archivo con un class, se decir el file + espacio y la extensión | opciones: zip, pdf, xls, doc, txt -->
                 <span class="fecha"><%= (oMan.getfechaPublicacion() == null ? " " : Fecha.showFechaForm(oMan.getfechaPublicacion())) %></span>
                  <a  href="<%= pathManuales %><%=(oMan.getlink()==null?"#": oMan.getlink() )%>" class="link-archivo"  target="_blank"><%= oMan.gettitulo() %></a>
                  <span class="descripcion-archivo"><%= oMan.getmensaje() %></span>
            </div>
<%              }
     %>
<%     }
    %>
        </div>
        <!--! .archivos -->

    </div>
    <!--! -->
        </td>
    </tr>
<%   }
   %>
    <TR>
        <TD valign="bottom" align="center"><jsp:include  flush="true" page="/bottom.jsp"/></TD>
    </TR>
  </TABLE>
</body>
<script>
     CloseEspere();
<% if (sAlerta.equals("S")) { 
%>
     Alerta();
<%  }
    %>
 //  Banner();
</script>
