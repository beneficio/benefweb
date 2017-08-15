package ar.com.surassur.models.lr;

import java.util.LinkedList;
import java.util.List;

import ar.com.jdomlib.models.Attribute;
import ar.com.jdomlib.models.Node;
import ar.com.jdomlib.models.TagAttribute;
import ar.com.jdomlib.models.TagLabel;     
            
public class Asegurado 
{      
	
	private static String Asegurado = "Asegurado";
	private static String TipoAsegurado = "TipoAsegurado";	
	private static String TipoDoc = "TipoDoc";
	private static String NroDoc = "NroDoc";	
	private static String Nombre = "Nombre";
	
	private String tipoAsegurado;
	private String tipoDoc;
	private String nroDoc;	
	private String nombre;
	
	public Asegurado ( String tipoAsegurado , String tipoDoc , String nroDoc, String nombre) {
		this.tipoAsegurado = tipoAsegurado;
		this.tipoDoc = tipoDoc; 
		this.nroDoc = nroDoc;
		this.nombre = nombre;
	}
	
	public Node getNodeAsegurado ()
	{	
		List<Attribute> lAttrAseg1 = new LinkedList <Attribute>();
		lAttrAseg1.add( new Attribute( this.TipoAsegurado, this.tipoAsegurado));
		lAttrAseg1.add( new Attribute( this.TipoDoc, this.tipoDoc));
		lAttrAseg1.add( new Attribute( this.NroDoc, this.nroDoc));
		lAttrAseg1.add( new Attribute( this.Nombre, this.nombre));
		Node asegurado  = new Node((new TagAttribute(this.Asegurado,lAttrAseg1 )));
		return asegurado ;
	}
	
	
}
