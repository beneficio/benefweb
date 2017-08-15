package ejemplo.paises;

import com.google.gson.annotations.Expose;

public class Provincia {
	
	private static int counter = 0;

	@Expose
	private int id;
	
	@Expose
	private String nombre;
	
	private Ciudad[] ciudades;
	
	public Provincia(String nombre, Ciudad[] ciudades) {
		this.id = counter++;
		this.nombre = nombre;   
		this.ciudades = ciudades;
	}

	public int getId() {
		return id;
	}

	public String getNombre() {
		return nombre;
	}

	public Ciudad[] getCiudades() {
		return ciudades;
	}
	
}
