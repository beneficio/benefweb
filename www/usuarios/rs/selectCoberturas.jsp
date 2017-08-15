<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.LinkedList"%>
<%
Connection dbCon = null;
CallableStatement proc = null;
ResultSet rs = null;
int iCodProd = Integer.parseInt (request.getParameter ("cod_prod"));
int codRama = request.getParameter ("cod_rama") == null ? 10 : Integer.parseInt (request.getParameter ("cod_rama"));
int codSubRama = request.getParameter ("cod_sub_rama") == null ? 999 : Integer.parseInt (request.getParameter ("cod_sub_rama"));
int iCantCob = 0;
int iAnt = 0;
try {

    dbCon = db.getConnection();
    dbCon.setAutoCommit(false);
    proc = dbCon.prepareCall(db.getSettingCall("US_GET_ALL_PROD_COBERTURAS( ?, ?, ?)"));
    proc.registerOutParameter(1, java.sql.Types.OTHER);
    proc.setInt(2, codRama );
    proc.setInt(3, codSubRama);
    proc.setInt(4, iCodProd );

    proc.execute();

    rs = (ResultSet) proc.getObject(1); 
%>
<html>
<head><title>JSP Page</title>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css">
<SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
</head>
<body style="background-color:#F4F4F4;">
<div id="div_espere"  name="div_espere" style="position:absolute;top:0;left:0;width:100%;height:100%;background-color:#F4F4F4;text-align:center;visibility:visible;">
	Cargando datos...
</div>
<form method="post" id="form1" name="form1">
   <input type="hidden" name="opcion" id="opcion">
    <input type="hidden" name="cod_prod" id="cod_prod" value="<%=iCodProd %>">
    <input type="hidden" name="cod_rama" id="cod_rama" value="<%=codRama%>">
    <input type="hidden" name="cod_sub_rama" id="cod_sub_rama" value="<%=codSubRama%>">
    <input type="hidden" name="numSecuUsu" id="numSecuUsu" value="0">

<TABLE border='0' width='100%' cellpadding='2' cellspacing='0' align="left" style='margin-top:5;margin-bottom:5;'>
    <tr>
        <th align="center" width='250'>Sub Rama</th>  
        <th align="center" width='300'>Cobertura</th>  
        <th align="left" width='140'>Max. Suma Aseg.</th>  
    </tr>
<%          if (rs != null) {  
                    while (rs.next ()) {
                            iCantCob += 1;
   %>
<%
                            if (rs.getInt ("COD_SUB_RAMA") != iAnt) {
%>
                        <tr><td colspan='3'><hr></td></tr>
<%                              iAnt = rs.getInt ("COD_SUB_RAMA");
                            }
    %>
                            <INPUT type="hidden" name="SUB_RAMA_<%= iCantCob %>" id="SUB_RAMA_<%= iCantCob %>" value="<%= rs.getInt ("COD_SUB_RAMA") %>">
                            <INPUT type="hidden" name="COB_<%= iCantCob %>" id="COB_<%= iCantCob %>" value="<%= rs.getInt ("COD_COBERTURA") %>">
                            <INPUT type="hidden" id="SUMA_ANT_<%= iCantCob %>" name="SUMA_ANT_<%= iCantCob %>" value="<%= Dbl.DbltoStr(rs.getDouble ("MAX_SUMA_ASEGURADA"),2)%>">
                            
                            <TR>
                                <TD align="LEFT" class='text'>&nbsp;&nbsp;<%= rs.getInt ("COD_SUB_RAMA")%>&nbsp;-&nbsp;<%= rs.getString ("SUB_RAMA")%></td>
                                <TD align="LEFT" class='text'>&nbsp;&nbsp;<%= rs.getInt ("COD_COBERTURA")%>&nbsp;-&nbsp;<%= rs.getString ("COBERTURA")%></td>
                                <td class='text'><INPUT type="text" id="SUMA_<%= iCantCob %>" name="SUMA_<%= iCantCob %>" onkeypress="return Mascara('D',event);" 
                                    class="inputTextNumeric" type="text"  size='13' maxlength='10' value='<%= Dbl.DbltoStr(rs.getDouble ("MAX_SUMA_ASEGURADA"),2)%>'>
                                </td>
                            </tr>
<%                  }
            } else {
    %>
                            <TR>
                                <TD colspan='2' align="LEFT">No existen coberturas informadas</td>
                                <td>&nbsp;</td>
                            </tr>
<%          }   
    %>
                            <INPUT type="hidden" name="CANT_COB" value="<%= iCantCob %>">
</table>
<script>
	document.getElementById ('div_espere').style.visibility="hidden";
</script>
</body>
</html>
<%     } catch (Exception e) {
       throw new SurException (e.getMessage());
        } finally {
         try {
            if (rs != null) rs.close ();
            if (proc != null) proc.close ();
         } catch (Exception e) {
            throw new SurException (e.getMessage());
        }
        db.cerrar(dbCon); 
        } 
   %>
