/*
 * PlanServlet.java
 *
 * Created on 16 de julio de 2008, 23:25
 */

package servlets;

import java.io.IOException;
import java.util.LinkedList;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import com.business.beans.*;
import com.business.util.*;
import com.business.db.*;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 *
 * @author  Usuario
 * @version
 */
public class PlanServlet extends HttpServlet {
    
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
            
            
            if (op.equals("getAllPlan")) {
                getAllPlan (request, response);
            } else if (op.equals("getPlan")) {
                getPlan (request, response);
            } else if (op.equals("grabarPlan")) {
                grabarPlan (request, response);
            } else if (op.equals("cambiarMcaPublicacion")) {
                cambiarMcaPublicacion(request, response);
            }  else if (op.equals("getAllProductores")) {
                getAllProductores (request, response);                
            }  else if (op.equals("grabarPlanProd")) {
                grabarPlanProd(request, response);
            }  else if (op.equals("borrarPlanProd")) {
                borrarPlanProd(request, response);
            }  else if (op.equals("getAllSumas")) {
                getAllSumas(request, response);
            }  else if (op.equals("grabarSumas")) {   
                grabarSumas(request, response);
            }  else if (op.equals("generarExcel")) {
                generarListadoExcel(request, response);
            }  else if (op.equals("getAllPlanes")) {
                getAllPlanes (request, response);
            }
        } catch (SurException se) {
            goToJSPError(request,response, se);
        } catch (Exception e) {
            goToJSPError(request,response, e);
        } 
    } 
    
    
    protected void getAllPlan (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons = null;
        LinkedList lPlan = new LinkedList();
        try {
            dbCon = db.getConnection();
            dbCon.setAutoCommit(false);            
            
            cons = dbCon.prepareCall(db.getSettingCall("ABM_PL_GET_ALL_PLANES()"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            
            cons.execute();
            
            ResultSet rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    Plan oPlan = new Plan();
                    oPlan.setcodPlan     (rs.getInt("COD_PLAN"));
                    oPlan.setdescripcion (rs.getString("DESCRIPCION"));                    
                    oPlan.setcodRama     (rs.getInt("COD_RAMA"));
                    oPlan.setcodSubRama  (rs.getInt("COD_SUB_RAMA"));
                    oPlan.setdescRama    (rs.getString("RAMA"));
                    oPlan.setdescSubRama (rs.getString("SUB_RAMA"));
                    oPlan.setestado      (rs.getString("ESTADO"));                    
                    oPlan.setmcaPublica  (rs.getString("MCA_PUBLICA"));
                    oPlan.setminPremio   (rs.getDouble("MIN_PREMIO"));
                    oPlan.setcodProducto (rs.getInt("COD_PRODUCTO"));
                    oPlan.setcodAgrupCobertura(rs.getInt("COD_AGRUP_COB"));
                    lPlan.add(oPlan);
                }
                rs.close();
            }

            request.setAttribute("planes", lPlan);
            doForward (request, response, "/abm/planes/formConsultaPlanes.jsp");
            
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

    protected void getAllPlanes (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons = null;
        ResultSet rs = null;
        LinkedList lPlan = new LinkedList();
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            Diccionario oDicc   = (Diccionario) (request.getSession().getAttribute("Diccionario"));

            int iCodProd        = oDicc.getInt (request, "F1cod_prod");
            String sNombre      = oDicc.getString (request, "F1desc_plan");
            int iCodPlan        = oDicc.getInt (request, "F1cod_plan");
            int iCodRama        = oDicc.getInt (request, "F1cod_rama");
            int iCurrentPage    = oDicc.getInt (request, "pager.offset");

            dbCon = db.getConnection();
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("ABM_PL_GET_FILTRAR_PLANES (?,?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            if ( iCodProd  == 0 ) {
                cons.setNull    (2, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (2, iCodProd );
            }
            if (sNombre.equals ("") ) {
                cons.setNull    (3, java.sql.Types.VARCHAR);
            } else {
                cons.setString  (3, sNombre);
            }
            if ( iCodPlan  == 0 ) {
                cons.setNull    (4, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (4, iCodPlan );
            }
            if ( iCodRama == 0 ) {
                cons.setNull    (5, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (5, iCodRama);
            }
            cons.setString (6, oUser.getusuario());

            cons.execute();
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    Plan oPlan = new Plan();
                    oPlan.setcodPlan     (rs.getInt("COD_PLAN"));
                    oPlan.setdescripcion (rs.getString("DESCRIPCION"));
                    oPlan.setcodRama     (rs.getInt("COD_RAMA"));
                    oPlan.setcodSubRama  (rs.getInt("COD_SUB_RAMA"));
                    oPlan.setdescRama    (rs.getString("RAMA"));
                    oPlan.setdescSubRama (rs.getString("SUB_RAMA"));
                    oPlan.setestado      (rs.getString("ESTADO"));
                    oPlan.setmcaPublica  (rs.getString("MCA_PUBLICA"));
                    oPlan.setminPremio   (rs.getDouble("MIN_PREMIO"));
                    oPlan.setcodProducto (rs.getInt("COD_PRODUCTO"));
                    oPlan.setcodAgrupCobertura(rs.getInt("COD_AGRUP_COB"));
                    lPlan.add(oPlan);
                }
                rs.close();
            }

            request.setAttribute("planes", lPlan);
            doForward (request, response, "/abm/planes/filtrarPlanes.jsp?pager.offset=" + iCurrentPage);

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
    
    
    protected void getPlan (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons = null;
        ResultSet rs = null;
        LinkedList lVig = new LinkedList();
        Plan oPlan = new Plan();
        try {            
            
            dbCon = db.getConnection();                                  
            int    codPlan  = 0;    
            if ( request.getParameter ("cod_plan") != null && 
                     !request.getParameter ("cod_plan").equals("") ) {
                   codPlan  = Integer.parseInt( request.getParameter ("cod_plan") );
            }                                    

            oPlan.setcodPlan(codPlan);
            oPlan.getDB(dbCon);

            if (oPlan.getcodPlan() >= 0) {
                dbCon.setAutoCommit(false);

                cons = dbCon.prepareCall(db.getSettingCall("ABM_PL_GET_ALL_VIGENCIAS(?,?,?,?)"));
                cons.registerOutParameter(1, java.sql.Types.OTHER);
                cons.setInt (2,oPlan.getcodRama());
                cons.setInt (3, oPlan.getcodSubRama());
                cons.setInt (4, oPlan.getcodProducto());
                cons.setInt (5, oPlan.getcodPlan());
                
                cons.execute();

                rs = (ResultSet) cons.getObject(1);
                if (rs != null) {
                    while (rs.next()) {
                        PlanVigencia oPV = new PlanVigencia() ;
                        oPV.setcodPlan     (rs.getInt("COD_PLAN"));
                        oPV.setcodVigencia(rs.getInt ("COD_VIGENCIA"));
                        oPV.setdescripcion (rs.getString("DESCRIPCION"));
                        oPV.setimpPremio(rs.getDouble ("IMP_PREMIO"));
                        oPV.setimpPrima(rs.getDouble("IMP_PRIMA"));
                        oPV.setminPremio(rs.getDouble ("MIN_PREMIO"));
                        oPV.setcantMaxCuotas(rs.getInt ("CANT_MAX_CUOTAS"));
                        oPV.setcantMaxCuotasVig (rs.getInt ("CANT_CUOTAS_VIG"));
                        oPV.setcantMaxDias(rs.getInt ("CANT_MAX_DIAS"));
                        oPV.setiCodFacturacion(rs.getInt ("COD_FACTURACION"));
                        oPV.setincluyeSellados(rs.getString ("INCLUYE_SELLADO"));
                        lVig.add(oPV);
                    }
                    rs.close();
                }
                cons.close();
            }
            PlanCosto oCosto = new PlanCosto();
            oCosto.setcodPlan(oPlan.getcodPlan());
//            oCosto = oPlan.getDBCosto(oCosto, dbCon);
            
            request.setAttribute("plan", oPlan); 
            request.setAttribute("costo", oCosto);
            request.setAttribute ("vigencias", lVig);
            
            doForward (request, response, "/abm/planes/formPlan.jsp");
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());            
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException(se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }
    
    
    protected void grabarPlan (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        String sError = "";
        
        try {
            dbCon = db.getConnection();  
            
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));

            int    codPlan  = 0;    
            if ( request.getParameter ("cod_plan") != null && 
                 !request.getParameter ("cod_plan").equals("") ) {
                   codPlan  = Integer.parseInt( request.getParameter ("cod_plan") );
            }                                                
            
            String descPlan = "";
            if ( request.getParameter ("desc_plan") != null && 
                 !request.getParameter ("desc_plan").equals("") ) {
                   descPlan  =  request.getParameter ("desc_plan") ;
            }                                    
                    
            int codRama = 0;
            if ( request.getParameter ("cod_rama") != null && 
                 !request.getParameter ("cod_rama").equals("") ) {
                   codRama  = Integer.parseInt( request.getParameter ("cod_rama") );
            }                                                            

            int codProducto = 0;
            if ( request.getParameter ("cod_producto") != null &&
                 !request.getParameter ("cod_producto").equals("") ) {
                   codProducto  = Integer.parseInt( request.getParameter ("cod_producto") );
            }

            int codAgrupCob = 0;
            if ( request.getParameter ("cod_agrup_cob") != null &&
                 !request.getParameter ("cod_agrup_cob").equals("") ) {
                   codAgrupCob  = Integer.parseInt( request.getParameter ("cod_agrup_cob") );
            }

            int codSubRama = 0;
            if ( request.getParameter ("cod_sub_rama") != null && 
                 !request.getParameter ("cod_sub_rama").equals("") ) {
                   codSubRama  = Integer.parseInt( request.getParameter ("cod_sub_rama") );
            }                                                                        
            
            double comisionMax = 0;
            if ( request.getParameter ("com_max") != null && 
                 !request.getParameter ("com_max").equals("") ) {
                   comisionMax  = Double.parseDouble( request.getParameter ("com_max") );
            }                                    
            
            String condicion   = "";
            if ( request.getParameter ("condicion") != null && 
                 !request.getParameter ("condicion").equals("") ) {
                   condicion  =  request.getParameter ("condicion") ;
            }               
            
            String medidaSeg   = "";
            if ( request.getParameter ("medida_seg") != null && 
                 !request.getParameter ("medida_seg").equals("") ) {
                   medidaSeg  =  request.getParameter ("medida_seg") ;
            }                                                
            
            String estado   = "";
            if ( request.getParameter ("estado") != null && 
                 !request.getParameter ("estado").equals("") ) {
                   estado  =  request.getParameter ("estado") ;
            }                                                
            
            String mcaPublica   = "";
            if ( request.getParameter ("mca_publica") != null && 
                 !request.getParameter ("mca_publica").equals("") ) {
                   mcaPublica  =  request.getParameter ("mca_publica") ;
            } 
            
            int codAmbito = 0;
            if ( request.getParameter ("cod_ambito") != null && 
                 !request.getParameter ("cod_ambito").equals("") ) {
                   codAmbito  = Integer.parseInt( request.getParameter ("cod_ambito") );
            }  
            
            int codActividad = 0;
            if ( request.getParameter ("cod_actividad") != null && 
                 !request.getParameter ("cod_actividad").equals("") ) {
                   codActividad  = Integer.parseInt( request.getParameter ("cod_actividad") );
            }                          
            
            double franquicia    = 0;
            if ( request.getParameter ("franquicia") != null && 
                 !request.getParameter ("franquicia").equals("") ) {
                   franquicia  = Double.parseDouble( request.getParameter ("franquicia") );
            }         

            String incluyeSellados = "S";
            if ( request.getParameter ("incluye_sellados") != null && 
                 !request.getParameter ("incluye_sellados").equals("") ) {
                   incluyeSellados  =  request.getParameter ("incluye_sellados") ;
            } 
            
            Plan oPlan = new Plan();
            oPlan.setcodPlan      (codPlan) ;
            oPlan.setdescripcion  (descPlan) ; 
            oPlan.setcodRama      (codRama)     ; 
            oPlan.setcodSubRama   (codSubRama)  ; 
            oPlan.setcomisionMax  (comisionMax) ; 
            oPlan.setcondiciones  (condicion)   ; 
            oPlan.setmedidaSeg    (medidaSeg)   ;
            oPlan.setmcaPublica   (mcaPublica )  ;          
            oPlan.setuserId       (oUser.getusuario() ); 
            oPlan.setestado       (estado) ;      
            oPlan.setcodAmbito    (codAmbito);
            oPlan.setcodActividad (codActividad);
            oPlan.setfranquicia   (franquicia);
            oPlan.setcodProducto   (codProducto);
            oPlan.setcodAgrupCobertura(codAgrupCob);
            oPlan = oPlan.setDB(dbCon);

            if (oPlan.getiNumError() == -1) {
                throw new SurException(oPlan.getsMensError());
            } else {
               /// GRABAR VIGENCIAS
                for (int i=1; i <= 9; i++) {
                    PlanVigencia oPV = new PlanVigencia ();
                    oPV.setcodPlan(oPlan.getcodPlan());
                    oPV.setcodVigencia(i);

                    if (request.getParameter ("vigencia_" + i )  == null ||
                        request.getParameter ("vigencia_" + i ).equals ("false") ) {
                        oPV.setDBDelete(dbCon, oUser.getusuario());

                    } else {

                        oPV.setiCodFacturacion(Integer.parseInt (request.getParameter ("cod_facturacion_" + i )));
                        oPV.setcantMaxCuotas(Integer.parseInt (request.getParameter ("max_cuotas_" + i )));
                        oPV.setimpPremio( Dbl.StrtoDbl(request.getParameter ("premio_" + i)));
                        oPV.setimpPrima ( Dbl.StrtoDbl(request.getParameter ("prima_" + i)));
                        oPV.setminPremio( Dbl.StrtoDbl(request.getParameter ("premio_min_" + i)));
                        if (i == 7) {
                            oPV.setcantMaxDias(Integer.parseInt (request.getParameter ("cant_dias")));
                        }
                        oPV.setincluyeSellados(incluyeSellados);
                        oPV.setDBAdd(dbCon,oUser.getusuario());
                    }

                    if (oPV.getiNumError() < 0) {
                        sError = oPV.getsMensError();
                        break;
                    }
                }

                if (sError.equals("")) {
                    String accion = request.getParameter ("accion");
                    if (accion.equals("salir")) {
                        response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
                        response.setHeader("Location","/benef/servlet/PlanServlet?opcion=getAllPlanes");
                    } else if (accion.equals("grabar")) {
                        response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
                        response.setHeader("Location",
                                           "/benef/servlet/PlanServlet?opcion=getPlan&cod_plan="+oPlan.getcodPlan()+"&abm="+request.getParameter ("abm") );
                    } else if (accion.equals("continuar")) {
                        response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
                        response.setHeader("Location",
                                           "/benef/servlet/PlanServlet?opcion=getAllProductores&cod_plan="+oPlan.getcodPlan()+"&abm="+request.getParameter ("abm") );
                    }
                } else {
                    throw new SurException (sError);
                }
            } 
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());            
        } finally {
            db.cerrar(dbCon);
        }            
        
    }    
    
    
    protected void cambiarMcaPublicacion (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        
        try {
            dbCon = db.getConnection();  
            
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));

            int    codPlan  = 0;    
            if ( request.getParameter ("cod_plan") != null && 
                 !request.getParameter ("cod_plan").equals("") ) {
                   codPlan  = Integer.parseInt( request.getParameter ("cod_plan") );
            }                                                            
            
            
            String newMcaPublica   = "";
            if ( request.getParameter ("new_mca_publica") != null && 
                 !request.getParameter ("new_mca_publica").equals("") ) {
                   newMcaPublica  =  request.getParameter ("new_mca_publica") ;
            }                                                
            
            Plan oPlan = new Plan();
            oPlan.setcodPlan      (codPlan) ;
            oPlan.setmcaPublica   (newMcaPublica);
            oPlan.setuserId       (oUser.getusuario() ); 
            oPlan = oPlan.setDBcambiarMcaPublica(dbCon);            
            
            response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);            
            response.setHeader("Location","/benef/servlet/PlanServlet?opcion=getAllPlanes");
            
            
        } catch (Exception e) {
            //System.out.println("error " + e.getMessage() );
            throw new SurException (e.getMessage());            
        } finally {
            db.cerrar(dbCon);
        }            
        
    }        
    
    
    // -----
    // NUEVO
    // -----
    protected void getAllProductores (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection       dbCon = null;
        CallableStatement cons = null;
        LinkedList lProductor  = new LinkedList();

        try {
            dbCon = db.getConnection();
            dbCon.setAutoCommit(false);
            int    codPlan  = 0;
            if ( request.getParameter ("cod_plan") != null &&
                 !request.getParameter("cod_plan").equals("") ) {
                   codPlan  = Integer.parseInt( request.getParameter ("cod_plan") );
            }
            
            // System.out.println("getAllProductores accion " + request.getParameter ("accion"));
            // System.out.println("getAllProductores abm    " + request.getParameter ("abm"));            

            cons = dbCon.prepareCall (db.getSettingCall("ABM_PL_GET_ALL_PRODUCTORES(?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt              (2, codPlan );

            cons.execute();

            ResultSet rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    PlanProductor oProd = new PlanProductor();
                    oProd.setcodPlan    (rs.getInt   ("COD_PLAN"));
                    oProd.setcodProd    (rs.getInt   ("COD_PROD"));
                    oProd.setdescProd   (rs.getString("DESC_PROD"));
                    oProd.setcomisionMax(rs.getDouble("COMISION_MAX"));
                    lProductor.add(oProd);
                }
                rs.close();
            }
            request.setAttribute("productores", lProductor);
            doForward (request, response, "/abm/planes/formPlanProductor.jsp");

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
    
    //01-08-2007   
    protected void grabarPlanProd (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        
        try {
            dbCon = db.getConnection();  
            
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));

            int    codPlan  = 0;    
            if ( request.getParameter ("cod_plan") != null && 
                 !request.getParameter ("cod_plan").equals("") ) {
                   codPlan  = Integer.parseInt( request.getParameter ("cod_plan") );
            }                                                            
            
            int    codProd  = 0;    
            if ( request.getParameter ("cod_prod") != null && 
                 !request.getParameter ("cod_prod").equals("") ) {
                   codProd  = Integer.parseInt( request.getParameter ("cod_prod") );
            }                                                                        
            
            double comisionMax = 0;
            if ( request.getParameter ("com_max") != null && 
                 !request.getParameter ("com_max").equals("") ) {
                   comisionMax  = Double.parseDouble( request.getParameter ("com_max") );
            }                                    

            
            PlanProductor oProd = new PlanProductor();
            oProd.setcodPlan(codPlan) ;
            oProd.setcodProd(codProd);
            oProd.setuserId(oUser.getusuario() ); 
            oProd.setcomisionMax(comisionMax);
            Plan oPlan = new Plan();
            oPlan.setcodPlan(codPlan) ;            
            oPlan.setDBPlanProd(oProd,dbCon);           
            response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);            
            response.setHeader("Location","/benef/servlet/PlanServlet?opcion=getAllProductores&cod_plan="+oProd.getcodPlan()+"&abm="+request.getParameter ("abm") );                  
                        
        } catch (Exception e) {
            //System.out.println("error " + e.getMessage() );
            throw new SurException (e.getMessage());            
        } finally {
            db.cerrar(dbCon);
        }            
        
    }        
    // Borrar plan productor
    //01-08-2007   
    protected void borrarPlanProd (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        
        try {
            dbCon = db.getConnection();  
            
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));

            int    codPlan  = 0;    
            if ( request.getParameter ("cod_plan") != null && 
                 !request.getParameter ("cod_plan").equals("") ) {
                   codPlan  = Integer.parseInt( request.getParameter ("cod_plan") );
            }                                                            
            
            int    codProd  = 0;    
            if ( request.getParameter ("cod_prod") != null && 
                 !request.getParameter ("cod_prod").equals("") ) {
                   codProd  = Integer.parseInt( request.getParameter ("cod_prod") );
            }                                                                        
            
            PlanProductor oProd = new PlanProductor();
            oProd.setcodPlan(codPlan) ;
            oProd.setcodProd(codProd);
            
            Plan oPlan = new Plan();
            oPlan.setcodPlan(codPlan) ;            
            oPlan.delDBPlanProd(oProd,dbCon);                       
            
            response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);            
            response.setHeader("Location","/benef/servlet/PlanServlet?opcion=getAllProductores&cod_plan="+oProd.getcodPlan()+"&abm="+request.getParameter ("abm") );                  
                        
        } catch (Exception e) {
            //System.out.println("error " + e.getMessage() );
            throw new SurException (e.getMessage());            
        } finally {
            db.cerrar(dbCon);
        }            
        
    }    
    //02-08-08
    protected void getAllSumas (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection       dbCon = null;
        CallableStatement cons = null;
        LinkedList lSumas  = new LinkedList();

        try {
            dbCon = db.getConnection();
            dbCon.setAutoCommit(false);
            int    codPlan  = 0;
            if ( request.getParameter ("cod_plan") != null &&
                 !request.getParameter("cod_plan").equals("") ) {
                   codPlan  = Integer.parseInt( request.getParameter ("cod_plan") );
            }

            cons = dbCon.prepareCall (db.getSettingCall("ABM_PL_GET_ALL_SUMAS(?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt              (2, codPlan );

            cons.execute();

            ResultSet rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    PlanSuma oSuma = new PlanSuma();
                    oSuma.setcodPlan    (rs.getInt   ("COD_PLAN"));
                    oSuma.setcodRama     (rs.getInt("COD_RAMA"));
                    oSuma.setcodSubRama(rs.getInt("COD_SUB_RAMA"));
                    oSuma.setcodCob(rs.getInt("COD_COB" ));
                    oSuma.setdescRama(rs.getString("DESC_RAMA"));
                    oSuma.setdescSubRama(rs.getString("DESC_SUB_RAMA"));
                    oSuma.setdescCob(rs.getString("DESC_COB"));
                    oSuma.setminSumAseg(rs.getDouble("MIN_SUMA_ASEGURADA" ));
                    oSuma.setmaxSumAseg(rs.getDouble("MAX_SUMA_ASEGURADA"));                    
                    oSuma.setMcaCobIncluida(rs.getString("MCA_COB_INCLUIDA"));
                    lSumas.add(oSuma);
                }
                rs.close();
            }
            request.setAttribute("sumas", lSumas);
            doForward (request, response, "/abm/planes/formPlanSuma.jsp");

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
    

    //01-08-2007   
    protected void grabarSumas (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        
        try {
            dbCon = db.getConnection();  
            
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));

            int    codPlan  = 0;    
            if ( request.getParameter ("cod_plan") != null && 
                 !request.getParameter ("cod_plan").equals("") ) {
                   codPlan  = Integer.parseInt( request.getParameter ("cod_plan") );
            } 
            
            int    cantCob  = 0;    
            if ( request.getParameter ("cant_cob") != null && 
                 !request.getParameter ("cant_cob").equals("") ) {
                   cantCob  = Integer.parseInt( request.getParameter ("cant_cob") );
            }             
            
            for (int i=0; i<cantCob;i++) {
                //System.out.println(" POS " + i + "");
            
                int codCob = 0;                     
                if ( request.getParameter ("cod_cob_" + i) != null && 
                    !request.getParameter ("cod_cob_" + i).equals("") ) {
                   codCob  = Integer.parseInt( request.getParameter ("cod_cob_" + i) );
                }                 
                
                double sumaMin = 0;                     
                if ( request.getParameter ("min_suma_" + i) != null && 
                    !request.getParameter ("min_suma_" + i).equals("") ) {
                   sumaMin  = Double.parseDouble( request.getParameter ("min_suma_" + i) );
                } 
            
                double sumaMax = 0;                     
                if ( request.getParameter ("max_suma_" + i) != null && 
                    !request.getParameter ("max_suma_" + i).equals("") ) {
                   sumaMax  = Double.parseDouble( request.getParameter ("max_suma_" + i) );
                }                 
                
                
                String mcaCobInc   = "";
                if ( request.getParameter ("mca_cob_inc_"+i) != null && 
                    !request.getParameter ("mca_cob_inc_"+i).equals("") ) {
                    mcaCobInc  =  request.getParameter ("mca_cob_inc_"+i) ;
                }                                                
                
                PlanProductor oProd = new PlanProductor();
                PlanSuma oPlanSuma = new PlanSuma();
                oPlanSuma.setcodPlan(codPlan) ;
                oPlanSuma.setcodCob (codCob);
                oPlanSuma.setminSumAseg(sumaMin);
                oPlanSuma.setmaxSumAseg(sumaMax);
                oPlanSuma.setMcaCobIncluida(mcaCobInc);
                oPlanSuma.setuserId(oUser.getusuario() ); 
            
                Plan oPlan = new Plan();
                oPlan.setcodPlan(codPlan) ;            
                oPlan.setDBPlanSuma(oPlanSuma,dbCon);       
                
            }            
            response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);            
            response.setHeader("Location","/benef/servlet/PlanServlet?opcion=getAllSumas&cod_plan="+codPlan+"&abm="+request.getParameter ("abm") );                  
                        
        } catch (Exception e) {
            //System.out.println("error " + e.getMessage() );
            throw new SurException (e.getMessage());            
        } finally {
            db.cerrar(dbCon);
        }            
        
    }            
    protected void generarListadoExcel (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection        dbCon = null;
        xls               oXls  = new xls ();
        CallableStatement cons  = null;
        LinkedList        lCert = new LinkedList();
        LinkedList        lRow  = null;
        try {
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));

            dbCon = db.getConnection();
            dbCon.setAutoCommit(false);

            cons = dbCon.prepareCall(db.getSettingCall("ABM_PL_GET_ALL_PLANES_EXCEL ()"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);

            cons.execute();

            ResultSet rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                oXls.setTitulo("Planes Especiales ");


                lRow   = new LinkedList();
                lRow.add(" ");
                oXls.setRows(lRow);


                lRow    = new LinkedList();

                lRow.add("COD_PLAN");
                lRow.add("DESCRIPCION");
                lRow.add("COD_PROD");
                lRow.add("DESC_PROD");
                lRow.add("DESC_VIGENCIA");
                lRow.add("PROPUESTAS");
                lRow.add("ULT.PROPUESTA");
                lRow.add("RAMA");
                lRow.add("SUB_RAMA");
                lRow.add("PRODUCTO");
                lRow.add("COMISION_MAX");
                lRow.add("IMP_PREMIO");
                lRow.add("IMP_PRIMA");
                lRow.add("FRANQUICIA");
                lRow.add("MIN_PREMIO");
                lRow.add("CANT_MAX_CUOTAS");
                lRow.add("CANT_MAX_DIAS");
                lRow.add("COD_FACTURACION");
                lRow.add("ESTADO");
                lRow.add("USERID");
                lRow.add("FECHA_TRABAJO");
                lRow.add("MCA_PUBLICA");
                lRow.add("ACTIVIDAD");
                lRow.add("DESC_AMBITO");
                lRow.add("COD_PRODUCTO");
                lRow.add("COD_AGRUP_COB");
                lRow.add("CONDICIONES");
                lRow.add("MEDIDA_SEG");

                oXls.setRows(lRow);
                while (rs.next()) {
                    lRow   = new LinkedList();
                    lRow.add(rs.getInt ("COD_PLAN"));
                    lRow.add(rs.getString ("DESCRIPCION"));
                    lRow.add(rs.getInt ("COD_PROD"));
                    lRow.add(rs.getString ("DESC_PROD"));
                    lRow.add(rs.getString ("DESC_VIGENCIA"));
                    lRow.add(rs.getInt ("PROPUESTAS"));
                    lRow.add((rs.getDate ("ULT_PROPUESTA") == null ? "" : Fecha.showFechaForm(rs.getDate("ULT_PROPUESTA"))) );
                    lRow.add(rs.getString ("RAMA"));
                    lRow.add(rs.getString ("SUB_RAMA"));
                    lRow.add(rs.getString ("PRODUCTO"));
                    lRow.add(rs.getDouble("COMISION_MAX"));
                    lRow.add(rs.getDouble("IMP_PREMIO"));
                    lRow.add(rs.getDouble("IMP_PRIMA"));
                    lRow.add(rs.getDouble("FRANQUICIA"));
                    lRow.add(rs.getDouble("MIN_PREMIO"));
                    lRow.add(rs.getInt ("CANT_MAX_CUOTAS"));
                    lRow.add(rs.getInt ("CANT_MAX_DIAS"));
                    lRow.add(rs.getInt ("COD_FACTURACION"));
                    lRow.add(rs.getString ("ESTADO"));
                    lRow.add(rs.getString ("USERID"));
                    lRow.add((rs.getDate ("FECHA_TRABAJO") == null ? "" : Fecha.showFechaForm(rs.getDate("FECHA_TRABAJO"))) );
                    lRow.add(rs.getString ("MCA_PUBLICA"));
                    lRow.add(rs.getString ("ACTIVIDAD"));
                    lRow.add(rs.getString ("DESC_AMBITO"));
                    lRow.add(rs.getInt ("COD_PRODUCTO"));
                    lRow.add(rs.getInt ("COD_AGRUP_COB"));
                    lRow.add(rs.getString ("CONDICIONES"));
                    lRow.add(rs.getString ("MEDIDA_SEG"));

                    oXls.setRows(lRow);
                }
            }

            request.setAttribute("oReportXls", oXls);
            doForward( request, response, "/servlet/ReportXls");
        } catch (Exception se) {
            throw new SurException (se.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    } /* END -- exportarCarteraVigente */
    
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

    } // goToJSPError
    
}
