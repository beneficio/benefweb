/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package ajaxdemo;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson;         
import java.util.LinkedHashMap;
import java.util.Map;
/**
 *
 * @author Rolando Elisii
 */
public class ActionServlet2 extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
     protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

         String op =  request.getParameter("opcion");
         if (op.equals("prueba1")) {
            prueba1 (request, response);
         }
    }

     protected void prueba1 (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {


        String country=request.getParameter("countryname");
        Map<String, String> ind = new LinkedHashMap<String, String>();
        ind.put("1", "New delhi");
        ind.put("2", "Tamil Nadu");
        ind.put("3", "Kerala");
        ind.put("4", "Andhra Pradesh");

        Map<String, String> us = new LinkedHashMap<String, String>();
        us.put("1", "Washington");
        us.put("2", "California");
        us.put("3", "Florida");
        us.put("4", "New York");

        String json = null ;
        if(country.equals("India")){
            json= new Gson().toJson(ind);
        } else if(country.equals("US")){
            json=new Gson().toJson(us);
        }
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json);
    }

  protected void doGet(HttpServletRequest request,   HttpServletResponse response)
        throws ServletException, IOException {
      processRequest(request, response);
 }

   

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
