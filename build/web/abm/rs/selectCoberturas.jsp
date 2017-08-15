<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.LinkedList"%>
<%
Connection dbCon = null;
CallableStatement proc = null;
ResultSet rs = null;
int iCodActividad = Integer.parseInt (request.getParameter ("cod_actividad"));
int codRama = request.getParameter ("cod_rama") == null ? 10 : Integer.parseInt (request.getParameter ("cod_rama"));
int codSubRama = request.getParameter ("cod_sub_rama") == null ? 999 : Integer.parseInt (request.getParameter ("cod_sub_rama"));
int iCantCob = 0;

try {

if (iCodActividad != -1) {
    dbCon = db.getConnection();
    dbCon.setAutoCommit(false);
    proc = dbCon.prepareCall(db.getSettingCall("ABM_GET_ALL_ACT_COBERTURAS( ?, ?, ?)"));
    proc.registerOutParameter(1, java.sql.Types.OTHER);
    proc.setInt(2, codRama );
    proc.setInt(3, codSubRama);
    proc.setInt(4, iCodActividad );

    proc.execute();

    rs = (ResultSet) proc.getObject(1);
} 
%>
<html>
<head><title>JSP Page</title>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css">
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
</head>
<body style="background-color:#F4F4F4;">
<div id="div_espere"  name="div_espere" style="position:absolute;top:0;left:0;width:100%;height:100%;background-color:#F4F4F4;text-align:center;visibility:visible;">
	Cargando datos...
</div>  
<form action="<%= Param.getAplicacion()%>servlet/ActividadCategoriaServlet" method="post" id="form1" name="form1">
   <input type="hidden" name="opcion" id="opcion" value="addActividadCategoria"/>
    <input type="hidden" name="COD_ACTIVIDAD" id="COD_ACTIVIDAD" value="<%=iCodActividad %>"/>
    <input type="hidden" name="COD_RAMA" id="COD_RAMA" value="<%=codRama%>"/>
    <input type="hidden" name="COD_SUB_RAMA" id="COD_SUB_RAMA" value="<%=codSubRama%>"/>
    <input type="hidden" name="CATEGORIA" id="CATEGORIA" value="0"/>
    <input type="hidden" name="DESCRIPCION" id="DESCRIPCION" value=""/>
    <input type="hidden" name="MCA_BAJA" id="MCA_BAJA" value=""/>
    <input type="hidden" name="MCA_PLANES" id="MCA_PLANES" value=""/>
    <input type="hidden" name="MCA_COTIZADOR" id="MCA_COTIZADOR" value=""/>
    <input type="hidden" name="MCA_NO_RENOVAR" id="MCA_NO_RENOVAR" value=""/>
    <input type="hidden" name="MCA_24HORAS" id="MCA_24HORAS" value=""/>
    <input type="hidden" name="MCA_ITINERE" id="MCA_ITINERE" value=""/>
    <input type="hidden" name="MCA_LABORAL" id="MCA_LABORAL" value=""/>


<table border='0' cellpadding='2' cellspacing='0' align="left" style='margin-top:5;margin-bottom:5;'>
    <tr>    
        <th align="center" width='350'>Cobertura</th>  
        <th align="left" width='150'>Max. Suma Aseg.</th>  
    </tr>
<%          if (rs != null) {  
                    while (rs.next ()) {
                            iCantCob += 1;
%>
                            <INPUT type="hidden" name="COB_<%= iCantCob %>" id="COB_<%= iCantCob %>" value="<%= rs.getInt ("COD_COBERTURA") %>"/>
                            <INPUT type="hidden" id="SUMA_ANT_<%=iCantCob %>" name="SUMA_ANT_<%= iCantCob %>" value='<%= Dbl.DbltoStr(rs.getDouble ("MAX_SUMA_ASEGURADA"),2)%>' />

                            <tr>
                                <td align="LEFT" width="200" class='text'>&nbsp;&nbsp;<%= rs.getInt ("COD_COBERTURA")%>&nbsp;-&nbsp;<%= rs.getString ("COBERTURA")%></td>
                                <td class='text'>&nbsp;<INPUT type="text" id="SUMA_<%= iCantCob %>" name="SUMA_<%= iCantCob %>" onkeypress="return Mascara('D',event);" 
                                        class="inputTextNumeric" type="text"  size='10' maxlength='10' style="width:70" value='<%= Dbl.DbltoStr(rs.getDouble ("MAX_SUMA_ASEGURADA"),2)%>' ></td>
                            </tr>
<%                  }
            } else {
    %>
                            <tr>
                                <td class='text'>No existen coberturas informadas</td>
                                <td>&nbsp;</td>
                            </tr>
<%          }   
    %>
                            <input type="hidden" name="CANT_COB" value="<%= iCantCob %>"/>
</table>
</form>
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
