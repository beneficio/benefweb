<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.beans.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Hashtable"%>
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>   
<%
Usuario usu = (Usuario) session.getAttribute("user"); 

// variable utilizada para grabar. La primera vez siempre es null
java.util.Date fechaTasaMensual = new Date ();
java.util.Date fecha     = new Date ();

int rama = 10;    
int subRama = 2;

// valores maximos. Pueden ser variables porque se pueden setear dinamicamente.
int maxCategoria = 6;
int maxAmbito = 3;
int maxCobertura = 3;
int maxTramos = 0;

// hashtable utilizada para armar la tabla
Hashtable tasas = null;
LinkedList lTramos = new LinkedList ();
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
<script type='text/javascript' src='<%=Param.getAplicacion()%>script/x_core.js'></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type='text/javascript'>
function Salir () {
       window.location.replace("<%= Param.getAplicacion()%>index.jsp");
}

</script>
</head>
<body>
<% 
CallableStatement cons = null;
CallableStatement cons1  = null;
CallableStatement cons2  = null;
Connection dbCon = null;
    try {
    dbCon = db.getConnection();
    dbCon.setAutoCommit(false);
    // Procedure call.
    cons = dbCon.prepareCall(db.getSettingCall("COT_GET_ALL_TASA_MENSUAL(?,?) "));
    cons.registerOutParameter(1, java.sql.Types.OTHER);
    cons.setInt (2, rama);
    cons.setInt (3, subRama);

    cons.execute();

    ResultSet rs = (ResultSet) cons.getObject(1);
    if (rs != null) {
        tasas = new Hashtable ();
        while (rs.next()) {
            TasaMensual oTasa = new TasaMensual ();
            oTasa.setcategoria  (rs.getInt("CATEGORIA"));
            oTasa.setcodRama    (rs.getInt("COD_RAMA"));
            oTasa.setcodSubRama (rs.getInt("COD_SUB_RAMA"));
            oTasa.setcodAmbito  (rs.getInt("COD_AMBITO"));
            oTasa.setcodCob     (rs.getInt("COD_COBERTURA"));
            oTasa.settasa       (rs.getDouble ("TASA"));
            oTasa.setfechaDesde (rs.getDate("FECHA_DESDE"));

            fechaTasaMensual = rs.getDate("FECHA_DESDE");
            tasas.put (rs.getString ("CLAVE"), oTasa); 
        }
        rs.close();
    }
    cons.close();
%>
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
        <td >
            <table border='0' width='100%'>
                <tr>
                    <td height='20' valign="middle" class='titulo' align="center">TASAS MENSUALES</td>
                </tr>
                <tr>
                    <td height='20' valign="middle" class='subtitulo'>Fecha de &uacute;ltima actualizaci&oacute;n&nbsp;<%= Fecha.showFechaForm(fechaTasaMensual) %></td>
                </tr>
                <tr>
                    <td align="left"  class="text" valign="top" >
                        <table  border="1" cellspacing="0" cellpadding="2" align="center" class="TablasBody">
                            <tr>
                                <th width='100'>Categ/Ambito</th>
                                <th width='60'>Muerte</th>
                                <th width='60'>Invalidez</th>
                                <th width='60'>Asistencia</th>
                            </tr>
<%                      for (int i= 1; i <= maxCategoria; i++) {
                            for (int j=1; j <= maxAmbito;j++) {
    %>
                            <tr>
                                <td>C:&nbsp;<%= i%>&nbsp;-&nbsp;A:<%= j%></td>
<%                              for (int k=1; k <= maxCobertura; k++) {
                                    double tasa = ((TasaMensual) tasas.get(String.valueOf (i) + "|" + String.valueOf (j)+ "|" + String.valueOf (k) ) == null ? 0 : 
                                                   ((TasaMensual) tasas.get(String.valueOf (i) + "|" + String.valueOf (j)+ "|" + String.valueOf (k) )).gettasa());
    %>
                                    <td align="right"><%= Dbl.DbltoStr(tasa,3) %></td>

<%                              }
    %>
                            </tr>
<%                          }
                        }
    %>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td><hr></td></tr>
<% 
   // Procedure call.
    cons1 = dbCon.prepareCall(db.getSettingCall("COT_GET_ALL_CABECERA_TRAMOS ()"));
    cons1.registerOutParameter(1, java.sql.Types.OTHER);
    cons1.execute();
    ResultSet rs1 = (ResultSet) cons1.getObject(1);
    if (rs1 != null) {
        while (rs1.next()) {
            Tramo oTramo = new Tramo ();
            oTramo.setnroTramo(rs1.getInt ("NRO_TRAMO"));
            oTramo.setmontoDesde(rs1.getInt ("MONTO_DESDE"));
            oTramo.setmontoHasta(rs1.getInt ("MONTO_HASTA"));
            lTramos.add (oTramo);
            maxTramos += 1;
        }
        rs1.close();
    }
    cons1.close();

    cons2 = dbCon.prepareCall(db.getSettingCall("COT_GET_ALL_TRAMOS () "));
    cons2.registerOutParameter(1, java.sql.Types.OTHER);
    cons2.execute();
    
    tasas = null;
    ResultSet rs3 = (ResultSet) cons2.getObject(1);
    if (rs3 != null) {
        tasas = new Hashtable ();
        while (rs3.next()) {
            Tramo oTramo = new Tramo ();
            oTramo.setnroTramo      (rs3.getInt ("NRO_TRAMO"));
            oTramo.setmontoDesde    (rs3.getInt ("MONTO_DESDE"));
            oTramo.setmontoHasta    (rs3.getInt ("MONTO_HASTA"));
            oTramo.setcategoria     (rs3.getInt("CATEGORIA"));
            oTramo.setcodAmbito     (rs3.getInt("COD_AMBITO"));
            oTramo.setvalor         (rs3.getDouble ("VALOR"));
            oTramo.setfechaDesde    (rs3.getDate("FECHA_DESDE"));
            fecha = rs3.getDate("FECHA_DESDE");
            tasas.put (rs3.getString ("CLAVE"), oTramo); 
        }
        rs3.close();
    }
    cons2.close();

} catch (SQLException se) {
    throw new SurException (se.getMessage());
} finally {
    try {
        if (cons  != null) { cons.close ();}
        if (cons2 != null) { cons2.close ();}
        if (cons1 != null) { cons1.close ();}
        db.cerrar (dbCon);
    } catch (SQLException se) {
        throw new SurException (se.getMessage());
    } 
} 
%>
        <tr>
        <td >
            <table border='0' width='100%'>
                <tr>
                    <td height='20' valign="middle" class='titulo' align="center">TASAS DE ASISTENCIA MEDICO FARMACEUTICA</td>
                </tr>
                <tr>
                    <td height='20' valign="middle" class='subtitulo'>Fecha de última actualización&nbsp;<%= Fecha.showFechaForm(fecha) %></td>
                </tr>
                <tr>
                    <td align="left"  class="text" valign="top" >
                        <table  border="1" cellspacing="0" cellpadding="2" align="center" class="TablasBody">
                            <tr>
                                <th >&nbsp;</th>
                                <th colspan="<%= lTramos.size() + 1 %>" align="center">Tramos</th>
                            </tr>  
                            <tr>
                                <th width='100'>Categoria&nbsp;-<br>Ambito</th>
