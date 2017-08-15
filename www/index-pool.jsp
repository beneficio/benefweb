<%@page contentType="text/html" errorPage="error.jsp"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.DbBean"%>
<%@page import="java.sql.*"%>
<%@ taglib uri="tld/menu.tld" prefix="menu" %>   
<% Usuario usu = (Usuario) session.getAttribute("user"); 
DbBean db = new DbBean ();
Connection dbCon = db.getConnection();
dbCon.setAutoCommit(false);
// Procedure call.
CallableStatement proc = dbCon.prepareCall(db.getSettingCall("GET_ALL_NOVEDADES()"));
proc.registerOutParameter(1, java.sql.Types.OTHER);
proc.execute();
ResultSet rs = (ResultSet) proc.getObject(1);
%>

<!DOCTYPE html public "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
    <HEAD>
        <TITLE>Untitled</TITLE>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css">
<script type='text/javascript' src='<%=Param.getAplicacion()%>script/x_core.js'></script>
<script type='text/javascript'>
</script>
</head>
    
<body  leftMargin=0 topMargin=5 marginheight="0" marginwidth="0">
<menu:renderMenuFromDB  aplicacion="1" userLogon="<%= usu.getusuario()%>" />
<TABLE cellSpacing=0 cellPadding=0 width=720 align=center border=0>
    <tr>
        <td align="center" valign="top">
            <jsp:include flush="true" page="/top.jsp"/>
        </td>
    </tr>
    <tr>
        <td valign="top" align="center">
<!-- comienzo del body-->
            <TABLE cellSpacing="0" cellPadding="0" width="720" border="0">
                <TR>
                    <TD width='335' align="left" valign="top">
                        <table align="left" width='100%' border="0" cellspacing="3" cellpadding="0" style='margin-top:10;margin-right:10;' >
                            <TR>
                                <TD width='100%' height='30' valign="top"><span  class="textonegro33"><B>Bienvenido&nbsp;</span><span  class="textorojo"><a  href="<%=Param.getAplicacion()%>servlet/setAccess?opcion=getUsuario&numSecuUsu=<%= usu.getiNumSecuUsu()%>"><%= usu.getsDesPersona()%></a></B></span>
                                </TD>
                             </TR>
                            <TR>
                                <TD width='100%' class="textonegro33"><B>&nbsp;NOVEDADES</B>
                                </TD>
                             </TR>
<%          if (rs != null) {    
                    while (rs.next ()) { 
%>
                             <TR>
                                <TD width="100%">
                                    <table width='100%' border='0' >
                                        <tr>
                                            <td width='60' nowrap class="textogris" valign="top"><%=Fecha.showFechaForm(rs.getDate("FECHA"))%>&nbsp;|&nbsp;</td>
                                            <td width='100%' >
                                            <A class="link" target='_blank'  href='<%= Param.getParam("pathNovedades")%><%=(rs.getString("LINK")==null?"#":rs.getString("LINK"))%>'>
                                            <IMG src='<%= Param.getAplicacion()%>images/<%= rs.getString ("TIPO_DOC")%>.gif' border='0' align="left">
                                            <b><%=rs.getString("TITULO")%></b>&nbsp;</A>  
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan='2'><span  class="textogris"><%=rs.getString("MENSAJE")%></span></td>
                                        </tr>			
                                    </table>          
                                </TD>
                          </TR>
                          <TR>
                            <td  nowrap style="border-top-style: dotted; border-top-color: Gray; border-top-width: 1;">
                                &nbsp;
                            </td>
                          </TR>
<%                  } 
                rs.close();
            }
 proc.close ();
%>
   <TR>
        <TD height='1'><HR width="100%" color="#0468cd" noShade>
        </TD>
    </TR>
<%  
CallableStatement proc2 = dbCon.prepareCall(db.getSettingCall("GET_ALL_MANUALES()"));
proc2.registerOutParameter(1, java.sql.Types.OTHER);
proc2.execute();
ResultSet rsM = (ResultSet) proc2.getObject(1);
    %>
  <TR>
    <TD width='100%'class="textonegro33"><B>&nbsp;MANUALES Y FORMULARIOS</B>
    </TD>
  </TR>
