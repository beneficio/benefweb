<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Hits"%>
<%@page import="com.business.beans.Poliza"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%@page import="java.io.*"%>
<%@taglib uri="/tld/menu.tld" prefix="menu"%>   
<%@taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg" %>
<%  
    Usuario usu = (Usuario) session.getAttribute("user");
    if (usu.getiCodTipoUsuario() != 0) {
        request.setAttribute("javax.servlet.jsp.jspException", new SurException ("acceso denegado"));
        getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
    }


Connection dbCon = null;
CallableStatement proc  = null;
ResultSet rs            = null;
CallableStatement proc2  = null;
ResultSet rs2            = null;
String sValor = null;
String sValorDesc = null;
String sHora  = null;
String sUser  = null;
java.util.Date dFecha = null;
String sValor2 = null;
String sValorDesc2 = null;
String sHora2  = null;
String sUser2  = null;
java.util.Date dFecha2 = null;
try {
    dbCon = db.getConnection();
    dbCon.setAutoCommit(false);
    proc = dbCon.prepareCall(db.getSettingCall("PARAM_GET_PARAMETRO (?)"));
    proc.registerOutParameter(1, java.sql.Types.OTHER);
    proc.setString (2, "ESTADO_INTERFACE");
    proc.execute();
    rs = (ResultSet) proc.getObject(1);
      while (rs.next ()) {
          sValor = rs.getString ("VALOR");
          if (sValor != null && rs.getString ("VALOR").equals("S")) {
              sValorDesc = "HABILITADA";
           } else {
              sValorDesc = "BLOQUEADA";
           }
          sHora  =  rs.getString ("HORA_TRABAJO");
          dFecha =  rs.getDate   ("FECHA_TRABAJO");
          sUser  = rs.getString ("COD_USR");
      }
     rs.close ();
     proc.close();

    proc2 = dbCon.prepareCall(db.getSettingCall("PARAM_GET_PARAMETRO (?)"));
    proc2.registerOutParameter(1, java.sql.Types.OTHER);
    proc2.setString (2, "ESTADO_INTERFACE_BATCH");
    proc2.execute();
    rs2 = (ResultSet) proc2.getObject(1);
      while (rs2.next ()) {
          sValor2 = rs2.getString ("VALOR");
          if (sValor2 != null && rs2.getString ("VALOR").equals("S")) {
              sValorDesc2 = "HABILITADA";
           } else {
              sValorDesc2 = "BLOQUEADA";
           }
          sHora2  =  rs2.getString ("HORA_TRABAJO");
          dFecha2 =  rs2.getDate   ("FECHA_TRABAJO");
          sUser2  = rs2.getString ("COD_USR");
      }
     rs2.close ();
     proc2.close();

%>
<html>
<head>
    <title>Interfaces</title>
    <LINK rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css">	
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
    <SCRIPT language="javascript">
    function Salir () {
        window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

    function Ejecutar () {
    
        if ( (document.getElementById ('interface_5').checked || document.getElementById ('interface_6').checked ) && 
              document.form1.estado.value == 'N') {
              alert ("INTERFACE WEB --> DC BLOQUEADA !!! ");
              return false;
        }

        if (document.getElementById ('interface_1').checked ) document.getElementById('interface_1').value = 'S'; 
        if (document.getElementById ('interface_2').checked ) document.getElementById('interface_2').value = 'S'; 
        if (document.getElementById ('interface_3').checked ) document.getElementById('interface_3').value = 'S'; 
        if (document.getElementById ('interface_4').checked ) document.getElementById('interface_4').value = 'S'; 
        if (document.getElementById ('interface_5').checked ) document.getElementById('interface_5').value = 'S'; 
        if (document.getElementById ('interface_6').checked ) document.getElementById('interface_6').value = 'S'; 
        
       if ( document.getElementById ('interface_1').checked  || 
            document.getElementById ('interface_2').checked  || 
            document.getElementById ('interface_3').checked  || 
            document.getElementById ('interface_4').checked  || 
            document.getElementById ('interface_5').checked  || 
            document.getElementById ('interface_6').checked )  {
         
            document.form1.submit();
            return true;
       } else {
            alert ("Debe seleccionar una interface válida !!!" );
            return false;
       }
    }

    function CambiarEstado (tipoEmision, estado) {

        document.form1.opcion.value = "cambiarEstado";
        document.form1.estado.value = estado;
        document.form1.tipo_emision.value = tipoEmision;
        document.form1.submit();
    }
    </SCRIPT>
</head>
<body  leftMargin="20" topMargin="5" marginheight="0" marginwidth="0">
<menu:renderMenuFromDB    aplicacion="1" userLogon="<%= usu.getusuario()%>"  />
<table cellSpacing="0" cellPadding="0" width="720"  align="left" border="0">
    <tr>
        <td align="center" valign="top" width="100%">
            <jsp:include flush="true" page="/top.jsp"/>
        </td>
    </tr>
    <tr>
        <td valign="top" align="center" width="755">
            <form name="form1" id="form1" method="POST" action="<%= Param.getAplicacion()%>servlet/InterfaceServlet">
                <input type="hidden" name="opcion" id="opcion" value="runInterface">
                <input type="hidden" name="estado" id="estado" value="<%= sValor %>">
                <input type="hidden" name="tipo_emision" id="tipo_emision" value="">
                <TABLE width="680" border="0" align="center" cellspacing="0" cellpadding="0"  class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                    <TR>
                        <TD height="30px" valign="middle" align="center" class='titulo' colspan='2'>PROCESAMIENTO DE INTERFACES</TD>
                    </TR>
                    <TR>
                        <TD align="left" class='subtitulo' colspan='2'>ESTADO DE INTERFACE ON LINE DE PROPUESTAS</TD>
                    </TR>
                    <TR>
                        <TD align="left" class='text' colspan='2'>
                            <img src="<%= Param.getAplicacion()%>images/<%= (sValor.equals("S") ? "ok.gif" : "nook.gif" ) %>" border="0">&nbsp;<%= sValorDesc %>&nbsp;
                            &nbsp;&nbsp;<%= Fecha.showFechaForm( dFecha ) %>&nbsp;a&nbsp;las&nbsp;<%= sHora %>&nbsp;por&nbsp;<%= sUser %>&nbsp;&nbsp;&nbsp;
                            <input type="button" name="cmdCambiar" value="<%= (sValor.equals("S") ? " BLOQUEAR " : " HABILITAR " ) %>"  height="20px" class="boton"
                                   onClick="CambiarEstado ('ESTADO_INTERFACE', '<%= (sValor.equals("S") ? "N" : "S") %>');">
                        </TD>
                    </TR>
                    <TR>
                        <TD align="left" class='subtitulo' colspan='2'>ESTADO DE INTERFACE BATCH DE PROPUESTAS</TD>
                    </TR>
                    <TR>
                        <TD align="left" class='text' colspan='2'>
                            <img src="<%= Param.getAplicacion()%>images/<%= (sValor2.equals("S") ? "ok.gif" : "nook.gif" ) %>" border="0">&nbsp;<%= sValorDesc2 %>&nbsp;
                            &nbsp;&nbsp;<%= Fecha.showFechaForm( dFecha2 ) %>&nbsp;a&nbsp;las&nbsp;<%= sHora2 %>&nbsp;por&nbsp;<%= sUser2 %>&nbsp;&nbsp;&nbsp;
                            <input type="button" name="cmdCambiar" value="<%= (sValor2.equals("S") ? " BLOQUEAR " : " HABILITAR " ) %>"  height="20px" class="boton"
                                   onClick="CambiarEstado ('ESTADO_INTERFACE_BATCH', '<%= (sValor2.equals("S") ? "N" : "S") %>');">
                        </TD>
                    </TR>
                    <TR>
                        <TD align="left" class='subtitulo' colspan='2'>DC --> WEB</TD>
                    </TR>
                    <tr>
                        <td align="left"  class="text">&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="interface_1" id="interface_1" value='N'></td>
                        <td align="left"  class="text">Pólizas y cobranza</td>
                    </tr>
                    <tr>
                        <td align="left"  class="text">&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="interface_2" id="interface_2" value='N'></td>
                        <td align="left"  class="text">Información básica del sistema: Ramas, Sub ramas, Coberturas, etc</td>
                    </tr>
                    <tr>
                        <td align="left"  class="text">&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="interface_3" id="interface_3" value='N'></td>
                        <td align="left"  class="text">Propuestas: actualización del estado de propuestas solicitadas desde la web</td>
                    </tr>
                    <tr>
                        <td align="left"  class="text">&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="interface_4" id="interface_4" value='N'></td>
                        <td align="left"  class="text">Productores: datos de acceso, personales y comisiones</td>
                    </tr>
                    <TR>
                        <TD align="left" class='subtitulo' colspan='2'>WEB --> DC</TD>
                    </TR>
                    <tr>
                        <td align="left"  class="text">&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="interface_5" id="interface_5"  value='N'></td>
                        <td align="left"  class="text">Actualización de Propuestas</td>
                    </tr>
                    <tr>
                        <td align="left"  class="text">&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="interface_6" id="interface_6"  value='N'></td>
                        <td align="left"  class="text">Tabla de Actividades/Categoria</td>
                    </tr>
                 </table>
            </form>
        </td>
    </tr>
   <TR>
        <TD align="center" >
        <input type="button" name="cmdSalir"  value="  Salir  "  height="20px" class="boton" onClick="Salir ();">&nbsp;&nbsp;&nbsp;&nbsp;
        <input type="button" name="cmdGrabar" value="  Ejecutar interface  "  height="20px" class="boton" onClick="Ejecutar ();">
        </TD>
    </TR>
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
<% } catch (SQLException e) {
        throw new SurException (e.getMessage());
    }  catch (Exception se) {
        throw new SurException (se.getMessage());
    } finally {
    if   ( rs != null)  { rs.close ();}
    if  (proc != null)  { proc.close ();}
    db.cerrar(dbCon);
   }
%>