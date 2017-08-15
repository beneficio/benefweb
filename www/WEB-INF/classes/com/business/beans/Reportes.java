/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.business.beans;
import java.util.LinkedList;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import com.business.util.*;
import com.business.db.*;

/**
 *
 * @author Rolando Elisii
 */
public class Reportes {

    private int numReporte = 0;
    private int dia = 0;
    private String tipoEjecucion = null;
    private String frecuencia = null;
    private String usuario  = null;
    private String nomArchivo  = null;
    private String categoriaUsuario = null;
    private String estado    = null;
    private LinkedList lParametros = null;
    private String descripcion = null;
    private String titulo    = null;
    private String fuente      = null;
    private String sobreescribe = null;
    private String sMensError           = "";
    private int  iNumError              = 0;
    private String carpetaDestino = null;
    private int zona = 0;
    private int oficina = 0;
    private CallableStatement cons = null;

    /** Creates a new instance of Asegurado */
    public Reportes () {
    }

    public int getnumReporte () { return this.numReporte; }
    public int getdia () { return this.dia; }
    public String gettipoEjecucion () { return this.tipoEjecucion; }
    public String getfrecuencia () { return this.frecuencia; }
    public String getusuario  () { return this.usuario; }
    public String getnomArchivo  () { return this.nomArchivo; }
    public String getcategoriaUsuario () { return this.categoriaUsuario; }
    public String getestado    () { return this.estado; }
    public LinkedList getParametros  () { return this.lParametros; }
    public String getdescripcion  () { return this.descripcion; }
    public String gettitulo  () { return this.titulo; }
    public String getfuente () { return this.fuente; }
    public String getsobreescribe () { return this.sobreescribe; }
    public String getcarpetaDestino () { return this.carpetaDestino; }
    public int getzona () { return this.zona; }
    public int getoficina () { return this.oficina; }

    public void setnumReporte (int param) { this.numReporte = param; }
    public void setdia (int param) { this.dia= param; }
    public void settipoEjecucion (String param) { this.tipoEjecucion= param; }
    public void setfrecuencia (String param) { this.frecuencia= param; }
    public void setusuario  (String param) { this.usuario= param; }
    public void setnomArchivo  (String param) { this.nomArchivo= param; }
    public void setcategoriaUsuario (String param) { this.categoriaUsuario= param; }
    public void setestado    (String param) { this.estado= param; }
    public void setParametros  (LinkedList param) { this.lParametros = param; }
    public void setdescripcion  (String param) { this.descripcion= param; }
    public void settitulo  (String param) { this.titulo = param; }
    public void setfuente  (String param) {this.fuente = param; }
    public void setsobreescribe  (String param) {this.sobreescribe = param; }
    public void setcarpetaDestino (String param) {this.carpetaDestino = param; }
    public void setzona (int param) { this.zona= param; }
    public void setoficina (int param) { this.oficina= param; }

    public String getsMensError  () {
        return this.sMensError ;
    }
    public void setsMensError  (String psMensError ) {
        this.sMensError  = psMensError ;
    }

    public int getiNumError  () {
        return this.iNumError ;
    }

    public void setiNumError  (int piNumError ) {
        this.iNumError  = piNumError;
    }

    public LinkedList getDBParametros ( Connection dbCon) throws SurException {
        LinkedList lCob = new LinkedList();
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("RPT_GET_ALL_PARAMETROS(?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getnumReporte());
            cons.execute();

            ResultSet rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    ParametroReporte oParam = new ParametroReporte();
                    oParam.setnumReporte        (this.getnumReporte());
                    oParam.setnomParametro      (rs.getString("NOM_PARAMETRO"));
                    oParam.settypeParametro     (rs.getString("TYPE_PARAMETRO"));
                    oParam.setvalorParametro    (rs.getString("VALOR_PARAMETRO"));
                    oParam.setorden             (rs.getInt ("ORDEN"));
                    oParam.setvalorDefecto      (rs.getString ("DEFAULT"));
                    oParam.setmcaHoy            (rs.getString ("MCA_HOY"));
                    oParam.setsumaDias          (rs.getInt ("SUMA_DIAS"));
                    lCob.add    (oParam);
                }
                rs.close();
            }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
              return lCob;
        }
    }
}

