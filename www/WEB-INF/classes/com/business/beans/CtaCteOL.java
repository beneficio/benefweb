package com.business.beans;
import java.util.Date;

public class CtaCteOL{

    private int    anioMes = 0;       //"ANIO_MES" integer,
    private int    numSecuCtaCte = 0; //"NUM_SECU_CTACTE" integer,
    private int    codProd = 0;       //"COD_PROD" integer,
    private int    codOrg = 0;        //"COD_ORG" integer,
    private String codProddDc = "";   // "COD_PROD_DC" character varying(10),
    private Date   fechaMov     = null; //"FECHA_MOV" date,
    private int    ordene = 0;         //"ORDENE" integer,
    private int    tipCom = 0;         //"TIPCOM" integer,
    private int    tipDif = 0;         //"TIPDIF" integer,
    private String matricula   = "";   // "MATRICULA" character varying(6),
    private int    grupo       = 0;    //"GRUPO" integer,
    private int    comprobante = 0;    //"COMPROBANTE" integer,
    private String concepto    = "";   // "CONCEPTO" character varying(100),
    private String detalleOp   = "";   // "DETALLE_OP" character varying(1),
    private int    operacion   = 0;    //"OPERACION" integer, -- 1: DEBE - 2: HABER
    private double importe     = 0;    // "IMPORTE" double precision,
    private double importeMon  = 0;    // "IMPORTE_MON" double precision,
    private double porcSoc     = 0;    // "PORC_SOC" double precision, -- PORC. SERVICIO SOCIALES
    private double impSoc      = 0;    // "IMP_SOC" double precision, -- IMPORTE SERVICIOS SOCIALES
    private int    pring1      = 0;    //"PRING1" integer,
    private double poing1      = 0;    // "POING1" double precision,
    private double reing1      = 0;    // "REING1" double precision,
    private int    pring2      = 0;    // "PRING2" integer,
    private double poing2      = 0;    // "POING2" double precision,
    private double reing2      = 0;    // "REING2" double precision,
    private double jubili      = 0;    // "JUBILI" double precision,
    private String nroCuit     = "";   // "NRO_CUIT" character varying(11),
    private String retGanancia = "";   // "RET_GANANCIA" character varying(1)

    private double debe      = 0;
    private double haber      = 0;
    private String movimiento   = "";


    // 
    private String sMensError = new String ();
    private int    iNumError = 0;

    public CtaCteOL(){
    }

    public int getAnioMes() {
        return anioMes;
    }

    public void setAnioMes(int anioMes) {
        this.anioMes = anioMes;
    }

    public int getCodOrg() {
        return codOrg;
    }

    public void setCodOrg(int codOrg) {
        this.codOrg = codOrg;
    }

    public int getCodProd() {
        return codProd;
    }

    public void setCodProd(int codProd) {
        this.codProd = codProd;
    }

    public String getCodProddDc() {
        return codProddDc;
    }

    public void setCodProddDc(String codProddDc) {
        this.codProddDc = codProddDc;
    }

    public int getComprobante() {
        return comprobante;
    }

    public void setComprobante(int comprobante) {
        this.comprobante = comprobante;
    }

    public String getConcepto() {
        return concepto;
    }

    public void setConcepto(String concepto) {
        this.concepto = concepto;
    }

    public String getDetalleOp() {
        return detalleOp;
    }

    public void setDetalleOp(String detalleOp) {
        this.detalleOp = detalleOp;
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

    public double getImpSoc() {
        return impSoc;
    }

    public void setImpSoc(double impSoc) {
        this.impSoc = impSoc;
    }

    public double getImporte() {
        return importe;
    }

    public void setImporte(double importe) {
        this.importe = importe;
    }

    public double getImporteMon() {
        return importeMon;
    }

    public void setImporteMon(double importeMon) {
        this.importeMon = importeMon;
    }

    public double getJubili() {
        return jubili;
    }

    public void setJubili(double jubili) {
        this.jubili = jubili;
    }

    public String getMatricula() {
        return matricula;
    }

    public void setMatricula(String matricula) {
        this.matricula = matricula;
    }

    public String getNroCuit() {
        return nroCuit;
    }

    public void setNroCuit(String nroCuit) {
        this.nroCuit = nroCuit;
    }

    public int getNumSecuCtaCte() {
        return numSecuCtaCte;
    }

    public void setNumSecuCtaCte(int numSecuCtaCte) {
        this.numSecuCtaCte = numSecuCtaCte;
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

    public double getPoing1() {
        return poing1;
    }

    public void setPoing1(double poing1) {
        this.poing1 = poing1;
    }

    public double getPoing2() {
        return poing2;
    }

    public void setPoing2(double poing2) {
        this.poing2 = poing2;
    }

    public double getPorcSoc() {
        return porcSoc;
    }

    public void setPorcSoc(double porcSoc) {
        this.porcSoc = porcSoc;
    }

    public int getPring1() {
        return pring1;
    }

    public void setPring1(int pring1) {
        this.pring1 = pring1;
    }

    public int getPring2() {
        return pring2;
    }

    public void setPring2(int pring2) {
        this.pring2 = pring2;
    }

    public double getReing1() {
        return reing1;
    }

    public void setReing1(double reing1) {
        this.reing1 = reing1;
    }

    public double getReing2() {
        return reing2;
    }

    public void setReing2(double reing2) {
        this.reing2 = reing2;
    }

    public int getTipCom() {
        return tipCom;
    }

    public void setTipCom(int tipCom) {
        this.tipCom = tipCom;
    }

    public int getTipDif() {
        return tipDif;
    }

    public void setTipDif(int tipDif) {
        this.tipDif = tipDif;
    }

    public String getRetGanancia() {
        return retGanancia;
    }

    public void setRetGanancia(String retGanancia) {
        this.retGanancia = retGanancia;
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

    public String getMovimiento() {
        return movimiento;
    }

    public void setMovimiento(String movimiento) {
        this.movimiento = movimiento;
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
}
