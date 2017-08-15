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

public class MercadoPago {

    private int numSecuMercadopago = 0;
    private String numDoc          = "";
// NUM. DOCUMENTO O CUIT INGRESADO DESDE EL PORTAL
    private int codEstado          = 0;
// 0: PENDIENTE - 1: FINALIZADA OK - 2 ERRONEA
    private String procedencia     = "";
// VALORES: PORTAL, POLIZA, PROPUESTA, PRELIQ, MULT_POLIZA
    private int opcionPago         = 0;
// 1:  ON LINE - 2: MAIL PAGO
    private int numPoliza          = 0;
// NUMERO DE POLIZA EN CASO DE UNICO VALOR O NUM_PRELIQ O UN CODIGO AGRUPADOR DE OPERACIONES VARIAS
    private int numEndoso          = 0;
    private int numPropuesta       = 0;
    private Date fechaEmision      = null;
    private Date fechaInicioVigencia = null;
    private Date fechaFinVigencia    = null;
    private int codRama            = 0;
// COD_RAMA EN CASO DE POLIZA UNICA O CODIGO DE PAGO EN CASO DE PRELIQUIDACION Y MULTIPLES POLIZAS
    private int codSubRama         = 0;
    private String estadoPoliza    = "";
    private double impTotalFacturado = 0;
    private double impSaldoPoliza  = 0;
    private double impDeuda        = 0;  
    private int codProd            = 0; 
    private int numTomador         = 0;
    private int cantVidas          = 0;     
    private String userId          = "";
    private Date fechaTrabajo      = null;
    private String horaOperacion     = null;
    private String descRama        = "";
    private String descSubRama     = "";
    private String descProductor   = "";
    private int tipoEndoso          = 0;
    private String sDescTipoEndoso  = new String ();
    private String sCodFormaPago    = "";
    private int codProducto         = 0;
    private String email            = "";
    private String  code            = "";
//  "MERCADOPAGO"."CODE" cod. de error o al realizar un cobro
    private String codeMensaje      = "";
// "MERCADOPAGO_DATA_ISSUE"."COMMUNICATION"
    private String status          = null;
// Resultados de la creación de un cobro: HTTP Status 201 OK, es clave foranea de MERCADOPAGO_PAYMENT_STATUS.status
    private String statusDetail       = "";
// "MERCADOPAGO"."STATUS_DETAIL"
    private String statusMensaje      = "";
// "MERCADOPAGO_PAYMENT_STATUS"."COMMUNICATION"
    private String idTransaccion      = "";
// External reference (id generado por nosotros)... "MERCADOPAGO"."ID_TRANSACCION"
    private String token              = "";
// "MERCADOPAGO"."TOKEN"
    private String descripcion        = "";
//  "MERCADOPAGO"."DESCRIPCION" character varying(500), -- Payment description (Descripcion del pago)...
    private int cantCuotas  = 0;
//  "MERCADOPAGO"."CANT_CUOTAS" integer, -- Installments
    private String metodoPago;
//  "MERCADOPAGO"."METODO_PAGO" integer, -- Payment method id (Visa, Master, etc)...
    private int codBanco    = 0;
//  "MERCADOPAGO"."COD_BANCO" integer, -- Issuer id (id del banco emisor de la tarjeta seleccionada)

    private String sMensError           = new String();
    private int  iNumError              = 0;
    private PersonaPoliza oTomador      = null;
    private CallableStatement cons = null;
    
    /** Creates a new instance of Certificado */
    public MercadoPago() {
    }

