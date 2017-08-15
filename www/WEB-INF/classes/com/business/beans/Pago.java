/*
 * Cuota.java
 *
 * Created on 30 de julio de 2003, 10:19 AM
 */

package com.business.beans;
import java.util.LinkedList;
import java.util.Date;
import com.business.db.*;
import com.business.util.*;
import com.business.interfaces.*;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
/**
 *
 * @author Rolando Elisii
 */
public class Pago {
    
//Datos de relacion

    private int codRama     = 0;
    private int numPoliza   = 0;
    private int endoso      = 0;
    private String asegurado = null;
    private Date FechaIniVig = null;
    private Date FechaFinVig = null;
    private Date FechaEmision = null;
    private int codMovimiento = 0;
    private String descMovimiento = null;
    private String comprobante = null;
    private int numCuota         = 0;
    private Date fechaVencimiento = null;
    private double importe       = 0.00;
    private double impTotalFact  = 0.00;
    private double impTotalFactPol = 0.00;    
    private double impSaldo      = 0.00;
    private double impDeuda      = 0.00;
    private double impTotalPagos = 0.00;
    private double impTotalReduc = 0.00;
    private double impDeuda15    = 0;
    private double impDeuda30    = 0;
    private double impDeuda60    = 0;
    private double impDeuda365   = 0;
    
    //Datos de la Cobranza de la Cuota
    private Date fechaCobro;
    private double tc;
    private String signoMoneda  ="";
    private int codMoneda       =1;
    private String sUsuario     = "";
    private String sVencida     = "";

    private String sMensError  = new String();
    private int iNumError      = 0;
    private CallableStatement cons     = null;
    
    //Ver como se maneja el campo tc (tipo de Cambio según la moneda)
    /** Creates a new instance of Cuota */
    
    public Pago () {
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
    public void setimpTotalFact (double param) {this.impTotalFact = param;}
    public double getimpTotalFact () {return this.impTotalFact;}
    public void setimpTotalPagos (double param) {this.impTotalPagos = param;}
    public double getimpTotalPagos () {return this.impTotalPagos;}
    public void setimpTotalReduc (double param) {this.impTotalReduc = param;}
    public double getimpTotalReduc () {return this.impTotalReduc;}
    public void setimpTotalFactPol (double param) {this.impTotalFactPol = param;}
    public double getimpTotalFactPol () {return this.impTotalFactPol;}
    public void setimpDeuda (double param) {this.impDeuda = param;}
    public double getimpDeuda () {return this.impDeuda;}

    public void setimpDeuda15 (double param) {this.impDeuda15 = param;}
    public double getimpDeuda15 () {return this.impDeuda15;}

    public void setimpDeuda30 (double param) {this.impDeuda30 = param;}
    public double getimpDeuda30 () {return this.impDeuda30;}

    public void setimpDeuda60 (double param) {this.impDeuda60 = param;}
    public double getimpDeuda60 () {return this.impDeuda60;}

    public void setimpDeuda365 (double param) {this.impDeuda365 = param;}
    public double getimpDeuda365 () {return this.impDeuda365;}
    
    public void setimpSaldo (double param) {this.impSaldo = param;}
    public double getimpSaldo () {return this.impSaldo;}
    public void setdFechaVencimiento (Date pdFechaVencimiento) {this.fechaVencimiento = pdFechaVencimiento;}
    
    public Date getdFechaVencimiento () {
        return this.fechaVencimiento;
    }
    
    public void setFechaCobro (Date pdFechaCobro) {
        this.fechaCobro = pdFechaCobro;
    }
    
    public Date getFechaCobro () {
        return this.fechaCobro;
    }
    
    public void setImporteTC (double piTC) {
        this.tc = piTC;
    }
    
    public double getImporteTC() {
        return this.tc;
    }
    
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

    public void setsVencida (String param) {
        this.sVencida = param;
    }
    
    public String getsVencida () {
        return this.sVencida;
    }
    
    public void setcomprobante (String param) {
        this.comprobante = param;
    }
    
    public String getcomprobante() {
        return this.comprobante;
    }
    
    public void setsUsuario (String psUsuario) {
        this.sUsuario = psUsuario;
    }
    
    public String getsUsuario () {
        return this.sUsuario;
    }
    
    public void setcodMovimiento(int piNumMov) {
        this.codMovimiento= piNumMov;
    }
    
    public int getcodMovimiento() {
        return this.codMovimiento;
    }
    
    public String getasegurado() {
        return this.asegurado;
    }
    
    public Date getFechaIniVig() {
        return this.FechaIniVig;
    }
    
    public Date getFechaFinVig() {
        return this.FechaFinVig;
    }

    public Date getFechaEmision() {
        return this.FechaEmision;
    }
    
    public String getdescMovimiento() {
        return this.descMovimiento;
    }
    
    
    public int getiNumError  () {
        return this.iNumError ;
    }
    
    public void setiNumError  (int piNumError ) {
        this.iNumError  = piNumError;
    }
    
    public String getsMensError  () {
        return this.sMensError ;
    }
    
    public void setsMensError  (String psMensError ) {
        this.sMensError  = psMensError ;
    }
    public void setasegurado  (String param ) {
        this.asegurado = param;
    }
    public void setFechaIniVig  (Date param) {
        this.FechaIniVig = param;
    }
    public void setFechaFinVig  (Date param) {
        this.FechaFinVig = param;
    }

    public void setFechaEmision  (Date param) {
        this.FechaEmision = param;
    }
    
    public void setdescMovimiento  (String param) {
        this.descMovimiento = param;
    }

}
