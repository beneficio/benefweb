package ar.com.jdomlib.models;


public class TagText extends TagLabel{

	private String text ;	
	
	public TagText (String name , String text) 
	{
		super(name);		
		this.text = text;
	} 
	
	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}
	
	
}

