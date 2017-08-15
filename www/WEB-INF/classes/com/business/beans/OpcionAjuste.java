/*
 * porcAjuste.java
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

import com.google.gson.annotations.Expose;

/**
 *
 * @author Rolando Elisii
 */
public class OpcionAjuste {


    @Expose
    private int codOpcion       = 0;
    private int codRama         = 0;
    private int codSubRama         = 0;
    private String descRama        = "";
    private String descSubRama     = "";    
    private double porcAjuste   = 0;
    private Date fechaTrabajo   = null;
    private String userid       = "";

    @Expose
    private String descripcion  = "";
    private String mcaPublica   = null;
    private int codAmbito       = 0;    
    private LinkedList lopcionAjusteDet    = null;
    private int codRebaja       = 0;
    private int codRecargo      = 0;
    
    private String sMensError      = new String();
    private int  iNumError         = 0;

    private CallableStatement cons = null;
    
    /** Creates a new instance of porcAjuste */
    public OpcionAjuste() {
    }

    public void setcodOpcion    (int param) { this.codOpcion       = param; }
    public void setcodRama      (int param) { this.codRama         = param; }
    public void setporcAjuste   (double param) { this.porcAjuste   = param; }
    public void setfechaTrabajo (Date param) { this.fechaTrabajo   = param; }
    public void setdescripcion  (String param) { this.descripcion  = param; }
    public void setuserid       (String param) { this.userid       = param; }
    public void setmcaPublica   (String param) { this.mcaPublica   = param; }
    public void setdescRama     (String param) { this.descRama = param; }
    public void setlopcionAjusteDet (LinkedList param) { this.lopcionAjusteDet = param; }
    public void setcodSubRama   (int param) { this.codSubRama         = param; }
    public void setdescSubRama  (String param) { this.descSubRama = param; }
    public void setcodAmbito    (int param) { this.codAmbito    = param; }
    public void setcodRebaja    (int param) { this.codRebaja    = param; }
    public void setcodRecargo   (int param) { this.codRecargo   = param; }
    
    public int getcodOpcion      () { return this.codOpcion ;}
    public int getcodRama        () { return this.codRama ;}
    public int getcodSubRama     () { return  this.codSubRama;}    
    public double getporcAjuste  () { return this.porcAjuste;}
    public Date getfechaTrabajo  () { return this.fechaTrabajo;}
    public String getdescripcion () { return this.descripcion;}
    public String getuserid      () { return this.userid;}   
    public String getmcaPublica  () { return this.mcaPublica;}
    public String getdescRama    () { return this.descRama;}
    public String getdescSubRama () { return this.descSubRama;}
    public int getcodAmbito      () { return this.codAmbito;}
    public int getcodRebaja      () { return this.codRebaja ;}
    public int getcodRecargo     () { return this.codRecargo ;}

    public LinkedList getlopcionAjusteDet () { return this.lopcionAjusteDet; }
    
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
    
    public void setDB (Connection dbCon) throws SurException {
    
      try {          
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall( "ABM_SET_OPCION_AJUSTE (?,?, ?, ?, ?,?,?,?, ?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt   (2, this.getcodOpcion() );
            cons.setInt   (3, this.getcodRama() );
            cons.setInt   (4, this.getcodSubRama() );            
            cons.setString (5, this.getdescripcion());
            cons.setString (6, this.getuserid());
            
            if (this.getmcaPublica().equals ("")) {
                cons.setNull(7, java.sql.Types.VARCHAR);
            } else {
                cons.setString (7, this.getmcaPublica());
            }
            cons.setDouble(8, this.getporcAjuste() );
            cons.setInt   (9, this.getcodAmbito());
            cons.setInt   (10, this.getcodRebaja());
            cons.setInt   (11, this.getcodRecargo());
            
            cons.execute();
            
            this.setcodOpcion ( cons.getInt (1));
      }  catch (SQLException se) {
                this.setiNumError( -1 );
                this.setsMensError(se.getMessage());
		throw new SurException("Error al grabar las porcAjustees: " + se.getMessage());
        } catch (Exception e) {
                this.setiNumError(-1);
                this.setsMensError(e.getMessage());
                throw new SurException("Error al grabar las porcAjustees: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }
    
    public OpcionAjuste getDB ( Connection dbCon) throws SurException {
        ResultSet rs = null;
      CallableStatement cons2 = null;
       ResultSet rs2 = null;
        
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("ABM_GET_OPCION_AJUSTE (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt(2, this.getcodOpcion());
            cons.execute();
             
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    this.setcodRama             (rs.getInt ("COD_RAMA"));
                    this.setcodSubRama          (rs.getInt ("COD_SUB_RAMA"));
                    this.setdescripcion         (rs.getString ("DESCRIPCION")); 
                    this.setmcaPublica          (rs.getString ("MCA_PUBLICA"));                     
                    this.setporcAjuste          (rs.getDouble ("PORC_AJUSTE"));
                    this.setuserid              (rs.getString ("USERID"));
                    this.setcodAmbito           (rs.getInt ("COD_AMBITO"));
                    this.setcodRebaja           (rs.getInt ("COD_REBAJA"));
                    this.setcodRecargo          (rs.getInt ("COD_RECARGO"));
                }
                rs.close();
                
                lopcionAjusteDet = new LinkedList();
                
                cons2 = dbCon.prepareCall(db.getSettingCall("ABM_GET_ALL_OPCION_AJUSTE_DET (?)"));
                cons2.registerOutParameter(1, java.sql.Types.OTHER);
                cons2.setInt(2, this.getcodOpcion());
                cons2.execute();

                rs2 = (ResultSet) cons2.getObject(1);
                if (rs2 != null) {
                    while (rs2.next()) {
                        OpcionAjusteDet oOpcionDet = new OpcionAjusteDet ();
                        oOpcionDet.setcodOpcion    (this.getcodOpcion());
                        oOpcionDet.setcodProd      (rs2.getInt ("COD_PROD"));
                        oOpcionDet.setdescProd     (rs2.getString ("DESCRIPCION")); 
                        oOpcionDet.setporcAjuste   (rs2.getDouble ("PORC_AJUSTE"));
                        oOpcionDet.setuserid       (rs2.getString ("USERID"));
                        lopcionAjusteDet.add(oOpcionDet);
                    }
                    rs2.close();
                }
            }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error en OpcionAjuste[getDB]: " + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error en OpcionAjuste[getDB]: " + e.getMessage());
        } finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) cons.close (); 
                if (rs2 != null) rs2.close ();
                if (cons2 != null) cons2.close ();
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }
}
