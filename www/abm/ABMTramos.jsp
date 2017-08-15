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

    if (usu.getiCodTipoUsuario() != 0) {
        request.setAttribute("javax.servlet.jsp.jspException", new SurException ("acceso denegado"));
        getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
        
    }


LinkedList lTramos = new LinkedList ();

// variable utilizada para grabar. La primera vez siempre es null
String grabar  = (request.getParameter("grabar") == null ? "no" : request.getParameter("grabar"));
String sOpcion = (request.getParameter("opcion") == null ? "save" : request.getParameter("opcion"));
int rama = 10;    
int subRama = 2;

// valores maximos. Pueden ser variables porque se pueden setear dinamicamente.
int maxTramos = 0;
int maxCategoria = 6;
int maxAmbito = 3;

// hashtable utilizada para armar la tabla
Hashtable tasas = null;
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
</head>
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

    function Agregar () {
        if (!Validar()) {return }
           
        if (document.form1.opcion.value == "add") {
            document.getElementById ('desde_' + document.form1.tramos.value).disabled = false; 
        }
        bHuboCambios = false;//pongo el flag en false ya que voy a grabar
        document.form1.opcion.value = "add";
        document.form1.submit ();
    }

    function BorrarTramo(oCheck, oInput){
       if (!oCheck.checked){
         alert("Si no borrara este tramo, debe ingresar un valor hasta");
         oInput.focus();
       } else{
          oInput.value=0;
       }
    }

    function TramoHastaDoBlur(nTramo){

      var oHasta = document.getElementById("hasta_" + nTramo);
      var oCheck = document.getElementById("chkBorrar_" + nTramo);

      //Si se agrego un valor 
      if (oHasta.value !="0" && oHasta.value!=""){
         //quito el check de tramo borrado  
         oCheck.checked = false;
         var c = parseInt(document.form1.tramos.value);//obtengo la cantidad de tramos
         if (nTramo >= c) {return;} //si es el ultimo tramo me voy
         //copio el valor hasta de este tramo al valor desde del proximo
         nTramo++; //paso al siguiente tramo
         var oDesde = document.getElementById("desde_" + nTramo);
         oDesde.value = oHasta.value;
      }else{
          //Si valor hasta esta en cero o vacio y no esta checkeado para ser borrado
          if (!oCheck.checked){
              if (confirm("Si borra este valor o lo deja en cero, todo este tramo sera eliminado. \n¿Esta seguro que desea borrar este tramo?")){
                 oHasta.value="0";
                 oCheck.checked = true;
                 return;
              }else{
                 alert("Por favor ingrese un valor"); 
                 oHasta.focus();
                 return;  
              }
          } 
      }
    }

    function Validar(){
      var i;
      var bAnteriorBorrado = true;
      var c = parseInt(document.form1.tramos.value);
      var oHasta = document.getElementById("hasta_" + c);
      var antDesde = oHasta.value;
      for (i=c;i>0;i--){
           var oDesde = document.getElementById("desde_" + i);
           var oHasta = document.getElementById("hasta_" + i);
           var oCheck = document.getElementById("chkBorrar_" + i);
           //valido que no se borren tramos intermedios
           if (oHasta.value == 0 ||
               oHasta.value == ""){
               if ( !bAnteriorBorrado ){
                  alert("Hay un tramo que tiene el valor hasta en cero. No se pueden borrar tramos intermedios");  
                  oHasta.focus();
                  return false;  
               }
           }else{
              bAnteriorBorrado = false;  
           }
           //Si el tramo no esta marcado para ser borrado
           if ( !oCheck.checked && oHasta.value!=0 && oHasta.value!="" ){
               //valido que el valor hasta no sea mayor al desde y que ambos no sean mayores 
               //a los tramos superiores  
               if (antDesde != oHasta.value){
                  alert("El valor \"desde\" de este tramo y el valor \"hasta\" del siguiente deben ser iguales.");  
                  oHasta.focus();
                  return false;  
               }
               if ( oDesde.value == oHasta.value){
                   alert("Los valores desde y hasta no pueden ser iguales.");  
                   oHasta.focus();
                   return false;  
               }  
               if ( parseInt(oDesde.value) > parseInt(oHasta.value) ){
                   alert("El valor hasta debe ser mayor al valor desde.");  
                   oHasta.focus();
                   return false;  
               }  
           }
           antDesde = oDesde.value;
       }

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
       
       return true;
    }

    function Grabar () {
        if (!Validar()) {return }

        if (document.form1.opcion.value == "add") {
            document.getElementById ('desde_' + document.form1.tramos.value).disabled = false; 
        }
        bHuboCambios = false;//pongo el flag en false ya que voy a grabar
        document.form1.opcion.value = "save";
        document.form1.submit ();
    }

    function PasarAProduccion () {
        if (confirm("Estos valores entraran en vigencia a partir del dia "+ document.getElementById("fecha_desde").value +".\n¿Esta usted seguro que desea pasar a produccion estos valores?")) {
            bHuboCambios = false;//pongo el flag en false ya que voy a grabar
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
              Grabar();
           }
           return false;
        }
    }
