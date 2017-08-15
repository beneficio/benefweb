/*
 * BonificacionServlet.java
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
public class BonificacionServlet extends HttpServlet {
    
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
            
            if (op.equals("addBonificacion")) {
                addBonificacion (request, response);//grabo
                getAllBonificacion (request, response);//regreso al abm
           
            } else if (op.equals("addProdBonificacion")) {
                addProdBonificacion (request, response);//paso a produccion
                getAllBonificacion (request, response);//regreso al abm

            } else if (op.equals("getAllBonificacion")) {
                getAllBonificacion (request, response);
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
    protected void addBonificacion (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {
            Integer nBonificacion = (Integer.parseInt (request.getParameter("cant_bonificacion")));
            
            Integer i;
            Date fecha;
            fecha   = Fecha.strToDate(request.getParameter ("FECHA_DESDE").equals ("") ? Fecha.getFechaActual () : request.getParameter ("FECHA_DESDE"));
            int iCodRama     = Integer.parseInt (request.getParameter("cod_rama" )); 
            int iCodSubRama  = Integer.parseInt (request.getParameter("cod_sub_rama" ));  
            int iCodProducto = Integer.parseInt (request.getParameter("cod_producto" ));                     
            
            Bonificacion oBonificacion = new Bonificacion ();
            oBonificacion.setiNumError(0);
            oBonificacion.setcodRama(iCodRama);
            oBonificacion.setcodSubRama(iCodSubRama);
            oBonificacion.setcodProducto(iCodProducto);

            dbCon = db.getConnection();
            oBonificacion.delDB(dbCon);
            
            if (oBonificacion.getiNumError() == 0) {
                for (i=0;i<nBonificacion && oBonificacion.getiNumError()==0 ;i++){
                    oBonificacion.setcodRama            (iCodRama); 
                    oBonificacion.setcodSubRama         (iCodSubRama); 
                    oBonificacion.setcodProducto        (iCodProducto);                     
                    oBonificacion.setcantPersonasDesde  (Integer.parseInt (request.getParameter("CANT_PERSONAS_DESDE_"+String.valueOf(i)) ));
                    oBonificacion.setcantPersonasHasta  (Integer.parseInt (request.getParameter("CANT_PERSONAS_HASTA_"+String.valueOf(i)) ));
                    oBonificacion.setbonificacion       (Double.parseDouble (request.getParameter("BONIFICACION_"+String.valueOf(i)) ));
                    oBonificacion.setfechaDesde         (fecha);

                    oBonificacion.setDB(dbCon);
                }

                if (oBonificacion.getiNumError() == 0) {
                    request.setAttribute("mensaje", "La informacion ha sido actualizada exitosamente.");
                } else {
                    String sMensaje = "";                
                    switch (oBonificacion.getiNumError()) {
                        case -1: // error de actualizacion
                            sMensaje = "Error al actualizar la Bonificacion<br><br>Por favor comiquese con sistemas.</br></br>Muchas Gracias.";
                            break;

                        default: // normal html
                            sMensaje = "Hubo algún problema en la actualizacion de las bonificaciones. Por favor, comuniquese con sistemas</br></br>Muchas Gracias.";

                    }
                    request.setAttribute("mensaje", sMensaje);                
                    request.setAttribute("volver", Param.getAplicacion() + "index.jsp");             
                    doForward (request, response, "/include/MsjHtmlServidor.jsp");                      
                }
            }    

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void getAllBonificacion (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons = null;
        CallableStatement cons2 = null;        
        LinkedList lLista = new LinkedList();
        LinkedList <Bonificacion> lProd  = new LinkedList();
        try {
            int codRama     = Integer.parseInt (request.getParameter ("cod_rama") == null ? "10" : request.getParameter ("cod_rama"));
            int codSubRama  = Integer.parseInt (request.getParameter ("cod_sub_rama") == null ? "-1" : request.getParameter ("cod_sub_rama"));            
            int codProducto = Integer.parseInt (request.getParameter ("cod_producto") == null ? "-1" : request.getParameter ("cod_producto"));            

            if ( codSubRama != -1 && codProducto != -1  ) {
                dbCon = db.getConnection();
                dbCon.setAutoCommit(false);
                cons = dbCon.prepareCall(db.getSettingCall("ABM_GET_ALL_BONIFICACION_ABM(?,?,?)"));
                cons.registerOutParameter(1, java.sql.Types.OTHER);
                cons.setInt (2, codRama);
                cons.setInt (3, codSubRama);
                cons.setInt (4, codProducto);            

                cons.execute();

                ResultSet rs = (ResultSet) cons.getObject(1);
                if (rs != null) {
                    while (rs.next()) {
                        Bonificacion oBonificacion = new Bonificacion();
                        oBonificacion.setcodRama           (rs.getInt ("COD_RAMA"));
                        oBonificacion.setcodSubRama        (rs.getInt ("COD_SUB_RAMA"));
                        oBonificacion.setcodProducto       (rs.getInt ("COD_PRODUCTO"));                    
                        oBonificacion.setcantPersonasDesde (rs.getInt("CANT_PERSONAS_DESDE"));
                        oBonificacion.setcantPersonasHasta (rs.getInt("CANT_PERSONAS_HASTA"));
                        oBonificacion.setbonificacion      (rs.getDouble("BONIFICACION"));
                        oBonificacion.setfechaDesde        (rs.getDate("FECHA_DESDE"));    
                        oBonificacion.setsRama      (rs.getString ("RAMA"));
                        oBonificacion.setsSubRama   (rs.getString ("SUB_RAMA"));
                        oBonificacion.setsProducto  (rs.getString ("PRODUCTO"));

                        lLista.add(oBonificacion);
                    }
                    rs.close ();
                }

                cons2 = dbCon.prepareCall(db.getSettingCall("ABM_GET_ALL_BONIFICACION(?,?,?)"));
                cons2.registerOutParameter(1, java.sql.Types.OTHER);
                cons2.setInt (2, codRama);
                cons2.setInt (3, codSubRama);
                cons2.setInt (4, codProducto);            

                cons2.execute();

                ResultSet rs2 = (ResultSet) cons2.getObject(1);
                if (rs2 != null) {
                    while (rs2.next()) {
                        Bonificacion oBonificacion = new Bonificacion();
                        oBonificacion.setcodRama           (rs2.getInt ("COD_RAMA"));
                        oBonificacion.setcodSubRama        (rs2.getInt ("COD_SUB_RAMA"));
                        oBonificacion.setcodProducto       (rs2.getInt ("COD_PRODUCTO"));                    
                        oBonificacion.setcantPersonasDesde (rs2.getInt("CANT_PERSONAS_DESDE"));
                        oBonificacion.setcantPersonasHasta (rs2.getInt("CANT_PERSONAS_HASTA"));
                        oBonificacion.setbonificacion      (rs2.getDouble("BONIFICACION"));
                        oBonificacion.setfechaDesde        (rs2.getDate("FECHA_DESDE"));    
                        oBonificacion.setsRama      (rs2.getString ("RAMA"));
                        oBonificacion.setsSubRama   (rs2.getString ("SUB_RAMA"));
                        oBonificacion.setsProducto  (rs2.getString ("PRODUCTO"));

                        lProd.add(oBonificacion);
                    }
                    rs2.close ();
                }
            }

            request.setAttribute("produccion", lProd);
            request.setAttribute("bonificaciones", lLista);
            doForward (request, response, "/abm/formBonif.jsp");
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close ();
                if (cons2 != null) cons2.close ();                
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }

    
    protected void addProdBonificacion (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons = null;
        LinkedList lLista = new LinkedList();
        String sMensaje = "";                        
        try {
            int codRama     = Integer.parseInt (request.getParameter ("cod_rama") == null ? "10" : request.getParameter ("cod_rama"));
            int codSubRama  = Integer.parseInt (request.getParameter ("cod_sub_rama") == null ? "-1" : request.getParameter ("cod_sub_rama"));            
            int codProducto = Integer.parseInt (request.getParameter ("cod_producto") == null ? "-1" : request.getParameter ("cod_producto"));            
            
            if (codSubRama != -1 && codProducto != -1 ) {
                dbCon = db.getConnection();
                cons = dbCon.prepareCall(db.getSettingCall("ABM_PROD_BONIFICACION(?,?,?)"));
                cons.registerOutParameter(1, java.sql.Types.INTEGER);
                cons.setInt (2, codRama);
                cons.setInt (3, codSubRama);
                cons.setInt (4, codProducto);            

                cons.execute();

                int res = cons.getInt (1);

               if (res == 0) {
                    request.setAttribute("mensaje", "Los datos han sido pasados a produccion con exito.");
                } else {
                    sMensaje = "Error al pasar a produccion la Bonificacion<br><br>Por favor comiquese con sistemas.</br></br>Muchas Gracias.";
                    request.setAttribute("mensaje", sMensaje);                
                    request.setAttribute("volver", Param.getAplicacion() + "index.jsp");             
                    doForward (request, response, "/include/MsjHtmlServidor.jsp");                          }
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