/*
 * CotizadorApServlet.java
 *
 * Created on 29 de enero de 2005, 13:46
 */

package servlets;  
       
import java.io.IOException;
import java.util.LinkedList;
import java.util.List;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;

import com.business.beans.Usuario;
import com.business.beans.CotizadorAp;
import com.business.beans.Cotizacion;
import com.business.beans.Persona;
import com.business.beans.ConsultaMaestros;
import com.business.beans.FormaPago;
import com.business.util.*;
import com.business.db.*;
import com.business.beans.CotFinanciacion;
import com.business.beans.Facturacion;

import javax.servlet.*;
import javax.servlet.http.*;

/**
 *
 * @author Rolando Elisii
 * @version
 */
public class CotizadorApServlet extends HttpServlet {
    
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
            if ( request.getParameter ("procedencia") != null) {
                getServletConfig().getServletContext().getRequestDispatcher("/servlet/setAccess?opcion=ADDPROC").include(request,response);
            }

            String op =  request.getParameter("opcion");
            
            if (op.equals("addCotizacion")) {
                addCotizacion (request, response);
            
            } else if (op.equals("getAllCotizaciones")) {
                getAllCotizaciones (request, response);

            } else if (op.equals("getPrintCot")) {
                getPrintCotizacion (request, response);
            
            } else if (op.equals("cambiarEstado")) {
                cambiarEstadoCotizacion (request, response);
            
            } else if (op.equals("sendEmailCot")) {
                sendEmailCotizacion (request, response);

            } else if (op.equals("ABMaddCotizacion")) {
                ABMaddCotizacion (request, response);
            
            } else if (op.equals("getCot")) {
                getCotizacion (request, response);
            
            } else if (op.equals ("cotizador")) {
                Cotizador (request, response);

            } else if (op.equals("getCotNew")) {
                getCotizacionNew (request, response);

            } else if (op.equals("getCotPDF") || op.equals("getCotEmail")) {
                getCotizacionPDF (request, response);

            }
            
         } catch (SurException se) {
            goToJSPError(request,response, se);
        } catch (Exception e) {
            goToJSPError(request,response, e);
        }
    }

    protected void Cotizador (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));

            Cotizacion oCot = new Cotizacion ();
            oCot.setcodRama           (Integer.parseInt (request.getParameter("COD_RAMA")));
            oCot.setcodSubRama        (Integer.parseInt (request.getParameter("COD_SUB_RAMA")));
            oCot.setcodAmbito         (Integer.parseInt (request.getParameter("COD_AMBITO")));
            oCot.setcodProvincia      (Integer.parseInt (request.getParameter("COD_PROVINCIA")));
            oCot.setcodVigencia       (Integer.parseInt (request.getParameter("COD_VIGENCIA")));
            oCot.setcantPersonas      (Integer.parseInt (request.getParameter("CANT_PERSONAS")));
            oCot.setcapitalMuerte     (Dbl.StrtoDbl(request.getParameter("CAPITAL_MUERTE")));
            oCot.setcapitalInvalidez  (Dbl.StrtoDbl(request.getParameter("CAPITAL_INVALIDEZ")));
            oCot.setcapitalAsistencia (Dbl.StrtoDbl(request.getParameter("CAPITAL_ASISTENCIA")));
            oCot.setfranquicia        (Dbl.StrtoDbl(request.getParameter("FRANQUICIA")));
            oCot.setnumCotizacion     (Integer.parseInt (request.getParameter ("num_cotizacion")));
            oCot.settomadorApe        (request.getParameter ("TOMADOR_APE"));
            oCot.setuserId(oUser.getusuario());
            if (request.getParameter ("COD_PROD") == null){
               oCot.setcodProd(oUser.getiCodProd());
            }else{
               oCot.setcodProd(Integer.parseInt(request.getParameter ("COD_PROD")));
            }

            oCot.setmcaTipoCotizacion(request.getParameter ("tipo_cotizacion"));

            if (oCot.getmcaTipoCotizacion().equals ("APD")) {
                oCot.setcodActividad      (Integer.parseInt (request.getParameter("actividad")));

                if (request.getParameter ("actividad2") != null &&
                    ! request.getParameter ("actividad2").equals ("")) {
                    oCot.setcodActividadSec (Integer.parseInt (request.getParameter ("actividad2")));
                }
            } else {
                oCot.setcategoria( Integer.parseInt (request.getParameter("CATEGORIA")));
            }

            if (request.getParameter ("COD_OPCION") != null &&
              ! request.getParameter ("COD_OPCION").equals ("") ) {
                oCot.setcodOpcion     (Integer.parseInt (request.getParameter ("COD_OPCION")));
            }

            if (request.getParameter ("mca_prestacion") != null ) {
                oCot.setmcaPrestacion (request.getParameter ("mca_prestacion"));
            } else {
                oCot.setmcaPrestacion(oCot.getcodSubRama() == 1 ? "R" : "P");
            }

            oCot.setcodProducto (Integer.parseInt (request.getParameter ("COD_PRODUCTO")));
            
            if (oCot.getcodVigencia() == 7 ) {
                oCot.setcantDias(Integer.parseInt (request.getParameter ("CANT_DIAS")));
            } else {
                oCot.setcantDias(0);
            }
            
            oCot.setcategoriaPersona(request.getParameter("categoria_persona"));
            
            dbCon = db.getConnection();
            oCot.setDB (dbCon);
