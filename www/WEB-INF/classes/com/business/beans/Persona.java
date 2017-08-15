/****************************************************************************+
/** Persona
* @author  Gisela Cabot
* @version  Fri Jul 04 11:04:34 ART 2003
*/
// This class belongs to the following package:

package com.business.beans;

import com.business.util.*;
import com.business.interfaces.*;   
import java.io.Serializable;
import java.util.Date;
import java.util.LinkedList;
import java.text.SimpleDateFormat;

import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;

public class Persona implements Serializable {
    
   /** La categoría representa si es una persona Física o Jurídica
   */
    protected String scategoria         = new String("F");
    private java.util.Date dfechaEquipo = new java.util.Date();
    private String susuario             = new String();
    private String sapellido            = new String();
    private String sdoc                 = null;
    private java.util.Date dfechaNac;
    private String snom                 = new String();
    private String ssexo                = new String("M");
    private String stel1                = new String();
    private String stel2                = new String();
    private String stipoDoc             = "96";
    private String sdescTipoDoc         = "DNI";
    private String semail               = new String();
    private String mfax                 = new String();
    private String sDesCondIB           = new String();
    private String sDesCondIVA          = new String();
    private String sCuit                = new String ();
    private String sDesPersona          = new String ();
    private String sMensError           = new String();
    private int  iNumError              = 0;
    private int icodCondIB = 1;
    private int icodCondIVA = 4;
    private java.util.Date dfechaInicAct;
    private String snumIB = new String();
    private String srazonSocial= new String();
    private String  calle             = new String(" ");
    private String  numero            = new String(" ");
    private String  piso              = new String(" ");
    private String  dpto              = new String(" ");
    private String  pcia              = new String(" ");
    private String  pais              = new String(" ");
    private String  localidad         = new String(" ");
    private String  codigoPostal      = new String(" ");
    private String descripcion        = new String(" ");
    private java.util.Date dFechaEquipo = new java.util.Date ();
    private String sDesProvincia      = new String (" ");
    private String sDesPais           = new String (" ");

//****************************************************************************+
/**  Get/Set Methods
*/
   
  /**   Devuelve el código de Persona.
  *   3 = Tomador
  *   4 = Asegurado
  *   2 = Intermediario
  */
       
    public Persona Persona () {
        return this;
    }
  
    public String getCategoria() {
        return scategoria;
    }

    public void setCategoria(String pscategoria) {
        this.scategoria = pscategoria;
    }

    public String getCuit() {
        return sCuit;
    }

    public void setCuit(String psCuit) {
        this.sCuit = psCuit;
    }

    
    public java.util.Date getFechaEquipo() {
        return dfechaEquipo;
    }

    public void setFechaEquipo(java.util.Date mfechaEquipo) {
        this.dfechaEquipo = mfechaEquipo;
    }

    public String getUsuario() {
        return susuario;
    }

    public void setUsuario(String musuario) {
        this.susuario = musuario;
    }
        
    public String getsDesPersona() {
        return sDesPersona;
    }

    public void setsDesPersona(String musuario) {
        this.sDesPersona = musuario;
    }

    public String getEmail() {
        return semail;
    }

    public void setEmail(String psemail) {
        this.semail = psemail;
    }

     public String getFax() {
        return mfax;
    }

    public void setFax(String mfax) {
        this.mfax = mfax;
    }
    
    public String getTel1() {
        return stel1;
    }

    public void setTel1(String  psTelPart) {
        this.stel1 = psTelPart;
    }
    
     public String getTel2() {
        return stel2;
    }

    public void setTel2(String  psTelPart) {
        this.stel2 = psTelPart;
    }

     public String getApellido() {
        return sapellido;
    }

    public void setApellido(String psapellido) {
        this.sapellido = psapellido;
    }
    
    public String getDoc() {
        return sdoc;
    }
    
    public void setDoc(String psdoc) {
        this.sdoc = psdoc;
    }
 
     
    public java.util.Date getFechaNac() {
        return dfechaNac;
    }

