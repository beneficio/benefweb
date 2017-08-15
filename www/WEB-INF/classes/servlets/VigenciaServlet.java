/*
 * VigenciaServlet.java
 *
 * Created on 29 de enero de 2005, 13:46
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

import com.business.beans.*;
import com.business.util.*;
import com.business.db.*;
import com.business.interfaces.*;

import javax.servlet.*;
import javax.servlet.http.*;

/**
 *
 * @author Rolando Elisii
 * @version
 */
public class VigenciaServlet extends HttpServlet {
    
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
            
            if (op.equals("addVigencia")) {
                addVigencia (request, response);
           
            } else if (op.equals("getAllVigencia")) {
                getAllVigencia (request, response);
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
    protected void addVigencia (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {
            dbCon = db.getConnection();            
            int nVigencia = (Integer.parseInt (request.getParameter("cant_vigencia")));
            Vigencia oVigencia = new Vigencia ();
            oVigencia.setiNumError(0);
            for (int i=0;i<nVigencia && oVigencia.getiNumError()==0 ;i++){
                oVigencia.setcodRama      (Integer.parseInt (request.getParameter("COD_RAMA_"+String.valueOf(i)) ));
                oVigencia.setcodVigencia  (Integer.parseInt (request.getParameter("COD_VIGENCIA_"+String.valueOf(i)) ));
                int cuotas = (request.getParameter("CANT_CUOTAS_"+String.valueOf(i)).equals ("")  ? 1 : Integer.parseInt (request.getParameter("CANT_CUOTAS_"+String.valueOf(i)) ));
                oVigencia.setcantCuotas   (cuotas);
                oVigencia.setDB(dbCon);
            }
            
            if (oVigencia.getiNumError() == 0) {
                request.setAttribute("mensaje", "La informacion ha sido actualizada exitosamente.</br><br><br> Muchas Gracias.");
                request.setAttribute("volver", Param.getAplicacion() + "abm/formAbmIndex.jsp");             
                doForward (request, response, "/include/MsjHtmlServidor.jsp");                      
            } else {
                String sMensaje = "";                
                switch (oVigencia.getiNumError()) {
                    case -1: // error de actualizacion
                        sMensaje = "Error al actualizar la vigencia<br>(cod_vigencia = "+String.valueOf(oVigencia.getcodVigencia())+") <br>Por favor comiquese con sistemas.</br></br>Muchas Gracias.";
                        break;

                    default: // normal html
                        sMensaje = "Hubo algún problema en la actualizacion de las Tasas Provinciales. Por favor, comuniquese con sistemas</br></br>Muchas Gracias.";

                }
                request.setAttribute("mensaje", sMensaje);                
                request.setAttribute("volver", Param.getAplicacion() + "index.jsp");             
                doForward (request, response, "/include/MsjHtmlServidor.jsp");                      
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void getAllVigencia (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons = null;
        LinkedList lLista = new LinkedList();
        try {
            dbCon = db.getConnection();
            dbCon.setAutoCommit(false);
            
            Integer nCodRama = (Integer.parseInt (request.getParameter("cod_rama")));
            
            cons = dbCon.prepareCall(db.getSettingCall("ABM_GET_ALL_VIGENCIA(?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt   (2, nCodRama );
            
            cons.execute();
            
            ResultSet rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    Vigencia oVigencia = new Vigencia();
                    oVigencia.setcodRama         (rs.getInt("COD_RAMA"));
                    oVigencia.setcodVigencia     (rs.getInt("COD_VIGENCIA"));
                    oVigencia.setcantCuotas      (rs.getInt("CANT_CUOTAS"));
                    oVigencia.setdescVigencia (rs.getString("DESC_VIGENCIA"));                    
                    
                    lLista.add(oVigencia);
                }
                rs.close();
            }

            request.setAttribute("vigencias", lLista);
            doForward (request, response, "/abm/formVigencia.jsp");
            
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