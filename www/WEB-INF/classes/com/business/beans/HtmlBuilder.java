/*  
 * HtmlBuilder.java
 *
 * Created on 10 de julio de 2003, 10:25
 */
 
package com.business.beans;

import java.io.*;
import java.net.*;
import java.util.*;
import javax.servlet.http.*;
import com.business.util.*;
import com.business.interfaces.*;


/**
 *
 * @author  Gisela Cabot
 * @version
 */
public class HtmlBuilder {
     
    private int cantCol=0;
    private int cantFilas=0;
    private String titulos;
    private String filePath="";
    
    public HtmlBuilder() {
    }
   
    public String armarHTMLInicTAG() {
        String inicHtml;
        inicHtml="<html>\n";
        inicHtml+="<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">\n";
        return inicHtml;
    }
    
    public String armarHTMLFinTAG() {
        String finHtml;
        return finHtml="</html>\n";
    }
    
    public String armarMetaTAG(String pscssLink) {
        String meta;
        meta ="<META content=\"text/html; charset=windows-1252\" http-equiv=Content-Type>\n";
        meta +="<LINK href=" + pscssLink + "rel=STYLESHEET type=text/css>\n";	
        meta +="<META content=\"MSHTML 5.00.2614.3500\" name=GENERATOR>\n";
        meta +="<meta http-equiv=\"Pragma\" content=\"no-cache\">\n";
        meta +="</META>\n";
        return meta;
    }
    
    public String armarHeadTAG(String pstitulo, boolean pbincludeJS, String psjsName, String psdeclFuncion, String pscuerpoFuncion) {
        String head;
        head ="<head>\n";
        head += "<title>" + pstitulo + "</title>\n";
        if (pbincludeJS == true ) {
            head +="<SCRIPT language=JavaScript src=" + psjsName + "> </SCRIPT>\n";
            head +="<SCRIPT>\n";
            head += "function" + psdeclFuncion;
            head += "{   return " + pscuerpoFuncion;
            head +="}";
            head +="</SCRIPT>\n";
        }
        head +="</head>\n";
        return head;
    }
   
    
    public String armarSelectTAG(LinkedList maestroInfo) {
        String salida="";
        Iterator elements= maestroInfo.iterator();  
        
        while (elements.hasNext()) {            
            MaestroInfo mInfo = (MaestroInfo) elements.next();       
            if ( mInfo.getsCodigo() == null) {
                salida += "<option value=" + mInfo.getCodigo() + ">" + mInfo.getDescripcion() + "</option>\n";
            } else {
               salida += "<option value=" + mInfo.getsCodigo() + ">" + mInfo.getDescripcion() + "</option>\n";
            }
        }     
        return salida;
    }
    public String armarSelectTAG(LinkedList maestroInfo, int iValorDefecto) {
        String salida="";
        Iterator elements= maestroInfo.iterator();  
        
        while (elements.hasNext()) {            
            MaestroInfo mInfo = (MaestroInfo) elements.next();       
            if (iValorDefecto == mInfo.getCodigo()){
                salida += "<option value='" + mInfo.getCodigo() + "' selected>" + mInfo.getDescripcion() + "</option>\n";
            }else{
                salida += "<option value='" + mInfo.getCodigo() + "'>" + mInfo.getDescripcion() + "</option>\n";
            }
            
        }     
        return salida;
     }

    public String armarSelectTAG(LinkedList maestroInfo, String sValorDefecto) {
        String salida="";
        Iterator elements= maestroInfo.iterator();  
        
        while (elements.hasNext()) {            
            MaestroInfo mInfo = (MaestroInfo) elements.next();       
            if (sValorDefecto.equals (mInfo.getsCodigo())){
                salida += "<option value='" + mInfo.getsCodigo() + "' selected>" + mInfo.getDescripcion() + "</option>\n";
            }else{
                salida += "<option value='" + mInfo.getsCodigo() + "'>" + mInfo.getDescripcion() + "</option>\n";
            }
            
        }     
        return salida;
     }
    
}
   