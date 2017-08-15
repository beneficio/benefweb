/*
 * CotizadorAp.java
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
/**
 *
 * @author Rolando Elisii
 */
public class CotizadorVC {
    
    private int numCotizacion        = 0;
    private int codRama              = 0;
    private int codSubRama           = 0;
    private int codAmbito            = 0;
    private String descAmbito        = "";
    private String descRama          = "";
    private String descSubRama       = "";    
    private int codActividad         = 0;
    private String descActividad     = "";    
    private int codProvincia         = 0;
    private String descProvincia     = "";    
    private int codVigencia          = 0;
    private int cantCuotas           = 0;
    private String descVigencia      = "";
    private int cantPersonas         = 0;
    private double gastosAdquisicion = 0;
    private double franquicia        = 0;
    private String userId            = "";
    private String usuarioCambiaEstado= "";
    private String descUsuarioCambiaEstado= "";
    private String descUsu           = "";
    private Date fechaCotizacion     = null;
    private String horaCotizacion    = null;
    private Date fechaCambiaEstado   = null;
    //datos del tomador
    private String tomadorApe        = "";    
    private String tomadorNom        = "";    
    private String tomadorTel        = "";    
    private int tomadorCodIva        = 0;
    private String tomadorDescIva    = "";
    //datos de la cotizacion
    private double primaTar          = 0;
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
    private double premio            = 0;
    private double primaPura         = 0;    
    private double recAdmin          = 0;
    private double recFinan          = 0;
    private double porcRecAdmin      = 0;
    private double porcRecFinan      = 0;
    private double valorCuota        = 0;
    private double porcAjusteTarifa  = 0;
    private double impAjusteTarifa   = 0;
    private String nivelAjusteTarifa = "";
    
    private int estadoCotizacion         = 0;
    private int modoVisualizacion        = 3;
    private String descModoVisualizacion = "";
    private int tipoEnvioOrig      = 1;  // 1: correo, 2:mensajeria 
    private String descModoEnvio   = "";
    private String descProd        = "";
    private Date fechaTrabajo      = null;
    private Date horaOperacion     = null;
    private int codProd            = -1;
    private String sMensError      = new String();
    private int  iNumError         = 0;
    private String abm               = "N";
    private String sMcaBajaActividad = "";
    private int codActividadSec     = 0;
    private String descActividadSec = "";
    private int codOpcion           = 0;
    private double porcOpcionAjuste = 0;
    private int codProducto         = 0;
    private String tipoPropuesta    = "P";
    private int numPoliza           = 0;
    private String sDescOpcion      = null;

    private CallableStatement cons = null;
    
    /** Creates a new instance of Cotizador */
    public CotizadorVC() {
    }

