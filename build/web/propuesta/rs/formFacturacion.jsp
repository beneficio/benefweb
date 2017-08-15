<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.beans.EntidadSobre"%>
<%@page import="com.business.beans.Facturacion"%>
<%@page import="com.business.beans.FormaPago"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>

<%
    StringBuffer sDescFacturacion = new StringBuffer();
    LinkedList lFact = new LinkedList ();
    LinkedList lfPagos = new LinkedList ();
    HtmlBuilder ohtml = new HtmlBuilder();
    Tablas oTabla = new Tablas();
    LinkedList lTabla = new LinkedList();
    LinkedList lEntidades = new LinkedList();

    int codRama      = (request.getParameter ("cod_rama")         == null ? 10 : Integer.parseInt (request.getParameter ("cod_rama")));
    int codSubRama   = (request.getParameter ("cod_sub_rama")     == null ? 0 : Integer.parseInt (request.getParameter ("cod_sub_rama")));
    int codProducto  = (request.getParameter ("cod_producto")== null ? 0 : Integer.parseInt (request.getParameter ("cod_producto")));
    int codFac       = (request.getParameter ("fac")         == null ? 1 : Integer.parseInt(request.getParameter ("fac")));
    int codVigencia  = (request.getParameter ("vig")         == null ? 0 : Integer.parseInt(request.getParameter ("vig")));
    int cantVidas    = (request.getParameter ("cantVidas")   == null ? 0 : Integer.parseInt(request.getParameter ("cantVidas")));
    int codPlan      = (request.getParameter ("cod_plan")    == null ? -1 : Integer.parseInt(request.getParameter ("cod_plan")));
    int cantCuotas   = (request.getParameter ("cant_cuotas")    == null ? 0 : Integer.parseInt(request.getParameter ("cant_cuotas")));
    int cantCuotasVig= (request.getParameter ("cant_cuotas_vig") == null ? 0 : Integer.parseInt(request.getParameter ("cant_cuotas_vig")));
    String tipoNomina= (request.getParameter ("tipo_nomina") == null ? "S" : request.getParameter ("tipo_nomina"));
    int numPropuesta = (request.getParameter ("num_propuesta")   == null ? 0 : Integer.parseInt(request.getParameter ("num_propuesta")));
    int codProd      = (request.getParameter ("cod_prod")   == null ? 0 : Integer.parseInt(request.getParameter ("cod_prod")));
    int formaPago    = (request.getParameter ("forma_pago")   == null ? 0 : Integer.parseInt(request.getParameter ("forma_pago")));
    String convenio = (request.getParameter ("convenio") == null ? "0" : request.getParameter ("convenio"));
    String nroTarjCred = (request.getParameter ("num_tarjeta") == null ? "" : request.getParameter ("num_tarjeta"));
    String CBU = (request.getParameter ("cbu") == null ? "" : request.getParameter ("cbu"));
    int codTarjeta = (request.getParameter ("cod_tarjeta")   == null ? 0 : Integer.parseInt(request.getParameter ("cod_tarjeta")));
    int codBcoCta = (request.getParameter ("cod_banco")   == null ? 0 : Integer.parseInt(request.getParameter ("cod_banco")));
    int numCotizacion= (request.getParameter ("num_cotizacion")   == null ? 0 : Integer.parseInt(request.getParameter ("num_cotizacion")));


