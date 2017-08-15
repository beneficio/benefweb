package servlets;

import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.io.*;
import java.util.zip.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.business.beans.Usuario;
import com.business.util.*;
import com.business.db.db;

import ar.com.surassur.models.lr.Asegurado;  
import ar.com.surassur.models.lr.Cabecera;
import ar.com.surassur.models.lr.ROS;
import ar.com.surassur.models.lr.RegistroROS;
import ar.com.surassur.models.lr.RCR;
import ar.com.surassur.models.lr.RegistroRCR;
import ar.com.surassur.models.lr.Organizador;

import java.io.IOException;
import java.util.LinkedList;
import java.util.List;
import java.util.Date;

import javax.xml.parsers.ParserConfigurationException;
import org.omg.CosNaming.NamingContextExtPackage.StringNameHelper;
          

/**
 *
 * @author  surprogra
 * @version
 */     
public class LibrosDigitalesServlet extends HttpServlet {

    private static final int BUFFER_SIZE = 1024;
    
    /** Initializes the servlet.
     */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }    
    /** Destroys the servlet.
     */
    public void destroy() {
    }
    
    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
      try {
//Chequeo si el usuario esta logueado o no ocurrio un timeout
        if (!ValidadorSesion.Validar(request, response, this)) return; 
          
        String op =  request.getParameter ("opcion");
        
        if (op.equals ("get_emision")) { // filtrado de polizas
           LibroEmision (request,response);
        } else if (op.equals ("get_cobranza")) {  // nuevo endoso
            LibroCobranza  (request,response);
        }
      } catch (SurException se) {
            goToJSPError (request,response, se);
      }
    }

    protected void LibroEmision (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        ResultSet rs = null;
        CallableStatement cons = null;
        Connection dbCon = null;
	FileInputStream fis = null;
        FileOutputStream fos = null;
        ZipOutputStream zipos = null;        
        
        try {
           HttpSession sesion   = request.getSession();
           Usuario user    = (Usuario) sesion.getAttribute("user");
           int codProd     = Integer.parseInt (request.getParameter ("cod_prod"));
           String sDesde   = request.getParameter("fecha_desde");
           String sHasta   = request.getParameter("fecha_hasta");
           Date fechaDesde = Fecha.strToDate ( sDesde );
           Date fechaHasta = Fecha.strToDate ( sHasta );
           java.sql.Date   dFecha_desde  = Fecha.convertFecha(fechaDesde);
           java.sql.Date   dFecha_hasta  = Fecha.convertFecha(fechaHasta);

           String sLink = getServletConfig().getServletContext ().getRealPath("/files/libros/ROS_" + String.valueOf (codProd) + "_" + sDesde.replace("/", "") + "_" + sHasta.replace ("/","") + ".xml");
           String pZipFile = getServletConfig().getServletContext ().getRealPath("/files/libros/ROS_" + String.valueOf (codProd) + "_" + sDesde.replace("/", "") + "_" + sHasta.replace ("/","") + ".zip");
           String sLinkLog      = getServletConfig().getServletContext ().getRealPath("/files/libros/ROS_" + String.valueOf (codProd) + "_" + sDesde.replace("/", "") + "_" + sHasta.replace ("/","") + ".csv");
           String sLinkRelativo     = "files/libros/ROS_" + String.valueOf (codProd) +"_" + sDesde.replace("/", "") + "_" + sHasta.replace ("/","") + ".zip";
           String sLinkLogRelativo  = "files/libros/ROS_" + String.valueOf (codProd) +"_" + sDesde.replace("/", "") + "_" + sHasta.replace ("/","") + ".csv";
           String sNombre = "ROS_" + String.valueOf (codProd) +"_" + sDesde.replace("/", "") + "_" + sHasta.replace ("/","") + ".xml";
           

           FileOutputStream fosLog = new FileOutputStream ( sLinkLog );
           OutputStreamWriter osw = new OutputStreamWriter (fosLog); //, "8859_1");
           BufferedWriter bwLog = new BufferedWriter (osw);
           
// titulos del log
           StringBuilder sbTit = new StringBuilder();           
           sbTit.append("fecha;CPTomador;DomicilioTomador;ramo;sumaAsegurada;FechaDesde;sFechaHasta;");
           sbTit.append("TipoOperacion;sOperacionOrigen;DocTomador;RazonSocialTomador;Poliza");
           bwLog.write(sbTit.toString() + "\r\n");           

           String sEstado = "OK";
	   String Version = "1";

           dbCon = db.getConnection();
           dbCon.setAutoCommit(false);
           Usuario  oProd = new Usuario ();
           oProd.setiCodProd(codProd);
           oProd.getDBProductor(dbCon);
           
           Usuario oOrg = new Usuario ();
           oOrg.setiCodProd(oProd.getorganizador());
           oOrg.getDBProductor(dbCon);

           if (oProd.getmatricula() == 0 ) {
               sEstado = "Error al obtener los datos del productor: Matricula inexistente ";
           } else {
            String Productor_TipoPersona = (oProd.getTipoDoc().equals("80") && 
                     ( oProd.getDoc().startsWith("30") || oProd.getDoc().startsWith("33")) ? "2" : "1"); // 1 fisica , 2 juridica
            String Productor_Matricula   = String.valueOf (oProd.getmatricula());
            int cantRegistros            = 0;

            String Organizador_TipoPersona = (oOrg.getTipoDoc().equals("80") && 
                     ( oOrg.getDoc().startsWith("30") || oOrg.getDoc().startsWith("33")) ? "2" : "1"); // 1 fisica , 2 juridica
            String Organizador_Matricula   = String.valueOf (oOrg.getmatricula());

            Organizador organizador = null;
            
            if ( ! Organizador_Matricula.equals("199") &&  
                    ! Organizador_Matricula.equals("200") && 
                     ! Organizador_Matricula.equals("201") ) {
                organizador = new Organizador ( Organizador_TipoPersona,
                   Organizador_Matricula , "");
            }
             
            cons = dbCon.prepareCall(db.getSettingCall("LRD_GET_ALL_EMISION(?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);            
            cons.setDate(2, dFecha_desde );
            cons.setDate(3, dFecha_hasta );
            cons.setInt(4, codProd );
            
            cons.execute();
            rs = (ResultSet) cons.getObject(1);

//System.out.println ( rs);

            if (rs != null) {
               List<RegistroROS> registros = new LinkedList<RegistroROS>();

                while (rs.next()) {
                    StringBuilder sbLog = new StringBuilder();
                    List<Asegurado> lAseg = new LinkedList<Asegurado>();

//System.out.println ("----------------------------------------" + rs.getInt ("COD_RAMA") + " " + rs.getInt ("NUM_POLIZA") + " " + rs.getInt ("ENDOSO"));

                    String tipoPersona = "2";
                    String numDoc      = rs.getString ("CUIT");
                    if (rs.getString ("TIPO_DOC").equals("96")) {
                        tipoPersona = "1";
                        numDoc      = rs.getString ("NUM_DOC");
                    }

                    Asegurado aseg1 = new Asegurado(tipoPersona, rs.getString ("TIPO_DOC_SSN"), numDoc ,Formatos.truncate(rs.getString ("RAZON_SOCIAL"),100));
                         
                    lAseg.add(aseg1);

                    String fechaRegistro  =rs.getString ("FECHA_EMISION_END");

                    String cpaProponente = rs.getString ("COD_POSTAL");
                    String obsProponente = rs.getString ("OBS_PROPONENTE");
                    String cpaCantidad  = "1";
                    List<String> cpas = new LinkedList<String>();
                    cpas.add(cpaProponente);

                    String ciaID  = rs.getString ("CIAID");

                    String ramo = rs.getString ("RAMO");

                    String sumaAsegurada = rs.getString("SUMA_ASEGURADA");
                    String sumaAseguradaTipo = rs.getString ("TIPO_SUMA_ASEGURADA");
                    String sFechaDesde = rs.getString ("FECHA_INI_VIG_END");
                    String sFechaHasta = rs.getString ("FECHA_FIN_VIG_END");
                    String sFlota = rs.getString ("FLOTA");

                    String sTipo  = rs.getString ("TIPO_OPERACION"); 
                    String sPoliza = String.valueOf (rs.getInt ("NUM_POLIZA"));
                    String sOperacionOrigen = rs.getString ("TIPO_CONTACTO") ;

                    String bienAsegurado = rs.getString ("BIEN_A_ASEGURAR");
            
                    cantRegistros += 1;       
                    registros.add( new RegistroROS (
                                                    fechaRegistro,
                                                    Formatos.truncate(cpaProponente,8),
                                                    Formatos.truncate(obsProponente,100),
                                                    cpaCantidad,
                                                    ciaID,
                                                    bienAsegurado,
                                                    ramo,
                                                    sumaAsegurada ,
                                                    sumaAseguradaTipo,
                                                    sFechaDesde,
                                                    sFechaHasta,
                                                    sFlota,
                                                    sTipo, 
                                                    sOperacionOrigen,
                                                    lAseg,   
                                                    cpas,
                                                    organizador,     
                                                    sPoliza) );
                        
                    sbLog.append(fechaRegistro).append(";").append(Formatos.truncate(cpaProponente,8)).append(";");
                    sbLog.append(Formatos.truncate(obsProponente,100)).append(";").append(ramo).append(";");
                    sbLog.append(sumaAsegurada).append(";").append(sFechaDesde).append(";").append(sFechaHasta).append(";");
                    sbLog.append(sTipo).append(";").append(sOperacionOrigen).append(";").append(numDoc).append(";").append(Formatos.truncate(rs.getString ("RAZON_SOCIAL"),100));
                    sbLog.append (";").append(sPoliza);
                   
                    bwLog.write(sbLog.toString() + "\r\n");

                }
      

                bwLog.flush();
                bwLog.close();
                osw.close();
                fosLog.close();

//System.out.println ("salio del loop antes de setear la cabecera");

		 Cabecera cabecera = new Cabecera( Version, Productor_TipoPersona,
				 		   "", Productor_Matricula,
				 		  String.valueOf ( cantRegistros ));

		 ROS ros = new ROS (cabecera,registros);

//System.out.println ("despues de setearo la cabcera");
      
		 try     
		 {     
		     ros.BuildXxmlROS ( sLink,"UTF-8" );

// zipear archivo
                    byte[] buffer = new byte[BUFFER_SIZE];
                    try {
                        
                            // fichero a comprimir
                            fis = new FileInputStream(sLink);
                            File aComprimir = new File (sNombre);
                            OutputStream outComprimir = new FileOutputStream(aComprimir);
                            byte[] buf = new byte[BUFFER_SIZE];
                            int len1;
                            while ((len1 = fis.read(buf)) > 0) {
                              outComprimir.write(buf, 0, len1);
                            }                            
                            
                            fis = new FileInputStream(sNombre);
                            // fichero contenedor del zip
                            fos = new FileOutputStream(pZipFile);
                            // fichero comprimido
                            zipos = new ZipOutputStream(fos);

                            ZipEntry zipEntry = new ZipEntry( sNombre );
                            zipos.putNextEntry(zipEntry);
                            int len = 0;
                            // zippear
                            while ((len = fis.read(buffer, 0, BUFFER_SIZE)) != -1) 
                                    zipos.write(buffer, 0, len);
                            // volcar la memoria al disco
                            zipos.flush();
                    } catch (Exception e) {
                            throw e;
                    } finally {
                            // cerramos los files
                            zipos.close(); 
                            fis.close(); 
                            fos.close(); 
                    } // end try

		 } catch (IOException e) {
		     e.printStackTrace();
		 } catch (ParserConfigurationException e) {
			e.printStackTrace();
		 }
      

               }
            rs.close ();
            }
           cons.close ();

// setear el control de acceso
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, 39);
           
           request.setAttribute ("estado", sEstado);
           request.setAttribute ("link", sLinkRelativo);
           request.setAttribute ("linkLog", sLinkLogRelativo);
           doForward(request, response, "/librosDigitales/formSubdiario.jsp");
          
        } catch (Exception se){
           throw new SurException (se.getMessage());
        } finally {
            try {
                if (rs != null) rs.close ();
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }

    protected void LibroCobranza (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        ResultSet rs = null;
        CallableStatement cons = null;
        Connection dbCon = null;
	FileInputStream fis = null;
        FileOutputStream fos = null;
        ZipOutputStream zipos = null;        

        try {
           HttpSession sesion   = request.getSession();
           Usuario user    = (Usuario) sesion.getAttribute("user");
           int codProd     = Integer.parseInt (request.getParameter ("cod_prod"));
           String sDesde   = request.getParameter("fecha_desde");
           String sHasta   = request.getParameter("fecha_hasta");
           Date fechaDesde = Fecha.strToDate ( sDesde );
           Date fechaHasta = Fecha.strToDate ( sHasta );
           java.sql.Date   dFecha_desde  = Fecha.convertFecha(fechaDesde);
           java.sql.Date   dFecha_hasta  = Fecha.convertFecha(fechaHasta);
            int cantRegistros = 0;           

           String sLink             = getServletConfig().getServletContext ().getRealPath("/files/libros/RCR_" + String.valueOf (codProd) + "_" + sDesde.replace("/", "") + "_" + sHasta.replace ("/","") + ".xml");
           String pZipFile          = getServletConfig().getServletContext ().getRealPath("/files/libros/RCR_" + String.valueOf (codProd) + "_" + sDesde.replace("/", "") + "_" + sHasta.replace ("/","") + ".zip");
           String sLinkLog          = getServletConfig().getServletContext ().getRealPath("/files/libros/RCR_" + String.valueOf (codProd) + "_" + sDesde.replace("/", "") + "_" + sHasta.replace ("/","") + ".csv");
           String sLinkRelativo     = "files/libros/RCR_" + String.valueOf (codProd) +"_" + sDesde.replace("/", "") + "_" + sHasta.replace ("/","") + ".zip";
           String sLinkLogRelativo  = "files/libros/RCR_" + String.valueOf (codProd) +"_" + sDesde.replace("/", "") + "_" + sHasta.replace ("/","") + ".csv";           
           String sNombre  = "RCR_" + String.valueOf (codProd) +"_" + sDesde.replace("/", "") + "_" + sHasta.replace ("/","") + ".xml";           

           FileOutputStream fosLog = new FileOutputStream ( sLinkLog );
           OutputStreamWriter osw = new OutputStreamWriter (fosLog); //, "8859_1");
           BufferedWriter bwLog = new BufferedWriter (osw);
           
           String sEstado = "OK";
	   String Version = "1";

// titulos del log
           bwLog.write("tipoReg;fecha;descripcion;importe;polizas\r\n");           
           
           dbCon = db.getConnection();
           dbCon.setAutoCommit(false);
           Usuario  oProd = new Usuario ();
           oProd.setiCodProd(codProd);
           oProd.getDBProductor(dbCon);
           
           Usuario oOrg = new Usuario ();
           oOrg.setiCodProd(oProd.getorganizador());
           oOrg.getDBProductor(dbCon);

           if (oProd.getmatricula() == 0 ) {
               sEstado = "Error al obtener los datos del productor: Matricula inexistente ";
           } else {
            String Productor_TipoPersona = (oProd.getTipoDoc().equals("80") && 
                     ( oProd.getDoc().startsWith("30") || oProd.getDoc().startsWith("33")) ? "2" : "1"); // 1 fisica , 2 juridica
            String Productor_Matricula   = String.valueOf (oProd.getmatricula());

            String Organizador_TipoPersona = (oOrg.getTipoDoc().equals("80") && 
                     ( oOrg.getDoc().startsWith("30") || oOrg.getDoc().startsWith("33")) ? "2" : "1"); // 1 fisica , 2 juridica
            String Organizador_Matricula   = String.valueOf (oOrg.getmatricula());

            Organizador organizador = null;
            
            if ( ! Organizador_Matricula.equals("199") &&  
                    ! Organizador_Matricula.equals("200") && 
                     ! Organizador_Matricula.equals("201") ) {
                organizador = new Organizador ( Organizador_TipoPersona,
                   Organizador_Matricula , "");
            }
             
            cons = dbCon.prepareCall(db.getSettingCall("LRD_GET_ALL_COBRANZA(?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);            
            cons.setDate(2, dFecha_desde );
            cons.setDate(3, dFecha_hasta );
            cons.setInt(4, codProd );
            
            cons.execute();
            rs = (ResultSet) cons.getObject(1);

            if (rs != null) {
                List<RegistroRCR> registros = new LinkedList<RegistroRCR>();
                String conceptoAnt = "";
                String tipoReg  = "";
                String fecha    = "";
                String descripcion = "";
                String ciaid    = "";
                double importe  = 0; 
                String tipoImporte = ""; 
                List<String> polizas = new LinkedList<String>();               
                StringBuffer sbPol = new StringBuffer();
                
                while (rs.next() ) {
                   if ( ! rs.getString ("DESCRIPCION").equals(conceptoAnt) ) {
                        if ( ! conceptoAnt.equals("") ) {
                            StringBuffer sbLog = new StringBuffer();                            
                            cantRegistros += 1;                            
                            registros.add( new RegistroRCR (tipoReg,
                                                            fecha,
                                                            descripcion,
                                                            ciaid,
                                                            String.format( "%.2f", importe).replace(".", ","),
                                                            tipoImporte, 
                                                            polizas ,
                                                            organizador) 
                                            ); 
                            
                            sbLog.append(tipoReg).append(";").append(fecha).append(";").append(descripcion).append(";");
                            sbLog.append(String.format( "%.2f", importe).replace(".", ",")).append(";").append(sbPol.toString()); 
                            
                            bwLog.write(sbLog.toString() + "\r\n");
                        
                            polizas = new LinkedList<String>();           
                            sbPol.delete(0, sbPol.length());
                            importe = 0;
                        }
                        conceptoAnt = rs.getString ("DESCRIPCION");
                    } 
                    polizas.add(rs.getString ("NUM_POLIZA"));
                    sbPol.append(rs.getString ("NUM_POLIZA")).append(",");
                    tipoReg  = rs.getString ("TIPO_REGISTRO");
                    fecha    = rs.getString ("FECHA_INFO");
                    descripcion = rs.getString ("DESCRIPCION");
                    ciaid    = rs.getString ("CIAID");
                    importe  += rs.getDouble ("IMPORTE");
                    tipoImporte = rs.getString ("TIPO_IMPORTE"); 
                } 

                    cantRegistros += 1;                            
                    registros.add( new RegistroRCR (tipoReg,
                                     fecha,
                                     descripcion,
                                     ciaid,
                                     String.format( "%.2f", importe).replace(".", ","),
                                     tipoImporte, 
                                     polizas ,
                                     organizador) 
                     ); 
              
                    StringBuffer sbLog = new StringBuffer();
                    sbLog.append(tipoReg).append(";").append(fecha).append(";").append(descripcion).append(";");
                    sbLog.append(String.format( "%.2f", importe).replace(".", ",")).append(";").append(sbPol.toString()); 

                    bwLog.write(sbLog.toString() + "\r\n");
                    bwLog.flush();
                    bwLog.close();
                    osw.close();
                    fosLog.close();

                    Cabecera cabecera = new Cabecera( Version, Productor_TipoPersona,
                                                      "", Productor_Matricula,
                                                     String.valueOf ( cantRegistros ));

                    RCR rcr = new RCR (cabecera,registros);

		 try     
		 {     
		     rcr.BuildXxmlRCR ( sLink,"UTF-8" );

// zipear archivo
                    byte[] buffer = new byte[BUFFER_SIZE];
                    try {
                        
                            // fichero a comprimir
                            fis = new FileInputStream(sLink);
                            File aComprimir = new File (sNombre);
                            OutputStream outComprimir = new FileOutputStream(aComprimir);
                            byte[] buf = new byte[BUFFER_SIZE];
                            int len1;
                            while ((len1 = fis.read(buf)) > 0) {
                              outComprimir.write(buf, 0, len1);
                            }                            
                            
                            fis = new FileInputStream(sNombre);
                            // fichero contenedor del zip
                            fos = new FileOutputStream(pZipFile);
                            // fichero comprimido
                            zipos = new ZipOutputStream(fos);

                            ZipEntry zipEntry = new ZipEntry( sNombre );
                            zipos.putNextEntry(zipEntry);
                            int len = 0;
                            // zippear
                            while ((len = fis.read(buffer, 0, BUFFER_SIZE)) != -1) 
                                    zipos.write(buffer, 0, len);
                            // volcar la memoria al disco
                            zipos.flush();
                    } catch (Exception e) {
                            throw e;
                    } finally {
                            // cerramos los files
                            zipos.close(); 
                            fis.close(); 
                            fos.close(); 
                    } // end try
		 } catch (IOException e) {
		     e.printStackTrace();
		 } catch (ParserConfigurationException e) {
			e.printStackTrace();
		 }
               }
            rs.close ();
            }
           cons.close ();
// setear el control de acceso
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, 40);

           request.setAttribute ("estado", sEstado);
           request.setAttribute ("link", sLinkRelativo);
           request.setAttribute ("linkLog", sLinkLogRelativo);
           doForward(request, response, "/librosDigitales/formSubdiario.jsp");
          
        } catch (Exception se){
           throw new SurException (se.getMessage());
        } finally {
            try {
                if (rs != null) rs.close ();
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }


    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    /** Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Short description";
    }
    
    public void doForward(HttpServletRequest request, HttpServletResponse response,
        String nextPage) throws ServletException, IOException {
	try {
      		getServletConfig().getServletContext().getRequestDispatcher(nextPage).forward(request,response);
	} catch (IOException ioe) {
                goToJSPError (request,response, ioe);
	} catch (ServletException se) {
                goToJSPError (request,response, se);
	} catch (Exception e) {
                goToJSPError (request,response, e);
	}  // try		

    } // doForward
    
    public void goToJSPError (HttpServletRequest request, HttpServletResponse response, Throwable t) throws ServletException, IOException {
	try {
                request.setAttribute("javax.servlet.jsp.jspException", t);
		getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
	} catch (IOException ioe) {
		System.out.println("LoginServlet IOException Forwarding Request: " + ioe);
	} catch (ServletException se) {
		System.out.println("LoginServlet ServletException Forwarding Request: " + se);
	} // try		

    } // doForward
    
  
}
