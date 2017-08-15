/*
 * Diccionario.java
 *
 * Created on 14 de febrero de 2006, 14:04
 */

package com.business.util;

import java.util.Hashtable;
import java.util.Date;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 *
 * @author  relisii
 */
public class Diccionario {
    
    Hashtable hDicc = new Hashtable ();
    
    /** Creates a new instance of Diccionario */
    public Diccionario() {
    }
    
    public void add (String variable, String valor) {
        
        hDicc.put(variable, (valor == null ? "" : valor));
    }

    public void add (String variable, Date valor) {

        hDicc.put(variable,(valor == null ? null : valor));
    }
    
    public String get (String variable) {
        
        return (hDicc.containsKey(variable) ?  (String) hDicc.get(variable) : null);
        
    }

    public String getString (javax.servlet.http.HttpServletRequest request, String variable) {
        return (request.getParameter (variable)  == null ? ( 
                this.get(variable) == null ? "" : this.get(variable)) : request.getParameter (variable));
    }

    public String getString (javax.servlet.http.HttpServletRequest request, String variable, String sDefault) {
        return (request.getParameter (variable)  == null ? ( 
                this.get(variable) == null ? sDefault : this.get(variable)) : request.getParameter (variable));
    }
    
    public int getInt (javax.servlet.http.HttpServletRequest request, String variable) {
        return (request.getParameter (variable) == null || request.getParameter (variable).equals ("") ?  
               ( this.get(variable) == null ? 0 : Integer.parseInt(this.get(variable)) ) : Integer.parseInt(request.getParameter(variable))) ;
    }
   public Date getDate (javax.servlet.http.HttpServletRequest request, String variable) {
        return (request.getParameter (variable) == null ? 
            (this.get(variable) == null ? null :(this.get(variable).equals ("") ? 
                null :Fecha.strToDate(this.get(variable)) )  ): (request.getParameter (variable).equals("") ? 
                    null :  Fecha.strToDate(request.getParameter(variable))  )  );
    }

    public boolean exists (String variable) {
        return hDicc.containsKey(variable);
    }
    
}
