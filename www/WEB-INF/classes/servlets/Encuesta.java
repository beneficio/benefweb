/*
 * setAccess.java
 *
 * Created on 14 de enero de 2005, 17:46
 */

package servlets;

import java.io.*;
import java.util.LinkedList;
import java.text.SimpleDateFormat;
import java.net.*;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;

import javax.servlet.*;
import javax.servlet.http.*;

import com.business.beans.ProductorCobertura;
import com.business.beans.Usuario;
import com.business.beans.Persona;
import com.business.util.*;
import com.business.db.db;

/**
 *
 * @author  surprogra
 * @version
 */
public class Encuesta extends HttpServlet {

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
        String op =  request.getParameter ("opcion");

        if (op.equals ("add_encuesta")) {
           addEncuesta (request,response);
        }

      } catch (SurException se) {
          goToJSPError (request,response, se);
      } catch (Exception e) {
          goToJSPError (request,response, e);
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

     public void addEncuesta (HttpServletRequest request, HttpServletResponse response) throws SurException {
        Connection dbCon = null;
        CallableStatement proc = null;
         try {
            db.realPath (getServletConfig().getServletContext ().getRealPath("/propiedades/config.xml"));
            if (Param.getAplicacion() == null) {
                Param.realPath (getServletContext().getRealPath("/propiedades/config.xml"));
            }

            dbCon = db.getConnection();

            dbCon.setAutoCommit (true);
            proc = dbCon.prepareCall(db.getSettingCall("ENC_SET_REGISTRO (?,?,?,?,?,?,?,?,?,?,?,?,?,?)"));
            proc.registerOutParameter(1, java.sql.Types.INTEGER);
            proc.setInt     (2,  Integer.valueOf(request.getParameter("num_encuesta")));
            proc.setString  (3, request.getParameter("nombre"));
            proc.setString  (4, request.getParameter("matricula"));
            proc.setString  (5, request.getParameter("telefono1"));
            proc.setString  (6, request.getParameter("telefono2"));
            proc.setString  (7, request.getParameter("email"));
            proc.setString  (8, request.getParameter("trabaja"));
            proc.setString  (9, request.getParameter("patrimoniales"));
            proc.setString  (10, request.getParameter("art"));
            proc.setString  (11, request.getParameter("vida_colec"));
            proc.setString  (12, request.getParameter("vida_indiv"));
            proc.setString  (13, request.getParameter("ap"));
            proc.setString  (14, request.getParameter("conocia"));
            proc.setString  (15, request.getParameter("compania_vida_ap"));

            proc.execute();

            proc.close();
            request.setAttribute("mensaje", "La operación fue realizada con exito");

            request.setAttribute("volver",  "/benef/expo.htm");
            doForward (request, response, "/include/MsjHtmlServidor.jsp");
        } catch (Exception e) {
            throw new SurException ("Error al grabar la encuesta " + e.getMessage());
        } finally {
            try {
                if (proc != null) { proc.close(); }
            } catch (Exception ee) {
               throw new SurException ("Error al grabar la encuesta " + ee.getMessage());
            }
            db.cerrar(dbCon);
        }
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

    public void goToJSPError (HttpServletRequest request, HttpServletResponse response, Throwable t) throws ServletException, IOException {
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
