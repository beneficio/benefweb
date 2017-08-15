<%@page import="ar.com.beneficio.tokens.BeneficioTokens"%>
<%@page contentType="text/html" pageEncoding="UTF-8" errorPage="/error.jsp"%>
<%@page import="com.business.beans.Portal"%>
<%@page import="com.business.beans.PortalTexto"%>
<%@page import="com.business.beans.PortalTabla"%>
<%@page import="com.business.util.*"%>
<%  String certError   = (String) request.getAttribute("error_cert");
    String poliza_mens = (String) request.getAttribute("poliza_mens");
    String urlExtranet = config.getServletContext().getInitParameter ("urlExtranet");
    if (urlExtranet == null) { urlExtranet = "https://www.beneficioweb.com.ar/"; }
%>
<%-- <%@ page isELIgnored="false" %> --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="es-419"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="es-419"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="es-419"> <![endif]-->
<!--[if IE 9]>         <html class="no-js lt-ie10" lang="es-419"> <![endif]-->
<!--[if gt IE 9]><!--> <html class="no-js" lang="es-419"> <!--<![endif]-->
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title></title>
    
    <meta property="og:title" content="Clientes">
	<meta property="og:type" content="website">
	<meta property="og:url" content="http://www.beneficioweb.com.ar">
	<meta property="og:image" content="http://www.beneficioweb.com.ar/portal/img/avatar.png">
	<meta property="og:site_name" content="Beneficio SA - Compañia de Seguros">
	<meta property="fb:admins" content="100004514563818">
	<meta property="og:description" content="BENEFICIO S.A. Compañ&iacute;a de Seguros fue formada el 01 de julio de 1995,
	con las m&aacute;s recientes caracter&iacute;sticas establecidas por la Superintendencia de Seguros de la Naci&oacute;n para empresas que desarrollan los ramos Vida, Salud, Sepelio Y Accidentes Personales,
	que son ramos espec&iacute;ficos de los seguros sobre las personas. A partir de mayo 2011 estamos autorizados por la SSN a comercializar Seguros de Caucion">
	
	<link rel="icon" href="http://www.beneficioweb.com.ar/favicon.ico" type="image/x-icon">
 	<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/spinner.css">
	<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/main.css">
	<link rel="stylesheet" href="<%= Param.getAplicacion()%>portal/css/table.css">
	<link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos-pay.css"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/estilos.css"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/custom-bootstrap.css"/>
	<link rel="canonical" href="https://www.beneficioweb.com/url.html">
	<!-- <link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css"> -->
	<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">

	<link rel="stylesheet" href="//cdn.datatables.net/plug-ins/1.10.7/integration/jqueryui/dataTables.jqueryui.css">
	
	
	<script src="<%= Param.getAplicacion()%>portal/js/vendor/modernizr-2.6.1.min.js"></script>
    <script src="https://code.jquery.com/jquery-1.11.0.min.js"></script>
    <script src="https://code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
    <script src="https://secure.mlstatic.com/sdk/javascript/v1/mercadopago.js"></script>
    <script src="<%= Param.getAplicacion()%>portal/js/ga.js"></script>
    <script src="<%= Param.getAplicacion()%>portal/js/bootstrap.min.js"></script>
    <script src="<%= Param.getAplicacion()%>portal/js/formValidation.min.js"></script>
    <script src="<%= Param.getAplicacion()%>portal/js/bootstrap.min.custom.js"></script>
    <script src="<%= Param.getAplicacion()%>portal/js/jquery.payment.js"></script>
    
    <script src="//cdn.datatables.net/1.10.7/js/jquery.dataTables.min.js"></script>
	<script src="//cdn.datatables.net/plug-ins/1.10.7/integration/jqueryui/dataTables.jqueryui.js"></script>
	
	
    
    <style type="text/css">
    
    	.MP-common-lightblue-CDm {
		    background: #b8d2eb url("https://a248.e.akamai.net/secure.mlstatic.com/mptools/assets/MP-payButton-lightblue.png") repeat scroll 0 0;
		    border: 1px solid #8db7e9;
		    color: #215181;
		    cursor: pointer;
		    display: inline-block;
		    font-size: 20px;
		    font-weight: normal;
		    line-height: 40px;
		    margin: 10px;
		    padding: 0 20px;
		    text-decoration: none;
		}
		
		.MP-m-ov-Dm {
		    border-radius: 15px;
		    font-size: 17px;
		    line-height: 30px;
		    padding: 0 17px;
		}
		
		.MP-common-green-CDl {
		  cursor: pointer;
		  display: inline-block;
		  margin: 10px;
		  font-weight: normal;
		  text-decoration: none;
		  font-size: 20px;
		  line-height: 40px;
		  padding: 0px 20px;
		  background: url(https://a248.e.akamai.net/secure.mlstatic.com/mptools/assets/MP-payButton-green.png) rgb(7, 117, 116);
		  color: rgb(255, 255, 255);
		  border: 1px solid rgb(11, 137, 139);
		  border-image-source: initial;
		  border-image-slice: initial;
		  border-image-width: initial;
		  border-image-outset: initial;
		  border-image-repeat: initial;
		  text-shadow: rgb(11, 137, 139) 1px 1px;
		}
		
		.MP-l-rn-Dl {
		  font-size: 16px;
		  line-height: 40px;
		  padding: 0px 13px;
		  border-top-left-radius: 7px;
		  border-top-right-radius: 7px;
		  border-bottom-right-radius: 7px;
		  border-bottom-left-radius: 7px;
		}
		
		.col-xs-1 {
		  width: 10.333333% !important;
		}
		
		.rTable {
			box-sizing: inherit !important;
		}
		
		.personalData {
			margin-left: 30px;
		}
		
		.label {
		  float: left;
		  display: block;
		  width: 100%;
		  height: auto;
		  margin: 0;
		  padding: 0;
		  font: 600 0.938em "Open Sans", arial, helvetica, sans-serif;
		  color: #4b4c4c;
		  line-height: 40px;
		}
		
		.form h2 {
			margin-bottom: 2%;
  			margin-top: 2%;
		}
		
		h1.title-section {
		  margin-top: 5%;
		}
		
		.form-wrap {
		  margin-bottom: 50px !important;
		}
		
		.form label {
		  line-height: 25px !important;
		}
		
		.custom-margin {
			margin-left: 30px !important;
		}
		
		.has-error input {
	      border-width: 2px;
	    }
	    .validation.text-danger:after {
	      content: 'Validation failed';
	    }
	    .validation.text-success:after {
	      content: 'Validation passed';
	    }
	    
	    .no-close .ui-dialog-titlebar-close {
		  display: none;
		}
		
		td, th {
		    text-align: center;
		}
		
    </style>
    
    <script type="text/javascript">
    
    	jQuery(function($) {
			$( "#radio_credit_card").on( "click", function() {
				
				if($('#amount').val() > 0) {
					$("#div_credit_card").show("slow");
					$("#div_mail").hide("slow");
	    		}else{
	    			$('#radio_credit_card').prop('checked', false);
	    			showDialog('<%= BeneficioTokens.mensaje_monto%>');	
	    		}
						  
			});
			
			$( "#radio_mail").on( "click", function() {
				
				if($('#amount').val() > 0) {
					$("#div_credit_card").hide("slow");
					$("#div_mail").show("slow");
				} else {
					$('#radio_mail').prop('checked', false);
					showDialog('<%= BeneficioTokens.mensaje_monto%>');
				}
			});
			
			Mercadopago.getIdentificationTypes();
			
			$('#cardNumber').payment('formatCardNumber');
			$('#securityCode').payment('formatCardCVC');
			$('[data-numeric]').payment('restrictNumeric');
			
			$.fn.toggleInputError = function(erred) {
		       this.parent('.form-group').toggleClass('has-error', erred);
		       return this;
		    };
		    
		    $('#payment-table').dataTable();
		    
		    <c:choose>
				<c:when test="${idtransaction eq 1}">
					$('#credit_card_option').show();
					$('#mail_option').hide();
				</c:when>
				<c:when test="${idtransaction eq 2}">
					$('#credit_card_option').hide();
					$('#mail_option').show();
				</c:when>
				<c:when test="${idtransaction eq 3}">
					$('#credit_card_option').show();
					$('#mail_option').show();
				</c:when>
			</c:choose>
		    
    	});
    	
    	function resetPaymentForm() {
    		$("#pay")[0].reset();
			$("#lissuer").hide();
			$("#installments").prop("disabled", true);
    	}
		
	    function goBack() {
	  	  var redirect = "<%= Param.getAplicacion()%><c:out value="${idbackpage}"/>";
	  	  
	  	  if(redirect){
	  	  	window.location.replace(redirect);
	  	  }
	  	  
	  	  return false;
	    }
	    
	    function cancelPayment() {
	    	window.history.go(-1);
	    }
	    
	    function CheckList() {
	    	
	    	$("#endosos").val("");
	     	$("#endososamount").val("");
	     	$("#endosospremios").val("");
	     	$("#endososinicio").val("");	
	     	$("#endososfin").val("");
	    
	    	$('input[name="totalparcial"]:checked').each(function() {
	    	//$('[name="totalparcial"]').change(function() {
			   //console.log(this.value);

			   var value = this.value.split('_');
			   var nroend = value[0];
			   var amountend = value[1];
			   var premio = value[2];
			   var fechaInicio = value[3];
			   var fechaFin = value[4];

		   	   $("#endosos").val($("#endosos").val().concat(nroend + '_'));
		   	   $("#endososamount").val($("#endososamount").val().concat(amountend + '_'));
			   $("#endosospremios").val($("#endosospremios").val().concat(nroend + '_'));
			   $("#endososinicio").val($("#endososinicio").val().concat(nroend + '_'));
			   $("#endososfin").val($("#endososfin").val().concat(nroend + '_'));
		   });
	    }
	    
	    
	    function transaction() {
	       
		   // Getting checkboxes checked with endoso number and amount.
		   var monto = $('#amount').val();
		   
		   if(monto > 0) {
		   
			   CheckList();
		       
	    	   var controller = "<%= Param.getAplicacion()%>portal/transaction.html";
	    	   $.post(controller, $("#pay").serialize(), function(result) {
	    		   
	    		 showDialog(result.message);
	    		   
				 /*if (result.success == true || result.success == 'true') {
										
				 }else{
					alert('fallido');
				 }*/
	           }, 'json');
		   } else {
			   showDialog("Por favor, seleccione alguna p&oacute;liza a pagar.");			   
		   }
        }
	    
	    function showDialog(message) {
	    	
	    	$("#dialog_message").html(message);
	    	$("#dialog").dialog({
	    		dialogClass: "no-close", 
	    		closeOnEscape: false, 
	    		closeText: "hide", 
	    		modal: true, 
	    		title: "Transacción de pago",
	    		buttons: [{
 		            text: "Ok",
 		            icons: {
 		              primary: "ui-icon-heart"
 		            },
 		            click: function() {
 		              resetPaymentForm();	
 		              $( this ).dialog( "close" );
 		            }
 		        }]
	    	});
	    	
	    }
	    
	    $('#loadingDiv')
    	.hide()
	    .ajaxStart(function() {
	        $(this).show();
	    })
	    .ajaxStop(function() {
	        $(this).hide();
	    });
	    
    </script>
</head>

  <body>
  		<div id="dialog" style="display: none;">
  			<p id="dialog_message"></p>
  		</div>
  		<div id="loadingDiv" class="spinner" style="display: none;"></div>
      	<div class="wrapper">
			<div class="container">
				<div class="header">
					<img src="/benef/images/logos/bnf_web_logo.png" width="326" height="88" alt="logo" class="logo">
				</div>
				
				<h1 class="title-section hcotizadores">Informaci&oacute;n de la operaci&oacute;n a pagar</h1>
				<div class="tabs-container">
					<div id="tab1" class="tab-content form">
						<div class="form-wrap">					
							<div class="personalData">
								<span>
									<label>Rama: <c:out value="${cabecera.descRama}"></c:out></label>
									<label>P&oacute;liza: <c:out value="${cabecera.numPoliza}"></c:out></label>
									<label>Tomador:	<c:out value="${persona.razonSocial}"></c:out></label> 
									<label>Dni/Cuit: 
										<c:choose>
										    <c:when test="${persona.tipoDoc == 80}">
										        <c:out value="${persona.cuit}"></c:out>
										    </c:when>    
										    <c:otherwise>
										       <c:out value="${persona.numDoc}"></c:out>
										    </c:otherwise>
										</c:choose>
									</label>
								</span>
							</div>
							<h2 class="title-section hcotizadores">1 - Seleccione las operaciones a pagar:</h2>
							
							<table id="payment-table" class="display" cellspacing="0" width="100%">
								<thead>
									<tr>
										<th>Rama</th>
										<th>P&oacute;liza</th>
										<th>Endoso</th>
										<th>Vigencia</th>
										<th>Premio</th>
										<th>Saldo</th>
										<th>A Pagar</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${detalle}" var="endoso">
										<tr>
											<td><c:out value="${endoso.descRama}" /></td>
											<td><c:out value="${endoso.numPoliza}" /></td>
											<td><c:out value="${endoso.numEndoso}" /></td>
											<td><c:out value="${endoso.fechaInicioVigenciaEnd}" /> al <c:out value="${endoso.fechaFinVigenciaEnd}" /></td>
											<td><c:out value="${endoso.impTotalFacturado}" /></td>
											<td><c:out value="${endoso.impSaldoPoliza}" /></td>
											<td><input id="${endoso.numEndoso}_${endoso.impSaldoPoliza}_${endoso.impTotalFacturado}_${endoso.fechaInicioVigenciaEnd}_${endoso.fechaFinVigenciaEnd}" name="totalparcial" type="checkbox" value="${endoso.numEndoso}_${endoso.impSaldoPoliza}_${endoso.impTotalFacturado}_${endoso.fechaInicioVigenciaEnd}_${endoso.fechaFinVigenciaEnd}" /></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							<br>
							
							<!-- <input name="cancelPay" onclick="goBack()" type="button" class="MP-common-green-CDl MP-l-rn-Dl" id="cancelPay" value="Cancelar Pago" /> -->
							<div style="width:100%;position:relative;">
								<div style="position:absolute; left:0%; width:50%;">
									<a href="#" onclick="goBack();">Cancelar</a>
								</div>
								<div align="right" style="position:absolute; left:50%; width:50%; font-size:16px">
									<label id="lbamount" for="amount_label" align="center">Total a pagar: &nbsp;&nbsp; $<span id="grid_label_amount">00.00</span></label>
								</div>
							</div>
							
					      	<h2 class="title-section hcotizadores">2 - Seleccione como desea realizar el pago:</h2>
					      	<div id="credit_card_option" style="width:800px; margin:0 auto; margin-bottom: 40px;">
					      		<div>
									<div style="float: left;">
										<input type="radio" name="radio_option" id="radio_credit_card">
									</div>
						      		<div style="margin-left: 30px;">
						      			<label>Pagar con tarjeta de cr&eacute;dito desde aqui</label>
						      		</div>
						      		<div style="margin-left: 30px;">
						      			<img src="https://imgmp.mlstatic.com/org-img/banners/ar/medios/785X40.jpg" title="MercadoPago - Medios de pago" alt="MercadoPago - Medios de pago" width="785" height="40">
						      		</div>					      		
					      		</div>
					      		<div id="div_credit_card" style="display: none; margin-left: 30px; margin-top: 30px;">
									<form action="" method="post" id="pay" name="pay" class="form-horizontal" autocomplete="on">
										<input id="amount" type="hidden" name="amount" value=""/>
										<input id="endosos" type="hidden" name="endosos" value="" />
										<input id="endososamount" type="hidden" name="endososamount" value="" />
										<input id="endosospremios" type="hidden" name="endosospremios" value="" />
										<input id="endososinicio" type="hidden" name="endososinicio" value="" />
										<input id="endososfin" type="hidden" name="endososfin" value="" />
										
										<div class="form-group">
									        <label id="lbemail" for="email" class="col-xs-3 control-label">Email</label>
									        <div class="col-xs-5">
									            <input id="email" name="email" value="" type="tel" placeholder="Tu email" class="form-control" />
									        </div>
									    </div>
									    <div class="form-group">
									        <label id="lbcardNumber" for="cardNumber" class="col-xs-3 control-label">N&uacute;mero de la tarjeta</label>
									        <div class="col-xs-5">
									            <input type="tel" id="cardNumber" data-checkout="cardNumber" placeholder="•••• •••• •••• ••••" class="form-control cardNumber" autocomplete="cardNumber" required />
									        </div>
									    </div>
									    <div class="form-group">
									        <label id="lbsecurityCode" for="securityCode" class="col-xs-3 control-label">C&oacute;digo de seguridad</label>
									        <div class="col-xs-5">
									            <input type="tel" id="securityCode" data-checkout="securityCode" placeholder="123" class="form-control" autocomplete="off" />
									        </div>
									    </div>
									    <div class="form-group">
									        <label id="lbcardExpirationMonth" for="cardExpirationMonth" class="col-xs-3 control-label">Mes de expiraci&oacute;n</label>
									        <div class="col-xs-5">
									            <input type="tel" id="cardExpirationMonth" data-checkout="cardExpirationMonth" placeholder="12" class="form-control" autocomplete="cardExpirationMonth" data-numeric />
									        </div>
									    </div>
									    <div class="form-group">
									        <label id="lbcardExpirationYear" for="cardExpirationYear" class="col-xs-3 control-label">Año de expiraci&oacute;n</label>
									        <div class="col-xs-5">
									            <input type="tel" id="cardExpirationYear" data-checkout="cardExpirationYear" placeholder="2015" class="form-control" autocomplete="cardExpirationYear" data-numeric />
									        </div>
									    </div>
									    <div class="form-group">
									        <label id="lbcardholderName" for="cardholderName" class="col-xs-3 control-label">Titular de la tarjeta</label>
									        <div class="col-xs-5">
									            <input type="tel" id="cardholderName" data-checkout="cardholderName" placeholder="APRO" class="form-control" />
									        </div>
									    </div>
									    <div id="lissuer" class="form-group">
									        <label id="lbissuer" for="issuer" class="col-xs-3 control-label">Medio de pago</label>
									        <div class="col-xs-3 selectContainer">
									            <select id="issuer" name="issuer" class="form-control">
											    	<option value="-1">Elegir...</option>
											    </select>
									        </div>
									    </div>
									    <div class="form-group">
									        <label id="lbinstallments" for="installments" class="col-xs-3 control-label">Cuotas</label>
									        <div class="col-xs-3 selectContainer">
									            <select id="installments" name="installments" class="form-control">
											    	<option value="-1">Elegir...</option>
											    </select>
									        </div>
									    </div>
									    <div class="form-group">
									        <label id="lbdocType" for="docType" class="col-xs-3 control-label">Tipo de documento</label>
									        <div class="col-xs-3 selectContainer">
									        	<select id="docType" data-checkout="docType" class="form-control"></select>
									        </div>
									    </div>
									    <div class="form-group">
									        <label id="lbdocNumber" for="docNumber" class="col-xs-3 control-label">N&uacute;mero de documento</label>
									        <div class="col-xs-5">
									            <input type="tel" id="docNumber" data-checkout="docNumber" placeholder="12345678" class="form-control" data-numeric />
									        </div>
									    </div>
									    <div class="form-group">
									        <label id="lbamount" for="amount_label" class="col-xs-3 control-label">Total a pagar</label>
									        <label style="margin-top: 8px; margin-left: 16px;" for="amount">$ <span id="label_amount">00.00</span></label>
									    </div>
									    <div class="form-group custom-margin">
									        <div class="col-xs-9 col-xs-offset-3">
									            <!-- <input class="MP-common-lightblue-CDm MP-m-ov-Dm" type="button" value="Confirmar Pago" id="btnPay"> -->
									            
									            <input class="MP-common-lightblue-CDm MP-m-ov-Dm" type="submit" value="Confirmar Pago" id="btnPay">
									            
									      		<a href="#" onclick="goBack();">Cancelar</a>
									        </div>
									    </div>
									</form>
						      	</div>
					      	</div>
					      	<div id="mail_option" style="width:800px; margin:0 auto;">
					      		<div>
									<div style="float: left;">  
										<input type="radio" name="radio_option" id="radio_mail">
									</div>
  
									<div style="margin-left: 30px;">
                                                                            <label>Email de pago</label>
										<label>Ingrese una direcci&oacute;n de email donde le llegar&aacute; un correo con un bot&oacute;n de pago para pagar en otro momento desde Mercadopago</label>
									</div>
  								</div>
					      		<div id="div_mail" style="display: none; margin-left: 30px; margin-top: 30px;" class="form-horizontal">
									<div class="form-group">
										<label id="lbemail_pago" for="email" class="col-xs-3 control-label">Email</label>
								        <div class="col-xs-4">
									   		<input type="email" name="email_pago" id="email_pago" placeholder="Tu email" class="form-control" value="">
										</div>
										<div class="col-xs-1">
										  <input class="MP-common-lightblue-CDm MP-m-ov-Dm" type="button" name="btn_mail" id="btn_mail" value="Enviar" style="margin-top: 0px;">      				
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<table cellspacing="0" cellpadding="0" width="100%" align="center" border="0" class="bottom no-imprimir">
					<tbody>
						<tr>
							<td><hr width="98%" color="#d54536" noshade=""></td>
						</tr>
						<tr>
							<td>
								<div align="center"><p style="FONT-WEIGHT: normal; FONT-SIZE: 10px; COLOR: #666666; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif; TEXT-DECORATION: none;">
									Casa Central: Leandro N. Alem Nο 530 piso 1 (1047) Capital Federal  - Tel.Fax- 011 5236 4300  / buenosaires@beneficio.com.ar
								<br>Sede Administrativa: C&oacute;rdoba 1015, Galer&iacute;a Victoria Mall, Piso 2ο oficina 7 - (2000) Rosario - Tel.Fax- 0341 527 1071 / beneficio@beneficio.com.ar <br>Oficina Salta: Santiago del Estero 789, (4400) Salta - Tel/Fax: +54 (0387)480-0830 / salta@beneficio.com.ar</p>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>

		<script type="text/javascript">
	      	Mercadopago.setPublishableKey("TEST-ee1ef699-12a9-42f2-babb-53d3ea52f2d7");
	      	var doSubmit = false;

	      	$('[name="totalparcial"]').click(function() {
				var total = 0;
				var longtotal = $('[name="totalparcial"]').length;
				var ischecked = [];
				var check = $(this);
				var unpayment = false;
				
				if(longtotal >= 1) {
			    	$('[name="totalparcial"]').each(function(index) {
			    		ischecked[index] = $(this).prop("checked");
			    		if(this!=null && $(this)!=null && $(this).prop("checked")) {
			    			for (i = index; i >= 0; --i) {
			    				if(ischecked[i]==false && unpayment==false) {
			    					showDialog("Debe seleccionar para pagar del endoso más antiguo al más reciente.");
			    					unpayment = true;
			    				}
			    			}
			    			if(unpayment) {
			    				check.attr('checked', false);
			    				$('[name="totalparcial"]').each(function(indexinside) {
			    					if(indexinside >= index) {
			    						$(this).attr('checked', false);
			    					}
			    				});
			    				return false;
			    			}
			    			
			    			if($(this).attr('id')!=null) {
				    			var id = null;
				    			var amount = null;
				    			var idplusamount = $(this).attr('id').split('_');
				    			if(idplusamount.length > 1) {
									id = idplusamount[0];
									amount = idplusamount[1];
									if(amount!=null){
										total += parseFloat(amount);
									}
				    			}
				    		}
			    		}
			    	});
			    	
			    	if(parseFloat(total)!=null) {
			    		var data = parseFloat(total).toFixed(2);
			    		if(data != null){
				    		$('#total').html(data);
				    		$('#amount').val(data);
				    		$('#label_amount').html(data);
				    		$('#grid_label_amount').html(data);
				    		
				    		//$('#btnPay').prop('disabled', false);
			    		}
			    	}
			    }
	    	});

	      	function getBin() {
	      	    var cardSelector = document.querySelector("#cardId");
	      	    if (cardSelector && cardSelector[cardSelector.options.selectedIndex].value != "-1") {
	      	        return cardSelector[cardSelector.options.selectedIndex].getAttribute('first_six_digits');
	      	    }
	      	    var ccNumber = document.querySelector('input[data-checkout="cardNumber"]');
	      	    return ccNumber.value.replace(/[ .-]/g, '').slice(0, 6);
	      	}

	      	function clearOptions() {
	      	    var bin = getBin();
	      	    if (bin.length == 0) {
	      	    	document.querySelector("#lissuer").style.display = 'none';
	      	        document.querySelector("#issuer").style.display = 'none';
	      	        document.querySelector("#issuer").innerHTML = "";

	      	        var selectorInstallments = document.querySelector("#installments"),
	      	            fragment = document.createDocumentFragment(),
	      	            option = new Option("Choose...", '-1');

	      	        selectorInstallments.options.length = 0;
	      	        fragment.appendChild(option);
	      	        selectorInstallments.appendChild(fragment);
	      	        selectorInstallments.setAttribute('disabled', 'disabled');
	      	    }
	      	}

	      	function guessingPaymentMethod(event) {
	      	    var bin = getBin(),
	      	  	amount = document.querySelector('input[name=amount]').value;
	      	    
	      	    if (event.type == "keyup") {
	      	        if (bin.length == 6) {
	      	            Mercadopago.getPaymentMethod({
	      	                "bin": bin,
	      	                "amount": parseFloat(amount)
	      	            }, setPaymentMethodInfo);
	      	        }
	      	    } else {
	      	        setTimeout(function() {
	      	            if (bin.length >= 6) {
	      	                Mercadopago.getPaymentMethod({
	      	                    "bin": bin,
	      	                    "amount": parseFloat(amount)
	      	                }, setPaymentMethodInfo);
	      	            }
	      	        }, 100);
	      	    }
	      	};

	      	function setPaymentMethodInfo(status, response) {
	      	    if (status == 200) {
	      	        // do somethings ex: show logo of the payment method
	      	        var form = document.querySelector('#pay'),
	      	      	amount = document.querySelector('input[name=amount]').value;
	      	        

	      	        if (document.querySelector("input[name=paymentMethodId]") == null) {
	      	            var paymentMethod = document.createElement('input');
	      	            paymentMethod.setAttribute('name', "paymentMethodId");
	      	            paymentMethod.setAttribute('type', "hidden");
	      	            paymentMethod.setAttribute('value', response[0].id);
	      	            form.appendChild(paymentMethod);
	      	        } else {
	      	            document.querySelector("input[name=paymentMethodId]").value = response[0].id;
	      	        }

	      	        // check if the security code (ex: Tarshop) is required
	      	        var cardConfiguration = response[0].settings,
	      	            bin = getBin();

	      	        for (var index = 0; index < cardConfiguration.length; index++) {
	      	            if (bin.match(cardConfiguration[index].bin.pattern) != null && cardConfiguration[index].security_code.length == 0) {
	      	                document.querySelector("#cvv").style.display = "none";
	      	            } 
	      	        }

	      	        Mercadopago.getInstallments({
	      	            "bin": bin,
	      	            "amount": parseFloat(amount)
	      	        }, setInstallmentInfo);

	      	        // check if the issuer is necessary to pay
	      	        var issuerMandatory = false,
	      	            additionalInfo = response[0].additional_info_needed;

	      	        for (var i = 0; i < additionalInfo.length; i++) {
	      	            if (additionalInfo[i] == "issuer_id") {
	      	                issuerMandatory = true;
	      	            }
	      	        };
	      	        if (issuerMandatory) {
	      	            Mercadopago.getIssuers(response[0].id, showCardIssuers);
	      	            addEvent(document.querySelector('#issuer'), 'change', setInstallmentsByIssuerId);
	      	        } else {
	      	        	document.querySelector("#lissuer").style.display = 'none';
	      	            document.querySelector("#issuer").style.display = 'none';
	      	            document.querySelector("#issuer").options.length = 0;
	      	        }
	      	    }
	      	};

	      	function showCardIssuers(status, issuers) {
	      	    var issuersSelector = document.querySelector("#issuer"),
	      	        fragment = document.createDocumentFragment();

	      	    issuersSelector.options.length = 0;
	      	    var option = new Option("Choose...", '-1');
	      	    fragment.appendChild(option);

	      	    for (var i = 0; i < issuers.length; i++) {
	      	        if (issuers[i].name != "default") {
	      	            option = new Option(issuers[i].name, issuers[i].id);
	      	        } else {
	      	            option = new Option("Otro", issuers[i].id);
	      	        }
	      	        fragment.appendChild(option);
	      	    }
	      	    issuersSelector.appendChild(fragment);
	      	    issuersSelector.removeAttribute('disabled');
	      	    document.querySelector("#issuer").removeAttribute('style');
	      	  	document.querySelector("#lissuer").removeAttribute('style');
	      	};

	      	function setInstallmentsByIssuerId(status, response) {
	      	    var issuerId = document.querySelector('#issuer').value,
	      	        amount = document.querySelector('input[name=amount]').value;

	      	    if (issuerId === '-1') {
	      	        return;
	      	    }

	      	    Mercadopago.getInstallments({
	      	        "bin": getBin(),
	      	        "amount": parseFloat(amount),
	      	        "issuer_id": issuerId
	      	    }, setInstallmentInfo);
	      	};

	      	function setInstallmentInfo(status, response) {
	      	    var selectorInstallments = document.querySelector("#installments"),
	      	        fragment = document.createDocumentFragment();

	      	    selectorInstallments.options.length = 0;

	      	    if (response.length > 0) {
	      	        var option = new Option("Choose...", '-1'),
	      	            payerCosts = response[0].payer_costs;

	      	        fragment.appendChild(option);
	      	        for (var i = 0; i < payerCosts.length; i++) {
	      	            option = new Option(payerCosts[i].recommended_message, payerCosts[i].installments);
	      	            fragment.appendChild(option);
	      	        }
	      	        selectorInstallments.appendChild(fragment);
	      	        selectorInstallments.removeAttribute('disabled');
	      	    }
	      	};

	      	function cardsHandler() {
	      	    clearOptions();
	      	    var cardSelector = document.querySelector("#cardId"),
	      	        amount = document.querySelector('input[name=amount]').value;

	      	    if (cardSelector && cardSelector[cardSelector.options.selectedIndex].value != "-1") {
	      	        document.querySelector('#cardOptions').style.display = "block";
	      	        document.querySelector('#fullForm').style.display = "none";
	      	        document.querySelector('#save').style.display = "none";

	      	        if (cardSelector[cardSelector.options.selectedIndex].getAttribute('security_code_length') === 4) {
	      	            document.querySelector('input[data-checkout=securityCode]').setAttribute('placeholder', '1234');
	      	        } else {
	      	            document.querySelector('input[data-checkout=securityCode]').setAttribute('placeholder', '123');
	      	        }

	      	        var _bin = cardSelector[cardSelector.options.selectedIndex].getAttribute("first_six_digits");
	      	        Mercadopago.getPaymentMethod({
	      	            "bin": _bin
	      	        }, setPaymentMethodInfo);
	      	    }
	      	}

	      	addEvent(document.querySelector('input[data-checkout="cardNumber"]'), 'keyup', guessingPaymentMethod);
	      	addEvent(document.querySelector('input[data-checkout="cardNumber"]'), 'keyup', clearOptions);
	      	addEvent(document.querySelector('input[data-checkout="cardNumber"]'), 'change', guessingPaymentMethod);
	      	cardsHandler();
	    	
	    	function addEvent(el, eventName, handler) {
	    	    if (el.addEventListener) {
	    	           el.addEventListener(eventName, handler);
	    	    } else {
	    	        el.attachEvent('on' + eventName, function(){
	    	          handler.call(el);
	    	        });
	    	    }
	    	};
	    	
	    	$("#radio_credit_card").click(function() {
	    		$("#email_pago").val("");
	    	});
	    	
			$("#radio_mail").click(function() {
				resetPaymentForm();
				
				// r3s3t styles on payment form
				$('#lbcardNumber').toggleInputError(false);
		        $('#lbemail').toggleInputError(false);
		        $('#lbsecurityCode').toggleInputError(false);
		        $('#lbcardExpirationMonth').toggleInputError(false);
		        $('#lbcardExpirationYear').toggleInputError(false);
		        $('#lbcardholderName').toggleInputError(false);
		        $('#lbdocNumber').toggleInputError(false);
		        $('#lbinstallments').toggleInputError(false);
		        $('#lbissuer').toggleInputError(false);
		        $('#lbamount').toggleInputError(false);

		        $('.validation').removeClass('text-danger text-success');
		        $('.validation').addClass($('.has-error').length ? 'text-danger' : 'text-success');
				
	    	});

	    	$("#btnPay").click(function() {
    		 	event.preventDefault();
    		 	
    		 	var cnumber = true;
    		 	var email = true;
    		 	var seccode = true;
    		 	var cexpirdate = true;
    		 	var choldername = true;
    		 	var installments = true;
    		 	var issuer = true;
    		 	var docnumber = true;
    		 	var cantidad = true;
    		 	var cardType = $.payment.cardType($('.cc-number').val());
    		 	
    		 	cnumber = $.payment.validateCardNumber($('#cardNumber').val());
    		 	email = validateEmpty($('#email'));
    		 	seccode = $.payment.validateCardCVC($('#securityCode').val());
    		 	cexpirdate = $.payment.validateCardExpiry($('#cardExpirationMonth').val(), $('#cardExpirationYear').val());
    		 	choldername = validateEmpty($('#cardholderName'));
    		 	docnumber = validateEmpty($('#docNumber'));
    		 	installments = validateNotChooseOption($('#installments'));
    		 	issuer = validateNotChooseOption($('#issuer'));
    		 	cantidad = validateEmpty($('#amount'));
    		 	
		        $('#lbcardNumber').toggleInputError(!cnumber);
		        $('#lbemail').toggleInputError(!email);
		        $('#lbsecurityCode').toggleInputError(!seccode);
		        $('#lbcardExpirationMonth').toggleInputError(!cexpirdate);
		        $('#lbcardExpirationYear').toggleInputError(!cexpirdate);
		        $('#lbcardholderName').toggleInputError(!choldername);
		        $('#lbdocNumber').toggleInputError(!docnumber);
		        $('#lbinstallments').toggleInputError(!installments);
		        $('#lbissuer').toggleInputError(!issuer);
		        $('#lbamount').toggleInputError(!cantidad);
		        
		        $('.validation').removeClass('text-danger text-success');
		        $('.validation').addClass($('.has-error').length ? 'text-danger' : 'text-success');
    		 	
	    	    if(cnumber && email && seccode && cexpirdate && choldername && installments && issuer && docnumber) {
	    	        var $form = document.querySelector('#pay');
	    	        Mercadopago.createToken($form, sdkResponseHandler);
	    	        return false;
	    	    }
    		});
	    	
	    	
	    	$("#btn_mail").click(function() {
	    		event.preventDefault();
	    		
	    		var monto = $('#amount').val();
	  		   
	  		    if(monto > 0) {
	    		
		    		var email = true;
		    		email = validateEmpty($('#email_pago'));
		    		$('#lbemail_pago').toggleInputError(!email);
		    		CheckList();
		    		
		    		if(email) {
		    			$.get('<%= Param.getAplicacion()%>portal/sendMail/'+ $('#email_pago').val() +'.html', $("#pay").serialize(), function(result) {
	
			     	    	showDialog(result.message);
			     	    	
			            }, 'json');
		    		}
	  		    }else{
	  		    	showDialog("Por favor, seleccione alguna p&oacute;liza a pagar.");
	  		    }
	    		
	    	});
	    		
	    	
	    	var $loading = $('#loadingDiv').hide();
	        $(document)
	          .ajaxStart(function () {
	            $loading.show();
	          })
	          .ajaxStop(function () {
	            $loading.hide();
	          });
	    	
	    	function sdkResponseHandler(status, response) {
	    	    if (status != 200 && status != 201) {
	    	    	$.get('<%= Param.getAplicacion()%>portal/getmessage/'+ status +'.html', null, function(result) {
	    				if(result.success == true) {
	    					showDialog(result.message);
	    				} else {				
	    					showDialog("Verificar los datos ingresados");
	    				}
	    			}, 'json');
	    	    }else{
	    	        var form = document.querySelector('#pay');
	    	        if(document.querySelector('input[name=token]') != null){
	    	        	document.querySelector('input[name=token]').remove();
	    	        }
	    	        var card = document.createElement('input');
	    	        card.setAttribute('name',"token");
	    	        card.setAttribute('type',"hidden");
	    	        card.setAttribute('value',response.id);
	    	        form.appendChild(card);
	    	        transaction();
	    	    }
	    	};
	    	
	    	function validateEmpty(obj) {
	    		if(obj != null && obj.val().length === 0 ) {
	    			return false;
	    		}
	    		
	    		return true;
	    	}
	    	
	    	function validateNotChooseOption(obj) {
	    		if(obj.css('display') == 'none') {
	    			return true;
	    		}
	    		
	    		if($("#"+ obj.prop('id') +" option:selected").val() == "-1") {
	    			return false;
	    		}
	    		
	    		return true;
	    	}
	    	
	    	(function(){function $MPC_load(){window.$MPC_loaded !== true && (function(){var s = document.createElement("script");s.type = "text/javascript";s.async = true;
    	    s.src = document.location.protocol+"//resources.mlstatic.com/mptools/render.js";
    	    var x = document.getElementsByTagName('script')[0];x.parentNode.insertBefore(s, x);window.$MPC_loaded = true;})();}
    	    window.$MPC_loaded !== true ? (window.attachEvent ? window.attachEvent('onload', $MPC_load) : window.addEventListener('load', $MPC_load, false)) : null;})();
	    	
	    </script>
  </body>