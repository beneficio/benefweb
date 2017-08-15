package ar.com.surassur.models.lr;

import java.io.IOException;
import java.util.List;    

import javax.xml.parsers.ParserConfigurationException;

import ar.com.jdomlib.helper.BuilXmlHelper;
import ar.com.jdomlib.models.Node;
import ar.com.jdomlib.models.TagLabel;
     
public class ROS 
{
	private static String SSN     = "SSN";	
	private static String Detalle = "Detalle";
	
	private Cabecera cabecera;	
	private List<RegistroROS> registros ;
	
	public ROS (Cabecera cabecera , List<RegistroROS> registros) 
	{	
		this.cabecera = cabecera;
		this.registros = registros;
	}
	
	public Node getROS ()
	{	
		Node SSN = new Node(new TagLabel(this.SSN));		
		Node Detalle = new Node (new TagLabel(this.Detalle));
		
	    if ( this.registros!=null ) 
	        {
	        	List<RegistroROS> lReg = this.registros;	
	    		for (RegistroROS  reg :  lReg ) 
	    		{
	    			Node registroROS = reg.getNodeRegistroROS();
	    			Detalle.addChildren(registroROS);
	    		}	        	
	    }		
		SSN.addChildren(this.cabecera.getNodeCabecera()); 		 
		SSN.addChildren(Detalle); 	
	
		return SSN;		
	}
	
	public void BuildXxmlROS ( String file ) throws IOException, ParserConfigurationException 
	{
		Node SSN = this.getROS();
		
		BuilXmlHelper.toXml(SSN,file);
		
	} 
	  
	public void BuildXxmlROS ( String file , String format  ) throws IOException, ParserConfigurationException 
	{
		Node SSN = this.getROS();
		
		BuilXmlHelper.toXml(SSN,file , format);
		
		
	} 	
	
	
}
