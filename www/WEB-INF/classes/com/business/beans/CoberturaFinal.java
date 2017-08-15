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

import com.business.db.*;
import com.business.util.*;
/**
 *
 * @author Rolando Elisii
 */
public class CoberturaFinal {
    
    private String tipoCertificado = "PR";
    private int numCertificado     = 0;
    private int codRama            = 0;
    private int codSubRama         = 0;
    private int codCobFinal        = 0;
    private String descCob         = "";
    private double impSumaRiesgo   = 0;

    private String sMensError           = new String();
    private int  iNumError              = 0;

    
    private CallableStatement cons = null;
    
    /** Creates a new instance of Certificado */
    public CoberturaFinal() {
    }

    public void settipoCertificado (String param) { this.tipoCertificado    = param; }
    public void setnumCertificado     (int param) { this.numCertificado     = param; }
    public void setcodRama            (int param) { this.codRama            = param; }
    public void setcodSubRama         (int param) { this.codSubRama         = param; }
    public void setcodCobFinal        (int param) { this.codCobFinal        = param; }
    public void setimpSumaRiesgo    (double param) { this.impSumaRiesgo   = param; }
    public void setdescCob          (String param) {this.descCob          = param; }

    
    public String gettipoCertificado  () { return tipoCertificado; }
    public int getnumCertificado      () { return  this.numCertificado;}
    public int getcodRama             () { return  this.codRama;}
    public int getcodSubRama          () { return  this.codSubRama;}
    public int getcodCobFinal         () { return  this.codCobFinal;}
    public double getimpSumaRiesgo    () { return  this.impSumaRiesgo;}
    public String getdescCob          () { return descCob; }    

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
