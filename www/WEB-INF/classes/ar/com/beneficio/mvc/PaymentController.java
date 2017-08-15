package ar.com.beneficio.mvc;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;      
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.mail.EmailException;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import com.business.beans.MercadoPago;
import com.business.beans.Poliza;
import com.business.beans.Usuario;
import com.business.util.Param;
import com.google.gson.Gson;
import com.mercadopago.MP;
import ar.com.beneficio.mvc.form.PaymentForm;
import ar.com.beneficio.mvc.form.PersonalDataForm;
import ar.com.beneficio.mvc.json.EndosoPayment;
import ar.com.beneficio.mvc.json.GenericResponse;
import ar.com.beneficio.mvc.json.PaymentResponse;
import ar.com.beneficio.service.PolizaService;
import ar.com.beneficio.tokens.BeneficioTokens;
import ar.com.beneficio.utilities.MailSender;

/**
 * @author Gustavo
 *
 */

@Controller
public class PaymentController implements BeneficioTokens {
	
	@Autowired
	PolizaService polizaService;
	
	@RequestMapping(value="/portal/payment.html", method= RequestMethod.GET)
	public String payment(Model model, HttpServletRequest request) {
		
		HttpSession page = request.getSession();
		
		if(page.getAttribute(header)==null || page.getAttribute(body)==null || page.getAttribute(person)==null) {
			System.err.println("No se han encontrado los objetos en el contexto de la aplicacion. Redirigiendo a la pagina de error.");
			return error_absolute_page;
		}

		return payment_absolute_page;
	}
	
	@RequestMapping(value="/portal/clientes.html", method= RequestMethod.GET)
	public String clients(Model model, HttpServletRequest request) {
		return "clientes";
	}
	
	@RequestMapping(value="/portal/getmessage/{code}", method= RequestMethod.GET)
	public @ResponseBody GenericResponse getDataIssueMessage(@PathVariable String code, Model model, HttpServletRequest request) {

		GenericResponse response = new GenericResponse();
		response.setSuccess(true);
		MercadoPago mp = new MercadoPago();
		mp.setcode(code);
		response.setMessage(polizaService.getMessageDataIssue(mp));

		return response;
	}
	
	
	@RequestMapping(value="/portal/sendMail/{email}", method= RequestMethod.GET)
	public @ResponseBody GenericResponse sendEmail(@ModelAttribute("paymentForm") PaymentForm paymentForm, @PathVariable String email, Model model, HttpServletRequest request) {

		HttpSession page = request.getSession();
		GenericResponse response = new GenericResponse();
		MercadoPago cabecera = (MercadoPago) page.getAttribute(header);
		List<EndosoPayment> endosoList = fillMap(paymentForm, cabecera);
		
		MailSender sender = new MailSender();
		List<String> emailsTo = new ArrayList<String>();
		List<String> emailsCopyTo = new ArrayList<String>();
		emailsTo.add(email);
		
		try {

			if(email == null || (email != null && StringUtils.isEmpty(email))) {
				response.setSuccess(false);
				response.setMessage(fail_sent_email_field);
			}
			emailsCopyTo = polizaService.getCompanyEmails();
      
		} catch (Exception e1) {
			response.setSuccess(false);
			response.setMessage(fail_sent);
		}
     
		try {

			boolean isSendOk = sender.sendMessage(Param.getMailHost(), Param.getMailSource(), emailsTo, emailsCopyTo, null, subject_email, cabecera, endosoList);        
			if(isSendOk) {
				response.setSuccess(true);
				response.setMessage(success_sent);
			}else{
				response.setSuccess(false);
				response.setMessage(fail_sent);
			}

		} catch (EmailException e) {    
			e.printStackTrace();
			response.setSuccess(false);
			response.setMessage(fail_sent);
		} catch (Exception e) {
			e.printStackTrace();
			response.setSuccess(false);
			response.setMessage(fail_sent);
		}
		
		return response;
	}
	
