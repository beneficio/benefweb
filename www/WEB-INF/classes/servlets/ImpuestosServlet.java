/*
 * ImpuestosServlet.java
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
public class ImpuestosServlet extends HttpServlet {
    
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
            
            if (op.equals("addImpuestos")) {
                addImpuestos (request, response);
                getAllImpuestos (request, response);//por ultimo vuelvo al abm

            } else if (op.equals("addProd")) {
                addImpuestos (request, response);//primero grabo
                addProduccion (request, response);//despues paso a produccion
                getAllImpuestos (request, response);//por ultimo vuelvo al abm
           
            } else if (op.equals("getAllImpuestos")) {
                getAllImpuestos (request, response);
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
    protected void addImpuestos (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {
            int nImpuestos = (Integer.parseInt (request.getParameter("cant_impuestos")));
            int nCodRama=0;
            Impuestos oImpuesto = new Impuestos ();
            Date fecha;
            fecha   = Fecha.strToDate(request.getParameter ("FECHA_DESDE").equals ("") ? Fecha.getFechaActual () : request.getParameter ("FECHA_DESDE"));
            oImpuesto.setiNumError(0);
            dbCon = db.getConnection ();

            for (int i=0 ; i < nImpuestos && oImpuesto.getiNumError()==0 ; i++){
                nCodRama = (Integer.parseInt (request.getParameter("COD_RAMA_"+String.valueOf(i)) ));
                oImpuesto.setcodRama      (Integer.parseInt (request.getParameter("COD_RAMA_"+String.valueOf(i)) ));
                oImpuesto.setcodSubRama   (Integer.parseInt (request.getParameter("COD_SUB_RAMA_"+String.valueOf(i)) ));                
                oImpuesto.setcodImpuesto  (Integer.parseInt (request.getParameter("COD_IMPUESTO_"+String.valueOf(i)) ));
                
                double tasa     = ( request.getParameter("VALOR_"+String.valueOf(i)).equals ("") ? 0 : Double.parseDouble(request.getParameter("VALOR_"+String.valueOf(i)) ));
                double valorAct = ( request.getParameter("VALOR_ACT_"+String.valueOf(i)).equals ("") ? 0 : Double.parseDouble(request.getParameter("VALOR_ACT_"+String.valueOf(i)) ));                
                oImpuesto.settipoValor   ( request.getParameter("TIPO_VALOR_"+String.valueOf(i)) );                
                
                oImpuesto.setvalor       (tasa);
                oImpuesto.setfechaDesde  (fecha);
                oImpuesto.setDB(dbCon);
            }
            
            if (oImpuesto.getiNumError() == 0) {
                request.setAttribute("mensaje", "La informacion ha sido actualizada exitosamente.");
                request.setAttribute("cod_rama", nCodRama);
            } else {
                String sMensaje = "";                
                switch (oImpuesto.getiNumError()) {
                    case -1: // error de actualizacion
                        sMensaje = "Error al actualizar el impuesto<br>(cod_impuesto = "+String.valueOf(oImpuesto.getcodImpuesto())+") <br>Por favor comiquese con sistemas.</br></br>Muchas Gracias.";
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

    protected void addProduccion (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons = null;
        Integer nCodRama = (Integer.parseInt (request.getParameter("COD_RAMA_1")));
        try {
            dbCon = db.getConnection();
            cons = dbCon.prepareCall(db.getSettingCall("ABM_PROD_IMPUESTOS(?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt   (2, nCodRama );
            
            cons.execute();
            
            int res = cons.getInt (1);
            
           if (res == 0) {
                request.setAttribute("mensaje", "Los datos han sido pasados a produccion con exito.");
                request.setAttribute("cod_rama", nCodRama);
           } else {
                request.setAttribute("mensaje", "Error al pasar a produccion los impuestos<br><br>Por favor comiquese con sistemas.</br></br>Muchas Gracias.");                
                request.setAttribute("volver", Param.getAplicacion() + "index.jsp");             
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
    
    protected void getAllImpuestos (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        ResultSet rs     = null;
        CallableStatement cons = null;
        LinkedList lLista = new LinkedList();
        try {
            dbCon = db.getConnection();
            dbCon.setAutoCommit(false);
            Integer nCodRama;
            if ( request.getAttribute("cod_rama") != null){
                nCodRama = (Integer)request.getAttribute("cod_rama");
            }else{
                nCodRama = (Integer.parseInt (request.getParameter("cod_rama")==null?"0":request.getParameter("cod_rama") ));
            }
            
            cons = dbCon.prepareCall(db.getSettingCall("ABM_GET_ALL_IMPUESTOS(?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt   (2, nCodRama );
            
            cons.execute();
            
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    Impuestos oImpuesto = new Impuestos();
                    oImpuesto.setcodRama         (rs.getInt("COD_RAMA"));
                    oImpuesto.setcodSubRama      (rs.getInt("COD_SUB_RAMA"));                    
                    oImpuesto.setcodImpuesto     (rs.getInt("COD_IMPUESTO"));
                    oImpuesto.setvalor           (rs.getDouble("VALOR"));
                    oImpuesto.settipoValor       (rs.getString("TIPO_VALOR"));                    
                    oImpuesto.setfechaDesde      (rs.getDate("FECHA_DESDE"));                    
                    oImpuesto.setdescImpuesto    (rs.getString("DESC_IMPUESTO"));                    
                    oImpuesto.setdescRama        (rs.getString("DESC_RAMA"));                    
                    oImpuesto.setdescSubRama     (rs.getString("DESC_SUB_RAMA"));    
                    oImpuesto.setvalorProduccion (rs.getDouble ("VALOR_PROD"));
                    
                    lLista.add(oImpuesto);
                }
                rs.close();
            }

            request.setAttribute("impuestos", lLista);
            doForward (request, response, "/abm/formImpuestos.jsp");
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close ();
                if (rs != null) rs.close ();                
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