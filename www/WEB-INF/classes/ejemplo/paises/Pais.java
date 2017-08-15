package ejemplo.paises;

import com.google.gson.annotations.Expose;

public class Pais {
	
	private static int counter = 0;

	@Expose
	private int id;
	
	@Expose
	private String nombre;
	
	private Provincia[] provincias;
	
	public Pais(String nombre, Provincia[] provincias) {
		this.id = counter++;
		this.nombre = nombre;
		this.provincias = provincias;  
	}

	public int getId() {
		return id;
	}

	public String getNombre() {
		return nombre;
	}

	public Provincia[] getProvincias() {
		return provincias;
	}
	
}
