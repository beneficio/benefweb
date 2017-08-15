/*
 * ValidadorSesion.java
 *
 * Created on 11 de junio de 2004, 15:11
 */

package com.business.util;

/**
 *
 * @author  surprogra
 */
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;


public class ValidadorSesion {
    public static boolean Validar (javax.servlet.http.HttpServletRequest request,
        javax.servlet.http.HttpServletResponse response, HttpServlet  servlet )	{
        HttpSession sesion	= request.getSession();	
 //Chequeo si el usuario esta logueado o no ocurrio un timeout
        if (sesion.getAttribute("user") == null) {	
            try {
                servlet.getServletConfig().getServletContext().getRequestDispatcher("/sessionCancel.jsp").forward(request,response);
            } catch (IOException ioe) {
		System.out.println("LoginServlet IOException Forwarding Request: " + ioe);
            } catch (ServletException se) {
		System.out.println("LoginServlet ServletException Forwarding Request: " + se);
            } // try		 	
            return false;
	  } else 
             return true;
        }
}

