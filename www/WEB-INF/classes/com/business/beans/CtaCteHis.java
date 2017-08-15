package com.business.beans;

import java.util.Date;
   
public class CtaCteHis {
    //
    private int    anioMes = 0;       // "ANIO_MES" integer,
    private int    ordene = 0;       // "ORDENE" integer, -- 1 Saldo Anterior/ 2 Comisiones Devengadas/ 4 Anticipos de caja/ 6 Servicios Sociales/ 7 Ingresos Brutos
    private int    grupo = 0;       // "GRUPO" integer,
    private int    codProd = 0;     // "COD_PROD" integer,
    private int    codOrg = 0;      // "COD_ORG" integer,
    private String codProddDc = "";   // "COD_PROD_DC" character varying(10),
    private Date   fechaMov     = null; //"FECHA_MOV" date,
    private Date   fechaInf     = null; //"FECHA_INF" date,
    private int    codRama = 0;       // "COD_RAMA" integer,
    private int    numPoliza = 0;       // "NUM_POLIZA" integer,
    private int    numTomador = 0;       // "NUM_TOMADOR" integer,
    private String tomador = "";   ////"TOMADOR" character varying(100),
    private int    operacion = 0;       // "OPERACION" integer, -- 1: DEBE - 2: HABER
    private int    endoso = 0;       // "ENDOSO" integer,
    private double importe      = 0;    // //"IMPORTE" double precision,
    private String comprobante = "";   //"COMPROBANTE" character varying,
    private String concepto = "";   ////"CONCEPTO" character varying(100),
    private int    canal = 0;       // "CANAL" integer,
    private int    tipoin = 0;       // "TIPOIN" integer, -- 1 RP-Rapi Pago/ 2 TC-Tarjeta Credito/ 3 PL-Planes Ahorro/ 4 SO-Sobre/ 5 PH-Pres. Hipotecario/ 6 DA-Debito Automatico/ 7 PF-Pago Facil/vacio Cobranza Normal/ 55 AFIP
    private double impPremio = 0; //"IMP_PREMIO" double precision,
    private double impPrima = 0 ;//"IMP_PRIMA" double precision
    //
    private String sMensError = new String ();
    private int    iNumError = 0;
    //
    private double debe      = 0;   
    private double haber      = 0;  
    private double saldo      = 0;  
    private double comision   = 0;
    private String movimiento   = "";
    private String tipoIngreso = "";

    public CtaCteHis(){
    }

    public int getCodProd() {
        return codProd;
    }

    public void setCodProd(int codProd) {
        this.codProd = codProd;
    }

    public double getImporte() {
        return importe;
    }

    public void setImporte(double importe) {
        this.importe = importe;
    }

    public int getAnioMes() {
        return anioMes;
    }

    public void setAnioMes(int anioMes) {
        this.anioMes = anioMes;
    }

    public int getCanal() {
        return canal;
    }

    public void setCanal(int canal) {
        this.canal = canal;
    }

    public int getCodOrg() {
        return codOrg;
    }

    public void setCodOrg(int codOrg) {
        this.codOrg = codOrg;
    }

    public String getCodProddDc() {
        return codProddDc;
    }

    public void setCodProddDc(String codProddDc) {
        this.codProddDc = codProddDc;
    }

    public int getCodRama() {
        return codRama;
    }

    public void setCodRama(int codRama) {
        this.codRama = codRama;
    }

    public String getComprobante() {
        return comprobante;
    }

    public void setComprobante(String comprobante) {
        this.comprobante = comprobante;
    }

    public String getConcepto() {
        return concepto;
    }

    public void setConcepto(String concepto) {
        this.concepto = concepto;
    }

    public int getEndoso() {
        return endoso;
    }

    public void setEndoso(int endoso) {
        this.endoso = endoso;
    }

    public Date getFechaInf() {
        return fechaInf;
    }

    public void setFechaInf(Date fechaInf) {
        this.fechaInf = fechaInf;
    }

    public Date getFechaMov() {
        return fechaMov;
    }

    public void setFechaMov(Date fechaMov) {
        this.fechaMov = fechaMov;
    }

    public int getGrupo() {
        return grupo;
    }

    public void setGrupo(int grupo) {
        this.grupo = grupo;
    }

    public double getImpPremio() {
        return impPremio;
    }

    public void setImpPremio(double impPremio) {
        this.impPremio = impPremio;
    }

    public double getImpPrima() {
        return impPrima;
    }

    public void setImpPrima(double impPrima) {
        this.impPrima = impPrima;
    }

    public int getNumPoliza() {
        return numPoliza;
    }

    public void setNumPoliza(int numPoliza) {
        this.numPoliza = numPoliza;
    }

    public int getNumTomador() {
        return numTomador;
    }

    public void setNumTomador(int numTomador) {
        this.numTomador = numTomador;
    }

    public int getOperacion() {
        return operacion;
    }

    public void setOperacion(int operacion) {
        this.operacion = operacion;
    }

    public int getOrdene() {
        return ordene;
    }

    public void setOrdene(int ordene) {
        this.ordene = ordene;
    }

    public int getTipoin() {
        return tipoin;
    }

    public void setTipoin(int tipoin) {
        this.tipoin = tipoin;
    }

    public String getTomador() {
        return tomador;
    }

    public void setTomador(String tomador) {
        this.tomador = tomador;
    }

    //

    // Error
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

    public double getDebe() {
        return debe;
    }

    public void setDebe(double debe) {
        this.debe = debe;
    }

    public double getHaber() {
        return haber;
    }

    public void setHaber(double haber) {
        this.haber = haber;
    }

    public double getSaldo() {
        return saldo;
    }

    public void setSaldo(double saldo) {
        this.saldo = saldo;
    }

    public double getComision() {
        return comision;
    }

    public void setComision(double comision) {
        this.comision = comision;
    }

    public String getMovimiento() {
        return movimiento;
    }

    public void setMovimiento(String movimiento) {
        this.movimiento = movimiento;
    }

    public String getTipoIngreso() {
        return tipoIngreso;
    }

    public void setTipoIngreso(String tipoIngreso) {
        this.tipoIngreso = tipoIngreso;
    }

    

}
