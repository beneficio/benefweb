/*
 * Certificado.java
 *
 * Created on 9 de enero de 2005, 19:37
 */

package com.business.beans;
import java.util.Date;
import java.util.LinkedList; 
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;

import com.business.util.*;
import com.business.db.*;
import com.business.interfaces.*;/**
 *
 * @author Rolando Elisii
 */
public class AsegBeneficiario {
    
    private String tipoCertificado  = "";
    private int numCertificado      = 0;
    private String numDoc              = "";
    private String tipoDocBenef     = "";
    private String descTipoDocBenef = "";
    private String numDocBenef         = "";
    private String tipoDoc          = "";
    private String descTipoDoc      = "";
    private String razonSocial      = "";
    private String sMensError       = new String();
    private int  iNumError          = 0;
    private CallableStatement cons  = null;
        
    
    /** Creates a new instance of Certificado */
    public AsegBeneficiario() {
    }

    public void settipoCertificado  (String param) { this.tipoCertificado = param; }
    public void setnumCertificado   (int param) { this.numCertificado = param; }
    public void setnumDoc           (String param) { this.numDoc = param; }
    public void setnumDocBenef      (String param) { this.numDoc = param; }
    public void settipoDocBenef     (String param) { this.tipoDocBenef = param; }
    public void setdescTipoDoc      (String param) { this.descTipoDoc = param; }
    public void setdescTipoDocBenef (String param) { this.descTipoDocBenef = param; }
    public void settipoDoc          (String param) { this.tipoDoc = param; }
    public void setrazonSocial      (String param) { this.razonSocial = param; }

    public String gettipoCertificado    () { return tipoCertificado; }
    public int getnumCertificado        () { return  this.numCertificado;}
    public String getnumDoc                () { return this.numDoc;}
    public String getnumDocBenef           () { return this.numDoc;}
    public String gettipoDoc            () { return this.tipoDoc;}
    public String gettipoDocBenef       () { return this.tipoDocBenef;}
    public String getdescTipoDoc        () { return this.descTipoDoc;}
    public String getdescTipoDocBenef   () { return this.descTipoDocBenef;}
    public String getrazonSocial        () { return this.razonSocial;}
    
    
    public void setsMensError  (String psMensError ) {
        this.sMensError  = psMensError ;
    }

    public int getiNumError  () {
        return this.iNumError ;
    }
    
    public void setiNumError  (int piNumError ) {
        this.iNumError  = piNumError;
    }
/*
    
    public LinkedList getDBCoberturasAseg ( Connection dbCon) throws SurException {
       LinkedList lAseg = new LinkedList ();
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("CE_GET_ALL_ASEGURADO_COB (?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString (2, this.gettipoCertificado());
            cons.setInt (3, this.getnumCertificado());
            cons.setString (4, this.gettipoDoc());
            cons.setString (5, this.getnumDoc());
            cons.execute();
           
            ResultSet rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    AsegCobertura oCob = new AsegCobertura ();
                    oCob.settipoCertificado     (rs.getString ("TIPO_CERTIFICADO"));
                    oCob.setnumCertificado      (rs.getInt    ("NUM_CERTIFICADO"));
                    oCob.settipoDoc             (rs.getString ("TIPO_DOC")); 
                    oCob.setnumDoc              (rs.getString ("NUM_DOC"));
                    oCob.setcodRama             (rs.getInt    ("COD_RAMA"));
                    oCob.setcodSubRama          (rs.getInt    ("COD_SUB_RAMA"));
                    oCob.setcodCob              (rs.getInt    ("COD_COB"));
                    oCob.setimpSumaRiesgo       (rs.getDouble ("IMP_SUMA_RIESGO"));
                    
                    lAseg.add (oCob);
                }
                rs.close();
            }
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
            return lAseg;
        }
    }

  */
}