//System.out.println ("formCondicionFactuacion: cotizacion " + numCotizacion + " fact " + codFac + " " + codRama + " " + codSubRama + " " +  codProducto + " "+ codProd + " " + formaPago + "  " +
//                   convenio + " " + nroTarjCred + " " + CBU + " " + codTarjeta + " " + codBcoCta + " " + cantCuotas + " " + cantCuotasVig +  " " + codPlan);

    if (codSubRama > 0 && codProducto > 0)  {
        Connection dbCon = null;
        try {
            dbCon = db.getConnection();
            
            if (numCotizacion == 0 ) { 
                lFact    = ConsultaMaestros.getAllCondFacturacion (dbCon, codRama, codSubRama, codProducto, codVigencia, codPlan, codProd, cantVidas );
            } else {
                lFact    = ConsultaMaestros.cotGetAllFacturacion(dbCon, codRama, codSubRama, numCotizacion);
            }
            
            lfPagos  = ConsultaMaestros.getAllFormaPago (dbCon, codRama, codSubRama, codProducto, codPlan, codProd );
            lEntidades = ConsultaMaestros.getEntidadSobre (dbCon, codProd );

            if ( formaPago > 0 ) {
                boolean bExiste = false;
                for (int i=0; i < lfPagos.size(); i++) {
                    FormaPago of = (FormaPago) lfPagos.get(i);
                    if (of.getCodigo() == formaPago) {
                        bExiste = true;
                        break;
                    }
                }
                if ( ! bExiste ) {
                    formaPago   = 0;
                    convenio    = "";
                    nroTarjCred = "";
                    CBU         = "";
                    codTarjeta  = 0;
                    codBcoCta   = 0;
                }
            }

        } catch (Exception e) {
            throw new SurException(e.getMessage());
        } finally {
             db.cerrar(dbCon);
        }
    }

   %>
<head><title>Cotizador AP</title>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>css/Tablas.css"/>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/alttxt.js"></script>
<script type="text/javascript" language="JavaScript">
    var navegador =  BrowserDetect.browser;
    var aDesdeFact = new Array (<%= lFact.size() + 1%>);
    var aHastaFact = new Array (<%= lFact.size() + 1%>);
    var aCodFact   = new Array (<%= lFact.size() + 1%>);
    var aCuotas    = new Array (<%= lFact.size() + 1%>);
    var aFPagosCod  = new Array (<%= lfPagos.size() + 1%>);
    var aFPagosTrat = new Array (<%= lfPagos.size() + 1%>);
    var codPlan    = <%= codPlan %>;

    function SetearFacturacion () {
        for (ii = 1; ii <= aCodFact.length ;ii++) {
            if ( parseInt (document.formFact.prop_fac.value) ===  aCodFact [ii] ) {
                document.getElementById ('prop_cant_max_cuotas').value =  aCuotas [ii];
                break;
            }
        }

        if (parseInt (document.getElementById ('prop_cant_max_cuotas').value) == 0) {
            switch (  parseInt (document.formFact.prop_fac.value) ) {
                case 1 : document.getElementById ('prop_cant_max_cuotas').value = 1;
                break;
                case 2 : document.getElementById ('prop_cant_max_cuotas').value = 2;
                break;
                case 3 : document.getElementById ('prop_cant_max_cuotas').value = 3;
                break;
                case 4 : document.getElementById ('prop_cant_max_cuotas').value = 4;
                break;
                case 5 : document.getElementById ('prop_cant_max_cuotas').value = 5;
                break;
                case 6 : document.getElementById ('prop_cant_max_cuotas').value = 10;
                break;
                default: document.getElementById ('prop_cant_max_cuotas').value = 1;
            }
        }

      //  if (parseInt (document.getElementById('num_propuesta').value) == 0){
      //      document.getElementById ('prop_cant_cuotas').value =
      //          document.getElementById ('prop_cant_max_cuotas').value;
      //  }

    if ( parseInt (document.getElementById ('prop_cant_max_cuotas').value) <
         parseInt (document.getElementById ('prop_cant_cuotas').value) || 
         parseInt (document.getElementById ('prop_cant_max_cuotas').value) === 0) {
         document.getElementById ('prop_cant_cuotas').value = 
             document.getElementById ('prop_cant_max_cuotas').value;
         }

     var ok = 0;
     if (document.getElementById('prop_tipo_nomina').value == 'S') {
//  if (parseInt(codPlan) <= 0) {
// validar la facturación segun la cantidad de asegurados  -- prop_fac pinolux

         for (i = 1; i <= aCodFact.length ;i++) {
             if ( parseInt (document.getElementById('prop_fac').value) ==  aCodFact [i] ) {
                 if ( parseInt (document.getElementById('prop_cantVidas').value) > 0 &&
                      parseInt (document.getElementById('prop_cantVidas').value) >= aDesdeFact [i]) {
                      ok = 1;
                      break;
                 }
             }
          }
     } else {
        ok = 1;
     }
     if (ok == 1) {
            if (navegador == 'Mozilla' || navegador == 'Firefox') {
              window.parent.DoChangeFact ();
            } else {
               window.parent.DoChangeFact (document.getElementById ('formFact'));
            }
            return true;
      } else {
          if ( parseInt (document.getElementById ('prop_vig').value) > 0 &&
                parseInt (document.getElementById('prop_cantVidas').value) > 0) {
            alert (" Periodo de Facturación inválido. Modifique el periodo de facturación según tabla ");
            return document.getElementById('prop_fac').focus();
          }
     }

    }

    function validarCuotas () {
        if ( parseInt (document.getElementById ('prop_cant_max_cuotas').value) <
             parseInt (document.getElementById ('prop_cant_cuotas').value) ||
             parseInt (document.getElementById ('prop_cant_cuotas').value) == 0 ) {
             alert ("La cantidad de cuotas no debe superar el maximo para la facturación");
             document.getElementById ('prop_cant_cuotas').value =
                 document.getElementById ('prop_cant_max_cuotas').value;
             return document.formFact.prop_cant_cuotas.focus();
//             } else {
//                return true;
         }

        if (navegador == 'Mozilla' || navegador == 'Firefox') {
          window.parent.DoChangeFact ();
        } else {
           window.parent.DoChangeFact (document.getElementById ('formFact'));
        }
        return true;
    }

    function HabilitarDiv(divName) {

        document.getElementById('div_TARJETA').style.visibility = 'hidden';
        document.getElementById('div_CBU').style.visibility = 'hidden';
        document.getElementById('div_SOBRE').style.visibility = 'hidden';

         for (i = 0; i < aFPagosCod.length ;i++) {
             if ( divName  ===  aFPagosCod [i] ) {
                 if ( aFPagosTrat [i] === 'TARJETA' || aFPagosTrat [i] === 'CBU'  || aFPagosTrat [i] === 'SOBRE' ) {
                      document.getElementById('div_' + aFPagosTrat [i]).style.visibility = 'visible';
                      break;
                 }
             }
          }
    }

