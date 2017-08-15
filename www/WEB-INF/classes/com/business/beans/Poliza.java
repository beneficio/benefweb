/*
 * Certificado.java
 *
 * Created on 9 de enero de 2005, 19:37
 */
     
package com.business.beans;
  
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.LinkedList;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;  
import java.sql.CallableStatement;
import com.business.db.*;
import com.business.util.*;
import com.google.gson.annotations.Expose;
   
    
public class Poliza {
    
    private int numPoliza          = 0;
    private int numEndoso          = 0;
    private int numPropuesta       = 0;
    private Date fechaEmision      = null;
    @Expose
    private Date fechaInicioVigencia = null;
    @Expose
    private Date fechaFinVigencia    = null;
    private Date fechaEmisionEnd     = null;
    private Date fechaInicioVigenciaEnd = null;
    private Date fechaFinVigenciaEnd    = null;
    private int codRama            = 0;
    @Expose
    private int codSubRama         = 0;
    private int codCobFinal        = 0;
    private String estado          = "";
    private String boca            = "";
    private double impTotalFacturado = 0;
    private double impSaldoPoliza  = 0;
    private double impDeuda        = 0;  
    private int codMoneda          = 0;
    @Expose
    private int codProd            = 0; 
    @Expose
    private int numTomador         = 0;
    @Expose
    private String razonSocialTomador = "";
    private int periodoFact        = 0;
    private int cantVidas          = 0;
    private String observacion     = ""; 
    private int codUbicacionRiesgo = 0;
    private Date fechaFTP          = null;   
    private String userId          = "";
    private Date fechaTrabajo      = null;
    private Date horaOperacion     = null;
    @Expose
    private String descRama        = "";
    @Expose
    private String descSubRama     = "";
    @Expose
    private String descProductor   = "";
    private Premio oPremio         = null;
    private int numPolizaAnt       = 0;
    private double impSaldoPolizaAnt = 0;
    private String descActividad    = null;
    private String claNoRepeticion = "N";
    private String claSubrogacion  = "N";
    private String benefHerederos  = "N";
    private String benefTomador    = "N";    
    private double limMaxAcontecimiento = 0;
    private int codActividadSec     = 0;
    private int cantMaxClausulas    = 0;
    private String cuic             = new String ();
    private int tipoEndoso          = 0;
    private String sDescTipoEndoso  = new String ();
    private int iPolizaGrupo        = 0;
    private String sDescPolizaGrupo = null;
    private String sDescMoneda      = "Pesos";
    private String sSignoMoneda     = "$";
    private int renovadaPor         = 0;
    private int numCotizacion       = 0;
    private String sCodFormaPago    = "";
    @Expose
    private int codProducto         = 0;
    private int subSeccion          = 0;
    
    private LinkedList lClausulas   = null;
    private LinkedList lAsegurados  = null;
    private LinkedList lCobranza    = null;
    private LinkedList lSeguimiento = null;
    private LinkedList lCuotas      = null;
    private LinkedList lTextos      = null;

    private NoGestionar oNoGestionar = null;
    @Expose
    private String sMensError           = new String();
    @Expose
    private int  iNumError              = 0;
    private CallableStatement cons = null;
    
    /** Creates a new instance of Certificado */
    public Poliza() {
    }

    public void setfechaEmision      (Date param) { this.fechaEmision = param; }
    public void setfechaInicioVigencia (Date param) { this.fechaInicioVigencia = param; }
    public void setfechaFinVigencia    (Date param) { this.fechaFinVigencia = param; }
    public void setfechaEmisionEnd      (Date param) { this.fechaEmisionEnd = param; }
    public void setfechaInicioVigenciaEnd (Date param) { this.fechaInicioVigenciaEnd = param; }
    public void setfechaFinVigenciaEnd    (Date param) { this.fechaFinVigenciaEnd = param; }
    public void setcodRama            (int param) { this.codRama = param; }
    public void setcodSubRama         (int param) { this.codSubRama = param; }
    public void setcodCobFinal        (int param) { this.codCobFinal = param; }
    public void setestado             (String param) { this.estado = param; }
    public void setboca             (String param) { this.boca = param; }    
    public void setcantVidas          (int param) { this.cantVidas = param; }
    public void setnumPoliza          (int param) { this.numPoliza  = param; }
    public void setnumPolizaAnt          (int param) { this.numPolizaAnt  = param; }
    public void setnumEndoso          (int param) { this.numEndoso  = param; }
    public void setnumTomador         (int param) { this.numTomador  = param; }
    public void setcodProd            (int param) { this.codProd   = param; }
    public void setimpTotalFacturado  (double param) { this.impTotalFacturado = param; }
    public void setimpSaldoPoliza     (double param) { this.impSaldoPoliza = param; }
    public void setimpSaldoPolizaAnt  (double param) { this.impSaldoPolizaAnt = param; }    
    public void setimpDeuda           (double param) { this.impDeuda = param; }
    public void setrazonSocialTomador (String param) { this.razonSocialTomador = param; }
    public void setdescRama          (String param) { this.descRama      = param; }
    public void setdescSubRama       (String param) { this.descSubRama   = param; }    
    public void setdescProductor     (String param) { this.descProductor = param; }    
    public void setfechaFTP          (Date param) { this.fechaFTP = param; }
    public void setnumPropuesta      (int param) { this.numPropuesta  = param; }
    public void setAsegurados        (LinkedList param) { this.lAsegurados = param; }
    public void setCobranza          (LinkedList param) { this.lCobranza   = param; }
    public void setSeguimiento       (LinkedList param) { this.lSeguimiento = param; }
    public void setCuotas            (LinkedList param) { this.lCuotas     = param; }
    public void setrenovadaPor       (int param) { this.renovadaPor = param; }
    public void setnumCotizacion     (int param) { this.numCotizacion = param; }
    public void setcodProducto       (int param) { this.codProducto  = param; }
    
