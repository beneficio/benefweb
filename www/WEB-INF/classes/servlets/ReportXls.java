/*
 * ReportXls.java
 *
 * Created on 12 de febrero de 2004, 16:37
 */

package servlets;

import com.business.beans.Usuario;
import java.io.*;
import java.net.*;

import javax.servlet.*;
import javax.servlet.http.*;
import com.business.util.xls;
import com.business.util.ValidadorSesion;

/**
 *
 * @author  rjofre
 * @version
 */
public class ReportXls extends HttpServlet {
    
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

//Chequeo si el usuario esta logueado o no ocurrio un timeout
        if (!ValidadorSesion.Validar(request, response, this)) return; 

        Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));
        
System.out.println ("en ReportXls: " + (oUser == null ? " usuario nulo" : oUser.getusuario() ) );        
        
        xls oXls = (xls) request.getAttribute("oReportXls");

System.out.println (oXls.getTitulo());

        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-Disposition","attachment; filename =Beneficio.xls");
        oXls.generate().write(response.getOutputStream());

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
    
}
