/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.business.beans;

/**
 *
 * @author Rolando Elisii
 */
public class RepDestino {

    private int numReporte = 0;
    private int numDestino = 0;
    private String tipoDestino = null;
    private String mail = null;
    private String path  = null;
    private String usuario  = null;
    private String clave = null;
    private String enviarSiempre = "S";

    /** Creates a new instance of Asegurado */
    public RepDestino () {
    }

    public int getnumReporte () { return this.numReporte; }
    public int getnumDestino () { return this.numDestino; }
    public String gettipoDestino () { return this.tipoDestino; }
    public String getmail () { return this.mail; }
    public String getpath  () { return this.path; }
    public String getusuario  () { return this.usuario; }
    public String getclave () { return this.clave; }
    public String getenviarSiempre () { return this.enviarSiempre; }

    public void setnumReporte (int param) { this.numReporte = param; }
    public void setnumDestino (int param) { this.numDestino = param; }
    public void settipoDestino (String param) { this.tipoDestino = param; }
    public void setmail (String param) { this.mail = param; }
    public void setpath  (String param) { this.path = param; }
    public void setusuario  (String param) { this.usuario = param; }
    public void setclave (String param) { this.clave = param; }
    public void setenviarSiempre (String param) { this.enviarSiempre = param; }    
}