// setear el control de acceso
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, 13);
            String sMensaje = "";
            String sVolver = "";
// fin de setear el control de acceso
            if (oCot.getiNumError() == 0) {

                oCot.setDBCotizarAp(dbCon, "C");

                if (oCot.getiNumError() < 0 ) {
                        sMensaje = "";
                        switch (oCot.getiNumError() ) {
                            case -200:
                                sMensaje = "Riesgo no cotizable por la web, para más información contactese con su representante comercial. Muchas gracias ";
                                break;
                            case -301:
                                sMensaje = "Alguna de las actividades seleccionadas no es compatible con el ámbito 24 HORAS.";
                                break;
                            case -302:
                                sMensaje = "Alguna de las actividades seleccionadas no es compatible con el ámbito LABORAL e ITINERE.";
                                break;
                            case -303:
                                sMensaje = "Alguna de las actividades seleccionadas no es compatible con el ámbito 24 LABORAL EXCLUSIVAMENTE";
                                break;
                            default:
                                sMensaje = "";
                        }

                    if ( ! sMensaje.equals("")) {
                        sVolver  = Param.getAplicacion() + "servlet/CotizadorApServlet?opcion=getCotNew&num_cotizacion=" + oCot.getnumCotizacion() + "&siguiente=solapa1";
                        request.setAttribute("mensaje", sMensaje );
                        request.setAttribute("volver", sVolver );
                        doForward (request, response, "/include/MsjHtmlServidor.jsp");
                    } else {
                        throw new SurException (oCot.getsMensError() );
                    }
                } else {
                    oCot.getDB(dbCon);
                    
                    if (oCot.getiNumError() < 0 ) {
                        throw new SurException (oCot.getsMensError() );
                    } else {
                        oCot.getDBFinanciacion(dbCon);
                        if (oCot.getiNumError() < 0 ) {
                            throw new SurException (oCot.getsMensError() );
                        } else { 
                            request.setAttribute("cotizacion", oCot);
                            doForward (request, response, "/cotizador/ap/cotizaAP_deta_sol2.jsp");
                        }
                    }
                }

            } else {
                throw new SurException (oCot.getsMensError() );
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void addCotizacion (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));
            
            CotizadorAp oCot = new CotizadorAp ();

            oCot.setcodRama           (Integer.parseInt (request.getParameter("COD_RAMA")));
            oCot.setcodSubRama        (Integer.parseInt (request.getParameter("COD_SUB_RAMA")));
            oCot.setcodAmbito         (Integer.parseInt (request.getParameter("COD_AMBITO")));
            oCot.setcodActividad      (Integer.parseInt (request.getParameter("COD_ACTIVIDAD")));
            oCot.setcodProvincia      (Integer.parseInt (request.getParameter("COD_PROVINCIA")));
            oCot.setcodVigencia       (Integer.parseInt (request.getParameter("COD_VIGENCIA")));
            oCot.setcantPersonas      (Integer.parseInt (request.getParameter("CANT_PERSONAS")));
            oCot.setgastosAdquisicion (Dbl.StrtoDbl(request.getParameter("GASTOS_ADQUISICION")));
            oCot.setcapitalMuerte     (Dbl.StrtoDbl(request.getParameter("CAPITAL_MUERTE")));
            oCot.setcapitalInvalidez  (Dbl.StrtoDbl(request.getParameter("CAPITAL_INVALIDEZ")));
            oCot.setcapitalAsistencia (Dbl.StrtoDbl(request.getParameter("CAPITAL_ASISTENCIA")));
            oCot.setfranquicia        (Dbl.StrtoDbl(request.getParameter("FRANQUICIA")));
            oCot.setnumCotizacion     (Integer.parseInt (request.getParameter ("numCotizacion")));
            oCot.settomadorApe        (request.getParameter ("TOMADOR_APE"));
//            oCot.settomadorNom        (request.getParameter ("TOMADOR_NOM"));
            oCot.settomadorTel        (request.getParameter ("TOMADOR_TEL"));
            oCot.settomadorCodIva     (Integer.parseInt (request.getParameter ("TOMADOR_COD_IVA")));
            oCot.setcantCuotas        (Integer.parseInt (request.getParameter ("cuotas")));

            oCot.setuserId(oUser.getusuario());
            if (request.getParameter ("COD_PROD") == null){
               oCot.setcodProd(oUser.getiCodProd());
            }else{
               oCot.setcodProd(Integer.parseInt(request.getParameter ("COD_PROD")));
            }
            
            oCot.setcodActividadSec (Integer.parseInt (request.getParameter ("cod_actividad_sec")));
            oCot.setcodOpcion       (Integer.parseInt (request.getParameter ("cod_opcion")));
            
            dbCon = db.getConnection();
            oCot.setDB(dbCon);

