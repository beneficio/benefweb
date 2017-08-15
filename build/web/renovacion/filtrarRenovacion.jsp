<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Poliza"%>
<%@page import="com.business.beans.Grupo"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.db"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<%@taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg"  %>
<%
    LinkedList lPolizas = (LinkedList) request.getAttribute("polizas");
    Diccionario oDicc   = (Diccionario) session.getAttribute("Diccionario");
    Usuario usu = (Usuario) session.getAttribute("user");

    int iSize           = (lPolizas == null ? 0 : lPolizas.size());    
    String sPri         = oDicc.getString(request,"F1pri","S");
    int iCodProd        = oDicc.getInt (request, "F1cod_prod");
    String sNombre      = oDicc.getString (request, "F1nombre");
    int iNumPoliza      = oDicc.getInt (request, "F1num_poliza");
    int iCodRama        = oDicc.getInt (request, "F1cod_rama");
    int iNumPolizaSelec = oDicc.getInt (request, "F1num_poliza_sel");
    int iCodRamaSelec   = oDicc.getInt (request, "F1cod_rama_sel");
    int iGrupo          = oDicc.getInt (request, "F1grupo");
    Date dFechaDesde    = oDicc.getDate(request, "F1fecha_desde");
    Date dFechaHasta    = oDicc.getDate(request, "F1fecha_hasta");
    String sRenovadas    = oDicc.getString (request, "F1renovadas");
    int iCurrentPageNumber = oDicc.getInt (request,"pager.offset");

    oDicc.add("F1pri", sPri );
    oDicc.add("F1nombre", sNombre);
    oDicc.add("F1cod_prod", String.valueOf(iCodProd));
    oDicc.add("F1num_poliza", String.valueOf (iNumPoliza));
    oDicc.add("F1cod_rama", String.valueOf (iCodRama));
    oDicc.add("F1num_poliza_sel", String.valueOf (iNumPolizaSelec));
    oDicc.add("F1cod_rama_sel", String.valueOf (iCodRamaSelec));
    oDicc.add("F1grupo", String.valueOf (iGrupo));
    oDicc.add("F1fecha_desde", (dFechaDesde == null ? null : Fecha.showFechaForm(dFechaDesde)));
    oDicc.add("F1fecha_hasta", (dFechaHasta == null ? null : Fecha.showFechaForm(dFechaHasta)));
    oDicc.add("F1renovadas", (sRenovadas.equals ("") ? "N" : sRenovadas) );
    oDicc.add("pager.offset", String.valueOf(iCurrentPageNumber));
    
    session.setAttribute("Diccionario", oDicc);

