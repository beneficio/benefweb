/*
 * CLausula.java
 *
 * Created on 16 de octubre de 2007, 08:31
 */

package com.business.beans;

import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Connection;   
import java.sql.SQLException;
import java.sql.CallableStatement;

import java.text.*;
import java.util.LinkedList;
import com.business.util.*;
import com.business.db.db;
/**
 *
 * @author  Rolando Elisii
 */
public class Clausula {
    
    private String tipoCertificado = "PZ";
    private int numCertificado     = 0;    
    private String boca = "WEB";
    private int numPropuesta = 0;
    private int codClausula = 0;
    private String descClausula = "";
    private String cuitEmpresa;
    private String descEmpresa = "";
    private int  numItem    = 0;
    
    /** Creates a new instance of CLausula */
    public Clausula() {
    }
    
    public void settipoCertificado (String param) { this.tipoCertificado    = param; }
    public void setnumCertificado     (int param) { this.numCertificado     = param; }
    public String gettipoCertificado  () { return tipoCertificado; }
    public int getnumCertificado      () { return  this.numCertificado;}
    
    public String getboca  (){ return this.boca; } 
    public int getnumPropuesta () { return this.numPropuesta; }
    public String getcuitEmpresa  (){ return this.cuitEmpresa; } 
    public String getdescEmpresa  (){ return this.descEmpresa; } 
    public int getnumItem () { return this.numItem; }
    
    public void setboca         ( String param ) {  this.boca = param ; } 
    public void setnumPropuesta (int param) {this.numPropuesta = param; }
    public void setcuitEmpresa  ( String param ) {  this.cuitEmpresa = param ; } 
    public void setdescEmpresa  ( String param ) {  this.descEmpresa = param ; } 
    public void setnumItem      (int param) {this.numItem = param; }
    
    public Clausula setDB(Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {       
            
           dbCon.setAutoCommit(true);
           
           cons = dbCon.prepareCall(db.getSettingCall( "PRO_SET_CLAUSULA_EMPRESA (?, ?, ?, ?, ?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setString           (2, this.getboca());
           cons.setInt              (3, this.getnumPropuesta());           
           cons.setString           (4, this.getcuitEmpresa());
           cons.setString           (5, this.getdescEmpresa());
           cons.setInt              (6,  this.getnumItem());
           
           cons.execute();                       
        }  catch (SQLException se) {
            throw new SurException("Error SQL Clausula[setDB]: " + se.getMessage());
        } catch (Exception e) {
            throw new SurException("Error Java Clausula[setDB]: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    } 
    
    public Clausula delDB(Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {       
            
           dbCon.setAutoCommit(true);
           
           cons = dbCon.prepareCall(db.getSettingCall( "PRO_DEL_CLAUSULA_EMPRESA (?, ?, ?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setString           (2, this.getboca());
           cons.setInt              (3, this.getnumPropuesta());           
           cons.setInt              (4,  this.getnumItem());
           
           cons.execute();                       
        }  catch (SQLException se) {
            throw new SurException("Error SQL Clausula[delDB]: " + se.getMessage());
        } catch (Exception e) {
            throw new SurException("Error Java Clausula[delDB]: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    } 
    
    public Clausula setDBCertificado (Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {       
            
           dbCon.setAutoCommit(true);
           
           cons = dbCon.prepareCall(db.getSettingCall( "CE_SET_CLAUSULA_EMPRESA (?, ?, ?, ?, ?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setString           (2, this.gettipoCertificado());
           cons.setInt              (3, this.getnumCertificado());           
           cons.setString           (4, this.getcuitEmpresa());
           cons.setString           (5, this.getdescEmpresa());
           cons.setInt              (6,  this.getnumItem());
           
           cons.execute();                       
        }  catch (SQLException se) {
            throw new SurException("Error SQL Clausula[setDB]: " + se.getMessage());
        } catch (Exception e) {
            throw new SurException("Error Java Clausula[setDB]: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    } 
    
    public Clausula delDBCertificado (Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {       
            
           dbCon.setAutoCommit(true);
           
           cons = dbCon.prepareCall(db.getSettingCall( "CE_DEL_CLAUSULA_EMPRESA (?, ?, ?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setString           (2, this.gettipoCertificado());
           cons.setInt              (3, this.getnumCertificado());           
           cons.setInt              (4,  this.getnumItem());
           
           cons.execute();                       
        }  catch (SQLException se) {
            throw new SurException("Error SQL Clausula[delDB]: " + se.getMessage());
        } catch (Exception e) {
            throw new SurException("Error Java Clausula[delDB]: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    }     
}
