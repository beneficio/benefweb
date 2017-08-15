package ar.com.surassur.models.lr;

import java.util.LinkedList;
import java.util.List;

import ar.com.jdomlib.models.Attribute;
import ar.com.jdomlib.models.Node;
import ar.com.jdomlib.models.TagAttribute;
import ar.com.jdomlib.models.TagLabel;
import ar.com.jdomlib.models.TagText;

public class RegistroRCR 
{
	private static String Registro      = "Registro";
	private static String TipoRegistro  ="TipoRegistro";
	private static String FechaRegistro ="FechaRegistro";
	private static String Concepto      ="Concepto";
	private static String Polizas       ="Polizas";
	private static String Poliza        ="Poliza";
	private static String CiaID         ="CiaID";
	private static String Importe       ="Importe";
	private static String ImporteTipo   ="ImporteTipo";
	
	private static String Organizador = "Organizador"; 
	private static String TipoPersona = "TipoPersona";
	private static String Matricula = "Matricula";
	private static String CUIT = "CUIT";
	
	private String tipoRegistro;
	private String fechaRegistro;
	private String concepto;		
	private String ciaID;	
	private String importe;
	private String importeTipo;		
	List<String>   polizas;	
	private Organizador organizador;
	
	public RegistroRCR ( String tipoRegistro,
	                     String fechaRegistro,
	                     String concepto,	                    	
	                     String ciaID,	                     
	                     String importe,
	                     String importeTipo,
	                     List<String> polizas,	                 	 
	                     Organizador organizador
	                     ) 
	{
		this.tipoRegistro =tipoRegistro; 
		this.fechaRegistro =fechaRegistro;
		this.concepto =concepto;			
		this.ciaID =ciaID;        
		this.importe =importe;
		this.importeTipo =importeTipo;
		this.polizas = polizas;
		this.organizador = organizador;		
	}
	
	public Node getNodeRegistroRCR () 
	{
		Node Registro = new Node(new TagLabel( this.Registro));
		
		Node TipoRegistro = new Node((new TagText(this.TipoRegistro ,this.tipoRegistro)));
		
		Node FechaRegistro = new Node((new TagText(this.FechaRegistro ,this.fechaRegistro)));
		
		Node Concepto = new Node((new TagText(this.Concepto ,this.concepto)));
		
		Node Polizas = new Node((new TagLabel(this.Polizas )));
		
        if ( this.polizas!=null ) 
        {        	
        	List<String> lPoliza = this.polizas;
    		for (String  poliza :  lPoliza ) 
    		{
    			Node Poliza = new Node((new TagText(this.Poliza,poliza)));    			
    			Polizas.addChildren(Poliza);
    		}
        }
        
        Node CiaID = null;
        if (this.ciaID != null) {
        	CiaID = new Node((new TagText(this.CiaID ,this.ciaID)));
        }
        
        
		List<Attribute> lAttrOrg = new LinkedList <Attribute>();
		
		Node Organizador = null;
		if (organizador != null) 
		{
			lAttrOrg.add( new Attribute(this.TipoPersona,organizador.getTipoPersona()));
			lAttrOrg.add( new Attribute(this.Matricula,organizador.getMatricula()));
		//	lAttrOrg.add( new Attribute(this.CUIT,organizador.getCuit()));				  
			Organizador  = new Node((new TagAttribute(this.Organizador,lAttrOrg )));			
		} 
		
		Node Importe = new Node((new TagText(this.Importe ,this.importe)));
		
		Node ImporteTipo = new Node((new TagText(this.ImporteTipo ,this.importeTipo)));
		
		Registro.addChildren(TipoRegistro);
		Registro.addChildren(FechaRegistro);
		Registro.addChildren(Concepto);
		Registro.addChildren(Polizas);
		if (CiaID != null) 
		{
			Registro.addChildren(CiaID);
		}
		if (Organizador!= null)
		{
			Registro.addChildren(Organizador);
		}
		Registro.addChildren(Importe);
		Registro.addChildren(ImporteTipo);		
		
		
		return Registro;
	}	
}