String sPath  =
    "&F1pri=N&F1nombre=" + sNombre +  "&F1grupo=" + iGrupo +
    "&F1cod_prod=" + iCodProd  + "&F1renovadas=" + (sRenovadas.equals("") ? "N" : sRenovadas) +
    (dFechaDesde == null ? "" : "&F1fecha_desde=" + Fecha.showFechaForm(dFechaDesde)) +
    (dFechaHasta == null ? "" : "&F1fecha_hasta=" + Fecha.showFechaForm(dFechaHasta)) +
    "&F1num_poliza=" + iNumPoliza + "&F1num_poliza_sel=0&F1cod_rama_sel=0&F1cod_rama=" + iCodRama +
    "&opcion=getAllPol" ;

    HtmlBuilder ohtml       = new HtmlBuilder();
    Tablas oTabla = new Tablas ();
    LinkedList lTabla = new LinkedList ();
    %>  
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js" defer="defer"></script>
    <script language="javascript">

    function  VerPoliza  ( rama, poliza ) {


       document.form1.action = '<%= Param.getAplicacion()%>servlet/ConsultaServlet';
       document.form1.F1cod_rama_sel.value   = rama;
       document.form1.F1num_poliza_sel.value = poliza;
       document.form1.opcion.value  = 'getPol';
       document.form1.submit(); 
       return true;
    }
    function  EditarPropuesta ( numPropuesta ) {
       document.form1.action = '<%= Param.getAplicacion()%>servlet/RenuevaServlet';
       document.form1.opcion.value  = 'getPropuesta';
       document.form1.numPropuesta.value  = numPropuesta;
       document.form1.submit();
       return true;
    }

    function  Recotizar ( rama, poliza ) {

       document.form1.action = '<%= Param.getAplicacion()%>servlet/RenuevaServlet';
       document.form1.F1cod_rama_sel.value   = rama;
       document.form1.F1num_poliza_sel.value = poliza;
       document.form1.cant_vidas.value = document.getElementById( rama + "_" + poliza + "_vidas"  ).value;
       document.form1.num_cotizacion.value = document.getElementById( rama + "_" + poliza + "_cotiz"  ).value;
       if (parseInt (document.form1.cant_vidas.value) > 0) {
           document.form1.opcion.value  = 'recotizar';
           document.form1.submit();
           return true;
       } else {
           alert ("Debe ingresar la cantidad de vidas a recotizar !");
           document.getElementById( rama + "_" + poliza + "_vidas"  ).focus;
           return false;
       }
    }

    function  Renovar ( rama, poliza, estado ) {

        if (estado == 'FINALIZADA') {
            alert ("LA POLIZA ESTA FINALIZADA, RECUERDE QUE EMITIRA UNA POLIZA NUEVA Y NO UNA RENOVACION");
        }
       document.form1.action = '<%= Param.getAplicacion()%>servlet/RenuevaServlet';
       document.form1.opcion.value  = 'renovar';
       document.form1.F1cod_rama_sel.value   = rama;
       document.form1.F1num_poliza_sel.value = poliza;
       document.form1.cant_vidas.value = document.getElementById( rama + "_" + poliza + "_vidas"  ).value;
       document.form1.num_cotizacion.value = document.getElementById( rama + "_" + poliza + "_cotiz"  ).value;
       if (parseInt (document.form1.cant_vidas.value) > 0) {
           if ( parseInt (document.getElementById( rama + "_" + poliza + "_vidas_orig"  ).value) !=
                parseInt (document.form1.cant_vidas.value)){
                document.form1.num_cotizacion.value = '0';
           }
           document.form1.submit();
           return true;
       } else {
           alert ("Debe ingresar la cantidad de vidas a renovar !");
           document.getElementById( rama + "_" + poliza + "_vidas"  ).focus;
           return false;
       }
    }

    function Buscar ( tipoConsulta ) {
        
        if (document.form1.F1num_poliza.value == "") {
            document.form1.F1num_poliza.value    = 0;
        }
        document.getElementById('F1renovadas').value = (document.getElementById('F1renovadas').checked == true ? 'S' : 'N');

        document.getElementById('F1renovadas').checked = true;
        if ( document.form1 ) {
            document.form1.action = "<%= Param.getAplicacion()%>servlet/RenuevaServlet";
            document.form1.opcion.value  = tipoConsulta;
            document.form1.submit(); 
            return true;
       } else {
            return false;
       }
    }
    function Salir () {
        window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }
    function Submitir(evt) {
           var nkeyCode;
           if (document.all) {
                 nkeyCode = evt.keyCode;
           }else
             if (evt) {
                nkeyCode = evt.which;
           }

          if (nkeyCode==13) {
            Buscar ();
          }
    }
    function ModifVidas ( numProp) {
        if (parseInt(numProp) > 0) {
            alert ("No puede modificar la cantidad de vidas porque ya existe la propuesta de renovación, modifique desde el formulario de propuesta.");
            return false;
        }
        return true;
    }
    </script>
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
            <form name="form1" id="form1" method="POST" action="<%= Param.getAplicacion()%>servlet/RenuevaServlet">
                <input type="hidden" name="opcion" id="opcion" value="getAllPol"/>
                <input type="hidden" name="F1pri" id="F1pri" value="N"/>
                <input type="hidden" name="volver" id="volver" value='filtrarRenovacion'/>
                <input type="hidden" name="F1num_poliza_sel" id="F1num_poliza_sel" value="0"/>
                <input type="hidden" name="F1cod_rama_sel" id="F1cod_rama_sel" value="0"/>
                <input type="hidden" name="cant_vidas" id="cant_vidas" value="0"/>
                <input type="hidden" name="num_cotizacion" id="num_cotizacion" value="0"/>
                <input type="hidden" name="numPropuesta" id="numPropuesta" value="0"/>
                <input type="hidden" name="pager.offset" id="pager.offset" value="<%= iCurrentPageNumber %>"/>
                <table width="100%" border="0" align="center" cellspacing="4" cellpadding="4"
                       class="fondoForm" style="margin-top:1;margin-bottom:1;">
                    <TR>
                        <TD valign="middle" align="center" class='titulo' height="30" >POLIZAS A RENOVAR</TD>
                    </TR>
