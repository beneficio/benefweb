package com.business.beans;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.util.Date;
import java.util.LinkedList;
import com.business.util.*;
import com.business.db.*;
import java.sql.Types;
        
public class OrdenPago {

    private int    codProd      = 0;       //"COD_PROD" integer,
    private int    codOrg       = 0;        //"COD_ORG" integer,
    private String tipoOrden    = "";  
    private Date   fechaFactura = null; 
    private String tipoFactura  = "";  
    private int    numOrden     = 0;
    private int    numSuc       = 0;
    private int    numFactura   = 0;
    private int    codEstado    = 0;
    private int    codErrorOP   = 0;
    private String userId;
    private Date fechaTrabajo;
    private String horaTrabajo;
    private String mcaFacturaFisica = "";
    private double impIvaCierre = 0;
    private double impNeto      = 0;
    private String beneficiario = "";
    private double impIva       = 0;
    private double impFactura   = 0;
    private double impOrdenPago = 0;
    private String cuit         = ""; 
    private String nomArchivoFactura;
    private String userIdAutoriza   = "";  
    private int    numSecuOp     = 0;
    private LinkedList <OrdenPagoDet> ldet = null;
    private String descErrorOP   = "";
    private String descEstado    = "";
    private String productor     = "";
    private String codProdDc     = "";
    private Date fechaEmision    = null;
    private String useridAnula   = null;
    private Date fechaAnula      = null;
    private String horaAnula     = null;
    private String sMensError = new String ();
    private int    iNumError = 0;
    private CallableStatement cons = null;
    private CallableStatement cons2 = null;

