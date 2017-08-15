/*
 * Certificado.java
 *
 * Created on 9 de enero de 2005, 19:37
 */

package com.business.beans;

import java.util.Date;
import java.util.LinkedList;  
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;

import com.business.util.*;
import com.business.db.*;     

public class PersonaCertificado {
    
    private String tipoCertificado  = "";
    private int numCertificado      = 0;
    private String numDoc      = "";
    private String tipoDoc          = "";
    private String descTipoDoc      = "";
    private int numTomador          = 0;
    private int codCondicionIVA     = 0;
    private String razonSocial      = "";
    private String codPostal        = "";
    private String domicilio        = "";
    private String localidad        = "";    
    private String provincia        = "";    
    private String cuit             = "";
    private Date fechaAlta          = null;
    private Date fechaBaja          = null;
    private String estado           = null;
    private int item                = 0;
    private int subItem             = 0;
    private int parentesco          = 0;
    private String descParentesco   = "";
    private LinkedList lAsegurados  = null;
    private LinkedList lCoberturas  = null;
    private String sMensError       = new String();
    private int  iNumError          = 0;
    
    /** Creates a new instance of Certificado */
    public PersonaCertificado() {
    }

    public void settipoCertificado      (String param) { this.tipoCertificado = param; }
    public void setnumCertificado    (int param) { this.numCertificado = param; }
    public void setnumTomador   (int param) { this.numTomador = param; }
    public void setcodCondicionIVA (int param) { this.codCondicionIVA = param; }
    public void setnumDoc       (String param) { this.numDoc = param; }
    public void settipoDoc      (String param) { this.tipoDoc = param; }
    public void setdescTipoDoc  (String param) { this.descTipoDoc = param; }
    public void setrazonSocial      (String param) { this.razonSocial = param; }
    public void setcodPostal        (String param) { this.codPostal = param; }
    public void setdomicilio        (String param) { this.domicilio = param; }
    public void setlocalidad        (String param) { this.localidad = param; }
    public void setprovincia        (String param) { this.provincia = param; }
    public void setcuit             (String param) { this.cuit = param; }
    public void setlAsegurados      (LinkedList param) { this.lAsegurados = param; }
    public void setlCoberturas      (LinkedList param) { this.lCoberturas = param; }
    public void setestado           (String param) { this.estado = param; }
    public void setitem             (int param) { this.item = param; }
    public void setsubItem             (int param) { this.subItem = param; }
    public void setparentesco       (int param) { this.parentesco       = param; }
    public void setdescParentesco   (String param) {this.descParentesco= param; }
    public void setfechaAlta        (Date param) {this.fechaAlta = param; }
    
    public String gettipoCertificado    () { return tipoCertificado; }
    public int getnumCertificado     () { return  this.numCertificado;}
    public int getnumTomador    () { return  this.numTomador;}
    public int getcodCondicionIVA () { return  this.codCondicionIVA;}
    public String getnumDoc     () { return this.numDoc;}
    public String gettipoDoc    () { return this.tipoDoc;}
    public String getdescTipoDoc() { return this.descTipoDoc;}
    public String getrazonSocial() { return this.razonSocial;}
    public String getcodPostal        () { return this.codPostal;}
    public String getdomicilio        () { return this.domicilio;}
    public String getlocalidad        () { return this.localidad;}
    public String getprovincia        () { return this.provincia;}
    public String getcuit             () { return this.cuit;}
    public LinkedList getlAsegurados  () { return this.lAsegurados;}
    public LinkedList getlCoberturas  () { return this.lCoberturas;}
    public String getestado           () { return this.estado;}
    public int getitem                () { return this.item;}
    public int getsubItem             () { return this.subItem;}
    public int getparentesco          () { return  this.parentesco;}
    public String getdescParentesco   () { return  this.descParentesco;}
    public Date getfechaAlta          () { return this.fechaAlta;}
    
    public void setsMensError  (String psMensError ) {
        this.sMensError  = psMensError ;
    }

    public int getiNumError  () {
        return this.iNumError ;
    }

    public String getsMensError () {
        return this.sMensError; 
    }
    
    public void setiNumError  (int piNumError ) {
        this.iNumError  = piNumError;
    }
    