// setear el control de acceso
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, 13);
                          
// fin de setear el control de acceso 
            
            if (oCot.getnumCotizacion() > 0) {
 
                doForward (request, response, "/cotizador/10/printCotizadorAp.jsp?opcion=getPrintCot&tipo=html&origen=cotizacion&numCotizacion="+oCot.getnumCotizacion());
                  
            } else {
                String sMensaje = "Hubo algún problema en el cotizador. Por favor, contactese con su representante en Beneficio. Sepa disculparnos.";
                String sVolver  = Param.getAplicacion() + "index.jsp";
                if (oCot.getnumCotizacion() == -200) {
                    sMensaje = "Riesgo no cotizable, para más información contactese con su representante comercial. Muchas gracias ";
                    sVolver  = Param.getAplicacion() + "cotizador/10/formCotizadorAp.jsp";
                }
                request.setAttribute("mensaje", sMensaje );                
                request.setAttribute("volver", sVolver );             
                doForward (request, response, "/include/MsjHtmlServidor.jsp");
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }


    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void ABMaddCotizacion (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));
            
            CotizadorAp oCot = new CotizadorAp ();

            oCot.setcodRama           (Integer.parseInt (request.getParameter("COD_RAMA")));
            oCot.setcodSubRama        (Integer.parseInt (request.getParameter("COD_SUB_RAMA")));
            oCot.setcodAmbito         (Integer.parseInt (request.getParameter("COD_AMBITO")));
            oCot.setcodActividad      (Integer.parseInt (request.getParameter("COD_ACTIVIDAD")));
            oCot.setcodProvincia      (Integer.parseInt (request.getParameter("COD_PROVINCIA")));
            oCot.setcodVigencia       (Integer.parseInt (request.getParameter("COD_VIGENCIA")));
            oCot.setcantPersonas      (Integer.parseInt (request.getParameter("CANT_PERSONAS")));
            oCot.setgastosAdquisicion (Double.parseDouble(request.getParameter("GASTOS_ADQUISICION")));
            oCot.setcapitalMuerte     (Double.parseDouble(request.getParameter("CAPITAL_MUERTE")));
            oCot.setcapitalInvalidez  (Double.parseDouble(request.getParameter("CAPITAL_INVALIDEZ")));
            oCot.setcapitalAsistencia (Double.parseDouble(request.getParameter("CAPITAL_ASISTENCIA")));
            oCot.setfranquicia        (Double.parseDouble(request.getParameter("FRANQUICIA")));
            oCot.setnumCotizacion     (Integer.parseInt (request.getParameter ("numCotizacion")));
            oCot.setabm               ("S");
            oCot.setcodActividadSec(Integer.parseInt (request.getParameter ("cod_actividad_sec")));
            oCot.setcodOpcion         (Integer.parseInt (request.getParameter ("cod_opcion")));
            oCot.setuserId(oUser.getusuario());

            dbCon = db.getConnection();
            oCot.setDB(dbCon);

// setear el control de acceso
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, 13);
                          
