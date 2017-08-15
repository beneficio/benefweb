<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Propuesta"%>
<%@page import="com.business.beans.Clausula"%>
<%@page import="com.business.beans.UbicacionRiesgo"%>
<%@page import="com.business.beans.AseguradoPropuesta"%>
<%@page import="com.business.beans.AsegCobertura"%>
<%@page import="com.business.beans.Cobertura"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Documentacion"%>
<%@page import="java.util.*"%>
<%@page import="java.util.LinkedList"%>
<%  

    Usuario usu = (Usuario) session.getAttribute("user"); 
    String origen       = (String) request.getAttribute ("origen");
    Propuesta oProp     = (Propuesta) request.getAttribute ("propuesta");
    LinkedList lNomina  = (LinkedList) request.getAttribute("nominas");

    UbicacionRiesgo oRiesgo = oProp.getoUbicacionRiesgo();

    if (oRiesgo == null) { oRiesgo = new UbicacionRiesgo (); }
    
    String sColorEstado = "black";
    int    nroProp      = 0;
    String nroPropDesc  = "SIN ASIGNAR";
    int    codProd      = 0;
    String descProd     = "";
    int    codVig       = 0 ;
    int    codActividad = 0 ;

    String nomApe       = ""; 
    String domicilio    = "";
    String localidad    = "";
    String codigoPostal = "";    
    String documento    = ""; 
    String telefono     = "";
    String mail         = "";
    String tipoDoc      = "" ;
     
    String fechaVigDesde = "";
    String fechaVigHasta = "";

    double capMuerte    = 0.0;
    double capAsist     = 0.0; 
    double capInvalidez = 0.0; 
    double franquicia   = 0.0;
    double premio       = 0.0;
    double prima        = 0.0;

    String observacion   ="";
    int    formaPago     =0; 

    String sTarjeta         = "";
    String titularTarj      = "";
    String titularCta       = "";
    String fechaVtoTarjCred = "";
    String nroTarjCred      = "";
    String sucursal         = "";
    String CBU              = "";
    int    codTarjeta       = 0;
    int    codBcoTarj       = 0;
    int    codBcoCta        = 0;    

    int    nroCot       = 0; 
    int    cantCuotas   = 0 ;
    int    numSocio     = 0; // num Tomador
    int    codEstado    = 0;

    if (oProp != null) {
        if (oProp.getNumPropuesta()>0) {
            nroPropDesc = String.valueOf(oProp.getNumPropuesta());
            nroProp     = oProp.getNumPropuesta();
        }
        switch ( oProp.getCodEstado() ) { 
            case  0:
            case  2:
            case  4:
               sColorEstado = "red";
            break;
            case 1:
            case 7:
            case 5: 
                sColorEstado = "green";
            break;
            default: 
                sColorEstado = "black";
            break;
        }
    }

    codProd      = oProp.getCodProd();
    descProd     = oProp.getdescProd();
    codVig       = oProp.getCodVigencia ();
    codActividad = oProp.getCodActividad();
    
    telefono     = (oProp.getTomadorTE ()==null)?"":oProp.getTomadorTE ();
    mail         = (oProp.getTomadorEmail()==null)?"":oProp.getTomadorEmail();
    
    numSocio     = oProp.getNumTomador();
    nomApe       = oProp.getTomadorRazon();
    documento    = oProp.getTomadorNumDoc();
    tipoDoc      = oProp.getTomadorDescTipoDoc();
    domicilio    = (oProp.getTomadorDom()==null)?"":oProp.getTomadorDom();
    localidad    = (oProp.getTomadorLoc()==null)?"":oProp.getTomadorLoc();
    codigoPostal = (oProp.getTomadorCP()==null)?"":oProp.getTomadorCP();    
    nroCot       = oProp.getNumSecuCot    ();
    cantCuotas   = oProp.getCantCuotas    ();
    codEstado    = oProp.getCodEstado();
    
    String disabled; 
    if (codEstado == 0 ) {
        disabled = "";
    } else if(codEstado==4){  
        disabled = "";
    } else {
        disabled = "disabled";
    }

    capMuerte    = oProp.getCapitalMuerte();
    capAsist     = oProp.getCapitalAsistencia ();
    capInvalidez = oProp.getCapitalInvalidez  ();
    franquicia   = oProp.getFranquicia        ();
    premio       = oProp.getImpPremio         ();
    if (oProp.getcodPlan() > 0 ) { 
        prima        = oProp.getprimaPura  (); 
    } else {
        prima        = oProp.getImpPrimaTar(); 
    } 

    observacion   = (oProp.getObservaciones() == null ? " " : oProp.getObservaciones()) ; 
    formaPago     = oProp.getCodFormaPago();

    if ( formaPago == 1 ) {
        
        if (oProp.getVencTarjCred() != null) {
            fechaVtoTarjCred = Fecha.showFechaForm(oProp.getVencTarjCred());
        }
        sTarjeta         = oProp.getDescTarjCred();
        nroTarjCred      = oProp.getNumTarjCred();
        titularTarj      = oProp.getTitular();
        codTarjeta       = oProp.getCodTarjCred();
        codBcoTarj       = oProp.getCodBanco();
    }
    if ( formaPago == 2 || formaPago == 3 || formaPago == 6) {
        CBU        = oProp.getCbu();
        sucursal   = oProp.getSucBanco();
        titularCta = oProp.getTitular();
        codBcoCta  = oProp.getCodBanco();
    }

    if ( formaPago == 4  ) {
        CBU        = oProp.getCbu();
    }
    
    Tablas oTabla = new Tablas();
    LinkedList <Documentacion> lDoc = oTabla.getAllDocumentos (0, 0, oProp.getNumPropuesta(), 0, 0, 0, 0, 0, usu.getusuario());
    
    String formaEnvio = "La p&oacute;liza se enviar&aacute; por mail"; 
    if ( oProp.getMcaEnvioPoliza().equals ("S")) {
        formaEnvio = "La p&oacute;liza se enviar&aacute; por correo";
    } else  if ( oProp.getMcaEnvioPoliza().equals ("N")) {
        formaEnvio = "La p&oacute;liza no ser&aacute; enviada";
        }
