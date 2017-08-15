/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.business.beans;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import com.business.db.*;
import com.business.util.*;


/**
 *
 * @author Rolando Elisii
 */
public class PlanVigencia {

  private int    codPlan      = 0;
  private int    codVigencia  =0;
  private String descripcion = "";
  private double impPrima         = 0;
  private int    cantMaxCuotas  = 0;
  private double    impPremio  = 0;
  private double    minPremio  = 0;
  private int cantMaxCuotasVig  = 0;
  private int cantMaxDias  = 0;
  private String sMensError           = new String();
  private int  iNumError              = 0;
  private int iCodFacturacion = 0;
  private String incluyeSellados = "";


    /** Creates a new instance of PlanimpPrima */
    public PlanVigencia () {
    }
    public int getcodPlan() {
        return codPlan;
    }

    public void setcodPlan(int codPlan) {
        this.codPlan = codPlan;
    }
    public int getcodVigencia() {
        return codVigencia;
    }
    public void setcodVigencia(int codVigencia) {
        this.codVigencia = codVigencia;
    }

    public double getimpPrima() {
        return impPrima;
    }
    public String getdescripcion () {
        return descripcion;
    }

    public String getincluyeSellados () {
        return incluyeSellados;
    }
    
    public void setimpPrima(double impPrima) {
        this.impPrima = impPrima;
    }
    public int getcantMaxCuotas() {
        return cantMaxCuotas;
    }
    public void setcantMaxCuotas(int cantMaxCuotas) {
        this.cantMaxCuotas = cantMaxCuotas;
    }
    public double getimpPremio() {
        return impPremio;
    }
    public void setimpPremio(double impPremio) {
        this.impPremio = impPremio;
    }
    public double getminPremio() {
        return minPremio;
    }
    public int getiCodFacturacion () {
        return iCodFacturacion;
    }
    public void setminPremio(double minPremio) {
        this.minPremio = minPremio;
    }
    public void setdescripcion (String param) {
        this.descripcion = param;
    }
    public int getcantMaxCuotasVig() {
        return cantMaxCuotasVig;
    }
    public void setcantMaxCuotasVig(int param) {
        this.cantMaxCuotasVig = param;
    }
    public int getcantMaxDias() {
        return cantMaxDias;
    }
    public void setcantMaxDias(int param) {
        this.cantMaxDias = param;
    }
    public void setiCodFacturacion (int param) {
        this.iCodFacturacion = param;
    }

    public void setincluyeSellados  (String param) {
        this.incluyeSellados  = param;
    }
    
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

    public void setDBDelete (Connection dbCon, String usuario )
       throws SurException {
       CallableStatement cons = null;
       try {

           dbCon.setAutoCommit(true);

           cons = dbCon.prepareCall(db.getSettingCall("ABM_PL_VIGENCIA_DELETE (?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt    (2,  this.getcodPlan() );
           cons.setInt    (3, this.getcodVigencia());
           cons.setString (4, usuario);

           cons.execute();

           this.setiNumError(0);

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
               throw new SurException (se.getMessage());
           }
       }
    }
    public void setDBAdd (Connection dbCon, String usuario )
       throws SurException {
       CallableStatement cons = null;
       try {

           dbCon.setAutoCommit(true);


           cons = dbCon.prepareCall(db.getSettingCall("ABM_PL_VIGENCIA_ADD (?,?,?,?,?,?,?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt    (2,  this.getcodPlan() );
           cons.setInt    (3, this.getcodVigencia());
           cons.setInt    (4, this.getcantMaxCuotas());
           cons.setDouble (5, this.getimpPremio());
           cons.setDouble (6, this.getimpPrima());
           cons.setDouble (7, this.getminPremio());
           cons.setInt    (8, this.getcantMaxDias());
           cons.setString (9, usuario);
           cons.setInt    (10, this.getiCodFacturacion());
           cons.setString (11, this.getincluyeSellados());

           cons.execute();

           this.setiNumError(0);

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
               throw new SurException (se.getMessage());
           }
       }
    }

}
