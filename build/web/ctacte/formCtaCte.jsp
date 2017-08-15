<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Poliza"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>
<%@ taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg" %>
<%          
    Usuario usu = (Usuario) session.getAttribute("user");
    String fechaMaxCtaCte    = (String)request.getAttribute("fechaMaxCtaCte");
    Date   fechaMaxCtaCteHis = (Date)  request.getAttribute("fechaMaxCtaCteHis");

    if (fechaMaxCtaCteHis == null) {
        fechaMaxCtaCteHis = new Date ();
        }

    Calendar ahoraCal = Calendar.getInstance();
    ahoraCal.setTime(fechaMaxCtaCteHis);

    ahoraCal.add(Calendar.MONTH, 1);
    int  iMes = ahoraCal.get (Calendar.MONTH );
    int  iAno = ahoraCal.get(Calendar.YEAR );

    String sMes = String.valueOf(iMes);
    if (iMes < 10) {
        sMes = "0" + sMes;
       }
    String sMesAnio = sMes  + "/" + String.valueOf(iAno);
//    String sMesAnio = "12/2016";
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
    <SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <SCRIPT language="javascript">
        function CheckedHis(){
           document.getElementById ('cc_fecha_desde').disabled = false;
           document.getElementById ('cc_fecha_hasta').disabled = false;
        }
        function CheckedOL(){
            document.getElementById ('cc_fecha_desde').disabled = true;
            document.getElementById ('cc_fecha_hasta').disabled = true;
        }

        function ValidarFecha (input,origen){
            var nSeparador = input.value.indexOf( "/", 0 )
            var fechaReturn;            
            if (nSeparador == -1) {
                input.value = '01'+ input.value
            } else {
                input.value = '01/'+ input.value
            }
            var ret = validaFecha(input);
            fechaReturn = ret.substring(3, ret.length) ;
            if (origen == 'DESDE') {
                document.getElementById ('cc_fecha_desde').value =fechaReturn;
                return true;
            } else {
                if (origen == 'HASTA') {
                    document.getElementById ('cc_fecha_hasta').value =fechaReturn;
                    return true;
                }
            }
        }

        function FormatFechaOnLine(fechaOL){            
            var nSeparador = fechaOL.indexOf( "/", 0 );            
            var aux = fechaOL.substring(nSeparador +1, fechaOL.length);
            var fechaReturn = aux.substring(3,aux.length) + aux.substring(0,2);
            return fechaReturn;
        }

        function Salir () {
            window.location.replace("<%= Param.getAplicacion()%>index.jsp");
        }

        function Enviar () {

          if (document.getElementById('cc_tipo_his').checked){
                document.form1.opcion.value  = 'getCtasCtesHIS';
                if (document.getElementById('cc_fecha_desde').value.length<=0) {
                    alert ("Debe ingresar Fecha Desde .");
                    document.getElementById('cc_fecha_desde').focus();
                    return false;
                } else {
                    if (document.getElementById('cc_fecha_hasta').value.length<=0) {
                        alert ("Debe ingresar Fecha Hasta .");
                        document.getElementById('cc_fecha_hasta').focus();                        
                        return false;
                    } 
                }              
                var fDesde  = document.getElementById ('cc_fecha_desde').value.replace("/","");                
                document.getElementById ('cc_fecha_desde').value = fDesde.substring(2,fDesde.length) + fDesde.substring(0,2);                               
                var fHasta  = document.getElementById ('cc_fecha_hasta').value.replace("/","");                
                document.getElementById ('cc_fecha_hasta').value = fHasta.substring(2,fHasta.length) + fHasta.substring(0,2);

                var _fechaMin   = document.form1.cc_min_anio_mes.value ;
                var _fechaDesde = document.form1.cc_fecha_desde.value ;
                var _fechaMax   = document.form1.cc_max_anio_mes.value ;
                var _fechaHasta = document.form1.cc_fecha_hasta.value ;
                if (!(isValidarRangoFecha(_fechaMin, _fechaMax, _fechaDesde,_fechaHasta))) {
                    document.getElementById ('cc_fecha_desde').value =fDesde.substring(0,2) + "/" + fDesde.substring(2,fHasta.length);
                    document.getElementById ('cc_fecha_hasta').value =fHasta.substring(0,2) + "/" + fHasta.substring(2,fHasta.length);
                    return false;
                }
            } else{
               var fecha_ol = document.getElementById ('cc_fecha_ol').value ;
               if (fecha_ol == 'no informado') {
                   alert( "No hay fecha informada para poder realizar la consulta <<ON LINE>>.");
                   return false;
               } else {
                   var fecha = FormatFechaOnLine(fecha_ol);                   
                   document.form1.cc_fecha_ol_yyyymm.value  = fecha;
               }
               document.form1.opcion.value  = 'getCtasCtesOL';
            }

            var indice = 0;

            if (document.getElementById ('tipo_usuario').value == "0" ||
                 (document.getElementById ('tipo_usuario').value == "1" &&
                  Number (document.getElementById ('cod_usuario').value > 79999)) ) {
                indice = document.getElementById ('cc_cod_prod').selectedIndex;
                document.form1.cc_prod_desc.value =  document.getElementById ('cc_cod_prod').options[indice].text;
            }

            document.form1.action = "<%= Param.getAplicacion()%>servlet/CtaCteServlet";
            document.form1.submit();            
        }

        function isValidarRangoFecha(pFechaMin, pFechaMax,pFechaDesde,pFechaHasta) {

            // alert (" ( min   : " + pFechaMin + ") " + " <= "+ " ( desde : " + pFechaDesde  + ")");
            // alert (" ( max   : " + pFechaMax + ") " + " >= "+ " ( hasta : " + pFechaHasta  + ")");

            if ( pFechaDesde < pFechaMin  ) {
                alert ("La fecha desde solictada, no se puede procesar");
                return false;
            }
            if ( pFechaHasta > pFechaMax  ) {
                alert ("La fecha hasta solictada, no se puede procesar");
                return false;
            }
            return true;

        }

    function CambiarSelectProd ( accDir ) {
        var       i = 0;
        var bExiste = false;

        if ( (accDir.value == "" || accDir.value == "0")) {
            if (document.getElementById ('cc_cod_prod').value != "0") {
                document.getElementById ('cc_cod_prod').value = "0";
            }
            return true;
        } else {
            for (i = 0; i < document.getElementById ('cc_cod_prod').length; i++) {
                if (document.getElementById ('cc_cod_prod').options [i].value == accDir.value) {
                    bExiste = true;
                    break;
                }
            }
            if ( bExiste ) {
                document.getElementById ('cc_cod_prod').value = accDir.value;
                return true;
            } else {
                alert (" Código inexistente  !! ");
                accDir.value = "";
                return false;
            }
        }
    }

    </SCRIPT>
