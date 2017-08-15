<%@page contentType="text/html"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.*"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.text.*"%>
<%  Usuario oUser               = (Usuario) session.getAttribute("user");

    CotizadorAp oCot           = (CotizadorAp) request.getAttribute("cotizador");
    String sMsgCuotas;
    
    //si la cuota es menor a $30
//    sMsgCuotas = "En "+ oCot.getcantCuotas()+" cuotas de $"+ Dbl.DbltoStr((float)oCot.getpremio()/(float)oCot.getcantCuotas(),2);
    sMsgCuotas = "En "+ oCot.getcantCuotas()+" cuotas de $"+ Dbl.DbltoStr(oCot.getvalorCuota() ,2);

    %>
<html>
    <head>
        <title>Cotizacion</title>
        <link rel="STYLESHEET" type="text/css" href="<%= Param.getAplicacion()%>css/reports.css">
    </head>
<body leftmargin=0 topmargin=0 style="margin-top: 0; margin-right: 0; margin-left: 0; margin-bottom: 0; padding-bottom: 0; padding-left: 0; padding-right: 0; padding-top: 0; top: 0; vertical-align: top;">
    <TABLE align="center" width='100%' border='1' cellpadding='0' cellspacing='6' >
        <tr>
            <td width='100%' height='60'>
                <table border='0' cellpadding='2' cellspacing='0' width='100%'>
                    <tr>
                        <td width='50%' valign="top" align="left"><img src="<%= Param.getAplicacion()%>images/logos/logo_beneficio_new.jpg"  border='0'></td>
                        <td width='50%' valign="middle" align="center" class='titulos'>COTIZACI&Oacute;N
<% if ( oCot.getabm().equals("S")){  %>
                        DE PRUEBA
<% }%>
                        </td>
                    </tr>
                    <tr>
                        <td  valign="top" align="left" class="valor">COTIZADO POR:&nbsp;<%= oCot.getdescUsu()%></td>
 <% if (! oCot.getabm().equals("S")){  %>
                        <td  valign="top" align="left" class="valor">PRODUCTOR:&nbsp;<%= oCot.getdescProd()%>(<%= oCot.getcodProd()%>) </td>

 <% }  else {  %>
                       <td>&nbsp;</td>
 <% } %>
                    </tr>
                    <tr>
                        <td valign="middle" align="left" class='campo'>OPERACI&Oacute;N NRO:&nbsp;<%= oCot.getnumCotizacion() %></td>
                        <td valign="middle" align="left" class='campo'>FECHA:&nbsp;<%= oCot.getfechaCotizacion() %></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td width='100%'>
                <table border='0' cellpadding='0' cellspacing='4' width='100%'>
                    <tr>
                        <td width='100%' valign="middle" align="center" class='SubTitulos'>COTIZACI&Oacute;N DE <%= oCot.getdescRama().toUpperCase() %></td>
                    </tr>
