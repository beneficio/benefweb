/*
 * AseguradoPropuesta.java
 *
 * Created on 17 de junio de 2006, 22:49
 */

package com.business.beans;
  
import java.util.Date;
import java.util.LinkedList;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import com.business.util.*;
import com.business.db.*;


/**
 *
 * @author  Usuario
 */
public class AseguradoPropuesta {
    
    private int    codProceso    = 0;
    private String codBoca       = "";
    private int    numPropuesta  = 0;
    private int    orden         = 0;    
    private String codigoPosta    = "";
    private Date   fechaNac       = null;    
    private String sexo           = "";
    private double sumaAseg       = 0;
    private double impSueldo      = 0;
    private Date   fechaIng       = null;   
    private String mano           = "D";
    //
    private int    codRama        = 0;
    private int    numPoliza      = 0;    
    private int    certificado    = 0;
    private int    subCertificado = 0;    
    private String tipoDoc        = null;
    private String numDoc         = null;
    private String nombre         = null;
    private String apellido       = null;
    private String domicilio      = null;
    private String localidad        = "";
    private String provincia        = "";
    private String descProvincia    = "";
    
    private Date   fechaAltaCob   = null;    
    private Date   fechaBaja      = null;
    private String estado         = null;      
    private Date fechaFTP         = null;
    private String descTipoDoc    = null;
    private int    codAgrupCob    = 0;
    private int    parentesco     = 0;
    private String descParentesco = null;
    private int  codCobOpcion     = 0;
    private double impPremio = 0;
    private String sMensError           = "";
    private int  iNumError              = 0;
    private LinkedList<Cobertura> lCoberturas = null;
    private String sMcaDiscapacitado  = "N";
    private LinkedList<Beneficiario> lBenef = null;
    
    /** Creates a new instance of AseguradoPropuesta */
    public AseguradoPropuesta() {
    }
    
    public int    getCodProceso     () { return this.codProceso;}
    public String getCodBoca        () { return this.codBoca;}
    public int    getNumPropuesta   () { return this.numPropuesta;}
    public int    getOrden          () { return this.orden;}    
    public String getCodigoPosta    () { return this.codigoPosta;}
    public Date   getFechaNac       () { return this.fechaNac;}
    public String getSexo           () { return this.sexo;}
    public double getSumaAseg       () { return this.sumaAseg;}
    public double getImpSueldo      () { return this.impSueldo;}
    public Date   getFechaIng       () { return this.fechaIng;}
    
    public int    getCodRama        () { return this.codRama; }
    public int    getNumPoliza      () { return this.numPoliza; }
    public int    getCertificado    () { return this.certificado; }
    public int    getSubCertificado () { return this.subCertificado; }    
    public String getTipoDoc        () { return this.tipoDoc; }    
    public String getNumDoc         () { return this.numDoc; }
    public String getNombre         () { return this.nombre; }
    public String getApellido       () { return this.apellido; }
    public String getDomicilio      () { return this.domicilio; }
    public String getlocalidad        () { return this.localidad;}
    public String getprovincia        () { return this.provincia;}
    public String getdescProvincia    () { return this.descProvincia;}    
    
    public Date   getFechaAltaCob   () { return this.fechaAltaCob; }
    public Date   getFechaBaja      () { return this.fechaBaja; }    
    public String getEstado         () { return this.estado; }
    public Date   getFechaFTP       () { return this.fechaFTP; }
    public String getDescTipoDoc    () { return this.descTipoDoc; } 
    public String getmano           () { return this.mano; }
    public int    getcodAgrupCob    () { return this.codAgrupCob; }
    public int    getparentesco     () { return this.parentesco; }
    public String getdescParentesco () { return this.descParentesco; }
    public int    getcodCobOpcion   () { return this.codCobOpcion; }
    public double getimpPremio () { return this.impPremio;}
    public LinkedList getlCoberturas () {return this.lCoberturas;}
    public String getsMcaDiscapacitado () { return this.sMcaDiscapacitado; }
    public LinkedList getlBenef     () {return this.lBenef;}


