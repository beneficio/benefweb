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
public class Parametro {
    private String sCodigo   = null;
    private String sValor    = null;
    private String sUserid   = null;
    private String sMensError= new String();
    private int  iNumError   = 0;

    public Parametro (){
    }

    public String getsValor  () {
        return this.sValor ;
    }
    public void setsValor  (String psValor ) {
        this.sValor  = psValor ;
    }

    public String getsCodigo  () {
        return this.sCodigo ;
    }

    public void setsCodigo  (String psNumError ) {
        this.sCodigo  = psNumError;
    }

    public String getsUserid  () {
        return this.sUserid ;
    }
    public void setsUserid  (String psValor ) {
        this.sUserid  = psValor ;
    }

    public String getsMensError  () { return this.sMensError;}
    public void setsMensError  (String psMensError ) {this.sMensError = psMensError;}
    public int getiNumError  () {return this.iNumError;}
    public void setiNumError  (int piNumError ) {this.iNumError  = piNumError;}


    public String  getDBValor ( Connection dbCon) throws SurException {
       CallableStatement cons  = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PARAM_GET_VALOR_PARAMETRO (?)"));
            cons.registerOutParameter(1, java.sql.Types.VARCHAR);
            cons.setString (2, this.getsCodigo() );
            cons.execute();
            this.setsValor(cons.getString(1));

            cons.close();

        }  catch (SQLException se) {
		throw new SurException("Class Error [getDB]" + se.getMessage());
        } catch (Exception e) {
		throw new SurException("Class Error [getDB]" + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this.getsValor();
        }
    }

    public Parametro setDB ( Connection dbCon) throws SurException {
       CallableStatement cons  = null;
       try {
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall("PARAM_SET_PARAMETRO (?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setString (2, this.getsCodigo());
            cons.setString (3, this.getsValor());
            cons.setString (4, this.getsUserid());
            cons.execute();

            this.setiNumError(cons.getInt(1));

        }  catch (SQLException se) {
                this.setiNumError(-1);
                this.setsMensError(se.getMessage());
		throw new SurException("Class Error [setDB]" + se.getMessage());
        } catch (Exception e) {
                this.setiNumError(-1);
                this.setsMensError(e.getMessage());
		throw new SurException("Class Error [setDB]" + e.getMessage());
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

