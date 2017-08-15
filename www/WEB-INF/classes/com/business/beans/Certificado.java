/*
 * Certificado.java
 *
 * Created on 9 de enero de 2005, 19:37
 */

package com.business.beans;

import java.util.Date;
import java.util.LinkedList;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;

import com.business.db.*;
import com.business.util.*;
/**
 *
 * @author Rolando Elisii
 */
public class Certificado {
    
    private String tipoCertificado = "PZ";
    private int numPoliza          = 0;
    private int numPropuesta       = 0;
    private int numCertificado     = 0;
    private Date fechaEmisionPol  = null;
    private Date fechaEmision      = null;
    private Date fechaInicioSuceso = null;
    private Date fechaFinSuceso    = null;    
    private int codRama            = 0;
    private int codSubRama         = 0;
    private String descRama        = "";
    private String codMoneda       = "1";
    private String simboloMoneda   = "$";    
    private String descSubRama     = "";    
    private int codCobFinal        = 0;
    private int cantDias           = 15;
    private int estadoCertificado  = 0;
    private int modoVisualizacion = 3;
    private String descModoVisualizacion = "";
    private String imprSubdiario   = "N";
    private String imprSumas       = "N";
    private String imprDocumento   = "N";
    private String imprBenef       = "N";    
    private String imprReducido    = "S";    
    private String imprOriginal    = "N";
    private int tipoEnvioOrig      = 1;  // 1: correo, 2:mensajeria 
    private String descModoEnvio   = "";
    private String userId          = "";
    private String descProd       = "";
    private Date fechaTrabajo      = null;
    private String horaOperacion     = null;
    private int codProd            = 0;
    private double impTotalFacturado = 0;
    private double impSaldoPoliza   = 0;
    private double impDeuda         = 0;
    private String tipoDoc          = "";
    private String numDoc           = "";
    private String presentar        = null;
    private String tipoPropuesta    = null;
    private String claNoRepeticion = "N";
    private String claSubrogacion  = "N";
    private LinkedList lClausulas   = null;
    private int cantMaxClausulas     = 0;
    private int item                = 0;
    private int codProducto         = 0;
    private String nivelCob    = "P";
    
    private String sMensError           = new String();
    private int  iNumError              = 0;

    
    private CallableStatement cons = null;
    
    /** Creates a new instance of Certificado */
    public Certificado() {
    }

    public void settipoCertificado (String param) { this.tipoCertificado    = param; }
    public void setcodProd         (int param) { this.codProd            = param; }
    public void setnumCertificado     (int param) { this.numCertificado     = param; }
    public void setnumPoliza          (int param) { this.numPoliza          = param; }
    public void setnumPropuesta       (int param) { this.numPropuesta       = param; }    
    public void setfechaEmisionPol  (Date param) { this.fechaEmisionPol   = param; }
    public void setfechaEmision      (Date param) { this.fechaEmision       = param; }
    public void setfechaInicioSuceso (Date param) { this.fechaInicioSuceso  = param; }
    public void setfechaFinSuceso    (Date param) { this.fechaFinSuceso     = param; }
    public void setcodRama            (int param) { this.codRama            = param; }
    public void setcodSubRama         (int param) { this.codSubRama         = param; }
    public void setcodCobFinal        (int param) { this.codCobFinal        = param; }
    public void setcantDias           (int param) { this.cantDias           = param; }
    public void setestadoCertificado (int param) { this.estadoCertificado   = param; }
    public void setimprSubdiario   (String param) { this.imprSubdiario      = param; }
    public void setimprSumas       (String param) { this.imprSumas          = param; }
    public void setimprDocumento   (String param) { this.imprDocumento      = param; }
    public void setimprBenef       (String param) { this.imprBenef          = param; }
    public void setimprReducido    (String param) { this.imprReducido       = param; }
    public void setimprOriginal    (String param) { this.imprOriginal       = param; }
    public void settipoEnvioOrig      (int param) { this.tipoEnvioOrig      = param; } // 1: correo, 2:mensajeria 
    public void setmodoVisualizacion  (int param) { this.modoVisualizacion  = param; } // 1: correo, 2:mensajeria     
    public void setuserId          (String param) { this.userId             = param; }
    public void setdescProd          (String param) { this.descProd           = param; }
    public void setfechaTrabajo      (Date param) { this.fechaTrabajo       = param; }
    public void sethoraOperacion     (String param) { this.horaOperacion      = param; }
    public void setimpTotalFacturado (double param) { this.impTotalFacturado= param; }
    public void setimpSaldoPoliza    (double param) { this.impSaldoPoliza   = param; }
    public void setimpDeuda          (double param) { this.impDeuda         = param; }
    public void setdescRama          (String param) { this.descRama           = param; }
    public void setdescSubRama       (String param) { this.descSubRama           = param; }    
    public void setdescModoEnvio     (String param) { this.descModoEnvio       = param; }    
    public void setdescModoVisualizacion (String param) { this.descModoVisualizacion           = param; }    
    public void setcodMoneda         (String param) { this.codMoneda = param; }        
    public void setsimboloMoneda     (String param) { this.simboloMoneda = param; }        
    public void settipoDoc           (String param) { this.tipoDoc = param; }            
    public void setnumDoc           (String param) { this.numDoc = param; }                
    public void setpresentar        (String param) { this.presentar = param; }                
    public void setclaNoRepeticion ( String param){ claNoRepeticion = param; }
    public void setclaSubrogacion  ( String param){ claSubrogacion = param; }
    public void setcantMaxClausulas ( int param ) {  this.cantMaxClausulas = param ; }
    public void setAllClausulas (LinkedList param) {this.lClausulas = param;}    
    public void settipoPropuesta    ( String param){ tipoPropuesta = param; }
    public void setitem             ( int param ) {  this.item  = param ; }
    public void setcodProducto      ( int param ) {  this.codProducto = param ; }
    public void setnivelCob          (String param){ this.nivelCob = param ; }
    
