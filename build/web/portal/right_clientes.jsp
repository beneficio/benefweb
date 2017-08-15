<%-- 
    Document   : right
    Created on : 25/10/2012, 12:38:16
    Author     : relisii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.business.util.*"%>
<%
  String urlExtranet = config.getServletContext().getInitParameter ("urlExtranet");

  if (urlExtranet == null) { urlExtranet =  "https://www.beneficioweb.com.ar/"; }
    %>
    <div class="five columns omega">
   	<!-- sidebar -->
    <aside id="sidebar">
        <div class="widget redes-sociales">
            <h3>Redes Sociales</h3>
            <div class="content_body">
           	<p>Seguinos en nuestros canales oficiales Beneficio S.A. junto a vos.</p>
            <a href="https://www.facebook.com/beneficioweb" title="Facebook Beneficio S.A." class="fb"></a>
            <a href="https://twitter.com/beneficioweb" title="Twitter Beneficio S.A." class="tw"></a>
<%--        <a href="https://www.youtube.com/user/BeneficioSA" title="Youtube Beneficio S.A." class="yt"></a>
            <a href="https://plus.google.com/108530855719950664521" title="Google + Beneficio S.A." class="gplus"></a>
            <a href="#" title="Linkedin Beneficio S.A." class="in"></a>
--%>
            </div>
        </div>

        <div class="widget telefonos">
            <h3>Teléfonos útiles</h3>
            <div class="content_body">
                 <p class="city">Buenos Aires</p>
                 <p class="tel">(011) - 5236-4300</p>

                 <p class="city">Rosario</p>
                 <p class="tel">(0341) - 527-1071</p>

                 <p class="city">Salta</p>
                 <p class="tel">(0387) - 480-0830</p>

                 <p class="city">C&oacute;rdoba</p>
                 <p class="tel">(0351) 568-1000</p>

                 <span class="divider"></span>

                 <p class="city">Asistencia M&eacute;dico Farmace&uacute;tica</p>
                 <p class="tel">0800-333-2861</p>

            </div>
        </div>
        <div class="widget twitter">
            <h3>Twitter</h3>
            <div class="content_body">
            <a class="twitter-timeline" href="https://twitter.com/beneficioweb" data-widget-id="260566679812186112">Tweets por @beneficioweb</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="https://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
            </div>
        </div>

    </aside>
    <!--! sidebar -->

    </div><!--! right -->