</head>
<body>
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
        <td valign="top" align="center">
            <form name="form1" id="form1" method="POST" action="<%= Param.getAplicacion()%>servlet/CtaCteServlet">
               <input type="hidden" name="opcion" id="opcion" value="getCtasCtesHIS"/>
               <input type="hidden" name="cc_1pri" id="cc_pri" value="S"/>
               <input type="hidden" name="volver" id="volver" value='formCtaCte'/>
               <input type="hidden" name="cc_max_anio_mes" id="cc_max_anio_mes" value="<%=String.valueOf(iAno)%><%=sMes%>"/>
               <input type="hidden" name="cc_min_anio_mes" id="cc_min_anio_mes" value="201101"/>
               <input type="hidden" name="cc_fecha_ol" id="cc_fecha_ol" value="<%=fechaMaxCtaCte%>" />
               <input type="hidden" name="cc_fecha_ol_yyyymm" id="cc_fecha_ol_yyyymm" value="" />
               <input type="hidden" name="cc_prod_desc" id="cc_prod_desc"
                      value="<%= usu.getsDesPersona() %>&nbsp;(<%= usu.getiCodProd()%>)" />
               <input type="hidden"  name="tipo_usuario" id="tipo_usuario" value="<%= usu.getiCodTipoUsuario()%>"/>
               <input type="hidden"  name="cod_usuario"  id="cod_usuario" value="<%= usu.getiCodProd()%>"/>
                <table width="700" border="0" align="center" cellspacing="4" cellpadding="2"
                       class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                    <tr>
                        <td height="30px" valign="middle" align="center" class='titulo'>CUENTA CORRIENTE</td>
                    </tr>
                    <tr>
                        <td align="center" valign="top" width="100%">
                            <table border='0' align="center" cellpadding='2' cellspacing='2'>

