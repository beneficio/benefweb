/*
 * TasaProvincialServlet.java
 *
 * Created on 29 de enero de 2005, 13:46
 */

package servlets;
 
import java.io.IOException;
import java.util.LinkedList;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.util.Date; 
import com.business.beans.*;
import com.business.util.*;
import com.business.db.*;

import javax.servlet.*;
import javax.servlet.http.*;

/**
 *
 * @author Rolando Elisii
 * @version
 */
public class TasaProvincialServlet extends HttpServlet {
    
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
            
            if (op.equals("addTasaProvincial")) {
                addTasaProvincial (request, response);//grabo
                getAllTasaProvincial (request, response);//vuelvo al abm

            } else if (op.equals("addProd")) {
                addTasaProvincial (request, response);//grabo
                addProduccion (request, response);//paso a produccion
                getAllTasaProvincial (request, response);//vuelvo al abm
           
            } else if (op.equals("getAllTasaProvincial")) {
                getAllTasaProvincial (request, response);
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
    protected void addTasaProvincial (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {
            dbCon = db.getConnection();            
            int nTasas = (Integer.parseInt (request.getParameter("cant_tasas")));
            TasaProvincial oTasa = new TasaProvincial ();
            oTasa.setiNumError(0);
            for (int i=0;i<nTasas && oTasa.getiNumError()==0 ;i++){
                oTasa.setcodProvincia  (Integer.parseInt (request.getParameter("PROVINCIA"+String.valueOf(i)) ));
                oTasa.setcodRama       (Integer.parseInt (request.getParameter("RAMA"+String.valueOf(i)) ));
                oTasa.setcodSubRama    (Integer.parseInt (request.getParameter("SUB_RAMA"+String.valueOf(i)) ));
                oTasa.setcodProducto   (Integer.parseInt (request.getParameter("PRODUCTO"+String.valueOf(i)) ));
                oTasa.setbaseCalculo   (request.getParameter ("BASE"+String.valueOf(i)) );
                double tasa = (request.getParameter("TASA"+String.valueOf(i)).equals ("") ? 0 : Double.parseDouble(request.getParameter("TASA"+String.valueOf(i)) ));
                oTasa.settasa         (tasa);
                oTasa.setnumOrden     ( i );
                double minimo = (request.getParameter("MINIMO"+String.valueOf(i)).equals ("") ? 0 : Double.parseDouble(request.getParameter("MINIMO"+String.valueOf(i)) ));
                oTasa.setimpMinimo(minimo);
                String tipoPersona = request.getParameter("categoria_persona"+String.valueOf(i));
                if (tipoPersona.equals("ALL")) {
                    oTasa.setcategoriaPersona(null);
                } else {
                    oTasa.setcategoriaPersona(tipoPersona);
                } 
                double baseMinimo = (request.getParameter("BASE_MINIMO"+String.valueOf(i)).equals ("") ? 0 : Double.parseDouble(request.getParameter("BASE_MINIMO"+String.valueOf(i)) ));
                oTasa.setbaseCalculoMin(baseMinimo);
                
                oTasa.setDB(dbCon);
                if (oTasa.getiNumError() < 0) {
                    throw new SurException(oTasa.getsMensError());
                }
            }
            
            if (oTasa.getiNumError() == 0) {
                request.setAttribute("mensaje", "La informacion ha sido actualizada exitosamente.");
            } else {
                String sMensaje = "";                
                switch (oTasa.getiNumError()) {
                    case -1: // error de actualizacion
                        sMensaje = "Error al actualizar la tasa provincial<br>(cod_provincia = "+String.valueOf(oTasa.getcodProvincia())+") <br>Por favor comiquese con sistemas.</br></br>Muchas Gracias.";
                        break;

                    default: // normal html
                        sMensaje = "Hubo algún problema en la actualizacion de las Tasas Provinciales. Por favor, comuniquese con sistemas</br></br>Muchas Gracias.";

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
    
    
    protected void addProduccion (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons = null;
        LinkedList lLista = new LinkedList();
        try {
            dbCon = db.getConnection();
            cons = dbCon.prepareCall(db.getSettingCall("ABM_PROD_TASA_PROVINCIAL()"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            
            cons.execute();
            
            int res = cons.getInt (1);
            
           if (res == 0) {
                request.setAttribute("mensaje", "Los datos han sido pasados a produccion con exito.");
            } else {
                String sMensaje = "Error al pasar a producción las tasas provinciales<br><br>Por favor comiquese con sistemas.</br></br>Muchas Gracias.";
                request.setAttribute("mensaje", sMensaje);                
                request.setAttribute("volver", "-1");             
                doForward (request, response, "/include/MsjHtmlServidor.jsp");                      
            }
            
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
    

    protected void getAllTasaProvincial (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons = null;
        LinkedList <TasaProvincial> lTasa = new LinkedList();
        try {
            dbCon = db.getConnection();
            dbCon.setAutoCommit(false);
            
            cons = dbCon.prepareCall(db.getSettingCall("ABM_GET_ALL_TASA_PROVINCIAL()"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            
            cons.execute();
            
            ResultSet rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    TasaProvincial oTasa = new TasaProvincial();
                    oTasa.setdescProvincia  (rs.getString("DESC_PROVINCIA"));  
                    oTasa.settasa           (rs.getDouble ("TASA"));
                    oTasa.setcodProvincia   (rs.getInt ("COD_PROVINCIA"));
                    oTasa.setcodRama        (rs.getInt ("COD_RAMA"));
                    oTasa.setcodSubRama     (rs.getInt ("COD_SUB_RAMA"));
                    oTasa.setcodProducto    (rs.getInt ("COD_PRODUCTO"));
	            oTasa.setdescProducto   (rs.getString("DESC_PRODUCTO"));
                    oTasa.setbaseCalculo    (rs.getString("BASE_CALCULO"));
                    oTasa.setimpMinimo      (rs.getDouble("IMP_MINIMO"));
                    oTasa.setbaseCalculoMin (rs.getDouble("BASE_CALCULO_MIN"));
                    
                    lTasa.add(oTasa); 
                }
                rs.close();
            }

            request.setAttribute("tasas", lTasa);
            doForward (request, response, "/abm/formTasaProvincial.jsp");
            
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