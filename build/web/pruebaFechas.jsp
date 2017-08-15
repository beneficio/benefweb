<%@page contentType="text/html" errorPage="error.jsp"%>
<%@page import="com.business.beans.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.LinkedList"%>
<%@ taglib uri="tld/menu.tld" prefix="menu" %>   
<% Usuario usu = (Usuario) session.getAttribute("user"); 
int rama = (request.getParameter ("cod_rama") == null ? -1 : Integer.parseInt (request.getParameter ("cod_rama")));
int poliza = (request.getParameter ("num_poliza") == null ? -1 : Integer.parseInt (request.getParameter ("num_poliza")));
java.util.Date fecha = new Date ();

if (request.getParameter("fecha") != null && ! request.getParameter("fecha").equals ("") ) {
    fecha = Fecha.strToDate(request.getParameter("fecha"));
}

HtmlBuilder ohtml       = new HtmlBuilder();
Tablas oTabla = new Tablas ();
LinkedList lTabla = new LinkedList ();
boolean bExiste = false;
double deuda = 0;
%>

<!DOCTYPE html public "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
    <HEAD>
        <TITLE>Beneficio Web</TITLE>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css">
<script type='text/javascript' src='<%=Param.getAplicacion()%>script/x_core.js'></script>
<SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type='text/javascript'>
</script>
</head>
    
<body  leftMargin=20 topMargin=5 marginheight="0" marginwidth="0">
<menu:renderMenuFromDB  aplicacion="1" userLogon="<%= usu.getusuario()%>" />
<%
if (rama != -1) {
    Connection dbCon = db.getConnection();

    dbCon.setAutoCommit(false);
    // Procedure call.
    CallableStatement cons = dbCon.prepareCall(db.getSettingCall("PZ_EXISTE_POLIZA (?,?,?)"));
    cons.registerOutParameter(1, java.sql.Types.INTEGER);
    cons.setInt (2, rama);
    cons.setInt (3, poliza);
    cons.setString (4, usu.getusuario());
    cons.execute();
    
    if (cons.getInt (1) > 0) { bExiste = true; }

    cons.close();

    if ( bExiste ) { 
        dbCon.setAutoCommit(false);
        // Procedure call.
        CallableStatement proc = dbCon.prepareCall(db.getSettingCall("CE_CALCULAR_DEUDA_POLIZA(?,?,?)"));
        proc.registerOutParameter(1, java.sql.Types.DOUBLE);
        proc.setInt(2, rama);
        proc.setInt(3, poliza);
        proc.setDate(4, Fecha.convertFecha(fecha));

        proc.execute();

        deuda = proc.getDouble(1);
        proc.close();
    }
    db.cerrar (dbCon);
}
%>
<TABLE cellSpacing=0 cellPadding=0 width=720 align="left" border=0>
    <tr>
        <td align="center" valign="top">
            <jsp:include flush="true" page="/top.jsp"/>
        </td>
    </tr>
<% if (rama != -1 && !bExiste) {
    %>
    <tr>
        <td align="center" valign="top" style='color:red;'>
Número de póliza invalida
        </td>
    </tr>
<%  }
    %>

    <tr>
        <td >
            <form action='/benef/pruebaFechas.jsp' method="post" name="form1">
            <table border='0' width='100%'>
                <tr>
                    <td align="left"  class="text" valign="top" >Rama:&nbsp;</td>
                    <td align="left"  class="text">
                        <SELECT name="cod_rama" id="cod_rama"   class="select">
    <%              lTabla = oTabla.getRamas ();
                     out.println(ohtml.armarSelectTAG(lTabla)); 
    %>
                        </select>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                    <td align="left"  class="text" valign="top">&nbsp;&nbsp;P&oacute;liza:&nbsp;</td>
                    <td align="left"  class="text"><input name="num_poliza" id="num_poliza"  size='12' maxlength='12'  onkeypress="return Mascara('D',event);" class="inputTextNumeric">
                    Ingrese el número completo sin la barra  
                    </td>
                </tr>
                <tr>
                    <td align="left"  class="text">Fecha de consulta :&nbsp;</td>
                    <td align="left"  class="text"><input name="fecha" id="fecha" size="10" onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value="<%= Fecha.getFechaActual()%>">&nbsp;(dd/mm/yyyy).
                    </td>
                </tr>
                <tr>
                    <td align="left"  class="text">Deuda:&nbsp;</td>
                    <td align="left"  class="text"><input name="deuda" id="deuda" size="10"  value="<%= deuda %>">
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan='2'>
                        <input type="button" name="enviar" value=" Consultar " height="20px" class="boton" onclick="document.form1.submit();">
                    </td>
                </tr>
            </table>
            </form>
        </td>
    </tr>
    <TR>
        <TD valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
    </tr>
  </table>
</body>
<script>
     CloseEspere();
</script>
