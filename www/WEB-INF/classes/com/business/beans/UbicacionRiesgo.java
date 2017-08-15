/*
 * UbicacionRiesgo.java
 *
 * Created on 26 de marzo de 2006, 23:03
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

import com.business.util.*;
import com.business.db.*;
import com.business.interfaces.*;

/**
 *
 * @author Rolando Elisii
 */
public class UbicacionRiesgo {
    
    private int codRama       = 0;
    private int numPoliza      = 0;
    private int endoso         = 0;
    private String codPostal   = "";
    private String domicilio   = "";
    private String localidad   = "";    
    private String provincia   = "";    
    private String descProvincia = "";
    private int codProceso     = 1;
    private String boca        = "WEB";
    private int numPropuesta   =  0;
    private String igualTomador = "S";
    private int codLocalidad;
    
    private String sMensError       = "";
    private int  iNumError          = 0;
    private CallableStatement cons  = null;
    
    /** Creates a new instance of Certificado */
    public UbicacionRiesgo () {
    }

    public void setcodRama      (int param) { this.codRama = param; }
    public void setnumPoliza    (int param) { this.numPoliza = param; }
    public void setendoso       (int param) { this.endoso = param; }
    public void setcodPostal        (String param) { this.codPostal = param; }
    public void setdomicilio        (String param) { this.domicilio = param; }
    public void setlocalidad        (String param) { this.localidad = param; }
    public void setprovincia        (String param) { this.provincia = param; }
    public void setdescProvincia    (String param) { this.descProvincia = param; }

    public void setcodProceso   (int param) { this.codProceso      = param; }
    public void setnumPropuesta (int param) { this.numPropuesta    = param; }
    public void setboca         (String param) { this.boca         = param; }
    public void setigualTomador (String param) { this.igualTomador = param; }    
    public void setcodLocalidad (int param) { this.codLocalidad    = param; }
    
    public int getcodRama    () { return codRama; }
    public int getnumPoliza     () { return  this.numPoliza; }
    public int getendoso        () { return  this.endoso; }    
    public String getcodPostal        () { return this.codPostal;}
    public String getdomicilio        () { return this.domicilio;}
    public String getlocalidad        () { return this.localidad;}
    public String getprovincia        () { return this.provincia;}
    public String getdescProvincia    () { return this.descProvincia;}    

    public int getcodProceso    () { return codProceso; }
    public int getnumPropuesta  () { return  this.numPropuesta; }
    public String getboca       () { return this.boca;}
    public String getigualTomador () { return this.igualTomador;}
    public int getcodLocalidad  () { return codLocalidad; }
    
    public void setsMensError  (String psMensError ) {
        this.sMensError  = psMensError ;
    }

    public int getiNumError  () {
        return this.iNumError ;
    }
    
    public void setiNumError  (int piNumError ) {
        this.iNumError  = piNumError;
    }

    public String getsMensError  () {
        return this.sMensError;
    }
   
    public UbicacionRiesgo getDB ( Connection dbCon) throws SurException {
       ResultSet rs = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PZ_GET_UBICACION_RIESGO (?, ?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodRama ());
            cons.setInt (3, this.getnumPoliza ());            
            cons.setInt (4, this.getendoso ());            
            cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    this.setcodRama     (rs.getInt ("COD_RAMA"));
                    this.setnumPoliza   (rs.getInt ("NUM_POLIZA"));
                    this.setendoso      (rs.getInt ("ENDOSO"));
                    this.setdomicilio   (rs.getString ("DOMICILIO_RIESGO"));
                    this.setlocalidad   (rs.getString ("LOCALIDAD_RIESGO"));
                    this.setcodPostal   (rs.getString ("COD_POSTAL"));
                    this.setprovincia   (rs.getString ("PROVINCIA_RIESGO"));
                    this.setdescProvincia(rs.getString ("DESC_PROVINCIA"));
                }
                rs.close();
            }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Sql al obtener el usuario: " + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error al obtener el usuario: " + e.getMessage());
        } finally {
            try{
                if (rs != null)  rs.close (); 
                if (cons != null)  cons.close (); 
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }

    public UbicacionRiesgo getDBPropuesta ( Connection dbCon) throws SurException {
       ResultSet rs = null;
       boolean bExiste = false;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PRO_GET_UBICACION_RIESGO (?, ?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt    (2, this.getcodProceso ());
            cons.setString (3, this.getboca ());            
            cons.setInt    (4, this.getnumPropuesta ());            
            cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    this.setdomicilio   (rs.getString ("DOMICILIO_RIESGO"));
                    this.setlocalidad   (rs.getString ("LOCALIDAD_RIESGO"));
                    this.setcodPostal   (rs.getString ("COD_POSTAL"));
                    this.setprovincia   (rs.getString ("PROVINCIA_RIESGO"));
                    this.setdescProvincia(rs.getString ("DESC_PROVINCIA"));
                    this.setigualTomador(rs.getString ("IGUAL_TOMADOR"));
                    this.setcodLocalidad(rs.getInt    ("COD_LOCALIDAD"));
                    
                    bExiste = true;
                }
                rs.close();
            }
            cons.close ();
           if ( ! bExiste ) {
            this.setiNumError( -100);
           }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
        } finally {
            try{
                if (rs != null)  rs.close (); 
                if (cons != null)  cons.close (); 
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }
    
    public UbicacionRiesgo setDBPropuesta (Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {                   
           dbCon.setAutoCommit(true);           
           cons = dbCon.prepareCall(db.getSettingCall( "PRO_SET_UBICACION_RIESGO ( ?,?,?,?,?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getcodProceso());
           cons.setString           (3, this.getboca());
           cons.setInt              (4, this.getnumPropuesta());           
           cons.setString           (5, this.getcodPostal());
           cons.setString           (6, this.getdomicilio());           
           cons.setString           (7, this.getlocalidad());
           cons.setString           (8, this.getprovincia());
           cons.setString           (9, this.getigualTomador());
           
           cons.execute();
                      
        }  catch (SQLException se) {
            System.out.println("error " + se.getMessage());
            throw new SurException("Error SQL UbicacionRiesgo [setDBPropuesta]: " + se.getMessage());
        } catch (Exception e) {
            System.out.println("error " + e.getMessage());
            throw new SurException("Error Java: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    }                    
}