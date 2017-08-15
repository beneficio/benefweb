<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
<%@page import="java.text.SimpleDateFormat"%>
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
CallableStatement proc3  = null;
ResultSet rs3            = null;
CallableStatement proc4  = null;
ResultSet rs4            = null;
CallableStatement proc5  = null;
ResultSet rs5            = null;
CallableStatement proc6  = null;
ResultSet rs6            = null;

String sValor     = null;
String sValorDesc = null;
String sHora  = null;
String sUser  = null;
java.util.Date dFecha = null;
String sValor2     = null;
String sValorDesc2 = null;
String sHora2  = null;
String sUser2  = null;
java.util.Date dFecha2 = null;
String sValor3     = null;
String sValorDesc3 = null;
String sHora3  = null;
String sUser3  = null;
java.util.Date dFecha3 = null;
String sValor4     = null;
String sValorDesc4 = null;
String sHora4  = null;
String sUser4  = null;
java.util.Date dFecha4 = null;
String sValor5     = null;
String sValorDesc5 = null;
String sHora5  = null;
String sUser5  = null;
java.util.Date dFecha5 = null;

String sValor6     = null;
String sValorDesc6 = null;
String sHora6  = null;
String sUser6  = null;
java.util.Date dFecha6 = null;

try {
    dbCon = db.getConnection();
    dbCon.setAutoCommit(false);
    proc = dbCon.prepareCall(db.getSettingCall("PARAM_GET_PARAMETRO (?)"));
    proc.registerOutParameter(1, java.sql.Types.OTHER);
    proc.setString (2, "ESTADO_INTERFACE");
    proc.execute();
    rs = (ResultSet) proc.getObject(1);
      while (rs.next ()) {
          if (rs.getString ("VALOR") != null && rs.getString ("VALOR").equals("S")) {
              sValorDesc = "HABILITADA";
           } else {
              sValorDesc = "BLOQUEADA";
           }
          sValor = rs.getString ("VALOR");
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
          if (rs2.getString ("VALOR") != null && rs2.getString ("VALOR").equals("S")) {
              sValorDesc2 = "HABILITADA";
           } else {
              sValorDesc2 = "BLOQUEADA";
           }
          sValor2 = rs2.getString ("VALOR");
          sHora2  =  rs2.getString ("HORA_TRABAJO");
          dFecha2 =  rs2.getDate   ("FECHA_TRABAJO");
          sUser2  = rs2.getString ("COD_USR");
      }
     rs2.close ();
     proc2.close();

    proc3 = dbCon.prepareCall(db.getSettingCall("PARAM_GET_PARAMETRO (?)"));
    proc3.registerOutParameter(1, java.sql.Types.OTHER);
    proc3.setString (2, "ESTADO_INTERFACE_ONLINE");
    proc3.execute();
    rs3 = (ResultSet) proc3.getObject(1);
      while (rs3.next ()) {
          if (rs3.getString ("VALOR") != null && rs3.getString ("VALOR").equals("S")) {
              sValorDesc3 = "HABILITADA";
           } else {
              sValorDesc3 = "BLOQUEADA";
           }
          sValor3 = rs3.getString ("VALOR");
          sHora3  =  rs3.getString ("HORA_TRABAJO");
          dFecha3 =  rs3.getDate   ("FECHA_TRABAJO");
          sUser3  = rs3.getString ("COD_USR");
      }
     rs3.close ();
     proc3.close();

    proc4 = dbCon.prepareCall(db.getSettingCall("PARAM_GET_PARAMETRO (?)"));
    proc4.registerOutParameter(1, java.sql.Types.OTHER);
    proc4.setString (2, "ESTADO_PRELIQ_ONLINE");
    proc4.execute();
    rs4 = (ResultSet) proc4.getObject(1);
      while (rs4.next ()) {
          if ( rs4.getString ("VALOR") != null && rs4.getString ("VALOR").equals("S")) {
              sValorDesc4 = "HABILITADA";
           } else {
              sValorDesc4 = "BLOQUEADA";
           }
          sValor4 = rs4.getString ("VALOR");
          sHora4  =  rs4.getString ("HORA_TRABAJO");
          dFecha4 =  rs4.getDate   ("FECHA_TRABAJO");
          sUser4  = rs4.getString ("COD_USR");
      }
     rs4.close ();
     proc4.close();

    proc5 = dbCon.prepareCall(db.getSettingCall("PARAM_GET_PARAMETRO (?)"));
    proc5.registerOutParameter(1, java.sql.Types.OTHER);
    proc5.setString (2, "ESTADO_INFO_VIA_MAIL");
    proc5.execute();
    rs5 = (ResultSet) proc5.getObject(1);
      while (rs5.next ()) {
          if ( rs5.getString ("VALOR") != null && rs5.getString ("VALOR").equals("S")) {
              sValorDesc5 = "HABILITADA";
           } else {
              sValorDesc5 = "BLOQUEADA";
           }
          sValor5 = rs5.getString ("VALOR");
          sHora5  =  rs5.getString ("HORA_TRABAJO");
          dFecha5 =  rs5.getDate   ("FECHA_TRABAJO");
          sUser5  = rs5.getString ("COD_USR");
      }
     rs5.close ();
     proc5.close();

// VERIFICAR SI LA WEB ESTA BLOQUEADA PARA PRODUCTORES.
     String  _file ="/opt/tomcat/webapps/benef/propiedades/web_ctl.bloq";//"./www/propiedades/config.xml";
     boolean acceso_ok = true;
     String lineProd = "";
     String sFechaProd = "";
     try {
        File bloque_prod =new File(_file);
        if( bloque_prod.exists()){
            BufferedReader br = new BufferedReader(new FileReader(bloque_prod));
            lineProd = br.readLine();

            SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");

            sFechaProd = sdf.format(bloque_prod.lastModified());
            br.close();

           acceso_ok = false;
        }

      }  catch (Exception e) {
            throw new SurException (e.getMessage());
      }

    proc6 = dbCon.prepareCall(db.getSettingCall("PARAM_GET_PARAMETRO (?)")); 
    proc6.registerOutParameter(1, java.sql.Types.OTHER); 
    proc6.setString (2, "MAX_CIERRE_CTACTE_PROD"); 
    proc6.execute(); 
    rs6 = (ResultSet) proc6.getObject(1); 
    while (rs6.next ()) { 
          sValor6 = rs6.getString ("VALOR"); 
          sHora6  =  rs6.getString ("HORA_TRABAJO"); 
          dFecha6 =  rs6.getDate   ("FECHA_TRABAJO"); 
          sUser6  = rs6.getString ("COD_USR");
    }
    rs6.close ();
    proc6.close();

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
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
        if (tipoEmision == 'ESTADO_INTERFACE' ||
            tipoEmision == 'ESTADO_INTERFACE_BATCH' ||
            tipoEmision == 'ESTADO_INTERFACE_ONLINE' ) {
            document.form1.action ="<%= Param.getAplicacion()%>usuarios/updateEstadoInterface.jsp"
            document.form1.estado.value = estado;
            document.form1.tipo_emision.value = tipoEmision;
            document.form1.submit();
            return true;
        }

        if (tipoEmision == 'ESTADO_INFO_VIA_MAIL' ||
            tipoEmision == 'ESTADO_PRELIQ_ONLINE' ) {
            document.form1.opcion.value = "cambiarEstado";
            document.form1.estado.value = estado;
            document.form1.tipo_emision.value = tipoEmision;
            document.form1.submit();
            return true;
        }

        if (tipoEmision === 'ACCESO_PRODUCTOR' ) {
            document.form1.action ="<%= Param.getAplicacion()%>usuarios/updateAccesoProductor.jsp"
            document.form1.estado.value = estado;
            document.form1.submit();
            return true;
        }
        if (tipoEmision === 'CTACTE_PRODUCTOR' ) {
            document.form1.opcion.value = "desbloquearCtaCte";
            document.form1.submit();
            return true;
        }
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
            <form name="form1" id="form1" method="POST" action="<%= Param.getAplicacion()%>servlet/InterfaceServlet">
                <input type="hidden" name="opcion" id="opcion" value="runInterface">
                <input type="hidden" name="estado" id="estado" value="">
                <input type="hidden" name="tipo_emision" id="tipo_emision" value="">
                <TABLE width="100%" border="0" align="center" cellspacing="3" cellpadding="5"  class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                    <TR>
                        <TD height="30px" valign="middle" align="center" class='titulo' colspan='2'>PROCESAMIENTO DE INTERFACES</TD>
                    </TR>
                    <TR>
                        <TD align="left" class='subtitulo' colspan='2'>INTERFACE PERIODICA DE PROPUESTAS (cada 4'):&nbsp;
                            <img src="<%= Param.getAplicacion()%>images/<%= (sValor.equals("S") ? "ok.gif" : "nook.gif" ) %>" border="0">&nbsp;<%= sValorDesc %>&nbsp;
                            &nbsp;&nbsp;<%= Fecha.showFechaForm( dFecha ) %>&nbsp;a&nbsp;las&nbsp;<%= sHora %>&nbsp;por&nbsp;<%= sUser %>&nbsp;&nbsp;&nbsp;
                            <input type="button" name="cmdCambiar" value="<%= (sValor.equals("S") ? " BLOQUEAR " : " HABILITAR " ) %>"  height="20px" class="boton"
                                   onClick="CambiarEstado ('ESTADO_INTERFACE', '<%= (sValor.equals("S") ? "N" : "S") %>');">
                        </TD>
                    </TR>
                    <TR>
                        <TD align="left" class='text' colspan='2'>
                            Esta es la interface vieja de propuestas, solo funciona para endosos de alta y baja de asegurados. Se tiene que
                            deshabilitar cuando se ejecuta la refacturaci&oacute;n. POR LAS DUDAS INHABILITAR EN EL CIERRE
                        </TD>
                    </TR>
                    <TR>
                        <TD align="left" class='subtitulo' colspan='2'>INTERFACE PROPUESTAS BATCH:&nbsp;
                            <img src="<%= Param.getAplicacion()%>images/<%= (sValor2.equals("S") ? "ok.gif" : "nook.gif" ) %>" border="0">&nbsp;<%= sValorDesc2 %>&nbsp;
                            &nbsp;&nbsp;<%= Fecha.showFechaForm( dFecha2 ) %>&nbsp;a&nbsp;las&nbsp;<%= sHora2 %>&nbsp;por&nbsp;<%= sUser2 %>&nbsp;&nbsp;&nbsp;
                            <input type="button" name="cmdCambiar" value="<%= (sValor2.equals("S") ? " BLOQUEAR " : " HABILITAR " ) %>"  height="20px" class="boton"
                                   onClick="CambiarEstado ('ESTADO_INTERFACE_BATCH', '<%= (sValor2.equals("S") ? "N" : "S") %>');">
                        </TD>
                    </TR>
                    <TR>
                        <TD align="left" class='text' colspan='2'>
                            Esta interface  corre todos los d&iacute;as una vez a la noche (20 hs.) y emite masivamente todas las propuestas que se hayan cargado como batch.<br/>
                            Se utiliza para la renovación de VCO y ajustes masivos de Vida+Salud
                        </TD>
                    </TR>
                    <TR>
                        <TD align="left" class='subtitulo' colspan='2'>INTERFACE ON LINE DE PROPUESTAS (On line):&nbsp;
                            <img src="<%= Param.getAplicacion()%>images/<%= (sValor3.equals("S") ? "ok.gif" : "nook.gif" ) %>" border="0">&nbsp;<%= sValorDesc3 %>&nbsp;
                            &nbsp;&nbsp;<%= Fecha.showFechaForm( dFecha3 ) %>&nbsp;a&nbsp;las&nbsp;<%= sHora3 %>&nbsp;por&nbsp;<%= sUser3 %>&nbsp;&nbsp;&nbsp;
                            <input type="button" name="cmdCambiar" value="<%= (sValor3.equals("S") ? " BLOQUEAR " : " HABILITAR " ) %>"  height="20px" class="boton"
                                   onClick="CambiarEstado ('ESTADO_INTERFACE_ONLINE', '<%= (sValor3.equals("S") ? "N" : "S") %>');">
                        </TD>
                    </TR>
                    <TR>
                        <TD align="left" class='text' colspan='2'>
                            Esta es la nueva interface de propuestas. Emite propuestas nuevas y renovaciones. Emite  On line pero si por algún motivo no
                            se pudo emitir,  a los 25' la emite batch. Esta interface solo se tiene que bloquear cuando hay algún problema con el servidor de DC.<BR/>
                            INHABILITAR EN EL CIERRE
                        </TD>
                    </TR>
                    <TR>
                        <TD align="left" class='subtitulo' colspan='2'>INTERFACE DE PRELIQUIDACIONES (On line):&nbsp;
                            <img src="<%= Param.getAplicacion()%>images/<%= (sValor4.equals("S") ? "ok.gif" : "nook.gif" ) %>" border="0">&nbsp;<%= sValorDesc4 %>&nbsp;
                            &nbsp;&nbsp;<%= Fecha.showFechaForm( dFecha4 ) %>&nbsp;a&nbsp;las&nbsp;<%= sHora4 %>&nbsp;por&nbsp;<%= sUser4 %>&nbsp;&nbsp;&nbsp;
                            <input type="button" name="cmdCambiar" value="<%= (sValor4.equals("S") ? " BLOQUEAR " : " HABILITAR " ) %>"  height="20px" class="boton"
                                   onClick="CambiarEstado ('ESTADO_PRELIQ_ONLINE', '<%= (sValor4.equals("S") ? "N" : "S") %>');">
                        </TD>
                    </TR>                        
                    <TR>
                        <TD align="left" class='text' colspan='2'>
                            Esta interface se usa para generar nuevas preliquidaciones en la web cuando el productor ingresa al m&oacute;dulo y tiene emisi&oacute;n nueva.<br/>
                            Se tiene que bloquear cuando se generan en cada quincena las preliquidaciones masivas. 
                        </TD>

                    </TR>
                    <TR>
                        <TD align="left" class='subtitulo' colspan='2'>OPERACIONES DEL MENU INFO VIA MAIL:&nbsp;
                            <img src="<%= Param.getAplicacion()%>images/<%= (sValor5.equals("S") ? "ok.gif" : "nook.gif" ) %>" border="0">&nbsp;<%= sValorDesc5 %>&nbsp;
                            &nbsp;&nbsp;<%= Fecha.showFechaForm( dFecha5 ) %>&nbsp;a&nbsp;las&nbsp;<%= sHora5 %>&nbsp;por&nbsp;<%= sUser5 %>&nbsp;&nbsp;&nbsp;
                            <input type="button" name="cmdCambiar" value="<%= (sValor5.equals("S") ? " BLOQUEAR " : " HABILITAR " ) %>"  height="20px" class="boton"
                                   onClick="CambiarEstado ('ESTADO_INFO_VIA_MAIL', '<%= (sValor5.equals("S") ? "N" : "S") %>');">
                        </TD>
                    </TR>                        
                    <TR>
                        <TD align="left" class='text' colspan='2'>
                            Se refiere a la copia de pólizas, endoso, preliquidaciones, liquidaciones, comisiones a facturar y renovaciones pendientes.
                            Solo se tienen que bloquear cuando hay algún problema con DC.
                        </TD>
                    </TR>
                    <TR>
                        <TD align="left" class='subtitulo' colspan='2'>ULT. CIERRE HABILITADO A PRODUCTORES:&nbsp;
                            <span style="color:red;">&nbsp;<%= sValor6 %>&nbsp;</span>
                            - Ultima actualizacion:&nbsp;<%= Fecha.showFechaForm( dFecha6 ) %>&nbsp;a&nbsp;las&nbsp;<%= sHora6 %>&nbsp;por&nbsp;<%= sUser6 %>&nbsp;&nbsp;&nbsp;
                            <input type="button" name="cmdCambiar" height="20px" class="boton" value="Desbloquear" 
                                   onClick="CambiarEstado ('CTACTE_PRODUCTOR', '');">
                        </TD>
                    </TR>                        
                    <TR>
                        <TD align="left" class='text' colspan='2'>
                            Se refiere a la copia de pólizas, endoso, preliquidaciones, liquidaciones, comisiones a facturar y renovaciones pendientes.
                            Solo se tienen que bloquear cuando hay algún problema con DC.
                        </TD>
                    </TR>
                        
                    <TR>
                        <TD align="left" class='subtitulo' colspan='2'>ACCESO A PRODUCTORES:&nbsp;
                            <img src="<%= Param.getAplicacion()%>images/<%= (acceso_ok == true ? "ok.gif" : "nook.gif" ) %>" border="0">&nbsp;<%= (acceso_ok == true ? "HABILITADO" : "BLOQUEADO" ) %>&nbsp;
                                &nbsp;&nbsp;<%= sFechaProd %>&nbsp;&nbsp;-&nbsp;Usuario:&nbsp;<%= lineProd %>&nbsp;&nbsp;&nbsp;
                            <input type="button" name="cmdCambiar" value="<%= (acceso_ok == true ? " BLOQUEAR " : " HABILITAR " ) %>"  height="20px" class="boton"
                                   onClick="CambiarEstado ('ACCESO_PRODUCTOR', '<%= (acceso_ok == true ? "N" : "S") %>');">
                        </TD>
                    <TR>
                        <TD align="left" class='text' colspan='2'>
                            Se bloquea solo el acceso a productores a la extranet. Si el archivo /opt/tomcat/webapps/benef/propiedades/web_ctl.bloq existe
                            entonces la web esta bloqueada. Para desbloquear eliminar dicho archivo.
                        </TD>
                    </TR>
                    </TR>

<%--
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
--%>
                 </table>
            </form>
        </td>
    </tr>
   <TR>
        <TD align="center" >
        <input type="button" name="cmdSalir"  value="  Salir  "  height="20px" class="boton" onClick="Salir ();">
<%--            &nbsp;&nbsp;&nbsp;&nbsp;
        <input type="button" name="cmdGrabar" value="  Ejecutar interface  "  height="20px" class="boton" onClick="Ejecutar ();">
--%>
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