<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.CotizadorAp"%>
<%@page import="com.business.db.db"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.LinkedList"%>
<%
    Connection dbCon = null;
    CallableStatement proc = null;
    ResultSet rs = null;
   try {
    int codRama      = (request.getParameter ("cod_rama") == null ? 10 : Integer.parseInt (request.getParameter ("cod_rama"))); 
    int codSubRama   = (request.getParameter ("cod_sub_rama") == null ? 2 : Integer.parseInt (request.getParameter ("cod_sub_rama")));    
    int codActividad = (request.getParameter ("cod_actividad") == null ? 0 : Integer.parseInt (request.getParameter ("cod_actividad")));
    int codProd      = (request.getParameter ("cod_prod") == null ? -1 : Integer.parseInt (request.getParameter ("cod_prod")));
    double iSumaMuerte     = (request.getParameter ("muerte") == null ? 0 : Dbl.StrtoDbl (request.getParameter ("muerte")));
    double iSumaInvalidez  = (request.getParameter ("invalidez") == null ? 0 : Dbl.StrtoDbl (request.getParameter ("invalidez")));
    double iSumaAsistencia = (request.getParameter ("asistencia") == null ? 0 : Dbl.StrtoDbl(request.getParameter ("asistencia")));
    double iSumaFranq      = (request.getParameter ("franq") == null ? 0 : Dbl.StrtoDbl(request.getParameter ("franq")));
    
    double iMaxSumaMuerte       = 300000;
    double iMaxSumaInvalidez    = 300000;
    double iMaxSumaAsistencia   = 50000;
    double iMaxSumaFranq        = 10000;

    double iMinSumaMuerte       = 1000;
    double iMinSumaInvalidez    = 1000;
    double iMinSumaAsistencia   = 0;
    double iMinSumaFranq        = 0;

    dbCon = db.getConnection();
    dbCon.setAutoCommit(false);
    proc = dbCon.prepareCall(db.getSettingCall("COT_GET_ALL_MAX_SUMAS_ASEGURADAS ( ?, ?, ?,?)"));
    proc.registerOutParameter(1, java.sql.Types.OTHER);
    proc.setInt(2, codRama );
    proc.setInt(3, codSubRama);
    proc.setInt(4, codActividad );
    proc.setInt(5, codProd);

    proc.execute();

    rs = (ResultSet) proc.getObject(1);
    if (rs != null) {  
        while (rs.next ()) {
            switch (rs.getInt ("COD_COBERTURA") ) {
                case 1: iMaxSumaMuerte = (rs.getDouble ("MAX_SUMA_ASEGURADA") == 0 ? iMaxSumaMuerte : rs.getDouble ("MAX_SUMA_ASEGURADA"));
                        iMinSumaMuerte = (rs.getDouble ("MIN_SUMA_ASEGURADA") == 0 ? iMinSumaMuerte : rs.getDouble ("MIN_SUMA_ASEGURADA"));
                        break;
                case 2: iMaxSumaInvalidez = (rs.getDouble ("MAX_SUMA_ASEGURADA") == 0 ? iMaxSumaInvalidez : rs.getDouble ("MAX_SUMA_ASEGURADA"));
                        iMinSumaInvalidez = (rs.getDouble ("MIN_SUMA_ASEGURADA") == 0 ? iMinSumaInvalidez : rs.getDouble ("MIN_SUMA_ASEGURADA"));
                        break;
                case 4: iMaxSumaAsistencia = (rs.getDouble ("MAX_SUMA_ASEGURADA") == 0 ? iMaxSumaAsistencia : rs.getDouble ("MAX_SUMA_ASEGURADA"));
                        iMinSumaAsistencia = (rs.getDouble ("MIN_SUMA_ASEGURADA") == 0 ? iMinSumaAsistencia : rs.getDouble ("MIN_SUMA_ASEGURADA"));
                        break;
                default: break;
            }
                

        }
    } 
   %>
<html>
<head><title>Cotizador AP</title></head>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css">
<link href="<%=Param.getAplicacion()%>css/Tablas.css" rel="stylesheet" type="text/css">
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
<SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/alttxt.js"></SCRIPT>
<body style="background-color:#F4F4F4;">
<div id="div_espere"  name="div_espere" style="position:absolute;top:0;left:0;width:100%;height:100%;background-color:#F4F4F4;text-align:center;visibility:visible;">
	Cargando datos...
</div>
      <form name="formCob" id="formCob"  method="POST">
        <input type="hidden" name="SUMA_MIN_1" ID="SUMA_MIN_1" VALUE="<%= iMinSumaMuerte %>">
        <input type="hidden" name="SUMA_MIN_2" ID="SUMA_MIN_2" VALUE="<%= iMinSumaInvalidez %>">
        <input type="hidden" name="SUMA_MIN_4" ID="SUMA_MIN_4" VALUE="<%= iMinSumaAsistencia %>">
        <input type="hidden" name="SUMA_MIN_5" ID="SUMA_MIN_5" VALUE="<%= iMinSumaFranq %>">

        <input type="hidden" name="SUMA_MAX_1" ID="SUMA_MAX_1" VALUE="<%= iMaxSumaMuerte %>">
        <input type="hidden" name="SUMA_MAX_2" ID="SUMA_MAX_2" VALUE="<%= iMaxSumaInvalidez %>">
        <input type="hidden" name="SUMA_MAX_4" ID="SUMA_MAX_4" VALUE="<%= iMaxSumaAsistencia %>">
        <input type="hidden" name="SUMA_MAX_5" ID="SUMA_MAX_5" VALUE="<%= iMaxSumaFranq %>">

        <table width='100%' border='0' align="left" cellpadding='0' cellspacing='1' class="fondoForm" style='padding: 1px 1px 1px 1px;'>
         <tr align="center"> 
            <td  colspan='2' class='TablasTit'>Coberturas</td>
          </tr>
            <tr> 
                <td class="text"  width='225'> Muerte por accidente </td>
                <td width='300' ><input type="text" name="CAPITAL_MUERTE" id="CAPITAL_MUERTE" value="<%= Dbl.DbltoStr( iSumaMuerte ,2)%>" onBlur="writetxt(0)" 
                    min="<%= iMinSumaMuerte %>" max="<%= iMaxSumaMuerte %>" onKeyPress="return Mascara('N',event);" class="inputTextNumeric" 
                    onfocus="writetxt('Ingrese Suma Asegurada entre $<%= Dbl.DbltoStr(iMinSumaMuerte,0) %> y $<%=  Dbl.DbltoStr(iMaxSumaMuerte,0)%>')" 
                    onmouseover="writetxt('Ingrese Suma Asegurada entre $<%= Dbl.DbltoStr(iMinSumaMuerte,0) %> y $<%= Dbl.DbltoStr(iMaxSumaMuerte,0) %>')" onmouseout="writetxt(0)">
                    <img src="<%= Param.getAplicacion()%>images/pregunta1.gif" 
                    onmouseover="writetxt('Ingrese Suma Asegurada entre $<%= Dbl.DbltoStr(iMinSumaMuerte,0) %> y $<%= Dbl.DbltoStr(iMaxSumaMuerte,0) %>')" onmouseout="writetxt(0)">
                </td>
            </tr>
            <tr> 
                <td class="text"> Invalidez permanente total y/o parcial</td>
                <td><input type="text" name="CAPITAL_INVALIDEZ" id="CAPITAL_INVALIDEZ" value="<%= Dbl.DbltoStr(iSumaInvalidez ,2)%>" onBlur="writetxt(0)" 
                    min="<%= iMinSumaInvalidez %>" max="<%= iMaxSumaInvalidez %>" onKeyPress="return Mascara('N',event);" class="inputTextNumeric" 
                    onfocus="writetxt('Ingrese Suma Asegurada entre $<%= Dbl.DbltoStr(iMinSumaInvalidez,0) %> y $<%= Dbl.DbltoStr(iMaxSumaInvalidez,0) %>')"  
                    onmouseover="writetxt('Ingrese Suma Asegurada entre $<%= Dbl.DbltoStr(iMinSumaInvalidez,0) %> y $<%= Dbl.DbltoStr(iMaxSumaInvalidez,0) %>')" onmouseout="writetxt(0)">
                    <img src="<%= Param.getAplicacion()%>images/pregunta1.gif" 
                    onmouseover="writetxt('Ingrese Suma Asegurada entre $<%= Dbl.DbltoStr(iMinSumaInvalidez,0) %> y $<%= Dbl.DbltoStr(iMaxSumaInvalidez,0) %>')" onmouseout="writetxt(0)">
                </td>
            </tr>
            <tr> 
                <td class="text"> Asistencia m&eacute;dica farmac&eacute;utica </td>
                <td><input type="text" name="CAPITAL_ASISTENCIA" id="CAPITAL_ASISTENCIA" value="<%= Dbl.DbltoStr( iSumaAsistencia ,2)%>" onBlur="writetxt(0)" notNull="false" 
                    min="<%= iMinSumaAsistencia %>" max="<%= iMaxSumaAsistencia %>" onKeyPress="return Mascara('N',event);" class="inputTextNumeric"   
                    onfocus="writetxt('Ingrese Suma Asegurada entre $<%= Dbl.DbltoStr(iMinSumaAsistencia,0) %> y $<%= Dbl.DbltoStr(iMaxSumaAsistencia,0) %>')" 
                    onmouseover="writetxt('Ingrese Suma Asegurada entre $<%= Dbl.DbltoStr(iMinSumaAsistencia,0) %> y $<%= Dbl.DbltoStr(iMaxSumaAsistencia,0) %>')" onmouseout="writetxt(0)">
                    <img src="<%= Param.getAplicacion()%>images/pregunta1.gif" 
                    onmouseover="writetxt('Ingrese Suma Asegurada entre $<%= Dbl.DbltoStr(iMinSumaAsistencia,0) %> y $<%= Dbl.DbltoStr(iMaxSumaAsistencia,0) %>')" onmouseout="writetxt(0)">
                </td>
            </tr>
            <tr> 
                <td class="text"> Franquicia </td>
                <td><input type="text" name="FRANQUICIA"  id="FRANQUICIA" value="<%= Dbl.DbltoStr(iSumaFranq ,2)%>" onBlur="writetxt(0)" notNull="false" 
                    min="<%= iMinSumaFranq %>" max="<%= iMaxSumaFranq %>"  onKeyPress="return Mascara('N',event);" class="inputTextNumeric" 
                    onfocus="writetxt('Ingrese valor entre $<%= Dbl.DbltoStr(iMinSumaFranq,0) %> y $<%= Dbl.DbltoStr(iMaxSumaFranq,0) %>')" 
                    onmouseover="writetxt('Ingrese valor entre $<%= Dbl.DbltoStr(iMinSumaFranq,0) %> y $<%= Dbl.DbltoStr(iMaxSumaFranq,0) %>')" onmouseout="writetxt(0)">
                    <img src="<%= Param.getAplicacion()%>images/pregunta1.gif" 
                    onmouseover="writetxt('Ingrese valor entre $<%= Dbl.DbltoStr(iMinSumaFranq,0) %> y $<%= Dbl.DbltoStr(iMaxSumaFranq,0) %>')" onmouseout="writetxt(0)">
                </td>
            </tr>
        </table>
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
<script>
	document.getElementById ('div_espere').style.visibility="hidden";
</script>
</body>
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