<%          if (usu.getiCodTipoUsuario() != 0) {
                        if (usu.getiCodTipoUsuario () == 1 && usu.getiCodProd () < 80000) {
    %>

                            <input type="hidden" name="F1cod_prod" value="<%= usu.getiCodProd () %>"/>
<%                      }
            %>
<%          }
    %>
                <tr>
                    <td width='100%' align="left" class='subtitulo' valign="top">
Estimado colaborador: desde aqu&iacute; usted podr&aacute;  recotizar, modificar datos y enviar por sus propios medios la propuesta de renovación.
Entre los cambios que puede realizar se encuentra la actualización de nómina, pudiendo eliminar, modificar y/o agregar asegurados.
<br/>Si usted no ingresa ning&uacute;n filtro el sistema seleccionar&aacute; todas las p&oacute;lizas con vencimiento hasta 30 d&iacute;as de antelación y vencidas.
<br/>Si la p&oacute;liza se encuentra FINALIZADA NO SE CONSIDERA RENOVACION, SINO POLIZA NUEVA.
<BR/>
<span style="color:red">IMPORTANTE: Debido al cambio de suma asegurada que entra en vigencia el 4 de abril de 2014 se ecnuentra deshabilitada la 
    renovación web de Vida Colectivo Obligatorio.  Dichas renovaciones se harán de forma automática.
</span>
                    </td>
                </tr>
<%         if (usu.getiCodTipoUsuario() == 0 || usu.getiCodProd () >= 80000) {
    %>
                <tr>
                    <td align="left" class="text">Productor:&nbsp;
                        <select class='select' name="F1cod_prod" id="F1cod_prod">
                            <option value='0' >Todos los productores</option>
<%                              LinkedList lProd = (LinkedList) session.getAttribute("Productores");
                     for (int i= 0; i < lProd.size (); i++) {
                            Usuario oProd = (Usuario) lProd.get(i);
                            out.print("<option value='" + String.valueOf (oProd.getiCodProd()) + "' " + (oProd.getiCodProd() == iCodProd ? "selected" : " ") + ">" + oProd.getsDesPersona() + " (" + oProd.getiCodProd() + ")</option>");
                        }
%>
                        </select>
                    </td>
                </tr>

<%         }
    %>
                <tr>
                    <td align="left" valign="top">
                        <table border='0' align="left" cellpadding='2' cellspacing='3'>
                            <tr>
                                <td align="left" class="text">Fecha Vencimiento desde:&nbsp;
                                    <input type="text" name="F1fecha_desde" id="F1fecha_desde" size="10"
                                           onblur="validaFecha(this);" onkeypress="return Mascara('F',event);"
                                           value='<%=(dFechaDesde == null ? "" : Fecha.showFechaForm(dFechaDesde))%>'>
                                </td>
                                <td align="left" class="text" colspan="2">Hasta:&nbsp;
                                    <input type="text" name="F1fecha_hasta" id="F1fecha_hasta" size="10"
                                           onblur="validaFecha(this);" onkeypress="return Mascara('F',event);"
                                           value='<%=(dFechaHasta == null ? "" :  Fecha.showFechaForm(dFechaHasta))%>'>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <input type="checkbox" name="F1renovadas" id="F1renovadas" <%= sRenovadas.equals("S") ? "checked" : " "%>
                                           value="<%= (sRenovadas == null || sRenovadas.equals("") ? "N" : sRenovadas)    %>">&nbsp;Ver p&oacute;lizas renovadas
                                </td>
                            </tr>
                            <tr>
                                <td align="left"  class="text" valign="top" width="230" >Rama:&nbsp;
                                    <select name="F1cod_rama" id="F1cod_rama"   class="select">
                                        <option value='0' >Todas las rama</option>
    <%                           lTabla = oTabla.getRamas ();
                                 out.println(ohtml.armarSelectTAG(lTabla, iCodRama )); 
    %>
                                    </select>
                                </td>
                                <td align="left" class='text'>
                                (**) N&uacute;mero P&oacute;liza:&nbsp;<input name="F1num_poliza" id="F1num_poliza"  size='12' maxlength='12'
                                                                              value="<%= iNumPoliza %>"  onkeypress="return Mascara('D',event);"
                                                                              class="inputTextNumeric">
                                </td>
                            </tr>
                            <tr>
                                <td align="left"  class="text"  >(*) Nombre/Apellido/ R.Social Cliente:</td>
                                <td align="left"  class="text"><input name="F1nombre" id="F1nombre" size='45' value="<%= sNombre %>"></td>
                            </tr>
