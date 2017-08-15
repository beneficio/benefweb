/*
 * ControlDeUso.java
 *
 * Created on 9 de diciembre de 2003, 11:20
 */
    
package com.business.util;
           
import com.business.db.*;
import com.business.util.Fecha;
import com.business.util.SurException;
import com.business.interfaces.MaestroInfo;
import com.business.interfaces.InterReport;  
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;

/**
 *
 * @author  surprogra
 */
public class ControlDeUso {
    
    /** Creates a new instance of ControlDeUso */
    private final String sRedLocal []   = { "192.168" };
    private String sIPRemote            = new String ();
    private int iCodProcedencia         = 1;
    private int iCodProd                = 0;
    private String sDescProcedencia     = new String ();
    private String sUsuario             = new String ();
    private java.util.Date dFechaAcceso = new java.util.Date (); 
    private String sBrowser             = "";
    private String sVersion             = "";
    private String sOS                  = "";
    private String sMensError           = new String();
    private int  iNumError              = 0;
     
    
    private CallableStatement cons = null;

    public ControlDeUso() {
    }
    
    public ControlDeUso (String usuario, String IPRemote) {
        this.sUsuario = usuario;
        this.sIPRemote = IPRemote;
    }

    public ControlDeUso (String usuario, String IPRemote, int iCodProd) {
        this.sUsuario = usuario;
        this.sIPRemote = IPRemote;
        this.iCodProd  = iCodProd;
    }

        public ControlDeUso (String usuario, String IPRemote, int iCodProd, String sBrowser, String sVersion, String sOS) {
        this.sUsuario = usuario;
        this.sIPRemote = IPRemote;
        this.iCodProd  = iCodProd;
        this.sBrowser  = sBrowser;
        this.sVersion  = sVersion;
        this.sOS       = sOS;
    }

    public void setearAcceso (Connection dbCon, int codProcedencia) throws SurException { 
     try {
        boolean bEsLocal = false;
        
        for (int i = 0; i < this.sRedLocal.length; i++) {
            if (this.sIPRemote.startsWith(this.sRedLocal [i])) {
                bEsLocal = true;
                break;
            }
        }
        
        if (! bEsLocal) {
            this.iCodProcedencia = codProcedencia;
            this.setDB(dbCon);
        }
     } catch (SurException se) {
         throw new SurException (se.getMessage());
     }
    }
    
    public int getiNumError  () {
        return this.iNumError ;
    }
    
    public void setiNumError  (int piNumError ) {
        this.iNumError  = piNumError;
    }
    
    public String getsMensError  () {
        return this.sMensError ;
    }
    
    public void setsMensError  (String psMensError ) {
        this.sMensError  = psMensError ;
    }

    public void setDB(Connection dbCon) throws SurException {
    
      try {
           dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall( "US_SET_PROCEDENCIA (?,?,?,?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setString (2, sUsuario);
            cons.setInt (3, this.iCodProcedencia);
            cons.setInt (4, iCodProd);
            cons.setString(5, this.sBrowser);
            cons.setString(6, this.sVersion);
            cons.setString(7, this.sOS);
            cons.setString(8, this.sIPRemote);
            cons.execute();
          
      }  catch (SQLException se) {
		throw new SurException("Error al obtener la solicitud: " + se.getMessage());
        } catch (Exception e) {
		throw new SurException("Error al obtener la solicitud: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }
}
