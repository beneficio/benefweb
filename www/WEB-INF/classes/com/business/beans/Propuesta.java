/*
 * Certificado.java
 *
 * Created on 9 de enero de 2005, 19:37
 */

package com.business.beans;

import java.sql.ResultSet;
import java.sql.Connection;   
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.util.LinkedList;
import com.business.util.*;
import com.business.db.db;
import java.util.Date;
/**
 *
 * @author Rolando Elisii     
 */
public class Propuesta {
    
    private int    codProceso  ;  // int4 DEFAULT 1,
    private String boca          ;  // varchar(3),
    private int    numPropuesta  ;  // int4,
    private int    codRama       ;  // int4,
    private int    codSubRama    ;  // int4,
    private int    numPoliza     ;  // int4,
    private int    codCobFinal   ;  // int4,
    private int    codMoneda     ;  // int4 DEFAULT 1,
    private double impPremio     ;  // float8,
    private int    codFormaPago  ;  // int4,
    private double impCuota      ;  // float8,
    private int    codProd       ;  // int4,
    
    private int    periodoFact   ;  // int4,
    private int    cantCuotas    ;  // int4,
    private int    maxCantCuotas ;  // int4,
    private Date   fechaIniVigPol;  // date,
    private Date   fechaFinVigPol;  // date,
    private int    codVigencia   ;  // int4,
    private Date   fechaAlta     ;  // date,
    private int    cantVidas     ;  // int4,
    private int    codEstado     ;  // int4 DEFAULT 0,
    private String observaciones ;  // varchar(500),
    private int    numSecuCot    ;  // int4,
    private Date   fechaTrabajo  ;  // date DEFAULT ('now'::text)::date,
    private String   horaTrabajo   ;  // time DEFAULT ('now'::text)::time(6) with time zone,
    private String userid        ;  // varchar(20),
    private Date  fechaEnvioProd ;  // date,
    private Date  fechaEnvioBenef  ;  // date,
    private Date  fechaRespBenef   ;  // date,
    private Date  fechaEmision     ;  // date,
    private Date  fechaAnulacion   ;  // date,
    private String  horaEnvioProd    ;  // time,
    private String  horaEnvioBenef   ;  // time,
    private String  horaRespBenef    ;  // time,
    private String tipoPropuesta    ;  // varchar(1) DEFAULT 'P'::character varying    
    private int    codActividad     ;
    private String descProd     = "";
    private String descEstado   = "";
    private String descMcaEnviarPoliza = "";
    private String descRama     = "";
    private String descSubRama  = "";    
    //Datos del tomador
    private int    numTomador    ;  // int4,   
    private String tomadorTipoDoc = "";
    private String tomadorNumDoc  = "";
    private String tomadorRazon   = "";
    private String tomadorCuit    = "";  
    private int    tomadorCondIva = 0;   
    private String tomadorDom     = "";    
    private String tomadorLoc     = "";    
    private String tomadorCP      = "";    
    private String tomadorCodProv = "";     
    private String tomadorEmail   = "";     
    private String tomadorTE      = "";  
    private String mcaEnvioPoliza = "N";
    private String tomadorNom     = "";
    private String tomadorApe     = "";
    private String tomadorCargo   = "";
    private int tomadorCodLocalidad = 0;
    
    //Coberturas
    private double capitalMuerte     = 0.0;
    private double capitalAsistencia = 0.0;
    private double capitalInvalidez  = 0.0;
    private double franquicia        = 0.0;
    private double impPrimaTar       = 0.0;
    private double gastosAdquisicion = 0;    
    private double derEmi            = 0;
    private double gda               = 0;
    private double subTotal          = 0;
    private double porcIva           = 0;
    private double iva               = 0;
    private double porcSsn           = 0;
    private double ssn               = 0;
    private double porcSoc           = 0;
    private double soc               = 0;
    private double porcSellado       = 0;
    private double sellado           = 0;
    private double primaPura         = 0;    
    private double recAdmin          = 0;
    private double recFinan          = 0;
    private double porcRecAdmin      = 0;
    private double porcRecFinan      = 0;
    private double porcGDA           = 0;
    private double porcAjusteTarifa  = 0;
    private double impAjusteTarifa   = 0;
    private String nivelAjusteTarifa = "P";
    

    // Forma de Pago    
    private int    codTarjCred  = 0;
    private String descTarjCred = "";
    private String numTarjCred  = "";
    private Date   vencTarjCred;
    private int    codBanco     = 0;
    private String descBanco    = "";
    private String sucBanco     = "";        
    private String titular      = "";        
    private String cbu          = "";        
    private String descActividad = "";
    private String descVigencia  = "";
    private String tomadorDescTipoDoc = "";
    private String tomadorDescProv = "";     
    private String descFormaPago = "";
    private String tomadorDescCondIva = "";       
    private String descAmbito    = "";
    private int codFacturacion   = 0;
    private String descFacturacion = "";
    private int cantVidasAltas   = 0;
    private int cantVidasBajas   = 0;
    
    private String claNoRepeticion = "N";
    private String claSubrogacion  = "N";
    private String benefHerederos  = "N";
    private String benefTomador    = "N";
    private double limMaxAcontecimiento = 0;
    private int codActividadSec    = 0;
    private UbicacionRiesgo oRiesgo = null;
    private LinkedList lClausulas   = null;
    private int cantMaxClausulas    = 0;
    private int codPlan             = 0;
    private String descPlan         = null;
    private LinkedList lCoberturas  = null;
    private int numCertificado      = 0;
    private int codOpcion           = 0;
    private double porcOpcionAjuste = 0;
    private String codSeguridadTarjeta = " ";
    private String dirTitularTarjeta   = " ";
    private int codProducto  = 0;
    private int    codError   = 0;
    private String descError   = "";
    private String tipoNomina  = "S";
    private String nivelCob    = "P";
    private int polizaGrupo    = 0;
    private String descProducto = "";
    private int codAmbito      = 0;
    private String empleador   = "";
    private int numReferencia  = 0;
    private int polizaAnterior = 0;
    private int cantDias       = 0;
    private String categoriaPersona = null;   
    private int tipoEndoso     = 0;
    private String descTipoEndoso = "";
    private int numEndoso   = 0;
    private int subSeccion  = 0;
    private double porcComisionOrg = 0;
    private String baseCalculoComision = "A";
    private int numPropuestaSec = 0;

    /** Creates a new instance of Certificado */
    public Propuesta() {
    }
    
    // GET    
    public int    getCodProceso     (){ return this.codProceso;}
    public String getBoca           (){ return this.boca;}
    public int    getNumPropuesta   (){ return this.numPropuesta;}
    public int    getCodRama        (){ return this.codRama;}
    public int    getCodSubRama     (){ return this.codSubRama;}
    public int    getNumPoliza      (){ return this.numPoliza;}
    public int    getCodCobFinal    (){ return this.codCobFinal; }
    public int    getCodMoneda      (){ return this.codMoneda; }
    public double getImpPremio      (){ return this.impPremio; }
    public int    getCodFormaPago   (){ return this.codFormaPago; }
    public double getImpCuota       (){ return this.impCuota; }
    public int    getCodProd        (){ return this.codProd; }    
    public int    getPeriodoFact    (){ return this.periodoFact; }
    public int    getCantCuotas     (){ return this.cantCuotas; }
    public Date   getFechaIniVigPol (){ return this.fechaIniVigPol; }
    public Date   getFechaFinVigPol (){ return this.fechaFinVigPol; } 
    public int    getCodVigencia    (){ return this.codVigencia; }
    public Date   getFechaAlta      (){ return this.fechaAlta; }  
    public int    getCantVidas      (){ return this.cantVidas; }
    public int    getCodEstado      (){ return this.codEstado; }
    public int    getCantVidasAltas (){ return this.cantVidasAltas; }
    public int    getCantVidasBajas (){ return this.cantVidasBajas; }
    
    public String getObservaciones  (){ return this.observaciones; } 
    public int    getNumSecuCot     (){ return this.numSecuCot; }
    public Date   getFechaTrabajo   (){ return this.fechaTrabajo;  }
    public String   getHoraTrabajo    (){ return this.horaTrabajo;  }
    public String getUserid         (){ return this.userid;  }
    public Date   getFechaEnvioProd (){ return this.fechaEnvioProd; }
    public Date   getFechaEnvioBenef(){ return this.fechaEnvioBenef;  }
    public Date   getFechaRespBenef (){ return this.fechaRespBenef; } 
    public Date   getFechaEmision   (){ return this.fechaEmision; }
    public Date   getFechaAnulacion (){ return this.fechaAnulacion; }
    public String getHoraEnvioProd  (){ return this.horaEnvioProd; }
    public String getHoraEnvioBenef (){ return this.horaEnvioBenef; }
    public String getHoraRespBenef  (){ return this.horaRespBenef; }
    public String getTipoPropuesta  (){ return this.tipoPropuesta; }     
    public int    getCodActividad   (){ return this.codActividad; }
    public String getdescProd       () { return this.descProd;}    
    public String getdescEstado     () { return this.descEstado;}    
    public String getdescActividad  () { return this.descActividad;}    
    public String getdescVigencia   () { return this.descVigencia;}    
    public String getdescFormaPago  () { return this.descFormaPago;}  
    public int    getCodError       (){ return this.codError; }
    public String getDescError      (){ return this.descError; }     
    public String getdescMcaEnviarPoliza  () { return this.descMcaEnviarPoliza;}  
    public String getTomadorCargo   () { return this.tomadorCargo;}
    public int    getnumReferencia  (){ return this.numReferencia; }
    
