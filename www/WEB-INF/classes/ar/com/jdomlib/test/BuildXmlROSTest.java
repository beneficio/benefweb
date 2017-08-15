package ar.com.jdomlib.test;

import java.io.IOException;
import java.util.LinkedList;
import java.util.List;

import javax.xml.parsers.ParserConfigurationException;

import ar.com.jdomlib.helper.BuilXmlHelper;
import ar.com.jdomlib.models.Attribute;
import ar.com.jdomlib.models.Node;
import ar.com.jdomlib.models.TagAttribute;
import ar.com.jdomlib.models.TagLabel;
import ar.com.jdomlib.models.TagText;



public class BuildXmlROSTest {

	 public static void main(String args[])  {
		 
		 //Node SSN = new Node(new TagLabel("SSN"));
			 
		 //Node SSN1 = new Node("SSN");
		 
		 
		//Cabecera --------------------->
		  Node Cabecera = new Node(new TagLabel("Cabecera"));
		  Node Version = new Node((new TagText("Version","1")));			  
		  List<Attribute> lAttrProd = new LinkedList <Attribute>();
		  lAttrProd.add( new Attribute("TipoPersona","1"));
		  lAttrProd.add( new Attribute("CUIT","20123456784"));
		  lAttrProd.add( new Attribute("Matricula","9999"));		  
		  Node Productor  = new Node((new TagAttribute("Productor",lAttrProd )));		  		  
		  Node CantidadRegistros = new Node((new TagText("CantidadRegistros","1")));
		  
		  Cabecera.addChildren(Version);
		  Cabecera.addChildren(Productor); 
		  Cabecera.addChildren(CantidadRegistros);
				  
		  // Registro ------------------------		  
		  Node Registro = new Node(new TagLabel("Registro"));		  
		  Node NroOrden = new Node((new TagText("NroOrden","10")));		  
		  Node FechaRegistro = new Node((new TagText("FechaRegistro","2011-12-05")));
		      
		  //       Asegurados --------------
		  Node Asegurados = new Node(new TagLabel("Asegurados"));
		  // Lista de asegurados
		  List<Attribute> lAttrAseg1 = new LinkedList <Attribute>();
		  lAttrAseg1.add( new Attribute("TipoAsegurado","1"));
		  lAttrAseg1.add( new Attribute("NroDoc","12345678"));
		  lAttrAseg1.add( new Attribute("Nombre","Jos� P�rez"));		  
		  Node asegurado1  = new Node((new TagAttribute("Asegurado",lAttrAseg1 )));
		//<Asegurado TipoAsegurado="1" NroDoc="23456789" Nombre="Nicolas Quiroga" />
		  Asegurados.addChildren(asegurado1);		  
		  //       -------------------------
		  Node CPAProponente = new Node((new TagText("CPAProponente","C1090AAX")));	  
	
		  Node ObsProponente = new Node((new TagText("ObsProponente","Esto es una observaci�n de un proponente")));
				  
		  Node CPACantidad =  new Node((new TagText("CPACantidad","2")));

		  Node CodigosPostales = new Node(new TagLabel("CodigosPostales"));	  		  
		  // Lista de codigos postales
		  Node CPA1 = new Node((new TagText("CPA","C1091AAN")));
		  Node CPA2 = new Node((new TagText("CPA","C1067ABC")));
         CodigosPostales.addChildren(CPA1);
         CodigosPostales.addChildren(CPA2);
		  /*
		   * 
          */
         Node CiaID =  new Node((new TagText("CiaID","9999")));
         Node BienAsegurado =  new Node((new TagText("BienAsegurado","900000")));
         Node Ramo =  new Node((new TagText("Ramo","2")));
         Node SumaAsegurada =  new Node((new TagText("SumaAsegurada","90000")));
	      
	      /*
	      <SumaAseguradaTipo>1</SumaAseguradaTipo>
	      <Cobertura FechaDesde="2012-01-01" FechaHasta="2012-12-01" />
	      <Observacion Tipo="1" Poliza="12152" />
	      <Flota>0</Flota>
	      <OperacionOrigen>1</OperacionOrigen>			  
		  */
		  
		  Registro.addChildren(NroOrden);		  
		  Registro.addChildren(FechaRegistro);
		  Registro.addChildren(Asegurados);	
		  Registro.addChildren(CPAProponente);
		  Registro.addChildren(ObsProponente);
		  Registro.addChildren(CPACantidad);
		  Registro.addChildren(CodigosPostales );
		  
		  Registro.addChildren(CiaID);
		  Registro.addChildren(BienAsegurado);
		  Registro.addChildren(Ramo);
		  Registro.addChildren(SumaAsegurada);		  
		  
		  // ------------------------
		  
		  Node SSN = new Node(new TagLabel("SSN"));
		  SSN.addChildren(Cabecera);
		  
		  Node detalle = new Node(new TagLabel("Detalle"));
		  detalle.addChildren(Registro);
		  
		  SSN.addChildren(detalle);		 
		 try {
			BuilXmlHelper.toXml(SSN,"D:/Usuarios/SUP/proyecto/surassur/ROS_SSN.xml");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	 }
}
