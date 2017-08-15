/*
 * Bonificacion.java
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
public class Bonificacion {
    
    private int codRama     = 0;
    private int codSubRama  = 0;
    private int codProducto = 0;
    private int cantPersonasDesde  = 0;
    private int cantPersonasHasta  = 0;
    private double bonificacion    = 0;
    private Date fechaDesde      = null;
    private String sRama    = "";
    private String sSubRama = "";
    private String sProducto= "";

    private String sMensError      = new String();
    private int  iNumError         = 0;

    private CallableStatement cons = null;
    
    /** Creates a new instance of Bonificacion */
    public Bonificacion() {
    }

    public void setcantPersonasDesde      (int param) { this.cantPersonasDesde     = param; }
    public void setcantPersonasHasta      (int param) { this.cantPersonasHasta     = param; }
    public void setbonificacion           (double param) { this.bonificacion       = param; }
    public void setfechaDesde             (Date param) { this.fechaDesde           = param; }
    public void setcodRama                (int param) { this.codRama     = param; }
    public void setcodSubRama             (int param) { this.codSubRama  = param; }
    public void setcodProducto            (int param) { this.codProducto = param; }
    public void setsRama                  (String param) { this.sRama       = param; } 
    public void setsSubRama               (String param) { this.sSubRama    = param; } 
    public void setsProducto              (String param) { this.sProducto   = param; } 
    
    public int getcantPersonasDesde         () { return this.cantPersonasDesde ;}
    public int getcantPersonasHasta         () { return this.cantPersonasHasta ;}
    public double getbonificacion           () { return this.bonificacion      ;}
    public Date getfechaDesde               () { return this.fechaDesde        ;}
    public int getcodRama                   () { return this.codRama ;}
    public int getcodSubRama                () { return this.codSubRama ;}
    public int getcodProducto               () { return this.codProducto ;}
    public String getsRama                  () { return this.sRama;}
    public String getsSubRama               () { return this.sSubRama;}
    public String getsProducto              () { return this.sProducto;}
    
    
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
            cons = dbCon.prepareCall(db.getSettingCall( "ABM_ADD_BONIFICACION(?, ?, ?, ?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt   (2, this.getcodRama());
            cons.setInt   (3, this.getcodSubRama());
            cons.setInt   (4, this.getcodProducto());
            cons.setInt   (5, this.getcantPersonasDesde() );
            cons.setInt   (6, this.getcantPersonasHasta() );
            cons.setDouble(7, this.getbonificacion() );
            
            if (this.getfechaDesde() == null)
                cons.setNull(8, java.sql.Types.DATE);
            else
                cons.setDate(8, Fecha.convertFecha(this.getfechaDesde()));
            cons.execute();
       
            this.setiNumError(cons.getInt (1));
      }  catch (SQLException se) {
		throw new SurException("Error en Bonificacion[setDB]: " + se.getMessage());
        } catch (Exception e) {
		throw new SurException("Error en Bonificacion[setDB]: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }

    public void delDB (Connection dbCon) throws SurException {
    
      try {
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall( "ABM_DEL_BONIFICACION(?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt (2, this.getcodRama());
            cons.setInt (3, this.getcodSubRama());
            cons.setInt (4, this.getcodProducto());
            
            cons.execute();
            
            this.setiNumError(cons.getInt (1));
           
      }  catch (SQLException se) {
		throw new SurException("Error en Bonificacion[delDB]: " + se.getMessage());
        } catch (Exception e) {
		throw new SurException("Error en Bonificacion[delDB]: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }
    
}
