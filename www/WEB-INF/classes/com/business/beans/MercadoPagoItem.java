/*
 * Certificado.java
 *
 * Created on 9 de enero de 2005, 19:37
 */
     
package com.business.beans;
  
import java.util.Date;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;  
import java.sql.CallableStatement;
import com.business.db.*;
import com.business.util.*;

public class MercadoPagoItem {

    private int numSecuMercadopago = 0;
    private int numItem            = 0;
    private int codRama            = 0;
    private int numPoliza          = 0;
    private int endoso             = 0;
    private double impItem         = 0;
    private String descRama        = "";

    private String sMensError           = new String();
    private int  iNumError              = 0;
    private CallableStatement cons = null;
    
    /** Creates a new instance of Certificado */
    public MercadoPagoItem() {
    }

    public void setcodRama            (int param) { this.codRama = param; }
    public void setnumPoliza          (int param) { this.numPoliza  = param; }
    public void setendoso          (int param) { this.endoso  = param; }
    public void setimpItem  (double param) { this.impItem = param; }
    public void setdescRama          (String param) { this.descRama      = param; }
    public void setnumSecuMercadopago   (int param) { this.numSecuMercadopago = param; }
    public void setnumitem              (int param) { this.numItem  = param; }

    public int getcodRama             () { return  this.codRama;}
    public int getnumPoliza           () { return this.numPoliza;}    
    public int getendoso           () { return this.endoso;}
    public double getimpItem () { return this.impItem;}
    public String getdescRama         () { return this.descRama;}
    public int    getnumSecuMercadopago () { return this.numSecuMercadopago; }
    public int    getnumItem  () { return this.numItem; }

    public String getsMensError  () { return this.sMensError;}
    public void setsMensError  (String psMensError ) {this.sMensError = psMensError;}
    public int getiNumError  () {return this.iNumError;}
    public void setiNumError  (int piNumError ) {this.iNumError  = piNumError;}

    public void setDB (Connection dbCon) {

      try {
            this.setiNumError( 0 );
            
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall( "MP_SET_MERCADOPAGO_ITEM (?,?,?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt    (2, this.getnumSecuMercadopago() );
            cons.setInt    (3, this.getcodRama() );
            cons.setInt    (4, this.getnumPoliza() );
            cons.setInt    (5, this.getendoso());
            cons.setDouble (6, this.getimpItem());
            cons.setInt    (7, this.getnumItem());

            cons.execute();

            this.setiNumError( cons.getInt (1));

            if (this.getiNumError() == -100 ) {
                this.setsMensError("NUM. DE ITEM INVALIDO");
            }

      }  catch (SQLException se) {
                this.setiNumError( -1 );
                this.setsMensError(se.getMessage());
        } catch (Exception e) {
                this.setiNumError(-1);
                this.setsMensError(e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
            	this.setiNumError(-1);
                this.setsMensError(see.getMessage());
            }
        }
    }

}