	private List<EndosoPayment> fillMap(PaymentForm paymentForm, MercadoPago mp) {
		
		String[] endosos = paymentForm.getEndosos().split("_");
		String[] amounts = paymentForm.getEndososamount().split("_");
		String[] premios = paymentForm.getEndosospremios().split("_");
		String[] inicio = paymentForm.getEndososinicio().split("_");
		String[] fin = paymentForm.getEndososfin().split("_");
		
		List<EndosoPayment> endosoList = new ArrayList<EndosoPayment>();
		
		for (int i = 0; i < endosos.length; i++) {
			String endoso = endosos[i];
			String importe = amounts[i];
			String premio = premios[i];
			String fechainicio = inicio[i];
			String fechafin = fin[i];
			
			EndosoPayment endosoPay = new EndosoPayment();
			endosoPay.setRamaCode(mp.getcodRama());
			endosoPay.setNroPoliza(mp.getnumPoliza());
			endosoPay.setNroEndoso(Integer.valueOf(endoso));
			endosoPay.setImporteEndoso(Double.valueOf(importe));
			endosoPay.setPremio(premio);
			endosoPay.setVigencia(fechainicio + " al " + fechafin); 
			
			endosoList.add(endosoPay);
		}
		
		return endosoList;
	}
	
	@RequestMapping(value="/portal/authority.html", method= RequestMethod.POST)
	public @ResponseBody GenericResponse authority(@ModelAttribute("PersonalDataForm") PersonalDataForm personalDataForm, Model model, HttpServletRequest request) {
		
		GenericResponse response = new GenericResponse();
		MercadoPago cabecera = new MercadoPago();
		MercadoPago detalle = new MercadoPago();
		List<Poliza> detalleList = null;
		response.setSuccess(true);
		
		HttpSession page = request.getSession();		
		Usuario user = (Usuario) page.getAttribute("user");
		
		/*if(!polizaService.isEnableMP(user)) {
			response.setSuccess(false);
			response.setMessage(modulo_mp);
			
			return response;
		}*/
		
		cabecera.setnumDoc(personalDataForm.getNumDoc());
		cabecera.setnumPoliza(Integer.valueOf(personalDataForm.getPolizaNumber()));
		cabecera.setcodRama(Integer.valueOf(personalDataForm.getRamaCode()));
		cabecera = polizaService.getMercadoPagoHeader(cabecera);
		detalle.setnumPoliza(Integer.valueOf(personalDataForm.getPolizaNumber()));
		detalle.setcodRama(Integer.valueOf(personalDataForm.getRamaCode()));

		if(!StringUtils.isEmpty(personalDataForm.getOrigen())) {
			cabecera.setprocedencia(personalDataForm.getOrigen());
			detalle.setprocedencia(personalDataForm.getOrigen());
		}else{
			cabecera.setprocedencia(sin_procedencia);
			detalle.setprocedencia(sin_procedencia);
		}
		detalleList = polizaService.getMercadoPagoBody(detalle);

		if(cabecera.getiNumError() >= 0) {
			page.setAttribute(header, cabecera);
			page.setAttribute(body, detalleList);
			page.setAttribute(person, cabecera.getoTomador());
			
			page.setAttribute("idtransaction", personalDataForm.getIdtransaction());
			page.setAttribute("idorigen", personalDataForm.getOrigen());
			page.setAttribute("idbackpage", personalDataForm.getBackPage());
			
		}else{
			response.setSuccess(false);
			response.setMessage(cabecera.getsMensError());

			return response;
		}
		
		response.setRedirect(payment_page);
		
		return response;
	}
	
