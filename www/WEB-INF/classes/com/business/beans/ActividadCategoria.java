/*
 * ActividadCategoria.java
 *
 * Created on 9 de enero de 2005, 19:37
 */

package com.business.beans;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import com.business.db.*;      
import com.business.util.*;

/**
 *
 * @author Rolando Elisii
 */
public class ActividadCategoria {
    
    private int codRama         = 0;
    private int codActividad    = 0;
    private int categoria       = 0;
    private String descripcion  = "";
    private String mcaBaja      = "";
    private String sMensError   = new String();
    private int  iNumError      = 0;
    private int  iCodRubro      = 0;

    private CallableStatement cons = null;
    
    private String mcaPlanes      = "";
    private String mcaCotizador   = "";
    private String mcaNoRenovar   = null;
    private String mca24horas     = null;
    private String mcaItinere     = null;
    private String mcaLaboral     = null;

    
    /** Creates a new instance of ActividadCategoria */
    public ActividadCategoria() {
    }

    public void setcodRama          (int param) { this.codRama      = param; }
    public void setcodActividad     (int param) { this.codActividad = param; }
    public void setcategoria        (int param) { this.categoria    = param; }
    public void setdescripcion   (String param) { this.descripcion  = param; }    
    public void setmcaBaja       (String param) { this.mcaBaja  = param; }
    public void setiCodRubro     (int param) { this.iCodRubro    = param; }
    public void setmcaNoRenovar  (String param) { this.mcaNoRenovar = param; }
    public void setmca24Horas    (String param) { this.mca24horas  = param; }
    public void setmcaItinere    (String param) { this.mcaItinere  = param; }
    public void setmcaLaboral    (String param) { this.mcaLaboral  = param; }
    
    public int getcodRama        () { return this.codRama;}
    public int getcodActividad   () { return this.codActividad;}
    public int getcategoria     () { return this.categoria;}
    public String getdescripcion () { return this.descripcion;}
    public String getmcaBaja     () { return this.mcaBaja;}
    public int getiCodRubro   () { return this.iCodRubro;}
    public String getmcaNoRenovar() { return this.mcaNoRenovar;}
    public String getmca24Horas  () { return this.mca24horas;}
    public String getmcaItinere  () { return this.mcaItinere;}
    public String getmcaLaboral  () { return this.mcaLaboral;}
    public String getsMensError  () { return this.sMensError;}
    public void setsMensError  (String psMensError ) {this.sMensError  = psMensError;}

    public int getiNumError  () {return this.iNumError ;}
    public void setiNumError  (int piNumError ) {this.iNumError  = piNumError;}
    
    public void setDB (Connection dbCon) throws SurException {
      try {
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall( "ABM_ADD_ACTIVIDAD_CATEGORIA(?,?,?,?,?, ?,?,?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt   (2, this.getcodRama() );
            cons.setInt   (3, this.getcodActividad() );
            cons.setInt   (4, this.getcategoria() );
            cons.setString(5, this.getdescripcion() );
            cons.setString(6, this.getmcaBaja());
            cons.setString(7, this.getmcaPlanes());
            cons.setString(8, this.getmcaCotizador());
            cons.setString (9, this.getmcaNoRenovar());
            cons.setString (10, this.getmca24Horas());
            cons.setString (11, this.getmcaItinere());
            cons.setString (12, this.getmcaLaboral());
            cons.execute();
       
            this.setcodActividad(cons.getInt (1));
            
       }  catch (SQLException se) {
                this.setiNumError(-100);
		throw new SurException("Error al grabar la Actividad Categoria: " + se.getMessage());
        } catch (Exception e) {
                this.setiNumError(-100);
		throw new SurException("Error al grabar Actividad Categoria: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }
    
    /** Getter for property mcaPlanes.
     * @return Value of property mcaPlanes.
     *
     */
    public String getmcaPlanes() {
        return mcaPlanes;
    }
    
    /** Setter for property mcaPlanes.
     * @param mcaPlanes New value of property mcaPlanes.
     *
     */
    public void setmcaPlanes(String mcaPlanes) {
        this.mcaPlanes = mcaPlanes;
    }
    
    /** Getter for property mcaCotizador.
     * @return Value of property mcaCotizador.
     *
     */
    public String getmcaCotizador() {
        return mcaCotizador;
    }
    
    /** Setter for property mcaCotizador.
     * @param mcaCotizador New value of property mcaCotizador.
     *
     */
    public void setmcaCotizador(String mcaCotizador) {
        this.mcaCotizador = mcaCotizador;
    }
    
}
