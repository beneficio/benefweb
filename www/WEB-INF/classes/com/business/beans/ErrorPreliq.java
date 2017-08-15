/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.business.beans;

public class ErrorPreliq {
    int numLotePreliq = 0;
    int numPreliq = 0;
    int codError= 0;
    int codProd = 0;
    String descError = null;

    public ErrorPreliq(){ }

    public int getCodError() {
        return codError;
    }

    public int getNumPreliq() {
        return numPreliq;
    }

    public void setNumPreliq(int numPreliq) {
        this.numPreliq = numPreliq;
    }

    public void setCodError(int codError) {
        this.codError = codError;
    }

    public int getCodProd() {
        return codProd;
    }

    public void setCodProd(int codProd) {
        this.codProd = codProd;
    }

    public String getDescError() {
        return descError;
    }

    public void setDescError(String descError) {
        this.descError = descError;
    }

    public int getNumLotePreliq() {
        return numLotePreliq;
    }

    public void setNumLotePreliq(int numLotePreliq) {
        this.numLotePreliq = numLotePreliq;
    }
}
