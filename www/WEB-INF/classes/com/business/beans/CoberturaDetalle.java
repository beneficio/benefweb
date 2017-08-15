/*
 * codProducto.java
 *
 * Created on 9 de enero de 2005, 19:37
 */

package com.business.beans;

import com.google.gson.annotations.Expose;

/**
 *
 * @author Rolando Elisii
 */
public class CoberturaDetalle {
    
    private int codRama       = 0;
    private int codSubRama    = 0;
    @Expose
    private int codCob        = 0;
    private int codProducto   = 0;
    private String descripcion    = "";
    @Expose
    private double sumaMaxima = 0;
    @Expose
    private double sumaMinima = 0;
        
    /** Creates a new instance of codProducto */
    public CoberturaDetalle() {
    }

    public void setcodRama      (int param) {this.codRama       = param; }
    public void setcodSubRama   (int param) {this.codSubRama    = param; }
    public void setcodCob       (int param) {this.codCob        = param; }
    public void setsumaMaxima   (double param) {this.sumaMaxima   = param; }
    public void setsumaMinima   (double param) {this.sumaMinima  = param; }
    public void setdescripcion  (String param) {this.descripcion= param; }
    public void setcodProducto  (int param) {this.codProducto= param;}

    public int getcodRama       () {return  this.codRama;}
    public int getcodSubRama    () {return  this.codSubRama;}
    public int getcodCob        () {return  this.codCob;}
    public double getsumaMaxima () {return  this.sumaMaxima;}
    public double getsumaMinima () {return  this.sumaMinima;}
    public String getdescripcion() {return descripcion; }
    public int getcodProducto   () {return  this.codProducto;}
}
