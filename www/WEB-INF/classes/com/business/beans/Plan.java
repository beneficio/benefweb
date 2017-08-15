/*
 * Certificado.java
 *
 * Created on 9 de enero de 2005, 19:37
 */
        
package com.business.beans;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.LinkedList;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;  
import java.sql.CallableStatement;

import com.business.db.*;
import com.business.util.*;

public class Plan {
    
    private int codRama             = 0;
    private int codSubRama          = 0;
    private int codPlan             = 0;
    private String estado           = "";
    private String descripcion      = "";
    private double minPremio        = 0;
    private double minPremioAux     = 0;
    private double minCuota         = 1;
    private double minPrima         = 0;
    private double comisionMax       = 0;
    private String mcaPublica      = "";    
    private String condiciones      = "";    
    private String medidaSeg        = "";    
    
    private int codAmbito           = 0;
    private int codVigencia         = 0;
    private int codActividad        = 0;
    
    private Date fechaFTP          = null;   
    private String userId          = "";
    private Date fechaTrabajo      = null;
    private String descRama        = "";
    private String descSubRama     = "";
    private int cantMaxCuotas       = 1;
    private double franquicia      = 0;
    private int codProducto     = 0;
    private int codAgrupCobertura = 0;
    private int cantDias         = 0;

    private LinkedList lProductores   = null;
    private LinkedList lCostos  = null;
    private LinkedList lSumas    = null;

    private String sMensError           = new String();
    private int  iNumError              = 0;
    private CallableStatement cons = null;
    
    /** Creates a new instance of Certificado */
    public Plan() {
    }

    public void setcodRama          (int param) { this.codRama = param; }
    public void setcodSubRama       (int param) { this.codSubRama = param; }
    public void setcodPlan          (int param) { this.codPlan = param; }
    public void setestado           (String param) { this.estado = param; }
    public void setdescripcion      (String param) { this.descripcion = param; }    

    public void setminPremio        (double param) { this.minPremio = param; }
    public void setminPremioAux     (double param) { this.minPremioAux = param; }
    public void setdescRama         (String param) { this.descRama      = param; }
    public void setdescSubRama      (String param) { this.descSubRama   = param; }    
    public void setfechaFTP         (Date param) { this.fechaFTP = param; }
    public void setCostos           (LinkedList param) { this.lCostos = param; }
    public void setSumas            (LinkedList param) { this.lSumas   = param; }
    public void setuserId           (String param) { this.userId = param; }
    public void setfechaTrabajo     (Date param) { this.fechaTrabajo = param; }
    public void setAllProductores   (LinkedList param) {this.lProductores = param;}    
    public void setcantMaxCuotas    (int param) { this.cantMaxCuotas = param; }
    public void setfranquicia       (double param) { this.franquicia = param; }
    public void setcodProducto      (int param) { this.codProducto = param; }
    public void setcodAgrupCobertura(int param) { this.codAgrupCobertura = param; }
    public void setcantDias         (int param) { this.cantDias = param; }
    
    public int getcodRama             () { return  this.codRama;}
    public int getcodSubRama          () { return  this.codSubRama;}
    public int getcodPlan             () { return  this.codPlan;}
    public String getestado           () { return this.estado;}
    public String getdescripcion      () { return this.descripcion;}    
    public double getminPremio        () { return this.minPremio;}
    public double getminPremioAux     () { return this.minPremioAux;}
    public String getdescRama         () { return this.descRama;}
    public String getdescSubRama      () { return this.descSubRama;}    
    public LinkedList getCostos       () { return this.lCostos; }        
    public LinkedList getSumas        () { return this.lSumas; }  
    public String getuserId           () { return this.userId;}
    public Date getfechaTrabajo       () { return  this.fechaTrabajo;}
    public Date getfechaFTP           () { return  this.fechaFTP;}
    public LinkedList getAllProductores () {return lProductores;}
    public int getcantMaxCuotas       () { return  this.cantMaxCuotas;}
    public double getfranquicia       () { return this.franquicia;}
    public int getcodProducto             () { return  this.codProducto;}
    public int getcodAgrupCobertura  () { return  this.codAgrupCobertura;}
    public int getcantDias           () { return  this.cantDias;}
   
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
    
    
    // 
    public void   setminCuota        (double param) { this.minCuota = param; }
    public double getminCuota        ()             { return this.minCuota;  }
    
    public void   setminPrima        (double param) { this.minPrima = param; }
    public double getminPrima        ()             { return this.minPrima;  }    
    
