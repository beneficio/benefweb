package ar.com.surassur.test.lr;

import java.io.IOException;
import java.util.LinkedList;
import java.util.List;
import javax.xml.parsers.ParserConfigurationException;
import ar.com.surassur.models.lr.Cabecera;
import ar.com.surassur.models.lr.Organizador;
import ar.com.surassur.models.lr.RCR;
import ar.com.surassur.models.lr.RegistroRCR;
/*
 * ***************** *
 * FORMATO - EJEMPLO *
 * ***************** *
 * 
 *  
 <?xml version='1.0' encoding='utf-8' ?>
<SSN>
<Cabecera>
	<Version>1</Version>
	<Productor TipoPersona="1" Matricula="69083" CUIT="20361584792"/>
	<CantidadRegistros>1</CantidadRegistros>
</Cabecera>
<Detalle>
	<Registro>
		<TipoRegistro>2</TipoRegistro>
		<FechaRegistro>2011-12-05</FechaRegistro>
		<Concepto>Cuota Nº 1/6. Recibo Nº 7878</Concepto>
		<Polizas>
			<Poliza>10212</Poliza>
			<Poliza>10213</Poliza>
		</Polizas>
		<CiaID></CiaID>
		<Organizador TipoPersona="1" Matricula="12345" CUIT"20361584792"/>
		<Importe>1410</Importe>
		<ImporteTipo>1</ImporteTipo>
	<	/Registro>
	</Detalle>

</SSN>
 
 * 
 */

public class RCRTest {	
	//**
	
	
	 public static void main(String args[])  
	 {
	     String Version 				= "1";
		 String Productor_TipoPersona	= "1";
		 String Productor_CUIT 			= "20361584792";
		 String Productor_Matricula 	= "69083";
		 String CantidadRegistros 		= "1";
		 
		 Cabecera cabecera = new Cabecera( Version,
				                           Productor_TipoPersona,
				                           Productor_CUIT,
				                           Productor_Matricula,
				 						   CantidadRegistros);			 
		 
		 
		 
		 List<RegistroRCR> registros = new LinkedList<RegistroRCR>();
		 for (int i = 0 ; i <=0 ; i++ )
		 {     
			 List<String> polizas = new LinkedList<String>();		 
			 polizas.add("10212");
			 polizas.add("10213");				 
			 String tipoRegistro = "2";
			 String fechaRegistro = "2011-12-05";
			 String concepto = "Cuota Nº 1/6. Recibo Nº 7878";
			 /*
			    <CiaID></CiaID>
				Marca para indicar el código de la entidad aseguradora. En caso de tratarse de una rendición a un
				Organizador, esta marca no deberá existir.
			 */				 
			 String ciaId        = /*null;*/  "12" ; 
			 String importe      = "1410";
			 String importeTipo  = "1";
			 String orgTipoPers  = "1";
			 String orgMatricula = "12345";
			 String orgCuit      = "20361584792";
			 /*
			   <Organizador TipoPersona=”” Matricula=”” CUIT=””></Organizador>
				Marca que indica el tipo de productor, el número de matrícula y el CUIT. El valor para
				TipoPersona será: 1 para persona física o 2 para persona jurídica. El valor para Matricula será el
				número de matrícula del productor y la CUIT, la correspondiente también al productor.
				En caso de no haber un Organizador, porque está realizándose una operación para una Entidad
				Aseguradora, esta marca no deberá existir
				**/
			 Organizador organizador = /*null ;*/ new Organizador (orgTipoPers,orgMatricula,orgCuit);
			 registros.add( new RegistroRCR ( tipoRegistro,
					                          fechaRegistro,
					                          concepto,
					                          ciaId,
					                          importe,
					                          importeTipo , 
					                          polizas ,
					                          organizador 
			                                ));
		 }				 	
		 
		 RCR rcr = new RCR (cabecera,registros);
		 
		 try 
		 {
		     rcr.BuildXxmlRCR("RCR.xml");
		 } catch (IOException e) 
		 {
		     e.printStackTrace();
		 } catch (ParserConfigurationException e) 
		 {
			e.printStackTrace();
		 }
		 
		 
		 RCR rcrUTF8 = new RCR (cabecera,registros);
		 
		 try 
		 {
			 rcrUTF8.BuildXxmlRCR("RCR-UTF8.xml","UTF-8");
		 } catch (IOException e) 
		 {
		     e.printStackTrace();
		 } catch (ParserConfigurationException e) 
		 {
			e.printStackTrace();
		 }		 
		 
		 
	 }	
}
