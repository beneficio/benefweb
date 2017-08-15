/*
 * Certificado.java
 *
 * Created on 9 de enero de 2005, 19:37
 */

package com.business.beans;
/**
 *
 * @author Rolando Elisii
 */
public class Cobertura {
    
    private String boca = "WEB";
    private int numPropuesta  = 0;
    private int codRama       = 0;
    private int codSubRama    = 0;
    private int codCob        = 0;
    private int certificado   = 0;
    private int subCertificado = 0;
    private String descripcion    = "";
    private double sumaAseg = 0;
        
    /** Creates a new instance of Certificado */
    public Cobertura() {
    }

    public void setboca         (String param) {this.boca       = param; }
    public void setnumPropuesta (int param)    {this.numPropuesta = param; }
    public void setcodRama      (int param) {this.codRama       = param; }
    public void setcodSubRama   (int param) {this.codSubRama    = param; }
    public void setcodCob       (int param) {this.codCob        = param; }
    public void setsumaAseg     (double param) {this.sumaAseg   = param; }
    public void setdescripcion  (String param) {this.descripcion= param; }
    public void setCertificado  (int param) {this.certificado= param;}
    public void setSubCertificado (int param) {this.subCertificado= param;}

    public String getboca       () {return boca; }
    public int getnumPropuesta  () {return  this.numPropuesta;}
    public int getcodRama       () {return  this.codRama;}
    public int getcodSubRama    () {return  this.codSubRama;}
    public int getcodCob        () {return  this.codCob;}
    public double getsumaAseg   () {return  this.sumaAseg;}
    public String getdescripcion() {return descripcion; }
    public int getcertificado   () {return  this.certificado;}
    public int getSubCertificado() {return  this.subCertificado;}
}
