/**
 * 
 */
package ar.com.beneficio.dao;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import javax.annotation.PostConstruct;
import javax.sql.DataSource;

import org.apache.commons.lang.StringUtils;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.simple.SimpleJdbcDaoSupport;
import org.springframework.stereotype.Repository;
import ar.com.beneficio.mvc.json.EndosoPayment;
import ar.com.beneficio.tokens.BeneficioTokens;

import com.business.beans.MercadoPago;
import com.business.beans.MercadoPagoItem;
import com.business.beans.Persona;
import com.business.beans.Poliza;
import com.business.beans.Usuario;
import com.business.util.Email;
import com.business.util.Parametro;
import com.business.util.SurException;

/**
 * @author Gustavo
 *
 */

@Repository
public class PolizaDAOImpl extends SimpleJdbcDaoSupport implements PolizaDAO {
	
	@Autowired
	public SessionFactory sessionFactory;
	
	
	@Autowired
	public PolizaDAOImpl(DataSource datasource) {
		setDataSource(datasource);
	}
	
	@PostConstruct
	void init() {
		
	}

	public MercadoPago getMercadoPagoHeader(MercadoPago mp) {
		return mp.getDBMercadoPago(sessionFactory.getCurrentSession().connection());
	}

	public List<Poliza> getMercadoPagoBody(MercadoPago mp) {
		return mp.getDBOperaciones(sessionFactory.getCurrentSession().connection());
	}

	public void paymentPoliza(MercadoPago mp) {
		mp.setDB(sessionFactory.getCurrentSession().connection());
	}
	
	public void paymenteEndosos(Integer numsecu, List<EndosoPayment> endosoPay) {
		int counterItem = 0;	
		for (EndosoPayment endosoPayment : endosoPay) {
			MercadoPagoItem mpitem = new MercadoPagoItem();
			mpitem.setnumSecuMercadopago(numsecu);
			mpitem.setcodRama(endosoPayment.getRamaCode());
			mpitem.setnumPoliza(endosoPayment.getNroPoliza());
			mpitem.setendoso(endosoPayment.getNroEndoso());
			mpitem.setnumitem(++counterItem);
			mpitem.setimpItem(endosoPayment.getImporteEndoso());
			mpitem.setDB(sessionFactory.getCurrentSession().connection());
		}
	}
	
	public String getMessageDataIssue (MercadoPago mp) {
		return mp.getPaymentDataIssueMessage(sessionFactory.getCurrentSession().connection());
		
	}
	
	public String getMessagePaymentStatus (MercadoPago mp) {
		return mp.getPaymentStatusMessage(sessionFactory.getCurrentSession().connection());
		
	}

	public Boolean isEnableMP(Usuario user) {
		String sMercadoPago = "N";
	    try {
	    	
            Parametro oParam = new Parametro ();
 
            if (user!=null && user.getiCodTipoUsuario() == 0 ) {
                oParam.setsCodigo("ESTADO_MERCADOPAGO_INTERNO");
            } else  {
                oParam.setsCodigo("ESTADO_MERCADOPAGO_PROD");
            }
                
            sMercadoPago = oParam.getDBValor(sessionFactory.getCurrentSession().connection());
	 
	    } catch (Exception se) {
	            return Boolean.FALSE;
	    }
		
		return ("N".equalsIgnoreCase(sMercadoPago)?Boolean.FALSE:Boolean.TRUE);
	}

	public List<String> getCompanyEmails() throws SurException {
		
		Email email = new Email();
		String emailOne = null;
		List<String> listEmail = new ArrayList<String>();
		LinkedList<Persona> destinos = email.getDBDestinos(sessionFactory.getCurrentSession().connection(), 0, BeneficioTokens.mercadopago);
		// devuelve siempre la LinkedList de 1 registro.
		 
		for (int i=0; i < destinos.size();i++) {
		   Persona oPers = (Persona) destinos.get(i);
		   emailOne = oPers.getEmail();
		   if(emailOne != null || !(StringUtils.isEmpty(emailOne))) {
			   listEmail.add(emailOne);
		   }
		}
		
		return listEmail;
	}

}
