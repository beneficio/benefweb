/**
 * 
 */
package ar.com.beneficio.dao;

import java.util.LinkedList;
import java.util.List;

import ar.com.beneficio.mvc.json.EndosoPayment;

import com.business.beans.MercadoPago;
import com.business.beans.Persona;
import com.business.beans.Poliza;
import com.business.beans.Usuario;
import com.business.util.SurException;      

/**
 * @author Gustavo
 *
 */
public interface PolizaDAO {
	
	/*public LinkedList<Poliza> getAllEndosos(Integer codRama, Integer numPol) throws Exception;
	public Poliza getPoliza(Integer codRama, Integer numPol) throws Exception;
	public PersonaPoliza getTomador(Integer numTomador) throws Exception;*/
	
	//public Connection getCurrentSession();
	
	public MercadoPago getMercadoPagoHeader(MercadoPago mp);
	
	public List<Poliza> getMercadoPagoBody(MercadoPago mp);
	
	public void paymentPoliza(MercadoPago mp);
	
	public void paymenteEndosos(Integer numsecu, List<EndosoPayment> endosoPay);
	
	public String getMessageDataIssue (MercadoPago mp);
	
	public String getMessagePaymentStatus (MercadoPago mp);
	
	public Boolean isEnableMP(Usuario user);
	
	public List<String> getCompanyEmails() throws SurException;
	
}
