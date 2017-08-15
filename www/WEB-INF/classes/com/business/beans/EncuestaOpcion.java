/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.business.beans;

import java.util.Date;

/**
 *
 * @author silvio
 */
public class EncuestaOpcion {

   
    private int    numEncuesta = 0;
    private int    numPregunta = 0;
    private int    numOpcion = 0;
    private String descripcion  = "";
    private String mcaCampoAbierto = "";
    private int    longCampoAbierto = 0;
    private Date   fechaTrabajo=null;
    private String userId ="";
    

    private String sMensError           = "";
    private int  iNumError              = 0;


    public EncuestaOpcion(){};

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public Date getFechaTrabajo() {
        return fechaTrabajo;
    }

    public void setFechaTrabajo(Date fechaTrabajo) {
        this.fechaTrabajo = fechaTrabajo;
    }

    public int getLongCampoAbierto() {
        return longCampoAbierto;
    }

    public void setLongCampoAbierto(int longCampoAbierto) {
        this.longCampoAbierto = longCampoAbierto;
    }

    public String getMcaCampoAbierto() {
        return mcaCampoAbierto;
    }

    public void setMcaCampoAbierto(String mcaCampoAbierto) {
        this.mcaCampoAbierto = mcaCampoAbierto;
    }

    public int getNumEncuesta() {
        return numEncuesta;
    }

    public void setNumEncuesta(int numEncuesta) {
        this.numEncuesta = numEncuesta;
    }

    public int getNumOpcion() {
        return numOpcion;
    }

    public void setNumOpcion(int numOpcion) {
        this.numOpcion = numOpcion;
    }

    public int getNumPregunta() {
        return numPregunta;
    }

    public void setNumPregunta(int numPregunta) {
        this.numPregunta = numPregunta;
    }
 
    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }
    

    public String getsMensError() {
        return sMensError;
    }

    public void setsMensError(String sMensError) {
        this.sMensError = sMensError;
    }

    public int getiNumError() {
        return iNumError;
    }

    public void setiNumError(int iNumError) {
        this.iNumError = iNumError;
    }

}