    //Datos del tomador
    public int    getNumTomador     (){ return this.numTomador; }
    public String getTomadorTipoDoc (){ return this.tomadorTipoDoc;}        
    public String getTomadorDescTipoDoc (){ return this.tomadorDescTipoDoc;}        
    public String getTomadorNumDoc  (){ return this.tomadorNumDoc;}        
    public String getTomadorRazon   (){ return this.tomadorRazon;}        
    public String getTomadorCuit    (){ return this.tomadorCuit;}        
    public int    getTomadorCondIva (){ return this.tomadorCondIva;}        
    public String getTomadorDescCondIva (){ return this.tomadorDescCondIva;}        
    public String getTomadorDom     (){ return this.tomadorDom;}        
    public String getTomadorLoc     (){ return this.tomadorLoc;}        
    public String getTomadorCP      (){ return this.tomadorCP;}        
    public String getTomadorCodProv (){ return this.tomadorCodProv;}        
    public String getTomadorDescProv (){ return this.tomadorDescProv;}        
    public String getTomadorEmail   (){ return this.tomadorEmail;}        
    public String getTomadorTE      (){ return this.tomadorTE;}        
    public String getTomadorNom     (){ return this.tomadorNom;}        
    public String getTomadorApe     (){ return this.tomadorApe;}        
    public int    getTomadorCodLocalidad (){ return this.tomadorCodLocalidad;}        
    
    //cobertura
    public double getCapitalMuerte     (){ return this.capitalMuerte;}        
    public double getCapitalAsistencia (){ return this.capitalAsistencia;}        
    public double getCapitalInvalidez  (){ return this.capitalInvalidez;}        
    public double getFranquicia        (){ return this.franquicia;}        
    public double getImpPrimaTar       (){ return this.impPrimaTar;}        

    public double getderEmi      () { return this.derEmi; }
    public double getgda         () { return this.gda; }
    public double getsubTotal    () { return this.subTotal; }
    public double getporcIva     () { return this.porcIva; }
    public double getiva         () { return this.iva; }
    public double getporcSsn     () { return this.porcSsn; }
    public double getssn         () { return this.ssn; }
    public double getporcSoc     () { return this.porcSoc; }
    public double getsoc         () { return this.soc; }
    public double getporcSellado () { return this.porcSellado; }
    public double getsellado     () { return this.sellado; }
    public double getprimaPura   () { return this.primaPura; }       
    public double getrecAdmin    () { return this.recAdmin; }           
    public double getrecFinan    () { return this.recFinan; }               
    public double getporcRecAdmin    () { return this.porcRecAdmin; }           
    public double getporcRecFinan    () { return this.porcRecFinan; }               
    public double getgastosAdquisicion() { return this.gastosAdquisicion;}
    public double getporcGDA    () { return this.porcGDA; }   
    public double getimpAjusteTarifa  () { return this.impAjusteTarifa; }        
    public double getporcAjusteTarifa () { return  this.porcAjusteTarifa; }        
    public String getnivelAjusteTarifa () { return this.nivelAjusteTarifa; }
    
    // Forma de Pago    
    public int    getCodTarjCred   (){ return this.codTarjCred;}    
    public String getDescTarjCred  (){ return this.descTarjCred;}    
    public String getNumTarjCred   (){ return this.numTarjCred;}    
    public Date   getVencTarjCred  (){ return this.vencTarjCred;}    
    public int    getCodBanco      (){ return this.codBanco;}    
    public String getDescBanco     (){ return this.descBanco;}    
    public String getSucBanco      (){ return this.sucBanco;}    
    public String getTitular       (){ return this.titular;}    
    public String getCbu           (){ return this.cbu;}    
    public String getMcaEnvioPoliza(){ return this.mcaEnvioPoliza;}        
    public String getDescAmbito    (){ return this.descAmbito; }         
    public String getDescRama      (){ return this.descRama; }         
    public String getDescSubRama   (){ return this.descSubRama; }         
    public int    getCodFacturacion(){ return this.codFacturacion ;}    
    public String getDescFacturacion  (){ return this.descFacturacion;}    
    public UbicacionRiesgo getoUbicacionRiesgo () { return this.oRiesgo; }

    public String getclaNoRepeticion   (){ return this.claNoRepeticion; }
    public String getclaSubrogacion    (){ return this.claSubrogacion; }
    public String getbenefHerederos    (){ return this.benefHerederos; }
    public String getbenefTomador      (){ return this.benefTomador; }
    public double getlimMaxAcontecimiento (){ return this.limMaxAcontecimiento; }
    public int    getcodActividadSec   (){ return this.codActividadSec; }
    public LinkedList getAllClausulas  () {return lClausulas;}
    public int    getcantMaxClausulas  (){ return this.cantMaxClausulas; }        
    public LinkedList getAllCoberturas () {return lCoberturas;}
    public int    getcodPlan           (){ return this.codPlan; }
    public String getdescPlan          (){ return this.descPlan;}        
    public int  getNumCertificado  ()            { return this.numCertificado;}
    public int getcodOpcion              () { return this.codOpcion;}
    public double getporcOpcionAjuste    () { return this.porcOpcionAjuste;}    
    public String getcodSeguridadTarjeta (){ return this.codSeguridadTarjeta;}    
    public String getdirTitularTarjeta   (){ return this.dirTitularTarjeta;}
    public int getcodProducto            () { return this.codProducto;}
    public String gettipoNomina   (){ return this.tipoNomina;}
    public String getnivelCob     (){ return this.nivelCob;}
    public int getpolizaGrupo     () { return this.polizaGrupo;}
    public String getdescProducto (){ return this.descProducto;}
    public int getcodAmbito       () { return this.codAmbito;}
    public String getempleador    (){ return this.empleador;}
    public int getpolizaAnterior  () { return this.polizaAnterior;}
    public int getcantDias        () { return this.cantDias;}
    public String getcategoriaPersona () { return this.categoriaPersona; }    
    public int gettipoEndoso      (){ return this.tipoEndoso;}    
    public String getdescTipoEndoso(){ return this.descTipoEndoso;}
    public int getnumEndoso       (){ return this.numEndoso;}    
    public int getsubSeccion      (){ return this.subSeccion;}    
    public double getporcComisionOrg(){ return this.porcComisionOrg;}    
    public String getbaseCalculoComisiones(){ return this.baseCalculoComision;}    
    public int getnumPropuestaSec (){ return this.numPropuestaSec;}    
    
    /*SET*/
    public void setNumCertificado  ( int param ) {  this.numCertificado= param ; }
    public void setCodProceso     ( int    param ) {  this.codProceso = param ;}
    public void setBoca           ( String param ) {  this.boca= param ;}
    public void setNumPropuesta   ( int param ) {  this.numPropuesta= param ;}
    public void setCodRama        ( int param ) {  this.codRama= param ;}
    public void setCodSubRama     ( int param ) {  this.codSubRama= param ;}
    public void setNumPoliza      ( int param ) {  this.numPoliza= param ;}
    public void setCodCobFinal    ( int param ) {  this.codCobFinal= param ; }
    public void setCodMoneda      ( int param ) {  this.codMoneda= param ; }
    public void setImpPremio      ( double param  ) {  this.impPremio= param ; }
    public void setCodFormaPago   ( int param ) {  this.codFormaPago= param ; }
    public void setImpCuota       ( double param ) {  this.impCuota= param ; }
    public void setCodProd        ( int param) {   this.codProd= param ; }    
    public void setPeriodoFact    ( int param ) {  this.periodoFact= param ; }
    public void setCantCuotas     ( int param ) {  this.cantCuotas= param ; }
    public void setFechaIniVigPol ( Date param) {  this.fechaIniVigPol= param ; }
    public void setFechaFinVigPol ( Date param ) { this.fechaFinVigPol= param ; } 
    public void setCodVigencia    ( int param ) {  this.codVigencia= param ; }
    public void setFechaAlta      ( Date param ) { this.fechaAlta= param ; }  
    public void setCantVidas      ( int param ) {  this.cantVidas= param ; }
    public void setCantVidasAltas ( int param ) {  this.cantVidasAltas = param ; }
    public void setCantVidasBajas ( int param ) {  this.cantVidasBajas = param ; }
    
