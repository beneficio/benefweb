/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.business.beans;

/**
 *
 * @author Rolando Elisii
 */
public class Rubro {

    private int  codigo;
    private String descripcion;

    /** Creates a new instance of Pais */
    public Rubro(int  piCod, String sdesc) {
        this.codigo = piCod;
        this.descripcion = sdesc;
    }


    public int getCodigo() {
        return codigo;
    }

    public String getDescripcion() {
        return descripcion;
    }

}
