<%@page import="java.awt.image.BufferStrategy"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Cotizacion"%>
<%@page import="com.business.beans.CotizadorSumas"%>
<%@page import="com.business.beans.CotizadorNomina"%>
<%@page import="com.business.beans.Producto"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.beans.FormaPago"%>
<%@page import="com.business.beans.Facturacion"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.sql.Connection"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>
<%
    Usuario usu = (Usuario) session.getAttribute("user");
    Cotizacion oCot = (Cotizacion) request.getAttribute("cotizacion");
    Producto   oProd = (Producto) request.getAttribute("producto");

    LinkedList lfPagos = new LinkedList ();
    LinkedList lFact   = new LinkedList ();
    Connection dbCon = null;
    StringBuilder sb = new StringBuilder();

// cambiado para el nuevo cotizador por la prima comisionable
//    int impPrima  = (int) oCot.getprimaPura();
    int impPrima  = (int) oCot.getimpPrimaComisionable() ;
    int impPremio = (int) oCot.getpremio();
    int porcComision = (int) oCot.getgastosAdquisicion();

    try {

        dbCon = db.getConnection();
        lfPagos  = ConsultaMaestros.getAllFormaPago (dbCon, oCot.getcodRama(), oCot.getcodSubRama(),
                oCot.getcodProducto (), 0, oCot.getcodProd() );
        lFact    = ConsultaMaestros.getAllCondFacturacion (dbCon, oCot.getcodRama(), oCot.getcodSubRama(), oCot.getcodProducto(),
                    oCot.getcodVigencia(), -1, oCot.getcodProd(), oCot.getcantPersonas() );


        boolean bFirst = true;
        for (int i=0; i < lfPagos.size(); i++) {
            FormaPago  of = (FormaPago) lfPagos.get(i);
            if ( bFirst ) {
                sb.append (of.getDescripcion() );
                bFirst = false;
            } else {
                sb.append ("&nbsp;-&nbsp;").append(of.getDescripcion() );
            }
        }
    } catch (Exception e) {
        throw new SurException(e.getMessage());
    } finally {
         db.cerrar(dbCon);
    }


    %>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<!-- estilos css -->
    <title>BENEFICIO S.A. - Cotizador de Vida Colectivo</title>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos-cot.css" media="screen"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css" media="screen"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/print_cotizador.css" media="print"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>datatables/DataTables1.10.6/media/css/jquery.dataTables.css"/>

    <script src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
    <script type="text/javascript">window.jQuery || document.write('<script src="<%= Param.getAplicacion()%>portal/js/vendor/jquery-1.8.0.min.js"><\/script>')</script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/chosen.jquery.js"></script>
    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/prism.js" charset="utf-8"></script>

    <script type="text/javascript" language="javascript" src="<%= Param.getAplicacion()%>datatables/DataTables1.10.6/media/js/jquery.dataTables.min.js"></script>

    <script type="text/javascript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>



<script type="text/javascript">


    $(document).ready(function()
    {
        $('#example').DataTable({
            "language": {
                "sProcessing":    "Procesando...",
                "sLengthMenu":    "Mostrar _MENU_ registros",
                "sZeroRecords":   "No se encontraron resultados",
                "sEmptyTable":    "Ningún dato disponible en esta tabla",
                "sInfo":          "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
                "sInfoEmpty":     "Mostrando registros del 0 al 0 de un total de 0 registros",
                "sInfoFiltered":  "(filtrado de un total de _MAX_ registros)",
                "sInfoPostFix":   "",
                "sSearch":        "Buscar:",
                "sUrl":           "",
                "sInfoThousands":  ",",
                "sLoadingRecords": "Cargando...",
                "oPaginate": {
                    "sFirst":    "Primero",
                    "sLast":    "Último",
                    "sNext":    "Siguiente",
                    "sPrevious": "Anterior"
                },
                "oAria": {
                    "sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
                    "sSortDescending": ": Activar para ordenar la columna de manera descendente"
                }
            }

        });


    });


</script>
<script type="text/javascript">

<!--
function validateEmail( emailID ){
   atpos = emailID.indexOf("@");
   dotpos = emailID.lastIndexOf(".");
   if (atpos < 1 || ( dotpos - atpos < 2 ))
   {
       return false;
   }
   return( true );
}
//-->

    $(document).ready(function(){

            $("#salir").click(function(){
                Volver  ();
            });

            $("#volver").click(function(){
                Ir ('solapa1');
            });

            $("#emitir").click(function(){
                Ir ('emitir');
            });

            $("#reset").click(function(){
                Recotizar ( 0 );
            });
            $("#recotizar").click(function(){
                Recotizar ( 1 );
            });
            $(".opt-link a-pdf").click(function(){
                overlay2();
            });
            $(".opt-link a-mail").click(function(){
                overlay();
            });

    });

window.onload = function () {

    $('#recotizar').focus();

    if (typeof history.pushState === "function") {
        history.pushState("jibberish", null, null);
        window.onpopstate = function () {
            history.pushState('newjibberish', null, null);
            // Handle the back (or forward) buttons here
            // Will NOT handle refresh, use onbeforeunload for this.
        };
    }
    else {
        var ignoreHashChange = true;
        window.onhashchange = function () {
            if (!ignoreHashChange) {
                ignoreHashChange = true;
                window.location.hash = Math.random();
                // Detect and redirect change here
                // Works in older FF and IE9
                // * it does mess with your hash symbol (anchor?) pound sign
                // delimiter on the end of the URL
            }
            else {
                ignoreHashChange = false;
            }
        };
    }
}

function overlay() {
	el = document.getElementById("overlay");
	el.style.visibility = (el.style.visibility == "visible") ? "hidden" : "visible";
        document.getElementById("dest").value = document.getElementById("email").value;
        if (el.style.visibility == "visible") {
            el = document.getElementById("message").focus();
        }
}

