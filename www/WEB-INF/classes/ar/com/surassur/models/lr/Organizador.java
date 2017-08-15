package ar.com.surassur.models.lr;
          
import ar.com.jdomlib.models.Attribute;
import ar.com.jdomlib.models.Node;
import ar.com.jdomlib.models.TagAttribute;
import java.util.LinkedList;
import java.util.List;     

public class Organizador 
{
    private static String Organizador = "Organizador";
    private static String TipoPersona = "TipoPersona";	
    private static String Matricula = "Matricula";
    
	private String tipoPersona;  
	public String getTipoPersona() {
		return tipoPersona;
	}

	public String getCuit() {
		return cuit;
	}
      
	public String getMatricula() {
		return matricula;
	}

	private String cuit;
	private String matricula;
	
	public Organizador (String tipoPersona ,  String matricula , String cuit ) {
		this.tipoPersona = tipoPersona;
		this.cuit = cuit;
		this.matricula  = matricula;
	}     
        
	public Node getNodeOrganizador ()
	{	
		List<Attribute> lAttrOrg1 = new LinkedList <Attribute>();
		lAttrOrg1.add( new Attribute( this.TipoPersona, this.tipoPersona));
		lAttrOrg1.add( new Attribute( this.Matricula, this.matricula));
		Node organizador  = new Node((new TagAttribute(this.Organizador,lAttrOrg1 )));
		return organizador ;
	}
        
}
