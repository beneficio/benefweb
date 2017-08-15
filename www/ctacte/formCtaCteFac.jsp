<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.CtaCteFac"%>
<%@page import="com.business.beans.Poliza"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>
<%@ taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg" %>
<%
    Usuario usu = (Usuario) session.getAttribute("user");
    int iCodProd    = Integer.parseInt(request.getParameter("cod_prod"));
    LinkedList lCtaCteFac = (LinkedList) request.getAttribute("ctactefac");
    Usuario oProdSelect = (Usuario) request.getAttribute ("productor");
    boolean bCuitValido = true;
    if (oProdSelect != null ) {
        bCuitValido = oProdSelect.getcuitValido(); 
    }
    
    String sPath = "&cod_prod=" + iCodProd + "&opcion=getCtaCteFac" ;

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); //Para declarar valores en nuevos objetos date, usa el mismo formato date que usaste al crear las fechas 
    Date date1 = null;
    if (usu.getiCodTipoUsuario() == 0) {
        date1 = sdf.parse("2014-09-30");
    } else {
        date1 = sdf.parse("2016-09-30");        
    }

    int secuencia = 0;
    boolean existeFactura = false;
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <SCRIPT language="javascript">
        function Salir () {
            if (document.getElementById("ce_origen").value !== "formResultCtaCteHis") {
                window.location.replace("<%= Param.getAplicacion()%>index.jsp");
            } else {
                document.form1.action = "<%= Param.getAplicacion()%>servlet/CtaCteServlet";
                document.form1.opcion.value  = 'selectCtaCte';
                document.form1.submit();
            }
            return true;
        }

        function Enviar () {

            document.form1.action = "<%= Param.getAplicacion()%>servlet/CtaCteServlet";
            document.form1.opcion.value = "getCtaCteFac";
            document.form1.submit();            
        }

        function Facturar () {
            
//            if ( document.getElementById ('tipo_usuario').value === "1") {
//                   alert ("Funci&oacute;n NO habilitada !!!");
//                   return false;
//            }
            
            if ( document.getElementById ('cant_registros').value === "0") {
                document.form1.action = "<%= Param.getAplicacion()%>servlet/CtaCteServlet";
                document.form1.opcion.value = "getCtaCteFac";
            } else { 
                var check  = 0;
                var indice =  parseInt (document.getElementById("secuencia").value);
                
                for(var i=1; i <= indice; i++) {
                    var sigte = i + 1;
                    var elemento = document.getElementById ( "check_" + i);
                    var elemento2 =  document.getElementById ( "check_" + sigte);
                    if (elemento.checked === true)  {
                        elemento.value = "S";
                        check = check + 1;
                    }
                    if(elemento.type === "checkbox" && elemento.checked === true && 
                        elemento2 && elemento2.type === "checkbox" && elemento2.checked === false ) {
                        if (document.getElementById ("tipo_usuario").value === "1") { 
                            alert ("Debe seleccionar a facturar del mes m&aacute;s antiguo al m&aacute;s reciente");
                            return elemento2.focus();
                        }
                    }
                }
                if (check === 0 ) {
                    alert ("Seleccione los cierres comisionarios que desea facturar ");
                    return elemento.focus ();
                }
                
                document.form1.action = "<%= Param.getAplicacion()%>servlet/OrdenPagoServlet";
                document.form1.opcion.value = "selectCtaCte";
            }
            document.form1.submit();    
            return true;
        }


    function verFactura ( numSecuOp ) {    
        document.form1.action = "<%= Param.getAplicacion()%>servlet/OrdenPagoServlet";
        document.form1.opcion.value = "getFactura";
        document.form1.num_secu_op.value = numSecuOp;
        document.form1.submit();    
        return true;
    }
    
    function CambiarSelectProd ( accDir ) {
        var       i = 0;
        var bExiste = false;

        if ( (accDir.value === "" || accDir.value === "0")) {
            if (document.getElementById ('cod_prod').value !== "0") {
                document.getElementById ('cod_prod').value = "0";
            }
            return true;
        } else {
            for (i = 0; i < document.getElementById ('cod_prod').length; i++) {
                if (document.getElementById ('cod_prod').options [i].value === accDir.value) {
                    bExiste = true;
                    break;
                }
            }
            if ( bExiste ) {
                document.getElementById ('cod_prod').value = accDir.value;
                return true;
            } else {
                alert (" C&oacute;digo inexistente  !! ");
                accDir.value = "";
                return false;
            }
        }
    }
    
    function AgregarCuit ( cuit, oper ) {

        document.form1.action = "<%= Param.getAplicacion()%>servlet/OrdenPagoServlet";
        document.form1.opcion.value = "addCuitAfip";
        document.form1.cuit.value = cuit;
        document.form1.operacion.value = oper;
        document.form1.submit();            
    }
    
    </SCRIPT>
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
               <input type="hidden" name="opcion"    id="opcion"      value="getCtaCteFac"/>
               <input type="hidden" name="ce_origen" id="ce_origen" value="<%=(request.getParameter("ce_origen") == null ? "" : request.getParameter("ce_origen"))%>"/>
               <input type="hidden" name="cant_registros" id="cant_registros" value="<%= lCtaCteFac.size() %>"/>
               <input type="hidden" name="num_secu_op" id="num_secu_op" value="0" />
               <input type="hidden" name="cuit_valido" id="cuit_valido" value="<%= (oProdSelect != null && oProdSelect.getcuitValido() == false ? "N" : "S") %>" />
               <input type="hidden" name="cuit" id="cuit" value="" />
               <input type="hidden" name="operacion" id="operacion" value="" />
               <input type="hidden" name="tipo_usuario" id="tipo_usuario" value="<%= usu.getiCodTipoUsuario() %>"/>
               

               <table width="100%" border="0" align="center" cellspacing="2" cellpadding="2" class="fondoForm" style="margin-top:5;margin-bottom:5;">
                    <tr>
                        <td height="30px" valign="middle" align="center" class="titulo">CUENTA CORRIENTE FACTURACION</td>
                    </tr>
                    <tr>
                        <td height="30px" valign="middle" align="left">
                            <span style="color:red;">IMPORTANTE: </span><span class="subtitulo">a partir del  cierre  de Septiembre 2016 se modificar&aacute; la forma de entregar la factura de comisiones, 
    haci&eacute;ndose a partir de ahora, por medio de la web. Este primer mes convivir&aacute;n los dos sistemas, pero a partir del cierre de Octubre, solo 
    quedar&aacute; el sistema autom&aacute;tico.</span><br/><br/>