%>
<HTML> 
<head><title>Impresi&oacute;n de propuesta</title></head>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css">
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script language='javascript'>

    function Trim(TRIM_VALUE){
        if(TRIM_VALUE.length < 1){
          return"";
        }
        TRIM_VALUE = RTrim(TRIM_VALUE);
        TRIM_VALUE = LTrim(TRIM_VALUE);
        if(TRIM_VALUE==""){
            return "";
        }
        else{
           return TRIM_VALUE;
        }
    } //End Function

    function RTrim(VALUE){
        var w_space = String.fromCharCode(32);
        var v_length = VALUE.length;
        var strTemp = "";
        if(v_length < 0){
        return"";
        }
        var iTemp = v_length -1;

        while(iTemp > -1){
        if(VALUE.charAt(iTemp) == w_space){
        }
        else{
        strTemp = VALUE.substring(0,iTemp +1);
        break;
        }
        iTemp = iTemp-1;

        } //End While
        return strTemp;

    } //End Function

    function LTrim(VALUE){
        var w_space = String.fromCharCode(32);
        if(v_length < 1){
        return"";
        }
        var v_length = VALUE.length;
        var strTemp = "";

        var iTemp = 0;

        while(iTemp < v_length){
        if(VALUE.charAt(iTemp) == w_space){
        }
        else{
        strTemp = VALUE.substring(iTemp,v_length);
        break;
        }
        iTemp = iTemp + 1;
        } //End While
        return strTemp;
    } //End Function

    function HabilitarDiv(divName) {
          
        // for(i=1; i<=2; i++) 
        for(i=1; i<=3; i++) 
            document.getElementById('div_' + i).style.visibility = 'hidden';
	  
        if (divName ==1 ) {
            document.getElementById('div_1').style.visibility = 'visible';
        }
 
        if ((divName ==2) || (divName ==3)) {
            document.getElementById('div_2').style.visibility = 'visible';
        }

        if (divName ==4 ) {
            document.getElementById('div_3').style.visibility = 'visible';
        }
    }