    // ------------------------------------------------------------------------
    
    public void setCodProceso     (int param)    { this.codProceso= param;}
    public void setCodBoca        (String param) { this.codBoca= param;}
    public void setNumPropuesta   (int param)    { this.numPropuesta= param;}
    public void setOrden          (int param)    { this.orden= param;}    
    
    public void setCodigoPosta    (String param) { this.codigoPosta= param;}    
    public void setFechaNac       (Date param)   { this.fechaNac= param;}    
    public void setSexo           (String param) { this.sexo= param;}    
    public void setSumaAseg       (double param) { this.sumaAseg= param;}    
    public void setImpSueldo      (double param) { this.impSueldo= param;}    
    public void setFechaIng       (Date param)   { this.fechaIng= param;}    
    
    public void setCodRama      (int param) { this.codRama = param; }
    public void setNumPoliza    (int param) { this.numPoliza= param; }
    public void setCertificado  (int param) { this.certificado= param; }
    public void setSubCertificado (int param) { this.subCertificado= param; }
    public void setTipoDoc      (String param) { this.tipoDoc= param; }   
    public void setNumDoc       (String param) { this.numDoc= param; }
    public void setNombre       (String param) { this.nombre= param; }
    public void setApellido     (String param) { this.apellido = param; }
    public void setDomicilio    (String param) { this.domicilio= param; }
    public void setlocalidad    (String param) { this.localidad = param; }
    public void setprovincia    (String param) { this.provincia = param; }
    public void setdescProvincia(String param) { this.descProvincia = param; }
    public void setFechaAltaCob (Date param) { this.fechaAltaCob = param; }
    public void setFechaBaja    (Date param) { this.fechaBaja = param; }
    public void setEstado       (String param) { this.estado = param; }
    public void setFechaFTP     (Date param) { this.fechaFTP = param; }
    public void setDescTipoDoc  (String param) { this.descTipoDoc = param; }
    public void setmano         (String param) { this.mano = param; }
    public void setdescParentesco(String param) { this.descParentesco= param; }
    public void setparentesco   (int param) { this.parentesco = param; }
    public void setcodAgrupCob  (int param) { this.codAgrupCob  = param; }
    public void setcodCobOpcion (int param) { this.codCobOpcion = param; }
    public void setimpPremio (double param) { this.impPremio = param;}
    public void setsMcaDiscapacitado (String param) { this.sMcaDiscapacitado = param; }
    public void setlBenef (LinkedList param) { this.lBenef = param;}    
     
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
    
