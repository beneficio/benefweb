package com.business.beans;
   
import com.business.db.db;
import com.business.util.SurException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.LinkedList;

    
public class Preliq {

    private int  numPreliq = 0; 
    private Date fechaTrabajo  = null; 
    private String userid ="";
    private int codEstado = 0;
    private String codProdDc = "";
    private int codProd = 0;
    private int codOrg = 0;
    private int codZona = 0;
    private Date   fechaEnvioProd =null;
    private String horaEnvioProd = null;
    private String useridEnvioProd = null;
    private Date   fechaEnvioBenef = null;
    private String horaEnvioBenef = null;
    private String useridEnvioBenef ="";
    private int numLotePreliq=0;
    private String sMensError = "";
    private int    iNumError = 0;
    private LinkedList lPreliDet = null;
    private String codProdDesc ="";
    private String sDescEstado = "";
    private int iNumPreliqReem = 0;
    private String numDoc      = "";

    public Preliq(){
    }

    public int getCodEstado() {
        return codEstado;
    }

    public void setCodEstado(int codEstado) {
        this.codEstado = codEstado;
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

    public int getCodZona() {
        return codZona;
    }

    public void setCodZona(int codZona) {
        this.codZona = codZona;
    }

    public Date getFechaEnvioBenef() {
        return fechaEnvioBenef;
    }

    public void setFechaEnvioBenef(Date fechaEnvioBenef) {
        this.fechaEnvioBenef = fechaEnvioBenef;
    }

    public Date getFechaEnvioProd() {
        return fechaEnvioProd;
    }

    public void setFechaEnvioProd(Date fechaEnvioProd) {
        this.fechaEnvioProd = fechaEnvioProd;
    }

    public Date getFechaTrabajo() {
        return fechaTrabajo;
    }

    public void setFechaTrabajo(Date fechaTrabajo) {
        this.fechaTrabajo = fechaTrabajo;
    }

    public String getHoraEnvioBenef() {
        return horaEnvioBenef;
    }

    public void setHoraEnvioBenef(String horaEnvioBenef) {
        this.horaEnvioBenef = horaEnvioBenef;
    }

    public String getHoraEnvioProd() {
        return horaEnvioProd;
    }

    public void setHoraEnvioProd(String horaEnvioProd) {
        this.horaEnvioProd = horaEnvioProd;
    }

    public int getNumLotePreliq() {
        return numLotePreliq;
    }

    public void setNumLotePreliq(int numLotePreliq) {
        this.numLotePreliq = numLotePreliq;
    }

    public int getNumPreliq() {
        return numPreliq;
    }

    public void setNumPreliq(int numPreliq) {
        this.numPreliq = numPreliq;
    }

    public int getNumPreliqReem() {
        return iNumPreliqReem;
    }

    public void setNumPreliqReem (int numPreliq) {
        this.iNumPreliqReem = numPreliq;
    }

    public String getUserid() {
        return userid;
    }

    public void setUserid(String userid) {
        this.userid = userid;
    }

    public String getUseridEnvioBenef() {
        return useridEnvioBenef;
    }

    public void setUseridEnvioBenef(String useridEnvioBenef) {
        this.useridEnvioBenef = useridEnvioBenef;
    }

    public String getUseridEnvioProd() {
        return useridEnvioProd;
    }

    public void setUseridEnvioProd(String useridEnvioProd) {
        this.useridEnvioProd = useridEnvioProd;
    }

    public LinkedList getLPreliDet() {
        return lPreliDet;
    }

    public void setLPreliDet(LinkedList lPreliDet) {
        this.lPreliDet = lPreliDet;
    }

    public String getCodProdDesc() {
        return codProdDesc;
    }

    public void setCodProdDesc(String codProdDesc) {
        this.codProdDesc = codProdDesc;
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

    public String getsDescEstado() {
        return sDescEstado;
    }

    public void setsDescEstado (String param) {
        this.sDescEstado = param;
    }

    public String getnumDoc() {
        return numDoc;
    }

    public void setnumDoc (String param ) {
        this.numDoc = param;
    }
    
    public Preliq getDB  ( Connection dbCon ) throws SurException {
        ResultSet rs = null;
        CallableStatement cons = null;
        boolean bExiste   = false;
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("CO_GET_PRELIQ (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt(2, this.getNumPreliq());
            cons.execute();
            rs = (ResultSet) cons.getObject(1);
            if (rs != null ) {
                if (rs.next()) {
                    bExiste = true;
                    this.setNumPreliq       (rs.getInt("NUM_PRELIQ"));
                    this.setCodEstado       (rs.getInt("COD_ESTADO"));
	            this.setCodProdDc       (rs.getString("COD_PROD_DC"));
	            this.setCodProd         (rs.getInt("COD_PROD"));
                    this.setCodProdDesc     (rs.getString("COD_PROD_DESC"));
	            this.setCodOrg          (rs.getInt("COD_ORG"));
                    this.setCodZona         (rs.getInt("COD_ZONA"));
                    this.setFechaEnvioProd  (rs.getDate("FECHA_ENVIO_PROD"));
                    this.setHoraEnvioProd   (rs.getString("HORA_ENVIO_PROD"));
                    this.setUseridEnvioProd (rs.getString("USERID_ENVIO_PROD"));
                    this.setFechaEnvioBenef (rs.getDate("FECHA_ENVIO_BENEF"));
                    this.setHoraEnvioBenef  (rs.getString("HORA_ENVIO_BENEF"));
                    this.setUseridEnvioBenef(rs.getString("USERID_ENVIO_BENEF"));
                    this.setNumLotePreliq   (rs.getInt("NUM_LOTE_PRELIQ"));
                    this.setsDescEstado     (rs.getString("DESC_ESTADO"));
                    this.setNumPreliqReem   (rs.getInt ("NUM_PRELIQ_REEM"));
                    this.setnumDoc          (rs.getString ("DOCUMENTO"));
                }
                rs.close();
            }
            cons.close();

            if (! bExiste ) {
                this.setiNumError(-100);
                this.setsMensError("PRELIQUIDACION INEXISTENTE");
            }
        }  catch (SQLException se) {
            this.setiNumError(-1);
            this.setsMensError("Preliq[getDB]" + se.getMessage());
        } catch (Exception e) {
            this.setiNumError(-1);
            this.setsMensError("Preliq[getDB]" + e.getMessage());
        } finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    } //getDB

    public void getDBPreliqDet ( Connection dbCon, String sOrden ) throws SurException {
        LinkedList lPreliqDet = new LinkedList();
        ResultSet rs = null;
        CallableStatement cons = null;
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("CO_GET_PRELIQ_DET(?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2,this.getNumPreliq());
            cons.setString (3, sOrden);
            cons.execute();

            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {    
                    PreliqDet oPreliqDet = new PreliqDet();
                    oPreliqDet.setNumPreliq     (rs.getInt("NUM_PRELIQ"));
                    oPreliqDet.setCodRama       (rs.getInt("COD_RAMA"));
                    oPreliqDet.setCodRamaDesc   (rs.getString("RAMA"));
                    oPreliqDet.setNumPoliza     (rs.getInt("NUM_POLIZA"));
                    oPreliqDet.setEndoso        (rs.getInt("ENDOSO"));
                    oPreliqDet.setNumCuota      (rs.getInt("NUM_CUOTA"));
                    oPreliqDet.setFechaRec(rs.getDate ("FECHA_REC"));
                    oPreliqDet.setAsegurado     (rs.getString("ASEGURADO"));
                    oPreliqDet.setImpPrima      (rs.getDouble("IMP_PRIMA"));
                    oPreliqDet.setImpPremio     (rs.getDouble("IMP_PREMIO"));
                    oPreliqDet.setImpPremioPesos(rs.getDouble("IMP_PREMIO_PESOS"));
                    oPreliqDet.setImpPremioNeto(rs.getDouble("IMP_PREMIO_NETO"));
                    oPreliqDet.setImpComisBrutaProd(rs.getDouble("IMP_COMIS_BRUTA_PROD"));
                    oPreliqDet.setRenovadaPor   (rs.getInt("RENOVADA_POR"));
                    oPreliqDet.setMcaCobro      (rs.getString("MCA_COBRO"));
                    oPreliqDet.setNumFila       (rs.getInt("NUM_FILA"));
                    oPreliqDet.setHoraCobro     (rs.getString ("HORA_COBRO"));
                    oPreliqDet.setFechaCobro    (rs.getDate ("FECHA_COBRO"));
                    oPreliqDet.setUseridCobro   (rs.getString("USERID_COBRO") );
                    oPreliqDet.setOperacion     (rs.getString("OPERACION"));
                    oPreliqDet.setColor         (rs.getString ("COLOR"));
                    oPreliqDet.setFechaAseg     (rs.getDate ("FECHA_ASEG"));
                    lPreliqDet.add(oPreliqDet);
                }
                rs.close();
            }
        }  catch (SQLException se) {
            this.setiNumError(-1);
            this.setsMensError("Preliq[getDBPreliqDet]" + se.getMessage());
        } catch (Exception e) {
            this.setiNumError(-1);
            this.setsMensError("Preliq[getDBPreliqDet]" + e.getMessage());
        } finally {
            try{
                if (rs != null) { rs.close (); }
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                see.printStackTrace();                
                throw new SurException (see.getMessage());
            }
            this.setLPreliDet(lPreliqDet);
            
        }
    }



                
    public Preliq setDBCerrarPreliq (Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall("CO_SET_CIERRE_PRELIQ(?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt   (2, this.numPreliq);
            cons.setInt   (3, this.codProd);
            cons.setString(4, this.userid);
            cons.execute();

            int res =cons.getInt (1);

            if (res!= 0) {
                this.setiNumError(res);
                if (res == -100) {
                    this.setsMensError("NO PUEDE CERRAR LA PRELIQUIDACION PORQUE NO EXISTEN CUOTAS COBRADAS. ");
                } else {
                    this.setsMensError("ERROR AL CERRAR LA PRELIQUIDACION. ");
                }
            }

        }  catch (SQLException se) {
            se.printStackTrace();
            this.setiNumError(-1);
            this.setsMensError("Preliq[setDBCerrarPreliq ]" + se.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            this.setiNumError(-1);
            this.setsMensError("Preliq[setDBCerrarPreliq ]" + e.getMessage());

        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                see.printStackTrace();
                this.setiNumError(-1);
                this.setsMensError("Preliq[setDBCerrarPreliq ]" + see.getMessage());
            }
            return this;
        }
    }//setDBCerrarPreliq

    public Preliq setDBCambioEstado (Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall("CO_SET_CAMBIAR_ESTADO_PRELIQ(?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt   (2, this.numPreliq);
            cons.setInt   (3, this.codEstado);
            cons.setString(4, this.userid);
            cons.execute();

            int res =cons.getInt (1);

            this.setiNumError(0);

        }  catch (SQLException se) {
//            dbCon.rollback();
            this.setiNumError(-1);
            this.setsMensError("Preliq[setDBCerrarPreliq ]" + se.getMessage());
        } catch (Exception e) {
//            dbCon.rollback();
            this.setiNumError(-1);
            this.setsMensError("Preliq[setDBCerrarPreliq ]" + e.getMessage());

        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                this.setiNumError(-1);
                this.setsMensError("Preliq[setDBCerrarPreliq ]" + see.getMessage());
            }
            return this;
        }
    }//setDBCerrarPreliq
    
