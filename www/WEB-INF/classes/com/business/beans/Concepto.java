package com.business.beans;

public class Concepto {

    String tipoCertificado = ""; //"TIPO_CERTIFICADO" character varying(2),
    int  numCertificado = 0;     //"NUM_CERTIFICADO" integer,
    int codConcepto = 0;         // "COD_CONCEPTO" integer,
    int orden =0 ;               // "ORDEN" integer,
    String texto ="";            //TEXTO" character varying(250)

    private String sMensError = new String();
    private int    iNumError  = 0;
   
    public Concepto(){

    }

    public int getCodConcepto() {
        return codConcepto;
    }

    public void setCodConcepto(int codConcepto) {
        this.codConcepto = codConcepto;
    }

    public int getNumCertificado() {
        return numCertificado;
    }

    public void setNumCertificado(int numCertificado) {
        this.numCertificado = numCertificado;
    }

    public int getOrden() {
        return orden;
    }

    public void setOrden(int orden) {
        this.orden = orden;
    }

    public String getTexto() {
        return texto;
    }

    public void setTexto(String texto) {
        this.texto = texto;
    }

    public String getTipoCertificado() {
        return tipoCertificado;
    }

    public void setTipoCertificado(String tipoCertificado) {
        this.tipoCertificado = tipoCertificado;
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

}
