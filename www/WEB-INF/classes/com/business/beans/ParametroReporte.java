/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.business.beans;

/**
 *
 * @author Rolando Elisii
 */
public class ParametroReporte {
    private int numReporte = 0;
    private int orden = 0;
    private String nomParametro   = null;
    private String typeParametro  = null;
    private String valorParametro = null;
    private String valorDefecto   = null;
    private String mcaHoy         = null;
    private int sumaDias          = 0;

    /** Creates a new instance of Asegurado */
    public ParametroReporte () {
    }

    public int getnumReporte () { return this.numReporte; }
    public int getorden () { return this.orden; }
    public String getnomParametro () { return this.nomParametro; }
    public String gettypeParametro () { return this.typeParametro; }
    public String getvalorParametro  () { return this.valorParametro; }
    public String getvalorDefecto   () { return this.valorDefecto; }
    public int getsumaDias          () { return this.sumaDias; }
    public String getmcaHoy  () { return this.mcaHoy; }

    public void setnumReporte (int param) { this.numReporte = param; }
    public void setorden (int param) { this.orden= param; }
    public void setnomParametro (String param) { this.nomParametro= param; }
    public void settypeParametro (String param) { this.typeParametro= param; }
    public void setvalorParametro  (String param) { this.valorParametro= param; }
    public void setvalorDefecto  (String param) { this.valorDefecto= param; }
    public void setsumaDias (int param) { this.sumaDias = param; }
    public void setmcaHoy (String param) { this.mcaHoy = param; }

}
