/*
 * Asegurado.java
 *
 * Created on 12 de noviembre de 2005, 10:47
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

/**
 *
 * @author Rolando Elisii
 */
public class Asegurado {
    
    private int codRama = 0;
    private int numPoliza = 0;
    private int certificado = 0;
    private int subCertificado = 0;
    private String tipoDoc = null;
    private String descTipoDoc = null;
    private String numDoc  = null;
    private String nombre  = null;
    private String domicilio = null;
    private Date fechaAltaCob = null;
    private Date fechaBaja    = null;
    private int endosoAlta   = 0;
    private int endosoBaja   = 0;
    private String estado    = null;
    private Date fechaFTP  = null;
    private LinkedList lCoberturas = null;
    private int existeAfip = 0;
    private String mcaAfip = null;
    private String sTelefono    = null;
    private Date dFechaNac      = null;
    private int iSueldo         = 0;
    private String sPuesto      = null;
    private String sVigente     = null;
    private String sMensError           = new String();
    private int  iNumError              = 0;
    private CallableStatement cons = null;
  
    /** Creates a new instance of Asegurado */
    public Asegurado() {
    }

    public int getcodRama () { return this.codRama; }
    public int getnumPoliza () { return this.numPoliza; }
    public int getcertificado () { return this.certificado; }
    public int getsubCertificado () { return this.subCertificado; }
    public String gettipoDoc () { return this.tipoDoc; }
    public String getdescTipoDoc () { return this.descTipoDoc; }  
    public String getnumDoc  () { return this.numDoc; }
    public String getnombre  () { return this.nombre; }
    public String getdomicilio () { return this.domicilio; }
    public Date getfechaAltaCob () { return this.fechaAltaCob; }
    public Date getfechaBaja    () { return this.fechaBaja; }
    public int getendosoAlta   () { return this.endosoAlta; }
    public int getendosoBaja   () { return this.endosoBaja; }
    public String getestado    () { return this.estado; }
    public Date getfechaFTP  () { return this.fechaFTP; }
    public LinkedList getCoberturas  () { return this.lCoberturas; }
    public int getexisteAfip   () { return this.existeAfip; }
    public String getmcaAfip  () { return this.mcaAfip; }
    public Date getdFechaNac  () { return this.dFechaNac; }
    public int getiSueldo   () { return this.iSueldo; }
    public String getsTelefono  () { return this.sTelefono; }
    public String getsPuesto () { return this.sPuesto; }
    public String getsVigente () { return this.sVigente; }

    public void setcodRama (int param) { this.codRama = param; }
    public void setnumPoliza (int param) { this.numPoliza= param; }
    public void setcertificado (int param) { this.certificado= param; }
    public void setsubCertificado (int param) { this.subCertificado= param; }
    public void settipoDoc (String param) { this.tipoDoc= param; }
    public void setdescTipoDoc (String param) { this.descTipoDoc= param; }  
    public void setnumDoc  (String param) { this.numDoc= param; }
    public void setnombre  (String param) { this.nombre= param; }
    public void setdomicilio (String param) { this.domicilio= param; }
    public void setfechaAltaCob (Date param) { this.fechaAltaCob= param; }
    public void setfechaBaja    (Date param) { this.fechaBaja= param; }
    public void setendosoAlta   (int param) { this.endosoAlta= param; }
    public void setendosoBaja   (int param) { this.endosoBaja= param; }
    public void setestado    (String param) { this.estado= param; }
    public void setfechaFTP  (Date param) { this.fechaFTP= param; }
    public void setCoberturas  (LinkedList param) { this.lCoberturas = param; }
    public void setexisteAfip   (int param) { this.existeAfip= param; }
    public void setmcaAfip  (String param) { this.mcaAfip= param; }
    public void setdFechaNac  (Date param) { this.dFechaNac = param; }
    public void setiSueldo   (int param) { this.iSueldo = param; }
    public void setsTelefono  (String param) { this.sTelefono = param; }
    public void setsPuesto  (String param) {this.sPuesto = param; }
    public void setsVigente (String param) {this.sVigente = param; }


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
  
    public LinkedList getDBCoberturas ( Connection dbCon) throws SurException {
        LinkedList lCob = new LinkedList();
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PZ_GET_ASEGURADO_COBERTURAS (?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodRama());
            cons.setInt (3, this.getnumPoliza ());
            cons.setInt (4, this.getcertificado());
            cons.setInt (5, this.getsubCertificado());
            cons.execute();
           
            ResultSet rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    AsegCobertura oCob = new AsegCobertura();
                    oCob.setcodCob        (rs.getInt ("COD_COB"));
                    oCob.setimpSumaRiesgo (rs.getDouble ("IMP_SUMA_ASEG"));
                    oCob.setdescCob        (rs.getString ("DESC_COB"));
                    oCob.setimpPrima       (rs.getDouble ("IMP_PRIMA"));
                    lCob.add(oCob);
                }
                rs.close();
            }
            return lCob;
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Asegurado [getDBCoberturas]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error Asegurado [getDBCoberturas]" + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }
  
    public LinkedList getDBCoberturasEnd ( Connection dbCon, int endoso) throws SurException {
        LinkedList lCob = new LinkedList();
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PZ_GET_ASEGURADO_COBERTURAS (?,?,?, ?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodRama());
            cons.setInt (3, this.getnumPoliza ());
            cons.setInt (4, endoso);
            cons.setInt (5, this.getcertificado());
            cons.setInt (6, this.getsubCertificado());
            cons.execute();

            ResultSet rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    AsegCobertura oCob = new AsegCobertura();
                    oCob.setcodCob        (rs.getInt ("COD_COB"));
                    oCob.setimpSumaRiesgo (rs.getDouble ("IMP_SUMA_ASEG"));
                    oCob.setdescCob        (rs.getString ("DESC_COB"));
                    oCob.setimpPrima       (rs.getDouble ("IMP_PRIMA"));
                    lCob.add(oCob);
                }
                rs.close();
            }
            return lCob;
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Asegurado [getDBCoberturas]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error Asegurado [getDBCoberturas]" + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }
  
}