</script>
<body leftmargin=0 topmargin=0 style="margin-top: 0; margin-right: 0; margin-left: 0; margin-bottom: 0; padding-bottom: 0; padding-left: 0; padding-right: 0; padding-top: 0; top: 0; vertical-align: top;">
    <TABLE align="center" width='700' border='1' cellpadding='0' cellspacing='6' >
        <tr>
            <td width='100%' height='60'>
                <table border='0' cellpadding='2' cellspacing='0' width='100%'>
                    <tr>
                        <td width='10%' valign="top" align="right"><img src="<%= Param.getAplicacion()%>images/logos/logo_beneficio_new.jpg"  border='0'></td>
                        <td width='90%' valign="top" align="center" class="titulo">FORMULARIO DE PROPUESTA DE&nbsp;<%= (oProp.getTipoPropuesta().equals("R") ? "RENOVACION DE" : "")%>&nbsp;P&Oacute;LIZA</td>
                    </tr>
                </table>
            </td>
        </tr>
<%      if (codProd == 1 || codProd == 2 || codProd == 3 || codProd == 31038) {
    %>
        <tr>
            <td height="40" valign="middle" align="left" class="titulo" style="color:red;">PROPUESTA NO VÁLIDA - ESTO ES UNA DEMOSTRACION</td>
        </tr>
<%      }
    %>
        <TR>
            <TD align="center" valign="top" width='720'>
                 <TABLE border='0' width='100%'> 
                    <TR>
                        <TD>
                            <TABLE border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>               
                                <TR>
                                    <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'>Datos Generales</TD>
                                </TR>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text' width='100'>Propuesta Nº:</TD>
<%                              if (oProp.getTipoPropuesta().equals("R")) {
    %>
                                    <TD align="left" class='text' width='500'><b><%=oProp.getBoca() %>&nbsp;<%=nroPropDesc%>&nbsp;&nbsp;-&nbsp;Renueva p&oacute;liza&nbsp;<%= oProp.getNumPoliza() %>&nbsp;-&nbsp;Estado&nbsp;
                                            <span style="color:<%=sColorEstado%>;"><%= oProp.getdescEstado() %></span>
                                        </b></TD>
<%                              } else {
    %>
                                    <TD align="left" class='text' width='500'><b><%=oProp.getBoca() %>&nbsp;<%=nroPropDesc%>&nbsp;-&nbsp;Estado&nbsp;
                                            <span style="color:<%=sColorEstado%>;"><%= oProp.getdescEstado() %></span>
                                        </b></TD>
<%                              }
    %>
                                </TR>
                                <TR> 
                                    <td>&nbsp;</td>
                                    <TD align="left"  class="text" valign="top" >Rama/Sub Rama:&nbsp;</TD>
                                    <TD align="left"  class="text"><b><%= oProp.getDescRama() %>&nbsp;/&nbsp;<%= oProp.getDescSubRama() %></b></TD>
                                </TR>
<%                      if (oProp.getcodPlan () > 0) {
                            if (oProp.getCodRama() == 21 ) {
    %>
                                <TR>
                                    <td>&nbsp;</td>
                                    <TD align="left"  class="text" valign="top" >Producto:&nbsp;</TD>
                                    <TD align="left"  class="text"><b><%= oProp.getcodPlan()%></b></TD>
                                </TR>
<%                          } else {
    %>
                                <TR> 
                                    <td>&nbsp;</td>
                                    <TD align="left"  class="text" valign="top" >Descripci&oacute;n del Plan:&nbsp;</TD>
                                    <TD align="left"  class="text"><b><%= oProp.getdescPlan() %></b></TD>
                                </TR>
<%                          }
                        } else {
    %>
                                <TR>
                                    <td>&nbsp;</td>
                                    <TD align="left"  class="text" valign="top" >Producto:&nbsp;</TD>
                                    <TD align="left"  class="text"><b><%= (oProp.getdescProducto() == null ? "&nbsp;" : oProp.getdescProducto())%></b></TD>
                                </TR>
<%                  }
    %>
                                <TR>
                                    <td>&nbsp;</td>
                                    <TD align="left" class='text'>Productor:</TD>
                                    <TD align="left" class='text'><%=descProd%>&nbsp;Cod&nbsp;:&nbsp;<%=codProd%></TD>
                                </TR>                          
                                <TR>
                                    <td>&nbsp;</td>
                                    <TD align="left" class='text'>Fecha de env&iacute;o:</TD>
                                    <TD align="left" class='text'><%= (oProp.getFechaEnvioProd () == null ? "no enviado" : Fecha.showFechaForm(oProp.getFechaEnvioProd ())) %>&nbsp;,&nbsp;<%= oProp.getHoraEnvioProd () %>&nbsp;hs.&nbsp;por&nbsp;<%= oProp.getUserid() %></TD>
                                </TR>
                                <TR>
                                    <td>&nbsp;</td>
                                    <TD align="left" class='text'>Vigencia:</TD>
