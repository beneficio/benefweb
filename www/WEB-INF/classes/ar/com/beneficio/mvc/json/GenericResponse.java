/**
 * 
 */
package ar.com.beneficio.mvc.json;

/**
 * @author Gustavo
 *
 */
public class GenericResponse {
	
	private Boolean success;
	private String message;
	private String redirect;
	
	public Boolean getSuccess() {
		return success;
	}
	public void setSuccess(Boolean success) {
		this.success = success;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getRedirect() {
		return redirect;
	}
	public void setRedirect(String redirect) {
		this.redirect = redirect;
	}
}