<%                              int t=0;
                                int ultTramo = 0;
                                for (t = 0; t < maxTramos; t++) {
                                Tramo oTramo = (Tramo) lTramos.get(t);
                                ultTramo =  oTramo.getmontoHasta ();
    %>
                                <th align="center" >&nbsp;&nbsp;
                                    <INPUT name="desde_<%= t + 1 %>" size='6' maxlength='6' value="<%= oTramo.getmontoDesde ()%>"  onkeypress="return Mascara('D',event);" class="inputTextNumeric">&nbsp;&nbsp;<br>&nbsp;&nbsp;
                                    <INPUT name="hasta_<%= t + 1 %>" size='6' maxlength='6'  value="<%= oTramo.getmontoHasta ()%>"  onkeypress="return Mascara('D',event);" class="inputTextNumeric">&nbsp;&nbsp;
                                </th>  
<%                              }
    %>
                            </tr>
<%                      for (int i= 1; i <= maxCategoria; i++) {
                            for (int j=1; j <= maxAmbito;j++) {
    %>
                            <tr>
                                <td>C:&nbsp;<%= i%>&nbsp;-&nbsp;A:<%= j%></td>
<%                              for (int k=1; k <= maxTramos; k++) {
                                    double tasa = ((Tramo) tasas.get(String.valueOf (i) + "|" + String.valueOf (j)+ "|" + String.valueOf (k) ) == null ? 0 : 
                                                    ((Tramo) tasas.get(String.valueOf (i) + "|" + String.valueOf (j)+ "|" + String.valueOf (k) )).getvalor());

    %>
                                    <td align="right"><%= Dbl.DbltoStr(tasa,3) %></td>

<%                              }
    %>
                            </tr>
<%                          }
                        }
    %>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="center">  
                        <input type="button" name="cmdSalir" value=" Salir " height="20px" class="boton" onClick="Salir();">
                    </td>
                </tr>
            </table>
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