<%
    if (usu.getiCodTipoUsuario() == 0 || usu.getiCodProd () >= 80000) { 
%>
                                <tr>                                
                                    <td align="left" class="text"  >Productor:&nbsp;
                                        <select class='select' name="cc_cod_prod" id="cc_cod_prod">
<%
         LinkedList lProd = (LinkedList) session.getAttribute("Productores");
         for (int i= 0; i < lProd.size (); i++) {
             Usuario oProd = (Usuario) lProd.get(i);
             out.print("<option value='" + oProd.getiCodProd() + "' " + (oProd.getiCodProd() == usu.getiCodProd () ? "selected" : " ") + ">" + oProd.getsDesPersona() + " (" + oProd.getiCodProd() + ")</option>");
         }
%>
                                        </select>
                                    &nbsp;
                                    <LABEL>Cod : </LABEL>
                                    &nbsp;
                                    <INPUT name="prod_dir" id="prod_dir" value='0' size='10' maxlength='10'
                                           class='inputTextNumeric' onchange='CambiarSelectProd ( this );' onkeypress="" >
                                    </td>
                                </tr>
<%    } else {
    %>
                                <input type="hidden" name="cc_cod_prod" id="cc_cod_prod" value="<%= usu.getiCodProd() %>" >
<%
    }
%>                              <tr>
                                    <td align="left" class='text'>
                                        <input type="radio" value='HIS' name='cc_tipo' id='cc_tipo_his' onclick="CheckedHis();" checked>&nbsp;&nbsp;
                                            <b>Cuenta corriente histórica:</b> se refiere a la cuenta corriente cerrada mensual, de aquí usted puede obtener los saldos mensuales desde el periodo 01/2011 al último mes cerrado.<br><br>
                                            <b><span style="color:red">IMPORTANTE:</span>&nbsp;&uacute;ltimo cierre mensual disponible:&nbsp;<%= Fecha.showFechaForm(fechaMaxCtaCteHis ) %></b>
                                       </td>
                                </tr>                                  
                                <tr>
                                    <td  align="left"  valign="top" class="text">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ingrese mes/año desde (mm/yyyy):&nbsp;<input name="cc_fecha_desde" id="cc_fecha_desde" size="7" maxlength="7"
                                         onblur="ValidarFecha(this,'DESDE');" onkeypress="return Mascara('F',event);" value="<%= sMesAnio %>" >
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ingrese mes/año hasta (mm/yyyy): <input name="cc_fecha_hasta" id="cc_fecha_hasta" size="7" maxlength="7"
                                         onblur="ValidarFecha(this,'HASTA');" onkeypress="return Mascara('F',event);" value="<%= sMesAnio %>" >
                                    </td>
                                </tr>                                
                                <tr>
                                    <td align="left" class='text' >
                                        <input type="radio" value='ONL' name='cc_tipo' id='cc_tipo_onl' onclick="CheckedOL();">&nbsp;&nbsp;
                                            <b>Cuenta corriente On Line:</b> se refiere solo a la cuenta corriente del mes en curso actualizada al <b><i><%=fechaMaxCtaCte%></i></b>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <input type="button" name="cmdSalir" value=" Salir " height="20px" class="boton" onClick="Salir();">&nbsp;&nbsp;&nbsp;&nbsp;
                            <input type="button" name="cmdGrabar" value=" Enviar " height="20px" class="boton" onClick="Enviar();">
                        </td>
                    </tr>
                </table>
            </form>
        </td>
    </tr>
    <tr>
        <td valign="bottom" align="center">
            <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
   </tr>
</table>
<script>  
     CloseEspere();
</script>
</body>
</HTML>