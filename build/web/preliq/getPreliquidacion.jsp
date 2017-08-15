<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%> 
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%> 
<%@page import="com.business.beans.ErrorPreliq"%>
<%@page import="com.business.beans.Preliq"%>
<%@page import="com.business.beans.PreliqDet"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@ taglib uri="/tld/menu.tld" prefix="menu" %>
<%     
    Preliq preliq =(Preliq)request.getAttribute("preliq");
    LinkedList lPreliqDet =(LinkedList)request.getAttribute("lPreliqDet");
    Diccionario oDicc   = (Diccionario) session.getAttribute("Diccionario");
    int iSize        = (lPreliqDet == null ? 0 : lPreliqDet.size());
    int iNumPreliq   = oDicc.getInt   (request,"co_numPreliq");
    String sOrden    = oDicc.getString (request, "co_orden","POLIZA");

    Usuario usu = (Usuario) session.getAttribute("user");
    oDicc.add("co_numPreliq", String.valueOf(iNumPreliq));
    oDicc.add("co_orden", sOrden);
    oDicc.add("co_CodProd",String.valueOf(preliq.getCodProd()));

    session.setAttribute("Diccionario", oDicc);
    int estadoPreliq =preliq.getCodEstado();
    double totalPrima = 0;
    double totalPremio = 0;

    //Hashtable lCuotaError = request.getAttribute("lCuotaError") == null ? new Hashtable() :(Hashtable)request.getAttribute("lCuotaError");

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>portal/js/vendor/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <script language="javascript">

    function Salir () {
        window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

    function Buscar() {
        document.form1.action = "<%= Param.getAplicacion()%>servlet/PreliquidacionServlet";
        document.form1.opcion.value  = 'getPreliquidacion';
        document.form1.submit();
    }

    function Grabar() {

        if (confirm("Desea grabar las cuotas Seleccionadas ?  ")) {
            document.form1.action = "<%= Param.getAplicacion() %>servlet/PreliquidacionServlet";
            document.form1.opcion.value="grabarCuotasPreliq";           
            document.form1.submit();
        }
    }
    
    function CerrarPreliq() {
        if (confirm("ATENCION: si CIERRA la Preliquidaci&oacute;n no podra volver a cargarle cuotas. Confirma ? ")) {
            document.form1.action = "<%= Param.getAplicacion() %>servlet/PreliquidacionServlet";
            document.form1.opcion.value='cerrarPreLiquidacion';
            document.form1.submit();
            return true;
        } else {
            return false;
        }
    }

    function AnularCobro ( numFila ) {
        document.form1.action = "<%= Param.getAplicacion() %>servlet/PreliquidacionServlet";
        document.form1.opcion.value='anularCobro';
        document.form1.co_numFila.value = numFila;
        document.form1.submit();
        return true;
    }

    function selCheckedPreliq() {
        //alert (document.getElementById("SEL_CHECKED_PRELIQ").checked);
        checkPreliq(document.getElementById("SEL_CHECKED_PRELIQ").checked);
    }
    
    function checkPreliq(valor) {
        var elems = document.getElementsByTagName("*");
        for (var i=0; i<elems.length; i++) {
            if (elems[i].id.indexOf("CBX_PRELIQ") == 0) {
                 var e = document.getElementById( elems[i].id  ) ;
                 e.checked = valor;
            }
        }
    }
    function cambiarOrden () {
        document.form1.action = "<%= Param.getAplicacion() %>servlet/PreliquidacionServlet";
        document.form1.opcion.value="cambiarOrden";
        document.form1.submit();
    }
    function EnviarMensaje  () {
        document.form1.action = "<%= Param.getAplicacion() %>servlet/PreliquidacionServlet";
        document.form1.opcion.value="enviarMensaje";
        document.form1.submit();
    }

function calcLong(txt, dst, formul, maximo) {
    var largo;
    largo = formul[txt].value.length;
    if (largo > maximo) {
        formul[txt].value = formul[txt].value.substring(0,maximo);
    }
     formul[dst].value = formul[txt].value.length;
}

function ValidarNC ( chk, numFila ) {

    if ( document.getElementById ('tipo_usuario' ).value ==  "1") {
        if ( chk.checked == true && document.getElementById ('NC_FILA_' + numFila ).value == "NC_NO_OK" ) {
            alert ("No puede aplicar notas de credito de futuros convenios  ")
            chk.checked = false;
            return false;
        }
    }

    return true;
}

    </script>
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
        <td valign="top" align="center" width="100%">
            <form name="form1" id="form1" method="POST" action="<%= Param.getAplicacion()%>servlet/PreliquidacionServlet"
                  onKeyUp="calcLong('DESCRIPCION', 'caracteres',this, 300)">
                <input type="hidden" name="opcion" id="opcion" value="getPreliquidacion"/>
                <input type="hidden" name="co_numPreliq" id="co_numPreliq" value="<%= iNumPreliq %>"/>
                <input type="hidden" name="co_numFila" id="co_numFila" value="0"/>
                <input type="hidden" name="tipo_usuario" id="tipo_usuario" value="<%= usu.getiCodTipoUsuario() %>"/>
                <table width="100%" border="0" align="center" cellspacing="2" cellpadding="2"
                       class="fondoForm" style='margin-top:5;margin-bottom:5;'>
                    <tr>
                        <td colspan="0" height="30px" valign="middle" align="center" class='titulo'>PRELIQUIDACION WEB</td>
                    </tr>
                    <tr>
                        <td>
                            <label class="campo" >
                                Estimado colaborador,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Haga clic en la celda correspondiente a la cuota cobrada y luego en el bot&oacute;n <strong>"Grabar cuotas"</strong>. De esta forma
                        usted podr&aacute; ir acentando la cobranza a medida que la vaya realizando. Antes de presentar los valores de la forma habitual que lo ven&iacute;a haciendo,
                        deber&aacute; enviarnos la preliquidaci&oacute;n desde el bot&oacute;n <strong>"Cerrar preliquidaci&oacute;n"</strong> y si usted lo desea podr&aacute; bajar un PDF de la preliquidaci&oacute;n.<br>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Las cuotas marcadas como cobradas no podr&aacute;n desmarcarse.
                        </label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0">
                                <tr>
                                    <td width="20%" height="20px" valign="middle" align="left" class='text'>
                                        <strong>Preliquidaci&oacute;n &nbsp;:&nbsp;&nbsp;&nbsp;</strong>
                                        <%=preliq.getNumPreliq()%>
                                    </td>
                                    <td width="60%" valign="middle" align="center" class='text'>
                                        <strong>Productor &nbsp;:&nbsp;&nbsp;&nbsp;</strong>
                                        <%=preliq.getCodProdDesc()%>(<%=preliq.getCodOrg()%>.<%=preliq.getCodProd()%>)
                                        &nbsp;&nbsp;&nbsp;&nbsp;
                                    </td>
                                    <td width="20%"  valign="middle" align="right" class='text'>
                                        <strong>Estado &nbsp;:&nbsp;&nbsp;&nbsp;</strong>
                                        <%= preliq.getsDescEstado() %>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" class="campo" ><span style="color:red">Referencias:</span></td>
                    </tr>
                    <tr>
                        <td valign="middle" align="left">
                            <table align="left" border="0">
                                <tr>
                                    <td bgcolor="#F6CECE" width="20"
                                        style="BORDER-RIGHT: #00CCFF 1px solid; BORDER-BOTTOM: #00CCFF 1px solid;
                                               BORDER-LEFT: #00CCFF 1px solid; BORDER-TOP: #00CCFF  1px solid;" >&nbsp;</td>
                                    <td align="left" class="text" width="650">Cuotas impagas del convenio anterior</td>
                                </tr>
                                <tr>
                                    <td bgcolor="#A9F5BC"
                                        style="BORDER-RIGHT: #00CCFF 1px solid; BORDER-BOTTOM: #00CCFF 1px solid;
                                               BORDER-LEFT: #00CCFF 1px solid; BORDER-TOP: #00CCFF  1px solid;">&nbsp;</td>
                                    <td align="left" class="text">Cuotas exigibles del convenio actual</td>
                                </tr>
                                <tr>
                                    <td bgcolor="#F2F5A9"
                                        style="BORDER-RIGHT: #00CCFF 1px solid; BORDER-BOTTOM: #00CCFF 1px solid;
                                               BORDER-LEFT: #00CCFF 1px solid; BORDER-TOP: #00CCFF  1px solid;">&nbsp;</td>
                                    <td align="left" class="text">Cuotas NO exigibles</td>
                                </tr>
                                <tr>
                                    <td ><IMG  alt="Cuota cobrada" src="<%= Param.getAplicacion() %>images/ok.gif"  border="0"  hspace="0" vspace="0" align="bottom"></td>
                                    <td align="left" class="text">Cuota marcada como cobrada</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" class="text" valign="center" height="45">Ordenado por&nbsp;
                            <select class='select' name="co_orden" id="co_orden" onchange="javacript:cambiarOrden();">
                                <option value="POLIZA" <%=(sOrden.equals("POLIZA") ? "selected" : " ") %>>N&uacute;mero de P&oacute;liza</option>
                                <option value="ASEGURADO" <%=(sOrden.equals("ASEGURADO") ? "selected" : " ") %>>Raz&oacute;n Social del Asegurado</option>
                                <option value="FECHA" <%=(sOrden.equals("FECHA") ? "selected" : " ") %>>Fecha vencimiento productor</option>
                                <option value="FECHA_ASEG" <%=(sOrden.equals("FECHA_ASEG") ? "selected" : " ") %>>Fecha vencimiento asegurado</option>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <table border="0"  width="100%" cellPadding="0" cellSpacing="1" align="center" >
                                <tr> 
                                    <td valign="top"  width='100%'>
                                            <table  border="0" cellspacing="0" cellpadding="2" align="center" class="TablasBody" >
                                                <thead>
                                                    <th width="30px" align="center">Sc</th>
                                                    <th  width="50px" align="center" nowrap>Poliza/End</th>
                                                    <th width="40px" align="center">Cuo<br/>ta</th>
                                                    <th width="65px" align="center">Vencimiento<br/>asegurado</th>
                                                    <th width="65px" align="center">Vencimiento<br/>productor</th>
                                                    <th align="center" nowrap>Asegurado</th>
<%--                                                    <th width="80px" align="center">Prima</th>
--%>
                                                    <th width="80px" align="center">Premio</th>
                                                    <th width="70px" align="center" nowrap>Fecha cobro</th>
                                                    <th width="70px" align="center">Usuario<br/>cobro</th>
                                                    <th width="15px" align="center">
                                                        <INPUT type='CHECKBOX' name='SEL_CHECKED_PRELIQ' id='SEL_CHECKED_PRELIQ' ONCLICK="selCheckedPreliq()" 
                                                               TITLE="Marcar o desmarcar todas las cuotas" ALT="Marcar o desmarcar todas las cuotas"/>
                                                    </th>
                                                </thead>
<%
                           if (iSize == 0 ){
%>
                                                <tr>
                                                    <td colspan="10" height='25' valign="middle"><span style='color:red'>Preliquidaci&oacute; vacia. Contactese con el sector de cobranzas para resolver el problema. Gracias </span></td>
                                                </tr>
<%                         } else {
                               for (int i=0; i < iSize; i++)  {

                                    PreliqDet oPreliq = (PreliqDet) lPreliqDet.get(i);
                                    String sColor = "#F6CECE";
                                    if ( oPreliq.getColor().equals("1")) {
                                        sColor = "#A9F5BC";
                                        } else if ( oPreliq.getColor().equals("2")) {
                                            sColor = "#F2F5A9";
                                            }
%>
<%--
                                    String key = oPreliq.getNumPreliq()+"_"+oPreliq.getNumFila();                                    
                                    boolean existsErroCuota = lCuotaError.containsKey(key);
                                    if (existsErroCuota) {%>
                                                <tr style="text-decoration:line-through;" >
<%                                  }else{ %>
                                                <tr>
<%                                  }
--%>

                                                <tr style="background-color: <%= sColor %>">
                                                    <td align="center" class="text"><%= oPreliq.getCodRamaDesc() %></td>
                                                    <td align="left" class="text">&nbsp;<%= oPreliq.getNumPoliza() %><b>/&nbsp;</b><%= oPreliq.getEndoso()%></td>
                                                    <td align="center" class="text"><%=(oPreliq.getNumCuota())%></td>
                                                    <td align="center"><%= (oPreliq.getFechaAseg() == null ? "&nbsp;" : Fecha.showFechaForm(oPreliq.getFechaAseg())) %></td>
                                                    <td align="center"><%= (oPreliq.getFechaRec() == null ? "&nbsp;" : Fecha.showFechaForm(oPreliq.getFechaRec())) %></td>
                                                    <td align="left" class="text" nowrap><%=(oPreliq.getAsegurado()==null?"&nbsp;":oPreliq.getAsegurado())%></td>
<%--                                                    <td align="right"><%=Dbl.DbltoStr(oPreliq.getImpPrima(),2) %></td>
    --%>
                                                    <td align="right"><%=Dbl.DbltoStr(oPreliq.getImpPremioPesos(),2) %></td>                                                   
                                                    <td align="right" nowrap><%= (oPreliq.getFechaCobro() == null ? "&nbsp;" : (Fecha.showFechaForm(oPreliq.getFechaCobro())+ " " + oPreliq.getHoraCobro())) %></td>
                                                    <td align="right" nowrap><%= (oPreliq.getUseridCobro()== null ? "&nbsp;" : oPreliq.getUseridCobro() ) %></td>
<%                                  if (oPreliq.getMcaCobro()!= null && oPreliq.getMcaCobro().equals("*") ) {
                                       totalPrima    += oPreliq.getImpPrima() ;
                                       totalPremio   += oPreliq.getImpPremioPesos();
                                    }
    %>

<%                                       if ( oPreliq.getMcaCobro()== null ) {
    %>
                                                    <td  align="center">
                                                        <input type="checkbox" name='CBX_PRELIQ_<%=oPreliq.getNumPreliq()%>_FILA_<%=oPreliq.getNumFila()%>'
                                                               id='CBX_PRELIQ_<%=oPreliq.getNumPreliq()%>_FILA_<%=oPreliq.getNumFila()%>'  onchange=''
                                                                <%= ( oPreliq.getMcaCobro()!= null && oPreliq.getMcaCobro().equals("*") ? "checked" : " " ) %> 
                                                                onclick="javascript:ValidarNC ( this, <%= oPreliq.getNumFila() %>)"/>
                                                    </td>
                                                    <input type="hidden" name="NC_FILA_<%= oPreliq.getNumFila() %>" id="NC_FILA_<%= oPreliq.getNumFila() %>"
                                                           value="<%= (oPreliq.getImpPremio() < 0 && oPreliq.getColor().equals("2") ? "NC_NO_OK" : ""  ) %>" />
                                
<%                                       } else {
    %>
                                                    <td  align="center">
<%                                              if (usu.getiCodTipoUsuario() == 0 ) {
    %>
                                                        <IMG alt="ANULAR COBRO" src="<%= Param.getAplicacion() %>images/eliminar.gif"  border="0"  hspace="0" vspace="0" align="bottom" 
                                                             onclick="AnularCobro (<%=oPreliq.getNumFila()%>);"   style="cursor: hand;" >
<%                                              } else {
    %>
                                                        <IMG alt="Cuota cobrada" src="<%= Param.getAplicacion() %>images/ok.gif"  border="0"  hspace="0" vspace="0" align="bottom">
<%                                              }
    %>
                                                    </td>
                                                        <INPUT type ="HIDDEN" name='CUOTA_PRELIQ_<%=oPreliq.getNumPreliq()%>_FILA_<%=oPreliq.getNumFila()%>' id='CUOTA_PRELIQ_<%=oPreliq.getNumPreliq()%>_FILA_<%=oPreliq.getNumFila()%>'>
                                                        <INPUT type ="HIDDEN" name='CBX_PRELIQ_<%=oPreliq.getNumPreliq()%>_FILA_<%=oPreliq.getNumFila()%>'   id='CBX_PRELIQ_<%=oPreliq.getNumPreliq()%>_FILA_<%=oPreliq.getNumFila()%>'>
<%                                       }
    %>

                                                </tr>
<%
                               } // for
                           } // end if. size
%>
                                            </table>
                                    </td>
                                </tr>
                           </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table border="0" width="100%">
                                <tr>
                                    <td colspan='0' height="20px" valign="middle" align="left" class='text'>
                                        <strong>Prima cobrada&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   :&nbsp;&nbsp;&nbsp;</strong>$&nbsp;
                                        <%=Dbl.DbltoStr(totalPrima,2) %>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan='0' height="20px" valign="middle" align="left" class='text'>
                                        <strong>Premio cobrado&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;</strong>$&nbsp;
                                        <%=Dbl.DbltoStr(totalPremio,2) %>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr valign="bottom" >
                        <td width="100%" align="center" colspan="1" >
                            <input type="button" name="cmdSalir"  value="Salir"  height="20px" class="boton" onClick="Salir();"/>&nbsp;&nbsp;&nbsp;&nbsp;
                            <% if ( estadoPreliq ==0  )  { %>
                            <input type="button" name="cmdGrabar"  value="Grabar Cuotas"  height="20px" class="boton" onClick="Grabar();"/>&nbsp;&nbsp;&nbsp;&nbsp;
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            <input type="button" name="cmdCerrar"  value="Cerrar PreLiquidaci&oacute;n"  height="20px" class="boton" onClick="CerrarPreliq();"/>
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            <% } %>

                        </td>
                    </tr>
                    <tr>
                        <td class="subtitulo">
                            Si el pago que se acredita por este recibo fue efectuado vencido el plazo convenido en la cl&aacute;usula de cobranza que
                            integra la p&oacute;liza, la cobertura suspendida en virtud de tal cl&aacute;usula s&oacute;lo queda rehabilitada desde la hora 0 del
                            d&iacute;a siguiente al de este recibo y con efecto futuro. Los siniestros ocurridos durante la suspensi&oacute;n permanecen sin cobertura.<br/><br/>
                            Si usted desea modificar la informaci&oacute;n de esta preliquidaci&oacute;n o reclamar alguna p&oacute;liza inexistente,
                            solicitelo v&iacute;a mail a&nbsp;<a href="mailto:<%= (usu.getoficina() == 2 ? "COBRANZAS_BSAS@BENEFICIOSA.COM.AR":"COBRANZA@BENEFICIOSA.COM.AR" ) %>">
                            <%= (usu.getoficina() == 2 ? "cobranzas_bsas@beneficiosa.com.ar":"cobranza@beneficiosa.com.ar" ) %></a>
                            y un representante se contactar&aacute; con usted. Gracias.
                        </td>
                    </tr>
<%--                    <tr>
                        <td class="subtitulo">
                            Si usted desea modificar la informaci&oacute;n de esta preliquidaci&oacute;n o reclamar alguna p&oacute;liza inexistente,
                            solicitelo desde aqui y un representante  se contactar&aacute; con usted v&iacute;a mail. Gracias.
                        </td>
                    </tr>
                    <tr>
                        <td align="left" class="text">Mail remitente:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <input type="text" name="remitente" id="remitente" size="60" maxlength="100" value="<%= usu.getEmail() %>">
                        </td>
                    </tr>
                    <tr>
                        <td align="left" class="text" valign="top">Ingrese comentarios:&nbsp;<br>
                            <textarea cols="70" rows="6"  class='inputText' name='DESCRIPCION' id="DESCRIPCION" ></textarea><br>
                            <input name="caracteres" type="text" id="caracteres" value="0" size="4" readonly>&nbsp;Max. 1.000 caracteres
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <input type="button" name="cmdMail"  value="Enviar mensaje"  height="20px"
                                   class="boton" onClick="EnviarMensaje();">
                        </td>
                    </tr>
--%>
               </table>
            </form>
        </td>
    </tr>
    <tr><td>&nbsp;</td></tr>
    <tr><td>&nbsp;</td></tr>
    <tr>
        <td valign="bottom" align="center">
             <jsp:include  flush="true" page="/bottom.jsp"/>
        </td>
    </tr>
</table>
<script>
     CloseEspere();
<% if (request.getParameter ("mensaje") != null && request.getParameter ("mensaje").equals("ok")) {
    %>
    alert ("El mensaje fue enviado con exito !!")
<% }
    %>
</script>
</body>
</HTML>

