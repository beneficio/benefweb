<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Propuesta"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.beans.AseguradoPropuesta"%>
<%@page import="com.business.beans.AsegCobertura"%>
<%@page import="com.business.beans.Facturacion"%>
<%@page import="com.business.beans.Vigencia"%>
<%@page import="com.business.beans.Generico"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<%  Usuario usu = (Usuario) session.getAttribute("user"); 
    int codSubRama = (request.getParameter ("codSubRama") == null ? 1 :
                      Integer.parseInt (request.getParameter ("codSubRama")));
//    LinkedList lFact = new LinkedList();
    HtmlBuilder ohtml  = new HtmlBuilder();
    Tablas      oTabla = new Tablas ();
    LinkedList  lTabla = new LinkedList ();
    Propuesta oProp  = (Propuesta) request.getAttribute ("propuesta");
    AseguradoPropuesta oAseg = (AseguradoPropuesta) request.getAttribute("asegurado");

    if (oProp != null) {
        codSubRama = oProp.getCodSubRama();
    }

    LinkedList lVig  = new LinkedList();
    Connection dbCon = null;
    int cantMaxCob = 0;
    int allCob = 0;

   try {
        dbCon = db.getConnection();
  //      lFact = ConsultaMaestros.getAllCondFacturacion (dbCon, 9, codSubRama);
        lVig  = ConsultaMaestros.getAllVigencias ( dbCon, 9, codSubRama );
        if (oProp.getAllCoberturas() == null) {
            allCob = 0;
        } else {
            allCob = oProp.getAllCoberturas().size();
        }
        cantMaxCob = Integer.parseInt(Dbl.DbltoStr(ConsultaMaestros.getParametro (dbCon, oProp.getCodRama(), 10), 0));

    } catch (Exception e) {
            throw new SurException (e.getMessage());
    } finally {
            db.cerrar(dbCon);
    }
    StringBuffer sDescFacturacion = new StringBuffer ();
    GregorianCalendar gc    = new GregorianCalendar();
    
    int    nroProp      = 0;
    String nroPropDesc  = "SIN ASIGNAR";
    int    codProd      = 0;
    String descProd     = "";
    int    codVig       = 0 ;
    int    codActividad = 0 ;

    String apeRazon     = ""; 
    String nombre       = ""; 
    String domicilio    = "";
    String localidad    = "";
    String codigoPostal = "";    
    String documento    = ""; 
    String telefono     = "";
    String mail         = "";
    int    condIva      = 0 ;
    String tipoDoc      = "80" ;
    int    codProvincia = 0;
 
    String fechaVigDesde = "";
    String fechaVigHasta = "";

    double capMuerte    = 0;
    double premio       = 0;
    double prima        = 0;
    String observacion  = "";
    int    formaPago    = 0; 
    String titularTarj      = "";
    String titularCta       = "";
    String fechaVtoTarjCred = "";
    String sCodSegTarjeta = "";
    String nroTarjCred      = "";
    String sucursal         = "";
    String CBU              = "";
    int    codTarjeta       = 0;
    int    codBcoTarj       = 0;
    int    codBcoCta        = 0;    
    int    nroCot           = 0;
    int    cantCuotas       = 1 ;
    int    numSocio         = 0; // num Tomador
    int    codEstado        = 0;
    int    cantMeses        = 1;
    String mcaEnvio         = "M";
    String puesto           = "";

    if (oProp.getNumPropuesta()>0) {
        nroPropDesc = String.valueOf(oProp.getNumPropuesta());
        nroProp     = oProp.getNumPropuesta();
    }

    codProd      = oProp.getCodProd();
    descProd     = oProp.getdescProd();
    codVig       = oProp.getCodVigencia ();
    codActividad = oProp.getCodActividad();

    telefono     = (oProp.getTomadorTE ()==null ? "" : oProp.getTomadorTE ());
    mail         = (oProp.getTomadorEmail()==null ? "" : oProp.getTomadorEmail());
    puesto       = (oProp.getTomadorCargo()==null ? "" : oProp.getTomadorCargo());

    numSocio     = oProp.getNumTomador();
    apeRazon     = ( oProp.getTomadorApe () == null ? "" : oProp.getTomadorApe ());
    nombre       = ( oProp.getTomadorNom () == null ? "" : oProp.getTomadorNom ());

    documento    = oProp.getTomadorNumDoc();
    tipoDoc      = (oProp.getTomadorTipoDoc().equals ("") ? "80" : oProp.getTomadorTipoDoc());
    condIva      = oProp.getTomadorCondIva();
    domicilio    = (oProp.getTomadorDom()==null ? "":oProp.getTomadorDom());
    localidad    = (oProp.getTomadorLoc()==null ? "":oProp.getTomadorLoc());
    codigoPostal = (oProp.getTomadorCP()==null ? "":oProp.getTomadorCP());
    codProvincia =  Integer.valueOf( (oProp.getTomadorCodProv() == null || oProp.getTomadorCodProv().equals(""))?"0": oProp.getTomadorCodProv() ).intValue();

    nroCot       = oProp.getNumSecuCot    ();
    if (oProp.getNumPropuesta() != 0) {
        cantCuotas   = oProp.getCantCuotas ();
    }
    codEstado    = oProp.getCodEstado();

    if (oProp.getFechaIniVigPol() == null) {
        oProp.setFechaIniVigPol(new java.util.Date());
    }
    gc.setTime(oProp.getFechaIniVigPol());
    fechaVigDesde = gc.get(Calendar.DAY_OF_MONTH) + "/" + (gc.get(Calendar.MONTH) + 1) + "/" + gc.get(Calendar.YEAR);

    if ( oProp.getCodVigencia() == 0 ) {
        oProp.setCodVigencia ( 1);
    }

    capMuerte    = oProp.getCapitalMuerte();
    premio       = oProp.getImpPremio         ();
    prima        = oProp.getprimaPura       ();

    observacion   = oProp.getObservaciones();
    formaPago     = oProp.getCodFormaPago();

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

    /*
        gc.setTime(new java.util.Date ());
        fechaVigDesde = gc.get(Calendar.DAY_OF_MONTH) + "/" + (gc.get(Calendar.MONTH) + 1) + "/" + gc.get(Calendar.YEAR);

        cantMeses = 12;
        formaPago = 5;   

        proc = null;
        rs = null;        
        try {
            dbCon.setAutoCommit(false);
            proc = dbCon.prepareCall(db.getSettingCall("PRO_GET_ALL_SUMAS_COBERTURAS( ?, ?, ?, ?)"));
            proc.registerOutParameter(1, java.sql.Types.OTHER);
            proc.setInt(2, 9 );
            proc.setInt(3, codSubRama);
            proc.setInt(4, 0);
            proc.setInt(5, 0);
            proc.execute();
            rs = (ResultSet) proc.getObject(1);
            while (rs.next ()) {
                capMuerte = rs.getDouble("MAX_SUMA_ASEGURADA");
            }
        } catch (Exception e) {
       throw new SurException (e.getMessage());
     } finally {
         try {
            if (rs != null) rs.close ();
            if (proc != null) proc.close ();
         } catch (Exception e) {
            throw new SurException (e.getMessage());
        }
        db.cerrar(dbCon);
        }
   }
 * */
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
</head>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>css/Tablas.css"/>