<%                              if ( oProp.getFechaFinVigPol() != null && Fecha.showFechaForm(oProp.getFechaFinVigPol()).equals("01/01/1900") ) {     
    %>
                                    <TD align="left" class='text'><b><%= oProp.getdescVigencia() %>&nbsp;&nbsp;&nbsp;-&nbsp;Desde:&nbsp;<%=Fecha.showFechaForm(oProp.getFechaIniVigPol()) %></b></TD>                                    
<%                                     
                                } else {   
    %>                                
                                    <td align="left" class='text'><b><%= oProp.getdescVigencia() %>&nbsp;&nbsp;&nbsp;-&nbsp;Desde:&nbsp;<%=Fecha.showFechaForm(oProp.getFechaIniVigPol()) %>&nbsp;al&nbsp;<%=Fecha.showFechaForm(oProp.getFechaFinVigPol())%></b></td>
<%                                     
                                } 
    %>                                
                                </TR>
                                <TR>
                                    <td>&nbsp;</td>
                                    <TD align="left" class='text'>Facturaci&oacute;n:</TD>
                                    <TD align="left" class='text'><%= oProp.getDescFacturacion () %></TD>
                                </TR>

                                <% if (oProp.getCodRama()== 10)  { %>                                
                                <TR>
                                    <td>&nbsp;</td> 
                                    <TD align="left" class='text'>Actividad :</TD>                                
                                    <TD align="left" class='text'><%= oProp.getdescActividad () %></TD>
                                </TR>
                                <%}  %> 
                            </TABLE>
                        </TD>
                    </TR>         
                    <TR>
                        <TD>
                            <TABLE border='0' align='left' class="fondoForm" style='margin-top:10;margin-bottom:10;' width='100%'>                                       
                                <TR>
                                    <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'>Datos del Tomador</TD>
                                </TR>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text' width='100'>Nombre y Apellido:</TD>
                                    <TD align="left" class='text' width='500'><%=nomApe%></TD>
                                </TR>
                                <TR> 
                                    <td>&nbsp;</td>
                                    <TD align="left" class='text'><%= tipoDoc %>:</TD>
                                    <TD align="left" class='text'><%=documento%></TD>
                                </TR>
                                <TR>
                                    <td >&nbsp;</td>
                                    <TD align="left" class='text'>Condici&oacute;n&nbsp;IVA:</TD>
                                    <TD align="left" class='text'><%= oProp.getTomadorDescCondIva() %></TD>                   
                                </TR>
                                <TR>
                                    <td >&nbsp;</td>
                                    <TD align="left" class='text'>Domicilio:</TD>
                                    <TD align="left" class='text'><%=domicilio%></TD>
                                </TR>
                                <TR>
                                    <td >&nbsp;</td>
                                    <TD align="left" class='text'>Localidad:</TD>
                                    <TD align="left" class='text'><%=localidad%></TD>
                                </TR>
                                <TR>                   
                                    <td>&nbsp;</td>
                                    <TD align="left" class='text'>C&oacute;digo&nbsp;Postal:</TD>
                                    <TD align="left" class='text'><%=codigoPostal%></TD>
                                </TR>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text'>Lugar de trabajo:</TD>
                                    <TD align="left" class='text'><%= (oProp.getempleador() == null ? " " : oProp.getempleador()) %></TD>
                                </TR>
                                <TR>                   
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text'>Mail:</TD>
                                    <TD align="left" class='text'><%=mail%></TD>
                                </TR>            
                                <TR>                   
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text'>Tel&eacute;fono:</TD>
                                    <TD align="left" class='text'><%=telefono%></TD>
                                </TR>            
                                <TR> 
                                    <td>&nbsp;</td>
                                    <TD align="left" class='text'>Provincia:</TD>
                                    <TD align="left" class='text'><%= oProp.getTomadorDescProv () %></TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>         
