package ar.com.surassur.models.lr;


import java.util.List;
import ar.com.jdomlib.models.Node;
import ar.com.jdomlib.models.TagLabel;
import ar.com.jdomlib.models.TagText;
   
public class RegistroROS 
{	
	private static String Registro = "Registro";	
//	private static String NroOrden = "NroOrden";	
	private static String FechaRegistro = "FechaRegistro";     
	private static String Asegurados = "Asegurados";
	private static String CPAProponente = "CPAProponente";
	private static String ObsProponente = "ObsProponente";
	private static String CPACantidad = "CPACantidad";     
	private static String CodigosPostales = "CodigosPostales";
	private static String CPA = "CPA";
	private static String CiaID = "CiaID";
        private static String Organizador = "Organizador";
	private static String BienAsegurado = "BienAsegurado";
	private static String Ramo = "Ramo";
	private static String SumaAsegurada = "SumaAsegurada";	
	/**/	
	private static String SumaAseguradaTipo = "SumaAseguradaTipo";
//	private static String Cobertura = "Cobertura";
	private static String CoberturaFechaDesde = "CoberturaFechaDesde";
	private static String CoberturaFechaHasta = "CoberturaFechaHasta";
//	private static String Observacion = "Observacion";
	private static String TipoOperacion = "TipoOperacion";
	private static String Poliza = "Poliza";
	private static String Flota = "Flota";
//	private static String OperacionOrigen="OperacionOrigen";
        private static String TipoContacto = "TipoContacto";
	/**/
	
	private String nroOrden ;
	private String fechaRegistro  ;     	
	private String cpaProponente;
	private String obsProponente;
	private String cpaCantidad ;     	
	private String ciaID ;
        private Organizador organizador;
	private String bienAsegurado ;
	private String ramo;
	private String sumaAsegurada ;	
	private String sumaAseguradaTipo;
	private String coberturaFechaDesde;
	private String coberturaFechaHasta;
	private String observacionTipo;
//	private String observacionPoliza;
	private String flota;
	private String operacionOrigen;	
	private List<String> codigosPostales ;
	private List<Asegurado> asegurados;
        private String tipoContacto;
        private String tipoOperacion;
        private String poliza;
    
        public RegistroROS ( //String nroOrden ,
                                String fechaRegistro  ,
                                String cpaProponente,
                                String obsProponente,
                                String cpaCantidad ,
                                String ciaID ,
                                String bienAsegurado ,
                                String ramo,
                                String sumaAsegurada ,			             
                                String sumaAseguradaTipo,
                                String coberturaFechaDesde,
                                String coberturaFechaHasta,
                              //  String observacionTipo,
                //                String observacionPoliza,		
                                String flota,
                              //  String operacionOrigen,
                                String tipoOperacion,
                                String tipoContacto,
                                List<Asegurado> asegurados ,
                                List<String> codigosPostales,
                                Organizador organizador,
                                String poliza) 
	{
	//   this.nroOrden            = nroOrden;
	   this.fechaRegistro       = fechaRegistro;
	   this.cpaProponente       = cpaProponente;
	   this.obsProponente       = obsProponente;
	   this.cpaCantidad         = cpaCantidad;
	   this.ciaID               = ciaID;
	   this.bienAsegurado       = bienAsegurado;
	   this.ramo                = ramo;
	   this.sumaAsegurada       = sumaAsegurada;	
   	   this.sumaAseguradaTipo   = sumaAseguradaTipo;
   	   this.coberturaFechaDesde = coberturaFechaDesde;
   	   this.coberturaFechaHasta = coberturaFechaHasta; 
   	//   this.observacionTipo     = observacionTipo; 
   	//   this.observacionPoliza   = observacionPoliza; 	
   	   this.flota               = flota ;
   	//   this.operacionOrigen     = operacionOrigen;
	   this.asegurados          = asegurados;
	   this.codigosPostales     = codigosPostales;
           this.tipoOperacion       = tipoContacto;
           this.tipoContacto        = tipoContacto;
           this.organizador         = organizador;
           this.poliza              = poliza;
	   
	}
	       
