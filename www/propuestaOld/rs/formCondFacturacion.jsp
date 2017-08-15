<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.beans.Facturacion"%>
<%@page import="java.util.LinkedList"%>
<% 
    StringBuffer sDescFacturacion = new StringBuffer();
    String descFac = "Sin informar";
    LinkedList lFact = new LinkedList ();
    
    int codRama      = (request.getParameter ("cod_rama")         == null ? 10 : Integer.parseInt (request.getParameter ("cod_rama")));
    int codSubRama   = (request.getParameter ("cod_sub_rama")     == null ? 2 : Integer.parseInt (request.getParameter ("cod_sub_rama")));
    int codFac       = (request.getParameter ("prop_fac")         == null ? 1 : Integer.parseInt(request.getParameter ("prop_fac")));
    int cantVidas    = (request.getParameter ("prop_cantVidas")   == null ? 0 : Integer.parseInt(request.getParameter ("prop_cantVidas")));
    int codPlan      = (request.getParameter ("prop_cod_plan")    == null ? -1 : Integer.parseInt(request.getParameter ("prop_cod_plan")));
    String tipoNomina   = (request.getParameter ("prop_tipo_nomina") == null ? "S" : request.getParameter ("prop_tipo_nomina"));

    if (codPlan <= 0 ) {
        lFact = ConsultaMaestros.getAllCondFacturacion(codRama, (codSubRama == -1 ? 2 : codSubRama));
    }
    System.out.println ("formCondicionFactuacion" + codRama + " " + " " + codSubRama + " " + codFac + " " + tipoNomina);
   %>
<html>
<head><title>Cotizador AP</title>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css">
<link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>css/Tablas.css">
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript">
    var navegador = navigator.appCodeName;
    var aDesdeFact = new Array (<%= lFact.size()%>);
    var aHastaFact = new Array (<%= lFact.size()%>);
    var aCodFact   = new Array (<%= lFact.size()%>);
    var codPlan    = <%= codPlan %>;

    function SetearFacturacion () {
        if ( document.getElementById('prop_tipo_nomina').value == 'S' &&
            ( document.getElementById('prop_cantVidas').value == "0"  ||
            document.getElementById('prop_cantVidas').value == "" )) {
            alert (" Debe ingresar la cantidad de asegurados de la nómina ");
            return document.getElementById('prop_cantVidas').focus();
        }  else {
            if (document.getElementById('prop_tipo_nomina').value == 'S') {
               var ok = 0;
               if (parseInt(codPlan) <= 0) {
                // validar la facturación segun la cantidad de asegurados  -- prop_fac pinolux

                    for (i = 1; i <= aCodFact.length ;i++) {
                        if ( parseInt (document.getElementById('prop_fac').value) ==  aCodFact [i] ) {
                            if ( parseInt (document.getElementById('prop_cantVidas').value) >= aDesdeFact [i]) {
                                ok = 1;
                                break;
                            }
                        }
                    }
                } else { ok = 1;}

                if (ok == 1) {
                    if (navegador == 'Mozilla') {
                      window.parent.DoChangeFact ();
                    } else {
                       window.parent.DoChangeFact (document.getElementById ('formFact'));
                    }
                    return true;
                } else {
                    alert (" Periodo de Facturación inválido. Modifique el periodo de facturación según tabla ");
                    return document.getElementById('prop_fac').focus();
                }
            }
        }
    }
</script>
</head>
<body>
<form name="formFact" id="formFact"  method="POST">
    <input type="hidden" name="prop_tipo_nomina" id="prop_tipo_nomina" value="<%= tipoNomina%>">
    <table border='0' align='left' class="fondoForm" width="100%" height="100%" >
    <tr>
        <td width='15' >&nbsp;</td>
<%      if(tipoNomina.equals ("S")) {
    %>
        <td class="text" align="left" width="130px">Cantidad de asegurados:</td>
        <td class="text" align="left" >
            <input type="text" name="prop_cantVidas" id="prop_cantVidas"
                   value="<%= cantVidas %>" size="5" maxlength="3"
                   onKeyPress="return Mascara('D',event);"
                   class="inputTextNumeric"
                   onblur="javascript:SetearFacturacion ();">
        </td>
<%      } else {
    %>
    <td colspan="2">&nbsp;<input type="hidden" name="prop_cantVidas" id="prop_cantVidas" value="0"></td>
<%      }
    %>
        <td rowspan="2" class='text' height="100%">
<%              if (tipoNomina.equals ("S")) {
                       sDescFacturacion.append("<span style='color:red;'>Condiciones de Facturación:<br></span><b>");
                            StringBuffer sDescAux = new StringBuffer();

                            if (codPlan > 0 ) {
                                sDescFacturacion.append("Para planes especiales la <br>factuación es igual a la vigencia");
                            } else {
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
                                            sDescFacturacion.append("<b>- ");
                                            sDescFacturacion.append(oFact.getcantDesde());
                                            sDescFacturacion.append(" a ");
                                            sDescFacturacion.append(oFact.getcantHasta());
                                            sDescFacturacion.append(" asegurados: ");
                                            sDescFacturacion.append(sDescAux.toString());
                                            sDescFacturacion.append("</b><br>");
                                         } else {
                                            sDescFacturacion.delete(64, sDescFacturacion.length());;
                                            sDescFacturacion.append("<b>- ");
                                            sDescAux.append(oFact.getdescFacturacion());
                                            sDescFacturacion.append(sDescAux.toString());
                                            sDescFacturacion.append("</b><br>");
                                        }
                                    }
                               }
                 %>
                <%= sDescFacturacion.toString()%>
<%          }
    %>
        </td>   
    </tr>
    <tr>
        <td width='15'>&nbsp;</td>
        <TD class='text'>Periodo de Facturación:</TD>
        <td class='text'>
            <SELECT name="prop_fac" id="prop_fac" class="select" STYLE="WIDTH:120px;"
                    onblur="javascript:SetearFacturacion ();" >
<%           if (codPlan > 0 ) {
                  switch ( codFac ) {
                  case 1:
                    descFac = "Mensual";
                    break;
                  case 2:
                    descFac = "Bimestral";
                    break;
                  case 3:
                    descFac = "Trimestral";
                    break;
                  case 4:
                    descFac = "Cuatrimestral";
                    break;
                  case 5:
                    descFac = "Semestral";
                    break;
                  case 6:
                    descFac = "Anual";
                    break;
                  default:
                    descFac = "Sin informar";
                  }
   %>
                <option value="<%= codFac%>"  selected><%= descFac %></option>
 <%           } else {
                   for (int ii = 0; ii < lFact.size(); ii++) {
                        Facturacion oFact = (Facturacion) lFact.get(ii);
        %>
                <option value="<%= oFact.getcodFacturacion()%>" <%= (oFact.getcodFacturacion() == codFac ? "selected" : " ")%> ><%= oFact.getdescFacturacion()%></option>
                <%          }
              }
                %>
            </SELECT>
        </td>
    </tr>
</table>
</form>
<script>
<%
for (int i = 1; i <= lFact.size(); i++) {
    Facturacion oFact = (Facturacion) lFact.get(i - 1);
%>
    aDesdeFact [<%= i%>] = <%= oFact.getcantDesde()%>;
    aHastaFact [<%= i%>] = <%= oFact.getcantHasta()%>;
    aCodFact   [<%= i%>] = <%= oFact.getcodFacturacion()%>;
<%
 }
%>
</script>
</body>
</html>