function overlay2() {
	el = document.getElementById("overlay2");
	el.style.visibility = (el.style.visibility == "visible") ? "hidden" : "visible";
        if (el.style.visibility == "visible") {
            $("form[name=form3]").find("input[name='incluir_comision']").focus();
        }
}
    function PrintPDF () {

        if ( $("#check_comisionP").prop("checked")  ) {
            $("#incluir_comisionP").val ("S");
        } else {
            $("#incluir_comisionP").val ("N");
        }
        $("#opcionP").val ("getCotPDF");

        overlay2();
        document.form3.submit();
        return true;
    }

    function EnviarMail () {

        var des = Trim($("#dest").val());
        if ( des.length == 0) {
            alert ("ingrese destinatario !!");
            $("#dest").focus();
            return false;
        } else if ( validateEmail( des ) == false ) {
            alert ("Mail del destinatario inválido !! ");
            $("#dest").focus();
            return false;
        }
        $("#dest").val(des);

        var cc = Trim($("#cc").val());
        if ( cc.length > 0) {
             if ( validateEmail( cc ) == false ) {
                alert ("Mail de la copia  inválido !! ");
                $("#cc").focus();
                return false;
             }
             $("#cc").val(cc);
        }

        if ( $("#check_comisionM").prop("checked")  ) {
            $("#incluir_comisionM").val ("S");
        } else {
            $("#incluir_comisionM").val ("N");
        }

        document.getElementById ("opcionM").value = 'getCotEmail';
         $( "#form-email" ).submit();
         return true;
    } 

    function Ir (sigte) {
        var comision   =  parseFloat ($('#COMISION').val());

        if (document.getElementById ("estado").value == "0") {
            if ( sigte == 'solapa1' ||sigte == 'solapa2' ) {
                //document.getElementById ("opcion").value = 'getCotNew';
                document.getElementById("siguiente").value = sigte;
                document.form1.submit();
            } else if ( sigte == 'emitir') {
                 if ( comision == 0 ) {
                     alert ("ATENCION !!! - ESTA EMITIENDO CON COMISION CERO. SI NO ES CORRECTO, NO EMITA LA PROPUESTA Y MODIFIQUE LAS COMISIONES ")
                 }
                 if ( window.confirm("Esta seguro que desea solicitar la propuesta de la cotización ?") ) {
                     var sUrl= "<%= Param.getAplicacion() %>servlet/PropuestaServlet?opcion=addPropuestaAP&numCotizacion=<%=oCot.getnumCotizacion() %>";
                     window.location.replace( sUrl );
                     return true;
                 } else {
                    return false;
                 }
            }
        } else {
            alert ("La cotizacion no puede ser modificada porque ya fue convertida a propuesta.\n Ingrese una nueva cotizacion.")
            return false;
        }
    }

    function Volver () {
        document.form1.opcion.value = "getAllCotizaciones";
        document.form1.submit();
        return true;
    }

    function Recotizar ( valor ) {

        var matricula  =  $('#matricula').val ();

        if ( matricula == "199" || matricula == "200" || matricula == "201" ) {
                $('#mensaje_error').text("ERROR: OPERACIONES DIRECTA NO PUEDE MANIPULAR PREMIO NI COMISION !! ") ;
                return false;
        }
        var prima      =  parseFloat ($('#IMP_PRIMA').val());
        var primaOrig  =  parseFloat ($('#IMP_PRIMA_ORIG').val());
        var premio     =  parseFloat ($('#IMP_PREMIO').val());
        var premioOrig =  parseFloat ($('#IMP_PREMIO_ORIG').val());
        var comision   =  parseFloat ($('#COMISION').val());
        var comisionOrig  =  parseFloat ($('#COMISION_ORIG').val());

        $('#mensaje_error').text("") ;

        if ( parseInt (valor) == 0 ) {
            premio     =  0;
            comision   =  0;
        } else {
            if ( premio == premioOrig && comision  == comisionOrig) {
                $('#mensaje_error').text("- ERROR: Para recotizar modifique Premio o Comisión. ") ;
                $('#IMP_PREMIO').focus();
                return false;
            }

            if ( premio != premioOrig &&
                 comision  != comisionOrig) {
                $('#mensaje_error').text("- ERROR: solo puede ajustar Premio O Comisión, no ambos ") ;
                $('#IMP_PREMIO').val($('#IMP_PREMIO_ORIG').val());
                $('#COMISION').val($('#COMISION_ORIG').val());
                $('#IMP_PREMIO').focus();
                return false;
            }
        }


        var cotiz = $('#num_cotizacion').val();
        // Hacemos un request AJAX para pedir los datos de paises.
        // Esperamos recibir la respuesta en formato JSON.
        var url = "<%= Param.getAplicacion()%>rest/cotizaService/recotizarVC/?num_cotizacion=" + cotiz +
                  "&premio=" + premio + "&premio_orig=" + premioOrig +
                  "&prima=" + prima + "&prima_orig=" + primaOrig +
                  "&comision=" + comision + "&comision_orig=" + comisionOrig;

        $.getJSON(url, function(data){
                $(data).each(function(index, oCot ) {
                    if (oCot.iNumError >= 0 ) {
                        $('input[name=IMP_PREMIO_ORIG]').attr('value',oCot.premio );
                        $('input[name=COMISION_ORIG]').attr('value', oCot.gastosAdquisicion );
                        $('input[name=IMP_PREMIO]').attr('value',oCot.premio );
                        $('input[name=COMISION]').attr('value', oCot.gastosAdquisicion );
                        $('input[name=IMP_PRIMA]').attr('value', oCot.impPrimaComisionable );
                        if ( $("#prima_comisionable") ) {
                            $("#prima_comisionable").text( oCot.impPrimaComisionable );
                        }
                        if ( $("#recargo_admin") ) {
                            $("#recargo_admin").text( oCot.recAdmin );
                        }
                        if ( $("#gda") )  {
                            $("#gda").text( oCot.gda );
                        }
                        if ($("#prima_tarifa") ) {
                            $("#prima_tarifa").text( oCot.primaTar );
                        }
                        if ( $("#iva")) {
                            $("#iva").text( oCot.iva );
                            $("#ssn").text( oCot.ssn );
                            $("#soc").text( oCot.soc );
                            $("#sellados").text( oCot.sellado );
                            $("#premio").text( oCot.premio  );
                        }
                        if ( oCot.iNumError > 0 ) {
                            $('#mensaje_error').text("- ALERTA: " + oCot.sMensError ) ;
                        }
                    }
                });
        });

    }
