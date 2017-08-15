/*
 * PolizaServlet.java
 *
 * Created on 28 de mayo de 2006, 19:57
 */       
        
package servlets;
import java.io.IOException;
import java.util.*;
import java.sql.Connection;
import java.util.Enumeration;

import com.business.beans.Endoso;
import com.business.beans.Poliza;
import com.business.beans.AseguradoPropuesta;
import com.business.beans.Usuario;
import com.business.beans.Persona;
import com.business.beans.PersonaPoliza;
import com.business.beans.UbicacionRiesgo;
import com.business.beans.Localidad;
import com.business.beans.Clausula;
import com.business.util.*;
import com.business.db.*;
import java.sql.CallableStatement;
import java.sql.ResultSet;

import javax.servlet.*;
import javax.servlet.http.*;

import com.google.gson.Gson;


/**
 *
 * @author  Usuario
 * @version
 */
public class EndosoServlet extends HttpServlet {
    
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
            String op =  request.getParameter("opcion");                     
            
            if  (op.equals("getPolEnd")) {
                getPolizaAEndosar (request, response);            
            } else if (op.equals ("editEndoso")) {
                getEndoso (request, response);
            } else if (op.equals ("addPersona") || op.equals ("delPersona") || op.equals ("cancelPersona") || op.equals ("enviarEndoso")) {
                grabarEndoso (request, response);
            } else if (op.equals ("printEndoso")) {
                printEndoso (request, response);
            } else if (op.equals ("delEndoso")) {
                delEndoso (request, response);
            } else if (op.equals ("getFormEndoso")) {
                getFormEndoso (request, response);
            } else if (op.equals ("getLocalidad")) {
                getLocalidad (request, response);
            } else if (op.equals ("setFormTomador")) {
                setFormTomador (request, response);
            } else if (op.equals ("setFormUbicacion")) {
                setFormUbicacion (request, response);
            } else if (op.equals ("setFormClausulas")) {
                setFormClausulas (request, response);
            } else if (op.equals ("setFormComisiones")) {
                setFormComisiones(request, response);
            }       
            
        } catch (SurException se) {
            goToJSPError(request,response, se);
        } catch (Exception e) {
            goToJSPError(request,response, e);
        }
    }
    
    protected void getLocalidad (HttpServletRequest request,
                    HttpServletResponse response) throws ServletException, IOException {
        Connection dbCon = null;
        ResultSet rs = null;
        CallableStatement cons = null;

        response.setContentType("application/json");
        try {
                String term = request.getParameter("term");
                int iCodProvincia = Integer.parseInt (request.getParameter("cod_provincia"));
                
//                System.out.println("Data from ajax call " + term);

                ArrayList<Localidad> list = new ArrayList ();

                dbCon = db.getConnection();
                dbCon.setAutoCommit(false);

                cons = dbCon.prepareCall(db.getSettingCall("get_all_localidad (?, ?)"));
                cons.registerOutParameter(1, java.sql.Types.OTHER);            
                cons.setString (2, term );
                cons.setInt    (3, iCodProvincia);

                cons.execute();
                rs = (ResultSet) cons.getObject(1);
                if (rs != null) {
                    while (rs.next()) {
                        Localidad oLoc = new Localidad ();
                        oLoc.setcodLocalidad(rs.getInt ("cod_localidad"));
                        oLoc.setcodPostal(rs.getString ("cod_postal"));
                        oLoc.setcodProvincia(rs.getInt ("cod_provincia"));
                        oLoc.setlocalidad(rs.getString ("localidad"));
                        oLoc.setprovincia(rs.getString ("provincia"));
                        oLoc.setdescLocalidad(rs.getString ("desc_localidad"));
            
                        list.add(oLoc);
                    }
                }
                

                String searchList = new Gson().toJson(list);
                response.getWriter().write(searchList);
                
        } catch (Exception e) {
                e.printStackTrace();
        }
    }

    protected void getFormEndoso (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        UbicacionRiesgo oUbic = null;
        try {
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));

            Endoso oProp = new Endoso ();

            oProp.setNumPoliza( Integer.parseInt (request.getParameter ("num_poliza")));
            oProp.setCodRama  ( Integer.parseInt (request.getParameter ("cod_rama")));
            oProp.settipoEndoso (Integer.parseInt (request.getParameter ("TIPO_ENDOSO")));
            String sForm = request.getParameter ("formulario");
            String sNivel = request.getParameter ("nivel");

            if (oProp.gettipoEndoso() == 2000) { // redirecciona al modulo anterior de alta/baja asegurado
                this.getPolizaAEndosar (request, response);
            } else {
            dbCon = db.getConnection();
  //          oProp.getDBVerificarPoliza (dbCon, oUser.getusuario());

            
  //          if (oProp.getCodError() < 0) {
  //            request.setAttribute("mensaje",  oProp.getDescError());
  //              request.setAttribute("volver", "-1");
  //              doForward (request, response, "/include/MsjHtmlServidor.jsp");
  //          } else {
                    
                    Poliza oPol = new Poliza ();
                    oPol.setnumPoliza(oProp.getNumPoliza());
                    oPol.setcodRama(oProp.getCodRama());
                    oPol.getDB(dbCon);
                    
                    if (oPol.getiNumError() < 0 ) {
                        throw new SurException(oPol.getsMensError());
                    } else {
                        PersonaPoliza oPers = new PersonaPoliza ();
                        oPers.setnumTomador(oPol.getnumTomador());
                        oPers.getDB(dbCon);
        
                        oProp.setCodProd(oPol.getcodProd());
                        oProp.setdescProd(oPol.getdescProductor());
                        oProp.setCodSubRama(oPol.getcodSubRama());
                        oProp.setcodProducto(oPol.getcodProducto());
                        oProp.setDescRama(oPol.getdescRama());
                        oProp.setDescSubRama(oPol.getdescSubRama());
                        oProp.setFechaEmision(oPol.getfechaEmision());
                        oProp.setFechaFinVigPol(oPol.getfechaFinVigencia());
                        oProp.setFechaIniVigPol(oPol.getfechaInicioVigencia());
                        oProp.setpolizaAnterior(oPol.getnumPolizaAnt());
                        oProp.setTomadorCP(oPers.getcodPostal());
                        oProp.setTomadorApe(oPers.getapellido());
                        oProp.setTomadorCodProv(oPers.getprovincia());
                        oProp.setTomadorDescProv(oPers.getdescProvincia());
                        oProp.setTomadorCondIva(oPers.getcodCondicionIVA());
                        oProp.setTomadorCuit(oPers.getcuit());
                        oProp.setTomadorDescCondIva(oPers.getdescIVA());
                        oProp.setTomadorDescTipoDoc(oPers.getdescTipoDoc());
                        oProp.setTomadorTE(oPers.gettelefono());
                        oProp.setTomadorDom(oPers.getdomicilio());
                        oProp.setTomadorLoc(oPers.getlocalidad());
                        oProp.setTomadorNom(oPers.getnombre());
                        oProp.setTomadorNumDoc(oPers.getnumDoc());
                        oProp.setTomadorRazon(oPers.getrazonSocial());
                        oProp.setTomadorTipoDoc(oPers.gettipoDoc());
                        oProp.setporcComisionOrg(oPol.getPremio().getporcComisionPrimaOrg());
                        oProp.setporcGDA(oPol.getPremio().getporcComisionPrimaProd());
                        oProp.setsubSeccion(oPol.getsubSeccion());

                          
                        if (sNivel.equals("P")) {
                            
                            if (oProp.gettipoEndoso() == 1302 ) { 
                            // actualizacion de ubicacion de riesgo
                                oUbic = new UbicacionRiesgo();
                                oUbic.setcodRama(oProp.getCodRama());
                                oUbic.setnumPoliza(oProp.getNumPoliza());
                                oUbic.getDB(dbCon);

                                oProp.setoUbicacionRiesgo(oUbic);
                            } else { 
                                if (oProp.gettipoEndoso() == 0 || oProp.gettipoEndoso() ==1303) {
                                    // actualizacion de clausulas
                                    oProp.setAllClausulas(oPol.getDBAllEmpresasClausulas(dbCon));
                                }
                                
                            }

                        } else if (sNivel.equals("N")) {
                            LinkedList lAseg = new LinkedList ();

                            lAseg = oProp.getDBAseguradosAEndosar(dbCon);

                            if (oProp.getCodError() == -1) {
                                throw new SurException ("Error en getPolizaAEndosar [getDBAseguradosAEndosar]:" + oProp.getDescError());
                            }
                            request.setAttribute("nomina", lAseg );
                            
                        }
                        
                    }
                    
                request.setAttribute("propuesta", oProp );
                doForward (request, response, sForm );
                
            }
                
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void printEndoso (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {        
        Connection        dbCon = null;
        int  nroProp = Integer.valueOf( request.getParameter("num_propuesta") == null ? "0" : request.getParameter("num_propuesta"));
        LinkedList nominas = new LinkedList ();
        try {
            dbCon = db.getConnection();  
            Endoso oProp = new Endoso ();
            oProp.setNumPropuesta   (nroProp);
            oProp.getDB(dbCon);
            
            nominas = oProp.getDBNominasPropuesta(dbCon);  
            
            
            
            request.setAttribute ("propuesta", oProp);            
            request.setAttribute ("nominas", nominas);            
            doForward (request, response, "/propuesta/report/endosoHTML.jsp");            
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
        
    }                                
    
    
    protected void getPolizaAEndosar (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));

            Endoso oProp = new Endoso ();

            oProp.setNumPoliza( Integer.parseInt (request.getParameter ("num_poliza")));
            oProp.setCodRama  ( Integer.parseInt (request.getParameter ("cod_rama")));
            
            dbCon = db.getConnection();
            oProp.getDBVerificarPoliza (dbCon, oUser.getusuario());

        if (oProp.getCodError() < 0) {
/*
                switch (oProp.getCodError()) {
                    case -100: // la poliza no existe
                        sMensaje = "La p&oacute;liza solicitada no existe o no se encuentra registrada en la web.<br> Por favor comiquese con su representante.</br></br>Muchas Gracias.";
                        break;

                    case -200: // ya existe en carga
                        sMensaje = "Ya existe un endoso en carga para la p&oacute;liza. Ingrese desde el menu Propuestas --> Mis Propuestas.</br></br>Muchas Gracias.";
                        break;
                    case -300: // la poliza no esta vigente
                        sMensaje = "La p&oacute;liza no esta vigente.</br></br>Muchas Gracias.";
                        break;
                    case -400: // existe deuda
                        sMensaje = "La p&oacute;liza registra una deuda pendiente.<br> Ante cualquier duda por favor comiquese con su representante.</br></br>Muchas Gracias.";
                        break;
                    case -500: // LA PoLIZA esta anulada
                        sMensaje = "La p&oacute;liza esta anulada.";
                        break;
                    case -600: //  vida colectivo y vida deudores.
                        sMensaje = "Por el momento no es posible solicitar endosos de Vida Colectivo o Vida Deudores de un Acreedor.";
                        break;
                    case -700: // LA PoLIZA no tiene CUIC
                        sMensaje = "La p&oacute;liza aun no tiene CUIC asignado por la SSN.<br> Intente nuevamente en 48 a 76 hs. a partir de la emisión. Muchas gracias";
                        break;
                    case -800: //  vida colectivo y vida deudores.
                        sMensaje = "NO se permiten endosos de alta/bajas de asegurado el &uacute;ltimo d&iacute;a de vigencia de la p&oacute;liza.";
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
 *
 */
                request.setAttribute("mensaje",  oProp.getDescError());
                request.setAttribute("volver", "-1");
                doForward (request, response, "/include/MsjHtmlServidor.jsp");
            } else {
                if (oProp.getCodError() == 0 ) {
                    oProp.setUserid(oUser.getusuario());
                
                    oProp.setDBEndosar (dbCon);

                    if (oProp.getCodError() == -1) {
                        throw new SurException ("Error en getPolizaAEndosar [setDBEndsar]:" + oProp.getDescError());
                    }
                } else {
                    oProp.setNumPropuesta(oProp.getCodError());
                }
                oProp.getDB(dbCon);

                if (oProp.getCodError() < 0) {
                    throw new SurException ("Error en getPolizaAEndosar [getDB]:" + oProp.getDescError());
                }
                
                LinkedList lAseg = new LinkedList ();

                lAseg = oProp.getDBAseguradosAEndosar(dbCon);

                if (oProp.getCodError() == -1) {
                    throw new SurException ("Error en getPolizaAEndosar [getDBAseguradosAEndosar]:" + oProp.getDescError());
                }
                request.setAttribute("propuesta", oProp );
                request.setAttribute("nomina", lAseg );
                doForward (request, response, "/propuesta/formEndosarAseg.jsp");
                
            }
                
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    
    protected void getEndoso (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        int codRama, numPoliza, numPropuesta = 0;
        LinkedList <AseguradoPropuesta> lAseg = null; 
        try {
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));

            dbCon = db.getConnection();

            Endoso oProp = new Endoso ();

            if (request.getParameter ("num_propuesta") == null || request.getParameter ("num_propuesta").equals ("0")) {
                oProp.setCodRama    ( Integer.parseInt (request.getParameter ("cod_rama")));
                oProp.setNumPoliza  ( Integer.parseInt (request.getParameter ("num_poliza")));
                oProp.setUserid(oUser.getusuario());
            } else {
                oProp.setNumPropuesta(Integer.parseInt (request.getParameter( "num_propuesta")));
            }
        
            oProp.getDB( dbCon);
           
            if (oProp.getCodError() != 0) {
                throw new SurException ("Error en el alta de Propuesta de endoso [getEndoso]");
            }
            
            oProp.getDBVerificarPoliza (dbCon, oUser.getusuario());
            
            String sMensaje = oProp.getDescError();
           
//            if (oProp.getCodError() != -200 && oProp.getCodError() != 0) {
            if (oProp.getCodError() == -1 && sMensaje.contains("YA EXISTE UN ENDOSO EN CARGA DE LA MISMA POLIZA") == false ) {
/*                switch (oProp.getCodError()) {
                    case -100: // la poliza no existe
                        sMensaje = "La p&oacute;liza solicitada no existe o no se encuentra registrada en la web.<br> Por favor comiquese con su representante.</br></br>Muchas Gracias.";
                        break;

                    case -300: // la poliza no esta vigente
                        sMensaje = "La p&oacute;liza no esta vigente.</br></br>Muchas Gracias.";
                        break;

                    case -400: // existe deuda
                        sMensaje = "La p&oacute;liza registra una deuda pendiente.<br> Ante cualquier duda por favor comiquese con su representante.</br></br>Muchas Gracias.";
                        break;   

                    case -500: // LA POLIZA esta anulada
                        sMensaje = "La p&oacute;liza esta anulada.";
                        break;
                    case -600: // LA POLIZA esta anulada
                        sMensaje = "Por el momento no es posible solicitar endosos de Vida Colectivo o Vida Deudores de un Acreedor.";
                        break;
                    case -700: // LA PoLIZA no tiene CUIC
                        sMensaje = "La p&oacute;liza aun no tiene CUIC asignado por la SSN.<br> Intente nuevamente en 48 a 76 hs. a partir de la emisión. Muchas gracias";
                        break;
                    case -800: //  vida colectivo y vida deudores.
                        sMensaje = "No puede realizar endosos el mismo día de vencimiento de la p&oacute;liza, deberá hacerlo en la renovaci&oacute;n.";
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
 *
 */
                request.setAttribute("mensaje", sMensaje);                
                request.setAttribute("volver", Param.getAplicacion() + "propuesta/formEndosoAB.jsp");             
                doForward (request, response, "/include/MsjHtmlServidor.jsp");
            } else {
                lAseg =  oProp.getDBAseguradosAEndosar(dbCon);

                if (oProp.getCodError() == -1) {
                    throw new SurException( oProp.getDescError());
                }

                request.setAttribute("propuesta", oProp );
                request.setAttribute("nomina", lAseg );
                doForward (request, response, "/propuesta/formEndosarAseg.jsp");
            }
        
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void delEndoso (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));

            dbCon = db.getConnection();

            Endoso oProp = new Endoso ();

            oProp.setNumPropuesta(Integer.parseInt (request.getParameter( "prop_numero")));
        
            oProp.setDBDelete( dbCon, oUser.getusuario());
           
            if (oProp.getCodError() < 0) {
                throw new SurException (oProp.getDescError());
            }
            
            request.setAttribute("volver", Param.getAplicacion() + "propuesta/filtrarPropuestas.jsp");
            request.setAttribute("mensaje", "El endoso fue eliminado exitosamente");
            doForward(request, response,  "/include/MsjHtmlServidor.jsp");
        
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }
    
    protected void delPersona (HttpServletRequest request, HttpServletResponse response)
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

            String tdBorrar = request.getParameter ("prop_del_tipo_doc");
            String ndBorrar = request.getParameter ("prop_del_num_doc");
            int    itBorrar = Integer.valueOf(request.getParameter ("prop_del_item"));

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

            AseguradoPropuesta oAseg = new AseguradoPropuesta();            
            
            oAseg.setCodProceso   (numProceso);
            oAseg.setCodBoca      (codBoca);
            oAseg.setNumPropuesta (nroPropuesta);           
            oAseg.setCodRama      (codRama);          
            oAseg.setTipoDoc      (tdBorrar);
            oAseg.setNumDoc       (ndBorrar);
            oAseg.setOrden        (itBorrar);
            
            dbCon = db.getConnection();
            
            oAseg.setDBEndosarBaja (dbCon);                       

            String sMensaje = "";
            
            if (oAseg.getiNumError() != 0) {
                switch (oAseg.getiNumError()) {
                    case -200 :
                        sMensaje = "El asegurado no existe en la nómina de la póliza";
                        break;
                    case -300 :
                        sMensaje = "El asegurado existe en otra propuesta pendiente de emisión.";
                        break;
                    case -400 :
                        sMensaje = "Asegurado existente en la propuesta de endoso";
                        break;
                    case -500 :
                        sMensaje = "La baja ya existe con fecha de vigencia mayor a la del d&iacute;a, verifique desde consulta de p&oacute;oliza, solapa Endosos.";
                        break;
 
                    default :
                        sMensaje = "Se ha producido un erroe en el alta del endoso";
                }
                
                request.setAttribute("volver", "-1");
                request.setAttribute("mensaje", sMensaje);
                doForward(request, response, "/include/MsjHtmlServidor.jsp");
            } else {
                response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);                
                response.setHeader("Location",
                                   "/benef/servlet/EndosoServlet?opcion=editEndoso&num_propuesta="  + oAseg.getNumPropuesta()   );
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }                    

    protected void cancelPersona (HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException, SurException {      
        
        Connection dbCon = null;
        try {            
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));                       

            int nroPropuesta = 0;
            if ( request.getParameter ("prop_numero") != null && 
                 !request.getParameter ("prop_numero").equals("") ) {
               nroPropuesta  = Integer.parseInt( request.getParameter ("prop_numero") );
            }           
            
            String tdBorrar = request.getParameter ("prop_del_tipo_doc");
            String ndBorrar = request.getParameter ("prop_del_num_doc");

            AseguradoPropuesta oAseg = new AseguradoPropuesta();            
            
            oAseg.setNumPropuesta (nroPropuesta);           
            oAseg.setTipoDoc      (tdBorrar);
            oAseg.setNumDoc       (ndBorrar);
            
            dbCon = db.getConnection();
            
            oAseg.setDBCancelarEndosoAseg (dbCon);                       

            response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);                
            response.setHeader("Location",
                               "/benef/servlet/EndosoServlet?opcion=editEndoso&num_propuesta="  + oAseg.getNumPropuesta()   );

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }                    
    
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
            
            int codRama = 0;          
            if ( request.getParameter ("prop_rama") != null && 
                 !request.getParameter ("prop_rama").equals("") ) {                 
                 codRama  = Integer.parseInt( request.getParameter ("prop_rama") );    
            }
            
            String apeNom = request.getParameter ("prop_nom_ApeNom");
            String tipDoc = request.getParameter ("prop_nom_tipDoc");
            String numDoc = request.getParameter ("prop_nom_numDoc");           

            AseguradoPropuesta oAseg = new AseguradoPropuesta();
            
            oAseg.setCodProceso  (numProceso);
            oAseg.setCodBoca     (codBoca);
            oAseg.setNumPropuesta(nroPropuesta);           
            oAseg.setCodRama     (codRama);
            oAseg.setOrden       (orden);           
            oAseg.setTipoDoc     (tipDoc);
            oAseg.setNumDoc      (numDoc);
            oAseg.setNombre      (apeNom);                                                      
            
            String fechaNacimiento = (request.getParameter ("prop_nom_fechaNac")==null)?"":request.getParameter ("prop_nom_fechaNac");
            if (fechaNacimiento.equals("")) {
                oAseg.setFechaNac(null);
            } else {
                oAseg.setFechaNac(Fecha.strToDate( request.getParameter ("prop_nom_fechaNac") ));                            
            }    
            
            dbCon = db.getConnection();
            oAseg.setDBEndosarAlta (dbCon);

            String sMensaje = "";
            
            if (oAseg.getiNumError() < 0) {
/*                switch (oAseg.getiNumError()) {
                    case -200 :
                        sMensaje = "El asegurado ya existe en la nómina de la póliza";
                        break;
                    case -400 :
                        sMensaje = "El asegurado ya existe en la propuesta de endoso";
                        break;
                    case -500 :
                        sMensaje = "El asegurado ya fue dado de alta pero aùn no esta vigente, puede verificarlo desde la Consulta de P&oacuteliza, solapa Endosos";
                        break;
                    default :
                        sMensaje = "Se ha producido un error en el alta del endoso";
                }
 *
 */
                sMensaje = oAseg.getsMensError();
                request.setAttribute("volver", "-1");
                request.setAttribute("mensaje", sMensaje);
                doForward(request, response,"/include/MsjHtmlServidor.jsp");
            } else {
                response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);                
                response.setHeader("Location",
                                   "/benef/servlet/EndosoServlet?opcion=editEndoso&num_propuesta="  + oAseg.getNumPropuesta()   );
            }
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }    

    protected void setFormTomador (HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException, SurException {        
        
        Connection dbCon = null;
	int[] numPropuestas =new int[2];
        
        try {            
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));         
                        
            numPropuestas [0] = 0;
            numPropuestas [1] = 0;
            
            String sRazonSocial = request.getParameter ("razon_social");
            String domicilio = request.getParameter ("domicilio");
            int codLoc  = Integer.parseInt (request.getParameter ( "cod_localidad"));

            String codProv   = request.getParameter ( "cod_provincia");
            String localidad = request.getParameter ("localidad");
            String codPostal = request.getParameter ("cod_postal");
            
            
            int codRama      = Integer.parseInt( request.getParameter ("cod_rama") );  
            
            int  numPoliza   = Integer.parseInt( request.getParameter ("num_poliza") );
            int codIva       = Integer.parseInt( request.getParameter ("cond_iva") );
            String telefono  =  request.getParameter ("telefono");
            String email     =  request.getParameter ("email");
            int tipoEndoso   = Integer.parseInt (request.getParameter ("TIPO_ENDOSO"));

            String ubicIgualTomador  =  request.getParameter ("ubic_igual_tomador");

            Endoso oProp = new Endoso ();

            dbCon = db.getConnection();
            
            oProp.setCodRama  (codRama);
            oProp.setNumPoliza(numPoliza);
            oProp.setTomadorRazon(sRazonSocial);
            oProp.setTomadorDom(domicilio);
            oProp.setTomadorCodLocalidad(codLoc);
            oProp.setTomadorCodProv(codProv);
            oProp.setTomadorCP(codPostal);
            oProp.setTomadorLoc(localidad);
            oProp.setUserid(oUser.getusuario());
            oProp.setTomadorTE(telefono);
            oProp.setTomadorCondIva(codIva);
            oProp.settipoEndoso(tipoEndoso);           
            oProp.setTomadorEmail(email);

            oProp.setDBEndosarTomador (dbCon);

            if (oProp.getCodError() < 0) {
                request.setAttribute("volver", "-1");
                request.setAttribute("mensaje", oProp.getDescError());
                doForward(request, response,"/include/MsjHtmlServidor.jsp");
            } else {                
                numPropuestas [0] = oProp.getNumPropuesta();
                
                if (ubicIgualTomador != null && ubicIgualTomador.equals("S") ) {
                    oProp.setCodError(0);
                    oProp.settipoEndoso (1302);
                    oProp.setnumPropuestaSec(oProp.getNumPropuesta());
                    
                    UbicacionRiesgo oUbic = new UbicacionRiesgo();
                    oUbic.setdomicilio(domicilio);
                    oUbic.setcodLocalidad(codLoc);
                    oUbic.setprovincia(codProv);
                    oUbic.setcodPostal(codPostal);
                    oUbic.setlocalidad(localidad);
                    oProp.setoUbicacionRiesgo(oUbic);

                    oProp.setDBEndosarUbicacion (dbCon);
                    
                    if (oProp.getCodError() < 0 ) {
                        request.setAttribute("volver", "-1");
                        request.setAttribute("mensaje", oProp.getDescError());
                        doForward(request, response,"/include/MsjHtmlServidor.jsp");
                    } else {
                        numPropuestas [1] = oProp.getNumPropuesta();
                    }
                }
                                
            }
        
            getServletConfig().getServletContext().getRequestDispatcher("/servlet/PropuestaServlet?opcion=enviarPropuesta&prop_numero=" + numPropuestas[0] + "&prop_numero_2=" + numPropuestas [1] ).include(request,response);
  
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }    
    
    protected void setFormUbicacion (HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException, SurException {        
        
        Connection dbCon = null;
        try {            
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));         

            String domicilio = request.getParameter ("domicilio");
            int codLoc  = Integer.parseInt (request.getParameter ( "cod_localidad"));
            String codProv   = request.getParameter ( "cod_provincia");
            String localidad = request.getParameter ("localidad");
            String codPostal = request.getParameter ("cod_postal");
            int codRama      = Integer.parseInt( request.getParameter ("cod_rama") );  
            int  numPoliza   = Integer.parseInt( request.getParameter ("num_poliza") );
            int tipoEndoso   = Integer.parseInt (request.getParameter ("TIPO_ENDOSO"));

            Endoso oProp = new Endoso ();
            oProp.setCodRama  (codRama);
            oProp.setNumPoliza(numPoliza);
            oProp.setUserid     (oUser.getusuario());
            oProp.settipoEndoso(tipoEndoso);           

            dbCon = db.getConnection();
                        
            UbicacionRiesgo oUbic = new UbicacionRiesgo();

            oUbic.setdomicilio(domicilio);
            oUbic.setcodLocalidad(codLoc);
            oUbic.setprovincia(codProv);
            oUbic.setcodPostal(codPostal);
            oUbic.setlocalidad(localidad);
            oUbic.setigualTomador(null);
            
            oProp.setoUbicacionRiesgo(oUbic);
        
            oProp.setDBEndosarUbicacion (dbCon);

            if (oProp.getCodError() < 0) {
                request.setAttribute("volver", "-1");
                request.setAttribute("mensaje", oProp.getDescError());
                doForward(request, response,"/include/MsjHtmlServidor.jsp");
            } else
                getServletConfig().getServletContext().getRequestDispatcher("/servlet/PropuestaServlet?opcion=enviarPropuesta&prop_numero=" + oProp.getNumPropuesta()).include(request,response);
                
            
         
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }    

    protected void setFormClausulas (HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException, SurException {        
        
        Connection dbCon = null;
        try {            
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));         

            int codRama      = Integer.parseInt( request.getParameter ("cod_rama") );  
            int  numPoliza   = Integer.parseInt( request.getParameter ("num_poliza") );
            int tipoEndoso   = Integer.parseInt (request.getParameter ("TIPO_ENDOSO"));
            String noRepeticion = request.getParameter ("cla_no_repeticion");
            String subrogacion  = request.getParameter ("cla_subrogacion");

            Endoso oProp = new Endoso ();
            oProp.setCodRama  (codRama);
            oProp.setNumPoliza(numPoliza);
            oProp.setUserid     (oUser.getusuario());
            oProp.settipoEndoso(tipoEndoso);           
            oProp.setclaNoRepeticion(noRepeticion);
            oProp.setclaSubrogacion(subrogacion);

            dbCon = db.getConnection();                        

            // Get the values of all request parameters
            LinkedList <Clausula> lClau = new LinkedList ();
            Enumeration en=request.getParameterNames();
            int item =  0;
            while(en.hasMoreElements())
            {
                Object objOri=en.nextElement();
                String param=(String)objOri;
                if (param.startsWith("descripcion") ) {                    
                    String value= request.getParameter(param);
                    
                    if ( value != null && ! value.trim().equals ("") ) {
                        int indice = Integer.parseInt (param.replace("descripcion", ""));
                        
                        String cuit = request.getParameter ("cuit" + indice);
                       
                        item += 1;
                        Clausula oClau = new Clausula ();
                        oClau.setdescEmpresa(value);
                        oClau.setcuitEmpresa(cuit);
                        oClau.setnumItem(item);
                        lClau.add(oClau);
                        
                    }
                }
                    
            }
            
            
            if (item > 0 ) {
                oProp.setAllClausulas(lClau);
                oProp.setDBEndosarClausulas(dbCon);
            } else {
                oProp.setCodError(-1);
                oProp.setDescError("DESCRIPCIONES DE CLAUSULAS VACIAS");
            }
			

            if (oProp.getCodError() < 0) {
                request.setAttribute("volver", "-1");
                request.setAttribute("mensaje", oProp.getDescError());
                doForward(request, response,"/include/MsjHtmlServidor.jsp");
            } else
                getServletConfig().getServletContext().getRequestDispatcher("/servlet/PropuestaServlet?opcion=enviarPropuesta&prop_numero=" + oProp.getNumPropuesta()).include(request,response);
                
            
         
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }    

    protected void setFormComisiones (HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException, SurException {        
        
        Connection dbCon = null;
        try {            
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));         

            int codRama      = Integer.parseInt( request.getParameter ("cod_rama") );  
            int  numPoliza   = Integer.parseInt( request.getParameter ("num_poliza") );
            int tipoEndoso   = Integer.parseInt (request.getParameter ("TIPO_ENDOSO"));
            double porcComisionProd = Dbl.StrtoDbl (request.getParameter ("porc_comision_prod"));
            double porcComisionOrg  = Dbl.StrtoDbl (request.getParameter ("porc_comision_org"));
            int   subSeccion =  Integer.parseInt (request.getParameter ("sub_seccion"));

            Endoso oProp = new Endoso ();
            oProp.setCodRama        (codRama);
            oProp.setNumPoliza      (numPoliza);
            oProp.setUserid         (oUser.getusuario());
            oProp.settipoEndoso     (tipoEndoso);           
            oProp.setporcGDA        (porcComisionProd);
            oProp.setporcComisionOrg(porcComisionOrg);
            oProp.setsubSeccion     (subSeccion);

            dbCon = db.getConnection();                        

            oProp.setDBEndosarComisiones(dbCon);  

            if (oProp.getCodError() < 0) {
                request.setAttribute("volver", "-1");
                request.setAttribute("mensaje", oProp.getDescError());
                doForward(request, response,"/include/MsjHtmlServidor.jsp");
            } else
                getServletConfig().getServletContext().getRequestDispatcher("/servlet/PropuestaServlet?opcion=enviarPropuesta&prop_numero=" + oProp.getNumPropuesta()).include(request,response);
                
            
         
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }    
    
    protected void grabarEndoso (HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException, SurException {        
        
        Connection dbCon = null;
        try {            
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));         
                        
            int nroPropuesta = 0;
            if ( request.getParameter ("prop_numero") != null && 
                 !request.getParameter ("prop_numero").equals("") ) {
               nroPropuesta  = Integer.parseInt( request.getParameter ("prop_numero") );
            }           
            int codRama = 0;          
            if ( request.getParameter ("prop_rama") != null && 
                 !request.getParameter ("prop_rama").equals("") ) {                 
                 codRama  = Integer.parseInt( request.getParameter ("prop_rama") );    
            }

            int numPoliza = 0;
            if ( request.getParameter ("num_poliza") != null &&
                 !request.getParameter ("num_poliza").equals("") ) {
                 numPoliza  = Integer.parseInt( request.getParameter ("num_poliza") );
            }
            
            Endoso oProp = new Endoso ();

            dbCon = db.getConnection();
            
            oProp.setNumPropuesta   (nroPropuesta);
            oProp.setCodRama        (codRama);
            oProp.setNumPoliza(numPoliza);
 //           oProp.setCodEstado      (0);

            oProp.setmcaEnvioPoliza (request.getParameter ("prop_mca_envio_poliza") == null ? "S" : request.getParameter ("prop_mca_envio_poliza"));
            oProp.setObservaciones  (request.getParameter ("prop_obs"));
            String fechaVigDesde    = ( request.getParameter ("prop_vig_desde") == null) ? "" : request.getParameter ("prop_vig_desde");
            if (fechaVigDesde.equals("")) {
                oProp.setFechaIniVigPol(null);
            } else {                
                oProp.setFechaIniVigPol( Fecha.strToDate( request.getParameter ("prop_vig_desde") ));
            }    
            oProp.setUserid(oUser.getusuario());
  
            oProp.setDBEndosar(dbCon);

            if (oProp.getCodError() < 0) {
                request.setAttribute("volver", "-1");
                request.setAttribute("mensaje", oProp.getDescError());
                doForward(request, response,"/include/MsjHtmlServidor.jsp");
            } else {
                String op = request.getParameter("opcion");

                if (op.equals ("addPersona")) {
                    addPersona(request, response);
                } else if (op.equals ("delPersona")) {
                    delPersona(request, response);
                } else if (op.equals ("cancelPersona")) {
                    cancelPersona(request, response);
                }  else if (op.equals ("enviarEndoso")) {
                    enviarPropuesta(request, response);
                }
            }
         
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }    
    
    protected void enviarPropuesta (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {      
        
        Connection dbCon = null;
        try {            
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));                       
            int nroPropuesta = 0;
            if ( request.getParameter ("prop_numero") != null && 
                 !request.getParameter ("prop_numero").equals("") ) {
               nroPropuesta  = Integer.parseInt( request.getParameter ("prop_numero") );
            }            
            dbCon = db.getConnection();         
            
            Endoso oProp = new Endoso();
            oProp.setNumPropuesta( nroPropuesta);         
            oProp.setUserid      (oUser.getusuario());
            oProp.setCodEstado   ( 1 );                           
              
            oProp.setDBEstado(dbCon);
            
            String  sMensaje = "La propuesta de Endoso Nro.: " + nroPropuesta + " ha sido enviada con exito ! ";
            String  sVolver  = Param.getAplicacion() + "propuesta/printEndoso.jsp?opcion=printEndoso&formato=HTML&cod_rama=0&num_propuesta=" + nroPropuesta;
            
            if (oProp.getCodError() < 0) {
                switch (oProp.getCodError()) {                
                    case -400 :
                        sMensaje = "La propuesta no pudo ser enviada porque existe otra p&oacute;liza con deuda del mismo tomador. Por favor, contactese con su representante comercial. Muchas gracias ";
                        break;

                    case -500:
                        sMensaje = "La propuesta no pudo ser enviada porque un asegurado de la n&oacute;mina ya existe en otra p&oacute;liza vigente o anulada con deuda. Por favor, contactese con su representante comercial. Muchas gracias ";
                        sVolver  = "-1";
                        break;
                    case -800:
                        sMensaje = "LA PROPUESTA YA FUE ENVIADA";
                        sVolver  = "-1";
                        break;
                    case -900:
                        sMensaje = "UN MOVIMIENTO YA EXISTE EN OTRA PROPUESTA DEL MISMO DIA";
                        sVolver  = "-1";
                        break;
                    default:
                        sMensaje =  oProp.getDescError();
                        sVolver  = "-1";
                }
            } else {
                oProp.getDB(dbCon);

    // setear el control de acceso
                ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
                oControl.setearAcceso(dbCon, 20); // setear en TABLAS LA PROCEDENCIA: ENDOSOS ENVIADOS

    // fin de setear el control de acceso 

                this.sendEmailPropuesta (dbCon, oUser, oProp );
            }

            request.setAttribute("mensaje", sMensaje);                
            request.setAttribute("volver", sVolver );             
            doForward (request, response, "/include/MsjHtmlServidor.jsp");     
                
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }                
    
    
    protected void sendEmailPropuesta (Connection dbCon, Usuario oUser, Endoso oCot)
    throws ServletException, IOException, SurException {
        StringBuilder sMensaje = new StringBuilder();
        try {
      //    String  sMsgCuotas = "En "+ oCot.getCantCuotas() +" cuotas de $"+ Dbl.DbltoStr(oCot.getImpCuota() ,2);
            
            sMensaje.append("AVISO DE SOLICITUD DE ENDOSO DE ").append(oCot.getDescRama()).append(" - N ").append(oCot.getNumPropuesta ()).append("\n");
            
            sMensaje.append("-----------------------------------\n\n");
            sMensaje.append("NUM PROPUESTA: ").append(oCot.getNumPropuesta ()).append("\n");
            sMensaje.append("NUM DE POLIZA: ").append(Formatos.showNumPoliza (oCot.getNumPoliza ())).append("\n");
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