<%                      if (usu.getiCodTipoUsuario() == 0 || usu.getiCodTipoUsuario() == 1) {
    %>
                            <tr>
                                <td align="left" class="text" colspan='2'>Poliza grupo:&nbsp;
                                    <select class='select' name="F1grupo" id="F1grupo">
                                        <option value='0'>Seleccione grupo</option>
<%                                     lTabla = oTabla.getGrupos(usu.getusuario() );
                                        for (int i= 0; i < lTabla.size (); i++) {
                                            Grupo oG = (Grupo) lTabla.get(i);
                                            out.print("<option value='" + oG.getiCodGrupo() + "' "+ (oG.getiCodGrupo() == iGrupo ? "selected" : " ") + " >" + oG.getsDescripcion() + "</option>");
                                        }
                                        if (usu.getiCodTipoUsuario() == 0) {
                                            out.print("<option value='99999'>Todos los grupos</option>");
                                        }
    %>
                                    </select>
                                </td>
                            </tr>

<%                      } else {
    %>
    <input type="hidden" name="F1grupo" id="F1grupo"/>
<%                     }
    %>
                            </table>
                        </td>
                    </tr>
                    <TR>
                        <TD valign="middle" align="left" class='text' >(*) Puede ingresar el valor parcialmente.&nbsp;
                            Por ej: ingresando Oscar, visualizar&aacute; todas las p&oacute;lizas en la que el cliente contenga Oscar<br>
                        (**)&nbsp;<span style="color:red">ATENCI&Oacute;N:</span> Ingrese el n&uacute;mero de p&oacute;liza sin el digito verificador
                        </TD>
                    </TR>
                    <TR>
                        <TD align="center" >
                        <input type="button" name="cmdSalir"  value="  Salir  "  height="20px" class="boton" onClick="javascript:Salir ();"/>&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button" name="cmdGrabar" value="  Buscar  "  height="20px" class="boton" onClick="javascript:Buscar ('getAllPol');"/>
<%              if (usu.getiCodTipoUsuario() == 0 ) {
    %>
    &nbsp;&nbsp;&nbsp;&nbsp;<input type="button" name="cmdGrabar" value="Bajar a EXCEL"  height="20px" class="boton" onClick="javascript:Buscar ('getAllXLS');"/>
<%              }
    %>
                        </TD>
                    </TR>
                 </table>
            </form>
        </td>
    </tr>
