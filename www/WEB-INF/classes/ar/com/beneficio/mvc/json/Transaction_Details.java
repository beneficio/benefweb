package ar.com.beneficio.mvc.json;

public class Transaction_Details {
	
	private String net_received_amount;
	private String total_paid_amount;
	private String overpaid_amount;
	private String external_resource_url;
	private String installment_amount;
	private String financial_institution;
	private String payment_method_reference_id;
	
	public String getNet_received_amount() {
		return net_received_amount;
	}
	public void setNet_received_amount(String net_received_amount) {
		this.net_received_amount = net_received_amount;
	}
	public String getTotal_paid_amount() {
		return total_paid_amount;
	}
	public void setTotal_paid_amount(String total_paid_amount) {
		this.total_paid_amount = total_paid_amount;
	}
	public String getOverpaid_amount() {
		return overpaid_amount;
	}
	public void setOverpaid_amount(String overpaid_amount) {
		this.overpaid_amount = overpaid_amount;
	}
	public String getExternal_resource_url() {
		return external_resource_url;
	}
	public void setExternal_resource_url(String external_resource_url) {
		this.external_resource_url = external_resource_url;
	}
	public String getInstallment_amount() {
		return installment_amount;
	}
	public void setInstallment_amount(String installment_amount) {
		this.installment_amount = installment_amount;
	}
	public String getFinancial_institution() {
		return financial_institution;
	}
	public void setFinancial_institution(String financial_institution) {
		this.financial_institution = financial_institution;
	}
	public String getPayment_method_reference_id() {
		return payment_method_reference_id;
	}
	public void setPayment_method_reference_id(String payment_method_reference_id) {
		this.payment_method_reference_id = payment_method_reference_id;
	}

}