    public void   setcomisionMax      (double param) { this.comisionMax = param; }
    public double getcomisionMax      ()             { return this.comisionMax;  }        
    
    
    public void   setmcaPublica      (String param) { this.mcaPublica = param; }
    public String getmcaPublica      ()             { return this.mcaPublica;  }        
    
    public void   setcondiciones    (String param) { this.condiciones = param; }
    public String getcondiciones    ()             { return this.condiciones;  }            

    public void   setmedidaSeg    (String param) { this.medidaSeg = param; }
    public String getmedidaSeg    ()             { return this.medidaSeg;  }                

    public Plan getDB ( Connection dbCon) throws SurException {
        Date oTime = new Date();
        GregorianCalendar gc = new GregorianCalendar();
        gc.setTime(oTime);
         ResultSet rs = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_PLAN (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodPlan());
            cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    this.setcodRama             (rs.getInt     ("COD_RAMA"));
                    this.setcodSubRama          (rs.getInt     ("COD_SUB_RAMA"));
                    this.setestado              (rs.getString  ("ESTADO"));
                    this.setminPremio           (rs.getDouble  ("MIN_PREMIO"));
                    this.setdescripcion         (rs.getString  ("DESCRIPCION"));
                    this.setminCuota            (rs.getDouble  ("MIN_CUOTA"));
                    this.setminPrima            (rs.getDouble  ("MIN_PRIMA"));
                    this.setcomisionMax          (rs.getDouble ("COMISION_MAX"));
                    this.setestado              (rs.getString  ("ESTADO"));
                    this.setmcaPublica          (rs.getString  ("MCA_PUBLICA"));
                    this.setcondiciones         (rs.getString  ("CONDICIONES")); 
                    this.setmedidaSeg           (rs.getString  ("MEDIDA_SEG"));  
                    this.setcantMaxCuotas       (rs.getInt     ("CANT_MAX_CUOTAS"));
                    
                    this.setcodAmbito           (rs.getInt     ("COD_AMBITO"));  
                    this.setcodVigencia         (rs.getInt     ("COD_VIGENCIA"));  
                    this.setfranquicia          (rs.getDouble  ("FRANQUICIA"));
                    this.setcodActividad        (rs.getInt     ("COD_ACTIVIDAD"));
                    this.setcodProducto         (rs.getInt     ("COD_PRODUCTO"));
                    this.setcodAgrupCobertura   (rs.getInt     ("COD_AGRUP_COB"));
                    this.setminPremioAux        (rs.getDouble  ("MIN_PREMIO_AUX"));
                    this.setcantDias            (rs.getInt     ("CANT_DIAS"));
                }
                rs.close();
            }
           cons.close();
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Plan [getDB]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error Plan [getDB]" + e.getMessage());
        } finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) cons.close (); 
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }
    
    public Plan setDB (Connection dbCon )
       throws SurException {
       
       try {         
           dbCon.setAutoCommit(true);
           cons = dbCon.prepareCall(db.getSettingCall("ABM_PL_SET_PLAN (?, ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt    (2,  this.getcodPlan() );
           cons.setString (3,  this.getdescripcion() ); // p_DESCRIPCION     ALIAS FOR $2;
           cons.setInt    (4,  this.getcodRama   () ); // p_COD_RAMA        ALIAS FOR $3;
           cons.setInt    (5,  this.getcodSubRama() ); // p_COD_SUB_RAMA    ALIAS FOR $4;
           cons.setDouble (6,  this.getminPremio() ); // p_MIN_PREMIO      ALIAS FOR $5;
           cons.setDouble (7,  this.getminCuota() ); // p_MIN_CUOTA       ALIAS FOR $6;
           cons.setDouble (8,  this.getminPrima() );   // p_MIN_PRIMA       ALIAS FOR $7;
           cons.setDouble (9,  this.getcomisionMax() ); // p_COMISION_MAX    ALIAS FOR $8;
           cons.setString (10, this.getcondiciones() ); // p_CONDICIONES     ALIAS FOR $9;
           cons.setString (11, this.getmedidaSeg() );   // p_MEDIDA_SEG      ALIAS FOR $10;
           cons.setString (12, this.getmcaPublica() ); // p_MCA_PUBLICA     ALIAS FOR $11;
           cons.setString (13, this.getuserId() );     // p_USERID          ALIAS FOR $12;
           cons.setString (14, this.getestado() );    // p_ESTADO          ALIAS FOR $13;
           cons.setInt    (15, this.getcodAmbito() );    // p_AMBITO          ALIAS FOR $14;
           cons.setInt    (16, this.getcodVigencia() );    // p_VIGENCIA        ALIAS FOR $15;
           cons.setInt    (17, this.getcodActividad());    // p_VIGENCIA        ALIAS FOR $15;
           cons.setInt    (18, this.getcantMaxCuotas());
           cons.setDouble (19, this.getfranquicia());
           cons.setInt    (20, this.getcodProducto());
           cons.setInt    (21, this.getcodAgrupCobertura());
           cons.setDouble (22, this.getminPremioAux());
           cons.setInt    (23, this.getcantDias());
           
           cons.execute();                     
           this.setcodPlan(cons.getInt (1));                      

       }  catch (SQLException se) {
           this.setiNumError(-1);
           this.setsMensError(se.getMessage());
       }  catch (Exception e) {       
           this.setiNumError(-1);
           this.setsMensError(e.getMessage());
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
    
    
    public Plan setDBcambiarMcaPublica (Connection dbCon )
       throws SurException {
       try {           
           
           dbCon.setAutoCommit(true);
           
           cons = dbCon.prepareCall(db.getSettingCall("ABM_PL_CAMBIAR_MCA_PUBLICAR (?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt    (2,  this.getcodPlan() );
           cons.setString (3, this.getmcaPublica() ); 
           cons.setString (4, this.getuserId() );     

           cons.execute();
                      
           this.setcodPlan(cons.getInt (1)); 

       }  catch (SQLException se) {                 
           throw new SurException("Error en PLAN [setDBcambiarMcaPublica]: " + se.getMessage());
       }  catch (Exception e) {           
           throw new SurException("Error en PLAN [setDBcambiarMcaPublica]: " + e.getMessage());
       } finally {
           try {
               if (cons != null) cons.close();
           } catch (SQLException se) {                          
               throw new SurException (se.getMessage());
           }
           return this;
       }
    } // setDBcambiarMcaPublica
    
    // Actualizar Plan Productor.    
    public void setDBPlanProd (PlanProductor oProd ,Connection dbCon )
       throws SurException {
       try {          
           
           dbCon.setAutoCommit(true);
           
           cons = dbCon.prepareCall(db.getSettingCall("ABM_PL_SET_PLAN_PROD (?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt    (2,  this.getcodPlan() );
           cons.setInt    (3,  oProd.getcodProd() ); 
           cons.setString (4,  oProd.getuserId() );                
           cons.setDouble (5,  oProd.getcomisionMax() );
           
           cons.execute();           
           this.setcodPlan(cons.getInt (1)); 
           
           
       }  catch (SQLException se) {                                
           throw new SurException("Error en PLAN [setDBPlanProd]: " + se.getMessage());
       }  catch (Exception e) {           
           throw new SurException("Error en PLAN [setDBPlanProd]: " + e.getMessage());
       } finally {
           try {
               if (cons != null) cons.close();
           } catch (SQLException se) {                          
               throw new SurException (se.getMessage());
           }
           // return this;
       }
    } // setDBPlanProd
    
    
    // Actualizar Plan Productor.    
    public void delDBPlanProd (PlanProductor oProd ,Connection dbCon )
       throws SurException {
       try {          
           
           dbCon.setAutoCommit(true);
           
           cons = dbCon.prepareCall(db.getSettingCall("ABM_PL_DEL_PLAN_PROD (?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt    (2,  this.getcodPlan() );
           cons.setInt    (3,  oProd.getcodProd() );            
           cons.execute();           
           this.setcodPlan(cons.getInt (1)); 
           
           
       }  catch (SQLException se) {                                
           throw new SurException("Error en PLAN [setDBPlanProd]: " + se.getMessage());
       }  catch (Exception e) {           
           throw new SurException("Error en PLAN [detDBPlanProd]: " + e.getMessage());
       } finally {
           try {
               if (cons != null) cons.close();
           } catch (SQLException se) {                          
               throw new SurException (se.getMessage());
           }
           
       }
    } // detDBPlanProd    
    
    // 03-08-2008
    // Actualizar Plan Suma.    
    public void setDBPlanSuma (PlanSuma oSuma ,Connection dbCon )
       throws SurException {
       try {          
           
           dbCon.setAutoCommit(true);
           
           cons = dbCon.prepareCall(db.getSettingCall("ABM_PL_SET_PLAN_SUMA (?,?,?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt    (2,  this.getcodPlan() );
           cons.setInt    (3,  oSuma.getcodCob() ); 
           cons.setString (4,  oSuma.getuserId() );                
           cons.setDouble (5,  oSuma.getminSumAseg() );
           cons.setDouble (6,  oSuma.getmaxSumAseg() );
           cons.setString (7,  oSuma.getMcaCobIncluida() );
           
           cons.execute();           
           this.setcodPlan(cons.getInt (1)); 
           
           
       }  catch (SQLException se) {                                
           throw new SurException("Error en PLAN [setDBPlanSuma]: " + se.getMessage());
       }  catch (Exception e) {           
           throw new SurException("Error en PLAN [setDBPlanSuma]: " + e.getMessage());
       } finally {
           try {
               if (cons != null) cons.close();
           } catch (SQLException se) {                          
               throw new SurException (se.getMessage());
           }
           // return this;
       }
    }
    
    /** Getter for property codAmbito.
     * @return Value of property codAmbito.
     *
     */
    public int getcodAmbito() {
        return codAmbito;
    }
    
    /** Setter for property codAmbito.
     * @param codAmbito New value of property codAmbito.
     *
     */
    public void setcodAmbito(int codAmbito) {
        this.codAmbito = codAmbito;
    }
    
    /** Getter for property codVigencia.
     * @return Value of property codVigencia.
     *
     */
    public int getcodVigencia() {
        return codVigencia;
    }
    
    /** Setter for property codVigencia.
     * @param codVigencia New value of property codVigencia.
     *
     */
    public void setcodVigencia(int codVigencia) {
        this.codVigencia = codVigencia;
    }
    
 // 
    
    
    public PlanCosto getDBCosto (PlanCosto oCosto , Connection dbCon) throws SurException {
        Date oTime = new Date();
        GregorianCalendar gc = new GregorianCalendar();
        gc.setTime(oTime);
         ResultSet rs = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("ABM_PL_GET_COSTO (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, oCosto.getcodPlan());
            cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                if (rs.next()) {
                    oCosto.setcodPlan       (rs.getInt     ("COD_PLAN"));
                    oCosto.setcodCategoria  (rs.getInt     ("CATEGORIA"));                    
                    oCosto.setcosto         (rs.getDouble  ("COSTO"));
                    oCosto.setcantPersonaMin(rs.getInt     ("CANT_MIN_PERSONAS"));
                    oCosto.setedadMin       (rs.getInt     ("EDAD_MINIMA"));
                    oCosto.setedadMax       (rs.getInt     ("EDAD_MAXIMA"));

                }
                rs.close();
            }
            //System.out.println(" catehg" + oCosto.getcodCategoria());
        }  catch (SQLException se) {
                //System.out.println(" se " + se.getMessage());
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Plan [getDBCosto]" + se.getMessage());
        } catch (Exception e) {
                //System.out.println(" e " + e.getMessage());
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error Plan [getDBCosto]" + e.getMessage());
        } finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return oCosto;
        }
    }    
    
    
    
    public void setDBCosto (PlanCosto oCosto ,Connection dbCon )
       throws SurException {
       try {          
           
           dbCon.setAutoCommit(true);
           
           cons = dbCon.prepareCall(db.getSettingCall("ABM_PL_SET_COSTO (?,?,?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt    (2,  this.getcodPlan() );
           cons.setInt    (3,  oCosto.getcodCategoria() );
           cons.setDouble (4,  oCosto.getcosto() );           
           cons.setInt   (5,  oCosto.getcantPersonaMin());
           cons.setInt    (6,  oCosto.getedadMin());
           cons.setInt    (7,  oCosto.getedadMax());           
           
           cons.execute();           
           this.setcodPlan(cons.getInt (1)); 
           
           
       }  catch (SQLException se) {                                
           throw new SurException("Error en PLAN [setDBPCosto]: " + se.getMessage());
       }  catch (Exception e) {           
           throw new SurException("Error en PLAN [setDBCosto]: " + e.getMessage());
       } finally {
           try {
               if (cons != null) cons.close();
           } catch (SQLException se) {                          
               throw new SurException (se.getMessage());
           }
           // return this;
       }
    }    
    
    /** Getter for property codActividad.
     * @return Value of property codActividad.
     *
     */
    public int getcodActividad() {
        return codActividad;
    }
    
    /** Setter for property codActividad.
     * @param codActividad New value of property codActividad.
     *
     */
    public void setcodActividad(int codActividad) {
        this.codActividad = codActividad;
    }
    
}

