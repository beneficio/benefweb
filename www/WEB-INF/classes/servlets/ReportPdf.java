/*
 * xmlpdf.java
 *
 * Created on 11 de julio de 2003, 09:32
 */

package servlets;

import com.business.beans.Usuario;
import java.io.*;  
import java.sql.SQLException;
import javax.servlet.*;
import javax.servlet.http.*;
import xmlpdf.*;
import com.business.util.*;
/**
 *
 * @author  rjofre
 * @version
 */
public class ReportPdf extends HttpServlet {
    
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
        try{ 
//Chequeo si el usuario esta logueado o no ocurrio un timeout
            if (!ValidadorSesion.Validar(request, response, this)) return; 
            
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));
        
System.out.println ("en ReportPdf: " + (oUser == null ? " usuario nulo" : oUser.getusuario() ) );        
            
            Report oReport = (Report) request.getAttribute("oReport");
            String sName  = (String) request.getAttribute ("nombre");
            
System.out.println (oReport.getReportName());
System.out.println (oReport.getXmlData().length() );

            String xmlData          = oReport.getXmlData  ();
            InputStream stream      = new FileInputStream (oReport.getReportName());
            StringBuffer streamData = new StringBuffer    (xmlData);

//            streamData.insert(0, xmlData); 

            PDFDocument doc = new PDFDocument();

             // Toma la orientacion que quiero dar a la p�gina
            // portrait = horizontal, landscape = vertical
            
            doc.setAttributeTranslation( "$orientation" , oReport.getOrientacion());
            
            ByteArrayOutputStream outStream = new ByteArrayOutputStream();

           doc.generate( stream, outStream, streamData );

 //           if (sName != null) {
 //         doc.generate(oReport.getReportName(), "/files/mergerows.pdf", oReport.getXmlData  () );
 //           }

            if (sName == null) {
                sName = "Beneficio.pdf";
            }     

            response.setContentType("application/pdf");
            response.setContentLength( outStream.size() );
            response.setHeader("Content-disposition","inline; filename=\"" + sName + "\"");

            PrintStream ps = new PrintStream (response.getOutputStream() );
            ps.write( outStream.toByteArray() );
            ps.close ();
             
        } catch( SQLException Sqle){
              goToJSPError (request,response, Sqle);
        } catch( Exception e){
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