<%  if (oCot.getsubTotal() == 0) {
    %>
                    <tr>
                        <td width='100%' valign="middle" align="center" class='campoBold'><spam style='color:red'>RIESGO NO COTIZABLE - CONTACTESE CON SU REPRESENTANTE COMERCIAL</spam></td>
                    </tr>
<%  } else {
    %>
                    <tr>
                        <td width='100%' valign="middle" align="center">&nbsp;</td>
                    </tr>
 <% }
    if (! oCot.getabm().equals("S")){  %>
                    <tr>
                        <td width='100%' valign="middle" align="center" class='SubTitulos'>Presentado a:</td>
                    </tr>
                    <tr>
                        <td width='100%'>
                            <table border='0' cellspacing='0' cellpadding='2' width='100%'>
                                <col width='170px'>
                                <col width=''>
                                <tr>
                                    <td class='valor'>Tomador:</td>
                                    <td class='campo'><%= oCot.gettomadorApe ()%></td>
                                </tr>
                                <tr>
                                    <td class='valor'>Descripci&oacute;n Tareas:</td>
                                    <td class='campo'><%= oCot.getdescActividad()%>
<%                      if (oCot.getcodActividadSec() != 0) {
    %>
                               &nbsp;-&nbsp;Actividad Secundaria:&nbsp;<%= oCot.getdescActividadSec()%>
<%                      }
    %>
                                    </td>
                                </tr>
                                <tr>
                                    <td class='valor'>Telefono:</td>
                                    <td class='campo'><%= (oCot.gettomadorTel () == null ? " " : oCot.gettomadorTel ())%></td>
                                </tr>
                                <tr>
                                    <td class='valor'>Cond I.V.A:</td>
                                    <td class='campo'><%= (oCot.gettomadorDescIva () == null ? " " : oCot.gettomadorDescIva ()) %></td>
                                </tr>
<%        if (oCot.getsDescOpcion() != null ) {
    %>
                                <tr>
                                    <td class='valor'>Opcional:</td>
                                    <td class='campo'><%= oCot.getsDescOpcion() %></td>
                                </tr>
<%      }
    %>
                            </table>
                        </td>
                    </tr>
 <% } else { %>
                                <tr>
                                    <td class='campo'><%= oCot.getdescActividad()%></td>
                                </tr>
<%                      if (oCot.getcodActividadSec() != 0) {
    %>
                                <tr>
                                    <td class='campo'>Actividad Secundaria:&nbsp;<%= oCot.getdescActividadSec()%></td>
                                </tr>
<%                      }
    %>
<%     } %>
                    <tr>
                        <td width='100%' valign="middle" align="center">&nbsp;</td>
                    </tr>

                    <tr>
                        <td width='100%'>
                            <table border='0' cellspacing='0' cellpadding='2' width='100%'>
                            <col width='50%'>
                            <col width='50%'>
                            <tr>
                              <td valign='top'>
                                <table border='0' cellspacing='4' cellpadding='2' width='100%'>
                                    <col width='130px'>
                                    <col width=''>
                                    <tr>
                                        <td colspan='2' width='100%' valign="middle" align="center" class='SubTitulos'>Caracter&iacute;sticas del seguro</td>
                                    </tr>
                                    <tr>
                                        <td colspan='2' width='100%' valign="middle" align="center">&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td class='valor'>Ubicaci&oacute;n del Tomador:</td>
                                        <td class='campo'><%= oCot.getdescProvincia ()%></td>
                                    </tr>
                                    <tr>
                                        <td class='valor'>Modalidad:</td>
                                        <td class='campo'><%= oCot.getdescAmbito ()%></td>
                                    </tr>
                                    <tr>
                                        <td class='valor'>Vigencia:</td>
                                        <td class='campo'><%= oCot.getdescVigencia ()%></td>
                                    </tr>
                                    <tr>
                                        <td class='valor'>Cantidad de Vidas:</td>
                                        <td class='campo'><%= oCot.getcantPersonas () %></td>
                                    </tr>
                                </table>
                              </td>
                              <td  valign='top'>
                                <table border='0' cellspacing='4' cellpadding='2' width='100%'>
                                    <col width='250px'>
                                    <col width=''>
                                    <tr>
                                        <td align='center' colspan='2' class='subtitulos'>Descripcion de Coberturas</td>
                                    </tr>
                                    <tr>
                                        <td align='center' class='subtitulos'>Cobertura</td>
                                        <td align='center' class='subtitulos'>Capital</td>
                                    </tr>
                                    <tr>
                                        <td class='campo'>Muerte por accidente</td>
                                        <td align='right' class='campo'>$<%= Dbl.DbltoStr(oCot.getcapitalMuerte (),2)%></td>
                                    </tr>
                                    <tr>
                                        <td class='campo'>Invalidez permanente total y/o parcial</td>
                                        <td align='right' class='campo'>$<%= Dbl.DbltoStr(oCot.getcapitalInvalidez (),2)%></td>
                                    </tr>
                                    <tr>
                                        <td class='campo'>Asistencia medica farmaceutica</td>
                                        <td align='right' class='campo'>$<%= Dbl.DbltoStr(oCot.getcapitalAsistencia (),2) %></td>
                                    </tr>
                                    <tr>
                                        <td class='campo'>Franquicia</td>
                                        <td align='right' class='campo'>$<%= oCot.getfranquicia ()==0?"0.00":Dbl.DbltoStr(oCot.getfranquicia (),2) %></td>
                                    </tr>
                                </table>
                              </td>
                              </tr>
                            </table>
                             
                        </td>
                    </tr>

                    <tr>
                        <td width='100%' valign="middle" align="center">&nbsp;</td>
                    </tr>
