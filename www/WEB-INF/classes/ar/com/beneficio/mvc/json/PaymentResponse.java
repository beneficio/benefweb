package ar.com.beneficio.mvc.json;

import org.codehaus.jackson.annotate.JsonIgnoreProperties;


@JsonIgnoreProperties
public class PaymentResponse {
	
	private String status;
	private Response response;
	
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Response getResponse() {
		return response;
	}
	public void setResponse(Response response) {
		this.response = response;
	}

}