    public PersonaCertificado getDBTomador ( Connection dbCon) throws SurException {
       CallableStatement cons = null;
       ResultSet rs = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("CE_CERTIFICADO_TOMADOR (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString (2, this.gettipoCertificado());
            cons.setInt (3, this.getnumCertificado());
            cons.execute();
           
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    this.settipoDoc     (rs.getString ("TIPO_DOC"));
                    this.setdescTipoDoc(rs.getString ("DESC_TIPO_DOC"));
                    this.setnumDoc      (rs.getString ("NUM_DOC"));
                    this.setrazonSocial (rs.getString ("RAZON_SOCIAL"));
                    this.setcuit        (rs.getString ("CUIT"));
                    this.setdomicilio   (rs.getString ("DOMICILIO"));
                    this.setlocalidad   (rs.getString ("LOCALIDAD"));
                    this.setcodPostal   (rs.getString ("COD_POSTAL"));
                    this.setprovincia   (rs.getString ("PROVINCIA"));
                }
                rs.close();
            }
            cons.close();
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
        } finally {
            try{
                if (rs != null)  rs.close ();
                if (cons != null)  cons.close (); 
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }
    public LinkedList getDBCoberturasAseg ( Connection dbCon) throws SurException {
       LinkedList lCob = new LinkedList ();
       CallableStatement cons = null;
       ResultSet rs = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("CE_GET_ALL_ASEGURADO_COB (?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString (2, this.gettipoCertificado());
            cons.setInt (3, this.getnumCertificado());
            cons.setInt (4, this.getitem());
            cons.setInt (5, this.getsubItem());
 
            cons.execute();
           
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    AsegCobertura oCob = new AsegCobertura ();
                    oCob.settipoCertificado (rs.getString ("TIPO_CERTIFICADO"));
                    oCob.setnumCertificado  (rs.getInt    ("NUM_CERTIFICADO"));
                    oCob.settipoDoc         (rs.getString ("TIPO_DOC"));
                    oCob.setnumDoc          (rs.getString  ("NUM_DOC"));
                    oCob.setcodCob          (rs.getInt ("COD_COB"));
                    oCob.setimpSumaRiesgo   (rs.getDouble ("IMP_SUMA_RIESGO")); 
                    oCob.setdescCob         (rs.getString ("COBERTURA"));
                    oCob.setitem            (rs.getInt ("ITEM"));
                    oCob.setsubItem         (rs.getInt ("SUB_ITEM"));
                    oCob.setnombre          (rs.getString ("RAZON_SOCIAL"));
                    oCob.setparentesco      (rs.getInt("PARENTESCO"));
                    oCob.setdescParentesco  (rs.getString ("DESC_PARENTESCO"));
                    lCob.add (oCob);
                }
                rs.close();
            }
            cons.close ();
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
        } finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) cons.close (); 
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return lCob;    
        }
    }

    public LinkedList getDBBeneficiarios ( Connection dbCon) throws SurException {
       LinkedList lAseg = new LinkedList ();
       CallableStatement cons = null;
       ResultSet rs = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("CE_GET_ALL_ASEGURADO_BENEF (?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString (2, this.gettipoCertificado());
            cons.setInt (3, this.getnumCertificado());
            cons.setString (4, this.gettipoDoc());
            cons.setString (5, this.getnumDoc());

            cons.execute();

            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    AsegBeneficiario oAseg = new AsegBeneficiario();
                    oAseg.settipoCertificado (rs.getString ("TIPO_CERTIFICADO"));
                    oAseg.setnumCertificado  (rs.getInt    ("NUM_CERTIFICADO"));
                    oAseg.settipoDoc         (rs.getString ("TIPO_DOC"));
                    oAseg.setnumDoc          (rs.getString  ("NUM_DOC"));
                    oAseg.setdescTipoDoc     (rs.getString ("DESC_TIPO_DOC"));
                    oAseg.settipoDocBenef    (rs.getString ("TIPO_DOC_BENEF"));
                    oAseg.setdescTipoDocBenef(rs.getString("DESC_TIPO_DOC_BENEF"));
                    oAseg.setnumDocBenef     (rs.getString ("NUM_DOC_BENEF"));
                    oAseg.setrazonSocial     (rs.getString ("RAZON_SOCIAL"));
                    lAseg.add (oAseg);
                }
                rs.close();
            }
            cons.close ();
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
        } finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) cons.close ();
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return lAseg;
        }
    }
}