<span  class="subtitulo">Que beneficio obtiene usted con este nuevo servicio ?</span><br/><br/>
<span  class="textogriz">Agilizar nuestro circuito de pago, lo que va representar que usted tenga disponible el cobro de sus comisiones con mayor celeridad.</span><br/><br/>
<span  class="subtitulo">Como ingreso la factura ?</span><br/><br/>
<span  class="textogriz">Primero tiene que consultar el importe a facturar y emitir la factura correspondiente:<br/> 
&nbsp;&nbsp;&nbsp;- Si la emisi&oacute;n es manual, deber&iacute;a escanear la factura en formato PDF (recomendable) o JPG y luego el Original hacerlo llegar a la Empresa.<br/>
&nbsp;&nbsp;&nbsp;- Si utiliza Factura Electr&oacute;nica, deber&aacute; adjuntar el PDF con la misma, no siendo necesaria la entrega del original.<br/><br/>
Luego de emitirla ingrese a nuestra web desde la opci&oacute;n de men&uacute; Cobranza&nbsp;&rArr;&nbsp;Comisiones a fact.</span> <br/>
<span  class="textogriz">En la columna Facturar tiene que seleccionar el  periodo a facturar.  Solo podr&aacute; ingresar facturas del periodo Septiembre 2016 en adelante,  periodos anteriores  deber&aacute; hacerlo de la forma habitual.</span><br/>
                        </td>
                    </tr>
                   