    public void setfechaEmision      (Date param) { this.fechaEmision = param; }
    public void setfechaInicioVigencia (Date param) { this.fechaInicioVigencia = param; }
    public void setfechaFinVigencia    (Date param) { this.fechaFinVigencia = param; }
    public void setcodRama            (int param) { this.codRama = param; }
    public void setcodSubRama         (int param) { this.codSubRama = param; }
    public void setestadoPoliza             (String param) { this.estadoPoliza = param; }
    public void setcantVidas          (int param) { this.cantVidas = param; }
    public void setnumPoliza          (int param) { this.numPoliza  = param; }
    public void setnumEndoso          (int param) { this.numEndoso  = param; }
    public void setnumTomador         (int param) { this.numTomador  = param; }
    public void setcodProd            (int param) { this.codProd   = param; }
    public void setimpTotalFacturado  (double param) { this.impTotalFacturado = param; }
    public void setimpSaldoPoliza     (double param) { this.impSaldoPoliza = param; }
    public void setimpDeuda           (double param) { this.impDeuda = param; }
    public void setdescRama          (String param) { this.descRama      = param; }
    public void setdescSubRama       (String param) { this.descSubRama   = param; }    
    public void setdescProductor     (String param) { this.descProductor = param; }    
    public void setnumPropuesta      (int param) { this.numPropuesta  = param; }
    public void setcodProducto       (int param) { this.codProducto  = param; }
    
    public void setuserId             (String param) { this.userId = param; }
    public void setfechaTrabajo       (Date param) { this.fechaTrabajo = param; }
    public void sethoraOperacion      (String param) { this.horaOperacion = param; }
    public void settipoEndoso     (int param ){ tipoEndoso      = param; }
    public void setsDescTipoEndoso( String param){ sDescTipoEndoso = param; }
    public void setsCodFormaPago  (String param) { this.sCodFormaPago = param; }
    public void setoTomador       (PersonaPoliza  param) { this.oTomador = param; }
    public void setnumSecuMercadopago (int param) { this.numSecuMercadopago = param; }
    public void setnumDoc       (String param) { this.numDoc =   param; }
    public void setcodEstado    (Integer param) { this.codEstado =  param; }
    public void setstatus       (String param) { this.status =  param; }
    public void setprocedencia  (String param) { this.procedencia =  param; }
    public void setopcionPago   (int param) { this.opcionPago =  param; }
    public void setemail        (String param) { this.email =   param; }
    public void setstatusDetail (String param) { this.statusDetail =   param; }
    public void setidTransaccion(String param) { this.idTransaccion =   param; }
    public void settoken        (String param) { this.token =   param; }
    public void setdescripcion  (String param) { this.descripcion =   param; }
    public void setcantCuotas   (int param) { this.cantCuotas =  param; }
    public void setmetodoPago   (String param) { this.metodoPago =  param; }
    public void setcodBanco     (Integer param) { this.codBanco =  param; }
    public void setcode         (String param) { this.code =  param; }
    public void setcodeMensaje  (String param) { this.codeMensaje =  param; }
    public void setstatusMensaje(String param) { this.statusMensaje =  param; }

