/*
 * Certificado.java
 * @author Rolando Elisii
 * Created on 9 de enero de 2005, 19:37
 */
     
package com.business.beans;
    
import java.util.Date;
import java.util.LinkedList;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;  
import java.sql.CallableStatement;

import com.business.db.*;
import com.business.util.*;
import java.sql.Types;

public class SeteoProd {
      
    private int codSeteo            = 0;
    private int codRama             = 0;
    private int codSubRama          = 0;
    private int codProd             = 0;
    private String estado           = "";
    private String descProd         = "";
    private double minPrima         = 0;
    private String userId          = "";
    private Date fechaTrabajo      = null;
    private String descRama        = "";
    private String descSubRama     = "";
    private int cantMaxCuotas       = 1;
    private int diaDebito           = 0;
    private double maxComisionCot   = 0;
    private double maxTopePremioCot = 0;
    private double porcRecargoRetenido = 0;
    private String mailGestionDeuda = null;
    private String mcaNoGestionar   = null;
    private String permisoEmision  = null;
    private int limiteEmision = 0;


    private String sMensError       = new String();
    private int  iNumError          = 0;
    
    /** Creates a new instance of Certificado */
    public SeteoProd() {
    }

    public void setcodSeteo         (int param) { this.codSeteo = param; }
    public void setcodRama          (int param) { this.codRama = param; }
    public void setcodSubRama       (int param) { this.codSubRama = param; }
    public void setcodProd          (int param) { this.codProd = param; }
    public void setestado           (String param) { this.estado = param; }
    public void setdescProd         (String param) { this.descProd = param; }
    public void setminPrima         (double param) { this.minPrima = param; }
    public void setdescRama         (String param) { this.descRama      = param; }
    public void setdescSubRama      (String param) { this.descSubRama   = param; }    
    public void setuserId           (String param) { this.userId = param; }
    public void setfechaTrabajo     (Date param) { this.fechaTrabajo = param; }
    public void setcantMaxCuotas    (int param) { this.cantMaxCuotas = param; }
    public void setdiaDebito        (int param) { this.diaDebito = param; }
    public void setmaxComisionCot   (double param) { this.maxComisionCot = param; }
    public void setmaxTopePremioCot (double param) { this.maxTopePremioCot = param; }
    public void setporcRecargoRetenido(double param) { this.porcRecargoRetenido = param; }
    public void setmcaNoGestionar   (String param) { this.mcaNoGestionar = param; }
    public void setmailGestionDeuda (String param) { this.mailGestionDeuda = param; }
    public void setpermisoEmision  (String param) { this.permisoEmision = param; }
    public void setlimiteEmision    (int param) { this.limiteEmision = param; }

    public int getcodSeteo          () { return  this.codSeteo;}
    public int getcodRama           () { return  this.codRama;}
    public int getcodSubRama        () { return  this.codSubRama;}
    public int getcodProd           () { return  this.codProd;}
    public String getestado         () { return this.estado;}
    public String getdescProd       () { return this.descProd;}
    public double getminPrima       () { return this.minPrima;}
    public String getdescRama       () { return this.descRama;}
    public String getdescSubRama    () { return this.descSubRama;}    
    public String getuserId         () { return this.userId;}
    public Date getfechaTrabajo     () { return  this.fechaTrabajo;}
    public int getcantMaxCuotas     () { return  this.cantMaxCuotas;}
    public int  getdiaDebito        () { return  this.diaDebito;}
    public double getmaxComisionCot   () {return this.maxComisionCot; }
    public double getmaxTopePremioCot () {return this.maxTopePremioCot; }
    public double getporcRecargoRetenido() {return this.porcRecargoRetenido; }
    public String getmcaNoGestionar () { return this.mcaNoGestionar; }
    public String getmailGestionDeuda () { return this.mailGestionDeuda; }
    public String getpermisoEmision  () { return this.permisoEmision; }
    public int  getlimiteEmision      () { return  this.limiteEmision;}

    
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

    public SeteoProd getDB ( Connection dbCon) throws SurException {
         ResultSet rs = null;
        CallableStatement cons = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("ABM_GET_SETEO_PROD (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodSeteo());
            cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    this.setcodSeteo      (rs.getInt ("COD_SETEO"));
                    this.setcodProd       (rs.getInt ("COD_PROD"));                    
                    this.setcodRama       (rs.getInt ("COD_RAMA"));
                    this.setcodSubRama    (rs.getInt ("COD_SUB_RAMA"));
                    this.setminPrima      (rs.getDouble("PRIMA_MINIMA"));  
                    this.setcantMaxCuotas (rs.getInt ("CANT_MAX_CUOTAS"));
                    this.setuserId        (rs.getString ("USERID"));
                    this.setdiaDebito     (rs.getInt("DIA_DEBITO"));
                    this.setmaxComisionCot(rs.getDouble ("MAX_COMISION_COT"));
                    this.setmaxTopePremioCot(rs.getDouble ("MAX_TOPE_PREMIO_COT"));
                    this.setporcRecargoRetenido(rs.getDouble ("PORC_RECARGO_RETENIDO"));
                    this.setmailGestionDeuda(rs.getString ("MAIL_GESTION_DEUDA"));
                    this.setmcaNoGestionar (rs.getString ("MCA_NO_GESTIONAR"));
                    this.setlimiteEmision(rs.getInt ("LIMITE_EMISION"));
                    this.setpermisoEmision(rs.getString ("PERMISO_EMISION"));
                }
                rs.close();
            }
           cons.close();
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
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

