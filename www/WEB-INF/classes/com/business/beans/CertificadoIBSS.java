
package com.business.beans;

import com.business.db.db;
import com.business.util.Fecha;
import com.business.util.SurException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.LinkedList;


public class CertificadoIBSS {

    String tipoCertificado ="";
    int    codProd         = 0;
    Date   fechaEmision    = null;
    int    numCertificado  = 0;
    String razonSocial     = "";
    String codProdDC       = "";
    String cuit            = "";
    String domicilioCompleto="";
    String periodo = "";

    private LinkedList conceptosIBSS = null;
    private String sMensError = new String();
    private int    iNumError  = 0;

    public CertificadoIBSS (){
    }

    public String getCodProdDC() {
        return codProdDC;
    }

    public void setCodProdDC(String codProdDC) {
        this.codProdDC = codProdDC;
    }

    public String getCuit() {
        return cuit;
    }

    public void setCuit(String cuit) {
        this.cuit = cuit;
    }

    

    public String getDomicilioCompleto() {
        return domicilioCompleto;
    }

    public void setDomicilioCompleto(String domicilioCompleto) {
        this.domicilioCompleto = domicilioCompleto;
    }

    public int getNumCertificado() {
        return numCertificado;
    }

    public void setNumCertificado(int numCertificado) {
        this.numCertificado = numCertificado;
    }

    public String getRazonSocial() {
        return razonSocial;
    }

    public void setRazonSocial(String razonSocial) {
        this.razonSocial = razonSocial;
    }

    public LinkedList getConceptosIBSS() {
        return conceptosIBSS;
    }

    public void setConceptosIBSS(LinkedList conceptosIBSS) {
        this.conceptosIBSS = conceptosIBSS;
    }

    public int getCodProd() {
        return codProd;
    }

    public void setCodProd(int codProd) {
        this.codProd = codProd;
    }

    public Date getFechaEmision() {
        return fechaEmision;
    }

    public void setFechaEmision(Date fechaemision) {
        this.fechaEmision = fechaemision;
    }

    public String getTipoCertificado() {
        return tipoCertificado;
    }

    public void setTipoCertificado(String tipoCertificado) {
        this.tipoCertificado = tipoCertificado;
    }

    public String getPeriodo() {
        return periodo;
    }

    public void setPeriodo(String periodo) {
        this.periodo = periodo;
    }

    

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



    public CertificadoIBSS getDB ( Connection dbCon) throws SurException {
        ResultSet rs = null;
        CallableStatement cons = null;
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("CE_GET_CERTIFICADO_IBSS (?, ? )"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            if ( this.getTipoCertificado()== null ) {
                cons.setNull    (2, java.sql.Types.VARCHAR);
            } else {
                cons.setString(2, this.getTipoCertificado() );
            }
            cons.setInt     (3, this.getNumCertificado());
            cons.execute();      
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    this.setCodProd(rs.getInt("COD_PROD"));
                    this.setFechaEmision(rs.getDate("FECHA_EMISION"));
                    this.setPeriodo(rs.getString("PERIODO"));
                    this.setNumCertificado (rs.getInt("NUM_CERTIFICADO"));
                    this.setRazonSocial(rs.getString ("RAZON_SOCIAL"));
                    this.setCodProdDC(rs.getString ("COD_PROD_DC"));
                    this.setCuit(rs.getString ("CUIT"));
                    this.setDomicilioCompleto(rs.getString ("DOMICILIO_COMPLETO"));
                }
                rs.close();
            }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		        throw new SurException("Error Sql : " + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		        throw new SurException("Error : " + e.getMessage());
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

    public CertificadoIBSS getDB ( Connection dbCon, String pTipoCertificado ,String pCodProd , Date pFechaEmision) throws SurException {
        ResultSet rs = null;
        CallableStatement cons = null;
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("CE_GET_CERTIFICADO_IBSS (?, ? , ?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            this.setTipoCertificado(pTipoCertificado);
            this.setCodProdDC(pCodProd);
            this.setFechaEmision(pFechaEmision);
            if ( this.getTipoCertificado()== null ) {
                cons.setNull    (2, java.sql.Types.VARCHAR);
            } else {
                cons.setString(2, this.getTipoCertificado() );
            }
            cons.setString     (3, this.getCodProdDC());
            if ( this.getFechaEmision()== null ) {
                cons.setNull    (4, java.sql.Types.DATE);
            } else {
                cons.setDate(4, Fecha.convertFecha(this.getFechaEmision()) );
            }
            cons.execute();
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    this.setCodProd(rs.getInt("COD_PROD"));
                    this.setFechaEmision(rs.getDate("FECHA_EMISION"));
                    this.setPeriodo(rs.getString("PERIODO"));
                    this.setNumCertificado (rs.getInt("NUM_CERTIFICADO"));
                    this.setRazonSocial(rs.getString ("RAZON_SOCIAL"));
                    this.setCodProdDC(rs.getString ("COD_PROD_DC"));
                    this.setCuit(rs.getString ("CUIT"));
                    this.setDomicilioCompleto(rs.getString ("DOMICILIO_COMPLETO"));
                }
                rs.close();
            }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Sql : " + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error : " + e.getMessage());
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

    public CertificadoIBSS getDBConceptos ( Connection dbCon) throws SurException {
        ResultSet rs           = null;
        CallableStatement cons = null;
        this.conceptosIBSS = new LinkedList();
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("CE_GET_ALL_CONCEPTO_IBSS (?, ? )"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            if ( this.getTipoCertificado()== null ) {
                cons.setNull    (2, java.sql.Types.VARCHAR);
            } else {
                cons.setString(2, this.getTipoCertificado() );
            }
            cons.setInt     (3, this.getNumCertificado());
            cons.execute();
            rs = (ResultSet) cons.getObject(1);

            if (rs != null) {
                while (rs.next()) {
                    Concepto oConcepto = new Concepto();                    
                    oConcepto.setTipoCertificado(rs.getString("TIPO_CERTIFICADO"));
                    oConcepto.setNumCertificado(rs.getInt("NUM_CERTIFICADO"));
                    oConcepto.setCodConcepto(rs.getInt("COD_CONCEPTO"));
                    oConcepto.setOrden(rs.getInt("ORDEN"));
                    oConcepto.setTexto(rs.getString("TEXTO"));
                    this.conceptosIBSS.add(oConcepto);
                }
                rs.close();
            }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		        throw new SurException("Error Sql : " + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		        throw new SurException("Error : " + e.getMessage());
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
