/**
 * 
 */
package ar.com.beneficio.mvc.form;

/**
 * @author gcespedes
 *
 */
public class PaymentForm {
	
	private Integer installments;
	private String token;
	private String amount;
	private String paymentMethodId;
	private String email;
	private Integer issuer;
	private String endosos;
	private String endososamount;
	private String endosospremios;
	private String endososinicio;
	private String endososfin;
	
	
	public String getAmount() {
		return amount;
	}
	public void setAmount(String amount) {
		this.amount = amount;
	}
	public String getToken() {
		return token;
	}
	public void setToken(String token) {
		this.token = token;
	}
	public Integer getInstallments() {
		return installments;
	}
	public void setInstallments(Integer installments) {
		this.installments = installments;
	}
	public String getPaymentMethodId() {
		return paymentMethodId;
	}
	public void setPaymentMethodId(String paymentMethodId) {
		this.paymentMethodId = paymentMethodId;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public Integer getIssuer() {
		return issuer;
	}
	public void setIssuer(Integer issuer) {
		this.issuer = issuer;
	}
	public String getEndosos() {
		return endosos;
	}
	public void setEndosos(String endosos) {
		this.endosos = endosos;
	}
	public String getEndososamount() {
		return endososamount;
	}
	public void setEndososamount(String endososamount) {
		this.endososamount = endososamount;
	}
	public String getEndosospremios() {
		return endosospremios;
	}
	public void setEndosospremios(String endosospremios) {
		this.endosospremios = endosospremios;
	}
	public String getEndososinicio() {
		return endososinicio;
	}
	public void setEndososinicio(String endososinicio) {
		this.endososinicio = endososinicio;
	}
	public String getEndososfin() {
		return endososfin;
	}
	public void setEndososfin(String endososfin) {
		this.endososfin = endososfin;
	}
	
}
