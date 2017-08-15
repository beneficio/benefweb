/*
 * Cuota.java
 *
 * Created on 30 de julio de 2003, 10:19 AM
 */

package com.business.beans;
import java.util.Date;
/**
 *
 * @author Rolando Elisii
 */
public class Cuota {
    
//Datos de relacion

    private int codRama     = 0;
    private int numPoliza   = 0;
    private int endoso      = 0;
    private int numCuota         = 0;
    private Date fechaVencimiento = null;
    private double importe       = 0.00;
    private Date dFechaFtp  = null;
    
    private String signoMoneda  ="";
    private int codMoneda       =1;
    private String sUsuario     = "";
    
    public Cuota() {
    }

    public void setcodRama      (int param) {this.codRama = param;}
    public int getcodRama   () {return this.codRama;}
    public void setiNumCuota    (int piNumCuota) {this.numCuota = piNumCuota;}
    public int getiNumCuota () {return this.numCuota;}
    public void setendoso       (int pendoso) {this.endoso = pendoso;}
    public int getendoso    () {return this.endoso;}
    public void setnumPoliza (int pnumPoliza) {this.numPoliza = pnumPoliza;}
    public int getnumPoliza () {return this.numPoliza;}
    public void setiImporte (double piImporte) {this.importe = piImporte;}
    public double getiImporte () {return this.importe;}

    public void setdFechaVencimiento (Date pdFechaVencimiento) {this.fechaVencimiento = pdFechaVencimiento;}    
    public Date getdFechaVencimiento () {  return this.fechaVencimiento;  }

    public void setdFechaFtp (Date param) {this.dFechaFtp = param;}    
    public Date getdFechaFtp () {  return this.dFechaFtp;  }
    
    public void setCodMoneda(int piCodMoneda) {
        this.codMoneda = piCodMoneda;
    }
    
    public int getCodMoneda() {
        return this.codMoneda;
    }
    
    public void setSimboloMonetario(String piSignoMoneda) {
        this.signoMoneda = piSignoMoneda;
    }
    
    public String getSimboloMonetario() {
        return this.signoMoneda;
    }

    public void setsUsuario (String psUsuario) {
        this.sUsuario = psUsuario;
    }
    
    public String getsUsuario () {
        return this.sUsuario;
    }
 }