    public void setFechaNac(java.util.Date pdfechaNac) {
        this.dfechaNac = pdfechaNac;
    }
    
    public String getNom() {
        return snom;
    }

    public void setNom(String mnom) {
        this.snom = mnom;
    }

    public String getSexo() {
        return ssexo;
    }

    public void setSexo(String pssexo) {
        this.ssexo = pssexo;
    }

    public String getTipoDoc() {
       return stipoDoc;
    }

    public void setTipoDoc(String pstipoDoc) {
       this.stipoDoc = pstipoDoc;
    }    

    public String getdescTipoDoc() {
       return sdescTipoDoc;
    }

    public void setdescTipoDoc(String param) {
       this.sdescTipoDoc = param;
    }    
    
    public int getCodCondIB() {
        return icodCondIB;
    }

    public void setCodCondIB(int picodCondIB) {
        this.icodCondIB = picodCondIB;
    }

    public int getCodCondIVA() {
        return icodCondIVA;
    }

    public void setCodCondIVA(int picodCondIVA) {
        this.icodCondIVA = picodCondIVA;
    }
    
    public java.util.Date getFechaInicAct() {
        return dfechaInicAct;
    }

    public void setFechaInicAct(java.util.Date pdfechaInicAct) {
        this.dfechaInicAct = pdfechaInicAct;
    }
      public String getNumIB() {
        return snumIB;
    }

    public void setNumIB(String psnumIB) {
        this.snumIB = psnumIB;
    }

    public String getRazonSoc() {
        return srazonSocial;
    }

    public void setRazonSoc(String srazonSoc) {
        this.srazonSocial = srazonSoc;
    }

    public String getsMensError  () {
        return this.sMensError ;
    }
    
    public void setsDesCondIB  (String psDesCondIB ) {
        this.sDesCondIB  = psDesCondIB;
    }
    public String getsDesCondIB  () {
        return this.sDesCondIB;
    }
    
    public void setsDesCondIVA  (String psDesCondIVA) {
        this.sDesCondIVA  = psDesCondIVA;
    }
    
    public String getsDesCondIVA () {
        return this.sDesCondIVA;
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
    
// getting y setting de dirección.
    
    public void setCalle(String pcalle)           { this.calle = pcalle; }
    public void setNumero(String pnro)            { this.numero = pnro; }
    public void setPiso(String ppiso)             { this.piso = ppiso; }
    public void setDepto(String pdpto)            { this.dpto = pdpto; }
    public void setPcia(String pcia)              { this.pcia = pcia; }
    public void setPais(String ppais)             { this.pais = ppais; }
    public void setLocalidad(String ploc)         { this.localidad = ploc; }
    public void setCodigoPostal(String pcodP)     { this.codigoPostal = pcodP; }
    public void setdFechaEquipo (java.util.Date pdFecha) { this.dFechaEquipo = pdFecha;}
    public void setsDesProvincia(String psDesProvincia)  { this.sDesProvincia = psDesProvincia; }
    public void setsDesPais(String psDesPais)     { this.sDesPais = psDesPais; }

    public String  getCalle()                     { return(this.calle); }
    public String  getNumero()                    { return(this.numero); }
    public String  getPiso()                      { return(this.piso); }
    public String  getDepto()                     { return(this.dpto); }
    public String  getPcia()                      { return(this.pcia); }
    public String  getPais()                      { return(this.pais); }
    public String  getLocalidad()                 { return(this.localidad); }
    public String  getCodigoPostal()              { return(this.codigoPostal); }
    public String  getDireccion()                 { return(new String(this.calle + " "+ this.numero + " " + this.localidad + " (" + this.codigoPostal + ") " )); }
    public java.util.Date getdFechaEquipo()       { return(this.dFechaEquipo); }  
    public String  getsDesProvincia()             { return(this.sDesProvincia); }
    public String  getsDesPais()                  { return(this.sDesPais); }
    
}
// End of Persona.java

