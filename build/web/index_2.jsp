<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Manual"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.CallableStatement"%>
<%@page import="com.business.db.*"%>
<%@page import="java.sql.SQLException"%>
<%@ taglib uri="tld/menu.tld" prefix="menu" %>
<% Usuario usu = new Usuario();
usu.setiCodTipoUsuario(0);
usu.setusuario("PINO");

LinkedList lManuales  = null;
LinkedList lNovedades = null;
LinkedList lPanel     = null;
String sFecha        =  null;
Connection dbCon = null;
CallableStatement cons = null;
ResultSet rs           = null;
CallableStatement cons2 = null;
ResultSet rs2           = null;
CallableStatement cons3 = null;

try {
    dbCon = db.getConnection();
    dbCon.setAutoCommit(false);
    cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_MANUALES(?)"));
    cons.registerOutParameter(1, java.sql.Types.OTHER);
    cons.setInt (2, usu.getiCodTipoUsuario());

    cons.execute();

    rs = (ResultSet) cons.getObject(1);
    if (rs != null) {
        lManuales = new LinkedList ();
        while (rs.next()) {
            Manual oMan = new Manual ();
            oMan.setcodSeccion(rs.getInt ("COD_SECCION"));
            oMan.settitulo(rs.getString ("TITULO"));
            oMan.setcategoria(rs.getString ("CATEGORIA"));
            oMan.setmensaje(rs.getString ("MENSAJE"));
            oMan.setlink(rs.getString ("LINK"));
            oMan.settipoDoc(rs.getString ( "TIPO_DOC"));
            lManuales.add (oMan);
       }
        rs.close();
    }
    cons.close();

    dbCon.setAutoCommit(false);
    cons2 = dbCon.prepareCall(db.getSettingCall("GET_ALL_NOVEDADES(?)"));
    cons2.registerOutParameter(1, java.sql.Types.OTHER);
    cons2.setInt (2, usu.getiCodTipoUsuario());

    cons2.execute();

    rs2 = (ResultSet) cons2.getObject(1);
    if (rs2 != null) {
        lNovedades = new LinkedList ();
        while (rs2.next()) {
            Manual oMan = new Manual ();
            oMan.settitulo(rs2.getString ("TITULO"));
            oMan.setmensaje(rs2.getString ("MENSAJE"));
            oMan.setlink(rs2.getString ("LINK"));
            oMan.settipoDoc(rs2.getString ( "TIPO_DOC"));
            oMan.setfechaPublicacion(rs2.getDate ("FECHA"));
            lNovedades.add (oMan);
       }
        rs2.close();
    }
    cons2.close();

    cons3= dbCon.prepareCall(db.getSettingCall("INT_ULTIMA_INTERFASE()"));
    cons3.registerOutParameter(1, java.sql.Types.VARCHAR);
    cons3.execute();
    sFecha = cons3.getString(1);  
    cons3.close();
  } catch (SQLException se) {
    System.out.println ("ERROR HOME" + se.getMessage());
  } finally {
            try {
                if (cons != null ) cons.close();
                if (rs != null) rs.close();
                if (cons2 != null ) cons2.close();
                if (rs2 != null) rs2.close();
                if (cons3 != null ) cons3.close();
            } catch (SQLException se) {
                throw new SurException( se.getMessage());
            }

            db.cerrar(dbCon);
      }

String pathNovedades = "/benef/files/novedades/";
String pathManuales  = "/benef/files/manuales/";
session.setAttribute("Diccionario", null);
session.setAttribute("Diccionario", new Diccionario ());
String sAlerta    = (request.getParameter ("alerta") == null ? "N" : request.getParameter ("alerta"));
String sBloqueada = (request.getParameter ("flag") == null ? "N" : request.getParameter ("flag"));
String sPri       = (request.getParameter ("pri") == null ? "N" : request.getParameter ("pri"));
%>
<html xmlns="https://www.w3.org/1999/xhtml">
<head><title>Entranet de productores - Beneficio</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>portal/css/estilos.css"/>
<link href="<%= Param.getAplicacion()%>script/flexnav/css/flexnav.css" media="screen, projection" rel="stylesheet" type="text/css"/>
<link href="<%= Param.getAplicacion()%>script/flexnav/css/font-awesome.css" media="screen, projection" rel="stylesheet" type="text/css"/>

<script type='text/javascript' src='<%=Param.getAplicacion()%>script/popUp.js'></script>

<!-- libreria jquery desde el cdn de google o fallback local -->
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js"></script>
<script type="text/javascript">window.jQuery || document.write('<script src="<%=Param.getAplicacion()%>portal/js/vendor/jquery-1.8.0.min.js"><\/script>')</script>