<%              if (oProdSelect != null && bCuitValido == false) { 
    %>                  
                    <tr>
                        <td class="subtitulo" valign="middle">
                            <span style="color:red">IMPORTANTE:</span>&nbsp;
                        Usted podr&aacute; ingresar la orden de pago desde aqu&iacute; pero la misma permanecer&aacute; pendiente 
                        hasta que regularice la situaci&oacute;n de su CUIT con AFIP 

<%                  if ( usu.getiCodTipoUsuario() == 0 ) { 
    %>
                         <input type="button" name="cmdAgregar" value=" Agregar a la n&oacute;mina de AFIP " height="20px" class="boton" onClick="javascript:AgregarCuit ('<%= oProdSelect.getCuit() %>','ALTA');"/>
<%                  }
    %>
                        </td>
                    </tr>
<%              }  
                if ( oProdSelect != null && iCodProd != 0 && bCuitValido == true && usu.getiCodTipoUsuario() == 0 ) { 
    %>                  
                    <tr>
                        <td>
                            <input type="button" name="cmdEliminar" value=" Eliminar el Cuit de la n&oacute;mina de AFIP " height="20px" class="boton" onClick="javascript:AgregarCuit ('<%= oProdSelect.getCuit() %>', 'BAJA');"/>
                        </td>
                    </tr>     
<%              } 
    %>
                    <tr>
                        <td align="center" valign="top" width="100%">
                            <table border='0' align="center" cellpadding='2' cellspacing='2'>

