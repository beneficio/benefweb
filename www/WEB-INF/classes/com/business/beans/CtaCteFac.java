package com.business.beans;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.util.Date;
import com.business.util.*;
import com.business.db.*;
     
import com.google.gson.annotations.Expose;


public class CtaCteFac {

    private int    codProd      = 0;       //"COD_PROD" integer,
    private int    codOrg       = 0;        //"COD_ORG" integer,
    private String codProdDc    = "";   // "COD_PROD_DC" character varying(10),
@Expose    
    private Date   fechaMov     = null; //"FECHA_MOV" date,
    private String operacion    = "";         //"TIPCOM" integer,
@Expose    
    private int    numOrden     = 0;         //"numOrden" integer,
    private String estado       = "";    //"OPERACION" integer, -- 1: DEBE - 2: HABER
    private double importe      = 0;    // "IMPORTE" double precision,
    private double importeMon   = 0;    // "IMPORTE_MON" double precision,
    private String beneficiario = "";   // "beneficiario" character varying(6),
    private double impIva       = 0;    // "PORC_SOC" double precision, -- PORC. SERVICIO SOCIALES
@Expose    
    private double impFactura   = 0;
    private double impTotal     = 0;    // "IMP_SOC" double precision, -- IMPORTE SERVICIOS SOCIALES
@Expose    
    private String tipoComprob  = "";   // "CONCEPTO" character varying(100),
    private String numComprob1  = "";   // "DETALLE_OP" character varying(1),
    private String numComprob2  = "";   // "NRO_CUIT" character varying(11),
    private int    numSecuOp    = 0;
    private int    anioMes      = 0;  
    private int    codEstadoOP  = 0;
@Expose    
    private Date fechaFactura    = null;
@Expose
    private String sMensError = new String ();
@Expose
    private int    iNumError = 0;
    private CallableStatement cons = null;

    private String estadoPago  = "";
    private double brutoFactura = 0;
    private double netoAPagar = 0;
    
    public CtaCteFac (){
    }


    public int getCodOrg() {
        return codOrg;
    }

    public void setCodOrg(int codOrg) {
        this.codOrg = codOrg;
    }

    public int getCodProd() {
        return codProd;
    }

    public void setCodProd(int codProd) {
        this.codProd = codProd;
    }

    public String getCodProdDc() {
        return codProdDc;
    }

    public void setCodProdDc(String codProdDc) {
        this.codProdDc = codProdDc;
    }

    public String gettipoComprob() {
        return tipoComprob;
    }

    public void settipoComprob(String tipoComprob) {
        this.tipoComprob = tipoComprob;
    }

    public String getnumComprob1() {
        return numComprob1;
    }

    public void setnumComprob1(String numComprob1) {
        this.numComprob1 = numComprob1;
    }

    public Date getFechaMov() {
        return fechaMov;
    }

    public void setFechaMov(Date fechaMov) {
        this.fechaMov = fechaMov;
    }

    public Date getfechaFactura() {
        return fechaFactura;
    }

    public void setfechaFactura (Date param) {
        this.fechaFactura = param;
    }

    public double getimpTotal() {
        return impTotal;
    }

    public void setimpTotal(double impTotal) {
        this.impTotal = impTotal;
    }

    public double getimpFactura() {
        return impFactura;
    }

    public void setimpFactura(double imp) {
        this.impFactura = imp;
    }

    public void setnumSecuOp (int imp) {
        this.numSecuOp = imp;
    }
    
    public double getImporte() {
        return importe;
    }

    public void setImporte(double importe) {
        this.importe = importe;
    }

    public double getImporteMon() {
        return importeMon;
    }

    public void setImporteMon(double importeMon) {
        this.importeMon = importeMon;
    }


    public String getbeneficiario() {
        return beneficiario;
    }

    public void setbeneficiario(String beneficiario) {
        this.beneficiario = beneficiario;
    }

    public String getnumComprob2() {
        return numComprob2;
    }

    public void setnumComprob2(String numComprob2) {
        this.numComprob2 = numComprob2;
    }

    public String getOperacion() {
        return operacion;
    }

    public void setOperacion(String operacion) {
        this.operacion = operacion;
    }

    public String getestado() {
        return estado;
    }

    public void setestado (String operacion) {
        this.estado = operacion;
    }

    public double getimpIva() {
        return impIva;
    }

    public void setimpIva(double impIva) {
        this.impIva = impIva;
    }

    public int getnumOrden() {
        return numOrden;
    }

    public void setnumOrden(int numOrden) {
        this.numOrden = numOrden;
    }

    public int getNumSecuOp () {
        return numSecuOp;
    }

    public void setanioMes(int param) {
        this.anioMes = param;
    }

    public int getanioMes () {
        return anioMes;
    }

    public void setcodEstadoOP (int param) {
        this.codEstadoOP = param;
    }

    public int getcodEstadoOP () {
        return codEstadoOP;
    }
    
    //
    // Error
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

    public String getestadoPago () {
        return this.estadoPago ;
    }
    public void setestadoPago (String param ) {
        this.estadoPago  = param ;
    }
    
    public double getbrutoFactura() {
        return brutoFactura;
    }

    public void setbrutoFactura(double param) {
        this.brutoFactura = param;
    }
    public double getnetoAPagar() {
        return netoAPagar;
    }

