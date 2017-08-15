package com.business.beans;

/**
 *
 * @author Rolando Elisii
 */
public class PortalTexto {
    
    private int codPortal   = 0;
    private String titulo   = null;
    private String texto    = null;
  
    public PortalTexto () {
    }

    public int getcodPortal () { return this.codPortal; }
    public String gettitulo () { return this.titulo; }
    public String gettexto () { return this.texto; }

    public void setcodPortal  (int param) { this.codPortal = param; }
    public void settitulo     (String param) { this.titulo = param; }
    public void settexto      (String param) { this.texto = param; }

}
