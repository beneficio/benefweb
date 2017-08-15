package ar.com.beneficio.mvc.json;

public class Card {
	
	private String id;
	private String first_six_digits;
	private String last_four_digits;
	private String expiration_month;
	private String expiration_year;
	private String date_created;
	private String date_last_updated;
	private Cardholder cardholder;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getFirst_six_digits() {
		return first_six_digits;
	}
	public void setFirst_six_digits(String first_six_digits) {
		this.first_six_digits = first_six_digits;
	}
	public String getLast_four_digits() {
		return last_four_digits;
	}
	public void setLast_four_digits(String last_four_digits) {
		this.last_four_digits = last_four_digits;
	}
	public String getExpiration_month() {
		return expiration_month;
	}
	public void setExpiration_month(String expiration_month) {
		this.expiration_month = expiration_month;
	}
	public String getExpiration_year() {
		return expiration_year;
	}
	public void setExpiration_year(String expiration_year) {
		this.expiration_year = expiration_year;
	}
	public String getDate_created() {
		return date_created;
	}
	public void setDate_created(String date_created) {
		this.date_created = date_created;
	}
	public String getDate_last_updated() {
		return date_last_updated;
	}
	public void setDate_last_updated(String date_last_updated) {
		this.date_last_updated = date_last_updated;
	}
	public Cardholder getCardholder() {
		return cardholder;
	}
	public void setCardholder(Cardholder cardholder) {
		this.cardholder = cardholder;
	}
	
}