    public SeteoProd getDBSeteosProductor ( Connection dbCon) throws SurException {
         ResultSet rs = null;
        CallableStatement cons = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_PRODUCTOR_SETEOS (?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodProd());
            cons.setInt (3, this.getcodRama());
            cons.setInt (4, this.getcodSubRama());
            
            cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    this.setcodSeteo      (rs.getInt ("COD_SETEO"));
                    this.setcodProd       (rs.getInt ("COD_PROD"));                    
                    this.setcodRama       (rs.getInt ("COD_RAMA"));
                    this.setcodSubRama    (rs.getInt ("COD_SUB_RAMA"));
                    this.setminPrima      (rs.getDouble("PRIMA_MINIMA"));  
                    this.setcantMaxCuotas (rs.getInt ("CANT_MAX_CUOTAS"));
                    this.setuserId        (rs.getString ("USERID"));
                    this.setdiaDebito     (rs.getInt("DIA_DEBITO"));
                    this.setmaxComisionCot(rs.getDouble ("MAX_COMISION_COT"));
                    this.setmaxTopePremioCot(rs.getDouble ("MAX_TOPE_PREMIO_COT"));
                    this.setporcRecargoRetenido(rs.getDouble ("PORC_RECARGO_RETENIDO"));
                    this.setmailGestionDeuda(rs.getString ("MAIL_GESTION_DEUDA"));
                    this.setmcaNoGestionar (rs.getString ("MCA_NO_GESTIONAR"));
                    this.setlimiteEmision(rs.getInt ("LIMITE_EMISION"));
                    this.setpermisoEmision(rs.getString ("PERMISO_EMISION"));
                }
                rs.close();
            }
           cons.close();
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
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
    
    public SeteoProd getDBnivelSuperior ( Connection dbCon) throws SurException {
         ResultSet rs = null;
        CallableStatement cons = null;
        boolean noExiste = true;
       try {

            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("ABM_GET_SETEO_PROD_SUPERIOR (?, ?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodRama ());
            cons.setInt (3, this.getcodSubRama());
            cons.setInt (4, this.getcodProd ());
            cons.execute();

           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    noExiste = false;
                    this.setcodSeteo      (rs.getInt ("COD_SETEO"));
                    this.setcodProd       (rs.getInt ("COD_PROD"));
                    this.setcodRama       (rs.getInt ("COD_RAMA"));
                    this.setcodSubRama    (rs.getInt ("COD_SUB_RAMA"));
                    this.setminPrima      (rs.getDouble("PRIMA_MINIMA"));
                    this.setcantMaxCuotas (rs.getInt ("CANT_MAX_CUOTAS"));
                    this.setuserId        (rs.getString ("USERID"));
                    this.setdiaDebito     (rs.getInt("DIA_DEBITO"));
                    this.setmaxComisionCot(rs.getDouble ("MAX_COMISION_COT"));
                    this.setmaxTopePremioCot(rs.getDouble ("MAX_TOPE_PREMIO_COT"));
                    this.setporcRecargoRetenido(rs.getDouble ("PORC_RECARGO_RETENIDO"));
                    this.setmailGestionDeuda(rs.getString ("MAIL_GESTION_DEUDA"));
                    this.setmcaNoGestionar (rs.getString ("MCA_NO_GESTIONAR"));
                    this.setlimiteEmision(rs.getInt ("LIMITE_EMISION"));
                    this.setpermisoEmision(rs.getString ("PERMISO_EMISION"));
                }
                rs.close();
            }
           cons.close();

           if (noExiste == true ) {
               this.setiNumError(-100);
           }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
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
    
    public LinkedList getDBCuotas ( Connection dbCon) throws SurException {
         ResultSet rs = null;
         LinkedList lCuotas = null;
        CallableStatement cons = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("ABM_GET_SETEO_ALL_CUOTAS (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodSeteo());
            cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                lCuotas = new LinkedList();
                while (rs.next()) {
                    Vigencia oVig = new Vigencia ();
                    oVig.setcodVigencia (rs.getInt("COD_VIGENCIA"));
                    oVig.setcantCuotas  (rs.getInt("CANT_MAX_CUOTAS"));
                    oVig.setdescVigencia(rs.getString("DESC_VIGENCIA"));
                    oVig.setcuotaMinima (rs.getDouble("CUOTA_MINIMA"));

                    lCuotas.add(oVig);
                }
                rs.close();
            }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
        } finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) { cons.close (); }
                return lCuotas;
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }
    
    public SeteoProd setDB (Connection dbCon )
       throws SurException {
       CallableStatement  cons = null;
       try {         
           dbCon.setAutoCommit(true);
           cons = dbCon.prepareCall(db.getSettingCall("ABM_SET_SETEO_PROD (?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt    (2, this.getcodSeteo());
           cons.setInt    (3,  this.getcodRama   () ); // p_COD_RAMA        ALIAS FOR $3;
           cons.setInt    (4,  this.getcodSubRama() ); // p_COD_SUB_RAMA    ALIAS FOR $4;
           cons.setInt    (5,  this.getcodProd() );
           cons.setString (6, this.getuserId() );     // p_USERID          ALIAS FOR $12;
           cons.setDouble (7,  this.getminPrima() ); // p_MIN_PREMIO      ALIAS FOR $5;
           cons.setInt    (8, this.getcantMaxCuotas());
           cons.setInt    (9, this.getdiaDebito());
           cons.setDouble (10, this.getmaxComisionCot());
           cons.setDouble (11, this.getmaxTopePremioCot());
           cons.setDouble (12, this.getporcRecargoRetenido());
           cons.setString (13, this.getmcaNoGestionar());
           cons.setString (14, this.getmailGestionDeuda());
           if (this.getpermisoEmision() != null && this.getpermisoEmision().equals ("")) { 
                cons.setNull(15, Types.VARCHAR);
           } else {
                cons.setString (15, this.getpermisoEmision());
           }
           cons.setInt    (16, this.getlimiteEmision());
           
           cons.execute();                     
           this.setcodSeteo(cons.getInt (1));
           cons.close ();

       }  catch (SQLException se) {
//           this.setiNumError(-1);
//           this.setsMensError("Error en SeteoProd [setDB]: " + se.getMessage());
           throw new SurException(se.getMessage());
       }  catch (Exception e) {       
//           this.setiNumError(-1);
//           this.setsMensError("Error en SeteoProd [setDB]: " + e.getMessage());
           throw new SurException(e.getMessage());
       } finally {
           try {
               if (cons != null) cons.close();
           } catch (SQLException se) {
               throw new SurException (se.getMessage());
           }
           return this;
       }
    } // setDB      

    public SeteoProd setDBCuotas (Connection dbCon, Vigencia oVig )
       throws SurException {
       CallableStatement  cons = null;
       try {         
           dbCon.setAutoCommit(true);
           cons = dbCon.prepareCall(db.getSettingCall("ABM_SET_SETEO_VIG_CUOTAS (?, ?, ?, ?, ?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt    (2, this.getcodSeteo());
           cons.setInt    (3, oVig.getcodVigencia());
           cons.setInt    (4, oVig.getcantCuotas());
           cons.setString (5, this.getuserId() );
           cons.setDouble (6, oVig.getcuotaMinima());
           
           cons.execute();                     
           this.setcodSeteo(cons.getInt (1));

       }  catch (SQLException se) {
           this.setiNumError(-1);
           this.setsMensError("Error en SeteoProd [setDBCuotas]: " + se.getMessage());
       }  catch (Exception e) {       
           this.setiNumError(-1);
           this.setsMensError("Error en SeteoProd [setDBCuotas]: " + e.getMessage());
       } finally {
           try {
               if (cons != null) cons.close();
           } catch (SQLException se) {
                          //System.out.println(" error 1  " + se.getMessage());
               throw new SurException (se.getMessage());
           }
           return this;
       }
    } // setDB          
    
    // Actualizar Seteo Productor.    
    public void delDBSeteoProd (Connection dbCon )
       throws SurException {
       CallableStatement  cons = null;
       try {          
           
           dbCon.setAutoCommit(true);
           
           cons = dbCon.prepareCall(db.getSettingCall("ABM_DEL_SETEO_PROD (?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt    (2,  this.getcodSeteo ());
           cons.setString (3,  this.getuserId   ());
           
           cons.execute();                      
           
       }  catch (SQLException se) { 
           this.setiNumError(-1);
           this.setsMensError(se.getMessage());
           throw new SurException("Error en PLAN [setDBSeteoProd]: " + se.getMessage());
       }  catch (Exception e) {  
           this.setiNumError(-1);
           this.setsMensError(e.getMessage());
           throw new SurException("Error en PLAN [detDBSeteoProd]: " + e.getMessage());
       } finally {
           try {
               if (cons != null) cons.close();
           } catch (SQLException se) {                          
               throw new SurException (se.getMessage());
           }
           
       }
    } // detDBSeteoProd          
}