    public void setuserId             (String param) { this.userId = param; }
    public void setfechaTrabajo       (Date param) { this.fechaTrabajo = param; }
    public void sethoraOperacion      (Date param) { this.horaOperacion = param; }
    public void setPremio             (Premio param) { this.oPremio  = param; }
    public void setdescActividad         (String param) { this.descActividad  = param; }
    public void setperiodoFact        (int param) { this.periodoFact = param; }
    public void setbenefHerederos  ( String param){ benefHerederos = param; }
    public void setbenefTomador    ( String param){ benefTomador = param; }
    public void setlimMaxAcontecimiento (double param){ limMaxAcontecimiento  = param; }
    public void setcodActividadSec (int param ){ codActividadSec  = param; }
    public void setclaNoRepeticion ( String param){ claNoRepeticion = param; }
    public void setclaSubrogacion  ( String param){ claSubrogacion = param; }
    public void setcantMaxClausulas ( int param ) {  this.cantMaxClausulas = param ; }    
    public void setAllClausulas (LinkedList param) {this.lClausulas = param;}
    public void setCuic           ( String param){ cuic         = param; }
    public void settipoEndoso     (int param ){ tipoEndoso      = param; }
    public void setsDescTipoEndoso( String param){ sDescTipoEndoso = param; }
    public void setiPolizaGrupo    (int param ){ iPolizaGrupo   = param; }
    public void setsDescPolizaGrupo(String param){ sDescPolizaGrupo = param; }
    public void setsDescMoneda  ( String param){ sDescMoneda    = param; }
    public void setsSignoMoneda ( String param){ sSignoMoneda   = param; }
    public void setlTextos        (LinkedList param) { this.lTextos  = param; }
    public void setsCodFormaPago  (String param) { this.sCodFormaPago = param; }
    public void setoNoGestionar   (NoGestionar  param) { this.oNoGestionar = param; }
    public void setsubSeccion     (int param ){ subSeccion   = param; }

    public Date getfechaEmision       () { return  this.fechaEmision;}
    public Date getfechaInicioVigencia() { return  this.fechaInicioVigencia;}
    public Date getfechaFinVigencia   () { return  this.fechaFinVigencia;}
    public Date getfechaEmisionEnd       () { return  this.fechaEmisionEnd;}
    public Date getfechaInicioVigenciaEnd() { return  this.fechaInicioVigenciaEnd;}
    public Date getfechaFinVigenciaEnd   () { return  this.fechaFinVigenciaEnd;}
    public int getcodRama             () { return  this.codRama;}
    public int getcodSubRama          () { return  this.codSubRama;}
    public int getcodCobFinal         () { return  this.codCobFinal;}
    public String getestado           () { return this.estado;}
    public String getboca             () { return this.boca;}    
    public int getnumPoliza           () { return this.numPoliza;}    
    public int getnumPolizaAnt        () { return this.numPolizaAnt;}    
    public int getnumEndoso           () { return this.numEndoso;}    
    public int getnumTomador          () { return this.numTomador;}    
    public double getimpTotalFacturado () { return this.impTotalFacturado;}
    public double getimpSaldoPoliza    () { return this.impSaldoPoliza;}
    public double getimpSaldoPolizaAnt () { return this.impSaldoPolizaAnt;}
    public double getimpDeuda          () { return this.impDeuda;}
    public String getrazonSocialTomador () { return this.razonSocialTomador; }
    public String getdescRama         () { return this.descRama;}
    public String getdescSubRama      () { return this.descSubRama;}    
    public String getdescProductor    () { return this.descProductor;}    
    public int getnumPropuesta        () { return this.numPropuesta;}        
    public LinkedList getAsegurados   () { return this.lAsegurados; }        
    public LinkedList getCobranza     () { return this.lCobranza; }  
    public LinkedList getSeguimiento  () { return this.lSeguimiento; } 
    public LinkedList getCuotas       () { return this.lCuotas; } 
    public Premio getPremio           () { return  this.oPremio;}
    public String getdescActividad         () { return  this.descActividad  ; }
    public int getcantVidas () { return this.cantVidas ; }
    public String getuserId           () { return this.userId;}
    public Date getfechaTrabajo       () { return  this.fechaTrabajo;}
    public Date gethoraOperacion      () { return  this.horaOperacion;}
    public Date getfechaFTP           () { return  this.fechaFTP;}
    public int getperiodoFact         () { return this.periodoFact;}        
    public String getbenefHerederos   (){ return this.benefHerederos; }
    public String getbenefTomador     (){ return this.benefTomador; }
    public double getlimMaxAcontecimiento (){ return this.limMaxAcontecimiento; }
    public int    getcodActividadSec  (){ return this.codActividadSec; }   
    public String getclaNoRepeticion  (){ return this.claNoRepeticion; }
    public String getclaSubrogacion   (){ return this.claSubrogacion; }
    public int    getcantMaxClausulas (){ return this.cantMaxClausulas; }        
    public LinkedList getAllClausulas () {return lClausulas;}
    public String getCuic             () {return this.cuic; }
    public int    gettipoEndoso       () {return this.tipoEndoso; }
    public int    getcodProd          () {return this.codProd; }
    public String getsDescTipoEndoso  () {return this.sDescTipoEndoso; }
    public int    getiPolizaGrupo     () {return this.iPolizaGrupo; }
    public String getsDescPolizaGrupo () {return this.sDescPolizaGrupo; }
    public String getsDescMoneda      () {return this.sDescMoneda; }
    public String getsSignoMoneda     () {return this.sSignoMoneda; }
    public int    getrenovadaPor      () {return this.renovadaPor; }
    public int    getnumCotizacion    () {return this.numCotizacion; }
    public LinkedList getlTextos      () { return this.lTextos; }
    public String getsCodFormaPago    () {return this.sCodFormaPago; }
    public NoGestionar getoNoGestionar() {return this.oNoGestionar; }
    public int    getcodProducto      () {return this.codProducto; }
    public int    getsubSeccion       () {return this.subSeccion; }