// fin de setear el control de acceso 
            
            if (oCot.getnumCotizacion() > 0) {
                  doForward (request, response, "/cotizador/10/ABMprintCotizadorAp.jsp?opcion=getPrintCot&tipo=html&origen=cotizacion&numCotizacion="+oCot.getnumCotizacion());
            } else {
                String sMensaje = "Hubo algún problema en el cotizador. Por favor, contactese con su representante en Beneficio. Sepa disculparnos.";
                String sVolver  = Param.getAplicacion() + "index.jsp";
                if (oCot.getnumCotizacion() == -200) {
                    sMensaje = "Riesgo no cotizable, para más información contactese con su representante comercial. Muchas gracias ";
                    sVolver  = Param.getAplicacion() + "cotizador/10/ABMformCotizadorAp.jsp";
                }
                request.setAttribute("mensaje", sMensaje );                
                request.setAttribute("volver", sVolver );             
                doForward (request, response, "/include/MsjHtmlServidor.jsp");
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }
    
    
    public void cambiarEstadoCotizacion (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {
            dbCon = db.getConnection();  
            int numCotizacion = request.getParameter ("numCotizacion")==null?-1:
                                Integer.parseInt (request.getParameter ("numCotizacion"));
            int estado        = request.getParameter ("estado")==null?-1:
                                Integer.parseInt (request.getParameter ("estado"));       
            Usuario oUser     = (Usuario) (request.getSession().getAttribute("user"));                                

            //si no vino el estado como parametro
            if ( estado == -1 || numCotizacion == -1){
                request.setAttribute("mensaje", "Ocurrio un error al intentar cambiar el estado de la Cotizacion. </br>Por favor reintente.<br><br> Muchas Gracias.");
                request.setAttribute("volver", Param.getAplicacion() + "servlet/CotizadorApServlet?opcion=getAllCotizaciones");             
                doForward (request, response, "/include/MsjHtmlServidor.jsp");                      
            }else{
                CotizadorAp oCot = new CotizadorAp ();
                oCot.setnumCotizacion (numCotizacion);             
                oCot.setestadoCotizacion (estado);        
                oCot.setusuarioCambiaEstado ( oUser.getusuario());
                 
                oCot.setDBCambiarEstadoCotizacion (dbCon);
                
                //enviar email informando que cambio el estado de la cotizacion
                this.sendEmailCotizacion(request,response);
            }
           
        } catch (Exception se) {
           throw new SurException (se.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }
  
    
    protected void getAllCotizaciones (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons = null;
        LinkedList lCot = new LinkedList();
        try {
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
           
            dbCon = db.getConnection();
            dbCon.setAutoCommit(false);
            
            cons = dbCon.prepareCall(db.getSettingCall("COT_GET_ALL_COTIZACIONES(?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString (2, oUser.getusuario());
            
            cons.execute();
            
            ResultSet rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    CotizadorAp oCot = new CotizadorAp();
                    oCot.setnumCotizacion     (rs.getInt("NUM_COTIZACION"));
                    oCot.setcodRama           (rs.getInt("COD_RAMA"));
                    oCot.setcodSubRama        (rs.getInt("COD_SUB_RAMA"));
                    oCot.setcodAmbito         (rs.getInt("COD_AMBITO"));
                    oCot.setcodActividad      (rs.getInt("COD_ACTIVIDAD"));
                    oCot.setcodProvincia      (rs.getInt("COD_PROVINCIA"));
                    oCot.setcodVigencia       (rs.getInt("COD_VIGENCIA"));
                    oCot.setcantPersonas      (rs.getInt("CANT_PERSONAS"));
                    oCot.setgastosAdquisicion (rs.getDouble("GASTOS_ADQUISICION"));
                    oCot.setcapitalMuerte     (rs.getDouble("CAPITAL_MUERTE"));
                    oCot.setcapitalInvalidez  (rs.getDouble("CAPITAL_INVALIDEZ"));
                    oCot.setcapitalAsistencia (rs.getDouble("CAPITAL_ASISTENCIA"));
                    oCot.setfranquicia        (rs.getDouble("FRANQUICIA"));
                    oCot.setcodProd           (rs.getInt("COD_PROD"));
                    oCot.setuserId            (rs.getString("USUARIO"));
                    oCot.setusuarioCambiaEstado(rs.getString("USUARIO_CAMBIA_ESTADO"));
                    oCot.setdescUsuarioCambiaEstado(rs.getString("DESC_USUARIO_CAMBIA_ESTADO"));
                    oCot.setfechaCotizacion   (rs.getDate("FECHA_COTIZ"));
                    oCot.setfechaCambiaEstado (rs.getDate("FECHA_CAMBIA_ESTADO"));
                    oCot.settomadorApe        (rs.getString("TOMADOR_APE"));
                    oCot.settomadorNom        (rs.getString("TOMADOR_NOM"));
                    oCot.setdescUsu           (rs.getString ("DESC_USU"));
                    oCot.setestadoCotizacion  (rs.getInt("ESTADO"));
                    oCot.setabm               (rs.getString ("ABM"));
                    oCot.sethoraCotizacion    (rs.getString ("HORA_COTIZ"));
                    oCot.setsMcaBajaActividad (rs.getString("MCA_BAJA_ACT"));
                    oCot.settipoPropuesta     (rs.getString ("TIPO_PROPUESTA"));
                    lCot.add(oCot);
                }
                rs.close();
            }

            request.setAttribute("cotizaciones", lCot);
            doForward (request, response, "/cotizador/10/consCotizadorAp.jsp");
            
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

    protected void getPrintCotizacion (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        LinkedList lCot = new LinkedList();
        try {
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            int numCotizacion = Integer.parseInt (request.getParameter ("numCotizacion"));
            boolean viewPDF    = (request.getParameter ("tipo") != null && request.getParameter ("tipo").equals ("pdf") ? true : false);
            
            CotizadorAp oCot = new CotizadorAp ();
            oCot.setnumCotizacion (numCotizacion); 
            
           if (viewPDF) {
                this.getPrintAcrobat (request, response, oCot);
            } else {
                this.getPrintHTML(request, response, oCot);
            }
         
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } 
    }


    protected void getCotizacion (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        
        try {
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            int numCotizacion = Integer.parseInt (request.getParameter ("numCotizacion"));
            dbCon = db.getConnection();
            Parametro oParam = new Parametro ();
            oParam.setsCodigo("HABILITA_NEW_COT_AP");

            String sHabilitaNewCot = "S";

            if (oUser.getiCodTipoUsuario() != 0) {
                sHabilitaNewCot = oParam.getDBValor(dbCon);
            }

            if ( sHabilitaNewCot != null && sHabilitaNewCot.equals("S")) {
                doForward (request, response, "/servlet/CotizadorApServlet?opcion=getCotNew&num_cotizacion=" + numCotizacion + "&siguiente=solapa1" );
            } else {
                CotizadorAp oCot = new CotizadorAp();
                oCot.setnumCotizacion (numCotizacion);
                oCot.getDB(dbCon);

                request.setAttribute ("cotizador", oCot);

                if ( oCot.getabm().equals("S")){
                   doForward (request, response, "/cotizador/10/ABMformCotizadorAp.jsp");
                }else{
                   doForward (request, response, "/cotizador/10/formCotizadorAp.jsp");
                }
            }
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void getCotizacionNew (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;

        try {
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            int numCotizacion = (request.getParameter ("num_cotizacion") == null ? 0 :
                                 Integer.parseInt (request.getParameter ("num_cotizacion")));

            dbCon = db.getConnection();
            Cotizacion oCot = new Cotizacion ();
            oCot.setnumCotizacion (numCotizacion);
            oCot.getDB(dbCon);
            request.setAttribute ("cotizacion", oCot);

            if ( request.getParameter ("siguiente") == null ||
                 request.getParameter ("siguiente").equals("solapa1") || 
                 oCot.getmcaTipoCotizacion() == null
                ) {
               doForward (request, response, "/cotizador/ap/cotizaAP_deta_sol1.jsp");
            } else {
                oCot.getDBFinanciacion(dbCon);   
                if ( oCot.getiNumError()< 0) {
                    throw new SurException (oCot.getsMensError());
                } else { 
                    doForward (request, response, "/cotizador/ap/cotizaAP_deta_sol2.jsp");
                }
            }
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }
    
    protected void getPrintHTML (HttpServletRequest request, HttpServletResponse response, CotizadorAp oCot)
    throws ServletException, IOException, SurException {
        Connection dbCon        = null;
        CallableStatement cons  = null;
        LinkedList lCoberturas  = null;
        try {
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            
            dbCon = db.getConnection();
            oCot.getDB(dbCon);
            
            if (oCot.getiNumError() != 0) {
                throw new SurException (oCot.getsMensError());
            }
            
            request.setAttribute("cotizador", oCot);
            
            doForward (request, response, "/cotizador/10/report/cotizadorApHTML.jsp");

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

    protected void getCotizacionPDF (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon        = null;
        LinkedList lfPagos      = new LinkedList ();
        List <CotFinanciacion> lFinan  = new LinkedList ();
        try {
            dbCon = db.getConnection();

            if (dbCon == null ) {
                db.realPath (getServletConfig().getServletContext ().getRealPath("/propiedades/config.xml"));
                if (Param.getAplicacion() == null) {
                    Param.realPath (getServletContext().getRealPath("/propiedades/config.xml"));
                }
            }
            int numCotizacion = Integer.parseInt (request.getParameter ("num_cotizacion"));

            Cotizacion oCot = new Cotizacion ();
            oCot.setnumCotizacion(numCotizacion);

            oCot.getDB(dbCon);

            if (oCot.getiNumError() < 0) {
                throw new SurException (oCot.getsMensError());
            }

            oCot.getDBFinanciacion(dbCon);
            if (oCot.getiNumError() < 0) {
                throw new SurException (oCot.getsMensError());
            }
            
            Usuario user =  (Usuario) (request.getSession().getAttribute("user"));

            Report oReport = new Report ();

            oReport.setTitulo       ("Cotización de " + oCot.getdescRama());
            oReport.addlObj         ("subtitulo" , "COTIZACION");
            oReport.setUsuario      (user.getusuario());
            oReport.setFecha        (Fecha.toString(new java.util.Date ()));
            oReport.setFormulario   ("COT001");
            if (oCot.getcodRama() == 10 ) {
                oReport.setReportName   (getServletContext ().getRealPath("/cotizador/ap/report/cotizadorAP.xml"));
            }  else {
                oReport.setReportName   (getServletContext ().getRealPath("/cotizador/vc/report/cotizadorVC.xml"));
            }

            oReport.setsContextPath ( request.getScheme() + "://" + request.getHeader("host"));
            oReport.addImage        ("logo", getServletContext ().getRealPath("/images/logos/logo_beneficio_new.jpg"));
            oReport.addImage        ("firma", getServletContext ().getRealPath("/images/firmaBenef.jpg"));

            oReport.addlObj("C_NUM_COTIZACION", String.valueOf (oCot.getnumCotizacion()));
            oReport.addlObj("C_FECHA_COTIZ", Fecha.showFechaForm(oCot.getfechaCotizacion()));
            oReport.addlObj("C_CLIENTE", (oCot.gettomadorApe() == null ? " " : oCot.gettomadorApe()));
            oReport.addlObj("C_PRODUCTOR", (oCot.getdescProd() ));
            oReport.addlObj("C_CANT_PERSONAS", String.valueOf(oCot.getcantPersonas()));
            oReport.addlObj("C_PROVINCIA", oCot.getdescProvincia());
            if (oCot.getcodVigencia() == 7 ) { 
                oReport.addlObj("C_VIGENCIA", oCot.getcantDias() + " dia/s");
            } else { 
                oReport.addlObj("C_VIGENCIA", oCot.getdescVigencia());
            }
            oReport.addlObj("C_AMBITO", oCot.getdescAmbito());
            oReport.addlObj("C_CATEGORIA", String.valueOf( oCot.getcategoria()));
            oReport.addlObj("C_OPCIONAL", oCot.getsDescOpcion());
            oReport.addlObj("C_ACTIVIDAD", oCot.getdescActividad());
            if (oCot.getcodActividadSec() > 0 ) {
                oReport.addCondicion("ACTIVIDAD_SEC", "true");
                oReport.addlObj("C_ACTIVIDAD_SEC", oCot.getdescActividadSec());
            } else {
                oReport.addCondicion("ACTIVIDAD_SEC", "false");
                oReport.addlObj("C_ACTIVIDAD_SEC", " ");
            }
            if (oCot.getmcaPrestacion() == null) {
                oReport.addlObj("C_PRESTACIONAL", " ");
            } else {
                if ( oCot.getmcaPrestacion().equals ("P")) {
                    oReport.addlObj("C_PRESTACIONAL", "PRESTACIONAL");
                } else {
                    oReport.addlObj("C_PRESTACIONAL", "REINTEGRO");
                }
            }
            oReport.addlObj("C_SUMA_MUERTE",  Dbl.DbltoStr(oCot.getcapitalMuerte(), 0) );
            oReport.addlObj("C_SUMA_INVALIDEZ",  Dbl.DbltoStr(oCot.getcapitalInvalidez(), 0) );
            oReport.addlObj("C_SUMA_ASISTENCIA",  Dbl.DbltoStr(oCot.getcapitalAsistencia(), 0) );
            oReport.addlObj("C_FRANQUICIA",  Dbl.DbltoStr(oCot.getfranquicia(), 0) );
            oReport.addlObj("C_PRIMA",  Dbl.DbltoStr(oCot.getimpPrimaComisionable(), 0) );
            oReport.addlObj("C_PREMIO",  Dbl.DbltoStr(oCot.getpremio(), 0) );

            String sComision = (request.getParameter ("incluir_comision") == null ? "S" :
                                request.getParameter ("incluir_comision"));

            if (sComision.equals("S")) {
                oReport.addlObj("C_COMISION",  Dbl.DbltoStr(oCot.getgastosAdquisicion(), 0) );
                oReport.addCondicion("CON_COMISION", "true");
                oReport.addCondicion("SIN_COMISION", "false");
            } else {
                oReport.addCondicion("CON_COMISION", "false");
                oReport.addCondicion("SIN_COMISION", "true");
            }

            lfPagos  = ConsultaMaestros.getAllFormaPago (dbCon, oCot.getcodRama(), oCot.getcodSubRama(),
                    oCot.getcodProducto (), 0, oCot.getcodProd() );
           
            boolean bFirst = true;
            StringBuilder sb = new StringBuilder ();
            sb.append("Formas de pago habilitadas: ");
            for (int i=0; i < lfPagos.size(); i++) {
                FormaPago  of = (FormaPago) lfPagos.get(i);
                if ( bFirst ) {
                    sb.append (of.getDescripcion() );
                    bFirst = false;
                } else {
                    sb.append (" - ").append(of.getDescripcion() );
                }
            }

            oReport.addlObj("C_FORMA_PAGO",  sb.toString());
            
            lFinan = oCot.getDBListFinanciacion(dbCon);
            oReport.addIniTabla("TABLA_FINANCIACION");                
            String sStyle[] = {"ItemTextoVar8"};
            
System.out.println ("cantidad de cuotas: " + lFinan.size ());

            String sElem1 [] = { "Financiación:"  };
            oReport.addElementsTabla(sElem1, sStyle);  

            if (lFinan.size() > 0 ) {     
                for (int i=0; i< lFinan.size();i++) {
                    CotFinanciacion oFinan = (CotFinanciacion) lFinan.get(i);
                    StringBuilder sbHtml = new StringBuilder ();                
                    sbHtml.append("   - facturación ");
                    sbHtml.append( oFinan.getdescFacturacion());
                    sbHtml.append(" de $ ").append(oFinan.getpremio());
                    sbHtml.append(oFinan.getcantCuotas() == 1 ? " en " : " hasta en ");
                    sbHtml.append(oFinan.getcantCuotas()).append(" ");
                    sbHtml.append(oFinan.getcantCuotas() == 1 ? "cuota de $ " : "cuotas de $ ");
                    sbHtml.append(oFinan.getvalorCuota());
                    String sElem [] = { sbHtml.toString()  }; 
                    oReport.addElementsTabla(sElem, sStyle);   
                }
            } else  {
                LinkedList lFact    = ConsultaMaestros.getAllCondFacturacion (dbCon, oCot.getcodRama(), oCot.getcodSubRama(), oCot.getcodProducto(),
                            oCot.getcodVigencia(), -1, oCot.getcodProd(), oCot.getcantPersonas() );

                for (int ii = 0; ii < lFact.size(); ii++) {
                    Facturacion oFact = (Facturacion) lFact.get(ii);
                    StringBuilder sbHtml = new StringBuilder ();                
                    sbHtml.append("   - facturación ");
                    sbHtml.append(oFact.getdescFacturacion());
                    sbHtml.append(" ");
                    sbHtml.append(oFact.getcantCuotas() == 1 ? " en " : " hasta en ");
                    sbHtml.append(oFact.getcantCuotas()).append(" ");
                    String sElem [] = { sbHtml.toString()  }; 
                    oReport.addElementsTabla(sElem, sStyle);   
                }

            }
            oReport.addFinTabla();            
            
            if (request.getParameter("opcion").equals("getCotPDF")) {
                request.setAttribute("oReport", oReport );
                request.setAttribute("nombre", "cotizacion_AP_" + oCot.getnumCotizacion() + ".pdf");
                doForward (request,response, "/servlet/ReportPdfWeb");
            } else {

                String from     = "webmaster@beneficio.com.ar";
                String to       = (request.getParameter ("dest") == null || request.getParameter ("dest").equals("") ?
                                  user.getEmail()  : request.getParameter ("dest") ) ;
                String cc       = (request.getParameter ("cc") == null || request.getParameter ("cc").equals("") ?
                                  null : request.getParameter ("cc") ) ;
                String subject  = (request.getParameter ("title") == null ? "Beneficio S.A. - Cotización Nº " + oCot.getnumCotizacion() :
                                   request.getParameter ("title"));
                String sMensaje = request.getParameter ("message");
                
                String archivo  = getServletContext ().getRealPath("/files/cotizaciones/cotiz" + oCot.getnumCotizacion() + ".pdf");

                boolean debug   = false;

                Email mail = new Email();
                // ------------------------------
                // Configuracion Local mail Gmail
                mail.setEnableStarttls(false);
                mail.setSource      (from);
                mail.setSubject     (subject);
                mail.addContent     (sMensaje.toString());

                oReport.getFilePDF (archivo);

                mail.addAttach(archivo );

                mail.setDestination(to);
                if (cc != null ) {
                    mail.setCC(cc);
                }
                mail.sendMultipart(); //Message("text/html");

                request.setAttribute("mensaje", "El mail ha sido enviado con exito !!" );
                request.setAttribute("volver", Param.getAplicacion() + "servlet/CotizadorApServlet?opcion=getCotNew&num_cotizacion=" + oCot.getnumCotizacion() + "&siguiente=solapa2" );
                doForward (request, response, "/include/MsjHtmlServidor.jsp");
            }

        }  catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }


    protected void getPrintAcrobat (HttpServletRequest request, HttpServletResponse response, CotizadorAp oCot)
    throws ServletException, IOException, SurException {
    }

    protected void sendEmailCotizacion (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon        = null;
        StringBuilder sMensaje = new StringBuilder();
        String sMsgCuotas = "";
        try {
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            
            int numCotizacion = Integer.parseInt (request.getParameter ("numCotizacion"));
            
            dbCon = db.getConnection();
            CotizadorAp oCot = new CotizadorAp();
            oCot.setnumCotizacion (numCotizacion); 
            oCot.getDB(dbCon);

            if (oCot.getabm().equals("S")) {
                throw new SurException ("Operación invalida.La cotización es de Testeo, no puede ser enviada.");
            }
            
            oCot.setestadoCotizacion (1); 
            oCot.setusuarioCambiaEstado (oUser.getusuario());
            oCot.setDBCambiarEstadoCotizacion(dbCon);
            
            if (oCot.getiNumError() < 0) {
                throw new SurException ("Operación invalida.La cotización no se puede enviar. Consulte a su representante. Muchas Gracias ");
            }
            
            sMsgCuotas = "En "+ oCot.getcantCuotas()+" cuotas de $"+ Dbl.DbltoStr(oCot.getvalorCuota(),2);
            
            sMensaje.append(oCot.getdescEstadoCotizacion()).append(" DE COTIZACION DE ACCIDENTES PERSONALES\n");
            
            sMensaje.append("-----------------------------------\n\n");
            sMensaje.append("COTIZADO POR : ").append(oCot.getdescUsu()).append("\n");
            sMensaje.append("PRODUCTOR    : ").append(oCot.getdescProd()).append("(").append(oCot.getcodProd()).append(")\n");
            sMensaje.append("OPERACION NRO: ").append(String.valueOf(oCot.getnumCotizacion())).append("\n");
            sMensaje.append("FECHA        : ").append(oCot.getfechaCotizacion()).append("\n");
            sMensaje.append(" \n");
            sMensaje.append("Tomador           : ").append(oCot.gettomadorApe()).append("\n");
            sMensaje.append("Descripción Tareas: ").append(oCot.getdescActividad()).append("\n");
            sMensaje.append("Telefono          : ").append((oCot.gettomadorTel () == null ? " " : oCot.gettomadorTel ())).append("\n");
            sMensaje.append("Cond I.V.A        : ").append((oCot.gettomadorDescIva () == null ? " " : oCot.gettomadorDescIva ())).append("\n");
            sMensaje.append(" \n");
            sMensaje.append("Características del seguro\n");
            sMensaje.append("-------------------------- \n");
            sMensaje.append("Ubicación del riesgo: ").append(oCot.getdescProvincia()).append("\n");
            sMensaje.append("Modalidad           : ").append(oCot.getdescAmbito()).append("\n");
            sMensaje.append("Vigencia            : ").append(oCot.getdescVigencia()).append("\n");
            sMensaje.append("Cantidad de Vidas   : ").append(String.valueOf(oCot.getcantPersonas())).append("\n");
            sMensaje.append(" \n");
            sMensaje.append("Descripcion de Coberturas\n");
            sMensaje.append("-------------------------\n");
            sMensaje.append("Muerte por accidente                   $").append(Dbl.DbltoStrPadRight( oCot.getcapitalMuerte(),2, 15)).append("\n");
            sMensaje.append("Invalidez permanente total y/o parcial $").append(Dbl.DbltoStrPadRight( oCot.getcapitalInvalidez(),2, 15)).append("\n");
            sMensaje.append("Asistencia medica farmaceutica         $").append(Dbl.DbltoStrPadRight( oCot.getcapitalAsistencia(),2, 15)).append("\n");
            sMensaje.append("Franquicia                             $").append(Dbl.DbltoStrPadRight( oCot.getfranquicia(),2, 15)).append("\n");
            sMensaje.append(" \n");
            sMensaje.append("Presupuesto\n");
            sMensaje.append("-----------\n");
            sMensaje.append("Prima pura          $").append( Dbl.DbltoStrPadRight( oCot.getprimaPura(),2, 15)).append( "\n");
            sMensaje.append("Sub-Total           $").append( Dbl.DbltoStrPadRight( oCot.getsubTotal(),2, 15)).append( "\n");
            sMensaje.append("Subtotal            $").append( Dbl.DbltoStrPadRight( oCot.getprimaPura()+ oCot.getrecAdmin() ,2, 15)).append( "\n");
            sMensaje.append(" GDA " ).append( Dbl.DbltoStrPadRight( oCot.getgastosAdquisicion(),2, 6)).append("%        $").append( Dbl.DbltoStrPadRight( oCot.getgda(),2, 15)).append( "\n");
            sMensaje.append("Recargos finan. ").append( Dbl.DbltoStrPadRight( oCot.getporcRecFinan(),2, 6)).append("%  $").append( Dbl.DbltoStrPadRight( oCot.getrecFinan(),2, 15)).append( "\n");
            sMensaje.append(" Derecho de Emision $").append( Dbl.DbltoStrPadRight( oCot.getderEmi(),2, 15)).append( "\n");
            sMensaje.append("Prima Tarifa        $").append( Dbl.DbltoStrPadRight( oCot.getprimaTar(),2, 15)).append( "\n");
            sMensaje.append(" IVA ").append( Dbl.DbltoStrPadRight( oCot.getporcIva(),2, 6)).append("%        $").append( Dbl.DbltoStrPadRight( oCot.getiva(),2, 15)).append( "\n");
            sMensaje.append(" Tasa SSN ").append( Dbl.DbltoStrPadRight( oCot.getporcSsn(),2, 6)).append("%   $").append( Dbl.DbltoStrPadRight( oCot.getssn(),2, 15)).append( "\n");
            sMensaje.append(" Serv.Soc ").append( Dbl.DbltoStrPadRight( oCot.getporcSoc(),2, 6)).append("%   $").append( Dbl.DbltoStrPadRight( oCot.getsoc(),2, 15)).append( "\n");
            sMensaje.append(" Sellado  ").append( Dbl.DbltoStrPadRight( oCot.getporcSellado(),2, 6)).append("%   $").append( Dbl.DbltoStrPadRight( oCot.getsellado(),2, 15)).append( "\n");
            sMensaje.append("Premio              $").append( Dbl.DbltoStrPadRight( oCot.getpremio(),2, 15)).append( "\n");
            sMensaje.append(" \n");
            
            sMensaje.append(sMsgCuotas).append("\n");

            sMensaje.append("Este es un mensaje automático generado por BENEFICIO WEB.\n");
            sMensaje.append("Cualquier duda o consulta puede comunicarse por este medio a webmaster@beneficiosa.com.ar\n");

            Email oEmail = new Email ();

            oEmail.setSubject("Beneficio Web - AVISO de "+ oCot.getdescEstadoCotizacion() +" DE COTIZACION DE A.P. N° " + oCot.getnumCotizacion());
            oEmail.setContent(sMensaje.toString());

            LinkedList lDest = oEmail.getDBDestinos(dbCon, oUser.getoficina(), "COTIZADOR");

            for (int i=0; i < lDest.size();i++) {
                Persona oPers = (Persona) lDest.get(i);
                oEmail.setDestination(oPers.getEmail());
               // oEmail.sendMessage();
                oEmail.sendMessageBatch();
            }
             
            request.setAttribute("mensaje", oCot.getMensajeEstado());
            request.setAttribute("volver", Param.getAplicacion() + "servlet/CotizadorApServlet?opcion=getAllCotizaciones");             
            doForward (request, response, "/include/MsjHtmlServidor.jsp");                      
            
        } catch (Exception e) { 
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }
        
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
