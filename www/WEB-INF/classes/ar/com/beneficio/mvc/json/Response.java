/**
 * 
 */
package ar.com.beneficio.mvc.json;

import java.util.List;

import org.codehaus.jackson.annotate.JsonIgnoreProperties;

/**
 * @author gcespedes
 *
 */

@JsonIgnoreProperties
public class Response {
	
	private String id;
	private String date_created;
	private String date_approved;
	private String date_last_updated;
	private String money_release_date;
	private String operation_type;
	private String issuer_id;
	private String payment_method_id;
	private String payment_type_id;
	private String status;
	private String status_detail;
	private String currency_id;
	private String description;
	private String live_mode;
	private String sponsor_id;
	private String collector_id;
	private Payer payer;
	private String external_reference;
	private String transaction_amount;
	private String transaction_amount_refunded;
	private String coupon_amount;
	private String differential_pricing_id;
	private Transaction_Details transaction_details;
	private List<Fee_Details> fee_details;
	private String captured;
	private String binary_mode;
	private String call_for_authorize_id;
	private String statement_descriptor;
	private String installments;
	private Card card;
	private String notification_url;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getDate_created() {
		return date_created;
	}
	public void setDate_created(String date_created) {
		this.date_created = date_created;
	}
	public String getDate_approved() {
		return date_approved;
	}
	public void setDate_approved(String date_approved) {
		this.date_approved = date_approved;
	}
	public String getDate_last_updated() {
		return date_last_updated;
	}
	public void setDate_last_updated(String date_last_updated) {
		this.date_last_updated = date_last_updated;
	}
	public String getMoney_release_date() {
		return money_release_date;
	}
	public void setMoney_release_date(String money_release_date) {
		this.money_release_date = money_release_date;
	}
	public String getOperation_type() {
		return operation_type;
	}
	public void setOperation_type(String operation_type) {
		this.operation_type = operation_type;
	}
	public String getIssuer_id() {
		return issuer_id;
	}
	public void setIssuer_id(String issuer_id) {
		this.issuer_id = issuer_id;
	}
	public String getPayment_method_id() {
		return payment_method_id;
	}
	public void setPayment_method_id(String payment_method_id) {
		this.payment_method_id = payment_method_id;
	}
	public String getPayment_type_id() {
		return payment_type_id;
	}
	public void setPayment_type_id(String payment_type_id) {
		this.payment_type_id = payment_type_id;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getStatus_detail() {
		return status_detail;
	}
	public void setStatus_detail(String status_detail) {
		this.status_detail = status_detail;
	}
	public String getCurrency_id() {
		return currency_id;
	}
	public void setCurrency_id(String currency_id) {
		this.currency_id = currency_id;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getLive_mode() {
		return live_mode;
	}
	public void setLive_mode(String live_mode) {
		this.live_mode = live_mode;
	}
	public String getSponsor_id() {
		return sponsor_id;
	}
	public void setSponsor_id(String sponsor_id) {
		this.sponsor_id = sponsor_id;
	}
	public String getCollector_id() {
		return collector_id;
	}
	public void setCollector_id(String collector_id) {
		this.collector_id = collector_id;
	}
	public Payer getPayer() {
		return payer;
	}
	public void setPayer(Payer payer) {
		this.payer = payer;
	}
	public String getExternal_reference() {
		return external_reference;
	}
	public void setExternal_reference(String external_reference) {
		this.external_reference = external_reference;
	}
	public String getTransaction_amount() {
		return transaction_amount;
	}
	public void setTransaction_amount(String transaction_amount) {
		this.transaction_amount = transaction_amount;
	}
	public String getTransaction_amount_refunded() {
		return transaction_amount_refunded;
	}
	public void setTransaction_amount_refunded(String transaction_amount_refunded) {
		this.transaction_amount_refunded = transaction_amount_refunded;
	}
	public String getCoupon_amount() {
		return coupon_amount;
	}
	public void setCoupon_amount(String coupon_amount) {
		this.coupon_amount = coupon_amount;
	}
	public String getDifferential_pricing_id() {
		return differential_pricing_id;
	}
	public void setDifferential_pricing_id(String differential_pricing_id) {
		this.differential_pricing_id = differential_pricing_id;
	}
	public Transaction_Details getTransaction_details() {
		return transaction_details;
	}
	public void setTransaction_details(Transaction_Details transaction_details) {
		this.transaction_details = transaction_details;
	}
	public List<Fee_Details> getFee_details() {
		return fee_details;
	}
	public void setFee_details(List<Fee_Details> fee_details) {
		this.fee_details = fee_details;
	}
	public String getCaptured() {
		return captured;
	}
	public void setCaptured(String captured) {
		this.captured = captured;
	}
	public String getBinary_mode() {
		return binary_mode;
	}
	public void setBinary_mode(String binary_mode) {
		this.binary_mode = binary_mode;
	}
	public String getCall_for_authorize_id() {
		return call_for_authorize_id;
	}
	public void setCall_for_authorize_id(String call_for_authorize_id) {
		this.call_for_authorize_id = call_for_authorize_id;
	}
	public String getStatement_descriptor() {
		return statement_descriptor;
	}
	public void setStatement_descriptor(String statement_descriptor) {
		this.statement_descriptor = statement_descriptor;
	}
	public String getInstallments() {
		return installments;
	}
	public void setInstallments(String installments) {
		this.installments = installments;
	}
	public Card getCard() {
		return card;
	}
	public void setCard(Card card) {
		this.card = card;
	}
	public String getNotification_url() {
		return notification_url;
	}
	public void setNotification_url(String notification_url) {
		this.notification_url = notification_url;
	}
	
}