    public void setnumCotizacion        (int param) { this.numCotizacion      = param; }
    public void setcodRama              (int param) { this.codRama            = param; }
    public void setcodSubRama           (int param) { this.codSubRama         = param; }
    public void setcodAmbito            (int param) { this.codAmbito          = param; }
    public void setdescAmbito        (String param) { this.descAmbito         = param; }
    public void setdescRama          (String param) { this.descRama           = param; }
    public void setdescSubRama       (String param) { this.descSubRama        = param; }    
    public void setcodActividad         (int param) { this.codActividad       = param; }
    public void setdescActividad     (String param) { this.descActividad      = param; }
    public void setcodProvincia         (int param) { this.codProvincia       = param; }
    public void setdescProvincia     (String param) { this.descProvincia      = param; }
    public void setcodVigencia          (int param) { this.codVigencia        = param; }
    public void setcantCuotas           (int param) { this.cantCuotas         = param; }
    public void setdescVigencia      (String param) { this.descVigencia       = param; }
    public void setcantPersonas         (int param) { this.cantPersonas       = param; }
    public void setgastosAdquisicion (double param) { this.gastosAdquisicion  = param; }
    public void setfranquicia        (double param) { this.franquicia         = param; }
    public void setuserId            (String param) { this.userId             = param; }
    public void setusuarioCambiaEstado (String param) { this.usuarioCambiaEstado = param; }
    public void setdescUsuarioCambiaEstado (String param) { this.descUsuarioCambiaEstado = param; }
    public void setdescUsu           (String param) { this.descUsu            = param; }
    public void setfechaCotizacion     (Date param) { this.fechaCotizacion    = param; }
    public void sethoraCotizacion     (String param) { this.horaCotizacion    = param; }
    public void setfechaCambiaEstado   (Date param) { this.fechaCambiaEstado  = param; }
    public void setestadoCotizacion      (int param) { this.estadoCotizacion    = param; }
    public void setmodoVisualizacion    (int param) { this.modoVisualizacion  = param; } // 1: correo, 2:mensajeria     
    public void setdescModoVisualizacion (String param) { this.descModoVisualizacion           = param; }    
    public void settipoEnvioOrig        (int param) { this.tipoEnvioOrig      = param; } // 1: correo, 2:mensajeria 
    public void setdescModoEnvio     (String param) { this.descModoEnvio      = param; }    
    public void setdescProd          (String param) { this.descProd           = param; }
    public void setfechaTrabajo        (Date param) { this.fechaTrabajo       = param; }
    public void sethoraOperacion       (Date param) { this.horaOperacion      = param; }
    public void setcodProd              (int param) { this.codProd            = param; }
    /*datos tomador*/
    public void settomadorApe          (String param) { this.tomadorApe           = param; }
    public void settomadorNom          (String param) { this.tomadorNom           = param; }
    public void settomadorTel          (String param) { this.tomadorTel           = param; }
    public void settomadorCodIva          (int param) { this.tomadorCodIva        = param; }
    public void settomadorDescIva      (String param) { this.tomadorDescIva       = param; }
   /*datos cotizacion*/
    public void setprimaTar    (double param) { this.primaTar  = param; }
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
    public void setpremio      (double param) { this.premio  = param; }
    public void setprimaPura   (double param) { this.primaPura  = param; }
    public void setrecAdmin    (double param) { this.recAdmin = param; }    
    public void setrecFinan    (double param) { this.recFinan = param; }        
    public void setporcRecAdmin    (double param) { this.porcRecAdmin = param; }    
    public void setporcRecFinan    (double param) { this.porcRecFinan = param; }        
    public void setvalorCuota      (double param) { this.valorCuota   = param; }        
    public void setabm         (String param) { this.abm  = param; }
    public void setimpAjusteTarifa  (double param) { this.impAjusteTarifa  = param; }        
    public void setporcAjusteTarifa (double param) { this.porcAjusteTarifa = param; }        
    public void setnivelAjusteTarifa (String param) { this.nivelAjusteTarifa  = param; }
    public void setcodActividadSec   (int param) { this.codActividadSec       = param; }
    public void setsMcaBajaActividad (String param) { this.sMcaBajaActividad  = param; }
    public void setdescActividadSec  (String param) { this.descActividadSec   = param; }
    public void setcodOpcion         (int param) { this.codOpcion             = param; }
    public void setporcOpcionAjuste  (double param) { this.porcOpcionAjuste   = param; }
    public void setcodProducto       (int param) { this.codProducto           = param; }
    public void settipoPropuesta     (String param) { this.tipoPropuesta      = param; }
    public void setnumPoliza         (int param) { this.numPoliza             = param; }
    public void setsDescOpcion      ( String param){ sDescOpcion = param; }
    
    public String getdescActividadSec    () { return this.descActividadSec;}
    public int getnumCotizacion       () { return this.numCotizacion;}
    public int getcodRama             () { return this.codRama;}
    public int getcodSubRama          () { return this.codSubRama;}
    public int getcodAmbito           () { return this.codAmbito;}
    public String getdescAmbito       () { return this.descAmbito;}
    public String getdescRama         () { return this.descRama;}
    public String getdescSubRama      () { return this.descSubRama;}    
    public int getcodActividad        () { return this.codActividad;}
    public String getdescActividad    () { return this.descActividad;}
    public int getcodProvincia        () { return this.codProvincia;}
    public String getdescProvincia    () { return this.descProvincia;}
    public int getcodVigencia         () { return this.codVigencia;}
    public int getcantCuotas          () { return this.cantCuotas;}
    public String getdescVigencia     () { return this.descVigencia;}
    public int getcantPersonas        () { return this.cantPersonas;}
    public double getgastosAdquisicion() { return this.gastosAdquisicion;}
    public double getfranquicia       () { return this.franquicia;}
    public String getuserId           () { return this.userId;}
    public String getusuarioCambiaEstado(){ return this.usuarioCambiaEstado;}
    public String getdescUsuarioCambiaEstado(){ return this.descUsuarioCambiaEstado;}
    public String getdescUsu          () { return this.descUsu;}
    public Date   getfechaCotizacion  () { return this.fechaCotizacion;}
    public String gethoraCotizacion  () { return this.horaCotizacion;}    
    public Date   getfechaCambiaEstado() { return this.fechaCambiaEstado;}
    public int getestadoCotizacion     () { return this.estadoCotizacion;}
    public int getmodoVisualizacion   () { return  this.modoVisualizacion;}
    public String getdescModoVisualizacion () { return this.descModoVisualizacion;}
    public int gettipoEnvioOrig       () { return  this.tipoEnvioOrig;} // 1: correo, 2:mensajeria 
    public String getdescModoEnvio    () { return this.descModoEnvio; }
    public String getdescProd         () { return this.descProd;}
    public Date getfechaTrabajo       () { return  this.fechaTrabajo;}
    public Date gethoraOperacion      () { return  this.horaOperacion;}
    public int getcodProd             () { return this.codProd;}
    public int getcodProducto         () { return this.codProducto;}
    public int getnumPoliza           () { return this.numPoliza;}
    public String gettipoPropuesta    () { return this.tipoPropuesta;}
    
