package ar.com.beneficio.tokens;

public interface BeneficioTokens {
	
	public static final String REQ_ENDOSOS = "endosos";
	
	public static final String REQ_POLIZA = "poliza";
	
	public static final String REQ_TOMADOR = "tomador";
	
	public static final String ERROR_MESSAGE = "error_message";
	
	public static final String client_page = "portal/clientes.jsp";
	
	public static final String payment_page = "portal/payment.html";
	
	public static final String error_absolute_page = "error";
	
	public static final String clientes_page = "portal/clientes.html";
	
	public static final String payment_absolute_page = "payment";
	
	/*  
	 *	Parametros de poliza Ãºnica 
	 */
	public static final String procedencia_portal = "PORTAL";
	public static final String procedencia_poliza = "POLIZA";
	public static final String procedencia_propuesta = "PROPUESTA";
	public static final String sin_procedencia = "SIN PROCEDENCIA";
	
	/*  
	 *	Parametros de varias polizas 
	 */
	public static final String procedencia_multipoliza = "MULTI_POLIZA";
	public static final String procedencia_preliq = "PRELIQ";
	
	public static final String header = "cabecera";
	public static final String body = "detalle";
	public static final String person = "persona";
	
	public static final String error_code = "ERROR_CODE";
	public static final String error_message = "ERROR_MESSAGE";
	
	
	//public static final String access_token = "APP_USR-5976339125922150-061910-194abff25c615f979055f6d6bebaad0d__I_C__-185923736";
	
	//public static final String access_token = "TEST-4911601320824528-052909-ee36d9c2b4d2c5e3970841ff33b39905__LA_LB__-181478362";
	
	public static final String access_token = "TEST-5976339125922150-061915-d8263d1a174dd9397f2e6d81533c0a14__LD_LC__-185923736";
	
	public static final Integer codigo_estado_pendiente = 0;
	
	public static final Integer codigo_estado_finalizado = 1;

	public static final Integer codigo_estado_erroneo = 2;
	
	public static final Integer opcion_pago_online = 1;
	
	public static final Integer opcion_pago_mail = 2;
	
	public static final String procedencia_user_id = "WEB";
	
	public static final String payment_description = "Pago de poliza y endosos desde el portal.";
	
	public static final String payment_message = "La transaccion no se ha procesado. Por favor intente nuevamente.";
	
	public static final String payment_message_amount = "Por favor, seleccionar un endoso a pagar.";
	
	
	////////////////////////////////////////////////////////////////////////////
	
	public static final String msg_approved = "approved";
	
	public static final String msg_accredited = "accredited";
	
 	public static final String msg_rejected = "rejected";
 	
 	public static final String msg_cc_rejected_call_for_authorize = "cc_rejected_call_for_authorize";
 	
 	public static final String msg_cc_rejected_card_disabled = "cc_rejected_card_disabled";
 	
 	public static final String msg_cc_rejected_insufficient_amount = "cc_rejected_insufficient_amount";
 	
 	public static final String msg_cc_rejected_invalid_installments = "cc_rejected_invalid_installments";
 	
 	public static final String msg_cc_rejected_other_reason = "cc_rejected_other_reason"; 	
 	
 	
 	
 	//////////////////////// TAGS ///////////////////////////
 	
 	
 	public static final String tag_amount = "<%amount%>";
 	
 	public static final String tag_statement_descriptor = "<%statement_descriptor%>";

 	public static final String tag_payment_method_id = "<%payment_method_id%>";
 	
 	public static final String tag_installments = "<%installments%>";
 	
 	public static final String tag_109 = "109";
 	
 	public static final String tag_129 = "129";
 	
 	public static final String tag_204 = "204";
 	
 	public static final String tag_201 = "201";
 	
 	public static final String mensaje_monto = "Por favor, seleccione un monto a pagar.";
 	
 	public static final String success_sent = "Email enviado exitosamente. Por favor revise su correo.";
 	
 	public static final String fail_sent = "Hubo un inconveniente al enviar el email. Por favor intente nuevamente.";
 	
 	public static final String fail_sent_email_field = "Por favor, complete el campo con el email del destinatario.";
 	
 	public static final String subject_email = "Pago online Beneficio";
 	
 	public static final String idpaymentonline = "1";  
 	
 	public static final String idpaymentmail = "2";
 	
 	public static final String idpaymentboth = "3";
 	
 	public static final String modulo_mp = "El m&oacute;dulo de mp se encuentra deshabilitado.";
 	
 	public static final String mercadopago = "MERCADOPAGO";
 	
	
}
