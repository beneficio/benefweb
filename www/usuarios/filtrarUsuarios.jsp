<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.sql.*"%>
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>   
<%@ taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg" %>
<%  Diccionario oDicc   = (Diccionario) session.getAttribute("Diccionario");
    Usuario usu = (Usuario) session.getAttribute("user");
    
    String sPri         = oDicc.getString(request,"pri","S");
    String sUsuario     = oDicc.getString (request, "Fusuario");
    String sNombre      = oDicc.getString (request, "Fnombre");
    String sDocumento   = oDicc.getString (request, "Fdocumento");
    int iTipoUsuario    = oDicc.getInt (request, "FtipoUsuario");
    int iCodProd        = oDicc.getInt (request, "Fcod_prod");
    int iNumTomador     = oDicc.getInt (request, "Fnum_tomador");

    if (sPri != null && sPri.equals("S")) {
        iTipoUsuario = 1;
        }
    oDicc.add("pri", sPri );
    oDicc.add("Fusuario", sUsuario );
    oDicc.add("Fnombre", sNombre);
    oDicc.add("Fdocumento", sDocumento);
    oDicc.add("FtipoUsuario", String.valueOf (iTipoUsuario));
    oDicc.add("Fcod_prod", String.valueOf(iCodProd));
    oDicc.add("Fnum_tomador", String.valueOf (iNumTomador));
    session.setAttribute("Diccionario", oDicc);

CallableStatement cons  = null;  
Connection dbCon        = null;
ResultSet rs            = null;
String sPath            = 
    "&pri=N&Fusuario=" + sUsuario + "&Fnombre=" + sNombre +  
    "&Fdocumento=" + sDocumento +  "&FtipoUsuario=" + iTipoUsuario + 
    "&Fcod_prod=" + iCodProd  + "&Fnum_tomador=" + iNumTomador; 

