/*
 * CotizadorAp.java
 *
 * Created on 9 de enero de 2005, 19:37
 */     

package com.business.beans;

import com.google.gson.annotations.Expose;  
   
/**
 *
 * @author Rolando Elisii
 */
public class CotFinanciacion  {
         
    private int numCotizacion        = 0;
    private int codRama              = 0;
    private int codSubRama           = 0;
    private String descRama          = "";
    private String descSubRama       = "";    
    private int cantCuotas           = 0;
 @Expose
    private double premio            = 0;
    private double valorCuota        = 0;
  @Expose
    private String sMensError      = new String();
  @Expose
    private int  iNumError         = 0;
    private int codFacturacion      = 0;
    private String descFacturacion  = "";
  @Expose
    private int cantDias                = 0;
    
    /** Creates a new instance of Cotizador */
    public CotFinanciacion () {
    }   

    public void setnumCotizacion        (int param) { this.numCotizacion      = param; }
    public void setcodRama              (int param) { this.codRama            = param; }
    public void setcodSubRama           (int param) { this.codSubRama         = param; }
    public void setdescRama          (String param) { this.descRama           = param; }
    public void setdescSubRama       (String param) { this.descSubRama        = param; }    
    public void setcantCuotas           (int param) { this.cantCuotas         = param; }
    public void setpremio      (double param) { this.premio  = param; }
    public void setvalorCuota      (double param) { this.valorCuota   = param; }        
    public void setcodFacturacion    (int param) { this.codFacturacion        = param; }
    public void setdescFacturacion   (String param) { this.descFacturacion    = param; }
    public void setcantDias             (int param) { this.cantDias = param; }
    public int getnumCotizacion       () { return this.numCotizacion;}
    public int getcodRama             () { return this.codRama;}
    public int getcodSubRama          () { return this.codSubRama;}
    public String getdescRama         () { return this.descRama;}
    public String getdescSubRama      () { return this.descSubRama;}    
    public int getcantCuotas          () { return this.cantCuotas;}
    public double getpremio      () { return this.premio; }   
    public double getvalorCuota      () { return this.valorCuota; }   
    public int getcodFacturacion      () { return this.codFacturacion;}
    public String getdescFacturacion  () { return this.descFacturacion;}
    public int getcantDias () {return this.cantDias;}
    
    public String getsMensError  () {return this.sMensError ; }
    public void setsMensError  (String psMensError ) {this.sMensError = psMensError;}
    public int getiNumError  () {return this.iNumError;}
    public void setiNumError  (int piNumError ) {this.iNumError  = piNumError;}

}