    /*
     *  setDB
     */
    public AseguradoPropuesta setDB(Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {                   
           dbCon.setAutoCommit(true);           
           cons = dbCon.prepareCall(db.getSettingCall( "PRO_SET_ASEGURADO_PROPUESTA (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getCodProceso());
           cons.setString           (3, this.getCodBoca());
           cons.setInt              (4, this.getNumPropuesta());           
           cons.setInt              (5, this.getCodRama());
           cons.setInt              (6, this.getOrden());           
           cons.setString           (7, this.getTipoDoc());
           cons.setString           (8, this.getNumDoc());
           cons.setString           (9, this.getNombre());           
           if (this.getFechaNac() == null) {  
               cons.setNull(10, java.sql.Types.DATE);
           } else {      
               cons.setDate(10, Fecha.convertFecha(this.getFechaNac()));     
           }           
           
           cons.setString          (11, this.getmano());
           cons.setInt             (12, this.getparentesco());
           cons.setInt             (13, this.getcodAgrupCob());
           cons.setDouble          (14, this.getSumaAseg()) ;
           cons.setInt             (15, this.getCertificado() == 0 ? this.getOrden() : this.getCertificado());
           cons.setInt             (16, this.getSubCertificado());
           cons.setInt             (17, this.getcodCobOpcion());
           cons.setString          (18, this.getsMcaDiscapacitado());
           
           cons.execute();

           this.setiNumError(cons.getInt (1));

        }  catch (SQLException se) {
            this.setiNumError(-1);
            this.setsMensError(se.getMessage());
        } catch (Exception e) {
            this.setiNumError(-1);
            this.setsMensError(e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    }                    
    
    public AseguradoPropuesta setDBEndosarBaja (Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {                   
           dbCon.setAutoCommit(true);           
           cons = dbCon.prepareCall(db.getSettingCall( "END_SET_BAJA_ASEGURADO ( ?,?,?,?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getCodProceso());
           cons.setString           (3, this.getCodBoca());
           cons.setInt              (4, this.getNumPropuesta());           
           cons.setInt              (5, this.getCodRama());
           cons.setString           (6, this.getTipoDoc());
           cons.setString           (7, this.getNumDoc());
           cons.setInt              (8, this.getOrden());

           cons.execute();
           
           this.setiNumError(cons.getInt (1));
           
        }  catch (SQLException se) {
            this.setiNumError(-1);
            this.setsMensError(se.getMessage());
        } catch (Exception e) {
            this.setiNumError(-1);
            this.setsMensError(e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    }                    
    
    public AseguradoPropuesta setDBCancelarEndosoAseg (Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {                   
           dbCon.setAutoCommit(true);           
           cons = dbCon.prepareCall(db.getSettingCall( "END_SET_CANCELAR_ENDOSO_ASEG ( ?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getNumPropuesta());           
           cons.setString           (3, this.getTipoDoc());
           cons.setString           (4, this.getNumDoc());

           cons.execute();
           
           this.setiNumError(cons.getInt (1));
           
        }  catch (SQLException se) {
            this.setiNumError(-1);
            this.setsMensError(se.getMessage());
        } catch (Exception e) {
            this.setiNumError(-1);
            this.setsMensError(e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    }                    

    public AseguradoPropuesta setDBEndosarAlta (Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {                   
           dbCon.setAutoCommit(true);           
           cons = dbCon.prepareCall(db.getSettingCall( "END_SET_ALTA_ASEGURADO ( ?,?,?,?,?,?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getCodProceso());
           cons.setString           (3, this.getCodBoca());
           cons.setInt              (4, this.getNumPropuesta());           
           cons.setInt              (5, this.getCodRama());
           cons.setInt              (6, this.getOrden());           
           cons.setString           (7, this.getTipoDoc());
           cons.setString           (8, this.getNumDoc());
           cons.setString           (9, this.getNombre());           
           if (this.getFechaNac() == null) {  
               cons.setNull(10, java.sql.Types.DATE);
           } else {      
               cons.setDate(10, Fecha.convertFecha(this.getFechaNac()));     
           }           
           
           cons.execute();
           
           this.setiNumError(cons.getInt (1));

        }  catch (SQLException se) {
            this.setiNumError(-1);
            this.setsMensError(se.getMessage());
        } catch (Exception e) {
            this.setiNumError(-1);
            this.setsMensError(e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    }                    
    

    /*
     *  delDB
     */
    public void delDB(Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {                   
           dbCon.setAutoCommit(true);           
           cons = dbCon.prepareCall(db.getSettingCall( "PRO_DEL_ASEGURADO_PROPUESTA(?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getCodProceso());
           cons.setString           (3, this.getCodBoca());
           cons.setInt              (4, this.getNumPropuesta());           
           cons.setInt              (5, this.getCodRama());
           
           cons.execute();

           this.setiNumError(cons.getInt(1));

        }  catch (SQLException se) {
            this.setiNumError(-1);
            this.setsMensError(se.getMessage());
        } catch (Exception e) {
            this.setiNumError(-1);
            this.setsMensError(e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }            
        }
    }                        
    
    /*
     *  delDBbyOrden
     */
    public void delDBbyOrden(Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {                   
           dbCon.setAutoCommit(true);           
           cons = dbCon.prepareCall(db.getSettingCall( "PRO_DEL_ASEGURADO_PROPUESTA_BY_ORDEN(?,?,?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getCodProceso());
           cons.setString           (3, this.getCodBoca());
           cons.setInt              (4, this.getNumPropuesta());           
           cons.setInt              (5, this.getCodRama());
           cons.setInt              (6, this.getOrden());
           cons.setInt              (7, this.getSubCertificado());
           
           cons.execute();
                       
           this.setiNumError(cons.getInt(1));

        }  catch (SQLException se) {
            this.setiNumError(-1);
            this.setsMensError(se.getMessage());
        } catch (Exception e) {
            this.setiNumError(-1);
            this.setsMensError(e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }            
        }
    }
    public AseguradoPropuesta setDBAseguradoCaucion ( Connection dbCon) throws SurException {
        CallableStatement cons = null;
        try {
           dbCon.setAutoCommit(true);
    
           cons = dbCon.prepareCall(db.getSettingCall( "PRO_SET_ASEGURADO_CAUCION(?,?,?,?,?,?,?,?,?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getCodProceso());
           cons.setString           (3, this.getCodBoca() );
           cons.setInt              (4, this.getNumPropuesta());
           cons.setInt              (5, this.getCodRama());
           cons.setString           (6, this.getTipoDoc() );
           cons.setString           (7, this.getNumDoc()  );
           cons.setString           (8, this.getDomicilio() );
           cons.setString           (9, this.getlocalidad() );
           cons.setString           (10, this.getCodigoPosta());
           cons.setString           (11, this.getprovincia() );
           cons.setString           (12, this.getApellido ());
           cons.setString           (13, this.getNombre());

           cons.execute();

           this.setiNumError(cons.getInt(1));

        }  catch (SQLException se) {
            this.setiNumError(-1);
            this.setsMensError(se.getMessage());
        } catch (Exception e) {
            this.setiNumError(-1);
            this.setsMensError(e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    }

    public AseguradoPropuesta getDBAseguradoCaucion ( Connection dbCon) throws SurException {
       ResultSet rs = null;
       CallableStatement cons = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PRO_GET_ASEGURADO_CAUCION (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getNumPropuesta());
            cons.execute();

           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    this.setTipoDoc     (rs.getString ("TIPO_DOC"));
                    this.setDescTipoDoc(rs.getString ("DESC_TIPO_DOC"));
                    this.setNumDoc      (rs.getString ("NUM_DOC"));
                    this.setNombre      (rs.getString ("NOMBRE"));
                    this.setApellido    (rs.getString ("APELLIDO"));
                    this.setDomicilio   (rs.getString ("DOMICILIO"));
                    this.setlocalidad   (rs.getString ("LOCALIDAD"));
                    this.setCodigoPosta (rs.getString ("COD_POSTAL"));
                    this.setprovincia   (rs.getString ("PROVINCIA"));
                    this.setdescProvincia(rs.getString ("DESC_PROVINCIA"));
                    this.setCodRama     (rs.getInt   ("COD_RAMA"));
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
                if (rs != null)  rs.close ();
                if (cons != null)  cons.close ();
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }
    public void setDBlCoberturas ( Connection dbCon, int producto) throws SurException {
       ResultSet rs = null;
       CallableStatement cons = null;
       try {
            this.lCoberturas = new LinkedList ();
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PRO_GET_ALL_COBERTURAS_ASEGURADO (?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getNumPropuesta());
            cons.setInt (3, this.getCertificado());
            cons.setInt (4, this.getSubCertificado());
            cons.setInt (5, producto);
            cons.execute();

            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    Cobertura oCob = new Cobertura();
                    oCob.setnumPropuesta(rs.getInt("NUM_PROPUESTA"));
                    oCob.setCertificado (rs.getInt ("CERTIFICADO"));
                    oCob.setSubCertificado(rs.getInt ("SUB_CERTIFICADO"));
                    oCob.setcodRama     (rs.getInt ("COD_RAMA"      ));
                    oCob.setcodSubRama  (rs.getInt ("COD_SUB_RAMA"  ));
                    oCob.setcodCob      (rs.getInt ("COD_COB"));
                    oCob.setsumaAseg    (rs.getDouble ("SUMA_ASEG"));
                    oCob.setdescripcion(rs.getString ("DESCRIPCION"));
                    lCoberturas.add(oCob);
                }
                rs.close();
            }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Sql al obtener COBERTURAS: " + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error al obtener el COBERTURAS: " + e.getMessage());
        } finally {
            try {
                if (rs   != null) { rs.close ();}
                if (cons != null) { cons.close ();}
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }
    
    public void getDBlBeneficiarios ( Connection dbCon) throws SurException {
       ResultSet rs = null;
       CallableStatement cons = null;
       int indice = 1;
       try {

            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PRO_GET_ALL_BENEFICIARIOS (?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getNumPropuesta());
            cons.setInt (3, this.getCertificado());
            cons.setInt (4, this.getSubCertificado());
            cons.execute();

            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                this.lBenef = new LinkedList ();                
                while (rs.next()) {
                    for ( int i=1; i < 5;i++ ) {
                        if (rs.getString ("NOMBRE_" + i) != null && ! rs.getString ("NOMBRE_" + i).equals ("") ) { 
                            Beneficiario oBen = new Beneficiario ();
                            oBen.setnumPropuesta(rs.getInt("NUM_PROPUESTA"));
                            oBen.setCertificado (rs.getInt ("CERTIFICADO"));
                            oBen.setsubCertificado(rs.getInt ("SUB_CERTIFICADO"));
                            oBen.setnumDoc      (rs.getString ("NUM_DOC_" + i));
                            oBen.settipoDoc     (rs.getString ("TIPO_DOC_" + i));
                            oBen.setrazonSocial (rs.getString ("NOMBRE_" + i));
                            oBen.setparentesco  (rs.getInt  ("PARENTESCO_" + i));
                            oBen.setporcentaje  (rs.getDouble("PORCENTAJE_" + i));
                            lBenef.add(oBen);
                        }
                    }
                }
                rs.close();
            }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Sql al obtener COBERTURAS: " + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error al obtener el COBERTURAS: " + e.getMessage());
        } finally {
            try {
                if (rs   != null) { rs.close ();}
                if (cons != null) { cons.close ();}
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }
 
    public void setDBBeneficiarios (Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        int indice = 1;
        try {       

            dbCon.setAutoCommit(true);   
           
            cons = dbCon.prepareCall(db.getSettingCall( "PRO_SET_BENEFICIARIOS (?, ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"));
            cons.registerOutParameter(indice++, java.sql.Types.INTEGER);
            cons.setInt              (indice++, this.getNumPropuesta());
            cons.setInt              (indice++, this.getCertificado());
            cons.setInt              (indice++, 0 );
            for (int i=0;i<this.lBenef.size();i++) {
                Beneficiario oBenef = (Beneficiario) this.lBenef.get(i);
                cons.setString (indice++,oBenef.getnumDoc());
                cons.setString (indice++,oBenef.getrazonSocial());
                cons.setInt    (indice++,oBenef.getparentesco());
                cons.setDouble (indice++,oBenef.getporcentaje());
            }

            cons.execute();
            this.setNumPropuesta(cons.getInt (1));                        
                       
        }  catch (SQLException se) {
            this.setiNumError  (-1);
            this.setsMensError (se.getMessage());
        } catch (Exception e) {
            this.setiNumError  (-1);
            this.setsMensError (e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
        }
    }
        
    public void setDBResetBeneficiarios (Connection dbCon)  throws SurException { 
        CallableStatement cons = null;

        try {       
            dbCon.setAutoCommit(true);   
           
            cons = dbCon.prepareCall(db.getSettingCall( "PRO_DEL_BENEFICIARIOS (?, ?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt              (2, this.getNumPropuesta());
            cons.setInt              (3, this.getCertificado());
            cons.setInt              (4, this.getSubCertificado());
           
           cons.execute();
           this.setNumPropuesta(cons.getInt (1));                        
                       
        }  catch (SQLException se) {
            this.setiNumError  (-1);
            this.setsMensError (se.getMessage());
        } catch (Exception e) {
            this.setiNumError  (-1);
            this.setsMensError (e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
        }
    }
}
