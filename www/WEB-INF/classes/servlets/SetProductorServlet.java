/*
 * SetProductorServlet.java
 *
 * Created on 25 de febrero de 2009, 23:10
 */

package servlets;

import java.io.IOException;
import java.sql.Types;
import java.util.LinkedList;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import com.business.beans.SeteoProd;
import com.business.beans.Usuario;
import com.business.beans.Vigencia;
import com.business.util.*;
import com.business.db.*;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 *
 * @author  Usuario
 * @version
 */
public class SetProductorServlet extends HttpServlet {
    
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
            
            
            if (op.equals("getAllSeteoProd")) {
                getAllSeteoProd (request, response);
            } else if (op.equals("getSeteoProd")) {
                getSeteoProd (request, response);
            } else if (op.equals("grabarSeteoProd")) {
                grabarSeteoProd (request, response);
            }  else if (op.equals("delSeteoProd")) {
                borrarSeteoProd(request, response);
            }   else if (op.equals("obtenerDatos")) {
                obtenerDatos (request, response);
            }
          
        } catch (SurException se) {
            goToJSPError(request,response, se);
        } catch (Exception e) {
            goToJSPError(request,response, e);
        } 
    } 
    
    
    protected void getAllSeteoProd (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons = null;
        LinkedList lSeteoProd = new LinkedList();
        ResultSet rs = null;
        try {

            int iCodProd = Integer.parseInt (request.getParameter ("cod_prod") == null ? "0" :
                                             request.getParameter ("cod_prod"));

            dbCon = db.getConnection();
            dbCon.setAutoCommit(false);            
            
            cons = dbCon.prepareCall(db.getSettingCall("ABM_GET_ALL_SETEO_PROD(?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            if (iCodProd == 0) {
                cons.setNull(2, Types.INTEGER);
            } else {
                cons.setInt  (2, iCodProd);
            }
            
            cons.execute();
            
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    SeteoProd oSeteoProd = new SeteoProd();
                    oSeteoProd.setcodSeteo     (rs.getInt("COD_SETEO"));
                    oSeteoProd.setcodProd      (rs.getInt ("COD_PROD"));                    
                    oSeteoProd.setcodRama      (rs.getInt("COD_RAMA"));
                    oSeteoProd.setcodSubRama   (rs.getInt("COD_SUB_RAMA"));
                    oSeteoProd.setdescRama     (rs.getString("RAMA"));
                    oSeteoProd.setdescSubRama  (rs.getString("SUB_RAMA"));
                    oSeteoProd.setdescProd     (rs.getString("DESC_PRODUCTOR"));                    
                    oSeteoProd.setminPrima     (rs.getDouble("PRIMA_MINIMA"));  
                    oSeteoProd.setcantMaxCuotas(rs.getInt("CANT_MAX_CUOTAS"));
                    oSeteoProd.setdiaDebito    (rs.getInt("DIA_DEBITO"));
                    oSeteoProd.setmaxComisionCot (rs.getDouble ("MAX_COMISION_COT"));
                    oSeteoProd.setmaxTopePremioCot (rs.getDouble( "MAX_TOPE_PREMIO_COT"));
                    oSeteoProd.setporcRecargoRetenido (rs.getDouble ("PORC_RECARGO_RETENIDO"));
                    oSeteoProd.setmcaNoGestionar (rs.getString("MCA_NO_GESTIONAR"));
                    oSeteoProd.setmailGestionDeuda (rs.getString ("MAIL_GESTION_DEUDA"));
                    oSeteoProd.setpermisoEmision(rs.getString ("PERMISO_EMISION"));
                    oSeteoProd.setlimiteEmision (rs.getInt ("LIMITE_EMISION"));
                    
                    lSeteoProd.add(oSeteoProd);
                }
                rs.close();
            }

            cons.close();
            request.setAttribute("seteos", lSeteoProd);
            doForward (request, response, "/abm/setProd/formConsultaSeteos.jsp");
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close ();
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }

 
    
    protected void getSeteoProd (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        LinkedList lCuotas = new LinkedList();
        try {            
            
            dbCon = db.getConnection();                                  
            int    codSeteoProd  = 0;    
            if ( request.getParameter ("cod_seteo") != null && 
                     !request.getParameter ("cod_seteo").equals("") ) {
                   codSeteoProd  = Integer.parseInt( request.getParameter ("cod_seteo") );
            }                                    

            SeteoProd oSeteoProd = new SeteoProd();
            oSeteoProd.setcodSeteo (codSeteoProd);
            oSeteoProd.getDB(dbCon);     

            if (oSeteoProd.getiNumError() < 0) {
                throw new SurException (oSeteoProd.getsMensError());
            }

            lCuotas = oSeteoProd.getDBCuotas(dbCon);
            if (oSeteoProd.getiNumError() < 0) {
                throw new SurException (oSeteoProd.getsMensError());
            }

            request.setAttribute("vigencias", lCuotas);
            request.setAttribute("seteo", oSeteoProd); 
            
            doForward (request, response, "/abm/setProd/formSeteoProd.jsp?abm=MODIFICACION");
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());            
        } finally {
            db.cerrar(dbCon);
        }
    }
    
    
    protected void grabarSeteoProd (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        
        try {
            dbCon = db.getConnection();  
            
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));

            int    codSeteoProd  = 0;    
            if ( request.getParameter ("cod_seteo") != null && 
                 !request.getParameter ("cod_seteo").equals("") ) {
                   codSeteoProd  = Integer.parseInt( request.getParameter ("cod_seteo") );
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
                        
            int codProd = 0;
            if ( request.getParameter ("cod_prod") != null && 
                 !request.getParameter ("cod_prod").equals("") ) {
                   codProd  = Integer.parseInt( request.getParameter ("cod_prod") );
            }                                                                        

            int diaDebito = 0;
            if ( request.getParameter ("dia_debito") != null &&
                 !request.getParameter ("dia_debito").equals("") ) {
                   diaDebito  = Integer.parseInt( request.getParameter ("dia_debito") );
            }

            double primaMin    = 0;
            if ( request.getParameter ("prima_min") != null && 
                 !request.getParameter ("prima_min").equals("") ) {
                   primaMin  = Double.parseDouble( request.getParameter ("prima_min") );
            }             

            double maxCom  = 0;
            if ( request.getParameter ("max_comision_cot") != null &&
                 !request.getParameter ("max_comision_cot").equals("") ) {
                   maxCom  = Double.parseDouble( request.getParameter ("max_comision_cot") );
            }

            double maxTope  = 0;
            if ( request.getParameter ("max_tope_premio_cot") != null &&
                 !request.getParameter ("max_tope_premio_cot").equals("") ) {
                   maxTope  = Double.parseDouble( request.getParameter ("max_tope_premio_cot") );
            }
            double coefRep  = 0;
            if ( request.getParameter ("porc_recargo_retenido") != null &&
                 !request.getParameter ("porc_recargo_retenido").equals("") ) {
                   coefRep  = Double.parseDouble( request.getParameter ("porc_recargo_retenido") );
            }

            String mcaNoGestionar = null;
            if ( request.getParameter ("mca_no_gestionar") != null &&
                 !request.getParameter ("mca_no_gestionar").equals("") ) {
                   mcaNoGestionar  =  request.getParameter ("mca_no_gestionar");
            }

            String mailGestionDeuda = null;
            if ( request.getParameter ("mail_gestion_deuda") != null &&
                 !request.getParameter ("mail_gestion_deuda").equals("") ) {
                   mailGestionDeuda  =  request.getParameter ("mail_gestion_deuda");
            }

System.out.println (request.getParameter ("permiso_emision"));

            String permisoEmision = null;
            if ( request.getParameter ("permiso_emision") != null &&
                 !request.getParameter ("permiso_emision").equals("") ) {
                   permisoEmision  =  request.getParameter ("permiso_emision");
            }

            int limiteEmision = 0;
            if ( request.getParameter ("limite_emision") != null &&
                 !request.getParameter ("limite_emision").equals("") ) {
                   limiteEmision  = Integer.parseInt( request.getParameter ("limite_emision") );
            }
            
            SeteoProd oSeteoProd = new SeteoProd();
            oSeteoProd.setcodSeteo     (codSeteoProd) ;
            oSeteoProd.setcodRama      (codRama)     ; 
            oSeteoProd.setcodSubRama   (codSubRama)  ;
            oSeteoProd.setcodProd      (codProd)  ;             
            oSeteoProd.setminPrima     (primaMin)    ; 
            oSeteoProd.setuserId       (oUser.getusuario() ); 
            oSeteoProd.setdiaDebito    (diaDebito);
            oSeteoProd.setmaxComisionCot(maxCom);
            oSeteoProd.setmaxTopePremioCot(maxTope);
            oSeteoProd.setporcRecargoRetenido(coefRep);
            oSeteoProd.setmcaNoGestionar(mcaNoGestionar);
            oSeteoProd.setmailGestionDeuda(mailGestionDeuda);
            oSeteoProd.setlimiteEmision(limiteEmision);
            oSeteoProd.setpermisoEmision(permisoEmision);

            oSeteoProd.setDB           (dbCon);
            
            if (oSeteoProd.getiNumError() < 0) {
                throw new SurException (oSeteoProd.getsMensError());
            }
/*
            int nVigencia = (Integer.parseInt (request.getParameter("cant_vigencia")));

            for (int i=0;i<nVigencia ;i++){
                Vigencia oVigencia = new Vigencia ();
                oVigencia.setcodVigencia  (Integer.parseInt (request.getParameter("COD_VIGENCIA_"+String.valueOf(i)) ));
                int cuotas = (request.getParameter("CANT_CUOTAS_"+String.valueOf(i)).equals ("")  ? 1 : 
                    Integer.parseInt (request.getParameter("CANT_CUOTAS_"+String.valueOf(i)) ));
                double cuotaMin = (request.getParameter("CUOTA_MINIMA_"+String.valueOf(i)).equals ("")  ? 1 : Dbl.StrtoDbl(request.getParameter("CUOTA_MINIMA_"+String.valueOf(i)) ));
                oVigencia.setcantCuotas   (cuotas);
                oVigencia.setcuotaMinima(cuotaMin);
                oSeteoProd.setDBCuotas (dbCon, oVigencia);
                
                if (oSeteoProd.getiNumError() < 0) {
                    throw new SurException (oSeteoProd.getsMensError());
                }
            }
  */
            response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
            response.setHeader("Location","/benef/servlet/SetProductorServlet?opcion=getAllSeteoProd&cod_prod=" + codProd);

        } catch (Exception e) {
            throw new SurException (e.getMessage());            
        } finally {
            db.cerrar(dbCon);
        }            
    }    

    protected void obtenerDatos (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;

        try {
            dbCon = db.getConnection();

            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));

            int    codSeteoProd  = 0;
            if ( request.getParameter ("cod_seteo") != null &&
                     !request.getParameter ("cod_seteo").equals("") ) {
                   codSeteoProd  = Integer.parseInt( request.getParameter ("cod_seteo") );
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

            int codProd = 0;
            if ( request.getParameter ("cod_prod") != null &&
                 !request.getParameter ("cod_prod").equals("") ) {
                   codProd  = Integer.parseInt( request.getParameter ("cod_prod") );
            }

            int diaDebito = 0;
            if ( request.getParameter ("dia_debito") != null &&
                 !request.getParameter ("dia_debito").equals("") ) {
                   diaDebito  = Integer.parseInt( request.getParameter ("dia_debito") );
            }

            double primaMin    = 0;
            if ( request.getParameter ("prima_min") != null &&
                 !request.getParameter ("prima_min").equals("") ) {
                   primaMin  = Double.parseDouble( request.getParameter ("prima_min") );
            }

            double maxCom  = 0;
            if ( request.getParameter ("max_comision_cot") != null &&
                 !request.getParameter ("max_comision_cot").equals("") ) {
                   maxCom  = Double.parseDouble( request.getParameter ("max_comision_cot") );
            }

            double maxTope  = 0;
            if ( request.getParameter ("max_tope_premio_cot") != null &&
                 !request.getParameter ("max_tope_premio_cot").equals("") ) {
                   maxTope  = Double.parseDouble( request.getParameter ("max_tope_premio_cot") );
            }
            double coefRep  = 0;
            if ( request.getParameter ("porc_recargo_retenido") != null &&
                 !request.getParameter ("porc_recargo_retenido").equals("") ) {
                   coefRep  = Double.parseDouble( request.getParameter ("porc_recargo_retenido") );
            }    

            String mcaNoGestionar = null;
            if ( request.getParameter ("mca_no_gestionar") != null &&
                 !request.getParameter ("mca_no_gestionar").equals("") ) {
                   mcaNoGestionar  =  request.getParameter ("mca_no_gestionar");
            }

            String mailGestionDeuda = null;
            if ( request.getParameter ("mail_gestion_deuda") != null &&
                 !request.getParameter ("mail_gestion_deuda").equals("") ) {
                   mailGestionDeuda  =  request.getParameter ("mail_gestion_deuda");
            }

System.out.println ( request.getParameter ("permiso_emision"));

            String permisoEmision = null;
            if ( request.getParameter ("permiso_emision") != null &&
                 !request.getParameter ("permiso_emision").equals("") ) {
                   permisoEmision  =  request.getParameter ("permiso_emision");
            }

            int limiteEmision = 0;
            if ( request.getParameter ("limite_emision") != null &&
                 !request.getParameter ("limite_emision").equals("") ) {
                   limiteEmision  = Integer.parseInt( request.getParameter ("limite_emision") );
            }
            

            SeteoProd oSeteoProd = new SeteoProd();
            oSeteoProd.setcodSeteo     (codSeteoProd) ;
            oSeteoProd.setcodRama      (codRama)     ;
            oSeteoProd.setcodSubRama   (codSubRama)  ;
            oSeteoProd.setcodProd      (codProd)  ;
            oSeteoProd.setminPrima     (primaMin)    ;
            oSeteoProd.setuserId       (oUser.getusuario() );
            oSeteoProd.setdiaDebito    (diaDebito);
            oSeteoProd.setmaxComisionCot(maxCom);
            oSeteoProd.setmaxTopePremioCot(maxTope);
            oSeteoProd.setporcRecargoRetenido(coefRep);
            oSeteoProd.setmcaNoGestionar(mcaNoGestionar);
            oSeteoProd.setmailGestionDeuda(mailGestionDeuda);
            oSeteoProd.setlimiteEmision(limiteEmision);
            oSeteoProd.setpermisoEmision(permisoEmision);

            oSeteoProd.getDBnivelSuperior (dbCon);

            if (oSeteoProd.getiNumError() == -1 ) {
                throw new SurException( (oSeteoProd.getsMensError()));
            }


            if (oSeteoProd.getiNumError() == 0 && ( oSeteoProd.getcodRama() != codRama ||
                                                    oSeteoProd.getcodSubRama() != codSubRama )) {
                oSeteoProd.setcodSeteo(codSeteoProd );
                oSeteoProd.setcodRama      (codRama)     ;
                oSeteoProd.setcodSubRama   (codSubRama)  ;
            }

            // LinkedList lCuotas = oSeteoProd.getDBCuotas(dbCon);
            //if (oSeteoProd.getiNumError() < 0) {
            //    throw new SurException (oSeteoProd.getsMensError());
            //}

            // request.setAttribute("vigencias", lCuotas);
            request.setAttribute("seteo", oSeteoProd);

            doForward (request, response, "/abm/setProd/formSeteoProd.jsp?abm=ALTA");

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }
    
  protected void borrarSeteoProd (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        
        try {
            dbCon = db.getConnection();  
            
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));

            int    codSeteoProd  = 0;    
            if ( request.getParameter ("cod_seteo") != null && 
                 !request.getParameter ("cod_seteo").equals("") ) {
                   codSeteoProd  = Integer.parseInt( request.getParameter ("cod_seteo") );
            }                                                            
                        
            
            SeteoProd oSeteoProd = new SeteoProd();
            oSeteoProd.setcodSeteo (codSeteoProd) ;
            oSeteoProd.setuserId   (oUser.getusuario());
            
            oSeteoProd.delDBSeteoProd(dbCon);
            
            if (oSeteoProd.getiNumError() < 0) {
                throw new SurException(oSeteoProd.getsMensError());
            }

            request.setAttribute("mensaje", "El seteo de la rama/subrama/productor fue elimininado exitosamente !!");             
            request.setAttribute("volver", "/benef/servlet/SetProductorServlet?opcion=getAllSeteoProd");             

            doForward (request, response, "/include/MSJServidor.jsp");
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