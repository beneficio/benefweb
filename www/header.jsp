<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%  String sAplicacion = request.getParameter ("aplicacion");
    String sUsuario    = request.getParameter ("usuario");
    String sDescripcion = request.getParameter("descripcion");
    %>
    <div class="header">
     <img src="<%=sAplicacion %>images/logos/bnf_web_logo.png" width="326" height="88" alt="logo" class="logo" />

     <div class="user-info">
          <span class="name">Bienvenido <a href="/benef/servlet/setAccess?opcion=getUsuario&usuario=<%= sUsuario  %>&estado=A" title="ver perfil"><%= sDescripcion %></a></span>
          <span class="sesion"><a href="/benef/servlet/setAccess?opcion=LOGOUTNEW" title="cerrar sesi&oacute;n">Salir</a></span>
     </div>

    </div>      