</script>

</head>

<!--[if lt IE 9]>
	<script src="http://css3-mediaqueries-js.googlecode.com/svn/trunk/css3-mediaqueries.js"></script>
<![endif]-->

<!--[if IE 7]>         <body class="ie ie7 oldie"> <![endif]-->
<!--[if IE 8]>         <body class="ie ie8"> <![endif]-->
<!--[if IE 9]>         <body class="ie ie9"> <![endif]-->
<!--[if gt IE 9]><!--> <body>         <!--<![endif]-->

<!--[if lt IE 7]><div class="browser_old" id="aviso">Â¡Tu navegador es muy viejo! <a href="http://browsehappy.com/?locale=es" target="_blank">Actualizalo a uno mÃ¡s moderno</a> para tener una mejor experiencia y velocidad en la aplicacion.
<a href="#" class="close_message" title="cerrar aviso" onclick="document.getElementById('aviso').style.display='none';return false"></a>
</div><![endif]-->

<div class="wrapper">

    <!-- container -->
    <div class="container">

        <jsp:include page="/header.jsp">
            <jsp:param name="aplicacion" value="<%= Param.getAplicacion() %>" />
            <jsp:param name="usuario" value="<%= usu.getusuario() %>" />
            <jsp:param name="descripcion" value="<%= usu.getRazonSoc() %>" />
        </jsp:include>
        <div class="menu">
            <menu:renderMenuFromDB    aplicacion="1"  userLogon="<%= usu.getusuario()%>" />
        </div>

         <img class="bnf_logo_print" src="<%= Param.getAplicacion()%>images/logos/logo_beneficio_new.jpg" width="200" height="54" alt="bnflogo" />
<h1 class="title-section hcotizadores">cotizador de vida colectivo</h1>

         <!-- tabs -->

         <div class="tabs-container">

            <ul class="tabs">
                <li><span class="step">1</span><a href="#"  onclick="Ir ('solapa1');" title="datos generales">Datos Generales</a></li>
                <li><span class="step">2</span><a href="#"  onclick="Ir ('solapa2');" title="datos de asegurados">Datos de Asegurados</a></li>
                <li class="active"><span class="step">3</span><a href="#tab3" title="cotizacion" class="last">Cotizaci&oacute;n</a></li>
            </ul>
            <!-- -->
            <div id="tab2" class="tab-content form">
            	 <span class="anchor" id="top"></span>
            <div class="form-wrap">
            <form name="form1" id="form1" method="post"  action="<%= Param.getAplicacion()%>servlet/CotizadorVCServlet">
            <input type="hidden" name="opcion"      id="opcion"    value="cotizador"/>
            <input type="hidden" name="siguiente"   id="siguiente" value="solapa1"/>
            <input type="hidden" name="tipo_cotizacion" id="tipo_cotizacion"    value="VC"/>
            <input type="hidden" name="COD_RAMA"    id="COD_RAMA"  value="<%= oCot.getcodRama () %>"/>
            <input type="hidden" name="COD_SUB_RAMA"id="COD_SUB_RAMA"  value="<%= oCot.getcodSubRama() %>"/>
            <input type="hidden" name="COD_PRODUCTO"id="COD_PRODUCTO"  value="<%= oCot.getcodProducto() %>"/>

            <input type="hidden"   name="COD_PROVINCIA" id="COD_PROVINCIA" value="<%= oCot.getcodProvincia() %>"/>
            <input type="hidden"   name="COD_VIGENCIA"  id="COD_VIGENCIA"  value="<%= oCot.getcodVigencia() %>"/>
            <input type="hidden"   name="TOMADOR_APE"   id="TOMADOR_APE"   value="<%= oCot.gettomadorApe() %>"/>
            <input type="hidden"   name="COD_PROD"   id="COD_PROD"   value="<%= oCot.getcodProd() %>"/>
            <input type="hidden" name="COD_SUB_RAMA_DESC" id="COD_SUB_RAMA_DESC"  value="<%= oCot.getdescSubRama () %>"/>

            <input type="hidden" name="MCA_NOMINA_EXCEL" id="MCA_NOMINA_EXCEL"  value="<%= (oCot.getmcaNominaExcel()==null)?"":oCot.getmcaNominaExcel() %>"/>

            <input type="hidden" name="usuario"     id="usuario"   value="<%= usu.getusuario() %>"/>
            <input type="hidden" name="num_cotizacion" id="num_cotizacion"   value="<%= oCot.getnumCotizacion() %>"/>
            <input type="hidden" name="IMP_PRIMA_ORIG" id="IMP_PRIMA_ORIG" value="<%= impPrima %>"/>
            <input type="hidden" name="IMP_PREMIO_ORIG" id="IMP_PREMIO_ORIG" value="<%= impPremio  %>"/>
            <input type="hidden" name="COMISION_ORIG" id="COMISION_ORIG" value="<%= porcComision %>"/>
            <input type="hidden" name="email" id="email" value="<%= usu.getEmail() %>"/>
            <input type="hidden" name="estado" id="estado" value="<%= oCot.getestadoCotizacion() %>"/>
            <input type="hidden" name="matricula" id="matricula" value="<%= (usu.getiCodTipoUsuario() == 1 && usu.getiCodProd() < 80000 ?  usu.getmatricula() : 0)  %>"/>

            <div class="form-file">
                 <div class="wrap-elements w15">
                     <span class="item">Cotizaci&oacute;n N&deg;:</span>
                     <span class="item">Fecha:</span>
                 </div>
                 <div class="wrap-elements w25">
                 	<span class="item-result"><%= oCot.getnumCotizacion() %></span>
                        <span class="item-result"><%= Fecha.showFechaForm(oCot.getfechaCotizacion()) %></span>
                 </div>
                 <div class="wrap-elements w15">
                     <span class="item">Cotizado por:</span>
                    <span class="item">Cliente:</span>
                 </div>
                 <div class="wrap-elements w45">
                 	<span class="item-result"><%= oCot.getdescProd() + " (" + oCot.getcodProd() + ")" %></span>
                    <span class="item-result"><%= (oCot.gettomadorApe() == null ? " " : oCot.gettomadorApe()) %></span>
                 </div>
            </div>
            <div class="form-file">
                 <div class="wrap-elements w15">
                    <span class="item">Producto :</span>
                 </div>
                 <div class="wrap-elements w85">
                     <span class="item-result"><%= oCot.getdescSubRama() %>&nbsp;-&nbsp;<%= oCot.getdescProducto() %></span>
                 </div>
            </div>
            <div class="form-file">
                 <div class="wrap-elements w15">
                    <span class="item">Asegurados:</span>
                    <span class="item">Vigencia:</span>
                 </div>
                 <div class="wrap-elements w25">
                 	<span class="item-result"><%= oCot.getcantPersonas() %></span>
                    <span class="item-result"><%= oCot.getdescVigencia() %></span>
                 </div>
                <div class="form-file">
                     <div class="wrap-elements w15">
                        <span class="item">Provincia :</span>
                     </div>
                     <div class="wrap-elements w85">
                         <span class="item-result"><%= oCot.getdescProvincia() %></span>
                     </div>
                </div>
            </div>
            <!-- Table markup-->
