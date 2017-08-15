/*
 * Provincia.java
 *
 * Created on 12 de agosto de 2003, 17:40
 */

package com.business.beans;

/**
 *
 * @author  Gisela Cabot
 */

public class Provincia {
    private int codigo;
    private String descripcion;
    private String convMultilateral; // N o vacio no tiene, S caso contrario
    
    /** Creates a new instance of Provincia */
    public Provincia(int psCod, String sdesc) {
        this.codigo = psCod;
        this.descripcion = sdesc;
    }
    
    public int getCodigo() {
        return codigo;
    }
    
    public String getDescripcion() {
        return descripcion;
    }

    public String getConvMultilateral () {
        return convMultilateral;
    }
    
    public void setConvMultilateral (String conv) {
        convMultilateral = conv;
    }
    
}