<% if (oProp.getCodRama()== 10 || oProp.getCodRama () == 22 )  { %>
                    <TR>
                        <TD>
                            <TABLE border='0' align='left' class="fondoForm" style='margin-top:10;margin-bottom:10;' width='100%'>                                       
                                <TR>
                                    <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'>Ubicaci&oacute;n del Riesgo</TD>
                                </TR>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text'  width='100' nowrap>Domicilio:</TD>
                                    <TD align="left" class='text'><%=oRiesgo.getdomicilio ()%></TD>
                                </TR>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text'>Localidad:</TD>
                                    <TD align="left" class='text'><%=oRiesgo.getlocalidad ()%></TD>
                                </TR>
                                <TR>                   
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text'>C&oacute;digo&nbsp;Postal:</TD>
                                    <TD align="left" class='text'><%=oRiesgo.getcodPostal ()%></TD>
                                </TR>   
                                <TR> 
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text'>Provincia:</TD>
                                    <TD align="left" class='text'><%= oRiesgo.getdescProvincia() %></TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>         
<% }
          if (oProp.getCodRama() == 9 || oProp.getnivelCob().equals("P") ) {
          %>
                    <TR>
                        <TD>
                            <TABLE border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>                                       
                                <TR>
                                    <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'>Sumas Aseguradas</TD>
                                </TR>
<%                                 if (oProp.getAllCoberturas() != null) {
                                      LinkedList lCob = oProp.getAllCoberturas() ;                                       
                                       for (int i = 0 ; i < lCob.size() ;i++) {
                                           AsegCobertura oCob = (AsegCobertura) lCob.get(i);                                           
                                %>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text' width='200px'><%=oCob.getdescripcion()%>:</TD>                               
                                    <TD align="left" class='text'>&nbsp;$&nbsp;<%= Dbl.DbltoStr(oCob.getimpSumaRiesgo(),2)%></TD>
                                </TR>                   
<%                                       }
                                     }
                                 if (oProp.getCodRama () == 10) {
    %>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text' width='200px'>Franquicia:</TD>
                                    <TD align="left" class='text'>&nbsp;$&nbsp;<%= Dbl.DbltoStr(franquicia,2)%></TD>
                                </TR>
<%                              }
    %>
                            </TABLE>
                        </TD>
                    </TR>
<%              }
    %>
                    <TR>
                        <TD>
                            <TABLE border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>
                                <TR>
                                    <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'>Premio</TD>
                                </TR>
 <%                     if (oProp.getCodRama() != 22) {
    %>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text' width='200px'><b>Prima:</b></TD>                                 
                                    <TD align="left" class='text'><b>&nbsp;$&nbsp;<%= Dbl.DbltoStr(prima,2)%></b></TD>
                                </TR>
<%                      }
    %>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text' width='200px'><b>Premio:</b></TD>                                 
                                    <TD align="left" class='text'><b>&nbsp;$&nbsp;<%= Dbl.DbltoStr(premio,2)%></b></TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>    
                    <TR>
                        <TD>
                            <TABLE border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>                                       
                                <TR>
                                    <TD colspan='2' height="30px" valign="middle" align="left" class='titulo'>Forma de Pago</TD>
                                </TR>
                                <TR>
                                    <td width='10'>&nbsp;</td>                                
                                    <TD align="left" class='text'>Forma de Pago:&nbsp;<B><%= oProp.getdescFormaPago() %>&nbsp;en&nbsp;<%= cantCuotas %>&nbsp;cuota/s&nbsp;por&nbsp;por facturaci&oacute;n</B>
                                </TD>
                            </TR>                                                       
			    <!-- Comienzo divs -->  
