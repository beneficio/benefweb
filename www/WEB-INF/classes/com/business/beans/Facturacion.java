/*
 * Vigencia.java
 *
 * Created on 9 de enero de 2005, 19:37
 */

package com.business.beans;
/**
 *
 * @author Rolando Elisii
 */
public class Facturacion {
    
    private int codRama         = 0;
    private int codSubRama      = 0;
    private int codProducto     = 0;
    private int cantDesde       = 0;
    private int cantHasta       = 0;
    private int codFacturacion  = 0;
    private int cantCuotas      = 0;
    private String descFacturacion  = "";
    private int codVigencia     = 0;
    private double impCuota     = 0;
    private double impFacturacion = 0;
    private String sMensError      = new String();
    private int  iNumError         = 0;
    
    /** Creates a new instance of Vigencia */
    public Facturacion() {
    }

    public void setcodRama          (int param) { this.codRama     = param; }
    public void setcantDesde        (int param) { this.cantDesde   = param; }
    public void setcantHasta        (int param) { this.cantHasta   = param; }
    public void setcodFacturacion   (int param) { this.codFacturacion     = param; }
    public void setcantCuotas       (int param) { this.cantCuotas  = param; }
    public void setdescFacturacion  (String param) { this.descFacturacion = param; }    
    public void setcodVigencia      (int param) { this.codVigencia = param; }
    public void setcodSubRama       (int param) { this.codSubRama  = param; }
    public void setcodProducto      (int param) { this.codProducto = param; }
    public void setimpCuota         (double param) { this.impCuota  = param; }
    public void setimpFacturacion   (double param) { this.impFacturacion  = param; }
       
    public int getcodRama               () { return this.codRama;}
    public int getcantDesde             () { return this.cantDesde;}
    public int getcantHasta             () { return this.cantHasta;}
    public int getcodFacturacion        () { return this.codFacturacion;}
    public int getcantCuotas            () { return this.cantCuotas;}
    public String getdescFacturacion    () { return this.descFacturacion;}
    public int getcodVigencia           () { return this.codVigencia;}
    public int getcodSubRama            () { return this.codSubRama;}
    public int getcodProducto           () { return this.codProducto;}
    public double getimpCuota              () { return this.impCuota;}
    public double getimpfacturacion        () { return this.impFacturacion;}
    
    
    public String getsMensError  () {return this.sMensError ;   }
    public void setsMensError  (String psMensError ) {this.sMensError  = psMensError ;}
    public int getiNumError  () {return this.iNumError ; }    
    public void setiNumError  (int piNumError ) { this.iNumError  = piNumError;}
}
