package com.business.beans;
import com.business.db.db;
import com.business.util.Fecha;
import com.business.util.SurException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
      
public class OrdenPagoDet {

    private int    numItem = 0; 
    private int    anioMes = 0;
    private String item    = "";  
    private String codProdDC  = "";  
    private double impNeto      = 0;
    private double impIva       = 0;
    private double impOP        = 0;
    private int    numSecuOp = 0;
    private String sMensError = new String ();
    private int    iNumError = 0;
    private CallableStatement cons = null;

    public OrdenPagoDet (){
    }


    public int getanioMes() {
        return anioMes;
    }

    public void setanioMes(int param) {
        this.anioMes = param;
    }

    public int getnumItem() {
        return numItem;
    }

    public void setnumItem (int param) {
        this.numItem = param;
    }

    public String getitem () {
        return item;
    }

    public void setitem (String param) {
        this.item = param;
    }

    public void setnumSecuOp (int imp) {
        this.numSecuOp = imp;
    }
    
    public double getimpOP() {
        return impOP;
    }

    public void setimpOP (double param) {
        this.impOP = param;
    }
    
    public double getimpNeto () {
        return impNeto;
    }

    public void setimpNeto (double impNeto) {
        this.impNeto = impNeto;
    }
    public double getimpIva() {
        return impIva;
    }

    public void setimpIva(double param) {
        this.impIva = param;
    }


    public String getcodProdDC() {
        return codProdDC;
    }

    public void setcodProdDC (String codProdDC) {
        this.codProdDC = codProdDC;
    }
    public int getNumSecuOp () {
        return numSecuOp;
    }
    // Error
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
   
    public void setDB (Connection dbCon) throws SurException {
    
      try {
           dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall( "OP_SET_ORDEN_PAGO_DET (?,?,?, ?, ?, ?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt    (2, this.getNumSecuOp());
            cons.setInt    (3, this.getnumItem());
            cons.setString (4, this.getitem());
            cons.setInt    (5, this.getanioMes());
            cons.setDouble (6, this.getimpNeto());
            cons.setString (7, this.getcodProdDC());
            cons.setDouble (8, this.getimpOP());
            
            cons.execute();
            
            this.setiNumError(cons.getInt (1));
           
      }  catch (SQLException se) {
            this.setiNumError(-1);
            this.setsMensError("Error en OrdenPagoDet [setDB]: " + se.getMessage());
        } catch (Exception e) {
            this.setiNumError(-1);
            this.setsMensError("Error en OrdenPagoDet [setDB]: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }
    
    
}
