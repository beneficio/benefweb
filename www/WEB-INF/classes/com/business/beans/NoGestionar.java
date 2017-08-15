/*
 * Certificado.java
 *
 * Created on 9 de enero de 2005, 19:37
 */
     
package com.business.beans;
  
import java.util.Date;
import java.util.GregorianCalendar;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;  
import java.sql.CallableStatement;
import com.business.db.*;
import com.business.util.*;

public class NoGestionar {
    
    private int codRama            = 0;
    private int numPoliza          = 0;
    private int numEndoso          = 0;
    private Date fechaHasta        = null;
    private String estado          = "";
    private String userId          = "";
    private Date fechaTrabajo      = null;
    private Date horaOperacion     = null;
    private int zona               = 0;
    private int nivel              = 0;
    private int numTomador         = 0;
    private String motivo          =  "";
  
    private String sMensError           = new String();
    private int  iNumError              = 0;
    private CallableStatement cons = null;
    
    /** Creates a new instance of Certificado */
    public NoGestionar() {
    }

    public void setfechaHasta      (Date param) { this.fechaHasta = param; }
    public void setcodRama            (int param) { this.codRama = param; }
    public void setestado             (String param) { this.estado = param; }
    public void setnumPoliza          (int param) { this.numPoliza  = param; }
    public void setnumEndoso          (int param) { this.numEndoso  = param; }
    public void setuserId             (String param) { this.userId = param; }
    public void setfechaTrabajo       (Date param) { this.fechaTrabajo = param; }
    public void sethoraOperacion      (Date param) { this.horaOperacion = param; }
    public void setnivel              (int param) { this.nivel = param; }
    public void setzona               (int param) { this.zona  = param; }
    public void setnumTomador         (int param) { this.numTomador  = param; }
    public void setmotivo             (String param) { this.motivo = param; }


    public Date getfechaHasta       () { return  this.fechaHasta;}
    public int getcodRama             () { return  this.codRama;}
    public String getestado           () { return this.estado;}
    public int getnumPoliza           () { return this.numPoliza;}    
    public int getnumEndoso           () { return this.numEndoso;}    
    public String getuserId           () { return this.userId;}
    public Date getfechaTrabajo       () { return  this.fechaTrabajo;}
    public Date gethoraOperacion      () { return  this.horaOperacion;}
    public int getnivel               () { return  this.nivel;}
    public int getzona                () { return  this.zona;}
    public int getnumTomador          () { return this.numTomador;}
    public String getmotivo           () { return this.motivo;}

    public String getsMensError  () { return this.sMensError;}
    public void setsMensError  (String psMensError ) {this.sMensError = psMensError;}
    public int getiNumError  () {return this.iNumError;}
    public void setiNumError  (int piNumError ) {this.iNumError  = piNumError;}
    
    public NoGestionar getDB ( Connection dbCon) throws SurException {
        ResultSet rs = null;
        boolean bExiste = false;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("CO_GET_NO_GESTIONAR (?,?,?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodRama());
            cons.setInt (3, this.getnumPoliza ());
            cons.setInt (4, this.getnumEndoso());
            cons.setInt (5, this.getzona () );
            cons.setInt (6, this.getnivel ());//nivel 1 = pOLIZA, 2: ENDOSO; 3 ZONA
            cons.setInt (7, this.getnumTomador());
            cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    bExiste     = true;
                    this.setcodRama     (rs.getInt ("COD_RAMA"));
                    this.setnumPoliza   (rs.getInt ( "NUM_POLIZA" ));
                    this.setnumEndoso   (rs.getInt ("ENDOSO"));
                    this.setfechaTrabajo(rs.getDate ("FECHA_TRABAJO"));
                    this.setuserId      (rs.getString ("USERID"));
                    this.setnivel       (rs.getInt ("NIVEL_EXCLUSION"));
                    this.setfechaHasta  (rs.getDate ("FECHA_HASTA"));
                    this.sethoraOperacion(rs.getTime("HORA_TRABAJO"));
                    this.setzona        (rs.getInt ("ZONA"));
                    this.setnumTomador(rs.getInt ("NUM_TOMADOR"));
                    this.setmotivo (rs.getString ("MOTIVO"));
                }
                rs.close();
            }
           if (! bExiste) {
                setiNumError (-100);
                setsMensError ("NO EXISTE ");
           }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error NoGestionar [getDB]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error NoGestionar [getDB]" + e.getMessage());
        } finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }

    public NoGestionar setDB (Connection dbCon )
       throws SurException {

       try {
           dbCon.setAutoCommit(true);
           cons = dbCon.prepareCall(db.getSettingCall("CO_SET_NO_GESTIONAR (?,?,?,?,?,?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt  (2, this.getcodRama());
           cons.setInt  (3, this.getnumPoliza());
           cons.setInt  (4, this.getnumEndoso());
           cons.setInt  (5, this.getnivel());
           if (this.getfechaHasta() == null) {
                cons.setNull(6, java.sql.Types.DATE);
           } else {
                cons.setDate(6, Fecha.convertFecha(this.getfechaHasta())) ;
           }
           cons.setString (7, this.getuserId() );
           cons.setInt    (8, this.getzona() );
           cons.setInt (9, this.getnumTomador());
           cons.setString (10, this.getmotivo());

           cons.execute();
           this.setiNumError(cons.getInt (1));

       }  catch (SQLException se) {
           this.setiNumError(-1);
           this.setsMensError(se.getMessage());
       }  catch (Exception e) {
           this.setiNumError(-1);
           this.setsMensError(e.getMessage());
       } finally {
           try {
               if (cons != null) cons.close();
           } catch (SQLException se) {
               throw new SurException (se.getMessage());
           }
           return this;
       }
    } // setDB

    public NoGestionar deleteDB (Connection dbCon )
       throws SurException {

       try {
           dbCon.setAutoCommit(true);
           cons = dbCon.prepareCall(db.getSettingCall("CO_DELETE_NO_GESTIONAR (?,?,?,?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt  (2, this.getcodRama());
           cons.setInt  (3, this.getnumPoliza());
           cons.setInt  (4, this.getnumEndoso());
           cons.setInt  (5, this.getnivel());
           cons.setString (6, this.getuserId() );
           cons.setInt    (7, this.getzona() );
           cons.setInt(8, this.getnumTomador());

           cons.execute();
           this.setiNumError(cons.getInt (1));

       }  catch (SQLException se) {
           this.setiNumError(-1);
           this.setsMensError(se.getMessage());
       }  catch (Exception e) {
           this.setiNumError(-1);
           this.setsMensError(e.getMessage());
       } finally {
           try {
               if (cons != null) cons.close();
           } catch (SQLException se) {
               throw new SurException (se.getMessage());
           }
           return this;
       }
    } // setDB

}


