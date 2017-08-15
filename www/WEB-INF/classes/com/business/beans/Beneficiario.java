/*
 * Certificado.java
 *
 * Created on 9 de enero de 2005, 19:37
 */

package com.business.beans;
import java.util.Date;
import java.util.LinkedList; 
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;

import com.business.util.*;
import com.business.db.*;
import com.business.interfaces.*;/**
 *
 * @author Rolando Elisii
 */
public class Beneficiario {
    
    private int numPropuesta   = 0;    
    private int subCertificado = 0;
    private int Certificado    = 0;
    private String numDoc      = "";
    private String tipoDoc     = "";
    private String descTipoDoc = "";
    private int  parentesco    = 0;
    private String razonSocial = "";
    private double  porcentaje = 0;
    private String sMensError  = new String();
    private int  iNumError     = 0;
    private CallableStatement cons  = null;
        
    
    /** Creates a new instance of Certificado */
    public Beneficiario() {
    }

    public void setnumPropuesta     (int param) { this.numPropuesta = param; }
    public void setsubCertificado   (int param) { this.subCertificado = param; }
    public void setCertificado      (int param) { this.Certificado = param; }
    public void setnumDoc           (String param) { this.numDoc = param; }
    public void settipoDoc          (String param) { this.tipoDoc = param; }
    public void setdescTipoDoc      (String param) { this.descTipoDoc = param; }
    public void setparentesco       (int param) { this.parentesco = param; }
    public void setporcentaje       (double param) { this.porcentaje = param; }
    public void setrazonSocial      (String param) { this.razonSocial = param; }

    public int getnumPropuesta      () { return numPropuesta; }
    public int getsubCertificado    () { return subCertificado; }
    public int getCertificado       () { return  this.Certificado;}
    public String getnumDoc         () { return this.numDoc;}
    public String gettipoDoc        () { return this.tipoDoc;}
    public String getdescTipoDoc    () { return this.descTipoDoc;}
    public String getrazonSocial    () { return this.razonSocial;}
    public int getparentesco        () { return  this.parentesco;}
    public double getporcentaje        () { return  this.porcentaje;}
    
    
    public void setsMensError  (String psMensError ) {this.sMensError  = psMensError;}
    public String getsMensError  () {return this.sMensError;}
    public int getiNumError  () {return this.iNumError ;}
    public void setiNumError  (int piNumError ) {this.iNumError  = piNumError;}
   
}
