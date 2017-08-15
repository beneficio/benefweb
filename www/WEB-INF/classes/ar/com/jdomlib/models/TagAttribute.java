package ar.com.jdomlib.models;

import java.util.List;


public class TagAttribute extends TagLabel{

	private List<Attribute> attributes ;
	
	public TagAttribute (String name) {		
		super(name);
	}
	public TagAttribute (String name , List<Attribute> attributes) {		
		super(name);
		this.attributes =  attributes;
	}	

	public List<Attribute> getAttributes() {
		return attributes;
	}
	

	
}
