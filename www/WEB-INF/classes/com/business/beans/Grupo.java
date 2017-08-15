/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.business.beans;

/**
 *
 * @author Rolando Elisii
 */
public class Grupo {

private int iCodGrupo = 0;
private String sDescripcion = "";
private String sCodProdDC ="";
private int iCodProd  = 0;
private int iCodOrg = 0;

    public Grupo () {
    }

public void setiCodGrupo (int param) { this.iCodGrupo  = param; }
public void setiCodProd  (int param) { this.iCodProd   = param; }
public void setiCodOrg   (int param) { this.iCodOrg    = param; }
public void setsDescripcion(String param) { this.sDescripcion = param; }
public void setsCodProdDC  (String param) { this.sCodProdDC   = param; }

public String getsDescripcion () { return this.sDescripcion;}
public int getiCodGrupo       () { return this.iCodGrupo;}
public int getiCodProd        () { return this.iCodProd;}
public int getiCodOrg         () { return this.iCodOrg;}
public String getsCodProdDC   () { return this.sCodProdDC;}
}
