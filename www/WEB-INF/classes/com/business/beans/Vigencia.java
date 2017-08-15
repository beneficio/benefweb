/*
 * Vigencia.java
 *
 * Created on 9 de enero de 2005, 19:37
 */

package com.business.beans;

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
public class Vigencia {
    
    private int codRama         = 0;
    private int codSubRama      = 0;

    @Expose
    private int codVigencia     = 0;

    private int cantCuotas      = 0;
    private int cantMeses       = 0;
    private int cantDias         = 0;

    @Expose
    private String descVigencia  = "";

    private String sMensError      = new String();
    private int  iNumError         = 0;
    private double cuotaMinima     = 0;
    private CallableStatement cons = null;
    
    /** Creates a new instance of Vigencia */
    public Vigencia() {
    }

    public Vigencia(int codigo, String descripcion) {
        this.codVigencia  = codigo;
        this.descVigencia = descripcion;
    }


    public void setcodRama          (int param) { this.codRama     = param; }
    public void setcodSubRama       (int param) { this.codSubRama  = param; }
    public void setcodVigencia      (int param) { this.codVigencia = param; }
    public void setcantCuotas       (int param) { this.cantCuotas  = param; }
    public void setcantDias        (int param) { this.cantDias     = param; }
    public void setcantMeses        (int param) { this.cantMeses = param; }
    public void setdescVigencia    (String param) { this.descVigencia = param; }
    public void setcuotaMinima     (double param) { this.cuotaMinima = param; }
    
    public int getcodRama         () { return this.codRama;}
    public int getcodVigencia     () { return this.codVigencia;}
    public int getcantCuotas      () { return this.cantCuotas;}
    public int getcodSubRama      () { return this.codSubRama;}
    public int getcantDias        () { return this.cantDias;}
    public int getcantMeses       () { return this.cantMeses;}
    public String getdescVigencia () { return this.descVigencia;}
    public double getcuotaMinima  () { return this.cuotaMinima;}
    
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
            cons = dbCon.prepareCall(db.getSettingCall( "ABM_ADD_VIGENCIA(?, ?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt   (2, this.getcodRama() );
            cons.setInt   (3, this.getcodVigencia() );
            cons.setInt   (4, this.getcantCuotas() );
            cons.execute();
       
            this.setiNumError(cons.getInt (1));
  
      }  catch (SQLException se) {
		throw new SurException("Error al grabar las Vigencias: " + se.getMessage());
        } catch (Exception e) {
		throw new SurException("Error al grabar las Vigencias: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }
}