    public String gettomadorApe       () { return this.tomadorApe; }
    public String gettomadorNom       () { return this.tomadorNom; }
    public String gettomadorTel       () { return this.tomadorTel; }
    public int gettomadorCodIva       () { return this.tomadorCodIva;}
    public String gettomadorDescIva   () { return this.tomadorDescIva; }
   /*datos cotizacion*/
    public double getprimaTar    () { return this.primaTar; }
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
    public double getpremio      () { return this.premio; }   
    public double getprimaPura   () { return this.primaPura; }       
    public double getrecAdmin    () { return this.recAdmin; }           
    public double getrecFinan    () { return this.recFinan; }               
    public double getporcRecAdmin    () { return this.porcRecAdmin; }           
    public double getporcRecFinan    () { return this.porcRecFinan; }               
    public double getvalorCuota      () { return this.valorCuota; }   
    public String getabm         () { return this.abm; }   
    public double getimpAjusteTarifa  () { return this.impAjusteTarifa; }        
    public double getporcAjusteTarifa () { return  this.porcAjusteTarifa; }        
    public String getnivelAjusteTarifa () { return this.nivelAjusteTarifa; }
    public String getsMcaBajaActividad () { return this.sMcaBajaActividad; }    
    public int getcodActividadSec        () { return this.codActividadSec;}
    public int getcodOpcion              () { return this.codOpcion;}
    public double getporcOpcionAjuste    () { return this.porcOpcionAjuste;}
    public String getsDescOpcion      (){ return this.sDescOpcion; }
    
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

    public String getdescEstadoCotizacion () { 
        String mensaje;
        switch(this.getestadoCotizacion()){
            case 1:
                 mensaje =  "SOLICITUD";
                break;
            case 2:
                 mensaje =  "AUTORIZACION";
                break;
            case 3:
                 mensaje =  "RECHAZO";  
                break;
            default:
                 mensaje =  "";
        }
        return mensaje;
    }
    
    public String getMensajeEstado () { 
        String mensaje;
        switch(this.getestadoCotizacion()){
            case 1:
                mensaje = "La cotizaci&oacute;n ha sido enviada exitosamente. </br></br>N&uacute;mero de Operaci&oacute;n <b>" + this.getnumCotizacion() + "</b>.</br>A la brevedad un representante comercial se contactar&aacute; con Ud.<br><br> Muchas Gracias.";
                break;
            case 2:
                mensaje = "La cotizaci&oacute;n ha sido autorizada exitosamente. </br></br>N&uacute;mero de Operaci&oacute;n <b>" + this.getnumCotizacion() + "</b>.</br>Se ha enviado un e-mail informando la autorizaci&oacute;n al productor "+ this.getdescProd()+".<br><br>";
                break;
            case 3:
                mensaje = "La cotizaci&oacute;n ha sido rechazada exitosamente. </br></br>N&uacute;mero de Operaci&oacute;n <b>" + this.getnumCotizacion() + "</b>.</br>Se ha enviado un e-mail informando el rechazo al productor "+this.getdescProd()+".<br><br>";
                break;
            default:
                mensaje =  "";
        }
        return mensaje; 
    }
    
