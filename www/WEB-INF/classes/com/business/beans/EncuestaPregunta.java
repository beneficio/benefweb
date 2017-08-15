/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.business.beans;
  
import com.business.db.db;
import com.business.util.SurException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.LinkedList;



/**
 *
 * @author silvio
 */
public class EncuestaPregunta {

 
    
    private int    numEncuesta = 0;
    private int    numPregunta = 0;
    private String pregunta ="";
    private String multipleChoise ="";
    private Date   fechaTrabajo=null;
    private String userId ="";
    private int    cantOpcion = 0;
    private LinkedList lOpcion = null;

    private String sMensError           = "";
    private int    iNumError              = 0;

    public EncuestaPregunta(){};

    public Date getFechaTrabajo() {
        return fechaTrabajo;
    }

    public void setFechaTrabajo(Date fechaTrabajo) {
        this.fechaTrabajo = fechaTrabajo;
    }

    public String getMultipleChoise() {
        return multipleChoise;
    }

    public void setMultipleChoise(String multipleChoise) {
        this.multipleChoise = multipleChoise;
    }

    public int getNumEncuesta() {
        return numEncuesta;
    }

    public void setNumEncuesta(int numEncuesta) {
        this.numEncuesta = numEncuesta;
    }

    public int getNumPregunta() {
        return numPregunta;
    }

    public void setNumPregunta(int numPregunta) {
        this.numPregunta = numPregunta;
    }

    public String getPregunta() {
        return pregunta;
    }

    public void setPregunta(String pregunta) {
        this.pregunta = pregunta;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public int getCantOpcion() {
        return cantOpcion;
    }

    public void setCantOpcion(int cantOpcion) {
        this.cantOpcion = cantOpcion;
    }

    public LinkedList getLOpcion() {
        return lOpcion;
    }

    public void setLOpcion(LinkedList lOpcion) {
        this.lOpcion = lOpcion;
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


    public LinkedList getDBOpciones ( Connection dbCon) throws SurException {
        LinkedList lOpcion = new LinkedList();
        ResultSet rs = null;
        CallableStatement cons = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("ENC_GET_OPCIONES (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getNumEncuesta());
            cons.setInt (3, this.getNumPregunta ());
            cons.execute();
            rs = (ResultSet) cons.getObject(1);

            if (rs != null) {
                while (rs.next()) {
                    EncuestaOpcion oEncOpc = new EncuestaOpcion();
                   
                     oEncOpc.setNumEncuesta(rs.getInt("NUM_ENCUESTA"));
                     oEncOpc.setNumPregunta(rs.getInt("NUM_PREGUNTA"));
                     oEncOpc.setNumOpcion(rs.getInt("NUM_OPCION"));
                     oEncOpc.setDescripcion(rs.getString("DESCRIPCION"));
                     oEncOpc.setMcaCampoAbierto(rs.getString("MCA_CAMPO_ABIERTO"));
                     oEncOpc.setLongCampoAbierto(rs.getInt("LONG_CAMPO_ABIERTO"));
                     oEncOpc.setFechaTrabajo(rs.getDate("FECHA_TRABAJO"));
                     oEncOpc.setUserId(rs.getString("USERID"));


                    

                    lOpcion.add(oEncOpc );
                }
                rs.close();
            }
            
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error EncuestaPregunta [getDBOpciones]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error EncuestaPregunta [getDBOpciones]" + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return lOpcion;
        }
    }



}