</script>
</head>
<form name="formFact" id="formFact"  method="POST">
    <input type="hidden" name="prop_tipo_nomina" id="prop_tipo_nomina" value="<%= tipoNomina%>"/>
    <input type="hidden" name="prop_cant_max_cuotas" id="prop_cant_max_cuotas" value="0"/>
    <input type="hidden" name="prop_cantVidas" id="prop_cantVidas" value="<%= cantVidas %>"/>
    <input type="hidden" name="num_propuesta" id="num_propuesta" value="<%= numPropuesta%>"/>
    <input type="hidden" name="prop_vig" id="prop_vig" value="<%= codVigencia%>"/>

    <table border='0' align='left' width="100%" cellpadding="1" cellspacing="1">
    <tr>
        <td class='text' valign="top" align="left" nowrap>&nbsp;Facturación:</td>
        <td class="text" valign="top" align="left" width="700px">
            <select name="prop_fac" id="prop_fac" class="select" style="width:350px;"
                    onblur="javascript:SetearFacturacion ();" >
<%              if ( lFact.size() > 0 ) {
                   for (int ii = 0; ii < lFact.size(); ii++) {
                        Facturacion oFact = (Facturacion) lFact.get(ii);
     %>
                <option value="<%= oFact.getcodFacturacion() %>" <%= (oFact.getcodFacturacion() == codFac ? "selected" : " ")%> ><%= oFact.getdescFacturacion()%></option>
<%                  }
                } else {
    %>

                <option value="<%= codVigencia %>" selected >Idem vigencia</option>
<%              }
    %>
            </select>
    &nbsp;&nbsp;