	@RequestMapping(value="/portal/transaction", method= RequestMethod.POST)
	public @ResponseBody GenericResponse transaction(@ModelAttribute("paymentForm") PaymentForm paymentForm, Model model, HttpServletRequest request) {
		
		GenericResponse response = new GenericResponse();
		HttpSession page = request.getSession();
		PaymentResponse response_mp = null;
		
		MP mp = new MP(access_token);
		mp.sandboxMode(true);
		Map<String, Object> payment_json = new HashMap<String, Object> ();
		Map<String, Object> payer_json = new HashMap<String, Object> ();
		JSONObject payment = null;
		
		MercadoPago cabecera = (MercadoPago) page.getAttribute(header);
		List<EndosoPayment> endosoPay = preparePayment(paymentForm, cabecera);
		
		if(!validatePayment(response, cabecera)) {
			return response;
		}
		
		polizaService.paymentPoliza(cabecera);
		polizaService.paymenteEndosos(cabecera.getnumSecuMercadopago(), endosoPay);
		
		try {
				payment_json.put("external_reference", cabecera.getidTransaccion());
				payment_json.put("transaction_amount", cabecera.getimpTotalFacturado());
				payment_json.put("token", cabecera.gettoken());
				payment_json.put("description", payment_description);
				payer_json.put("email", cabecera.getemail());
				payment_json.put("payer", payer_json);
				payment_json.put("installments", cabecera.getcantCuotas());
				payment_json.put("payment_method_id", paymentForm.getPaymentMethodId());
				
				if(cabecera.getcodBanco() != null) {
					payment_json.put("issuer_id", cabecera.getcodBanco());
				}
				
				payment = mp.post("/v1/payments", payment_json);
				response_mp = new  Gson().fromJson(payment.toString(), PaymentResponse.class);
				
		} catch (JSONException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		postPayment(response, cabecera, response_mp);
		
		return response;
	}
	
	private List<EndosoPayment> preparePayment(PaymentForm paymentForm, MercadoPago mp) {
		
		String[] endosos = paymentForm.getEndosos().split("_");
		String[] amounts = paymentForm.getEndososamount().split("_");
		String[] premios = paymentForm.getEndosospremios().split("_");
		String[] inicio = paymentForm.getEndososinicio().split("_");
		String[] fin = paymentForm.getEndososfin().split("_");
		String idreference = String.valueOf(mp.getcodRama()) + "-" + String.valueOf(mp.getnumPoliza()) + "-" + paymentForm.getAmount();
		     
		mp.setimpTotalFacturado((paymentForm.getAmount()!=null)? Double.valueOf(paymentForm.getAmount()) : 0);
		mp.setcodEstado(codigo_estado_pendiente);
		mp.setopcionPago(opcion_pago_online);
		mp.setemail(paymentForm.getEmail());
		mp.setuserId(procedencia_user_id);
		mp.setidTransaccion(idreference);
		mp.settoken(paymentForm.getToken());
		mp.setcantCuotas(paymentForm.getInstallments());
		
		if(paymentForm.getPaymentMethodId() != null && paymentForm.getPaymentMethodId().length() > 0) {
			mp.setmetodoPago(paymentForm.getPaymentMethodId());
		}else{
			mp.setmetodoPago(null);
		}
		
		mp.setcodBanco(paymentForm.getIssuer());
		
		List<EndosoPayment> endosoList = new ArrayList<EndosoPayment>();
		
		for (int i = 0; i < endosos.length; i++) {
			String endoso = endosos[i];
			String importe = amounts[i];
			String premio = premios[i];
			String fechainicio = inicio[i];
			String fechafin = fin[i];
			
			EndosoPayment endosoPay = new EndosoPayment();
			endosoPay.setRamaCode(mp.getcodRama());
			endosoPay.setNroPoliza(mp.getnumPoliza());
			endosoPay.setNroEndoso(Integer.valueOf(endoso));
			endosoPay.setImporteEndoso(Double.valueOf(importe));
			endosoPay.setPremio(premio);
			endosoPay.setVigencia(fechainicio + " al " + fechafin); 
			
			endosoList.add(endosoPay);
		}
		
		return endosoList;
	}
	
	private void postPayment(GenericResponse response, MercadoPago mp, PaymentResponse payresponse) {
	
		if(payresponse.getStatus() != null && payresponse.getStatus().length() > 0) {
			mp.setstatus(payresponse.getResponse().getStatus());
			mp.setstatusDetail(payresponse.getResponse().getStatus_detail());
			mp.setcode(payresponse.getStatus());
			mp.setcodEstado(codigo_estado_finalizado);
			
			Integer code = (mp.getcode()!=null)?Integer.valueOf(mp.getcode()):null;
			if(code != null && code == 201) {
				response.setSuccess(true);
				response.setMessage(fillTagsMessage(mp, payresponse));
			}else{
				mp.setcodEstado(codigo_estado_pendiente);
				response.setSuccess(false);
				String message = fillTagsMessage(mp, payresponse);
				
				if(message != null && message.length() > 0) {
					response.setMessage(message);
				} else {
					response.setMessage(payment_message);
				}
			}
		} else {
			mp.setcodEstado(codigo_estado_erroneo);
			response.setSuccess(false);
			response.setMessage(payment_message);
		}
		
		polizaService.paymentPoliza(mp);
	}
	
	private Boolean validatePayment(GenericResponse response, MercadoPago mp) {
		
		if(mp.getimpTotalFacturado() == 0) {
			response.setSuccess(false);
			response.setMessage(payment_message_amount);
			
			return false; 
		}
		
		return true;
	}
	
	private String fillTagsMessage (MercadoPago mp, PaymentResponse pr) {
		
		String message = null;
		
		if(pr!=null && pr.getResponse()!=null && pr.getStatus().length() > 3 || tag_201.equalsIgnoreCase(mp.getcode())) {
			message = polizaService.getMessagePaymentStatus(mp);

			if(msg_approved.equalsIgnoreCase(mp.getstatus()) && msg_accredited.equalsIgnoreCase(mp.getstatusDetail())) {
				message = message.replace(tag_amount, pr.getResponse().getTransaction_amount());
				message = message.replace(tag_statement_descriptor, String.valueOf(pr.getResponse().getStatement_descriptor()));
			}
			if(msg_rejected.equalsIgnoreCase(mp.getstatus()) && msg_cc_rejected_call_for_authorize.equalsIgnoreCase(mp.getstatusDetail())) {
				message = message.replace(tag_payment_method_id, pr.getResponse().getPayment_method_id());
				message = message.replace(tag_amount, pr.getResponse().getTransaction_amount());
			}
			if(msg_rejected.equalsIgnoreCase(mp.getstatus()) && msg_cc_rejected_card_disabled.equalsIgnoreCase(mp.getstatusDetail())) {
				message = message.replace(tag_payment_method_id, pr.getResponse().getPayment_method_id());
			}
			if(msg_rejected.equalsIgnoreCase(mp.getstatus()) && msg_cc_rejected_insufficient_amount.equalsIgnoreCase(mp.getstatusDetail())) {
				message = message.replace(tag_payment_method_id, pr.getResponse().getPayment_method_id());
			}
			if(msg_rejected.equalsIgnoreCase(mp.getstatus()) && msg_cc_rejected_other_reason.equalsIgnoreCase(mp.getstatusDetail())) {
				message = message.replace(tag_payment_method_id, pr.getResponse().getPayment_method_id());
			}
		} else {
			message = polizaService.getMessageDataIssue(mp);
			
			if(tag_109.equalsIgnoreCase(mp.getcode())) {
				message = message.replace(tag_payment_method_id, pr.getResponse().getPayment_method_id());
				message = message.replace(tag_installments, pr.getResponse().getInstallments());
			}
			if(tag_129.equalsIgnoreCase(mp.getcode())) {
				message = message.replace(tag_payment_method_id, pr.getResponse().getPayment_method_id());
			}
			if(tag_204.equalsIgnoreCase(mp.getcode())) {
				message = message.replace(tag_payment_method_id, pr.getResponse().getPayment_method_id());
			}
		}
		
		return message;
	}
	
}
