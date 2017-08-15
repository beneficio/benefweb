<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Propuesta"%>
<%@page import="com.business.beans.Clausula"%>
<%@page import="com.business.beans.UbicacionRiesgo"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="java.util.*"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<%  
    Usuario usu = (Usuario) session.getAttribute("user"); 
    HtmlBuilder ohtml  = new HtmlBuilder();
    Tablas      oTabla = new Tablas ();
    LinkedList  lTabla = new LinkedList ();

    String origen  = (String) request.getAttribute ("origen");
    Propuesta oProp  = (Propuesta) request.getAttribute ("propuesta");

    UbicacionRiesgo  oRiesgo = new UbicacionRiesgo ();
    if (oProp.getoUbicacionRiesgo() != null) {
        oRiesgo = oProp.getoUbicacionRiesgo();
    } else {
        oRiesgo.setigualTomador("N");
        oRiesgo.setprovincia(oProp.getTomadorCodProv());
    }
    
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
    int    condIva      = 0 ;
    String tipoDoc      = "" ;
    int    codProvincia = 0;
 
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
   int cantMeses = 1;

    if (oProp != null) {
        if (oProp.getNumPropuesta()>0) {
            nroPropDesc = String.valueOf(oProp.getNumPropuesta());
            nroProp     = oProp.getNumPropuesta();
        }
    }

    codProd      = oProp.getCodProd();
    descProd     = oProp.getdescProd();
    codVig       = oProp.getCodVigencia ();
    codActividad = oProp.getCodActividad();
 
    telefono     = (oProp.getTomadorTE ()==null)?"":oProp.getTomadorTE ();
    mail         = (oProp.getTomadorEmail()==null)?"":oProp.getTomadorEmail();

    numSocio     = oProp.getNumTomador();
