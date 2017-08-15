/**
 * 
 */
package ar.com.beneficio.mvc;
    
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
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
//import com.business.beans.Payment_;
import com.business.beans.PersonaPoliza;
import com.business.beans.Poliza;
import com.mercadopago.MP;
import ar.com.beneficio.mvc.form.PaymentForm;
import ar.com.beneficio.mvc.json.GenericResponse;
import ar.com.beneficio.service.PolizaService;
import ar.com.beneficio.tokens.BeneficioTokens;

/**
 * @author Gustavo
 *
 */

//@Controller
//@RequestMapping(value="/payment")
/*public class ExtranetPaymentController implements BeneficioTokens {
	
	@Autowired
	PolizaService polizaService;
	
	@RequestMapping(value="/portal/payment.html", method= RequestMethod.GET)
	public String payment(Model model) {
		return "payment";
	}*/
	
	/*@RequestMapping(value="/portal/access/{dni}/{poliza}/{rama}", method= RequestMethod.GET)
	public @ResponseBody GenericResponse payment(@PathVariable String dni, @PathVariable String poliza, @PathVariable String rama, Model model, HttpServletRequest request) {
		
		GenericResponse response = new GenericResponse();
		response.setSuccess(true);
		response.setMessage("Se ha procesado de manera satisfactoria.");
		HttpSession session = request.getSession();
		
		if(rama==null || poliza==null) {
			response.setSuccess(false);
			response.setMessage("Error en los datos ingresados.");
			return response;
		}
		
		try {
			Integer lrama = Integer.valueOf(rama);
			Integer lpoliza = Integer.valueOf(poliza);
			PersonaPoliza req_tomador = null;
			LinkedList<Poliza> req_endosos = polizaService.getAllEndosos(lrama, lpoliza);
			Poliza req_poliza = polizaService.getPoliza(lrama, lpoliza);
			
			if(req_endosos==null) {
				response.setSuccess(false);
				response.setMessage("No se posee endosos.");
				return response;
			}
			
			if(req_poliza!=null) {
				req_tomador = polizaService.getTomador(req_poliza.getnumTomador());
			}else{
				response.setSuccess(false);
				response.setMessage("No se posee poliza.");
				return response;
			}
			
			if(req_tomador==null) {
				response.setSuccess(false);
				response.setMessage("No se posee tomador.");
				return response;
			}
			
			session.setAttribute(REQ_ENDOSOS, req_endosos);
			session.setAttribute(REQ_POLIZA, req_poliza);
			session.setAttribute(REQ_TOMADOR, req_tomador);
		} catch (Exception e) {
			response.setSuccess(false);
			response.setMessage("Por favor, vuelva a intentar.");
		}
		
		return response;
	}
	
	@RequestMapping(value="/portal/process", method= RequestMethod.POST)
	public @ResponseBody GenericResponse process(@ModelAttribute("paymentForm") PaymentForm paymentForm, Model model, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		GenericResponse response = new GenericResponse();
		response.setSuccess(true);
		response.setMessage("Se ha procesado de manera satisfactoria.");
		
		LinkedList<Poliza> endosos = (LinkedList<Poliza>) session.getAttribute(REQ_ENDOSOS);
		Poliza poliza = (Poliza) session.getAttribute(REQ_POLIZA);
		PersonaPoliza req_tomador = (PersonaPoliza) session.getAttribute(REQ_TOMADOR);
		
		MP mp = new MP(access_token);
		mp.sandboxMode(true);
		Map<String, Object> payment_json = new HashMap<String, Object> ();
		Map<String, Object> payer_json = new HashMap<String, Object> ();
		
		JSONObject payment = null;
		
		try {
				payment_json.put("external_reference", "ram-pol-end-imp");
				payment_json.put("transaction_amount", paymentForm.getAmount());
				payment_json.put("token", paymentForm.getToken());
				payment_json.put("description", "descripcion del pago");
				payer_json.put("email", paymentForm.getEmail());
				payment_json.put("payer", payer_json);
				payment_json.put("installments", paymentForm.getInstallments());
				payment_json.put("payment_method_id", paymentForm.getPaymentMethodId());
				
				if(paymentForm.getIssuer()!=null){
					payment_json.put("issuer_id", paymentForm.getIssuer());
				}
				
				payment = mp.post("/v1/payments", payment_json);
				
		} catch (JSONException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return response;
	}
	
	@RequestMapping(value="/transaction.html", method= RequestMethod.POST)
	public @ResponseBody GenericResponse transaction(@ModelAttribute("payment") Payment_ payment, HttpServletRequest request) {
		
		GenericResponse response = new GenericResponse();
		
		return response;
	}*/

//}
