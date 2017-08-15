/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
   
package com.business.beans;
import com.business.db.db;
import com.business.util.Fecha;
import com.business.util.SurException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Date;
/**
 *
 * @author silvio
 */
public class EncuestaRespuesta {
 
    private int    numEncuesta = 0;
    private int    numPregunta = 0;
    private int    numOpcion = 0;
    private String campoAbierto = "";
    private String origen = "";
    private Date   fechaTrabajo=null;
    private String userId ="";
    private String navegador = "";

    private String sMensError           = "";
    private int  iNumError              = 0;

    public EncuestaRespuesta(){}

    public int getNumEncuesta() {
        return numEncuesta;
    }

    public void setNumEncuesta(int numEncuesta) {
        this.numEncuesta = numEncuesta;
    }

    public String getCampoAbierto() {
        return campoAbierto;
    }

    public void setCampoAbierto(String campoAbierto) {
        this.campoAbierto = campoAbierto;
    }

    public Date getFechaTrabajo() {
        return fechaTrabajo;
    }

    public void setFechaTrabajo(Date fechaTrabajo) {
        this.fechaTrabajo = fechaTrabajo;
    }

    public String getNavegador() {
        return navegador;
    }

    public void setNavegador(String navegador) {
        this.navegador = navegador;
    }

    public int getNumOpcion() {
        return numOpcion;
    }

    public void setNumOpcion(int numOpcion) {
        this.numOpcion = numOpcion;
    }

    public int getNumPregunta() {
        return numPregunta;
    }

    public void setNumPregunta(int numPregunta) {
        this.numPregunta = numPregunta;
    }

    public String getOrigen() {
        return origen;
    }

    public void setOrigen(String origen) {
        this.origen = origen;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

     public String getsMensError() {
        return sMensError;
    }

    public void setsMensError(String sMensError) {
        this.sMensError = sMensError;
    }

    public int getiNumError() {
        return iNumError;
    }

    public void setiNumError(int iNumError) {
        this.iNumError = iNumError;
    }

        public EncuestaRespuesta delDBRespuestasByNumEncuesta ( Connection dbCon) throws SurException {
        CallableStatement cons = null;
        try {
           dbCon.setAutoCommit(true);
           cons = dbCon.prepareCall(db.getSettingCall( "ENC_DEL_ENCUESTA_RESPUESTA(?, ?, ?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getNumEncuesta());
           cons.setString           (3, this.getOrigen());
           cons.setString           (4, this.getUserId());

           cons.execute();
           this.setiNumError(cons.getInt (1));
        }  catch (SQLException se) {
            //System.out.println("error del 1" + se.getMessage());
            throw new SurException("Error SQL al generar borrar Encuesta: " + se.getMessage());
        } catch (Exception e) {
            //System.out.println("error del 2" + e.getMessage());
            throw new SurException("Error Java al borrar Encuesta:: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    } // delDB
  

    public int setDB(Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        int res = -1;        
        try {
           dbCon.setAutoCommit(true);
           cons = dbCon.prepareCall(db.getSettingCall( "ENC_SET_RESPUESTA ( ?, ?, ?, ?, ?, ?, ?, ? )"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);           
           cons.setInt              (2, this.getNumEncuesta());
           cons.setInt              (3, this.getNumPregunta());
           cons.setInt              (4, this.getNumOpcion());
           cons.setString           (5, this.getCampoAbierto());
           cons.setString           (6, this.getOrigen());
           if (this.getFechaTrabajo() == null) {
               cons.setNull(7, java.sql.Types.DATE);
           } else {
               cons.setDate(7, Fecha.convertFecha(this.getFechaTrabajo()));
           }
           cons.setString (8,this.getUserId());
           cons.setString (9, this.getNavegador());
           cons.execute();
           res = cons.getInt (1);



        }  catch (SQLException se) {
            System.out.println(" Error se " + se.getMessage());
            throw new SurException("Error SQL EncuestaRespuesta [setDB]: " + se.getMessage());
        } catch (Exception e) {
            System.out.println(" Error e " + e.getMessage());
            throw new SurException("Error EncuestaRespuesta [setDB]: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return res;
        }
    }




}
