<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.sql.*"%>
<%  Usuario usu = (Usuario) session.getAttribute("user");
    int codAlerta = (request.getParameter ("codAlerta") == null ? -1 : Integer.parseInt (request.getParameter ("codAlerta")));
    Connection dbCon = null;
    CallableStatement proc  = null;
    ResultSet rs            = null;
    String sBody            = "";
    int ancho       = 0;
    int alto        = 0;

try {
    dbCon = db.getConnection();
    dbCon.setAutoCommit(false);
    proc = dbCon.prepareCall(db.getSettingCall("US_GET_ALERTA (?,?)"));
    proc.registerOutParameter(1, java.sql.Types.OTHER);
    proc.setInt(2, usu.getiCodTipoUsuario());
    proc.setInt(3, codAlerta);
    proc.execute();
    rs = (ResultSet) proc.getObject(1);
      while (rs.next ()) {
          sBody =  rs.getString ("BODY");
          alto  = rs.getInt ("ALTO");
          ancho = rs.getInt("ANCHO");
          }
     rs.close ();
     proc.close();
%>
<body>
<HTML>
<HEAD>
<TITLE>Beneficio Web - Alerta</TITLE>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<script language="JavaScript" type="text/javascript">
<!--
//window.moveTo(0,0);
window.resizeTo(<%= ancho%>,<%= alto %>);
//--> 
</script>
</head>
    
<body marginheight="0" marginwidth="0" onresize='window.resizeTo(<%= ancho%>,<%= alto %>);' >
<table cellSpacing=0 cellPadding=0 width="100%" align="center" border=0>
    <TR>
        <TD><%= sBody  %></TD>
     </TR>
  </table>
</body>
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