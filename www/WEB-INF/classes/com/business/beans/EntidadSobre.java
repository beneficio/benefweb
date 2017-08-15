/*
 * Certificado.java
 *
 * Created on 9 de enero de 2005, 19:37
 */
        
package com.business.beans;
import java.util.Date;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;  
import java.sql.CallableStatement;

import com.business.db.*;
import com.business.util.*;

public class EntidadSobre {
    
    private int codigo   = 0;
    private int sizeCuenta    = 0;
    private String mcaBaja  = "";
    private String descripcion  = "";
    private String mcaCuenta     = "";
    private String mcaConvenio   = "";
    private Date fechaTrabajo  = null;

    private String sMensError = new String();
    private int  iNumError    = 0;
    private CallableStatement cons = null;
    
    /** Creates a new instance of Certificado */
    public EntidadSobre () {
    }

    public void setcodigo          (int param) { this.codigo = param; }
    public void setsizeCuenta          (int param) { this.sizeCuenta = param; }
    public void setmcaBaja           (String param) { this.mcaBaja = param; }
    public void setdescripcion      (String param) { this.descripcion = param; }
    public void setmcaConvenio           (String param) { this.mcaConvenio = param; }
    public void setfechaTrabajo     (Date param) { this.fechaTrabajo = param; }
    
    public int getcodigo             () { return  this.codigo;}
    public int getsizeCuenta             () { return  this.sizeCuenta;}
    public String getmcaBaja           () { return this.mcaBaja;}
    public String getdescripcion      () { return this.descripcion;}
    public String getmcaConvenio           () { return this.mcaConvenio;}
    public Date getfechaTrabajo       () { return  this.fechaTrabajo;}
   
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
    public void   setmcaCuenta      (String param) { this.mcaCuenta = param; }
    public String getmcaCuenta      ()             { return this.mcaCuenta;  }

}

