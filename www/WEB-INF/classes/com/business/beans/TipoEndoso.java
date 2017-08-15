/*
 * Provincia.java
 *
 * Created on 12 de agosto de 2003, 17:40
 */

package com.business.beans;
import com.google.gson.annotations.Expose;

public class TipoEndoso {
    @Expose
    private int codigo;
    @Expose
    private String descripcion;
    @Expose
    private String formulario = "";
    @Expose
    private String nivel = "";
        
    /** Creates a new instance of TipoEndoso */
    public TipoEndoso (int cod, String sdesc) {
        this.codigo = cod;
        this.descripcion = sdesc;
    }
    
    public int getCodigo() {
        return codigo;
    }
    
    public String getDescripcion() {
        return descripcion;
    }
    public String getformulario () {
        return formulario;
    }
    public String getnivel () {
        return nivel;
    }

    public void setCodigo(int param) {
        codigo = param;
    }
    
    public void setDescripcion( String param) {
        descripcion = param;
    }
    public void setformulario (String param) {
        formulario = param;
    }
    public void setnivel (String param) {
        nivel = param;
    }
    
}