<%
      if (lFact.size() > 1 ) {
          if (tipoNomina.equals ("S")) {
               // sDescFacturacion.append("<span style='color:red;'>Condiciones de Facturación:<br></span><b>");
               sDescFacturacion.append("Condiciones de Facturación:<br>");
                StringBuffer sDescAux = new StringBuffer();

                        boolean bFirst = true;
                        for (int iii = 0; iii < lFact.size(); iii++) {
                            Facturacion oFact = (Facturacion) lFact.get(iii);
                            if (bFirst) {
                                bFirst = false;
                            } else {
                                sDescAux.append("/ ");
                            }

                            if ( oFact.getcantDesde() != 1 || oFact.getcantHasta() != 99999 ) {

                                sDescAux.append(oFact.getdescFacturacion());
                                sDescFacturacion.append("<b>&nbsp;&nbsp;- ");
                                sDescFacturacion.append(oFact.getcantDesde());
                                sDescFacturacion.append(" a ");
                                sDescFacturacion.append(oFact.getcantHasta());
                                sDescFacturacion.append(" asegurados: ");
                                sDescFacturacion.append(sDescAux.toString());
                                sDescFacturacion.append("</b><br>");
                             } else {
                                sDescFacturacion.delete(64, sDescFacturacion.length());;
                                sDescFacturacion.append("<b>&nbsp;&nbsp;- ");
                                sDescAux.append(oFact.getdescFacturacion());
                                sDescFacturacion.append(sDescAux.toString());
                                sDescFacturacion.append("<br>");
                            }
                        }
                    } 
     %>
     <%-- sDescFacturacion.append("</span>").toString()--%>
<%          }
%>
            &nbsp;&nbsp;&nbsp;
                    <img src="<%= Param.getAplicacion()%>images/pregunta1.gif"
                    onmouseover="writetxt('<%= (sDescFacturacion == null ? " " : sDescFacturacion.toString() )%>');" onmouseout="writetxt(0);"/>

        </td>
    </tr>
    <tr>
        <td  nowrap class='text' align="left">&nbsp;Cantidad de Cuotas:&nbsp;</td>
        <td  class='text' align="left"  >
            <input type="text" name="prop_cant_cuotas" id="prop_cant_cuotas"  size="10" maxleng="20" value="<%= cantCuotas %>"
                   onKeyPress="return Mascara('N',event);" class="inputTextNumeric" onchange="javascript:validarCuotas();"/>
        </td>
    </tr>
    <tr>
        <td  nowrap class='text' colspan="2" align="left">&nbsp;<span style="color:red;"><b>Nota:&nbsp;</b></span>
            <b>Se refiere a la cantidad de cuotas máxima para cada facturación</b>
        </td>
    </tr>
    <tr>
        <td  nowrap class='text' align="left">&nbsp;Forma de pago:&nbsp;</td>
        <td  class='text' align="left"  >
            <select name="prop_form_pago" id="prop_form_pago" class="select" onchange="HabilitarDiv(this.value);" style="width:350px;">
<%              if (formaPago == 0) {
    %>
                <option value="0" selected>Seleccione forma de pago</option>
<%              }
                if ( lfPagos.size() > 0 ) {
                   for (int ii = 0; ii < lfPagos.size(); ii++) {
                        FormaPago oF = (FormaPago) lfPagos.get(ii);
     %>
                <option value="<%= oF.getCodigo() %>" <%= (oF.getCodigo() == formaPago ? "selected" : " ")%> ><%= oF.getDescripcion()%></option>
<%                  }
                } else {
    %>

                <option value="5" selected >Cupones </option>
<%              }
    %>
            </select>
        </td>
    </tr>
    <!-- Comienzo divs -->
    <tr>
        <td width='100%' valign="top" height='100%' colspan="2" >
            <table align="left" border='0' cellpadding='0' cellspacing='0' width='100%' heigth="100%">
                <tr>
                    <td height='45px' width='100%' valign="top" align="left" nowrap>
                        <div name="div_TARJETA" id="div_TARJETA" style="VISIBILITY: hidden; POSITION: absolute;">
                            <table  align="left" style="MARGIN-LEFT: 5px">
                                <tr>
                                    <td nowrap class="text" width="40%" align="left">Tarjeta:&nbsp;
                                        <SELECT name="pro_TarCred"  id="pro_TarCred" style="WIDTH: 200px;" class="select">
                                            <OPTION value='0'>Seleccione Tarjeta de Cr&eacute;dito</OPTION>
                                            <%
                                                 lTabla = oTabla.getTarjetas();
                                                 out.println(ohtml.armarSelectTAG(lTabla, codTarjeta));
                                            %>
                                        </SELECT>
                                    </td>
                                        <td class="text" width="60%" align="left" >N&uacute;mero:&nbsp;<input type="text" id="pro_TarCredNro" name="pro_TarCredNro" maxlength="16" size="25"
                                        value="<%=nroTarjCred%>"  onKeyPress="return Mascara('N',event);" class="inputTextNumeric"/>
                                    </td>

                                </tr>
                                    <td class="text" align="left" colspan="2" valign="middle"><span style="color:red;">Importante:&nbsp;</span>
                                        Por favor remitir a la Compa&ntilde;ia el formulario de adhesi&oacute;n firmado por el tomador.&nbsp;En caso de
                                        no hacerlo,<br/> si el tomador desconoce el d&eacute;bito, usted ser&aacute; responsable por el mismo.&nbsp;
                                        <a href="/benef/files/manuales/Debito%20Banco%20Macro%20Bansud1.pdf" target="_blank">Haga clic aqui para bajar el formulario de D&eacute;bito por tarjeta</a>
                                    </td>
                                <tr>
                                </tr>
