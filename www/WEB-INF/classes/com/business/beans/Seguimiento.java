/*
 * Certificado.java
 *
 * Created on 9 de enero de 2005, 19:37
 */

package com.business.beans;

import java.util.Date;
import com.business.util.*;
/**
 *
 * @author Rolando Elisii
 */
public class Seguimiento {
    
    private String boca          ;  // varchar(3),
    private int    numPropuesta  ;  // int4,
    private int    codRama       ;  // int4,
    private int    numPoliza     ;  // int4,
    private int    numEndoso     ;
    private String codEstado ; 
    private Date   fechaTrabajo  ;  // date DEFAULT ('now'::text)::date,
    private String   horaTrabajo   ;  // time DEFAULT ('now'::text)::time(6) with time zone,
    private String userid        ;  // varchar(20),
    private String descEstado ;    
    /** Creates a new instance of Certificado */
    public Seguimiento() {
    }
    
    public String getBoca           (){ return this.boca;}
    public int    getNumPropuesta   (){ return this.numPropuesta;}
    public int    getCodRama        (){ return this.codRama;}
    public int    getNumPoliza      (){ return this.numPoliza;}
    public int    getNumEndoso      (){ return this.numEndoso;}
    public String getCodEstado      (){ return this.codEstado; }
    public Date   getFechaTrabajo   (){ return this.fechaTrabajo;  }
    public String   getHoraTrabajo    (){ return this.horaTrabajo;  }
    public String getUserid         (){ return this.userid;  }
    public String getdescEstado     () { return this.descEstado;}    

    public void setBoca           ( String param ) {  this.boca= param ;}
    public void setNumPropuesta   ( int param ) {  this.numPropuesta= param ;}
    public void setCodRama        ( int param ) {  this.codRama= param ;}
    public void setNumPoliza      ( int param ) {  this.numPoliza= param ;}
    public void setNumEndoso      ( int param ) {  this.numEndoso= param ;}
    public void setCodEstado      ( String param ) {  this.codEstado= param ; }
    public void setFechaTrabajo   ( Date param) { this.fechaTrabajo= param ;  }
    public void setHoraTrabajo    ( String param) { this.horaTrabajo= param ;  }
    public void setUserid         ( String param ) {  this.userid= param ;  }
    public void setdescEstado     (String param) { this.descEstado = param; }
    
}