    public void setCodEstado      ( int param ) {  this.codEstado= param ; }
    public void setObservaciones  ( String param ) {  this.observaciones= param ; } 
    public void setNumSecuCot     ( int param ) {     this.numSecuCot= param ; }
    public void setFechaTrabajo   ( Date param) {     this.fechaTrabajo= param ;  }
    public void setHoraTrabajo    ( String param) {     this.horaTrabajo= param ;  }
    public void setUserid         ( String param ) {  this.userid= param ;  }
    public void setFechaEnvioProd ( Date param ) { this.fechaEnvioProd= param ; }
    public void setFechaEnvioBenef( Date param ) { this.fechaEnvioBenef= param ;  }
    public void setFechaRespBenef ( Date param) {  this.fechaRespBenef= param ; } 
    public void setFechaEmision   ( Date param ) { this.fechaEmision= param ; }
    public void setFechaAnulacion ( Date param ) { this.fechaAnulacion= param ; }
    public void setHoraEnvioProd  ( String param) {  this.horaEnvioProd= param ; }
    public void setHoraEnvioBenef ( String param) {  this.horaEnvioBenef= param ; }
    public void setHoraRespBenef  ( String param) {  this.horaRespBenef= param ; }
    public void setTipoPropuesta  ( String param) {  this.tipoPropuesta= param ; }        
    public void setCodActividad   ( int  param  ){ this.codActividad=param; }
    public void setdescProd       (String param) { this.descProd                 = param; }
    public void setdescEstado     (String param) { this.descEstado               = param; }
    public void setdescActividad  (String param) { this.descActividad            = param; }
    public void setdescVigencia   (String param) { this.descVigencia             = param; }
    public void setdescFormaPago  (String param) { this.descFormaPago            = param; }    
    public void setCodError            ( int  param  ){ this.codError            = param; }
    public void setDescError           (String param) { this.descError           = param; }
    public void setdescMcaEnviarPoliza (String param) { this.descMcaEnviarPoliza = param; }
    
    //Datos del tomador
    public void setNumTomador       ( int param )   {  this.numTomador= param ; }    
    public void setTomadorTipoDoc ( String param ){ this.tomadorTipoDoc= param ; }    
    public void setTomadorDescTipoDoc ( String param ){ this.tomadorDescTipoDoc= param ; }    
    public void setTomadorNumDoc  ( String param ){ this.tomadorNumDoc= param ; }    
    public void setTomadorRazon   ( String param ){ this.tomadorRazon= param ; }    
    public void setTomadorCuit    ( String param ){ this.tomadorCuit= param ; }    
    public void setTomadorCondIva ( int param )   { this.tomadorCondIva= param ; }    
    public void setTomadorDescCondIva (String param )   { this.tomadorDescCondIva= param ; }    
    public void setTomadorDom     ( String param ){ this.tomadorDom= param ; }    
    public void setTomadorLoc     ( String param ){ this.tomadorLoc= param ; }    
    public void setTomadorCP      ( String param ){ this.tomadorCP= param ; }    
    public void setTomadorCodProv ( String param ){ this.tomadorCodProv= param ; }    
    public void setTomadorDescProv ( String param ){ this.tomadorDescProv= param ; }    
    public void setTomadorEmail   ( String param ){ this.tomadorEmail= param ; }    
    public void setTomadorTE      ( String param ){ this.tomadorTE= param ; }    
    public void setTomadorNom     ( String param ){ this.tomadorNom = param ; }    
    public void setTomadorApe     ( String param ){ this.tomadorApe = param ; }    
    public void setTomadorCargo   ( String param ){ this.tomadorCargo    = param ; }
    public void setTomadorCodLocalidad ( int param )   { this.tomadorCodLocalidad= param ; }    

    //cobertura
    public void setCapitalMuerte     (double param){ this.capitalMuerte= param ; }    
    public void setCapitalAsistencia (double param){ this.capitalAsistencia= param ; }    
    public void setCapitalInvalidez  (double param){ this.capitalInvalidez= param ; }    
    public void setFranquicia        (double param){ this.franquicia= param ; }    
    public void setImpPrimaTar       (double param){ this.impPrimaTar= param ; }    
    
    public void setgastosAdquisicion (double param) { this.gastosAdquisicion  = param; }    
    public void setderEmi      (double param) { this.derEmi  = param; }
    public void setgda         (double param) { this.gda  = param; }
    public void setsubTotal    (double param) { this.subTotal  = param; }
    public void setporcIva     (double param) { this.porcIva  = param; }
    public void setiva         (double param) { this.iva  = param; }
    public void setporcSsn     (double param) { this.porcSsn  = param; }
    public void setssn         (double param) { this.ssn  = param; }
    public void setporcSoc     (double param) { this.porcSoc  = param; }
    public void setsoc         (double param) { this.soc  = param; }
    public void setporcSellado (double param) { this.porcSellado  = param; }
    public void setsellado     (double param) { this.sellado  = param; }
    public void setprimaPura   (double param) { this.primaPura  = param; }
    public void setrecAdmin    (double param) { this.recAdmin = param; }    
    public void setrecFinan    (double param) { this.recFinan = param; }        
    public void setporcRecAdmin    (double param) { this.porcRecAdmin = param; }    
    public void setporcRecFinan    (double param) { this.porcRecFinan = param; }        
    public void setporcGDA         (double param) { this.porcGDA = param; }        
    public void setimpAjusteTarifa  (double param) { this.impAjusteTarifa  = param; }        
    public void setporcAjusteTarifa (double param) { this.porcAjusteTarifa = param; }        
    public void setnivelAjusteTarifa (String param) { this.nivelAjusteTarifa  = param; }
    public void setcodSeguridadTarjeta (String param) { this.codSeguridadTarjeta  = param; }
    public void setdirTitularTarjeta   (String param) { this.dirTitularTarjeta    = param; }
        
    // Forma de Pago    
    public void setCodTarjCred   (int    param){ this.codTarjCred= param ; }        
    public void setDescTarjCred  (String param){ this.descTarjCred= param ; }        
    public void setNumTarjCred   (String param){ this.numTarjCred= param ; }        
    public void setVencTarjCred  (Date   param){ this.vencTarjCred      = param ; }        
    public void setCodBanco      (int param){ this.codBanco             = param ; }        
    public void setDescBanco     (String param){ this.descBanco         = param ; }        
    public void setSucBanco      (String param){ this.sucBanco          = param ; }        
    public void setTitular       (String param){ this.titular           = param ; }        
    public void setCbu           (String param){ this.cbu               = param ; }        
    public void setmcaEnvioPoliza(String param){ this.mcaEnvioPoliza    = param ; }            
    public void setDescAmbito    ( String param ){ this.descAmbito      = param ; }    
    public void setDescRama      ( String param ){ this.descRama        = param ; }        
     public void setDescSubRama      ( String param ){ this.descSubRama        = param ; }           
    public void setCodFacturacion  (int    param){ this.codFacturacion = param ; }        
    public void setDescFacturacion (String param){ this.descFacturacion = param ; }        
    public void setoUbicacionRiesgo (UbicacionRiesgo param ) { this.oRiesgo = param; }
    
    public void setclaNoRepeticion ( String param){ claNoRepeticion = param; }
    public void setclaSubrogacion  ( String param){ claSubrogacion = param; }
    public void setbenefHerederos  ( String param){ benefHerederos = param; }
    public void setbenefTomador    ( String param){ benefTomador = param; }
    public void setlimMaxAcontecimiento (double param){ limMaxAcontecimiento  = param; }
    public void setcodActividadSec (int param ){ codActividadSec  = param; }
    public void setcantMaxClausulas ( int param ) {  this.cantMaxClausulas = param ; }
    public void setAllClausulas (LinkedList param) {this.lClausulas  = param;}    
    public void setAllCoberturas (LinkedList param) {this.lCoberturas = param;}    
    public void setcodPlan       (int param ){ codPlan                = param; }
    public void setdescPlan      (String param){ this.descPlan = param ; }        
    public void setcodOpcion         (int param) { this.codOpcion             = param; }
    public void setporcOpcionAjuste  (double param) { this.porcOpcionAjuste   = param; }
    public void setcodProducto       (int param) { this.codProducto   = param; }
    public void settipoNomina        (String param){ this.tipoNomina = param ; }
    public void setnivelCob          (String param){ this.nivelCob = param ; }
    public void setpolizaGrupo       (int param) { this.polizaGrupo= param; }
    public void setdescProducto      (String param){ this.descProducto = param ; }
    public void setcodAmbito         (int param) { this.codAmbito = param; }
    public void setempleador         (String param){ this.empleador = param ; }
    public void setnumReferencia     (int    param){ this.numReferencia = param ; }
    public void setpolizaAnterior    (int    param){ this.polizaAnterior = param ; }
    public void setcantDias          (int    param){ this.cantDias = param ; }        
    public void setcategoriaPersona  (String param){ this.categoriaPersona = param; }    
    public void settipoEndoso        (int    param){ this.tipoEndoso = param ; }        
    public void setdescTipoEndoso    (String param){ this.descTipoEndoso = param; }
    public void setnumEndoso         (int    param){ this.numEndoso = param ; }        
    public void setsubSeccion        (int    param){ this.subSeccion = param;}    
    public void setporcComisionOrg   (double param){ this.porcComisionOrg = param;}    
    public void setbaseCalculoComisiones(String param){ this.baseCalculoComision = param;}    
    public void setnumPropuestaSec   (int    param){ this.numPropuestaSec   = param;}    
             
