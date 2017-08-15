<%-- 
    Document   : footer
    Created on : 25/10/2012, 11:21:49
    Author     : relisii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.business.util.*"%>
<%
  //ServletConfig config = getServletConfig();
  String urlExtranet = config.getServletContext().getInitParameter ("urlExtranet");

    %>
<footer>
	<div class="container">
	<div class="row footer-links">

    <div class="eight columns alpha">
    <div class="personas">
    <h3>Personas</h3>
    <ul>
        <li><a href="<%= Param.getAplicacion()%>PortalServlet?opcion=home_producto&rama=10" rel="internal">Accidentes Personales</a></li>
        <li><a href="<%= Param.getAplicacion()%>PortalServlet?opcion=home_producto&rama=22" rel="internal">Vida Colectivo Personas</a></li>
<!--        <li><a href="<%= Param.getAplicacion()%>PortalServlet?opcion=home_producto&rama=222" rel="internal">Vida Colectivo Empresas</a></li>
-->
        <li><a href="<%= Param.getAplicacion()%>PortalServlet?opcion=home_producto&rama=25" rel="internal">Salud</a></li>
        <li><a href="<%= Param.getAplicacion()%>PortalServlet?opcion=home_producto&rama=23" rel="internal">Saldo Deudor</a></li>
        <li><a href="<%= Param.getAplicacion()%>PortalServlet?opcion=home_producto&rama=18" rel="internal">Sepelio</a></li>
    </ul>
    </div><!-- /.bottom links -->
    <div class="caucion">
    <h3>Empresas</h3>
    <ul>
        <li><a href="<%= Param.getAplicacion()%>PortalServlet?opcion=home_producto&rama=222" rel="internal">Vida Colectivo</a></li>
    </ul>
    <ul class="ul-bottom">
        <li><a href="http://qr.afip.gob.ar/?qr=-tPe_XC8VxJ93E9_QR6GMQ,," target="_F960AFIPInfo"><img src="http://www.afip.gob.ar/images/f960/DATAWEB.jpg" border="0" width="92" height="126"></a></li>
    </ul>
    </div><!-- /.bottom links -->
<!--    <div class="caucion">
    <h3>Caución</h3>
    <ul>
        <li><a href="<%= Param.getAplicacion()%>PortalServlet?opcion=getCaucion&rama=9001" rel="internal">Garantía de alquileres particulares y comerciales</a></li>
        <li><a href="<%= Param.getAplicacion()%>PortalServlet?opcion=getCaucion&rama=9002" rel="internal">Garantía de Administradores de Sociedades</a></li>
        <li><a href="<%= Param.getAplicacion()%>PortalServlet?opcion=getCaucion&rama=9003" rel="internal">Garantías Contractuales</a></li>
        <li><a href="<%= Param.getAplicacion()%>PortalServlet?opcion=getCaucion&rama=9004" rel="internal">Cauciones Aduaneras</a></li>
        <li><a href="<%= Param.getAplicacion()%>PortalServlet?opcion=getCaucion&rama=9005" rel="internal">Cauciones para Actividad o Profesión</a></li>
        <li><a href="<%= Param.getAplicacion()%>PortalServlet?opcion=getCaucion&rama=9006" rel="internal">Cauciones para empresas de Viajes y Turismo</a></li>
        <li><a href="<%= Param.getAplicacion()%>PortalServlet?opcion=getCaucion&rama=9007" rel="internal">Cauciones de pago de Crédito Garantizado</a></li>
    </ul>
    </div>
--><!-- /.bottom links -->
    </div>
    <div class="eight columns omega">
    <div class="institucional">
    <h3>Institucional</h3>
    <ul>
        <li><a href="<%= Param.getAplicacion()%>portal/acercaDe.jsp" rel="internal">Acerca de Beneficio</a></li>
        <li><a href="<%= Param.getAplicacion()%>PortalServlet?opcion=red_productores" rel="internal">Red de Productores</a></li>
        <li><a href="<%= Param.getAplicacion()%>portal/cvForm.jsp" rel="internal">Trabajá con Nosotros</a></li>
<!--        <li><a href="<%= Param.getAplicacion()%>portal/sitiosDeInteres.jsp" rel="internal">Sitios de Interés</a></li>
-->
    </ul>
    </div>
<!-- /.bottom links -->
    <div class="accesos-l">
    <h3>Accesos</h3>
    <ul>
        <li><a href="<%= urlExtranet %>portal/extranet.jsp" target="_blank">Beneficio Web (productores)</a></li>
        <li><a href="<%= Param.getAplicacion()%>portal/clientes.jsp" rel="internal">Beneficio On-line (clientes)</a></li>
        <li><a href="<%= Param.getAplicacion()%>PortalServlet?opcion=descargas" rel="internal">Descarga de Formularios</a></li>
        <li><a href="<%= Param.getAplicacion()%>portal/registracionForm.jsp" rel="internal">¿Querés ser Productor?</a></li>
        <li><a href="<%= Param.getAplicacion()%>portal/cvForm.jsp" rel="internal">Ingresá tu C.V.</a></li>
    </ul>
    <ul class="ul-bottom">
        <li><a href="<%= Param.getAplicacion()%>portal/contacto.jsp?opcion=0" rel="internal">Contacto</a></li>
        <li><a href="http://www.beneficioweb.com.ar:8080/webmail/src/login.php" rel="internal" target="_blank">Webmail Beneficio S.A.</a></li>
    </ul>
    </div><!-- /.bottom links -->

    </div>
    	</div>

    <div class="row">

    <div id="info-bottom" class="sixteen columns">
    <div class="eight columns alpha">
    <!-- hcard -->
    <address id="about" class="vcard body">
    		<span class="fn">Casa Central</span>
    		<span class="adr">
            	<span class="street-address">Leandro N. Alem N° 530 piso 1</span>
            	<span class="postal-code">(1047)</span>
                <span class="locality">Capital Federal</span>
            </span>
            <span class="tel">
                 <span class="type">Tel/Fax: </span>
                 <span class="value">+54 (011) 5236-4300</span>
            </span>
            <span class="email">
                 <span class="value">casacentral@beneficiosa.com.ar</span>
            </span>
    </address>
    <!--! hcard -->
    <p class="copyright">Superintendencia de Seguros de la Naci&oacute;n</p>
    <p class="copyright">Organo de Control de la Actividad Aseguradora y Reaseguradora</p>
    <p class="copyright">0800-666-8400 - <a href="http://www.ssn.gob.ar" target="_blank">www.ssn.gob.ar</a> - Nº de inscripci&oacute;n: 555</p>
    <p class="copyright">&copy; 2012 Todos los derechos reservados - Beneficio S.A.</p>
    </div>
    <div class="eight columns omega">
    <!-- extras -->
    <div class="extras">
        <a id="top-bt" href="#top" title="go to top">Ir arriba</a>
        <div class="redes-sociales-bottom">
            <a href="https://www.facebook.com/beneficioweb" title="Facebook Beneficio S.A." class="fb"></a>
            <a href="https://twitter.com/beneficioweb" title="Twitter Beneficio S.A." class="tw"></a>
<%--            <a href="https://www.youtube.com/user/BeneficioSA" title="Youtube Beneficio S.A." class="yt"></a>
            <a href="https://plus.google.com/108530855719950664521" rel="publisher" title="Google + Beneficio S.A." class="gplus"></a>
            <a href="#" title="Linkedin Beneficio S.A." class="in"></a>
--%>
        </div>
    </div>
    <!--! extras -->
    </div>

    </div>
    </div>

   </div><!--! container -->
</footer>
