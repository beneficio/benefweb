/*
 * TextoPoliza.java
 *
 * Created on 26 de marzo de 2006, 23:32
 */

package com.business.beans;

import java.util.Date;

/**
 *
 * @author Rolando Elisii
 */
public class TextoPoliza {
    
    private int codRama = 0;
    private int numPoliza = 0;
    private int endoso    = 0;
    private Date fechaFTP = null;
    
// campos de texto fijo
    private int secuencia = 0;
    private String codTexto = "";
    
// campos para el texto fijo
    
    private int renglon = 0;
    private String texto = "";
   
    /** Creates a new instance of TextoPoliza */
    public TextoPoliza() {
    }
    
    public void setcodRama      (int param) { codRama = param; }
    public void setnumPoliza    (int param) { numPoliza = param; }
    public void setendoso       (int param) { endoso = param; }
    public void setsecuencia    (int param) { secuencia = param; }
    public void setcodTexto     (String param) { codTexto = param; }
    public void setrenglon      (int param) { renglon = param; }
    public void settexto        (String param) { texto = param; }
    public void setfechaFTP          (Date param) { this.fechaFTP = param; }
    
    public int getcodRama       () { return codRama; }
    public int getnumPoliza     () { return numPoliza; }
    public int getendoso        () { return endoso; }    
    public int getsecuencia     () { return secuencia; }    
    public String getcodTexto   () { return codTexto; }    
    public int getrenglon       () { return renglon; }    
    public String gettexto      () { return texto; }    
    public Date getfechaFTP     () { return fechaFTP; }    
}