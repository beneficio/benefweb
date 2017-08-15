/*
 * Alerta.java
 *
 * Created on 26 de noviembre de 2008, 21:25
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

/**
 *
 * @author Rolando Elisii
 */
public class Alerta {
    
    private int codAlerta   = 0;
    private String titulo   = null;
    private Date fechaDesde = null;
    private Date fechaHasta = null;
    private String mcaBaja  = null;
    private String userId   = null;
    private int tipoUsuario = 0;
    private String sBody = null;
    private String mcaPublica  = null;
    private int alto      = 0;
    private int ancho     = 0;
    
    private String sMensError = null;
    private int  iNumError    = 0;
    
    private CallableStatement cons = null;
  
    public Alerta () {
    }

    public int getcodAlerta () { return this.codAlerta; }
    public String gettitulo () { return this.titulo; }
    public Date getfechaDesde () { return this.fechaDesde; }
    public Date getfechaHasta () { return this.fechaHasta; }
    public String getmcaBaja () { return this.mcaBaja; }
    public String getuserId () { return this.userId; }
    public int gettipoUsuario () { return this.tipoUsuario; }
    public String getsBody () { return this.sBody; }
    public String getmcaPublica () { return this.mcaPublica; }
    public String getsMensError () { return this.sMensError; }
    public int getiNumError     () { return this.iNumError; }
    public int getalto     () { return this.alto; }
    public int getancho     () { return this.ancho; }

    public void setcodAlerta    (int param) { this.codAlerta = param; }
    public void settitulo       (String param) { this.titulo = param; }
    public void setfechaDesde   (Date param) { this.fechaDesde = param; }
    public void setfechaHasta   (Date param) { this.fechaHasta = param; }
    public void setmcaBaja      (String param) { this.mcaBaja = param; }
    public void setuserId       (String param) { this.userId = param; }
    public void settipoUsuario  (int param) { this.tipoUsuario = param; }
    public void setsBody        (String param) { this.sBody = param; }
    public void setmcaPublica   (String param) { this.mcaPublica = param; }    
    public void setsMensError   (String param) { this.sMensError = param; }
    public void setiNumError    (int param) { this.iNumError = param; }
    public void setalto     (int param) { this.alto = param; }
    public void setancho    (int param) { this.ancho = param; }

    public Alerta getDB ( Connection dbCon) throws SurException {
         ResultSet rs = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PUB_GET_ALERTA (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodAlerta());
            cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    this.setcodAlerta       (rs.getInt     ("COD_ALERTA"));
                    this.settipoUsuario     (rs.getInt     ("TIPO_USUARIO"));
                    this.settitulo          (rs.getString  ("TITULO"));
                    this.setsBody           (rs.getString  ("BODY"));
                    this.setmcaPublica      (rs.getString  ("MCA_PUBLICA"));
                    this.setfechaDesde      (rs.getDate    ("FECHA_DESDE"));
                    this.setfechaHasta      (rs.getDate    ("FECHA_HASTA"));
                    this.setalto            (rs.getInt     ("ALTO"));
                    this.setancho           (rs.getInt     ("ANCHO"));
                }
                rs.close();
            }
           cons.close();
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Alerta [getDB]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error Alerta [getDB]" + e.getMessage());
        } finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }
    
    public Alerta setDB (Connection dbCon )
       throws SurException {
       CallableStatement  cons = null;
       try {         
           dbCon.setAutoCommit(true);
           cons = dbCon.prepareCall(db.getSettingCall("PUB_SET_ALERTA (?,?,?,?,?,?,?,?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt    (2,  this.getcodAlerta() );
           cons.setString (3,  this.gettitulo   () );
           cons.setString (4,  this.getsBody    () );
           cons.setInt    (5,  this.gettipoUsuario   () );
           cons.setString (6, this.getmcaPublica() ); 
           cons.setString (7, this.getuserId() );     
           cons.setString (8, this.getmcaBaja() );    
           cons.setDate   (9, Fecha.convertFecha(this.getfechaDesde()) );
           cons.setDate   (10, Fecha.convertFecha(this.getfechaHasta()));
           cons.setInt    (11, this.getalto());
           cons.setInt    (12,this.getancho());
           
           cons.execute();                     
           this.setcodAlerta(cons.getInt (1));
           cons.close();

       }  catch (SQLException se) { 
           this.setiNumError(-1);
           throw new SurException("Error en Alerta [setDB]: " + se.getMessage());
       }  catch (Exception e) {       
           this.setiNumError(-1);
           throw new SurException("Error en Alerta [setDB]: " + e.getMessage());
       } finally {
           try {
               if (cons != null) cons.close();
           } catch (SQLException se) {
           this.setiNumError(-1);
           throw new SurException (se.getMessage());
           }
           return this;
       }
    } // setDB      
    
    
    public Alerta setDBcambiarMcaPublica (Connection dbCon )
       throws SurException {
       CallableStatement  cons = null;
       try {           
           
           dbCon.setAutoCommit(true);
           
           cons = dbCon.prepareCall(db.getSettingCall("PUB_SET_PUBLICA_ALERTA (?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt    (2,  this.getcodAlerta() );
           cons.setString (3, this.getmcaPublica() ); 
           cons.setString (4, this.getuserId() );     

           cons.execute();
                      
           this.setcodAlerta(cons.getInt (1));
           cons.close();

       }  catch (SQLException se) {                 
           throw new SurException("Error en Alerta [setDBcambiarMcaPublica]: " + se.getMessage());
       }  catch (Exception e) {           
           throw new SurException("Error en Alerta [setDBcambiarMcaPublica]: " + e.getMessage());
       } finally {
           try {
               if (cons != null) cons.close();
           } catch (SQLException se) {                          
               throw new SurException (se.getMessage());
           }
           return this;
       }
    } // setDBcambiarMcaPublica
    

}