<!-- aca van las tablas de rangos de sumas para Capitales uniformes o nominas C1, C2, C3 para capitales NO uniformes -->

            <table width="100%" cellpadding="10" cellspacing="0" id="table-results" class="table1" summary="Coberturas y capitales cotizados">

<%
if (oProd.getNivelCob().equals("P") )
{
    //Capitales uniformes
    //System.out.println("Uniformes");
%>
                <thead>
                    <tr>
                        <th scope="col" class="a" width="23%">Edad<br/>&nbsp;</th>
                        <th scope="col" class="b" width="23%">Cantidad de <br/>Asegurados</th>
                        <th scope="col" class="b" width="23%">Sumas Aseguradas<br/>Muerte por asegurado</th>
                        <th scope="col" class="b" width="23%">Sumas Aseguradas<br/>Invalid&eacute;z por asegurado</th>
                    </tr>
                </thead>
<%
    LinkedList lsumas = oCot.getlRangosSumas();
    if ( lsumas!=null && lsumas.size()>0)
    {
%>
                <tbody>
<%
        int totalVidas = 0;
        double totalMuerte = 0;
        double totalInvalidez = 0;
        for (int i=0; i<lsumas.size();i++ )
        {
            CotizadorSumas oCS = (CotizadorSumas) lsumas.get(i);
            if ( oCS.getcantVidas() > 0 ) {
                totalVidas += oCS.getcantVidas();
                totalMuerte += oCS.getsumaAsegMuerte();
                totalInvalidez += oCS.getsumaAsegInvalidez();
%>
                    <tr>
                        <td class="a" width="23%"><%=oCS.getedadDesde()%>&nbsp;a&nbsp; <%=oCS.getedadHasta()%></td>
                        <td class="b" width="23%"><%=oCS.getcantVidas()%></td>
                        <td class="b" width="23%"><%= (oCS.getsumaAsegMuerte() > 0 ? oCS.getsumaAsegMuerte() :
                                                      (oCS.getmaxSumaAsegMuerte() == oCS.getminSumaAsegMuerte() ? oCS.getminSumaAsegMuerte()  : 0 ) ) %></td>
                        <td class="b" width="23%"><%= (oCS.getsumaAsegInvalidez() > 0 ? oCS.getsumaAsegInvalidez():
                                (oCS.getmaxSumaAsegInvalidez() == oCS.getminSumaAsegInvalidez() ? oCS.getminSumaAsegInvalidez() : 0 ) ) %></td>
                    </tr>
<%
            }
        }
%>
                    <tr>
                        <td scope="col" class="a" width="23%"><b>Totales</b></td>
                        <td scope="col" class="b" width="23%"><b><%=totalVidas%></b></td>
                        <td scope="col" class="b" width="23%"><b><%=totalMuerte%></b></td>
                        <td scope="col" class="b" width="23%"><b><%=totalInvalidez%></b></td>
                    </tr>
                </tbody>
<%
    }
    else
    {
 %>
                <tbody>
                    <tr>
                        <td class="a" width="96%">
                            <h3>Sin Datos. </h3>
                        </td>
                    </tr>
                </tbody>
 <%
    }
}
else
{
    //Capitales NO uniformes
    //System.out.println("no uniformes");
//--------
//Cabecera
//--------
    // Capitales no uniformes y sin excel....
    if (oCot.getmcaNominaExcel()== null || oCot.getmcaNominaExcel().equals("") || !oCot.getmcaNominaExcel().equals("X"))
    {

    //
    if ( oProd.gettipoNomina().equals("C1") )
    {
 %>
               <thead>
                    <tr>
                        <th scope="col" class="a" width="23%">Edad</th>
                        <th scope="col" class="b" width="23%">Antiguedad</th>
                        <th scope="col" class="b" width="23%">Sueldo bruto mensual</th>
                        <th scope="col" class="b" width="23%">&nbsp;</th>
                    </tr>
                </thead>
 <%
    }
    else if ( oProd.gettipoNomina().equals("C2") )
    {
 %>
                <thead>
                    <tr>
                        <th scope="col" class="a" width="23%">Edad</th>
                        <th scope="col" class="b" width="23%">Cant. de Sueldos</th>
                        <th scope="col" class="b" width="23%">Sueldo bruto mensual</th>
                        <th scope="col" class="b" width="23%">&nbsp;</th>
                    </tr>
                </thead>
 <%
    }
    else
    {
 %>
                <thead>
                    <tr>
                        <th scope="col" class="a" width="23%">Edad</th>
                        <th scope="col" class="b" width="23%">Suma Asegurada</th>
                        <th scope="col" class="b" width="23%">&nbsp;</th>
                        <th scope="col" class="b" width="23%">&nbsp;</th>
                    </tr>
                </thead>
 <%
    }
    boolean hayInfo = (oCot.getlNomina()!= null && oCot.getlNomina().size()>0);
    //Sin Datos
    if (!hayInfo)
    {
%>
                <tbody>
                    <tr>
                        <td class="a" width="96%">
                            <h3>Sin Datos. </h3>
                        </td>
                    </tr>
                </tbody>
<%
    }
    else
    {
    // Datos
%>
                <tbody>
<%
        for (int i=0; i < oCot.getlNomina().size(); i++) {
            CotizadorNomina oNom = (CotizadorNomina) oCot.getlNomina().get(i);
%>

                    <tr>
                        <td scope="col" class="a" width="23%"><%=oNom.getedad()%></td>
<%
            if ( oProd.gettipoNomina().equals("C1") )
            {
%>
                        <td scope="col" class="b" width="23%"><%=oNom.getantiguedad()%></td>
                        <td scope="col" class="b" width="23%"><%= Dbl.DbltoStr(oNom.getsueldo() ,2) %></td>
                        <td scope="col" class="b" width="23%">&nbsp;</td>

<%
            }
            else if ( oProd.gettipoNomina().equals("C2") )
            {
%>
                        <td scope="col" class="b" width="23%"><%= oNom.getcantSueldos() %></td>
                        <td scope="col" class="b" width="23%"><%= Dbl.DbltoStr(oNom.getsueldo() ,2) %></td>
                        <td scope="col" class="b" width="23%">&nbsp;</td>
<%
           }
           else
           {
%>
                        <td scope="col" class="b" width="23%"><%= Dbl.DbltoStr(oNom.getsumaAsegMuerte(),2) %></td>
                        <td scope="col" class="b" width="23%">&nbsp;</td>
                        <td scope="col" class="b" width="23%">&nbsp;</td>
<%
           }
%>
                    </tr>


<%


        }
    } // Capitales no uniformes , sin excel , datos

    } else { // Capitales no uniformes y con excel....
%>
    <table id="example" class="display" >
        <thead>
            <tr>
                <!--
                <th>Nombre</th>
                <th>Apellido</th>
                <th>Fecha</th> -->
                <!--th>Error</th-->

<% if ( oProd.gettipoNomina().equals("C1") ) { %>
                <th>Edad</th>
                <th>Antiguedad</th>
                <th>Sueldo bruto mensual</th>

<% } else if ( oProd.gettipoNomina().equals("C2") ) { %>
                <th>Edad</th>
                <th>Cant. de Sueldos</th>
                <th>Sueldo bruto mensual</th>

<% } else if ( oProd.gettipoNomina().equals("C3") ) { %>
                <th>Edad</th>
                <th>Suma Asegrada</th>
<% } %>
            </tr>
         </thead>

       
         <tbody>

<%        for (int i=0; i < oCot.getlNomina().size(); i++) {
                CotizadorNomina oNom = (CotizadorNomina) oCot.getlNomina().get(i);

                System.out.println(oNom.getedad());
%>
<%             if ( oProd.gettipoNomina().equals("C1") ) { %>
            <tr>
                <td><%=oNom.getedad()%></td>
                <td><%=oNom.getantiguedad()%></td>
                <td><%=oNom.getsueldo()%></td>
            </tr>
<%             } else if ( oProd.gettipoNomina().equals("C2") ) { %>

            <tr>
                <td> <%=oNom.getedad()%></td>
                <td> <%= oNom.getcantSueldos() %></td>
                <td> <%= Dbl.DbltoStr(oNom.getsueldo() ,2) %> </td>
            </tr>
<%             } else if ( oProd.gettipoNomina().equals("C3") ) { %>
            <tr>
                <%--
                <td><%=oNom.getnombre()%></td>
                <td><%=oNom.getapellido()%></td>
                <td><%=Fecha.showFechaForm(oNom.getfechaNac())%> --%>
                <td><%=oNom.getedad()%></td>
                <td><%=oNom.getsumaAsegMuerte()%></td>
                <%--
                <td><%=oNom.getsMensErrorXls()%></td> --%>
           </tr>

<%             } %>
<%
          }
%>
        </tbody>
    </table>

<%
    } // End Capitales no uniformes y con excel

} //Capitales uniformes
%>
                </tbody>
            </table>



 <!--! Table markup-->

             <div class="form-file">
                 <div class="wrap-elements w15">
                     <span class="item-ma">Muerte Accidental para todos los asegurados</span>
                 </div>
                 <div class="wrap-elements w35">
                     <span class="item-result"><%= (oCot.getmcaMuerteAccidental() != null && oCot.getmcaMuerteAccidental().equals("S") ? "SI" : "NO")  %></span>
                 </div>
                 <div class="wrap-elements w50">
                     <span class="item-result">&nbsp;</span>
                 </div>
            </div>

            <!-- prima, premio, tasas, recotizacion -->

             <div class="form-file cot1">
                    <div class="wrap-elements w30">
                         <label for="" class="lone">Prima $:</label>
                         <input type="text" name="IMP_PRIMA" id="IMP_PRIMA" value="<%= impPrima %>"  disabled align="right"/>
                    </div>

                   <div class="wrap-elements w35">
                     <label class="ltwo">(*) Premio $:</label>
                	 <input type="text" name="IMP_PREMIO" id="IMP_PREMIO" value="<%= impPremio  %>"
                                onkeypress="return Mascara('D',event);" maxlength="9"  align="right"
                                <%= (oCot.getestadoCotizacion() == 0 ? " " : "readonly") %>/>
                   </div>

                   <div class="wrap-elements w35">
                       <label class="lone">(*) Comisi&oacute;n %:</label>
                       <input type="text" name="COMISION" id="COMISION" value="<%=  porcComision %>" onkeypress="return Mascara('D',event);" maxlength="5"  align="right"
                                <%= (oCot.getestadoCotizacion() == 0 ? " " : "readonly") %>/>
                   </div>
            </div>