int iSize = 0;
try {
    if (sPri.equals ("N")) {
        dbCon = db.getConnection();

        dbCon.setAutoCommit(false);
        // Procedure call.  
        cons = dbCon.prepareCall(db.getSettingCall("US_GET_ALL_FILTRAR_USUARIOS (?,?,?,?,?,?)"),
                                 ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        cons.registerOutParameter(1, java.sql.Types.OTHER);
        if ( iCodProd  == 0 ) {
            cons.setNull    (2, java.sql.Types.INTEGER);
        } else {
            cons.setInt     (2, iCodProd );
        }
        if (sNombre.equals ("") ) {
            cons.setNull    (3, java.sql.Types.VARCHAR);
        } else {
            cons.setString  (3, sNombre);
        }
        if (iNumTomador  == 0 ) {
            cons.setNull    (4, java.sql.Types.INTEGER);
        } else {
            cons.setInt     (4, iNumTomador);
        }
        if (sDocumento.equals("")) {
            cons.setNull    (5, java.sql.Types.VARCHAR);
        } else {
            cons.setString  (5, sDocumento);
        }
        if (sUsuario.equals("")) {
            cons.setNull    (6, java.sql.Types.VARCHAR);
        } else {
            cons.setString  (6, sUsuario);
        }

        cons.setInt (7, iTipoUsuario);

        cons.execute();
        rs = (ResultSet) cons.getObject(1);
        
        if (rs != null) {
            while (rs.next()) {
                iSize += 1;
            }
            
        }
   }
    %>  
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
    <SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <SCRIPT language="javascript">

    function  EditarUsuario ( numSecuUsu, usu ) {

       document.formPersona.action = '<%= Param.getAplicacion()%>servlet/setAccess';
       document.formPersona.numSecuUsu.value = numSecuUsu;
       document.formPersona.usuario.value = usu;
       document.formPersona.opcion.value  = 'getUsuario';
       document.formPersona.submit(); 
       return true;
    }

   function  EditarSumas ( numSecuUsu, usu ) {

       document.formPersona.action = '<%= Param.getAplicacion()%>servlet/setAccess';
       document.formPersona.numSecuUsu.value = numSecuUsu;
       document.formPersona.usuario.value = usu;
       document.formPersona.opcion.value  = 'getSumas';
       document.formPersona.submit(); 
       return true;
    }

   function  EditarProductores ( codOrg ) {

       document.formPersona.action = '<%= Param.getAplicacion()%>usuarios/formAllProd.jsp';
       document.formPersona.opcion.value  = 'getProd';
       document.formPersona.cod_org.value  = codOrg;
       document.formPersona.submit(); 
       return true;
    }


    function  CambiarEstado ( numSecuUsu, estado, usu ) {
       var titulo = "Habilitar";
       if ( estado == 'S') titulo = "Deshabilitar";

       if( confirm ("Esta usted seguro que desea " + titulo + " al usuario seleccionado ? ")) {
            document.formPersona.action = '<%= Param.getAplicacion()%>servlet/setAccess';
            document.formPersona.numSecuUsu.value = numSecuUsu;
            document.formPersona.usuario.value = usu;
            document.formPersona.opcion.value  = 'cambiarEstado';
            document.formPersona.submit(); 
            return true;
       } else {
            return false;
       }
    }

    function Buscar () {

       if( document.formPersona ) {
            document.formPersona.action = "<%= Param.getAplicacion()%>usuarios/filtrarUsuarios.jsp";
            document.formPersona.submit(); 
            return true;
       } else {
            return false;
       }
    }
    function Salir () {
        window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }
    </SCRIPT>
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
        <td valign="top" align="center" width="100%">
            <form name="formPersona" id="formPersona" method="POST" action="<%= Param.getAplicacion()%>usuarios/filtrarUsuarios.jsp">
                <input type="hidden" name="opcion" id="opcion" value="getUsuario">
                <input type="hidden" name="pri" id="pri" value="N">
                <input type="hidden" name="estado" id="estado" value="A">
                <input type="hidden" name="volver" id="volver" value='filtrar'>
                <input type="hidden" name="numSecuUsu" id="numSecuUsu" value="-1">
                <input type="hidden" name="cod_prod" id="cod_prod" value="-1">
                <input type="hidden" name="cod_org" id="cod_org" value="-1">
                <input type="hidden" name="usuario" id="usuario" value="">
                <TABLE width="680" border="0" align="center" cellspacing="0" cellpadding="0"  class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                    <TR>
                        <TD height="30px" valign="middle" align="center" class='titulo'>FILTRAR USUARIOS</TD>
                    </TR>
                    <TR>
                        <TD height="20px" valign="middle" align="left" class="subtitulo">Ingrese uno o más de los siguientes filtros:</TD>
                    </TR>
                    <tr>
                        <td>
                            <table align="left" style="margin-left: 15px;">
                                <TR>
                                    <TD width="160px"  class='text'>Tipo de usuario:</TD> 
                                    <TD class='text'>
                                        <select class="select" name='FtipoUsuario' id='FtipoUsuario' >
                                            <option value='999' <%= (iTipoUsuario == 999 ? "selected" : " " )%>>TODOS</option>
                                            <option value='0' <%= (iTipoUsuario == 0 ? "selected" : " " )%>>INTERNOS</option>
                                            <option value='1' <%= (iTipoUsuario == 1 ? "selected" : " " )%>>PRODUCTORES</option>
                                            <option value='80000' <%= (iTipoUsuario == 80000 ? "selected" : " " )%>>ORGANIZADORES</option>
                                            <option value='2' <%= (iTipoUsuario == 2 ? "selected" : " " )%>>CLIENTES</option>
                                        </select>  
                                    </TD>
                                </TR>
                                <tr>
                                     <TD class='text'>Nombre/Apellido/Raz&oacute;n Social:(*)</TD> 
                                     <TD class='text' align="left"><INPUT type="text" name="Fnombre" value="<%=  sNombre %>" size="40" maxlengh="50"></TD>
                                </tr>
                                <TR >
                                    <TD class='text'>Usuario de acceso:(*)</TD> 
                                    <TD class='text' align="left">
                                        <INPUT type="text" name="Fusuario" id="Fusuario" value="<%= sUsuario %>" size="10" maxlengh="20" >
                                    </TD>
                                </TR>
                                <TR>
                                    <td class='text'>Código de productor:&nbsp;</td>
                                    <td align="left"><INPUT type="text" name="Fcod_prod" id="Fcod_prod" value="<%= iCodProd %>" size="10" maxlengh="10"  onkeypress="return Mascara('D',event);" class="inputTextNumeric"></td>
                                <tr>
                                    <td class='text'>Número de cliente:&nbsp;</td>
                                    <td align="left"><INPUT type="text" name="Fnum_tomador" id="Fnum_tomador" value="<%= iNumTomador %>" size="10" maxlengh="10"  onkeypress="return Mascara('D',event);" class="inputTextNumeric"></td>
                                </TR>
                                <tr>
                                    <td align="left" class='text'>N° Documento/CUIT/CUIL:(*)</td>
                                    <td><INPUT name="Fdocumento" value="<%= sDocumento %>" size="13" onkeypress="return Mascara('D',event);" class="inputTextNumeric">
                                    </TD>
                                </TR>
                            </table>
                        </td>
                    </tr>
                    <TR>
                        <TD height="20px" valign="middle" align="left" class="subtitulo" >(*) puede ingresar el valor parcialmente.<br>
                        Por ej: documento = 22 busca todos los documentos que contengan el 22</TD>
                    </TR>
                    <TR>
                        <TD align="center" >
                        <input type="button" name="cmdSalir"  value="  Salir  "  height="20px" class="boton" onClick="Salir ();">&nbsp;&nbsp;&nbsp;
                        <input type="button" name="cmdGrabar" value="  Buscar  "  height="20px" class="boton" onClick="Buscar ();">
                        </TD>
                    </TR>
                 </table>
            </form>
        </td>
    </tr>
<%
    if (sPri != null && sPri.equals ("N")) {
    %>

    <tr>
        <td>
            <TABLE border="0"  width='100%' cellPadding="0" cellSpacing="0" align="left" >
                <tr>
                    <td height="30" class='titulo' valign="middle" align="left">Resultado de la consulta</td>
                </tr>

                <TR>
                    <td valign="top" width='100%'>
                        <pg:pager  maxPageItems="40" items="<%= iSize %>" url="/benef/usuarios/filtrarUsuarios.jsp" maxIndexPages="20" export="currentPageNumber=pageNumber">
                        <pg:param name="keywords"/>

                        <table  border="1" cellspacing="0" cellpadding="0" align="center" class="TablasBody">
                            <thead>
                                <th  width="49px">Usuario</th>
                                <th  width="49px">Estado</th>
                                <th  width="50px">Tipo</th>
                                <th  width="160px">Descripcion</th>
                                <th  width="80px">Documento</th>
                                <th  width="50px">Cod. Prod.</th>
                                <th  width="50px">Num. Cliente</th>
                                <th>Editar</th>
                                <th>Sumas<br> Aseg</th> 
                                 <th>Produc<br>tores</th> 
                               <th >Modif<br>Estado</th>
                            </thead>
                           <% if (rs == null ){%>
                            <tr>
                                <td colspan="11">&nbsp;No existen usuarios</td>
                            </tr>
<%                         } rs.beforeFirst(); 
                           while (rs != null && rs.next ()) { %>
                          <pg:item>
                          <%  
                                String tipo = "Interno";
                                if (rs.getInt ("TIPO_USUARIO") == 1) { tipo = "Productor";}
                                if (rs.getInt ("TIPO_USUARIO") == 2) { tipo = "Cliente";}
    %>
                            <tr>
                                <td align="center" ><span style="color:blue"><%= rs.getString ("USUARIO")%></span></td>
                                <td align="center" ><span style="color:<%= (rs.getString ("HABILITADO").equals("S") ? "green" : "red") %>"><%= (rs.getString("HABILITADO").equals("S") ? "Habilitado" : "Deshabilitado") %></span></td>
                                <td ><span><%= tipo %></span></td>
                                <td ><span><%= rs.getString ("DESCRIPCION") %></span>&nbsp;</td>
                                <td align="right"><span><%= rs.getString ("DESC_TIPO_DOC") %>&nbsp;<%= (rs.getString("DOCUMENTO") == null ? " " : rs.getString("DOCUMENTO")) %></span></td>
                                <td align="right"><span><%= rs.getInt("COD_PROD") %></span></td>
                                <td ><span><%= rs.getInt("NUM_TOMADOR") %></span></td>
                                <td align="center"><span><IMG onClick="EditarUsuario('<%= rs.getInt ("NUM_SECU_USU")%>', '<%= rs.getString ("USUARIO")%>');"  alt="Ver datos del usuario" src="<%= Param.getAplicacion() %>images/nuevo.gif"
                                                    border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;">
                                                    </span></td>
<%                              if (rs.getInt ("TIPO_USUARIO") == 1) {
    %>
                                <td align="center"><span><IMG onClick="EditarSumas('<%= rs.getInt("NUM_SECU_USU") %>', '<%= rs.getString ("USUARIO")%>');"
                                                    src="<%= Param.getAplicacion() %>images/<%= (rs.getDouble("CANT_COB") == 0 ? "nuevo.gif" : "finalizar.gif" )%>"  
                                                    border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;"
                                                    alt=<%= (rs.getDouble("CANT_COB") == 0 ? "No existen sumas máximas cargadas para el productor" : "Existen sumas máximas cargadas para el productor" )%>>
                                                    </span></td>
<%                              } else {
    %>
                                <td>&nbsp;</td>
<%                              }
    %>
<%                              if (rs.getInt ("TIPO_USUARIO") == 1 && rs.getInt ("CANT_PROD") > 0 ) {
    %>
                                <td align="center"><span><IMG onClick="EditarProductores('<%= rs.getInt("COD_PROD") %>');"  
                                                    src="<%= Param.getAplicacion() %>images/productores.gif"  
                                                    border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;"
                                                    alt="Ver el detalle de los&nbsp;<%= rs.getInt ("CANT_PROD") %>&nbsp; productores asociados a este productor/organizador">
                                                    </span></td>
<%                              } else {
    %>
                                <td>&nbsp;</td>
<%                              }
    %>

                                <td align="center"><span><IMG onClick="CambiarEstado('<%= rs.getInt ("NUM_SECU_USU")%>','<%=rs.getString ("HABILITADO") %>', '<%= rs.getString ("USUARIO")%>');"  alt="Habilitar/Deshabilitar usuario" src="<%= Param.getAplicacion() %>images/<%= (rs.getString ("HABILITADO").equals("S") ? "nook.gif" : "ok.gif") %>"  border="0"  hspace="0" vspace="0" align="bottom" style="cursor: hand;"></span></td>
                            </tr>
                            </pg:item> 
                            <%}  %>
                              <thead>
                                <th colspan="11">
                                    <pg:prev>
                                    <a class="rnavLink" href="<%= pageUrl %><%= sPath%>">[Anterior]</a>
                                    </pg:prev>
                                    <pg:pages>
                               <% if (pageNumber == currentPageNumber) { %>
                                    <b><%= pageNumber %></b>
                               <% } else { %>
                                    <a class="rnavLink" href="<%= pageUrl %><%= sPath %>"</a>										   
                               <% } %>
                                    </pg:pages>
                                    <pg:next>
                                    <a class="rnavLink" href="<%= pageUrl %><%= sPath %>">[Siguiente]</a>
                                    </pg:next>
                                </th>
                            </thead>
                        </table>	
                    </pg:pager>
                    </td>
               </tr>
            </table>
        </td>
   </tr>
<%      }
%>
   <TR>
        <TD valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
   </tr>
</table>
<script>
     CloseEspere();
</script>
</body>
</HTML>
<%
    } catch (SQLException se) {
        throw new SurException (se.getMessage());
    } catch (Exception e) {
        throw new SurException (e.getMessage());
    } finally {
        try {
            if (rs != null) { rs.close (); }
            if (cons != null){ cons.close(); }
            db.cerrar(dbCon);
        } catch (SQLException se) {
            throw new SurException (se.getMessage());
        }
    }
    %>
