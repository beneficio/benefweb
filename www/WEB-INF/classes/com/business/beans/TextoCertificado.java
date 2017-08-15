/*
 * Certificado.java
 *
 * Created on 9 de enero de 2005, 19:37
 */

package com.business.beans;

import java.util.Date;
/**
 *
 * @author Rolando Elisii
 */
public class TextoCertificado {
    
    private String tipoCertificado = "PR";
    private int numCertificado     = 0;
    private int secuencia            = 0;
    private int numRenglon         = 0;
    private String codTexto   = "N";
    private String tipoTexto       = "N";
    private String texto   = "N";
    private String imprBenef       = "N";    
    private String imprReducido    = "S";    
    private String imprOriginal    = "N";
    private int tipoEnvioOrig      = 1;  // 1: correo, 2:mensajeria 
    private String userId          = "";
    private Date fechaTrabajo      = null;
    private Date horaOperacion     = null;
    
    /** Creates a new instance of Certificado */
    public TextoCertificado() {
    }

    public void settipoCertificado (String param) { this.tipoCertificado = param; }
    public void setnumCertificado     (int param) { this.numCertificado = param; }
    public void setsecuencia            (int param) { this.secuencia = param; }
    public void setnumRenglon         (int param) { this.numRenglon = param; }
    public void setcodTexto   (String param) { this.codTexto = param; }
    public void settipoTexto       (String param) { this.tipoTexto = param; }
    public void settexto   (String param) { this.texto = param; }

    public String gettipoCertificado  () { return tipoCertificado; }
    public int getnumCertificado      () { return  this.numCertificado;}
    public int getsecuencia             () { return  this.secuencia;}
    public int getnumRenglon          () { return  this.numRenglon;}
    public String getcodTexto    () { return this.codTexto;}
    public String gettipoTexto        () { return this.tipoTexto;}
    public String gettexto    () { return this.texto;}
    
}
