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
/**
 *
 * @author Rolando Elisii
 */
public class OpcionAjusteDet {
    
    private int codOpcion       = 0;
    private int codProd         = 0;
    private double porcAjuste   = 0;
    private Date fechaTrabajo   = null;
    private String userid       = "";
    private String operacion  = "";
    private String descProd   = null;
    
    private String sMensError      = new String();
    private int  iNumError         = 0;

    private CallableStatement cons = null;
    
    /** Creates a new instance of porcAjuste */
    public OpcionAjusteDet() {
    }

    public void setcodOpcion    (int param) { this.codOpcion       = param; }
    public void setcodProd      (int param) { this.codProd         = param; }
    public void setporcAjuste   (double param) { this.porcAjuste   = param; }
    public void setfechaTrabajo (Date param) { this.fechaTrabajo   = param; }
    public void setoperacion       (String param) { this.operacion  = param; }
    public void setuserid       (String param) { this.userid       = param; }
    public void setdescProd  (String param) { this.descProd  = param; }

    public int getcodOpcion      () { return this.codOpcion ;}
    public int getcodProd        () { return this.codProd ;}
    public double getporcAjuste  () { return this.porcAjuste;}
    public Date getfechaTrabajo  () { return this.fechaTrabajo;}
    public String getoperacion      () { return this.operacion;}
    public String getuserid      () { return this.userid;}
    public String getdescProd () { return this.descProd;}
    
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
            cons = dbCon.prepareCall(db.getSettingCall( "ABM_SET_OPCION_AJUSTE_DET (?, ?, ?, ?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt    (2, this.getcodOpcion() );
            cons.setInt    (3, this.getcodProd() );
            cons.setString (4, this.getuserid());
            cons.setDouble (5, this.getporcAjuste() );
            cons.setString (6, this.getoperacion());
            
            cons.execute ();
            this.setiNumError(cons.getInt (1));
      }  catch (SQLException se) {
            this.setiNumError(-1);
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
}
