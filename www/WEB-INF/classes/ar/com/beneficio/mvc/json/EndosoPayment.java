package ar.com.beneficio.mvc.json;

public class EndosoPayment {
	
	private Integer ramaCode;
	private Integer nroPoliza;
	private Integer nroEndoso;
	private Double importeEndoso;
	private String vigencia;
	private String premio;
	
	
	public Integer getRamaCode() {
		return ramaCode;
	}
	public void setRamaCode(Integer ramaCode) {
		this.ramaCode = ramaCode;
	}
	public Integer getNroPoliza() {
		return nroPoliza;
	}
	public void setNroPoliza(Integer nroPoliza) {
		this.nroPoliza = nroPoliza;
	}
	public Integer getNroEndoso() {
		return nroEndoso;
	}
	public void setNroEndoso(Integer nroEndoso) {
		this.nroEndoso = nroEndoso;
	}
	public Double getImporteEndoso() {
		return importeEndoso;
	}
	public void setImporteEndoso(Double importeEndoso) {
		this.importeEndoso = importeEndoso;
	}
	public String getVigencia() {
		return vigencia;
	}
	public void setVigencia(String vigencia) {
		this.vigencia = vigencia;
	}
	public String getPremio() {
		return premio;
	}
	public void setPremio(String premio) {
		this.premio = premio;
	}

}