<%
    if (usu.getiCodTipoUsuario() == 0 || usu.getiCodProd () >= 80000) { 
%>
                                <tr>                                
                                    <td align="left" class="text">Productor:&nbsp;
                                        <select class='select' name="cod_prod" id="cod_prod">
<%
         LinkedList lProd = (LinkedList) session.getAttribute("Productores");
         for (int i= 0; i < lProd.size (); i++) {
             Usuario oProd = (Usuario) lProd.get(i);
                 out.print("<option value='" + oProd.getiCodProd() + "' " + (oProd.getiCodProd() == (iCodProd > 0 ? iCodProd : usu.getiCodProd () ) ? "selected" : " ") +
                                            ">" + oProd.getsDesPersona() + " (" + oProd.getiCodProd() + ")</option>");
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
                                <input type="hidden" name="cod_prod" id="cod_prod" value="<%= (iCodProd > 0 ? iCodProd : usu.getiCodProd()) %>" >
<%
    }
%>
                            </table>
                        </td>
                    </tr>
<%          if (lCtaCteFac == null || lCtaCteFac.size() == 0) {
                if (iCodProd > 0 ) {
    %>
    <tr>
        <td class="subtitulo">
            <span style="color:red">No existe informaci&oacute;n disponible para el productor<br>
        </td>
    </tr>
<%              }
            } else {
    %>
                    <TR>
                        <td valign="top"  width='100%'>
                            <pg:pager maxPageItems="30" items="<%= lCtaCteFac.size() %>" url="/benef/servlet/CtaCteServlet"
                            maxIndexPages="20" export="currentPageNumber=pageNumber"  index="half-full">
                            <pg:param name="keywords"/>
                            <table  border="1" cellspacing="0" cellpadding="2" align="center" class="TablasBody" >
                                <thead>
                                    <th width='20px' nowrap align="center">Cod.Prod</th>
                                    <th width='20px' nowrap align="center">Fecha</th>
                                    <th width='20px' nowrap align="center">Estado</th>
                                    <th  width="30px" nowrap align="center">Concepto</th>
                                    <th  width="70px" nowrap align="center">Comisiones<br>a facturar</th>
                                    <th width="60px" nowrap align="center">Iva</th>
                                    <th  width="70px" nowrap align="center">Total de<br>factura</th>
                                    <th  width="70px" nowrap align="center">Importe<br>neto</th>
                                    <th  width="50px" nowrap align="center">Orden<br>Pago</th>
                                    <th  width="120px" nowrap align="center">Comprobante</th>
                                    <th  nowrap align="center">Facturar</th>
                                </thead>
                               <% if (lCtaCteFac.size()  == 0 ){%>
                                <tr>
                                    <td colspan="11" height='25' valign="middle"><span style="color:red">No existen informaci&oacute; para el productor</span></td>
                                </tr>
    <%                         }
                               for (int i=0; i < lCtaCteFac.size(); i++)  {
                                   CtaCteFac oCC = (CtaCteFac) lCtaCteFac.get(i);
                                   if ( oCC.getOperacion().equals("D") && ! oCC.getestado().equals ("A") && usu.getiCodTipoUsuario() == 1 && oCC.getNumSecuOp() == 0 ) {
                                       existeFactura = true;
                                   }
        %>
        
                              <pg:item>
                                <tr>
                                    <td align="center" class="text" <%= (oCC.getestado().equals("A") ? "style='text-decoration: line-through;'" : oCC.getOperacion().equals("D") ? "style='color:green'" : " ")%>><%= oCC.getCodProdDc()%></td>
                                    <td align="center" class="text" <%= (oCC.getestado().equals("A") ? "style='text-decoration: line-through;'" :oCC.getOperacion().equals("D") ? "style='color:green'" : " ")%>><%= Fecha.showFechaForm(oCC.getfechaFactura()) %></td>
                                    <td align="center" class="text" <%= (oCC.getOperacion().equals("D") ? "style='color:green'" : " ")%>><%= (oCC.getOperacion().equals("D") ? (oCC.getestadoPago() != null && oCC.getestadoPago().equals("PEN") ? "OP.Pendiente":"OP.Pagada" ) : "&nbsp;") %></td>
                                    <td align="center" class="text" <%= (oCC.getOperacion().equals("D") ? "style='color:green'" : "style='color:red'")%>><%= (oCC.getOperacion().equals("D") ? "D&eacute;bito" : "Cr&eacute;dito") %></td>                                    
                                    <td align="right" class="text" <%= (oCC.getestado().equals("A") ? "style='text-decoration: line-through;'" : oCC.getOperacion().equals("D") ? "style='color:green'" : " ")%>><%= Dbl.DbltoStr(oCC.getImporte(), 2) %></td>
                                    <td align="right" class="text" <%= (oCC.getestado().equals("A") ? "style='text-decoration: line-through;'" : oCC.getOperacion().equals("D") ? "style='color:green'" : " ")%>><%= Dbl.DbltoStr(oCC.getimpIva(), 2)%></td>
                                    <td align="right" class="text" <%= (oCC.getOperacion().equals("D") ? "style='color:green'" : "style='color:red'")%>><%= Dbl.DbltoStr(oCC.getimpFactura(), 2)%></td>
                                    <td align="right" class="text" <%= (oCC.getestado().equals("A") ? "style='text-decoration: line-through;'" : oCC.getOperacion().equals("D") ? "style='color:green'" : "style='color:red'")%>><%= (oCC.getOperacion().equals("D") ? Dbl.DbltoStr(oCC.getImporte(), 2):"&nbsp;")%></td>
                                    <td align="center" class="text" <%= (oCC.getOperacion().equals("D") ? "style='color:green'" : " ")%>><%= (oCC.getnumOrden() == 0 ? "&nbsp;" : oCC.getnumOrden()) %></td>
                                    <td nowrap align="center" class="text" <%= (oCC.getestado().equals("A") ? "style='text-decoration: line-through;'" : "style='color:green'")%>>
<%                        if ( oCC.getNumSecuOp() > 0 && oCC.getFechaMov().compareTo(date1) >= 0 ) {     
        %> 
        <a href="#" onclick="javascript:verFactura(<%= oCC.getNumSecuOp() %>);">
<%= (oCC.getnumComprob2() == null ? "Factura s/n&uacute;mero" :
                                    oCC.gettipoComprob() + "-" + oCC.getnumComprob1()+ "-" + oCC.getnumComprob2()) %>            
        </a>
<%                        } else { 
    %>
                                        
                                        <%= (oCC.getnumComprob2() == null ? "&nbsp;" :
                                    oCC.gettipoComprob() + "-" + oCC.getnumComprob1()+ "-" + oCC.getnumComprob2()) %>
<%                        }
    %>
                                    </td>
                                    <td align="center">&nbsp;
<%                        if ( oCC.getOperacion().equals("C") && 
                               ( oCC.getNumSecuOp() == 0 || (oCC.getNumSecuOp() > 0 && oCC.getcodEstadoOP() == 9 )) &&  
                               oCC.getFechaMov().compareTo(date1) >= 0 && 
                               existeFactura == false ) {
                                    secuencia += 1;  
    %>
        
                                    <input type="checkbox" name="numsecuop_<%= oCC.getanioMes() %>_<%= oCC.getCodProdDc() %>" 
                                                              id="check_<%= secuencia %>" value="N"/> 
                                    <input type="hidden" name="impneto_<%= oCC.getanioMes() %>_<%= oCC.getCodProdDc() %>" 
                                           id="impneto_<%= oCC.getanioMes() %>_<%= oCC.getCodProdDc() %>" value="<%= Dbl.DbltoStr(oCC.getImporte(),2) %>"/>
                                    <input type="hidden" name="impiva_<%= oCC.getanioMes() %>_<%= oCC.getCodProdDc() %>" 
                                           id="impiva_<%= oCC.getanioMes() %>_<%= oCC.getCodProdDc() %>" value="<%= Dbl.DbltoStr(oCC.getimpIva(),2) %>"/>
                                    <input type="hidden" name="impbruto_<%= oCC.getanioMes() %>_<%= oCC.getCodProdDc() %>" 
                                           id="impbruto_<%= oCC.getanioMes() %>_<%= oCC.getCodProdDc() %>" value="<%= Dbl.DbltoStr(oCC.getimpTotal(),2) %>"/>

<%                         }
    %>
                                    </td>
                                </tr>
                            </pg:item>
    <%                          }
        %>
                                 <thead>
                                    <th colspan="11">
                                        <pg:prev>   
                                          <a href="${pageUrl }" class="rnavLink">P&aacute;gina anterior</a>   
                                        </pg:prev>                              
                                        <pg:pages>
                                   <% if (pageNumber == currentPageNumber) { %>
                                        <b><%= pageNumber %></b>
                                   <% } else { %>
                                        <a class="rnavLink" href="<%= pageUrl %><%= sPath %>"><%= pageNumber %></a>
                                   <% } %>
                                        </pg:pages>
                                        <pg:next>
                                        <a class="rnavLink" href="<%= pageUrl %><%= sPath %>">[Siguiente]</a>
                                        </pg:next>
                                    </th>
                                </thead>
                            </table>
                        </pg:pager>
                        </td>
                   </tr>
<%      }
    %>
                <input type="hidden" name="secuencia" id="secuencia" value="<%= secuencia %>"/>
                    <tr>
                       <td class="subtitulo" valign="middle">
                           <span style="color:red">Referencias:</span>&nbsp;
                           El importe resaltado en <span style="color:red;font-weight: bold">rojo</span> es el monto a facturar y la fila en <span style="color:green; font-weight: bold">verde</span> son las facturas emitidas.<br>
                           Las filas tachadas son registros anulados.
                       </td>
                   </tr>
                    <tr>
                        <td align="center">
                            <input type="button" name="cmdSalir" value=" Salir " height="20px" class="boton" onClick="Salir();"/>&nbsp;&nbsp;&nbsp;&nbsp;
                            <input type="button" name="cmdGrabar" value=" Buscar " height="20px" class="boton" onClick="Enviar();"/>&nbsp;&nbsp;&nbsp;&nbsp;
                            <input type="button" name="cmdFact" value=" Facturar " height="20px" class="boton" onClick="Facturar();"/>
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