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
  String aplicPortal = config.getServletContext().getInitParameter ("aplic_portal");

    %>
<footer>
	<div class="container">
	<div class="row footer-links">

    <div class="eight columns alpha">
    <div class="personas">
    <h3>Personas</h3>
    <ul>
        <li><a href="<%= aplicPortal%>PortalServlet?opcion=home_producto&rama=10" rel="internal">Accidentes Personales</a></li>
        <li><a href="<%= aplicPortal%>PortalServlet?opcion=home_producto&rama=22" rel="internal">Vida Colectivo Personas</a></li>
        <li><a href="<%= aplicPortal%>PortalServlet?opcion=home_producto&rama=25" rel="internal">Salud</a></li>
        <li><a href="<%= aplicPortal%>PortalServlet?opcion=home_producto&rama=23" rel="internal">Saldo Deudor</a></li>
        <li><a href="<%= aplicPortal%>PortalServlet?opcion=home_producto&rama=18" rel="internal">Sepelio</a></li>
    </ul>
    </div><!-- /.bottom links -->
    <div class="caucion">
    <h3>Empresas</h3>
    <ul>
        <li><a href="<%= aplicPortal%>PortalServlet?opcion=home_producto&rama=222" rel="internal">Vida Colectivo</a></li>
    </ul>
    </div>

    <!-- /.bottom links -->
    </div>
    <div class="eight columns omega">
    <div class="institucional">
    <h3>Institucional</h3>
    <ul>
        <li><a href="<%= aplicPortal%>portal/acercaDe.jsp" rel="internal">Acerca de Beneficio</a></li>
        <li><a href="<%= aplicPortal%>PortalServlet?opcion=red_productores" rel="internal">Red de Productores</a></li>
        <li><a href="<%= aplicPortal%>portal/cvForm.jsp" rel="internal">Trabajá con Nosotros</a></li>
<!--        <li><a href="<%= aplicPortal%>portal/sitiosDeInteres.jsp" rel="internal">Sitios de Interés</a></li>
-->
    </ul>
    </div>
<!-- /.bottom links -->
    <div class="accesos-l">
    <h3>Accesos</h3>
    <ul>
        <li><a href="<%= urlExtranet %>portal/RedirecExtranet.html" target="_blank">Beneficio Web (productores)</a></li>
            <a href="<%= urlExtranet %>portal/RedirecClientes.html" target="_blank" title="Acceso a clientes">Beneficio On-line (clientes)</a>
        <li><a href="<%= aplicPortal%>PortalServlet?opcion=descargas" rel="internal">Descarga de Formularios</a></li>
        <li><a href="<%= aplicPortal%>portal/registracionForm.jsp" rel="internal">¿Querés ser Productor?</a></li>
        <li><a href="<%= aplicPortal%>portal/cvForm.jsp" rel="internal">Ingresá tu C.V.</a></li>
    </ul>
    <ul class="ul-bottom">
        <li><a href="<%= aplicPortal%>portal/contacto.jsp?opcion=0" rel="internal">Contacto</a></li>
        <li><a href="http://www.beneficioweb.com.ar:8080/roundcube" rel="internal" target="_blank">Webmail Beneficio S.A.</a></li>
    </ul>
    </div><!-- /.bottom links -->

    </div>
    </div>

    <div class="row">

    <div id="web-links" class="sixteen columns">
    	 <div class="twelve columns alpha">
             <a href="<%= aplicPortal%>portal/condicionesUso.jsp">Condiciones de Uso</a>
             <span class="sep">|</span> <a href="<%= aplicPortal%>portal/politicaPrivacidad.jsp">Pol&iacute;tica de Privacidad</a>
             <span class="sep">|</span> <a href="<%= aplicPortal%>portal/datosPersonales.jsp">Webmaster</a>
             <span class="sep">|</span> <a href="<%= aplicPortal%>portal/servicioAT.jsp">Servicio atenci&oacute;n al Asegurado</a>
             <span class="sep">|</span> <a href="<%= aplicPortal%>portal/prevencionFraude.jsp">Fraude</a>
         </div>
         <div class="four columns alpha">
             <a href="https://qr.afip.gob.ar/?qr=-tPe_XC8VxJ93E9_QR6GMQ,," target="_F960AFIPInfo" title="QR - AFIP, Data Fiscal" class="qr-code">
                <img src="<%= aplicPortal%>images/logos/DATAWEB.jpg" align="qr-afip" height="126" width="92">
             </a>
<script src="<%= aplicPortal%>images/certisur/JavaScript-Seal-v3.0.js" type="text/javascript"></script>
<div align="center" title="Haga Click para Verificar - Este sitio cuenta con un Certificado SSL para asegurar la confidencialidad de sus comunicaciones.">
<a href="javascript:Seal_Certificado('www.beneficioweb.com.ar', 'es', 'CTRM-3.0', 'imagen');"><img src="<%= aplicPortal%>images/certisur/CTRM-3.0.gif" alt="CertiSur Seal" width="80" height="80" border="0" /></a>
</div>
             
         </div>
             
    </div>

    <div id="info-bottom" class="sixteen columns">
    <div class="eight columns alpha">
    <!-- hcard -->
    <address id="about" class="vcard body">
    		<span class="fn">Casa Central</span>
    		<span class="adr">
            	<span class="street-address">Leandro N. Alem N° 584 piso 12</span>
            	<span class="postal-code">(1001)</span>
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
    <p class="copyright">&copy; 2012 Todos los derechos reservados - Beneficio S.A.</p>
    </div>

    <div class="eight columns omega">
    <!-- extras -->
    <div class="extras">
        <a id="top-bt" href="#top" title="go to top">volver arriba</a>
        <div class="redes-sociales-bottom">
            <a href="https://www.facebook.com/pages/Beneficio-SA/490835027613830" title="Facebook Beneficio S.A." class="fb"></a>
            <a href="https://twitter.com/beneficioweb" title="Twitter Beneficio S.A." class="tw"></a>
<!--            <a href="https://www.youtube.com/user/BeneficioSA" title="Youtube Beneficio S.A." class="yt"></a>
            <a href="https://plus.google.com/108530855719950664521" rel="publisher" title="Google + Beneficio S.A." class="gplus"></a>
            <a href="#" title="Linkedin Beneficio S.A." class="in"></a>
-->
        </div>
    </div>
    <!--! extras -->
    </div>

    </div>

    <div class="sixteen columns alpha">
    	 <p class="ssn">
    	 Superintendencia de Seguros de la Naci&oacute;n
         Organo de Control de la Actividad Aseguradora y Reaseguradora
         <span><a href="tel:08006668400" title="llamar ...">0800-666-8400</a> - <a href="https://www.ssn.gob.ar/" target="_blank" title="Web SSN">www.ssn.gob.ar</a> - N&ordm; de inscripci&oacute;n: 555</span>
         </p>
    </div>

    </div>

   </div><!--! container -->
</footer>
