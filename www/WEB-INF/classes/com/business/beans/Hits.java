/*
 *
 * Created on 9 de febrero de 2004, 09:37
 */
package com.business.beans;
import java.util.Date;

public class Hits {

     private Date fechaAcceso = null;
     private String usuario = null;
     private String descUsuario = null;
     private String tipoUsuario = null;
     private String operacion   = null;
     private int cantidad       = 0;
     private String mes         = null;
     private String horaAcceso  = null;
     private int cantCotiz      = 0;
     private int cantPropAP     = 0;
     private int cantPropVC     = 0;
     private int cantPropVO     = 0;
     private int cantPropCaucion= 0;
     private int cantEndoso     = 0;
     private int cantOtros      = 0;


    /** Creates a new instance of Empresa */
    public Hits() {
    }

     public Date getfechaAcceso     () { return this.fechaAcceso; }
     public String getusuario       () { return this.usuario; }
     public String getdescUsuario   () { return this.descUsuario; }
     public String gettipoUsuario   () { return this.tipoUsuario; }
     public String getoperacion     () { return this.operacion; }
     public int getcantidad         () { return this.cantidad; }
     public String getmes           () { return this.mes; }
     public String gethoraAcceso    () { return this.horaAcceso; }
     public int getcantCotiz           () { return this.cantCotiz; }
     public int getcantPropAP          () { return this.cantPropAP; }
     public int getcantPropVC          () { return this.cantPropVC; }
     public int getcantPropVO          () { return this.cantPropVO; }
     public int getcantPropCaucion     () { return this.cantPropCaucion; }
     public int getcantEndoso          () { return this.cantEndoso; }
     public int getcantOtros           () { return this.cantOtros; }

     public void setfechaAcceso ( Date param) { this.fechaAcceso = param; }
     public void setusuario     ( String param) { this.usuario = param; }
     public void setdescUsuario ( String param) { this.descUsuario = param; }
     public void settipoUsuario ( String param) { this.tipoUsuario = param; }
     public void setoperacion   ( String param) { this.operacion = param; }
     public void setcantidad    ( int param) { this.cantidad = param; }
     public void setmes         ( String param) { this.mes = param; }
     public void sethoraAcceso  ( String param) { this.horaAcceso = param; }
     public void setcantCotiz           (int param) {  this.cantCotiz = param;}
     public void setcantPropAP          (int param) {  this.cantPropAP = param;}
     public void setcantPropVC          (int param) {  this.cantPropVC = param;}
     public void setcantPropVO          (int param) {  this.cantPropVO = param;}
     public void setcantPropCaucion     (int param) {  this.cantPropCaucion= param;}
     public void setcantEndoso          (int param) {  this.cantEndoso = param;}
     public void setcantOtros           (int param) {  this.cantOtros = param;}
    
}
