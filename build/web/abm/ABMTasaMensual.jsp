<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="error.jsp"%>
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

    if (usu.getiCodTipoUsuario() != 0) {
        request.setAttribute("javax.servlet.jsp.jspException", new SurException ("acceso denegado"));
        getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
        
    }

// variable utilizada para grabar. La primera vez siempre es null
String grabar = (request.getParameter("grabar") == null ? "no" : request.getParameter("grabar"));
String sOpcion = (request.getParameter("opcion") == null ? "save" : request.getParameter("opcion"));

int rama = 10;    
int subRama = Integer.parseInt (request.getParameter ("cod_sub_rama"));

// valores maximos. Pueden ser variables porque se pueden setear dinamicamente.
int maxCategoria = 6;
int maxAmbito = 3;
int maxCobertura = 3;

// hashtable utilizada para armar la tabla
Hashtable tasas = null;
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
<script type='text/javascript' src='<%=Param.getAplicacion()%>script/x_core.js'></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/fechas.js"></script>
<script type='text/javascript'>
    var sAuxValorAnterior="";
    var bHuboCambios = false;
    function InputDoFocus(oInput){
        //guardo el valor que tiene el input para detectar posibles cambios
        sAuxValorAnterior = oInput.value;
    }    
    function InputDoBlur(oInput){
        //verifico si cambio el valor
        bHuboCambios = sAuxValorAnterior != oInput.value;
    }

    function Validar(){

       //Valido que la fecha de validez sea mayor o igual al dia de hoy 
       var oFechaDesde = document.getElementById("fecha_desde");
       var d = new Date();
       var hoy =  d.getDate()+ "/" + (d.getMonth()+1) + "/" + d.getFullYear();
       if (oFechaDesde.value.length == 0){
           alert("Por favor ingrese la fecha desde cuando tendran validez los tramos.");  
           oFechaDesde.focus();
           return false;  
       }
       var aAux = oFechaDesde.value.split("/");
       var dia  = aAux[0] * 1;
       var mes  = aAux[1] * 1;
       var anio = aAux[2] * 1;
       if ( dateDiff("d",new Date(anio,mes-1,dia),new Date() ) > 0 ){
           alert("Por favor ingrese una fecha mayor o igual al dia de hoy.");  
           oFechaDesde.focus();
           return false;  
       }

       bHuboCambios = false; //pongo la bandera en false para grabar
       return true;
    }


    function PasarAProduccion () {
        if (confirm("Estos valores entraran en vigencia a partir del dia "+ document.getElementById("fecha_desde").value +".\n¿Esta usted seguro que desea pasar a produccion estos valores?")) {
            bHuboCambios = false; //pongo la bandera en false para grabar
            document.form1.opcion.value = "addProd";
            if (Validar()){
               document.form1.submit();
            }
            return true;
        } else {
            return false;
        }
    }
    function Volver () {
           window.location.replace("<%= Param.getAplicacion()%>abm/formAbmIndex.jsp");
    }

    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

    window.onunload= function(){
        if ( bHuboCambios ){
           if ( window.confirm("ATENCION se detectaron cambios.\n¿Desea guardar los cambios?.") ){
              document.form1.submit();
           }
           return false;
        }
    }
