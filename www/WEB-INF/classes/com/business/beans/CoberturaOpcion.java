/*
 * Certificado.java
 *
 * Created on 9 de enero de 2005, 19:37
 */

package com.business.beans;
     
public class CoberturaOpcion {
    
    private int codCobOpcion    = 0;
    private int codRama         = 0;
    private int codSubRama      = 0;
    private int codProducto     = 0;
    private int codAgrupCob     = 0;
    private String categoria    = "";
    private String descripcion      = "";
    private double impPremioAnual   = 0;
    private double impPremioMensual = 0;
    private String mcaHijos ;
    private int edadMin         = 0;
    private int edadMax         = 0;
    private int edadPermanencia = 0;
    private int edadMinHi         = 0;
    private int edadMaxHi         = 0;
    private int edadPermanenciaHi = 0;
    private int edadMinAd         = 0;
    private int edadMaxAd         = 0;
    private int edadPermanenciaAd = 0;
    private String mcaAdherente = "";

    private String sMensError           = new String();
    private int  iNumError              = 0;
    
    /** Creates a new instance of Certificado */
    public CoberturaOpcion() {   
    }

    public void setcategoria       (String param) {this.categoria      = param;}
    public void setcodProducto     (int param) {this.codProducto       = param;}
    public void setcodRama         (int param) {this.codRama           = param;}
    public void setcodSubRama      (int param) {this.codSubRama        = param;}
    public void setcodCobOpcion    (int param) {this.codCobOpcion      = param;}
    public void setcodAgrupCob     (int param) {this.codAgrupCob       = param;}
    public void setimpPremioAnual  (double param) {this.impPremioAnual = param;}
    public void setimpPremioMensual(double param) {this.impPremioMensual = param;}
    public void setdescripcion     (String param) {this.descripcion    = param;}
    public void setmcaHijos        (String param) {this.mcaHijos       = param;}
    public void setedadMin         (int param) {this.edadMin           = param;}
    public void setedadMax         (int param) {this.edadMax           = param;}
    public void setedadPermanencia (int param) {this.edadPermanencia   = param;}
    public void setedadMinHi         (int param) {this.edadMinHi           = param;}
    public void setedadMaxHi         (int param) {this.edadMaxHi           = param;}
    public void setedadPermanenciaHi (int param) {this.edadPermanenciaHi   = param;}
    public void setedadMinAd         (int param) {this.edadMinAd           = param;}
    public void setedadMaxAd         (int param) {this.edadMaxAd           = param;}
    public void setedadPermanenciaAd (int param) {this.edadPermanenciaAd   = param;}
    public void setmcaAdherente    (String param) {this.mcaAdherente   = param;}

    
    public String getcategoria      () { return categoria; }
    public int getcodProducto       () { return  this.codProducto;}
    public int getcodRama           () { return  this.codRama;}
    public int getcodSubRama        () { return  this.codSubRama;}
    public int getcodCobOpcion      () { return  this.codCobOpcion;}
    public int getcodAgrupCob       () { return  this.codAgrupCob;}
    public double getimpPremioAnual () { return  this.impPremioAnual;}
    public double getimpPremioMensual() { return  this.impPremioMensual;}
    public String getdescripcion    () { return descripcion; }
    public String getmcaHijos       () { return mcaHijos; }
    public int getedadMin           () { return  this.edadMin;}
    public int getedadMax           () { return  this.edadMax;}
    public int getedadPermanencia   () { return  this.edadPermanencia;}
    public int getedadMinHi           () { return  this.edadMinHi;}
    public int getedadMaxHi           () { return  this.edadMaxHi;}
    public int getedadPermanenciaHi   () { return  this.edadPermanenciaHi;}
    public int getedadMinAd           () { return  this.edadMinAd;}
    public int getedadMaxAd           () { return  this.edadMaxAd;}
    public int getedadPermanenciaAd   () { return  this.edadPermanenciaAd;}
    public String getmcaAdherente   () { return mcaAdherente; }

    public String getsMensError  () {
        return this.sMensError ;
    }
    public void setsMensError  (String psMensError ) {
        this.sMensError  = psMensError ;
    }

    public int getiNumError  () {
        return this.iNumError ;
    }
    
    public void setiNumError  (int piNumError ) {
        this.iNumError  = piNumError;
    }
}