<%--
                                        <INPUT type="HIDDEN" name="pro_TarCredVto"  id="pro_TarCredVto" value="<%=fechaVtoTarjCred%>"  size="11" maxlength="10" onblur="validaFecha(this);" onkeypress="return Mascara('F',event);"   >
                                        <INPUT type="HIDDEN"  name="pro_TarCredCodSeguridad" id="pro_TarCredCodSeguridad" value="<%= (sCodSegTarjeta == null ? "" : sCodSegTarjeta)  %>"  size="7" maxlength='4'  >
                                        <INPUT type="HIDDEN" name="pro_TarCredTit" id="pro_TarCredTit" value="<%=titularTarj%>"  size="60" maxlength='150'  >
--%>
                            </table>
                        </div>
                        <div id="div_CBU" name="div_CBU" style="VISIBILITY: hidden; POSITION: absolute;">
                            <table border="0" align="left" style="MARGIN-LEFT: 5px">
                                <tr>
                                    <td  class="text" >CBU:</td>
                                    <td  align="left" nowrap><input type="text" name="pro_DebCtaCBU" id="pro_DebCtaCBU" value="<%=CBU%>"
                                                             size='35' maxlength='22' onkeypress="return Mascara('D',event);"
                                                             class="inputTextNumeric"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="text" align="left" colspan="2" valign="middle"><span style="color:red;">Importante:&nbsp;</span>
                                        Por favor remitir a la Compa&ntilde;ia el formulario de adhesi&oacute;n firmado por el tomador.&nbsp;En caso de
                                        no hacerlo,<br/> si el tomador desconoce el d&eacute;bito, usted ser&aacute; responsable por el mismo.&nbsp;
                                        <a href="/benef/files/manuales/Debito%20automatico%20CBU.pdf" target="_blank">Haga clic aqu&iacute; para bajar el formulario de D&eacute;bito por CBU</a>
                                    </td>
                                </tr>

                                                             <%--
                                     <input type="hidden" name="pro_CtaTit" id="pro_CtaTit" value="<%=titularCta%>"/>
                                                             --%>
                            </table>
                        </div>
                        <div id="div_SOBRE" name="div_SOBRE" style="VISIBILITY: hidden; POSITION: absolute;">
                            <table border="0" align="left" style="MARGIN-LEFT: 5px">
                                <tr>
                                    <td  class="text" nowrap width="50%" align="left" >Entidad a debitar:&nbsp;
                                        <select   name="pro_CtaBco"  id="pro_CtaBco" style="width:250px" class="select"  >
                                            <option value="0">Seleccione entidad</option>
