/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.business.beans;
import com.business.db.*;
import com.business.util.*;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;

import com.google.gson.annotations.Expose;

/**
 *
 * @author Rolando Elisii
 */
    
public class Producto {


    private int    codRama   ;
    private int    codSubRama;

    @Expose
    private int    codProducto;

    @Expose
    private String descProducto;

    private String tipoNomina = "S";
    // S: simple (datos minimos) G: 1 solo Grupo y GM: Multiples grupos
    private String nivelCob   = "P";
    //P: coberturas a nivel de poliza todas iguales, N: coberturas a nivel de nomina
    private String existeSubSeccion = null;
   
    private int     iNumError = 0;
    private String sMensError = "";
    private String mcaEmite = null;
    private String mcaRenueva = null;
    private String mcaCotiza = null;
    private String mcaBloquear = null;
    private int codProductoDefault = 0;
    private String tipoEnvio = null;
    private int tarifa = 0;

  public Producto() {
  }

   public Producto(int codigo, String descripcion) {
       this.codProducto = codigo;
       this.descProducto = descripcion;
  }

    public int    getCodRama       (){ return this.codRama;}
    public int    getCodSubRama    (){ return this.codSubRama;}
    public int    getcodProducto   (){ return this.codProducto;}
    public String getdescProducto  (){ return this.descProducto; }
    public String getNivelCob      (){ return this.nivelCob;}
    public String gettipoNomina    (){ return this.tipoNomina;}
    public String getexisteSubSeccion (){ return this.existeSubSeccion; }
    public int    getiNumError     (){ return this.iNumError;}
    public String getsMensError    (){ return this.sMensError; }
    public String getmcaEmite      (){ return this.mcaEmite; }
    public String getmcaRenueva    (){ return this.mcaRenueva; }
    public String getmcaCotiza     (){ return this.mcaCotiza; }
    public String getmcaBloquear   (){ return this.mcaBloquear; }
    public int getcodProductoDefault (){ return this.codProductoDefault; }
    public String gettipoEnvio     (){ return this.tipoEnvio; }
    public int gettarifa (){ return this.tarifa; }


    public void setCodRama      (int param ) {  this.codRama       = param ;}
    public void setCodSubRama   (int param ) {  this.codSubRama    = param ;}
    public void setcodProducto  (int param ) {  this.codProducto   = param ;}
    public void setdescProducto (String param ) {  this.descProducto= param ;}
    public void setnivelCob     (String param ) {  this.nivelCob    = param ;}
    public void settipoNomina   (String param ) {  this.tipoNomina  = param ;}
    public void setexisteSubSeccion (String param ) {  this.existeSubSeccion = param ;}
    public void setiNumError    (int param)     {  this.iNumError   = param;    }
    public void setsMensError   (String param)  {  this.sMensError  = param;    }
    public void setmcaEmite      (String param){ this.mcaEmite = param; }
    public void setmcaRenueva    (String param){ this.mcaRenueva = param; }
    public void setmcaCotiza     (String param){ this.mcaCotiza = param; }
    public void setmcaBloquear   (String param){this.mcaBloquear = param; }
    public void setcodProductoDefault (int param){ this.codProductoDefault = param; }
    public void settipoEnvio     (String param){ this.tipoEnvio = param; }
    public void settarifa (int param){ this.tarifa = param; }

    public Producto getDB ( Connection dbCon) throws SurException {
       ResultSet rs         = null;
       CallableStatement cons = null;
       boolean bExiste       = false;
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("COT_GET_PRODUCTO (?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getCodRama());
            cons.setInt (3, this.getCodSubRama());
            cons.setInt (4, this.getcodProducto());
            cons.execute();

            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    bExiste         = true;
                    this.setCodRama     (rs.getInt("COD_RAMA"));
                    this.setCodSubRama  (rs.getInt("COD_SUB_RAMA"));
                    this.setcodProducto (rs.getInt  ("COD_PRODUCTO"));
                    this.setdescProducto(rs.getString("DESC_PRODUCTO"));
                    this.settipoNomina  (rs.getString ("TIPO_NOMINA"));
                    this.setnivelCob    (rs.getString ("NIVEL_COB"));
                    this.setmcaEmite    (rs.getString ("MCA_EMITE"));
                    this.setcodProductoDefault( rs.getInt ("COD_PRODUCTO_DEFAULT"));
                    this.settipoEnvio   (rs.getString ("TIPO_ENVIO"));
                    this.setmcaRenueva  (rs.getString ("MCA_RENUEVA"));
                    this.setmcaCotiza   (rs.getString ("MCA_COTIZA"));
                    this.settarifa      (rs.getInt("TARIFA"));
                    this.setmcaBloquear (rs.getString ("MCA_BLOQUEAR"));
                }
                
                rs.close();
            }
            cons.close();

            if ( ! bExiste) {
                setiNumError (-1);
                setsMensError ("PRODUCTO INEXISTENTE");
            }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
        } finally {
            try{
                if (rs != null) {rs.close();}
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }
}
