package ejemplo.paises;

import com.google.gson.annotations.Expose;

public class Ciudad {
	
	private static int counter = 0;

	@Expose
	private int id;
	
	@Expose
	private String nombre;
	
	public Ciudad(String nombre) {
		this.id = counter++;
		this.nombre = nombre;
	}
	
	public static Ciudad C(String nombre) { 
		return new Ciudad(nombre);
	}

	public int getId() {
		return id;
	}

	public String getNombre() {
		return nombre;
	}

}
