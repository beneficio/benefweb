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

public class ConvenioMacro {
    
    private int codRegion   = 0;
    private int convenio    = 0;
    private String mcaBaja  = "";
    private String empresa  = "";
    private String tipo     = "";
    private String userId   = "";
    private Date fechaTrabajo  = null;

    private String sMensError = new String();
    private int  iNumError    = 0;
    private CallableStatement cons = null;
    
    /** Creates a new instance of Certificado */
    public ConvenioMacro () {
    }

    public void setcodRegion          (int param) { this.codRegion = param; }
    public void setconvenio          (int param) { this.convenio = param; }
    public void setmcaBaja           (String param) { this.mcaBaja = param; }
    public void setempresa      (String param) { this.empresa = param; }
    public void setuserId           (String param) { this.userId = param; }
    public void setfechaTrabajo     (Date param) { this.fechaTrabajo = param; }
    
    public int getcodRegion             () { return  this.codRegion;}
    public int getconvenio             () { return  this.convenio;}
    public String getmcaBaja           () { return this.mcaBaja;}
    public String getempresa      () { return this.empresa;}
    public String getuserId           () { return this.userId;}
    public Date getfechaTrabajo       () { return  this.fechaTrabajo;}
   
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
    
    
    public void   settipo      (String param) { this.tipo = param; }
    public String gettipo      ()             { return this.tipo;  }

    public ConvenioMacro getDB ( Connection dbCon) throws SurException {
         ResultSet rs = null;
         boolean bExiste = false;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_CONVENIO_MACRO (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getconvenio());
            cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    bExiste = true;
                    this.setconvenio   (rs.getInt    ("CONVENIO"));
                    this.setcodRegion  (rs.getInt    ("COD_REGION"));
                    this.setempresa    (rs.getString ("EMPRESA"));
                    this.setmcaBaja    (rs.getString ("MCA_BAJA"));
                    this.settipo       (rs.getString ("TIPO"));
                    this.setuserId     (rs.getString ("USERID"));
                }
                rs.close();
            }
           cons.close();

           if (! bExiste ) {
                setiNumError (-100);
                setsMensError ("CONVENIO INEXISTENTE");
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
                if (cons != null) cons.close (); 
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }
    
    public ConvenioMacro setDB (Connection dbCon )
       throws SurException {
       
       try {         
           dbCon.setAutoCommit(true);
           cons = dbCon.prepareCall(db.getSettingCall("ABM_SET_CONVENIO_MACRO (?,?,?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt    (2,  this.getconvenio() );
           cons.setString (3,  this.getempresa() );
           cons.setInt    (4,  this.getcodRegion());
           cons.setString (5, this.gettipo() );
           cons.setString (6, this.getuserId() );
           cons.setString (7, this.getmcaBaja() );
           
           cons.execute();                     
           this.setconvenio(cons.getInt (1));

       }  catch (SQLException se) {
           this.setiNumError(-1);
           this.setsMensError(se.getMessage());
           throw new SurException("Error en ConvenioMacro [setDB]: " + se.getMessage());
       }  catch (Exception e) {       
           this.setiNumError(-1);
           this.setsMensError(e.getMessage());
           throw new SurException("Error en ConvenioMacro [setDB]: " + e.getMessage());
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
    
/*
    public ConvenioMacro setDBcambiartipo (Connection dbCon )
       throws SurException {
       try {           
           
           dbCon.setAutoCommit(true);
           
           cons = dbCon.prepareCall(db.getSettingCall("ABM_PL_CAMBIAR_MCA_PUBLICAR (?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt    (2,  this.getconvenio() );
           cons.setString (3, this.gettipo() );
           cons.setString (4, this.getuserId() );     

           cons.execute();
                      
           this.setconvenio(cons.getInt (1));

       }  catch (SQLException se) {                 
           throw new SurException("Error en ConvenioMacro [setDBcambiartipo]: " + se.getMessage());
       }  catch (Exception e) {           
           throw new SurException("Error en ConvenioMacro [setDBcambiartipo]: " + e.getMessage());
       } finally {
           try {
               if (cons != null) cons.close();
           } catch (SQLException se) {                          
               throw new SurException (se.getMessage());
           }
           return this;
       }
    } // setDBcambiartipo
  */
}

