/**
 * 
 */
package ar.com.beneficio.mvc.form;

/**
 * @author gcespedes
 *
 */
public class PersonalDataForm {
	
	private String numDoc; // cuit - dni
	private String polizaNumber;
	private String ramaCode;
	private String origen;
	private String backPage;
	private String idtransaction;
	
	
	public String getNumDoc() {
		return numDoc;
	}
	public void setNumDoc(String numDoc) {
		this.numDoc = numDoc;
	}
	public String getPolizaNumber() {
		return polizaNumber;
	}
	public void setPolizaNumber(String polizaNumber) {
		this.polizaNumber = polizaNumber;
	}
	public String getRamaCode() {
		return ramaCode;
	}
	public void setRamaCode(String ramaCode) {
		this.ramaCode = ramaCode;
	}
	public String getOrigen() {
		return origen;
	}
	public void setOrigen(String origen) {
		this.origen = origen;
	}
	public String getBackPage() {
		return backPage;
	}
	public void setBackPage(String backPage) {
		this.backPage = backPage;
	}
	public String getIdtransaction() {
		return idtransaction;
	}
	public void setIdtransaction(String idtransaction) {
		this.idtransaction = idtransaction;
	}

}
