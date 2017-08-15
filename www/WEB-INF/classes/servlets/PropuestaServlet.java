/*
 * PropuestaServlet.java
 *
 * Created on 28 de mayo de 2006, 19:57
 */  
      
package servlets; 
import java.io.*;
import java.util.*;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import com.business.beans.*;
import com.business.util.*;
import com.business.db.*;
import java.net.URLConnection;
import javax.servlet.*;
import javax.servlet.http.*;
/**
 *
 * @author  Usuario
 * @version
 */
public class PropuestaServlet extends HttpServlet {   
    
    /** Initializes the servlet.
     */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        
    }

    /** Destroys the servlet.
     */
    public void destroy() {
        
    }
     
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            if ( request.getParameter ("procedencia") != null) {
                getServletConfig().getServletContext().getRequestDispatcher("/servlet/setAccess?opcion=ADDPROC").include(request,response);
            }

            String op =  request.getParameter("opcion");                     

            if  (op.equals("generarPropuesta")) {
                generarPropuesta (request, response);            
            }  else if (op.equals("verificarTomador"))    {
                verificarTomador (request, response);            
            } else if (op.equals("grabarPropuesta")) {
                grabarPropuesta(request, response);            
            }  else if (op.equals("grabarNomina")) {
                grabarNomina(request, response);            
            }  else if (op.equals("borrarNomina")) {
                borrarNomina(request, response);                            
            }  else if (op.equals("grabaNominaXls")) {
                grabaNominaXls(request, response);                            
            }  else if (op.equals("enviarPropuesta") || op.equals ("autorizarProp")) {
                enviarPropuesta(request, response);                                            
            }  else if (op.equals("getPropuestaXls")) {
                getPropuestaXls(request, response);
            } else if (op.equals("getPropuestaBenef") ) {
                getPropuestaBenef(request, response);
            } else if (op.equals("printPropuesta") ) {
                getPrintPropuesta(request, response);
            } else if (op.equals("getAllProp")) {
                getAllPropuestas (request, response);
            } else if (op.equals("eliminarProp")) {
                setEliminarPropuesta (request, response);
            } else if (op.equals("grabarPropuestaRedireccion")) {
                grabarPropuestaRedireccion(request, response);
            } else if (op.equals("grabarNominasDelXlsRedireccion")) {
                grabarNominasDelXlsRedireccion(request, response);
            } else if (op.equals("borrarNominaRedireccion")) {
                borrarNominaRedireccion(request, response);
            } else if (op.equals("addPropuestaAP")) {
                addPropuestaAP (request, response);
            }

            /* ---------------------------------------------------------------*/
            /* ---------------------------------------------------------------*/
            /* Propuesta VO 15-11-2006*/
            /* -----------------------*/
               else if (op.equals("grabarPropuestaVO")) {
                grabarPropuestaVO(request, response);
            } else if (op.equals("getNominaVO")) {
                getNominaVO(request, response);
            } else if (op.equals("getNominaVC")) {
                getNominaVC(request, response);
            } else if (op.equals("addPersona")) {
                addPersona(request, response);            
            } else if (op.equals("delPersona")) {
                delPersona(request, response);            
            }  else if (op.equals("getNominaXls")) { /*upload */
                getNominaXls(request, response);                        
            }  else if (op.equals("grabarPropuestaPlan") || op.equals("CalcularPremioPlan")) {
                grabarPropuestaPlan(request, response);
            }  else if (op.equals("grabarPropuestaVC") || op.equals("CalcularPremioVC")) {
                grabarPropuestaVC(request, response);
            }  else if (op.equals("grabarNominaVC")) {
                grabarNominaVC(request, response);
            }

        } catch (SurException se) {
            goToJSPError(request,response, se);
        } catch (Exception e) {
            goToJSPError(request,response, e);
        }
    }
    
    protected void getAllPropuestas (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        
        Connection dbCon = null;
        CallableStatement cons  = null;
        ResultSet rs = null;
        LinkedList lPropuestas = new LinkedList ();
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            Diccionario oDicc   = (Diccionario) (request.getSession().getAttribute("Diccionario"));            
           
            int iCodProd        = oDicc.getInt (request, "F2cod_prod");
            String sNombre      = oDicc.getString (request, "F2nombre");
            int iNumPoliza      = oDicc.getInt (request, "F2num_poliza");
            int iNumPropuesta   = oDicc.getInt (request, "F2num_propuesta");
            int iCodRama        = oDicc.getInt (request, "F2cod_rama");
            String sFDesde      = oDicc.getString (request, "F2f_desde");
            String sFHasta      = oDicc.getString (request, "F2f_hasta");
            int iEstado         = oDicc.getInt (request, "F2estado");

// setear el control de acceso

        dbCon = db.getConnection();
        dbCon.setAutoCommit(false);
        
        cons = dbCon.prepareCall(db.getSettingCall("PRO_GET_FILTRAR_PROPUESTAS(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"));            
        cons.registerOutParameter(1, java.sql.Types.OTHER);
        cons.setString  (2, oUser.getusuario());
        cons.setInt     (3, oUser.getiCodTipoUsuario());
        cons.setInt     (4, iCodProd );
        cons.setInt     (5, oUser.getoficina());
        cons.setInt     (6, oUser.getzona());
        if (sNombre == null || sNombre.equals("")) {
            cons.setNull  (7, java.sql.Types.VARCHAR);
        } else {
            cons.setString  (7, sNombre.toUpperCase());
        }
        cons.setInt     (8, iNumPoliza);
        cons.setInt     (9, iNumPropuesta);
        cons.setInt     (10 , iCodRama);
        
        if (sFDesde  != null && sFDesde.equals ("")) {
            cons.setNull    (11, java.sql.Types.DATE);
        } else {
            cons.setDate    (11 , Fecha.convertFecha( Fecha.strToDate(sFDesde)));
        }
        if (sFHasta != null && sFHasta.equals ("")) {
            cons.setNull    (12, java.sql.Types.DATE);
        } else {
            cons.setDate    (12 , Fecha.convertFecha(Fecha.strToDate(sFHasta)));
        }
        cons.setInt (13, iEstado);
                 
        cons.execute();
        
       rs = (ResultSet) cons.getObject(1);
        if (rs != null) {
            while (rs.next()) {
                Propuesta oProp = new Propuesta();
                oProp.setDescRama       (rs.getString ("DESC_RAMA"));
                oProp.setNumPropuesta   (rs.getInt("NUM_PROPUESTA"));
                oProp.setNumSecuCot     (rs.getInt("NUM_SECU_COT"));
                oProp.setFechaTrabajo   (rs.getDate("FECHA_TRABAJO"));
                oProp.setCodEstado      (rs.getInt("COD_ESTADO")); 
                oProp.setNumPoliza      (rs.getInt ("NUM_POLIZA"));
                oProp.setDescError      (rs.getString("DESC_ERROR"));
                oProp.setdescEstado     (rs.getString("DESCRIPCION")); // DESCRIPCION ESTADO                  
                oProp.setdescProd       (rs.getString("DESC_PROD"));
                oProp.setTipoPropuesta  (rs.getString("TIPO_PROPUESTA"));
                oProp.setCodRama        (rs.getInt ("COD_RAMA"));                          
                oProp.setNumCertificado (rs.getInt("NUM_CERTIFICADO"));
                
                lPropuestas.add(oProp);
            }
            rs.close ();
        }            
            request.setAttribute("propuestas", lPropuestas);
            doForward(request, response, "/propuesta/filtrarPropuestas.jsp");
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();                
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }
    
    // -------------------------------------------------------------------------
    // REDIRECCION
    /*
     * Grabar datos de la propuesta.
     */
    protected void grabarPropuestaRedireccion (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {    
        Connection dbCon = null;
        try {
            Propuesta oProp = new Propuesta();
            int    codProceso    = 1;
            String codBoca       = "WEB";
            int    numPropuesta  = 0;    
            if ( request.getParameter ("numPropuesta") != null && 
                     !request.getParameter ("numPropuesta").equals("") ) {
                   numPropuesta  = Integer.parseInt( request.getParameter ("numPropuesta") );
            }
            int    cantVidas     = 0;
            if ( request.getParameter ("cantVidas") != null && 
                     !request.getParameter ("cantVidas").equals("") ) {
                   cantVidas  = Integer.parseInt( request.getParameter ("cantVidas") );
            }        
            dbCon = db.getConnection();              
            oProp.setCodProceso (codProceso);
            oProp.setBoca       (codBoca);
            oProp.setNumPropuesta(numPropuesta);
            oProp.setCantVidas  (cantVidas) ;
            oProp.setCodRama    (10);
            oProp.getDB(dbCon);
            
            LinkedList nominas = oProp.getDBNominasPropuesta(dbCon);                          
            
            request.setAttribute("nominas", nominas);        
            request.setAttribute("propuesta", oProp); 
            doForward (request, response, "/propuesta/formNomina.jsp");
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }                
    
    }    
    
    protected void grabarNominasDelXlsRedireccion (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {      
        Connection dbCon = null;
        try {
            Propuesta oProp = new Propuesta();
            int    codProceso    = 1;
            String codBoca       = "WEB";
            int    numPropuesta  = 0;    
            if ( request.getParameter ("numPropuesta") != null && 
                     !request.getParameter ("numPropuesta").equals("") ) {
                   numPropuesta  = Integer.parseInt( request.getParameter ("numPropuesta") );
            }
            int    cantVidas     = 0;
            if ( request.getParameter ("cantVidas") != null && 
                     !request.getParameter ("cantVidas").equals("") ) {
                   cantVidas  = Integer.parseInt( request.getParameter ("cantVidas") );
            }        
            dbCon = db.getConnection();
            oProp.setCodProceso     (codProceso);
            oProp.setBoca           (codBoca);
            oProp.setNumPropuesta   (numPropuesta);
            oProp.setCodRama        (10);
            oProp.setCantVidas      (cantVidas) ;
            oProp.getDB(dbCon);
            
            LinkedList nominas = oProp.getDBNominasPropuesta(dbCon);                          
 
            request.setAttribute("nominas", nominas);                    
            request.setAttribute("propuesta", oProp);    
            doForward (request, response, "/propuesta/formNomina.jsp");
        
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }    
    }        
    
    protected void borrarNominaRedireccion (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {      
        Connection dbCon = null;
        try {
            Propuesta oProp = new Propuesta();
            int    codProceso    = 1;
            String codBoca       = "WEB";
            int    numPropuesta  = 0;    
            if ( request.getParameter ("numPropuesta") != null && 
                     !request.getParameter ("numPropuesta").equals("") ) {
                   numPropuesta  = Integer.parseInt( request.getParameter ("numPropuesta") );
            }
/*            int    cantVidas     = 0;
            if ( request.getParameter ("cantVidas") != null && 
                     !request.getParameter ("cantVidas").equals("") ) {
                   cantVidas  = Integer.parseInt( request.getParameter ("cantVidas") );
            }
 */        
            dbCon = db.getConnection();
            oProp.setCodProceso (codProceso);
            oProp.setBoca       (codBoca);
            oProp.setNumPropuesta(numPropuesta);
//            oProp.setCantVidas  (cantVidas) ;
            oProp.setCodRama    (10);
            oProp.getDB(dbCon);
            
           LinkedList nominas = oProp.getDBNominasPropuesta(dbCon);              
            
            request.setAttribute("nominas", nominas);                    
            request.setAttribute("propuesta", oProp);    
            doForward (request, response, "/propuesta/formNomina.jsp");
        
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }    
    }            

    protected void generarPropuesta (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CotizadorAp oCot = null;
        
        try {
            
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            int numCotizacion = Integer.parseInt (request.getParameter ("numCotizacion"));
            
            if (oUser.getiCodTipoUsuario() == 0 && oUser.getmenu() == 4) {
                    request.setAttribute ("volver","-1");            
                    request.setAttribute ("mensaje", "Acceso denegado " );            
                    doForward (request, response, "/include/MsjHtmlServidor.jsp");                    
            } else {            
                String origen = "generarPropuesta";

                dbCon = db.getConnection();

                Propuesta oProp = new Propuesta();
                oProp.setNumSecuCot(numCotizacion);

                oProp.getDBxNumCotizacion(dbCon);

                if (oProp.getCodError() == 100) { // existe la propuesta
                    oCot = new CotizadorAp();

                    oCot.setnumCotizacion (numCotizacion); 
                    oCot.getDB(dbCon);                       

                    oProp.setNumPropuesta      (0);
                    oProp.setdescProd          ( oCot.getdescProd());
                    oProp.setCodProd           ( oCot.getcodProd());            
                    oProp.setCodVigencia       ( oCot.getcodVigencia());
                    oProp.setCodActividad      ( oCot.getcodActividad()); 

                    oProp.setTomadorRazon      ( ((oCot.gettomadorApe()==null)?"":oCot.gettomadorApe().trim()) + " " +((oCot.gettomadorNom()==null)?"":oCot.gettomadorNom()));
                    oProp.setTomadorApe(oCot.gettomadorApe() == null ? "" : oCot.gettomadorApe());
                    oProp.setTomadorNom (oCot.gettomadorNom()== null ? "" : oCot.gettomadorNom());
                    oProp.setTomadorCondIva    ( oCot.gettomadorCodIva());
                    oProp.setTomadorTE         (oCot.gettomadorTel());
                    oProp.setTomadorCodProv    ( String.valueOf(oCot.getcodProvincia()));
                    oProp.setCantCuotas        (oCot.getcantCuotas());
                    oProp.setNumSecuCot        (oCot.getnumCotizacion());      

                    oProp.setCapitalMuerte     ( oCot.getcapitalMuerte ());
                    oProp.setCapitalAsistencia ( oCot.getcapitalAsistencia());
                    oProp.setCapitalInvalidez  ( oCot.getcapitalInvalidez());
                    oProp.setFranquicia        ( oCot.getfranquicia());            
                    oProp.setImpPremio         ( oCot.getpremio());
                    oProp.setImpPrimaTar       ( oCot.getprimaTar());                       
                    oProp.setprimaPura         ( oCot.getprimaPura());
                    oProp.setCodFacturacion    (oCot.getcodFacturacion());
                    oProp.setcodProducto       (oCot.getcodProducto());

                    oProp.setObservaciones     ("");
                    oProp.setCodFormaPago      (0);
                    oProp.setFechaIniVigPol    (new java.util.Date());
                   
                    int cantMeses = 1;
                    switch ( oProp.getCodVigencia() ) {
                        case 1: cantMeses = 1;
                                break;
                        case 2: cantMeses = 2;
                                break;
                        case 3: cantMeses = 3;
                                break;
                        case 4: cantMeses = 4;
                                break;
                        case 5: cantMeses = 6;
                                break;
                        case 6: cantMeses = 12;
                                break;
                        case 8: cantMeses = 12;
                                break;
                        case 9: cantMeses = 9;
                    }
                    
                    String fechaVigHasta = Fecha.getFechaFinVigencia(oProp.getFechaIniVigPol(),  cantMeses);
                    oProp.setFechaFinVigPol (Fecha.strToDate ( fechaVigHasta));

                    oProp.setCodRama        (oCot.getcodRama());
                    oProp.setCodSubRama     (oCot.getcodSubRama());
                    oProp.setAllClausulas   ( new LinkedList ());
                    oProp.setcodActividadSec(oCot.getcodActividadSec());
                    oProp.setcodOpcion      (oCot.getcodOpcion());
                    oProp.setTipoPropuesta  ("P");
                    oProp.setcodAmbito      (oCot.getcodAmbito());

                    boolean bErrorComision = false;
/*                    double gastosMax = 0;


                    if (oCot.getgastosAdquisicion() > 0 ) {                    
                        gastosMax = ConsultaMaestros.getPorcComisionProd(dbCon, oCot.getcodProd(), oCot.getcodRama() );
                        if (gastosMax > 0 && oCot.getgastosAdquisicion() > gastosMax) {
                            bErrorComision = true;
                        }
                    }
*/

                    if ( bErrorComision ) {
                        request.setAttribute ("volver","-1");            
                        request.setAttribute ("mensaje", "La propuesta no pudo ser generada porque el gasto de adquisición es mayor al permitido para la rama.<br>Consulte con su representante comercial.<br><br>Muchas Gracias. " );
                        doForward (request, response, "/include/MsjHtmlServidor.jsp");                    
                    } else {
                        request.setAttribute ("origen", origen);            
                        request.setAttribute ("propuesta", oProp);            
                        doForward (request, response, "/propuesta/formPropuesta.jsp");
                    }
                } else if (oProp.getCodError() == 0 && oProp.getCodEstado() == 0 ) {
                    // LA PROPUESTA YA EXISTE Y ESTA PENDIENTE
                            request.setAttribute ("propuesta", oProp);            
                            doForward (request, response, "/propuesta/formPropuesta.jsp");
                        } else {
                    // LA PROPUESTA EXISTE Y EL ESTADO ES ENVIADO
                            request.setAttribute ("volver","-1");            
                            request.setAttribute ("mensaje", "La propuesta ya ha sido enviada con el N° " + oProp.getNumPropuesta() + ". Ingrese desde el menú opción Cotizadores -> Mis propuestas. " );
                            doForward (request, response, "/include/MsjHtmlServidor.jsp");
                        }
            }
           
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }           

    protected void addPropuestaAP (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        Cotizacion oCot = null;

        try {

            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            int numCotizacion = Integer.parseInt (request.getParameter ("numCotizacion"));

            if (oUser.getiCodTipoUsuario() == 0 && oUser.getmenu() == 4) {
                    request.setAttribute ("volver","-1");
                    request.setAttribute ("mensaje", "Acceso denegado " );
                    doForward (request, response, "/include/MsjHtmlServidor.jsp");
            } else {
                String origen = "generarPropuesta";

                dbCon = db.getConnection();

                Propuesta oProp = new Propuesta();
                oProp.setNumSecuCot(numCotizacion);

                oProp.getDBxNumCotizacion(dbCon);

                if (oProp.getCodError() == 100) { // existe la propuesta
                    oCot = new Cotizacion();

                    oCot.setnumCotizacion (numCotizacion);
                    oCot.getDB(dbCon);


                    oProp.setNumPropuesta      (0);
                    oProp.setdescProd          ( oCot.getdescProd());
                    oProp.setCodProd           ( oCot.getcodProd());
                    oProp.setCodVigencia       ( oCot.getcodVigencia());
                    oProp.setCodActividad      ( oCot.getcodActividad());

                    oProp.setTomadorRazon      ( ((oCot.gettomadorApe()==null)?"":oCot.gettomadorApe().trim()) + " " +((oCot.gettomadorNom()==null)?"":oCot.gettomadorNom()));
                    oProp.setTomadorApe(oCot.gettomadorApe() == null ? "" : oCot.gettomadorApe());
                    oProp.setTomadorNom (oCot.gettomadorNom()== null ? "" : oCot.gettomadorNom());
                    oProp.setTomadorCondIva    ( oCot.gettomadorCodIva());
                    oProp.setTomadorTE         (oCot.gettomadorTel());
                    oProp.setTomadorCodProv    ( String.valueOf(oCot.getcodProvincia()));
                    oProp.setCantCuotas        (oCot.getcantCuotas());
                    oProp.setNumSecuCot        (oCot.getnumCotizacion());

                    oProp.setCapitalMuerte     ( oCot.getcapitalMuerte ());
                    oProp.setCapitalAsistencia ( oCot.getcapitalAsistencia());
                    oProp.setCapitalInvalidez  ( oCot.getcapitalInvalidez());
                    oProp.setFranquicia        ( oCot.getfranquicia());
                    oProp.setImpPremio         ( oCot.getpremio());
                    oProp.setImpPrimaTar       ( oCot.getprimaTar());
                    oProp.setprimaPura         ( oCot.getprimaPura());
                    oProp.setcategoriaPersona  (oCot.getcategoriaPersona());

                    oProp.setObservaciones     (""); 
                    oProp.setCodFormaPago      (0);

                    Calendar hoy = Calendar.getInstance();
                    oProp.setFechaIniVigPol(hoy.getTime());
                    
                    int cantMeses = 1;
                    switch ( oProp.getCodVigencia() ) {
                        case 1: cantMeses = 1;
                                break;
                        case 2: cantMeses = 2;
                                break;
                        case 3: cantMeses = 3;
                                break;
                        case 4: cantMeses = 4;
                                break;
                        case 5: cantMeses = 6;
                                break;
                        case 6: cantMeses = 12;
                                break;
                        case 8: cantMeses = 12;
                                break;
                        case 9: cantMeses = 9;
                    }
                    
                    if (oProp.getCodVigencia() == 7 ) {
                        hoy.add(Calendar.DATE, oCot.getcantDias());
                        oProp.setcantDias(oCot.getcantDias());
                    } else {
                        hoy.add(Calendar.MONTH, cantMeses);                        
                    }

//                    String fechaVigHasta = Fecha.getFechaFinVigencia(oProp.getFechaIniVigPol(),  cantMeses);
                    oProp.setFechaFinVigPol (hoy.getTime());

                    oProp.setCodRama        (oCot.getcodRama());
                    oProp.setCodSubRama     (oCot.getcodSubRama());
                    oProp.setcodProducto    (oCot.getcodProducto());
                    oProp.setAllClausulas   ( new LinkedList ());
                    oProp.setcodActividadSec(oCot.getcodActividadSec());
                    oProp.setcodOpcion      (oCot.getcodOpcion());
                    oProp.setTipoPropuesta  ("P");
                    oProp.setcodAmbito      (oCot.getcodAmbito());
                    oProp.setCodFacturacion(oCot.getcodFacturacion());

                    double gastosMax = 0;
                    boolean bErrorComision = false;

/*                    if (oCot.getgastosAdquisicion() > 0 ) {
                        gastosMax = ConsultaMaestros.getPorcComisionProd(dbCon, oCot.getcodProd(), oCot.getcodRama() );

                        if (gastosMax > 0 && oCot.getgastosAdquisicion() > gastosMax) {
                            bErrorComision = true;
                        }
                    }
*/
                    if ( bErrorComision ) {
                        request.setAttribute ("volver","-1");
                        request.setAttribute ("mensaje", "La propuesta no pudo ser generada porque el gasto de adquisición es mayor al permitido para la rama.<br>Consulte con su representante comercial.<br><br>Muchas Gracias. " );
                        doForward (request, response, "/include/MsjHtmlServidor.jsp");
                    } else {
                        request.setAttribute ("origen", origen);
                        request.setAttribute ("propuesta", oProp);
                        doForward (request, response, "/propuesta/formPropuesta.jsp");
                    }
                } else if (oProp.getCodError() == 0 && oProp.getCodEstado() == 0 ) {
                    // LA PROPUESTA YA EXISTE Y ESTA PENDIENTE
                            request.setAttribute ("propuesta", oProp);
                            doForward (request, response, "/propuesta/formPropuesta.jsp");
                        } else {
                    // LA PROPUESTA EXISTE Y EL ESTADO ES ENVIADO
                            request.setAttribute ("volver","-1");
                            request.setAttribute ("mensaje", "La propuesta ya ha sido enviada con el N° " + oProp.getNumPropuesta() + ". Ingrese desde el menú opción Cotizadores -> Mis propuestas. " );
                            doForward (request, response, "/include/MsjHtmlServidor.jsp");
                        }
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void getPropuestaBenef (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {        
        Connection        dbCon = null;
        int  nroProp = Integer.valueOf( request.getParameter("numPropuesta") == null?"0":request.getParameter("numPropuesta"));
        
        try {
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));

            if (oUser.getiCodTipoUsuario() == 0 && oUser.getmenu() == 4) {
                    request.setAttribute ("volver","-1");            
                    request.setAttribute ("mensaje", "Acceso denegado " );            
                    doForward (request, response, "/include/MsjHtmlServidor.jsp");                    
            } else {            
                    dbCon = db.getConnection();  
                    Propuesta oProp = new Propuesta();
                    oProp.setNumPropuesta(nroProp);
                    
                    oProp.getDB(dbCon);
                    if (oProp.getCodError() < 0 ) {
                        throw new SurException( (oProp.getDescError()));
                    }

                    if (oProp.getCodRama() == 21 ){
                        request.setAttribute ("propuesta", oProp);
                        doForward (request, response, "/propuesta/formPropuestaVO.jsp");
                    } else if ( oProp.getcodPlan () > 0 ) {
                        request.setAttribute ("propuesta", oProp);            
                        doForward (request, response, "/propuesta/formPropuestaPlanes_1.jsp?codRama=" + oProp.getCodRama());
                    } else if (oProp.getCodRama() == 18 ||  
                               oProp.getCodRama() == 22 || 
                               oProp.getCodRama() == 23 || 
                               oProp.getCodRama() == 24 || 
                               oProp.getCodRama() == 15 ) {
                        request.setAttribute ("propuesta", oProp);            
                        doForward (request, response, "/propuesta/formPropuestaColectivo.jsp?codRama=" + oProp.getCodRama());
                    } else {
                        request.setAttribute ("propuesta", oProp);
                        doForward (request, response, "/propuesta/formPropuesta.jsp");
                    }
            }
        
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
        
    }                                

    protected void getPrintPropuesta (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {        
        Connection        dbCon = null;
        int  nroProp = Integer.valueOf( request.getParameter("numPropuesta") == null?"0":request.getParameter("numPropuesta"));
        LinkedList nominas = new LinkedList ();
        try {
            dbCon = db.getConnection();  
            Propuesta oProp = new Propuesta();
            oProp.setNumPropuesta   (nroProp);
            oProp.getDB(dbCon);
            if (oProp.getCodRama() == 9 || oProp.getnivelCob().equals("P")) {
                nominas = oProp.getDBNominasPropuesta(dbCon);
            } else {
                nominas = oProp.getDBPrintNomina(dbCon, oProp.getcodProducto());
            }
            
            request.setAttribute ("propuesta", oProp);            
            request.setAttribute ("nominas", nominas);            
            doForward (request, response, "/propuesta/report/propuestaHTML.jsp");            
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
        
    }                                
    
    
    /*
     * Verificar datos con tomador de las polizs. Reemplaza al verifTomador
     */
    protected void verificarTomador (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection        dbCon = null;
        CallableStatement cons  = null;
        LinkedList        lTom  = new LinkedList();
        try {
            Usuario oUser  = (Usuario) (request.getSession().getAttribute("user"));
            String  nroDoc = request.getParameter ("verif_doc");

            dbCon = db.getConnection();
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PRO_GET_P_TOMADOR(?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString           (2, nroDoc);
            cons.execute();

            ResultSet rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    PersonaPoliza oTom = new PersonaPoliza();
                    oTom.setnumTomador      (rs.getInt    ("NUM_TOMADOR"));
                    oTom.settipoDoc         (rs.getString ("TIPO_DOC"));
                    oTom.setnumDoc          (rs.getString ("NUM_DOC"));
                    oTom.setrazonSocial     (rs.getString ("RAZON_SOCIAL"));
                    oTom.setcuit            (rs.getString ("CUIT"));
                    oTom.setcodCondicionIVA (rs.getInt    ("COD_CONDICION_IVA"));
                    oTom.setdomicilio       (rs.getString ("DOMICILIO"));
                    oTom.setlocalidad       (rs.getString ("LOCALIDAD"));
                    oTom.setcodPostal       (rs.getString ("COD_POSTAL"));
                    oTom.setprovincia       (rs.getString ("PROVINCIA"));
                    oTom.setapellido        (rs.getString ("RAZON_SOCIAL"));

                    lTom.add(oTom);
                }
                rs.close ();
            }

            request.setAttribute("tomadores", lTom);

            doForward (request, response, "/propuesta/PopUpVerificarTomador.jsp");
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }    
    
    /*
     * Grabar datos de la propuesta.
     */
    protected void grabarPropuesta (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {        
        
        Connection dbCon = null;
        try {            
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));                     
            
            int nroProp = 0;                        
            if ( request.getParameter ("prop_num_prop") != null && 
                 !request.getParameter ("prop_num_prop").equals("") ) {                 
                 nroProp  = Integer.parseInt( request.getParameter ("prop_num_prop") );    
            }              

            dbCon = db.getConnection();
            Propuesta oProp = new Propuesta();
            if (nroProp > 0) {
                oProp.setNumPropuesta(nroProp);
                oProp.getDB(dbCon);
                if (oProp.getCodError() < 0 ) {
                    throw new SurException(oProp.getDescError());
                }
                if (oProp.getCodEstado() != 0 && oProp.getCodEstado() != 4) {
                    throw new SurException("LA PROPUESTA NO PUEDE SER MODIFICADA");
                }
            }

            int codRama = 0;
            if ( request.getParameter ("prop_rama") != null &&
                 !request.getParameter ("prop_rama").equals("") ) {
               codRama  = Integer.parseInt( request.getParameter ("prop_rama") );
            }

            int codSubRama = 0;
            if ( request.getParameter ("prop_sub_rama") != null &&
                 !request.getParameter ("prop_sub_rama").equals("") ) {
               codSubRama  = Integer.parseInt( request.getParameter ("prop_sub_rama") );
            }

            int codProd = 0;                        
            if ( request.getParameter ("prop_cod_prod") != null && 
                 !request.getParameter ("prop_cod_prod").equals("") ) {
               codProd  = Integer.parseInt( request.getParameter ("prop_cod_prod") );
            }            
                        
            int codVig = 0;
            if ( request.getParameter ("prop_vig") != null && 
                 !request.getParameter ("prop_vig").equals("") ) {
               codVig  = Integer.parseInt( request.getParameter ("prop_vig") );
            }                                                        

            int codActividad = 0;
            if ( request.getParameter ("prop_aseg_actividad") != null && 
                 !request.getParameter ("prop_aseg_actividad").equals("") ) {
               codActividad  = Integer.parseInt( request.getParameter ("prop_aseg_actividad") );
            }         

            int cantCuota = 0;                        
            if ( request.getParameter ("prop_cant_cuotas") != null && 
                 !request.getParameter ("prop_cant_cuotas").equals("") ) {
               cantCuota  = Integer.parseInt( request.getParameter ("prop_cant_cuotas") );
            }            
                        
            int numSocio = 0;                        
            if ( request.getParameter ("prop_numSocio") != null && 
                 !request.getParameter ("prop_numSocio").equals("") ) {
               numSocio  = Integer.parseInt( request.getParameter ("prop_numSocio") );
            }
            
            String observacion   = request.getParameter ("prop_obs");
            
            int codFormaPago = 0;
            if ( request.getParameter ("prop_form_pago") != null && 
                 !request.getParameter ("prop_form_pago").equals("") ) {
               codFormaPago  = Integer.parseInt( request.getParameter ("prop_form_pago") );
            }                        
/*            double premio = 0;
            if ( request.getParameter ("prop_premio") != null && 
                 !request.getParameter ("prop_premio").equals("") ) {
               premio  = Dbl.StrtoDbl( request.getParameter ("prop_premio") );
            }                       
  */
            int numCotizacion = 0;                        
            if ( request.getParameter ("prop_nro_cot") != null && 
                 !request.getParameter ("prop_nro_cot").equals("") ) {
               numCotizacion  = Integer.parseInt( request.getParameter ("prop_nro_cot") );
            }                     
            
            int codEstado = 0;          
            if ( request.getParameter ("prop_cod_est") != null && 
                 !request.getParameter ("prop_cod_est").equals("") ) {                 
                 codEstado  = Integer.parseInt( request.getParameter ("prop_cod_est") );    
            }                           

            double valorCuota = 0;
            if ( request.getParameter ("pro_valor_cuota") != null &&
                 !request.getParameter ("pro_valor_cuota").equals("") ) {
               valorCuota  =  Double.parseDouble( request.getParameter ("pro_valor_cuota")) ;
            }

            int  numReferencia = 0;
            if ( request.getParameter ("prop_num_referencia") != null &&
                 !request.getParameter ("prop_num_referencia").equals("") ) {
               numReferencia  = Integer.parseInt ( request.getParameter ("prop_num_referencia")) ;
            }

            int codFact = Integer.parseInt( request.getParameter ("prop_cod_facturacion"));

            CotizadorAp oCotizacion = new CotizadorAp();  
            oCotizacion.setnumCotizacion (numCotizacion); 
            oCotizacion.getDB(dbCon);                                   

            // --> Fijo
            oProp.setCodProceso  (1);
            oProp.setBoca        ("WEB");
            oProp.setCodRama     (codRama);
            oProp.setNumPropuesta(nroProp);                      
            oProp.setCodSubRama  (codSubRama);
            oProp.setcodProducto (oCotizacion.getcodProducto());
            oProp.setNumPoliza   (0);
            oProp.setCodCobFinal (0);
            oProp.setCodMoneda   (0);
            // 
            oProp.setImpPremio    ( oCotizacion.getpremio());
            oProp.setCodFormaPago (codFormaPago);  
            oProp.setImpCuota     (valorCuota);
            oProp.setCodProd      (codProd); 
            oProp.setNumTomador   (numSocio); 
            oProp.setPeriodoFact  (codFact);
            oProp.setCodFacturacion(codFact);

            oProp.setCantCuotas   ( cantCuota );
            if ( cantCuota == 0 ) {
                oProp.setCantCuotas   ( oCotizacion.getcantCuotas());
            }
            oProp.setCodActividad (codActividad);            
            
            oProp.setmcaEnvioPoliza(request.getParameter ("prop_mca_envio_poliza") == null ? "S" : request.getParameter ("prop_mca_envio_poliza"));
            
            String fechaVigDesde = (request.getParameter ("prop_vig_desde")==null)?"":request.getParameter ("prop_vig_desde");
            
            if (fechaVigDesde.equals("")) {
                oProp.setFechaIniVigPol(null);
            } else {                
                oProp.setFechaIniVigPol( Fecha.strToDate( request.getParameter ("prop_vig_desde") ));
            }    
            
            String fechaVigHasta = (request.getParameter ("prop_vig_hasta")==null)?"":request.getParameter ("prop_vig_hasta");
            if (fechaVigHasta.equals("")) {
                oProp.setFechaFinVigPol(null);
            } else {                
                oProp.setFechaFinVigPol( Fecha.strToDate( request.getParameter ("prop_vig_hasta")));
            }                    

            oProp.setCodVigencia(codVig);
            oProp.setCantVidas(oCotizacion.getcantPersonas()); // De la Cotizacion.
            //oProp.setCodEstado(0);
            oProp.setCodEstado(codEstado); 
            oProp.setObservaciones(observacion); 
            oProp.setNumSecuCot(numCotizacion); 
            oProp.setUserid(oUser.getusuario());    
            
            oProp.setclaNoRepeticion    (request.getParameter ("prop_cla_no_repeticion") == null ? "N" : request.getParameter ("prop_cla_no_repeticion"));
            oProp.setclaSubrogacion     (request.getParameter ("prop_cla_subrogacion") == null ? "N" : request.getParameter ("prop_cla_subrogacion") );
            oProp.setbenefHerederos     (request.getParameter ("prop_benef_herederos") == null ? "N" : request.getParameter ("prop_benef_herederos"));
            oProp.setbenefTomador       (request.getParameter ("prop_benef_tomador") == null ? "N" : request.getParameter ("prop_benef_tomador"));

            if (oCotizacion.getcodProducto() == 0) {
                oProp.setcodProducto(oCotizacion.getcodAmbito());
            } else {
                oProp.setcodProducto (oCotizacion.getcodProducto());
            }

            oProp.setnumReferencia ( numReferencia );
            oProp.setTipoPropuesta(request.getParameter ("prop_tipo_propuesta"));
            oProp.setcantDias(Integer.parseInt (request.getParameter ("prop_cant_dias")));
            
            oProp.setDB(dbCon);

            if (oProp.getCodError() == -1 ) {
                request.setAttribute("mensaje", oProp.getDescError());
                request.setAttribute("volver", Param.getAplicacion() + "index.jsp");
                doForward (request, response, "/include/MsjHtmlServidor.jsp");
                
            }

            int iCantClausulas = (request.getParameter ("prop_cant_max_clausulas") == null ? 0 : Integer.parseInt (request.getParameter ("prop_cant_max_clausulas")));
            
            for (int i= 1; i <= iCantClausulas;i++) {
                Clausula oCla =  new Clausula ();
                oCla.setboca(oProp.getBoca());
                oCla.setnumPropuesta(oProp.getNumPropuesta());
                oCla.setnumItem (i);
                oCla.setcuitEmpresa (request.getParameter ("CLA_CUIT_" + i));
                oCla.setdescEmpresa (request.getParameter ("CLA_DESCRIPCION_" + i));
                
                if (i == 1) {
                    oCla.delDB (dbCon);
                }
                if (oCla.getdescEmpresa() != null && oCla.getdescEmpresa().trim().length() > 0) {
                    oCla.setDB(dbCon);
                }
            }
            
           if (oProp.getNumPropuesta() > 0) {   
                
                // ----------------------
                // DATOS DE FORMA DE PAGO 
                // ----------------------
                // 1 - TARJETA DE CREDITO.-                
                if ( oProp.getCodFormaPago() ==1 ) {
                    int codTarjCred = 0;
                    if ( request.getParameter ("pro_TarCred") != null && 
                         !request.getParameter ("pro_TarCred").equals("") ) {
                        codTarjCred  = Integer.parseInt( request.getParameter ("pro_TarCred") );     
                    }

                   int codTarjBco = 0;
 //                   if ( request.getParameter ("pro_TarCredBco") != null && 
 //                        !request.getParameter ("pro_TarCredBco").equals("") ) {
 //                       codTarjBco  = Integer.parseInt( request.getParameter ("pro_TarCredBco") );               
 //                   }
                    String nroTarjCred      = request.getParameter ("pro_TarCredNro");                
                    String fechaVtoTarjCred = request.getParameter ("pro_TarCredVto");                   
                    String titularTarjCred  = request.getParameter ("pro_TarCredTit");   
                    
                    oProp.setCodTarjCred(codTarjCred);
                    oProp.setNumTarjCred(nroTarjCred);                   
                    
                    if (fechaVigHasta.equals("")) {
                        oProp.setVencTarjCred(null);
                    } else {                
                        oProp.setVencTarjCred( Fecha.strToDate( fechaVtoTarjCred));
                    }                      
                    oProp.setCodBanco(codTarjBco);
                    oProp.setTitular(titularTarjCred);
                    oProp.setcodSeguridadTarjeta(request.getParameter ("pro_TarCredCodSeguridad"));
//                    oProp.setdirTitularTarjeta  (request.getParameter ("pro_TarCredTitDomicilio"));
                    oProp.setDBTarjetaCredito(dbCon);
                    
                // 2-3 - DEBITO .-    
                } else if ( oProp.getCodFormaPago() == 2 || oProp.getCodFormaPago() == 3  ) {
                    
                    int codCtaBco = 0;
                    if ( request.getParameter ("pro_CtaBco") != null && 
                         !request.getParameter ("pro_CtaBco").equals("") ) {
                        codCtaBco  = Integer.parseInt( request.getParameter ("pro_CtaBco") );               
                    }            
                    String cbu      = request.getParameter ("pro_CtaCBU");     
                    String Sucursal = request.getParameter ("pro_CtaBcoSuc");     
                    String titular  = request.getParameter ("pro_CtaTit"); 

                    oProp.setCodBanco(codCtaBco);
                    oProp.setTitular(titular);                                
                    oProp.setCbu(cbu);
                    oProp.setSucBanco(Sucursal);
                // DEBITO CUENTA   
                } else if ( oProp.getCodFormaPago() == 4  ) {
                    String cbu      = request.getParameter ("pro_DebCtaCBU");
                    String titular  = request.getParameter ("pro_CtaTit");
                    oProp.setCbu     (cbu);
                    oProp.setTitular (titular);
                    oProp.setDBTarjetaDebitoCuenta(dbCon);
                } else if ( oProp.getCodFormaPago() == 6  ) {

                    int codCtaBco = 0;
                    if ( request.getParameter ("pro_CtaBco") != null &&
                         !request.getParameter ("pro_CtaBco").equals("") ) {
                        codCtaBco  = Integer.parseInt( request.getParameter ("pro_CtaBco") );
                    }
                    String cbu      = request.getParameter ("pro_cuenta_banco");
                    String titular  = request.getParameter ("pro_convenio");

                    oProp.setCodBanco(codCtaBco);
                    oProp.setTitular(titular);
                    oProp.setCbu(cbu);
                    oProp.setDBBancoConvenio(dbCon);
                // DEBITO CUENTA
                } else {                    
                    // Otro forma de pago debe resetear otros campos de forma de Pago.
                    oProp.setDBFormaPagoReset(dbCon);
                }                   
                // ------------------
                // DATOS DEL TOMADOR
                // ------------------
                String tipoDocTomador = request.getParameter ("prop_tom_tipoDoc");
                String nroDocTomador  = request.getParameter ("prop_tom_nroDoc");
                String TomadorNom     = request.getParameter ("prop_tom_nombre");
                String TomadorApe     = request.getParameter ("prop_tom_apellido");

                int ivaTomador = 0;                        
                if ( request.getParameter ("prop_tom_iva") != null && 
                     !request.getParameter ("prop_tom_iva").equals("") ) {
                   ivaTomador  = Integer.parseInt( request.getParameter ("prop_tom_iva") );
                }                    
                String domTomador    = request.getParameter ("prop_tom_dom");            
                String locTomador    = request.getParameter ("prop_tom_loc");                        
                String cpTomador     = request.getParameter ("prop_tom_cp");

                String mailTomador   = request.getParameter ("prop_tom_email");            
                String teTomador     = request.getParameter ("prop_tom_te");            
                String provTomador   = request.getParameter ("prop_tom_prov");            

                PersonaPoliza oTom   = new PersonaPoliza();
                oTom.setnumTomador  (numSocio);
                oTom.settipoDoc     (tipoDocTomador);
                oTom.setnumDoc      (nroDocTomador);
                oTom.setrazonSocial (TomadorApe.trim() + " " + TomadorNom.trim());
                oTom.setnombre      (TomadorNom);
                oTom.setapellido    (TomadorApe);
                oTom.setcodCondicionIVA(ivaTomador);            
                oTom.setdomicilio   (domTomador);
                oTom.setlocalidad   (locTomador);
                oTom.setcodPostal   (cpTomador );
                oTom.setmail        (mailTomador);
                oTom.settelefono    (teTomador);
                oTom.setprovincia   (provTomador);                
                
                oTom.setcodProceso        (oProp.getCodProceso());
                oTom.setcodBoca           (oProp.getBoca());
                oTom.setnumPropuesta      (oProp.getNumPropuesta());
                oTom.setDBTomadorPropuesta(dbCon);
                
                // ------------------
                // DATOS DE COBERTURA
                // ------------------
                // SOLAMENTE SE GRABA CUNADO ES UNA PROPUESTA NUEVA .
                if (nroProp == 0) {
                    // MUERTE
                    double capMuerte  = 0;
                    if ( request.getParameter ("prop_cap_muerte") != null && 
                         !request.getParameter ("prop_cap_muerte").equals("") ) {                    
                        capMuerte  = Dbl.StrtoDbl(request.getParameter ("prop_cap_muerte") );

                    }                                           
                    // INVALIDEZ 
                    double capInvalidez = 0;                        
                    if ( request.getParameter ("prop_cap_invalidez") != null && 
                         !request.getParameter ("prop_cap_invalidez").equals("") ) {                    
                        capInvalidez = Dbl.StrtoDbl(request.getParameter ("prop_cap_invalidez") );
                    }                                                                    
                    //ASISTENCIA
                    double capAsistencia = 0;                        
                    if ( request.getParameter ("prop_cap_asistencia") != null && 
                         !request.getParameter ("prop_cap_asistencia").equals("") ) {                    
                        capAsistencia  =  Dbl.StrtoDbl(request.getParameter ("prop_cap_asistencia") );
                    }                        
                    // FRANQUICIA
                    double franquicia = 0;            
                    if ( request.getParameter ("prop_franquicia") != null && 
                         !request.getParameter ("prop_franquicia").equals("") ) {                    
                        franquicia  =  Dbl.StrtoDbl(request.getParameter ("prop_franquicia") );    
                    }                                        
                    AsegCobertura oCob = new AsegCobertura();
                    oCob.setcodProceso(oProp.getCodProceso());
                    oCob.setcodBoca(oProp.getBoca());                
                    oCob.setnumPropuesta(oProp.getNumPropuesta());                
                    oCob.setcodRama(oProp.getCodRama());
                    oCob.setcodSubRama(oProp.getCodSubRama());
                    // COB=1 Muerte
                    oCob.setcodCob(1);                
                    oCob.setimpSumaRiesgo(capMuerte);                               
                    oCob.setDBCobPropuesta(dbCon);                
                    // COB=2 Invalidez
                    oCob.setcodCob(2);
                    oCob.setimpSumaRiesgo(capInvalidez);                
                    oCob.setDBCobPropuesta(dbCon);                
                    // COB=4 Asistencia Medica 
                    oCob.setcodCob(4);                                        
                    oCob.setimpSumaRiesgo(capAsistencia);                
                    oCob.setDBCobPropuesta(dbCon);
                }
                
                UbicacionRiesgo oRiesgo = new UbicacionRiesgo ();
                oRiesgo.setnumPropuesta(oProp.getNumPropuesta());
                
                if (request.getParameter ("prop_misma_ubic_riesgo") != null && request.getParameter ("prop_misma_ubic_riesgo").equals ("S")) {
                    oRiesgo.setcodPostal (oTom.getcodPostal());
                    oRiesgo.setprovincia (oTom.getprovincia());
                    oRiesgo.setdomicilio (oTom.getdomicilio());
                    oRiesgo.setlocalidad (oTom.getlocalidad());
                    oRiesgo.setigualTomador("S");
                } else {
                    oRiesgo.setcodPostal (request.getParameter ("prop_ubic_cp"));
                    oRiesgo.setprovincia (request.getParameter ("prop_ubic_prov"));
                    oRiesgo.setdomicilio (request.getParameter ("prop_ubic_dom"));
                    oRiesgo.setlocalidad (request.getParameter ("prop_ubic_loc"));
                    oRiesgo.setigualTomador("N");
                }
                
                oRiesgo.setDBPropuesta(dbCon);
                
                response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);                
                response.setHeader("Location",
                                   "/benef/servlet/PropuestaServlet?opcion=grabarPropuestaRedireccion&codProceso="+oProp.getCodProceso()      +
                                                                                                    "&codBoca="+ oProp.getBoca()              +
                                                                                                    "&numPropuesta="+ oProp.getNumPropuesta() +
                                                                                                    "&cantVidas="+ oProp.getCantVidas()       +
                                                                                                    "&volver=" + (request.getParameter("volver") == null ?
                                                                                                      "filtrarPropuestas" : request.getParameter("volver")));
            } else {   
                String sMensaje = "";                
                sMensaje = "Hubo algún problema en el alta del propuesta. Por favor, comuniquese con su representante</br></br>Muchas Gracias.";
                request.setAttribute("mensaje", sMensaje);                
                request.setAttribute("volver", Param.getAplicacion() + "index.jsp");                       

                doForward (request, response, "/include/MsjHtmlServidor.jsp"); 
            }            
        } catch (SurException se) {
            throw new SurException (se.getMessage());            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }       
    
    /*
     * Grabar nomina.
     */
    protected void grabarNomina (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {        
        
        Connection dbCon = null;
        try {            
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));         
            
            int numProceso = 0;                        
            if ( request.getParameter ("prop_proceso") != null && 
                 !request.getParameter ("prop_proceso").equals("") ) {
               numProceso  = Integer.parseInt( request.getParameter ("prop_proceso") );
            }            
            
            String codBoca = request.getParameter ("prop_codBoca");
                        
            int nroPropuesta = 0;
            if ( request.getParameter ("prop_numero") != null && 
                 !request.getParameter ("prop_numero").equals("") ) {
               nroPropuesta  = Integer.parseInt( request.getParameter ("prop_numero") );
            }           
            int orden = 0;
            if ( request.getParameter ("prop_nom_orden") != null && 
                 !request.getParameter ("prop_nom_orden").equals("") ) {
               orden  = Integer.parseInt( request.getParameter ("prop_nom_orden") );
            }                       
            String apeNom = request.getParameter ("prop_nom_ApeNom");
            String tipDoc = request.getParameter ("prop_nom_tipDoc");
            String numDoc = request.getParameter ("prop_nom_numDoc");
            String mano   = request.getParameter("prop_nom_mano");
            
            dbCon = db.getConnection();
            AseguradoPropuesta oAseg = new AseguradoPropuesta();
            
            oAseg.setCodProceso(numProceso);
            oAseg.setCodBoca(codBoca);
            oAseg.setNumPropuesta(nroPropuesta);           
            oAseg.setCodRama(10);
            oAseg.setOrden(orden);           
            oAseg.setTipoDoc(tipDoc);
            oAseg.setNumDoc(numDoc);
            oAseg.setNombre(apeNom);                              
            oAseg.setmano(mano);
            
            String fechaNacimiento = (request.getParameter ("prop_nom_fechaNac")==null)?"":request.getParameter ("prop_nom_fechaNac");
            if (fechaNacimiento.equals("")) {
                oAseg.setFechaNac(null);
            } else {
                oAseg.setFechaNac(Fecha.strToDate( request.getParameter ("prop_nom_fechaNac") ));                
            }    
            
            oAseg.setDB(dbCon);
            
            if (oAseg.getiNumError() >= 0) {
                Propuesta oProp = new Propuesta();
                oProp.setCodProceso  ( oAseg.getCodProceso());
                oProp.setBoca        ( oAseg.getCodBoca() );
                oProp.setNumPropuesta( oAseg.getNumPropuesta());           
                oProp.setCodRama     ( oAseg.getCodRama()); 
                
                oProp.getDB(dbCon);
                
/*
                int cantVidas = 0;
                if ( request.getParameter ("prop_cantVidas") != null && 
                    !request.getParameter ("prop_cantVidas").equals("") ) {
                    cantVidas  = Integer.parseInt( request.getParameter ("prop_cantVidas") );
                }            
                oProp.setCantVidas(cantVidas);
*/
                
                LinkedList nominas = oProp.getDBNominasPropuesta(dbCon);                              
                
                request.setAttribute("nominas", nominas);    
                request.setAttribute("propuesta", oProp);    
                
                doForward (request, response, "/propuesta/formNomina.jsp");  
                
            } else {    
                String sMensaje = oAseg.getsMensError();
                request.setAttribute("mensaje", sMensaje);
                request.setAttribute("volver", "/servlet/PropuestaServlet?opcion=getNominaVC&numPropuesta=" + nroPropuesta );
                doForward (request, response, "/include/MsjHtmlServidor.jsp");
            }    
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }       

    protected void grabarNominaVC (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        Connection dbCon = null;
        boolean bError  = false;
        try {
System.out.println ("entro en grabarNominaVC");

            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));
            String sSig   = request.getParameter ("siguiente");
            int codRama     = Integer.parseInt (request.getParameter ("prop_rama"));
            int nroPropuesta= Integer.parseInt( request.getParameter ("prop_numero") );
            int orden       = Integer.parseInt( request.getParameter ("prop_nom_orden") == null ?
                                                request.getParameter ("prop_grupo") :
                                                request.getParameter ("prop_nom_orden"));

            String sTipoNomina = (request.getParameter ("prop_tipo_nomina") == null ? "S" :
                                 request.getParameter ("prop_tipo_nomina"));
            AseguradoPropuesta oAseg = new AseguradoPropuesta();
            dbCon = db.getConnection();

            if (sTipoNomina.equals ("S")) {
                String apeNom = request.getParameter ("prop_nom_ApeNom");
                String tipDoc = request.getParameter ("prop_nom_tipDoc");
                String numDoc = request.getParameter ("prop_nom_numDoc");
                String mano   = request.getParameter("prop_nom_mano");

                oAseg.setCodProceso(1);
                oAseg.setCodBoca("WEB");
                oAseg.setNumPropuesta(nroPropuesta);
                oAseg.setCodRama(codRama);
                oAseg.setOrden(orden);
                oAseg.setTipoDoc(tipDoc);
                oAseg.setNumDoc(numDoc);
                oAseg.setNombre(apeNom);
                oAseg.setmano(mano);

                String fechaNacimiento = (request.getParameter ("prop_nom_fechaNac")==null)?"":request.getParameter ("prop_nom_fechaNac");
                if (fechaNacimiento.equals("")) {
                    oAseg.setFechaNac(null);
                } else {
                    oAseg.setFechaNac(Fecha.strToDate( request.getParameter ("prop_nom_fechaNac") ));
                }

                oAseg.setDB(dbCon);

                if (oAseg.getiNumError() < 0) {
                    bError = true;
                    request.setAttribute("mensaje", oAseg.getsMensError());
                    request.setAttribute("volver", Param.getAplicacion() + "servlet/PropuestaServlet?opcion=getNominaVC&numPropuesta=" + nroPropuesta );
                    doForward (request, response, "/include/MsjHtmlServidor.jsp");
                }
            } else {
// graba grupo - titular:
                int iParentesco = Integer.parseInt (request.getParameter ("prop_add_parentesco"));

                oAseg.setCodProceso(1);
                oAseg.setCodBoca("WEB");
                oAseg.setNumPropuesta(nroPropuesta);
                oAseg.setCodRama(codRama);
                oAseg.setOrden(orden);
                oAseg.setTipoDoc(request.getParameter ("tit_nom_tipDoc"));
                oAseg.setNumDoc(request.getParameter ("tit_nom_numDoc"));
                oAseg.setNombre(request.getParameter ("tit_nom_ApeNom"));
                String fechaNacimiento = (request.getParameter ("tit_nom_fechaNac")==null)?"":request.getParameter ("tit_nom_fechaNac");
                if (fechaNacimiento.equals("")) {
                    oAseg.setFechaNac(null);
                } else {
                    oAseg.setFechaNac(Fecha.strToDate( request.getParameter ("tit_nom_fechaNac") ));
                }
                oAseg.setparentesco(1); // titular
                oAseg.setCertificado(orden);
                oAseg.setSubCertificado(0);
                oAseg.setcodAgrupCob(Integer.parseInt(request.getParameter("prop_cod_agrup_cob_tit")));
                oAseg.setcodCobOpcion(Integer.parseInt(request.getParameter("prop_cod_cob_opcion")));

                oAseg.setDB(dbCon);

                if (oAseg.getiNumError() < 0) {
                    bError = true;
                    request.setAttribute("mensaje", oAseg.getsMensError());
                    request.setAttribute("volver", Param.getAplicacion() + "servlet/PropuestaServlet?opcion=getNominaVC&numPropuesta=" + nroPropuesta );
                    doForward (request, response, "/include/MsjHtmlServidor.jsp");
                }

//graba grupo - conyuge:
//                if (request.getParameter ("cony_nom_ApeNom") != null && request.getParameter("cony_nom_ApeNom").trim().length() > 0) {
                    oAseg.setTipoDoc(request.getParameter ("cony_nom_tipDoc"));
                    oAseg.setNumDoc(request.getParameter ("cony_nom_numDoc"));
                    oAseg.setNombre(request.getParameter ("cony_nom_ApeNom"));
                    fechaNacimiento = (request.getParameter ("cony_nom_fechaNac")==null)?"":request.getParameter ("cony_nom_fechaNac");
                    if (fechaNacimiento.equals("")) {
                        oAseg.setFechaNac(null);
                    } else {
                        oAseg.setFechaNac(Fecha.strToDate( request.getParameter ("cony_nom_fechaNac") ));
                    }
                    oAseg.setparentesco(2); // titular
                    oAseg.setCertificado(orden);
                    oAseg.setSubCertificado(Integer.parseInt (request.getParameter("cony_nom_orden")));
                    oAseg.setcodAgrupCob(Integer.parseInt(request.getParameter("prop_cod_agrup_cob_cony")));
                    oAseg.setcodCobOpcion(Integer.parseInt(request.getParameter("prop_cod_cob_opcion")));

                    oAseg.setDB(dbCon);

                    if (oAseg.getiNumError() < 0 && bError == false ) {
                        request.setAttribute("mensaje", oAseg.getsMensError());
                        request.setAttribute("volver", Param.getAplicacion() +  "servlet/PropuestaServlet?opcion=getNominaVC&numPropuesta=" + nroPropuesta );
                        doForward (request, response, "/include/MsjHtmlServidor.jsp");
                    }

//                }

                if (iParentesco != 99) {
                    String sPrefijo = "adher_";
                    if (iParentesco == 3) {
                        sPrefijo = "hijo_";
                    }
                    oAseg.setTipoDoc(request.getParameter ( sPrefijo + "nom_tipDoc"));
                    oAseg.setNumDoc(request.getParameter (sPrefijo + "nom_numDoc"));
                    oAseg.setNombre(request.getParameter (sPrefijo + "nom_ApeNom"));
                    fechaNacimiento = (request.getParameter (sPrefijo + "nom_fechaNac")==null)?"":request.getParameter (sPrefijo + "nom_fechaNac");
                    if (fechaNacimiento.equals("")) {
                        oAseg.setFechaNac(null);
                    } else {
                        oAseg.setFechaNac(Fecha.strToDate( request.getParameter (sPrefijo + "nom_fechaNac") ));
                    }
                    String sMcaDiscapacitado = ( request.getParameter (sPrefijo + "mca_discapacitado") == null ? "N" :
                                                 request.getParameter (sPrefijo + "mca_discapacitado") );

                    oAseg.setsMcaDiscapacitado(sMcaDiscapacitado);
                    oAseg.setparentesco(iParentesco); // titular
                    oAseg.setCertificado(orden);
                    oAseg.setSubCertificado(-1);
                    oAseg.setDB(dbCon);

                    if (oAseg.getiNumError() < 0 && bError == false) {
                        request.setAttribute("mensaje", oAseg.getsMensError());
                        request.setAttribute("volver", Param.getAplicacion() +  "servlet/PropuestaServlet?opcion=getNominaVC&numPropuesta=" + nroPropuesta );
                        doForward (request, response, "/include/MsjHtmlServidor.jsp");
                    }
                }
            }
            
            String sBenefHerederos = request.getParameter("prop_benef_herederos");
            String sBenefTomador = request.getParameter ("prop_benef_tomador");

            if (sBenefHerederos.equals("N") && sBenefTomador.equals("N") ) {
                LinkedList <Beneficiario> lBenef = new LinkedList ();
                for (int i= 0;i< 4; i++) {
                    Beneficiario oBenef = new Beneficiario ();
                    oBenef.setCertificado(oAseg.getCertificado());
                    oBenef.setnumPropuesta(oAseg.getNumPropuesta());
                    oBenef.setsubCertificado( 0 );
                    oBenef.setnumDoc(request.getParameter ("benef_num_doc_" + i));
                    oBenef.setrazonSocial(request.getParameter ("benef_nombre_" + i));
                    oBenef.setparentesco (Integer.parseInt (request.getParameter ("benef_parentesco_" + i)));
                    oBenef.setporcentaje (Dbl.StrtoDbl(request.getParameter ("benef_porcentaje_" + i)));
                    lBenef.add(oBenef);
                }
                oAseg.setlBenef(lBenef);
                oAseg.setDBBeneficiarios(dbCon);
            } else {
                oAseg.setDBResetBeneficiarios(dbCon);
            }
            
            if (bError == false ) {
                if (oAseg.getiNumError() >= 0) {
                    if (sSig.equals("enviarVC")) {
                        doForward (request, response, "/servlet/PropuestaServlet?opcion=enviarPropuesta" );
                    } else if (sSig.equals("modificarVC")){
                        doForward (request, response, "/servlet/PropuestaServlet?opcion=getPropuestaBenef&numPropuesta=" + nroPropuesta );
                    } else {
                        doForward (request, response, "/servlet/PropuestaServlet?opcion=getNominaVC&numPropuesta=" + nroPropuesta );
                    }
                }
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    /*
     *
     */
    protected void borrarNomina (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {      
        
        Connection dbCon = null;
        try {            
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));                       
            
            int numProceso = 0;                        
            if ( request.getParameter ("prop_proceso") != null && 
                 !request.getParameter ("prop_proceso").equals("") ) {
               numProceso  = Integer.parseInt( request.getParameter ("prop_proceso") );
            }            
            
            String codBoca = request.getParameter ("prop_codBoca");
                        
            int nroPropuesta = 0;
            if ( request.getParameter ("prop_numero") != null && 
                 !request.getParameter ("prop_numero").equals("") ) {
               nroPropuesta  = Integer.parseInt( request.getParameter ("prop_numero") );
            }           
            
            int ordenBorrar = 0;
            if ( request.getParameter ("prop_del_orden") != null && 
                 !request.getParameter ("prop_del_orden").equals("") ) {
               ordenBorrar  = Integer.parseInt( request.getParameter ("prop_del_orden") );
            }      
            
            int cantVidas = 0;
            if ( request.getParameter ("prop_cantVidas") != null && 
                !request.getParameter ("prop_cantVidas").equals("") ) {
                    cantVidas  = Integer.parseInt( request.getParameter ("prop_cantVidas") );
            }                        
            
            dbCon = db.getConnection();
            AseguradoPropuesta oAseg = new AseguradoPropuesta();            
           
            oAseg.setCodProceso(numProceso);
            oAseg.setCodBoca(codBoca);
            oAseg.setNumPropuesta(nroPropuesta);           
            oAseg.setCodRama(10);          
            oAseg.setOrden(ordenBorrar);
            
            oAseg.delDBbyOrden(dbCon);            
           
            /* 
            Propuesta oProp = new Propuesta();
            oProp.setCodProceso  ( oAseg.getCodProceso());
            oProp.setBoca        ( oAseg.getCodBoca() );
            oProp.setNumPropuesta( oAseg.getNumPropuesta());           
            oProp.setCodRama     ( oAseg.getCodRama());                           
            */
            /*
            LinkedList nominas = oAseg.getDBNominasPropuesta(dbCon);
            
            int cantVidas = 0;
            if ( request.getParameter ("prop_cantVidas") != null && 
                !request.getParameter ("prop_cantVidas").equals("") ) {
                    cantVidas  = Integer.parseInt( request.getParameter ("prop_cantVidas") );
            }            
            oProp.setCantVidas(cantVidas);            
                
            request.setAttribute("nominas", nominas);                    
            request.setAttribute("propuesta", oProp);    
            doForward (request, response, "/propuesta/formNomina.jsp");                                                                     
            
            */
            response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);                
            response.setHeader("Location",
                               "/benef/servlet/PropuestaServlet?opcion=borrarNominaRedireccion&codProceso="    + nroPropuesta  +
                                                                                              "&codBoca="      + codBoca         +
                                                                                              "&numPropuesta=" + nroPropuesta +
                                                                                              "&cantVidas="    + cantVidas );                        
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }            
    
    /*
     *
     */
    protected void grabaNominaXls (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {      
        
        Connection dbCon = null;
        try {            
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));      
            
            int numProceso = 0;                        
            if ( request.getParameter ("nomXls_proceso") != null && 
                 !request.getParameter ("nomXls_proceso").equals("") ) {
               numProceso  = Integer.parseInt( request.getParameter ("nomXls_proceso") );
            }            
            
            String codBoca = request.getParameter ("nomXls_codBoca");            
                        
            int nroPropuesta = 0;
            if ( request.getParameter ("nomXls_propuesta") != null && 
                 !request.getParameter ("nomXls_propuesta").equals("") ) {
               nroPropuesta  = Integer.parseInt( request.getParameter ("nomXls_propuesta") );
            }                     
                                
            int cantNom = 0;
            if ( request.getParameter ("nomXls_cantNom") != null && 
                 !request.getParameter ("nomXls_cantNom").equals("") ) {
               cantNom  = Integer.parseInt( request.getParameter ("nomXls_cantNom") );
            }                               
            
            dbCon = db.getConnection();
            
            AseguradoPropuesta oAsegDel = new AseguradoPropuesta();                       
            oAsegDel.setCodProceso(numProceso);
            oAsegDel.setCodBoca(codBoca);
            oAsegDel.setNumPropuesta(nroPropuesta);           
            oAsegDel.setCodRama(10);          
            oAsegDel.delDB(dbCon);      
            //oAseg.setOrden(orden);                            
            // oAseg.delDBbyOrden(dbCon);      
            
            for (int i=1; i<=cantNom;i++) {
                
                int orden = Integer.parseInt( request.getParameter ("nomXls_orden_"+i) );
                
                String sNomApe   = request.getParameter ("nomXls_ApeNom_"+i);            
                String sTipoDoc  = request.getParameter ("nomXls_tipDoc_"+i);            
                String sNumDoc   = request.getParameter ("nomXls_numDoc_"+i);            
                
                AseguradoPropuesta oAsegNew = new AseguradoPropuesta();                                    
                oAsegNew.setCodProceso(numProceso);
                oAsegNew.setCodBoca(codBoca);
                oAsegNew.setNumPropuesta(nroPropuesta);           
                oAsegNew.setCodRama(10);
                oAsegNew.setOrden (orden);  
                
                oAsegNew.setTipoDoc(sTipoDoc);
                oAsegNew.setNumDoc (sNumDoc);
                oAsegNew.setNombre (sNomApe);                                                      
            
                String sFechaNac = (request.getParameter ("nomXls_fechaNac_"+i)==null)?"":request.getParameter ("nomXls_fechaNac_"+i);
                
                if (sFechaNac.equals("")) {
                    oAsegNew.setFechaNac(null);
                } else {
                    oAsegNew.setFechaNac(Fecha.strToDate( request.getParameter ("nomXls_fechaNac_"+i) ));                
                }             
                oAsegNew.setDB(dbCon);                
            }
            
            Propuesta oProp = new Propuesta();
            oProp.setCodProceso  ( oAsegDel.getCodProceso());
            oProp.setBoca        ( oAsegDel.getCodBoca() );
            oProp.setNumPropuesta( oAsegDel.getNumPropuesta());           
            oProp.setCodRama     ( oAsegDel.getCodRama());                           
            
            oProp.getDB(dbCon);
            
            LinkedList nominas = oProp.getDBNominasPropuesta(dbCon);  
            
/*            int cantVidas = 0;
            if ( request.getParameter ("prop_cantVidas") != null && 
                !request.getParameter ("prop_cantVidas").equals("") ) {
                    cantVidas  = Integer.parseInt( request.getParameter ("prop_cantVidas") );
            }            
            oProp.setCantVidas(cantVidas);             
  */          
            request.setAttribute("nominas", nominas);                    
            request.setAttribute("propuesta", oProp);    
            doForward (request, response, "/propuesta/formNomina.jsp");
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        } 
    }                
    
    
    /*
     * Verificar getPropuestaXls
     */    
    protected void getPropuestaXls (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {           
        int    codProceso   = 1;     // oProp.getCodProceso();
        String codBoca      = "WEB"; //oProp.getBoca();    
        int    numPropuesta = Integer.valueOf(request.getParameter("num_propuesta")) ;    
        int    cantNom      = 0 ;
        String path         = (String)request.getParameter("path") ;
        int    cantVidas    = 0;
        if ( request.getParameter ("prop_cantVidas") != null && 
            !request.getParameter ("prop_cantVidas").equals("") ) {
            cantVidas  = Integer.parseInt( request.getParameter ("prop_cantVidas") );
        }            
        
        String pathReal = this.getServletConfig().getServletContext().getRealPath("") ;        
        path = pathReal + path ;                
        
        LinkedList hFilaAux   = new LinkedList();
        LinkedList hFila      = new LinkedList();
        LinkedList nameCol    = new LinkedList();    
        LinkedList typeCol    = new LinkedList();    
        LinkedList hFilaError = new LinkedList();
        // 
        LinkedList lTipoDoc = new LinkedList();
        LinkedList lDoc     = new LinkedList();
         
        String   msgError   = "";
        int      cantidadNominasExcel = 0 ;
        int      cantidadNomReal      = 0 ;
        
        int lineaExcel = 0;
        
        int iFilaSize = 0;
        if (path !=null && !path.equals("") ) {
            // nameCol = new LinkedList();    
            nameCol.add(0,"APELLIDO");
            nameCol.add(1,"NOMBRE");
            nameCol.add(2,"TIPO");
            nameCol.add(3,"DOCUM");
            nameCol.add(4,"F_NACIM");
            int iCantCol = nameCol.size();
            
            // LinkedList typeCol = new LinkedList();    
            typeCol.add(0,"TYPE_STRING");
            typeCol.add(1,"TYPE_STRING");
            typeCol.add(2,"TYPE_STRING");
            typeCol.add(3,"TYPE_NUMERIC");
            typeCol.add(4,"TYPE_DATE");
            
            try {                       
                hFilaAux = xls.getInfoByXls(typeCol,nameCol,path,1);                                                
                cantidadNominasExcel = hFilaAux.size() ;
                
                if (hFilaAux!=null) {
                    
                    if ( cantidadNominasExcel < cantVidas ) {
                        msgError   = "Hay informada " + cantVidas + " personas en la cotización , no se corresponde con las " + cantidadNominasExcel + " personas informadas en el Excel" ;
                        hFilaError.add(msgError);                        
                    } else  {                                                          
                        if (hFilaAux.size() > 0){
                            int iColSize  = nameCol.size();    
                            iFilaSize = hFilaAux.size();             
                            cantNom = iFilaSize; 
                            
                            for ( int i=0 ; i< iFilaSize ; i++ ) {
                                
                                lineaExcel = i+1; 
                                Hashtable has =(Hashtable)hFilaAux.get(i); 
                                
                                if ( lineaExcel == 1) {
                                   hFila.add(has);  
                                }  else {                                   
                                    String apellido = ((String)has.get("APELLIDO"))==null?"":((String)has.get("APELLIDO")).trim().toUpperCase();
//                                    String nombre   = ((String)has.get("NOMBRE"))==null?"":((String)has.get("NOMBRE")).trim().toUpperCase();
                                    String tipo     = ((String)has.get("TIPO"))==null?"":((String)has.get("TIPO")).trim().toUpperCase();
                                    String doc      = ((String)has.get("DOCUM"))==null?"":((String)has.get("DOCUM")).trim();
                                    String nacim    = ((String)has.get("F_NACIM"))==null?"":((String)has.get("F_NACIM")).trim();

                                    if ( apellido.equals("") && 
  //                                       nombre.equals("")   &&
                                         tipo.equals("")     &&
                                         doc.equals("")     &&
                                         nacim.equals("")
                                       ) {
                                       msgError   = "Fila sin información. Fila nro. = " + lineaExcel ;
                                       hFilaError.add(msgError);
                                       break;

                                    }  else {                                   

                                        if ( apellido.equals("") ) {
                                            String error = "El campo del apellido no esta informado. Fila nro. = "  + lineaExcel ;
                                            hFilaError.add(error);
                                        }
/*                                        if ( nombre.equals("") ) {
                                            String error = "El campo del nombre no esta informado. Fila nro. = " + lineaExcel ;
                                            hFilaError.add(error);
                                        }
 *
 */
                                        if ( tipo.equals("") ) {
                                            String error = "El campo del tipo de documento no esta informado. Fila nro. = " + lineaExcel ;
                                            hFilaError.add(error);
                                        } else {
                                            if ( !tipo.equals("DNI")  &&
                                                 !tipo.equals("CUIL") ) {
                                                   String error = "El campo del tipo de documento es incorrecto Fila nro. = " + lineaExcel ;      
                                                   hFilaError.add(error);
                                               }
                                        }                            
                                        if ( doc.equals("") ) {
                                            String error = "El campo del documento no esta informado. Fila nro. = " + lineaExcel ;
                                            hFilaError.add(error);
                                        } else {
                                            if ( ( tipo.equals("CUIL") && doc.length() != 11  ) ||
                                                 ( tipo.equals("DNI") && ( doc.length() < 7 || doc.length() > 8 ) ) ) {
                                                String error = "Long. de documento inválido. Fila nro. = " + lineaExcel ;
                                                hFilaError.add(error);
                                            }
                                            // Validar que el documento no este repetido.-
                                            
                                            for (int j=0; j < lDoc.size();j++) {
                                                String numDoc = (String) lDoc.get(j);
                                                if ( doc.equals(numDoc) ){
                                                    String tipoDoc = (String) lTipoDoc.get(j);
                                                    if (tipo.equals(tipoDoc) ) {
                                                        String error = "Esta repetido el documento = " + tipo + " : " + numDoc  + ". Fila nro. = " + lineaExcel ;
                                                        hFilaError.add(error);                                                        
                                                        break;
                                                    }
                                                }
                                            }
                                            lTipoDoc.add(tipo);
                                            lDoc.add(doc);                                                                                        
                                            
                                        }         
                                        
                                        if ( nacim.equals("") ) {
                                            String error = "El campo del fecha de nacimiento no esta informado. Fila nro. = " + lineaExcel ;
                                            hFilaError.add(error);                                            
                                        }  else {
                                            try {
                                                java.util.Date dFechaNac = Fecha.strToDate(nacim);
                                                // validar que la edad no se superior a 65 años.
                                                
                                            } catch (Exception exp1) {
                                                String error = "Error en el formato de fecha informado. Fila nro. = " + lineaExcel ;
                                                hFilaError.add(error);                                                                                            
                                            }    
                                        }                                                                     
    
                                        cantidadNomReal = cantidadNomReal + 1;
                                        if ( cantidadNomReal > cantVidas ) {                                    
                                            msgError   = "Hay mas personas informadas en el archivo Excel , que las informada en la cotizacion que son " + cantVidas  ;                               
                                           hFilaError.add(msgError);
                                           break;                                        
                                        } else {
                                            hFila.add(has); 
                                            // GRABO HASTA LA CANTIDAD DE VIDA 
                                            if ( cantidadNomReal == cantVidas ) {
                                                break;                                        
                                            } 
                                        } // cantidadNomReal > cantVidas    
                                    } // apellido = "" and ....
                                
                                } // linea excel
                            } // for             
                        }
                    }
                }          
            } catch (Exception e) {
                throw new SurException (e.getMessage());
            }      
        }        
        
        Propuesta oProp = new Propuesta();
        oProp.setCodProceso  ( codProceso );
        oProp.setBoca        ( codBoca );
        oProp.setNumPropuesta( numPropuesta );           
        oProp.setCodRama     ( 10);                                   
        oProp.setCantVidas(cantVidas);                    

        String sUrl = Param.getAplicacion() + "servlet/PropuestaServlet?opcion=grabarNominasDelXlsRedireccion&codProceso=1&codBoca=WEB" +
                                            "&numPropuesta="+ oProp.getNumPropuesta() +
                                            "&cantVidas="+ oProp.getCantVidas();
        if (hFilaError.size() > 0 ) {        
            request.setAttribute("hFilaError"   , hFilaError);                    
            request.setAttribute("hFila"   , hFila);                    
            request.setAttribute("nameCol" , nameCol);                    
            request.setAttribute("typeCol" , typeCol);                                
            request.setAttribute("propuesta", oProp);
            request.setAttribute("volver", sUrl);
            doForward (request, response, "/propuesta/formNominaXls.jsp");
            
        } else {
            
            /* ---------------------------------------------------------------*/
            /* ---------------------------------------------------------------*/
            /* Propuesta VO 15-11-2006*/
            /* -----------------------*/
            // MODIF: por cambio propuesta VO + parametro CodRama -------------->>>>>>>>>>>>
            grabarNominasDelXls(hFila, codProceso,codBoca ,numPropuesta , cantidadNomReal, 10);
            // MODIF: por cambio propuesta VO + parametro CodRama <<<<<<<<<<<<<<------------
            /* ---------------------------------------------------------------*/

            response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);                
            response.setHeader("Location", sUrl );
           
        }          

    }
    
    /*
     * Propuesta VO 15-11-2006 
     * Modif. pro cambio para propuesta VO + parametro codRama     
     */
    private void grabarNominasDelXls ( LinkedList hFila, 
                                       int    numProceso  ,
                                       String codBoca  , 
                                       int    nroPropuesta ,
                                       int    cantidadNomReal,
                                       int    codRama  ) 
    throws ServletException, IOException, SurException {          
        
        Connection dbCon = null;
        try {            
            dbCon = db.getConnection();
            
            AseguradoPropuesta oAsegDel = new AseguradoPropuesta();                       
            oAsegDel.setCodProceso(numProceso);
            oAsegDel.setCodBoca(codBoca);
            oAsegDel.setNumPropuesta(nroPropuesta);           
            oAsegDel.setCodRama(codRama);          
            oAsegDel.delDB(dbCon);    
            
            for (int i=1; i<=cantidadNomReal;i++) {
                AseguradoPropuesta oAseg = new AseguradoPropuesta();                       
                oAseg.setCodProceso     (numProceso);
                oAseg.setCodBoca        (codBoca);
                oAseg.setNumPropuesta   (nroPropuesta);           
                oAseg.setCodRama        (codRama);                          
                Hashtable has =(Hashtable)hFila.get(i); 
                String apellido  = ((String)has.get("APELLIDO"))==null?"":((String)has.get("APELLIDO")).trim();
                String nombre    = ((String)has.get("NOMBRE"))==null?"":((String)has.get("NOMBRE")).trim();
                String sTipoDoc  = ((String)has.get("TIPO"))==null?"":((String)has.get("TIPO")).trim();
                String sNumDoc   = ((String)has.get("DOCUM"))==null?"":((String)has.get("DOCUM")).trim();
                String sFechaNac = ((String)has.get("F_NACIM"))==null?"":((String)has.get("F_NACIM")).trim();                
                
                oAseg.setOrden (i);        
                if        (sTipoDoc.equals("DNI")) {
                    oAseg.setTipoDoc("96");
                } else if (sTipoDoc.equals("CUIL")) {
                    oAseg.setTipoDoc("80");
                }                                
                oAseg.setNumDoc (sNumDoc);
                oAseg.setNombre (apellido + " " + nombre);
                
                if (sFechaNac.equals("")) {
                    oAseg.setFechaNac(null);
                } else {
                    oAseg.setFechaNac(Fecha.add (Fecha.strToDate (sFechaNac ),1));
                }             

                oAseg.setDB(dbCon);                        
            }    
                
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        } 
    }                       
        
/*
 *  enviarPropuesta    
 */
    public void enviarPropuesta (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {      
        
        Connection dbCon = null;
        int numPoliza    = 0;
        int error2       = 0;
        String  sMensaje = "";
        String  sVolver  = "-1";

        try {

            Usuario oUser = (Usuario)(request.getSession().getAttribute("user"));                       
            int nroPropuesta = 0;
            if ( request.getParameter ("prop_numero") != null && 
                 !request.getParameter ("prop_numero").equals("") ) {
               nroPropuesta  = Integer.parseInt( request.getParameter ("prop_numero") );
            }       

            int nroPropuesta2 = 0;
            if ( request.getParameter ("prop_numero_2") != null && 
                 !request.getParameter ("prop_numero_2").equals("") ) {
               nroPropuesta2  = Integer.parseInt( request.getParameter ("prop_numero_2") );
            }       
            
            String opcion = request.getParameter ("opcion");
            
            int codEstado = 1;
            if (opcion.equals("autorizarProp")) { 
                codEstado = 10;
            }
            dbCon = db.getConnection();         
            
            Propuesta oProp = new Propuesta();
            oProp.setNumPropuesta( nroPropuesta);         
            oProp.setUserid      (oUser.getusuario());
            oProp.setCodEstado   (codEstado);                           
            
            oProp.setDBEstado(dbCon);

System.out.println ( "despues del setDBEstado en PRopuestaServlet " + oProp.getCodError() );

            if (oProp.getCodError() >= 0 && oProp.getCodEstado() != 2 ) {
                String sTipoEnvio = verificarTipoEnvio(dbCon, nroPropuesta);

System.out.println ("tipo de envio " + sTipoEnvio);

                if (sTipoEnvio != null && sTipoEnvio.equals("ON_LINE")) {
                        numPoliza = this.enviarPropuestaOnLine(dbCon, nroPropuesta);

System.out.println ("numPoliza  --> " + numPoliza);

                    if ( numPoliza < 0) {
                        oProp.setCodError(numPoliza);
                    } 
                    if ( nroPropuesta2 != 0) {
                        error2  = this.enviarPropuestaOnLine(dbCon, nroPropuesta2 );
                    }                         
                }
            }
            
            if (oProp.getCodError() < 0) {
                sMensaje = ConsultaMaestros.getdescError(dbCon, oProp.getCodError(), "PROPUESTA");
                if (sMensaje == null || sMensaje.equals ("")) {
                    
                    sMensaje = ConsultaMaestros.getdescError(dbCon, oProp.getCodError() * -1 , "PROPUESTA");
                    
                    if (sMensaje == null || sMensaje.equals ("")) {
                        sMensaje = "ERROR DESCONOCIDO EN LA EMISION DE LA PROPUESTA";
                    }
                }
                
/*                switch (oProp.getCodError()) {                
                    case -400 :
                        sMensaje = "La propuesta no pudo ser enviada porque existe otra póliza con deuda del mismo tomador. Por favor, contactese con su representante comercial. Muchas gracias ";
                        break;

                    case -500:
                        sMensaje = "La propuesta no pudo ser enviada porque un asegurado de la nómina ya existe en otra póliza vigente. Por favor, contactese con su representante comercial. Muchas gracias ";
                        break;
                    case -600:
                        sMensaje = "La propuesta no pudo ser enviada porque un asegurado de la nómina ya existe en otra póliza anulada con deuda. Por favor, contactese con su representante comercial. Muchas gracias ";
                        break;
                    case -700:
                        sMensaje = "Ya existe otra póliza vigente de VCO del mismo tomador. Por favor, contactese con su representante comercial. Muchas gracias ";
                        break;
                    case -800:
                        sMensaje = "LA PROPUESTA YA FUE ENVIADA";
                        break;
                    case -900:
                        sMensaje = "UN MOVIMIENTO YA EXISTE EN OTRA PROPUESTA DEL MISMO DIA";
                        break;
                    default:                        
                        sMensaje = ConsultaMaestros.getdescError(dbCon, oProp.getCodError(), "PROPUESTA");
                        if (sMensaje == null || sMensaje.equals ("")) {
                            if (oProp.getDescError() != null ) {
                                sMensaje = oProp.getDescError();
                            } else {
                                sMensaje = "ERROR DESCONOCIDO EN LA EMISION DE LA PROPUESTA";
                            }
                        }
                    }*/
                
            } else {                
                oProp.getDB(dbCon);
                 
                if (oProp.getCodError() < 0) {
                     throw new SurException (oProp.getDescError());
                }
                 
                if (oProp.getTipoPropuesta().equals("P") || oProp.getTipoPropuesta().equals("R")) { 
                    sVolver  = Param.getAplicacion() + "propuesta/printPropuesta.jsp?opcion=printPropuesta&formato=HTML&cod_rama=0&numPropuesta=" + nroPropuesta  +
                                    "&volver=" + (request.getParameter("volver") == null ? "filtrarPropuestas" : request.getParameter("volver")) ;
                    if (numPoliza > 0 ) {
                        oProp.setNumPoliza(numPoliza);             
                    }
                } else {
                    sVolver  = Param.getAplicacion() + "propuesta/printEndoso.jsp?opcion=printEndoso&formato=HTML&cod_rama=0&num_propuesta=" + 
                            nroPropuesta + "&num_propuesta2=" + nroPropuesta2;
                }
                 
                if ( numPoliza > 0 && ( oProp.getTipoPropuesta().equals("P") || oProp.getTipoPropuesta().equals("R")) ) {
                     oProp.setNumPoliza(numPoliza);             
                }

// setear el control de acceso
                      
                int iProcedencia = 38; // OTRAS RAMAS
                 
                if (oProp.getTipoPropuesta().equals ("R") ) {
                     iProcedencia = 31; // TIPO_PROPUESTA = R -> RENOVACIONES
                }
                if (oProp.getTipoPropuesta().equals ("E") || oProp.getTipoPropuesta().equals ("C") ) {
                    iProcedencia  = 20;
                } else if (oProp.getTipoPropuesta().equals ("P") ) {
                            switch (oProp.getCodRama()) {
                                case 9:
                                   iProcedencia = 26;
                                   break;
                                case 10: 
                                   iProcedencia = 22;
                                   break;
                                case 21: 
                                   iProcedencia = 23;
                                   break;
                                case 22: 
                                   iProcedencia = 24;
                                   break;
                                case 25: 
                                   iProcedencia = 37;
                                   break;
                                default: iProcedencia = 38;
                            }
                        }
                 
                ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
                oControl.setearAcceso(dbCon, iProcedencia );
// fin de setear el control de acceso 
                if (oProp.getTipoPropuesta().equals("R") || oProp.getTipoPropuesta().equals("P")) {
                    this.sendEmailCotizacion(dbCon, oUser, oProp );
                } else { 
                    this.sendEmailEndoso (dbCon, oUser, oProp);                    
                }
            }

            if (sVolver.equals ("-1")) {
                String sSig = request.getParameter ("siguiente");
                if (sSig != null ) { 
                    if (sSig.equals("formNomina")) {
                        sVolver = Param.getAplicacion() + "servlet/PropuestaServlet?opcion=grabarPropuestaRedireccion&codProceso=1&codBoca=WEB"+
                                "&numPropuesta="+ oProp.getNumPropuesta() + "&cantVidas="+ oProp.getCantVidas() +
                                "&volver=" + request.getParameter("volver");

                    } else if (sSig.equals ("formNominaVO") || sSig.equals("formNominaXls")) {
                        sVolver = Param.getAplicacion() + "servlet/PropuestaServlet?opcion=getNominaVO&numPropuesta="  +
                                oProp.getNumPropuesta() + "&volver=" + request.getParameter("volver");

                    } else if (sSig.equals("enviarVC")) {
                        sVolver = Param.getAplicacion() + "/servlet/PropuestaServlet?opcion=getNominaVC&numPropuesta=" + oProp.getNumPropuesta();
                    }
                }
            }
            
System.out.println (sMensaje);
System.out.println (sVolver);

            request.setAttribute("mensaje", sMensaje);                
            request.setAttribute("volver", sVolver);
            request.setAttribute("propuesta", oProp);
            doForward (request, response, "/propuesta/mensaje.jsp");
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }                

    
    protected  String verificarTipoEnvio (Connection dbCon, int nroPropuesta )  throws SurException {
        CallableStatement cons = null;
        String retorno = "";
        try {

           dbCon.setAutoCommit(true);

           cons = dbCon.prepareCall(db.getSettingCall( "PRO_VERIFICAR_TIPO_ENVIO ( ?)"));
           cons.registerOutParameter( 1, java.sql.Types.VARCHAR);
           cons.setInt              ( 2, nroPropuesta);

           cons.execute();

           retorno = cons.getString (1);

        }  catch (SQLException se) {
            throw new SurException("Error SQL al modificar el estado : " + se.getMessage());
        } catch (Exception e) {
            throw new SurException ("Error Java: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return retorno;
        }
    }

    protected int enviarPropuestaOnLine (Connection dbCon, int nroPropuesta)
            throws IOException,  SurException {
        URLConnection urlConnection = null;
        BufferedReader inStream = null;
        int vRetorno = 0;
        boolean bProcesarRetorno = true;
        String  _file = "/opt/tomcat/webapps/benef/propiedades/config.xml";
        String sFile    = "/opt/tomcat/webapps/benef/files/ftppino/";
        String sServer  = "dc_server";
        String repositorio = "/opt/tomcat/webapps/benef/files/ftppino/bk";

        try {
                armarArchivos (dbCon, nroPropuesta);
                if ( System.getProperty("os.name" ).contains("Windows") ) {
                    _file = getServletConfig().getServletContext().getRealPath("/benef/propiedades/");
                    _file = _file + "config.xml";
                    sFile = getServletConfig().getServletContext().getRealPath("/benef/files/ftppino/");
                    repositorio = getServletConfig().getServletContext().getRealPath("/benef/files/ftppino/bk");
                }

                if (phpDC.getRealPath() == null) {
                    phpDC.realPath (_file);
                }
                
                StringBuilder sb = new StringBuilder ();
                sb.append("PROGRAMA=").append( phpDC.getPrograma(dbCon, "PHP_EMITE_ONLINE")).append("\n");
                sb.append("NROLOT=").append(Formatos.formatearCeros(String.valueOf(nroPropuesta), 6)).append("\n");

                try {

                    urlConnection = phpDC.getConnection(sb.toString());

System.out.println (urlConnection);

                    inStream =  phpDC.sendRequest(urlConnection);
                    StringBuilder buffer = new StringBuilder();
                    String linea;
                    while((linea = inStream.readLine() ) != null) {
                        buffer.append(linea);
                    }

System.out.println ("paso 7 --> " + buffer.toString());

                    if (buffer == null || ! buffer.toString().endsWith("FIN-PROCESO")) {
                        bProcesarRetorno = false;
                        throw new Exception ("Salida incorrecta:" + (buffer == null ? "nula" : buffer.toString() ));
                    }

                } catch (Exception ioe) {
                        Email oEmail = new Email ();

                        oEmail.setSubject("ERROR EN PROPUESTA ON LINE - PROPUESTA Nº " + nroPropuesta);
                        oEmail.setContent(ioe.getMessage());
                        LinkedList lDest = oEmail.getDBDestinos(dbCon, 0, "ERROR_INTERFACE");

                        for (int i=0; i < lDest.size();i++) {
                            Persona oPers = (Persona) lDest.get(i);
                            oEmail.setDestination(oPers.getEmail());
                            oEmail.sendMessageBatch();
                        }
                        bProcesarRetorno = false;
                }
         
                if (bProcesarRetorno) {
// PROCESAR RESPUESTA
                    vRetorno = procesarVuelta (dbCon, nroPropuesta);
                }

                RenameFile (repositorio , sFile, nroPropuesta );
                
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            return vRetorno;
        }
    }
    private static int procesarVuelta (Connection dbCon, int nroPropuesta) throws SurException {
        String sRespVprop = "/opt/tomcat/webapps/benef/files/ftppino/SOLVPROP.TXT";
        int iNumPolizaRetorno = 0;
        boolean bPrimero = true;
       try {
// PROCESAR RESPUESTA

System.out.println (" entro en procesarVuelta");           
           
            File fRespVprop = new File(sRespVprop + nroPropuesta );

            BufferedReader di = new BufferedReader(new FileReader( fRespVprop));
            String linea;
            /***** Lee línea a línea el  archivo ... ****/
            int numFila = 0;
            do {
                linea = di.readLine();
                if (linea == null) {
                    break;
                }  else {
System.out.println (linea);                    
//193726|3|0|EMITIDA: 10/0167237/086518|2013-02-15|2013-05-14|2013-02-15|2013-02-15
                    String delims = "[|]";
                    String [] aLin = linea.split(delims);

                    Propuesta oProp = new Propuesta ();
                    oProp.setNumPropuesta( Integer.parseInt (aLin [0]));
                    oProp.setCodEstado   ( Integer.parseInt (aLin [1]));
                    oProp.setCodError    ( Integer.parseInt (aLin [2]));

                    oProp.setDBRetornoDC(dbCon, aLin [3], aLin [4]);
                    if (oProp.getCodError() < 0) {
                        throw new SurException( oProp.getDescError() );
                    }
                    if (bPrimero)  {
                        if (Integer.parseInt (aLin [2]) == 0 ) {
                            iNumPolizaRetorno = oProp.getNumPoliza();
                        } else {
                            iNumPolizaRetorno = -1 * Integer.parseInt (aLin [2]);
                        }

                    }

                }
                numFila += 1;
            } while ( true );
            di.close();
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            return iNumPolizaRetorno;
        }
    }

    private static void RenameFile (String repositorio , String sFile, int nroPropuesta )
            throws SurException {

    try {
        String sLote = Formatos.formatearCeros ( String.valueOf (nroPropuesta), 6);

        File fichero1 = new File(sFile + "SOLASEGU.TXT" + sLote );
        File fichero2 = new File(sFile + "SOLCOBER.TXT" + sLote );
        File fichero3 = new File(sFile + "SOLECLA.TXT"  + sLote );
        File fichero4 = new File(sFile + "SOLERROR.TXT" + sLote );
        File fichero5 = new File(sFile + "SOLPROPU.TXT" + sLote );
        File fichero6 = new File(sFile + "SOLTOMAD.TXT" + sLote );
        File fichero7 = new File(sFile + "SOLUBIC.TXT"  + sLote );
        File fichero8 = new File(sFile + "SOLVPROP.TXT" + sLote );

        String sBarra = "/";

        if ( System.getProperty("os.name" ).contains("Windows") ) {
            sBarra = "\\";
        }
        File newFichero1 = new File(repositorio + sBarra + "SOLASEGU.TXT" + sLote );
        File newFichero2 = new File(repositorio + sBarra + "SOLCOBER.TXT" + sLote );
        File newFichero3 = new File(repositorio + sBarra + "SOLECLA.TXT" + sLote );
        File newFichero5 = new File(repositorio + sBarra + "SOLPROPU.TXT" + sLote );
        File newFichero6 = new File(repositorio + sBarra + "SOLTOMAD.TXT" + sLote );
        File newFichero7 = new File(repositorio + sBarra + "SOLUBIC.TXT" + sLote );
        File newFichero8 = new File(repositorio + sBarra + "SOLVPROP.TXT" + sLote );
        File newFichero4 = new File(repositorio + sBarra + "SOLERROR.TXT" + sLote );

        fichero1.renameTo(newFichero1);
        fichero2.renameTo(newFichero2);
        fichero3.renameTo(newFichero3);
        fichero4.renameTo(newFichero4);
        fichero5.renameTo(newFichero5);
        fichero6.renameTo(newFichero6);
        fichero7.renameTo(newFichero7);
        fichero8.renameTo(newFichero8);
    } catch (Exception e) {
            throw new SurException ("CreateFile:" + e.getMessage());
        }
    }

    private static void armarArchivos (Connection dbCon, int lote) throws SurException {
       CallableStatement cons  = null;
       ResultSet rs = null;
       try {

           FileOutputStream fos = new FileOutputStream (getPathFile(dbCon,"PROPUESTA") +
                   Formatos.formatearCeros(String.valueOf(lote), 6));
           OutputStreamWriter osw = new OutputStreamWriter (fos); //, "8859_1");
           BufferedWriter bw = new BufferedWriter (osw);

           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( db.getSettingCall("INT_PRO_IDA_PROPUESTA_NEW (?, ?)"));
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, 0);
           cons.setInt(3, lote);
           cons.execute();

           rs = (ResultSet) cons.getObject(1);
           if (rs != null) {
                while (rs.next()) {
                    bw.write(rs.getString ("CAMPO"));
                }
                rs.close();
            }
            cons.close ();
           bw.flush();
           bw.close();
           osw.close();
           fos.close();

           fos = new FileOutputStream (getPathFile(dbCon,"TOMADOR") +
                   Formatos.formatearCeros(String.valueOf(lote), 6));
           osw = new OutputStreamWriter (fos); //, "8859_1");
           bw  = new BufferedWriter (osw);

           cons = dbCon.prepareCall ( db.getSettingCall("INT_PRO_IDA_TOMADOR_NEW (?, ?)"));
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, 0);
           cons.setInt(3, lote);
           cons.execute();

           rs = (ResultSet) cons.getObject(1);
           if (rs != null) {
                while (rs.next()) {
                    bw.write(rs.getString ("CAMPO"));
                }
                rs.close();
            }

           cons.close();
            bw.flush();
            bw.close();
            osw.close();
            fos.close();

           fos = new FileOutputStream (getPathFile(dbCon,"ASEGURADO") +
                   Formatos.formatearCeros(String.valueOf(lote), 6));
           osw = new OutputStreamWriter (fos); // "8859_1");
           bw = new BufferedWriter (osw);

           cons = dbCon.prepareCall (db.getSettingCall("INT_PRO_IDA_ASEGURADO_NEW(?, ?)"));
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, 0);
           cons.setInt(3, lote);
           cons.execute();

           rs = (ResultSet) cons.getObject(1);
           if (rs != null) {
                while (rs.next()) {
                    bw.write(rs.getString ("CAMPO"));
                }
                rs.close();
            }

           cons.close();
            bw.flush();
            bw.close();
            osw.close();
            fos.close();

            fos = new FileOutputStream (getPathFile(dbCon,"UBICACION") +
                    Formatos.formatearCeros(String.valueOf(lote), 6));
            osw = new OutputStreamWriter (fos); // "8859_1");
            bw = new BufferedWriter (osw);

           cons = dbCon.prepareCall ( db.getSettingCall("INT_PRO_IDA_UBICACION_RIESGO_NEW (?, ?)"));
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, 0);
           cons.setInt(3, lote);
           cons.execute();

           rs = (ResultSet) cons.getObject(1);
           if (rs != null) {
                while (rs.next()) {
                    bw.write(rs.getString ("CAMPO"));
                }
                rs.close();
            }

           cons.close();
            bw.flush();
            bw.close();
            osw.close();
            fos.close();
            
            fos = new FileOutputStream (getPathFile(dbCon,"COBERTURAS") +
                    Formatos.formatearCeros(String.valueOf(lote), 6));
            osw = new OutputStreamWriter (fos); //, "8859_1");
            bw = new BufferedWriter (osw);

           cons = dbCon.prepareCall (db.getSettingCall("INT_PRO_IDA_COBERTURAS_NEW (?, ?)"));
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, 0);
           cons.setInt(3, lote);
           cons.execute();

           rs = (ResultSet) cons.getObject(1);
           if (rs != null) {
                while (rs.next()) {
                    bw.write(rs.getString ("CAMPO"));
                }
                rs.close();
            }

           cons.close();
            bw.flush();
            bw.close();
            osw.close();
            fos.close();

            
            fos = new FileOutputStream (getPathFile(dbCon,"EMPRESAS") +
                    Formatos.formatearCeros(String.valueOf(lote), 6));
            osw = new OutputStreamWriter (fos); //, "8859_1");
            bw = new BufferedWriter (osw);

           cons = dbCon.prepareCall ( db.getSettingCall("INT_PRO_IDA_CLAUSULAS_NEW (?, ?)"));
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt(2, 0);
           cons.setInt(3, lote);
           cons.execute();

           rs = (ResultSet) cons.getObject(1);
           if (rs != null) {
                while (rs.next()) {
                    bw.write(rs.getString ("CAMPO"));
                }
                rs.close();
            }

           cons.close();
            bw.flush();
            bw.close();
            osw.close();
            fos.close();
            
        } catch (Exception e) {
            throw new SurException ("PINCHO EN armarArchivos: " + e.getMessage());

        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
    }

    private static String getPathFile (Connection dbCon, String tabla) throws SurException {
       CallableStatement cons  = null;

       try {
           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( db.getSettingCall("GET_TABLAS_DESCRIPCION(? , ?)"));
           cons.registerOutParameter(1, java.sql.Types.VARCHAR);
           cons.setString (2, "INT_PROPUESTA_PATH_NEW");
           cons.setString (3, tabla);
           cons.execute();

           return cons.getString (1);
        } catch (Exception e) {
            throw new SurException ("PINCHO EN getPathFile: " + e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
    }

    protected void setEliminarPropuesta (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        Connection dbCon = null;
        try {
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));
            int nroPropuesta = 0;
            if ( request.getParameter ("prop_num_prop") != null &&
                 !request.getParameter ("prop_num_prop").equals("") ) {
               nroPropuesta  = Integer.parseInt( request.getParameter ("prop_num_prop") );
            }
            dbCon = db.getConnection();

            Propuesta oProp = new Propuesta();
            oProp.setNumPropuesta( nroPropuesta);
            oProp.setUserid      (oUser.getusuario());

            oProp.setDBDelete(dbCon);

            if (oProp.getCodError() < 0) {
                throw new SurException(oProp.getDescError());
            }

            String  sVolver  = Param.getAplicacion() + "servlet/PropuestaServlet?opcion=getAllProp";


            request.setAttribute("mensaje", "La propuesta ha sido eliminada con exito !!");
            request.setAttribute("volver", sVolver);
            doForward (request, response, "/include/MsjHtmlServidor.jsp");

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }
    
    protected void sendEmailCotizacion (Connection dbCon, Usuario oUser, Propuesta oCot)
    throws ServletException, IOException, SurException {
        StringBuilder  sMensaje = new StringBuilder ();
        String sMsgCuotas = "";
        try {
            if (oCot.getTipoPropuesta().equals("R")){
                sMensaje.append("AVISO DE ENVIO DE RENOVACION - POLIZA N ").append(oCot.getNumPoliza()).append(" - ").append(oCot.getDescRama()).append( " - PROPUESTA N ").append(oCot.getNumPropuesta ()).append("\n");
            } else {
                sMensaje.append("AVISO DE ENVIO DE PROPUESTA DE ").append(oCot.getDescRama()).append( " - N ").append(oCot.getNumPropuesta ()).append("\n");
            }
            
            sMensaje.append("---------------------------------------\n\n");
            sMensaje.append("NUM PROPUESTA: ").append(oCot.getNumPropuesta ()).append("\n");
            sMensaje.append("ESTADO: ").append(oCot.getdescEstado()).append("\n");
            sMensaje.append("ENVIADA POR  : " ).append(oUser.getApellido()).append(" ").append(oUser.getNom()).append("\n");
            sMensaje.append("PRODUCTOR    : ").append(oCot.getdescProd()).append("(").append(oCot.getCodProd()).append(")\n");
            sMensaje.append("NUM COTIZACION: ").append(String.valueOf(oCot.getNumSecuCot())).append("\n");
            sMensaje.append("FECHA        : ").append(
                    (oCot.getFechaEnvioProd() == null ? " " : Fecha.showFechaForm(oCot.getFechaEnvioProd()))
                    ).append(", ").append((oCot.getHoraEnvioProd() == null ? " " : oCot.getHoraEnvioProd() ) ).append
                    ("\n");
            sMensaje.append(" \n");
            sMensaje.append("Tomador           : ").append(oCot.getTomadorRazon ()).append("\n");
            sMensaje.append("DNI               : ").append(oCot.getTomadorDescTipoDoc()).append(
                    " ").append(oCot.getTomadorNumDoc()).append("\n");
            sMensaje.append("Domicilio         : ").append(oCot.getTomadorDom()).append(" ").append(
                    oCot.getTomadorLoc()).append(" (" ).append( oCot.getTomadorCP()).append(") - ").append(
                    oCot.getTomadorDescProv()).append("\n");
            sMensaje.append("Ambito            : ").append(oCot.getDescAmbito   ()).append("\n");
            sMensaje.append("Como enviar poliza: ").append(oCot.getdescMcaEnviarPoliza()).append("\n");
            sMensaje.append("Descripcion Tareas: ").append(oCot.getdescActividad()).append("\n");
            sMensaje.append("Cond I.V.A        : ").append((oCot.getTomadorDescCondIva() == null ?
                "no informado" : oCot.getTomadorDescCondIva())).append("\n");
            sMensaje.append(" \n");
            sMensaje.append("Características del seguro\n");
            sMensaje.append("-------------------------- \n");

            UbicacionRiesgo oRiesgo = new UbicacionRiesgo ();
            oRiesgo = oCot.getoUbicacionRiesgo();
            
            if (oRiesgo != null ) {
                if (oRiesgo.getigualTomador().equals("S")) {
                    sMensaje.append("Ubicacion del riesgo:  idem a la del tomador \n");
                } else {
                    sMensaje.append("Ubicacion del riesgo: ").append(oRiesgo.getdomicilio()).append(" - "
                                                             ).append(oRiesgo.getlocalidad()).append(" (").append(oRiesgo.getcodPostal()).append(") - "
                                                             ).append(oRiesgo.getdescProvincia()).append("\n");
                }
            }
            
            sMensaje.append("Vigencia            : ").append(oCot.getdescVigencia()).append(", desde ").append(Fecha.showFechaForm(oCot.getFechaIniVigPol())).append(" hasta ").append(Fecha.showFechaForm(oCot.getFechaFinVigPol())).append("\n");
            sMensaje.append("Facturacion         : ").append(oCot.getDescFacturacion()).append("\n");
            sMensaje.append("Cantidad de Vidas   : ").append(String.valueOf(oCot.getCantVidas())).append("\n");
            sMensaje.append(" \n");
            sMensaje.append("Descripcion de Coberturas\n");
            sMensaje.append("-------------------------\n");
            sMensaje.append("Muerte por accidente                   $").append(Dbl.DbltoStrPadRight( oCot.getCapitalMuerte(),2, 15)).append("\n");
            sMensaje.append("Invalidez permanente total y/o parcial $").append(Dbl.DbltoStrPadRight( oCot.getCapitalInvalidez(),2, 15)).append("\n");
            sMensaje.append("Asistencia medica farmaceutica         $").append(Dbl.DbltoStrPadRight( oCot.getCapitalAsistencia(),2, 15)).append("\n");
            sMensaje.append("Franquicia                             $").append(Dbl.DbltoStrPadRight( oCot.getFranquicia(),2, 15)).append("\n");
            sMensaje.append(" \n");
            sMensaje.append("Presupuesto\n");
            sMensaje.append("-----------\n");
            sMensaje.append("Prima pura          $").append(Dbl.DbltoStrPadRight( oCot.getprimaPura(),2, 15)).append("\n");
            sMensaje.append("Sub-Total           $").append(Dbl.DbltoStrPadRight( oCot.getsubTotal(),2, 15)).append("\n");
            sMensaje.append("Subtotal            $").append(Dbl.DbltoStrPadRight( oCot.getprimaPura() + oCot.getrecAdmin() ,2, 15)).append("\n");
            sMensaje.append(" GDA            "     ).append(Dbl.DbltoStrPadRight( oCot.getporcGDA(),2, 5) ).append("%  $").append(Dbl.DbltoStrPadRight( oCot.getgda(),2, 11)).append("\n");
            sMensaje.append("Recargos finan. "     ).append(Dbl.DbltoStrPadRight( oCot.getporcRecFinan(),2, 5) ).append("%  $").append(Dbl.DbltoStrPadRight( oCot.getrecFinan(),2, 11)).append("\n");
            sMensaje.append("Derecho de Emision  $").append(Dbl.DbltoStrPadRight( oCot.getderEmi(),2, 15)).append("\n");
            sMensaje.append("Prima Tarifa        $").append(Dbl.DbltoStrPadRight( oCot.getImpPrimaTar(),2, 15)).append("\n");

            if (oCot.getimpAjusteTarifa() != 0) {
                sMensaje.append(" Ajuste de tarifa: ").append(Dbl.DbltoStrPadRight( oCot.getporcAjusteTarifa(),2, 5)).append
                        ("%        $").append(Dbl.DbltoStrPadRight ( oCot.getimpAjusteTarifa(), 2, 11)).append("\n");
            } else {
                sMensaje.append(" Ajustes opciones: no ajusta.\n");
            }
            if (oCot.getcodOpcion() >  0) {
                sMensaje.append(" Ajustes Opcionales: ").append(Dbl.DbltoStrPadRight( oCot.getporcOpcionAjuste() ,2, 5) ).append("%        $").append(Dbl.DbltoStrPadRight( oCot.getimpAjusteTarifa(), 2, 11)).append("\n");
            } else {
                sMensaje.append(" Ajustes opcionales: no ajusta.\n");
            }
            
            sMensaje.append(" IVA ").append( Dbl.DbltoStrPadRight( oCot.getporcIva(),2, 6) ).append("%        $").append(Dbl.DbltoStrPadRight( oCot.getiva(),2, 15)).append("\n");
            sMensaje.append(" Tasa SSN ").append( Dbl.DbltoStrPadRight( oCot.getporcSsn(),2, 6) ).append("%   $").append(Dbl.DbltoStrPadRight( oCot.getssn(),2, 15)).append("\n");
            sMensaje.append(" Serv.Soc ").append( Dbl.DbltoStrPadRight( oCot.getporcSoc(),2, 6) ).append("%   $").append(Dbl.DbltoStrPadRight( oCot.getsoc(),2, 15)).append("\n");
            sMensaje.append(" Sellado  ").append( Dbl.DbltoStrPadRight( oCot.getporcSellado(),2, 6) ).append("%   $").append(Dbl.DbltoStrPadRight( oCot.getsellado(),2, 15)).append("\n");
            sMensaje.append("Premio              $").append(Dbl.DbltoStrPadRight( oCot.getImpPremio(),2, 15)).append("\n");

            StringBuilder sFormaPago = new StringBuilder();
            sFormaPago.append("Forma de Pago:\n");
            sFormaPago.append (oCot.getdescFormaPago()).append(", ").append(oCot.getCantCuotas() ).append(" cuotas de $").append(Dbl.DbltoStr(oCot.getImpCuota() ,2)).append("\n");
            switch ( oCot.getCodFormaPago()) {
                case 1:
                    sFormaPago.append("Tarjeta:").append(oCot.getDescTarjCred()).append(" Nº ").append(oCot.getNumTarjCred()).append(" (").append(oCot.getcodSeguridadTarjeta()).append(").\n" );
//                    sFormaPago.append("Fecha Venc: ").append(Fecha.showFechaForm(oCot.getVencTarjCred())).append( ".\n" );
//                    sFormaPago.append("Titular:").append(oCot.getTitular()).append( ".\n" );
                    break;
                case 4:
                    sFormaPago.append("CBU:").append(oCot.getCbu()).append( ".\n");
                    //sFormaPago.append("Titular:").append(oCot.getTitular()).append( ".\n");
                    break;
                case 6:
                    sFormaPago.append("EMPRESA:").append(oCot.getCodBanco()).append( ".\n");
                    sFormaPago.append("CUENTA:").append(oCot.getCbu()).append( ".\n");
                    sFormaPago.append("CONVENIO:").append(oCot.getTitular()).append( ".\n");
                    break;
                default:
                    sFormaPago.append("\n");
            }

            sMensaje.append(sFormaPago.toString()).append("\n");

            if (oCot.getCodRama() == 10 || oCot.getCodRama () == 22) {
                sMensaje.append("Beneficiarios herederos legales:").append( oCot.getbenefHerederos ()).append( "\n");
                sMensaje.append("Beneficiarios Tomador          :").append( oCot.getbenefTomador ()).append( "\n");
                sMensaje.append("Clausula de No Repeticion      :").append( oCot.getclaNoRepeticion ()).append( "\n");
                sMensaje.append("Clausula de Subrogacion        :").append( oCot.getclaSubrogacion ()).append("\n");

                if (oCot.getAllClausulas().size() > 0 ) {
                    sMensaje.append("Listado de empresas para clausulas:").append("\n\n");
                    for (int i = 1;i <= oCot.getAllClausulas().size() ;i++) {
                        Clausula oCla = (Clausula) oCot.getAllClausulas().get(i - 1);
                        sMensaje.append("Cuit: ").append( oCla.getcuitEmpresa()).append(" - Empresa: ").append( oCla.getdescEmpresa()).append("\n");
                    }
                }
            }
            
            sMensaje.append(" \n");
            sMensaje.append("Nomina de asegurados \n");
            sMensaje.append("-------------------- \n");
            
            LinkedList lNomina = oCot.getDBNominasPropuesta(dbCon);
            
            for( int ii=0; ii < lNomina.size(); ++ii) {
                AseguradoPropuesta oAseg = (AseguradoPropuesta)lNomina.get(ii);
                sMensaje.append("  - ").append(oAseg.getNombre()).append(" ").append(oAseg.getDescTipoDoc()).append(": ").append(oAseg.getNumDoc()).append(" - F. Nac: ").append(( oAseg.getFechaNac() == null ? "no info" : Fecha.showFechaForm(oAseg.getFechaNac()))).append("\n");
            
            }
            
            if (oCot.getObservaciones() != null ) {
                sMensaje.append(" \n");
                sMensaje.append("Observaciones\n");
                sMensaje.append("---------------------------- \n");
                sMensaje.append(oCot.getObservaciones()).append("\n");
            }
            
            sMensaje.append(" \n");            
            sMensaje.append("Este es un mensaje automatico generado por BENEFICIO WEB.\n");
            sMensaje.append("Cualquier duda o consulta puede comunicarse por este medio a webmaster@beneficiosa.com.ar\n");

            Email oEmail = new Email ();

            if (oCot.getTipoPropuesta().equals("R")) {
                oEmail.setSubject((oCot.getCodEstado() == 2 ? "PEND. DE AUTORIZACION - " : "") + "RENOVACION " + oCot.getDescRama() + " - N° " + oCot.getNumPropuesta() + " - Poliza " + oCot.getNumPoliza());
            } else {
                oEmail.setSubject((oCot.getCodEstado() == 2 ? "PEND. DE AUTORIZACION - " : "") + "PROPUESTA " + oCot.getDescRama() + " - N° " + oCot.getNumPropuesta());
            }
            oEmail.setContent(sMensaje.toString());

            LinkedList lDest = oEmail.getDBDestinos (dbCon, oUser.getoficina(), (oCot.getCodEstado() == 2 ? "AUTORIZA_PROP" : "PROPUESTA"));

            for (int i=0; i < lDest.size();i++) {
                Persona oPers = (Persona) lDest.get(i);
                oEmail.setDestination(oPers.getEmail());
            //        oEmail.sendMessage();
                oEmail.sendMessageBatch();
            }
            
        } catch (Exception e) { 
            throw new SurException (e.getMessage());
        }
    }
    
    protected void sendEmailEndoso (Connection dbCon, Usuario oUser, Propuesta oCot)
    throws ServletException, IOException, SurException {
        StringBuilder sMensaje = new StringBuilder();
        try {
      //    String  sMsgCuotas = "En "+ oCot.getCantCuotas() +" cuotas de $"+ Dbl.DbltoStr(oCot.getImpCuota() ,2);
            
            sMensaje.append("AVISO DE SOLICITUD DE ENDOSO DE ").append(oCot.getDescRama()).append(" - N ").append(oCot.getNumPropuesta ()).append("\n");
            
            sMensaje.append("-----------------------------------\n\n");
            sMensaje.append("NUM PROPUESTA: ").append(oCot.getNumPropuesta ()).append("\n");
            sMensaje.append("NUM DE POLIZA: ").append(Formatos.showNumPoliza (oCot.getNumPoliza ())).append("\n");
            sMensaje.append("TIPO DE ENDOSO:").append(oCot.gettipoEndoso());
            sMensaje.append("ENVIADA POR  : ").append(oUser.getApellido()).append(" ").append(oUser.getNom ()).append("\n");
            sMensaje.append("PRODUCTOR    : ").append(oCot.getdescProd()).append("(").append(oCot.getCodProd ()).append(")\n");

            sMensaje.append("FECHA        : " ).append((oCot.getFechaEnvioProd() == null ? " " : Fecha.showFechaForm(oCot.getFechaEnvioProd()))).append(", " ).append((oCot.getHoraEnvioProd() == null ? " " : oCot.getHoraEnvioProd() )).append("\n");
            sMensaje.append(" \n");
            sMensaje.append("Tomador           : " ).append(oCot.getTomadorRazon ()).append( "\n");
            sMensaje.append("Como enviar endoso: ").append(oCot.getdescMcaEnviarPoliza()).append("\n");
            sMensaje.append(" \n");
            sMensaje.append("Cantidad de Vidas   : ").append(String.valueOf(oCot.getCantVidas())).append("\n");
            sMensaje.append(" \n");
            sMensaje.append("Nómina de asegurados \n");
            sMensaje.append("-------------------- \n");
            
            LinkedList lNomina = oCot.getDBNominasPropuesta(dbCon);
            
            for( int ii=0; ii < lNomina.size(); ++ii) {
                AseguradoPropuesta oAseg = (AseguradoPropuesta)lNomina.get(ii);
                sMensaje.append("  - " ).append(oAseg.getNombre()).append( " ").append(oAseg.getDescTipoDoc()).append( ": " );
                sMensaje.append(oAseg.getNumDoc()).append(" - F. Nac: "               ).append(( oAseg.getFechaNac() == null ? "no info" :
                            Fecha.showFechaForm(oAseg.getFechaNac())));
                sMensaje.append(" - ").append(oAseg.getEstado().equals ("A") ? "ALTA" : "BAJA").append("\n");
            
            }
            sMensaje.append(" \n");
            sMensaje.append("Este es un mensaje autom�tico generado por BENEFICIO WEB.\n");
            sMensaje.append("Cualquier duda o consulta puede comunicarse por este medio a webmaster@beneficiosa.com.ar\n");

            Email oEmail = new Email ();

            oEmail.setSubject("ENDOSO " + oCot.getDescRama() + " - Nº " + oCot.getNumPropuesta());
            oEmail.setContent(sMensaje.toString());

            LinkedList lDest = oEmail.getDBDestinos(dbCon, oUser.getoficina(), "ENDOSOS");

            for (int i=0; i < lDest.size();i++) {
                Persona oPers = (Persona) lDest.get(i);
                oEmail.setDestination(oPers.getEmail());
                  //  oEmail.sendMessage();
                oEmail.sendMessageBatch();
            }
             
            
        } catch (Exception e) { 
            throw new SurException (e.getMessage());
        }
    }
    
    /* ---------------------------------------------------------------------- */
    /* Propuesta VO 15-11-2006                                                */
    /* ---------------------------------------------------------------------- */
    
    /*
     * Grabar datos de la propuestaVO .
     */
    protected void grabarPropuestaVO (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {        
        
        Connection dbCon = null;
        try {            
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));                     
            
            int nroProp = 0;                        
            if ( request.getParameter ("prop_num_prop") != null && 
                 !request.getParameter ("prop_num_prop").equals("") ) {                 
                 nroProp  = Integer.parseInt( request.getParameter ("prop_num_prop") );    
            }              

            dbCon = db.getConnection();
            Propuesta oProp = new Propuesta();
            if (nroProp > 0) {
                oProp.setNumPropuesta(nroProp);
                oProp.getDB(dbCon);
                if (oProp.getCodError() < 0 ) {
                    throw new SurException(oProp.getDescError());
                }
                if (oProp.getCodEstado() != 0 && oProp.getCodEstado() != 4) {
                    throw new SurException("LA PROPUESTA NO PUEDE SER MODIFICADA");
                }
            }

            int codProd = 0;                        
            if ( request.getParameter ("prop_cod_prod") != null && 
                 !request.getParameter ("prop_cod_prod").equals("") ) {
               codProd  = Integer.parseInt( request.getParameter ("prop_cod_prod") );
            }            
                        
            int codVig = 0;
            if ( request.getParameter ("prop_vig") != null && 
                 !request.getParameter ("prop_vig").equals("") ) {
               codVig  = Integer.parseInt( request.getParameter ("prop_vig") );
            }                                                        

            int codActividad = 0;
            if ( request.getParameter ("prop_aseg_actividad") != null && 
                 !request.getParameter ("prop_aseg_actividad").equals("") ) {
               codActividad  = Integer.parseInt( request.getParameter ("prop_aseg_actividad") );
            }         
            
            int cantCuota = 0;                        
            if ( request.getParameter ("prop_cant_cuotas") != null && 
                 !request.getParameter ("prop_cant_cuotas").equals("") ) {
               cantCuota  = Integer.parseInt( request.getParameter ("prop_cant_cuotas") );
            }            
                        
            int numSocio = 0;                        
            if ( request.getParameter ("prop_numSocio") != null && 
                 !request.getParameter ("prop_numSocio").equals("") ) {
               numSocio  = Integer.parseInt( request.getParameter ("prop_numSocio") );
            }
            
            String observacion   = request.getParameter ("prop_obs");
            
            int codFormaPago = 0;
            if ( request.getParameter ("prop_form_pago") != null && 
                 !request.getParameter ("prop_form_pago").equals("") ) {
               codFormaPago  = Integer.parseInt( request.getParameter ("prop_form_pago") );
            }                        
            
            double premio = 0;                        
            if ( request.getParameter ("prop_premio") != null && 
                 !request.getParameter ("prop_premio").equals("") ) {
               premio  = Dbl.StrtoDbl( request.getParameter ("prop_premio") );
            }                       
            
            int numCotizacion = 0;                     
            if ( request.getParameter ("prop_nro_cot") != null && 
                 !request.getParameter ("prop_nro_cot").equals("") ) {
               numCotizacion  = Integer.parseInt( request.getParameter ("prop_nro_cot") );
            }                     
            
            int codEstado = 0;          
            if ( request.getParameter ("prop_cod_est") != null && 
                 !request.getParameter ("prop_cod_est").equals("") ) {                 
                 codEstado  = Integer.parseInt( request.getParameter ("prop_cod_est") );    
            }                     
            
            int codRama = 0;          
            if ( request.getParameter ("prop_rama") != null && 
                 !request.getParameter ("prop_rama").equals("") ) {                 
                 codRama  = Integer.parseInt( request.getParameter ("prop_rama") );    
            }
            int  numReferencia = 0;
            if ( request.getParameter ("prop_num_referencia") != null &&
                 !request.getParameter ("prop_num_referencia").equals("") ) {
               numReferencia  = Integer.parseInt ( request.getParameter ("prop_num_referencia")) ;
            }

            oProp.setCodProceso   (1);
            oProp.setBoca         ("WEB");
            oProp.setCodRama      (codRama);            
            oProp.setNumPropuesta (nroProp);                      
            oProp.setCodSubRama   (1);
            oProp.setNumPoliza    (0);
            oProp.setCodCobFinal  (0);
            oProp.setCodMoneda    (1);           
            oProp.setImpPremio    (premio);                   
            oProp.setCodFormaPago (codFormaPago);  
            oProp.setImpCuota     (0);
            oProp.setCodProd      (codProd); 
            oProp.setNumTomador   (numSocio); 
            oProp.setPeriodoFact  (0);
            oProp.setCantCuotas   (cantCuota); 
            oProp.setCodActividad (codActividad);            
            
            oProp.setmcaEnvioPoliza(request.getParameter ("prop_mca_envio_poliza") == null ? "S" : request.getParameter ("prop_mca_envio_poliza"));
            
            String fechaVigDesde = (request.getParameter ("prop_vig_desde")==null)?"":request.getParameter ("prop_vig_desde");
            
            if (fechaVigDesde.equals("")) {
                oProp.setFechaIniVigPol(null);
            } else {                
                oProp.setFechaIniVigPol( Fecha.strToDate( request.getParameter ("prop_vig_desde") ));
            }    
            
//            String fechaVigHasta = (request.getParameter ("prop_vig_hasta")==null)?"":request.getParameter ("prop_vig_hasta");
//            if (fechaVigHasta.equals("")) {
            oProp.setFechaFinVigPol(null);
/*            } else {                
                oProp.setFechaFinVigPol( Fecha.strToDate( request.getParameter ("prop_vig_hasta")));
            }                    
*/
            oProp.setCodVigencia(codVig);
            if (request.getParameter ("prop_cantVidas") != null) {
                oProp.setCantVidas( Integer.parseInt (request.getParameter ("prop_cantVidas")) );
            }
            if (request.getParameter ("prop_fac") != null) {
                oProp.setCodFacturacion(Integer.parseInt (request.getParameter ("prop_fac")) );
            }            
            oProp.setCodEstado(codEstado); 
            oProp.setObservaciones(observacion); 
            oProp.setNumSecuCot(numCotizacion); 
            oProp.setUserid(oUser.getusuario());            

            oProp.setbenefHerederos     (request.getParameter ("prop_benef_herederos") == null ? "N" : request.getParameter ("prop_benef_herederos"));
            oProp.setbenefTomador       (request.getParameter ("prop_benef_tomador") == null ? "N" : request.getParameter ("prop_benef_tomador"));
            
            if (request.getParameter ("prop_mca_empleada") == null || 
                request.getParameter ("prop_mca_empleada").equals("N") ) {
                oProp.setcodPlan(1);
                oProp.setcodProducto(1);
            } else {
                oProp.setcodProducto(2);
                oProp.setcodPlan(2);                
            }

            oProp.setnumReferencia(numReferencia);
            oProp.setTipoPropuesta(request.getParameter ("prop_tipo_propuesta"));

            oProp.setDB(dbCon);  

            if (oProp.getCodError() != 0) {
                request.setAttribute("mensaje", oProp.getDescError());
                request.setAttribute("volver", Param.getAplicacion() + "index.jsp");
                doForward (request, response, "/include/MsjHtmlServidor.jsp");
            }
            
            if (oProp.getNumPropuesta() > 0) {                   
                // ----------------------
                // DATOS DE FORMA DE PAGO
                // ----------------------
                // 1 - TARJETA DE CREDITO.-
                if ( oProp.getCodFormaPago() ==1 ) {
                    int codTarjCred = 0;
                    if ( request.getParameter ("pro_TarCred") != null &&
                         !request.getParameter ("pro_TarCred").equals("") ) {
                        codTarjCred  = Integer.parseInt( request.getParameter ("pro_TarCred") );
                    }

                    int codTarjBco = 0;
                    if ( request.getParameter ("pro_TarCredBco") != null &&
                         !request.getParameter ("pro_TarCredBco").equals("") ) {
                        codTarjBco  = Integer.parseInt( request.getParameter ("pro_TarCredBco") );
                    }
                    String nroTarjCred      = request.getParameter ("pro_TarCredNro");
                    String fechaVtoTarjCred = request.getParameter ("pro_TarCredVto");
                    String titularTarjCred  = request.getParameter ("pro_TarCredTit");

                    oProp.setCodTarjCred(codTarjCred);
                    oProp.setNumTarjCred(nroTarjCred);

                    if (fechaVtoTarjCred.equals("")) {
                        oProp.setVencTarjCred(null);
                    } else {
                        oProp.setVencTarjCred( Fecha.strToDate( fechaVtoTarjCred));
                    }
                    oProp.setCodBanco(codTarjBco);
                    oProp.setTitular(titularTarjCred);
                    oProp.setcodSeguridadTarjeta(request.getParameter ("pro_TarCredCodSeguridad"));

                    oProp.setDBTarjetaCredito(dbCon);

                // 2-3 - DEBITO no va mas / 6 = Debito bancario por sobre
                } else if ( oProp.getCodFormaPago() == 6  ) {

                    int codCtaBco = 0;
                    if ( request.getParameter ("pro_CtaBco") != null &&
                         !request.getParameter ("pro_CtaBco").equals("") ) {
                        codCtaBco  = Integer.parseInt( request.getParameter ("pro_CtaBco") );
                    }
                    String cbu      = request.getParameter ("pro_cuenta_banco");
                    String titular  = request.getParameter ("pro_convenio");

                    oProp.setCodBanco(codCtaBco);
                    oProp.setTitular(titular);
                    oProp.setCbu(cbu);
                    oProp.setDBBancoConvenio(dbCon);
                // DEBITO CUENTA
                } else if ( oProp.getCodFormaPago() == 4  ) {
                    String cbu      = request.getParameter ("pro_DebCtaCBU");
                    String titular  = request.getParameter ("pro_CtaTit");
                    oProp.setCbu     (cbu);
                    oProp.setTitular (titular);
                    oProp.setDBTarjetaDebitoCuenta(dbCon);
                } else {
                    // Otro forma de pago debe resetear otros campos de forma de Pago.
                    oProp.setDBFormaPagoReset(dbCon);
                }
                // ------------------
                // DATOS DEL TOMADOR
                // ------------------
                String tipoDocTomador = request.getParameter ("prop_tom_tipoDoc");
                String nroDocTomador  = request.getParameter ("prop_tom_nroDoc");
                String TomadorNom     = request.getParameter ("prop_tom_nombre");
                String TomadorApe     = request.getParameter ("prop_tom_apellido");

                int ivaTomador = 0;                        
                if ( request.getParameter ("prop_tom_iva") != null && 
                     !request.getParameter ("prop_tom_iva").equals("") ) {
                   ivaTomador  = Integer.parseInt( request.getParameter ("prop_tom_iva") );
                }                    
                String domTomador    = request.getParameter ("prop_tom_dom");            
                String locTomador    = request.getParameter ("prop_tom_loc");                        
                String cpTomador     = request.getParameter ("prop_tom_cp");

                String mailTomador   = request.getParameter ("prop_tom_email");            
                String teTomador     = request.getParameter ("prop_tom_te");            
                String provTomador   = request.getParameter ("prop_tom_prov");            

                PersonaPoliza oTom   = new PersonaPoliza();
                oTom.setnumTomador  (numSocio);
                oTom.settipoDoc     (tipoDocTomador);
                oTom.setnumDoc      (nroDocTomador);
                oTom.setrazonSocial (TomadorApe + " " + TomadorNom);
                oTom.setnombre      (TomadorNom);
                oTom.setapellido    (TomadorApe);
                oTom.setcodCondicionIVA(ivaTomador);            
                oTom.setdomicilio   (domTomador);
                oTom.setlocalidad   (locTomador);
                oTom.setcodPostal   (cpTomador );
                oTom.setmail        (mailTomador);
                oTom.settelefono    (teTomador);
                oTom.setprovincia   (provTomador);                
                
                oTom.setcodProceso        (oProp.getCodProceso());
                oTom.setcodBoca           (oProp.getBoca());
                oTom.setnumPropuesta      (oProp.getNumPropuesta());
                oTom.setDBTomadorPropuesta(dbCon);

                if (oProp.getNumSecuCot() == 0 ) {
// ------------------
// DATOS DE COBERTURA
// ------------------                                
// MUERTE
                    double capMuerte  = 0;
                    if ( request.getParameter ("prop_cap_muerte") != null &&
                         !request.getParameter ("prop_cap_muerte").equals("") ) {
                        capMuerte  = Dbl.StrtoDbl(request.getParameter ("prop_cap_muerte") );
                    }
                    AsegCobertura oCob = new AsegCobertura();
                    oCob.setcodProceso  (oProp.getCodProceso());
                    oCob.setcodBoca     (oProp.getBoca());
                    oCob.setnumPropuesta(oProp.getNumPropuesta());
                    oCob.setcodRama     (oProp.getCodRama());
                    oCob.setcodSubRama  (oProp.getCodSubRama());

                    // COB=1 Muerte
                    oCob.setcodCob(1);
                    oCob.setimpSumaRiesgo(capMuerte);
                    oCob.setDBCobPropuesta(dbCon);
                }
                
                response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);                
                response.setHeader("Location",
                                   "/benef/servlet/PropuestaServlet?opcion=getNominaVO&numPropuesta="  + oProp.getNumPropuesta()  +
                                "&volver=" + (request.getParameter("volver") == null ? "filtrarPropuestas" : request.getParameter("volver")) );
                

            } else {
                String sMensaje = "";                
                sMensaje = "Hubo algún problema en el alta del propuesta. Por favor, comuniquese con su representante</br></br>Muchas Gracias.";
                request.setAttribute("mensaje", sMensaje);                
                request.setAttribute("volver", Param.getAplicacion() + "index.jsp");                       

                doForward (request, response, "/include/MsjHtmlServidor.jsp"); 
            }            
        } catch (SurException se) {
            throw new SurException (se.getMessage());            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }               
    
    /*
     * getNominaVO
     */
    protected void getNominaVO (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {    
        Connection dbCon = null;
        try {            
            int    numPropuesta  = 0;                
            if ( request.getParameter ("numPropuesta") != null && 
                     !request.getParameter ("numPropuesta").equals("") ) {
                   numPropuesta  = Integer.parseInt( request.getParameter ("numPropuesta") );
            }

            dbCon = db.getConnection();              
            Propuesta oProp = new Propuesta();
            oProp.setNumPropuesta(numPropuesta);            
            oProp.getDB(dbCon);

            LinkedList nominas = oProp.getDBNominasPropuesta(dbCon);                          
            request.setAttribute("nominas", nominas);        
            request.setAttribute("propuesta", oProp); 
            doForward (request, response, "/propuesta/formNominaVO.jsp");            
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }                    
    }    

    protected void getNominaVC (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {
            int    numPropuesta  = 0;
            if ( request.getParameter ("numPropuesta") != null &&
                     !request.getParameter ("numPropuesta").equals("") ) {
                   numPropuesta  = Integer.parseInt( request.getParameter ("numPropuesta") );
            }

            dbCon = db.getConnection();
            Propuesta oProp = new Propuesta();
            oProp.setNumPropuesta(numPropuesta);
            oProp.getDB(dbCon);

            LinkedList nominas = oProp.getDBNominasPropuesta(dbCon);
           
            request.setAttribute("nominas", nominas);
            request.setAttribute("propuesta", oProp);
            
            if ( oProp.gettipoNomina().equals("S") ) { // simple
                doForward (request, response, "/propuesta/formNominaVO.jsp");
            } else if (oProp.gettipoNomina().equals("G")) { // Grupo Simple
                doForward (request, response, "/propuesta/formNominaVCG.jsp");
            } else if (oProp.gettipoNomina().equals("GM")) {// Grupo multiple
                doForward (request, response, "/propuesta/formNominaVCGrupos.jsp");
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }
    
     /*
     * Add Persona (VO)
     * Modif.: 21-10-2006 Adaptado para uso de VC 
     * Propuesta VC -SUP  21-10-2007 >>>>>>>>>>>>>
     *
     */   
   protected void addPersona (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {        
        
        Connection dbCon = null;
        try {            
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));         
            
            int numProceso = 0;                        
            if ( request.getParameter ("prop_proceso") != null && 
                 !request.getParameter ("prop_proceso").equals("") ) {
               numProceso  = Integer.parseInt( request.getParameter ("prop_proceso") );
            }            
            
            String codBoca = request.getParameter ("prop_codBoca");
                        
            int nroPropuesta = 0;
            if ( request.getParameter ("prop_numero") != null && 
                 !request.getParameter ("prop_numero").equals("") ) {
               nroPropuesta  = Integer.parseInt( request.getParameter ("prop_numero") );
            }           
            int orden = 0;
            if ( request.getParameter ("prop_nom_orden") != null && 
                 !request.getParameter ("prop_nom_orden").equals("") ) {
               orden  = Integer.parseInt( request.getParameter ("prop_nom_orden") );
            }    
            
            int cantVidas = 0;
            if ( request.getParameter ("prop_cantVidas") != null && 
                !request.getParameter ("prop_cantVidas").equals("") ) {
                    cantVidas  = Integer.parseInt( request.getParameter ("prop_cantVidas") );
            }                         
            
            int codRama = 0;          
            if ( request.getParameter ("prop_rama") != null && 
                 !request.getParameter ("prop_rama").equals("") ) {                 
                 codRama  = Integer.parseInt( request.getParameter ("prop_rama") );    
            }
            
            String apeNom = request.getParameter ("prop_nom_ApeNom");
            String tipDoc = request.getParameter ("prop_nom_tipDoc");
            String numDoc = request.getParameter ("prop_nom_numDoc");
            String mano   = request.getParameter("prop_nom_mano");

            AseguradoPropuesta oAseg = new AseguradoPropuesta();

            oAseg.setCodProceso  (numProceso);
            oAseg.setCodBoca     (codBoca);
            oAseg.setNumPropuesta(nroPropuesta);
            oAseg.setCodRama     (codRama);
            oAseg.setOrden       (orden);
            oAseg.setTipoDoc     (tipDoc);
            oAseg.setNumDoc      (numDoc);
            oAseg.setNombre      (apeNom);
            oAseg.setmano        (mano);

            String fechaNacimiento = (request.getParameter ("prop_nom_fechaNac")==null)?"":request.getParameter ("prop_nom_fechaNac");
            if (fechaNacimiento.equals("")) {
                oAseg.setFechaNac(null);
            } else {
                oAseg.setFechaNac(Fecha.strToDate( request.getParameter ("prop_nom_fechaNac") ));
            }

            dbCon = db.getConnection();
            oAseg.setDB(dbCon);
            if (oAseg.getiNumError() >= 0 ) {
                String sUrl= "/benef/servlet/PropuestaServlet?opcion=getNominaVO&numPropuesta="  + oAseg.getNumPropuesta() +
                                "&volver=" + (request.getParameter("volver") == null ? "filtrarPropuestas" : request.getParameter("volver"));

                response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
                response.setHeader("Location", sUrl);
            } else {
                String sMensaje = oAseg.getsMensError();
                request.setAttribute("mensaje", sMensaje);
                request.setAttribute("volver", "-1");
                doForward (request, response, "/include/MsjHtmlServidor.jsp");
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }    
    

    /*
     * Borrar Persona (VO,VC)
     * Modif.: 21-10-2006 Adaptado para uso de VC 
     * Propuesta VC -SUP  21-10-2007 >>>>>>>>>>>>>     
     *
     */    
    protected void delPersona (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        Connection dbCon = null;
        try {
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));

            int numProceso = 1;
/*            if ( request.getParameter ("prop_proceso") != null &&
                 !request.getParameter ("prop_proceso").equals("") ) {
               numProceso  = Integer.parseInt( request.getParameter ("prop_proceso") );
            }
 *
 */
            String codBoca = "WEB"; // request.getParameter ("prop_codBoca");

            int nroPropuesta = 0;
            if ( request.getParameter ("prop_numero") != null &&
                 !request.getParameter ("prop_numero").equals("") ) {
               nroPropuesta  = Integer.parseInt( request.getParameter ("prop_numero") );
            }

            int ordenBorrar = 0;
            if ( request.getParameter ("prop_del_orden") != null &&
                 !request.getParameter ("prop_del_orden").equals("") ) {
               ordenBorrar  = Integer.parseInt( request.getParameter ("prop_del_orden") );
            }

            int cantVidas = 0;
            if ( request.getParameter ("prop_cantVidas") != null &&
                !request.getParameter ("prop_cantVidas").equals("") ) {
                    cantVidas  = Integer.parseInt( request.getParameter ("prop_cantVidas") );
            }

            int codRama = 0;
            if ( request.getParameter ("prop_rama") != null &&
                 !request.getParameter ("prop_rama").equals("") ) {
                 codRama  = Integer.parseInt( request.getParameter ("prop_rama") );
            }

            String sTipoNomina = (request.getParameter("prop_tipo_nomina") == null ? "S" : request.getParameter("prop_tipo_nomina"));

            int iSubCertificado = 0;
            if (! sTipoNomina.equals("S")) {
                iSubCertificado = Integer.parseInt (request.getParameter ("prop_del_sub_certificado"));
            }

            AseguradoPropuesta oAseg = new AseguradoPropuesta();

            oAseg.setCodProceso    (numProceso);
            oAseg.setCodBoca       (codBoca);
            oAseg.setNumPropuesta  (nroPropuesta);
            oAseg.setCodRama       (codRama);
            oAseg.setOrden         (ordenBorrar);
            oAseg.setCertificado   (ordenBorrar);
            oAseg.setSubCertificado(iSubCertificado);

            dbCon = db.getConnection();
            oAseg.delDBbyOrden(dbCon);

            if (oAseg.getiNumError() == 0 ) {
                String sUrl = "/benef/servlet/PropuestaServlet?opcion=getNominaVC&numPropuesta="  + oAseg.getNumPropuesta() +
                                "&volver=" + (request.getParameter("volver") == null ? "filtrarPropuestas" : request.getParameter("volver")) ;
                response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
                response.setHeader("Location", sUrl);
            } else {
                String sMensaje = oAseg.getsMensError();
                if (oAseg.getiNumError() == -100) {
                    sMensaje = "LA PROPUESTA YA FUE ENVIADA";
                }
                request.setAttribute("mensaje", sMensaje);
                request.setAttribute("volver", "-1");
                doForward (request, response, "/include/MsjHtmlServidor.jsp");
            }


        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    /*
     * getPropuestaXls   -- USADO PARA CARGAR LA NOMINA VIA EXCEL PARA VIDA OBLIGATORIO
     * toma codRama
     */
    protected void getNominaXls (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        int    codProceso   = 1;     // oProp.getCodProceso();
        String codBoca      = "WEB"; //oProp.getBoca();
        int    numPropuesta = Integer.valueOf(request.getParameter("num_propuesta")) ;
        int    cantNom      = 0 ;
        String path         = (String)request.getParameter("path") ;

        int    cantVidas    = 0;
        if ( request.getParameter ("prop_cantVidas") != null &&
            !request.getParameter ("prop_cantVidas").equals("") ) {
            cantVidas  = Integer.parseInt( request.getParameter ("prop_cantVidas") );
        }

        int codRama = 0;
        if ( request.getParameter ("prop_rama") != null &&
             !request.getParameter ("prop_rama").equals("") ) {
            codRama  = Integer.parseInt( request.getParameter ("prop_rama") );
        }

        String pathReal = this.getServletConfig().getServletContext().getRealPath("") ;
        path = pathReal + path ;

        LinkedList hFilaAux   = new LinkedList();
        LinkedList hFila      = new LinkedList();
        LinkedList nameCol    = new LinkedList();
        LinkedList typeCol    = new LinkedList();
        LinkedList hFilaError = new LinkedList();
        LinkedList lTipoDoc   = new LinkedList();
        LinkedList lDoc       = new LinkedList();

        String   msgError   = "";
        int      cantidadNominasExcel = 0 ;
        int      cantidadNomReal      = 0 ;

        int lineaExcel = 0;

        int iFilaSize = 0;
        if (path !=null && !path.equals("") ) {
            nameCol.add(0,"APELLIDO");
            nameCol.add(1,"NOMBRE");
            nameCol.add(2,"TIPO");
            nameCol.add(3,"DOCUM");
            nameCol.add(4,"F_NACIM");
            int iCantCol = nameCol.size();

            typeCol.add(0,"TYPE_STRING");
            typeCol.add(1,"TYPE_STRING");
            typeCol.add(2,"TYPE_STRING");
            typeCol.add(3,"TYPE_NUMERIC");
            typeCol.add(4,"TYPE_DATE");

            try {

                hFilaAux = xls.getInfoByXls(typeCol,nameCol,path,1);

                cantidadNominasExcel = hFilaAux.size() ;

                if (hFilaAux!=null) {

                    if ( cantidadNominasExcel < cantVidas ) {
                        msgError   = "Hay informada " + cantVidas + " personas en la propuesta, no se corresponde con las " + cantidadNominasExcel + " personas informadas en el Excel" ;
                        hFilaError.add(msgError);
                    } else  {
                        if (hFilaAux.size() > 0){
                            int iColSize  = nameCol.size();
                            iFilaSize = hFilaAux.size();             
                            cantNom = iFilaSize; 
                            
                            for ( int i=0 ; i< iFilaSize ; i++ ) {
                                
                                lineaExcel = i+1; 
                                Hashtable has =(Hashtable)hFilaAux.get(i); 
                                
                                if ( lineaExcel == 1) {
                                   hFila.add(has);  
                                }  else {                                   

                                    String apellido = ((String)has.get("APELLIDO"))==null?"":((String)has.get("APELLIDO")).trim().toUpperCase();
                                    String nombre   = ((String)has.get("NOMBRE"))==null?"":((String)has.get("NOMBRE")).trim().toUpperCase();
                                    String tipo     = ((String)has.get("TIPO"))==null?"":((String)has.get("TIPO")).trim().toUpperCase();
                                    String doc      = ( (String)has.get("DOCUM"))==null?"": ((String)has.get("DOCUM")).trim();

                                    doc = doc.replace(".", "");
                                    doc = doc.replace ("-", "");
                                    doc = doc.replace ("/", "");
                                    doc = doc.replace (" ", "");
                                    String nacim    = ((String)has.get("F_NACIM"))==null?"":((String)has.get("F_NACIM")).trim();

                                    if ( apellido.equals("") &&
//                                         nombre.equals("")   &&
                                         tipo.equals("")     &&
                                         doc.equals("")     &&
                                         nacim.equals("")
                                       ) {

                                       msgError   = "Fila sin informacion. Fila nro. = " + lineaExcel ;
                                       hFilaError.add(msgError);
                                       break;

                                    }  else {

                                        if ( apellido.equals("") ) {
                                            String error = "El campo del apellido no esta informado. Fila nro. = "  + lineaExcel ;
                                            hFilaError.add(error);
                                        }
  /*                                      if ( nombre.equals("") ) {
                                            String error = "El campo del nombre no esta informado. Fila nro. = " + lineaExcel ;
                                            hFilaError.add(error);
                                        }
   *
   */
                                        if ( tipo.equals("") ) {
                                            String error = "El campo del tipo de documento no esta informado. Fila nro. = " + lineaExcel ;
                                            hFilaError.add(error);
                                        } else {
                                            if (codRama == 21) {
                                                if (!tipo.equals("CUIL") && !tipo.equals("CUIT")) {
                                                       String error = "Tipo de documento inválido, solo puede ser CUIL. Fila nro. = " + lineaExcel ;
                                                       hFilaError.add(error);
                                                   }
                                            } else {
                                                if ( !tipo.equals("DNI")  && !tipo.equals("DNI") && !tipo.equals("CUIL")) {
                                                       String error = "Tipo de documento inválido, tiene que ser DNI o CUIL. Fila nro. = " + lineaExcel ;
                                                       hFilaError.add(error);
                                                   }
                                            }
                                        }
                                        if ( doc != null && doc.equals("") ) {
                                            String error = "El campo del documento no esta informado. Fila nro. = " + lineaExcel ;
                                            hFilaError.add(error);
                                        } else {
                                                if ( ( tipo.equals("CUIL") && doc.length() != 11  ) ||
                                                     ( tipo.equals("DNI") && ( doc.length() < 7 || doc.length() > 8 ) ) ) {
                                                    String error = "Long. de documento inválido. Fila nro. = " + lineaExcel ;
                                                    hFilaError.add(error);
                                                }
                                            // Validar que el documento no este repetido.-

                                            for (int j=0; j < lDoc.size();j++) {
                                                String numDoc = (String) lDoc.get(j);
                                                if ( doc.equals(numDoc) ){
                                                    String tipoDoc = (String) lTipoDoc.get(j);
                                                    if (tipo.equals(tipoDoc) ) {
                                                        String error = "Esta repetido el documento = " + tipo + " : " + numDoc  + ". Fila nro. = " + lineaExcel ;
                                                        hFilaError.add(error);
                                                        break;
                                                    }
                                                }
                                            }
                                            lTipoDoc.add(tipo);
                                            lDoc.add(doc);

                                        }

                                        if (! nacim.equals("") ) {
                                 //           String error = "El campo del fecha de nacimiento no esta informado. Fila nro. = " + lineaExcel ;
                                 //           hFilaError.add(error);
                                 //      }  else {
                                            try {
                                                java.util.Date dFechaNac = Fecha.strToDate(nacim, "dd/MM/yyyy");
                                                // validar que la edad no se superior a 65 años.

                                            } catch (Exception exp1) {
                                                String error = "Error en el formato de fecha informado. Fila nro. = " + lineaExcel ;
                                                hFilaError.add(error);
                                            }
                                        }

                                        cantidadNomReal = cantidadNomReal + 1;
                                        if ( cantidadNomReal > cantVidas ) {
                                            msgError   = "Hay mas personas informadas en el archivo Excel , que las informada en la propuesta que son " + cantVidas  ;
                                           hFilaError.add(msgError);
                                           break;
                                        } else {
                                            hFila.add(has);
                                            // GRABO HASTA LA CANTIDAD DE VIDA
                                            if ( cantidadNomReal == cantVidas ) {
                                                break;
                                            }
                                        } // cantidadNomReal > cantVidas
                                    } // apellido = "" and ....

                                } // linea excel
                            } // for
                        }
                    }
                }
            } catch (Exception e) {
                throw new SurException (e.getMessage());
            }
        }

        Propuesta oProp = new Propuesta();
        oProp.setCodProceso  ( codProceso );
        oProp.setBoca        ( codBoca );
        oProp.setNumPropuesta( numPropuesta );
        oProp.setCodRama     ( codRama);


        String sUrl = Param.getAplicacion() + "servlet/PropuestaServlet?opcion=getNominaVO&numPropuesta="+ oProp.getNumPropuesta() +
                            "&volver=" + (request.getParameter("volver") == null ? "filtrarPropuestas" : request.getParameter("volver")) ;

        if (hFilaError.size() > 0 ) {
            request.setAttribute("hFilaError"   , hFilaError);
            request.setAttribute("hFila"   , hFila);
            request.setAttribute("nameCol" , nameCol);
            request.setAttribute("typeCol" , typeCol);
            request.setAttribute("propuesta", oProp);
            request.setAttribute("volver", sUrl );
            doForward (request, response, "/propuesta/formNominaXls.jsp");

        } else {
            // MODIF: por cambio propuesta VO + parametro CodRama -------------->>>>>>>>>>>>
            grabarNominasDelXls(hFila, codProceso,codBoca ,numPropuesta , cantidadNomReal, codRama);
            // MODIF: por cambio propuesta VO + parametro CodRama <<<<<<<<<<<<<<------------

            response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
            response.setHeader("Location",sUrl);

        }          

    }    
  
    protected void getPolizaAEndosar (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));

            Propuesta oProp = new Propuesta ();

            oProp.setNumPoliza( Integer.parseInt (request.getParameter ("num_poliza")));
            oProp.setCodRama  ( Integer.parseInt (request.getParameter ("cod_rama")));
            
            dbCon = db.getConnection();
            oProp.getDB(dbCon);
            
            if ( ! oProp.getdescEstado().equals ("VIGENTE")) {
                oProp.setCodError(-300);
            }

            String sMensaje = "";       
            
            if (oProp.getCodError() != 0) {
                switch (oProp.getCodError()) {
                    case -100: // la poliza no existe
                        sMensaje = "La poliza solicitada no existe o no se encuentra registrada en la web.<br> Por favor comuniquese con su representante.</br></br>Muchas Gracias.";
                        break;

                    case -300: // la poliza no esta vigente
                        sMensaje = "La póliza no esta vigente.</br></br>Muchas Gracias.";
                        break;

                    case -400: // existe deuda
                        sMensaje = "La póliza registra una deuda pendinte.<br> Ante cualquier duda por favor comuniquese con su representante.</br></br>Muchas Gracias.";
                        break;

                    case -500: // LA PóLIZA esta anulada
                        sMensaje = "La póliza esta anulada.";
                        break;
                    default: // normal html
                        sMensaje = "Hubo algún problema en la busqueda de la póliza. Por favor, comuniquese con su representante</br></br>Muchas Gracias.";
                        Email oEmail = new Email ();
                        oEmail.setSubject("Beneficio Web - Aviso de ERROR ");
                        oEmail.setContent(sMensaje);

                        LinkedList lDest = oEmail.getDBDestinos(dbCon, 0, "ERROR");

                        for (int i=0; i < lDest.size();i++) {
                            Persona oPers = (Persona) lDest.get(i);
                            oEmail.setDestination(oPers.getEmail());
                            oEmail.sendMessage();
                        }

                }
                request.setAttribute("mensaje", sMensaje);                
                request.setAttribute("volver", Param.getAplicacion() + "consulta/formEndosoAB.jsp");             
                doForward (request, response, "/include/MsjHtmlServidor.jsp");
            } else {
                doForward (request, response, "/propuesta/formAltaEndosoAB.jsp");
            }
                
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }
    
      /*
     * Grabar datos de la propuestaVC .
     */
    protected void grabarPropuestaVC (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        
        Connection dbCon = null;
        try {
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));                     
            
            int nroProp = 0;                        
            if ( request.getParameter ("prop_num_prop") != null && 
                 !request.getParameter ("prop_num_prop").equals("") ) {                 
                 nroProp  = Integer.parseInt( request.getParameter ("prop_num_prop") );    
            }
            dbCon = db.getConnection();
            Propuesta oProp = new Propuesta();
            if (nroProp > 0) {
                oProp.setNumPropuesta(nroProp);
                oProp.getDB(dbCon);
                if (oProp.getCodError() < 0 ) {
                    throw new SurException(oProp.getDescError());
                }
                if (oProp.getCodEstado() != 0 && oProp.getCodEstado() != 4) {
                    throw new SurException("LA PROPUESTA NO PUEDE SER MODIFICADA");
                }
            }

            int codProd = 0;                        
            if ( request.getParameter ("prop_cod_prod") != null && 
                 !request.getParameter ("prop_cod_prod").equals("") ) {
               codProd  = Integer.parseInt( request.getParameter ("prop_cod_prod") );
            }            
                        
            int codVig = 0;
            if ( request.getParameter ("prop_vig") != null && 
                 !request.getParameter ("prop_vig").equals("") ) {
               codVig  = Integer.parseInt( request.getParameter ("prop_vig") );
            }                                                        

            
            int cantCuota = 0;                        
            if ( request.getParameter ("prop_cant_cuotas") != null && 
                 !request.getParameter ("prop_cant_cuotas").equals("") ) {
               cantCuota  = Integer.parseInt( request.getParameter ("prop_cant_cuotas") );
            }            

            int numSocio = 0;                        
            if ( request.getParameter ("prop_numSocio") != null && 
                 !request.getParameter ("prop_numSocio").equals("") ) {
               numSocio  = Integer.parseInt( request.getParameter ("prop_numSocio") );
            }
            
            
            int codFormaPago = 0;
            if ( request.getParameter ("prop_form_pago") != null && 
                 !request.getParameter ("prop_form_pago").equals("") ) {
               codFormaPago  = Integer.parseInt( request.getParameter ("prop_form_pago") );
            }                        
            
            double premio = 0;                        
            if ( request.getParameter ("prop_premio") != null && 
                 !request.getParameter ("prop_premio").equals("") ) {
               premio  = Dbl.StrtoDbl( request.getParameter ("prop_premio") );
            }                       
            
            int numCotizacion = 0;                     
            if ( request.getParameter ("prop_nro_cot") != null && 
                 !request.getParameter ("prop_nro_cot").equals("") ) {
               numCotizacion  = Integer.parseInt( request.getParameter ("prop_nro_cot") );
            }                     
            
            int codEstado = 0;          
            if ( request.getParameter ("prop_cod_est") != null && 
                 !request.getParameter ("prop_cod_est").equals("") ) {                 
                 codEstado  = Integer.parseInt( request.getParameter ("prop_cod_est") );    
            }                     
            
            int codRama = 22;
            if ( request.getParameter ("prop_rama") != null &&
                 !request.getParameter ("prop_rama").equals("") ) {                 
                 codRama  = Integer.parseInt( request.getParameter ("prop_rama") );    
            }

            int codSubRama = 0;          
            if ( request.getParameter ("prop_subrama") != null && 
                 !request.getParameter ("prop_subrama").equals("") ) {                 
                 codSubRama  = Integer.parseInt( request.getParameter ("prop_subrama") );    
            }

            int codProducto = 0;
            if ( request.getParameter ("prop_cod_producto") != null &&
                 !request.getParameter ("prop_cod_producto").equals("") ) {
                 codProducto  = Integer.parseInt( request.getParameter ("prop_cod_producto") );
            }

            int polizaGrupo = 0;
            if ( request.getParameter ("prop_poliza_grupo") != null &&
                 !request.getParameter ("prop_poliza_grupo").equals("") ) {
                 polizaGrupo  = Integer.parseInt( request.getParameter ("prop_poliza_grupo") );
            }

            String sTipoNomina = request.getParameter ("prop_tipo_nomina") == null ? "S" :
                                 request.getParameter ("prop_tipo_nomina");

            String sNivelCob   = request.getParameter ("prop_nivel_cob") == null ? "P" :
                                 request.getParameter ("prop_nivel_cob");

            int  numReferencia = 0;
            if ( request.getParameter ("prop_num_referencia") != null &&
                 !request.getParameter ("prop_num_referencia").equals("") ) {
               numReferencia  = Integer.parseInt ( request.getParameter ("prop_num_referencia")) ;
            }

            oProp.setcodProducto(codProducto);
            oProp.setCodProceso   (1);
            oProp.setBoca         ("WEB");
            oProp.setCodRama      (codRama);            
            oProp.setNumPropuesta (nroProp);                      
            oProp.setCodSubRama   (codSubRama);
            oProp.setNumPoliza    (0);
            oProp.setCodCobFinal  (0);
            oProp.setCodMoneda    (1);           
            oProp.setImpPremio    (premio);                   
            oProp.setCodFormaPago (codFormaPago);  
            oProp.setImpCuota     (0);
            oProp.setCodProd      (codProd); 
            oProp.setNumTomador   (numSocio); 
            oProp.setPeriodoFact  (0);
            oProp.setCantCuotas   (cantCuota); 
            oProp.setCodActividad (0);
            oProp.setcodOpcion    (0);

            oProp.setmcaEnvioPoliza(request.getParameter ("prop_mca_envio_poliza") == null ? "S" :
                                    request.getParameter ("prop_mca_envio_poliza"));

            String fechaVigDesde = (request.getParameter ("prop_vig_desde")==null)?"":
                                    request.getParameter ("prop_vig_desde");

            if (fechaVigDesde.equals("")) {
                oProp.setFechaIniVigPol(null);
            } else {
                oProp.setFechaIniVigPol( Fecha.strToDate( request.getParameter ("prop_vig_desde") ));
            }
            oProp.setFechaFinVigPol(null);

            oProp.setCodVigencia(codVig);
            if (request.getParameter ("prop_cantVidas") != null) {
                oProp.setCantVidas( Integer.parseInt (request.getParameter ("prop_cantVidas")) );
            }
            if (request.getParameter ("prop_fac") != null) {
                oProp.setCodFacturacion(Integer.parseInt (request.getParameter ("prop_fac")) );
            }

            oProp.setCodEstado(codEstado);
            oProp.setNumSecuCot(numCotizacion);
            oProp.setUserid(oUser.getusuario());

            String beneficiarios = request.getParameter ("prop_benef_seleccionado") == null ? "" :
                                     request.getParameter ("prop_benef_seleccionado");
            
            if (beneficiarios.equals("T")) {
                oProp.setbenefTomador   ("S");
            } else {
                oProp.setbenefTomador   ("N");
            }
        
            if (beneficiarios.equals("H")) {
                oProp.setbenefHerederos("S");
            } else {
                oProp.setbenefHerederos("N");
            }
            
/*            oProp.setbenefHerederos (request.getParameter ("prop_benef_herederos") == null ? "N" :
                                     request.getParameter ("prop_benef_herederos"));
            oProp.setbenefTomador   (request.getParameter ("prop_benef_tomador") == null ? "N" :
                                     request.getParameter ("prop_benef_tomador"));
*/
            oProp.setgastosAdquisicion (request.getParameter ("GASTOS_ADQUISICION") == null ? 0 :
                                    Dbl.StrtoDbl(request.getParameter ("GASTOS_ADQUISICION") ));
            oProp.setpolizaGrupo(polizaGrupo);

            oProp.setempleador(request.getParameter ("prop_tom_empleador"));

            oProp.setnumReferencia(numReferencia);
            oProp.setTipoPropuesta(request.getParameter ("prop_tipo_propuesta"));
            
            oProp.setDB(dbCon);

            if (oProp.getCodError() != 0) {
                request.setAttribute("mensaje", oProp.getDescError());
                request.setAttribute("volver", Param.getAplicacion() + "index.jsp");
                doForward (request, response, "/include/MsjHtmlServidor.jsp");
            }

            if (oProp.getNumPropuesta() > 0) {
                // ----------------------
                // DATOS DE FORMA DE PAGO
                // ----------------------
                // 1 - TARJETA DE CREDITO.-
                if ( oProp.getCodFormaPago() ==1 ) {
                    int codTarjCred = 0;
                    if ( request.getParameter ("pro_TarCred") != null &&
                         !request.getParameter ("pro_TarCred").equals("") ) {
                        codTarjCred  = Integer.parseInt( request.getParameter ("pro_TarCred") );
                    }

                    int codTarjBco = 0;
                    if ( request.getParameter ("pro_TarCredBco") != null &&
                         !request.getParameter ("pro_TarCredBco").equals("") ) {
                        codTarjBco  = Integer.parseInt( request.getParameter ("pro_TarCredBco") );
                    }
                    String nroTarjCred      = request.getParameter ("pro_TarCredNro");
                    String fechaVtoTarjCred = request.getParameter ("pro_TarCredVto");
                    String titularTarjCred  = request.getParameter ("pro_TarCredTit");

                    oProp.setCodTarjCred(codTarjCred);
                    oProp.setNumTarjCred(nroTarjCred);

                    if (fechaVtoTarjCred.equals("")) {
                        oProp.setVencTarjCred(null);
                    } else {
                        oProp.setVencTarjCred( Fecha.strToDate( fechaVtoTarjCred));
                    }
                    oProp.setCodBanco(codTarjBco);
                    oProp.setTitular(titularTarjCred);
                    oProp.setcodSeguridadTarjeta(request.getParameter ("pro_TarCredCodSeguridad"));
                    
                    oProp.setDBTarjetaCredito(dbCon);

                // 2-3 - DEBITO no va mas / 6 = Debito bancario por sobre
                } else if ( oProp.getCodFormaPago() == 6  ) {

                    int codCtaBco = 0;
                    if ( request.getParameter ("pro_CtaBco") != null &&
                         !request.getParameter ("pro_CtaBco").equals("") ) {
                        codCtaBco  = Integer.parseInt( request.getParameter ("pro_CtaBco") );
                    }
                    String cbu      = request.getParameter ("pro_cuenta_banco");
                    String titular  = request.getParameter ("pro_convenio");

 // PARA EL BANCO MACRO VALIDAR EL CONVENIO
                    if ( codCtaBco == 40 ) {
                         ConvenioMacro cb = new ConvenioMacro ();
                         cb.setconvenio(Integer.parseInt (titular));
                         cb.getDB(dbCon);
                         if ( cb.getiNumError() < 0 ) {
                             if (cb.getiNumError() == -100 ) {
                                request.setAttribute("mensaje", cb.getsMensError());
                                request.setAttribute("volver", Param.getAplicacion() + "servlet/PropuestaServlet?opcion=getPropuestaBenef&numPropuesta=" +
                                    oProp.getNumPropuesta() + "&volver=" + (request.getParameter("volver") == null ? "filtrarPropuestas" : request.getParameter("volver")));
                                doForward (request, response, "/include/MsjHtmlServidor.jsp");
                             } else {
                                 throw new SurException( cb.getsMensError());
                             }
                         }
                         if (cb.getmcaBaja() != null && cb.getmcaBaja().equals("X") ) {
                            request.setAttribute("mensaje", "EL CONVENIO ESTA DADO DE BAJA");
                            request.setAttribute("volver", Param.getAplicacion() + "servlet/PropuestaServlet?opcion=getPropuestaBenef&numPropuesta=" +
                                    oProp.getNumPropuesta() + "&volver=" + (request.getParameter("volver") == null ? "filtrarPropuestas" : request.getParameter("volver")));
                            doForward (request, response, "/include/MsjHtmlServidor.jsp");
                         }
                    }
                    oProp.setCodBanco(codCtaBco);
                    oProp.setTitular(titular);
                    oProp.setCbu(cbu);
                    oProp.setDBBancoConvenio(dbCon);
                // DEBITO CUENTA
                } else if ( oProp.getCodFormaPago() == 4  ) {
                    String cbu      = request.getParameter ("pro_DebCtaCBU");
                    String titular  = request.getParameter ("pro_CtaTit");
                    oProp.setCbu     (cbu);
                    oProp.setTitular (titular);
                    oProp.setDBTarjetaDebitoCuenta(dbCon);
                } else {
                    // Otro forma de pago debe resetear otros campos de forma de Pago.
                    oProp.setDBFormaPagoReset(dbCon);
                }
                // ------------------
                // DATOS DEL TOMADOR
                // ------------------
                String tipoDocTomador = request.getParameter ("prop_tom_tipoDoc");
                String nroDocTomador  = request.getParameter ("prop_tom_nroDoc");
                String TomadorNom     = request.getParameter ("prop_tom_nombre");
                String TomadorApe     = request.getParameter ("prop_tom_apellido");

                int ivaTomador = 0;
                if ( request.getParameter ("prop_tom_iva") != null &&
                     !request.getParameter ("prop_tom_iva").equals("") ) {
                   ivaTomador  = Integer.parseInt( request.getParameter ("prop_tom_iva") );
                }
                String domTomador    = request.getParameter ("prop_tom_dom");
                String locTomador    = request.getParameter ("prop_tom_loc");
                String cpTomador     = request.getParameter ("prop_tom_cp");

                String mailTomador   = request.getParameter ("prop_tom_email");
                String teTomador     = request.getParameter ("prop_tom_te");
                String provTomador   = request.getParameter ("prop_tom_prov");

                PersonaPoliza oTom   = new PersonaPoliza();
                oTom.setnumTomador  (numSocio);
                oTom.settipoDoc     (tipoDocTomador);
                oTom.setnumDoc      (nroDocTomador);
                oTom.setrazonSocial (TomadorApe + " " + TomadorNom);
                oTom.setnombre      (TomadorNom);
                oTom.setapellido    (TomadorApe);
                oTom.setcodCondicionIVA(ivaTomador);
                oTom.setdomicilio   (domTomador);
                oTom.setlocalidad   (locTomador);
                oTom.setcodPostal   (cpTomador );
                oTom.setmail        (mailTomador);
                oTom.settelefono    (teTomador);
                oTom.setprovincia   (provTomador);

                oTom.setcodProceso        (oProp.getCodProceso());
                oTom.setcodBoca           (oProp.getBoca());
                oTom.setnumPropuesta      (oProp.getNumPropuesta());

                oTom.setDBTomadorPropuesta(dbCon);

                if ( oTom.getiNumError() < 0  ) {
                     if (oTom.getiNumError() != -1 ) {
                        request.setAttribute("mensaje", "EL TOMADOR EXISTE COMO ASEGURADO EN OTRA POLIZA VIGENTE O ANULADA CON DEUDA Nº " + oTom.getiNumError());
                        request.setAttribute("volver", Param.getAplicacion() + "servlet/PropuestaServlet?opcion=getPropuestaBenef&numPropuesta=" +
                            oProp.getNumPropuesta() + "&volver=" + (request.getParameter("volver") == null ? "filtrarPropuestas" : request.getParameter("volver")));
                        doForward (request, response, "/include/MsjHtmlServidor.jsp");
                     } else {
                         throw new SurException( oTom.getsMensError());
                     }
                 }

                UbicacionRiesgo oRiesgo = new UbicacionRiesgo ();
                oRiesgo.setnumPropuesta(oProp.getNumPropuesta());

//                if (request.getParameter ("prop_misma_ubic_riesgo") != null && request.getParameter ("prop_misma_ubic_riesgo").equals ("S")) {
                    oRiesgo.setcodPostal (oTom.getcodPostal());
                    oRiesgo.setprovincia (oTom.getprovincia());
                    oRiesgo.setdomicilio (oTom.getdomicilio());
                    oRiesgo.setlocalidad (oTom.getlocalidad());
                    oRiesgo.setigualTomador("S");
//                } else {
//                    oRiesgo.setcodPostal (request.getParameter ("prop_ubic_cp"));
//                    oRiesgo.setprovincia (request.getParameter ("prop_ubic_prov"));
//                    oRiesgo.setdomicilio (request.getParameter ("prop_ubic_dom"));
//                    oRiesgo.setlocalidad (request.getParameter ("prop_ubic_loc"));
//                    oRiesgo.setigualTomador("N");
//                }
                oRiesgo.setDBPropuesta(dbCon);

                if (sNivelCob.equals ("P") && oProp.getNumSecuCot() == 0 ) {
                    int cantCob = request.getParameter ("prop_max_cant_cob") == null ? 0 :
                                 Integer.parseInt (request.getParameter ("prop_max_cant_cob"));

                    if (cantCob > 0) {
                        int    codCob = 0;
                        double impCob = 0;
                        AsegCobertura  oCob = new AsegCobertura();
                        oCob.setcodProceso  (oProp.getCodProceso());
                        oCob.setcodBoca     (oProp.getBoca());
                        oCob.setnumPropuesta(oProp.getNumPropuesta());

                        // Borro Coberturas .
                        oCob.delDBCobPropuesta(dbCon);

                        oCob.setcodRama     (oProp.getCodRama());
                        oCob.setcodSubRama  (oProp.getCodSubRama());
                        for (int i=1;i <=cantCob;i++  ) {
                            codCob = 0;
                            if ( request.getParameter ("prop_cob_cod_"+i) != null &&
                                 !request.getParameter ("prop_cob_cod_"+i).equals("") ) {
                                 codCob  =  Integer.parseInt( request.getParameter ("prop_cob_cod_"+i) );
                            }
                            impCob = 0;
                            if ( request.getParameter ("prop_cob_"+i) != null &&
                                 !request.getParameter ("prop_cob_"+i).equals("") ) {
                                 impCob  =  Dbl.StrtoDbl(request.getParameter ("prop_cob_"+i) );
                            }
                            oCob.setcodCob(codCob);
                            oCob.setimpSumaRiesgo(impCob);
                            // Grabo Cobertura.
                            oCob.setDBCobPropuesta(dbCon);
                            if ( oCob.getiNumError() < 0 ) {
                                throw new SurException(oCob.getsMensError());   
                            }
                        }
                        if (nroProp > 0) {
                            oCob.actualizarDBCobPropuesta(dbCon);
                        }

                    }
                }

                if (request.getParameter("opcion").equals("CalcularPremioVC")) {
                    oProp.setDBCalcularPremio(dbCon, oUser.getusuario());

                    response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
                    response.setHeader("Location", "/benef/servlet/PropuestaServlet?opcion=getPropuestaBenef&numPropuesta="  + oProp.getNumPropuesta() +
                            "&volver=" + (request.getParameter("volver") == null ? "filtrarPropuestas" : request.getParameter("volver")) );
                } else {
                    response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
                    response.setHeader("Location", "/benef/servlet/PropuestaServlet?opcion=getNominaVC&numPropuesta="  + oProp.getNumPropuesta() +
                            "&volver=" + (request.getParameter("volver") == null ? "filtrarPropuestas" : request.getParameter("volver")) );
                }
           } else {
                        String sMensaje = "";
                        sMensaje = "Hubo algún problema en el alta del propuesta. Por favor, comuniquese con su representante</br></br>Muchas Gracias.";
                        request.setAttribute("mensaje", sMensaje);
                        request.setAttribute("volver", Param.getAplicacion() + "index.jsp");
                        doForward (request, response, "/include/MsjHtmlServidor.jsp");
           }

        } catch (SurException se) {
            throw new SurException (se.getMessage());
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void grabarPropuestaPlan (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        Connection dbCon = null;
        String sMensaje = "Hubo algún problema en el alta del propuesta. Por favor, comuniquese con su representante</br></br>Muchas Gracias.";
        try {
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));

            int nroProp = 0;
            if ( request.getParameter ("prop_num_prop") != null &&
                 !request.getParameter ("prop_num_prop").equals("") ) {
                 nroProp  = Integer.parseInt( request.getParameter ("prop_num_prop") );
            }

            dbCon = db.getConnection();
            Propuesta oProp = new Propuesta();
            if (nroProp > 0) {
                oProp.setNumPropuesta(nroProp);
                oProp.getDB(dbCon);
                if (oProp.getCodError() < 0 ) {
                    throw new SurException(oProp.getDescError());
                }
                if (oProp.getCodEstado() != 0 && oProp.getCodEstado() != 4) {
                    throw new SurException("LA PROPUESTA NO PUEDE SER MODIFICADA");
                }
            }

            int codProd = 0;
            if ( request.getParameter ("prop_cod_prod") != null &&
                 !request.getParameter ("prop_cod_prod").equals("") ) {
               codProd  = Integer.parseInt( request.getParameter ("prop_cod_prod") );
            }

            int codVig = 0;
            if ( request.getParameter ("prop_vig") != null &&
                 !request.getParameter ("prop_vig").equals("") ) {
               codVig  = Integer.parseInt( request.getParameter ("prop_vig") );
            }

            int codActividad = 0;
            if ( request.getParameter ("prop_aseg_actividad") != null &&
                 !request.getParameter ("prop_aseg_actividad").equals("") ) {
               codActividad  = Integer.parseInt( request.getParameter ("prop_aseg_actividad") );
            }

            int cantCuota = 0;
            if ( request.getParameter ("prop_cant_cuotas") != null &&
                 !request.getParameter ("prop_cant_cuotas").equals("") ) {
               cantCuota  = Integer.parseInt( request.getParameter ("prop_cant_cuotas") );
            }

            int numSocio = 0;
            if ( request.getParameter ("prop_numSocio") != null &&
                 !request.getParameter ("prop_numSocio").equals("") ) {
               numSocio  = Integer.parseInt( request.getParameter ("prop_numSocio") );
            }

            String observacion   = request.getParameter ("prop_obs");

            int codFormaPago = 0;
            if ( request.getParameter ("prop_form_pago") != null &&
                 !request.getParameter ("prop_form_pago").equals("") ) {
               codFormaPago  = Integer.parseInt( request.getParameter ("prop_form_pago") );
            }

            double premio = 0;
            if ( request.getParameter ("prop_premio") != null &&
                 !request.getParameter ("prop_premio").equals("") ) {
               premio  = Dbl.StrtoDbl( request.getParameter ("prop_premio") );
            }

            int numCotizacion = 0;
            if ( request.getParameter ("prop_nro_cot") != null &&
                 !request.getParameter ("prop_nro_cot").equals("") ) {
               numCotizacion  = Integer.parseInt( request.getParameter ("prop_nro_cot") );
            }

            int codEstado = 0;
            if ( request.getParameter ("prop_cod_est") != null &&
                 !request.getParameter ("prop_cod_est").equals("") ) {
                 codEstado  = Integer.parseInt( request.getParameter ("prop_cod_est") );
            }

            int codRama = 0;
            if ( request.getParameter ("prop_rama") != null &&
                 !request.getParameter ("prop_rama").equals("") ) {
                 codRama  = Integer.parseInt( request.getParameter ("prop_rama") );
            }

            int codSubRama = 0;
            if ( request.getParameter ("prop_subrama") != null &&
                 !request.getParameter ("prop_subrama").equals("") ) {
                 codSubRama  = Integer.parseInt( request.getParameter ("prop_subrama") );
            }

            int codOpcion = 0;
            if ( request.getParameter ("prop_cod_opcion") != null &&
                 !request.getParameter ("prop_cod_opcion").equals("") ) {
                 codOpcion  = Integer.parseInt( request.getParameter ("prop_cod_opcion") );
            }

            int  numReferencia = 0;
            if ( request.getParameter ("prop_num_referencia") != null &&
                 !request.getParameter ("prop_num_referencia").equals("") ) {
               numReferencia  = Integer.parseInt ( request.getParameter ("prop_num_referencia")) ;
            }

            oProp.setCodProceso   (1);
            oProp.setBoca         ("WEB");
            oProp.setCodRama      (codRama);
            oProp.setNumPropuesta (nroProp);
            oProp.setCodSubRama   (codSubRama);
            oProp.setNumPoliza    (0);
            oProp.setCodCobFinal  (0);
            oProp.setCodMoneda    (1);
            oProp.setImpPremio    (premio);
            oProp.setCodFormaPago (codFormaPago);
            oProp.setImpCuota     (0);
            oProp.setCodProd      (codProd);
            oProp.setNumTomador   (numSocio);
            oProp.setPeriodoFact  (0);
            oProp.setCantCuotas   (cantCuota);
            oProp.setCodActividad (codActividad);
            oProp.setcodOpcion    (codOpcion);

            oProp.setmcaEnvioPoliza(request.getParameter ("prop_mca_envio_poliza") == null ? "S" : request.getParameter ("prop_mca_envio_poliza"));

            String fechaVigDesde = (request.getParameter ("prop_vig_desde")==null)?"":request.getParameter ("prop_vig_desde");

            if (fechaVigDesde.equals("")) {
                oProp.setFechaIniVigPol(null);
            } else {
                oProp.setFechaIniVigPol( Fecha.strToDate( request.getParameter ("prop_vig_desde") ));
            }
            oProp.setFechaFinVigPol(null);

            oProp.setCodVigencia(codVig);

            if (request.getParameter ("prop_cantVidas") != null) {
                oProp.setCantVidas( Integer.parseInt (request.getParameter ("prop_cantVidas")) );
            }

            if (request.getParameter ("prop_fac") != null) {
                oProp.setCodFacturacion(Integer.parseInt (request.getParameter ("prop_fac")) );
            }

            oProp.setCodEstado(codEstado);
            oProp.setObservaciones(observacion);
            oProp.setNumSecuCot(numCotizacion);
            oProp.setUserid(oUser.getusuario());

            // Nuevo 20-10-2007
            oProp.setclaNoRepeticion    (request.getParameter ("prop_cla_no_repeticion") == null ? "N" : request.getParameter ("prop_cla_no_repeticion"));
            oProp.setclaSubrogacion     (request.getParameter ("prop_cla_subrogacion") == null ? "N" : request.getParameter ("prop_cla_subrogacion") );
            oProp.setbenefHerederos     (request.getParameter ("prop_benef_herederos") == null ? "N" : request.getParameter ("prop_benef_herederos"));
            oProp.setbenefTomador       (request.getParameter ("prop_benef_tomador") == null ? "N" : request.getParameter ("prop_benef_tomador"));
            // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            oProp.setcodPlan(request.getParameter ("prop_cod_plan") == null ? 0 : ( request.getParameter ("prop_cod_plan") == "-1" ? 0 : Integer.parseInt (request.getParameter ("prop_cod_plan"))));
            oProp.setgastosAdquisicion (request.getParameter ("GASTOS_ADQUISICION") == null ? 0 : Dbl.StrtoDbl(request.getParameter ("GASTOS_ADQUISICION") ));

            oProp.setcodProducto (request.getParameter ("prop_cod_producto") == null ? 0 : Integer.parseInt (request.getParameter ("prop_cod_producto")));

            oProp.setnumReferencia(numReferencia);
            oProp.setTipoPropuesta(request.getParameter ("prop_tipo_propuesta"));

            oProp.setDB(dbCon);

            if (oProp.getCodError() == -1 ) {
                request.setAttribute("mensaje", oProp.getDescError());
                request.setAttribute("volver", Param.getAplicacion() + "index.jsp");
                doForward (request, response, "/include/MsjHtmlServidor.jsp");
                
            }


            if (oProp.getNumPropuesta() > 0) {

               // CARGA DE CLAUSULAS

                int iCantClausulas = (request.getParameter ("prop_cant_max_clausulas") == null ? 0 : Integer.parseInt (request.getParameter ("prop_cant_max_clausulas")));

                for (int i= 1; i <= iCantClausulas;i++) {
                    Clausula oCla =  new Clausula ();
                    oCla.setboca(oProp.getBoca());
                    oCla.setnumPropuesta(oProp.getNumPropuesta());
                    oCla.setnumItem (i);
                    oCla.setcuitEmpresa (request.getParameter ("CLA_CUIT_" + i));
                    oCla.setdescEmpresa (request.getParameter ("CLA_DESCRIPCION_" + i));

                    if (i == 1) {
                        oCla.delDB (dbCon);
                    }
                    if (oCla.getdescEmpresa() != null && oCla.getdescEmpresa().trim().length() > 0) {
                        oCla.setDB(dbCon);
                    }
                }

                // ----------------------
                // DATOS DE FORMA DE PAGO
                // ----------------------
                // 1 - TARJETA DE CREDITO.-
                if ( oProp.getCodFormaPago() ==1 ) {
                    int codTarjCred = 0;
                    if ( request.getParameter ("pro_TarCred") != null &&
                         !request.getParameter ("pro_TarCred").equals("") ) {
                        codTarjCred  = Integer.parseInt( request.getParameter ("pro_TarCred") );
                    }

                    int codTarjBco = 0;
                    if ( request.getParameter ("pro_TarCredBco") != null &&
                         !request.getParameter ("pro_TarCredBco").equals("") ) {
                        codTarjBco  = Integer.parseInt( request.getParameter ("pro_TarCredBco") );
                    }
                    String nroTarjCred      = request.getParameter ("pro_TarCredNro");
                    String fechaVtoTarjCred = request.getParameter ("pro_TarCredVto");
                    String titularTarjCred  = request.getParameter ("pro_TarCredTit");

                    oProp.setCodTarjCred(codTarjCred);
                    oProp.setNumTarjCred(nroTarjCred);

                    if (fechaVtoTarjCred.equals("")) {
                        oProp.setVencTarjCred(null);
                    } else {
                        oProp.setVencTarjCred( Fecha.strToDate( fechaVtoTarjCred));
                    }
                    oProp.setCodBanco(codTarjBco);
                    oProp.setTitular(titularTarjCred);
                    oProp.setcodSeguridadTarjeta(request.getParameter ("pro_TarCredCodSeguridad"));

                    oProp.setDBTarjetaCredito(dbCon);

                // 2-3 - DEBITO no va mas / 6 = Debito bancario por sobre
                } else if ( oProp.getCodFormaPago() == 6  ) {

                    int codCtaBco = 0;
                    if ( request.getParameter ("pro_CtaBco") != null &&
                         !request.getParameter ("pro_CtaBco").equals("") ) {
                        codCtaBco  = Integer.parseInt( request.getParameter ("pro_CtaBco") );
                    }
                    String cbu      = request.getParameter ("pro_cuenta_banco");
                    String titular  = request.getParameter ("pro_convenio");

                    oProp.setCodBanco(codCtaBco);
                    oProp.setTitular(titular);
                    oProp.setCbu(cbu);
                    oProp.setDBBancoConvenio(dbCon);
                // DEBITO CUENTA
                } else if ( oProp.getCodFormaPago() == 4  ) {
                    String cbu      = request.getParameter ("pro_DebCtaCBU");
                    String titular  = request.getParameter ("pro_CtaTit");
                    oProp.setCbu     (cbu);
                    oProp.setTitular (titular);
                    oProp.setDBTarjetaDebitoCuenta(dbCon);
                } else {
                    // Otro forma de pago debe resetear otros campos de forma de Pago.
                    oProp.setDBFormaPagoReset(dbCon);
                }
                // ------------------
                // DATOS DEL TOMADOR
                // ------------------
                String tipoDocTomador = request.getParameter ("prop_tom_tipoDoc");
                String nroDocTomador  = request.getParameter ("prop_tom_nroDoc");
                String TomadorNom     = request.getParameter ("prop_tom_nombre");
                String TomadorApe     = request.getParameter ("prop_tom_apellido");

                int ivaTomador = 0;
                if ( request.getParameter ("prop_tom_iva") != null &&
                     !request.getParameter ("prop_tom_iva").equals("") ) {
                   ivaTomador  = Integer.parseInt( request.getParameter ("prop_tom_iva") );
                }
                String domTomador    = request.getParameter ("prop_tom_dom");
                String locTomador    = request.getParameter ("prop_tom_loc");
                String cpTomador     = request.getParameter ("prop_tom_cp");

                String mailTomador   = request.getParameter ("prop_tom_email");
                String teTomador     = request.getParameter ("prop_tom_te");
                String provTomador   = request.getParameter ("prop_tom_prov");

                PersonaPoliza oTom   = new PersonaPoliza();
                oTom.setnumTomador  (numSocio);
                oTom.settipoDoc     (tipoDocTomador);
                oTom.setnumDoc      (nroDocTomador);
                oTom.setrazonSocial (TomadorApe + " " + TomadorNom);
                oTom.setnombre      (TomadorNom);
                oTom.setapellido    (TomadorApe);
                oTom.setcodCondicionIVA(ivaTomador);
                oTom.setdomicilio   (domTomador);
                oTom.setlocalidad   (locTomador);
                oTom.setcodPostal   (cpTomador );
                oTom.setmail        (mailTomador);
                oTom.settelefono    (teTomador);
                oTom.setprovincia   (provTomador);

                oTom.setcodProceso        (oProp.getCodProceso());
                oTom.setcodBoca           (oProp.getBoca());
                oTom.setnumPropuesta      (oProp.getNumPropuesta());

                oTom.setDBTomadorPropuesta(dbCon);

                UbicacionRiesgo oRiesgo = new UbicacionRiesgo ();
                oRiesgo.setnumPropuesta(oProp.getNumPropuesta());

                if (oProp.getCodRama() == 22 || ( request.getParameter ("prop_misma_ubic_riesgo") != null && request.getParameter ("prop_misma_ubic_riesgo").equals ("S"))) {
                    oRiesgo.setcodPostal (oTom.getcodPostal());
                    oRiesgo.setprovincia (oTom.getprovincia());
                    oRiesgo.setdomicilio (oTom.getdomicilio());
                    oRiesgo.setlocalidad (oTom.getlocalidad());
                    oRiesgo.setigualTomador("S");
                } else {
                    oRiesgo.setcodPostal (request.getParameter ("prop_ubic_cp"));
                    oRiesgo.setprovincia (request.getParameter ("prop_ubic_prov"));
                    oRiesgo.setdomicilio (request.getParameter ("prop_ubic_dom"));
                    oRiesgo.setlocalidad (request.getParameter ("prop_ubic_loc"));
                    oRiesgo.setigualTomador("N");
                }

                oRiesgo.setDBPropuesta(dbCon);

                if (oProp.getNumSecuCot() == 0 ) {

                    int cantCob = request.getParameter ("prop_max_cant_cob") == null ? 0 : Integer.parseInt (request.getParameter ("prop_max_cant_cob"));
                    if (cantCob > 0) {
                        int    codCob = 0;
                        double impCob = 0;
                        AsegCobertura  oCob = new AsegCobertura();
                        oCob.setcodProceso  (oProp.getCodProceso());
                        oCob.setcodBoca     (oProp.getBoca());
                        oCob.setnumPropuesta(oProp.getNumPropuesta());

                        // Borro Coberturas .
                        oCob.delDBCobPropuesta(dbCon);

                        oCob.setcodRama     (oProp.getCodRama());
                        oCob.setcodSubRama  (oProp.getCodSubRama());
                        for (int i=1;i <=cantCob;i++  ) {
                            codCob = 0;
                            if ( request.getParameter ("prop_cob_cod_"+i) != null &&
                                 !request.getParameter ("prop_cob_cod_"+i).equals("") ) {
                                 codCob  =  Integer.parseInt( request.getParameter ("prop_cob_cod_"+i) );
                            }
                            impCob = 0;
                            if ( request.getParameter ("prop_cob_"+i) != null &&
                                 !request.getParameter ("prop_cob_"+i).equals("") ) {
                                 impCob  =  Dbl.StrtoDbl(request.getParameter ("prop_cob_"+i) );
                            }
                            oCob.setcodCob(codCob);
                            oCob.setimpSumaRiesgo(impCob);
                            // Grabo Cobertura.
                            oCob.setDBCobPropuesta(dbCon);
                        }
                        if (nroProp > 0) {
                            oCob.actualizarDBCobPropuesta(dbCon);
                        }
                    }
                }

                    if (request.getParameter("opcion").equals("CalcularPremioPlan")) {
                        oProp.setDBCalcularPremio(dbCon, oUser.getusuario());

                        response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
                        response.setHeader("Location", "/benef/servlet/PropuestaServlet?opcion=getPropuestaBenef&numPropuesta="  + oProp.getNumPropuesta() +
                                "&volver=" + (request.getParameter("volver") == null ? "filtrarPropuestas" : request.getParameter("volver")) );
                    } else {
                        response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
                        response.setHeader("Location", "/benef/servlet/PropuestaServlet?opcion=getNominaVO&numPropuesta="  + oProp.getNumPropuesta() +
                                "&volver=" + (request.getParameter("volver") == null ? "filtrarPropuestas" : request.getParameter("volver")) );
                    }
                } else {
                request.setAttribute("mensaje", sMensaje);
                request.setAttribute("volver", Param.getAplicacion() + "index.jsp");

                doForward (request, response, "/include/MsjHtmlServidor.jsp");
            }
        } catch (SurException se) {
            throw new SurException (se.getMessage());
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

/* -------------------------------------------
   Propuesta VC -SUP  20-10-2007 <<<<<<<<<<<<<
   ------------------------------------------- */
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
        
    public void goToJSPError (HttpServletRequest request, HttpServletResponse response, Throwable t) 
     throws ServletException, IOException {
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
