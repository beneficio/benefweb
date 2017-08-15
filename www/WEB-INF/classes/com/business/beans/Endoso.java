/*
 * Endoso.java
 *
 * Created on 27 de marzo de 2007, 08:26
 */
    
package com.business.beans;

import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Connection;   
import java.sql.SQLException;
import java.sql.CallableStatement;   

import java.text.*;
import java.util.LinkedList;
import com.business.util.*;
import com.business.db.db;
import java.sql.Types;
//
import java.util.Date;

/**
 *
 * @author  Rolando Elisii
 */
public class Endoso extends Propuesta {
    
    private int cantVidasAltas   = 0;
    private int cantVidasBajas   = 0;
    
    
    /** Creates a new instance of Certificado */
    public Endoso () {
    }
    
    public int    getCantVidasAltas (){ return this.cantVidasAltas; }
    public int    getCantVidasBajas (){ return this.cantVidasBajas; }
    
    public void setCantVidasAltas ( int param ) {  this.cantVidasAltas = param ; }
    public void setCantVidasBajas ( int param ) {  this.cantVidasBajas = param ; }
    
    
    public Propuesta getDBVerificarPoliza (Connection dbCon, String userid)  throws SurException {
        CallableStatement cons = null;
        try {       
            
   //        dbCon.setAutoCommit(false);

           cons = dbCon.prepareCall(db.getSettingCall( "END_VERIFICAR_POLIZA ( ?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getCodRama());
           cons.setInt              (3, this.getNumPoliza());
           cons.setString           (4, userid);           
           cons.setInt              (5, this.gettipoEndoso());

           cons.execute();

           this.setCodError( cons.getInt (1));                        
                
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
           this.setCodError(0);

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
       
    public Propuesta setDBEndosarTomador (Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {       
          dbCon.setAutoCommit(true);

           cons = dbCon.prepareCall(db.getSettingCall( "END_SET_ENDOSAR_TOMADOR (?,?,?,?,?,?,?,?,?,?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getCodRama());
           cons.setInt              (3, this.getNumPoliza());
           cons.setString           (4, this.getTomadorRazon());
           cons.setString           (5, this.getTomadorDom());
           cons.setString           (6, this.getTomadorCP());
           cons.setString           (7, this.getTomadorCodProv());
           cons.setString           (8, this.getTomadorLoc());
           cons.setInt              (9, this.getTomadorCodLocalidad());
           cons.setInt              (10,this.getTomadorCondIva());
           cons.setString           (11, this.getTomadorTE());
           cons.setString           (12, this.getUserid());   
           cons.setInt              (13, this.gettipoEndoso());
           cons.setString           (14, this.getTomadorEmail());
           
           cons.execute();
           
           if (cons.getInt (1) >  0 ) { 
                this.setNumPropuesta(cons.getInt (1));
           } else { 
                this.setCodError(cons.getInt (1));
           }     

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

    public Propuesta setDBEndosarUbicacion (Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {       
          dbCon.setAutoCommit(true);
     
           cons = dbCon.prepareCall(db.getSettingCall( "END_SET_ENDOSAR_UBICACION (?,?,?,?,?,?,?,?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getCodRama());
           cons.setInt              (3, this.getNumPoliza());
           cons.setString           (4, this.getoUbicacionRiesgo().getdomicilio());
           cons.setString           (5, this.getoUbicacionRiesgo().getcodPostal());
           cons.setString           (6, this.getoUbicacionRiesgo().getprovincia());
           cons.setString           (7, this.getoUbicacionRiesgo().getlocalidad());
           cons.setInt              (8, this.getoUbicacionRiesgo().getcodLocalidad());
           cons.setString           (9,this.getUserid());   
           cons.setInt              (10,this.gettipoEndoso());
           if ( this.getoUbicacionRiesgo().getigualTomador() == null ) {
                cons.setNull        (11, Types.VARCHAR);
           } else {
                cons.setString      (11, this.getoUbicacionRiesgo().getigualTomador());
           }
           cons.setInt (12, this.getnumPropuestaSec());
           
           cons.execute();
           
           if (cons.getInt (1) >  0 ) { 
                this.setNumPropuesta(cons.getInt (1));
           } else { 
                this.setCodError(cons.getInt (1));
           }     

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
    
    public Propuesta setDBEndosarComisiones (Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {       
          dbCon.setAutoCommit(true);

           cons = dbCon.prepareCall(db.getSettingCall( "END_SET_ENDOSAR_COND_COMERCIAL (?,?,?,?,?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getCodRama());
           cons.setInt              (3, this.getNumPoliza());
           cons.setString           (4,this.getUserid());   
           cons.setInt              (5, this.gettipoEndoso());
           cons.setDouble           (6, this.getporcGDA());
           cons.setDouble           (7, this.getporcComisionOrg());
           cons.setString           (8, this.getbaseCalculoComisiones());
           cons.setInt              (9, this.getsubSeccion());
                      
           cons.execute();
           
           if (cons.getInt (1) >  0 ) { 
                this.setNumPropuesta(cons.getInt (1));
           } else { 
                this.setCodError(cons.getInt (1));
           }     

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

    public Propuesta setDBEndosarClausulas (Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {       
          dbCon.setAutoCommit(true);

           cons = dbCon.prepareCall(db.getSettingCall( "END_SET_ENDOSAR_CLAUSULAS (?,?,?,?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getCodRama());
           cons.setInt              (3, this.getNumPoliza());
           cons.setString           (4,this.getUserid());   
           cons.setInt              (5,this.gettipoEndoso());
           cons.setString           (6, this.getclaNoRepeticion());
           cons.setString           (7, this.getclaSubrogacion());
           cons.setInt              (8, this.getNumCertificado());
           
           cons.execute();
           
           if (cons.getInt (1) >  0 ) { 
                this.setNumPropuesta(cons.getInt (1));
                LinkedList <Clausula> lClau = this.getAllClausulas();
                for (int i=0; i<lClau.size(); i++) {
                    Clausula oClau = (Clausula) lClau.get(i);
                    oClau.setboca("WEB");
                    oClau.setnumPropuesta(this.getNumPropuesta());
                    oClau.setDB(dbCon);
                }
           } else { 
                this.setCodError(cons.getInt (1));
           }     

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
    
    public Propuesta setDBDelete(Connection dbCon, String usuario)  throws SurException {
        CallableStatement cons = null;
        try {       
           dbCon.setAutoCommit(true);
           
           cons = dbCon.prepareCall(db.getSettingCall( "END_SET_DEL_ENDOSO (?, ?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getNumPropuesta()); 
           cons.setString           (3, usuario);
           
           cons.execute();
          
           this.setCodError( cons.getInt (1));
           if (this.getCodError() == -100) {
               this.setDescError("LA PROPUESTA YA FUE ENVIADA");
           }

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

    public LinkedList getDBAseguradosAEndosar ( Connection dbCon) throws SurException {
        LinkedList lAseg = new LinkedList();
        ResultSet rs = null;
        CallableStatement cons = null;
        try {
//            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("END_GET_ALL_ASEGURADOS_ENDOSAR (?, ?, ?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getCodRama      ());
            cons.setInt (3, this.getNumPoliza    ());
            cons.setInt (4, this.getNumPropuesta ());
            cons.setString (5, this.getUserid    ());
            cons.execute();
            
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    AseguradoPropuesta oAseg = new AseguradoPropuesta();
                    oAseg.setCodRama        (rs.getInt("COD_RAMA"));
                    oAseg.setNumPoliza      (rs.getInt("NUM_POLIZA"));
                    oAseg.setCertificado    (rs.getInt("CERTIFICADO"));
                    oAseg.setSubCertificado (rs.getInt("SUB_CERTIFICADO"));
                    oAseg.setDescTipoDoc    (rs.getString("DESC_TIPO_DOC"));
                    oAseg.setTipoDoc        (rs.getString("TIPO_DOC"));
                    oAseg.setNumDoc         (rs.getString("NUM_DOC"));
                    oAseg.setNombre         (rs.getString("NOMBRE"));
                    oAseg.setDomicilio      (rs.getString("DOMICILIO"));
                    oAseg.setFechaAltaCob   (rs.getDate ("FECHA_ALTA_COB"));
                    oAseg.setFechaBaja      (rs.getDate ("FECHA_BAJA"));
                    oAseg.setEstado         (rs.getString("ESTADO"));
                    oAseg.setFechaNac       (rs.getDate  ("FECHA_NAC"));
                    oAseg.setOrden          (rs.getInt   ("ORDEN"));
                    
                    lAseg.add(oAseg);
                }
                rs.close();
            }
            cons.close ();

            this.setDescError(null);
            this.setCodError(0);

        }  catch (SQLException se) {
            this.setCodError(-1);
            this.setDescError(se.getMessage());
        } catch (Exception e) {
            this.setCodError(-1);
            this.setDescError(e.getMessage());
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
  
    public Endoso getDB ( Connection dbCon) throws SurException {
        CallableStatement cons = null;        
        ResultSet rs = null;
        boolean bExiste = false;

        try {        
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("END_GET_PROPUESTA (?)"));
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
                    this.setCantVidasAltas      (rs.getInt ("CANT_VIDAS_ALTAS"));
                    this.setCantVidasBajas      (rs.getInt ("CANT_VIDAS_BAJAS")); 
                    this.settipoEndoso          (rs.getInt ("TIPO_ENDOSO"));
                    this.setdescTipoEndoso      (rs.getString ("DESC_TIPO_ENDOSO"));
                    this.setnumEndoso           (rs.getInt ("NUM_ENDOSO"));
                    this.setsubSeccion          (rs.getInt ("SUB_SECCION"));
                    this.setporcComisionOrg     (rs.getDouble ("PORC_COMISION_ORG"));
                    this.setbaseCalculoComisiones(rs.getString ("BASE_CALCULO_COMIS"));
                    this.setTipoPropuesta("TIPO_PROPUESTA");
                    
                }
                rs.close ();
                
                if (this.getCodRama() == 10 ) {
                    UbicacionRiesgo oRiesgo = new UbicacionRiesgo ();
                    oRiesgo.setnumPropuesta(this.getNumPropuesta());
                    oRiesgo.getDBPropuesta (dbCon);
                    
                    if (oRiesgo.getiNumError() == 0 ) {
                        this.setoUbicacionRiesgo(oRiesgo);
                    }
 
                    if ( this.getCodRama () == 10 ) {
                        LinkedList <Clausula> lClausulas =  this.getDBEmpresasClausulas(dbCon);
                        
                        if (lClausulas != null) {
                            this.setAllClausulas(lClausulas);
                        }
                    }
                }
            }

            if (! bExiste) {
                this.setCodError(-100);
                this.setDescError("ERROR: ENDOSO INEXISTENTE ");
            }
            cons.close ();
            
        }  catch (SQLException se) {
            this.setCodError(-1);
            this.setDescError("ERROR: " + se.getMessage());
        } catch (Exception e) {
            this.setCodError(-1);
            this.setDescError("ERROR: " + e.getMessage());
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
}

