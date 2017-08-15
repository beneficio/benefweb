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
import com.business.db.*;
import com.business.util.*;
import java.io.*;


public class LoteEmisionDetalle {
    
    private int codRama          = 0;
    private int numPoliza        = 0;
    private int numPolizaAnt     = 0;
    private int numPropuesta     = 0;
    private String numDocTom     = "";
    private Date fechaEmision    = null;
    private int estadoProp       = 0;
    private String descEstadoPropuesta = "";
    private String observacion   = ""; 
    private String userId        = "";
    private Date fechaTrabajo    = null;
    private int numLote          = 0;
 
    private String sMensError      = "";
    private int  iNumError         = 0;
    private CallableStatement cons = null;
    
    /** Creates a new instance of Certificado */
    public LoteEmisionDetalle () {
    }

    public void setfechaEmision     (Date param) { this.fechaEmision = param; }
    public void setcodRama          (int param) { this.codRama = param; }
    public void setestadoProp       (int param) { this.estadoProp = param; }
    public void setnumPoliza        (int param) { this.numPoliza  = param; }
    public void setnumPolizaAnt     (int param) { this.numPolizaAnt  = param; }
    public void setnumPropuesta     (int param) { this.numPropuesta  = param; }
    public void setnumDocTom        (String param) { this.numDocTom = param; }
    public void setobservacion      (String param) { this.observacion      = param; }
    public void setuserId           (String param) { this.userId = param; }
    public void setfechaTrabajo     (Date param) { this.fechaTrabajo = param; }
    public void setnumLote          (int param ){ numLote       = param; }
    public void setdescEstadoPropuesta   (String param) { this.descEstadoPropuesta = param; }

    public Date getfechaEmision     () { return  this.fechaEmision;}
    public int getcodRama           () { return  this.codRama;}
    public int getnumPoliza         () { return this.numPoliza;}    
    public int getnumPolizaAnt      () { return this.numPolizaAnt;}    
    public int getnumPropuesta      () { return this.numPropuesta;}
    public String getnumDocTom      () { return this.numDocTom; }
    public String getobservacion    () { return this.observacion;}
    public int getestadoProp        () { return this.estadoProp ; }
    public String getuserId         () { return this.userId;}
    public Date getfechaTrabajo     () { return  this.fechaTrabajo;}
    public int    getnumLote       () {return this.numLote; }
    public String getsMensError  () { return this.sMensError;}
    public void setsMensError  (String psMensError ) {this.sMensError = psMensError;}
    public int getiNumError  () {return this.iNumError;}
    public void setiNumError  (int piNumError ) {this.iNumError  = piNumError;}
    public String getdescEstadoPropuesta      () { return this.descEstadoPropuesta; }



    public void setDB ( Connection dbCon) throws SurException {
       try {
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall("EMI_BATCH_SET_CONTROL (?,?,?,?,?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt (2, this.getnumLote());
            cons.setInt (3, this.getestadoProp());
            cons.setInt (4, this.getcodRama());
            cons.setInt (5, this.getnumPolizaAnt());
            cons.setInt (6, this.getnumPropuesta());
            cons.setString (7, this.getobservacion());
            cons.setInt (8, this.getnumPoliza());
            cons.setString (9, this.getnumDocTom());
            cons.execute();

            this.setiNumError(cons.getInt (1));

        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error LoteEmisionDetalle [setDB]:" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error LoteEmisionDetalle [setDB]:" + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }

    public void setDBAnularProp ( Connection dbCon) throws SurException {
       try {
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall("EMI_BATCH_SET_ANULAR_PROP (?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt (2, this.getnumLote());
            cons.setInt (3, this.getnumPropuesta());
            cons.setString (4, this.getuserId());
            cons.execute();

            this.setiNumError(cons.getInt (1));

        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }

    public void setDBEmitirPropOnLine ( Connection dbCon) throws SurException {
       try {
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall("EMI_BATCH_SET_PROP_ONLINE (?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt (2, this.getnumLote());
            cons.setInt (3, this.getnumPropuesta());
            cons.setString (4, this.getuserId());
            cons.execute();

            this.setiNumError(cons.getInt (1));

        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }

    public LoteEmisionDetalle getDB ( Connection dbCon) throws SurException {
        ResultSet rs = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("EMI_BATCH_GET_DETALLE (?, ?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getnumLote());
            cons.setInt (3, this.getcodRama());
            cons.setInt (4, this.getnumPolizaAnt());

            cons.execute();

            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    this.setnumPropuesta (rs.getInt ("NUM_PROPUESTA"));
                    this.setfechaTrabajo (rs.getDate("FECHA_TRABAJO"));
                    this.setobservacion  (rs.getString ("OBSERVACIONES"));
                    this.setnumPoliza    (rs.getInt ("NUM_POLIZA"));
                    this.setnumDocTom    (rs.getString ("NUM_DOC_TOM"));
                    this.setestadoProp   (rs.getInt ("ESTADO"));
                    this.setdescEstadoPropuesta(rs.getString ("DESC_ESTADO"));
                }
                rs.close();
            }

        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error LoteEmisionDetalle [getDB]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error LoteEmisionDetalle [getDB]" + e.getMessage());
        } finally {
            try{
                if (rs != null) { rs.close (); }
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }

}


