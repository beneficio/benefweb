/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.business.util;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;

import com.business.db.*;

/**
 *
 * @author Rolando Elisii
 */
public class Error {
    private int  iCodError              = 0;
    private String sMensError           = new String();
    private int iProcedencia            = 0;

    private CallableStatement cons = null;

    public Error (){
    }

    public String getsMensError  () {
        return this.sMensError ;
    }
    public void setsMensError  (String psMensError ) {
        this.sMensError  = psMensError ;
    }

    public int getiCodError  () {
        return this.iCodError ;
    }

    public void setiCodError  (int piNumError ) {
        this.iCodError  = piNumError;
    }

    public void setiProcedencia ( int pProcedencia){
        this.iProcedencia = pProcedencia;
    }

    public int getiProcedencia (){
        return this.iProcedencia;
    }

    public Error getDB ( Connection dbCon) throws SurException {

       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_DESC_ERROR (?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.VARCHAR);
            cons.setInt (2, this.getiProcedencia());
            cons.setInt (3, this.getiCodError());

            cons.execute();

            this.setsMensError( cons.getString (1) );

        }  catch (SQLException se) {
                setiCodError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Class Error [getDB]" + se.getMessage());
        } catch (Exception e) {
                setiCodError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Class Error [getDB]" + e.getMessage());
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