<%                      if ( formaPago == 1 ) {
    %>
                            <TR>
                                <td width='10'>&nbsp;</td>                                
                                 <TD class="text" height="20" valign="center" >Datos de Tarjeta de Cr&eacute;dito:</TD>
                            </TR>
                            <TR>
                                <td width='10'>&nbsp;</td>
                                <TD valign="top">
                                    <TABLE  align="left" style="MARGIN-LEFT: 5px">
                                        <TR>
                                            <TD  width='100px' class="text">Tarjeta:</TD>
                                            <TD  width='150px'  class='text'><%= sTarjeta %></TD>
                                            <TD class="text"  >N&uacute;mero:&nbsp;</TD>
                                            <TD  class='text'><%=nroTarjCred%></TD>
                                        </TR>
                                    </TABLE>
                                </TD>
                            </TR>
<%                      }
                      if ( formaPago == 2 || formaPago == 3) {
    %>
                            <TR>
                                <td width='10'>&nbsp;</td>                                
                                <TD class="text" height="20" valign="center">Datos de la Cuenta:</TD>
                            </TR>
                            <tr>
                                <td width='10'>&nbsp;</td>
                                <td>
                                    <TABLE border="0" align="left" style="MARGIN-LEFT: 5px;">
                                        <TR>
                                            <TD  class='text'>Banco:</TD>
                                            <TD  class='text'><%= codBcoCta %></TD>
                                            <TD  class="text">Sucursal:</TD>
                                            <TD align="left"  class='text'><%=sucursal%></TD>
                                        </TR>
                                        <TR> 
                                            <TD  width='60px' class="text" >CBU:</TD>
                                            <TD  align="left" colspan='3'  class='text'><%=CBU%></TD>
                                        </TR>
                                    </TABLE> 
                                 </td>
                            </tr>
<%                      }
                      if ( formaPago == 4 ) {
    %>
                            <TR>
                                <td width='10'>&nbsp;</td>                                
                                <TD class="text" height="20" valign="center">D&eacute;bito en Cuentas:</TD>
                            </TR>
                            <tr>
                                <td width='10'>&nbsp;</td>
                                <td>
                                    <TABLE border="0" align="left" style="MARGIN-LEFT: 5px">                                                                        
                                        <TR> 
                                            <TD  width='40px' class="text" >CBU:</TD>
                                            <TD  align="left" colspan='3'  class="text"><%=CBU%></TD>
                                        </TR>
                                    </TABLE>
                                </td>
                            </tr>                          
<%                  } if (formaPago == 6 ){
    %>
                            <tr>
                                <td width='10'>&nbsp;</td>
                                <td>
                                    <TABLE border="0" align="left" style="MARGIN-LEFT: 5px">
                                        <TR>
                                            <TD  class='text'>Empresa:</TD>
                                            <TD  class='text'><%= codBcoCta %></TD>
                                            <TD  class="text">Cuenta:</TD>
                                            <td align="left"  class='text'><%=CBU%>&nbsp;(<%=titularCta%>) </td>
                                        </TR>
                                    </TABLE>
                                 </td>
                            </tr>

<%                      }
    %>
                        </TABLE>
                    </TD>
                </TR>
                <TR>   
                     <TD>
                          <TABLE border='0' align='left' class="fondoForm" style='margin-top:10;margin-bottom:10;' width='100%'>                                       
                            <TR>
                                <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'>Informaci&oacute;n Adicional</TD>
                            </TR>
                            <TR>
                                <td width='10'>&nbsp;</td>
                                <TD align="left" class='text' valign="top" width='100' nowrap ><%= formaEnvio %></TD>
                                <TD align="left" class='text' >&nbsp;</TD>
                            </TR>
                            <tr><td colspan='3'><hr></td></tr>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text' valign="top" width='150' nowrap>Beneficiarios:</TD>                                
                                <TD align="left" class='text' >
                                    <input type="CHECKBOX" value='<%= oProp.getbenefHerederos () %>' name='prop_benef_herederos' <%= (oProp.getbenefHerederos().equals ("S") ? "checked" : " ") %> readonly>&nbsp;Herederos legales<br>
                                    <input type="CHECKBOX" value='<%= oProp.getbenefTomador () %>' name='prop_benef_tomador' <%= (oProp.getbenefTomador().equals ("S") ? "checked" : " ") %> readonly>&nbsp;Tomador
                                 </TD>                                
                            </TR>
                            <tr><td colspan='3'><hr></td></tr>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text' valign="top" width='150' nowrap>Num. Referencia:</TD>
                                <TD align="left" class='text' ><%= oProp.getnumReferencia() %> </TD>
                            </TR>