<script type="text/javascript">
$(document).ready(function(){

	 $(".accordion h2:first").addClass("active");
	 $(".accordion div.wrap-files:not(:first)").hide();

	 $(".accordion h2").click(function(){
	 $(this).next("div.wrap-files").slideToggle("fast")
	 .siblings("div.wrap-files:visible").slideUp("fast");
	 $(this).toggleClass("active");
	 $(this).siblings("h2").removeClass("active");
	 });

});
    var IE5 = (document.all && document.getElementById) ? true : false;
    var sfecha = "";
    function get_fecha(){
        dias=new Array("Domingo", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado");
        meses=new Array("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Setiembre", "Octubre", "Noviembre", "Diciembre");
        nmeses=new Array("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12");
        ndia=new Array("00","01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22","23", "24", "25", "26", "27", "28", "29", "30", "31");
        fecha=new Date();
        if (IE5) {
            sfecha = dias[fecha.getDay()]+" "+fecha.getDate()+" de "+meses[fecha.getMonth()]+" " +fecha.getYear();
        }else{
            sfecha = dias[fecha.getDay()]+" "+fecha.getDate()+" de "+meses[fecha.getMonth()]+" " +(fecha.getYear()+1900);
        }
      return sfecha; 
    }

   function Alerta () {
        var sUrl = "<%= Param.getAplicacion()%>usuarios/alerta.jsp";
        var W = 650;
        var H = 450;

        AbrirPopUp (sUrl, W, H);
    }

    function Banner () {
        var sUrl = "<%= Param.getAplicacion()%>news/e-mail/tarjeta-flash/archivos/index.html";
        var W = 820;
        var H = 535;

        AbrirPopUp (sUrl, W, H);
    }

</script>
</head>
<body>

<%--
<div class="container">
    <jsp:include page="/header.jsp">
        <jsp:param name="aplicacion" value="<%= Param.getAplicacion() %>" />
        <jsp:param name="usuario" value="<%= usu.getusuario() %>" />
        <jsp:param name="descripcion" value="<%= usu.getRazonSoc() %>" />
    </jsp:include>
--%>
     <!-- menu -->
     <div class="menu-button">Menu</div>
        <nav>
          <ul data-breakpoint="800" class="flexnav">
            <li><a href="">Item 1</a>
              <ul>
                <li> <a href="#content">Sub 1 Item 1</a></li>
                <li><a href="/">Sub 1 Item 2</a></li>
                <li><a href="/">Sub 1 Item 3</a></li>
                <li><a href="/">Sub 1 Item 4</a></li>
              </ul>
            </li>
            <li><a href="/">Item 2</a>
              <ul>
                <li><a href="/">Sub 1 Item 1</a></li>
                <li><a href="/">Sub 1 Item 2</a>
                  <ul>
                    <li><a href="/">Sub 2 Item 1</a></li>
                    <li><a href="http://jasonweaver.name/">Sub 2 Item 2</a></li>
                    <li><a href="http://jasonweaver.name/">Sub 2 Item 3</a></li>
                  </ul>
                </li>
                <li><a href="http://jasonweaver.name/">Sub 1 Item 3</a>
                  <ul>
                    <li><a href="http://jasonweaver.name/">Sub 2 Item 1</a></li>
                    <li><a href="http://jasonweaver.name/">Sub 2 Item 2</a>
                      <ul>
                        <li><a href="http://jasonweaver.name/">Sub 3 Item 1</a></li>
                        <li><a href="http://jasonweaver.name/">Sub 3 Item 2</a></li>
                        <li><a href="http://jasonweaver.name/">Sub 3 Item 3</a></li>
                      </ul>
                    </li>
                  </ul>
                </li>
              </ul>
            </li>
            <li><a href="http://jasonweaver.name/">Item 3</a>
              <ul>
                <li><a href="http://jasonweaver.name/">Sub 1 Item 1</a></li>
                <li><a href="http://jasonweaver.name/">Sub 1 Item 2</a></li>
                <li><a href="http://jasonweaver.name/">Sub 1 Item 3</a></li>
              </ul>
            </li>
            <li><a href="">Item 4</a>
              <ul>
                <li><a href="http://jasonweaver.name/">Sub 1 Item 1</a></li>
                <li><a href="http://jasonweaver.name/">Sub 1 Item 2</a></li>
                <li><a href="http://jasonweaver.name/">Sub 1 Item 3</a></li>
              </ul>
            </li>
            <li><a href="http://jasonweaver.name/">Item 5</a>
              <ul>
                <li><a href="http://jasonweaver.name/">Sub 1 Item 1</a></li>
                <li><a href="http://jasonweaver.name/">Sub 1 Item 2</a></li>
                <li><a href="http://jasonweaver.name/">Sub 1 Item 3</a></li>
              </ul>
            </li>
          </ul>
        </nav>
     <!--! menu -->
<%--    
     <div class="info">
          <span class="date"><script type="text/javascript">document.write(get_fecha());</script>
<%    if (sBloqueada.equals ("S") ) {
    %>
              <span style="color:red;font-weight:bold;font-size: x-large;">ATENCION: LA WEB ESTA BLOQUEADA PARA PRODUCTORES</span>
<%   }
    %>
          </span>
          <span class="update">Ultima actualizaci&oacute;n de p&oacute;lizas y cobranza:&nbsp;<%= sFecha %></span>
     </div>
<%
   if (lPanel != null) {
       %>
     <div class="wrap-panel">
         <h1 class="title-section">panel</h1>
         <div class="panel">
             <span class="info-txt new">Cuenta corriente  actualizada al ultimo mes </span>
             <span class="result">3</span>
             <span class="info-txt ok">Propuestas en carga pendiente de emision</span>
             <span class="result">3</span>
             <span class="info-txt alert">Propuestas RECHAZADAS</span>
             <span class="result">3</span>
             <span class="info-txt new">Polizas nuevas emitidas durante los ultimos 30 dias</span>
             <span class="result">3</span>
         </div>

     </div>
<%  }
   %>

--%>
<%--   
     <div class="left">
     	  <h1 class="title-section">novedades</h1>
     	  <div class="news">
<%          if (lNovedades != null) {
                for (int ii=0; ii< lNovedades.size(); ii++) {
                    Manual oMan = (Manual) lNovedades.get(ii);
    %>

               <div class="file <%= ( oMan.gettipoDoc()== null ? "" :  oMan.gettipoDoc().toLowerCase()) %>-mini">
                   <!-- Aca de identefica el icono del archivo con un class, es decir file + espacio y la extensiÃÂ³n | opciones: zip-mini, pdf-mini, xls-mini, doc-mini -->
        		  <span class="fecha"><%= (oMan.getfechaPublicacion() == null ? " " : Fecha.showFechaForm(oMan.getfechaPublicacion())) %></span>
<%                 if (oMan.getlink() == null) {
    %>
                          <span class="link-archivo"><b><%= oMan.gettitulo() %></b></span>
<%                  } else {
    %>
                          <a href="<%= pathNovedades %><%=oMan.getlink()%>" class="link-archivo" target="_blank"><%= oMan.gettitulo() %></a>
<%                  }
    %>
                  <span class="descripcion-archivo"><%= oMan.getmensaje() %></span>
                </div>
<%             }
            }
   %>
          </div>

     </div>
     <!--! left -->

     <!-- right -->
     <div class="right">
     	  <h1 class="title-section">manuales y formularios</h1>
          <div class="accordion">
<%  if (lManuales != null && lManuales.size() > 0) {
        int iSeccAnt = -1;
        boolean bFirst = true;
        for (int i=0; i< lManuales.size(); i++)  {
            Manual oMan = (Manual) lManuales.get(i);
            if ( iSeccAnt != oMan.getcodSeccion() ) {
                iSeccAnt = oMan.getcodSeccion();
                if ( bFirst ) {
                    bFirst = false;
                } else {
    %>
            </div>
<%             }
    %>

          	   <!-- bloque repeat -->
               <h2><%= (oMan.gettitulo()==null ? " " : oMan.gettitulo()) %></h2>
               <div class="wrap-files">
<%         }
            if ( ! oMan.getcategoria().equals("S") ) {
    %>
               <div class="file <%= ( oMan.gettipoDoc()== null ? "doc" :  oMan.gettipoDoc().toLowerCase()) %>-mini">
                   <!-- Aca de identefica el icono del archivo con un class, es decir file + espacio y la extensiÃÂ³n | opciones: zip-mini, pdf-mini, xls-mini, doc-mini -->
<%              if (oMan.getlink() == null ) {
    %>
                    <span class="descripcion-archivo"><b><%= oMan.gettitulo() %></b></span>
<%              } else {
    %>
      		     <a href="<%= pathManuales %><%= oMan.getlink() %>" class="link-archivo" target="_blank"><%= oMan.gettitulo() %>
<%              }
    %>
                  <span class="descripcion-archivo"><%= oMan.getmensaje() %></span>
                    </a>
                </div>
<%              }
            }
     }
   %>

        </div>
     </div>
</div>
--%>

    <script type="text/javascript">
      //$.noConflict();
    </script>
    <script src="<%= Param.getAplicacion()%>script/flexnav/js/jquery.flexnav.js" type="text/javascript"></script>
    <script type="text/javascript">
		jQuery(document).ready(function($) {
			// initialize FlexNav
			$(".flexnav").flexNav();
		});
    </script>

</body>
</html>   
