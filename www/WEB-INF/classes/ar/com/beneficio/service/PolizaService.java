/**
 * 
 */
package ar.com.beneficio.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.business.beans.MercadoPago;
import com.business.beans.Poliza;
import com.business.beans.Usuario;
import com.business.util.SurException;

import ar.com.beneficio.dao.PolizaDAO;
import ar.com.beneficio.mvc.json.EndosoPayment;

/**
 * @author Gustavo
 *
 */

@Service
@Transactional(rollbackFor = Exception.class)
public class PolizaService {

	@Autowired
	private PolizaDAO polizaDAO;
	
	/*public LinkedList<Poliza> getAllEndosos(Integer codRama, Integer numPol) throws Exception {
		return polizaDAO.getAllEndosos(codRama, numPol);
	}
	
	public Poliza getPoliza(Integer codRama, Integer numPol) throws Exception {
		return polizaDAO.getPoliza(codRama, numPol);
	}
	
	public PersonaPoliza getTomador(Integer numTomador) throws Exception {
		return polizaDAO.getTomador(numTomador);
	}*/
	
	/*public Connection getCurrentSession() {
		return polizaDAO.getCurrentSession();
	}*/
	
	public MercadoPago getMercadoPagoHeader(MercadoPago mp) {
		return polizaDAO.getMercadoPagoHeader(mp);
	}
	
	public List<Poliza> getMercadoPagoBody(MercadoPago mp) {
		return polizaDAO.getMercadoPagoBody(mp);
	}
	
	public void paymentPoliza(MercadoPago mp) {
		polizaDAO.paymentPoliza(mp);
	}
	
	public void paymenteEndosos(Integer numsecu, List<EndosoPayment> endosoPay) {
		polizaDAO.paymenteEndosos(numsecu, endosoPay);
	}
	
	public String getMessageDataIssue (MercadoPago mp) {
		return polizaDAO.getMessageDataIssue(mp);
		
	}
	
	public String getMessagePaymentStatus (MercadoPago mp) {
		return polizaDAO.getMessagePaymentStatus(mp);
	}
	
	public Boolean isEnableMP(Usuario user) {
		return polizaDAO.isEnableMP(user);
	}   
	
	public List<String> getCompanyEmails() throws Exception {
		return polizaDAO.getCompanyEmails();
	}
	
}