    public Date getfechaEmision       () { return  this.fechaEmision;}
    public Date getfechaInicioVigencia() { return  this.fechaInicioVigencia;}
    public Date getfechaFinVigencia   () { return  this.fechaFinVigencia;}
    public int getcodRama             () { return  this.codRama;}
    public int getcodSubRama          () { return  this.codSubRama;}
    public String getestadoPoliza           () { return this.estadoPoliza;}
    public int getnumPoliza           () { return this.numPoliza;}    
    public int getnumEndoso           () { return this.numEndoso;}    
    public int getnumTomador          () { return this.numTomador;}    
    public double getimpTotalFacturado () { return this.impTotalFacturado;}
    public double getimpSaldoPoliza    () { return this.impSaldoPoliza;}
    public double getimpDeuda          () { return this.impDeuda;}
    public String getdescRama         () { return this.descRama;}
    public String getdescSubRama      () { return this.descSubRama;}    
    public String getdescProductor    () { return this.descProductor;}    
    public int getnumPropuesta        () { return this.numPropuesta;}        
    public int getcantVidas () { return this.cantVidas ; }
    public String getuserId           () { return this.userId;}
    public Date getfechaTrabajo       () { return  this.fechaTrabajo;}
    public String gethoraOperacion      () { return  this.horaOperacion;}
    public int    gettipoEndoso       () {return this.tipoEndoso; }
    public String getsDescTipoEndoso  () {return this.sDescTipoEndoso; }
    public String getsCodFormaPago    () {return this.sCodFormaPago; }
    public int    getcodProducto      () {return this.codProducto; }
    public PersonaPoliza getoTomador  () {return this.oTomador; }
    public int    getnumSecuMercadopago () { return this.numSecuMercadopago; }
    public String getnumDoc             () { return this.numDoc; }
    public Integer    getcodEstado          () {return this.codEstado; }
    public String getstatus             () {return this.status; }
    public String getprocedencia        () {return this.procedencia; }
    public int    getopcionPago         () {return this.opcionPago; }
    public String getemail              () { return this.email;}
    public String getstatusDetail       () { return this.statusDetail;}
    public String getidTransaccion      () { return this.idTransaccion; }
    public String gettoken              () { return this.token; }
    public String getdescripcion        () { return this.descripcion; }
    public int getcantCuotas            () { return this.cantCuotas; }
    public String getmetodoPago            () { return this.metodoPago; }
    public Integer getcodBanco              () { return this.codBanco; }
    public String getcode               () { return this.code; }
    public String getcodeMensaje        () { return this.codeMensaje; }
    public String getstatusMensaje      () { return this.statusMensaje; }

    public String getsMensError  () { return this.sMensError;}
    public void setsMensError  (String psMensError ) {this.sMensError = psMensError;}
    public int getiNumError  () {return this.iNumError;}
    public void setiNumError  (int piNumError ) {this.iNumError  = piNumError;}
    

