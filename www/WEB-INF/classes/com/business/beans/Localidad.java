/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.business.beans;
import com.business.db.db;
import com.business.util.SurException;
import com.google.gson.annotations.Expose;
import java.sql.ResultSet;
import java.sql.Connection;   
import java.sql.SQLException;
import java.sql.CallableStatement;
/**
 *     
 * @author Rolando
 */
public class Localidad {

    @Expose
    private int codLocalidad = 0;
    @Expose
    private String localidad = "";
    @Expose
    private int codProvincia = 0;
    @Expose
    private String provincia = "";
    @Expose
    private String codPostal = "";
    @Expose
    private String descLocalidad = "";
    
    public Localidad () {
    }

    public void setcodLocalidad (int param) { this.codLocalidad = param; }
    public void setlocalidad (String param) { this.localidad = param; }
    public void setcodProvincia (int param) { this.codProvincia = param; }
    public void setprovincia (String param) { this.provincia = param; }
    public void setcodPostal (String param) { this.codPostal = param; }
    public void setdescLocalidad (String param) { this.descLocalidad = param; }
    
    public int getcodLocalidad () { return this.codLocalidad;}
    public String getlocalidad () { return this.localidad;}
    public int getcodProvincia () { return this.codProvincia;}
    public String getprovincia () { return this.provincia;}
    public String getcodPostal () { return this.codPostal;}
    public String getdescLocalidad () { return this.descLocalidad;}
   
    public void getDBdescLocalidad (Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {
           cons = dbCon.prepareCall(db.getSettingCall( "get_desc_localidad ( ?)"));
           cons.registerOutParameter(1, java.sql.Types.VARCHAR);
           cons.setInt              (2, this.getcodLocalidad());

           cons.execute();

           this.setdescLocalidad(cons.getString (1));
           
        }  catch (SQLException se) {
            throw new SurException("Error SQL en getDBdescLocalidad: " + se.getMessage());
        } catch (Exception e) {
            throw new SurException("Error Java en getDBdescLocalidad: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
        }
    }
    
}
