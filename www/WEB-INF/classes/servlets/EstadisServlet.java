/*
 * ConsultaServlet.java
 *
 * Created on 12 de noviembre de 2005, 10:02
 */
  
package servlets;
  
import java.io.IOException;
// import java.io.UnsupportedEncodingException;
// import java.net.MalformedURLException;
import java.util.LinkedList;
import java.text.SimpleDateFormat;


import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;

import com.business.beans.*;
import com.business.util.*;
import com.business.db.*;
//import com.business.interfaces.*;
// import com.ibm.as400.access.*;

import javax.servlet.*;
import javax.servlet.http.*;

/**
 *
 * @author Rolando Elisii
 * @version
 */
public class EstadisServlet extends HttpServlet {
    
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
            
            if (op.equals ("getUsoSistema")) {
                getUsoSistema (request, response);
            } else if (op.equals ("getDetalle")) {
                getUsoSistemaDetalle (request, response);
            } else if (op.equals ("getOpMensuales")) {
               getOpMensuales (request, response);
           } else if (op.equals ("getRankingProp")) {
               getRankingPropuestas (request, response);
           } 
            
         } catch (SurException se) {
            goToJSPError(request,response, se);
        } catch (Exception e) {
            goToJSPError(request,response, e);
        }
    } 
    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */

    protected void getUsoSistema (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        
        Connection dbCon = null;
        CallableStatement cons  = null;
        ResultSet rs = null;
        LinkedList lHits = new LinkedList ();
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
           
            String sUsuario     = request.getParameter("usuario");
// setear el control de acceso
            dbCon = db.getConnection();
            dbCon.setAutoCommit(false);
            // Procedure call.  
            cons = dbCon.prepareCall(db.getSettingCall("EST_USO_SISTEMA (?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            if (request.getParameter("fecha_desde") == null || request.getParameter("fecha_desde").equals ("") ) {
                cons.setNull    (2, java.sql.Types.DATE);
            } else {
                cons.setDate     (2, Fecha.convertFecha(Fecha.strToDate(request.getParameter("fecha_desde"))));
            }
            if (request.getParameter("fecha_hasta") == null || request.getParameter("fecha_hasta").equals ("") ) {
                cons.setNull    (3, java.sql.Types.DATE);
            } else {
                cons.setDate     (3, Fecha.convertFecha(Fecha.strToDate(request.getParameter("fecha_hasta"))));
            }
            if (sUsuario.equals ("") ) {
                cons.setNull    (4, java.sql.Types.VARCHAR);
            } else {
                cons.setString  (4, sUsuario);
            }
            
            cons.execute();
            rs = (ResultSet) cons.getObject(1);

            if (rs != null) {
                while (rs.next()) {
                    Hits oHits = new Hits ();
                    oHits.setfechaAcceso    (rs.getDate ("FECHA_ACCESO"));
                    oHits.setusuario    (rs.getString ("USUARIO"));                    
                    oHits.setdescUsuario    (rs.getString ("DESC_USUARIO"));
                    oHits.settipoUsuario    (rs.getString ("TIPO_USUARIO"));                    
                    oHits.setoperacion      (rs.getString ("OPERACION"));                                        
                    oHits.setcantidad       (rs.getInt    ("CANTIDAD"));                                        
                    
                    lHits.add(oHits);
                }
                rs.close ();
            }
            
            request.setAttribute("hits", lHits);
            doForward(request, response, "/estadistica/formEstadis.jsp");
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

    
    protected void getRankingPropuestas (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        
        Connection dbCon = null;
        CallableStatement cons  = null;
        ResultSet rs = null;
        LinkedList lHits = new LinkedList ();
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
           
            String sUsuario     = request.getParameter("usuario");
// setear el control de acceso
            dbCon = db.getConnection();
            dbCon.setAutoCommit(false);
            // Procedure call.  
            cons = dbCon.prepareCall(db.getSettingCall("EST_RANKING_PROPUESTAS (?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            if (request.getParameter("fecha_desde") == null || request.getParameter("fecha_desde").equals ("") ) {
                cons.setNull    (2, java.sql.Types.DATE);
            } else {
                cons.setDate     (2, Fecha.convertFecha(Fecha.strToDate(request.getParameter("fecha_desde"))));
            }
            if (request.getParameter("fecha_hasta") == null || request.getParameter("fecha_hasta").equals ("") ) {
                cons.setNull    (3, java.sql.Types.DATE);
            } else {
                cons.setDate     (3, Fecha.convertFecha(Fecha.strToDate(request.getParameter("fecha_hasta"))));
            }
            if (sUsuario.equals ("") ) {
                cons.setNull    (4, java.sql.Types.INTEGER);
            } else {
                cons.setInt  (4, Integer.parseInt (sUsuario));
            }
            
            cons.execute();
            rs = (ResultSet) cons.getObject(1);

            if (rs != null) {
                while (rs.next()) {
                    Hits oHits = new Hits ();
                    oHits.setusuario        (rs.getString ("COD_PROD"));
                    oHits.setdescUsuario    (rs.getString ("PRODUCTOR"));
  //                  oHits.setcantidad       (rs.getInt    ("CANTIDAD"));
                    oHits.setcantCotiz  (rs.getInt ("COTIZADOR"));
                    oHits.setcantEndoso (rs.getInt ("ENDOSO"));
                    oHits.setcantPropAP (rs.getInt ("AP"));
                    oHits.setcantPropVC (rs.getInt ("VC"));
                    oHits.setcantPropVO (rs.getInt ("VO"));
                    oHits.setcantPropCaucion (rs.getInt ("CAUCION"));
                    oHits.setcantOtros   (rs.getInt ("OTRO"));

                    lHits.add(oHits);
                }
                rs.close ();
            }    
            
            request.setAttribute("hits", lHits);
            doForward(request, response, "/estadistica/formEstadis.jsp");
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
    
    protected void getOpMensuales (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        
        Connection dbCon = null;
        CallableStatement cons  = null;
        ResultSet rs = null;
        LinkedList lHits = new LinkedList ();
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
           
            String sUsuario     = request.getParameter("usuario");
// setear el control de acceso
            dbCon = db.getConnection();
            dbCon.setAutoCommit(false);
            // Procedure call.  
            cons = dbCon.prepareCall(db.getSettingCall("EST_OPERACIONES_MENSUALES (?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            if (request.getParameter("fecha_desde") == null || request.getParameter("fecha_desde").equals ("") ) {
                cons.setNull    (2, java.sql.Types.DATE);
            } else {
                cons.setDate     (2, Fecha.convertFecha(Fecha.strToDate(request.getParameter("fecha_desde"))));
            }
            if (request.getParameter("fecha_hasta") == null || request.getParameter("fecha_hasta").equals ("") ) {
                cons.setNull    (3, java.sql.Types.DATE);
            } else {
                cons.setDate     (3, Fecha.convertFecha(Fecha.strToDate(request.getParameter("fecha_hasta"))));
            }
            if (sUsuario.equals ("") ) {
                cons.setNull    (4, java.sql.Types.VARCHAR);
            } else {
                cons.setString  (4, sUsuario);
            }
            
            cons.execute();
            rs = (ResultSet) cons.getObject(1);

            if (rs != null) {
                while (rs.next()) {
                    Hits oHits = new Hits ();
                    oHits.setoperacion  (rs.getString ("OPERACION"));                                        
                    oHits.setmes        (rs.getString ("MES"));
                    oHits.setcantidad   (rs.getInt    ("CANTIDAD"));                                        
                    
                    lHits.add(oHits);
                }
                rs.close ();
            }
            
            request.setAttribute("hits", lHits);
            doForward(request, response, "/estadistica/formEstadis.jsp");
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
    
    protected void getUsoSistemaDetalle (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        
        Connection dbCon = null;
        CallableStatement cons  = null;
        ResultSet rs = null;
        LinkedList lHits = new LinkedList ();
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
           
            String sUsuario     = request.getParameter("usuario");

            dbCon = db.getConnection();
            dbCon.setAutoCommit(false);
            // Procedure call.  
            cons = dbCon.prepareCall(db.getSettingCall("EST_USO_SISTEMA_DETALLE (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            if (request.getParameter("fecha") == null || request.getParameter("fecha").equals ("") ) {
                cons.setNull    (2, java.sql.Types.DATE);
            } else {
                cons.setDate     (2, Fecha.convertFecha(Fecha.strToDate(request.getParameter("fecha"))));
            }
            if (sUsuario.equals ("") ) {
                cons.setNull    (3, java.sql.Types.VARCHAR);
            } else {
                cons.setString  (3, sUsuario);
            }
            
            cons.execute();
            rs = (ResultSet) cons.getObject(1);

            if (rs != null) {
                while (rs.next()) {
                    Hits oHits = new Hits ();
                    oHits.setfechaAcceso    (rs.getDate ("FECHA_ACCESO"));
                    oHits.sethoraAcceso     (rs.getString ("HORA_ACCESO"));
                    oHits.setusuario        (rs.getString ("USUARIO"));                    
                    oHits.setdescUsuario    (rs.getString ("DESC_USUARIO"));
                    oHits.settipoUsuario    (rs.getString ("TIPO_USUARIO"));                    
                    oHits.setoperacion      (rs.getString ("OPERACION"));                                        
                  
                    lHits.add(oHits);
                }
                rs.close ();
            }
            
            request.setAttribute("hits", lHits);
            doForward(request, response, "/estadistica/PopUpDetalle.jsp");
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


