/*
 * Certificado.java
 *
 * Created on 9 de enero de 2005, 19:37
 */
package com.business.beans;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import com.business.util.*;
import com.business.db.*;
/**   
 *  
 * @author Rolando Elisii
 */
public class AsegCobertura {
    
    private String tipoCertificado  = "";
    private int numCertificado      = 0;
    private int codRama            = 0;
    private String tipoDoc         = "";
    private String numDoc          = "";
    private String nombre          = "";
    private int codSubRama         = 0;
    private int codCob             = 0;
    private double impSumaRiesgo   = 0;
    private double impPrima        = 0;
    private String descRama        = "";
    private String descSubRama     = "";  
    private String descCob         = "";
    private int numPoliza          = 0;
    private int numEndoso             = 0;
    private int codProceso         = 0;
    private String codBoca         = "";  
    private int numPropuesta       = 0;
    private String descripcion     = "";
    private int item                = 0;
    private int subItem             = 0;
    private int parentesco          = 0;
    private String descParentesco   = "";
    private int iNumError           = 0;
    private String sMensError       = "";
    
    /** Creates a new instance of Certificado */
    public AsegCobertura() {
    }

    public void settipoCertificado  (String param) { this.tipoCertificado = param; }
    public void setnumCertificado   (int param) { this.numCertificado   = param; }
    public void setcodRama          (int param) { this.codRama          = param; }
    public void setcodSubRama       (int param) { this.codSubRama       = param; }
    public void setcodCob           (int param) { this.codCob           = param; }
    public void setimpSumaRiesgo    (double param) { this.impSumaRiesgo = param; }
    public void setimpPrima         (double param) { this.impPrima      = param; }
    public void setnumDoc           (String param) { this.numDoc        = param; }
    public void settipoDoc          (String param) { this.tipoDoc       = param; }
    public void setdescRama         (String param) { this.descRama      = param; }
    public void setdescSubRama      (String param) { this.descSubRama   = param; }    
    public void setdescCob          (String param) { this.descCob       = param; }    
    public void setnumPoliza        (int param) { this.numPoliza        = param; }
    public void setnumEndoso        (int param) { this.numEndoso        = param; }    
    public void setcodProceso       (int param) { this.codProceso       = param; }
    public void setcodBoca          (String param) { this.codBoca       = param; }
    public void setnumPropuesta     (int param) { this.numPropuesta     = param; }    
    public void setdescripcion      (String param) { this.descripcion   = param; }
    public void setnumError         (int param) { this.iNumError        = param; }
    public void setsMensError        (String param) { this.sMensError    = param; }
    public void setitem             (int param) { this.item             = param; }
    public void setsubItem          (int param) { this.subItem          = param; }
    public void setnombre           (String param) { this.nombre        = param; }
    public void setparentesco       (int param) { this.parentesco       = param; }
    public void setdescParentesco   (String param) {this.descParentesco= param; }
    
    public int getnumPoliza           () { return this.numPoliza; }
    public int getnumEndoso           () { return this.numEndoso; }    
    public String getnumDoc           () { return this.numDoc;}
    public String gettipoDoc          () { return this.tipoDoc;}
    public String gettipoCertificado  () { return tipoCertificado; }
    public int getnumCertificado      () { return  this.numCertificado;}
    public int getcodRama             () { return  this.codRama;}
    public int getcodSubRama          () { return  this.codSubRama;}
    public int getcodCob              () { return  this.codCob;}
    public double getimpSumaRiesgo     () { return this.impSumaRiesgo; }    
    public double getimpPrima         () { return this.impPrima; }    
    public String getdescRama         () { return this.descRama;}
    public String getdescSubRama      () { return this.descSubRama;}    
    public String getdescCob          () { return this.descCob;}        
    public int getcodProceso          () { return  this.codProceso;}
    public String getcodBoca          () { return this.codBoca;}    
    public int getnumPropuesta        () { return  this.numPropuesta;}
    public String getdescripcion      () { return  this.descripcion;}
    public int getiNumError           () { return  this.iNumError;}
    public String getsMensError       () { return  this.sMensError;}
    public int getitem                () { return  this.item;}
    public int getsubItem             () { return  this.subItem;}
    public String getnombre           () { return  this.nombre;}
    public int getparentesco          () { return  this.parentesco;}
    public String getdescParentesco   () { return  this.descParentesco;}
    
    public AsegCobertura setDBCobPropuesta ( Connection dbCon) throws SurException {
        CallableStatement cons = null;
        try {            
           dbCon.setAutoCommit(true);
           
           cons = dbCon.prepareCall(db.getSettingCall( "PRO_SET_COB_PROPUESTA (?,?,?,?,?,?,? )"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);                             
           cons.setInt              (2, this.getcodProceso());             
           cons.setString           (3, this.getcodBoca() );
           cons.setInt              (4, this.getnumPropuesta());             
           cons.setInt              (5, this.getcodRama());             
           cons.setInt              (6, this.getcodSubRama());             
           cons.setInt              (7, this.getcodCob());                        
           cons.setDouble           (8, this.getimpSumaRiesgo());                                          
           cons.execute();
           // this.setnumPropuesta(cons.getInt (1));

           this.setnumError(0);
           
        }  catch (SQLException se) {   
            this.setnumError(-1);
            this.setsMensError("Error SQL en AsegCobertura: " + se.getMessage());
        } catch (Exception e) {
            this.setnumError(-1);
            this.setsMensError("Error SQL en AsegCobertura: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    }                    
    
    public AsegCobertura delDBCobPropuesta ( Connection dbCon) throws SurException {
        CallableStatement cons = null;
        try {            
           dbCon.setAutoCommit(true);
           
           cons = dbCon.prepareCall(db.getSettingCall( "PRO_DEL_COB_PROPUESTA (?,?,?)"));                      
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getcodProceso());                        
           cons.setString           (3, this.getcodBoca());
           cons.setInt              (4, this.getnumPropuesta());                      
           cons.execute();
           
        }  catch (SQLException se) {            
            this.setnumError(-1);
            throw new SurException("Error SQL al generar borrar coberturas de la propuesta: " + se.getMessage());
        } catch (Exception e) {
            this.setnumError(-1);
            throw new SurException("Error Java: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    } // delDBCobPropuesta                       

    public AsegCobertura actualizarDBCobPropuesta ( Connection dbCon) throws SurException {
        CallableStatement cons = null;
        try {
           dbCon.setAutoCommit(true);

           cons = dbCon.prepareCall(db.getSettingCall( "PRO_SET_UPDATE_COB_PROPUESTA (?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getnumPropuesta());
           cons.execute();

        }  catch (SQLException se) {
            this.setnumError(-1);
            throw new SurException("Error SQL al generar borrar coberturas de la propuesta: " + se.getMessage());
        } catch (Exception e) {
            this.setnumError(-1);
            throw new SurException("Error Java: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    } // delDBCobPropuesta
    
}
