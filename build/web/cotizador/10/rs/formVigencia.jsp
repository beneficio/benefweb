<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.CotizadorAp"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.db.db"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.LinkedList"%>
<%    
    HtmlBuilder ohtml       = new HtmlBuilder();
    Tablas oTabla = new Tablas ();
    LinkedList lTabla = new LinkedList ();
    Connection dbCon = null;
    CallableStatement proc = null;
    ResultSet rs = null;
   try {
    int codRama      = (request.getParameter ("cod_rama") == null ? 10 : Integer.parseInt (request.getParameter ("cod_rama"))); 
    int codSubRama   = (request.getParameter ("cod_sub_rama") == null ? 2 : Integer.parseInt (request.getParameter ("cod_sub_rama")));    
    String codVigencia  = (request.getParameter ("COD_VIGENCIA") == null ? "0" : request.getParameter ("COD_VIGENCIA"));
    int codProd      = (request.getParameter ("cod_prod") == null ? -1 : Integer.parseInt (request.getParameter ("cod_prod")));
    int cantCuotas   = (request.getParameter ("cuotas") == null ? 0 : Integer.parseInt (request.getParameter ("cuotas"))); 

    dbCon = db.getConnection();
    dbCon.setAutoCommit(false);
    proc = dbCon.prepareCall(db.getSettingCall("COT_GET_ALL_VIGENCIAS_PROD ( ?, ?, ?)"));
    proc.registerOutParameter(1, java.sql.Types.OTHER);
    proc.setInt(2, codRama );
    proc.setInt(3, codSubRama);
    proc.setInt(4, codProd);

    proc.execute();
   %>
<html>
<head><title>Cotizador AP</title>
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
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/alttxt.js"></script>
<script>
      var aCuotas = new Array (7);
      var aMeses  = new Array (7);

<%    rs = (ResultSet) proc.getObject(1);
    if (rs != null) { 
        int ii = 0;
        while (rs.next ()) {
        %>
       aMeses  [<%= ii + 1 %>]  = '<%= rs.getInt ("CANT_MESES") %>';
       aCuotas [<%= ii + 1 %>] = '<%= rs.getInt ("CANT_MAX_CUOTAS") %>';

<%     ii += 1;
        }
    }
    %>

    function setearCuotas (vigencia) {
        if (vigencia.value == '0') {
            document.getElementById ('cuotas').value = '1';
            return true;
        }
        if ( aCuotas [ vigencia.value ] == '-1') {
            alert ("La vigencia no es cotizable para el usuario.\nConsulte con su representante comercial.");
            return false;
      //  } else {
      //      document.getElementById ('cuotas').value = aCuotas [ vigencia.value ];
      //      window.parent.DoChangeVigencia ();
      //      return true;
        } else  {
            window.parent.DoChangeVigencia (aCuotas [ vigencia.value ]);
            return true;
        }
    }

    function ValidarCuotas (cuotas) {
        var cantCuotas    = parseFloat ( cuotas );
        var maxCuotas     = parseFloat ( aCuotas [ document.formCob.COD_VIGENCIA.value ] );
        if (isNaN (maxCuotas)) {
            maxCuotas = 1;
        }
        if ( cantCuotas > maxCuotas || cantCuotas == 0) {
            document.getElementById ('cuotas').value = '1';
            alert ("La cantidad máxima de cuotas para la vigencia es " + maxCuotas );
            document.formCob.cuotas.focus();
        }
        window.parent.DoChangeVigencia (maxCuotas);
    }

</script>
</head>
<body style="background-color:#F4F4F4;">
<div id="div_espere"  name="div_espere" style="position:absolute;top:0;left:0;width:100%;height:100%;background-color:#F4F4F4;text-align:center;visibility:visible;">
	Cargando datos...
</div>
      <form name="formCob" id="formCob"  method="POST">
        <table width='100%' border='0' align="left" cellpadding='0' cellspacing='3' class="fondoForm" style='padding: 1px 1px 1px 1px;'>
            <tr> 
                <td class="text" width='150' > Vigencia&nbsp;:</td>
                <td width='500'>
                  <select name="COD_VIGENCIA" id="COD_VIGENCIA" class="select" STYLE="WIDTH:50%" onchange="javascript:setearCuotas (this);">
                        <OPTION value='0' <%= (codVigencia.equals("0") ? "selected" : " ") %>>Seleccione vigencia</OPTION>
                    <%--
                          lTabla = oTabla.getDatosOrderByDesc ("VIGENCIA");
                          out.println(ohtml.armarSelectTAG(lTabla, codVigencia)); 
                         --%>
                        <OPTION value='1' <%= (codVigencia.equals("1") ? "selected" : " ") %>>Mensual</OPTION>
                        <OPTION value='2' <%= (codVigencia.equals("2") ? "selected" : " ") %>>Bimestral</OPTION>
                        <OPTION value='3' <%= (codVigencia.equals("3") ? "selected" : " ") %>>Trimestral</OPTION>
                        <OPTION value='4' <%= (codVigencia.equals("4") ? "selected" : " ") %>>Cuatrimestral</OPTION>
                        <OPTION value='5' <%= (codVigencia.equals("5") ? "selected" : " ") %>>Semestral</OPTION>
                        <OPTION value='6' <%= (codVigencia.equals("6") ? "selected" : " ") %>>Anual</OPTION>
                  </select>
                </td>
              </tr>
            <tr>
                <td class="text" colspan="2" > <span style="color:red;">Nota:&nbsp;</span>Menores a un mes: mensual, por el momento inhabilitada la cotización de polizas anuales. </td>
            </tr>
              <tr> 
                <td class="text">Ingrese la cantidad de cuotas:</td>
                <td class="text" ><input name="cuotas" id="cuotas" maxlength='2' size='2'
                                         onKeyPress="return Mascara('N',event);"
                                       class="inputTextNumeric" value="<%= cantCuotas%>" 
                                       onchange="javascript:ValidarCuotas(this.value);"
                                       onblur="javascript:ValidarCuotas(this.value);">
                &nbsp;&nbsp;(Puede ser menor o igual que la cant. máxima de cuotas para la vigencia seleccionada) </td>
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
<% if (cantCuotas == 0) {
    %>
        setearCuotas ( document.getElementById('COD_VIGENCIA'));
<%  } else {
    %>
    ValidarCuotas (<%= cantCuotas %>);
<%  }
    %>
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
