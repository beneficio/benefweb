package com.business.beans;

import com.business.db.db;
import com.business.util.SurException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Date;

    
public class PreliqResp {

    private int numPreliq = 0;
    private String sDescripcion;
    private String sUserid ;

    private String sMensError = new String ();
    private int    iNumError = 0;



    public PreliqResp (int numPreliq, String sDescripcion, String sUser){
        this.numPreliq = numPreliq;
        this.sDescripcion = sDescripcion;
        this.sUserid = sUser;
    }
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
 
    public PreliqResp setDB (Connection dbCon, int numFila)  throws SurException {
        CallableStatement cons = null;
        try {
           dbCon.setAutoCommit(true);           
           cons = dbCon.prepareCall(db.getSettingCall( "CO_SET_PRELIQ_RESP (?, ?, ?, ?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt    (2, this.numPreliq);
           cons.setString (3, this.sDescripcion);
           cons.setString (4, this.sUserid);
           cons.setInt    (5, numFila);

           cons.execute();
           this.setiNumError(cons.getInt (1));

        }  catch (SQLException se) {
            this.setiNumError(-1);
            this.setsMensError("PreliqResp[setDB]" + se.getMessage());
        } catch (Exception e) {
            this.setiNumError(-1);
            this.setsMensError("PreliqResp[setDB]" + e.getMessage());

        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                this.setiNumError(-1);
                this.setsMensError("PreliqResp[setDB]" + see.getMessage());

            }
            return this;
        }
    }
}
