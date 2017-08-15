package com.business.beans;
/**
 *
 * @author Rolando Elisii
 */
import com.business.db.*;
import com.business.util.*;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;

public class CotizadorSumas {

/**
 *
 * @author Rolando Elisii
 */


    private int    numCotizacion   ;
    private int    cantVidas;
    private int    edadDesde;
    private int    edadHasta;
    private double sumaAsegMuerte;
    private double sumaAsegInvalidez;
    private double maxSumaAsegMuerte;
    private double maxSumaAsegInvalidez;
    private double minSumaAsegMuerte;
    private double minSumaAsegInvalidez;
    private double tasaMuerte;
    private double tasaInvalidez;
    private String userid;
    private int    iNumError = 0;
    private String sMensError = "";

  public CotizadorSumas() {
  }

    public int    getnumCotizacion (){ return this.numCotizacion;}
    public int    getcantVidas     (){ return this.cantVidas;}
    public int    getedadDesde     (){ return this.edadDesde;}
    public int    getedadHasta     (){ return this.edadHasta;}
    public double getsumaAsegMuerte(){ return this.sumaAsegMuerte;}
    public double getsumaAsegInvalidez(){ return this.sumaAsegInvalidez;}
    public double getmaxSumaAsegMuerte(){ return this.maxSumaAsegMuerte;}
    public double getmaxSumaAsegInvalidez(){ return this.maxSumaAsegInvalidez;}
    public double getminSumaAsegMuerte(){ return this.minSumaAsegMuerte;}
    public double getminSumaAsegInvalidez(){ return this.minSumaAsegInvalidez;}
    public double gettasaMuerte(){ return this.tasaMuerte;}
    public double gettasaInvalidez(){ return this.tasaInvalidez;}
    public String getuserid        (){ return this.userid; }
    public int    getiNumError     (){ return this.iNumError;}
    public String getsMensError    (){ return this.sMensError; }


    public void setnumCotizacion(int param ){this.numCotizacion = param ;}
    public void setcantVidas    (int param )  {this.cantVidas = param ;}
    public void setedadDesde    (int param)   {this.edadDesde = param;}
    public void setedadHasta    (int param)   {this.edadHasta = param;}
    public void setiNumError    (int param)   {this.iNumError   = param;    }
    public void setsMensError   (String param){this.sMensError  = param;    }
    public void setsumaAsegMuerte       (double param) {this.sumaAsegMuerte = param;}
    public void setsumaAsegInvalidez    (double param) {this.sumaAsegInvalidez = param;}
    public void setmaxSumaAsegMuerte    (double param) {this.maxSumaAsegMuerte = param;}
    public void setmaxSumaAsegInvalidez (double param) {this.maxSumaAsegInvalidez = param;}
    public void setminSumaAsegMuerte    (double param) {this.minSumaAsegMuerte = param;}
    public void setminSumaAsegInvalidez (double param) {this.minSumaAsegInvalidez = param;}
    public void settasaMuerte           (double param) {this.tasaMuerte = param;}
    public void settasaInvalidez        (double param) {this.tasaInvalidez = param;}
    public void setuserid               (String param){this.userid  = param;    }

    public CotizadorSumas setDBEdadSumaAseg  ( Connection dbCon, int indice, int codRama, int codSubRama, int codProducto, int codProd  ) throws SurException {
    CallableStatement cons = null;

       try {
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall("COT_ADD_EDAD_SUMA_ASEG (?,?,?,?,?,?,?,? ,?,?,?,?)"));
            cons.registerOutParameter   (1, java.sql.Types.INTEGER);
            cons.setInt     (2, this.getnumCotizacion());
            cons.setInt     (3, codRama);
            cons.setInt     (4, codSubRama);
            cons.setInt     (5, codProducto);
            cons.setInt     (6, codProd);
            cons.setInt     (7, this.getedadDesde());
            cons.setInt     (8, this.getedadHasta());
            cons.setInt     (9, this.getcantVidas());
            cons.setDouble  (10, this.getsumaAsegMuerte());
            cons.setDouble  (11, this.getsumaAsegInvalidez());
            cons.setString  (12, this.getuserid());
            cons.setInt     (13, indice);

System.out.println ("indice --> " + indice);

            cons.execute();

            this.setiNumError(cons.getInt (1));

       }  catch (SQLException se) {
           this.setiNumError(-1);
           this.setsMensError(se.getMessage());
        } catch (Exception e) {
           this.setiNumError(-1);
           this.setsMensError(e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }

}
