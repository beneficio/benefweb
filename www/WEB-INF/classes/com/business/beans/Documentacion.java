/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.business.beans;

import java.sql.ResultSet;
import java.sql.Connection;   
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.util.LinkedList;
import com.business.util.*;
import com.business.db.db;
import java.util.Date;
/**
 *
 * @author relisii
 */
public class Documentacion {
    private int numDocumento = 0;
    private int numPropuesta = 0;
    private int codRama      = 0;
    private int numPoliza    = 0;
    private Date fechaTrabajo = null; 
    private String horaTrabajo = null;
    private int numSiniestro  = 0;
    private String nomArchivo = "";
    private String mcaBaja    = "";
    private String userid     = "";
    private int codProd       = 0;
    private int numTomador    = 0;    
    private int    codError   = 0;
    private String descError   = "";
    private int tipoDocumento = 0; 
    private int certificado   = 0;
    private int subCertificado = 0;
    private String descTipoDoc = "";
// 1:ficha, 1:DESIGN. BENEFICIARIO
    
    
    public Documentacion () {
    }    

    public int    getnumDocumento     (){ return this.numDocumento;}
    public int    getNumPropuesta   (){ return this.numPropuesta;}
    public int    getCodRama        (){ return this.codRama;}
    public int    getNumPoliza      (){ return this.numPoliza;}
    public int    getCodProd        (){ return this.codProd; }    
    public Date   getFechaTrabajo   (){ return this.fechaTrabajo;  }
    public String   getHoraTrabajo    (){ return this.horaTrabajo;  }
    public String getUserid         (){ return this.userid;  }
    public int    getNumTomador     (){ return this.numTomador;}
    public String getnomArchivo     (){ return this.nomArchivo;  }
    public String getmcaBaja        (){ return this.mcaBaja;  }
    public int    getNumSiniestro   (){ return this.numSiniestro;}
    public int    getCodError       (){ return this.codError; }
    public String getDescError      (){ return this.descError; }     
    public int    gettipoDocumento  (){ return this.tipoDocumento;}
    public int    getcertificado    (){ return this.certificado;}
    public int    getsubCertificado (){ return this.subCertificado;}
    public String getDescTipoDoc    (){ return this.descTipoDoc; }     
    
    
    public void setnumDocumento   ( int    param ) {  this.numDocumento = param ;}
    public void setNumPropuesta   ( int param ) {  this.numPropuesta= param ;}
    public void setCodRama        ( int param ) {  this.codRama= param ;}
    public void setNumPoliza      ( int param ) {  this.numPoliza= param ;}
    public void setCodProd        ( int param) {   this.codProd= param ; }    
    public void setFechaTrabajo   ( Date param) {     this.fechaTrabajo= param ;  }
    public void setHoraTrabajo    ( String param) {     this.horaTrabajo= param ;  }
    public void setUserid         ( String param ) {  this.userid= param ;  }
    public void setNumSiniestro   ( int param ) {  this.numSiniestro    = param ;}
    public void setnomArchivo     ( String param ) {  this.nomArchivo   = param ;  }
    public void setmcaBaja        ( String param ) {  this.mcaBaja      = param ;  }
    public void setNumTomador     ( int param )   {  this.numTomador    = param ; }   
    public void setCodError       ( int  param  ){ this.codError        = param; }
    public void setDescError      (String param) { this.descError       = param; }
    public void settipoDocumento  ( int param ) {  this.tipoDocumento   = param ;}    
    public void setsubCertificado ( int param ) {  this.subCertificado  = param ;}    
    public void setcertificado    ( int param ) {  this.certificado     = param ;}    
    public void setDescTipoDoc    (String param) { this.descTipoDoc     = param; }
    
             
    public void setDB(Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {       
           dbCon.setAutoCommit(true);

           cons = dbCon.prepareCall(db.getSettingCall( "DOC_SET_DOCUMENTO (?,?,?,?,?,?,?,?,?,?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getnumDocumento());
           cons.setInt              (3, this.getCodRama());
           cons.setInt              (4, this.getNumPropuesta());           
           cons.setInt              (5, this.getNumPoliza());
           cons.setInt              (6, this.getCodProd());
           cons.setInt              (7, this.getNumTomador());
           cons.setInt              (8, this.getNumSiniestro());
           cons.setString           (9, this.getUserid());           
           cons.setString           (10, this.getnomArchivo());
           cons.setString           (11, this.getmcaBaja());
           cons.setInt              (12, this.gettipoDocumento());
           cons.setInt              (13, this.getcertificado());
           cons.setInt              (14, this.getsubCertificado());

           cons.execute();
           this.setnumDocumento(cons.getInt (1));                        
                       
        }  catch (SQLException se) {
            this.setCodError(-1);
            this.setDescError(se.getMessage());
        } catch (Exception e) {
            this.setCodError(-1);
            this.setDescError(e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
        }
    }         

}
