<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Propuesta"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.beans.AsegCobertura"%>
<%@page import="com.business.beans.Facturacion"%>
<%@page import="com.business.beans.Generico"%>
<%@page import="com.business.beans.Clausula"%>  
<%@page import="com.business.beans.UbicacionRiesgo"%>  
<%@page import="java.util.*"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %> 

<%  Usuario usu = (Usuario) session.getAttribute("user");
    int codRama = (request.getParameter("codRama") == null ? 22 : Integer.parseInt(request.getParameter("codRama")));

    String origen = (String) request.getAttribute("origen");
    Propuesta oProp = (Propuesta) request.getAttribute("propuesta");
    UbicacionRiesgo oRiesgo = new UbicacionRiesgo();
    if (oProp != null && oProp.getoUbicacionRiesgo() != null && oProp.getCodRama() == 10) {
        oRiesgo = oProp.getoUbicacionRiesgo();
    } else {
        oRiesgo.setigualTomador("N");
    }

    HtmlBuilder ohtml = new HtmlBuilder();
    Tablas oTabla = new Tablas();
    LinkedList lTabla = new LinkedList();

    int nroProp         = 0;
    String nroPropDesc  = "SIN ASIGNAR";
    int codSubRama      = -1;
    GregorianCalendar gc = new GregorianCalendar();
    String descProd     = "";
    int codVig          = 6;
    int codFac          = 6;
    int codActividad    = 0;
    int codProd         = 0;
    String apeRazon     = "";
    String nombre       = "";
    String domicilio    = "";
    String localidad    = "";
    String codigoPostal = "";
    String documento    = "";
    String telefono     = "";
    String mail         = "";
    int condIva         = 0;
    String tipoDoc      = "80";
    int codProvincia    = 0;

    String fechaVigDesde = "";
    String fechaVigHasta = "";

    double premio = 0.0;
    double prima = 0.0;

    String observacion = "";
    int formaPago = 0;
    String titularTarj = "";
    String titularCta = "";
    String fechaVtoTarjCred = "";
    String sCodSegTarjeta = "";
    String nroTarjCred = "";
    String sucursal = "";
    String CBU = "";
    int codTarjeta = 0;
    int codBcoTarj = 0;
    int codBcoCta = 0;
    int nroCot = 0;
    int cantCuotas = 1;
    int numSocio = 0; // num Tomador
    int codEstado = 0;
    int cantMeses = 1;
    String disabled = "";
    String mcaEnvio = "M";

    if (oProp != null) {
        if (oProp.getNumPropuesta() > 0) {
            nroPropDesc = String.valueOf(oProp.getNumPropuesta());
            nroProp = oProp.getNumPropuesta();
        }
        codSubRama = oProp.getCodSubRama();
        codProd = oProp.getCodProd();
        descProd = oProp.getdescProd();
        codVig = oProp.getCodVigencia();
        codFac = oProp.getCodFacturacion();
        codActividad = oProp.getCodActividad();

        telefono = (oProp.getTomadorTE() == null) ? "" : oProp.getTomadorTE();
        mail = (oProp.getTomadorEmail() == null) ? "" : oProp.getTomadorEmail();

        numSocio = oProp.getNumTomador();
        apeRazon = (oProp.getTomadorApe() == null ? "" : oProp.getTomadorApe());
        nombre = (oProp.getTomadorNom() == null ? "" : oProp.getTomadorNom());

        documento = oProp.getTomadorNumDoc();
        tipoDoc = (oProp.getTomadorTipoDoc().equals("") ? "80" : oProp.getTomadorTipoDoc());
        condIva = oProp.getTomadorCondIva();
        domicilio = (oProp.getTomadorDom() == null) ? "" : oProp.getTomadorDom();
        localidad = (oProp.getTomadorLoc() == null) ? "" : oProp.getTomadorLoc();
        codigoPostal = (oProp.getTomadorCP() == null) ? "" : oProp.getTomadorCP();
        codProvincia = Integer.valueOf((oProp.getTomadorCodProv() == null || oProp.getTomadorCodProv().equals("")) ? "0" : oProp.getTomadorCodProv()).intValue();

        nroCot = oProp.getNumSecuCot();
        cantCuotas = oProp.getCantCuotas();
        codEstado = oProp.getCodEstado();

        disabled = "disabled";
        if (codEstado == 0 || codEstado == 4) {
            disabled = "";
        }

        if (oProp.getFechaIniVigPol() == null) {
            oProp.setFechaIniVigPol(new Date());
        }
        gc.setTime(oProp.getFechaIniVigPol());
        fechaVigDesde = gc.get(Calendar.DAY_OF_MONTH) + "/" + (gc.get(Calendar.MONTH) + 1) + "/" + gc.get(Calendar.YEAR);

        if (oProp.getCodVigencia() == 0) {
            oProp.setCodVigencia(6);
        }

        premio = oProp.getImpPremio();
        prima = oProp.getprimaPura();

        observacion = oProp.getObservaciones();
        formaPago = oProp.getCodFormaPago();

        if (formaPago == 1) {

            if (oProp.getVencTarjCred() != null) {
                gc.setTime(oProp.getVencTarjCred());
                fechaVtoTarjCred = gc.get(Calendar.DAY_OF_MONTH) + "/" + (gc.get(Calendar.MONTH) + 1) + "/" + gc.get(Calendar.YEAR);
            }

            nroTarjCred = oProp.getNumTarjCred();
            titularTarj = oProp.getTitular();
            codTarjeta = oProp.getCodTarjCred();
            codBcoTarj = oProp.getCodBanco();
            sCodSegTarjeta = oProp.getcodSeguridadTarjeta();
        }
        if (formaPago == 2 || formaPago == 3) {
            CBU = oProp.getCbu();
            sucursal = oProp.getSucBanco();
            titularCta = oProp.getTitular();
            codBcoCta = oProp.getCodBanco();
        }

        if (formaPago == 4) {
            CBU = oProp.getCbu();
            titularCta = oProp.getTitular();
        }

        if (oProp.getMcaEnvioPoliza() != null) {
            mcaEnvio = oProp.getMcaEnvioPoliza();
        }

        codRama = oProp.getCodRama();
    } else {

        gc.setTime(new Date());
        fechaVigDesde = gc.get(Calendar.DAY_OF_MONTH) + "/" + (gc.get(Calendar.MONTH) + 1) + "/" + gc.get(Calendar.YEAR);
        cantMeses = 12;
        formaPago = 0;
    }
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>css/Tablas.css"/>

 <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
 <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/alttxt.js"></script>
 <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
 <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/fechas.js"></script>
 <script type="text/javascript" language="JavaScript">
    var navegador = navigator.appCodeName;
    var aDesdeFact = new Array (20);
    var aHastaFact = new Array (20);
    var aCodFact   = new Array (20);
    var idFrame    = '0';
    function Eliminar () {
        if (confirm ("Esta usted seguro que desea ELIMINAR la propuesta ?")) {
            document.getElementById ('opcion').value = 'eliminarProp';
            document.formProp.submit();
            return true;
        } else {
            return false;
        }
    }

    function SetearCarga (id ) {
       idFrame = id;
    }

    function Salir () {
        window.location = "<%= Param.getAplicacion()%>index.jsp";
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

    function desbloquea(){
        document.formProp.prop_tom_prov.disabled = false;
        document.formProp.prop_cant_cuotas.disabled = false;
        document.formProp.prop_tom_cp.disabled = false;
        document.formProp.prop_aseg_actividad.disabled = false;
        document.formProp.prop_desc_prod.disabled = false;
        document.formProp.prop_vig.disabled = false;
        //document.formProp.prop_cod_prod.disabled = false;
        document.formProp.prop_prima.disabled = false;
        document.formProp.prop_premio.disabled = false;
        document.formProp.prop_num_prop.disabled = false;
        document.formProp.prop_cod_est.disabled = false;
        document.formProp.prop_rama.disabled = false;
    }

    function validaCampo(obj,sMsg){        
        // -- ----------------------
        // Si el campo no esta vacio
        // -- ----------------------
        if ( obj.value != "" ){
            // -- ----------------------
            // Si hay que validar rangos
            // -- ----------------------
            if ( typeof(obj.min) != "undefined" || typeof(obj.max) != "undefined" ){
                //le quito las posibles comas separadoras de mil
                obj.value = obj.value.replace(",","");
                obj.value = parseFloat(obj.value);
                if ( !isNaN(obj.value) ){
                    //si esta dentro de los rangos
                    if (parseFloat(obj.min) <= obj.value  && obj.value<= parseFloat(obj.max) ){
                        return true;
                    }else{
                        sMsg += " entre "+obj.min+" y "+obj.max;
                    }
                }
            }else{
                return true;
            }
        }else{
            //si se permite este campo vacio
            if (obj.notNull == "false"){
                obj.value=0;
                return true;
            }
        }
        alert ( sMsg );
        //     obj.focus();
        return false;
    } 

    function Grabar () {
        // Modif.Pino ---->
        document.getElementById('prop_cantVidas').value =
            oFrameFact.document.getElementById ('prop_cantVidas').value;

        document.getElementById('prop_fac').value       =
            oFrameFact.document.getElementById ('prop_fac').value;

        document.getElementById ('prop_benef_herederos').value =
            (document.getElementById ('prop_benef_herederos').checked == true ? 'S' : 'N' );

        document.getElementById ('prop_benef_tomador').value = 
            (document.getElementById ('prop_benef_tomador').checked == true ? 'S' : 'N' );

        document.getElementById ('prop_cla_no_repeticion').value = 
            (document.getElementById ('prop_cla_no_repeticion').checked == true ? 'S' : 'N' );

        document.getElementById ('prop_cla_subrogacion').value = 
            (document.getElementById ('prop_cla_subrogacion').checked == true ? 'S' : 'N' );
        
        if ( ValidarDatos() ) {
            desbloquea();
            document.getElementById ('opcion').value = 'grabarPropuestaPlan';
            document.formProp.submit();
        }
    }


    function ValidarDatos() {

        if ( document.getElementById('prop_cod_prod').value == "0" ) {
            alert (" Debe seleccionar un productor válido ");               
            return document.getElementById('prop_cod_prod').focus();
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

        var codSubRama  = document.formProp.prop_subrama.options[ document.formProp.prop_subrama.selectedIndex ].value;
        var codRama     = document.formProp.prop_rama.options[ document.formProp.prop_rama.selectedIndex ].value;
        var codPlan     = document.getElementById('prop_cod_plan').value;
        var codOpcion   = document.getElementById('prop_cod_opcion').value;

        if ( codSubRama == "-1") {
            alert (" Debe informar la sub rama !!! ");               
            return document.getElementById('prop_subrama').focus();
        }  
        
        if ( codPlan != "-1" && ( codOpcion != "0" && codOpcion != "-1")) {
            alert ("Opcionales no es compatible con Planes, por favor consulte con su representante comercial ");               
            return oFrameOpcionales.document.getElementById ('cod_opcion').focus();            
        }

       if ( Trim(document.getElementById('prop_cantVidas').value) == "" ) {
            alert (" Debe ingresar la cantidad de asegurados de la nómina ");
            return oFrameFact.document.getElementById('prop_cantVidas').focus();
        }

        if ( parseInt (Trim (document.getElementById('prop_cantVidas').value)) <= 0 ){
            alert (" Debe ingresar la cantidad de asegurados de la nómina ");
            return oFrameFact.document.getElementById('prop_cantVidas').focus();
        }
 //       if ( ! SetearFacturacion ()) {
 //           return false;
 //       }

        if (document.getElementById('prop_tom_iva').value == "" || 
            document.getElementById('prop_tom_iva').value == "6" || 
            document.getElementById('prop_tom_iva').value == "9") {
            alert ("La Condición del IVA debe estar informada ");               
            return document.getElementById('prop_tom_iva').focus();
        } 

        if ( document.getElementById('prop_tom_iva').value != "5"  && 
            document.getElementById('prop_tom_tipoDoc').value != "80") {
            alert ("Debe informar el CUIT para condición de IVA diferente a Consumidor Final");               
            return document.getElementById('prop_tom_tipoDoc').focus();
        }      
        if (Trim(document.getElementById('prop_tom_nroDoc').value) !=
            Trim(document.getElementById('prop_num_doc_orig').value) &&
            document.getElementById("prop_tipo_propuesta").value == "R") {
            alert ("No puede modificar el numero de documento en una RENOVACION");
            return document.getElementById('prop_tom_nroDoc').focus();
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

        if (Trim(document.getElementById('prop_tom_prov').value) == "-1") {
            alert (" Debe informar la provincia del tomador ");
            return document.getElementById('prop_tom_prov').focus();
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
                alert (" Debe informar el número de la tarjeta de credito  ");               
                return document.getElementById('pro_TarCredNro').focus();
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
        
        if ( !  ( document.formProp.prop_mca_envio_poliza[0].checked ||
            document.formProp.prop_mca_envio_poliza[1].checked ||
            document.formProp.prop_mca_envio_poliza[2].checked ) ) {
            alert (" Debe seleccionar como desea recibir la póliza ");
            return document.formProp.prop_mca_envio_poliza[0].focus();
        }
        if (document.getElementById ('prop_benef_herederos').checked &&
            document.getElementById ('prop_benef_tomador').checked ) {
            alert("Beneficiarios inválidos, seleccione herederos legalos o tomador");
            return document.getElementById ('prop_benef_herederos').focus();
            }
        // Modif. Pino --->
        var cla = ValidarClausulas ();
        if ( cla == 1) {
            alert ("Si seleccciona Clausulas debe detallar por lo menos una empresa ");               
            return document.formProp.CLA_DESCRIPCION_1.focus();
        }
        if ( cla == 2) {
            alert ("Si detalla empresas debe seleccionar al menos una clausula ");               
            return document.formProp.prop_cla_no_repeticion.focus();            
        }
        // Modif. Pino <---

        // Validar Coberturas
        if (oFrameCoberturas) {
            document.getElementById('prop_max_cant_cob').value =  oFrameCoberturas.document.getElementById ('MAX_CANT_COB').value;
            var cantCob = document.getElementById('prop_max_cant_cob').value;
            for( i=1;i<=cantCob;i++) {
                document.getElementById('prop_cob_'+i).value     =  oFrameCoberturas.document.getElementById ('COB_'+i).value;
                document.getElementById('prop_cob_'+i).min       =  oFrameCoberturas.document.getElementById ('COB_'+i).min;
                document.getElementById('prop_cob_'+i).max       =  oFrameCoberturas.document.getElementById ('COB_'+i).max;
                document.getElementById('prop_cob_cod_'+i).value =  oFrameCoberturas.document.getElementById ('COD_COB_'+i).value;

                if (!validaCampo(document.getElementById('prop_cob_'+i),"Por favor ingrese una suma correcta")){
                    oFrameCoberturas.document.getElementById ('COB_'+i).focus ();
                    return false;
                }
            }
        }

        return true;
    }

    function HabilitarDiv(divName) {


        document.getElementById('div_1').style.visibility = 'hidden';
        document.getElementById('div_2').style.visibility = 'hidden';
            
        if (divName ==1 ) {
            document.getElementById('div_1').style.visibility = 'visible';
        }

        if (divName ==4 ) {
            document.getElementById('div_2').style.visibility = 'visible';
        }
    }

    // Modif. Pino --->
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
                if ((typeof(obj) == "object") && obj.name.match(/^CLA_DESCRIPCION./)
                    && Trim (obj.value).length > 0 ) {
                    existe = 1;
                }
            }
            if (existe == 0) return 1; 
        } else {
            for (var i = 0; i < document.formProp.elements.length; i++) {
                var obj = document.formProp.elements.item(i);
                if ((typeof(obj) == "object") && obj.name.match(/^CLA_DESCRIPCION./)
                    && Trim (obj.value).length > 0 ) {
                    existe = 1;
                }
            }
            if (existe == 1) return 2; 
        }

        return 0;
    }
    // Modif. Pino <---


    function CambiarSelectProd ( accDir ) {
        var       i = 0;
        var bExiste = false;
        
        if ( (accDir.value == "" || accDir.value == "0")) {
            if (document.getElementById ('prop_cod_prod').value != "0") {
                document.getElementById ('prop_cod_prod').value = "0";
            } 
            return true;
        } else {
            for (i = 0; i < document.getElementById ('prop_cod_prod').length; i++) {
                if (document.getElementById ('prop_cod_prod').options [i].value == accDir.value) {
                    bExiste = true;
                    break;
                }
            }
            if ( bExiste ) {
                document.getElementById ('prop_cod_prod').value = accDir.value;                
                DoChangePlanes();                 
                return true;
            } else {
                alert (" Código inexistente  !! ");
                accDir.value = "";
                return false;
            }
        }
    }

    function SetearFacturacion () {
        
        if ( oFrameFact.document.getElementById('prop_cantVidas').value == "0"  ||
             oFrameFact.document.getElementById('prop_cantVidas').value == "") {
            alert (" Debe ingresar la cantidad de asegurados de la nómina ");
            return oFrameFact.document.getElementById('prop_cantVidas').focus();
        }  else {

            // validar la facturación segun la cantidad de asegurados  -- prop_fac pinolux
            var ok = 0;
            for (i = 1; i <= oFrameFact.document.aCodFact.length ;i++) {
                if ( parseInt (oFrameFact.document.getElementById('prop_fac').value) ==  
                               oFrameFact.document.aCodFact [i] ) {
                    if ( parseInt (oFrameFact.document.getElementById('prop_cantVidas').value) >= 
                        oFrameFact.document.aDesdeFact [i]) {
                        ok = 1;
                        break;
                    }
                }
            }

            if (ok == 1) {
                return true;
            } else {
                alert (" Periodo de Facturación inválido. Pase por encima del signo de pregunta para ver los valores posibles ");
                return oFrameFact.document.getElementById('prop_fac').focus();
            }
         }
    }

    function DoChangeCoberturasByPlan  () {
        if (oFramePlanes) {
            if (document.getElementById('prop_cod_plan')) {
                document.getElementById('prop_cod_plan').value    = window.frames['oFramePlanes'].document.formPlan.prop_plan.value;
            }
            if (document.getElementById('prop_vig')) {
                document.getElementById('prop_vig').value         = window.frames['oFramePlanes'].document.formPlan.prop_vig.value;
            }
            if (document.getElementById('prop_cant_cuotas')) {
                document.getElementById('prop_cant_cuotas').value = window.frames['oFramePlanes'].document.formPlan.prop_cant_cuotas.value;
            }
            if (document.getElementById ('prop_cod_producto')) {
                document.getElementById ('prop_cod_producto').value = window.frames['oFramePlanes'].document.formPlan.prop_cod_producto.value;
            }
            if (document.getElementById('prop_cod_plan')) {
                if (parseInt (document.getElementById('prop_cod_plan').value) > 0 ) {
                    document.getElementById('prop_fac').value =
                                 window.frames['oFramePlanes'].document.formPlan.prop_vig.value;
                    if (oFrameFact) {
                           var sUrl3 = "<%= Param.getAplicacion()%>propuesta/rs/formCondFacturacion.jsp" +
                                "?cod_rama="      + <%=codRama%>    +
                                "&cod_sub_rama="  +  document.formProp.prop_subrama.options[ document.formProp.prop_subrama.selectedIndex ].value +
                                "&prop_fac=" +  window.frames['oFramePlanes'].document.formPlan.prop_vig.value +
                                "&prop_cantVidas=" + document.getElementById('prop_cantVidas').value +
                                "&prop_cod_plan="  + document.getElementById('prop_cod_plan').value;

                                oFrameFact.location = sUrl3;

                        //window.frames['oFrameFact'].document.getElementById('prop_fac').value =
                        //         window.frames['oFramePlanes'].document.formPlan.prop_vig.value;

                    }
                }
            }
        }
        DoChangeCobertura();
        return true;
    }

    
    function DoChangeCobertura() {

       var codRama    = "<%=codRama%>";
       var codSubRama = 0;
       if (document.formProp.prop_subrama) {
           codSubRama = document.formProp.prop_subrama.options[ document.formProp.prop_subrama.selectedIndex ].value;
       }

       var codProd    = -1;
       if (document.formProp.prop_cod_prod) {
           codProd = document.formProp.prop_cod_prod.options[ document.formProp.prop_cod_prod.selectedIndex ].value;
       }

       var  cantCob2 = 10;
       if (document.getElementById('prop_max_cant_cob')) {
          cantCob2   = document.getElementById('prop_max_cant_cob').value ;
        }
        
        var codPlan    = -1;
        if (document.getElementById('prop_cod_plan')) {
            codPlan = document.getElementById('prop_cod_plan').value;
        }

        var sUrl = "<%= Param.getAplicacion()%>propuesta/rs/formCoberturasVC.jsp" +
            "?cod_rama="      + codRama    +
            "&cod_sub_rama="  + codSubRama +
            "&cod_prod="      + codProd    +
            "&prop_cantCob="  + cantCob2    +
            "&cod_plan="      + codPlan    ;

        var sUrl_1 = "";
        var sUrl_2 = "";
        for (i=1; i<= parseInt (cantCob2) ; i++) {
            if (document.getElementById ('prop_cob_'+i) && document.getElementById ('prop_cob_cod_'+i) ) {
                sUrl_1 = sUrl_1 +"&prop_cob_"    + i + "=" + document.getElementById ('prop_cob_'+i).value;
                sUrl_2 = sUrl_2 +"&prop_cob_cod_" + i + "=" + document.getElementById ('prop_cob_cod_'+i).value;
            }
        }                

       if (idFrame == '1'){
            oFrameCoberturas.location = sUrl+sUrl_1 +sUrl_2;
        }
        return true;
    }

    function DoChangePlanes() {   

        var codRama    = <%=codRama%>;

        var codSubRama = 0;
        if (document.getElementById ('prop_subrama')) {
            codSubRama = document.formProp.prop_subrama.options[ document.formProp.prop_subrama.selectedIndex ].value;
        }
        var codPlan    = -1;
        if (document.getElementById ('prop_cod_plan')) {
            codPlan = document.getElementById ('prop_cod_plan').value;
        }

        var codProd    = -1;
        if (document.getElementById ('prop_cod_prod')) {
            codProd = document.formProp.prop_cod_prod.options[ document.formProp.prop_cod_prod.selectedIndex ].value;
        }

       var codFact = 0;
       if (document.getElementById('prop_fac') ) {
           codFact = document.getElementById('prop_fac').value;
       }
       var cantVidas = 0;
       if (document.getElementById('prop_cantVidas')) {
           cantVidas = document.getElementById('prop_cantVidas').value;
       }

       var sUrl3 = "<%= Param.getAplicacion()%>propuesta/rs/formCondFacturacion.jsp" +
            "?cod_rama="      + codRama    +
            "&cod_sub_rama="  + codSubRama +
            "&prop_fac=" +  codFact +
            "&prop_cantVidas=" + cantVidas +
            "&prop_cod_plan=" + codPlan;

        if (oFrameFact ) {
            oFrameFact.location = sUrl3;
        }

        var codVig = 6;
        if (document.getElementById('prop_vig')) {
            codVig = document.getElementById('prop_vig').value;
        }

       var codProducto = 0;
       if (document.getElementById('prop_cod_producto')) {
           codProducto = document.getElementById('prop_cod_producto').value;
       }

      var sUrl = "<%= Param.getAplicacion()%>propuesta/rs/formPlanesVC.jsp" +
            "?cod_rama="      + codRama    +
            "&cod_sub_rama="  + codSubRama +
            "&cod_plan="      + codPlan    +
            "&cod_prod="      + codProd    +
            "&prop_vig="      + codVig     +
            "&prop_cod_producto=" + codProducto;

        if (oFramePlanes){
            oFramePlanes.location = sUrl;
        }

        var codOpcion = -1;
        if (document.getElementById('prop_cod_opcion')) {
            codOpcion = document.getElementById('prop_cod_opcion').value;
        }

        var sUrl2 = "<%= Param.getAplicacion()%>propuesta/rs/formOpcionesAjuste.jsp" +
            "?cod_rama="      + codRama    +
            "&cod_sub_rama="  + codSubRama +
            "&origen=PROD" +
            "&cod_prod=" + codProd +
            "&cod_opcion=" + codOpcion;

        if (oFrameOpcionales ) {
            oFrameOpcionales.location = sUrl2;
        }
    }
    
    function Refrescar ( codRama ) {
        if (navegador == 'Mozilla') {
            window.location.href = '<%= Param.getAplicacion()%>propuesta/formPropuestaPlanes.jsp?codRama=' + codRama;
        } else {
            window.location.href('<%= Param.getAplicacion()%>propuesta/formPropuestaPlanes.jsp?codRama=' + codRama );
        }
    }

    function Calcular () {

        document.getElementById('prop_cantVidas').value =
            oFrameFact.document.getElementById ('prop_cantVidas').value;
        document.getElementById('prop_fac').value       =
            oFrameFact.document.getElementById ('prop_fac').value;
        // Modif.Pino ---->
        document.getElementById ('prop_benef_herederos').value =
            (document.getElementById ('prop_benef_herederos').checked == true ? 'S' : 'N' );

        document.getElementById ('prop_benef_tomador').value = 
            (document.getElementById ('prop_benef_tomador').checked == true ? 'S' : 'N' );

        document.getElementById ('prop_cla_no_repeticion').value = 
            (document.getElementById ('prop_cla_no_repeticion').checked == true ? 'S' : 'N' );

        document.getElementById ('prop_cla_subrogacion').value = 
            (document.getElementById ('prop_cla_subrogacion').checked == true ? 'S' : 'N' );

        if ( document.getElementById('prop_cod_prod').value == "0" ) {
            alert (" Debe seleccionar un productor válido ");               
            return document.getElementById('prop_cod_prod').focus();
        }      

        if ( ! oFrameFact.SetearFacturacion ()) {
            return false;
        }

        var codSubRama  = document.formProp.prop_subrama.options[ document.formProp.prop_subrama.selectedIndex ].value;
        var codRama     = document.formProp.prop_rama.options[ document.formProp.prop_rama.selectedIndex ].value;
        var codPlan     = document.getElementById('prop_cod_plan').value;
        if ( codSubRama == "-1") {
            alert (" Debe informar la sub rama !!! ");               
            return document.getElementById('prop_subrama').focus();
        }  
        // Validar Coberturas
        if (oFrameCoberturas) {
            document.getElementById('prop_max_cant_cob').value =  oFrameCoberturas.document.getElementById ('MAX_CANT_COB').value;
            var cantCob = document.getElementById('prop_max_cant_cob').value;
            for( i=1;i<=cantCob;i++) {
                document.getElementById('prop_cob_'+i).value     =  oFrameCoberturas.document.getElementById ('COB_'+i).value;
                document.getElementById('prop_cob_'+i).min       =  oFrameCoberturas.document.getElementById ('COB_'+i).min;
                document.getElementById('prop_cob_'+i).max       =  oFrameCoberturas.document.getElementById ('COB_'+i).max;
                document.getElementById('prop_cob_cod_'+i).value =  oFrameCoberturas.document.getElementById ('COD_COB_'+i).value;

                if (!validaCampo(document.getElementById('prop_cob_'+i),"Por favor ingrese una suma correcta")){
                    oFrameCoberturas.document.getElementById ('COB_'+i).focus ();
                    return false;
                }
            }
        }
        
        desbloquea();
        document.getElementById ('opcion').value = 'CalcularPremioPlan';
        document.formProp.submit();  
        
        return true;
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
    function DoChangeOpciones () {
        if (oFrameOpcionales ) {
            document.getElementById('prop_cod_opcion').value =  oFrameOpcionales.document.getElementById ('cod_opcion').value;
        }
    }

  function DoChangeFact () {
     if (oFrameFact ) {
        document.getElementById('prop_cantVidas').value =
            oFrameFact.document.getElementById ('prop_cantVidas').value;

        document.getElementById('prop_fac').value       =
            oFrameFact.document.getElementById ('prop_fac').value;
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
    <TR>
        <TD align="center" valign="top" width='720'>
            <TABLE border='0' width='100%'>
                <form method="post" action="<%= Param.getAplicacion()%>servlet/PropuestaServlet" name='formProp' id='formProp'>
                    <INPUT type='hidden' name='prop_numSocio'            id='prop_numSocio'      value='<%=numSocio%>' >
                    <INPUT type="hidden" name="opcion"                   id="opcion"              value='' >
                    <INPUT type="hidden" name="volver"                   id="volver"
                           value="<%= (request.getParameter("volver") == null ? "filtrarPropuestas" : request.getParameter("volver"))%>" >
                    <INPUT type="hidden" name="prop_nro_cot"             id="prop_nro_cot"        value="<%=nroCot%>" >
                    <INPUT type="hidden" name="prop_num_prop"            id="prop_num_prop"       value="<%=nroProp%>" >
                    <INPUT type="hidden" name="prop_cod_est"             id="prop_cod_est"        value="<%=codEstado%>" >
                    <INPUT type="hidden" name="prop_desc_prod"           id="prop_desc_prod"      value="<%=descProd%>" >
                    <INPUT type="hidden" name="prop_aseg_actividad"      id="prop_aseg_actividad" value="<%=0%>" >
                    <INPUT type="hidden" name="prop_cod_plan"            id="prop_cod_plan"       value="<%= (oProp == null || oProp.getcodPlan() == 0) ? -1 : oProp.getcodPlan()%>" >   <%-- oPropuesta.getCodPlan --%>
                    <INPUT type="hidden" name="prop_cant_max_clausulas"  id="prop_cant_max_clausulas"  value="<%= (oProp != null ? oProp.getcantMaxClausulas() : Integer.parseInt(Dbl.DbltoStr(ConsultaMaestros.getParametro(codRama, 9), 0)))%>" >
                    <input type="hidden" name="GASTOS_ADQUISICION"       id="GASTOS_ADQUISICION"  value="25.34">
                    <input type="hidden" name="MAX_GASTOS_ADQUISICION"   id="MAX_GASTOS_ADQUISICION" value="25.34">
                    <input type="hidden" name="prop_vig"                 id="prop_vig"            value="<%= codVig%>">
                    <input type="hidden" name="prop_cod_opcion"          id="prop_cod_opcion"     value="<%= (oProp == null || oProp.getcodOpcion() == 0) ? 0 : oProp.getcodOpcion()%>">
                    <input type="hidden" name="prop_fac"                 id="prop_fac"            value="<%= (oProp == null || oProp.getCodFacturacion() == 0) ? 6 : oProp.getCodFacturacion() %>">
                    <input type="hidden" name="prop_cantVidas"           id="prop_cantVidas"      value="<%= (oProp == null ? 0 : oProp.getCantVidas())%>">
                    <INPUT type="hidden" name="prop_tipo_propuesta" id="prop_tipo_propuesta" value="<%=(oProp == null ? "P" : oProp.getTipoPropuesta())%>">
                    <INPUT type="hidden" name="prop_num_doc_orig"   id="prop_num_doc_orig"   value="<%=documento%>">
                    <INPUT type="hidden" name="prop_cod_producto"   id="prop_cod_producto"   value="<%=(oProp == null ? "0" : oProp.getcodProducto())%>">
                    <%
                    int cantMaxCob = 0;
                    int allCob = 0;
                    if (oProp == null) {
                        allCob = 0;
                        cantMaxCob = Integer.parseInt(Dbl.DbltoStr(ConsultaMaestros.getParametro(codRama, 10), 0));
                    } else {
                        allCob = oProp.getAllCoberturas().size();
                        cantMaxCob = Integer.parseInt(Dbl.DbltoStr(ConsultaMaestros.getParametro(oProp.getCodRama(), 10), 0));
                    }
                    %>
                    <INPUT type="hidden" name="prop_max_cant_cob" id="prop_max_cant_cob" value="<%=cantMaxCob%>">
                    <%
                    if (allCob > 0) {
                        for (int i = 1; i <= allCob; i++) {
                            AsegCobertura oCob = (AsegCobertura) oProp.getAllCoberturas().get(i - 1);
                    %>
                    <INPUT type="hidden" name="prop_cob_<%= i%>"      id="prop_cob_<%= i%>"      value="<%=oCob.getimpSumaRiesgo()%>">
                    <INPUT type="hidden" name="prop_cob_cod_<%= i%>"  id="prop_cob_cod_<%= i%>"  value="<%=oCob.getcodCob()%>">
                    <%
                        }
                    }
                    if (cantMaxCob > allCob) {
                        for (int ii = allCob + 1; ii <= cantMaxCob; ii++) {
                    %>
                    <INPUT type="hidden" name="prop_cob_<%= ii%>"  id="prop_cob_<%= ii%>"  min="0" max="0" value="0">
                    <INPUT type="hidden" name="prop_cob_cod_<%= ii%>"  id="prop_cob_cod_<%= ii%>"  min="0" max="0" value="0">
                    <%
                        }
                    }
                    %>
                    <TR>
                        <TD height="30px" valign="middle" align="center" class='titulo'><u>FORMULARIO DE PROPUESTA</u></TD>
                    </TR>
                    <TR>
                        <TD>
                            <TABLE border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>
                                <TR>
                                    <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'> A - Datos Generales</TD>
                                </TR>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='text' nowrap width="80">Propuesta Nº:</TD>
                                    <td align="left" class='text'>
                                        <INPUT type="text" name="prop_nro" id="prop_nro"  size="20" maxleng="20" value="<%=nroPropDesc%>" disabled>
                        &nbsp;&nbsp;&nbsp;
                                    <% if (oProp != null && oProp.getTipoPropuesta().equals("R")) {
                                        %>
                                        <span class="subtitulo">RENUEVA POLIZA:&nbsp;<%= oProp.getNumPoliza()%></span>
<%                                      }
    %>
                                    </td>
                                </TR>
                                <%
                                if (usu.getiCodTipoUsuario() == 1 && usu.getiCodProd() < 80000) {
                                %>
                                <TR>
                                    <TD width='15'>&nbsp;</TD>
                                    <TD align="left" class='text'>Productor:</TD>
                                    <TD align="left" class='text'>

                                        <select class='select' name="prop_cod_prod" id="prop_cod_prod"  onchange="DoChangePlanes();">
                                            <option value='<%=String.valueOf(usu.getiCodProd())%>'> <%=usu.getsDesPersona() + " (" + usu.getiCodProd() + ")"%>
                                            </option>
                                        </select>
                                        &nbsp;
                                        <LABEL>Cod : </LABEL>
                                        &nbsp;

                                        <INPUT name="prod_dir" id="prod_dir" value='0' size='10' maxlength='10' class='inputTextNumeric' onchange='CambiarSelectProd ( this );' onkeypress="" >


                                    </TD>
                                </TR>
                                <%
                                   } else {
                                %>
                                <TR>
                                    <TD width='15'>&nbsp;</TD>
                                    <TD align="left" class='text'>Productor:</TD>
                                    <TD align="left" class='text'>
                                        <select class='select' name="prop_cod_prod" id="prop_cod_prod"  onchange="DoChangePlanes();" style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size:11px;font-weight:normal;text-decoration: none;width:400;height:18">
                                            <option value='0' >Seleccione productor</option>
                                            <%
                                                   LinkedList lProd = (LinkedList) session.getAttribute("Productores");
                                                   for (int i = 0; i < lProd.size(); i++) {
                                                       Usuario oProd = (Usuario) lProd.get(i);
                                                       if (oProd.getiCodProd() < 80000) {
                                                            out.print("<option value='" + String.valueOf(oProd.getiCodProd()) + "' " + (oProd.getiCodProd() == codProd ? "selected" : " ") + ">" + oProd.getsDesPersona() + " (" + oProd.getiCodProd() + ")</option>");
                                                       }
                                                   }
                                            %>
                                        </select>
                                        &nbsp;
                                        <LABEL>Cod : </LABEL>
                                        &nbsp;
                                        <INPUT name="prod_dir" id="prod_dir" value='0' size='10' maxlength='10' class='inputTextNumeric' onchange='CambiarSelectProd ( this );' onkeypress="" >
                                </TR>
                                <%  }%>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left"  class="text" valign="top" >Rama:&nbsp;</TD>
                                    <TD align="left"  class="text">
                                        <SELECT name="prop_rama" id="prop_rama" class="select"
                                                onchange='javascript:Refrescar (this.value );'
                                                style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size:11px;font-weight:normal;text-decoration: none;width:350px;height:18px">
                                            <%
                                                        lTabla = oTabla.getRamas();
                                                        out.println(ohtml.armarSelectTAG(lTabla, codRama));

                                            %>
                                        </SELECT>
                                    </TD>
                                </TR>
                                <TR>
                                    <TD width='15'>&nbsp;</TD>
                                    <TD align="left"  class="text" valign="top" >Sub Rama:&nbsp;</TD>
                                    <TD align="left"  class="text">
                                        <SELECT name="prop_subrama" id="prop_subrama" class="select" onchange="javascript:DoChangePlanes();"
                                                style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size:11px;font-weight:normal;text-decoration: none;width:350px;height:18px" >
                                            <OPTION value='-1'>Seleccione sub rama</OPTION>
                                            <%
                                                lTabla = oTabla.getSubRamasPlanes (codRama, usu.getusuario());
                                                for (int ii = 0; ii < lTabla.size(); ii++) {
                                                    Generico oObj = (Generico) lTabla.get(ii);
                                            %>
                                            <OPTION value='<%= oObj.getCodigo()%>' <%= (oObj.getCodigo() == codSubRama ? "selected" : " ")%>><%= oObj.getDescripcion()%></OPTION>
                                    <%          }
                                    %>
                                        </SELECT>
                                    </TD>
                                </TR>
                                <%                      if (codRama == 22) {
                                %>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD class='text' colspan='2' align='left'>
                                        <LABEL> <span style='color:red;'><U>Nota:</U></span>Por el momento las &uacute;nicas Sub ramas de Vida Colectivo habilitadas para ingresar propuestas son <b>Convenio Mercantil y Seg. Oblig. Trabajadores Rurales</b><BR><BR>
                                        </LABEL>
                                    </TD>
                                </TR>
                                <%                      }
                                %>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <td class="text" valign="middle" align="left"> Opcionales:&nbsp;</td>
                                    <td class="text"  width='401' valign="middle" height='24' align="left">
                                        <iframe  name="oFrameOpcionales" id="oFrameOpcionales" style="width: 401px;height: 22px;"  marginheight="0" marginwidth="0" marginheight="0" align="top"  frameborder="0"  scrolling="no"
                                                 src="<%= Param.getAplicacion()%>propuesta/rs/formOpcionesAjuste.jsp?cod_rama=<%=codRama%>&cod_sub_rama=<%= codSubRama%>&origen=PROD&cod_opcion=<%= (oProp == null || oProp.getcodOpcion() == 0) ? -1 : oProp.getcodOpcion()%>&cod_prod=<%= (oProp == null || oProp.getCodProd() == 0 ? (usu.getiCodProd() == 0 ? 0 : usu.getiCodProd()) : oProp.getCodProd())%>">
                                        </iframe>
                                    </td>
                                </TR>
                                <TR>
                                    <td align="left"  class="text" colspan='3' height="100%">
                                        <iframe  name="oFramePlanes" id="oFramePlanes"  style="width:700px;height: 200px;"  marginheight="0" marginwidth="0" marginheight="0" align="top"  frameborder="0"  scrolling="no"
                                                 src="<%= Param.getAplicacion()%>propuesta/rs/formPlanesVC.jsp?prop_vig=<%= codVig%>&cod_rama=<%=codRama%>&cod_sub_rama=<%= codSubRama%>&cod_plan=<%= (oProp == null || oProp.getcodPlan() == 0) ? -1 : oProp.getcodPlan()%>&cod_prod=<%= (oProp == null || oProp.getCodProd() == 0 ? (usu.getiCodProd() == 0 ? -1 : usu.getiCodProd()) : oProp.getCodProd())%>&prop_cod_producto=<%= (oProp == null ? 0 : oProp.getcodProducto())%>">
                                        </iframe>
                                    </td>
                                </TR>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='text'>Inicio de vigencia:</TD>
                                    <TD align="left" class='text'>
                                        <INPUT type="text" name="prop_vig_desde" id="prop_vig_desde" size="10"  maxlength='10' onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value="<%=fechaVigDesde%>" <%=disabled%> >&nbsp;(dd/mm/yyyy)
                                    </TD>
                                </TR>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD class='text' colspan='2' align='left'>
                                        <LABEL> <span style="color:red;"><U>Nota:</U></span><b> La Fecha de Inicio de la P&oacute;liza es tentativa y
                                                supeditada a la aprobaci&oacute;n de la misma por la compa&ntilde;ia.<br>
                                                Todas las propuestas enviadas después de las 12:00 hs. tendrá fecha de inicio de vigencia a partir del día siguiente.</b><BR><BR>
                                        </LABEL>
                                    </TD>
                                </TR>
                                <tr>
                                    <td align="left"  class="text" colspan='3' width="100%">
                                        <IFRAME name="oFrameFact" id="oFrameFact" style="width:100%;height:59px;" marginwidth="0"
                                                marginheight="0" align="top" frameborder="0"
                                                src="<%= Param.getAplicacion()%>propuesta/rs/formCondFacturacion.jsp?cod_rama=<%=codRama%>&cod_sub_rama=<%= codSubRama%>&prop_fac=<%=codFac %>&prop_cantVidas=<%= (oProp == null ? 0 : oProp.getCantVidas())%>&cod_plan=<%= (oProp == null || oProp.getcodPlan() == 0) ? -1 : oProp.getcodPlan()%>">
                                        </IFRAME>
                                    </td>
                                </tr>
<%--
                                <tr>
                                    <td width='15'>&nbsp;</td>
                                    <td class="text">Cantidad de asegurados:</td>
                                    <td class="text">
                                        <input type="text" name="prop_cantVidas" id="prop_cantVidas"  value="<%= (oProp == null ? 0 : oProp.getCantVidas())%>" size="5" maxlength="3" onKeyPress="return Mascara('D',event);" class="inputTextNumeric" onblur="javascript:SetearFacturacion ();">
                                    </td>
                                </tr>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='text'>Periodo de Facturación:</TD>
                                    <TD align="left" class='text'>
                                        <SELECT name="prop_fac" id="prop_fac" class="select" STYLE="WIDTH:120px" onchange="javascript:SetearFacturacion ();" >
                                            <%          sDescFacturacion.append("Condiciones de Facturación:<br><br>");
                                                        StringBuffer sDescAux = new StringBuffer();
                                                        for (int ii = 0; ii < lFact.size(); ii++) {
                                                            Facturacion oFact = (Facturacion) lFact.get(ii);
                                                            if (oFact.getcantDesde() != 1) {
                                                                sDescAux.append("/ ");
                                                            }
                                                            sDescAux.append(oFact.getdescFacturacion());
                                                            sDescFacturacion.append("- ");
                                                            sDescFacturacion.append(oFact.getcantDesde());
                                                            sDescFacturacion.append(" a ");
                                                            sDescFacturacion.append(oFact.getcantHasta());
                                                            sDescFacturacion.append(" asegurados: ");
                                                            sDescFacturacion.append(sDescAux.toString());
                                                            sDescFacturacion.append("<br>");
                                            %>
                                            <option value="<%= oFact.getcodFacturacion()%>" <%= (oFact.getcodFacturacion() == codFac ? "selected" : " ")%> ><%= oFact.getdescFacturacion()%></option>
                                            <%                                          }
                                            %>
                                        </SELECT>
                                        <img src="<%= Param.getAplicacion()%>images/pregunta1.gif" onmouseover="writetxt('<%= sDescFacturacion.toString()%>')" onmouseout="writetxt(0)">
                                    </TD>
                                </TR>
--%>
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
                                                        lTabla = oTabla.getDatos("DOCUMENTO");
                                                        out.println(ohtml.armarSelectTAG(lTabla, String.valueOf(tipoDoc)));
                                            %>
                                        </SELECT>
                                        &nbsp;&nbsp;
                                        <INPUT name="prop_tom_nroDoc" id="prop_tom_nroDoc" size='11' maxlength='11' onkeypress="return Mascara('D',event);" class="inputTextNumeric" value="<%=documento%>" <%=disabled%>>
                                        &nbsp;&nbsp;
                                        <%                                  if (disabled.equals("")) {%>
                                        <INPUT type="button" name="cmdVerifTom" value=" Verificar Persona" height="20px" class="boton" onClick="VerificarTomador();">
                                        <%                                  }%>
                                    </TD>

                                </TR>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='text'>Apellido / Razón Social:</TD>
                                    <TD align="left" class='text'>
                                        <INPUT type="text" name="prop_tom_apellido" id="prop_tom_apellido"  size="55" maxleng="100" value="<%= apeRazon%>" <%=disabled%> >
                                    </TD>
                                </TR>
                                <TR>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='text'>Nombre:</TD>
                                    <TD align="left" class='text'>
                                        <INPUT type="text" name="prop_tom_nombre" id="prop_tom_nombre"  size="40" maxleng="50" value="<%= nombre%>" <%=disabled%> >
                                    </TD>
                                </TR>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='text'>Condici&oacute;n&nbsp;IVA:</TD>
                                    <TD align="left" >
                                        <SELECT name="prop_tom_iva" id="prop_tom_iva" size="1" style="WIDTH: 200px" class="select" <%=disabled%> >
                                            <%
                                                        lTabla.clear();
                                                        lTabla = oTabla.getDatos("CONDICION_IVA");
                                                        out.println(ohtml.armarSelectTAG(lTabla, String.valueOf(condIva)));
                                            %>
                                        </SELECT>
                                    </TD>
                                </TR>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='text'>Domicilio:</TD>
                                    <TD align="left" class='text'>
                                        <INPUT type="text" name="prop_tom_dom" id="prop_tom_dom"  size="40" maxlengTH="100" value="<%=domicilio%>" <%=disabled%> >
                                    </TD>
                                </TR>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='text'>Localidad:</TD>
                                    <TD align="left" class='text'>
                                        <INPUT type="text" name="prop_tom_loc" id="prop_tom_loc"  size="40" maxlength="50" value="<%=localidad%>" <%=disabled%> >
                                    </TD>
                                </TR>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='text' align="left">C&oacute;digo&nbsp;Postal:</TD>
                                    <TD align="left">
                                        <INPUT type="text" name="prop_tom_cp" id="prop_tom_cp" value="<%=codigoPostal%>" size='4' maxlength='4' onkeypress="return Mascara('D',event);" class="inputTextNumeric" <%=disabled%> >
                                    </TD>
                                </TR>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='text'>Mail:</TD>
                                    <TD align="left" class='text'><INPUT type="text" name="prop_tom_email" id="prop_tom_mail" value="<%=mail%>" size="40" maxlengh="100" <%=disabled%> ></TD>
                                </TR>

                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='text'>Telefono:</TD>
                                    <TD align="left" class='text'><INPUT type="text" name="prop_tom_te" id="prop_tom_te" value="<%=telefono%>" size="40" maxlengh="50" <%=disabled%>  ></TD>
                                </TR>

                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='text'>Provincia:</TD>
                                    <TD align="left" class='text'>
                                        <SELECT name="prop_tom_prov" id="prop_tom_prov" class="select" STYLE="WIDTH:100px">
                                            <option value="-1">Seleccionar</option>
                                            <%
                                                       lTabla = oTabla.getDatosOrderByDesc("PROVINCIA");
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
                                    <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'>D - Ubicación del Riesgo <B>(Solo para Planes especiales de Accidentes Personales)</B></TD>
                                </TR>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD  colspan='2' valign="middle" align="left" class='subtitulo' >La ubicación del riesgo es la misma que el domicilio del tomador
                                        <INPUT type="checkbox" value='<%= oRiesgo.getigualTomador()%>' name='prop_misma_ubic_riesgo' id='prop_misma_ubic_riesgo'  <%= (oRiesgo.getigualTomador().equals("S") ? "checked" : " ")%>  onclick="SetearUbicacion (this);">
                                    </TD>
                                </TR>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='text'>Domicilio:</TD>
                                    <TD align="left" class='text'>
                                        <INPUT type="text" name="prop_ubic_dom" id="prop_ubic_dom"  size="40" maxlengTH="100" value="<%= oRiesgo.getdomicilio()%>" <%=disabled%> >
                                    </TD>
                                </TR>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='text'>Localidad:</TD>
                                    <TD align="left" class='text'>
                                        <INPUT type="text" name="prop_ubic_loc" id="prop_ubic_loc"  size="40" maxlength="50" value="<%= oRiesgo.getlocalidad()%>" <%=disabled%> >
                                    </TD>
                                </TR>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='text'>C&oacute;digo&nbsp;Postal:</TD>
                                    <TD align="left">
                                        <INPUT type="text" name="prop_ubic_cp" id="prop_ubic_cp" value="<%=oRiesgo.getcodPostal()%>" size='4' maxlength='4' onkeypress="return Mascara('D',event);" class="inputTextNumeric" <%=disabled%> >
                                    </TD>
                                </TR>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='text'>Provincia:</TD>
                                    <TD align="left" class='text'>
                                        <SELECT name="prop_ubic_prov" id="prop_ubic_prov" class="select" STYLE="WIDTH:100px">
                                            <option value="-1">Seleccionar</option>
                                            <%
                                                       lTabla = oTabla.getDatosOrderByDesc("PROVINCIA");
                                                       out.println(ohtml.armarSelectTAG(lTabla, String.valueOf(oRiesgo.getprovincia())));
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
                                    <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'>C - Sumas Aseguradas por Personas</TD>
                                </TR>

                                <TR>
                                    <TD width='15'>&nbsp;</TD>
                                    <TD colspan='3' align='center'>
                                        <IFRAME name="oFrameCoberturas" id="oFrameCoberturas" width="100%" height="150px" marginwidth="0" marginheight="0" align="top" frameborder="0"
                                                src="<%= Param.getAplicacion()%>propuesta/rs/formCoberturasVC.jsp?prop_cantCob=<%=cantMaxCob%>&cod_rama=<%=codRama%>&cod_sub_rama=<%= codSubRama%>&cod_plan=<%= (oProp == null || oProp.getcodPlan() == 0) ? -1 : oProp.getcodPlan()%>&cod_prod=<%= (oProp == null || oProp.getCodProd() == 0 ? (usu.getiCodProd() == 0 ? -1 : usu.getiCodProd()) : oProp.getCodProd())%>">
                                        </IFRAME>

                                    </TD>
                                </TR>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD colspan='2'>&nbsp;</TD>
                                </TR>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='subtitulo' width='200px'>PRIMA:</TD>
                                    <TD align="left" class='subtitulo'>
                                        &nbsp;$&nbsp;
                                        <INPUT type="text" name="prop_prima" id="prop_prima"  size="20" maxleng="20" value="<%= Dbl.DbltoStr(prima, 2)%>"
                                               onKeyPress="return Mascara('N',event);" class="inputTextNumeric" disabled>
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        <input type="button" name="cmdCalcular"  value="  CALCULAR  "  height="20px" class="boton" onClick="javascript:Calcular ();">

                                    </TD>
                                </TR>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='subtitulo' width='200px'>PREMIO:</TD>
                                    <TD align="left" class='subtitulo'>
                                        &nbsp;$&nbsp;
                                        <INPUT type="text" name="prop_premio" id="prop_premio"  size="20" maxleng="20" value="<%= Dbl.DbltoStr(premio, 2)%>"   onKeyPress="return Mascara('N',event);" class="inputTextNumeric" disabled>
                                    </TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
                    <TR>
                        <TD>
                            <TABLE border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>
                                <TR>
                                    <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'>D - Forma de Pago</TD>
                                </TR>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='text'> Cantidad de Cuotas&nbsp;:&nbsp;
                                        <INPUT type="text" name="prop_cant_cuotas" id="prop_cant_cuotas"  size="10" maxleng="20" value="<%= Dbl.DbltoStr(cantCuotas, 0)%>"   onKeyPress="return Mascara('N',event);" class="inputTextNumeric" disabled >
                                    </TD>
                                </TR>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='text'>Forma de Pago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;
                                        <SELECT name="prop_form_pago" id="prop_form_pago" class="select" onchange="HabilitarDiv(this.value);" <%=disabled%>  >
                                            <option value='0' >Seleccione Forma de Pago</option>
                                            <%
                lTabla = oTabla.getFormasPagos();
                out.println(ohtml.armarSelectTAG(lTabla, formaPago));
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
                                                                            <TD  width='100px' class="text">Tarjeta:</TD>
                                                                            <TD  width='150px'>
                                                                                <SELECT name="pro_TarCred"  id="pro_TarCred" style="WIDTH: 145px" class="select" <%=disabled%> >
                                                                                    <OPTION value='0'>Seleccione Tarjeta de Cr&eacute;dito</OPTION>
                                                                                    <%
             lTabla = oTabla.getTarjetas();
             out.println(ohtml.armarSelectTAG(lTabla, codTarjeta));
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
                                                                                <INPUT name="pro_TarCredVto"  id="pro_TarCredVto" value="<%=fechaVtoTarjCred%>"  size="11" maxlength="10" onblur="validaFecha(this);" onkeypress="return Mascara('F',event);"  <%=disabled%> >
                                                                            </TD>
                                                                            <TD class="text">C&oacute;d. Seguridad:</TD>
                                                                            <TD align="left">
                                                                                <INPUT name="pro_TarCredCodSeguridad" id="pro_TarCredCodSeguridad" value="<%= (sCodSegTarjeta == null ? "" : sCodSegTarjeta)  %>"  size="7" maxlength='4' <%=disabled%> >
                                                                            </TD>
                                                                        </TR>
                                                                        <TR>
                                                                            <TD width='100px' class="text">Titular:</TD>
                                                                            <TD align="left" colspan='3'>
                                                                                <INPUT name="pro_TarCredTit" id="pro_TarCredTit" value="<%=titularTarj%>"  size="60" maxlength='150' <%=disabled%> >
                                                                            </TD>
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
                                                                <td valign="top">
                                                                    <TABLE border="0" align="left" style="MARGIN-LEFT: 5px">
                                                                        <TR>
                                                                            <td  class="text" >CBU:</td>
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
                                                                </td>
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
                                    <TD align="left" class='text' valign="top" width='150' nowrap>Seleccione forma de envío:</TD>
                                    <TD align="left" class='text' >
                                        <input type="radio" value='S' name='prop_mca_envio_poliza' id='prop_mca_envio_poliza' <%= (mcaEnvio.equals ("S") ? "checked" : " ") %>>&nbsp;Deseo recibir la p&oacute;liza <b>impresa por CORREO</b><br>
                                        <input type="radio" value='N' name='prop_mca_envio_poliza' id='prop_mca_envio_poliza' <%= (mcaEnvio.equals ("N") ? "checked" : " ") %>>&nbsp;NO deseo recibir la p&oacute;liza<br>
                                        <input type="radio" value='M' name='prop_mca_envio_poliza' id='prop_mca_envio_poliza' <%= (mcaEnvio.equals ("M") ? "checked" : " ") %>>&nbsp;Deseo recibir la p&oacute;liza <b>v&iacute;a MAIL</b><br>
                                    </TD>
                                </TR>
                                <tr>
                                    <td width='15'>&nbsp;</td>
                                    <td colspan="2" class="text"><span style="color:red">NOTA:</span>&nbsp;
                                        <span style="font-weight: bold">P&oacute;lizas mensuales de planes especiales solo ENVIO VIA MAIL</span>
                                    </td>
                                </tr>
                                <tr><td colspan='3'><hr></td></tr>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='text' valign="top" width='150' nowrap>Beneficiarios:</TD>
                                    <TD align="left" class='text' >
                                        <input type="CHECKBOX" value='<%= (oProp != null ? oProp.getbenefHerederos() : "")%>' name='prop_benef_herederos'  id='prop_benef_herederos'  <%= ((oProp != null && oProp.getbenefHerederos().equals("S")) ? "checked" : " ")%>>&nbsp;Herederos legales<br>
                                        <input type="CHECKBOX" value='<%= (oProp != null ? oProp.getbenefTomador() : "")%>' name='prop_benef_tomador'    id='prop_benef_tomador'    <%= ((oProp != null && oProp.getbenefTomador().equals("S")) ? "checked" : " ")%>>&nbsp;Tomador
                                    </TD>
                                </TR>
                                <tr><td colspan='3'><hr></td></tr>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='text' valign="top" width='150' nowrap>Cl&aacute;usulas:</TD>
                                    <TD align="left" class='text' >
                                        <input type="CHECKBOX" value='<%= (oProp != null ? oProp.getclaNoRepeticion() : "")%>' name='prop_cla_no_repeticion'  id='prop_cla_no_repeticion' <%= ((oProp != null && oProp.getclaNoRepeticion().equals("S")) ? "checked" : " ")%>>&nbsp;Cl&aacute;usula de No Repetición<br>
                                        <input type="CHECKBOX" value='<%= (oProp != null ? oProp.getclaSubrogacion() : "")%>' name='prop_cla_subrogacion'    id='prop_cla_subrogacion'   <%= ((oProp != null && oProp.getclaSubrogacion().equals("S")) ? "checked" : " ")%>>&nbsp;Cl&aacute;usula de Subrogación
                                    </TD>
                                </TR>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='text' valign="top" width='150' nowrap>Ingrese lista de Empresas:</TD>
                                    <td class='text'  align="left">&nbsp;&nbsp;&nbsp;&nbsp;Cuit&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Empresa</td>
                                </TR>
                                <%
                                            int cantMaxClausulas = 0;
                                            int allClausulas = 0;
                                            if (oProp == null) {
                                                allClausulas = 0;
                                                cantMaxClausulas = Integer.parseInt(Dbl.DbltoStr(ConsultaMaestros.getParametro(codRama, 9), 0));
                                            } else {
                                                allClausulas = oProp.getAllClausulas().size();
                                                cantMaxClausulas = Integer.parseInt(Dbl.DbltoStr(ConsultaMaestros.getParametro(oProp.getCodRama(), 9), 0));
                                            }
                                            if (allClausulas > 0) {
                                                for (int i = 1; i <= allClausulas; i++) {
                                                    Clausula oCla = (Clausula) oProp.getAllClausulas().get(i - 1);
                                %>
                                <TR>
                                    <td colspan="2">&nbsp;</td>
                                    <TD align="left" class='text' >
                                        <input type="hidden" name="CLA_ITEM_<%= i%>" id="CLA_ITEM_<%= i%>">
                                        <input type="text" name="CLA_CUIT_<%= i%>" id="CLA_CUIT_<%= i%>" value="<%= oCla.getcuitEmpresa()%>" size='12' maxlength='12'  onkeypress="return Mascara('D',event);" onblur="javascript:ValidoCuitEmpresa ( this );"  class="inputTextNumeric">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        <input type="text" name="CLA_DESCRIPCION_<%= i%>" id="CLA_DESCRIPCION_<%= i%>" value="<%= oCla.getdescEmpresa()%>" size='50' maxlength='50'>
                                    </TD>
                                </TR>
                                <%                      }
                                            }
                                            if (cantMaxClausulas > allClausulas) {

                                                for (int ii = allClausulas + 1; ii <= cantMaxClausulas; ii++) {
                                %>
                                <TR>
                                    <td colspan="2">&nbsp;</td>
                                    <TD align="left" class='text' >
                                        <input type="hidden" name="CLA_ITEM_<%= ii%>" id="CLA_ITEM_<%= ii%>">
                                        <input type="text" name="CLA_CUIT_<%= ii%>" id="CLA_CUIT_<%= ii%>" size='12' maxlength='12'  onkeypress="return Mascara('D',event);" onblur="javascript:ValidoCuitEmpresa ( this );"  class="inputTextNumeric">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        <input type="text" name="CLA_DESCRIPCION_<%= ii%>" id="CLA_DESCRIPCION_<%= ii%>" size='50' maxlength='50'>
                                    </TD>
                                </TR>
                                <%                     }
                                            }
                                %>
                                <%--                            <tr><td colspan='3'><hr></td></tr>
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
                                <INPUT type="hidden" name="prop_obs" id="prop_obs"  value='<%= observacion%>' >
                            </TABLE>
                        </TD>
                    </TR>
                    <tr valign="bottom" >
                        <td width="100%" align="center">
<%                              if (nroProp > 0) {
    %>
                                    <input type="button" name="cmdEliminar"  value="Eliminar Propuesta"  height="20px" class="boton" onClick="Eliminar ();">&nbsp;&nbsp;&nbsp;&nbsp;
<%                              }
    %>
                            <input type="button" name="cmdSalir"  value="Salir"  height="20px" class="boton" onClick="Salir ();">&nbsp;&nbsp;&nbsp;&nbsp;
                            <input type="button" name="cmdVolver"  value="Volver"  height="20px" class="boton" onClick="Volver ();">&nbsp;&nbsp;&nbsp;&nbsp;
                            <%                                  if (disabled.equals("")) {%>
                            <input type="button" name="cmdGrabar"  value="Grabar y continuar con el listado de la n&oacute;mina"  height="20px" class="boton" onClick="javascript:Grabar();">
                            <%                                  }%>
                        </td>
                    </tr>
                </form>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD width='100%'>
            <jsp:include flush="true" page="/bottom.jsp"/>
        </TD>
    </TR>
</TABLE>
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
            HabilitarDiv (<%=formaPago%>);
            CloseEspere();
        </script>
    </body>
</html>
