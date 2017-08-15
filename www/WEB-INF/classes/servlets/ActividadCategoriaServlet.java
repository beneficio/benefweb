/*
 * ActividadCategoriaServlet.java
 *
 * Created on 29 de enero de 2005, 13:46
 */

package servlets;

import java.io.IOException;
import java.sql.Connection;

import com.business.beans.ActividadCategoria;
import com.business.beans.ActividadCobertura;
import com.business.beans.Usuario;
import com.business.util.*;
import com.business.db.*;

import javax.servlet.*;
import javax.servlet.http.*;

/**
 *
 * @author Rolando Elisii
 * @version
 */
public class ActividadCategoriaServlet extends HttpServlet {
    
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
            
            if (op.equals("addActividadCategoria")) {
                addActividadCategoria (request, response);
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
    protected void addActividadCategoria (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {
            ActividadCategoria oActividadCategoria = new ActividadCategoria ();
            oActividadCategoria.setcodRama      (Integer.parseInt (request.getParameter("COD_RAMA") ));
            oActividadCategoria.setcodActividad (Integer.parseInt (request.getParameter("COD_ACTIVIDAD") ));
            oActividadCategoria.setcategoria    (Integer.parseInt (request.getParameter("CATEGORIA") ));
            oActividadCategoria.setdescripcion  (request.getParameter("DESCRIPCION") );
            oActividadCategoria.setmcaBaja      (request.getParameter("MCA_BAJA"));
            oActividadCategoria.setmcaPlanes    (request.getParameter("MCA_PLANES"));
            oActividadCategoria.setmcaCotizador (request.getParameter("MCA_COTIZADOR"));
            oActividadCategoria.setmcaNoRenovar (request.getParameter("MCA_NO_RENOVAR"));
            oActividadCategoria.setmca24Horas   (request.getParameter("MCA_24HORAS"));
            oActividadCategoria.setmcaItinere   (request.getParameter("MCA_ITINERE"));
            oActividadCategoria.setmcaLaboral   (request.getParameter("MCA_LABORAL"));

System.out.println (request.getParameter("MCA_NO_RENOVAR"));
System.out.println (oActividadCategoria.getmcaNoRenovar());

            dbCon = db.getConnection();
            oActividadCategoria.setDB(dbCon);

            int iCantCob = Integer.parseInt ( request.getParameter ("CANT_COB"));
            
            boolean bChange = false;
            
            for (int ii = 1; ii <= iCantCob; ii++) {                
                 if (Dbl.StrtoDbl (request.getParameter ("SUMA_" + ii)) != Dbl.StrtoDbl (request.getParameter ("SUMA_ANT_" + ii))) {
                    bChange = true;
                    break;
                 }
            }
    
            if (bChange) {
                for (int i = 1; i <= iCantCob; i++) {
                    ActividadCobertura oCob = new ActividadCobertura ();

                    oCob.setcodRama      (oActividadCategoria.getcodRama());
                    oCob.setcodSubRama   (Integer.parseInt (request.getParameter ("COD_SUB_RAMA")) );
                    oCob.setcodActividad (oActividadCategoria.getcodActividad ());
                    oCob.setcodCob       (Integer.parseInt (request.getParameter ("COB_" + i)));
                    oCob.setmaxSumaAseg  (Dbl.StrtoDbl (request.getParameter ("SUMA_" + i)));
                    oCob.setuserId ( ((Usuario) request.getSession().getAttribute("user")).getusuario());
                    oCob.setnumOrden(i);

                    oCob.setDB(dbCon);                
                }
            }
            
            if (oActividadCategoria.getiNumError() == 0) {
                request.setAttribute("mensaje", "La actividad  ha sido actualizada exitosamente.</br><br><br> Muchas Gracias.");
                request.setAttribute("volver", Param.getAplicacion() + "abm/formActividadCategoria.jsp?cod_actividad=" + oActividadCategoria.getcodActividad() );
                doForward (request, response, "/include/MsjHtmlServidor.jsp");                      
            } else {
                String sMensaje = "";                
                switch (oActividadCategoria.getiNumError()) {
                    case -1: // error de actualizacion
                        sMensaje = "Error al actualizar la ACTIVIDAD<br>(cod_actividad = "+String.valueOf(oActividadCategoria.getcodActividad())+") <br>Por favor comiquese con sistemas.</br></br>Muchas Gracias.";
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