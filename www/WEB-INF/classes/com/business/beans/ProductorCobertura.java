/*
 * ActividadcodCob.java
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
public class ProductorCobertura {
    
    private int codRama         = 0;
    private int codSubRama      = 0;
    private int codProd         = 0;
    private int codCob          = 0;
    private double maxSumaAseg  = 0;
    private double minSumaAseg  = 0;
    private String descripcion  = "";
    private String userId      = "";
    private String mcaBaja     = "";
    private String sMensError   = new String();
    private int  iNumError      = 0;
    private int  numOrden       = 0;

    private CallableStatement cons = null;
    
    /** Creates a new instance of ActividadcodCob */
    public ProductorCobertura() {
    }

    public void setcodRama         (int param) { this.codRama      = param; }
    public void setcodSubRama      (int param) { this.codSubRama   = param; }
    public void setcodProd         (int param) { this.codProd = param; }
    public void setcodCob          (int param) { this.codCob    = param; }
    public void setmaxSumaAseg     (double param) { this.maxSumaAseg    = param; }
    public void setminSumaAseg     (double param) { this.minSumaAseg    = param; }
    public void setdescripcion     (String param) { this.descripcion  = param; }    
    public void setmcaBaja         (String param) { this.mcaBaja  = param; }    
    public void setuserId          (String param) { this.userId  = param; }    
    public void setnumOrden        (int param) { this.numOrden    = param; }
    
    public int getcodRama        () { return this.codRama;}
    public int getcodSubRama     () { return this.codSubRama;}
    public int getcodProd        () { return this.codProd;}
    public int getcodCob         () { return this.codCob;}
    public double getmaxSumaAseg () { return this.maxSumaAseg;}
    public double getminSumaAseg () { return this.minSumaAseg;}
    public String getdescripcion () { return this.descripcion;}
    public String getmcaBaja     () { return this.mcaBaja;}
    public String getuserId      () { return this.userId;}
    public int getnumOrden       () { return this.numOrden; }
    
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
            cons = dbCon.prepareCall(db.getSettingCall( "US_ADD_PRODUCTOR_COBERTURA(?, ?, ?, ?, ?, ?, ?, ?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt    (2, this.getcodRama() );
            cons.setInt    (3, this.getcodSubRama());
            cons.setInt    (4, this.getcodProd() );
            cons.setInt    (5, this.getcodCob() );
            cons.setDouble (6, this.getmaxSumaAseg());
            cons.setString (7, this.getmcaBaja());
            cons.setString (8, this.getuserId());
            cons.setInt    (9, this.getnumOrden ());
            cons.setDouble (10, this.getminSumaAseg());                        
            cons.execute();
       
            this.setiNumError(cons.getInt (1));
       }  catch (SQLException se) {
                this.setiNumError(-1);           
		this.setsMensError( se.getMessage());
                throw new SurException ( se.getMessage());
        } catch (Exception e) {
                this.setiNumError(-1);           
		this.setsMensError( e.getMessage());
		throw new SurException("Error al grabar la Cobertura: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }
}