    public Preliq setDBRespuesta (Connection dbCon)  throws SurException {
        CallableStatement cons = null;
        try {
            dbCon.setAutoCommit(true);
            cons = dbCon.prepareCall(db.getSettingCall("CO_SET_PRELIQ_RESPUESTA (?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt   (2, this.numPreliq);
            cons.setString(3, this.userid);
            cons.execute();

            this.setiNumError(cons.getInt (1));

        }  catch (SQLException se) {
            this.setiNumError(-1);
            this.setsMensError("Preliq[setDBRespuesta]" + se.getMessage());
        } catch (Exception e) {
            this.setiNumError(-1);
            this.setsMensError("Preliq[setDBRespuesta]" + e.getMessage());

        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                this.setiNumError(-1);
                this.setsMensError("Preliq[setDBRespuesta]" + see.getMessage());
            }
            return this;
        }
    }//setDBRespuesta

    public Preliq getDBUltimaPreliq  ( Connection dbCon ) throws SurException {
        ResultSet rs = null;
        CallableStatement cons = null;
        boolean bExiste   = false;
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("CO_GET_ULTIMA_PRELIQ (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt(2, this.getCodProd());
            cons.execute();
            rs = (ResultSet) cons.getObject(1);
            if (rs != null ) {
                if (rs.next()) {
                    bExiste = true;
                    this.setNumPreliq       (rs.getInt("NUM_PRELIQ"));
                    this.setCodEstado       (rs.getInt("COD_ESTADO"));
	            this.setCodProdDc       (rs.getString("COD_PROD_DC"));
	            this.setCodProd         (rs.getInt("COD_PROD"));
                    this.setCodProdDesc     (rs.getString("COD_PROD_DESC"));
	            this.setCodOrg          (rs.getInt("COD_ORG"));
                    this.setCodZona         (rs.getInt("COD_ZONA"));
                    this.setFechaEnvioProd  (rs.getDate("FECHA_ENVIO_PROD"));
                    this.setHoraEnvioProd   (rs.getString("HORA_ENVIO_PROD"));
                    this.setUseridEnvioProd (rs.getString("USERID_ENVIO_PROD"));
                    this.setFechaEnvioBenef (rs.getDate("FECHA_ENVIO_BENEF"));
                    this.setHoraEnvioBenef  (rs.getString("HORA_ENVIO_BENEF"));
                    this.setUseridEnvioBenef(rs.getString("USERID_ENVIO_BENEF"));
                    this.setNumLotePreliq   (rs.getInt("NUM_LOTE_PRELIQ"));
                    this.setsDescEstado     (rs.getString("DESC_ESTADO"));
                    this.setNumPreliqReem   (rs.getInt ("NUM_PRELIQ_REEM"));
                }
                rs.close();
            }
            cons.close();

            if (! bExiste ) {
                this.setiNumError(-100);
                this.setsMensError("PRELIQUIDACION INEXISTENTE");
            }
        }  catch (SQLException se) {
            this.setiNumError(-1);
            this.setsMensError("Preliq[getDB]" + se.getMessage());
        } catch (Exception e) {
            this.setiNumError(-1);
            this.setsMensError("Preliq[getDB]" + e.getMessage());
        } finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    } //getDB

}
