/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.business.beans;

/**
 *
 * @author Rolando Elisii
 */
public class Compania {

    private int    codigo = 0;
    private String razonSocial = "";
    private String cuit   = "";
    private String web    = "";

    public Compania () {
    }

    public int  getcodigo   (){ return this.codigo;}
    public String getrazonSocial (){ return this.razonSocial;}
    public String getcuit (){ return this.cuit;}
    public String getweb (){ return this.web;}

    public void setcodigo   (int param ) {  this.codigo = param ;}
    public void setrazonSocial (String param ) {  this.razonSocial = param ;}
    public void setcuit (String param ) {  this.cuit = param ;}
    public void setweb  (String param ) {  this.web  = param ;}
}