    public String getsMensError  () { return this.sMensError;}
    public void setsMensError  (String psMensError ) {this.sMensError = psMensError;}
    public int getiNumError  () {return this.iNumError;}
    public void setiNumError  (int piNumError ) {this.iNumError  = piNumError;}
    
    public Poliza getDB ( Connection dbCon) throws SurException {
        Date oTime = new Date();
        GregorianCalendar gc = new GregorianCalendar();
        gc.setTime(oTime);
        ResultSet rs = null;
        boolean bExiste = false;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PZ_GET_POLIZA (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodRama());
            cons.setInt (3, this.getnumPoliza ());
            cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    bExiste     = true;
                    this.setcodRama             (rs.getInt ("COD_RAMA"));
                    this.setcodSubRama          (rs.getInt ("COD_SUB_RAMA"));
                    this.setcodProducto         (rs.getInt ("COD_PRODUCTO"));
                    this.setnumPoliza           (rs.getInt("NUM_POLIZA"));
                    this.setdescRama            (rs.getString ("RAMA"));
                    this.setdescSubRama         (rs.getString ("SUB_RAMA"));
                    this.setcodProd             (rs.getInt ("COD_PROD"));  
                    this.setnumTomador          (rs.getInt ("NUM_TOMADOR"));
                    this.setfechaEmision        (rs.getDate("FECHA_EMISION_POL"));
                    this.setfechaInicioVigencia (rs.getDate("FECHA_INI_VIG_POL"));
                    this.setfechaFinVigencia    (rs.getDate("FECHA_FIN_VIG_POL"));
                    this.setcantVidas           (rs.getInt ("CANT_VIDAS")); 
                    this.setestado              (rs.getString ("ESTADO"));
                    this.setperiodoFact         (rs.getInt ("PERIODO_FACT"));
                    this.setimpTotalFacturado   (rs.getDouble ("TOTAL_FACTURADO"));
                    this.setimpSaldoPoliza      (rs.getDouble ("SALDO_POLIZA"));
                    this.setimpDeuda            (rs.getDouble("IMP_DEUDA"));
                    this.setfechaFTP            (rs.getDate  ("FECHA_FTP")); 
                    this.setnumPropuesta        (rs.getInt ("NUM_PROPUESTA"));
                    this.setboca                (rs.getString ("BOCA"));
                    this.setnumPolizaAnt        (rs.getInt ("POLIZA_ANTERIOR"));
                    this.setimpSaldoPolizaAnt   (rs.getDouble ("SALDO_ANTERIOR"));
                    this.setdescActividad       (rs.getString ("DESC_ACTIVIDAD"));
                    this.setestado              (rs.getString ("ESTADO"));
                    
/*                    if (rs.getString ("ESTADO").equals ("4")) {
                        this.setestado              ("ANULADA");
                    } else if (rs.getDate("FECHA_FIN_VIG_POL") != null && rs.getDate("FECHA_FIN_VIG_POL").before(gc.getTime())) {
                        this.setestado ("FINALIZADA");                    
                    } else if (rs.getDate("FECHA_INI_VIG_POL") != null && rs.getDate("FECHA_INI_VIG_POL").after(gc.getTime())) {
                        this.setestado ("NO VIGENTE");                    
                    } else this.setestado              ("VIGENTE");
  */
                    this.setclaNoRepeticion (rs.getString ("CLA_NO_REPETICION"));
                    this.setclaSubrogacion  (rs.getString ("CLA_SUBROGACION"));
                    this.setbenefHerederos  (rs.getString ("BENEF_HEREDEROS"));
                    this.setbenefTomador    (rs.getString ("BENEF_TOMADOR"));
                    this.setlimMaxAcontecimiento (rs.getDouble ("LIM_MAX_ACONTECIMIENTO"));
                    this.setcodActividadSec (rs.getInt ("COD_ACTIVIDAD_SEC"));
                    this.setcantMaxClausulas(rs.getInt ("CANT_MAX_EMPRESAS"));
                    this.setCuic            (rs.getString ("CUIC"));
                    this.setiPolizaGrupo(rs.getInt ("POLIZA_GRUPO"));
                    this.setsDescPolizaGrupo(rs.getString ("DESC_POLIZA_GRUPO"));
                    this.setsDescMoneda      (rs.getString ("MONEDA"));
                    this.setsSignoMoneda     (rs.getString ("SIGNO_MONEDA"));
                    this.setsCodFormaPago    (rs.getString ("COD_FORMA_PAGO"));
                    this.setdescProductor    (rs.getString ("DESC_PRODUCTOR"));
                    this.setsubSeccion       (rs.getInt ("SUB_SECCION"));
   
                    Premio oPre = new Premio ();
                    
                    oPre.setimpPrima( rs.getDouble ("IMP_PRIMA"));
                    oPre.setMpremio ( rs.getDouble ("IMP_PREMIO"));
//                    oPre.setimpPrima( rs.getDouble ("TOTAL_FACTURADO_END"));
//                    oPre.setimpPrima( rs.getDouble ("SALDO_POLIZA_END"));
//                    oPre.setimpPrima( rs.getDouble ("IMP_DEUDA_END" ));
                    oPre.setimpRecFin   (rs.getDouble ("IMP_RECARGO_FINANCIERO" ));
                    oPre.setimpRecAdm   (rs.getDouble ("IMP_RECARGO_ADMINITRATIVO" ));
                    oPre.setimpDerEmi   (rs.getDouble ("IMP_DERECHO_EMISION"));
                    oPre.setimpIVA      (rs.getDouble ("IMP_IVA"));
                    oPre.setimpSellados (rs.getDouble ("IMP_SELLADOS"));
                    oPre.setimpOtrosImpuestos(rs.getDouble ("IMP_OTROS_IMPUESTOS"));
                    oPre.setsDescFormaPago          (rs.getString ("FORMA_PAGO"));
                    oPre.setporcComisionPrimaProd  (rs.getDouble ("PROD_COMISION_PRIMA"));
                    oPre.setporcComisionPremioProd (rs.getDouble ("PROD_COMISION_PREMIO"));
                    oPre.setporcComisionPrimaOrg   (rs.getDouble ("ORG_COMISION_PRIMA"));
                    oPre.setporcComisionPremioOrg  (rs.getDouble ("ORG_COMISION_PREMIO"));
                    this.setPremio(oPre);
                }
                rs.close();
            }
           if (! bExiste) {
                setiNumError (-100);
                setsMensError ("NO EXISTE LA POLIZA");
           }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Poliza [getDB]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error Poliza [getDB]" + e.getMessage());
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

    public Poliza getDBEnd ( Connection dbCon) throws SurException {
        Date oTime = new Date();
        GregorianCalendar gc = new GregorianCalendar();
        gc.setTime(oTime);
         ResultSet rs = null;
         boolean bExiste = false;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PZ_GET_POLIZA (?,?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodRama());
            cons.setInt (3, this.getnumPoliza ());
            cons.setInt (4, this.getnumEndoso());
            cons.execute();

           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    bExiste = true;
                    this.setcodRama             (rs.getInt ("COD_RAMA"));
                    this.setcodSubRama          (rs.getInt ("COD_SUB_RAMA"));
                    this.setcodProducto         (rs.getInt ("COD_PRODUCTO"));
                    this.setnumPoliza           (rs.getInt("NUM_POLIZA"));
                    this.setdescRama            (rs.getString ("RAMA"));
                    this.setdescSubRama         (rs.getString ("SUB_RAMA"));
                    this.setcodProd             (rs.getInt ("COD_PROD"));
                    this.setnumTomador          (rs.getInt ("NUM_TOMADOR"));
                    this.setfechaEmision        (rs.getDate("FECHA_EMISION_POL"));
                    this.setfechaInicioVigencia (rs.getDate("FECHA_INI_VIG_POL"));
                    this.setfechaFinVigencia    (rs.getDate("FECHA_FIN_VIG_POL"));
                    this.setfechaEmisionEnd        (rs.getDate("FECHA_EMISION_END"));
                    this.setfechaInicioVigenciaEnd (rs.getDate("FECHA_INI_VIG_END"));
                    this.setfechaFinVigenciaEnd    (rs.getDate("FECHA_FIN_VIG_END"));
                    this.setcantVidas           (rs.getInt ("CANT_VIDAS"));
                    this.setestado              (rs.getString ("ESTADO"));
                    this.setperiodoFact         (rs.getInt ("PERIODO_FACT"));
                    this.setimpTotalFacturado   (rs.getDouble ("TOTAL_FACTURADO"));
                    this.setimpSaldoPoliza      (rs.getDouble ("SALDO_POLIZA"));
                    this.setimpDeuda            (rs.getDouble("IMP_DEUDA"));
                    this.setfechaFTP            (rs.getDate  ("FECHA_FTP"));
                    this.setnumPropuesta        (rs.getInt ("NUM_PROPUESTA"));
                    this.setboca                (rs.getString ("BOCA"));
                    this.setnumPolizaAnt        (rs.getInt ("POLIZA_ANTERIOR"));
                    this.setimpSaldoPolizaAnt   (rs.getDouble ("SALDO_ANTERIOR"));
                    this.setdescActividad          (rs.getString ("DESC_ACTIVIDAD"));

                    if (rs.getString ("ESTADO").equals ("4")) {
                        this.setestado              ("ANULADA");
                    } else if (rs.getDate("FECHA_FIN_VIG_POL") != null && rs.getDate("FECHA_FIN_VIG_POL").before(gc.getTime())) {
                        this.setestado ("FINALIZADA");
                    } else if (rs.getDate("FECHA_INI_VIG_POL") != null && rs.getDate("FECHA_INI_VIG_POL").after(gc.getTime())) {
                        this.setestado ("NO VIGENTE");
                    } else this.setestado              ("VIGENTE");

                    this.setclaNoRepeticion (rs.getString ("CLA_NO_REPETICION"));
                    this.setclaSubrogacion  (rs.getString ("CLA_SUBROGACION"));
                    this.setbenefHerederos  (rs.getString ("BENEF_HEREDEROS"));
                    this.setbenefTomador    (rs.getString ("BENEF_TOMADOR"));
                    this.setlimMaxAcontecimiento (rs.getDouble ("LIM_MAX_ACONTECIMIENTO"));
                    this.setcodActividadSec (rs.getInt ("COD_ACTIVIDAD_SEC"));
                    this.setcantMaxClausulas(rs.getInt ("CANT_MAX_EMPRESAS"));
                    this.setCuic            (rs.getString ("CUIC"));
                    this.settipoEndoso      (rs.getInt("TIPO_ENDOSO"));
                    this.setsDescTipoEndoso(rs.getString ("DESC_TIPO_ENDOSO"));
                    this.setsDescMoneda(rs.getString ("MONEDA"));
                    this.setsSignoMoneda(rs.getString ("SIGNO_MONEDA"));
                    this.setsCodFormaPago(rs.getString ("COD_FORMA_PAGO"));
                    this.setdescProductor    (rs.getString ("DESC_PRODUCTOR"));
                    this.setsubSeccion       (rs.getInt ("SUB_SECCION"));                    

                    Premio oPre = new Premio ();

                    oPre.setimpPrima( rs.getDouble ("IMP_PRIMA"));
                    oPre.setMpremio ( rs.getDouble ("IMP_PREMIO"));
                    oPre.setimpRecFin   (rs.getDouble ("IMP_RECARGO_FINANCIERO" ));
                    oPre.setimpRecAdm   (rs.getDouble ("IMP_RECARGO_ADMINITRATIVO" ));
                    oPre.setimpDerEmi   (rs.getDouble ("IMP_DERECHO_EMISION"));
                    oPre.setimpIVA      (rs.getDouble ("IMP_IVA"));
                    oPre.setimpSellados (rs.getDouble ("IMP_SELLADOS"));
                    oPre.setimpOtrosImpuestos(rs.getDouble ("IMP_OTROS_IMPUESTOS"));
                    oPre.setsDescFormaPago          (rs.getString ("FORMA_PAGO"));
                    oPre.setporcComisionPrimaProd  (rs.getDouble ("PROD_COMISION_PRIMA"));
                    oPre.setporcComisionPremioProd (rs.getDouble ("PROD_COMISION_PREMIO"));
                    oPre.setporcComisionPrimaOrg   (rs.getDouble ("ORG_COMISION_PRIMA"));
                    oPre.setporcComisionPremioOrg  (rs.getDouble ("ORG_COMISION_PREMIO"));

                    this.setPremio(oPre);
                }
                rs.close();
           }
           if (! bExiste ) {
                setiNumError (-100);
                setsMensError ("ENDOSO INEXISTENTE");
           }
            
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Poliza [getDB]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error Poliza [getDB]" + e.getMessage());
        } finally {
            try{
                if (rs != null) { rs.close (); }
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }

    public LinkedList getDBAsegurados ( Connection dbCon) throws SurException {
        LinkedList lAseg = new LinkedList();
        ResultSet rs = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PZ_GET_ASEGURADOS (?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodRama());
            cons.setInt (3, this.getnumPoliza ());
            cons.setString (4, this.getuserId());
            cons.execute();
           
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    Asegurado oAseg = new Asegurado();
                    oAseg.setcodRama        (rs.getInt("COD_RAMA"));
                    oAseg.setnumPoliza      (rs.getInt("NUM_POLIZA"));
                    oAseg.setcertificado    (rs.getInt("CERTIFICADO"));
                    oAseg.setsubCertificado (rs.getInt("SUB_CERTIFICADO"));
                    oAseg.setdescTipoDoc    (rs.getString("DESC_TIPO_DOC"));
                    oAseg.setnumDoc         (rs.getString("NUM_DOC"));
                    oAseg.setnombre         (rs.getString("NOMBRE"));
                    oAseg.setdomicilio      (rs.getString("DOMICILIO"));
                    oAseg.setfechaAltaCob   (rs.getDate ("FECHA_ALTA_COB"));
                    oAseg.setfechaBaja      (rs.getDate ("FECHA_BAJA"));
                    oAseg.setendosoAlta     (rs.getInt("ENDOSO_ALTA"));
                    oAseg.setendosoBaja     (rs.getInt("ENDOSO_BAJA"));
                    oAseg.setestado         (rs.getString("ESTADO"));
                    oAseg.setfechaFTP       (rs.getDate ("FECHA_FTP"));
                    oAseg.setdFechaNac      (rs.getDate("FECHA_NAC"));
                    lAseg.add(oAseg);
                }
                rs.close();
            }
            cons.close();
            return lAseg;
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Poliza [getDBAsegurados]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error Poliza [getDBAsegurados]" + e.getMessage());
        } finally {
            try{
                if (rs != null ) rs.close ();
                if (cons != null) cons.close (); 
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }

    public LinkedList getDBTextosVariable ( Connection dbCon) throws SurException {
        LinkedList lTexto = new LinkedList();
         ResultSet rs =  null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PZ_GET_ALL_TEXTOS_VARIABLE (?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodRama ());
            cons.setInt (3, this.getnumPoliza ());
            cons.setInt (4, this.getnumEndoso());
            cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    TextoPoliza oText = new TextoPoliza ();
                    oText.setcodRama     (rs.getInt("COD_RAMA"));
                    oText.setnumPoliza   (rs.getInt("NUM_POLIZA"));
                    oText.setendoso      (rs.getInt("NUM_ENDOSO"));
                    oText.setrenglon     (rs.getInt ("RENGLON"));
                    oText.settexto       (rs.getString ("TEXTO"));
                    oText.setfechaFTP    (rs.getDate ("FECHA_FTP"));

                    lTexto.add(oText);
                }
                rs.close();
            }
            return lTexto;
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Poliza [getDBTExtosVariables]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error Poliza [getDBTextosVariables]" + e.getMessage());
        } finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }
    
    public LinkedList getDBAseguradosEnd ( Connection dbCon) throws SurException {
        LinkedList lAseg = new LinkedList();
        ResultSet rs = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PZ_GET_ASEGURADOS_END (?, ?, ?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodRama());
            cons.setInt (3, this.getnumPoliza ());
            cons.setInt (4, this.getnumEndoso());
            cons.setString (5, this.getuserId());
            cons.execute();
           
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    Asegurado oAseg = new Asegurado();
                    oAseg.setcodRama        (rs.getInt   ("COD_RAMA"));
                    oAseg.setnumPoliza      (rs.getInt   ("NUM_POLIZA"));
                    oAseg.setcertificado    (rs.getInt   ("CERTIFICADO"));
                    oAseg.setsubCertificado (rs.getInt   ("SUB_CERTIFICADO"));
                    oAseg.setdescTipoDoc    (rs.getString("DESC_TIPO_DOC"));
                    oAseg.settipoDoc        (rs.getString("TIPO_DOC"));
                    oAseg.setnumDoc         (rs.getString("NUM_DOC"));
                    oAseg.setnombre         (rs.getString("NOMBRE"));
  //                  oAseg.setdomicilio      (rs.getString("DOMICILIO"));
                    oAseg.setfechaAltaCob   (rs.getDate     ("FECHA_ALTA_COB"));
                    oAseg.setfechaBaja      (rs.getDate     ("FECHA_BAJA"));
                    oAseg.setendosoAlta     (rs.getInt      ("ENDOSO_ALTA"));
                    oAseg.setendosoBaja     (rs.getInt      ("ENDOSO_BAJA"));
                    oAseg.setestado         (rs.getString   ("ESTADO"));
                    oAseg.setsVigente       (rs.getString   ("VIGENTE"));
//                    oAseg.setfechaFTP       (rs.getDate ("FECHA_FTP"));

                    if ( this.getnumEndoso() == oAseg.getendosoAlta()) {
                        oAseg.setCoberturas(oAseg.getDBCoberturasEnd(dbCon, this.getnumEndoso()));
                    }
                    
                    lAseg.add(oAseg);
                }
                rs.close();
            }
            
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Poliza [getDBAsegurados]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error Poliza [getDBAsegurados]" + e.getMessage());
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

    public LinkedList getDBCobranzaEnd ( Connection dbCon) throws SurException {
        LinkedList lCob = new LinkedList();
        cons = null;
        ResultSet rs = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PZ_GET_COBRANZA_END (?, ?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodRama());
            cons.setInt (3, this.getnumPoliza ());
            cons.setInt (4, this.getnumEndoso());
            cons.execute();
           
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    Pago oPago = new Pago();
                    oPago.setcodRama       (rs.getInt ("COD_RAMA"));
                    oPago.setnumPoliza     (rs.getInt ("NUM_POLIZA"));
                    oPago.setendoso        (rs.getInt ("ENDOSO"));
                    oPago.setFechaCobro    (rs.getDate("FECHA_PAGO"));
                    oPago.setiImporte      (rs.getDouble("IMP_PAGO"));
                    oPago.setcodMovimiento (rs.getInt("TIPO_MOV"));
                    oPago.setcomprobante   (rs.getString("NUM_COMPROBANTE"));
                    oPago.setdescMovimiento(rs.getString ("DESCRIPCION"));

                    lCob.add(oPago);
                }
                rs.close();
            }
            
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Poliza [getDBCobranza]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error Poliza [getDBCobranza]" + e.getMessage());
        } finally {
            try{
                if (rs != null) { rs.close (); }
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return lCob;            
        }
    }

