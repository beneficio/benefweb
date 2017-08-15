package ar.com.surassur.models.lr;
      
import java.util.LinkedList;
import java.util.List;

import ar.com.jdomlib.models.Attribute;
import ar.com.jdomlib.models.Node;
import ar.com.jdomlib.models.TagAttribute;
import ar.com.jdomlib.models.TagLabel;
import ar.com.jdomlib.models.TagText;
    
public class Cabecera 
{	
	private static String Cabecera = "Cabecera";
	private static String Version = "Version";	
	private static String TipoPersona = "TipoPersona";
	private static String CUIT = "CUIT";
	private static String Productor = "Productor";
	private static String Matricula = "Matricula";
	private static String CantidadRegistros = "CantidadRegistros";
	
	private String version;
	private String tipoPersona;
	private String cuit;
	private String matricula;
	private String cantidadRegistros;
	
	public Cabecera ( String version,
			          String tipoPersona ,
			          String cuit ,
			          String matricula ,
			          String cantidadRegistros 
			          ) 
	{
		this.version = version;
		this.tipoPersona = tipoPersona;
		this.cuit = cuit;
		this.matricula = matricula;
		this.cantidadRegistros = cantidadRegistros;
	}
	
	public Node getNodeCabecera () {
		Node Cabecera = new Node(new TagLabel( this.Cabecera));
		Node Version = new Node((new TagText ( this.Version,this.version)));			  
		List<Attribute> lAttrProd = new LinkedList <Attribute>();
		lAttrProd.add( new Attribute(this.TipoPersona,this.tipoPersona));
		lAttrProd.add( new Attribute(this.Matricula,this.matricula));
	//	lAttrProd.add( new Attribute(this.CUIT,this.cuit));				  
		Node Productor  = new Node((new TagAttribute(this.Productor,lAttrProd )));		  		  
		Node CantidadRegistros = new Node((new TagText(this.CantidadRegistros,this.cantidadRegistros)));	  
	//	Cabecera.addChildren(Version);
		Cabecera.addChildren(Productor); 
		Cabecera.addChildren(CantidadRegistros);
		return Cabecera;
	}
	
}

