<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.CotizadorAp"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.db.db"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.LinkedList"%>
<%    
    Connection dbCon = null;
    CallableStatement proc = null;
    ResultSet rs     = null;
    int cantCob      = 0;
    int cantMaxCob   = 0;
    try { 

        int codRama      = (request.getParameter ("cod_rama") == null ? 22 : Integer.parseInt (request.getParameter ("cod_rama")));
        int codSubRama   = (request.getParameter ("cod_sub_rama") == null ? 0 : Integer.parseInt (request.getParameter ("cod_sub_rama")));
        int codProd      = (request.getParameter ("cod_prod") == null ? -1 : Integer.parseInt (request.getParameter ("cod_prod")));
        int propCantCob  = (request.getParameter ("prop_cantCob") == null ? 0 : Integer.parseInt (request.getParameter ("prop_cantCob")));
        int codPlan      = (request.getParameter ("cod_plan") == null ? -1 : Integer.parseInt (request.getParameter ("cod_plan")));
        String nivelCob  = (request.getParameter ("nivel_cob") == null ? " " : request.getParameter ("nivel_cob"));
        int codProducto  = (request.getParameter ("cod_producto") == null ? -1 : Integer.parseInt (request.getParameter ("cod_producto")));
        java.util.Hashtable hasCob = new java.util.Hashtable();

        if (codRama == 9 ||codPlan > 0 || (nivelCob.equals("P") && (codRama != 22 || (codRama == 22 && codProducto > 0)))) {
            if (propCantCob > 0) {
                //AsegCobertura oCob ;
                for (int i=1;i<=propCantCob;i++){
                    int    codCob = (request.getParameter ("prop_cob_cod_"+i) == null ? 0 : Integer.parseInt (request.getParameter ("prop_cob_cod_"+i)));
                    double impCob = (request.getParameter ("prop_cob_"+i) == null ? 0 : Double.parseDouble (request.getParameter ("prop_cob_"+i)));
                    hasCob.put(codCob,impCob);
                }
            }

        dbCon = db.getConnection();

        cantMaxCob   =  Integer.parseInt(Dbl.DbltoStr(ConsultaMaestros.getParametro(dbCon, codRama, 10),0));


        dbCon.setAutoCommit(false);
        proc = dbCon.prepareCall(db.getSettingCall("PRO_GET_ALL_SUMAS_COBERTURAS( ?, ?, ?, ?)"));
        proc.registerOutParameter(1, java.sql.Types.OTHER);
        proc.setInt(2, codRama );
        proc.setInt(3, codSubRama);
        proc.setInt(4, codProd);
        proc.setInt(5, codPlan);
        proc.execute();
        rs = (ResultSet) proc.getObject(1);
     }
%>
<html>
<head><title>Propuesta VC </title>
<link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css">
<link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>css/Tablas.css">
<style>
.TablasTit {
	BACKGROUND-COLOR: #6699cc;
	BORDER-BOTTOM: #3366cc 1px solid;
	BORDER-LEFT: #3366cc 1px solid;
	BORDER-RIGHT: #3366cc 1px solid;
	BORDER-TOP: #3366cc 1px solid;
        font-family: Verdana, Arial, Helvetica, sans-serif; color: #FFFFFF;
        font-size: 12px;
}
</style> 
<SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></SCRIPT>
<SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/alttxt.js"></SCRIPT>
</head>
<body  style="background-color:#F4F4F4;">
<div id="div_espere"  name="div_espere" style="position:absolute;top:0;left:0;width:100%;height:100%;background-color:#F4F4F4;text-align:center;visibility:visible;">
	Cargando datos...
</div>
   <form name="formCob" id="formCob"  method="POST">
      <table width='550px' border='0' align="left" cellpadding='0' cellspacing='1' class="fondoForm" style="padding: 1px 1px 1px 1px;">
         <tr align="center"> 
            <td  colspan='2' class='TablasTit'>Coberturas</td>
          </tr>
            <%
            if (rs != null) {
                int    i = 0;
                
               while (rs.next ()) {
                  int iCodCob = rs.getInt("COD_COBERTURA") ;
                  double importe = 0;
                  if (hasCob.get(iCodCob) != null) {
                      importe = (Double)hasCob.get(iCodCob);
                  }                   
                  i++;
            %>

                <TR>         
                   <INPUT type="hidden" name="COD_COB_<%=i%>"  id="COD_COB_<%=i%>"  value="<%=iCodCob%>">  
                   <TD class="text"  width='300px'> <%=iCodCob  + " - " +rs.getString("COBERTURA")%>&nbsp;
                       <%= (rs.getDouble("MIN_SUMA_ASEGURADA") == rs.getDouble("MAX_SUMA_ASEGURADA") ?
                           "&nbsp;" : "( $ " + Dbl.DbltoStr(rs.getDouble("MIN_SUMA_ASEGURADA"),0) + " a $ " + Dbl.DbltoStr(rs.getDouble("MAX_SUMA_ASEGURADA"),0) + ")" )%>
                   </TD>
                    <TD width='300' >
                        <INPUT type="text" 
                               name=  "COB_<%=i%>"
                               id=    "COB_<%=i%>"
                               min=  "<%=rs.getDouble("MIN_SUMA_ASEGURADA")%>" 
                               max=  "<%=rs.getDouble("MAX_SUMA_ASEGURADA")%>"
                               class="inputTextNumeric"  
                               <%=(rs.getDouble("MIN_SUMA_ASEGURADA") == rs.getDouble("MAX_SUMA_ASEGURADA") ? "readonly" : "onKeyPress=\"return Mascara('N',event);\" " )%>
                               value= "<%= (rs.getDouble("MIN_SUMA_ASEGURADA") == rs.getDouble("MAX_SUMA_ASEGURADA") ?  rs.getDouble("MAX_SUMA_ASEGURADA") : importe )%>"  >

<%--                           onBlur="javascript:writetxt(0);"
                               onfocus="javascript:writetxt('Ingrese Suma Asegurada entre $<%= rs.getDouble("MIN_SUMA_ASEGURADA")%> y $<%= rs.getDouble("MAX_SUMA_ASEGURADA")%>');"
                               onmouseover="javascript:writetxt('Ingrese Suma Asegurada entre $<%=rs.getDouble("MIN_SUMA_ASEGURADA")%> y $<%=rs.getDouble("MAX_SUMA_ASEGURADA")%>');"
                               onmouseout="javascript:writetxt(0);" 
                   <IMG src="<%= Param.getAplicacion()%>images/pregunta1.gif" 
                               onmouseover="javascript:writetxt('Ingrese Suma Asegurada entre $<%=rs.getDouble("MIN_SUMA_ASEGURADA")%> y $<%=rs.getDouble("MAX_SUMA_ASEGURADA")%>');" onmouseout="javascript:writetxt(0);">
 --%>                    </TD>
                </TR>

            <%
               cantCob++;
                }  // while rs.next
            } // if rs!=null
        // Maximo cantidad de Coberturas....
        if ( cantCob > cantMaxCob) {
             cantCob = cantMaxCob;
        }
            %> 
        </table>
      <INPUT type="hidden" name="MAX_CANT_COB"  id="MAX_CANT_COB"  min="0" max="0" value="<%=cantCob%>">
      </form>
<div id="navtxt" 
     class="navtext"
     style="visibility:hidden; position:absolute; top:0px; left:-400px;z-index:10000; padding:10px">
</div>
<div id="divInfo" 
     name="div_info"
     class="navtext"
     style="visibility:hidden; position:absolute;top:0px; left:-400px;z-index:10000; padding:10px">
</div>
</body>
<script>
	document.getElementById ('div_espere').style.visibility="hidden";
  window.onload = function () {
      return window.parent.SetearCarga('1');      
  }

</script>
</html>

<%   } catch (Exception e) {
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
