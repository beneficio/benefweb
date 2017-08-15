/*
 * Pais.java
 *
 * Created on 12 de agosto de 2003, 17:42
 */

package com.business.beans;

/**
 *
 * @author  Gisela Cabot
 *
 */

public class Pais {
    
    private String codigo;
    private String descripcion;
    
    /** Creates a new instance of Pais */
    public Pais(String psCod, String sdesc) {
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
    