<%
                                             for (int i=0; i< lEntidades.size();i++) {
                                                 EntidadSobre oEnt = (EntidadSobre) lEntidades.get (i);
    %>
                                            <option value="<%= oEnt.getcodigo() %>" <%= ( oEnt.getcodigo() == codBcoCta ? " selected " : " " )%>><%= oEnt.getdescripcion() %></option>
<%
                                             }
    %>
                                        </select>
<%
                                    for (int i=0; i< lEntidades.size();i++) {
                                        EntidadSobre oEnt = (EntidadSobre) lEntidades.get (i);
    %>
                                        <input type="hidden" name="sobre_mca_cuenta_<%= oEnt.getcodigo() %>" id="sobre_mca_cuenta_<%= oEnt.getcodigo() %>" value="<%= (oEnt.getmcaCuenta() == null ? "" : oEnt.getmcaCuenta()) %>"/>
                                        <input type="hidden" name="sobre_mca_convenio_<%= oEnt.getcodigo() %>" id="sobre_mca_convenio_<%= oEnt.getcodigo() %>" value="<%= (oEnt.getmcaConvenio() == null ? "" : oEnt.getmcaConvenio()) %>"/>
                                        <input type="hidden" name="sobre_size_cuenta_<%= oEnt.getcodigo()%>" id="sobre_size_cuenta_<%= oEnt.getcodigo()%>" value="<%= oEnt.getsizeCuenta() %>"/>
<%
                                     }
    %>

                                    </td>
                                    <td  class="text" align="left"  width="50%" nowrap>Nº de Cuenta:&nbsp;&nbsp;<input type="text" name="pro_cuenta_banco" id="pro_cuenta_banco" value="<%=CBU%>"
                                                     size='22' maxlength='16' onkeypress="return Mascara('D',event);" class="inputTextNumeric"/>
                                    &nbsp;&nbsp;Nº de Convenio (Solo Macro):&nbsp;<input type="text" name="pro_convenio" id="pro_convenio" value="<%=convenio %>"
                                                     size='5' maxlength='5' onkeypress="return Mascara('D',event);" class="inputTextNumeric"/>
                                    </td>
                                 </tr>
                            </table>
                        </div>
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
<%
if (lfPagos.size() > 0) {
    for (int iii = 0; iii < lfPagos.size(); iii++) {
        FormaPago oF = (FormaPago) lfPagos.get(iii);
%>
            aFPagosCod  [<%= iii%>] = "<%= oF.getCodigo() %>";
            aFPagosTrat [<%= iii%>] = "<%= oF.getTratamiento()%>";
<% }
 } else {
%>
            aFPagosCod  [0] = "5";
            aFPagosTrat [0] = "CUPON";
<% }

if (lFact.size() > 0) {
    for (int i = 1; i <= lFact.size(); i++) {
        Facturacion oFact = (Facturacion) lFact.get(i - 1);
%>
            aDesdeFact [<%= i%>] = <%= oFact.getcantDesde()%>;
            aHastaFact [<%= i%>] = <%= oFact.getcantHasta()%>;
            aCodFact   [<%= i%>] = <%= oFact.getcodFacturacion()%>;
            aCuotas    [<%= i%>] = <%= oFact.getcantCuotas()%>;
<% }
 } else {
%>
            aDesdeFact [1] = 0;
            aHastaFact [1] = 999999;
            aCodFact   [1] = <%= codVigencia%>;
            aCuotas    [1] = <%= cantCuotasVig %>;
<% }
    %>

var numCotizacion =  <%= numCotizacion %>;
for (i = 1; i <= aCodFact.length ;i++) {
    if ( parseInt (document.formFact.prop_fac.value)
        ==  aCodFact [i] ) {
        document.getElementById ('prop_cant_max_cuotas').value =  aCuotas [i];
        break;
    }
}
if (parseInt (document.getElementById('num_propuesta').value) == 0){
    if (numCotizacion == 0 || parseInt (document.getElementById ('prop_cant_cuotas').value) == 0) {
         document.getElementById ('prop_cant_cuotas').value =
             document.getElementById ('prop_cant_max_cuotas').value;
    }
}

HabilitarDiv (document.formFact.prop_form_pago.options[ document.formFact.prop_form_pago.selectedIndex ].value);
</script>