<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/alttxt.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/fechas.js"></script>
<script language='javascript'>
     var navegador = navigator.appCodeName;
 <%--    var aDesdeFact = new Array (<%= lFact.size ()%>);
     var aHastaFact = new Array (<%= lFact.size ()%>);
     var aCodFact   = new Array (<%= lFact.size ()%>);
--%>
    function Salir () {
           window.location = "<%= Param.getAplicacion()%>index.jsp";
    }
    function Volver () {
           window.history.back (-1);
    }

    function Refrescar ( codSubRama ) {
        var prop_nro = document.getElementById('prop_num_prop').value;

        if (navegador == 'Mozilla') {
            window.location.href = '<%= Param.getAplicacion()%>servlet/CaucionServlet?opcion=getPropuestaBenef&codSubRama=' + codSubRama + '&numPropuesta=' + prop_nro;
        } else {
            window.location.href('<%= Param.getAplicacion()%>servlet/CaucionServlet?opcion=getPropuestaBenef&codSubRama=' + codSubRama + '&numPropuesta=' + prop_nro);
        }
    }

    function SetearCarga (id ) {
       idFrame = id;
    }
    function VerificarPersona ( persona ) {

      if ( persona.value.length < 5) {
          alert ("Ingrese por lo menos 5 digitos del documento para acotar la busqueda!!!!!")
          return false;
      }

      var W = 400;
      var H = 300;      
                                              
      var sUrl = "<%= Param.getAplicacion()%>servlet/PropuestaServlet?opcion=verificarTomador&verif_doc=" + document.formProp.prop_tom_nroDoc.value;
      AbrirPopUp (sUrl, W, H);
      return true;    
      
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

    function getDatosTomador (param) {
        document.getElementById('prop_tom_tipoDoc').value   = param.tipoDoc.value;
        document.getElementById('prop_tom_nroDoc').value    = param.numDoc.value;
        document.getElementById('prop_tom_apellido').value  = param.razon.value;
        document.getElementById('prop_tom_iva').value       = param.iva.value;
        document.getElementById('prop_tom_dom').value       = param.domicilio.value;
        document.getElementById('prop_tom_loc').value       = param.localidad.value;
        document.getElementById('prop_tom_cp').value        = param.cp.value;
        document.getElementById('prop_numSocio').value      = param.numTomador.value;
        document.getElementById('prop_tom_prov').value      = param.provincia.value;
        
    // document.getElementById('prop_tom_nombre').value   = param..value;
    // document.getElementById('prop_tom_te').value       = param..value;
    }

    function Grabar () {

        if (confirm("Desea grabar la propuesta ... ?  ")) {
            if ( ValidarDatos() ) {   
                document.getElementById ('opcion').value = 'grabarPropuesta'; 
                document.formProp.submit();       
            }
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

//        if (document.getElementById('prop_tom_tipoDoc').value != "80") {
//            alert ("El tipo de Documento es incorrecto, debe ser CUIT ");
//               return document.getElementById('prop_tom_nroDoc').focus ();
//       }

 //       if  ( document.getElementById('prop_tom_iva').value != "1" &&
//              document.getElementById('prop_tom_iva').value != "4" &&
//              document.getElementById('prop_tom_iva').value != "8" ) {
//            alert ("La Condición de IVA es incorrecta ");
//            return document.getElementById('prop_tom_iva').focus();
//        }

//        if (document.getElementById('prop_tom_tipoDoc').value != "80") {
//            alert ("Tipo de documento inválido, debe informar  CUIT ");
//            return document.getElementById('prop_tom_tipoDoc').focus();
//        }

        if (Trim(document.getElementById('prop_tom_nroDoc').value) == "") {
            alert (" Debe informar el numero de documento del tomador");
            return document.getElementById('prop_tom_nroDoc').focus();
        }

        if (document.getElementById('prop_tom_tipoDoc').value == "80") { 
            if ( ! ValidoCuit (Trim(document.getElementById('prop_tom_nroDoc').value))) {
                alert ("CUIT INVALIDO");
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

            if (document.getElementById('pro_TarCredVto').value == "") {
                alert (" Debe informar la fecha de vencimiento de la tarjeta de credito  ");
                return document.getElementById('pro_TarCredVto').focus();
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
        } else if (document.getElementById('prop_form_pago').value == "6") {
            alert (" Forma de pago inválida ");
            return document.getElementById('prop_form_pago').focus();
        }
        
//       if ( !  ( document.formProp.prop_mca_envio_poliza[0].checked ||
//                 document.formProp.prop_mca_envio_poliza[1].checked ||
//                 document.formProp.prop_mca_envio_poliza[2].checked ) ) {
//                alert (" Debe seleccionar como desea recibir la póliza ");
//                return document.formProp.prop_mca_envio_poliza[0].focus();
//             }

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

    function DoChangeCobertura() {

       var codRama    = "9";
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
                return true;
            } else {
                alert (" Código inexistente  !! ");
                accDir.value = "";
                return false;
            }
        }
    }

    function Calcular () {

//        document.getElementById('prop_fac').value       =
//            oFrameFact.document.getElementById ('prop_fac').value;

        if ( document.getElementById('prop_cod_prod').value == "0" ) {
            alert (" Debe seleccionar un productor válido ");
            return document.getElementById('prop_cod_prod').focus();
        }

        var codSubRama  = document.formProp.prop_subrama.options[ document.formProp.prop_subrama.selectedIndex ].value;
        var codRama     = "9";
        if ( codSubRama == "0") {
            alert (" Debe informar el producto !!! ");
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

        document.getElementById ('opcion').value = 'CalcularPremio';
        document.formProp.submit();

        return true;
    }

</script>
<body  onload="Javascript:history.go(1);" onunload="Javascript:history.go(1);"> 
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
        <td align="center" valign="top">
            <FORM method="post" action="<%= Param.getAplicacion()%>servlet/CaucionServlet" name='formProp' id='formProp'>
            <input type='hidden' name='prop_numSocio'       id='prop_numSocio'      value='<%=numSocio%>' />
            <input type="hidden" name="opcion"              id="opcion"              value='' />
            <input type="hidden" name="prop_nro_cot"        id="prop_nro_cot"        value="<%=nroCot%>" />
            <input type="hidden" name="prop_num_prop"       id="prop_num_prop"       value="<%=nroProp%>" />
            <input type="hidden" name="prop_cod_est"        id="prop_cod_est"        value="<%=codEstado%>" />
            <input type="hidden" name="prop_desc_prod"      id="prop_desc_prod"      value="<%=descProd%>" />
            <input type="hidden" name="prop_franquicia" id="prop_franquicia"         value="<%=0%>" />
            <input type="HIDDEN" name="prop_rama"           id="prop_rama"           value="9"/>
            <%--
                        int cantMaxCob = 0;
                        int allCob = 0;
                            allCob = (oProp.getAllCoberturas() == null ? 0 : 
                                      oProp.getAllCoberturas().size() );
                            cantMaxCob = Integer.parseInt(Dbl.DbltoStr(ConsultaMaestros.getParametro(oProp.getCodRama(), 10), 0));
           --%>
            <input type="hidden" name="prop_max_cant_cob" id="prop_max_cant_cob" value="<%=cantMaxCob%>"/>
            <%
                        if (allCob > 0) {
                            for (int i = 1; i <= allCob; i++) {
                                AsegCobertura oCob = (AsegCobertura) oProp.getAllCoberturas().get(i - 1);
            %>
            <input type="hidden" name="prop_cob_<%= i%>"      id="prop_cob_<%= i%>"      value="<%=oCob.getimpSumaRiesgo()%>"/>
            <input type="hidden" name="prop_cob_cod_<%= i%>"  id="prop_cob_cod_<%= i%>"  value="<%=oCob.getcodCob()%>"/>
            <%
                            }
                        }
                        if (cantMaxCob > allCob) {
                            for (int ii = allCob + 1; ii <= cantMaxCob; ii++) {
            %>
            <input type="hidden" name="prop_cob_<%= ii%>"  id="prop_cob_<%= ii%>"  min="0" max="0" value="0"/>
            <input type="hidden" name="prop_cob_cod_<%= ii%>"  id="prop_cob_cod_<%= ii%>"  min="0" max="0" value="0"/>
            <%
                            }
                        }
            %>
                        <table border="0" align="left" class="fondoForm" width="100%" style="margin-top:10;margin-bottom:10;">
                            <tr>
                                <td  colspan='3' height="30px" valign="middle" align="center" class='titulo'><u>FORMULARIO DE PROPUESTA</U></td>
                            </tr>
<%                  if (codSubRama == 1 || codSubRama == 2 ) {
    %>
                            <tr>
                                <td align="left" class='titulo' colspan="3">A los efectos de esta solicitud, se definen como:</td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td align="left" class='text' colspan="2">
                                    <span class="subtitulo">Asegurado:&nbsp;</span>Es La empresa Beneficiaria de la Garant&iacute;a.<BR>
                                    <span class="subtitulo">Asegurador:&nbsp;</span>Es Beneficio SA Compañía de Seguros.<BR>
                                    <span class="subtitulo">Tomador:&nbsp;</span>Es la persona física con cargo de Director o Socio Gerente del Asegurado, quien por sí firma ésta solicitud.
                                </td>
                            </tr>
<%                  }
    %>
                            <tr>
                                <td  colspan='3' height="30px" valign="middle" align="left" class='titulo'>Datos Generales</td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text' nowrap>Propuesta Nº:</td>
                                <td align="left" class='text'>
                                    <input type="text" name="prop_nro" id="prop_nro"  size="20" maxleng="20" value="<%=nroPropDesc%>" readonly>
                                </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left"  class="text" valign="top" >Rama:&nbsp;</td>
                                <td align="left"  class="text">CAUCION</td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left"  class="text" valign="top" >Producto:&nbsp;</td>
                                <td align="left"  class="text">
                                    <select name="prop_subrama" id="prop_subrama" class="select"
                                            onchange='javascript:Refrescar (this.value );'>
                                        <option value='0'>Seleccione producto</option>
                                        <%
                                                    lTabla = oTabla.getSubRamas(oProp.getCodRama());
                                                    for (int ii = 0; ii < lTabla.size(); ii++) {
                                                        Generico oObj = (Generico) lTabla.get(ii);
                                                        if (oObj.getCodigo() < 1000) {
                                        %>
                                        <option value='<%= oObj.getCodigo()%>' <%= (oObj.getCodigo() == oProp.getCodSubRama() ? "selected" : " ")%>><%= oObj.getDescripcion()%></option>
                                        <%              }
                                                     }
                                        %>
                                    </select>
                                </td>
                            </tr>

<% 
   if ( usu.getiCodTipoUsuario()== 1 && usu.getiCodProd() < 80000) {
%>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Productor:</td>
                                <td align="left" class='text'>
                                    <select class='select' name="prop_cod_prod" id="prop_cod_prod">                                        
                                        <option value='<%=String.valueOf(usu.getiCodProd())%>'> <%=usu.getsDesPersona() + " (" + usu.getiCodProd() + ")" %> 
                                        </option>
                                    </select>
                                    &nbsp;
                                    <LABEL>Cod : </LABEL>
                                    &nbsp;                               
                                    <input name="prod_dir" id="prod_dir" value='0' size='10' maxlength='10' class='inputTextNumeric' onchange='CambiarSelectProd ( this );' onkeypress="" >
                                </td>
                            </tr>
<%   
   } else {
%>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Productor:</td>
                                <td align="left" class='text'>
                                    <select class='select' name="prop_cod_prod" id="prop_cod_prod">
                                        <option value='0' >Seleccione productor</option>
<%
                              LinkedList lProd = (LinkedList) session.getAttribute("Productores");
                                 for (int i= 0; i < lProd.size (); i++) {
                                        Usuario oProd = (Usuario) lProd.get(i);   
                                        if (oProd.getiCodProd() < 80000) {
                                            out.print("<option value='" + String.valueOf (oProd.getiCodProd()) + "' " + (oProd.getiCodProd() == codProd ? "selected" : " ") + ">" + oProd.getsDesPersona() + " (" + oProd.getiCodProd() + ")</option>");
                                        }
                                    }
%>
                                </select>
                                &nbsp;
                                <LABEL>Cod : </LABEL>
                                &nbsp;                               
                                <input name="prod_dir" id="prod_dir" value='0' size='10' maxlength='10' class='inputTextNumeric' onchange='CambiarSelectProd ( this );' onkeypress="" >

                            </tr>
<%
  }
%>   
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Periodo de Vigencia:</td>
                                <td align="left" class='text'>
                                    <select name="prop_vig" id="prop_vig" class="select" STYLE="WIDTH:170px">
<%                                          for (int i = 0; i < lVig.size (); i++) {
                                                Vigencia oVig = (Vigencia) lVig.get(i);
    %>
                                                <option value="<%= oVig.getcodVigencia () %>" <%= (oVig.getcodVigencia() == oProp.getCodVigencia() ? "selected" : "") %>><%= oVig.getdescVigencia() %></option>
<%                                          }
    %>
                                    </select>
                                    &nbsp;&nbsp;&nbsp;
                                    <LABEL>Desde el&nbsp;</LABEL>
                                    <input type="text" name="prop_vig_desde" id="prop_vig_desde" size="10"  maxlength='10'
                                           onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value="<%=fechaVigDesde%>">&nbsp;(dd/mm/yyyy)
                                </td>
                             </tr>
<%--                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Periodo de Facturación:</td>
                                <td align="left" class='text'>
                                    <select name="prop_fac" id="prop_fac" class="select" STYLE="WIDTH:120px">
<%                                          for (int ii = 0; ii < lFact.size (); ii++) {
                                                Facturacion oFact = (Facturacion) lFact.get(ii);
    %>
                                                <option value="<%= oFact.getcodFacturacion () %>" ><%= oFact.getdescFacturacion () %></option>
<%                                          }
    %>
                                    </select>
                                </td>
                             </tr>
--%>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>
                            <tr>
                                <td  colspan='3' height="30px" valign="middle" align="left" class='titulo'>Datos del Tomador</td>
                            </tr>

                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>
                                    Documento :
                                </td>

                                <td align="left" class='text'>
                                    <select style="WIDTH: 100px" name="prop_tom_tipoDoc" id="prop_tom_tipoDoc"  class="select">
<%  
                                 lTabla = oTabla.getDatos ("DOCUMENTO");
                                 out.println(ohtml.armarSelectTAG(lTabla,String.valueOf(tipoDoc)) ); 
%>  
                                    </select>
                                    &nbsp;&nbsp;
                                    <input name="prop_tom_nroDoc" id="prop_tom_nroDoc" size='20' maxlength='11' onkeypress="return Mascara('D',event);" class="inputTextNumeric" value="<%=documento%>">
                                    &nbsp;&nbsp;
<%--                                  if( disabled.equals("")) { %>
                                    <input type="button" name="cmdVerifTom" value=" Verificar Persona" height="20px" class="boton" onClick="VerificarPersona (document.getElementBy('prop_tom_nroDoc') );">
<%                                  } --%>
                                </td>

                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Apellido / Razón Social:</td>
                                <td align="left" class='text'>
                                    <input type="text" name="prop_tom_apellido" id="prop_tom_apellido"  size="55" maxleng="100" value="<%= apeRazon %>" >
                                </td>
                            </tr>
                            <tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Nombre:</td>
                                <td align="left" class='text'>
                                    <input type="text" name="prop_tom_nombre" id="prop_tom_nombre"  size="40" maxleng="50" value="<%= nombre %>">
                                </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Condici&oacute;n&nbsp;IVA:</td>
                                <td align="left" >
                                    <select name="prop_tom_iva" id="prop_tom_iva" size="1" style="WIDTH: 200px" class="select">
<%
                                        lTabla.clear();
                                        lTabla = oTabla.getDatos ("CONDICION_IVA");
                                        out.println(ohtml.armarSelectTAG(lTabla, String.valueOf(condIva))); 
%>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Domicilio:</td>
                                <td align="left" class='text'>
                                    <input type="text" name="prop_tom_dom" id="prop_tom_dom"  size="40" maxlengTH="100" value="<%=domicilio%>">
                                </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Localidad:</td>
                                <td align="left" class='text'>
                                    <input type="text" name="prop_tom_loc" id="prop_tom_loc"  size="40" maxlength="50" value="<%=localidad%>">
                                </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>C&oacute;digo&nbsp;Postal:</td>
                                <td  align="left">
                                    <input type="text" name="prop_tom_cp" id="prop_tom_cp" value="<%=codigoPostal%>" size='4' maxlength='4' onkeypress="return Mascara('D',event);" class="inputTextNumeric">
                                </td>
                            </tr>
<%--                             <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Mail:</td>
                                <td align="left" class='text'><input type="text" name="prop_tom_email" id="prop_tom_mail" value="<%=mail%>" size="40" maxlengh="100"></td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Telefono:</td>
                                <td align="left" class='text'><input type="text" name="prop_tom_te" id="prop_tom_te" value="<%=telefono%>" size="40" maxlengh="50"></td>
                            </tr>
--%>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Provincia:</td>
                                <td align="left" class='text'>
                                    <select name="prop_tom_prov" id="prop_tom_prov" class="select" STYLE="WIDTH:100px">
 <%  
                                    lTabla = oTabla.getDatosOrderByDesc ("PROVINCIA");
                                    out.println(ohtml.armarSelectTAG(lTabla, String.valueOf(codProvincia))); 
%>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Cargo:</td>
                                <td align="left" class='text'><input type="text" name="prop_tom_puesto" id="prop_tom_puesto" value="<%=puesto%>" size="55" maxlengh="150"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>
                            <tr>
                                <td  colspan='3' height="30px" valign="middle" align="left" class='titulo'>Datos del Asegurado</td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>
                                    Documento :
                                </td>

                                <td align="left" class='text'>
                                    <select style="WIDTH: 100px" name="prop_ase_tipoDoc" id="prop_ase_tipoDoc"  class="select">
<%
                                 lTabla = oTabla.getDatos ("DOCUMENTO");
                                 out.println(ohtml.armarSelectTAG(lTabla,String.valueOf(oAseg.getTipoDoc())) );
%>
                                    </select>
                                    &nbsp;&nbsp;
                                    <input name="prop_ase_nroDoc" id="prop_ase_nroDoc" size='20' maxlength='11' onkeypress="return Mascara('D',event);" class="inputTextNumeric" value="<%= (oAseg.getNumDoc() == null ? "" : oAseg.getNumDoc())%>">
                                    &nbsp;&nbsp;
<%--                                  if( disabled.equals("")) { %>
                                    <input type="button" name="cmdVerifTom" value=" Verificar Persona" height="20px" class="boton" onClick="VerificarPersona (document.getElementBy ('prop_ase_nroDoc'));">
<%                                  } --%>
                                </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Apellido / Razón Social:</td>
                                <td align="left" class='text'>
                                    <input type="text" name="prop_ase_apellido" id="prop_ase_apellido"  size="55" maxleng="100"
                                           value="<%= (oAseg.getApellido() == null ? "" : oAseg.getApellido()) %>">
                                </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Nombre:</td>
                                <td align="left" class='text'>
                                    <input type="text" name="prop_ase_nombre" id="prop_ase_nombre"  size="55" maxleng="50" value="<%= (oAseg.getNombre() == null ? "" : oAseg.getNombre()) %>">
                                </td>
                            </tr>
<%---                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Condici&oacute;n&nbsp;IVA:</td>
                                <td align="left" >
                                    <select name="prop_ase_iva" id="prop_ase_iva" size="1" style="WIDTH: 200px" class="select" >
<%
                                        lTabla.clear();
                                        lTabla = oTabla.getDatos ("CONDICION_IVA");
                                        out.println(ohtml.armarSelectTAG(lTabla, String.valueOf(condIva)));
%>
                                    </select>
                                </td>
                            </tr>
--%>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Domicilio:</td>
                                <td align="left" class='text'>
                                    <input type="text" name="prop_ase_dom" id="prop_ase_dom"  size="40" maxlengTH="100"
                                           value="<%= (oAseg.getDomicilio() == null ? "" : oAseg.getDomicilio()) %>" >
                                </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Localidad:</td>
                                <td align="left" class='text'>
                                    <input type="text" name="prop_ase_loc" id="prop_ase_loc"  size="40" maxlength="50"
                                           value="<%=(oAseg.getlocalidad() == null ? "" : oAseg.getlocalidad())%>" >
                                </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>C&oacute;digo&nbsp;Postal:</td>
                                <td>
                                    <input type="text" name="prop_ase_cp" id="prop_ase_cp" value="<%=(oAseg.getCodigoPosta() == null ? "" : oAseg.getCodigoPosta())%>"
                                           size='4' maxlength='4' onkeypress="return Mascara('D',event);" class="inputTextNumeric" >
                                </td>
                            </tr>
<%--                             <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Mail:</td>
                                <td align="left" class='text'><input type="text" name="prop_ase_email" id="prop_ase_mail" value="<%=mail%>" size="40" maxlengh="100"></td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Telefono:</td>
                                <td align="left" class='text'><input type="text" name="prop_ase_te" id="prop_ase_te" value="<%=telefono%>" size="40" maxlengh="50" ></td>
                            </tr>
--%>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Provincia:</td>
                                <td align="left" class='text'>
                                    <select name="prop_ase_prov" id="prop_ase_prov" class="select" STYLE="WIDTH:100px">
 <%
                                    lTabla = oTabla.getDatosOrderByDesc ("PROVINCIA");
                                    out.println(ohtml.armarSelectTAG(lTabla, String.valueOf(oAseg.getprovincia())));
%>
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border='0' align='left' class="fondoForm" width='100%' style='margin-top:10;margin-bottom:10;'>
                            <tr>
                                <td  colspan='3' height="30px" valign="middle" align="left" class='titulo'>Información Adicional</td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td colspan='2' align='center'>
                                    <iframe name="oFrameCoberturas" id="oFrameCoberturas" width="100%" height="150px" marginwidth="0" marginheight="0" align="top" frameborder="0"
                                            src="<%= Param.getAplicacion()%>propuesta/rs/formCoberturasVC.jsp?prop_cantCob=<%=cantMaxCob%>&cod_rama=<%= oProp.getCodRama() %>&cod_sub_rama=<%= oProp.getCodSubRama()%>&cod_plan=-1&cod_prod=<%= oProp.getCodProd() %>">
                                    </iframe>
                                </td>
                            </tr>
                            <tr>
                                <td height="20" colspan="3">&nbsp;</td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='subtitulo' width='200px'>PRIMA:</td>
                                <td align="left" class='subtitulo'>
                                    &nbsp;$&nbsp;
                                    <input type="text" name="prop_prima" id="prop_prima"  size="20" maxleng="20" value="<%= Dbl.DbltoStr(prima, 2)%>"   onKeyPress="return Mascara('N',event);" class="inputTextNumeric" readonly>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <input type="button" name="cmdCalcular"  value="  CALCULAR  "  height="20px" class="boton" onClick="javascript:Calcular ();">

                                </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='subtitulo' width='200px'>PREMIO:</td>
                                <td align="left" class='subtitulo'>
                                    &nbsp;$&nbsp;
                                    <input type="text" name="prop_premio" id="prop_premio"  size="20" maxleng="20" value="<%= Dbl.DbltoStr(premio, 2)%>"   onKeyPress="return Mascara('N',event);" class="inputTextNumeric" readonly>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>
                            <tr>
                                <td  colspan='2' height="30px" valign="middle" align="left" class='titulo'>Forma de Pago</td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'> Cantidad de Cuotas&nbsp;:&nbsp;
                                    <input type="text" name="prop_cant_cuotas" id="prop_cant_cuotas"  size="10" maxleng="2"
                                           value="<%= cantCuotas %>"   onKeyPress="return Mascara('N',event);" class="inputTextNumeric" readonly >
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Forma de Pago:&nbsp;
                                    <select name="prop_form_pago" id="prop_form_pago" class="select" onchange="HabilitarDiv(this.value);">
                                        <%
            lTabla = oTabla.getFormasPagos();
            out.println(ohtml.armarSelectTAG(lTabla, formaPago));
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <!-- Comienzo divs -->
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td width='100%' valign="top" height='100%' >
                                    <table align="left" border='0' cellpadding='0' cellspacing='0' width='100%' heigth="100%">
                                        <tr>
                                            <td height='85px' width='100%' valign="top" align="left">
                                                <div name="div_1" id="div_1" style="VISIBILITY: hidden; POSITION: absolute;">
                                                    <table align="center" border="0" cellpadding='0' cellspacing='0' width='100%' heigth="100%">
                                                        <tr>
                                                            <td valign="top">
                                                                <table  align="left" style="MARGIN-LEFT: 5px">
                                                                    <tr>
                                                                        <td  width='100px' class="text">Tarjeta:</td>
                                                                        <td  width='150px'>
                                                                            <select name="pro_TarCred"  id="pro_TarCred" style="WIDTH: 145px" class="select">
                                                                                <option value='0'>Seleccione Tarjeta de Cr&eacute;dito</option>
                                                                                <%
                                                                                 lTabla = oTabla.getTarjetas();
                                                                                 out.println(ohtml.armarSelectTAG(lTabla, codTarjeta));
                                                                                            %>
                                                                            </select>
                                                                        </td>
                                                                        <td class="text" >N&uacute;mero:&nbsp;</td>
                                                                        <td><input id="pro_TarCredNro" name="pro_TarCredNro" maxlength="16" size="20"
                                                                            value="<%=nroTarjCred%>" onKeyPress="return Mascara('N',event);" class="inputTextNumeric">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="text">Vencimiento:</td>
                                                                        <td align="left">
                                                                            <input name="pro_TarCredVto"  id="pro_TarCredVto" value="<%=fechaVtoTarjCred%>"  size="11" maxlength="10" onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" >
                                                                        </td>
                                                                        <td class="text">C&oacute;d. Seguridad:</td>
                                                                        <td align="left">
                                                                            <input name="pro_TarCredCodSeguridad" id="pro_TarCredCodSeguridad" value="<%= (sCodSegTarjeta == null ? "" : sCodSegTarjeta)  %>"  size="7" maxlength='4' >
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td width='100px' class="text">Titular:</td>
                                                                        <td align="left" colspan='3'>
                                                                            <input name="pro_TarCredTit" id="pro_TarCredTit" value="<%=titularTarj%>"  size="60" maxlength='150'>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                                <div id="div_2" name="div_2" style="VISIBILITY: hidden; POSITION: absolute;">
                                                    <table align="center" border="0" cellpadding='0' cellspacing='0' width='100%' heigth="100%">
                                                        <tr>
                                                            <td valign="top">
                                                                <table border="0" align="left" style="MARGIN-LEFT: 5px">
                                                                    <tr>
                                                                        <td  class="text" >CBU:</td>
                                                                        <td  align="left"><input name="pro_DebCtaCBU" id="pro_DebCtaCBU" value="<%=CBU%>"  size='25' maxlength='22'
                                                                                             onkeypress="return Mascara('D',event);" class="inputTextNumeric">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="text" >Titular:</td>
                                                                        <td  align="left"><input name="pro_CtaTit" id="pro_CtaTit" value="<%=titularCta%>" size='60' maxlength='150'></td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                             </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
              </FORM>
           </td>
        </tr>
        <tr valign="bottom" >
            <td width="100%" align="center">
                <table  width='100%' border="0" cellspacing="0" cellpadding="0" height="30px" align="center">
                    <tr>
                        <td align="center">
                            <input type="button" name="cmdVolver"  value="Volver"  height="20px" class="boton" onClick="Volver ();">&nbsp;&nbsp;&nbsp;&nbsp;
                            <input type="button" name="cmdGrabar"  value=" Enviar "  height="20px" class="boton" onClick="Grabar();">
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    <tr>
        <td width='100%'>
            <jsp:include flush="true" page="/bottom.jsp"/>
        </td>
    </tr>
</table>
<div id="navtxt" 
     class="navtext"
     style="visibility:hidden; position:absolute; padding:10px">
</div>
<script>
CloseEspere();
HabilitarDiv (<%=formaPago %>);
</script>
</BODY>
</HTML>