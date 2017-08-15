/*
 * OpcionServlet.java
 *
 * Created on 16 de julio de 2008, 23:25
 */

package servlets;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.util.LinkedList;
import java.text.SimpleDateFormat;   
    
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.util.Date; 

import com.business.beans.OpcionAjuste;
import com.business.beans.Usuario;
import com.business.beans.OpcionAjusteDet;
import com.business.util.*;
import com.business.db.*;
import com.business.interfaces.*;

import javax.servlet.*;
import javax.servlet.http.*;

/**
 *
 * @author  Usuario
 * @version
 */
public class OpcionesServlet extends HttpServlet {
    
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
            
            
            if (op.equals("getAllOpcion")) {
                getAllOpcion (request, response);
            }  else if (op.equals("getOpcion")) {
                getOpcion (request, response);
            } else if (op.equals("grabarOpcion")) {
                grabarOpcion (request, response);
            }  else if (op.equals("getAllProductores")) {
                getAllProductores (request, response);                
            } else if (op.equals ("grabarOpcionProd")) {
                grabarOpcionProd (request, response, "A");
            }  else if (op.equals("borrarOpcionProd")) {
                grabarOpcionProd (request, response, "B");
            } else if (op.equals("cambiarMcaPublicacion")) {
                cambiarMcaPublicacion(request, response);
            } 
             
        } catch (SurException se) {
            goToJSPError(request,response, se);
        } catch (Exception e) {
            goToJSPError(request,response, e);
        } 
    } 
    
    
    protected void getAllOpcion (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon        = null;
        CallableStatement cons  = null;
        LinkedList lOpcion      = new LinkedList();
        ResultSet rs            = null;
        try {
            dbCon = db.getConnection();
            dbCon.setAutoCommit(false);            
            
            cons = dbCon.prepareCall(db.getSettingCall("ABM_GET_ALL_OPCION_AJUSTE (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString (2, ((Usuario) (request.getSession().getAttribute("user"))).getusuario());
            
            cons.execute();
            
            rs =  (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    OpcionAjuste oOpcion = new OpcionAjuste();
                    oOpcion.setcodOpcion    (rs.getInt("COD_OPCION"));
                    oOpcion.setdescripcion  (rs.getString("DESCRIPCION"));                    
                    oOpcion.setcodRama      (rs.getInt("COD_RAMA"));
                    oOpcion.setdescRama     (rs.getString("DESC_RAMA"));
                    oOpcion.setcodSubRama   (rs.getInt("COD_SUB_RAMA"));
                    oOpcion.setdescSubRama  (rs.getString("DESC_SUB_RAMA"));
                    oOpcion.setporcAjuste   (rs.getDouble("PORC_AJUSTE"));                    
                    oOpcion.setmcaPublica   (rs.getString("MCA_PUBLICA"));
                    oOpcion.setcodRebaja    (rs.getInt("COD_REBAJA"));
                    oOpcion.setcodRecargo   (rs.getInt("COD_RECARGO"));
                    lOpcion.add(oOpcion);
                }
                rs.close();
            }
            cons.close();

            request.setAttribute("opciones", lOpcion);
            doForward (request, response, "/abm/opciones/formConsultaOpciones.jsp");
            
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

    
    protected void getOpcion (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;

        try {            
            
            dbCon = db.getConnection();                                  
            int    codOpcion  = 0;    
            if ( request.getParameter ("cod_opcion") != null && 
                     !request.getParameter ("cod_opcion").equals("") ) {
                   codOpcion  = Integer.parseInt( request.getParameter ("cod_opcion") );
            }                                    
            OpcionAjuste oOpcion = new OpcionAjuste();
            oOpcion.setcodOpcion(codOpcion);
            oOpcion.getDB(dbCon);
                        
            request.setAttribute("opcion", oOpcion); 
            
            doForward (request, response, "/abm/opciones/formOpciones.jsp");
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());            
        } finally {
            db.cerrar(dbCon);
        }
    }
    
  
    protected void grabarOpcion (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        
        try {
            dbCon = db.getConnection();  
            
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));

            int    codOpcion  = 0;    
            if ( request.getParameter ("cod_opcion") != null && 
                 !request.getParameter ("cod_opcion").equals("") ) {
                   codOpcion  = Integer.parseInt( request.getParameter ("cod_opcion") );
            }                                                
            
            String descOpcion = "";
            if ( request.getParameter ("desc_opcion") != null && 
                 !request.getParameter ("desc_opcion").equals("") ) {
                   descOpcion  =  request.getParameter ("desc_opcion") ;
            }                                    
                    
            int codRama = 0;
            if ( request.getParameter ("cod_rama") != null && 
                 !request.getParameter ("cod_rama").equals("") ) {
                   codRama  = Integer.parseInt( request.getParameter ("cod_rama") );
            }                                                            
            
            int codSubRama = 0;
            if ( request.getParameter ("cod_sub_rama") != null && 
                 !request.getParameter ("cod_sub_rama").equals("") ) {
                   codSubRama  = Integer.parseInt( request.getParameter ("cod_sub_rama") );
            }                                                                        
            
            double porcAjuste = 0;
            if ( request.getParameter ("porc_ajuste") != null && 
                 !request.getParameter ("porc_ajuste").equals("") ) {
                   porcAjuste  = Double.parseDouble( request.getParameter ("porc_ajuste") );
            } 
            
            int codAmbito = 0;
            if ( request.getParameter ("cod_ambito") != null && 
                 !request.getParameter ("cod_ambito").equals("") ) {
                   codAmbito  = Integer.parseInt( request.getParameter ("cod_ambito") );
            }                                                            
            
            String mcaPublica   = "";
            if ( request.getParameter ("mca_publica") != null && 
                 !request.getParameter ("mca_publica").equals("") ) {
                   mcaPublica  =  request.getParameter ("mca_publica") ;
            } 

            int codRebaja = 0;
            if ( request.getParameter ("cod_rebaja") != null &&
                 !request.getParameter ("cod_rebaja").equals("") ) {
                   codRebaja  = Integer.parseInt( request.getParameter ("cod_rebaja") );
            }
            int codRecargo = 0;
            if ( request.getParameter ("cod_recargo") != null &&
                 !request.getParameter ("cod_recargo").equals("") ) {
                   codRecargo  = Integer.parseInt( request.getParameter ("cod_recargo") );
            }
                       
            OpcionAjuste oOpcion = new OpcionAjuste();
            oOpcion.setcodOpcion    (codOpcion) ;
            oOpcion.setdescripcion  (descOpcion) ; 
            oOpcion.setcodRama      (codRama)     ; 
            oOpcion.setcodSubRama   (codSubRama)  ; 
            oOpcion.setporcAjuste   (porcAjuste)   ; 
            oOpcion.setmcaPublica   (mcaPublica )  ;          
            oOpcion.setuserid       (oUser.getusuario() ); 
            oOpcion.setcodAmbito    (codAmbito);
            oOpcion.setcodRebaja    (codRebaja);
            oOpcion.setcodRecargo   (codRecargo);

            oOpcion.setDB(dbCon);            
            
            if (oOpcion.getiNumError() != 0) {
                throw new SurException (oOpcion.getsMensError());
            }   
                
            String accion = request.getParameter ("accion");
            if (accion.equals("salir")) {
                response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);            
                response.setHeader("Location","/benef/servlet/OpcionesServlet?opcion=getAllOpcion");   
            } else if (accion.equals("grabar")) {
                response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);            
                response.setHeader("Location",
                                   "/benef/servlet/OpcionesServlet?opcion=getOpcion&cod_opcion="+oOpcion.getcodOpcion()+"&abm="+request.getParameter ("abm") );                   
            } else if (accion.equals("continuar")) {
                response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);            
                response.setHeader("Location",
                                   "/benef/servlet/OpcionesServlet?opcion=getAllProductores&cod_opcion="+oOpcion.getcodOpcion()+"&abm="+request.getParameter ("abm") );                  
            }             

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
        ResultSet       rs  = null;
        CallableStatement cons = null;
        LinkedList lProductor  = new LinkedList();

        try {
            dbCon = db.getConnection();
            dbCon.setAutoCommit(false);
            int    codOpcion  = 0;
            if ( request.getParameter ("cod_opcion") != null &&
                 !request.getParameter("cod_opcion").equals("") ) {
                   codOpcion  = Integer.parseInt( request.getParameter ("cod_opcion") );
            }
            
            cons = dbCon.prepareCall (db.getSettingCall ( "ABM_GET_ALL_OPCION_AJUSTE_DET ( ? )"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt              (2, codOpcion );

            cons.execute();

            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    OpcionAjusteDet oProd = new OpcionAjusteDet();
                    oProd.setcodOpcion    (rs.getInt   ("COD_OPCION"));
                    oProd.setcodProd      (rs.getInt   ("COD_PROD"));
                    oProd.setdescProd     (rs.getString("DESCRIPCION"));
                    oProd.setporcAjuste   (rs.getDouble("PORC_AJUSTE"));

                    lProductor.add(oProd);
                }
                rs.close();
            }
            cons.close();
            request.setAttribute("productores", lProductor);
            doForward (request, response, "/abm/opciones/formOpcionesProd.jsp");

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
    
    //01-08-2007   
    protected void grabarOpcionProd (HttpServletRequest request, HttpServletResponse response, String operacion)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        
        try {
            dbCon = db.getConnection();  
            
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));

            int    codOpcion  = 0;    
            if ( request.getParameter ("cod_opcion") != null && 
                 !request.getParameter ("cod_opcion").equals("") ) {
                   codOpcion  = Integer.parseInt( request.getParameter ("cod_opcion") );
            }                                                            
            
            int    codProd  = 0;    
            if ( request.getParameter ("cod_prod") != null && 
                 !request.getParameter ("cod_prod").equals("") ) {
                   codProd  = Integer.parseInt( request.getParameter ("cod_prod") );
            }                                                                        
            
            double porcAjuste = 0;
            
            if (operacion.equals ("A")) {
                if ( request.getParameter ("porc_ajuste") != null && 
                     !request.getParameter ("porc_ajuste").equals("") ) {
                       porcAjuste  = Double.parseDouble( request.getParameter ("porc_ajuste") );
                }                                    
            }
            
            OpcionAjusteDet oProd = new OpcionAjusteDet();
            oProd.setcodOpcion  (codOpcion) ;
            oProd.setcodProd    (codProd);
            oProd.setuserid     (oUser.getusuario() ); 
            oProd.setporcAjuste (porcAjuste);
            oProd.setoperacion  (operacion);
            oProd.setDB(dbCon);
            
            if (oProd.getiNumError() != 0) {
                throw new SurException(oProd.getsMensError());
            }
             
            response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);            
            response.setHeader("Location","/benef/servlet/OpcionesServlet?opcion=getAllProductores&cod_opcion="+oProd.getcodOpcion()+"&abm="+request.getParameter ("abm") );                  
                        
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

            int    codOpcion  = 0;    
            if ( request.getParameter ("cod_opcion") != null && 
                 !request.getParameter ("cod_opcion").equals("") ) {
                   codOpcion  = Integer.parseInt( request.getParameter ("cod_opcion") );
            }                                                            
            
            String newMcaPublica   = "";
            if ( request.getParameter ("new_mca_publica") != null && 
                 !request.getParameter ("new_mca_publica").equals("") ) {
                   newMcaPublica  =  request.getParameter ("new_mca_publica") ;
            }      
            
            OpcionAjuste oOpcion = new OpcionAjuste();
            oOpcion.setcodOpcion      (codOpcion) ;
            
            oOpcion.getDB(dbCon);
            
            oOpcion.setmcaPublica   (newMcaPublica);
            oOpcion.setuserid       (oUser.getusuario() );
            
            oOpcion.setDB(dbCon);
            
            response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);            
            response.setHeader("Location","/benef/servlet/OpcionesServlet?opcion=getAllOpcion");               
            
        } catch (Exception e) {
            //System.out.println("error " + e.getMessage() );
            throw new SurException (e.getMessage());            
        } finally {
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