    public String getnivelCob     (){ return this.nivelCob;}
    public String gettipoCertificado  () { return tipoCertificado; }
    public int getnumCertificado      () { return  this.numCertificado;}
    public int getcodProd             () { return  this.codProd;}
    public int getnumPoliza           () { return  this.numPoliza;}
    public int getnumPropuesta        () { return  this.numPropuesta;}
    public Date getfechaEmisionPol   () { return  this.fechaEmisionPol;}
    public Date getfechaEmision       () { return  this.fechaEmision;}
    public Date getfechaInicioSuceso  () { return  this.fechaInicioSuceso;}
    public Date getfechaFinSuceso     () { return  this.fechaFinSuceso;}
    public int getcodRama             () { return  this.codRama;}
    public int getcodSubRama          () { return  this.codSubRama;}
    public int getcodCobFinal         () { return  this.codCobFinal;}
    public int getcantDias            () { return  this.cantDias;}
    public int getestadoCertificado  () { return this.estadoCertificado;}
    public String getimprSubdiario    () { return this.imprSubdiario;}
    public String getimprSumas        () { return this.imprSumas;}
    public String getimprDocumento    () { return this.imprDocumento;}
    public String getimprBenef        () { return this.imprBenef ;}
    public String getimprReducido     () { return this.imprReducido;}
    public String getimprOriginal     () { return this.imprOriginal;}
    public int gettipoEnvioOrig       () { return  this.tipoEnvioOrig;} // 1: correo, 2:mensajeria 
    public int getmodoVisualizacion   () { return  this.modoVisualizacion;}
    public String getuserId           () { return this.userId;}
    public String getdescProd         () { return this.descProd;}
    public String getdescRama         () { return this.descRama;}
    public String getdescModoEnvio() { return this.descModoEnvio; }
    public String getdescModoVisualizacion () { return this.descModoVisualizacion;}
    public String getdescSubRama      () { return this.descSubRama;}    
    public Date getfechaTrabajo       () { return  this.fechaTrabajo;}
    public String gethoraOperacion      () { return  this.horaOperacion;}
    public String getcodMoneda        () { return this.codMoneda; }        
    public String getsimboloMoneda    () { return this.simboloMoneda; }        
    public String gettipoDoc          () { return this.tipoDoc; }            
    public String getnumDoc           () { return this.numDoc; }                
    public String getpresentar        () { return this.presentar; }                    
    public String getclaNoRepeticion  (){ return this.claNoRepeticion; }
    public String getclaSubrogacion   (){ return this.claSubrogacion; }
    public LinkedList getAllClausulas () {return lClausulas;}
    public int    getcantMaxClausulas (){ return this.cantMaxClausulas; }        
    public String gettipoPropuesta    (){ return this.tipoPropuesta; }
    public int    getitem             (){ return this.item; }
    public int    getcodProducto      (){ return this.codProducto; }
    
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
            cons = dbCon.prepareCall(db.getSettingCall( "CE_ADD_CERTIFICADO (?,?,?, ?, ?, ?, ?, ?, ?, ?,?, ?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt (2, this.getnumCertificado());
            cons.setInt (3, this.getnumPropuesta ());
            cons.setInt (4, this.getnumPoliza  ());
            cons.setString (5, this.gettipoCertificado());
            cons.setInt (6, this.getmodoVisualizacion());
            cons.setInt (7, this.gettipoEnvioOrig());
            cons.setInt (8, this.getcantDias ());
            cons.setInt (9, this.getestadoCertificado());
            cons.setInt (10, this.getcodRama());
            cons.setString (11, this.getuserId());
            cons.setInt (12, this.getcodProd());
            cons.setString (13, this.getpresentar());
            
            if (this.getclaNoRepeticion() == null) {
                cons.setNull(14, java.sql.Types.VARCHAR);
            } else {
                cons.setString (14, this.getclaNoRepeticion());
            }
            
            if (this.getclaSubrogacion() == null) {
                cons.setNull(15, java.sql.Types.VARCHAR);
            } else {
                cons.setString (15, this.getclaSubrogacion());
            }
            
            cons.execute();
            
            this.setnumCertificado(cons.getInt (1));
           
      }  catch (SQLException se) {
		throw new SurException("Error en Certificado [setDB]: " + se.getMessage());
        } catch (Exception e) {
		throw new SurException("Error en Certificado [setDB]: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }

    public void setDBCertificadoWeb (Connection dbCon) throws SurException {

      try {
           dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall( "CE_ADD_CERTIFICADO_WEB (?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt    (2, this.getnumPoliza ());
            cons.setString (3, this.getnumDoc());
            cons.setString (4, this.getuserId());
            cons.setString (5, this.getpresentar());

            cons.execute();

            this.setnumCertificado(cons.getInt (1));

      }  catch (SQLException se) {
		throw new SurException("Error en Certificado [setDB]: " + se.getMessage());
        } catch (Exception e) {
		throw new SurException("Error en Certificado [setDB]: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }

    public void setDBAsegurado (Connection dbCon) throws SurException {
    
      try {
           dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall( "CE_ADD_CERTIFICADO_IND (?,?,?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt (2, this.getnumCertificado());
            cons.setInt (3, this.getnumPropuesta ());
            cons.setInt (4, this.getnumPoliza  ());
            cons.setString (5, this.gettipoCertificado());
            cons.setInt (6, this.getmodoVisualizacion());
            cons.setInt (7, this.gettipoEnvioOrig());
            cons.setInt (8, this.getcantDias ());
            cons.setInt (9, this.getestadoCertificado());
            cons.setInt (10, this.getcodRama());
            cons.setString (11, this.getuserId());
            cons.setInt (12, this.getcodProd());
            cons.setString (13, this.gettipoDoc ());
            cons.setString (14, this.getnumDoc());
            cons.setString (15, this.getpresentar());
            cons.setInt    (16, this.getitem());
            
            cons.execute();

            this.setnumCertificado(cons.getInt (1));
           
      }  catch (SQLException se) {
		throw new SurException("Error en Certificado [setDBAsegurado]: " + se.getMessage());
        } catch (Exception e) {
		throw new SurException("Error en Certificado [setDBAsegurado]: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }

    public void setDBEndoso (Connection dbCon) throws SurException {
    
      try {
           dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall( "CE_CERTIFICADO_TO_ENDOSO (?,?,?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt (2, this.getcodRama());
            cons.setInt (3, this.getnumPoliza  ());
            cons.setInt (4, this.getnumCertificado());
            cons.setString (5, this.getuserId());
            cons.setString (6, this.getclaNoRepeticion());
            cons.setString (7, this.getclaSubrogacion());
            
            cons.execute();

            this.setiNumError(cons.getInt (1));
           
      }  catch (SQLException se) {
		throw new SurException("Error en Certificado [setDBEndoso]: " + se.getMessage());
        } catch (Exception e) {
		throw new SurException("Error en Certificado [setDBEndoso]: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }

    
    public Certificado getDB ( Connection dbCon) throws SurException {
        ResultSet rs = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("CE_GET_CERTIFICADO (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString (2, this.gettipoCertificado());
            cons.setInt (3, this.getnumCertificado());
            cons.execute();
           
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    this.settipoCertificado     (rs.getString ("TIPO_CERTIFICADO"));
                    this.setnumCertificado      (rs.getInt("NUM_CERTIFICADO"));
                    this.setfechaEmision        (rs.getDate("FECHA_EMISION"));
                    this.setfechaInicioSuceso   (rs.getDate("FECHA_INI_SUCESO"));
                    this.setfechaFinSuceso      (rs.getDate("FECHA_FIN_SUCESO"));
                    this.setcodRama             (rs.getInt ("COD_RAMA"));
                    this.setcodSubRama          (rs.getInt ("COD_SUB_RAMA"));
                    this.setdescRama            (rs.getString ("RAMA"));
                    this.setdescSubRama         (rs.getString ("SUB_RAMA"));
                    this.setcodCobFinal         (rs.getInt ("COD_COB_FINAL"));
                    this.setcantDias            (rs.getInt ("CANT_DIAS"));
                    this.setestadoCertificado   (rs.getInt ("ESTADO"));
                    this.setimprSubdiario       (rs.getString ("PRT_SUBDIARIO"));
                    this.setimprSumas           (rs.getString ("PRT_SUMAS"));
                    this.setimprDocumento       (rs.getString ("PRT_DOCUMENTO"));
                    this.setimprBenef           (rs.getString ("PRT_BENEF"));
                    this.setimprReducido        (rs.getString ("PRT_REDUCIDO"));
                    this.setuserId              (rs.getString ("USUARIO"));
                    this.setfechaTrabajo        (rs.getDate ("FECHA_TRABAJO"));
                    this.setnumPoliza           (rs.getInt  ("NUM_POLIZA"));
                    this.setnumPropuesta        (rs.getInt("NUM_PROPUESTA"));
                    this.setmodoVisualizacion   (rs.getInt ("MODO_VISUALIZACION"));
                    this.settipoEnvioOrig       (rs.getInt ("MODO_ENVIO"));
                    this.setcodProd             (rs.getInt ("COD_PROD"));
                    this.setimpTotalFacturado   (rs.getDouble ("IMP_TOTAL_FACTURADO"));
                    this.setimpSaldoPoliza      (rs.getDouble ("IMP_SALDO_POLIZA"));
                    this.setimpDeuda            (rs.getDouble("IMP_DEUDA"));
                    this.setcodMoneda           (rs.getString ("COD_MONEDA"));
                    this.setsimboloMoneda       (rs.getString ("SIMBOLO_MONEDA"));                    
                    this.setpresentar           (rs.getString ("PRESENTAR"));
                    this.setclaNoRepeticion     (rs.getString ("CLA_NO_REPETICION")); 
                    this.setclaSubrogacion      (rs.getString ("CLA_SUBROGACION"));      
                    this.settipoPropuesta       (rs.getString ("TIPO_PROPUESTA"));
                    this.setcodProducto         (rs.getInt    ("COD_PRODUCTO"));
                    this.setnivelCob            (rs.getString ("NIVEL_COB"));                    
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
                if (rs != null) rs.close ();
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }

    public LinkedList getDBAllAsegurados ( Connection dbCon) throws SurException {
        LinkedList lAseg = new LinkedList();
        ResultSet rs = null;
       try {
           
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("CE_ALL_ASEGURADOS (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString (2, this.gettipoCertificado());
            cons.setInt (3, this.getnumCertificado());
            cons.execute();
            
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    PersonaCertificado oPers = new PersonaCertificado ();
                    oPers.settipoCertificado    (rs.getString ("TIPO_CERTIFICADO"));
                    oPers.setnumCertificado     (rs.getInt    ("NUM_CERTIFICADO"));
                    oPers.settipoDoc            (rs.getString ("TIPO_DOC"));
                    oPers.setdescTipoDoc        (rs.getString ("DESC_TIPO_DOC"));                    
                    oPers.setnumDoc             (rs.getString ("NUM_DOC"));
                    oPers.setrazonSocial        (rs.getString ("RAZON_SOCIAL")); 
                    oPers.setestado             (rs.getString ("ESTADO"));
                    oPers.setitem               (rs.getInt    ("ITEM"));
                    oPers.setsubItem            (rs.getInt    ("SUB_ITEM"));
                    oPers.setparentesco         (rs.getInt    ("PARENTESCO"));
                    oPers.setdescParentesco     (rs.getString ("DESC_PARENTESCO"));
                    oPers.setfechaAlta          (rs.getDate   ("FECHA_ALTA_COB"));
                    lAseg.add(oPers); 
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
                if (rs != null) {rs.close();}
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return lAseg;
        }
    }
    
    public LinkedList getDBAllCoberturaFinal ( Connection dbCon) throws SurException {
       LinkedList lCob = new LinkedList ();
       CallableStatement cons = null;
       ResultSet rs = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("CE_SUMAS_COBERTURAS (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString (2, this.gettipoCertificado());
            cons.setInt (3, this.getnumCertificado());
            cons.execute();
           
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    CoberturaFinal oCob = new CoberturaFinal ();
                    oCob.settipoCertificado (rs.getString ("TIPO_CERTIFICADO"));
                    oCob.setnumCertificado  (rs.getInt    ("NUM_CERTIFICADO"));
                    oCob.setcodRama         (rs.getInt ("COD_RAMA"));
                    oCob.setcodSubRama      (rs.getInt ("COD_SUB_RAMA"));
                    oCob.setcodCobFinal     (rs.getInt ("COD_COB"));
                    oCob.setimpSumaRiesgo   (rs.getDouble ("IMP_SUMA_RIESGO")); 
                    oCob.setdescCob         (rs.getString ("COBERTURA"));
                    lCob.add (oCob);
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
                if (rs != null) { rs.close ();}
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return lCob;
        }
    }
    
    public LinkedList getDBAllTextoVariable ( Connection dbCon) throws SurException {
        LinkedList lAseg = new LinkedList();
        ResultSet rs = null;
       try {
           
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("CE_TEXTO_VARIABLE (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString (2, this.gettipoCertificado());
            cons.setInt (3, this.getnumCertificado());
            cons.execute();
           
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    TextoCertificado oTexto = new TextoCertificado ();
                    oTexto.settipoCertificado   (rs.getString ("TIPO_CERTIFICADO"));
                    oTexto.setnumCertificado    (rs.getInt    ("NUM_CERTIFICADO"));
                    oTexto.setnumRenglon        (rs.getInt ("NUM_RENGLON"));
                    oTexto.settexto             (rs.getString ("TEXTO_RENGLON"));
                    lAseg.add(oTexto);
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
                if (rs != null) { rs.close (); }
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return lAseg;
        }
    }
    public LinkedList getDBAllTextoFijo ( Connection dbCon) throws SurException {
        LinkedList lAseg = new LinkedList();
        ResultSet  rs = null;
       try {
           
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("CE_TEXTO_FIJO (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString (2, this.gettipoCertificado());
            cons.setInt (3, this.getnumCertificado());
            cons.execute();
           
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    TextoCertificado oTexto = new TextoCertificado ();
                    oTexto.settipoCertificado   (rs.getString ("TIPO_CERTIFICADO"));
                    oTexto.setnumCertificado    (rs.getInt    ("NUM_CERTIFICADO"));
                    oTexto.setcodTexto          (rs.getString ("COD_TEXTO"));
                    oTexto.setsecuencia         (rs.getInt    ("SECUENCIA"));
                    lAseg.add(oTexto);
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
                if (rs != null) { rs.close (); }
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return lAseg;
        }
    }
    public LinkedList getDBAllEmpresasClausulas ( Connection dbCon) throws SurException {
        LinkedList lCla = new LinkedList();
        ResultSet rs = null;
       try {
           
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("CE_GET_ALL_CLAUSULAS (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString (2, this.gettipoCertificado());
            cons.setInt (3, this.getnumCertificado());
            cons.execute();
           
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    Clausula oCla = new Clausula ();
                    oCla.settipoCertificado   (rs.getString ("TIPO_CERTIFICADO"));
                    oCla.setnumCertificado    (rs.getInt    ("NUM_CERTIFICADO"));
                    oCla.setcuitEmpresa       (rs.getString ("CUIT"));
                    oCla.setdescEmpresa       (rs.getString ("DESCRIPCION"));
                    lCla.add(oCla);
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
                if (rs != null) rs.close ();
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return lCla;
        }
    }
    
    
    /*
     **************************************************************************
     * Nuevo Silvio - 26-04-2008 INICIO 
     ***************************************************************************
     */         

    public void setDBPropuesta (Connection dbCon) throws SurException {
    
      try {
           dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall( "CE_ADD_CERTIFICADO_PROP (?,?,?,?,?,?,?,?)"));
            
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt    ( 2, this.getnumCertificado());
            cons.setInt    ( 3, this.getnumPropuesta ());            
            cons.setString ( 4, this.gettipoCertificado());
            cons.setInt    ( 5, this.getmodoVisualizacion());            
            cons.setInt    ( 6, this.getcantDias ());            
            cons.setInt    ( 7, this.getcodRama());
            cons.setString ( 8, this.getuserId());            
            cons.setString ( 9, this.getpresentar());
            
            cons.execute();

            this.setnumCertificado(cons.getInt (1));
           
      }  catch (SQLException se) {
		throw new SurException("Error en Certificado [setDBPropuesta ]: " + se.getMessage());
        } catch (Exception e) {
		throw new SurException("Error en Certificado [setDBPropuesta ]: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }    
     
    
    /*
     **************************************************************************
     * Nuevo Silvio - 26-04-2008 FIN 
     ***************************************************************************
     */         
}
