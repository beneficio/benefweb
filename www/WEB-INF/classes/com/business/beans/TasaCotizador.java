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

/**
 *
 * @author Rolando Elisii
 */

public class TasaCotizador  {


    private int    codRama   ;
    private int    codSubRama;
    private int    codProducto;
    private int    edadDesde;
    private int    edadHasta;
    private int    codProd;
    private double tasa;
    private int     iNumError = 0;
    private String sMensError = "";

  public TasaCotizador() {
  }

    public int    getCodRama       (){ return this.codRama;}
    public int    getCodSubRama    (){ return this.codSubRama;}
    public int    getcodProducto   (){ return this.codProducto;}
    public int    getiNumError     (){ return this.iNumError;}
    public String getsMensError    (){ return this.sMensError; }


    public void setCodRama      (int param ) {  this.codRama       = param ;}
    public void setCodSubRama   (int param ) {  this.codSubRama    = param ;}
    public void setcodProducto  (int param ) {  this.codProducto   = param ;}
    public void setiNumError    (int param)     {  this.iNumError   = param;    }
    public void setsMensError   (String param)  {  this.sMensError  = param;    }

}
