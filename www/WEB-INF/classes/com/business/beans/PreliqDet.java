package com.business.beans;

import com.business.db.db;
import com.business.util.SurException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Date;

    
public class PreliqDet {

    private int numPreliq = 0;
    private int codRama = 0;
    private int numPoliza = 0;
    private int endoso  = 0;
    private int numCuota  = 0;//
    private String operacion = "";
    private String asegurado = "";
    private String mcaCobro = "";
    private Date  fechaCobro = null;//
    private String useridCobro = "";
    private String horaCobro = null;
    private int codMon  = 0;
    private Date fechaRec = null;
    private double impPrima = 0;
    private double impPremio = 0;
    private double impPremioPesos = 0;
    private double impComisNeta = 0;
    private double impPremioNeto = 0;
    private String formaPagoProd = "";
    private double impComisBrutaProd = 0;
    private double impComisNetaProd = 0;
    private String formaPagoOrg = "";
    private double impComisBrutaOrg = 0;
    private double impComisNetaOrg = 0;
    private int numPolizaAnt = 0;
    private int renovadaPor = 0;
    private int codProd = 0;
    private String codRamaDesc = "";
    private int numFila=0;
    private String sColor = "";
    private Date fechaAseg = null;


    private String sMensError = new String ();
    private int    iNumError = 0;



    public PreliqDet(){
    }

    public String getAsegurado() {
        return asegurado;
    }

    public void setAsegurado(String asegurado) {
        this.asegurado = asegurado;
    }

    public int getCodMon() {
        return codMon;
    }

    public void setCodMon(int codMon) {
        this.codMon = codMon;
    }

    public int getCodProd() {
        return codProd;
    }

    public void setCodProd(int codProd) {
        this.codProd = codProd;
    }

    public int getCodRama() {
        return codRama;
    }

    public void setCodRama(int codRama) {
        this.codRama = codRama;
    }

    public int getEndoso() {
        return endoso;
    }

    public void setEndoso(int endoso) {
        this.endoso = endoso;
    }

    public Date getFechaCobro() {
        return fechaCobro;
    }

    public void setFechaCobro(Date fechaCobro) {
        this.fechaCobro = fechaCobro;
    }

    public Date getFechaRec() {
        return fechaRec;
    }

    public void setFechaRec(Date fechaRec) {
        this.fechaRec = fechaRec;
    }

    public String getFormaPagoOrg() {
        return formaPagoOrg;
    }

    public void setFormaPagoOrg(String formaPagoOrg) {
        this.formaPagoOrg = formaPagoOrg;
    }

    public String getFormaPagoProd() {
        return formaPagoProd;
    }    

    public void setFormaPagoProd(String formaPagoProd) {
        this.formaPagoProd = formaPagoProd;
    }

    public String getHoraCobro() {
        return horaCobro;
    }

    public void setHoraCobro(String horaCobro) {
        this.horaCobro = horaCobro;
    }

    public double getImpComisBrutaOrg() {
        return impComisBrutaOrg;
    }

    public void setImpComisBrutaOrg(double impComisBrutaOrg) {
        this.impComisBrutaOrg = impComisBrutaOrg;
    }

    public double getImpComisBrutaProd() {
        return impComisBrutaProd;
    }

    public void setImpComisBrutaProd(double impComisBrutaProd) {
        this.impComisBrutaProd = impComisBrutaProd;
    }

    public double getImpComisNeta() {
        return impComisNeta;
    }

    public void setImpComisNeta(double impComisNeta) {
        this.impComisNeta = impComisNeta;
    }

    public double getImpComisNetaOrg() {
        return impComisNetaOrg;
    }

    public void setImpComisNetaOrg(double impComisNetaOrg) {
        this.impComisNetaOrg = impComisNetaOrg;
    }

    public double getImpComisNetaProd() {
        return impComisNetaProd;
    }

    public void setImpComisNetaProd(double impComisNetaProd) {
        this.impComisNetaProd = impComisNetaProd;
    }

