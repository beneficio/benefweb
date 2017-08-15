/*
 * Documento.java
 *
 * Created on 31 de julio de 2003, 11:45
 */

package com.business.beans;

/**
 *
 * @author  Gisela Cabot
 */
public class Documento {
    
    private String codigo;
    private String descripcion;
    
    /** Creates a new instance of Documento */
    public Documento(String psCod, String sdesc) {
        this.codigo = psCod;
        this.descripcion = sdesc;
    }
 
    public String getCodigo() {
         return codigo;
    }    
    
    public String getDescripcion() {
         return descripcion;
    }
    
}
