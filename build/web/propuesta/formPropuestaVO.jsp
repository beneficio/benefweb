<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.db.*"%>
<%@page import="java.sql.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Propuesta"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.beans.FormaPago"%>
<%@page import="com.business.beans.Provincia"%>
<%@page import="com.business.beans.Facturacion"%>
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
                        
    LinkedList lFact = ConsultaMaestros.getAllCondFacturacion ( 21 ); 
    LinkedList lProv = ConsultaMaestros.getAllProvincias();
    LinkedList <FormaPago> lfPagos = new LinkedList();
     
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

    int capMuerte    = 0;
    double premio       = 0;
    double prima        = 0;
    String observacion  = "";
    int    formaPago    = 0; 
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
    int    cantCuotas   = 1 ;
    int    numSocio     = 0; // num Tomador
    int    codEstado    = 0;
    int    cantMeses = 1;
   
    String disabled = "";
    String mcaEnvio = "M";
    String benefHerederos = "S";
    int numReferencia  = 0;
    String sMercadoPago = "N";

    Connection dbCon = null;
    CallableStatement proc = null;
    ResultSet rs = null;
    try {
        dbCon = db.getConnection();
        dbCon.setAutoCommit(false);

//        lfPagos  = ConsultaMaestros.getAllFormaPago (dbCon, 21, 999, 999, -1, 99999999 );

        if (oProp != null) {
            if (oProp.getNumPropuesta()>0) {
                nroPropDesc = String.valueOf(oProp.getNumPropuesta());
                nroProp     = oProp.getNumPropuesta();
            }

            codProd      = oProp.getCodProd();
            descProd     = oProp.getdescProd();
            codVig       = oProp.getCodVigencia ();
            codActividad = oProp.getCodActividad();

            telefono     = (oProp.getTomadorTE ()==null)?"":oProp.getTomadorTE ();
            mail         = (oProp.getTomadorEmail()==null)?"":oProp.getTomadorEmail();

            numSocio     = oProp.getNumTomador();
            apeRazon     = ( oProp.getTomadorApe () == null ? "" : oProp.getTomadorApe ());
            nombre       = ( oProp.getTomadorNom () == null ? "" : oProp.getTomadorNom ());

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

            disabled = "disabled";
            if (codEstado == 0 || codEstado==4 ) {
                disabled = "";
            }

            if (oProp.getFechaIniVigPol() == null) {
                oProp.setFechaIniVigPol(new java.util.Date());
            }
            gc.setTime(oProp.getFechaIniVigPol());
            fechaVigDesde = gc.get(Calendar.DAY_OF_MONTH) + "/" + (gc.get(Calendar.MONTH) + 1) + "/" + gc.get(Calendar.YEAR);

            if ( oProp.getCodVigencia() == 0 ) {
                oProp.setCodVigencia ( 12);
            }

            capMuerte    = (int) oProp.getCapitalMuerte();
            premio       = oProp.getImpPremio         ();
            prima        = oProp.getprimaPura       ();

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
            if (oProp.getMcaEnvioPoliza() != null) {
                mcaEnvio = oProp.getMcaEnvioPoliza();
            }
            if (oProp.getbenefHerederos() != null) {
                benefHerederos = oProp.getbenefHerederos();
            }
            numReferencia = oProp.getnumReferencia();

        } else {
             gc.setTime(new java.util.Date ());
            fechaVigDesde = gc.get(Calendar.DAY_OF_MONTH) + "/" + (gc.get(Calendar.MONTH) + 1) + "/" + gc.get(Calendar.YEAR);

            cantMeses = 12;
            formaPago = 0;
                proc = dbCon.prepareCall(db.getSettingCall("PRO_GET_ALL_SUMAS_COBERTURAS( ?, ?, ?, ?)"));
                proc.registerOutParameter(1, java.sql.Types.OTHER);
                proc.setInt(2, 21 );
                proc.setInt(3, 1);
                proc.setInt(4, 0);
                proc.setInt(5, 0);
                proc.execute();
                rs = (ResultSet) proc.getObject(1);
                while (rs.next ()) {
                    capMuerte = (int) rs.getDouble("MAX_SUMA_ASEGURADA");
                }
            }

            Parametro oParam = new Parametro ();

            if ( usu.getiCodTipoUsuario() == 0 ) {
                oParam.setsCodigo("ESTADO_MERCADOPAGO_INTERNO");
            } else  {
                oParam.setsCodigo("ESTADO_MERCADOPAGO_PROD");
            }

            sMercadoPago = oParam.getDBValor(dbCon);

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
    
    
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>JSP Page</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<script language="javascript">
if ( history.forward(1) ) {
    history.replace(history.forward(1));
}
</script>
</head>
<link rel="icon" href="<%= Param.getAplicacion()%>favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<link rel="stylesheet" type="text/css" href="<%=Param.getAplicacion()%>css/Tablas.css"/>

<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/alttxt.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/fechas.js"></script>
<script language='javascript'>
    var mercadoPago = '<%= sMercadoPago %>';
    var aDesdeFact = new Array (<%= lFact.size ()%>);
    var aHastaFact = new Array (<%= lFact.size ()%>);
    var aCodFact   = new Array (<%= lFact.size ()%>);
    var provConvenio = new Array(); 
<%  int ind = 0;
    for (int i=0; i<lProv.size();i++) {
        Provincia oP = (Provincia) lProv.get(i);
        if (oP.getConvMultilateral().equals("S")) { 
    %>
        provConvenio [<%=ind %>] = <%= oP.getCodigo() %>;
<%      ind++;
        }
    } 
    %>


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
      document.formProp.prop_tom_cp.disabled = false;    
      document.formProp.prop_aseg_actividad.disabled = false;    
      document.formProp.prop_desc_prod.disabled = false;    
      document.formProp.prop_vig.disabled = false;    
      document.formProp.prop_cod_prod.disabled = false;    
      document.formProp.prop_prima.disabled = false;    
      document.formProp.prop_premio.disabled = false;    
      document.formProp.prop_num_prop.disabled = false;    
      document.formProp.prop_cod_est.disabled = false;       
      document.formProp.prop_rama.disabled = false;
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
        document.getElementById ('prop_benef_herederos').value = 
        (document.getElementById ('prop_benef_herederos').checked === true ? 'S' : 'N' );
        document.getElementById ('prop_mca_empleada').value =
        (document.getElementById ('prop_mca_empleada').checked === true ? 'S' : 'N' );

        if ( ValidarDatos() ) {
            desbloquea();
            document.getElementById ('opcion').value = 'grabarPropuestaVO';
            document.formProp.submit();
        }
    }


    function ValidarDatos() {

        if ( provConvenio.indexOf(parseInt (document.getElementById("prop_tom_prov").value)) < 0 && 
             document.getElementById('prop_tipo_propuesta').value === "P") { 
            alert ("No se puede emitir en la provincia seleccionada porque no existe convenio");               
            return document.getElementById('prop_tom_prov').focus();
        }

        if ( document.getElementById('prop_cod_prod').value === "0" ) {
            alert (" Debe seleccionar un productor válido ");               
            return document.getElementById('prop_cod_prod').focus();
        }      

        if (document.getElementById('prop_vig_desde').value === "") {
            alert (" Debe informar la fecha de vigencia desde ");               
            return document.getElementById('prop_vig_desde').focus();
        }      

         var dateString  = validaFecha(document.getElementById('prop_vig_desde'));  // mm/dd/yyyy [IE, FF]
//        var Fecha_Inicial = new Date(parseInt (dateString.substring(6)),
//                                     parseInt (dateString.substring(3,4)) - 1,
//                                     parseInt (dateString.substring(0,2)) );
        var Fecha_Inicial = new Date (FormatoFec( validaFecha(document.getElementById('prop_vig_desde'))));
        var diasVigencia = parseInt (dateDiff('d', new Date(), Fecha_Inicial ));

        
        if ( diasVigencia > 32 || diasVigencia < -32 )  {
            alert (" La fecha de inicio de Vigencia no debe superar los 30 días de la emisión ");
            return document.getElementById('prop_vig_desde').focus();
        }

        if (parseInt (dateString.substring(0,2)) !== 1 ) {
            alert (" La fecha de inicio de Vigencia debería ser el 1er. día del mes actual o corriente ");
            return document.getElementById('prop_vig_desde').focus();
        }

        var mesVigencia = dateDiff('m', new Date(), Fecha_Inicial );
        if (mesVigencia !== -1 &&  mesVigencia !== 0 ) {
            alert (" La fecha de inicio de Vigencia debería ser el 1er. día del mes actual o corriente ");
            return document.getElementById('prop_vig_desde').focus();
        }

        if ( Trim(document.getElementById('prop_cantVidas').value) === "" ) {
            alert (" Debe ingresar la cantidad de asegurados de la nómina ");
            return document.getElementById('prop_cantVidas').focus();
        }

        if ( parseInt (Trim (document.getElementById('prop_cantVidas').value)) <= 0 ){
            alert (" Debe ingresar la cantidad de asegurados de la nómina ");
            return document.getElementById('prop_cantVidas').focus();
        }

        SetearFacturacion ();

        if (document.getElementById('prop_tom_tipoDoc').value !== "80") {
            alert ("El tipo de Documento es incorrecto, debe ser CUIT ");
               return document.getElementById('prop_tom_nroDoc').focus ();
        }

        if  ( ( document.getElementById('prop_mca_empleada').checked === true &&
              ( document.getElementById('prop_tom_iva').value === "3" ||
                document.getElementById('prop_tom_iva').value === "6" ||
                document.getElementById('prop_tom_iva').value === "9" ) ) ||
               ( document.getElementById('prop_mca_empleada').checked === false &&
              ( document.getElementById('prop_tom_iva').value === "3" ||
                document.getElementById('prop_tom_iva').value === "5" ||
                document.getElementById('prop_tom_iva').value === "6" ||
                document.getElementById('prop_tom_iva').value === "9" )) ) {
            alert ("La Condición de IVA es incorrecta ");
            return document.getElementById('prop_tom_iva').focus();
        }

        if (Trim(document.getElementById('prop_tom_nroDoc').value) === "") {
            alert (" Debe informar el numero de documento del tomador");
            return document.getElementById('prop_tom_nroDoc').focus();
        }

        if (Trim(document.getElementById('prop_tom_nroDoc').value) !==
            Trim(document.getElementById('prop_num_doc_orig').value) &&
            document.getElementById('prop_tipo_propuesta').value === "R") {
            alert ("No puede modificar el numero de documento en una RENOVACION");
            return document.getElementById('prop_tom_nroDoc').focus();
        }

        if (document.getElementById('prop_tom_tipoDoc').value === "80") {
            if ( ! ValidoCuit (Trim(document.getElementById('prop_tom_nroDoc').value))) {
                alert ("CUIT INVALIDO");
                return document.getElementById('prop_tom_nroDoc').focus ();
            }
        }

//        if (document.getElementById('prop_tom_tipoDoc').value == "96") {
//            if ( document.getElementById('prop_tom_nroDoc').value.length < 7 ||
//                 document.getElementById('prop_tom_nroDoc').value.length > 8) {
//                alert ("DOCUMENTO  INVALIDO");
//                return document.getElementById('prop_tom_nroDoc').focus ();
//            }
//        }

        if (Trim(document.getElementById('prop_tom_apellido').value) === "") {
            alert (" Debe informar el apellido o Razón Social del tomador");               
            return document.getElementById('prop_tom_apellido').focus();
        }
        
        if (Trim(document.getElementById('prop_tom_dom').value) === "") {
            alert (" Debe informar el domicilio del tomador");               
            return document.getElementById('prop_tom_dom').focus();
        }      

        if (Trim(document.getElementById('prop_tom_loc').value) === "") {
            alert (" Debe informar la localidad del tomador");               
            return document.getElementById('prop_tom_loc').focus();
        }      

        if (Trim(document.getElementById('prop_tom_cp').value) === "") {
            alert (" Debe informar el código postal del tomador");               
            return document.getElementById('prop_tom_cp').focus();
        }             

        if ( document.getElementById('prop_tom_cp').length <= 4) {
            alert ("La longitud del Cod. Postal debe ser menor o igual a 4 cifras");               
            return document.getElementById('prop_tom_cp').focus();
        }             

        if (document.getElementById('prop_form_pago').value === "8" &&
            mercadoPago === 'N' ) { //MERCADOPAGO
            alert (" Por el momento no es posible pagar a travéz de MERCADOPAGO !! ");
            return document.getElementById('prop_form_pago').focus();
        }

        if (document.getElementById('prop_form_pago').value === "0") {
            alert (" Debe informar la forma de pago ");               
            return document.getElementById('prop_form_pago').focus();

        } else if ( document.getElementById('prop_form_pago').value === "6" ) {
            alert (" Forma de pago invalida para la rama ");
            return document.getElementById('prop_form_pago').focus();

        } else if ( document.getElementById('prop_mca_empleada').checked === false &&
                    document.getElementById('prop_form_pago').value !== "5" ) {
            alert (" La forma de pago solo puede ser Formulario 931 ");
            return document.getElementById('prop_form_pago').focus();
            
        } else if ( document.getElementById('prop_mca_empleada').checked === true &&
                    document.getElementById('prop_form_pago').value !== "1" &&
                    document.getElementById('prop_tipo_propuesta').value === "P" ) {
            alert (" Para VCO de empleadas domésticas solo con Tarjeta de Crédito  ");
            return document.getElementById('prop_form_pago').focus();
        
        } else if ( document.getElementById('prop_mca_empleada').checked === true &&
                    ( document.getElementById('prop_form_pago').value !== "5" ||
                      document.getElementById('prop_form_pago').value !== "1" ) &&
                    document.getElementById('prop_tipo_propuesta').value === "R" ) {
            alert (" Renovaciones de VCO de empleadas domésticas solo con Tarjeta de Crédito o cupón ");
            return document.getElementById('prop_form_pago').focus();

       
        } else if (document.getElementById('prop_form_pago').value === "1") {
              
            var codTarjeta = document.getElementById('pro_TarCred').value;
            var numTarjeta = Trim(document.getElementById('pro_TarCredNro').value);
              
            if (codTarjeta === "0") {
                alert (" Debe informar la tarjeta de credito  ");               
                return document.getElementById('pro_TarCred').focus();
            }
            
            if (numTarjeta === "") {
                alert (" Debe informar el número de la tarjeta de credito  ");               
                return document.getElementById('pro_TarCredNro').focus();
            }
//    si es un 3 la tarjeta es American Express --> 4
//    si es un 4 la tarjeta es Visa --> 2
//    si es un 5 la tarjeta es MasterCard  --> 1
//    si es un 6 la tarjeta es Discover   --> resto             
                if ( codTarjeta === "4" && numTarjeta.substr (0,1) !== "3") {
                    alert ("Número de tarjeta invalido para American Express, debería empezar con 3");
                    return document.getElementById('pro_TarCredNro').focus();
                }
                if ( codTarjeta === "2" && numTarjeta.substr (0,1) !== "4") {
                    alert ("Número de tarjeta invalido para Visa, debería empezar con 4");
                    return document.getElementById('pro_TarCredNro').focus();
                }
                if ( codTarjeta === "1" && numTarjeta.substr (0,1) !== "5") {
                    alert ("Número de tarjeta invalido para Mastercard, debería empezar con 5");
                    return document.getElementById('pro_TarCredNro').focus();
                }
            

//            if (document.getElementById('pro_TarCredVto').value === "") {
//                alert (" Debe informar la fecha de vencimiento de la tarjeta de credito  ");               
//                return document.getElementById('pro_TarCredVto').focus();
//            }

//            if (Trim(document.getElementById('pro_TarCredBco').value) === "0") {
//                alert (" Debe informar el Banco de la tarjeta de credito  ");               
//                return document.getElementById('pro_TarCredBco').focus();
//            }
            
//            if (Trim(document.getElementById('pro_TarCredTit').value) === "") {
//                alert (" Debe informar el titular de la tarjeta de credito  ");               
//                return document.getElementById('pro_TarCredTit').focus();
//            }
       } else if (document.getElementById('prop_form_pago').value === "4") {
            if (Trim(document.getElementById('pro_DebCtaCBU').value) === "") {
                alert (" Debe informar el CBU");
                return document.getElementById('pro_DebCtaCBU').focus();
            }
            if ( document.getElementById('pro_DebCtaCBU').value.length !== 22 ) {
                alert (" La CBU debería tener 22 cifras");
                return document.getElementById('pro_DebCtaCBU').focus();
            }
           if ( validarCBU (document.getElementById('pro_DebCtaCBU').value) === false ) {
                alert (" La CBU es inválida, por favor, verifique que sea correcta");
                return document.getElementById('pro_DebCtaCBU').focus();
            }
            if ( document.getElementById('pro_CtaTit').value === "" ) {
                alert (" Debe informar el titular de la cuenta");
                return document.getElementById('pro_CtaTit').focus();
            }
        }
        
//        if ( !  ( document.formProp.prop_mca_envio_poliza[0].checked ||
//                  document.formProp.prop_mca_envio_poliza[1].checked ||
//                  document.formProp.prop_mca_envio_poliza[2].checked ) ) {
//                alert (" Debe seleccionar como desea recibir la póliza ");
//                return document.formProp.prop_mca_envio_poliza[0].focus();
//             }

        return true;
    }

     function HabilitarDiv(divName) {

        for(i=1; i<=2; i++)
            document.getElementById('div_' + i).style.visibility = 'hidden';

        if (parseInt (divName) === 1 ) {
            document.getElementById('div_1').style.visibility = 'visible';
        }

        if (parseInt (divName) === 4 ) {
            document.getElementById('div_2').style.visibility = 'visible';
        }
    }

   function CambiarSelectProd ( accDir ) {
        var       i = 0;
        var bExiste = false;
        
        if ( (accDir.value === "" || accDir.value === "0")) {
            if (document.getElementById ('prop_cod_prod').value !== "0") {
                document.getElementById ('prop_cod_prod').value = "0";
            } 
            return true;
        } else {
            for (i = 0; i < document.getElementById ('prop_cod_prod').length; i++) {
                if (document.getElementById ('prop_cod_prod').options [i].value === accDir.value) {
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

    function SetearFacturacion () {
        if ( document.getElementById('prop_cantVidas').value === "0"  || 
             document.getElementById('prop_cantVidas').value === "") {
            alert (" Debe ingresar la cantidad de asegurados de la nómina ");               
            return document.getElementById('prop_cantVidas').focus();
        }  else {    
// validar la facturación segun la cantidad de asegurados  -- prop_fac pinolux 
             var ok = 0;   
            for (i = 1; i <= aCodFact.length ;i++) {
                if ( parseInt (document.getElementById('prop_fac').value) ===  aCodFact [i] ) { 
                    if ( parseInt (document.getElementById('prop_cantVidas').value) >= aDesdeFact [i]) {
                        ok = 1;
                        break;
                    }
                }
            }
        
            if (ok === 1) {
                return true;
            } else {
                alert (" Periodo de Facturación inválido. Pase por encima del signo de pregunta para ver los valores posibles ");
                return document.getElementById('prop_fac').focus();
            }
        }

   }


</script>
<body onload="Javascript:history.go(1);" onunload="Javascript:history.go(1);">
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
            <FORM method="post" action="<%= Param.getAplicacion()%>servlet/PropuestaServlet" name='formProp' id='formProp'>
            <INPUT type='hidden' name='prop_numSocio'       id='prop_numSocio'      value='<%=numSocio%>' />   
            <INPUT type="hidden" name="opcion"              id="opcion"              value='' />
                    <INPUT type="hidden" name="volver"      id="volver"
                           value="<%= (request.getParameter("volver") == null ? "filtrarPropuestas" : request.getParameter("volver"))%>" />
            <INPUT type="hidden" name="prop_nro_cot"        id="prop_nro_cot"        value="<%=nroCot%>" />  
            <INPUT type="hidden" name="prop_num_prop"       id="prop_num_prop"       value="<%=nroProp%>" />  
            <INPUT type="hidden" name="prop_cod_est"        id="prop_cod_est"        value="<%=codEstado%>" />  
            <INPUT type="hidden" name="prop_desc_prod"      id="prop_desc_prod"      value="<%=descProd%>" />  
            <INPUT type="hidden" name="prop_aseg_actividad" id="prop_aseg_actividad" value="<%=0%>" />
            <INPUT type="hidden" name="prop_benef_tomador"  id="prop_benef_tomador"  value="N"/>
            <INPUT type="hidden" name="prop_cap_invalidez"  id="prop_cap_invalidez"  value="<%=0%>" />
            <INPUT type="hidden" name="prop_cap_asistencia" id="prop_cap_asistencia" value="<%=0%>" />  
            <INPUT type="hidden" name="prop_franquicia"     id="prop_franquicia"     value="<%=0%>" />
            <INPUT type="hidden" name="prop_tipo_propuesta" id="prop_tipo_propuesta" value="<%=(oProp == null ? "P" : oProp.getTipoPropuesta())%>"/>
            <INPUT type="hidden" name="prop_num_doc_orig"   id="prop_num_doc_orig"   value="<%=documento%>"/>
                <TR>
                    <TD>
                        <TABLE border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>               
                            <TR>
                                <TD  colspan='3' height="30px" valign="middle" align="center" class='titulo'><u>FORMULARIO DE PROPUESTA</u></TD>
                            </TR>
                            <TR>
                                <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'> A - Datos Generales</TD>
                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text' nowrap>Propuesta Nº:</TD>
                                <TD align="left" class='text'>
                                    <INPUT type="text" name="prop_nro" id="prop_nro"  size="20" maxleng="20" value="<%=nroPropDesc%>" disabled>
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
                                    out.println(ohtml.armarSelectTAG(lTabla,21));  
%>
                                    </SELECT>                                    
                                </TD>
                            </TR>
<% 
   if ( usu.getiCodTipoUsuario()== 1 && usu.getiCodProd() < 80000) {
%>
                            <TR>
                                <TD width='15'>&nbsp;</TD>
                                <TD align="left" class='text'>Productor:</TD>
                                <TD align="left" class='text'>
                                    <select class='select' name="prop_cod_prod" id="prop_cod_prod">                                        
                                        <option value='<%=String.valueOf(usu.getiCodProd())%>'> <%=usu.getsDesPersona() + " (" + usu.getiCodProd() + ")" %> 
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
                                <INPUT name="prod_dir" id="prod_dir" value='0' size='10' maxlength='10' class='inputTextNumeric' onchange='CambiarSelectProd ( this );' onkeypress="" >

                            </TR>
<%
  }
%>   
                            <tr>
                               <td width='15'>&nbsp;</td>
                               <td class="text" align="left">Cantidad de asegurados:</td>
                                <td class="text" align="left">
                                  <input type="text" name="prop_cantVidas" id="prop_cantVidas"  value="<%= (oProp == null ? 0 : oProp.getCantVidas ())%>" size="5" maxlength="3" onKeyPress="return Mascara('D',event);" class="inputTextNumeric" 
                                         onblur="SetearFacturacion ();" <%= (nroCot > 0 ? "readonly" : " ")%>>
                                </td>
                            </tr>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text' valign="top" >Empleada dom&eacute;stica:</TD>
                                <TD align="left" class='text'>
                                    <input type="CHECKBOX" value='N' name='prop_mca_empleada'  id='prop_mca_empleada' <%= ( oProp == null ? " " : (oProp.getcodPlan() == 2 ? "checked" : " ")) %>>
                                 </TD>
                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>Periodo de Facturación:</TD>
                                <TD align="left" class='text'>
                                    <SELECT name="prop_fac" id="prop_fac" class="select" STYLE="WIDTH:120px" onchange='SetearFacturacion ();' >
<%                                          sDescFacturacion.append ( "Condiciones de Facturación:<br><br>" ); 
                                            StringBuffer sDescAux = new StringBuffer();
                                            for (int ii = 0; ii < lFact.size (); ii++) {
                                                Facturacion oFact = (Facturacion) lFact.get(ii);
                                                if (oFact.getcantDesde () != 1) {
                                                    sDescAux.append ("/ ");
                                                }
                                                sDescAux.append (oFact.getdescFacturacion () );
                                                sDescFacturacion.append ( "- " ); 
                                                sDescFacturacion.append ( oFact.getcantDesde () );
                                                sDescFacturacion.append ( " a "); 
                                                sDescFacturacion.append ( oFact.getcantHasta ()); 
                                                sDescFacturacion.append ( " asegurados: "); 
                                                sDescFacturacion.append ( sDescAux.toString () ); 
                                                sDescFacturacion.append ( "<br>");
    %>
                                                <option value="<%= oFact.getcodFacturacion () %>" ><%= oFact.getdescFacturacion () %></option>
<%                                          }
    %>
                                    </SELECT>  
              <img src="<%= Param.getAplicacion()%>images/pregunta1.gif" onmouseover="writetxt('<%= sDescFacturacion.toString() %>')" onmouseout="writetxt(0)">                             
                                </TD>    
                             </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>Periodo de Vigencia:</TD>
                                <TD align="left" class='text'>
                                    <SELECT name="prop_vig" id="prop_vig" class="select" STYLE="WIDTH:120px" disabled>
<%  
                                          lTabla = oTabla.getDatosOrderByDesc ("VIGENCIA");                                          
                                          out.println(ohtml.armarSelectTAG(lTabla,  String.valueOf(6))); 
%>
                                    </SELECT>                               
                                    &nbsp;&nbsp;&nbsp;
                                    <LABEL>Desde el día&nbsp;</LABEL>
                                    <INPUT type="text" name="prop_vig_desde" id="prop_vig_desde" size="10"  maxlength='10' onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value="<%=fechaVigDesde%>" <%=disabled%> >&nbsp;(dd/mm/yyyy)
                                </TD>    
                             </TR>
                            <TR>                                
                                <td width='15'>&nbsp;</td>
                                <TD class='text' colspan='2' align='left'>
                                    <LABEL><span style='color:red;'><U>Nota:</U></span><b>La Fecha de Inicio de vigencia de la P&oacute;liza debería ser el 1er. día del mes corriente o del siguiente.</b><BR><BR>
                                    </LABEL>
                                </TD>                                
                            </TR>

<%--
                            <TR> 
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>Actividad :</TD>                                
                                <TD align="left" class='text'>
                                    <SELECT name="prop_aseg_actividad" id="prop_aseg_actividad" class="select" style="width:625" >
<%                             lTabla = oTabla.getActividades ();
                                out.println(ohtml.armarSelectTAG(lTabla,codActividad)); 
%>
                              </SELECT>
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
                                 lTabla = oTabla.getDatos ("DOCUMENTO");
                                 out.println(ohtml.armarSelectTAG(lTabla,String.valueOf(tipoDoc)) ); 
%>  
                                    </SELECT>	    
                                    &nbsp;&nbsp;
                                    <INPUT name="prop_tom_nroDoc" id="prop_tom_nroDoc" size='20' maxlength='11' onkeypress="return Mascara('D',event);" class="inputTextNumeric" value="<%=documento%>" <%=disabled%>>
                                    &nbsp;&nbsp;
<%                                  if( disabled.equals("")) { %>
                                    <INPUT type="button" name="cmdVerifTom" value=" Verificar Persona" height="20px" class="boton" onClick="VerificarTomador();">
<%                                  } %>
                                </TD>

                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>Apellido / Razón Social:</TD>
                                <TD align="left" class='text'>
                                    <INPUT type="text" name="prop_tom_apellido" id="prop_tom_apellido"  size="55" maxleng="100" value="<%= apeRazon %>" <%=disabled%> >                                                                      
                                </TD>
                            </TR>
                            <TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>Nombre:</TD>
                                <TD align="left" class='text'>
                                    <INPUT type="text" name="prop_tom_nombre" id="prop_tom_nombre"  size="40" maxleng="50" value="<%= nombre %>" <%=disabled%> >                                    
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
                                <TD align="left" class='text'>C&oacute;digo&nbsp;Postal:</TD>
                                <TD  align="left">
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
                                    <SELECT name="prop_tom_prov" id="prop_tom_prov" class="select" STYLE="width: 200px;">
<%              for (int i=0; i<lProv.size();i++) {
                    Provincia oP = (Provincia) lProv.get(i);
    %>
                     <option value="<%= oP.getCodigo() %>" <%= (codProvincia == oP.getCodigo() ? "selected" : " ") %>><%= oP.getDescripcion() %></option>     
<%              }
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
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text' width='200px'>Muerte:</TD>                              
                                <TD align="left" class='text'>
                                    &nbsp;$&nbsp;
                                    <INPUT type="text" align='right'  name="prop_cap_muerte" id="prop_cap_muerte" value="<%= capMuerte %>"   
                                        onKeyPress="return Mascara('N',event);" class="inputTextNumeric" disabled >                                    
                                </TD>
                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD colspan='2'>&nbsp;</TD>
                            </TR>                                                      
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text' width='200px'>Prima:</TD>                                 
                                <TD align="left" class='text'>
                                    &nbsp;$&nbsp;
                                    <INPUT type="text" name="prop_prima" id="prop_prima"  size="20" maxleng="20" value="<%= Dbl.DbltoStr(prima,2)%>"   
                                        onKeyPress="return Mascara('N',event);" class="inputTextNumeric" disabled>                                    
                                </TD>
                            </TR>                                   
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text' width='200px'>Premio:</TD>                                 
                                <TD align="left" class='text'>
                                    &nbsp;$&nbsp;
                                    <INPUT type="text" name="prop_premio" id="prop_premio"  size="20" maxleng="20" value="<%= Dbl.DbltoStr(premio,2)%>"   
                                        onKeyPress="return Mascara('N',event);" class="inputTextNumeric" disabled>                                    
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
                                    <INPUT type="text" name="prop_cant_cuotas" id="prop_cant_cuotas"  size="10" maxleng="20" value="<%= Dbl.DbltoStr(cantCuotas,0)%>"   onKeyPress="return Mascara('N',event);" class="inputTextNumeric" disabled >                                    
                                </TD>

                            </TR>
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text'>Forma de Pago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;                              

                                    <SELECT name="prop_form_pago" id="prop_form_pago" class="select" onchange="HabilitarDiv(this.value);" >
                                        <option value="0">Seleccione la forma de pago</option>
<%
                                          lTabla = oTabla.getFormasPagos ();
                                          out.println(ohtml.armarSelectTAG(lTabla,formaPago));
    %>
<%--                                      
                                        if ( lfPagos.size() > 0 ) {
                                            for (int ii = 0; ii < lfPagos.size(); ii++) {
                                                FormaPago oF = (FormaPago) lfPagos.get(ii);
     %>
                                            <option value="<%= oF.getCodigo() %>" <%= (oF.getCodigo() == formaPago ? "selected" : " ")%> ><%= oF.getDescripcion()%></option>
<%                                          }
                                        } 
    --%>                                        
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
                                                <div name="div_1" id="div_1" style="visibility: hidden; position: absolute;">
                                                    <TABLE align="center" border="0" cellpadding='0' cellspacing='0' width='100%' heigth="100%">
                                                        <TR>
                                                            <TD class="text" height="20" valign="center" >Datos de Tarjeta de Cr&eacute;dito:</TD>
                                                        </TR>
                                                        <TR>
                                                            <TD valign="top">
                                                                <TABLE  align="left" style="margin-left:5px">
                                                                    <TR>
                                                                        <TD  width='100px' class="text">Tarjeta:</td>
                                                                        <TD  width='150px'>
                                                                                <SELECT name="pro_TarCred"  id="pro_TarCred" style="width: 220px" class="select" <%=disabled%> >
                                                                                   <OPTION value='0'>Seleccione Tarjeta de Credito</OPTION>
                                                                                   <%
                                                                                       lTabla = oTabla. getTarjetas ();
                                                                                       out.println(ohtml.armarSelectTAG(lTabla,codTarjeta));
                                                                                   %>
                                                                            </SELECT>
                                                                        </TD>
                                                                        <TD class="text" >N&uacute;mero:&nbsp;</TD>
                                                                        <TD><input id="pro_TarCredNro" name="pro_TarCredNro"  value="<%=nroTarjCred%>" <%=disabled%>  maxlength="16" size="20"  ></TD>
                                                                    </TR>
                                                                        <INPUT type="HIDDEN" name="pro_TarCredVto"  id="pro_TarCredVto" value="<%=fechaVtoTarjCred%>"  value="1900-01-01"/>
                                                                        <INPUT type="HIDDEN"  name="pro_TarCredCodSeguridad" id="pro_TarCredCodSeguridad" value="0" />
                                                                        <INPUT type="HIDDEN" name="pro_TarCredTit" id="pro_TarCredTit" value="<%=titularTarj%>" value="" />
                                                                </table>
                                                            </TD>
                                                        </TR>
                                                    </TABLE>
                                                </div>							
                                                <DIV id="div_2" name="div_2" style="VISIBILITY: hidden; POSITION: absolute;">
                                                    <TABLE align="center" border="0" cellpadding='0' cellspacing='0' width='100%' heigth="100%">
                                                        <TR>
                                                            <TD class="text" height="20" valign="center">Datos de la Cuenta:</TD>
                                                        </TR>
                                                        <TR>
                                                            <td valign="top">
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
                                                                        <TD  class="text" >CBU:</td>
                                                                        <TD  align="left"><input name="pro_DebCtaCBU" id="pro_DebCtaCBU" value="<%=CBU%>"  size='22' maxlength='22'
                                                                                                 onkeypress="return Mascara('D',event);" class="inputTextNumeric">
                                                                        </TD>
                                                                    </TR>
                                                                    <tr>
                                                                        <TD class="text" >Titular:</td>
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
                                        </TR>
                                    </TABLE>
                                </td>
                            </tr>                          
                        </TABLE>
                    </TD>
                </TR>    
                <TR>
                    <TD>
                        <TABLE border='0' align='left' class="fondoForm" width='100%' style='margin-top:10;margin-bottom:10;'>   
                            <TR>
                                <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'>F - Información Adicional</TD>
                            </TR>
<%--
                            <TR>
                                <td width='15'>&nbsp;</td>
                                <TD align="left" class='text' valign="top" width='130' nowrap>Seleccione forma de envío:</TD>                                
                                <TD align="left" class='text' width='400' >
                                    <input type="radio" value='S' name='prop_mca_envio_poliza' <%= (mcaEnvio.equals ("S") ? "checked" : " ") %>>&nbsp;Deseo recibir la p&oacute;liza <b>impresa por CORREO</b><br>
                                    <input type="radio" value='N' name='prop_mca_envio_poliza' <%= (mcaEnvio.equals ("N") ? "checked" : " ") %>>&nbsp;NO deseo recibir la p&oacute;liza<br>
                                    <input type="radio" value='M' name='prop_mca_envio_poliza' <%= (mcaEnvio.equals ("M") ? "checked" : " ") %>>&nbsp;Deseo recibir la p&oacute;liza <b>v&iacute;a MAIL</b><br>
                                 </TD>                                
                            </TR>
                            <tr><td colspan='3'><hr></td></tr>
--%>
                            <input type="hidden" name="prop_mca_envio_poliza" id="prop_mca_envio_poliza" value="M">
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text' width="150px"  >Beneficiarios:</td>
                                <td align="left" class='text' >
                                    <input type="CHECKBOX" value='<%= benefHerederos %>' name='prop_benef_herederos'  id='prop_benef_herederos' <%= (benefHerederos.equals ("S") ? "checked" : " ") %>/>&nbsp;Herederos legales<br/>
                                 </td>
                            </tr>
                            <tr>
                                <td width='15'>&nbsp;</td>
                                <td align="left" class='text' valign="top" >Num. de referencia:</td>
                                <td align="left" class='text' >
                                        <input name="prop_num_referencia" id="prop_num_referencia" value="<%= (oProp == null ? 0 : oProp.getnumReferencia()) %>"  size='22' maxlength='8'
                                               onkeypress="return Mascara('D',event);" class="inputTextNumeric"/>
                                        &nbsp;&nbsp;&nbsp;Este campo no es obligatorio, se refiere al n&uacute;mero de solicitud de su sistema de gesti&oacute;n de cartera.
                                </td>
                            </tr>

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
                            <INPUT type="hidden" name="prop_obs" id="prop_obs"  value='<%= observacion %>' >
                        </TABLE>
                    </TD>
                </tr>
                </FORM>       
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
                </tr>

            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD width='100%'>
            <jsp:include flush="true" page="/bottom.jsp"/>
        </TD>
    </TR>
</table>
<div id="navtxt" 
     class="navtext"
     style="visibility:hidden; position:absolute; padding:10px">
</div>
<script>
<%                                          
    for (int ii = 1; ii <= lFact.size (); ii++) {
        Facturacion oFact = (Facturacion) lFact.get(ii - 1);
%>
            aDesdeFact [<%= ii %>] = <%= oFact.getcantDesde () %>; 
            aHastaFact [<%= ii %>] = <%= oFact.getcantHasta () %>; 
            aCodFact   [<%= ii %>] = <%= oFact.getcodFacturacion () %>; 
<%      
    }
%>

CloseEspere();
HabilitarDiv (<%=formaPago %>);
</script>
</body>
</html>