    public Propuesta setDB(Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {       
           dbCon.setAutoCommit(true);
           
           if (this.getcodPlan() == -1) this.setcodPlan(0);
           
           cons = dbCon.prepareCall(db.getSettingCall( "PRO_SET_PROPUESTA (?, ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, ?,?, ?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getcodOpcion());
           cons.setString           (3, this.getBoca());
           cons.setInt              (4, this.getCodRama());
           cons.setInt              (5, this.getNumPropuesta());           
           cons.setInt              (6, this.getCodSubRama());
           cons.setInt              (7, this.getNumPoliza());
           cons.setDouble           (8, this.getgastosAdquisicion()); // EX COD COB FINAL
           cons.setInt              (9, this.getCodMoneda());
           cons.setDouble           (10, this.getImpPremio());
           cons.setInt              (11, this.getCodFormaPago());
           cons.setDouble           (12, this.getImpCuota());
           cons.setInt              (13, this.getCodProd());
           cons.setInt              (14, this.getNumTomador());
           cons.setInt              (15, this.getPeriodoFact());
           cons.setInt              (16, this.getCantCuotas());
           if (this.getFechaIniVigPol() == null) {  
               cons.setNull(17, java.sql.Types.DATE);
           } else {      
               cons.setDate(17, Fecha.convertFecha(this.getFechaIniVigPol()));     
           }
           if (this.getFechaFinVigPol() == null) {  
               cons.setNull(18, java.sql.Types.DATE);
           } else {      
               cons.setDate(18, Fecha.convertFecha(this.getFechaFinVigPol()));     
           }
           cons.setInt              (19, this.getCodVigencia());
           cons.setInt              (20, this.getCantVidas());
           cons.setInt              (21, this.getCodEstado());
           cons.setString           (22, this.getObservaciones());
           cons.setInt              (23, this.getNumSecuCot());
           cons.setString           (24, this.getUserid());           
           cons.setInt              (25, this.getCodActividad());
           cons.setString           (26, this.getMcaEnvioPoliza());
           cons.setInt              (27, this.getCodFacturacion());
           cons.setString           (28, this.getclaNoRepeticion());
           cons.setString           (29, this.getclaSubrogacion());
           cons.setString           (30, this.getbenefHerederos());
           cons.setString           (31, this.getbenefTomador());
           cons.setInt              (32, this.getcodPlan());
           cons.setInt              (33, this.getcodProducto());
           cons.setInt              (34, this.getpolizaGrupo());
           cons.setString           (35, this.getempleador());
           cons.setInt              (36, this.getnumReferencia());
           cons.setString           (37, this.getTipoPropuesta());
           cons.setInt              (38, this.getcantDias());
           
           cons.execute();
           this.setNumPropuesta(cons.getInt (1));                        
                       
        }  catch (SQLException se) {
            this.setCodError(-1);
            this.setDescError(se.getMessage());
        } catch (Exception e) {
            this.setCodError(-1);
            this.setDescError(e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }   
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    }         

    public Propuesta setDBCalcularPremio (Connection dbCon, String userid)  throws SurException {
        CallableStatement cons = null;
        try {
           cons = dbCon.prepareCall(db.getSettingCall( "PRO_SET_PREMIO_PROPUESTA ( ?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getNumPropuesta());
           cons.setInt              (3, 0); // num_cotizacion = 0
           cons.setString           (4, "P"); // calculo de propuesta
           cons.setString           (5, userid);

           cons.execute();

        }  catch (SQLException se) {
            throw new SurException("Error SQL en Propuesta [setDBCalcularPremio]: " + se.getMessage());
        } catch (Exception e) {
            throw new SurException("Error Java en Propuesta [setDBCalcularPremio]: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    }
    
    public Propuesta getDBVerificarPoliza (Connection dbCon, String userid)  throws SurException {
        CallableStatement cons = null;
        try {       
            
           dbCon.setAutoCommit(false);

           cons = dbCon.prepareCall(db.getSettingCall( "END_VERIFICAR_POLIZA ( ?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getCodRama());
           cons.setInt              (3, this.getNumPoliza());
           cons.setString           (4, userid);           

           cons.execute();

           this.setCodError( cons.getInt (1));                        
                       
        }  catch (SQLException se) {
            throw new SurException("Error SQL en Propuesta [getDBVerificarPoliza]: " + se.getMessage());
        } catch (Exception e) {
            throw new SurException("Error Java en Propuesta [getDBVerificarPoliza]: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    }         

    public Propuesta setDBEndosar(Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {       
           dbCon.setAutoCommit(true);
           
           cons = dbCon.prepareCall(db.getSettingCall( "END_SET_ENDOSAR (?,?,?,?,?,?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getCodRama());
           cons.setInt              (3, this.getNumPropuesta());           
           cons.setInt              (4, this.getNumPoliza());
           if (this.getFechaIniVigPol() == null) {  
               cons.setNull(5, java.sql.Types.DATE);
           } else {      
               cons.setDate(5, Fecha.convertFecha(this.getFechaIniVigPol()));     
           }
           cons.setInt              (6, this.getCantVidas()); 
           cons.setInt              (7, this.getCodEstado());
           cons.setString           (8, this.getObservaciones());
           cons.setString           (9, this.getUserid());           
           cons.setString           (10, this.getMcaEnvioPoliza());
           
           cons.execute();           
           this.setNumPropuesta(cons.getInt (1));                        
                       
        }  catch (SQLException se) {
            throw new SurException("Error SQL en Propuesta [setDBEndosar]: " + se.getMessage());
        } catch (Exception e) {
            throw new SurException("Error Java en Propuesta [setDBEndosar]: " + e.getMessage());
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
     *  setDBEstado
     */    
    public Propuesta setDBEstado(Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {       
            
           dbCon.setAutoCommit(true);
           
//           cons = dbCon.prepareCall(db.getSettingCall( "PRO_SET_ESTADO_PROPUESTA( ?,?  ,?)"));
           cons = dbCon.prepareCall(db.getSettingCall( "PRO_SET_ENVIAR_PROPUESTA( ?,?  ,?)"));           
           cons.registerOutParameter( 1, java.sql.Types.INTEGER);           
           cons.setInt              ( 2, this.getNumPropuesta());           
           cons.setInt              ( 3, this.getCodEstado());              
           cons.setString           ( 4, this.getUserid());                         
           
           cons.execute();
           
           if (cons.getInt (1) < 0) 
                this.setCodError(cons.getInt (1));
            else 
                this.setCodEstado(cons.getInt (1));                        
                       
        }  catch (SQLException se) {
            this.setCodError(-1);
            this.setDescError (se.getMessage());
            throw new SurException("Error SQL al modificar el estado : " + se.getMessage());
        } catch (Exception e) {
            this.setCodError(-1);
            this.setDescError (e.getMessage());
            throw new SurException ("Error Java: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    }             

    public Propuesta setDBRetornoDC (Connection dbCon, String sDescError, String sFechaAlta)  throws SurException {
        CallableStatement cons = null;
        try {

           dbCon.setAutoCommit(true);

           cons = dbCon.prepareCall(db.getSettingCall( "INT_PRO_VUELTA_PROPUESTA(?,?,?,?,?)"));
           cons.registerOutParameter( 1, java.sql.Types.INTEGER);
           cons.setInt              ( 2, this.getNumPropuesta());
           cons.setInt              ( 3, this.getCodEstado());
           cons.setInt              ( 4, this.getCodError());
           cons.setString           ( 5, sDescError );
           cons.setString           ( 6, sFechaAlta );
           
           cons.execute();

           if (cons.getInt (1) < 0) {
                this.setCodError (-1);
           }  else {
                this.setCodError (0);
                this.setNumPoliza(cons.getInt (1));
           }

        }  catch (SQLException se) {
            this.setCodError(-1);
            this.setDescError (se.getMessage());
        } catch (Exception e) {
            this.setCodError(-1);
            this.setDescError (e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    }

    public Propuesta setDBDelete(Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {

           dbCon.setAutoCommit(true);

           cons = dbCon.prepareCall(db.getSettingCall( "PRO_SET_ELIMINAR_PROPUESTA( ?,?)"));
           cons.registerOutParameter( 1, java.sql.Types.INTEGER);
           cons.setInt              ( 2, this.getNumPropuesta());
           cons.setString           ( 3, this.getUserid());

           cons.execute();

        }  catch (SQLException se) {
            this.setCodError(-1);
            this.setDescError (se.getMessage());
        } catch (Exception e) {
            this.setCodError(-1);
            this.setDescError (e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    }

    public Propuesta setDBEstadoCaucion (Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {

           dbCon.setAutoCommit(true);

           cons = dbCon.prepareCall(db.getSettingCall( "PRO_SET_ESTADO_CAUCION( ?, ?, ?, ?)"));
           cons.registerOutParameter( 1, java.sql.Types.INTEGER);
           cons.setInt              ( 2, this.getNumPropuesta());
           cons.setInt              ( 3, this.getNumPoliza());
           cons.setInt              ( 4, this.getCodEstado());
           cons.setString           ( 5, this.getUserid());

           cons.execute();

           if (cons.getInt (1) < 0)
                this.setCodError(cons.getInt (1));
            else
                this.setNumPropuesta(cons.getInt (1));

        }  catch (SQLException se) {
            this.setCodError(-1);
            this.setDescError (se.getMessage());
            throw new SurException("Error SQL al modificar el estado : " + se.getMessage());
        } catch (Exception e) {
            this.setCodError(-1);
            this.setDescError (e.getMessage());
            throw new SurException ("Error Java: " + e.getMessage());
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
     * Set forma pago Tarjeta Credito
     */
    
    /*
     *  setDBEstado
     */    
    public Propuesta setDBTarjetaCredito(Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {       
            
           dbCon.setAutoCommit(true);
           
           cons = dbCon.prepareCall(db.getSettingCall( "PRO_SET_FORMA_PAGO_TARJETA( ?,?,?,?,?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);           
           cons.setInt              (2, this.getNumPropuesta());           
           cons.setInt              (3, this.getCodTarjCred());
           cons.setInt              (4, this.getCodBanco() );
           cons.setString           (5, this.getNumTarjCred());                      
           if (this.getVencTarjCred() == null) {  
               cons.setNull(6, java.sql.Types.DATE);
           } else {      
               cons.setDate(6, Fecha.convertFecha(this.getVencTarjCred()));     
           }           
           cons.setString           (7, this.getTitular());
           cons.setString           (8, this.getcodSeguridadTarjeta());
           cons.setString           (9, this.getdirTitularTarjeta());
           
           cons.execute();
           this.setNumPropuesta(cons.getInt (1));                        
                       
        }  catch (SQLException se) {
            throw new SurException("Error SQL al modificar el forma pago tarjeta : " + se.getMessage());
        } catch (Exception e) {
            throw new SurException("Error Java: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    }
    public Propuesta setDBBancoConvenio (Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {

           dbCon.setAutoCommit(true);

           cons = dbCon.prepareCall(db.getSettingCall( "PRO_SET_FORMA_BANCO_CONVENIO(?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getNumPropuesta());
           cons.setInt              (3, this.getCodBanco() );
           cons.setString           (4, this.getCbu());
           cons.setString           (5, this.getTitular());

           cons.execute();
           this.setNumPropuesta(cons.getInt (1));

        }  catch (SQLException se) {
            throw new SurException("Error SQL al modificar el forma pago Convenio : " + se.getMessage());
        } catch (Exception e) {
            throw new SurException("Error Java: " + e.getMessage());
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
     * Setear Forma Pago Debito Cuenta
     */
    public Propuesta setDBTarjetaDebitoCuenta(Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {       
            
           dbCon.setAutoCommit(true);
           
           cons = dbCon.prepareCall(db.getSettingCall( "PRO_SET_FORMA_PAGO_DEBITO_CUENTA( ?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);           
           cons.setInt              (2, this.getNumPropuesta());           
           cons.setString           (3, this.getCbu());
           cons.setString           (4, this.getTitular());
           
           cons.execute();
           this.setNumPropuesta(cons.getInt (1));                        
                       
        }  catch (SQLException se) {
            throw new SurException("Error SQL al modificar el forma pago debito cuenta : " + se.getMessage());
        } catch (Exception e) {
            throw new SurException("Error Java: " + e.getMessage());
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
     * Setear Forma Pago Reset - Blanque alos campos de forma de pagos.
     */
    public Propuesta setDBFormaPagoReset(Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {       
            
           dbCon.setAutoCommit(true);
           
           cons = dbCon.prepareCall(db.getSettingCall( "PRO_SET_FORMA_PAGO_RESET( ?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);           
           cons.setInt              (2, this.getNumPropuesta());                      
           
           cons.execute();
           this.setNumPropuesta(cons.getInt (1));                        
                       
        }  catch (SQLException se) {
            throw new SurException("Error SQL al modificar el forma pago debito cuenta : " + se.getMessage());
        } catch (Exception e) {
            throw new SurException("Error Java: " + e.getMessage());
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
     * getDBNominasPropuesta
     */
    public LinkedList getDBNominasPropuesta ( Connection dbCon) 
    throws SurException {
        LinkedList lNom = new LinkedList ();
        CallableStatement cons = null;        
        ResultSet rs = null;
        try {        
            dbCon.setAutoCommit(false);
            
            cons = dbCon.prepareCall(db.getSettingCall("PRO_GET_NOMINAS_PROPUESTA (?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt    (2, this.getCodProceso());
            cons.setString (3, this.getBoca());
            cons.setInt    (4, this.getNumPropuesta());
            cons.setInt    (5, this.getCodRama());            
            cons.execute(); 
            rs = (ResultSet) cons.getObject(1);

            if (rs != null) {
                while (rs.next()) {
                    AseguradoPropuesta oAseg= new AseguradoPropuesta ();
                    oAseg.setNumPropuesta(this.getNumPropuesta());
                    oAseg.setNumDoc      (rs.getString ("NUM_DOC"));
                    oAseg.setTipoDoc     (rs.getString ("TIPO_DOC")); 
                    oAseg.setNombre      (rs.getString ("NOMBRE"));                     
                    oAseg.setDescTipoDoc (rs.getString ("DESC_TIPO_DOC"));                     
                    oAseg.setOrden       (rs.getInt    ("ORDEN"));
                    oAseg.setFechaNac    (rs.getDate("FECHA_NAC"));   
                    oAseg.setFechaAltaCob(rs.getDate ("FECHA_ALTA_COB"));
                    oAseg.setFechaBaja   (rs.getDate("FECHA_BAJA"));
                    oAseg.setEstado      (rs.getString ("ESTADO"));
                    oAseg.setmano        (rs.getString ("MANO"));
                    oAseg.setparentesco  (rs.getInt ("PARENTESCO"));
                    oAseg.setCertificado (rs.getInt ("CERTIFICADO"));
                    oAseg.setSubCertificado(rs.getInt ("SUB_CERTIFICADO"));
                    oAseg.setSumaAseg    (rs.getDouble("SUMA_ASEG"));
                    oAseg.setcodAgrupCob (rs.getInt("COD_AGRUP_COB"));
                    oAseg.setdescParentesco(rs.getString ("DESC_PARENTESCO"));
                    oAseg.setcodCobOpcion(rs.getInt("COD_COB_OPCION"));
                    oAseg.setimpPremio   (rs.getDouble("IMP_PREMIO"));
                    oAseg.setsMcaDiscapacitado(rs.getString ("MCA_DISCAPACITADO"));

                    if ( (this.getTipoPropuesta().equals("P") || this.getTipoPropuesta().equals("R")) && 
                          oAseg.getSubCertificado() == 0 && 
                         this.getbenefHerederos() != null && this.getbenefHerederos().equals("N") &&
                         this.getbenefTomador() != null && this.getbenefTomador().equals("N")) { 

                        oAseg.getDBlBeneficiarios(dbCon);  
                        if (oAseg.getiNumError() < 0) {
                            throw new SurException("Error en Propuesta [getDBNominasPropuesta]: " + oAseg.getsMensError());
                        }
                    }
                    lNom.add (oAseg);
                }
                rs.close();            
            }      
            
            cons.close ();
        return lNom;
        
        }  catch (SQLException se) {
            this.setCodError(-1);
            this.setDescError(se.getMessage());
            throw new SurException("Error en Propuesta [getDBNominasPropuesta]: " + se.getMessage());
        } catch (Exception e) {
            this.setCodError(-1);
            this.setDescError(e.getMessage());
            throw new SurException("Error en Propuesta [getDBNominasPropuesta]: " + e.getMessage());
        } finally {
            try{
                if (rs != null) { rs.close(); }                
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
        }            
    }        

    public LinkedList getDBPrintNomina ( Connection dbCon, int producto)
    throws SurException {
        LinkedList lNom = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs = null;
        try {
            dbCon.setAutoCommit(false);

            cons = dbCon.prepareCall(db.getSettingCall("PRO_GET_NOMINAS_PROPUESTA (?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt    (2, this.getCodProceso());
            cons.setString (3, this.getBoca());
            cons.setInt    (4, this.getNumPropuesta());
            cons.setInt    (5, this.getCodRama());
            cons.execute();
            rs = (ResultSet) cons.getObject(1);

            if (rs != null) {
                while (rs.next()) {
                    AseguradoPropuesta oAseg= new AseguradoPropuesta ();
                    oAseg.setNumDoc      (rs.getString ("NUM_DOC"));
                    oAseg.setTipoDoc     (rs.getString ("TIPO_DOC"));
                    oAseg.setNombre      (rs.getString ("NOMBRE"));
                    oAseg.setDescTipoDoc (rs.getString ("DESC_TIPO_DOC"));
                    oAseg.setOrden       (rs.getInt    ("ORDEN"));
                    oAseg.setFechaNac    (rs.getDate("FECHA_NAC"));
                    oAseg.setFechaAltaCob(rs.getDate ("FECHA_ALTA_COB"));
                    oAseg.setFechaBaja   (rs.getDate("FECHA_BAJA"));
                    oAseg.setEstado      (rs.getString ("ESTADO"));
                    oAseg.setmano        (rs.getString ("MANO"));
                    oAseg.setparentesco  (rs.getInt ("PARENTESCO"));
                    oAseg.setCertificado (rs.getInt ("CERTIFICADO"));
                    oAseg.setSubCertificado(rs.getInt ("SUB_CERTIFICADO"));
                    oAseg.setSumaAseg    (rs.getDouble("SUMA_ASEG"));
                    oAseg.setcodAgrupCob (rs.getInt("COD_AGRUP_COB"));
                    oAseg.setdescParentesco(rs.getString ("DESC_PARENTESCO"));
                    oAseg.setcodCobOpcion(rs.getInt("COD_COB_OPCION"));
                    oAseg.setimpPremio   (rs.getDouble("IMP_PREMIO"));
                    oAseg.setNumPropuesta(this.getNumPropuesta());
                    oAseg.setsMcaDiscapacitado(rs.getString ("MCA_DISCAPACITADO"));

                    oAseg.setDBlCoberturas(dbCon, producto);
                    if (oAseg.getiNumError() < 0) {
                        throw new SurException(oAseg.getsMensError());
                    }
                    lNom.add (oAseg);
                }
                rs.close();
            }

        }  catch (SQLException se) {
            throw new SurException("Error SQL al obtener lista de nomina a la propuesta: " + se.getMessage());
        } catch (Exception e) {
            throw new SurException("Error Java: " + e.getMessage());
        } finally {
            try{
                if (rs != null) { rs.close(); }
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return lNom;
        }
    }

    public LinkedList getDBEmpresasClausulas ( Connection dbCon) 
    throws SurException {
        LinkedList lNom = new LinkedList ();
        CallableStatement cons = null;        
        ResultSet rs = null;
        try {        
            dbCon.setAutoCommit(false);
            
            cons = dbCon.prepareCall(db.getSettingCall("PRO_GET_ALL_CLAUSULAS (?, ?, ?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt    (2, this.getCodProceso());
            cons.setString (3, this.getBoca());
            cons.setInt    (4, this.getNumPropuesta());
            cons.setInt    (5, this.getCodRama());            
            cons.execute(); 
            rs = (ResultSet) cons.getObject(1);

            if (rs != null) {
                while (rs.next()) {
                    Clausula oCla = new Clausula ();                    
                    oCla.setdescEmpresa  (rs.getString ("DESCRIPCION")); 
                    oCla.setcuitEmpresa  (rs.getString ("CUIT"));
                    
                    lNom.add (oCla);
                }
                rs.close();            
            }            
            
        }  catch (SQLException se) {
            throw new SurException("Error SQL al obtener clausulas [getDBEmpresasClausulas]: " + se.getMessage());
        } catch (Exception e) {
            throw new SurException("Error Java: " + e.getMessage());
        } finally {
            try{
                if (rs != null) { rs.close(); }                
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return lNom;
        }            
    }        

    public Propuesta getDB ( Connection dbCon) throws SurException {
        CallableStatement cons = null;        
        ResultSet rs = null;
        boolean bExiste = false;
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PRO_GET_PROPUESTA (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getNumPropuesta());
            cons.execute();    

            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                if (rs.next()) {
                    bExiste = true;
                    this.setCodProceso      (rs.getInt ("COD_PROCESO")); 
                    this.setBoca            (rs.getString ("BOCA" ));
                    this.setCodRama         (rs.getInt ("COD_RAMA"));
                    this.setCodSubRama      (rs.getInt ("COD_SUB_RAMA"));
                    this.setNumPoliza       (rs.getInt ("NUM_POLIZA"));
                    this.setNumPropuesta    (rs.getInt("NUM_PROPUESTA"));
                    this.setCodProd         (rs.getInt("COD_PROD"));                    
                    this.setdescProd        (rs.getString("DESC_PROD"));                                
                    this.setCodVigencia     (rs.getInt("COD_VIGENCIA"));                    
                    this.setCodActividad    (rs.getInt("COD_ACTIVIDAD"));                    
                    this.setNumTomador      (rs.getInt("NUM_TOMADOR"));
                    this.setTomadorTipoDoc  (rs.getString("TIPO_DOC"));
                    this.setTomadorDescTipoDoc  (rs.getString("DESC_TIPO_DOC"));
                    this.setTomadorNumDoc   (rs.getString("NUM_DOC"));
                    this.setTomadorRazon    (rs.getString("RAZON_SOCIAL"));
                    this.setTomadorNom      (rs.getString("NOMBRE"));
                    this.setTomadorApe      (rs.getString("APELLIDO"));
                    this.setTomadorCondIva  (rs.getInt("COD_CONDICION_IVA"));
                    this.setTomadorDom     (rs.getString("DOMICILIO"));
                    this.setTomadorLoc     (rs.getString("LOCALIDAD"));
                    this.setTomadorCP      (rs.getString("COD_POSTAL"));
                    this.setTomadorCodProv (rs.getString("PROVINCIA"));                                        
                    this.setTomadorDescProv (rs.getString("DESC_PROVINCIA"));                                        
                    this.setTomadorEmail   (rs.getString("EMAIL"));
                    this.setTomadorTE      (rs.getString("TELEFONO"));
                    this.setTomadorCargo   (rs.getString ("CARGO"));
                    this.setCodEstado      (rs.getInt("COD_ESTADO"));
                    this.setNumSecuCot     (rs.getInt("NUM_SECU_COT"));
                    this.setCantCuotas     (rs.getInt("CANT_CUOTAS"));
                    
                    this.setFechaIniVigPol(null);
                    if (rs.getDate("FECHA_INI_VIG_POL" ) != null) {                      
                         this.setFechaIniVigPol ( Fecha.convertFecha(rs.getDate("FECHA_INI_VIG_POL" )));
                    }     
                    this.setFechaFinVigPol (null);
                    if (rs.getDate("FECHA_FIN_VIG_POL" ) != null) {                      
                        this.setFechaFinVigPol ( Fecha.convertFecha(rs.getDate("FECHA_FIN_VIG_POL" )));
                    }
                    this.setCapitalMuerte     (rs.getDouble("CAP_MUERTE"));
                    this.setCapitalInvalidez  (rs.getDouble("CAP_INVALIDEZ"));
                    this.setCapitalAsistencia (rs.getDouble("CAP_ASISTENCIA"));
                    this.setFranquicia    (rs.getDouble("FRANQUICIA"));
                    this.setImpPremio     (rs.getDouble("IMP_PREMIO"));
                    this.setImpPrimaTar   (rs.getDouble("PRIMA_TAR"));                    

                    this.setderEmi      (rs.getDouble("DER_EMI"));
                    this.setgda         (rs.getDouble("GDA"));
                    this.setsubTotal    (rs.getDouble("SUBTOTAL"));
                    this.setporcIva     (rs.getDouble("PORC_IVA"));
                    this.setiva         (rs.getDouble("IVA"));
                    this.setporcSsn     (rs.getDouble("PORC_SSN"));
                    this.setssn         (rs.getDouble("SSN"));
                    this.setporcSoc     (rs.getDouble("PORC_SOC"));
                    this.setsoc         (rs.getDouble("SOC"));
                    this.setporcSellado (rs.getDouble("PORC_SELLADO"));
                    this.setsellado     (rs.getDouble("SELLADO"));
                    this.setprimaPura   (rs.getDouble("IMP_PRIMA_PURA"));
                    this.setrecAdmin    (rs.getDouble("REC_ADMIN"));
                    this.setrecFinan    (rs.getDouble("REC_FINAN"));
                    this.setporcRecAdmin(rs.getDouble("PORC_REC_ADMIN"));
                    this.setporcRecFinan(rs.getDouble("PORC_REC_FINAN"));
                    
                    this.setObservaciones (rs.getString("OBSERVACIONES"));                                                    
                    this.setCodFormaPago  (rs.getInt("COD_FORMA_PAGO"));      
                    this.setImpCuota      (rs.getDouble ("IMP_CUOTA"));
                    // this.setTitular();
                    this.setVencTarjCred(null);
                    if (rs.getDate("FECHA_VENC_TARJETA" )!=null) {
                        this.setVencTarjCred( Fecha.convertFecha(rs.getDate("FECHA_VENC_TARJETA" )));
                    }                        
                    this.setNumTarjCred     ( rs.getString("NUM_TARJETA"));                                                                        
                    this.setCodTarjCred     ( rs.getInt("COD_TARJETA"));                    
                    this.setCodBanco        ( rs.getInt("COD_BANCO"));                    
                    this.setCbu             ( rs.getString("CBU"));
                    this.setSucBanco        ( rs.getString("SUC_BANCO"));                    
                    this.setTitular         ( rs.getString("TITULAR"));
                    this.setcodSeguridadTarjeta (rs.getString ("COD_SEG_TARJETA"));
                    this.setdirTitularTarjeta   (rs.getString ("DIRECCION_TITULAR"));
                    this.setdescActividad   (rs.getString ("DESC_ACTIVIDAD"));
                    this.setdescVigencia    (rs.getString ("DESC_VIGENCIA"));
                    this.setNumSecuCot      (rs.getInt("NUM_SECU_COT"));
                    this.setFechaTrabajo    (rs.getDate("FECHA_TRABAJO"));
                    this.setHoraTrabajo     (rs.getString ("HORA_TRABAJO"));
                    this.setUserid          (rs.getString("USERID"));
                    this.setFechaEnvioProd  (rs.getDate("FECHA_ENVIO_PROD"));
                    this.setFechaEnvioBenef (rs.getDate("FECHA_ENVIO_BENEF"));
                    this.setFechaRespBenef  (rs.getDate("FECHA_RESP_BENEF"));
                    this.setFechaEmision    (rs.getDate("FECHA_EMISION"));
                    this.setFechaAnulacion  (rs.getDate("FECHA_ANULACION"));
                    this.setHoraEnvioProd   (rs.getString ("HORA_ENVIO_PROD"));
                    this.setHoraEnvioBenef  (rs.getString ("HORA_ENVIO_BENEF"));
                    this.setHoraRespBenef   (rs.getString ("HORA_RESP_BENEF"));
                    this.setdescFormaPago   (rs.getString ("DESC_FORMA_PAGO"));
                    this.setTomadorDescCondIva(rs.getString ("TOMADOR_DESC_IVA"));
                    this.setCantVidas       (rs.getInt ("CANT_VIDAS"));
                    this.setmcaEnvioPoliza  (rs.getString ("MCA_ENVIAR_POLIZA"));
                    this.setporcGDA         (rs.getDouble("GASTOS_ADQUISICION"));
                    this.setDescAmbito      (rs.getString ("DESC_AMBITO"));
                    this.setdescMcaEnviarPoliza(rs.getString ("DESC_ENVIAR_POLIZA"));
                    this.setDescBanco       (rs.getString ("DESC_BANCO"));
                    this.setDescTarjCred    (rs.getString ("DESC_TARJETA"));
                    this.setporcAjusteTarifa  (rs.getDouble ("PORC_AJUSTE_TARIFA"));
                    this.setimpAjusteTarifa  (rs.getDouble ("IMP_AJUSTE_TARIFA"));
                    this.setnivelAjusteTarifa (rs.getString ("NIVEL_AJUSTE_TARIFA"));
                    this.setDescRama            (rs.getString ("DESC_RAMA"));
                    this.setCodFacturacion      (rs.getInt ("COD_FACTURACION"));
                    this.setDescFacturacion     (rs.getString ("DESC_FACTURACION"));                    
                    this.setclaNoRepeticion (rs.getString ("CLA_NO_REPETICION"));
                    this.setclaSubrogacion  (rs.getString ("CLA_SUBROGACION"));
                    this.setbenefHerederos  (rs.getString ("BENEF_HEREDEROS"));
                    this.setbenefTomador    (rs.getString ("BENEF_TOMADOR"));
                    this.setlimMaxAcontecimiento (rs.getDouble ("LIM_MAX_ACONTECIMIENTO"));
                    this.setcodActividadSec (rs.getInt ("COD_ACTIVIDAD_SEC"));
                    this.setcantMaxClausulas(rs.getInt ("CANT_MAX_EMPRESAS"));
                    this.setcodPlan         (rs.getInt ("COD_PLAN"));
                    this.setDescSubRama     (rs.getString ("DESC_SUB_RAMA"));
                    this.setdescPlan        (rs.getString ("DESC_PLAN"));
                    this.setTipoPropuesta   (rs.getString ("TIPO_PROPUESTA"));
                    this.setcodOpcion       (rs.getInt ("COD_OPCION"));
                    this.setporcOpcionAjuste( Double.parseDouble( rs.getString("PORC_OPCION_AJUSTE")));
                    this.setcodProducto     (rs.getInt("COD_PRODUCTO"));
                    this.setnivelCob        (rs.getString ("NIVEL_COB"));
                    this.settipoNomina      (rs.getString ("TIPO_NOMINA"));
                    this.setdescProducto    (rs.getString ("DESC_PRODUCTO"));
                    this.setcodAmbito       (rs.getInt ("COD_AMBITO"));
                    this.setempleador       (rs.getString ("EMPLEADOR"));
                    this.setnumReferencia   (rs.getInt ("NUM_REFERENCIA"));
                    this.setcantDias        (rs.getInt ("CANT_DIAS"));
                    this.setcategoriaPersona(rs.getString ("CATEGORIA_PERSONA"));
                    this.setdescEstado      (rs.getString("DESC_ESTADO")); // DESCRIPCION ESTADO
                    this.setdescTipoEndoso  (rs.getString ("DESC_TIPO_ENDOSO"));
                    this.settipoEndoso      (rs.getInt ( "TIPO_ENDOSO"));
                    this.setnumEndoso       (rs.getInt ("NUM_ENDOSO"));
                    this.setsubSeccion      (rs.getInt ("SUB_SECCION"));
                    this.setporcComisionOrg (rs.getDouble ("PORC_COMISION_ORG"));
                    this.setbaseCalculoComisiones(rs.getString ("BASE_CALCULO_COMIS"));

                    lClausulas = new LinkedList ();

                    if (this.getCodRama() == 10 || this.getCodRama () == 22 ) {
                        UbicacionRiesgo oRiesgo = new UbicacionRiesgo ();
                        oRiesgo.setnumPropuesta(this.getNumPropuesta());
                        oRiesgo.getDBPropuesta (dbCon);
                        this.setoUbicacionRiesgo(oRiesgo);

                        if ( this.getCodRama () == 10 ) {
                            lClausulas = this.getDBEmpresasClausulas(dbCon);
                        }
                    }
                    
                    // agegado sup 01/11/2007
                    if (this.getnivelCob().equals("P")) {
                        this.lCoberturas =  this.getDBAllCoberturas(dbCon);
                    }
                }
                rs.close ();
            }

            if (! bExiste ) {
            this.setCodError(-1);
            this.setDescError("PROPUESTA INEXISTENTE");
            }
            cons.close ();
        }  catch (SQLException se) {
            this.setCodError(-1);
            this.setDescError(se.getMessage());
            throw new SurException("Error en Propuesta [getDB]: " + se.getMessage());
        } catch (Exception e) {
            this.setCodError(-1);
            this.setDescError(e.getMessage());
            throw new SurException("Error en Propuesta [getDB]: " + e.getMessage());
        } finally {
            try{
                if (rs != null) { rs.close(); }
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }            
    }        

    public Propuesta getDBxNumCotizacion ( Connection dbCon) throws SurException {
        CallableStatement cons = null;        
        ResultSet rs = null;
        try {        
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PRO_GET_PROPUESTA_COT (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getNumSecuCot());
            cons.execute();    

            rs = (ResultSet) cons.getObject(1);
            
            boolean bExiste = false;
            if (rs != null) {
                if (rs.next()) {
                    bExiste = true;
                    this.setCodProceso      (rs.getInt ("COD_PROCESO")); 
                    this.setBoca            (rs.getString ("BOCA" ));
                    this.setCodRama         (rs.getInt ("COD_RAMA"));
                    this.setCodSubRama      (rs.getInt ("COD_SUB_RAMA"));
                    this.setNumPoliza       (rs.getInt ("NUM_POLIZA"));
                    this.setNumPropuesta    (rs.getInt("NUM_PROPUESTA"));
                    this.setCodProd         (rs.getInt("COD_PROD"));                    
                    this.setdescProd        (rs.getString("DESC_PROD"));                                
                    this.setCodVigencia     (rs.getInt("COD_VIGENCIA"));                    
                    this.setCodActividad    (rs.getInt("COD_ACTIVIDAD"));                    
                    this.setNumTomador      (rs.getInt("NUM_TOMADOR"));
                    this.setTomadorTipoDoc  (rs.getString("TIPO_DOC"));
                    this.setTomadorDescTipoDoc  (rs.getString("DESC_TIPO_DOC"));
                    this.setTomadorNumDoc   (rs.getString("NUM_DOC"));
                    this.setTomadorRazon    (rs.getString("RAZON_SOCIAL"));
                    this.setTomadorNom      (rs.getString("NOMBRE"));
                    this.setTomadorApe      (rs.getString("APELLIDO"));
                    this.setTomadorCondIva  (rs.getInt("COD_CONDICION_IVA"));
                    
                    this.setTomadorDom     (rs.getString("DOMICILIO"));
                    this.setTomadorLoc     (rs.getString("LOCALIDAD"));
                    this.setTomadorCP      (rs.getString("COD_POSTAL"));
                    this.setTomadorCodProv (rs.getString("PROVINCIA"));                                        
                    this.setTomadorDescProv (rs.getString("DESC_PROVINCIA"));                                        
                    this.setTomadorEmail   (rs.getString("EMAIL"));
                    this.setTomadorTE      (rs.getString("TELEFONO"));                                
                    this.setCodEstado      (rs.getInt("COD_ESTADO"));
                    this.setNumSecuCot     (rs.getInt("NUM_SECU_COT"));
                    this.setCantCuotas     (rs.getInt("CANT_CUOTAS"));
                    
                    this.setFechaIniVigPol(null);
                    if (rs.getDate("FECHA_INI_VIG_POL" ) != null) {                      
                         this.setFechaIniVigPol ( Fecha.convertFecha(rs.getDate("FECHA_INI_VIG_POL" )));
                    }     
                    this.setFechaFinVigPol (null);
                    if (rs.getDate("FECHA_FIN_VIG_POL" ) != null) {                      
                        this.setFechaFinVigPol ( Fecha.convertFecha(rs.getDate("FECHA_FIN_VIG_POL" )));
                    }
                    this.setCapitalMuerte     (rs.getDouble("CAP_MUERTE"));
                    this.setCapitalInvalidez  (rs.getDouble("CAP_INVALIDEZ"));
                    this.setCapitalAsistencia (rs.getDouble("CAP_ASISTENCIA"));
                    this.setFranquicia    (rs.getDouble("FRANQUICIA"));
                    this.setImpPremio     (rs.getDouble("IMP_PREMIO"));
                    this.setImpPrimaTar   (rs.getDouble("PRIMA_TAR"));                    

                    this.setderEmi      (rs.getDouble("DER_EMI"));
                    this.setgda         (rs.getDouble("GDA"));
                    this.setsubTotal    (rs.getDouble("SUBTOTAL"));
                    this.setporcIva     (rs.getDouble("PORC_IVA"));
                    this.setiva         (rs.getDouble("IVA"));
                    this.setporcSsn     (rs.getDouble("PORC_SSN"));
                    this.setssn         (rs.getDouble("SSN"));
                    this.setporcSoc     (rs.getDouble("PORC_SOC"));
                    this.setsoc         (rs.getDouble("SOC"));
                    this.setporcSellado (rs.getDouble("PORC_SELLADO"));
                    this.setsellado     (rs.getDouble("SELLADO"));
                    this.setprimaPura   (rs.getDouble("IMP_PRIMA_PURA"));
                    this.setrecAdmin    (rs.getDouble("REC_ADMIN"));
                    this.setrecFinan    (rs.getDouble("REC_FINAN"));
                    this.setporcRecAdmin(rs.getDouble("PORC_REC_ADMIN"));
                    this.setporcRecFinan(rs.getDouble("PORC_REC_FINAN"));
                    
                    this.setObservaciones (rs.getString("OBSERVACIONES"));                                                    
                    this.setCodFormaPago  (rs.getInt("COD_FORMA_PAGO"));      
                    this.setImpCuota      (rs.getDouble ("IMP_CUOTA"));
                    // this.setTitular();
                    this.setVencTarjCred(null);
                    if (rs.getDate("FECHA_VENC_TARJETA" )!=null) {
                        this.setVencTarjCred( Fecha.convertFecha(rs.getDate("FECHA_VENC_TARJETA" )));
                    }                        
                    this.setNumTarjCred     ( rs.getString("NUM_TARJETA"));                                                                        
                    this.setCodTarjCred     ( rs.getInt("COD_TARJETA"));                    
                    this.setCodBanco        ( rs.getInt("COD_BANCO"));                    
                    this.setCbu             ( rs.getString("CBU"));                                                                        
                    this.setSucBanco        ( rs.getString("SUC_BANCO"));                    
                    this.setTitular         ( rs.getString("TITULAR"));  
                    this.setdescActividad   (rs.getString ("DESC_ACTIVIDAD"));
                    this.setdescVigencia    (rs.getString ("DESC_VIGENCIA"));
                    this.setNumSecuCot      (rs.getInt("NUM_SECU_COT"));
                    this.setFechaTrabajo    (rs.getDate("FECHA_TRABAJO"));
                    this.setHoraTrabajo     (rs.getString ("HORA_TRABAJO"));
                    this.setUserid          (rs.getString("USERID"));
                    this.setFechaEnvioProd  (rs.getDate("FECHA_ENVIO_PROD"));
                    this.setFechaEnvioBenef (rs.getDate("FECHA_ENVIO_BENEF"));
                    this.setFechaRespBenef  (rs.getDate("FECHA_RESP_BENEF"));
                    this.setFechaEmision    (rs.getDate("FECHA_EMISION"));
                    this.setFechaAnulacion  (rs.getDate("FECHA_ANULACION"));
                    this.setHoraEnvioProd   (rs.getString ("HORA_ENVIO_PROD"));
                    this.setHoraEnvioBenef  (rs.getString ("HORA_ENVIO_BENEF"));
                    this.setHoraRespBenef   (rs.getString ("HORA_RESP_BENEF"));
                    this.setdescFormaPago   (rs.getString ("DESC_FORMA_PAGO"));
                    this.setTomadorDescCondIva(rs.getString ("TOMADOR_DESC_IVA"));
                    this.setCantVidas       (rs.getInt ("CANT_VIDAS"));
                    this.setmcaEnvioPoliza  (rs.getString ("MCA_ENVIAR_POLIZA"));
                    this.setporcGDA         (rs.getDouble("GASTOS_ADQUISICION"));
                    this.setDescAmbito      (rs.getString ("DESC_AMBITO"));
                    this.setdescMcaEnviarPoliza(rs.getString ("DESC_ENVIAR_POLIZA"));
                    this.setDescBanco       (rs.getString ("DESC_BANCO"));
                    this.setDescTarjCred    (rs.getString ("DESC_TARJETA"));
                    this.setporcAjusteTarifa  (rs.getDouble ("PORC_AJUSTE_TARIFA"));
                    this.setimpAjusteTarifa  (rs.getDouble ("IMP_AJUSTE_TARIFA"));
                    this.setnivelAjusteTarifa (rs.getString ("NIVEL_AJUSTE_TARIFA"));
                    this.setDescRama            (rs.getString ("DESC_RAMA"));
                    this.setCodFacturacion      (rs.getInt ("COD_FACTURACION"));
                    this.setDescFacturacion     (rs.getString ("DESC_FACTURACION"));
 
                    this.setclaNoRepeticion (rs.getString ("CLA_NO_REPETICION"));
                    this.setclaSubrogacion  (rs.getString ("CLA_SUBROGACION"));
                    this.setbenefHerederos  (rs.getString ("BENEF_HEREDEROS"));
                    this.setbenefTomador    (rs.getString ("BENEF_TOMADOR"));
                    this.setlimMaxAcontecimiento (rs.getDouble ("LIM_MAX_ACONTECIMIENTO"));
                    this.setcodActividadSec (rs.getInt ("COD_ACTIVIDAD_SEC"));
                    this.setcantMaxClausulas(rs.getInt ("CANT_MAX_EMPRESAS"));                    
                    this.setcodPlan         (rs.getInt ("COD_PLAN"));
                    this.setTipoPropuesta   (rs.getString ("TIPO_PROPUESTA"));
                    this.setcodOpcion       (rs.getInt ("COD_OPCION"));
                    this.setporcOpcionAjuste( Double.parseDouble( rs.getString("PORC_OPCION_AJUSTE")));
                    this.setcodProducto     (rs.getInt("COD_PRODUCTO"));
                    this.setcodAmbito       (rs.getInt ("COD_AMBITO"));
                    this.setempleador       (rs.getString ("EMPLEADOR"));
                    this.setnumReferencia   (rs.getInt ("NUM_REFERENCIA"));
                    this.setcantDias        (rs.getInt ("CANT_DIAS"));
                    this.setcategoriaPersona(rs.getString ("CATEGORIA_PERSONA"));
                    this.setdescEstado     (rs.getString("DESC_ESTADO")); // DESCRIPCION ESTADO                  
                    this.setnumEndoso       (rs.getInt ("NUM_ENDOSO"));
                    this.setsubSeccion      (rs.getInt ("SUB_SECCION"));
                    this.setporcComisionOrg (rs.getDouble ("PORC_COMISION_ORG"));
                    this.setbaseCalculoComisiones(rs.getString ("BASE_CALCULO_COMIS"));
                    
                    UbicacionRiesgo oRiesgo = new UbicacionRiesgo ();
                    oRiesgo.setnumPropuesta(this.getNumPropuesta());
                    oRiesgo.getDBPropuesta (dbCon);
                    
                    this.setoUbicacionRiesgo(oRiesgo);
                    
                    lClausulas = this.getDBEmpresasClausulas(dbCon);
                }
            }
            
            if (! bExiste ) {
                this.setCodError(100);
                this.setDescError("La propuesta existe");
            }
        }  catch (SQLException se) {
            throw new SurException("Error SQL al obtener lista de nomina a la propuesta: " + se.getMessage());
        } catch (Exception e) {
            throw new SurException("Error Java: " + e.getMessage());
        } finally {
            try{
                if (rs != null) { rs.close(); }
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }            
    }        
    
    // SUP 01-11-2007
    
    public LinkedList getDBAllCoberturas ( Connection dbCon) 
    throws SurException {
        LinkedList        lCob  = new LinkedList ();
        CallableStatement cons = null;        
        ResultSet         rs = null;
        try {        
            
            dbCon.setAutoCommit(false);
            
            cons = dbCon.prepareCall(db.getSettingCall("PRO_GET_ALL_COBERTURAS (?,?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt    (2, this.getCodProceso());
            cons.setString (3, this.getBoca());
            cons.setInt    (4, this.getNumPropuesta());
            cons.setInt    (5, this.getCodRama());            
            cons.setInt    (6, this.getCodSubRama());            
            cons.execute(); 
            
            rs = (ResultSet) cons.getObject(1);

            if (rs != null) {
                while (rs.next()) {
                    
                    AsegCobertura oCob = new AsegCobertura ();                    
                    // Clausula oCla = new Clausula ();                    
                    // oCla.setdescEmpresa  (rs.getString ("DESCRIPCION")); 
                    // oCla.setcuitEmpresa  (rs.getString ("CUIT"));
                                        
                    oCob.setcodProceso   ( rs.getInt("COD_PROCESO"));   
		    oCob.setcodBoca      ( rs.getString("BOCA"));             
		    oCob.setnumPropuesta ( rs.getInt("NUM_PROPUESTA"));    
		    oCob.setcodRama      ( rs.getInt("COD_RAMA"));         
		    oCob.setcodSubRama   ( rs.getInt("COD_SUB_RAMA"));     
		    oCob.setcodCob       ( rs.getInt("COD_COB"));          
		    oCob.setimpSumaRiesgo( rs.getDouble("SUMA_ASEG"));        
                    oCob.setdescripcion  ( rs.getString("DESCRIPCION"));
                    
                    
                    lCob.add (oCob);
                }
                rs.close();            
            }            
            
        }  catch (SQLException se) {
            throw new SurException("Error SQL al obtener coberturas [getDBAllCoberturas]: " + se.getMessage());
        } catch (Exception e) {
            throw new SurException("Error Java: " + e.getMessage());
        } finally {
            try{
                if (rs != null) { rs.close(); }                
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return lCob;
        }            
    } // getDBAllCoberturas           

}

