/*
 * Usos.java
 *
 * Created on 15 de agosto de 2003, 17:39
 */

package com.business.beans;
import com.business.interfaces.MaestroInfo;

public class Generico implements MaestroInfo {
    
    private int iCodigo    = 0;
    private String sCodigo = null; 
    private String descripcion = null;
    
    /** Creates a new instance of Usos */
    public Generico(int piCod, String sdesc) {
        this.iCodigo = piCod;
        this.descripcion = sdesc;
    }

    public Generico(String psCod, String sdesc) {
        this.sCodigo = psCod;
        this.descripcion = sdesc;
    }
    
    public int getCodigo() {
        return iCodigo;
    }

    public String getsCodigo() {
        return sCodigo;
    }
    
    public String getDescripcion() {
        return descripcion;
    }
    
    
}
