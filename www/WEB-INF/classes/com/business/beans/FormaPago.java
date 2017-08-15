/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.business.beans;

/**
 *
 * @author Rolando Elisii
 */
public class FormaPago {

    private int  codigo;
    private String descripcion;
    private String tratamiento;

    /** Creates a new instance of Pais */
    public FormaPago(int  piCod, String sdesc, String tratamiento) {
        this.codigo = piCod;
        this.descripcion = sdesc;
        this.tratamiento = tratamiento;
    }

    public int getCodigo() {
        return codigo;
    }

    public String getDescripcion() {
        return descripcion;
    }
    public String getTratamiento () {
        return tratamiento;
    }

}
