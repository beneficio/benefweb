<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.sql.*"%>
<%@ taglib uri="tld/menu.tld" prefix="menu" %>   
<% Usuario usu = (Usuario) session.getAttribute("user"); 
   String pathNovedades = "/benef/files/novedades/";
   String pathManuales  = "/benef/files/manuales/";
   session.setAttribute("Diccionario", null);
   session.setAttribute("Diccionario", new Diccionario ());
   String sAlerta = (request.getParameter ("alerta") == null ? "N" : request.getParameter ("alerta"));
%>

<!DOCTYPE html public "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
    <HEAD>
        <TITLE>Beneficio Web</TITLE>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<script type='text/javascript' src='<%=Param.getAplicacion()%>script/x_core.js'></script>
<script type='text/javascript' src='<%=Param.getAplicacion()%>script/popUp.js'></script>
<script type='text/javascript' language="javsacript">
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
<%
Connection dbCon = null;
CallableStatement proc1 = null;
CallableStatement proc  = null;
ResultSet rs            = null;
ResultSet rsM           = null; 
CallableStatement proc2 = null;

try {
    dbCon = db.getConnection();
    dbCon.setAutoCommit(false);
    // Procedure call.
    proc1 = dbCon.prepareCall(db.getSettingCall("INT_ULTIMA_INTERFASE()"));
    proc1.registerOutParameter(1, java.sql.Types.VARCHAR);
    proc1.execute();
   String sFecha = proc1.getString(1);
   proc1.close();

    proc = dbCon.prepareCall(db.getSettingCall("GET_ALL_NOVEDADES(?)"));
    proc.registerOutParameter(1, java.sql.Types.OTHER);
    proc.setInt (2, usu.getiCodTipoUsuario());
    proc.execute();
    rs = (ResultSet) proc.getObject(1);
%>
<TABLE cellSpacing=0 cellPadding=0 width="740px" align="LEFT" border="0">
    <tr>
        <td align="center" valign="top">
            <jsp:include flush="true" page="/top.jsp"/>
        </td>
    </tr>
    <TR>
        <TD width='100%' height='30' valign="middle">
        <span  class="textonegro33"><B>Bienvenido&nbsp;</span><span  class="textorojo">
            <a  href="<%=Param.getAplicacion()%>servlet/setAccess?opcion=getUsuario&usuario=<%= usu.getusuario()%>"><%= usu.getsDesPersona()%></a>
.Ultima actualización de pólizas y cobranza:&nbsp;<%= sFecha %></B></span>
        </TD>
    </TR>
    <tr>
        <td valign="top" align="center">
<!-- comienzo del body-->
            <TABLE cellSpacing="0" cellPadding="0" width="720" border="0">
                <TR>
                    <TD  align="left" valign="top"><!-- ImageReady Slices (home.psd) -->
                        <DIV align="left">
<TABLE cellSpacing=0 cellPadding=0 width=192 border=0 style='margin-top:15;'>
    <TR>
        <TD colSpan=5><IMG height=23 alt="" src="/benef/images/botonera_01.gif" width=192></TD>
    </TR>
    <TR>
        <TD colSpan=2 rowSpan=19><IMG height=379 alt="" src="/benef/images/botonera_02.gif" width=17></TD>
        <TD background="/benef/images/botonera_20.gif" colSpan=2><a href="/benef/institucional.html#Prod" ><IMG height=24 border='0'
    src="/benef/images/botonera_03.gif" width=156></a></TD>
        <TD rowSpan=23  ><IMG height=425 alt="" src="/benef/images/botonera_04.gif" width=19></TD>
    </TR>
    <TR>
        <TD background="/benef/images/botonera_20.gif" colSpan=2><IMG height=24 alt="" 
    src="/benef/images/botonera_05.gif" width=156></TD>
    </TR>
    <TR>
        <TD background="/benef/images/botonera_20.gif" colSpan=2>&nbsp;&nbsp;&nbsp;&nbsp;<FONT 
    face="Arial, Helvetica, sans-serif"><A class=textoazulbold 
    href="/benef/institucional.html#AccPers">&nbsp;&nbsp;Accidentes Personales</A></FONT>
        </TD>
    </TR>
    <TR>
        <TD background="/benef/images/botonera_20.gif" 
    colSpan=2><IMG height=7 alt="" src="/benef/images/botonera_07.gif" width=156>
        </TD>
    </TR>
    <TR>
        <TD background="/benef/images/botonera_20.gif" colSpan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<FONT 
    face="Arial, Helvetica, sans-serif"><STRONG><A class=textoazulbold 
    href="/benef/institucional.html#AltaComp">Alta Complejidad</A></STRONG></FONT> 
        </TD>
    </TR>
    <TR> 
        <TD background="/benef/images/botonera_20.gif" colSpan=2><IMG height=6 alt="" 
    src="/benef/images/botonera_09.gif" width=156>
        </TD>
    </TR>
    <TR>
        <TD background="/benef/images/botonera_20.gif" colSpan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <A class=textoazulbold href="/benef/institucional.html#Deudores">Deudores</A>
        </TD>
    </TR>
    <TR>
        <TD background="/benef/images/botonera_20.gif" colSpan=2><IMG height=6 alt="" 
    src="/benef/images/botonera_11.gif" width=156>
        </TD>
    </TR>
    <TR>
        <TD background="/benef/images/botonera_20.gif" 
    colSpan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A class=textoazulbold 
    href="/benef/institucional.html#Inter">Intervenciones</A> 
        </TD>
    </TR>
    <TR>
        <TD background="/benef/images/botonera_20.gif" 
    colSpan=2><IMG height=5 alt="" src="/benef/images/botonera_13.gif" width=156>
        </TD>
    </TR>
    <TR>
        <TD background="/benef/images/botonera_20.gif" 
    colSpan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A 
    class=textoazulbold href="/benef/institucional.html#VidaOblig">Vida Obligatorio</A> 
        </TD>
    </TR>
    <TR>
        <TD background="/benef/images/botonera_20.gif" colSpan=2><IMG height=7 alt="" 
    src="/benef/images/botonera_15.gif" width=156>
        </TD>
    </TR>
    <TR>
        <TD background="/benef/images/botonera_20.gif" colSpan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A 
    class=textoazulbold href="/benef/institucional.html#VidaColec">Vida Colectivo</A>
        </TD>
    </TR>
    <TR>
        <TD background="/benef/images/botonera_20.gif" colSpan=2><IMG height=7 alt="" 
    src="/benef/images/botonera_15.gif" width=156>
        </TD>
    </TR>
    <TR>
        <TD background="/benef/images/botonera_20.gif" colSpan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A 
    class=textoazulbold href="/benef/institucional.html#VidaInd">Vida Individual</A>
        </TD>
    </TR>
    <TR>
        <TD background="/benef/images/botonera_20.gif" colSpan=2><IMG height=4 alt="" 
    src="/benef/images/botonera_17.gif" width=156>
        </TD>
    </TR>
    <TR>
        <TD background="/benef/images/botonera_20.gif" colSpan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A 
    class=textoazulbold href="/benef/institucional.html#Sepelio">Sepelio</A> 
        </TD>
    </TR>
    <TR>
        <TD colSpan=2><IMG height=2 alt="" src="/benef/images/botonera_22.gif" width=156></TD>
    </TR>
    <TR>
        <TD background="/benef/images/botonera_20.gif" colSpan=2><IMG height=34 alt="" 
    src="/benef/images/botonera_23.gif" width=156>
        </TD>
    </TR>
    <TR>
        <TD rowSpan=2><IMG height=46 alt="" src="/benef/images/botonera_24.gif" width=8></TD>
        <TD colSpan=2><A  href="http://www.latinamerica.adobe.com/products/acrobat/readstep2_allversions.html" target="_blank"><IMG 
    height=38 alt="" src="/benef/images/botonera_25.gif" width=92 border=0></A>
        </TD>
        <TD><IMG height=38 alt="" src="/benef/images/botonera_26.gif" width=73></TD>
    </TR>
    <TR>
        <TD colSpan=3><IMG height=8 alt="" src="/benef/images/botonera_27.gif" width=165></TD>
    </TR>
    <TR>
        <TD><IMG height=1 alt="" src="/benef/images/spacer.gif" width=1></TD>
        <TD><IMG height=1 alt="" src="/benef/images/spacer.gif" width=9></TD>
        <TD><IMG height=1 alt="" src="/benef/images/spacer.gif" width=83></TD>
        <TD><IMG height=1 alt="" src="/benef/images/spacer.gif" width=73></TD>
        <TD><IMG height=1 alt="" src="/benef/images/spacer.gif" width=1></TD>
    </TR>
</TABLE>
                        </DIV>
                    </TD> <!-- fin de productos -->
                    <TD width='100%' align="center" valign="top">
                        <TABLE align="center" width='100%' border="0" cellspacing="3" cellpadding="0" style='margin-top:10;margin-right:10;' >
<%          if (rs != null) {  
    %>
                            <TR>
                                <TD width='100%' class="textonegro33"><B>&nbsp;NOVEDADES</B></TD>
                             </TR>
<%
                    while (rs.next ()) { 
%>
                             <TR>
                                <TD width="100%">
                                    <table width='100%' border='0' >
                                        <tr>
                                            <td width='60' nowrap class="textogris" valign="top"><%=Fecha.showFechaForm(rs.getDate("FECHA"))%>&nbsp;|&nbsp;</td>
                                            <td width='100%' style='color:red'>
<%                              if ( rs.getString("LINK") != null && ! rs.getString ("LINK").equals ("") ) {
    %>
                                            <A class="link" target='_blank'  href='<%= pathNovedades %><%=(rs.getString("LINK")==null?"#":rs.getString("LINK"))%>'>
                                            <IMG src='<%= Param.getAplicacion()%>images/<%= rs.getString ("TIPO_DOC")%>.gif' border='0' align="left">
                                            <b><%=rs.getString("TITULO")%></b>&nbsp;</A>  
<%                              } else {
    %>
                                            <b><%=rs.getString("TITULO")%></b>&nbsp;
<%                              }
    %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan='2'><span   class='textonegro'><%=rs.getString("MENSAJE")%></span></td>
                                        </tr>			
                                    </table>          
                               </TD>
                          </TR>
                          <TR>
                            <td  nowrap style="border-top-style: dotted; border-top-color: Gray; border-top-width: 1;">&nbsp;</td>
                          </TR>
<%                  } 
                rs.close();
            } else {
%>
                            <TR>
                                <TD width='100%' class="textonegro33"><B>&nbsp;&nbsp;&nbsp;No existen novedades</B></TD>
                            </TR>
<%                  }
 proc.close ();
%>
                            <TR>
                                <TD height='1'><HR width="100%" color="#0468cd" noShade></TD>
                            </TR>
<%  
proc2 =  dbCon.prepareCall(db.getSettingCall("GET_ALL_MANUALES(?)"));
proc2.registerOutParameter(1, java.sql.Types.OTHER);
proc2.setInt (2, usu.getiCodTipoUsuario());
proc2.execute();
rsM =  (ResultSet) proc2.getObject(1);
    %>
                            <TR>
                                <TD width='100%'class="textonegro33"><B>&nbsp;MANUALES Y FORMULARIOS</B></TD>
                            </TR>
<% if ( rsM != null ) {
        while (rsM.next ()) { %>
                            <TR>
                                <td style='color:red'>
<%           if ( rsM.getString("LINK") != null && ! rsM.getString ("LINK").equals ("") )  {
    %>
                                <A class="link" target='_blank' href='<%= pathManuales %><%=rsM.getString("LINK")%>'>
                                    <IMG src='<%= Param.getAplicacion()%>images/<%= rsM.getString ("TIPO_DOC")%>.gif' border='0' align="left">
                                    <b><%=rsM.getString("TITULO")%></b>&nbsp;
                                </A>
<%          } else {
    %>
                                <b><%=rsM.getString("TITULO")%></b>&nbsp;
<%          }
    %>
                                </td>
                            </TR>
                            <tr>
                                <td><span  class='textonegro'><%=rsM.getString("MENSAJE")%></span></td>
                            </tr>
                            <TR>
                                <td nowrap style="border-top-style: dotted; border-top-color: Gray; border-top-width: 1;">&nbsp;</td>
                            </TR>
<%      }
    rsM.close ();
    %>
                        </TABLE>
<%  }
    proc2.close();
%>
                    </TD>
                    <%--
                    <td width='160' valign="top" align="center">
                        <table align="center" width='160px' style='margin-top:15;margin-left:10;' border="0" cellspacing="2" cellpadding="0" >
                            <tr>
                                <td  valign="top" height='140'>
                                    <div id=cg3>
                                    <div class="c1a">&nbsp;</div>
                                    <div class="c1b">
                                    <span class="textonegro33" ><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ACCESOS DIRECTOS</b></span>
                                    <hr>
                                    <IMG border='0' align="left" vspace='2' src='<%= Param.getAplicacion()%>images/certificado.gif' >
                                    <span class="textoazulbold"  >Certificados de Propuestas:&nbsp;</span>
                                    <span class="textogris">&nbsp;A partir de ahora podrá emitir su certificado de propuestas vía web desde&nbsp;
                                    <A href='<%= Param.getAplicacion()%>certificado/propuesta/formAllCertificadoProp.jsp' >aqui</a><br></span>
                                    <hr>
                                    <IMG border='0' align="left" vspace='2' src='<%= Param.getAplicacion()%>images/mailReport.gif' width='46' height='46' >
                                    <span class="textoazulbold"  >Info vía mail:&nbsp;</span>
                                    <span class="textogris">Obtenga desde <A href='<%= Param.getAplicacion()%>consulta/formMailReport.jsp' >aqui</a> copias de pólizas, pre - liquidaci&oacute;n y su cuenta corriente v&iacute;a mail<br></span>
                                    <hr>

<%                              if (usu.getiCodTipoUsuario() != 2) {
    %>
                                    <IMG border='0' align="left" vspace='2' src='<%= Param.getAplicacion()%>images/cotizador.jpg' width='45' height='42' >
                                    <span class="textoazulbold"  >Cotizador Accidentes Personales:&nbsp;</span>
                                    <span class="textogris">Cotice desde <A href='<%= Param.getAplicacion()%>cotizador/10/formCotizadorAp.jsp' >aqui</a> su póliza de Accidentes Personales.<br> 
                                    Ahora también va a poder generar la solicitud de la propuesta via web.<br></span>
                                    <hr>
<%                              }
    %>

                                    <IMG border='0' align="left" vspace='2' src='<%= Param.getAplicacion()%>images/consultasPol.jpg' >
                                    <span class="textoazulbold">Administrador de Cartera:&nbsp;</span>
                                    <span class="textogris">Consulte desde <A href='<%= Param.getAplicacion()%>consulta/filtrarPolizas.jsp' >aqui</a> su cartera en Beneficio S.A.<br> 
                                    Adem&aacute;s podr&aacute; obtener copias de p&oacute;lizas, consulta de endosos, cobranza, siniestros.<br></span>
                                    <hr>
                                    <IMG border='0' align="left" vspace='2' src='<%= Param.getAplicacion()%>images/deudores.gif' >
                                    <span class="textoazulbold"  >Deudores por Premio:&nbsp;</span>
                                    <span class="textogris">&nbsp;Haciendo click <A href='<%= Param.getAplicacion()%>deudores/formDeudores.jsp' >aqui</a> usted obtendrá el Deudores por Premio de 
                                    sus clientes. En el detallado podrá ver todos los pagos realizados.<br><br></span>
                                    </div>
                                    <div class="c1c">&nbsp;</div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                    --%>
                </TR>
            </TABLE>
        </td>
    </tr>
<!--</TABLE> -->
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
  // Banner();
</script>
<% } catch (SQLException e) {
        throw new SurException (e.getMessage());
    }  catch (Exception se) {
        throw new SurException (se.getMessage());
    } finally {
    if   ( rs != null)  { rs.close ();}
    if  ( rsM != null)  { rsM.close ();}
    if  (proc != null)  { proc.close ();}
    if (proc1 != null)  { proc1.close ();}
    if (proc2 != null)  { proc2.close ();}
    db.cerrar(dbCon);     
   }
%>