<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.business.util.*"%>
<%
  String urlExtranet = config.getServletContext().getInitParameter ("urlExtranet");
  String aplicPortal = config.getServletContext().getInitParameter ("aplic_portal");
  
  if (urlExtranet == null) { urlExtranet =  "https://www.beneficioweb.com.ar/"; }

    %>
<header>
	<div class="container">
	<div class="row header">
        <div class="eleven columns alpha">
        <h1><a href="<%= aplicPortal%>PortalServlet" title="Home"><img src="<%= aplicPortal%>portal/img/beneficio_marca.png" width="325" height="102" alt="Beneficio-SA"></a></h1>
        </div>
         <div class="five columns omega">
             <a href="<%= urlExtranet %>portal/RedirecExtranet.html" class="extranet"  target="_blank" title="BeneficioWeb" id="mienlace"><span class="a">BeneficioWeb</span><span class="b">Acceso a productores<br>Clientes registrados</span></a>
        </div>
    </div>
    </div>
</header>
<nav class="main-navigation">
	 <ul class="nav">
             <li><a href="<%= aplicPortal%>PortalServlet">Home</a></li>
         <li>
         <a href="<%= aplicPortal%>PortalServlet?opcion=home_producto&rama=999">Personas</a>
         <ul>
            <li class="first"></li>
            <li><a href="<%= aplicPortal%>PortalServlet?opcion=home_producto&rama=10">Accidentes Personales</a></li>
            <li><a href="<%= aplicPortal%>PortalServlet?opcion=home_producto&rama=22">Vida Colectivo </a></li>
<!--            <li><a href="<%= aplicPortal%>PortalServlet?opcion=home_producto&rama=222">Vida Colectivo Empresas</a></li>
-->
            <li><a href="<%= aplicPortal%>PortalServlet?opcion=home_producto&rama=25">Salud</a></li>
            <li><a href="<%= aplicPortal%>PortalServlet?opcion=home_producto&rama=23">Saldo Deudor</a></li>
            <li><a href="<%= aplicPortal%>PortalServlet?opcion=home_producto&rama=18">Sepelio</a></li>
          </ul>
         </li>
         <li>
         <a href="<%= aplicPortal%>PortalServlet?opcion=home_producto&rama=999">Empresas</a>
         <ul>
            <li class="first"></li>
            <li><a href="<%= aplicPortal%>PortalServlet?opcion=home_producto&rama=222">Vida Colectivo</a></li>
          </ul>
         </li>

<!--         <li>
         <a href="#">Caución</a>
        	<ul>
            <li class="first"></li>
            <li><a href="<%= aplicPortal%>PortalServlet?opcion=getCaucion&rama=9001">Garantía de alquileres particulares y comerciales</a></li>
            <li><a href="<%= aplicPortal%>PortalServlet?opcion=getCaucion&rama=9002">Garantía de Administradores de Sociedades</a></li>
            <li><a href="<%= aplicPortal%>PortalServlet?opcion=getCaucion&rama=9003">Garantías Contractuales</a></li>
            <li><a href="<%= aplicPortal%>PortalServlet?opcion=getCaucion&rama=9004">Cauciones Aduaneras</a></li>
            <li><a href="<%= aplicPortal%>PortalServlet?opcion=getCaucion&rama=9005">Cauciones para Actividad o Profesión</a></li>
            <li><a href="<%= aplicPortal%>PortalServlet?opcion=getCaucion&rama=9006">Cauciones para empresas de Viajes y Turismo</a></li>
            <li><a href="<%= aplicPortal%>PortalServlet?opcion=getCaucion&rama=9007">Cauciones de pago de Crédito Garantizado</a></li>
            </ul>
         </li>
-->
         <li>
         <a href="#">Institucional</a>
         	<ul>
            <li class="first"></li>
            <li><a href="<%= aplicPortal%>portal/acercaDe.jsp">Acerca de Beneficio</a></li>
            <li><a href="<%= aplicPortal%>PortalServlet?opcion=red_productores">Red de Productores</a></li>
            <li><a href="<%= aplicPortal%>portal/cvForm.jsp">Trabajá con Nosotros</a></li>
            <!--
            <li><a href="<%= aplicPortal%>portal/sitiosDeInteres.jsp">Sitios de Interés</a></li>
            -->
            </ul>
         </li>
         <li><a href="<%= aplicPortal%>portal/contacto.jsp?opcion=0">Contacto</a></li>
     </ul>
 </nav>

