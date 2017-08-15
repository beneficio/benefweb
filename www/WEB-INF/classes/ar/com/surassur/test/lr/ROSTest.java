package ar.com.surassur.test.lr;
/*
 * ***************** *
 * FORMATO - EJEMPLO *
 * ***************** *
 * 
 *  
 <?xml version="1.0" encoding="utf-8" ?>
<SSN>
	<Cabecera>
		<Version>1</Version>
		<Productor TipoPersona="1" Matricula="9999" CUIT="20123456784"/>
		<CantidadRegistros>1</CantidadRegistros>
	</Cabecera>

	<Detalle>
		<Registro>
			<NroOrden>10</NroOrden>
			<FechaRegistro>2011-12-05</FechaRegistro>
			<Asegurados>
				<Asegurado TipoAsegurado="1" TipoDoc="1" NroDoc="12345678" Nombre="Jos� P�rez"/>
				<Asegurado TipoAsegurado="1" TipoDoc="1" NroDoc="23456789" Nombre="Nicolas Quiroga"/>
			</Asegurados>
			<CPAProponente>C1090AAX</CPAProponente>
			<ObsProponente>Esto es una observaci�n de un proponente</ObsProponente>
			<CPACantidad>2</CPACantidad>
			<CodigosPostales>
				<CPA>C1091AAN</CPA>
				<CPA>C1067ABC</CPA>
			</CodigosPostales>
			<CiaID>9999</CiaID>
			<BienAsegurado>XXX - ABC123</BienAsegurado>
			<Ramo>1</Ramo>
			<SumaAsegurada>85000</SumaAsegurada>
			<SumaAseguradaTipo>1</SumaAseguradaTipo>
			<Cobertura FechaDesde="2012-01-01" FechaHasta="2012-12-01"/>
			<Observacion Tipo="1" Poliza="12152"/>
			<Flota>0</Flota>
			<OperacionOrigen>1</OperacionOrigen>
		</Registro>

	</Detalle>

</SSN>
 
 * 
 */
import java.io.IOException;
import java.util.LinkedList;
import java.util.List;

import javax.xml.parsers.ParserConfigurationException;

import ar.com.jdomlib.helper.BuilXmlHelper;
import ar.com.jdomlib.models.Node;
import ar.com.jdomlib.models.TagLabel;
import ar.com.surassur.models.lr.Asegurado;
import ar.com.surassur.models.lr.Cabecera;
import ar.com.surassur.models.lr.ROS;
import ar.com.surassur.models.lr.RegistroROS;

public class ROSTest {

	
	 public static void main(String args[])  
	 {
                String Version 			= "1";
                String Productor_TipoPersona	= "1";
                String Productor_CUIT		= "20123456784";
                String Productor_Matricula 	= "9999";
                String CantidadRegistros	= "1";
		 
		 Cabecera cabecera = new Cabecera( Version,
				                           Productor_TipoPersona,
				 						   Productor_CUIT,
				 						   Productor_Matricula,
				 						   CantidadRegistros);		 
		 
		 List<RegistroROS> registros = new LinkedList<RegistroROS>();
		 for (int i = 0 ; i <=0 ; i++ )
		 {
			 List<String> cpas = new LinkedList<String>();		 
			 cpas.add("C1091AAN");
			 cpas.add("C1067ABC");		 
			 List<Asegurado> lAseg = new LinkedList<Asegurado>();
			 Asegurado aseg1 = new Asegurado("1","1","12345678","Jos� P�rez");
			 Asegurado aseg2 = new Asegurado("1","1","23456789","Nicolas Quiroga");
			 lAseg.add(aseg1);
			 lAseg.add(aseg2);
 
			 
			 String nroOrden       = "10"; 
          	 String fechaRegistro  = "2011-12-05";
             String cpaProponente  = "C1090AAX";
             String obsProponente  = "Esto es una observaci�n de un proponente";
             String cpaCantidad    = "2";
             String ciaID          = "9999";
             String bienAsegurado  = "XXX - ABC123";
             String ramo           = "1";
             String sumaAsegurada  = "85000";
             
             String sumaAseguradaTipo    = "1";
			 String cobertura_FechaDesde ="2012-01-01";
			 String cobertura_FechaHasta = "2012-12-01" ;//null;//Ejemplo caucion <<--  // "2012-12-01"; 
			 String observacion_Tipo     ="1";
			 String observacion_Poliza   = "12152"; //null ; //Ejemplo poliza nueva /// "12152";
			 String flota                = "0";
			 String operacionOrigen      = "1";   
             
     /*                   
			 registros.add( new RegistroROS ( nroOrden ,
                                                fechaRegistro,
                                                cpaProponente,
                                                obsProponente,
                                                cpaCantidad,
                                                ciaID,
                                                bienAsegurado,
                                                ramo,
                                                sumaAsegurada , 
                                                sumaAseguradaTipo,
                                                cobertura_FechaDesde,
                                                cobertura_FechaHasta,
                                                observacion_Tipo,
                                                observacion_Poliza,
                                                flota,
                                                operacionOrigen,
                                                lAseg, 
                                                cpas) );
             */
             }
		 
		 ROS ros = new ROS (cabecera,registros);
		 try 
		 {
		     ros.BuildXxmlROS("ROS.xml");
		     
		 } catch (IOException e) 
		 {
		     e.printStackTrace();
		 } catch (ParserConfigurationException e) 
		 {
			e.printStackTrace();
		 }
		 
         // Con formato ejemplo con UTF-8  
		 ROS rosUTF8 = new ROS (cabecera,registros);
		 try 
		 {
			 rosUTF8.BuildXxmlROS("ROS-UTF8.xml","UTF-8");
		     
		 } catch (IOException e) 
		 {
		     e.printStackTrace();
		 } catch (ParserConfigurationException e) 
		 {
			e.printStackTrace();
		 }
		 
		 
		 
	 }
}
