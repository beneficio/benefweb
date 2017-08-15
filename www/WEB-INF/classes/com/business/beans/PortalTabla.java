package com.business.beans;

/**
 *
 * @author Rolando Elisii
 */
public class PortalTabla {
    
    private int codPortal   = 0;
    private int fila        = 0;
    private int columna     = 0;
    private int ancho       = 0;
    private String texto    = null;
  
    public PortalTabla () {
    }

    public int getcodPortal () { return this.codPortal; }
    public int getfila () { return this.fila; }
    public int getcolumna () { return this.columna; }
    public int getancho () { return this.ancho; }
    public String gettexto () { return this.texto; }

    public void setcodPortal  (int param) { this.codPortal = param; }
    public void setfila  (int param) { this.fila = param; }
    public void setcolumna  (int param) { this.columna = param; }
    public void setancho  (int param) { this.ancho = param; }
    public void settexto      (String param) { this.texto = param; }
}
