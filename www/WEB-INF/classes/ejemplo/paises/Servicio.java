package ejemplo.paises;

import java.lang.reflect.Modifier;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.annotations.Expose;      

@Path("/ejemplo")
public class Servicio {

	final static Pais[] paises = new Pais[] { 
			new Pais("Argentina", new Provincia[]{ 
				new Provincia("Buenos Aires",  new Ciudad[]{ new Ciudad("CABA"), new Ciudad("La Plata"), new Ciudad("Ensenada") }), 
				new Provincia("Cordoba",  new Ciudad[]{ new Ciudad("Cordoba"), new Ciudad("Villa Carlos Paz"), new Ciudad("La Falda") }),
				new Provincia("Santa Fe",  new Ciudad[]{ new Ciudad("Santa Fe"), new Ciudad("Rosario") })}
			),
			new Pais("Brasil", new Provincia[]{ 
				new Provincia("Distrito Federal",  new Ciudad[]{ new Ciudad("Brasilia") }), 
				new Provincia("San Pablo",  new Ciudad[]{ new Ciudad("San Pablo"), new Ciudad("Santos"), new Ciudad("Rio Claro") })}
			),
			new Pais("Mexico", new Provincia[]{ 
				new Provincia("Distrito Federal",  new Ciudad[]{ new Ciudad("DF") }), 
				new Provincia("Baja California",  new Ciudad[]{ new Ciudad("Mexicali")})}
			)};
 
	@GET
	@Path("/hola/{param}")
	public Response saludar(@PathParam("param") String msg) {
 
		String output = "Jersey say : " + msg;
 
		return Response.status(200).entity(output).build();
	}
	
	
	@GET
	@Path("/hola2/{nombre}")
	public String saludar2(@PathParam("nombre") String nombre) {
		return "Hola " + nombre;
	}
	
	@GET
	@Path("/paises")
	@Produces(MediaType.APPLICATION_JSON)
	public String paises() {
		// Gson se puede usar de muchas maneras.
		// Como ejemplo, quiero incluir algunas propiedades del objeto, y otras no.
		// Para eso, voy a usar el la anotacion @Expose, para que solo se incluyan las propiedades con esa anotacion.
		// Pero podría haber hecho otra cosa: crear un objeto DTO y serializar ese.
		Gson gson = new GsonBuilder()
		    .excludeFieldsWithoutExposeAnnotation() // esto es para que SOLO incluya las propiedades anotadas con @Expose
		    .create();
		return gson.toJson(paises);
		// Los paises van a incluir el 'id' y el 'nombre', y no van a incluir 'provincias'.
		// Se podría incluir todo si se quiere, pero supongamos que las colecciones son muy grandes y que no queremos hacerlo. 
	}

	@GET
	@Path("/provincias")
	@Produces(MediaType.APPLICATION_JSON)
	public String provincias(
			@QueryParam("pais") int pPais) {
		
		Provincia[] provincias = null;
		
		// Simulamos una búsqueda de las provincias de un pais
		for (Pais pais: paises) {
			if (pais.getId() == pPais) {
				// listo, lo encontramos
				provincias = pais.getProvincias();
				break;
			}
		}
		
		Gson gson = new GsonBuilder()
		    .excludeFieldsWithoutExposeAnnotation() // esto es para que SOLO incluya las propiedades anotadas con @Expose
		    .create();
		return gson.toJson(provincias);
	}
	
	@GET
	@Path("/ciudades")
	@Produces(MediaType.APPLICATION_JSON)
	public String ciudades(
			@QueryParam("pais") int pPais, 
			@QueryParam("prov") int pProv) {
		
		Ciudad[] ciudades = null;
		
		// Simulamos la búsqueda de las ciudades de una provincia en un país.
		for (Pais pais: paises) {
			if (pais.getId() == pPais) {
				for (Provincia prov: pais.getProvincias()) {
					if (prov.getId() == pProv) {
						// listo, lo encontramos
						ciudades = prov.getCiudades();
						break;
					}
				}
			}
		}
		
		Gson gson = new GsonBuilder()
		    .excludeFieldsWithoutExposeAnnotation() // esto es para que SOLO incluya las propiedades anotadas con @Expose
		    .create();
		return gson.toJson(ciudades);
	}
	
	
}