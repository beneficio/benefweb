<%@page contentType="text/html"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.*"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%  Usuario oUser          = (Usuario) session.getAttribute("user");
    Poliza oPol            = (Poliza) request.getAttribute("poliza");
    LinkedList lAsegurados     = (LinkedList) request.getAttribute("asegurados");
    LinkedList lAseguradosAfip = (LinkedList) request.getAttribute("aseguradosAfip");
    Date dFechaFTP         = oPol.getfechaFTP();
    int cantAseg = lAsegurados.size();
    int cantAsegAfip = lAseguradosAfip.size();

    int difCantAseg = 0;
    int difCantAsegAfip = 0;
    if (cantAseg < cantAsegAfip) {
        difCantAseg = cantAsegAfip - cantAseg;
    } else if (cantAseg > cantAsegAfip) {
        difCantAsegAfip = cantAseg - cantAsegAfip;
    }
%>
<html>
    <head>
        <title>Asegurados Afip</title>
        <link rel="STYLESHEET" type="text/css" href="<%= Param.getAplicacion()%>css/reports.css"/>
        <LINK rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css">
    </head>
<body  bgcolor="#F3F3F3" leftmargin=0 topmargin=0 style="margin-top: 0; margin-right: 0; margin-left: 0; margin-bottom: 0; padding-bottom: 0; padding-left: 0; padding-right: 0; padding-top: 0; top: 0; vertical-align: top;">
      <TABLE   align="center" width="700" border='0' cellpadding='2' cellspacing='0' >
        <tr>
            <td width='100%' height='10'><th></td>
        </tr>
        <tr> 
            <td align="center" width='100%'>
                <table align="center"  border='0' cellpadding='3' cellspacing='2' width='100%'>
                    <tr>
                        <td class='text'><b>Estimado colaborador, desde aqu&iacute; puede comparar ambas n&oacute;minas con el fin de gestionar la actualización correspondiente y su adecuada cobertura.</b></td>
                    </tr>
                    <tr>
                        <td class='tituloSolapa'><b>P&oacute;liza&nbsp;/endoso:</b>&nbsp;<%= Formatos.showNumPoliza(oPol.getnumPoliza()) %>/<%= oPol.getnumEndoso()%></strong></td>
                    </tr>
                    <tr>
                        <td class='tituloSolapa'>Vigencia:&nbsp;<%= Fecha.showFechaForm (oPol.getfechaInicioVigencia ()) %>&nbsp;al&nbsp;<%= Fecha.showFechaForm (oPol.getfechaFinVigencia ()) %></td>
                    </tr>
                </table>
            </td>
        </tr>   
        <tr>       
            <td class ="text"   ><b>
                Referencias:</b><br><br>
                <label style="color:red"><b>Rojo:</b> No existe en la otra n&oacute;mina</label>
<%--    <label style="color:blue"><b>Azul:</b> Existe en la nomina de Afip pero corresponde al r&eacute;gimen anterior.</label>
    --%> <br>
    &nbsp;<b>'S'&nbsp;&nbsp;&nbsp;:</b> el cobro ingreso desde la AFIP.<br>
    &nbsp;<b>'N'&nbsp;&nbsp;&nbsp;:</b> el asegurado fue ingresado antes del 01/01/2011.
            </td>     
        </tr>
        <tr valign="top">
            <td>
                <table align="center"  border='0' cellpadding='2' cellspacing='0' width='100%' >
                  <tr valign="top">
                    <td width='50%'>
              
                        <%--table border="0" width='100%' cellspacing="2" cellpadding="2" --%>
                        <table border='1' align="center" width='100%' cellpadding='0' cellspacing='0' class="TablasBody">

                            <tr>
                                <th align="center"  colspan="3" class='textSolapa'>N&oacute;mina Beneficio</th>
                            </tr>
                            <tr align="" valign="top">
                                <th align="left" width='80' class='textSolapa' align="center">Cuil</th>
                                <th align="left" width='260' class='textSolapa'>Nombre</th>
                                <th align="center" width='60' class='textSolapa'>F.Alta</th>
                            </tr>

