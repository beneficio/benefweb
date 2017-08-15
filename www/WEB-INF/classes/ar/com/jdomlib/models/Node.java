package ar.com.jdomlib.models;

import java.util.LinkedList;
import java.util.List;


public class Node {
	private Object data ;
	
	private List<Node> children;

	public Node (){
		
	}
	
	public Node (Object data ) {
		this.data = data;
	}
	
	public Object getData() {
		return data;
	}

	public void setData(Object data) {
		this.data = data;
	}

	public List<Node> getChildren() {
		return children;
	}
    
	public void addChildren(Node child ) {
		
		if (this.children == null) {
			this.children = new LinkedList<Node>() ;			
			
		} 
		this.children.add(child);
	}
	
	public Node getChild(int childIndex) {
        return this.children.get(childIndex);
    } 	
	
}