	public Node getNodeRegistroROS () 
	{		
		Node Registro      = new Node(new TagLabel( this.Registro));
	//	Node NroOrden      = new Node((new TagText(this.NroOrden ,this.nroOrden)));		
		Node FechaRegistro = new Node((new TagText(this.FechaRegistro, this.fechaRegistro )));
		Node Asegurados    = new Node(new TagLabel(this.Asegurados));
        if ( this.asegurados!= null ) 
        {
        	List<Asegurado> lAseg = this.asegurados;	
    		for (Asegurado  aseg :  lAseg ) 
    		{
    			Node asegurado = aseg.getNodeAsegurado();
    			Asegurados.addChildren(asegurado);
    		}        	
        }
				
		Node CPAProponente = new Node((new TagText(this.CPAProponente, this.cpaProponente)));
		Node ObsProponente = new Node((new TagText( this.ObsProponente,this.obsProponente)));
		Node CPACantidad =  new Node((new TagText(this.CPACantidad,this.cpaCantidad)));
		Node CodigosPostales = new Node(new TagLabel(this.CodigosPostales));
		
        if ( this.codigosPostales!=null ) 
        {        	
        	List<String> lCpa = this.codigosPostales;
    		for (String  cpa :  lCpa ) 
    		{
    			Node CPA = new Node((new TagText(this.CPA,cpa)));    			
    			CodigosPostales.addChildren(CPA);
    		}
        }	
        
        Node CiaID             =  new Node((new TagText(this.CiaID, this.ciaID)));
        
        Node Organizador       = null;
        if (this.organizador != null ) {
            Organizador       =  this.organizador.getNodeOrganizador();
        }    
        Node BienAsegurado     =  new Node((new TagText(this.BienAsegurado, this.bienAsegurado)));
        Node Ramo              =  new Node((new TagText(this.Ramo,this.ramo)));
        Node SumaAsegurada     =  new Node((new TagText(this.SumaAsegurada, this.sumaAsegurada)));               
        Node SumaAseguradaTipo =  new Node((new TagText(this.SumaAseguradaTipo, this.sumaAseguradaTipo)));
        Node CoberturaFechaDesde = new Node((new TagText(this.CoberturaFechaDesde, this.coberturaFechaDesde)));
        Node CoberturaFechaHasta = new Node((new TagText(this.CoberturaFechaHasta, this.coberturaFechaHasta)));
        
	//	List<Attribute> lAttrCob = new LinkedList <Attribute>();
	//	lAttrCob.add( new Attribute(this.FechaDesde, this.coberturaFechaDesde));
	//	if (this.coberturaFechaHasta != null) {
	//		lAttrCob.add( new Attribute(this.FechaHasta, this.coberturaFechaHasta));
	//	}
	//	Node Cobertura  = new Node((new TagAttribute(this.Cobertura,lAttrCob )));		       	
       	
        Node TipoOperacion = new Node ((new TagText(this.TipoOperacion, this.tipoOperacion)));
        
	//	List<Attribute> lAttrObs = new LinkedList <Attribute>();
	//	lAttrObs.add( new Attribute(this.Tipo, this.observacionTipo));
	//	if (this.observacionPoliza!=null ) {
        //            if (! this.observacionTipo.equals("1") ) {
	//		lAttrObs.add( new Attribute(this.Poliza, this.observacionPoliza));
        //           }
	//	}
        Node Poliza = new Node ((new TagText(this.Poliza, this.poliza)));
        
	//Node Observacion  = new Node((new TagAttribute(this.Observacion,lAttrObs )));			
		
        Node Flota =  new Node((new TagText(this.Flota, this.flota)));
        Node TipoContacto = new Node((new TagText(this.TipoContacto, this.tipoContacto)));
        
        //Node OperacionOrigen =  new Node((new TagText(this.OperacionOrigen, this.operacionOrigen)));
       
		Registro.addChildren(FechaRegistro);
		Registro.addChildren(Asegurados);	
		Registro.addChildren(CPAProponente);
		Registro.addChildren(ObsProponente);
		Registro.addChildren(CPACantidad);
		Registro.addChildren(CodigosPostales );
		Registro.addChildren(CiaID);
                if ( Organizador != null ) {
                    Registro.addChildren(Organizador);
                }
		Registro.addChildren(BienAsegurado);
		Registro.addChildren(Ramo);
		Registro.addChildren(SumaAsegurada);			
		Registro.addChildren(SumaAseguradaTipo);
                Registro.addChildren(CoberturaFechaDesde);
                Registro.addChildren(CoberturaFechaHasta);
                Registro.addChildren(TipoOperacion);
                Registro.addChildren(Poliza);
         	Registro.addChildren(Flota);		
		Registro.addChildren(TipoContacto);  
		return Registro ; 
		
	}
}        
