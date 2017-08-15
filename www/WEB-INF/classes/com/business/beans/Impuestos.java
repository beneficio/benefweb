/*
 * Impuestos.java
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
public class Impuestos {
    
    private int codRama          = 0;
    private int codSubRama       = 0;
    private int codImpuesto      = 0;
    private double valor         = 0;
    private String tipoValor     = "";
    private Date fechaDesde      = null;
    private String descImpuesto  = "";
    private String descRama      = "";
    private String descSubRama   = "";
    private double valorProduccion = 0;
    private String sMensError    = new String();
    private int  iNumError         = 0;

    private CallableStatement cons = null;
    
    /** Creates a new instance of Impuestos */
    public Impuestos() {
    }

    public void setcodRama         (int param) { this.codRama      = param; }
    public void setcodSubRama      (int param) { this.codSubRama   = param; }
    public void setcodImpuesto     (int param) { this.codImpuesto  = param; }
    public void setvalor           (double param) { this.valor     = param; }
    public void settipoValor       (String param) { this.tipoValor = param; }
    public void setfechaDesde      (Date param) { this.fechaDesde  = param; }
    public void setdescImpuesto    (String param) { this.descImpuesto = param; }    
    public void setdescRama        (String param) { this.descRama = param; }    
    public void setdescSubRama     (String param) { this.descSubRama = param; }
    public void setvalorProduccion (double param) { this.valorProduccion = param; }    
    
    public int getcodRama         () { return this.codRama;}
    public int getcodSubRama         () { return this.codSubRama;}    
    public int getcodImpuesto     () { return this.codImpuesto;}
    public double getvalor        () { return this.valor;}
    public String gettipoValor    () { return this.tipoValor;}
    public Date   getfechaDesde   () { return this.fechaDesde;}
    public String getdescImpuesto () { return this.descImpuesto;}
    public String getdescRama     () { return this.descRama;}
    public String getdescSubRama  () { return this.descSubRama;}    
    public double getvalorProduccion() { return this.valorProduccion;}
    
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
            cons = dbCon.prepareCall(db.getSettingCall( "ABM_ADD_IMPUESTOS(?, ?, ?, ?, ?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt   (2, this.getcodRama() );
            cons.setInt   (3, this.getcodSubRama());
            cons.setInt   (4, this.getcodImpuesto() );
            cons.setDouble(5, this.getvalor() );
            cons.setString(6, this.gettipoValor() );
            if (this.getfechaDesde() == null)
                cons.setNull(7, java.sql.Types.DATE);
            else
                cons.setDate(7, Fecha.convertFecha(this.getfechaDesde()));
            
            cons.execute();
       
            this.setiNumError(cons.getInt (1));
        
      }  catch (SQLException se) {
		throw new SurException("Error al grabar los impuestos: " + se.getMessage());
        } catch (Exception e) {
		throw new SurException("Error al grabar los impuestos: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }
    
}