// LA DIFERENCIA CON GET_COBRANZA_END ES QUE LOS PAGOS ESTAN AGRUPADOS POR FECHA
// EN GET_COBRANZA_END SON LAS APLICACIONES DIRECTAMENTE.
    public LinkedList getDBPagosEnd ( Connection dbCon) throws SurException {
        LinkedList lCob = new LinkedList();
        cons = null;
        ResultSet rs = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PZ_GET_PAGOS_END (?, ?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodRama());
            cons.setInt (3, this.getnumPoliza ());
            cons.setInt (4, this.getnumEndoso());
            cons.execute();

            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    Pago oPago = new Pago();
                    oPago.setcodRama       (rs.getInt ("COD_RAMA"));
                    oPago.setnumPoliza     (rs.getInt ("NUM_POLIZA"));
                    oPago.setendoso        (rs.getInt ("ENDOSO"));
                    oPago.setFechaCobro    (rs.getDate("FECHA_PAGO"));
                    oPago.setiImporte      (rs.getDouble("IMP_PAGO"));
                    lCob.add(oPago);
                }
                rs.close();
            }

        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Poliza [getDBPagos]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error Poliza [getDBPagos]" + e.getMessage());
        } finally {
            try{
                if (rs != null) { rs.close (); }
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return lCob;
        }
    }
    
    public LinkedList getDBCuotasEnd ( Connection dbCon) throws SurException {
        LinkedList lCob = new LinkedList();
        cons = null;
        ResultSet rs = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PZ_GET_CUOTAS_END (?, ?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodRama());
            cons.setInt (3, this.getnumPoliza ());
            cons.setInt (4, this.getnumEndoso());
            cons.execute();
           
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    Cuota oCuota = new Cuota();
                    oCuota.setcodRama       (rs.getInt ("COD_RAMA"));
                    oCuota.setnumPoliza     (rs.getInt ("NUM_POLIZA"));
                    oCuota.setendoso        (rs.getInt ("ENDOSO"));
                    oCuota.setdFechaVencimiento(rs.getDate("FECHA_VENCIMIENTO"));
                    oCuota.setiImporte      (rs.getDouble("IMP_CUOTA"));
                    oCuota.setiNumCuota     (rs.getInt ("NUM_CUOTA"));
                    lCob.add(oCuota);
                }
                rs.close();
            }
            
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Poliza [getDBCobranza]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error Poliza [getDBCobranza]" + e.getMessage());
        } finally {
            try{
                if (rs != null) { rs.close (); }
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return lCob;            
        }
    }

    public LinkedList getDBAllEmpresasClausulas ( Connection dbCon) throws SurException {
        LinkedList lCla = new LinkedList();
        cons = null;
        ResultSet rs = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PZ_GET_ALL_CLAUSULAS (?, ?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodRama());
            cons.setInt (3, this.getnumPoliza ());
            cons.setInt (4, this.getnumEndoso());
            cons.execute();
           
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    Clausula oCla = new Clausula();
                    oCla.setnumItem       (rs.getInt ("NUM_ITEM"));
                    oCla.setcuitEmpresa   (rs.getString ("CUIT"));
                    oCla.setdescEmpresa   (rs.getString ("DESCRIPCION"));
                    
                    lCla.add(oCla);
               }
                rs.close();
            }
            
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Poliza [getDBCobranza]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error Poliza [getDBCobranza]" + e.getMessage());
        } finally {
            try{
                if (rs != null) { rs.close (); }
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return lCla;            
        }
    }

    public boolean getDBExiste ( Connection dbCon) throws SurException {
        boolean bExiste = false;
       try {  
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PZ_EXISTE_POLIZA (?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt (2, this.getcodRama());
            cons.setInt (3, this.getnumPoliza ());
            cons.setString (4, this.getuserId());
            cons.execute();

            if (cons.getInt (1) > 0) bExiste = true;
           
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Poliza [getDBExiste]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error Poliza [getDBExiste]" + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return bExiste;
        }
    }

    public boolean getDBCoberturaFinanciera ( Connection dbCon, String operacion ) throws SurException {
        // devuelve true si tiene cobertura financiera, false caso contrario
        boolean bExiste = true;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PZ_GET_COBERTURA_FINANCIERA (?, ?,?,?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.BIT);
            cons.setInt (2, this.getcodRama());
            cons.setInt (3, this.getcodSubRama());
            cons.setInt (4, this.getnumPoliza ());
            cons.setString (5, operacion );
            cons.setString (6, this.getsCodFormaPago());
            cons.execute();

            bExiste = cons.getBoolean(1);

        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Poliza [getDBCoberturaFinanciera]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error Poliza [getDBCoberturaFinanciera]" + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return bExiste;
        }
    }
    
    public LinkedList getDBSeguimientoEnd ( Connection dbCon) throws SurException {
        LinkedList lSeg = new LinkedList();
        cons = null;
        ResultSet rs = null;
       try {
/*            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PZ_GET_SEGUIMIENTO_END (?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString (2, this.getboca());
            cons.setInt    (3, this.getnumPropuesta());
            cons.execute();
           
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    Seguimiento oSeg = new Seguimiento();
                    oSeg.setNumPropuesta(rs.getInt ("NUM_PROPUESTA"));
                    oSeg.setBoca        (rs.getString ("BOCA"));
                    oSeg.setCodEstado   (rs.getString ("ESTADO"));
                    oSeg.setdescEstado  (rs.getString ("DESCRIPCION"));
                    oSeg.setFechaTrabajo (rs.getDate  ("FECHA_TRABAJO"));
                    oSeg.setHoraTrabajo  (rs.getString ("HORA_TRABAJO"));
                    
                    lSeg.add(oSeg);
                }
                rs.close();
            }
  */
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PZ_GET_ALL_SEGUIMIENTO (?, ?, ? )"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodRama());
            cons.setInt  (3, this.getnumPoliza());
            cons.setInt(4, this.getnumEndoso());
            cons.execute();
           
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    Seguimiento oSeg = new Seguimiento();
                    oSeg.setNumPropuesta(rs.getInt ("NUM_PROPUESTA"));
                    oSeg.setBoca        (rs.getString ("BOCA"));
                    oSeg.setCodEstado   (rs.getString ("ESTADO"));
                    oSeg.setdescEstado  (rs.getString ("DESCRIPCION"));
                    oSeg.setFechaTrabajo (rs.getDate  ("FECHA_TRABAJO"));
                    oSeg.setHoraTrabajo  (rs.getString ("HORA_TRABAJO"));
                    
                    lSeg.add(oSeg);
                }
                rs.close();
            }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Poliza [getDBSeguimiento]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error Poliza [getDBSeguimiento]" + e.getMessage());
        } finally {
            try{
                if (rs != null) { rs.close (); }
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return lSeg;            
        }
    }

    public Poliza getDBWeb ( Connection dbCon, String dni) throws SurException {
        ResultSet rs = null;
        boolean bExiste = false;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PZ_GET_POLIZA_WEB (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString (2, dni);
            cons.setInt (3, this.getnumPoliza ());
            cons.execute();

           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    bExiste     = true;
                    this.setcodRama             (rs.getInt ("COD_RAMA"));
                    this.setcodSubRama          (rs.getInt ("COD_SUB_RAMA"));
                    this.setnumPoliza           (rs.getInt("NUM_POLIZA"));
                    this.setcodProd             (rs.getInt ("COD_PROD"));
                    this.setnumTomador          (rs.getInt ("NUM_TOMADOR"));
                    this.setfechaEmision        (rs.getDate("FECHA_EMISION_POL"));
                    this.setfechaInicioVigencia (rs.getDate("FECHA_INI_VIG_POL"));
                    this.setfechaFinVigencia    (rs.getDate("FECHA_FIN_VIG_POL"));
                    this.setimpDeuda            (rs.getDouble("IMP_DEUDA"));
                    this.setestado              (rs.getString ("ESTADO"));
                    this.setCuic                (rs.getString ("CUIC"));
                    this.setcantVidas           (rs.getInt ("CANT_VIDAS"));
                    this.setsCodFormaPago(rs.getString ("COD_FORMA_PAGO"));
                }
                rs.close();
            }
           if (! bExiste) {
                setiNumError (-100);
                setsMensError ("NO EXISTE LA POLIZA");
           }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Poliza [getDB]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error Poliza [getDB]" + e.getMessage());
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

}