</script>
</head>
<body>
<% 
ResultSet rs = null;
CallableStatement cons = null;
CallableStatement cons2   = null;
Connection dbCon = null;
java.util.Date fecha      = new Date ();

    try {
    dbCon = db.getConnection();

    if (grabar.equals ("si")) {

// aca entra cuando se presiona el boton actualizar.

        Date fechaDesde = Fecha.strToDate(request.getParameter("fecha_desde"));
        
        for (int ii= 1; ii <= maxCategoria; ii++) {
          for (int jj=1; jj <= maxAmbito;jj++) {
              for (int kk=1; kk <= maxCobertura; kk++) {
                    String item = "item_" + String.valueOf(ii) + "_" + String.valueOf(jj) + "_" +  String.valueOf(kk);
                    double tasa = Double.parseDouble((request.getParameter (item) == null || request.getParameter (item).equals ("") ? "0" : 
                                   request.getParameter (item)));
                    TasaMensual oTasa = new TasaMensual ();
                    oTasa.setcodRama(rama);
                    oTasa.setcodSubRama(subRama);
                    oTasa.setcategoria(ii);
                    oTasa.setcodAmbito(jj);
                    oTasa.setcodCob(kk);
                    oTasa.settasa(tasa);
                    oTasa.setfechaDesde(fechaDesde);
                    oTasa.setDB(dbCon);

                    if (oTasa.getiNumError() != 0) {
                        throw new SurException (oTasa.getsMensError());
                    }
              }
          }
        }
    }

    if (sOpcion.equals ("addProd")) {
        cons2 = dbCon.prepareCall(db.getSettingCall("ABM_PROD_TASA_MENSUAL(?, ?) "));
        cons2.registerOutParameter(1, java.sql.Types.INTEGER);
        cons2.setInt   (2, rama);
        cons2.setInt   (3, subRama );

        cons2.execute();
        int nErr = cons2.getInt(1);
        if ( nErr == 0 ) {
%>         <script>alert("Datos pasados a produccion con exito.")</script><%
        }else{
%>         <script>alert("Error numero <%=nErr%> al pasar los datos a produccion.")</script><%
        }
    }

    dbCon.setAutoCommit(false);
    // Procedure call.
    cons = dbCon.prepareCall(db.getSettingCall("ABM_GET_ALL_TASA_MENSUAL(?,?) "));
    cons.registerOutParameter(1, java.sql.Types.OTHER);
    cons.setInt (2, rama);
    cons.setInt (3, subRama);

    cons.execute();

    rs = (ResultSet) cons.getObject(1);
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
            fecha = rs.getDate("FECHA_DESDE");
            tasas.put (rs.getString ("CLAVE"), oTasa); 
        }
        rs.close();
    }
} catch (SQLException se) {
    throw new SurException (se.getMessage());
} finally {
    try {
        if (rs != null) { rs.close (); }
        if (cons != null) { cons.close ();}
        if (cons2 != null) { cons2.close ();}
        db.cerrar (dbCon);
    } catch (SQLException se) {
        throw new SurException (se.getMessage());
    } 
} 
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
            <form action='/benef/abm/ABMTasaMensual.jsp' method="post" name="form1" onsubmit='return Validar()'>
            <input type="hidden" name="grabar" value="si"/>
            <input type="hidden" name="opcion" value=""/>
            <input type="hidden" name="cod_sub_rama" value="<%= subRama%>"/>
            <table width='500' cellpadding='0' cellspacing='0' border='0' align="center" class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                <tr>
                    <td colspan="2" width='100%' height='30' align="center" class='titulo'>TASAS ANUALES&nbsp;(<%= "PLAN " + subRama + " (" + (subRama == 1 ? "REINTEGRO" : "PRESTACIONAL" ) + ")"  %></td>
                </tr>
                <tr>
                    <td align="center" class='subtitulo'>
                    <div style="width:80%;text-align:left;" >
                    Ingrese los valores de las tasas para cada cobertura. <br/>
                    Los valores se pueden cambiar y volver a modificar tantas veces como lo desee oprimiendo el boton "Grabar".<br>
                    <br/>IMPORTANTE: Si oprime el boton "Pasar a Produccion" la modificación tendrá validez sobre el cotizador a partir de la fecha ingresada la cual debe ser igual o superior al dia de hoy.
                    </div>
                    </td>
                </tr>
                <tr>
                    <td align="left"  class="text" valign="top" >
                        <table  border="1" cellspacing="0" cellpadding="2" align="center" class="TablasBody">
                            <tr>
                                <th width='100' align="center">Cobertura</th>
                                <th width='60' align="center">Muerte</th>
                                <th width='60' align="center">Invalidez</th>
                                <th width='60' align="center">Asistencia</th>
                            </tr>
<%                      for (int i= 1; i <= maxCategoria; i++) {
                            for (int j=1; j <= maxAmbito;j++) {
    %>
                            <tr>
                                <td><%= i%>&nbsp;-&nbsp;Ambito:<%= j%></td>
<%                              for (int k=1; k <= maxCobertura; k++) {
                                    double tasa = ((TasaMensual) tasas.get(String.valueOf (i) + "|" + String.valueOf (j)+ "|" + String.valueOf (k) ) == null ? 0 : 
                                                    ((TasaMensual) tasas.get(String.valueOf (i) + "|" + String.valueOf (j)+ "|" + String.valueOf (k) )).gettasa());
    %>
                                    <td align="center">
                                    <input name="item_<%= i%>_<%= j%>_<%= k%>" value="<%= tasa%>" maxlength='6' size='6' onkeypress="return Mascara('N',event);" class="inputTextNumeric"  onfocus='InputDoFocus(this)' onblur='InputDoBlur(this);'>
                                    </td>

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
                    <td height='20' valign="middle" align="center">
                    <div style="width:80%">
                    Fecha de validez de la actualización&nbsp;&nbsp;
                    <input name='fecha_desde' id='fecha_desde' size='10' maxlength='10' onfocus='InputDoFocus(this)' onblur='InputDoBlur(this);validaFecha(this);' onkeypress="return Mascara('F',event);" value="<%=Fecha.showFechaForm(fecha)%>">&nbsp;
                    </div>
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan='2'>
                        <input type="button" name="cmdSalir" value=" Salir " height="20px" class="boton" onClick="Salir();"/>&nbsp
                        <input type="button" name="cmdVolver" value=" Volver " height="20px" class="boton" onClick="Volver();"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="submit"  name="enviar" value=" Grabar " height="20px" class="boton" />&nbsp;&nbsp;&nbsp;&nbsp;

                        <br>
                        <br>
                        <input type="button" name="cmdProd"  value=" Pasar a Produccion " height="20px" class="boton" onclick="PasarAProduccion();">

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