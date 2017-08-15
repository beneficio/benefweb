/*
 * PlanCosto.java
 *
 * Created on 18 de agosto de 2008, 08:18
 */   

package com.business.beans;
import java.util.Date;
/**
 *
 * @author  Usuario
 */
public class PlanCosto {
  private int    codPlan      = 0;
  private int    codCategoria  =0;
  private double costo         = 0;  
  private int    cantPersonaMin  = 0;
  private int    edadMin  = 0;
  private int    edadMax  = 0;
  private Date fechaTrabajo      = null;
  private String userId      = "";
  
  
    /** Creates a new instance of PlanCosto */
    public PlanCosto() {
    }
    
    /** Getter for property codPlan.
     * @return Value of property codPlan.
     *
     */
    public int getcodPlan() {
        return codPlan;
    }
    
    /** Setter for property codPlan.
     * @param codPlan New value of property codPlan.
     *
     */
    public void setcodPlan(int codPlan) {
        this.codPlan = codPlan;
    }
    
    /** Getter for property codCategoria.
     * @return Value of property codCategoria.
     *
     */
    public int getcodCategoria() {
        return codCategoria;
    }
    
    /** Setter for property codCategoria.
     * @param codCategoria New value of property codCategoria.
     *
     */
    public void setcodCategoria(int codCategoria) {
        this.codCategoria = codCategoria;
    }
    
    /** Getter for property costo.
     * @return Value of property costo.
     *
     */
    public double getcosto() {
        return costo;
    }
    
    /** Setter for property costo.
     * @param costo New value of property costo.
     *
     */
    public void setcosto(double costo) {
        this.costo = costo;
    }
    
    /** Getter for property cantPersonaMin.
     * @return Value of property cantPersonaMin.
     *
     */
    public int getcantPersonaMin() {
        return cantPersonaMin;
    }
    
    /** Setter for property cantPersonaMin.
     * @param cantPersonaMin New value of property cantPersonaMin.
     *
     */
    public void setcantPersonaMin(int cantPersonaMin) {
        this.cantPersonaMin = cantPersonaMin;
    }
    
    /** Getter for property edadMin.
     * @return Value of property edadMin.
     *
     */
    public int getedadMin() {
        return edadMin;
    }
    
    /** Setter for property edadMin.
     * @param edadMin New value of property edadMin.
     *
     */
    public void setedadMin(int edadMin) {
        this.edadMin = edadMin;
    }
    
    /** Getter for property edadMax.
     * @return Value of property edadMax.
     *
     */
    public int getedadMax() {
        return edadMax;
    }
    
    /** Setter for property edadMax.
     * @param edadMax New value of property edadMax.
     *
     */
    public void setedadMax(int edadMax) {
        this.edadMax = edadMax;
    }
    
    /** Getter for property fechaTrabajo.
     * @return Value of property fechaTrabajo.
     *
     */
    public java.util.Date getFechaTrabajo() {
        return fechaTrabajo;
    }
    
    /** Setter for property fechaTrabajo.
     * @param fechaTrabajo New value of property fechaTrabajo.
     *
     */
    public void setFechaTrabajo(java.util.Date fechaTrabajo) {
        this.fechaTrabajo = fechaTrabajo;
    }
    
    /** Getter for property userId.
     * @return Value of property userId.
     *
     */
    public java.lang.String getuserId() {
        return userId;
    }
    
    /** Setter for property userId.
     * @param userId New value of property userId.
     *
     */
    public void setuserId(java.lang.String userId) {
        this.userId = userId;
    }
    
}