    public MercadoPago getDBMercadoPago ( Connection dbCon) {
        ResultSet rs = null;
        boolean bExiste = false;
        PersonaPoliza oTom = new PersonaPoliza ();
       try {
           
            System.out.println (this.getnumDoc());
            System.out.println (this.getcodRama());
            System.out.println (this.getnumPoliza ());
            System.out.println (this.getprocedencia());

            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("MP_GET_POLIZA (?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString (2, this.getnumDoc());
            cons.setInt    (3, this.getcodRama());
            cons.setInt    (4, this.getnumPoliza ());
            cons.setString (5, this.getprocedencia());
            // "PORTAL", "POLIZA" o "PROPUESTA" o "PRELIQ" o "MULTI_POLIZA"
            cons.execute();

           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    bExiste     = true;
                    this.setcodRama             (rs.getInt ("COD_RAMA"));
                    this.setdescRama            (rs.getString ("RAMA"));
                    this.setcodSubRama          (rs.getInt ("COD_SUB_RAMA"));
                    this.setcodProducto         (rs.getInt ("COD_PRODUCTO"));
                    this.setnumPoliza           (rs.getInt("NUM_POLIZA"));
                    this.setcodProd             (rs.getInt ("COD_PROD"));
                    this.setnumTomador          (rs.getInt ("NUM_TOMADOR"));
                    this.setfechaEmision        (rs.getDate("FECHA_EMISION_POL"));
                    this.setfechaInicioVigencia (rs.getDate("FECHA_INI_VIG_POL"));
                    this.setfechaFinVigencia    (rs.getDate("FECHA_FIN_VIG_POL"));
                    this.setimpDeuda            (rs.getDouble("IMP_DEUDA"));
                    this.setestadoPoliza        (rs.getString ("COD_ESTADO"));
                    this.setcantVidas           (rs.getInt ("CANT_VIDAS"));
                    this.setsCodFormaPago       (rs.getString ("COD_FORMA_PAGO"));
                    this.setimpSaldoPoliza      (rs.getDouble ("SALDO_TOTAL"));

                    if (this.getprocedencia().equals("PORTAL") ||
                        this.getprocedencia().equals("PROPUESTA") ||
                        this.getprocedencia().equals("POLIZA") ) {
                        oTom.settipoDoc     (rs.getString ("TIPO_DOC"));
                        oTom.setnumDoc      (rs.getString ("NUM_DOC"));
                        oTom.setcuit        (rs.getString ("CUIT"));
                        oTom.setrazonSocial (rs.getString("RAZON_SOCIAL"));
                        oTom.setlocalidad   (rs.getString ("LOCALIDAD"));
                        oTom.setnumTomador  (rs.getInt ("NUM_TOMADOR"));
                        oTom.setdomicilio   (rs.getString ("DOMICILIO"));
                        oTom.setcodPostal   (rs.getString ("COD_POSTAL"));
                        oTom.setprovincia   (rs.getString ("PROVINCIA"));
                        oTom.setdescProvincia(rs.getString("DESC_PROVINCIA"));
                        this.setoTomador    (oTom);
                    }
                }
                rs.close();
            }

           if (! bExiste) {
                setiNumError (-100);
                setsMensError ("NO EXISTE LA RAMA/NUMERO DE POLIZA INGRESADOS");
           } else if ( this.getestadoPoliza().equals("4")) {
                setiNumError (-200);
                setsMensError ("NO SE PUEDE PAGAR POR MERCADOPAGO PORQUE LA POLIZA ESTA ANULADA");
           } else if (this.getcodRama() == 21 && this.getcodSubRama() == 1 && this.getcodProducto() == 1 ) {
                setiNumError (-500);
                setsMensError ("EL PAGO DEBERIA INGRESAR POR AFIP - FORMULARIO 930");
           } else if ( procedencia.equals("PORTAL") && oTom != null &&  ! oTom.getnumDoc().equals(this.getnumDoc()) ) {
                setiNumError (-600);
                setsMensError ("EL NUM. DE DOCUMENTO O CUIT NO COINCIDE CON EL EMITIDO EN LA POLIZA");
           } else  if ( this.getimpSaldoPoliza() == 0 ) {
                setiNumError (-300);
                setsMensError ("LA POLIZA NO TIENE SALDO PENDIENTE DE PAGO");
           } else if ( ! this.getsCodFormaPago().equals("1") ) {
                setiNumError (-400);
                if ( this.getsCodFormaPago().equals("D") || this.getsCodFormaPago().equals("S") ) {
                    setsMensError ("LA POLIZA FUE EMITIDA CON DEBITO AUTOMATICO DE CUENTA ");
               } else if ( this.getsCodFormaPago().equals("T") ) {
                    setsMensError ("LA POLIZA FUE EMITIDA CON DEBITO AUTOMATICO DE TARJETA DE CREDITO");
               }
           }


        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
        } finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
            	setiNumError (-1);
                setsMensError (see.getMessage());
            }
            return this;
        }
    }

    public LinkedList getDBOperaciones ( Connection dbCon) {
        LinkedList lPol = new LinkedList();
        ResultSet rs = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("MP_GET_ALL_OPERACIONES (?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodRama());
            cons.setInt (3, this.getnumPoliza ());
            cons.setString (4, this.getprocedencia());

            cons.execute();

            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    Poliza oPol = new Poliza();
                    oPol.setcodRama         (rs.getInt("COD_RAMA"));
                    oPol.setdescRama        (rs.getString ("RAMA"));
                    oPol.setnumPoliza       (rs.getInt("NUM_POLIZA"));
                    oPol.setnumEndoso       (rs.getInt("ENDOSO"));
                    oPol.setfechaInicioVigenciaEnd  (rs.getDate ("FECHA_INI_VIG_END"));
                    oPol.setfechaFinVigenciaEnd     (rs.getDate ("FECHA_FIN_VIG_END"));
                    oPol.setimpTotalFacturado       (rs.getDouble ("IMP_PREMIO"));
                    oPol.setimpSaldoPoliza          (rs.getDouble ("SALDO_POLIZA_END"));

                    lPol.add(oPol);
                }
                rs.close();
            }
            cons.close();

        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
        } finally {
            try{
                if (rs != null ) rs.close ();
                if (cons != null) cons.close ();
            } catch (SQLException see) {
            	setiNumError (-1);
                setsMensError (see.getMessage());
            }
            return lPol;
        }
    }

    public Integer setDB (Connection dbCon) {

      try {
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall("MP_SET_MERCADOPAGO (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"));
            
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt    (2, this.getnumSecuMercadopago());
            cons.setInt    (3, this.getcodRama());
            cons.setInt    (4, this.getnumPoliza());
            cons.setString (5, this.getnumDoc());
            cons.setDouble (6, this.getimpTotalFacturado());
            cons.setInt    (7, this.getcodEstado());
            cons.setString (8, this.getstatus());
            cons.setString (9, this.getprocedencia());
            cons.setInt    (10, this.getopcionPago());
            cons.setString (11, this.getemail());
            cons.setString (12, this.getuserId());
            cons.setString (13, this.getidTransaccion());
            cons.setString (14, this.gettoken());
            cons.setString (15, this.getdescripcion());
            cons.setInt    (16, this.getcantCuotas());
            cons.setString (17, this.getmetodoPago());
            cons.setInt    (18, this.getcodBanco());
            cons.setString (19, this.getstatusDetail());
            cons.setString (20, this.getcode());
            cons.execute();

            this.setnumSecuMercadopago( cons.getInt (1));
            
            return numSecuMercadopago;
            
      }  catch (SQLException se) {
                this.setiNumError( -1 );
                this.setsMensError(se.getMessage());
        } catch (Exception e) {
                this.setiNumError(-1);
                this.setsMensError(e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                this.setiNumError( -1 );
                this.setsMensError(see.getMessage());
            }
        }
      
      	return null;
    }

    public MercadoPago getDB ( Connection dbCon) throws SurException {
        ResultSet rs = null;
        CallableStatement cons = null;
        boolean vExiste = false;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("MP_GET_MERCADOPAGO (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt(2, this.getnumSecuMercadopago());
            cons.execute();

            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    vExiste = true;
                    this.setcodRama     (rs.getInt ("COD_RAMA"));
                    this.setnumPoliza   (rs.getInt ("NUM_POLIZA"));
                    this.setnumDoc      (rs.getString ("NUM_DOC"));
                    this.setimpTotalFacturado (rs.getDouble("IMP_TOTAL"));
                    this.setcodEstado   (rs.getInt ("COD_ESTADO"));
                    this.setstatus      (rs.getString  ("STATUS"));
                    this.setfechaTrabajo(rs.getDate("FECHA_TRABAJO"));
                    this.sethoraOperacion(rs.getString ("HORA_TRABAJO"));
                    this.setuserId      (rs.getString ("USERID"));
                    this.setprocedencia (rs.getString ("PROCEDENCIA"));
                    this.setopcionPago  (rs.getInt ("OPCION_PAGO"));
                    this.setemail       (rs.getString ("EMAIL"));
                    this.setidTransaccion(rs.getString ("ID_TRANSACCION"));// External reference (id generado por nosotros)...
                    this.settoken       (rs.getString ("TOKEN"));
                    this.setdescripcion (rs.getString ("DESCRIPCION"));// Payment description (Descripcion del pago)...
                    this.setcantCuotas  (rs.getInt ("CANT_CUOTAS"));// Installments
                    this.setmetodoPago  (rs.getString ("METODO_PAGO"));// Payment method id (Visa, Master, etc)...
                    this.setcodBanco    (rs.getInt ("COD_BANCO"));// Issuer id (id del banco emisor de la tarjeta seleccionada)
                    this.setstatusDetail(rs.getString ("STATUS_DETAIL"));
                    this.setcode        (rs.getString ("CODE"));
                    this.setcodeMensaje(rs.getString ("CODE_MENSAJE"));
                    this.setstatusMensaje(rs.getString ("STATUS_MENSAJE"));
                }
                rs.close();
           }
            if ( vExiste == false) {
                setiNumError (-100);
                setsMensError ("REGISTRO DE MERCADOPAGO  INEXISTENTE");
            }

        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
        } finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) cons.close ();
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }
    
    public String getPaymentDataIssueMessage (Connection dbCon) {
    	
    	try {
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall("MP_MSG_DATA_ISSUE (?)"));
            
            cons.registerOutParameter(1, java.sql.Types.VARCHAR);
            cons.setString(2, this.getcode());
            cons.execute();

            return cons.getString(1);
            
      }  catch (SQLException se) {
                this.setiNumError( -1 );
                this.setsMensError(se.getMessage());
        } catch (Exception e) {
                this.setiNumError(-1);
                this.setsMensError(e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                this.setiNumError( -1 );
                this.setsMensError(see.getMessage());
            }
        }
      
      	return null;
    }
    
    
    public String getPaymentStatusMessage (Connection dbCon) {
                
    	try {
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall("MP_MSG_PAYMENT_STATUS (?,?)"));
            
            cons.registerOutParameter(1, java.sql.Types.VARCHAR);
            cons.setString(2, this.getstatus());
            cons.setString(3, this.getstatusDetail());
            cons.execute();
   
            return cons.getString(1);
            
      }  catch (SQLException se) {
                this.setiNumError( -1 );
                this.setsMensError(se.getMessage());
        } catch (Exception e) {
                this.setiNumError(-1);
                this.setsMensError(e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                this.setiNumError( -1 );
                this.setsMensError(see.getMessage());
            }
        }
      
      	return null;
    }

	@Override
	public String toString() {
		return "MercadoPago [numSecuMercadopago=" + numSecuMercadopago
				+ ", numDoc=" + numDoc + ", codEstado=" + codEstado
				+ ", procedencia=" + procedencia + ", opcionPago=" + opcionPago
				+ ", numPoliza=" + numPoliza + ", numEndoso=" + numEndoso
				+ ", numPropuesta=" + numPropuesta + ", fechaEmision="
				+ fechaEmision + ", fechaInicioVigencia=" + fechaInicioVigencia
				+ ", fechaFinVigencia=" + fechaFinVigencia + ", codRama="
				+ codRama + ", codSubRama=" + codSubRama + ", estadoPoliza="
				+ estadoPoliza + ", impTotalFacturado=" + impTotalFacturado
				+ ", impSaldoPoliza=" + impSaldoPoliza + ", impDeuda="
				+ impDeuda + ", codProd=" + codProd + ", numTomador="
				+ numTomador + ", cantVidas=" + cantVidas + ", userId="
				+ userId + ", fechaTrabajo=" + fechaTrabajo
				+ ", horaOperacion=" + horaOperacion + ", descRama=" + descRama
				+ ", descSubRama=" + descSubRama + ", descProductor="
				+ descProductor + ", tipoEndoso=" + tipoEndoso
				+ ", sDescTipoEndoso=" + sDescTipoEndoso + ", sCodFormaPago="
				+ sCodFormaPago + ", codProducto=" + codProducto + ", email="
				+ email + ", code=" + code + ", codeMensaje=" + codeMensaje
				+ ", status=" + status + ", statusDetail=" + statusDetail
				+ ", statusMensaje=" + statusMensaje + ", idTransaccion="
				+ idTransaccion + ", token=" + token + ", descripcion="
				+ descripcion + ", cantCuotas=" + cantCuotas + ", metodoPago="
				+ metodoPago + ", codBanco=" + codBanco + ", sMensError="
				+ sMensError + ", iNumError=" + iNumError + ", oTomador="
				+ oTomador + ", cons=" + cons + "]";
	}

}