<% if ( oProp.getCodRama()== 10 || oProp.getCodRama() == 22 )  { %>    
                            <tr><td colspan='3'><hr></td></tr>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text' valign="top" width='150' nowrap>Cl&aacute;usulas:</TD>                                
                                <TD align="left" class='text' >
                                    <input type="CHECKBOX" value='<%= oProp.getclaNoRepeticion () %>' name='prop_cla_no_repeticion'  <%= (oProp.getclaNoRepeticion ().equals ("S") ? "checked" : " ") %> readonly>&nbsp;Cl&aacute;usula de No Repetici&oacute;n<br>
                                    <input type="CHECKBOX" value='<%= oProp.getclaSubrogacion () %>' name='prop_cla_subrogacion' <%= (oProp.getclaSubrogacion ().equals ("S") ? "checked" : " ") %> readonly>&nbsp;Cl&aacute;usula de Subrogaci&oacute;n
                                 </TD>                                
                            </TR>
<%                   if (oProp.getAllClausulas().size() > 0 ) { 
    %>
                            <TR>
                                <td >&nbsp;</td>
                                <TD align="left" class='text' valign="top"nowrap>Lista de Empresas:</TD>                                
                                <TD class='text'  align="left">&nbsp;&nbsp;&nbsp;&nbsp;Cuit&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Empresa</TD>                                
                            </TR>                            
<% 
                        for (int i = 1;i <= oProp.getAllClausulas().size() ;i++) {
                            Clausula oCla = (Clausula) oProp.getAllClausulas().get(i - 1);
                            
    %>
                            <TR>
                                <TD colspan="2">&nbsp;</TD>
                                <TD align="left" class='text' >
                                    <input type="hidden" name="CLA_ITEM_<%= i %>">
                                    <input type="text" name="CLA_CUIT_<%= i %>" value="<%= oCla.getcuitEmpresa() %>" size='12' maxlength='12'  onkeypress="return Mascara('D',event);" onblur="ValidoCuitEmpresa ( this );"  class="inputTextNumeric">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <input type="text" name="CLA_DESCRIPCION_<%= i %>" value="<%= oCla.getdescEmpresa() %>" size='50' maxlength='50'>
                                 </TD>                                
                            </TR>
<%                          }
                        }
                    }
    %>
                           </TABLE>
                        </TD>
                    </TR>             