<%                      if (lAsegurados.size () == 0) { 
                            difCantAseg--;
%>
                            <tr><td align="left"  height='20' class='campo' colspan='5'>La póliza no tiene asegurados con cobertura</td></tr>
<%                      } else {
                            for (int i=0; i < lAsegurados.size (); i++) {
                                Asegurado oAseg = (Asegurado) lAsegurados.get(i);
%>
                            <tr>
                                <td align="left"  class='campo'  style ='color:<%= (oAseg.getexisteAfip()==1 ? "#000000":"red") %>' ><%= oAseg.getnumDoc ()%></td>
                                <td align="left"  class='campo'  style ='color:<%= (oAseg.getexisteAfip()==1 ? "#000000":"red") %>' ><%= oAseg.getnombre()%></td>
                                <td align="right"  class='campo' style ='color:<%= (oAseg.getexisteAfip()==1 ? "#000000":"red") %>' ><%= Fecha.showFechaForm(oAseg.getfechaAltaCob())%></td>
                            </tr>
<%                         }
                        }
                     for (int i=1; i <= difCantAseg; i++) {  %>

                             <tr>
                                 <td align="left"  class='campo'>&nbsp;</td>
                                 <td align="left"  class='campo'>&nbsp;</td>
                                 <td align="left"  class='campo'>&nbsp;</td>
                             </tr>
                            
<%                     }    %>


                        </table>

                    </td>
                    <td width='50%'>
                        <%--table border="0" width='100%' cellspacing="2" cellpadding="2"--%>
                        <table border='1' align="center" width='100%' cellpadding='0' cellspacing='0' class="TablasBody">
                            <tr>
                                <th align="center"  colspan="3" class='textSolapa'>N&oacute;mina AFIP</th>
                            </tr>



                            <tr align="" valign="top">
                                <th align="left" width='80' class='textSolapa'>Cuil</th>
                                <th align="left" width='260' class='textSolapa'>Nombre</th>
                                <th align="center" width='60' class='textSolapa'>AFIP</th>
                            </tr>


<%                      if (lAseguradosAfip.size () == 0) { 
                            difCantAsegAfip--;
%>
                            <tr><td align="left"  height='20' class='campo' colspan='5'>La póliza no tiene asegurados con cobertura</td></tr>
<%                      } else {
                            for (int i=0; i < lAseguradosAfip.size (); i++) {
                                Asegurado oAsegAfip = (Asegurado) lAseguradosAfip.get(i);
%>

                            <tr >
                                <td align="left"  class='campo' style ='color:<%= (oAsegAfip.getexisteAfip()==1 ? "#000000" : "red")%>'><%= oAsegAfip.getnumDoc ()%></td>
                                <td align="left"  class='campo' style ='color:<%= (oAsegAfip.getexisteAfip()==1 ? "#000000" : "red")%>'><%= oAsegAfip.getnombre()%></td>
                                <td align="right" class='campo' style ='color:<%= (oAsegAfip.getexisteAfip()==1 ? "#000000" : "red")%>'><%= oAsegAfip.getmcaAfip()%></td>

                                <%--td align="right" class='campo' style ='color:<%= (oAsegAfip.getexisteAfip()==1 && oAsegAfip.getmcaAfip().equals("S")) ?"blue":"red"%>'  ><%= oAsegAfip.getexisteAfip()%></td--%>

                            </tr>
<%                          }
                        }    %>


<%                     for (int i=0; i < difCantAsegAfip; i++) {  %>
                             <tr>
                                 <td align="left"  class='campo'>&nbsp;</td>
                                 <td align="left"  class='campo'>&nbsp;</td>
                                 <td align="left"  class='campo'>&nbsp;</td>
                             </tr>
<%                     }    %>

                        </table>
                    </td>
                </tr>
                </table>
            </td>
        </tr>
        <tr><td>&nbsp;</td></tr>
   </table>
</body>
</html>