<%
    if (sPri != null && sPri.equals ("N")) {
    %>

    <tr>
        <td>
            <table border="0"  width='100%' cellPadding="0" cellSpacing="1" align="left" >
                <tr>
                    <td height="30" class='titulo' width="70%" valign="middle" align="center">Resultado de la busqueda</td>
                </tr>
                <tr>
                    <td height="30" class='text' width="90%" valign="middle" align="left"><b><span style="color:red">NOTA:&nbsp;</span>
                        En la columna <b>Vidas</b> puede modificar la cantidad de asegurados a Recotizar/Renovar.&nbsp;
                        Si selecciona Renovar el sistema lo llevará a un formulario donde va poder realizar los cambios convenientes
                        a la propuesta de renovación</b>
                    </td>
                </tr>
                <tr>
                    <td align="right" class='text' width="90%" height="30" valign="middle">
                        <IMG src="<%= Param.getAplicacion()%>images/nuevo.gif">&nbsp;Ir a la propuesta de Renovación -&nbsp;
                        <IMG src="<%= Param.getAplicacion()%>images/nuevoP.gif">&nbsp;Consultar Póliza -&nbsp;
                        <IMG src="<%= Param.getAplicacion()%>images/ver_cotizacion.jpg">&nbsp;Recotizar póliza -&nbsp;
                        <IMG src="<%= Param.getAplicacion()%>images/finalizar.gif">&nbsp;RENOVAR -&nbsp;
                        <IMG src="<%= Param.getAplicacion()%>images/enviar.gif">&nbsp;Aviso enviado&nbsp;
                    </td>
                </tr>
                <tr>
                    <td valign="top"  width='100%'>
                        <pg:pager maxPageItems="20" items="<%= iSize %>" 
                                  url="/benef/servlet/RenuevaServlet"
                                  maxIndexPages="20"
                                  export="currentPageNumber=pageNumber">
                        <pg:param name="keywords" />
                        <table  border="1" cellspacing="0" cellpadding="2" align="center" class="TablasBody">
                            <thead>
                                <th width="20px" nowrap>Rama</th>
                                <th  width="50px">P&oacute;liza</th>
                                <th  width="120px" nowrap>Vigencias</th>
                                <th  width="110px" nowrap>Cliente</th>
                                <th  width="110px" nowrap>Productor</th>
                                <th  width="50px" nowrap>Prima</th>
                                <th  width="50px" nowrap>Premio</th>
                                <th  width="50px" nowrap>Vidas</th>
                                <th  width="80px">Opciones</th>
                            </thead>
                           <% if (iSize  == 0 ){%>
                            <tr>
                                <td colspan="9" height='25' valign="middle">
                                    <span style="color:red">No existen pólizas para la consulta realizada</span>
                                </td>
                            </tr>
<%                         } 
                           for (int i=0; i < iSize; i++)  {
                                 Poliza oPol = (Poliza) lPolizas.get(i); 
    %>
                          <pg:item>
                            <tr>
                                <td align="left" ><IMG src="<%= Param.getAplicacion()%>images/poliza.bmp" border='0'  style="cursor: hand;"
                                    onclick="VerPoliza ( '<%= oPol.getcodRama() %>' , '<%= oPol.getnumPoliza() %>' );">&nbsp;<%= oPol.getdescRama ()%>
                                </td>
                                <td align="right"><%= oPol.getnumPoliza() %></td>
                              <td align="center" nowrap><%= (oPol.getfechaInicioVigencia() == null ? "no informado" : Fecha.showFechaForm(oPol.getfechaInicioVigencia())) +
                                                     "-" + (oPol.getfechaFinVigencia ()==null ? " " :
                                                     Fecha.showFechaForm(oPol.getfechaFinVigencia ()))  %>
                                </td>
                                <td align="left" nowrap><%= oPol.getrazonSocialTomador ()%>&nbsp;</td>
                               <td align="left" nowrap><%= oPol.getdescProductor ()%>&nbsp;</td>
                                <td align="center"><%= (oPol.getPremio().getimpPrima() == 0 ? "-" : Dbl.DbltoStr(oPol.getPremio().getimpPrima(), 2)) %></td>
                                <td align="center"><%= (oPol.getPremio().getMpremio() == 0 ? "-" : Dbl.DbltoStr(oPol.getPremio().getMpremio(), 2)) %></td>
                                <td align="center"><input type="text" name="<%=oPol.getcodRama()%>_<%=oPol.getnumPoliza()%>_vidas" value="<%= oPol.getcantVidas() %>"
                                                          id="<%=oPol.getcodRama()%>_<%=oPol.getnumPoliza()%>_vidas" maxlength="3" size="3"
                                                          onkeypress="return Mascara('D',event);" class="inputTextNumeric" onchange="javascript:ModifVidas(<%= oPol.getnumPropuesta() %>);">
                                    <input type="hidden" name="<%=oPol.getcodRama()%>_<%=oPol.getnumPoliza()%>_cotiz" value="<%= oPol.getnumCotizacion()%>"
                                                          id="<%=oPol.getcodRama()%>_<%=oPol.getnumPoliza()%>_cotiz">
                                    <input type="hidden" name="<%=oPol.getcodRama()%>_<%=oPol.getnumPoliza()%>_vidas_orig" value="<%= oPol.getcantVidas() %>"
                                                          id="<%=oPol.getcodRama()%>_<%=oPol.getnumPoliza()%>_vidas_orig">
                                </td>
                                <td align="center">
<%                              if (oPol.getestado().equals("ANULADA")) {
    %>
    <span style="color: red">Anulada</span>
<%                              } else { if (oPol.getrenovadaPor() != 0) {
    %>
    <span style="color: blue">Renovada por&nbsp;<%= oPol.getrenovadaPor() %></span>
<%                              } else {
                                     if (oPol.getnumPropuesta() > 0){
    %>
                                    <IMG src="<%= Param.getAplicacion()%>images/nuevo.gif" onclick="EditarPropuesta ( <%= oPol.getnumPropuesta() %> );"
                                         alt="Ver póliza" style="cursor: hand;">
                                    &nbsp;<span style="color: green">Propuesta N&deg;<%= oPol.getnumPropuesta() %></span>
<%                                  } else {
                                         if (oPol.getcodCobFinal() > 0) {
    %>
                                        <IMG src="<%= Param.getAplicacion()%>images/nuevoP.gif" onclick="VerPoliza ( '<%= oPol.getcodRama() %>' , '<%= oPol.getnumPoliza() %>' );"
                                             alt="Ver póliza" style="cursor: hand;">
                                        &nbsp;&nbsp;
                                        <IMG src="<%= Param.getAplicacion()%>images/enviar.gif" onclick="alert ('Ya fue enviado el mensaje de aviso de renovación al sector');"
                                             alt="Mensaje de aviso de renovación ya enviado al sector" style="cursor: hand;">
                                        &nbsp;&nbsp;
<%                                       } else {
    %>
                                        <IMG src="<%= Param.getAplicacion()%>images/nuevoP.gif" onclick="javascript:VerPoliza ('<%= oPol.getcodRama() %>','<%= oPol.getnumPoliza() %>');"
                                             alt="Ver póliza" style="cursor: hand;">
                                        &nbsp;&nbsp;
                                        <IMG src="<%= Param.getAplicacion()%>images/ver_cotizacion.jpg" onclick="javascript:Recotizar ('<%= oPol.getcodRama() %>','<%= oPol.getnumPoliza() %>');"
                                             alt="Recotizar póliza" style="cursor: hand;">
                                        &nbsp;&nbsp;
                                        <IMG src="<%= Param.getAplicacion()%>images/finalizar.gif" onclick="javascript:Renovar('<%= oPol.getcodRama() %>','<%= oPol.getnumPoliza() %>','<%= oPol.getestado() %>' );"
                                             alt="Emitir la propuesta de renovación"  style="cursor: hand;">
<%                                       }
                                     }
                                  }
                               }
    %>
                                </td>
                            </tr>
                        </pg:item> 
<%                          }
   %>
                            <thead>
                                <th colspan="9">
                                    <pg:prev>
                                    <a class="rnavLink" href="<%= pageUrl %><%= sPath%>">[Anterior]</a>
                                    </pg:prev>
                                    <pg:pages  >
                               <% if (pageNumber == currentPageNumber ) { %>
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
            </table>
        </td>
   </tr>
<%   
    }
%>
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