    public void setnetoAPAgar(double param) {
        this.netoAPagar = param;
    }
    
    public CtaCteFac getDB ( Connection dbCon, String userid) throws SurException {
        ResultSet rs = null;
        boolean bExiste = false;
       try {
           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall(db.getSettingCall("CC_GET_CTACTE_FA (?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setDate   (2, Fecha.convertFecha(this.getFechaMov()));
           cons.setInt    (3, this.getCodProd());
           cons.setInt    (4, this.getCodOrg());
           cons.setString (5, userid);

           cons.execute();

           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    bExiste     = true;
                    this.setCodOrg(rs.getInt ("COD_ORG"));
                    this.setCodProd  (rs.getInt ("COD_PROD"));
                    this.setCodProdDc(rs.getString ("COD_PROD_DC"));
                    this.setFechaMov (rs.getDate ("FECHA"));
                    this.setImporte  (rs.getDouble("IMP_BASE"));
                    this.setimpIva   (rs.getDouble("IMP_IVA"));
                    this.setimpTotal (rs.getDouble("IMP_TOTAL"));
                }
                rs.close();
            }
           cons.close();
           if (! bExiste) {
                setiNumError (-100);
                setsMensError ("INFORMACION INEXISTENTE");
           }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error CtaCteFac [getDB]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error CtaCteFac [getDB]" + e.getMessage());
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
    
    public CtaCteFac getDBUltimaFactura ( Connection dbCon) throws SurException {
        ResultSet rs = null;
        boolean bExiste = false;
       try {   
           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall(db.getSettingCall("CC_GET_ULTIMA_FACT_CTACTE (?)"));
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setString (2, this.getCodProdDc());

           cons.execute();

           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    bExiste     = true;
                    this.setCodProdDc(rs.getString("COD_PROD_DC"));
                    this.setCodProd(rs.getInt("COD_PROD"));
                    this.setCodOrg(rs.getInt("COD_ORG"));
                    this.setbeneficiario(rs.getString("BENEFICIARIO"));
                    this.setFechaMov(rs.getDate("FECHA"));
                    this.setnumOrden(rs.getInt("NUM_ORDEN"));
                    this.setOperacion(rs.getString("OPERACION"));
                    this.setImporte(rs.getDouble("IMP_BASE"));
                    this.setimpIva(rs.getDouble("IMP_IVA"));
                    this.setimpTotal(rs.getDouble("IMP_TOTAL"));
                    this.setimpFactura(rs.getDouble("IMP_FACTURA"));
                    this.setestado(rs.getString("ESTADO"));
                    this.settipoComprob(rs.getString("TIPO_COMP"));
                    this.setnumComprob1(rs.getString("NUM_FACT1"));
                    this.setnumComprob2(rs.getString("NUM_FACT2"));
                    this.setnumSecuOp (rs.getInt ("NUM_SECU_OP"));
                    this.setanioMes (rs.getInt ("ANIO_MES"));
                }
                rs.close();
            }
           cons.close();
           if (! bExiste) {
                setiNumError (-100);
                setsMensError ("INFORMACION INEXISTENTE");
           }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error CtaCteFac [getDB]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error CtaCteFac [getDB]" + e.getMessage());
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

    
    public CtaCteFac getDBExisteComprobante ( Connection dbCon, String sCuit, String sUser) throws SurException {
        ResultSet rs = null;
        boolean bExiste = false;
       try {   
           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall(db.getSettingCall("CC_GET_EXISTE_COMPROBANTE (?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setString (2, this.getnumComprob1());
           cons.setString (3, this.getnumComprob2());
           cons.setString (4, sCuit); 
           cons.setString (5, sUser); 

           cons.execute();

           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    bExiste     = true;
                    this.setCodProdDc(rs.getString("COD_PROD_DC"));
                    this.setFechaMov(rs.getDate("FECHA"));
                    this.setnumOrden(rs.getInt("NUM_ORDEN"));
                    this.setimpFactura(rs.getDouble("IMP_TOTAL"));
                    this.settipoComprob(rs.getString("TIPO_COMP"));
                    this.setnumSecuOp (rs.getInt ("NUM_SECU_OP"));
                    this.setfechaFactura (rs.getDate("FECHA_FACTURA"));
                }
                rs.close();
            }
           cons.close();
           if (! bExiste) {
                setiNumError (-100);
                setsMensError ("FACTURA INEXISTENTE");
           }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error CtaCteFac [getDBExisteComprobante]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error CtaCteFac [getDBExisteComprobante]" + e.getMessage());
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

    public CtaCteFac getDBExisteFactura ( Connection dbCon, String sCuit, String sUser) throws SurException {
        ResultSet rs = null;
        boolean bExiste = false;
       try {   
           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall(db.getSettingCall("CC_GET_EXISTE_FACTURA (?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setString (2, this.getnumComprob1());
           cons.setString (3, this.getnumComprob2());
           cons.setString (4, sCuit); 
           cons.setString (5, sUser); 

           cons.execute();

            setiNumError (cons.getInt (1));
            if (getiNumError() == -100) {
                setsMensError ("FACTURA INEXISTENTE");
            }

           cons.close();
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError ("Error CtaCteFac [getDBExisteComprobante]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError ("Error CtaCteFac [getDBExisteComprobante]" + e.getMessage());
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