    public OrdenPago (){
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

    public String gettipoOrden () {
        return tipoOrden;
    }

    public void settipoOrden (String param) {
        this.tipoOrden = param;
    }

    public String getcuit() {
        return cuit;
    }

    public void setcuit(String cuit) {
        this.cuit = cuit;
    }

    public String getnomArchivoFactura() {
        return nomArchivoFactura;
    }

    public void setnomArchivoFactura(String nomArchivoFactura) {
        this.nomArchivoFactura = nomArchivoFactura;
    }

    public Date getfechaFactura() {
        return fechaFactura;
    }

    public void setfechaFactura (Date fechaFactura) {
        this.fechaFactura = fechaFactura;
    }

    public Date getfechaEmision() {
        return fechaEmision;
    }

    public void setfechaEmision (Date param) {
        this.fechaEmision = param;
    }
    
    public Date getfechaTrabajo() {
        return fechaTrabajo;
    }

    public void setfechaTrabajo (Date fecha) {
        this.fechaTrabajo = fecha;
    }

    public double getimpOrdenPago() {
        return impOrdenPago;
    }

    public void setimpOrdenPago(double impOrdenPago) {
        this.impOrdenPago = impOrdenPago;
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
    
    public double getimpIvaCierre() {
        return impIvaCierre;
    }

    public void setimpIvaCierre (double impIvaCierre) {
        this.impIvaCierre = impIvaCierre;
    }

    public double getimpNeto () {
        return impNeto;
    }

    public void setimpNeto (double impNeto) {
        this.impNeto = impNeto;
    }

    public String getbeneficiario() {
        return beneficiario;
    }

    public void setbeneficiario(String beneficiario) {
        this.beneficiario = beneficiario;
    }

    public String getcodProdDc () {
        return codProdDc;
    }

    public void setcodProdDc(String param) {
        this.codProdDc = param;
    }
    public String getdescEstado () {
        return descEstado;
    }

    public void setdescEstado(String param) {
        this.descEstado = param;
    }

    public String getproductor () {
        return productor;
    }

    public void setproductor (String param) {
        this.productor = param;
    }
    
    public String getuserIdAutoriza() {
        return userIdAutoriza;
    }

    public void setuserIdAutoriza(String userIdAutoriza) {
        this.userIdAutoriza = userIdAutoriza;
    }

    public String gettipoFactura() {
        return tipoFactura;
    }

    public void settipoFactura (String tipoFactura) {
        this.tipoFactura = tipoFactura;
    }

    public String getmcaFacturaFisica() {
        return mcaFacturaFisica;
    }

    public void setmcaFacturaFisica (String tipoFactura) {
        this.mcaFacturaFisica = tipoFactura;
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

    public void setnumSuc(int param) {this.numSuc = param;}
    public int getnumSuc () {return numSuc;}
    
    public void setnumFactura (int param) {this.numFactura = param;}
    public int getnumFactura () {return numFactura;}

    public void setcodEstado (int param) {this.codEstado = param;}
    public int getcodEstado () {return codEstado;}

    public void setcodErrorOP (int param) {this.codErrorOP = param;}
    public int getcodErrorOP () {return codErrorOP;}

    public String getuseridAnula() {
        return useridAnula;
    }

    public void setuseridAnula (String param) {
        this.useridAnula = param;
    }

    public String gethoraAnula() {
        return horaAnula;
    }

    public void sethoraAnula (String param) {
        this.horaAnula = param;
    }
    
    public Date getfechaAnula() {
        return fechaAnula;
    }

    public void setfechaAnula (Date param) {
        this.fechaAnula = param;
    }

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

    public String getuserId() {
        return userId;
    }

    public void setuserId(String userId) {
        this.userId = userId;
    }

    public LinkedList getDetalle() {
        return ldet;
    }

    public void setDetalle (LinkedList <OrdenPagoDet> ldet) {
        this.ldet = ldet;
    }

    public String getdescErrorOP () {
        return descErrorOP;
    }

    public void setdescErrorOP(String param) {
        this.descErrorOP = param;
    }
    
    public OrdenPago getDB ( Connection dbCon) throws SurException {
        ResultSet rs = null;
        ResultSet rs2 = null;
        boolean bExiste = false;
       try {           
           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall(db.getSettingCall("OP_GET_ORDEN_PAGO (?)"));
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt    (2, this.getNumSecuOp());

           cons.execute();

           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    bExiste = true;
                    this.settipoOrden     (rs.getString ("TIPO_ORDEN" ));
                    this.setnumOrden      (rs.getInt ("NUM_ORDEN" ));
                    this.settipoFactura   (rs.getString ("TIPO_FACTURA" ));
                    this.setnumSuc        (rs.getInt ("NUM_SUC" ));
                    this.setnumFactura    (rs.getInt ("NUM_FACTURA" ));
                    this.setmcaFacturaFisica(rs.getString ("MCA_FACTURA_FISICA" ));
                    this.setCodProd       (rs.getInt ("COD_PROD" ));
                    this.setcuit          (rs.getString ("CUIT" ));
                    this.setimpNeto       (rs.getDouble("IMP_NETO" ));
                    this.setimpIva        (rs.getDouble("IMP_IVA" ));
                    this.setimpOrdenPago  (rs.getDouble("IMP_ORDEN_PAGO" ));
                    this.setimpFactura    (rs.getDouble("IMP_FACTURA" ));
                    this.setuserId        (rs.getString ("USERID" ));
                    this.setfechaTrabajo  (rs.getDate("FECHA_TRABAJO" ));
                    //rs.getString ("HORA_TRABAJO" ));
                    this.setcodEstado     (rs.getInt ("COD_ESTADO" ));
                    this.setcodErrorOP    (rs.getInt ("COD_ERROR" ));
                    this.setimpIvaCierre  (rs.getDouble("IMP_IVA_CIERRE" ));
                    this.setnomArchivoFactura(rs.getString ("NOM_ARCHIVO_FACTURA" ));
                    this.setuserIdAutoriza(rs.getString ("USERID_AUTORIZA" ));
                    this.setnumSecuOp     (rs.getInt ("NUM_SECU_OP"));
                    this.setbeneficiario  (rs.getString ("BENEFICIARIO"));
                    this.setfechaFactura  (rs.getDate("FECHA_FACTURA"));
                    this.setdescErrorOP   (rs.getString ("DESC_ERROR"));
                    this.setcodProdDc     (rs.getString ("COD_PROD_DC"));
                    this.setCodOrg        (rs.getInt ("COD_ORG" ));
                    this.setfechaEmision  (rs.getDate ("FECHA_EMISION"));
                    this.setfechaAnula    (rs.getDate ("FECHA_ANULA"));
                    this.setuseridAnula   (rs.getString ("USERID_ANULA" ));
                    this.sethoraAnula     (rs.getString ("HORA_ANULA" ));
                }
                rs.close();
            }
            
           cons.close();
           
           if (bExiste == false ) {
               this.setiNumError(-100);
               this.setsMensError("OP INEXISTENTE");
           } else {

               
                dbCon.setAutoCommit(false);
                cons2 = dbCon.prepareCall(db.getSettingCall("OP_GET_ALL_ORDEN_PAGO_DET (?)"));
                cons2.registerOutParameter(1, java.sql.Types.OTHER);
                cons2.setInt    (2, this.getNumSecuOp());

                cons2.execute();

                rs2 = (ResultSet) cons2.getObject(1);
                 if (rs2 != null) {
                     
                     this.ldet = new <OrdenPagoDet> LinkedList ();
                     while (rs2.next()) {
                        OrdenPagoDet oDet = new OrdenPagoDet();
                        oDet.setnumSecuOp   (this.getNumSecuOp());
                        oDet.setnumItem     (rs2.getInt ("NUM_ITEM"));
                        oDet.setitem        (rs2.getString ("ITEM"));
                        oDet.setanioMes     (rs2.getInt ("ANIO_MES"));
                        oDet.setimpNeto     (rs2.getDouble ("IMPORTE"));
                        oDet.setcodProdDC   (rs2.getString ("COD_PROD_DC"));
                        ldet.add    (oDet);
                     }
                     rs2.close();
                 }

                cons2.close();
           }
           
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError ("Error OrdenPago [getDB]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError ("Error OrdenPago [getDB]" + e.getMessage());
        } finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) { cons.close (); }
                if (rs2 != null) rs2.close ();
                if (cons2 != null) { cons2.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }
    

    public LinkedList <CtaCteHis> getDBCtaCteHis ( Connection dbCon, int anioMesDesde, int anioMesHasta) throws SurException {
        ResultSet rs = null;
        LinkedList <CtaCteHis> lCtaCte = new LinkedList ();
       try {           
           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall(db.getSettingCall("OP_GET_ALL_CTACTE (?,?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setInt    (2, this.getNumSecuOp());
           cons.setString (3, this.getcodProdDc());
           cons.setInt    (4, anioMesDesde);
           cons.setInt    (5, anioMesHasta);

           cons.execute();

           rs = (ResultSet) cons.getObject(1);
           if (rs != null) {
                while (rs.next()) {
                    CtaCteHis oCC = new CtaCteHis ();
                    oCC.setCodProddDc(rs.getString ("COD_PROD_DC"));
                    oCC.setAnioMes   (rs.getInt    ("ANIO_MES"));
                    oCC.setImporte   (rs.getDouble ("IMPORTE"));
                    oCC.setConcepto  (rs.getString ("CONCEPTO"));
                    oCC.setMovimiento(rs.getString ("TIPO_MOV"));
                    oCC.setOrdene    (rs.getInt ("ORDENE"));
                    oCC.setFechaMov  (rs.getDate ("FECHA_MOV"));
                    
                    System.out.println (oCC.getConcepto());
                    
                    lCtaCte.add(oCC);
                }
                rs.close();
           }
           cons.close();
           
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError ("Error OrdenPago [getDBCtaCteHis]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError ("Error OrdenPago [getDBCtaCteHis]" + e.getMessage());
        } finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return lCtaCte;
        }
    }
    
    public void setDB (Connection dbCon) throws SurException {
    
      try {
           dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall( "OP_SET_ORDEN_PAGO ( ?,?,?, ?, ?, ?, ?, ?, ?, ?,?, ?,?,?,?,?,?,?,?,?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setString (2, this.gettipoOrden());
            cons.setInt    (3, this.getnumOrden());
            cons.setString (4, this.gettipoFactura());
            cons.setInt    (5, this.getnumSuc());
            cons.setInt    (6, this.getnumFactura());
            cons.setString (7, this.getmcaFacturaFisica());
            cons.setString (8, this.getcodProdDc());    
            cons.setString (9, this.getcuit());
            cons.setDouble  (10, this.getimpNeto());
            cons.setDouble (11, this.getimpIva());
            cons.setDouble (12, this.getimpOrdenPago());
            cons.setDouble (13, this.getimpFactura());
            cons.setString (14, this.getuserId());
            cons.setInt    (15, this.getcodEstado()); // 0: EN CARGA/ 1:ENVIADA? 2: AUTORIZADA/ 3:PROCESADA/ 4:PAGADA /5: ERROR
            cons.setInt    (16, this.getcodErrorOP());
            cons.setDouble (17, this.getimpIvaCierre());
            cons.setString (18, this.getnomArchivoFactura());
            cons.setString (19, this.getuserIdAutoriza());
            cons.setInt    (20, this.getNumSecuOp());
            cons.setString (21, this.getbeneficiario());
            cons.setDate   (22, Fecha.convertFecha(this.getfechaFactura()));
            cons.setString (23, this.getdescErrorOP() );
            if (this.getfechaEmision() == null ) {
                cons.setNull (24, java.sql.Types.DATE );
            } else {
                cons.setDate (24, Fecha.convertFecha(this.getfechaEmision() ));
            }
            
            cons.execute();
            
            this.setnumSecuOp(cons.getInt (1));
           
      }  catch (SQLException se) {
           this.setiNumError(-1);
           this.setsMensError("Error en OrdenPago [setDB]: " + se.getMessage());
        } catch (Exception e) {
           this.setiNumError(-1);
           this.setsMensError("Error en OrdenPago [setDB]: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }
    public void deleteDB (Connection dbCon) throws SurException {
    
      try {
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall( "OP_DEL_ORDEN_PAGO ( ?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt    (2, this.getNumSecuOp());
            cons.setString (3, this.getuserId());
            
            cons.execute();
            
            this.setiNumError(cons.getInt (1));
            if (this.getiNumError() == -100) {
                this.setsMensError("ORDEN DE PAGO INEXISTENTE O YA ANULADA");
            }
           
      }  catch (SQLException se) {
           this.setiNumError(-1);
           this.setsMensError("Error en OrdenPago [deleteDB]: " + se.getMessage());
        } catch (Exception e) {
           this.setiNumError(-1);
           this.setsMensError("Error en OrdenPago [deleteDB]: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }
    
    public void setDBConceptos (Connection dbCon, String codProdDC, int minAnioMes, int maxAnioMes ) throws SurException {
    
      try {
           dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall( "OP_SET_CONCEPTOS ( ?, ?, ?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt    (2, this.getNumSecuOp());
            cons.setInt    (3, minAnioMes);
            cons.setInt    (4, maxAnioMes);
            cons.setString (5, codProdDC); 
            
            cons.execute();
            
            this.setiNumError(cons.getInt (1));
           
      }  catch (SQLException se) {
           this.setiNumError(-1);
           this.setsMensError("Error en OrdenPago [setDBConceptos]: " + se.getMessage());
        } catch (Exception e) {
           this.setiNumError(-1);
           this.setsMensError("Error en OrdenPago [setDBConceptos]: " + e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }

}