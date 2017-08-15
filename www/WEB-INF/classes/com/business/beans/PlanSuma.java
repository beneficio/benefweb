/*
 * PlanSuma.java
 *
 * Created on 2 de agosto de 2008, 09:34
 */

package com.business.beans;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.LinkedList;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;

import com.business.db.*;
import com.business.util.*;
/**   
 *
 * @author  Usuario
 */
public class PlanSuma {
    
    private int codPlan         = 0;
    private int codRama         = 0;
    private int codSubRama      = 0;    
    private int codCob          = 0;    
    private String descRama     = "";
    private String descSubRama  = "";    
    private String descCob      = "";    
    private double minSumAseg   = 0;   
    private double maxSumAseg   = 0;   
    private String mcaCobIncluida = "";
    private String userId      = "";
    
    /** Creates a new instance of PlanSuma */
    public PlanSuma() {
    }
    
    /** Getter for property codPlan.
     * @return Value of property codPlan.
     *
     */
    public int getcodPlan() {
        return this.codPlan;
    }
    
    /** Setter for property codPlan.
     * @param codPlan New value of property codPlan.
     *
     */
    public void setcodPlan(int codPlan) {
        this.codPlan = codPlan;
    }
    
    /** Getter for property codRama.
     * @return Value of property codRama.
     *
     */
    public int getcodRama() {
        return codRama;
    }
    
    /** Setter for property codRama.
     * @param codRama New value of property codRama.
     *
     */
    public void setcodRama(int codRama) {
        this.codRama = codRama;
    }
    
    /** Getter for property codSubRama.
     * @return Value of property codSubRama.
     *
     */
    public int getcodSubRama() {
        return codSubRama;
    }
    
    /** Setter for property codSubRama.
     * @param codSubRama New value of property codSubRama.
     *
     */
    public void setcodSubRama(int codSubRama) {
        this.codSubRama = codSubRama;
    }
    
    /** Getter for property descRama.
     * @return Value of property descRama.
     *
     */
    public String getdescRama() {
        return descRama;
    }
    
    /** Setter for property descRama.
     * @param descRama New value of property descRama.
     *
     */
    public void setdescRama(String descRama) {
        this.descRama = descRama;
    }
    
    /** Getter for property descSubRama.
     * @return Value of property descSubRama.
     *
     */
    public java.lang.String getdescSubRama() {
        return descSubRama;
    }
    
    /** Setter for property descSubRama.
     * @param descSubRama New value of property descSubRama.
     *
     */
    public void setdescSubRama(java.lang.String descSubRama) {
        this.descSubRama = descSubRama;
    }
    
    /** Getter for property codCob.
     * @return Value of property codCob.
     *
     */
    public int getcodCob() {
        return codCob;
    }
    
    /** Setter for property codCob.
     * @param codCob New value of property codCob.
     *
     */
    public void setcodCob(int codCob) {
        this.codCob = codCob;
    }
    
    /** Getter for property descCob.
     * @return Value of property descCob.
     *
     */
    public String getdescCob() {
        return descCob;
    }
    
    /** Setter for property descCob.
     * @param descCob New value of property descCob.
     *
     */
    public void setdescCob(String descCob) {
        this.descCob = descCob;
    }
    
    /** Getter for property minSumAseg.
     * @return Value of property minSumAseg.
     *
     */
    public double getminSumAseg() {
        return minSumAseg;
    }
    
    /** Setter for property minSumAseg.
     * @param minSumAseg New value of property minSumAseg.
     *
     */
    public void setminSumAseg(double minSumAseg) {
        this.minSumAseg = minSumAseg;
    }
    
    /** Getter for property maxSumAseg.
     * @return Value of property maxSumAseg.
     *
     */
    public double getmaxSumAseg() {
        return maxSumAseg;
    }
    
    /** Setter for property maxSumAseg.
     * @param maxSumAseg New value of property maxSumAseg.
     *
     */
    public void setmaxSumAseg(double maxSumAseg) {
        this.maxSumAseg = maxSumAseg;
    }
    
    /** Getter for property mcaCobIncluida.
     * @return Value of property mcaCobIncluida.
     *
     */
    public String getMcaCobIncluida() {
        return mcaCobIncluida;
    }
    
    /** Setter for property mcaCobIncluida.
     * @param mcaCobIncluida New value of property mcaCobIncluida.
     *
     */
    public void setMcaCobIncluida(String mcaCobIncluida) {
        this.mcaCobIncluida = mcaCobIncluida;
    }
    
    /** Getter for property userId.
     * @return Value of property userId.
     *
     */
    public String getuserId() {
        return userId;
    }
    
    /** Setter for property userId.
     * @param userId New value of property userId.
     *
     */
    public void setuserId(String userId) {
        this.userId = userId;
    }
    
}