<%          if (usu.getusuario().equals ("PINO") ||
                usu.getusuario().equals ("ADRIANA") ||
                usu.getusuario().equals ("VEFICOVICH") ||
                usu.getusuario().equals ("HERNAN") ||
                usu.getusuario().equals ("GLUCERO") ) {
    %>
             <div class="form-file cot1">
                 <table align="center" border="1" cellpadding="4" cellspacing="4" >
                     <tr>
                         <td align="left" nowrap width="200px">Tasa Muerte</td>
                         <td align="left" nowrap width="100px" ><%= Dbl.DbltoStr( oCot.gettasaMuerte(),2) %></td>
                         <td align="left" nowrap width="200px" >Prima Muerte</td>
                         <td align="right" nowrap width="100px" ><%= Dbl.DbltoStr( oCot.getimpPrimaMuerte(),2) %></td>
                     </tr>
                     <tr>
                         <td align="left" nowrap >Tasa Invalidez</td>
                         <td align="left" nowrap ><%= Dbl.DbltoStr( oCot.getTasaInvalidez(),2) %></td>
                         <td align="left" nowrap >Prima Invalidez</td>
                         <td align="right" nowrap ><%= Dbl.DbltoStr( oCot.getimpPrimaInvalidez(),2) %></td>
                     </tr>
                     <tr>
                         <td align="left" nowrap ></td>
                         <td align="left" nowrap ></td>
                         <td align="left" nowrap >Prima Asistencia</td>
                         <td align="right" nowrap ><%= Dbl.DbltoStr( oCot.getimpPrimaAsistencia(),2) %></td>
                     </tr>
                     <tr>
                         <td align="left" nowrap >% Margen Seguridad</td>
                         <td align="left" nowrap ><%= Dbl.DbltoStr( oCot.getporcMargenSeg(),2) %></td>
                         <td align="left" nowrap >Margen Seguridad</td>
                         <td align="right" nowrap ><%= Dbl.DbltoStr( oCot.getimpMargenSeg(),2)%></td>
                     </tr>
                     <tr>
                         <td align="left" nowrap >% Ajuste de tarifa por <%= oCot.getnivelAjusteTarifa()  %></td>
                         <td align="left" nowrap ><%= oCot.getporcAjusteTarifa() %></td>
                         <td align="left" nowrap >$ Imp. Ajuste tarifa</td>
                         <td align="right" nowrap ><%= Dbl.DbltoStr( oCot.getimpAjusteTarifa(),2) %></td>
                     </tr>
                     <tr>
                         <td align="left" nowrap >% Opción de ajuste Nº&nbsp;<%= ( oCot.getcodOpcion() > 0 ? oCot.getcodOpcion() : 0)  %></td>
                         <td align="left" nowrap ><%= ( oCot.getcodOpcion() > 0 ? oCot.getporcOpcionAjuste() : 0 )%></td>
                         <td align="left" nowrap >$ Opción de ajuste</td>
                         <td align="right" nowrap ><%= Dbl.DbltoStr( oCot.getimpOpcionAjuste(),2) %></td>
                     </tr>
<%   if ( oCot.getcodOpcion() > 0 ) {
    %>
                     <tr>
                         <td align="left" colspan="3" height="35" valign="middle" >(<%= (oCot.getsDescOpcion() == null ? " " : oCot.getsDescOpcion()) %> )</td>
                         <td>&nbsp;</td>
                     </tr>
<%      }
    %>
                     <tr>
                         <td align="left" nowrap >% bonificación</td>
                         <td align="left" nowrap ><%= oCot.getporBonif() %></td>
                         <td align="left" nowrap >$ Bonificación</td>
                         <td align="right" nowrap ><%= Dbl.DbltoStr( oCot.getimpBonif(),2)%></td>
                     </tr>
                     <tr>
                         <td align="left" nowrap ></td>
                         <td align="left" nowrap ></td>
                         <td align="left" nowrap ></td>
                         <td align="center" nowrap >----------------------</td>
                     </tr>
                     <tr>
                         <td align="left" nowrap height="40px" valign="middle" >PRIMA PURA</td>
                         <td align="left" nowrap ></td>
                         <td align="left" nowrap ></td>
                         <td align="right" nowrap ><%= Dbl.DbltoStr(oCot.getimpPrimaOrig(),2) %></td>
                     </tr>

                     <tr>
                         <td align="left" nowrap >&nbsp;</td>
                         <td align="left" nowrap >&nbsp;</td>
                         <td align="left" nowrap >$ Prima comisionable</td>
                         <td align="right" nowrap id="prima_comisionable" ><%= Dbl.DbltoStr( oCot.getimpPrimaComisionable(),2) %></td>
                     </tr>

                     <tr>
                         <td align="left" nowrap >% Rec. Admin.</td>
                         <td align="left" nowrap ><%= Dbl.DbltoStr( oCot.getporcRecAdmin(),2) %></td>
                         <td align="left" nowrap >$ Rec. Admin.</td>
                         <td align="right" nowrap id="recargo_admin" ><%= Dbl.DbltoStr( oCot.getrecAdmin(),2) %></td>
                     </tr>
                     <tr>
                         <td align="left" nowrap >% Rec. Finan.</td>
                         <td align="left" nowrap ><%= Dbl.DbltoStr( oCot.getporcRecFinan(),2) %></td>
                         <td align="left" nowrap >$ Rec. Finan.</td>
                         <td align="right" nowrap ><%= Dbl.DbltoStr( oCot.getrecFinan(),2) %></td>
                     </tr>
                     <tr>
                         <td align="left" nowrap >&nbsp; </td>
                         <td align="left" nowrap >&nbsp;</td>
                         <td align="left" nowrap >$ Derecho Emisión</td>
                         <td align="right" nowrap ><%= Dbl.DbltoStr( oCot.getderEmi(),2)  %></td>
                     </tr>
                     <tr>
                         <td align="left" nowrap >% Gastos Adquisicion</td>
                         <td align="left" nowrap ><%= Dbl.DbltoStr( oCot.getgastosAdquisicion(),2) %></td>
                         <td align="left" nowrap >$ Imp. GDA</td>
                         <td align="right" nowrap id="gda" ><%= Dbl.DbltoStr( oCot.getgda(),2) %></td>
                     </tr>
                     <tr>
                         <td align="left" nowrap ></td>
                         <td align="left" nowrap ></td>
                         <td align="left" nowrap ></td>
                         <td align="center" nowrap >----------------------</td>
                     </tr>
                     <tr>
                         <td align="left" nowrap height="40px" valign="middle" >PRIMA TARIFA</td>
                         <td align="left" nowrap ></td>
                         <td align="left" nowrap ></td>
                         <td align="right" nowrap id="prima_tarifa" ><%= Dbl.DbltoStr( oCot.getprimaTar(),2)%></td>
                     </tr>
                     <tr>
                         <td align="left" nowrap >% IVA</td>
                         <td align="left" nowrap ><%= oCot.getporcIva()%></td>
                         <td align="left" nowrap >$ IVA</td>
                         <td align="right" nowrap id="iva" ><%= Dbl.DbltoStr( oCot.getiva(),2)%></td>
                     </tr>
                     <tr>
                         <td align="left" nowrap >% SSN</td>
                         <td align="left" nowrap ><%= oCot.getporcSsn()%></td>
                         <td align="left" nowrap >$ SSN</td>
                         <td align="right" nowrap  id="ssn" ><%= Dbl.DbltoStr( oCot.getssn(),2)%></td>
                     </tr>
                     <tr>
                         <td align="left" nowrap >% SOC</td>
                         <td align="left" nowrap ><%= oCot.getporcSoc()%></td>
                         <td align="left" nowrap >$ SOC</td>
                         <td align="right" nowrap id="soc" ><%= Dbl.DbltoStr( oCot.getsoc(),2) %></td>
                     </tr>
                     <tr>
                         <td align="left" nowrap >% Sellados</td>
                         <td align="left" nowrap ><%= oCot.getporcSellado()%></td>
                         <td align="left" nowrap >$ Sellado</td>
                         <td align="right" nowrap id="sellados" ><%= Dbl.DbltoStr( oCot.getsellado(),2) %></td>
                     </tr>
                     <tr>
                         <td align="left" nowrap ></td>
                         <td align="left" nowrap ></td>
                         <td align="left" nowrap ></td>
                         <td align="center" nowrap >----------------------</td>
                     </tr>
                     <tr>
                         <td align="left" nowrap height="40px" valign="middle" >PREMIO </td>
                         <td align="left" nowrap ></td>
                         <td align="left" nowrap ></td>
                         <td align="right" nowrap id="premio" ><%= Dbl.DbltoStr( oCot.getpremio(),2)%></td>
                     </tr>

                 </table>
             </div>
<%         }
    %>