<% if ( rsM != null ) {
    while (rsM.next ()) { %>
  <TR>
    <td>
    	<A class="link" target='_blank' href='<%= Param.getParam("pathManuales")%><%=rsM.getString("LINK")%>'>
	<IMG src='<%= Param.getAplicacion()%>images/<%= rsM.getString ("TIPO_DOC")%>.gif' border='0' align="left">
	<b><%=rsM.getString("TITULO")%></b>&nbsp;
		</A>  
	</td>
  </tr>
  <tr>
	<td><span  class="textogris"><%=rsM.getString("MENSAJE")%></span></td>
  </tr>			
  <TR>
    <td nowrap style="border-top-style: dotted; border-top-color: Gray; border-top-width: 1;">
	&nbsp;
    </td>
  </TR>
<%  }
    rsM.close ();
    %>
</TABLE>
<%  }
    proc2.close();
    db.cerrar();
   
%>
                    </td>
                    <td width='160' valign="top" align="center">
                        <table align="center" width='160px' style='margin-top:15;margin-left:15;' border="0" cellspacing="2" cellpadding="0" >
                            <tr>
                                <td  valign="top" height='140'>
                                    <div id=cg3>
                                    <div class="c1a">&nbsp;</div>
                                    <div class="c1b"><IMG border='0' align="left" vspace='2' src='/benef/images/certificado.gif' >
                                    <span class="textoazulbold"  >Certificados de Cobertura:&nbsp;</span>
                                    <span class="textogris">&nbsp;Obtenga desde <A href='/benef/certificado/formCertificado.jsp' >aqui</a> su Certificado de Cobertura de Póliza en forma On Line.<br> 
                                    También podrá solicitar el envío de Certificados de Cobertura de Propuestas.<br></span>
                                    </div>
                                    <div class="c1c">&nbsp;</div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td  valign="top" height='140'>
                                    <div id=cg3>
                                    <div class="c1a">&nbsp;</div>
                                    <div class="c1b"><IMG border='0' align="left" vspace='2' src='/benef/images/deudores.gif' >
                                    <span class="textoazulbold"  >Deudores por Premio:&nbsp;</span>
                                    <span class="textogris">&nbsp;Haciendo click <A href='/benef/deudores/formDeudores.jsp' >aqui</a> usted obtendrá el Deudores por Premio de 
                                    sus clientes. En el detallado podrá ver todos los pagos realizados.<br><br></span>
                                    </div>
                                    <div class="c1c">&nbsp;</div>
                                    </div>
                                </td>
                            </tr>

                        </table>
                    </td>
                    <TD width=213 align="right" valign="top"><!-- ImageReady Slices (home.psd) -->
                        <DIV align=right>
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
        <TD colSpan=2><A  href="http://www.prouns.com.ar/Lau/texto.html#"><IMG 
    height=38 alt="" src="/benef/images/botonera_25.gif" 
    width=92 border=0></A></TD>
    <TD><IMG height=38 alt="" 
    src="/benef/images/botonera_26.gif" width=73></TD></TR>
    <TR>
    <TD colSpan=3><IMG height=8 alt="" 
    src="/benef/images/botonera_27.gif" width=165></TD></TR>
    <TR>
    <TD><IMG height=1 alt="" src="/benef/images/spacer.gif" 
    width=8></TD>
    <TD><IMG height=1 alt="" src="/benef/images/spacer.gif" 
    width=9></TD>
    <TD><IMG height=1 alt="" src="/benef/images/spacer.gif" 
    width=83></TD>
    <TD><IMG height=1 alt="" src="/benef/images/spacer.gif" 
    width=73></TD>
    <TD><IMG height=1 alt="" src="/benef/images/spacer.gif" 
    width=19></TD></TR></TABLE><!-- End ImageReady Slices -->

        </DIV></TD></TR></TABLE></TD></TR></TABLE>
        </td>
    </tr>
        </td>
    </tr>
    <TR>
        <TD valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
    </tr>
</body>
<script>
     CloseEspere();
</script>
