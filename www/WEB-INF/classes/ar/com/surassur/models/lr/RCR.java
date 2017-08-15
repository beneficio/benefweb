package ar.com.surassur.models.lr;

import java.io.IOException;
import java.util.List;

import javax.xml.parsers.ParserConfigurationException;

import ar.com.jdomlib.helper.BuilXmlHelper;
import ar.com.jdomlib.models.Node;
import ar.com.jdomlib.models.TagLabel;
   
public class RCR {
	
	private static String SSN     = "SSN";	
	private static String Detalle = "Detalle";
	
	private Cabecera cabecera;	
	private List<RegistroRCR> registros ;
	
	public RCR (Cabecera cabecera , List<RegistroRCR> registros) 
	{	
		this.cabecera = cabecera;
		this.registros = registros;
	}
	
	public Node getRCR ()
	{	
		Node SSN = new Node(new TagLabel(this.SSN));
		
		Node Detalle = new Node (new TagLabel(this.Detalle));
		
	    if ( this.registros!=null ) 
	        {
	        	List<RegistroRCR> lReg = this.registros;	
	    		for (RegistroRCR  reg :  lReg ) 
	    		{
	    			Node registroRCR = reg.getNodeRegistroRCR();
	    			Detalle.addChildren(registroRCR);
	    		}	        	
	    }		
		SSN.addChildren(this.cabecera.getNodeCabecera()); 		 
		SSN.addChildren(Detalle); 	
	
		return SSN;		
	}
	
	public void BuildXxmlRCR ( String file ) throws IOException, ParserConfigurationException 
	{
		Node SSN = this.getRCR();
		
		BuilXmlHelper.toXml(SSN,file);
		
	}
	
	public void BuildXxmlRCR ( String file , String format) throws IOException, ParserConfigurationException 
	{
		Node SSN = this.getRCR();
		
		BuilXmlHelper.toXml(SSN,file,format);
		
	} 	
}