</script>
<body>
<% 
CallableStatement cons2   = null;
CallableStatement cons1   = null;
CallableStatement cons    = null;
Connection dbCon          = null;
java.util.Date fecha      = new Date ();

    try {
    dbCon = db.getConnection();

    if (grabar.equals ("si")) {

// aca entra cuando se presiona el boton actualizar.

        Date fechaDesde = Fecha.strToDate(request.getParameter("fecha_desde"));
        int tramos = Integer.parseInt (request.getParameter ("tramos"));
        
        for (int ii= 1; ii <= maxCategoria; ii++) {
          for (int jj=1; jj <= maxAmbito;jj++) {
              for (int kk=1; kk <= tramos; kk++) {
                    Tramo oTramo = new Tramo ();
                    oTramo.setcodRama   (rama);
                    oTramo.setcodSubRama(subRama);
                    oTramo.setnroTramo  (kk);

                    String desde = request.getParameter ("desde_" + kk);
                    String hasta = request.getParameter ("hasta_" + kk);

                    if ( ! ( hasta.equals ("") || hasta.equals ("0") ) ) {
                        String item = "item_" + String.valueOf(ii) + "_" + String.valueOf(jj) + "_" +  String.valueOf(kk);
                        double tasa = Double.parseDouble((request.getParameter (item) == null || request.getParameter (item).equals ("") ? "0" : 
                                       request.getParameter (item)));

                        oTramo.setcategoria     (ii);
                        oTramo.setcodAmbito     (jj);
                        oTramo.setvalor         (tasa);
                        oTramo.setmontoDesde    (Integer.parseInt (desde));
                        oTramo.setmontoHasta    (Integer.parseInt (hasta));
                        oTramo.setfechaDesde    (fechaDesde);
                        oTramo.setDB(dbCon);

                    } else {
                        oTramo.delDB(dbCon);
                    }

                    if (oTramo.getiNumError() != 0) {
                        throw new SurException (oTramo.getsMensError());
                    }

              }
          }
        }
    }

    if (sOpcion.equals ("addProd")) {
        cons2 = dbCon.prepareCall(db.getSettingCall("ABM_PROD_TRAMOS () "));
        cons2.registerOutParameter(1, java.sql.Types.INTEGER);
        cons2.execute();
        int nErr = cons2.getInt(1);
        if ( nErr == 0 ) {
%>         <script>alert("Datos pasados a produccion con exito.")</SCRIPT><%
        }else{
%>         <script>alert("Error numero <%=nErr%> al pasar los datos a produccion.")</SCRIPT><%
        }
        //luego de entrar en esta opcion la limpio para no volver a ejecutarla
       sOpcion = "";
    }

    dbCon.setAutoCommit(false);
    // Procedure call.
    cons1 = dbCon.prepareCall(db.getSettingCall("ABM_GET_ALL_CABECERA_TRAMOS ()"));
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

    cons = dbCon.prepareCall(db.getSettingCall("ABM_GET_ALL_TRAMOS () "));
    cons.registerOutParameter(1, java.sql.Types.OTHER);
    cons.execute();

    ResultSet rs = (ResultSet) cons.getObject(1);
    if (rs != null) {
        tasas = new Hashtable ();
        while (rs.next()) {
            Tramo oTramo = new Tramo ();
            oTramo.setnroTramo(rs.getInt ("NRO_TRAMO"));
            oTramo.setmontoDesde(rs.getInt ("MONTO_DESDE"));
            oTramo.setmontoHasta(rs.getInt ("MONTO_HASTA"));
            oTramo.setcategoria  (rs.getInt("CATEGORIA"));
            oTramo.setcodAmbito  (rs.getInt("COD_AMBITO"));
            oTramo.setvalor       (rs.getDouble ("VALOR"));
            oTramo.setfechaDesde (rs.getDate("FECHA_DESDE"));
            fecha = rs.getDate("FECHA_DESDE");
            tasas.put (rs.getString ("CLAVE"), oTramo); 
        }
        rs.close();
    }
} catch (SQLException se) {
    throw new SurException (se.getMessage());
} finally {
    try {
        if (cons != null) { cons.close ();}
        if (cons1 != null) { cons1.close ();}
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
        <td  align="center" valign="top" width='100%'>
            <form action='/benef/abm/ABMTramos.jsp' method="post" name="form1">
            <input type="hidden" name="grabar" value="si">
            <input type="hidden" name="opcion" value="<%= sOpcion %>">
            <input type="hidden" name="tramos" value="<%= lTramos.size ()%>">
            <table width='500' cellpadding='0' cellspacing='0' border='0' align="center" class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                <tr>
                    <td colspan="2" width='100%' height='30' align="center" class='titulo'>TASA ASISTENCIA MEDICO FACMACEUTICA (Anuales)</td>
                </tr>
                <tr>
                <td align="center" class='subtitulo'>
                <div style="width:80%;text-align:left;" >
                Ingrese los valores de las tasas para cada tramo. <br>
                Si desea modificar el rango de los tramos, cambie los valores en la cabecera de cada columna.<br>
                Si desea borrar un tramo entero haga click en el tilde (borrar), los tramos deben ser borrados
                desde el mayor al menor, no se pueden borrar columnas intermedias.<br>
                Si desea agregar un nuevo tramo oprima el boton "Grabar y Agregar tramo".<br>
                Los valores se pueden cambiar y volver a modificar tantas veces como lo desee oprimiendo el boton "Grabar".<br>  
                <br>IMPORTANTE: Si oprime el boton "Pasar a Produccion" la modificación tendrá validez sobre el cotizador a partir de la fecha ingresada la cual debe ser igual o superior al dia de hoy.
                </div> 
                </TD>
                </TR> 
                <tr>
                    <td align="left"  class="text" valign="top" >
                        <table  border="1" cellspacing="0" cellpadding="2" align="center" class="TablasBody">
                            <tr>
                                <th >&nbsp;</th>
<%                         if (sOpcion.equals ("add")) {
    %>
                                <th colspan="<%= lTramos.size() + 1 %>" align="center">Tramos</th>
<%                         } else {
    %>
                                <th colspan="<%= lTramos.size() %>" align="center">Tramos</th>
<%                          }
    %>

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
                                    borrar<input id="chkBorrar_<%= t + 1 %>" name="chkBorrar_<%= t + 1 %>" type="checkbox" onclick="BorrarTramo(this,hasta_<%= t + 1 %>);"><br>&nbsp;&nbsp;
                                    <INPUT name="desde_<%= t + 1 %>" id="desde_<%= t + 1 %>" size='6' maxlength='6' <%if (t>0){%> readonly style='color:gray'<%}%> value="<%= oTramo.getmontoDesde ()%>"  onkeypress="return Mascara('D',event);" class="inputTextNumeric">&nbsp;&nbsp;<br>&nbsp;&nbsp;
                                    <INPUT tabindex='<%= t + 1 %>' name="hasta_<%= t + 1 %>" id="hasta_<%= t + 1 %>"  size='6' maxlength='6' value="<%= oTramo.getmontoHasta ()%>"  onkeypress="return Mascara('D',event);" class="inputTextNumeric" onfocus='InputDoFocus(this)' onblur='InputDoBlur(this);TramoHastaDoBlur(<%= t + 1 %>)'>&nbsp;&nbsp;
                                </th>  
<%                              }
                            if (sOpcion.equals ("add")) {
                                maxTramos += 1;
    %>
                                <th align="center" >&nbsp;&nbsp;
                                    borrar<input id="chkBorrar_<%= maxTramos %>" name="chkBorrar_<%= maxTramos %>" type="checkbox" onclick="BorrarTramo(this,hasta_<%= maxTramos %>);"><br>&nbsp;&nbsp;
                                    <INPUT name="desde_<%= maxTramos %>" id="desde_<%= maxTramos %>"size='6' maxlength='6' value="<%= ultTramo%>" style='color:gray' readonly class="inputTextNumeric">&nbsp;&nbsp;<br>&nbsp;&nbsp;
                                    <INPUT name="hasta_<%= maxTramos %>" id="hasta_<%= maxTramos %>" size='6' maxlength='6'  value="0"  onkeypress="return Mascara('D',event);" class="inputTextNumeric"  onfocus='InputDoFocus(this)' onblur='InputDoBlur(this);TramoHastaDoBlur(<%= maxTramos %>)'>&nbsp;&nbsp;
                                </th>  
<%                          }
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
                                    <td align="center">
                                    <input name="item_<%= i%>_<%= j%>_<%= k%>" id="item_<%= i%>_<%= j%>_<%= k%>" value="<%= tasa%>" maxlength='6' size='6' onkeypress="return Mascara('N',event);" class="inputTextNumeric"  onfocus='InputDoFocus(this)' onblur='InputDoBlur(this);'>
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
                    <td height='30' valign="middle" align="center">Fecha de validez de la actualización&nbsp;&nbsp;
                    <input name='fecha_desde' id='fecha_desde'  size='10' maxlength='10'  onfocus='InputDoFocus(this)' onblur='InputDoBlur(this);validaFecha(this);' onkeypress="return Mascara('F',event);" value="<%= Fecha.showFechaForm(fecha) %>">&nbsp;
                    </td>
                </tr>
                <tr>
                    <td align="center" valign="middle" height='20'>
                        <input type="button" name="cmdSalir" value=" Salir " height="20px" class="boton" onClick="Salir();">&nbsp
                        <input type="button" name="cmdVolver" value=" Volver " height="20px" class="boton" onClick="Volver();">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button" name="enviar" value=" Grabar " height="20px" class="boton" onclick="Grabar ();">&nbsp
                        <input type="button" name="agregar" value=" Grabar y Agregar tramo " height="20px" class="boton" onclick="Agregar ();">
                        <br>
                        <br>
                        <input type="button" name="cmdProd"  value=" Pasar a Produccion " height="20px" class="boton" onclick="PasarAProduccion()">
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
     document.form1.tramos.value = <%= maxTramos %>;
     CloseEspere();
</script>