//    nomApe       = oProp.getTomadorRazon();
    documento    = oProp.getTomadorNumDoc();
    tipoDoc      = (oProp.getTomadorTipoDoc().equals ("") ? "80" : oProp.getTomadorTipoDoc());
    condIva      = oProp.getTomadorCondIva();
    domicilio    = (oProp.getTomadorDom()==null)?"":oProp.getTomadorDom();
    localidad    = (oProp.getTomadorLoc()==null)?"":oProp.getTomadorLoc();
    codigoPostal = (oProp.getTomadorCP()==null)?"":oProp.getTomadorCP();    
    codProvincia =  Integer.valueOf( (oProp.getTomadorCodProv() == null || oProp.getTomadorCodProv().equals(""))?"0": oProp.getTomadorCodProv() ).intValue();        

    nroCot       = oProp.getNumSecuCot    ();
    cantCuotas   = oProp.getCantCuotas    ();
    codEstado    = oProp.getCodEstado();

    String disabled = "disabled";
    if (codEstado == 0 || codEstado==4 ) {
        disabled = "";
    }

    GregorianCalendar gc    = new GregorianCalendar();
  
    if (oProp.getFechaIniVigPol() == null) {
        oProp.setFechaIniVigPol(new Date());
    }
    gc.setTime(oProp.getFechaIniVigPol());
    fechaVigDesde = gc.get(Calendar.DAY_OF_MONTH) + "/" + (gc.get(Calendar.MONTH) + 1) + "/" + gc.get(Calendar.YEAR);

     switch ( oProp.getCodVigencia() ) {
        case 1: cantMeses = 1;
                break;
        case 2: cantMeses = 2;
                break;
        case 3: cantMeses = 3;
                break;
        case 4: cantMeses = 4;
                break;
        case 5: cantMeses = 6;
                break;
        case 6: cantMeses = 12;
    }

    if (oProp.getFechaFinVigPol()== null) {
        fechaVigHasta = Fecha.getFechaFinVigencia (oProp.getFechaIniVigPol(), cantMeses );
    } else {
        gc.setTime(oProp.getFechaFinVigPol());
        fechaVigHasta = gc.get(Calendar.DAY_OF_MONTH) + "/" + (gc.get(Calendar.MONTH) + 1) + "/" + gc.get(Calendar.YEAR);
    }

    capMuerte    = oProp.getCapitalMuerte();
    capAsist     = oProp.getCapitalAsistencia ();
    capInvalidez = oProp.getCapitalInvalidez  ();
    franquicia   = oProp.getFranquicia        ();
    premio       = oProp.getImpPremio         ();
    prima        = oProp.getprimaPura         ();

    observacion   = oProp.getObservaciones(); 
    formaPago     = oProp.getCodFormaPago();

    if ( formaPago == 1 ) {
        
        if (oProp.getVencTarjCred()!=null) {        
            gc.setTime(oProp.getVencTarjCred());
            fechaVtoTarjCred = gc.get(Calendar.DAY_OF_MONTH) + "/" + ( gc.get(Calendar.MONTH) + 1) + "/" + gc.get(Calendar.YEAR);
        }

        nroTarjCred      = oProp.getNumTarjCred();
        titularTarj      = oProp.getTitular();
        codTarjeta       = oProp.getCodTarjCred();
        codBcoTarj       = oProp.getCodBanco();
    }
    if ( formaPago == 2 || formaPago == 3 ) {
        CBU        = oProp.getCbu();
        sucursal   = oProp.getSucBanco();
        titularCta = oProp.getTitular();
        codBcoCta  = oProp.getCodBanco();
    }

    if ( formaPago == 4  ) {
        CBU        = oProp.getCbu();
        titularCta = oProp.getTitular();
    }

    if (oProp.getMcaEnvioPoliza() == null ) { 
        oProp.setmcaEnvioPoliza ("M");
    }
    if ( oProp.getcantMaxClausulas() == 0) {
        oProp.setcantMaxClausulas( Integer.parseInt(Dbl.DbltoStr(ConsultaMaestros.getParametro(oProp.getCodRama(), 9),0)));
    }
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title></head>
<link rel="icon" href="http://www.beneficioweb.com.ar/favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/fechas.js"></script>
<script language='javascript'>
    function Eliminar () {
        if (confirm ("Esta usted seguro que desea ELIMINAR la propuesta ?")) {
            document.getElementById ('opcion').value = 'eliminarProp';
            document.formProp.submit();
            return true;
        } else {
            return false;
        }
    }

    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

    function Volver () {
           window.history.go (-1);
    }

    function VerificarTomador() {      

      if ( document.formProp.prop_tom_nroDoc.value.length < 5) {
          alert ("Ingrese por lo menos 5 digitos del documento para acotar la busqueda!!!!!")
          return false;
      }

      var W = 400;
      var H = 300;      
                                              
      var sUrl = "<%= Param.getAplicacion()%>servlet/PropuestaServlet?opcion=verificarTomador&verif_doc=" + document.formProp.prop_tom_nroDoc.value;
      AbrirPopUp (sUrl, W, H);
      return true;    
      
    }

    function desbloquea(){
      document.formProp.prop_tom_prov.disabled = false;      
      document.formProp.prop_cant_cuotas.disabled = false;      
      document.formProp.prop_cap_muerte.disabled = false;      
      document.formProp.prop_cap_invalidez.disabled = false;      
      document.formProp.prop_cap_asistencia.disabled = false;      
      document.formProp.prop_franquicia.disabled = false;    
      document.formProp.prop_tom_cp.disabled = false;    
      document.formProp.prop_aseg_actividad.disabled = false;    
      document.formProp.prop_desc_prod.disabled = false;    
      document.formProp.prop_vig.disabled = false;    
      document.formProp.prop_cod_prod.disabled = false;    
      document.formProp.prop_prima.disabled = false;    
      document.formProp.prop_premio.disabled = false;    
      document.formProp.prop_num_prop.disabled = false;    
      document.formProp.prop_cod_est.disabled = false;       

    }

    function getDatosTomador (param) {
        document.getElementById('prop_tom_tipoDoc').value     = param.tipoDoc.value;
        document.getElementById('prop_tom_nroDoc').value      = param.numDoc.value;
        document.getElementById('prop_tom_apellido').value    = param.razon.value;
        document.getElementById('prop_tom_iva').value         = param.iva.value;
        document.getElementById('prop_tom_dom').value         = param.domicilio.value;
        document.getElementById('prop_tom_loc').value         = param.localidad.value;
        document.getElementById('prop_tom_cp').value          = param.cp.value;
        document.getElementById('prop_numSocio').value        = param.numTomador.value;
        // document.getElementById('prop_tom_nombre').value   = param..value;

        // document.getElementById('prop_tom_te').value       = param..value;
        document.getElementById('prop_tom_prov').value      = param.provincia.value;

    }

    function Grabar () {

        document.getElementById ('prop_benef_herederos').value = 
        (document.getElementById ('prop_benef_herederos').checked == true ? 'S' : 'N' );

        document.getElementById ('prop_benef_tomador').value = 
        (document.getElementById ('prop_benef_tomador').checked == true ? 'S' : 'N' );

        document.getElementById ('prop_cla_no_repeticion').value = 
        (document.getElementById ('prop_cla_no_repeticion').checked == true ? 'S' : 'N' );

        document.getElementById ('prop_cla_subrogacion').value = 
        (document.getElementById ('prop_cla_subrogacion').checked == true ? 'S' : 'N' );

        document.getElementById ('prop_misma_ubic_riesgo').value = 
        (document.getElementById ('prop_misma_ubic_riesgo').checked == true ? 'S' : 'N' );
        
        if ( ValidarDatos() ) {
            desbloquea();
            document.formProp.opcion.value="grabarPropuesta";
            document.formProp.submit();
        }
    }


    function ValidarDatos() {

        
        if (document.getElementById('prop_tom_iva').value == "" || 
            document.getElementById('prop_tom_iva').value == "6" || 
            document.getElementById('prop_tom_iva').value == "9") {
            alert ("La Condición del IVA debe estar informada ");               
            return document.getElementById('prop_tom_iva').focus();
        } 
        if (Trim(document.getElementById('prop_tom_nroDoc').value) !=
            Trim(document.getElementById('prop_num_doc_orig').value) &&
            document.getElementById("prop_tipo_propuesta").value == "R") {
            alert ("No puede modificar el numero de documento en una RENOVACION");
            return document.getElementById('prop_tom_nroDoc').focus();
        }

        if ( document.getElementById('prop_tom_iva').value != "5"  && 
            document.getElementById('prop_tom_tipoDoc').value != "80") {
            alert ("Debe informar el CUIT para condición de IVA diferente a Consumidor Final");               
            return document.getElementById('prop_tom_tipoDoc').focus();
        }      

        if (document.getElementById('prop_tom_tipoDoc').value == "80") { 
            if ( ! ValidoCuit (Trim(document.getElementById('prop_tom_nroDoc').value))) {
                return document.getElementById('prop_tom_nroDoc').focus ();
            }
        }

        if (document.getElementById('prop_tom_tipoDoc').value == "96") {
            if ( document.getElementById('prop_tom_nroDoc').value.length < 7 ||
                 document.getElementById('prop_tom_nroDoc').value.length > 8) {
                alert ("DOCUMENTO  INVALIDO");
                return document.getElementById('prop_tom_nroDoc').focus ();
            }
        }

        if (document.getElementById('prop_vig_desde').value == "") {
            alert (" Debe informar la fecha de vigencia desde ");               
            return document.getElementById('prop_vig_desde').focus();
        }      

       var dateString = validaFecha(document.getElementById('prop_vig_desde'));  // mm/dd/yyyy [IE, FF]
//        var Fecha_Inicial = new Date(parseInt (dateString.substring(6)),
//                                     parseInt (dateString.substring(3,5)) - 1,
//                                     parseInt (dateString.substring(0,2)) );

        var Fecha_Inicial = new Date (FormatoFec( validaFecha(document.getElementById('prop_vig_desde'))));
        var diasVigencia = parseInt (dateDiff('d', new Date(), Fecha_Inicial ));

        if ( diasVigencia > 30 || diasVigencia < -30 )  {
            alert (" La fecha de inicio de Vigencia no debe superar los 30 días de la emisión ");
            return document.getElementById('prop_vig_desde').focus();
        }

        if (document.getElementById('prop_vig_hasta').value == "") {
            alert (" Debe informar la fecha de vigencia hasta ");               
            return document.getElementById('prop_vig_hasta').focus();
        }      

        if (Trim(document.getElementById('prop_tom_nroDoc').value) == "") {
            alert (" Debe informar el numero de documento del tomador");               
            return document.getElementById('prop_tom_nroDoc').focus();
        }      

        if (Trim(document.getElementById('prop_tom_apellido').value) == "") {
            alert (" Debe informar el apellido o Razón Social del tomador");               
            return document.getElementById('prop_tom_apellido').focus();
        }

        if (document.getElementById('prop_tom_tipoDoc').value != "80" && 
            Trim(document.getElementById('prop_tom_nombre').value) == "") {
            alert (" Debe informar el nombre del tomador");               
            return document.getElementById('prop_tom_nombre').focus();
        }      

        if (Trim(document.getElementById('prop_tom_dom').value) == "") {
            alert (" Debe informar el domicilio del tomador");               
            return document.getElementById('prop_tom_dom').focus();
        }      

        if (Trim(document.getElementById('prop_tom_loc').value) == "") {
            alert (" Debe informar la localidad del tomador");               
            return document.getElementById('prop_tom_loc').focus();
        }      

        if (Trim(document.getElementById('prop_tom_cp').value) == "") {
            alert (" Debe informar el código postal del tomador");               
            return document.getElementById('prop_tom_cp').focus();
        }             

        if ( document.getElementById('prop_tom_cp').length <= 4) {
            alert ("La longitud del Cod. Postal debe ser menor o igual a 4 cifras");               
            return document.getElementById('prop_tom_cp').focus();
        }             

        if (Trim(document.getElementById('prop_ubic_dom').value) == "") {
            alert (" Debe informar el domicilio del riesgo");
            return document.getElementById('prop_ubic_dom').focus();
        }

        if (Trim(document.getElementById('prop_ubic_loc').value) == "") {
            alert (" Debe informar la localidad del riesgo");
            return document.getElementById('prop_ubic_loc').focus();
        }

        if (Trim(document.getElementById('prop_ubic_cp').value) == "") {
            alert (" Debe informar el código postal del riesgo");
            return document.getElementById('prop_ubic_cp').focus();
        }

        if ( document.getElementById('prop_ubic_cp').length <= 4) {
            alert ("La longitud del Cod. Postal del Riesgo debe ser menor o igual a 4 cifras");
            return document.getElementById('prop_ubic_cp').focus();
        }

        if (Trim(document.getElementById('prop_ubic_prov').value) == "-1") {
            alert (" Debe informar la provincia del Riesgo ");
            return document.getElementById('prop_ubic_prov').focus();
        }

        if (document.getElementById('prop_form_pago').value == "0") {
            alert (" Debe informar la forma de pago ");               
            return document.getElementById('prop_form_pago').focus();

        } else if (document.getElementById('prop_form_pago').value == "1") {
              
            if (document.getElementById('pro_TarCred').value == "0") {
                alert (" Debe informar la tarjeta de credito  ");               
                return document.getElementById('pro_TarCred').focus();
            }
            
            if (Trim(document.getElementById('pro_TarCredNro').value) == "") {
                alert (" Debe informar el número de la tarjeta de crédito  ");
                return document.getElementById('pro_TarCredNro').focus();
            }

            if (document.getElementById('pro_TarCredVto').value == "") {
                alert (" Debe informar la fecha de vencimiento de la tarjeta de crédito  ");
                return document.getElementById('pro_TarCredVto').focus();
            }

            if (document.getElementById('pro_TarCredCodSeguridad').value == "") {
                alert (" Debe informar el código de seguridad  de la tarjeta de crédito  ");
                return document.getElementById('pro_TarCredCodSeguridad').focus();
            }

            if (Trim(document.getElementById('pro_TarCredTit').value) == "") {
                alert (" Debe informar el titular de la tarjeta de credito  ");               
                return document.getElementById('pro_TarCredTit').focus();
            }


        } else if (document.getElementById('prop_form_pago').value == "4") {
            if (Trim(document.getElementById('pro_DebCtaCBU').value) == "") {
                alert (" Debe informar el CBU");               
                return document.getElementById('pro_DebCtaCBU').focus();
            }
            if ( document.getElementById('pro_DebCtaCBU').value.length != 22 ) {
                alert (" La CBU debería tener 22 cifras");               
                return document.getElementById('pro_DebCtaCBU').focus();
            }
            if ( validarCBU (document.getElementById('pro_DebCtaCBU').value) == false ) {
                alert (" La CBU es inválida, por favor, verifique que sea correcta");
                return document.getElementById('pro_DebCtaCBU').focus();
            }

            if ( document.getElementById('pro_CtaTit').value == "" ) {
                alert (" Debe informar el titular de la cuenta");
                return document.getElementById('pro_CtaTit').focus();
            }
        }  
        
        if ( !  ( document.formProp.prop_mca_envio_poliza[0].checked  ||
                  document.formProp.prop_mca_envio_poliza[1].checked ||
                  document.formProp.prop_mca_envio_poliza[2].checked ) ) {
                alert (" Debe seleccionar como desea recibir la póliza ");               
                return document.formProp.prop_mca_envio_poliza[0].focus();
             }
          
        var cla = ValidarClausulas ();

        if ( cla == 1) {
            alert ("Si seleccciona Clausulas debe detallar por lo menos una empresa ");               
            return document.formProp.CLA_DESCRIPCION_1.focus();
        }
        if ( cla == 2) {
            alert ("Si detalla empresas debe seleccionar al menos una clausula ");               
            return document.formProp.prop_cla_no_repeticion.focus();            
        }
        
        return true;
    }

    function HabilitarDiv(divName) {
          
        // for(i=1; i<=2; i++) 
        for(i=1; i<=2; i++)
            document.getElementById('div_' + i).style.visibility = 'hidden';
	  
        if (divName ==1 ) {
            document.getElementById('div_1').style.visibility = 'visible';
        }

        if (divName ==4 ) {
            document.getElementById('div_2').style.visibility = 'visible';
        }
    }

    function SetearUbicacion ( ubic) {
        if ( ubic.checked == true ) {
            document.getElementById ('prop_ubic_cp').value = document.getElementById ('prop_tom_cp').value;
            document.getElementById ('prop_ubic_prov').value = document.getElementById ('prop_tom_prov').value;
            document.getElementById ('prop_ubic_dom').value = document.getElementById ('prop_tom_dom').value;
            document.getElementById ('prop_ubic_loc').value = document.getElementById ('prop_tom_loc').value;
            ubic.value = 'S';
        } else {
            document.getElementById ('prop_ubic_cp').value = '';
            document.getElementById ('prop_ubic_prov').value = document.getElementById ('prop_tom_prov').value;
            document.getElementById ('prop_ubic_dom').value = '';
            document.getElementById ('prop_ubic_loc').value = '';
            ubic.value = 'N';
        }
        return document.getElementById ('prop_ubic_dom').focus();
    }

    function ValidoCuitEmpresa (empresa) {
        
        if (empresa && empresa.value != "") {
            if ( ! ValidoCuit (Trim( empresa.value)) ) {
                    empresa.focus();
                    return false;
            }
        }
        return true;
    }

    function ValidarClausulas () {
        
        var existe = 0;
        
        if (document.getElementById ('prop_cla_no_repeticion').checked || 
            document.getElementById ('prop_cla_subrogacion').checked ) {
            for (var i = 0; i < document.formProp.elements.length; i++) {
                var obj = document.formProp.elements.item(i);
                if ((typeof(obj) == "object") && obj.name.match(/^CLA_DESCRIPCION./) && Trim (obj.value).length > 0 ) {
                    existe = 1;
                }
            }
            if (existe == 0) return 1; 
        } else {
            for (var i = 0; i < document.formProp.elements.length; i++) {
                var obj = document.formProp.elements.item(i);
                if ((typeof(obj) == "object") && obj.name.match(/^CLA_DESCRIPCION./) && Trim (obj.value).length > 0 ) {
                    existe = 1;
                }
            }
            if (existe == 1) return 2; 
        }

    return 0;
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
    <TR>
        <TD align="center" valign="top" width='100%'>
            <TABLE border='0' width='100%'> 
            <form method="post" action="<%= Param.getAplicacion()%>servlet/PropuestaServlet" name='formProp' id='formProp'>
            <input type='hidden' name='prop_numSocio' id='prop_numSocio'  value='<%=numSocio%>' >
            <input type="hidden" name="opcion"        id="opcion"         value='' >
            <input type="hidden" name="volver"        id="volver"
                   value="<%= (request.getParameter("volver") == null ? "filtrarPropuestas" : request.getParameter("volver"))%>" >
            <input type="hidden" name="prop_nro_cot"  id="prop_nro_cot"   value="<%=nroCot%>" >
            <input type="hidden" name="prop_num_prop" id="prop_num_prop"  value="<%=nroProp%>" >
            <input type="hidden" name="prop_cod_est"  id="prop_cod_est"  value="<%=codEstado%>" >
            <input type="hidden" name="prop_cant_max_clausulas"  id="prop_cant_max_clausulas"  value="<%= oProp.getcantMaxClausulas ()%>" >
            <input type="hidden" name="prop_cod_actividad_sec" id="prop_cod_actividad_sec" value="<%= oProp.getcodActividadSec ()%>">
            <input type="hidden" name="pro_TarCredTitDomicilio" id="pro_TarCredTitDomicilio" value="">
            <input type="hidden" name="prop_tipo_propuesta" id="prop_tipo_propuesta" value="<%=(oProp == null ? "P" : oProp.getTipoPropuesta())%>">
            <input type="hidden" name="prop_num_doc_orig"   id="prop_num_doc_orig"   value="<%=documento%>">

                <TR>
                    <TD>
                        <TABLE border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>               
                            <TR>
                                <TD  colspan='3' height="30px" valign="middle" align="center" class='titulo'><u>FORMULARIO DE PROPUESTA</U></TD>
                            </TR>
                            <TR>
                                <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'> A - Datos Generales</TD>
                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text' nowrap>Propuesta Nº:</TD>
                                <TD align="left" class='text'>
                                    <input type="text" name="prop_nro" id="prop_nro"  size="20" maxleng="20" value="<%=nroPropDesc%>" disabled>
                        &nbsp;&nbsp;&nbsp;
                                    <% if (oProp != null && oProp.getTipoPropuesta().equals("R")) {
                                        %>
                                        <span class="subtitulo">RENUEVA POLIZA:&nbsp;<%= oProp.getNumPoliza()%></span>
<%                                      }
    %>

                                </TD>
                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left"  class="text" valign="top" >Rama:&nbsp;</TD>
                                <TD align="left"  class="text">
                                    <SELECT name="prop_rama" id="prop_rama" class="select" disabled>
<%                                  lTabla = oTabla.getRamas ();
                                    out.println(ohtml.armarSelectTAG(lTabla,10));  
%>
                                    </SELECT>                                    
                                </TD>
                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>Productor:</TD>
                                <TD align="left" class='text'>
                                    <input type="text" name="prop_desc_prod" id="prop_desc_prod" size="50" maxleng="40" value="<%=descProd%>"  disabled>
                                    &nbsp;
                                    <LABEL>Cod : </LABEL>
                                    &nbsp;
                                    <input type="text" name="prop_cod_prod"  id="prop_cod_prod"  size="10" maxleng="10" value="<%=codProd%>"   disabled>
                                </TD>
                            </TR>                          
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>Vigencia:</TD>
                                <TD align="left" class='text'>
                                    <SELECT name="prop_vig" id="prop_vig" class="select" STYLE="WIDTH:120px" disabled>
<%  
                                          lTabla = oTabla.getDatosOrderByDesc ("VIGENCIA");
                                          out.println(ohtml.armarSelectTAG(lTabla,  String.valueOf(codVig))); 
%>
                                    </SELECT>                               
                                    &nbsp;Desde:&nbsp;
                                    <input type="text" name="prop_vig_desde" id="prop_vig_desde" size="10"  maxlength='10' onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value="<%=fechaVigDesde%>" <%=disabled%> >&nbsp;(dd/mm/yyyy)
                                    &nbsp;al:&nbsp;
                                    <input type="text" name="prop_vig_hasta" id="prop_vig_hasta" size="10"  maxlength='10' onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value="<%=fechaVigHasta%>" <%=disabled%> >&nbsp;(dd/mm/yyyy)
                                </TD>
                             </TR>
                            <TR>                                
                                <td width='15'>&nbsp;</td>
                                <TD class='text' colspan='2' align='left'>
                                    <LABEL> <span style='color:red;'><U>Nota:</U></span><b> La Fecha de Inicio de la P&oacute;liza es tentativa y
                                            supeditada a la aprobaci&oacute;n de la misma por la compa&ntilde;ia.<br>
                                            Todas las propuestas enviadas después de las 12:00 hs. tendrá fecha de inicio de vigencia a partir del día siguiente.</b><BR><BR>
                                    </LABEL>
                                </TD>
                                
                            </TR>
                                                  
                            <TR> 
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>Actividad :</TD>                                
                                <TD align="left" class='text'>
                                    <SELECT name="prop_aseg_actividad" id="prop_aseg_actividad" class="select" style="width:800px" disabled>
            <%                  lTabla = oTabla.getActividades ();
                                out.println(ohtml.armarSelectTAG(lTabla,codActividad)); 
%>
                              </SELECT>
                            </TD>
                          </TR>
                        </TABLE>
                    </TD>
                </TR>         
                <TR>
                    <TD>
                        <TABLE border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>                                       
                            <TR>
                                <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'>B - Datos del Tomador</TD>
                            </TR>

                            <TR> 
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>
                                    Documento :
                                </TD>

                                <TD align="left" class='text'>
                                    <SELECT style="WIDTH: 100px" name="prop_tom_tipoDoc" id="prop_tom_tipoDoc"  class="select" <%=disabled%>>
<%  
                                 lTabla = oTabla.getDatos ("DOCUMENTO");
                                 out.println(ohtml.armarSelectTAG(lTabla,String.valueOf(tipoDoc)) ); 
%>  
                                    </SELECT>	    
                                    &nbsp;&nbsp;
                                    <input name="prop_tom_nroDoc" id="prop_tom_nroDoc" size='11' maxlength='11' onkeypress="return Mascara('D',event);" class="inputTextNumeric" value="<%=documento%>" <%=disabled%>>
                                    &nbsp;&nbsp;
<%                                  if( disabled.equals("")) { %>
                                    <input type="button" name="cmdVerifTom" value=" Verificar Persona" height="20px" class="boton" onClick="VerificarTomador();">
<%                                  } %>
                                </TD>

                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>Apellido / Razón Social:</TD>
                                <TD align="left" class='text'>
                                    <input type="text" name="prop_tom_apellido" id="prop_tom_apellido"  size="55" maxleng="100"
                                    value="<%= (oProp.getTomadorApe () == null ? "" : oProp.getTomadorApe ())%>" <%=disabled%> >
                                </TD>
                            </TR>
                            <TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>Nombre:</TD>
                                <TD align="left" class='text'>
                                    <input type="text" name="prop_tom_nombre" id="prop_tom_nombre"  size="40" maxleng="50"
                                    value="<%=  (oProp.getTomadorNom () == null ? "" : oProp.getTomadorNom ())%>" <%=disabled%> >
                                </TD>
                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>Condici&oacute;n&nbsp;IVA:</TD>
                                <TD align="left" >
                                    <SELECT name="prop_tom_iva" id="prop_tom_iva" size="1" style="WIDTH: 200px" class="select" <%=disabled%> >
<%
                                        lTabla.clear();
                                        lTabla = oTabla.getDatos ("CONDICION_IVA");
                                        out.println(ohtml.armarSelectTAG(lTabla, String.valueOf(condIva))); 
%>
                                    </SELECT>
                                </TD>                   
                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>Domicilio:</TD>
                                <TD align="left" class='text'>
                                    <input type="text" name="prop_tom_dom" id="prop_tom_dom"  size="40" maxlengTH="100" value="<%=domicilio%>" <%=disabled%> >
                                </TD>
                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>Localidad:</TD>
                                <TD align="left" class='text'>
                                    <input type="text" name="prop_tom_loc" id="prop_tom_loc"  size="40" maxlength="50" value="<%=localidad%>" <%=disabled%> >
                                </TD>
                            </TR>
                            <TR>                   
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>C&oacute;digo&nbsp;Postal:</TD>
                                <TD align="left">
                                    <input type="text" name="prop_tom_cp" id="prop_tom_cp" value="<%=codigoPostal%>" size='4' maxlength='4' onkeypress="return Mascara('D',event);" class="inputTextNumeric" <%=disabled%> >
                                </TD>
                            </TR>   
                             <TR>                   
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>Mail:</TD>
                                <TD align="left" class='text'><input type="text" name="prop_tom_email" id="prop_tom_mail" value="<%=mail%>" size="40" maxlengh="100" <%=disabled%> ></TD>
                            </TR>            
                            <TR>                   
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>Telefono:</TD>
                                <TD align="left" class='text'><input type="text" name="prop_tom_te" id="prop_tom_te" value="<%=telefono%>" size="40" maxlengh="50" <%=disabled%>  ></TD>
                            </TR>            
                            <TR> 
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>Provincia:</TD>
                                <TD align="left" class='text'>
                                    <SELECT name="prop_tom_prov" id="prop_tom_prov" class="select" STYLE="WIDTH:100px" disabled >
 <%  
                                    lTabla = oTabla.getDatosOrderByDesc ("PROVINCIA");
                                    out.println(ohtml.armarSelectTAG(lTabla, String.valueOf(codProvincia))); 
%>
                                    </SELECT>
                                </TD>
                            </TR>
                        </TABLE>
                    </TD>
                </TR>     
                <TR>
                    <TD>
                        <TABLE border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>                                       
                            <TR>
                                <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'>C - Ubicación del Riesgo</TD>
                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD  colspan='2' valign="middle" align="left" class='subtitulo' >La ubicación del riesgo es la misma que el domicilio del tomador
                                <input type="checkbox" value='<%= oRiesgo.getigualTomador() %>' name='prop_misma_ubic_riesgo' id='prop_misma_ubic_riesgo'  <%= (oRiesgo.getigualTomador().equals ("S") ? "checked" : " ") %>  onclick="SetearUbicacion (this);">
                                </TD>
                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>Domicilio:</TD>
                                <TD align="left" class='text'>
                                    <input type="text" name="prop_ubic_dom" id="prop_ubic_dom"  size="40" maxlengTH="100" value="<%= oRiesgo.getdomicilio() %>" <%=disabled%> >
                                </TD>
                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>Localidad:</TD>
                                <TD align="left" class='text'>
                                    <input type="text" name="prop_ubic_loc" id="prop_ubic_loc"  size="40" maxlength="50" value="<%= oRiesgo.getlocalidad()%>" <%=disabled%> >
                                </TD>
                            </TR>
                            <TR>                   
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>C&oacute;digo&nbsp;Postal:</TD>
                                <TD align="left">
                                    <input type="text" name="prop_ubic_cp" id="prop_ubic_cp" value="<%=oRiesgo.getcodPostal()%>" size='4' maxlength='4' onkeypress="return Mascara('D',event);" class="inputTextNumeric" <%=disabled%> >
                                </TD>
                            </TR>   
                            <TR> 
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>Provincia:</TD>
                                <TD align="left" class='text'>
                                    <SELECT name="prop_ubic_prov" id="prop_ubic_prov" class="select" STYLE="WIDTH:100px">
                                        <OPTION value="-1">Seleccionar</OPTION>
 <%  
                                    lTabla = oTabla.getDatosOrderByDesc ("PROVINCIA");
                                    out.println(ohtml.armarSelectTAG(lTabla, String.valueOf( oRiesgo.getprovincia()))); 
%>
                                    </SELECT>
                                </TD>
                            </TR>
                        </TABLE>
                    </TD>
                </TR>         
                 <TR>
                    <TD>
                        <TABLE border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>                                       
                            <TR>
                                <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'>D - Sumas Aseguradas por Personas</TD>
                            </TR>

                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text' width='200px'>Muerte:</TD>                              
                                <TD align="left" class='text'>
                                    &nbsp;$&nbsp;
                                    <input type="text" align='right'  name="prop_cap_muerte" id="prop_cap_muerte" value="<%= Dbl.DbltoStr(capMuerte,2)%>"   onKeyPress="return Mascara('N',event);" class="inputTextNumeric" disabled>
                                </TD>
                            </TR>

                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text' width='200px'>Invalidez Permanente Total y/o Parcial:</TD>                               
                                <TD align="left" class='text'>
                                    &nbsp;$&nbsp;
                                    <input type="text" name="prop_cap_invalidez" id="prop_cap_invalidez" value="<%= Dbl.DbltoStr(capInvalidez,2)%>"  onKeyPress="return Mascara('N',event);" class="inputTextNumeric" disabled>
                                </TD>
                            </TR>

                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text' width='200px'>Asistencia M&eacute;dico y/o Farm.:</TD>                                                                
                                <TD align="left" class='text'>
                                    &nbsp;$&nbsp;
                                    <input type="text" name="prop_cap_asistencia" id="prop_cap_asistencia"  value="<%= Dbl.DbltoStr(capAsist,2)%>"   onKeyPress="return Mascara('N',event);" class="inputTextNumeric" disabled>
                                </TD>
                            </TR>                            
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text' width='200px'>Franquicia:</TD>                                 
                                <TD align="left" class='text'>
                                    &nbsp;$&nbsp;
                                    <input type="text" name="prop_franquicia" id="prop_franquicia"  size="20" maxleng="20" value="<%= Dbl.DbltoStr(franquicia,2)%>"   onKeyPress="return Mascara('N',event);" class="inputTextNumeric" disabled>
                                </TD>
                            </TR>         
                            
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD colspan='2'>&nbsp;</TD>
                            </TR>                                                      
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text' width='200px'>Prima comisionable:</TD>                                 
                                <TD align="left" class='text'>
                                    &nbsp;$&nbsp;
                                    <input type="text" name="prop_prima" id="prop_prima"  size="20" maxleng="20" value="<%= Dbl.DbltoStr(prima,2)%>"   onKeyPress="return Mascara('N',event);" class="inputTextNumeric" disabled>
                                </TD>
                            </TR>                                   
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text' width='200px'>Premio:</TD>                                 
                                <TD align="left" class='text'>
                                    &nbsp;$&nbsp;
                                    <input type="text" name="prop_premio" id="prop_premio"  size="20" maxleng="20" value="<%= Dbl.DbltoStr(premio,2)%>"   onKeyPress="return Mascara('N',event);" class="inputTextNumeric" disabled>
                                </TD>
                            </TR>                                                               
                        </TABLE>
                    </TD>
                </TR>    
                <TR>
                    <TD>
                        <TABLE border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>                                       
                            <TR>
                                <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'>E - Forma de Pago</TD>
                            </TR>

                            <TR>               
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'> Cantidad de Cuotas&nbsp;:&nbsp;
                                    <input type="text" name="prop_cant_cuotas" id="prop_cant_cuotas"  size="10" maxleng="20" value="<%= Dbl.DbltoStr(cantCuotas,0)%>"   onKeyPress="return Mascara('N',event);" class="inputTextNumeric" disabled >
                                </TD>

                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>Forma de Pago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;                              

                                    <SELECT name="prop_form_pago" id="prop_form_pago" class="select" onchange="HabilitarDiv(this.value);" <%=disabled%>  >
                                        <option value='0' >Seleccione Forma de Pago</option>
                                        <%
                                          lTabla = oTabla.getFormasPagos ();
                                          out.println(ohtml.armarSelectTAG(lTabla,formaPago));
                                        %>
                                    </SELECT>                                    
                                </TD>
                            </TR>                                                       

			    <!-- Comienzo divs -->  
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD width='100%' valign="top" height='100%' >
                                    <TABLE align="left" border='0' cellpadding='0' cellspacing='0' width='100%' heigth="100%">   
                                        <tr>
                                            <TD height='120px' width='100%' valign="top" align="left">
                                                <DIV name="div_1" id="div_1" style="VISIBILITY: hidden; POSITION: absolute;">
                                                    <TABLE align="center" border="0" cellpadding='0' cellspacing='0' width='100%' heigth="100%">
                                                        <TR>
                                                            <TD class="text" height="20" valign="center" >Datos de Tarjeta de Cr&eacute;dito:</TD>
                                                        </TR>
                                                        <TR>
                                                            <TD valign="top">
                                                                <TABLE  align="left" style="MARGIN-LEFT: 5px">
                                                                    <TR>
                                                                        <TD  width='75px' class="text">Tarjeta:</TD>
                                                                        <TD  width='150px'>
                                                                                <SELECT name="pro_TarCred"  id="pro_TarCred" style="WIDTH: 145px" class="select" <%=disabled%> >
                                                                                   <OPTION value='0'>Seleccione Tarjeta de Credito</OPTION>
                                                                                   <%
                                                                                       lTabla = oTabla. getTarjetas ();
                                                                                       out.println(ohtml.armarSelectTAG(lTabla,codTarjeta));
                                                                                   %>
                                                                            </SELECT>
                                                                        </TD>
                                                                        <TD class="text" >N&uacute;mero:&nbsp;</TD>
                                                                        <TD><input id="pro_TarCredNro" name="pro_TarCredNro" maxlength="16" size="17"
                                                                            value="<%=nroTarjCred%>" <%=disabled%> onKeyPress="return Mascara('N',event);" class="inputTextNumeric">
                                                                        </TD>
                                                                    </TR>
                                                                    <TR>
                                                                        <TD class="text">Vencimiento:</TD>
                                                                        <TD align="left">
                                                                            <input name="pro_TarCredVto"  id="pro_TarCredVto" value="<%=fechaVtoTarjCred%>"  size="11" maxlength="10" onblur="validaFecha(this);" onkeypress="return Mascara('F',event);"  <%=disabled%> >
                                                                        </TD>
                                                                        <TD class="text">C&oacute;d. Seguridad:</TD>
                                                                        <TD align="left">
                                                                            <input name="pro_TarCredCodSeguridad" id="pro_TarCredCodSeguridad" value="<%= " "%>"  size="7" maxlength='4' <%=disabled%> >
                                                                        </TD>
<%--                                                                        <TD class="text">Banco:</TD>
                                                                        <TD  width='200px'>
                                                                            <select name="pro_TarCredBco" id="pro_TarCredBco"  style="WIDTH: 145px" class="select" <%=disabled%> >                                                                                
                                                                                codBcoCta
                                                                                <OPTION value='0'>Seleccione Banco</OPTION>
                                                                                <%
                                                                                lTabla = oTabla.getBancos ();
                                                                                out.println(ohtml.armarSelectTAG(lTabla,codBcoTarj));
                                                                                %>                                                                             
                                                                            </SELECT>
                                                                        </TD>
--%>
                                                                    </TR>
                                                                    <TR>
                                                                        <TD class="text">Titular:</TD>
                                                                        <TD align="left" colspan="3">
                                                                            <input name="pro_TarCredTit" id="pro_TarCredTit" value="<%=titularTarj%>"  size="35" maxlength='150' <%=disabled%> >
                                                                        </TD>
                                                                        <%--
                                                                        <TD class="text">Domicilio:</td>
                                                                        <TD align="left">
                                                                            <input name="pro_TarCredTitDomicilio" id="pro_TarCredTitDomicilio" value="<%=titularTarj%>"  size="40" maxlength='150' <%=disabled%> >
                                                                        </TD>
                                                                        --%>
                                                                    </TR>
                                                                </TABLE>
                                                            </TD>
                                                        </TR>
                                                    </TABLE>
                                                </DIV>							
                                                <DIV id="div_2" name="div_2" style="VISIBILITY: hidden; POSITION: absolute;">
                                                    <TABLE align="center" border="0" cellpadding='0' cellspacing='0' width='100%' heigth="100%">
                                                        <TR>
                                                            <TD class="text" height="20" valign="center">Datos de la Cuenta:</TD>
                                                        </TR>
                                                        <TR>
                                                            <TD valign="top">
                                                                <TABLE border="0" align="left" style="MARGIN-LEFT: 5px">
                                               <%--                     <TR>
                                                                        <TD> <LABEL class="text">Banco:</LABEL> </TD>
                                                                        <TD> 
                                                                            <SELECT name="pro_CtaBco" id="pro_CtaBco"  style="WIDTH: 145px" class="select">
                                                                                
                                                                                <OPTION value='0'>Seleccione Banco</OPTION>
                                                                                <%
                                                                                lTabla = oTabla.getBancos ();
                                                                                out.println(ohtml.armarSelectTAG(lTabla,codBcoCta));
                                                                                %>                                                                                
                                                                            </SELECT> 
                                                                        </TD>
                                                                        <TD> <LABEL class="text">Sucursal:</LABEL> </TD>
                                                                        <td align="left"><input name="pro_CtaBcoSuc" id="pro_CtaBcoSuc" value="<%=sucursal%>" size='30' maxlength='35'></TD>
                                                                    </TR>
                                               --%>
                                                                    <TR> 
                                                                        <TD  class="text" >CBU:</TD>
                                                                        <TD  align="left"><input name="pro_DebCtaCBU" id="pro_DebCtaCBU" value="<%=CBU%>"  size='22' maxlength='22'
                                                                                                 onkeypress="return Mascara('D',event);" class="inputTextNumeric">
                                                                        </TD>
                                                                    </TR>
                                                                    <tr> 
                                                                        <TD class="text" >Titular:</TD>
                                                                        <TD  align="left"><input name="pro_CtaTit" id="pro_CtaTit" value="<%=titularCta%>"  
                                                                                                 size='60' maxlength='150'>
                                                                        </TD>
                                                                     </tr>
                                                                </TABLE>    
                                                            </TD>
                                                        </TR>                                                      
                                                    </TABLE>
                                                </DIV> 
                                            </TD>
                                        </tr>
                                    </TABLE>
                                </TD>
                            </TR>
                        </TABLE>
                    </TD>
                </TR>    
                <TR>
                    <TD>
                        <TABLE border='0' align='left' class="fondoForm" width='100%' style='margin-top:10;margin-bottom:10;'>   
                            <TR>
                                <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'>F - Información Adicional</TD>
                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text' valign="top" width='130' nowrap>Seleccione forma de envío:</TD>                                
                                <TD align="left" class='text' >
                                    <input type="radio" value='S' name='prop_mca_envio_poliza' id='prop_mca_envio_poliza' <%= (oProp.getMcaEnvioPoliza().equals ("S") ? "checked" : " ") %>>&nbsp;Deseo recibir la p&oacute;liza <b>impresa por CORREO</b><br>
                                    <input type="radio" value='N' name='prop_mca_envio_poliza' id='prop_mca_envio_poliza' <%= (oProp.getMcaEnvioPoliza().equals ("N") ? "checked" : " ") %>>&nbsp;NO deseo recibir la p&oacute;liza.<br>
                                    <input type="radio" value='M' name='prop_mca_envio_poliza' id='prop_mca_envio_poliza' <%= (oProp.getMcaEnvioPoliza().equals ("M") ? "checked" : " ") %>>&nbsp;Deseo recibir la p&oacute;liza <b>v&iacute;a MAIL</b><br>
                                 </TD>                                
                            </TR>
                            <tr><td colspan='3'><hr></td></tr>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text' valign="top"  nowrap>Beneficiarios:</TD>                                
                                <TD align="left" class='text' >
                                    <input type="CHECKBOX" value='<%= oProp.getbenefHerederos () %>' name='prop_benef_herederos' id='prop_benef_herederos' <%= (oProp.getbenefHerederos().equals ("S") ? "checked" : " ") %>>&nbsp;Herederos legales
                                    &nbsp;&nbsp;<b>(En 2do. t&eacute;rmino por el saldo de la prestaci&oacute;n)</b>
                                    <br>
                                    <input type="CHECKBOX" value='<%= oProp.getbenefTomador () %>' name='prop_benef_tomador' id='prop_benef_tomador' <%= (oProp.getbenefTomador().equals ("S") ? "checked" : " ") %>>&nbsp;Tomador
                                    &nbsp;&nbsp;<b>(En 1er. t&eacute;rmino y hasta su responsabilidad civil o legal por accidente del empleado)</b>
                                 </TD>                                
                            </TR>
                            <tr><td colspan='3'><hr></td></tr>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text' valign="top">Cl&aacute;usulas:</TD>                                
                                <TD align="left" class='text' >
                                    <input type="CHECKBOX" value='<%= oProp.getclaNoRepeticion () %>' name='prop_cla_no_repeticion'  id='prop_cla_no_repeticion' <%= (oProp.getclaNoRepeticion ().equals ("S") ? "checked" : " ") %>>&nbsp;Cl&aacute;usula de No Repetición<br>
                                    <input type="CHECKBOX" value='<%= oProp.getclaSubrogacion () %>' name='prop_cla_subrogacion' id='prop_cla_subrogacion' <%= (oProp.getclaSubrogacion ().equals ("S") ? "checked" : " ") %>>&nbsp;Cl&aacute;usula de Subrogación
                                 </TD>                                
                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text' valign="top" >Ingrese lista de Empresas:</TD>                                
                                <TD class='text'  align="left">&nbsp;&nbsp;&nbsp;&nbsp;Cuit&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Empresa</TD>                                
                            </TR>                            
<%                  if (oProp.getAllClausulas().size() > 0 ) {    
                        for (int i = 1;i <= oProp.getAllClausulas().size() ;i++) {
                            Clausula oCla = (Clausula) oProp.getAllClausulas().get(i - 1);
                            
    %>
                            <TR>
                                <TD colspan="2">&nbsp;</TD>
                                <TD align="left" class='text' >
                                    <input type="hidden" name="CLA_ITEM_<%= i %>">
                                    <input type="text" name="CLA_CUIT_<%= i %>" value="<%= oCla.getcuitEmpresa() %>" size='11' maxlength='11'  onkeypress="return Mascara('D',event);" onblur="ValidoCuitEmpresa ( this );"  class="inputTextNumeric">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <input type="text" name="CLA_DESCRIPCION_<%= i %>" value="<%= oCla.getdescEmpresa() %>" size='50' maxlength='50'>
                                 </TD>                                
                            </TR>
<%                      }
                    }
                    if ( oProp.getcantMaxClausulas () > oProp.getAllClausulas().size() ) {   
                     
                      for (int ii = oProp.getAllClausulas().size() + 1 ; ii <= oProp.getcantMaxClausulas () ;ii++) {
    %>
                            <TR>
                                <TD colspan="2">&nbsp;</TD>
                                <TD align="left" class='text' >
                                    <input type="hidden" name="CLA_ITEM_<%= ii %>">
                                    <input type="text" name="CLA_CUIT_<%= ii %>" size='11' maxlength='11'  onkeypress="return Mascara('D',event);" onblur="ValidoCuitEmpresa ( this );"  class="inputTextNumeric">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <input type="text" name="CLA_DESCRIPCION_<%= ii %>" size='50' maxlength='50'>
                                 </TD>                                
                            </TR>
<%                     }
                   }
    %>
 <%--                           <tr><td colspan='3'><hr></td></tr>
                            <TR>
                                <TD align="left" class='text' colspan='3'>Observaci&oacute;n :</TD>                                
                            </TR>
                            <TR>                           
                                <td width='15'>&nbsp;</td>
                                <TD width="100%" colspan='2'>
                                    <TEXTAREA cols='65' rows='3' name="prop_obs" id="prop_obs" <%=disabled%>  ><%= (observacion == null ? "" : observacion ) %></TEXTAREA>
                                </TD>
                                
                            </TR>
--%>
                            <input type="hidden" name="prop_obs" id="prop_obs"  value='<%= observacion %>' >
                        </TABLE>
                    </TD>
                </TR>
                <TR valign="bottom" >
                    <td width="100%" align="center">
                        <TABLE  width='100%' border="0" cellspacing="0" cellpadding="0" height="30px" align="center">
                            <TR>
                                <TD align="center">
<%                              if (nroProp > 0) {
    %>
                                    <input type="button" name="cmdEliminar"  value="Eliminar Propuesta"  height="20px" class="boton" onClick="Eliminar ();">&nbsp;&nbsp;&nbsp;&nbsp;
<%                              }
    %>
                                    <input type="button" name="cmdSalir"  value="Salir"  height="20px" class="boton" onClick="Salir ();">&nbsp;&nbsp;&nbsp;&nbsp;
                                    <input type="button" name="cmdVolver"  value="Volver"  height="20px" class="boton" onClick="Volver ();">&nbsp;&nbsp;&nbsp;&nbsp;
<%                                  if( disabled.equals("")) { %>
<input type="button" name="cmdGrabar"  value="Grabar y Continuar Listado Nominas >>"  height="20px" class="boton" onClick="Grabar();">
<%                                  } %>
                                </TD>
                            </TR>
                        </TABLE>		
                    </td>
                </TR>
                </form>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD width='100%'>
            <jsp:include flush="true" page="/bottom.jsp"/>
        </TD>
    </TR>
</table>
<script>
CloseEspere();
HabilitarDiv (<%=formaPago %>);
</script>
</body>
</html>