<%            if ( oCot.getestadoCotizacion() == 0 ) {
    %>
            <div class="cot-wrap">
                <span class="leyend" style="width: 80%"  >(*) Usted puede ajustar Premio o Comisi&oacute;n y luego haga clic en el bot&oacute;n recotizar ...<br/>
                        Puede volver a los valores de la cotizaci&oacute;n original haciendo <a href="#" id="reset" > clic aqu&iacute;</a><br/>
                        Formas de pago disponibles:&nbsp;<strong><%= sb.toString()  %></strong><br/>
<%--
                        Financiaci&oacute;n:<br/>
<%                  for (int ii = 0; ii < lFact.size(); ii++) {
                    Facturacion oFact = (Facturacion) lFact.get(ii);
    %>
    &nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;con facturacion <strong><%= oFact.getdescFacturacion()%></strong>&nbsp;<%= (oFact.getcantCuotas() == 1 ? "" : "hasta") %> en <strong><%= oFact.getcantCuotas() %></strong>&nbsp;<%= (oFact.getcantCuotas() == 1 ? "cuota" : "cuotas") %><br/>
<%                  }
    %>
--%>
                        La cotización incluye sellados provinciales.
                </span>
                <input type="button" name="recotizar" id="recotizar" value="Recotizar" class="bt-form bt-recot" />
                <span id="mensaje_error" class="validation-message">&nbsp;</span>
            </div>
<%             }
    %>
            </form>
            </div><!-- form wrap -->

            <div class="options">
                <a href="#" class="opt-link a-pdf" title="generar y descargar pdf" onclick="overlay2();">Generar PDF</a>
                 <a href="javascript:window.print();" class="opt-link a-printer" title="imprimir cotizacion">Imprimir</a>
