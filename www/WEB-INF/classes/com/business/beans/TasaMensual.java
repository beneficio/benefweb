/*
 * TasaMensual.java
 *
 * Created on 1 de agosto de 2006, 17:13
 */

package com.business.beans;

import java.util.Date;
import java.util.LinkedList;
import java.util.Hashtable;
  
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
 * @author  relisii
 */
public class TasaMensual {
    
    private int codRama = 0;
    private int codSubRama = 0;
    private int codCob = 0;    
    private int codAmbito = 0;
    private int categoria = 0;
    private double tasa = 0;
    private Date fechaDesde = null;
    private String sMensError  = "";
    private int  iNumError     = 0;
    private CallableStatement cons = null;
    
    /** Creates a new instance of TasaMensual */
    public TasaMensual() {
    }

    public void setcodRama     (int param) { this.codRama    = param; }
    public void setcodSubRama     (int param) { this.codSubRama    = param; }    
    public void setcodCob     (int param) { this.codCob    = param; }    
    public void setcategoria     (int param) { this.categoria    = param; }        
    public void setcodAmbito    (int param) { this.codAmbito   = param; }            
    public void settasa             (double param) { this.tasa            = param; }
    public void setfechaDesde         (Date param) { this.fechaDesde      = param; }

    public int getcodRama             () { return this.codRama;}
    public int getcodSubRama           () { return this.codSubRama;}
    public int getcodAmbito           () { return this.codAmbito;}
    public int getcodCob            () { return this.codCob;}    
    public int getcategoria           () { return this.categoria;}
    public double gettasa           () { return this.tasa;}
    public Date   getfechaDesde     () { return this.fechaDesde;}
    
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
            cons = dbCon.prepareCall(db.getSettingCall( "ABM_ADD_TASA_MENSUAL(?, ?, ?, ?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt   (2, this.getcodRama());
            cons.setInt   (3, this.getcodSubRama() );
            cons.setInt   (4, this.getcodCob() );
            cons.setInt   (5, this.getcategoria() );            
            cons.setInt   (6, this.getcodAmbito());            
            cons.setDouble(7, this.gettasa () );            
            if (this.getfechaDesde() == null)
                cons.setNull(8, java.sql.Types.DATE);
            else
                cons.setDate(8, Fecha.convertFecha(this.getfechaDesde()));
            
            cons.execute();
            
            this.setiNumError(cons.getInt (1));
      }  catch (SQLException se) {
		throw new SurException("Error al grabar tasa provincial: " + se.getMessage());
        } catch (Exception e) {
		throw new SurException("Error al grabar tasa provincial: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }

}