<%  if (oCot.getsubTotal() != 0) {
    %>
                    <tr>
                        <td width='100%' valign="middle" align="center" class='SubTitulos'>Presupuesto</td>
                    </tr>
                    <tr>
                        <td width='100%' valign="middle" align="center">&nbsp;</td>
                    </tr>
                    <tr>
                        <td width='100%' align='center'>
                            <table border='0' class='tblDatos' cellspacing='4' cellpadding='2' width='350px'>
                              <tr > 
                                <td colspan="2" height='30'  class='subtitulos'> Prima c.</td>
                                <td align="right"  class='subtitulos''>$<%= Dbl.DbltoStr(oCot.getprimaPura(),2)%> </td>
                              </tr>
      <% if ( oCot.getabm().equals("S")){  %>
                               <tr > 
                                <td colspan="2" class='campo' > Derecho de Emision</td>
                                <td align="right" class='campo'>$<%= Dbl.DbltoStr(oCot.getderEmi(),2)%> </td>
                              </tr>

<!--comisiones-->             <tr  > 
                                <td width="112" class='campo'> GDA</td>
                                <td width="73" align="right"  class='campo' ><%= oCot.getgastosAdquisicion()%>%</td>
                                <td align="right"  class='campo'>$<%= Dbl.DbltoStr(oCot.getgda(),2)%> </td>
                              </tr>

                              <tr> 
                                <td colspan="2" class='subtitulos'> Prima Tarifa</td>
                                <td align="right" class='subtitulos'>$<%= Dbl.DbltoStr(oCot.getprimaTar(),2)%> </td>
                              </tr>
                              <tr> 
                                <td colspan="2" class='subtitulos'> Ajuste de Tarifa</td>
<%                      if (oCot.getporcAjusteTarifa() == 100) {
    %>
                                <td align="right" class='subtitulos'>no ajusta</td>
<%                      } else {
    %>
                                <td align="right" class='subtitulos'>$<%= Dbl.DbltoStr(oCot.getimpAjusteTarifa(),2)%>&nbsp;(<%= Dbl.DbltoStr(oCot.getporcAjusteTarifa(),2)%>&nbsp;%&nbsp;a nivel de&nbsp;<%= oCot.getnivelAjusteTarifa() %>)</td>
<%                      }
    %>
                              </tr>
                              <tr> 
                                <td colspan="2" class='subtitulos'> Opcionales</td>
<%                      if (oCot.getcodOpcion () <= 0 ) {
    %>
                                <td align="right" class='subtitulos'>no ajusta</td>
<%                      } else {
    %>
                                <td align="right" class='subtitulos'><%= oCot.getsDescOpcion() %>&nbsp;(Cod.<%= oCot.getcodOpcion () %>&nbsp;:&nbsp;<%= Dbl.DbltoStr(oCot.getporcOpcionAjuste(),2)%>&nbsp;%)</td>
<%                      }
    %>
                              </tr>
                              <tr > 
                                <td class='campo' >IVA</td>
                                <td align="right"  class='campo'><%= oCot.getporcIva()%>%</td>
                                <td align="right" class='campo'>$<%= Dbl.DbltoStr(oCot.getiva(),2)%></td>
                              </tr>
                              <tr  > 
                                <td class='campo' >Tasa SSN</td>
                                <td align="right"  class='campo' ><%= oCot.getporcSsn()%>%</td>
                                <td align="right" class='campo'>$<%= Dbl.DbltoStr(oCot.getssn(),2)%></td>
                              </tr>
                              <tr > 
                                <td class='campo' >Serv.Soc</td>
                                <td align="right"   class='campo'><%= oCot.getporcSoc()%>%</td>
                                <td align="right" class='campo'>$<%= Dbl.DbltoStr(oCot.getsoc(),2)%></td>
                              </tr>
                              <tr > 
                                <td class='campo' >Sellado</td>
                                <td align="right"  class='campo' ><%= oCot.getporcSellado()%>%</td>
                                <td align="right" class='campo'>$<%= oCot.getsellado()==0?"0.00":Dbl.DbltoStr(oCot.getsellado(),2)%></td>
                              </tr>
<!-- fin comisiones-->
      <% }  %>
                              <tr> 
                                <td colspan="2" class='subtitulos' height='30'>Premio</td>
                                <td align="right" class='subtitulos'>$<%= Dbl.DbltoStr(oCot.getpremio(),2)%></td>
                              </tr>
                              <tr> 
                                <td class='' colspan="3" ></td>
                              </tr>
                              <tr> 
                                <td class='valor' colspan="3" ><%=sMsgCuotas%></td>
                              </tr>
                        </table>
                        </td>
                    </tr>
<%  }
    %>
    <% if ( oCot.getabm().equals("S") || oCot.getsubTotal() == 0){  %>
                    <tr class="campoBold"> 
                         <td>Aclaraci&oacute;n: esta cotizaci&oacute;n NO tiene validez.</td>
                   </tr>
<%      } else {
    %>
                    <tr align="center"> 
                         <td height='150' align="right" valign="middle">
                            <img src='<%= Param.getAplicacion()%>images/firmaBenef.jpg' border='0'>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                    </tr>
                    <tr class="campoBold"> 
                         <td>
                            <span style="color:red">IMPORTANTE:</span>&nbsp;PARA SOLICITAR LA PROPUESTA DE DICHA COTIZACION, HAGA CLICK EN EL BOTÓN "Generar Propuesta".<br><br>
                           <span style="color:red">Aclaraci&oacute;n:</span>&nbsp; esta cotizaci&oacute;n tendr&aacute; una validez de 7 d&iacute;as corridos a partir de la fecha de cotizaci&oacute;n.</td>
                   </tr>
<%      }
    %>
               </table>
            </td>
        </tr>
   </table>
</body>