    public void setDBDelete (Connection dbCon) throws SurException {
    
      try {
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall( "COT_DEL_COTIZACION (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt   (2, this.getnumCotizacion    () );
            cons.setString(3, this.getuserId           () );
            
            cons.execute();
            
            this.setnumCotizacion ( cons.getInt (1));
           
        }  catch (SQLException se) {
		throw new SurException("Error en CotizadorAP[setDBDelete]: " + se.getMessage());
        } catch (Exception e) {
		throw new SurException("Error en CotizadorAP[setDBDelete]: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }

    public CotizadorVC setDBCambiarEstadoCotizacion ( Connection dbCon) throws SurException {
       try {
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall("COT_CAMBIAR_ESTADO (?,?,?)"));
            cons.registerOutParameter   (1, java.sql.Types.INTEGER);
            cons.setInt                 (2, this.getnumCotizacion());
            cons.setInt                 (3, this.getestadoCotizacion());
            cons.setString              (4, this.getusuarioCambiaEstado());
            
            cons.execute();
            
            this.setiNumError(cons.getInt (1));
       
       }  catch (SQLException se) {
		throw new SurException("Error al cambiar el estado de la cotizacion: " + se.getMessage());
        } catch (Exception e) {
		throw new SurException("Error al cambair el estado de la cotizacion: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }    
    
    public CotizadorVC getDB ( Connection dbCon) throws SurException {
       ResultSet rs = null;
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("COT_GET_COTIZACION (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getnumCotizacion());
            cons.execute();
           
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    this.setcodRama              (rs.getInt("COD_RAMA"));
                    this.setdescRama             (rs.getString("DESC_RAMA"));
                    this.setcodSubRama           (rs.getInt("COD_SUB_RAMA"));
                    this.setcodAmbito            (rs.getInt("COD_AMBITO"));
                    this.setdescAmbito           (rs.getString("DESC_AMBITO"));
                    this.setcodActividad         (rs.getInt("COD_ACTIVIDAD"));
                    this.setdescActividad        (rs.getString("DESC_ACTIVIDAD"));
                    this.setcodProvincia         (rs.getInt("COD_PROVINCIA"));
                    this.setdescProvincia        (rs.getString("DESC_PROVINCIA"));
                    this.setcodVigencia          (rs.getInt("COD_VIGENCIA"));
                    this.setcantCuotas           (rs.getInt("CANT_CUOTAS"));
                    this.setdescVigencia         (rs.getString("DESC_VIGENCIA"));
                    this.setcantPersonas         (rs.getInt("CANT_PERSONAS"));
                    this.setgastosAdquisicion (rs.getDouble("GASTOS_ADQUISICION"));
                    this.setfranquicia        (rs.getDouble("FRANQUICIA"));
                    this.setuserId            (rs.getString("USUARIO"));
                    this.setusuarioCambiaEstado(rs.getString("USUARIO_CAMBIA_ESTADO"));
                    this.setdescUsuarioCambiaEstado(rs.getString("DESC_USUARIO_CAMBIA_ESTADO"));
                    this.setdescUsu           (rs.getString("DESC_USU"));
                    this.setcodProd           (rs.getInt("COD_PROD"));
                    this.setdescProd          (rs.getString ("DESC_PROD"));
                    this.setfechaCotizacion   (rs.getDate("FECHA_COTIZ"));
                    this.setfechaCambiaEstado (rs.getDate("FECHA_CAMBIA_ESTADO"));
                    this.settomadorApe        (rs.getString("TOMADOR_APE"));
                    this.settomadorNom        (rs.getString("TOMADOR_NOM"));
                    this.settomadorTel        (rs.getString("TOMADOR_TEL"));
                    this.settomadorCodIva     (rs.getInt("TOMADOR_COD_IVA"));
                    this.settomadorDescIva    (rs.getString("TOMADOR_DESC_IVA"));
                    this.setprimaTar    (rs.getDouble("PRIMA_TAR"));
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
                    this.setpremio      (rs.getDouble("PREMIO"));                    
                    this.setestadoCotizacion(rs.getInt("ESTADO"));
                    this.setprimaPura   (rs.getDouble("IMP_PRIMA_PURA"));
                    this.setrecAdmin    (rs.getDouble("REC_ADMIN"));
                    this.setrecFinan    (rs.getDouble("REC_FINAN"));
                    this.setporcRecAdmin(rs.getDouble("PORC_REC_ADMIN"));
                    this.setporcRecFinan(rs.getDouble("PORC_REC_FINAN"));
                    this.setvalorCuota  (rs.getDouble("VALOR_CUOTA"));
                    this.setabm         (rs.getString("ABM"));
                    this.sethoraCotizacion    (rs.getString ("HORA_COTIZ"));
                    this.setporcAjusteTarifa  (rs.getDouble ("PORC_AJUSTE_TARIFA"));
                    this.setimpAjusteTarifa   (rs.getDouble ("IMP_AJUSTE_TARIFA"));
                    this.setnivelAjusteTarifa (rs.getString ("NIVEL_AJUSTE_TARIFA"));
                    this.setcodActividadSec   (rs.getInt ("COD_ACTIVIDAD_SEC"));
                    this.setdescActividadSec  (rs.getString ("DESC_ACTIVIDAD_SEC"));
                    this.setcodOpcion           (rs.getInt ("COD_OPCION"));
                    this.setporcOpcionAjuste    ( Double.parseDouble( rs.getString("PORC_OPCION_AJUSTE")));
                    this.setnumPoliza(rs.getInt ("NUM_POLIZA"));
                    this.settipoPropuesta   (rs.getString("TIPO_PROPUESTA"));
                    this.setcodProducto     (rs.getInt  ("COD_PRODUCTO"));
                    this.setsDescOpcion     (rs.getString("DESC_OPCION"));
                }
                rs.close();
            }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Sql al obtener la cotizacion: " + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error al obtener la cotizacion: " + e.getMessage());
        } finally {
            try{
                if (rs != null) {rs.close();}
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }
}