    public double getImpPremio() {
        return impPremio;
    }

    public void setImpPremio(double impPremio) {
        this.impPremio = impPremio;
    }

    public double getImpPremioNeto() {
        return impPremioNeto;
    }

    public void setImpPremioNeto(double impPremioNeto) {
        this.impPremioNeto = impPremioNeto;
    }

    public double getImpPremioPesos() {
        return impPremioPesos;
    }

    public void setImpPremioPesos(double impPremioPesos) {
        this.impPremioPesos = impPremioPesos;
    }

    public double getImpPrima() {
        return impPrima;
    }

    public void setImpPrima(double impPrima) {
        this.impPrima = impPrima;
    }

    public String getMcaCobro() {
        return mcaCobro;
    }

    public void setMcaCobro(String mcaCobro) {
        this.mcaCobro = mcaCobro;
    }

    public int getNumCuota() {
        return numCuota;
    }

    public void setNumCuota(int numCuota) {
        this.numCuota = numCuota;
    }

    public int getNumPoliza() {
        return numPoliza;
    }

    public void setNumPoliza(int numPoliza) {
        this.numPoliza = numPoliza;
    }

    public int getNumPolizaAnt() {
        return numPolizaAnt;
    }

    public void setNumPolizaAnt(int numPolizaAnt) {
        this.numPolizaAnt = numPolizaAnt;
    }

    public int getNumPreliq() {
        return numPreliq;
    }

    public void setNumPreliq(int numPreliq) {
        this.numPreliq = numPreliq;
    }

    public String getOperacion() {
        return operacion;
    }

    public void setOperacion(String operacion) {
        this.operacion = operacion;
    }

    public int getRenovadaPor() {
        return renovadaPor;
    }

    public void setRenovadaPor(int renovadaPor) {
        this.renovadaPor = renovadaPor;
    }

    public String getUseridCobro() {
        return useridCobro;
    }

    public void setUseridCobro(String useridCobro) {
        this.useridCobro = useridCobro;
    }

    public String getCodRamaDesc() {
        return codRamaDesc;
    }

    public void setCodRamaDesc(String codRamaDesc) {
        this.codRamaDesc = codRamaDesc;
    }

    public int getNumFila() {
        return numFila;
    }

    public void setNumFila(int numFila) {
        this.numFila = numFila;
    }

    


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
    public String getColor() {
        return sColor;
    }

    public void setColor(String sColor) {
        this.sColor = sColor;
    }

    public Date getFechaAseg() {
        return fechaAseg;
    }

    public void setFechaAseg(Date fecha) {
        this.fechaAseg = fecha;
    }
    
    //Set Marca Cobro
    public PreliqDet setDBMcaCobro (Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {
           dbCon.setAutoCommit(true);
           cons = dbCon.prepareCall(db.getSettingCall( "CO_SET_MCACOBRO_PRELIQ_DET (?, ?, ?, ? )"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt  (2, this.getNumPreliq());
           cons.setInt  (3, this.getNumFila());
           if (this.getMcaCobro() == null || this.getMcaCobro().equals("")) {
               cons.setNull(4, java.sql.Types.VARCHAR);
           } else {
               cons.setString (4, this.getMcaCobro());
           }           
           cons.setString (5, this.getUseridCobro());
           cons.execute();
           this.setiNumError(cons.getInt (1));

        }  catch (SQLException se) {
            this.setiNumError(-1);
            this.setsMensError("PreliqDet[setDBMcaCobro]" + se.getMessage());
        } catch (Exception e) {
            this.setiNumError(-1);
            this.setsMensError("PreliqDet[setDBMcaCobro]" + e.getMessage());

        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                see.printStackTrace();
                this.setiNumError(-1);
                this.setsMensError("PreliqDet[setDBMcaCobro]" + see.getMessage());

            }
            return this;
        }
    }//setDBMcaCobro


}
