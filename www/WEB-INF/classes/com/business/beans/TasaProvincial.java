/*
 * TasaProvincial.java
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
public class TasaProvincial {
    
    private int codProvincia     = 0;
    private double tasa          = 0;
    private int numOrden         = 0;
    private Date fechaDesde      = null;
    private String descProvincia = "";
    private String sMensError      = new String();
    private int  iNumError         = 0;
    private int codRama         = 0;
    private int codSubRama      = 0;
    private int codProducto     = 0;
    private double impMinimo    = 0;
    private String baseCalculo  = null;
    private String descProducto = null;
    private String categoriaPersona = null;
    private double baseCalculoMin  = 0;

    private CallableStatement cons = null;
    
    /** Creates a new instance of TasaProvincial */
    public TasaProvincial() {
    }

    public void setcodProvincia        (int param) { this.codProvincia    = param; }
    public void settasa             (double param) { this.tasa            = param; }
    public void setnumOrden            (int param) { this.numOrden        = param; }
    public void setfechaDesde         (Date param) { this.fechaDesde      = param; }
    public void setdescProvincia    (String param) { this.descProvincia   = param; }
    public void setimpMinimo        (double param) { this.impMinimo       = param; }
    public void setcodRama          (int param) { this.codRama         = param; }
    public void setcodSubRama       (int param) { this.codSubRama      = param; }
    public void setcodProducto      (int param) { this.codProducto     = param; }
    public void setbaseCalculo      (String param) { this.baseCalculo  = param; }
    public void setdescProducto     (String param) { this.descProducto  = param; }
    public void setcategoriaPersona (String param) { this.categoriaPersona  = param; }
    public void setbaseCalculoMin   (double param) { this.baseCalculoMin    = param; }
    
    public int getcodProvincia      () { return this.codProvincia;}
    public double gettasa           () { return this.tasa;}
    public int getnumOrden          () { return this.numOrden;}
    public Date   getfechaDesde     () { return this.fechaDesde;}
    public String getdescProvincia  () { return this.descProvincia;}
    public double getimpMinimo      () { return this.impMinimo;}
    public int getcodRama           () { return this.codRama;}
    public int getcodSubRama        () { return this.codSubRama;}
    public int getcodProducto       () { return this.codProducto;}
    public String getbaseCalculo    () { return this.baseCalculo;}
    public String getdescProducto   () { return this.descProducto;}
    public String getcategoriaPersona() { return this.categoriaPersona;}
    public double getbaseCalculoMin () { return this.baseCalculoMin;}
    
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
            cons = dbCon.prepareCall(db.getSettingCall( "ABM_ADD_TASA_PROVINCIAL(?, ?, ?, ?, ?,?,?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt   (2, this.getcodRama() );
            cons.setInt   (3, this.getcodSubRama() );
            cons.setInt   (4, this.getcodProducto() );
            cons.setInt   (5, this.getcodProvincia() );
            cons.setInt   (6, this.getnumOrden() );
            cons.setDouble (7, this.gettasa() );
            cons.setString (8, this.getbaseCalculo());
            cons.setDouble (9, this.getimpMinimo() );
            if (this.getcategoriaPersona() == null) {
                cons.setNull (10, java.sql.Types.VARCHAR);
            } else {
                cons.setString (10, this.getcategoriaPersona());
            }
            cons.setDouble (11, this.getbaseCalculoMin());
            
            cons.execute();
            
            this.setiNumError(cons.getInt (1));
           
      }  catch (SQLException se) { 
		throw new SurException("Error TasaProvincial[setDB]: " + se.getMessage());
        } catch (Exception e) { 
		throw new SurException("Error TasaProvincial[setDB]: " + e.getMessage());
        } finally { 
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }
    
    public TasaProvincial getDB ( Connection dbCon) throws SurException {
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("ABM_GET_TASA_PROVINCIAL (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodProvincia());
            cons.execute();

            ResultSet rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    this.settasa           (rs.getDouble("TASA"));
                    this.setnumOrden       (rs.getInt("NUM_ORDEN"));
                    this.setfechaDesde     (rs.getDate("FECHA_DESDE"));
                    this.setcategoriaPersona(rs.getString ("CATEGORIA_PERSONA"));
                }
                rs.close();
            }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Sql al obtener la cotizacion: " + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error al obtener la cotizacion: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }
}