<%      if (observacion != null &&  ! observacion.equals ("") ) {
    %>
                <TR>
                    <TD>
                        <TABLE border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>                                       
                            <TR>
                                <TD align="left" class='text'>Observaci&oacute;n :</TD>                                
                            </TR>
                            <TR>                           
                                <TD width="100%" class='text'><B><%=observacion%></B></TD>
                            </TR>
                        </TABLE>
                    </TD>
                </TR>
<%      }
        if (lDoc != null && lDoc.size() > 0 ) {
    %>
                <TR>   
                     <TD>
                          <TABLE border='0' align='left' class="fondoForm" style='margin-top:10;margin-bottom:10;' width='100%'>                                       
                            <TR>
                                <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'>Documentaci&oacute;n adjunta</TD>
                            </TR>
<%          
                                for (int i=0;i<lDoc.size();i++) {
                                    Documentacion oDoc = (Documentacion) lDoc.get(i);
                                    if (oDoc.getmcaBaja() == null || 
                                            (oDoc.getmcaBaja() != null && oDoc.getmcaBaja().equals("") )) {                                     
    %>
                            <tr>
                                <td class="text" align="left" colspan="3"><%= oDoc.getDescTipoDoc() %>:&nbsp;<a href="<%= Param.getAplicacion() %>files/doc/<%= oDoc.getnomArchivo() %>" target="_blank"><%= oDoc.getnomArchivo() %></a> </td>        
                            </tr>
<%    
                                    }
                                }
    %>
                            
                        </TABLE>
                    </TD>
                </TR>
    
<%      }
        if (lNomina.size () > 0) { 
%>                
                <TR>
                    <TD>
                        <TABLE border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>                                       
                            <TR>
                                <TD height="30px" valign="middle" align="left" class='titulo'>N&oacute;mina</TD>
                            </TR>
                            <TR>
                                <TD width='100%'>
                                    <TABLE  border="0" cellspacing="0" cellpadding="0" align="center" class="TablasBody" style='margin-top:10;margin-bottom:10;margin-left:10;'>
                                        <thead>
                                            <th nowrap width="50px">Orden</th>
                                            <th nowrap width="250px">Nombre y Apellido</th>
                                            <th nowrap width="80px">Documento</th>
                                            <th nowrap width="60px">Parentesco</th>
                                            <th nowrap width="70px">Fecha Nac.</th>
                                            <th nowrap width="60px">Mano</th>
                                        </thead>
<%                                  if ( oProp.getnivelCob().equals("N") ) {
    %>
                                        <thead>
                                            <th nowrap width="50px">&nbsp;</th>
                                            <th nowrap width="250px">Coberturas</th>
                                            <th nowrap width="80px">Suma Aseg.</th>
                                            <th nowrap width="60px" colspan="3">&nbsp;</th>
                                        </thead>
<%                                  }
                                  for( int i=0; i < lNomina.size(); ++i) {
                                        AseguradoPropuesta oAseg = (AseguradoPropuesta)lNomina.get(i);
                    %>
                                        <TR>                                  
                                            <TD align='left'  class="text"><%= oAseg.getCertificado() %>.<%= oAseg.getSubCertificado() %>&nbsp;</TD>
                                            <TD align='left'  class="text">&nbsp;<%= oAseg.getNombre() %></TD>
                                            <TD align='left'  class="text"><%= oAseg.getDescTipoDoc() %>&nbsp;<%= oAseg.getNumDoc()%>&nbsp;</TD>
                                            <TD align='left'  class="text"><%= (oAseg.getdescParentesco() == null ? "&nbsp;":oAseg.getdescParentesco()) %>&nbsp;</TD>
                                            <TD align='center'  class="text"><%= (oAseg.getFechaNac() == null ? "no informado" : Fecha.showFechaForm(oAseg.getFechaNac())) %>&nbsp;</TD>
<%                                      if (oAseg.getmano() == null || oAseg.getmano ().equals ("")) {
    %>
                                            <TD align='center'  class="text">no info</TD>
<%                                      } else {
    %>
                                            <TD align='center'  class="text"><%= (oAseg.getmano().equals ("D") ? "Diestro" : "Zurdo") %>&nbsp;</TD>
<%                                      }
    %>
                                        </TR>
<%                                      if (oAseg.getlCoberturas() != null && oAseg.getlCoberturas().size()> 0 ) {
                                            for (int ii=0;ii < oAseg.getlCoberturas().size();++ii) {
                                                Cobertura oCob = (Cobertura) oAseg.getlCoberturas().get(ii); 
    %>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <TD align='left' class="text" ><%= oCob.getcodCob()%>.<%= oCob.getdescripcion() %></TD>
                                            <TD align="right"  class="text"><%= Dbl.DbltoStr(oCob.getsumaAseg(), 2) %></TD>
                                            <TD colspan="3">&nbsp;</TD>
                                        </tr>
                    <%                      }
                                        }
                            }
                    %>
                                    </TABLE>		
                                </TD>
                            </TR>
                            <TR>
                                <TD height="30px" valign="middle" align="left" class='text'>
En cumplimiento de lo dispuesto por la Disposición 10/08, Beneficio pone en conocimiento que:<br/> 
Los presentes datos son recolectados en funci&oacute;n de la propuesta de seguros que por este se formaliza.
El titular de los datos personales tiene la facultad de ejercer el derecho de acceso a los mismos en forma gratuita a intervalos no
inferiores a seis meses, salvo que se acredite un inter&eacute;s leg&iacute;timo al efecto conforme lo establecido en el art. 14, inc. 3 de la Ley Nº
25.326. La Direcci&oacute;n Nacional de Protecci&oacute;n de Datos Personales, &oacute;rgano de Control de la Ley Nº 25.326, tiene la atribuci&oacute;n de atender
las denuncias y reclamos que se interpongan con relaci&oacute;n al incumplimiento de las normas sobre protecci&oacute;n de datos personales
                                </TD>
                            </TR>
                        </TABLE>
                    </TD>
                </TR>
<%
    } 
%>
          </TABLE>
</body>
</html>   
