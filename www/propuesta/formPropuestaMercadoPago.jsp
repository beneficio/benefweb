<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<%@page import="java.sql.Connection"%>
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

    int capMuerte    = 0;
    int capAsist     = 0;
    int capInvalidez = 0;
    int franquicia   = 0;
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

    String disabled = "readonly";
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
                break;
        case 7: cantMeses = 1;
                break;
        case 8: cantMeses = 12;
    }

    if (oProp.getFechaFinVigPol()== null) {
        fechaVigHasta = Fecha.getFechaFinVigencia (oProp.getFechaIniVigPol(), cantMeses );
    } else {
        gc.setTime(oProp.getFechaFinVigPol());
        fechaVigHasta = gc.get(Calendar.DAY_OF_MONTH) + "/" + (gc.get(Calendar.MONTH) + 1) + "/" + gc.get(Calendar.YEAR);
    }

    capMuerte    = (int) oProp.getCapitalMuerte();
    capAsist     = (int) oProp.getCapitalAsistencia ();
    capInvalidez = (int) oProp.getCapitalInvalidez  ();
    franquicia   = (int) oProp.getFranquicia        ();
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

    double minValorCuota = ConsultaMaestros.getParametro(oProp.getCodRama(), 17 );

    String sUrlFact = Param.getAplicacion() + "propuesta/rs/formFacturacion.jsp?cod_rama=10&cod_sub_rama="  + oProp.getCodSubRama() +
                        "&fac=" + oProp.getCodFacturacion() + "&cantVidas=" +
                        (oProp == null ? 0 : oProp.getCantVidas()) + "&cod_plan=" + (oProp == null || oProp.getcodPlan() == 0 ? -1 : oProp.getcodPlan()) +
                        "&tipo_nomina=" + (oProp == null ? "S" : oProp.gettipoNomina())  + "&cod_producto=" + oProp.getcodProducto() + "&vig=" + codVig +
                        "&cant_cuotas=" + cantCuotas + "&num_propuesta=" + nroProp + "&cod_prod=" + oProp.getCodProd() +
                        "&forma_pago=" + formaPago + "&convenio=" +  titularCta + "&num_tarjeta=" +
                        nroTarjCred + "&cbu=" + CBU + "&cod_tarjeta=" + codTarjeta+ "&cod_banco=" +  codBcoCta +
                        "&num_cotizacion=" + oProp.getNumSecuCot() ;

    String sUrlVig =  Param.getAplicacion()+ "propuesta/rs/formVigencias.jsp?cod_rama=10&cod_sub_rama=" + oProp.getCodSubRama() +
            "&cantVidas=" + (oProp == null ? 0 : oProp.getCantVidas())+ "&cod_plan=" + oProp.getcodPlan()     + "&tipo_nomina=" +
                     (oProp == null ? "S" : oProp.gettipoNomina())+ "&cod_producto=" + oProp.getcodProducto() + "&vig=" + codVig+
                     "&nro_cot=" + nroCot;

   String sMercadoPago = "N";

    Connection dbCon = null;
    try {
        dbCon = db.getConnection();
        dbCon.setAutoCommit(false);

            Parametro oParam = new Parametro ();

            if ( usu.getiCodTipoUsuario() == 0 ) {
                oParam.setsCodigo("ESTADO_MERCADOPAGO_INTERNO");
            } else  {
                oParam.setsCodigo("ESTADO_MERCADOPAGO_PROD");
            }

            sMercadoPago = oParam.getDBValor(dbCon);

    } catch (Exception se) {
            throw new SurException (se.getMessage());
    } finally {
            db.cerrar(dbCon);
    }

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<script language="javascript">
if(history.forward(1)){
history.replace(history.forward(1));
}
</script>
</head>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/fechas.js"></script>
<script language='javascript'>
    var mercadoPago = '<%= sMercadoPago %>';    
    var pClaves    = new Array ("TERRITORIO", "REPUBLICA", "OTROS", "OTRAS", "INDISTINT",
                      "CUALQUIER", "A DECLARAR", "LUGAR", "PROVINCIA", "PCIA.");

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
      document.formProp.prop_rama.disabled = false;
      document.formProp.prop_ubic_prov.disabled = false;
      document.formProp.prop_cap_muerte.disabled = false;      
      document.formProp.prop_cap_invalidez.disabled = false;      
      document.formProp.prop_cap_asistencia.disabled = false;      
      document.formProp.prop_franquicia.disabled = false;    
      document.formProp.prop_tom_cp.disabled = false;    
      document.formProp.prop_vig.disabled = false;    
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

        document.getElementById('prop_form_pago').value =
            oFrameFact.document.getElementById ('prop_form_pago').value;

        document.getElementById('pro_TarCred').value =
            oFrameFact.document.getElementById ('pro_TarCred').value;
        document.getElementById('pro_TarCredNro').value =
            oFrameFact.document.getElementById ('pro_TarCredNro').value;
        document.getElementById('pro_DebCtaCBU').value =
            oFrameFact.document.getElementById ('pro_DebCtaCBU').value;
        document.getElementById('pro_CtaBco').value =
            oFrameFact.document.getElementById ('pro_CtaBco').value;
        document.getElementById('pro_cuenta_banco').value =
            oFrameFact.document.getElementById ('pro_cuenta_banco').value;
        document.getElementById('pro_convenio').value =
            oFrameFact.document.getElementById ('pro_convenio').value;

        document.getElementById('prop_cant_cuotas').value =
            oFrameFact.document.getElementById ('prop_cant_cuotas').value;

        document.getElementById ('prop_cant_max_cuotas').value =
           oFrameFact.document.getElementById ('prop_cant_max_cuotas').value;

        if ( ( parseInt (document.getElementById ('prop_cant_max_cuotas').value) <
             parseInt (document.getElementById ('prop_cant_cuotas').value) ) ||
             document.getElementById ('prop_cant_cuotas').value == "" ) {
             document.getElementById ('prop_cant_cuotas').value =
                 document.getElementById ('prop_cant_max_cuotas').value;
        }

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

        if ( parseInt (document.getElementById ('prop_cant_max_cuotas').value) <
             parseInt (document.getElementById ('prop_cant_cuotas').value) ||
             parseInt (document.getElementById ('prop_cant_cuotas').value) == 0 ) {
             alert ("La cantidad de cuotas no debe superar el maximo para la facturación");
             document.getElementById ('prop_cant_cuotas').value =
                 document.getElementById ('prop_cant_max_cuotas').value;
             return oFrameFact.document.getElementById('prop_cant_cuotas').focus();
        }

        if (parseInt (document.getElementById('prop_cod_facturacion').value) > 0 ) {
            var cantMesesFact = 0;
            switch ( parseInt (document.getElementById('prop_cod_facturacion').value)) {
                case 1: cantMesesFact = 1;
                    break;
                case 2: cantMesesFact = 2;
                    break;
                case 3: cantMesesFact = 3;
                    break;
                case 4: cantMesesFact = 4;
                    break;
                case 5: cantMesesFact = 6;
                    break;
                case 6: cantMesesFact = 12;
            }
            var cantCuotas = parseInt (document.getElementById ('prop_cant_cuotas').value);
            var premio = parseFloat (document.getElementById ('prop_premio').value );
            var minValorCuota = parseFloat (document.getElementById ('pro_min_valor_cuota').value );
            var cantMesesVig = parseInt (document.getElementById ('pro_cant_meses_vigencia').value );
            var nuevaCuota   =  Math.round( ( (premio / (cantMesesVig /cantMesesFact )) / cantCuotas  ) * 100) / 100;

            if (premio < minValorCuota ) {
                document.getElementById ('pro_valor_cuota').value = premio ;
                document.getElementById ('prop_cant_cuotas').value = "1";
            } else {
                if (nuevaCuota < minValorCuota ) {
                    alert ("Modifique la facturación porque el valor de la cuota esta por debajo de la cuota minima.\nValor de cuota: $ " + nuevaCuota + ", cuota mínima $ " + minValorCuota );
                    return oFrameFact.document.getElementById ('prop_fac').focus();
                } else  {
                    document.getElementById ('pro_valor_cuota').value = nuevaCuota ;
                }
            }
        }


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
        if (Trim(document.getElementById('prop_tom_prov').value) == "-1") {
            alert (" Debe informar la provincia del tomador ");
            return document.getElementById('prop_tom_prov').focus();
        }

        if (document.getElementById ('prop_cod_ambito').value != "1" &&
            document.getElementById('prop_cod_prod').value != "34991" ) {
            var ubic_dom = document.getElementById('prop_ubic_dom').value.toUpperCase();

            for(var i=0; i< pClaves.length; i++ ){
                if (ubic_dom.indexOf( pClaves[i]) != -1) {
                    alert ("Domicilio de la ubicación del riesgo inválida !!!");
                    return document.getElementById('prop_ubic_dom').focus();
                }
            }
        }

        if (Trim(document.getElementById('prop_ubic_loc').value) == "") {
            alert (" Debe informar la localidad del riesgo");
            return document.getElementById('prop_ubic_loc').focus();
        }

        if (document.getElementById ('prop_cod_ambito').value != "1"  &&
            document.getElementById('prop_cod_prod').value != "34991" ) {
            var ubic_dom = document.getElementById('prop_ubic_loc').value.toUpperCase();

            for(var i=0; i< pClaves.length; i++ ){
                if (ubic_dom.indexOf( pClaves[i]) != -1) {
                    alert ("Localidad de la ubicación del riesgo inválida !!!");
                    return document.getElementById('prop_ubic_loc').focus();
                }
            }
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
       if ( document.getElementById ('prop_ubic_cp').value != document.getElementById ('prop_tom_cp').value  ||
            document.getElementById ('prop_ubic_prov').value != document.getElementById ('prop_tom_prov').value ||
            document.getElementById ('prop_ubic_dom').value != document.getElementById ('prop_tom_dom').value ||
            document.getElementById ('prop_ubic_loc').value != document.getElementById ('prop_tom_loc').value ) {
            document.getElementById ('prop_misma_ubic_riesgo').value = "N";
            document.getElementById ('prop_misma_ubic_riesgo').checked  = 0;
        }

        if (oFrameFact.document.getElementById('prop_form_pago').value == "8" &&
            mercadoPago == 'N' ) { //MERCADOPAGO
            alert (" Por el momento no es posible pagar a travéz de MERCADOPAGO !! ");
            return oFrameFact.document.getElementById('prop_form_pago').focus();
        }

        if (oFrameFact.document.getElementById('prop_form_pago').value == "0") {
            alert (" Debe informar la forma de pago ");               
            return oFrameFact.document.getElementById('prop_form_pago').focus();

        } else if (oFrameFact.document.getElementById('prop_form_pago').value == "1") {
              
            if (oFrameFact.document.getElementById('pro_TarCred').value == "0") {
                alert (" Debe informar la tarjeta de credito  ");               
                return oFrameFact.document.getElementById('pro_TarCred').focus();
            }
            
            if (Trim(oFrameFact.document.getElementById('pro_TarCredNro').value) == "") {
                alert (" Debe informar el número de la tarjeta de crédito  ");
                return oFrameFact.document.getElementById('pro_TarCredNro').focus();
            }

        } else if (oFrameFact.document.getElementById('prop_form_pago').value == "4") {
            if (Trim(oFrameFact.document.getElementById('pro_DebCtaCBU').value) == "") {
                alert (" Debe informar el CBU");               
                return oFrameFact.document.getElementById('pro_DebCtaCBU').focus();
            }
            if ( oFrameFact.document.getElementById('pro_DebCtaCBU').value.length != 22 ) {
                alert (" La CBU debería tener 22 cifras");               
                return oFrameFact.document.getElementById('pro_DebCtaCBU').focus();
            }
            if ( validarCBU (oFrameFact.document.getElementById('pro_DebCtaCBU').value) == false ) {
                alert (" La CBU es inválida, por favor, verifique que sea correcta");
                return oFrameFact.document.getElementById('pro_DebCtaCBU').focus();
            }
        }   else if (oFrameFact.document.getElementById('prop_form_pago').value == "6") {
            var entidad = oFrameFact.document.getElementById('pro_CtaBco').value;
            var mcaCuenta  = oFrameFact.document.getElementById('sobre_mca_cuenta_' + entidad ).value;
            var sizeCuenta = parseInt (oFrameFact.document.getElementById('sobre_size_cuenta_' + entidad ).value);
            var mcaConvenio = oFrameFact.document.getElementById('sobre_mca_convenio_' + entidad ).value;

            if (codSubRama == 2 || codSubRama == 9) {
                alert (" Productos no validos para la forma de pago Debito Bancario(convenio)/Sobre");
                return oFrameFact.document.getElementById('pro_CtaBco').focus();
            }
            if (Trim( entidad ) == "0") {
                alert (" Debe informar la entidad ");
                return oFrameFact.document.getElementById('pro_CtaBco').focus();
            }
            if ( mcaCuenta == "X" && Trim(oFrameFact.document.getElementById('pro_cuenta_banco').value) == "") {
                alert (" Debe informar la cuenta");
                return oFrameFact.document.getElementById('pro_cuenta_banco').focus();
            }
            if ( mcaCuenta == "X" &&
                ! ( Trim(oFrameFact.document.getElementById('pro_cuenta_banco').value).length == sizeCuenta )) {
                alert (" La cuenta debería tener " + sizeCuenta + "  cifras, si es menor complete con ceros a izquierda ");
                return oFrameFact.document.getElementById('pro_cuenta_banco').focus();
            }

            if ( mcaConvenio == "X" &&
                 ( Trim (oFrameFact.document.getElementById ('pro_convenio').value)  == "0" ||
                   Trim (oFrameFact.document.getElementById ('pro_convenio').value) == "" )  ) {
                alert (" Debe informar el convenio");
                return oFrameFact.document.getElementById('pro_convenio').focus();
            }
        }
        
//        if ( !  ( document.formProp.prop_mca_envio_poliza[0].checked  ||
//                  document.formProp.prop_mca_envio_poliza[1].checked ||
//                  document.formProp.prop_mca_envio_poliza[2].checked ) ) {
//                alert (" Debe seleccionar como desea recibir la póliza ");
//                return document.formProp.prop_mca_envio_poliza[0].focus();
//             }
          
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

 
    function SetearUbicacion ( ubic) {

        if ( ubic.checked == true ) {
            if (document.getElementById ('prop_ubic_prov').value == document.getElementById ('prop_tom_prov').value ) {
                document.getElementById ('prop_ubic_cp').value = document.getElementById ('prop_tom_cp').value;
                document.getElementById ('prop_ubic_prov').value = document.getElementById ('prop_tom_prov').value;
                document.getElementById ('prop_ubic_dom').value = document.getElementById ('prop_tom_dom').value;
                document.getElementById ('prop_ubic_loc').value = document.getElementById ('prop_tom_loc').value;
                ubic.value = 'S';
            } else {
                alert ("Para tildar misma ubicación la provincia del tomador tiene que ser igual a la provincia del riesgo");
                ubic.checked = 0;
                ubic.value = 'N';
                return document.getElementById ('prop_ubic_dom').focus();
            }
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

  function DoChangeFact () {
     if (oFrameFact ) {
        document.getElementById('prop_cant_cuotas').value =
            oFrameFact.document.getElementById ('prop_cant_cuotas').value;

        document.getElementById('prop_cant_max_cuotas').value =
            oFrameFact.document.getElementById ('prop_cant_max_cuotas').value;

        document.getElementById('prop_cod_facturacion').value       =
            oFrameFact.document.getElementById ('prop_fac').value;

        if (parseInt (document.getElementById('prop_cod_facturacion').value) > 0 ) {
            var cantMesesFact = 0;
            switch ( parseInt (document.getElementById('prop_cod_facturacion').value)) {
                case 1: cantMesesFact = 1;
                    break;
                case 2: cantMesesFact = 2;
                    break;
                case 3: cantMesesFact = 3;
                    break;
                case 4: cantMesesFact = 4;
                    break;
                case 5: cantMesesFact = 6;
                    break;
                case 6: cantMesesFact = 12;
            }
            var cantCuotas = parseInt (document.getElementById ('prop_cant_cuotas').value);
            var premio = parseFloat (document.getElementById ('prop_premio').value );
            var minValorCuota = parseFloat (document.getElementById ('pro_min_valor_cuota').value );
            var cantMesesVig = parseInt (document.getElementById ('pro_cant_meses_vigencia').value );
            var nuevaCuota   =  Math.round( ( (premio / (cantMesesVig /cantMesesFact )) / cantCuotas  ) * 100) / 100;

            if (premio < minValorCuota ) {
                alert ("Como el premio esta por debajo de la cuota mínima se tiene que emitir en una sola cuota" );
                document.getElementById ('pro_valor_cuota').value = premio ;
                document.getElementById ('prop_cant_cuotas').value = "1";
                oFrameFact.document.getElementById ('prop_cant_cuotas').value = "1";
            } else {
                if (nuevaCuota < minValorCuota ) {
                    alert ("Modifique la facturación porque el valor de la cuota esta por debajo de la cuota minima.\nValor de cuota: $ " + nuevaCuota + ", cuota mínima $ " + minValorCuota );
                    return oFrameFact.document.getElementById ('prop_fac').focus();
                } else  {
                    document.getElementById ('pro_valor_cuota').value = nuevaCuota ;
                }
            }
        }
     }
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
        <td align="center" valign="top" width='100%'>
            <table border='0' width='100%'>
                <form method="post" action="<%= Param.getAplicacion()%>servlet/PropuestaServlet" name='formProp' id='formProp' accept-charset="utf-8">
                    <input type='hidden' name='prop_numSocio'           id='prop_numSocio'  value='<%=numSocio%>' />
                    <input type="hidden" name="opcion"                  id="opcion"         value='' />
                    <input type="hidden" name="volver"                  id="volver"
                           value="<%= (request.getParameter("volver") == null ? "filtrarPropuestas" : request.getParameter("volver"))%>" />
                    <input type="hidden" name="prop_nro_cot"            id="prop_nro_cot"   value="<%=nroCot%>" />
                    <input type="hidden" name="prop_num_prop"           id="prop_num_prop"  value="<%=nroProp%>" />
                    <input type="hidden" name="prop_cod_est"            id="prop_cod_est"  value="<%=codEstado%>" />
                    <input type="hidden" name="prop_cant_max_clausulas" id="prop_cant_max_clausulas"  value="<%= oProp.getcantMaxClausulas ()%>" />
                    <input type="hidden" name="prop_aseg_actividad"     id="prop_aseg_actividad" value="<%= oProp.getCodActividad() %>"/>
                    <input type="hidden" name="prop_cod_actividad_sec"  id="prop_cod_actividad_sec" value="<%= oProp.getcodActividadSec ()%>"/>
                    <input type="hidden" name="pro_TarCredTitDomicilio" id="pro_TarCredTitDomicilio" value=""/>
                    <input type="hidden" name="prop_tipo_propuesta"     id="prop_tipo_propuesta" value="<%=(oProp == null ? "P" : oProp.getTipoPropuesta())%>"/>
                    <input type="hidden" name="prop_num_doc_orig"       id="prop_num_doc_orig"   value="<%=documento%>"/>
                    <input type="hidden" name="prop_cod_facturacion"    id="prop_cod_facturacion" value="<%=(oProp == null ? 0 : oProp.getCodFacturacion())%>"/>
                    <input type="hidden" name="prop_sub_rama"           id="prop_sub_rama"   value="<%=(oProp == null ? 2 : oProp.getCodSubRama() )%>"/>
                    <input type="hidden" name="prop_cod_ambito"         id="prop_cod_ambito" value="<%=(oProp == null ? 0 : oProp.getcodAmbito()) %>"/>

                    <input type="hidden" name="prop_cant_cuotas"        id="prop_cant_cuotas"    value="<%= oProp.getCantCuotas() %>"/>
                    <input type="hidden" name="prop_cant_max_cuotas"    id="prop_cant_max_cuotas" value="<%= oProp.getCantCuotas() %>"/>
                    <input type="hidden" name="prop_cant_cuotas_vig"    id="prop_cant_cuotas_vig" value="<%= oProp.getCantCuotas() %>"/>
                    <input type="hidden" name="prop_cod_producto"       id="prop_cod_producto"   value="<%=(oProp == null ? 1 : oProp.getcodProducto () )%>"/>
                    <input type="hidden" name="prop_form_pago"          id="prop_form_pago" value="<%= formaPago %>" />
                    <input type="hidden" name="pro_TarCred"             id="pro_TarCred" value="<%= codTarjeta %>" />
                    <input type="hidden" id="pro_TarCredNro"            name="pro_TarCredNro" value="<%=nroTarjCred%>" />
                    <input type="hidden" name="pro_TarCredVto"          id="pro_TarCredVto" value="<%=fechaVtoTarjCred%>" />
                    <input type="hidden" name="pro_TarCredTit"          id="pro_TarCredTit" value="<%=titularTarj%>" />
                    <input type="hidden" name="pro_DebCtaCBU"           id="pro_DebCtaCBU" value="<%=CBU%>" />
                    <input type="hidden" name="pro_CtaTit"              id="pro_CtaTit"                 value="<%=titularCta%>"/>
                    <input type="hidden" name="pro_CtaBco"              id="pro_CtaBco"                 value="<%=codBcoCta %>"/>
                    <input type="hidden" name="pro_cuenta_banco"        id="pro_cuenta_banco"           value="<%=CBU%>" />
                    <input type="hidden" name="pro_convenio"            id="pro_convenio"               value="<%=titularCta%>" />
                    <input type="hidden" name="pro_min_valor_cuota"     id="pro_min_valor_cuota"        value="<%= minValorCuota%>"/>
                    <input type="hidden" name="pro_cant_meses_vigencia" id="pro_cant_meses_vigencia"   value="<%= cantMeses %>"/>
                    <input type="hidden" name="pro_valor_cuota"         id="pro_valor_cuota"            value="<%= oProp.getImpCuota() %>"/>
                <tr>
                    <td>
                        <table border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>
                            <tr>
                                <td  colspan='3' height="30px" valign="middle" align="center" class='titulo'><u>FORMULARIO DE PROPUESTA</u></td>
                            </tr>
                            <tr>
                                <td  colspan='3' height="30px" valign="middle" align="left" class='titulo'>Datos Generales</td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text' nowrap width="120">Propuesta Nº:</td>
                                <td align="left" class='text'>
                                    <input type="text" name="prop_nro" id="prop_nro"  size="20" maxleng="20" value="<%=nroPropDesc%>" readonly/>
                        &nbsp;&nbsp;&nbsp;
                                    <% if (oProp != null && oProp.getTipoPropuesta().equals("R")) {
                                        %>
                                        <span class="subtitulo">RENUEVA POLIZA:&nbsp;<%= oProp.getNumPoliza()%></span>
<%                                      }
    %>

                                </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left"  class="text" valign="top" >Rama:&nbsp;</td>
                                <td align="left"  class="text">
                                    <select name="prop_rama" id="prop_rama" class="select" disabled style="width: 300px;" >
<%                                  lTabla = oTabla.getRamas ();
                                    out.println(ohtml.armarSelectTAG(lTabla,10));  
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
                                    <select class='select' name="prop_cod_prod" id="prop_cod_prod" style="width: 350px;">
                                        <option value='<%=String.valueOf(usu.getiCodProd())%>'> <%=usu.getsDesPersona() + " (" + usu.getiCodProd() + ")" %>
                                        </option>
                                    </select>
                                    &nbsp;
                                    <LABEL>Cod : </LABEL>
                                    &nbsp;
                                    <INPUT name="prod_dir" id="prod_dir" value='0' size='10' maxlength='10' class='inputTextNumeric' onchange='CambiarSelectProd ( this );' onkeypress="" >
                                </td>
                            </tr>
<%
   } else {
%>
                            <TR>
                                <TD width='15'>&nbsp;</TD>
                                <TD align="left" class='text'>Productor:</TD>
                                <TD align="left" class='text'>
                                    <select class='select' name="prop_cod_prod" id="prop_cod_prod" style="width: 300px;">
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
                                <input name="prod_dir" id="prod_dir" value='0' size='10' maxlength='10' class='inputTextNumeric' onchange='CambiarSelectProd ( this );' onkeypress="" />

                            </tr>
<%
  }
%>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Vigencia:</td>
                                <td align="left" class='text'>
                                    <select name="prop_vig" id="prop_vig" class="select" style="width: 300px;" disabled>
<%  
                                          lTabla = oTabla.getDatosOrderByDesc ("VIGENCIA");
                                          out.println(ohtml.armarSelectTAG(lTabla,  String.valueOf(codVig))); 
%>
                                    </select>
                                    &nbsp;Desde:&nbsp;
                                    <input type="text" name="prop_vig_desde" id="prop_vig_desde" size="10"  maxlength='10' onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value="<%=fechaVigDesde%>" <%=disabled%> />&nbsp;(dd/mm/yyyy)
                                    &nbsp;al:&nbsp;
                                    <input type="text" name="prop_vig_hasta" id="prop_vig_hasta" size="10"  maxlength='10' onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value="<%=fechaVigHasta%>" <%=disabled%> />&nbsp;(dd/mm/yyyy)
                                </td>
                             </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td class='text' colspan='2' align='left'>
                                    <LABEL> <span style='color:red;'><U>Atenci&oacute;n:</U></span><b> La Fecha de Inicio de la P&oacute;liza es tentativa y
                                            supeditada a la aprobaci&oacute;n de la misma por la compa&ntilde;ia.<br>
                                            Todas las propuestas enviadas después de las 12:00 hs. tendrá fecha de inicio de vigencia a partir del día siguiente.</b><BR><BR>
                                    </LABEL>
                                </td>
                                
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left"  class="text" colspan='2' width="100%">
                                    <iframe name="oFrameFact" id="oFrameFact"style="width:100%;height:175px;" marginheight="0" marginwidth="0"
                                            marginheight="0" align="top"  frameborder="0"  scrolling="no" src="<%= sUrlFact %>">
                                    </iframe>
                                </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Actividad :</td>
                                <td align="left" class='text'><%= oProp.getdescActividad() %>
<%--                                    <select name="prop_aseg_actividad" id="prop_aseg_actividad" class="select" style="width:700px;" disabled >
            <%                  lTabla = oTabla.getActividades ();
                                out.println(ohtml.armarSelectTAG(lTabla,codActividad)); 
%>
                              </select>
--%>
                            </td>
                          </tr>
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
                                <td align="left" class='text' width="120">
                                    Documento :
                                </td>

                                <td align="left" class='text'>
                                    <select style="WIDTH: 100px" name="prop_tom_tipoDoc" id="prop_tom_tipoDoc"  class="select" <%=disabled%>>
<%  
                                 lTabla = oTabla.getDatos ("DOCUMENTO");
                                 out.println(ohtml.armarSelectTAG(lTabla,String.valueOf(tipoDoc)) ); 
%>  
                                    </select>
                                    &nbsp;&nbsp;
                                    <input name="prop_tom_nroDoc" id="prop_tom_nroDoc" size='20' maxlength='11' onkeypress="return Mascara('D',event);" class="inputTextNumeric" value="<%=documento%>" <%=disabled%>>
                                    &nbsp;&nbsp;
<%                                  if( disabled.equals("")) { %>
                                    <input type="button" name="cmdVerifTom" value=" Verificar Persona" height="20px" class="boton" onClick="VerificarTomador();">
<%                                  } %>
                                </td>

                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Apellido / Razón Social:</td>
                                <td align="left" class='text'>
                                    <input type="text" name="prop_tom_apellido" id="prop_tom_apellido"  size="55" maxleng="100"
                                    value="<%= (oProp.getTomadorApe () == null ? "" : oProp.getTomadorApe ())%>" <%=disabled%> >
                                </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Nombre:</td>
                                <td align="left" class='text'>
                                    <input type="text" name="prop_tom_nombre" id="prop_tom_nombre"  size="55" maxleng="50"
                                    value="<%=  (oProp.getTomadorNom () == null ? "" : oProp.getTomadorNom ())%>" <%=disabled%> />
                                </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Condici&oacute;n&nbsp;IVA:</td>
                                <td align="left" >
                                    <select name="prop_tom_iva" id="prop_tom_iva" size="1" style="width: 300px;" class="select" <%=disabled%> >
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
                                    <input type="text" name="prop_tom_dom" id="prop_tom_dom"  size="55" maxlengTH="100" value="<%=domicilio%>" <%=disabled%> >
                                </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Localidad:</td>
                                <td align="left" class='text'>
                                    <input type="text" name="prop_tom_loc" id="prop_tom_loc"  size="55" maxlength="50" value="<%=localidad%>" <%=disabled%> >
                                </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>C&oacute;digo&nbsp;Postal:</td>
                                <td align="left">
                                    <input type="text" name="prop_tom_cp" id="prop_tom_cp" value="<%=codigoPostal%>" size='8' maxlength='4' onkeypress="return Mascara('D',event);" class="inputTextNumeric" <%=disabled%> >
                                </td>
                            </tr>
                             <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Mail:</td>
                                <td align="left" class='text'><input type="text" name="prop_tom_email" id="prop_tom_mail" value="<%=mail%>" size="55" maxlengh="100" <%=disabled%> /></td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Telefono:</td>
                                <td align="left" class='text'><input type="text" name="prop_tom_te" id="prop_tom_te" value="<%=telefono%>" size="55" maxlengh="50" <%=disabled%> /></td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Provincia:</td>
                                <td align="left" class='text'>
                                    <select name="prop_tom_prov" id="prop_tom_prov" class="select" style="width:300px;">
 <%  
                                    lTabla = oTabla.getDatosOrderByDesc ("PROVINCIA");
                                    out.println(ohtml.armarSelectTAG(lTabla, String.valueOf(codProvincia))); 
%>
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>
                            <tr>
                                <td  colspan='3' height="30px" valign="middle" align="left" class='titulo'>Ubicación del Riesgo</td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td  colspan='2' valign="middle" align="left" class='subtitulo' >La ubicación del riesgo es la misma que el domicilio del tomador
                                <input type="checkbox" value='<%= oRiesgo.getigualTomador() %>' name='prop_misma_ubic_riesgo' id='prop_misma_ubic_riesgo'  <%= (oRiesgo.getigualTomador().equals ("S") ? "checked" : " ") %>  onclick="SetearUbicacion (this);"/>
                                </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text' width="120">Domicilio:</td>
                                <td align="left" class='text'>
                                    <input type="text" name="prop_ubic_dom" id="prop_ubic_dom"  size="55" maxlengTH="100" value="<%= oRiesgo.getdomicilio() %>" <%=disabled%> />
                                </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Localidad:</td>
                                <td align="left" class='text'>
                                    <input type="text" name="prop_ubic_loc" id="prop_ubic_loc"  size="55" maxlength="50" value="<%= oRiesgo.getlocalidad()%>" <%=disabled%> />
                                </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>C&oacute;digo&nbsp;Postal:</td>
                                <td align="left">
                                    <input type="text" name="prop_ubic_cp" id="prop_ubic_cp" value="<%=oRiesgo.getcodPostal()%>" size='8' maxlength='4' onkeypress="return Mascara('D',event);" class="inputTextNumeric" <%=disabled%> />
                                </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text'>Provincia:</td>
                                <td align="left" class='text'>
                                    <select name="prop_ubic_prov" id="prop_ubic_prov" class="select" style="width:300px;" disabled >
                                        <option  value="-1">Seleccionar</option>
 <%  
                                    lTabla = oTabla.getDatosOrderByDesc ("PROVINCIA");
                                    out.println(ohtml.armarSelectTAG(lTabla, String.valueOf( oRiesgo.getprovincia()))); 
%>
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                 <tr>
                    <td>
                        <table border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>
                            <tr>
                                <td  colspan='3' height="30px" valign="middle" align="left" class='titulo'>Sumas Aseguradas por Personas</td>
                            </tr>

                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text' width='200px'>Muerte:</td>
                                <td align="left" class='text'>
                                    &nbsp;$&nbsp;
                                    <input type="text" align='right'  name="prop_cap_muerte" id="prop_cap_muerte" value="<%= capMuerte %>"   onKeyPress="return Mascara('N',event);" class="inputTextNumeric" readonly  size="30"/>
                                </td>
                            </tr>

                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text' width='200px'>Invalidez Permanente Total y/o Parcial:</td>
                                <td align="left" class='text'>
                                    &nbsp;$&nbsp;
                                    <input type="text" name="prop_cap_invalidez" id="prop_cap_invalidez" value="<%= capInvalidez %>"  onKeyPress="return Mascara('N',event);" class="inputTextNumeric"  readonly  size="30"/>
                                </td>
                            </tr>

                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text' width='200px'>Asistencia M&eacute;dico y/o Farm.:</td>
                                <td align="left" class='text'>
                                    &nbsp;$&nbsp;
                                    <input type="text" name="prop_cap_asistencia" id="prop_cap_asistencia"  value="<%= capAsist %>"   onKeyPress="return Mascara('N',event);" class="inputTextNumeric" readonly size="30"/>
                                </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text' width='200px'>Franquicia:</td>
                                <td align="left" class='text'>
                                    &nbsp;$&nbsp;
                                    <input type="text" name="prop_franquicia" id="prop_franquicia"  size="30" value="<%= franquicia %>"   onKeyPress="return Mascara('N',event);" class="inputTextNumeric" readonly size="30"/>
                                </td>
                            </tr>
                            
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td colspan='2'>&nbsp;</td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text' width='200px'>Prima comisionable:</td>
                                <td align="left" class='text'>
                                    &nbsp;$&nbsp;
                                    <input type="text" name="prop_prima" id="prop_prima"  size="30"  value="<%= Dbl.DbltoStr(prima,2) %>"   onKeyPress="return Mascara('N',event);" class="inputTextNumeric" readonly/>
                                </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text' width='200px'>Premio:</td>
                                <td align="left" class='text'>
                                    &nbsp;$&nbsp;
                                    <input type="text" name="prop_premio" id="prop_premio"  size="30" value="<%= Dbl.DbltoStr( premio, 2) %>"   onKeyPress="return Mascara('N',event);" class="inputTextNumeric" readonly/>
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
<%--                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text' valign="top" width='130' nowrap>Seleccione forma de envío:</td>
                                <td align="left" class='text' >
                                    <input type="radio" value='S' name='prop_mca_envio_poliza' id='prop_mca_envio_poliza' <%= (oProp.getMcaEnvioPoliza().equals ("S") ? "checked" : " ") %>/>&nbsp;Deseo recibir la p&oacute;liza <b>impresa por CORREO</b><br/>
                                    <input type="radio" value='N' name='prop_mca_envio_poliza' id='prop_mca_envio_poliza' <%= (oProp.getMcaEnvioPoliza().equals ("N") ? "checked" : " ") %>/>&nbsp;NO deseo recibir la p&oacute;liza.<br/>
                                    <input type="radio" value='M' name='prop_mca_envio_poliza' id='prop_mca_envio_poliza' <%= (oProp.getMcaEnvioPoliza().equals ("M") ? "checked" : " ") %>/>&nbsp;Deseo recibir la p&oacute;liza <b>v&iacute;a MAIL</b><br/>
                                 </td>
                            </tr>
                            <tr><td colspan='3'><hr/></td></tr>
--%>
                            <input type="hidden" name="prop_mca_envio_poliza" id="prop_mca_envio_poliza" value="M"/>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text' valign="top"  nowrap width="150px">Beneficiarios:</td>
                                <td align="left" class='text' >
                                    <input type="CHECKBOX" value='<%= oProp.getbenefHerederos () %>' name='prop_benef_herederos' id='prop_benef_herederos' <%= (oProp.getbenefHerederos().equals ("S") ? "checked" : " ") %>/>&nbsp;Herederos legales
                                    &nbsp;&nbsp;<b>(En 2do. t&eacute;rmino por el saldo de la prestaci&oacute;n)</b>
                                    <br/>
                                    <input type="CHECKBOX" value='<%= oProp.getbenefTomador () %>' name='prop_benef_tomador' id='prop_benef_tomador' <%= (oProp.getbenefTomador().equals ("S") ? "checked" : " ") %>/>&nbsp;Tomador
                                    &nbsp;&nbsp;<b>(En 1er. t&eacute;rmino y hasta su responsabilidad civil o legal por accidente del empleado)</b>
                                 </td>
                            </tr>
                            <tr><td colspan='3'><hr/></td></tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text' valign="top" >Num. de referencia:</td>
                                <td align="left" class='text' >
                                        <input name="prop_num_referencia" id="prop_num_referencia" value="<%= (oProp == null ? 0 : oProp.getnumReferencia()) %>"  size='22' maxlength='8'
                                               onkeypress="return Mascara('D',event);" class="inputTextNumeric"/>
                                        &nbsp;&nbsp;&nbsp;Este campo no es obligatorio, se refiere al n&uacute;mero de solicitud de su sistema de gesti&oacute;n de cartera.
                                </td>
                            </tr>

                            <tr><td colspan='3'><hr/></td></tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text' valign="top">Cl&aacute;usulas:</td>
                                <td align="left" class='text' >
                                    <input type="CHECKBOX" value='<%= oProp.getclaNoRepeticion () %>' name='prop_cla_no_repeticion'  id='prop_cla_no_repeticion' <%= (oProp.getclaNoRepeticion ().equals ("S") ? "checked" : " ") %>>&nbsp;Cl&aacute;usula de No Repetición<br>
                                    <input type="CHECKBOX" value='<%= oProp.getclaSubrogacion () %>' name='prop_cla_subrogacion' id='prop_cla_subrogacion' <%= (oProp.getclaSubrogacion ().equals ("S") ? "checked" : " ") %>>&nbsp;Cl&aacute;usula de Subrogación
                                 </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text' valign="top" >Ingrese lista de Empresas:</td>
                                <td class='text'  align="left">&nbsp;&nbsp;&nbsp;&nbsp;Cuit&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Empresa</td>
                            </tr>
<%                  if (oProp.getAllClausulas().size() > 0 ) {    
                        for (int i = 1;i <= oProp.getAllClausulas().size() ;i++) {
                            Clausula oCla = (Clausula) oProp.getAllClausulas().get(i - 1);
                            
    %>
                            <tr>
                                <td colspan="2">&nbsp;</td>
                                <td align="left" class='text' >
                                    <input type="hidden" name="CLA_ITEM_<%= i %>">
                                    <input type="text" name="CLA_CUIT_<%= i %>" value="<%= oCla.getcuitEmpresa() %>" size='11' maxlength='11'  onkeypress="return Mascara('D',event);" onblur="ValidoCuitEmpresa ( this );"  class="inputTextNumeric">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <input type="text" name="CLA_DESCRIPCION_<%= i %>" value="<%= oCla.getdescEmpresa() %>" size='50' maxlength='50'>
                                 </td>
                            </tr>
<%                      }
                    }
                    if ( oProp.getcantMaxClausulas () > oProp.getAllClausulas().size() ) {   
                     
                      for (int ii = oProp.getAllClausulas().size() + 1 ; ii <= oProp.getcantMaxClausulas () ;ii++) {
    %>
                            <tr>
                                <td colspan="2">&nbsp;</td>
                                <td align="left" class='text' >
                                    <input type="hidden" name="CLA_ITEM_<%= ii %>">
                                    <input type="text" name="CLA_CUIT_<%= ii %>" size='11' maxlength='11'  onkeypress="return Mascara('D',event);" onblur="ValidoCuitEmpresa ( this );"  class="inputTextNumeric">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <input type="text" name="CLA_DESCRIPCION_<%= ii %>" size='50' maxlength='50'>
                                 </td>
                            </tr>
<%                     }
                   }
    %>
 <%--                           <tr><td colspan='3'><hr></td></tr>
                            <tr>
                                <td align="left" class='text' colspan='3'>Observaci&oacute;n :</td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td width="100%" colspan='2'>
                                    <TEXTAREA cols='65' rows='3' name="prop_obs" id="prop_obs" <%=disabled%>  ><%= (observacion == null ? "" : observacion ) %></TEXTAREA>
                                </td>
                                
                            </tr>
--%>
                            <input type="hidden" name="prop_obs" id="prop_obs"  value='<%= observacion %>' >
                        </table>
                    </td>
                </tr>
                <tr valign="bottom" >
                    <td width="100%" align="center">
                        <table  width='100%' border="0" cellspacing="0" cellpadding="0" align="center">
                            <tr>
                                <td align="center" height="35px" valign="middle">
<%                              if (nroProp > 0) {
    %>
                                    <input type="button" name="cmdEliminar"  value="Eliminar Propuesta"  height="20px" class="boton" onClick="Eliminar ();"/>&nbsp;&nbsp;&nbsp;&nbsp;
<%                              }
    %>
                                    <input type="button" name="cmdSalir"  value="Salir"  height="20px" class="boton" onClick="Salir ();"/>&nbsp;&nbsp;&nbsp;&nbsp;
                                    <input type="button" name="cmdVolver"  value="Volver"  height="20px" class="boton" onClick="Volver ();"/>&nbsp;&nbsp;&nbsp;&nbsp;
<%                                  if( disabled.equals("")) { %>
<input type="button" name="cmdGrabar"  value="Grabar y Continuar Listado Nominas >>"  height="20px" class="boton" onClick="Grabar();"/>
<%                                  } %>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                </form>
            </table>
        </td>
    </tr>
    <tr>
        <td width='100%'>
            <jsp:include flush="true" page="/bottom.jsp"/>
        </td>
    </tr>
</table>
<script>
CloseEspere();
</script>
</body>
</html>
