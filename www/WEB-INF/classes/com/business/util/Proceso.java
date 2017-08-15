/*
 * Proceso.java
 *
 * Created on 26 de junio de 2005, 16:14
 */    

package com.business.util;
      
import java.util.Date;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;

import com.business.util.*;
import com.business.db.*;     
import com.business.interfaces.*;
/**
 *
 * @author Rolando Elisii
 */
public class Proceso {

    private String sTabla       = "";
    private Date dFechaFTP      = null;
    private Date dFechaTrabajo  = null;
    private String sSecuencia   = "";
    private int iFilas          = 0;
    private String sDesc        = "";

    private String sMensError       = "";
    private int  iNumError          = 0;
    
    private CallableStatement cons     = null;
    
     /** Creates a new instance of Proceso */
    public Proceso() {
    }

    public String getsTabla     () {return this.sTabla;}
    public String getsDesc     () {return this.sDesc;}
    public Date getdFechaFTP     () {return this.dFechaFTP;}
    public Date getdFechaTrabajo () {return this.dFechaTrabajo;}
    public String  getsSecuencia    () {return this.sSecuencia;}
    public int getiFilas        () {return this.iFilas;}
    
    public void setsTabla      (String param) { this.sTabla = param; }
    public void setsDesc      (String param) { this.sDesc = param; }
    
    public void setsMensError  (String psMensError ) {
        this.sMensError  = psMensError ;
    }

    public String getsMensError  () {
        return this.sMensError ;
    }

    public int getiNumError  () {
        return this.iNumError ;
    }

    public void setiNumError  (int piNumError ) {
        this.iNumError  = piNumError;
    }
    
    
    public Proceso getDBUltimaInterfase ( Connection dbCon) throws SurException {
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("INT_MAX_FECHA_FTP (?)"));
            cons.registerOutParameter(1, java.sql.Types.DATE);
            cons.setString (2, this.sTabla);
            cons.execute();
            
            this.dFechaFTP      = cons.getDate(1);

       }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Sql al obtener el usuario: " + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error al obtener el usuario: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }

    public Proceso getDBUltimaCtaCte ( Connection dbCon, int tipoUsuario) throws SurException {
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("CC_ULTIMA_CTACTE_HIS (?)"));
            cons.registerOutParameter(1, java.sql.Types.DATE);
            cons.setInt (2, tipoUsuario); 
            cons.execute();

            this.dFechaFTP      = cons.getDate(1);

       }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Sql al obtener el usuario: " + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error al obtener el usuario: " + e.getMessage());
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
   
