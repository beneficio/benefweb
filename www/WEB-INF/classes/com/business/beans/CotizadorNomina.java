package com.business.beans;
/**
 *
 * @author Rolando Elisii
 */
import com.business.db.*;
import com.business.util.*;
import java.sql.*;
import java.util.Date;

public class CotizadorNomina {

/**
 *
 * @author Rolando Elisii
 */


    private int    numCotizacion   ;
    private int    edad;
    private int    antiguedad;
    private double sumaAsegMuerte;
    private double sueldo;
    private int cantSueldos;
    private Date fechaNac;
    private int    iNumError = 0;
    private String sMensError = "";
    private double tasaPrima;
    private double tasaPremio;
    private String userid;

    /* Nomina C1: Fecha Nac/Edad, antiguedad, sueldo
     * Nomina C2: Fecha Nac/Edad, cantSueldos, sueldo
     * NOmina C3: Fecha Nac/Edad, SumaAsegMuerte
     */

  public CotizadorNomina () {
  }

    public int    getnumCotizacion  (){ return this.numCotizacion;}
    public int    getedad           (){ return this.edad;}
    public int    getantiguedad     (){ return this.antiguedad;}
    public double getsumaAsegMuerte (){ return this.sumaAsegMuerte;}
    public double getsueldo         (){ return this.sueldo;}
    public int getcantSueldos    (){ return this.cantSueldos;}
    public Date   getfechaNac       (){ return this.fechaNac;}
    public double gettasaPrima     (){ return this.tasaPrima;}
    public double gettasaPremio  (){ return this.tasaPremio;}
    public String getuserid         (){ return this.userid; }
    public int    getiNumError      (){ return this.iNumError;}
    public String getsMensError     (){ return this.sMensError; }


    public void setnumCotizacion        (int param )   {this.numCotizacion = param ;}
    public void setedad                 (int param)    {this.edad = param;}
    public void setantiguedad           (int param)    {this.antiguedad = param;}
    public void setiNumError            (int param)    {this.iNumError   = param;    }
    public void setsMensError           (String param) {this.sMensError  = param;    }
    public void setsumaAsegMuerte       (double param) {this.sumaAsegMuerte = param;}
    public void setsueldo               (double param) {this.sueldo = param;}
    public void setcantSueldos          (int param) {this.cantSueldos = param;}
    public void setfechaNac             (Date param)   {this.fechaNac = param;}
    public void settasaPrima           (double param) {this.tasaPrima = param;}
    public void settasaPremio        (double param) {this.tasaPremio = param;}
    public void setuserid               (String param) {this.userid  = param;    }

    
    public void setDBAsegurado  ( Connection dbCon, int codRama, int codSubRama,
            int codProducto, int codProd, int indice ) throws SurException {
    CallableStatement cons = null;

       try {
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall("COT_ADD_ASEGURADO (?,?,?,?,?,?,?,? ,?,?,?,?,?)"));
            cons.registerOutParameter   (1, java.sql.Types.INTEGER);
            cons.setInt (2, codRama);
            cons.setInt (3, codSubRama);
            cons.setInt (4, codProducto);
            cons.setInt (5, codProd);
            cons.setInt (6, this.getnumCotizacion());
            if (this.fechaNac == null ) {
                cons.setNull    (7, Types.DATE);
           } else {
                cons.setDate    (7, Fecha.convertFecha(this.getfechaNac()));
           }

            cons.setInt     (8, this.getedad());
            cons.setInt     (9, this.getantiguedad());
            cons.setInt     (10, this.getcantSueldos());
            cons.setDouble  (11, this.getsumaAsegMuerte());
            cons.setDouble  (12, this.getsueldo());
            cons.setString  (13, this.getuserid());
            cons.setInt     (14, indice);

            cons.execute();

            this.setiNumError(cons.getInt (1));

            System.out.println ("en CotizadorNomina " + this.getiNumError());

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
        }
    }

}