<%            if ( oCot.getestadoCotizacion() == 0 ) {
    %>
                 <a href="#" class="opt-link a-mail" title="enviar cotizacion por correo" onclick="overlay();">Enviar por e-mail</a>
<%           }
    %>
            </div>

           </div>
           <!--! tab content .form-->
<%            if ( oCot.getestadoCotizacion() == 0 ) {
    %>
            <!-- button section -->
            <div class="form-file button-container">
                <input type="button" name="volver" id="volver" value="Modificar datos" class="bt atras" />
                <input type="button" name="emitir" id="emitir" value="emitir propuesta" class="bt next" />
            </div>
<%           } else {
    %>
            <div class="form-file button-container">
                <input type="button" name="salir" id="salir" value=" Volver " class="bt atras" />
            </div>
<%         }
    %>
            <!--! button section -->
            <div class="bottom_print">
                <span class="text_leyend">Esta cotizaci&oacute;n tendr&aacute; una valid&eacute;z de 15 d&iacute;as a partir de la fecha de cotizaci&oacute;n<br/>
                                        Formas de pago habilitadas:&nbsp;<%= sb.toString()  %>
                </span>
                 <span class="firma"><img class="bnf_firma_print" src="<%= Param.getAplicacion()%>images/firmaBenef_director.jpg" alt="firma director" /></span>
           </div>
            </div>
           <!--! tab content .form-->
        </div>

        <!--! tabs -->

             <div class="pdf-overlay" id="overlay2">
            	 <div class="pdf-wrapp">
                    <div class="pdf-form">
                      <form  name="form3" id="form3" action="<%= Param.getAplicacion()%>servlet/CotizadorVCServlet" method="post">
                          <input type="hidden" name="opcion"  id="opcionP" value="getCotPDF"/>
                          <input type="hidden" name="num_cotizacion"  value="<%= oCot.getnumCotizacion() %>"/>
                          <input type="hidden" name="incluir_comision" id="incluir_comisionP" />
                      <div class="form-file">
                          <label for="message">&nbsp;<input type="checkbox" name="check_comision" id="check_comisionP" value="N"/>&nbsp;Tilde si desea incluir los gastos de adquicisi&oacute;n en el PDF</label>
                      </div>
                      <div class="form-file">
                          <input type="button" value="Generar PDF" name="send" id="send" class="bt bt-email"  onclick="PrintPDF ();"/>
                           <span class="mseparator">&nbsp;&nbsp;</span><a href="#" onclick="overlay2(); return false;" class="cancel-link">cancelar</a>
                      </div>
                      </form>
                    </div>
                 </div>
             </div>
         <!-- popup oculto para el envio de e-mail -->
            <div class="mail-overlay" id="overlay">

            	 <div class="mail-wrapp">

            	 	  <h3>Formulario de envio por e-mail</h3>

                      <div class="mail-form">
                      <form name="form-email" id="form-email" action="<%= Param.getAplicacion()%>servlet/CotizadorVCServlet" method="post">
                          <input type="hidden" name="opcion" id="opcionM" value="getCotEmail"/>
                          <input type="hidden" name="num_cotizacion" id="num_cotizacion"   value="<%= oCot.getnumCotizacion() %>"/>
                          <input type="hidden" name="incluir_comision" id="incluir_comisionM" />
                          <div class="form-file">
                              <label for="dest">Destinatario</label>
                              <input type="text" name="dest" id="dest" value="<%= usu.getEmail() %>" onblur="if (this.value == &#39;&#39;) {this.value = &#39;<%= usu.getEmail() %>&#39;;}"
                                     onfocus="if (this.value == &#39;<%= usu.getEmail() %>&#39;) {this.value = &#39;&#39;;}" />
                          </div>
                          <div class="form-file">
                              <label for="dest">Con copia </label>
                              <input type="text" name="cc" id="cc" value="" />
                          </div>
                          <div class="form-file">
                              <label for="title">Titulo</label>
                              <input type="text" name="title" id="title" value="Cotizaci&oacute;n N&deg; <%= (oCot.getnumCotizacion() + " - " + (oCot.gettomadorApe() == null ? "" : oCot.gettomadorApe()) ) %>"
                                     onblur="if (this.value == &#39;&#39;) {this.value = &#39;Cotizaci&oacute;n N&deg; <%= (oCot.getnumCotizacion() + " - " + (oCot.gettomadorApe() == null ? "" : oCot.gettomadorApe()) ) %>&#39;;}"
                                     onfocus="if (this.value == &#39;Cotizaci&oacute;n N&deg; <%= (oCot.getnumCotizacion() + " - " + (oCot.gettomadorApe() == null ? "" : oCot.gettomadorApe()) ) %>&#39;) {this.value = &#39;&#39;;}" />
                          </div>
                          <div class="form-file">
                              <label for="message">Mensaje</label>
                              <textarea name="message" id="message" cols="6" rows="5">&nbsp;</textarea>
                          </div>

                          <div class="form-file">
                              <label for="message">La cotización será enviada adjunta en formato pdf</label>
                              <label for="message"><input type="checkbox" name="check_comision" id="check_comisionM" value="N"/>Deseo incluir los gastos de adquisici&oacute;n en el email</label>
                          </div>

                          <div class="form-file">
                              <input type="submit" value="Enviar Mensaje" name="send" id="send" class="bt bt-email" onclick="EnviarMail();" />
                               <span class="mseparator">&nbsp;&nbsp;</span><a href="#" onclick="overlay(); return false;" class="cancel-link">cancelar</a>
                          </div>

                      </form>
                      </div>
            	</div>

            </div>
            <!-- -->
            <jsp:include flush="true" page="/bottom.jsp"/>

    </div>
   <!--! container -->

</body>
</html>
