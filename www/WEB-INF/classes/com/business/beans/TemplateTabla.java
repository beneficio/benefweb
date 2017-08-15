/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.business.beans;
/**
 *
 * @author Rolando Elisii
 */
public class TemplateTabla {

 private int     numCampo    		= 0   ;
 private String  descripcion 		= ""  ;
 private String  tipoDato 		= ""  ;
 private String  obligatorio  		= ""  ;
 private String  validaMailProd		= ""  ;
 private String  detalle 		= ""  ;
 private int    codTemplate             = 0;

 public TemplateTabla(){

}
//Definicion de metodos Setter

public void  settipoDato     (String param){ this.tipoDato = param;}
public void  setnumCampo   (int param   ){ this.numCampo = param;}
public void  setdescripcion   (String param){ this.descripcion = param;}
public void  setobligatorio  (String param){ this.obligatorio = param;}
public void  setvalidaMailProd   (String param){ this.validaMailProd  = param;}
public void  setdetalle       (String param){ this.detalle      = param;}
public void  setCodTemplate (int param   ){ this.codTemplate = param;}

// Definicion de metos  getter
public  String 	   getdetalle	    (){ return this.detalle;}
public  String     gettipoDato       (){ return this.tipoDato;}
public  String     getvalidaMailProd     (){ return this.validaMailProd;}
public  String     getobligatorio    (){ return this.obligatorio;}
public  String     getdescripcion         (){ return this.descripcion;}
public  int        getnumCampo      (){ return this.numCampo;}
public  int        getCodTemplate   (){ return this.codTemplate;}
}
