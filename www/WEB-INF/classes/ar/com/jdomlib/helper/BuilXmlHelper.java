package ar.com.jdomlib.helper;

import java.io.FileOutputStream;
import java.io.IOException;

import javax.xml.parsers.ParserConfigurationException;

import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.Text;
import org.jdom2.output.Format;
import org.jdom2.output.XMLOutputter;

import ar.com.jdomlib.models.Node;
import ar.com.jdomlib.models.TagAttribute;
import ar.com.jdomlib.models.Attribute;
import ar.com.jdomlib.models.TagLabel;
import ar.com.jdomlib.models.TagText;

public class BuilXmlHelper {
	
	  protected static void Recursive (Document doc , Node node    , Element root )
	  {  
		  if ( node.getChildren() != null ) {
			  
			  for ( Node nodeChild : node.getChildren()  ) 
			  {  
				  Element child = null;				  
				  if (  nodeChild.getData() instanceof TagAttribute) {
					  
					  TagAttribute tagAttribute = (TagAttribute)nodeChild.getData();
					  child = new Element(((TagLabel)nodeChild.getData()).getName());					  
					  for (Attribute attr : tagAttribute.getAttributes())
					  {						  
						  child.setAttribute(attr.getKey(), attr.getValue());						
					  }
				  }	
				  else if (  nodeChild.getData() instanceof TagText) {
					  
					  TagText tagText = (TagText)nodeChild.getData();
					  child = new Element(((TagLabel)nodeChild.getData()).getName());
					  child.addContent(new Text( tagText.getText()) );				  
				  } 
				  else if (  nodeChild.getData() instanceof TagLabel) {
					  
					  child = new Element(((TagLabel)nodeChild.getData()).getName());					  
			      }
	
				  Recursive (doc, nodeChild , child );
				  root.addContent(child);
			  }
		  }	
	  }
	
	
	public static void toXml (Node node , String file) throws IOException, ParserConfigurationException 
	{	
		Document doc = new Document();
		
		Element SNN = new Element(((TagLabel)node.getData()).getName());
		
		Recursive(doc, node , SNN );
		
		doc.addContent(SNN);
		
		XMLOutputter xmlOutputter = new XMLOutputter(Format.getPrettyFormat());
      
	    xmlOutputter.output(doc, new FileOutputStream(file));		
		
	}	
	
	public static void toXml (Node node , String file , String format ) throws IOException, ParserConfigurationException 
	{	
		Document doc = new Document();
		
		Element SNN = new Element(((TagLabel)node.getData()).getName());
		
		Recursive(doc, node , SNN );
		
		doc.addContent(SNN);
		
        Format _format = Format.getPrettyFormat();
        
        _format.setEncoding(format);		
		
		XMLOutputter xmlOutputter = new XMLOutputter(_format);
      
	    xmlOutputter.output(doc, new FileOutputStream(file));		
		
	}	
	
	
}
