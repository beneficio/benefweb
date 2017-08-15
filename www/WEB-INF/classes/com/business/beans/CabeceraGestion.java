//Title Bean Gestion Cabecera

package com.business.beans;
   
import java.util.Date;
import java.util.LinkedList;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.Types;
import java.sql.SQLException;  
import java.sql.CallableStatement;

import com.business.db.*;
import com.business.util.*;

public class CabeceraGestion{

private  String usuario	        = "";
private  Date   fecTrabajo      = null;
private  Date   fecEnvio        = null;
private  int    cantMailsEnviados = 0;
private  int    cantFilaArchivo = 0;
private String  titulo          = "";
private  int    codTexto	= 0;
private  int    codEstado	= 0;
private  int    codError	= 0;
private  int    codGestion	= 0;
private  int    codTemplate   	= 0;
private  String horaTrabajo	= "";
private  String horaEnvio     	= "";
private  String descEstado	= "";
private  String archivo		= "";
private  String strMensajeError = "";
private  String texto	  	= "";
private  String firma	  	= "";
private  String remitente 	= "";
private  String cco             = "";
private LinkedList lDetalle      = null;
private String password         = "";
private String usermail         = "";
private String tipoProceso      = null;
/*
|| Crea una  nueva instancia de la Cabecera de Gestion
*/
public CabeceraGestion() {
}
/*
||Definicion de los metos  setter.
*/
public void setHoraTrabajo(String param){this.horaTrabajo = param;}
public void  setHoraEnvio(String param ){this.horaEnvio = param;}
public void setUsuario(String param){this.usuario = param;}
public void setCodTemplate(int param ){this.codTemplate = param;}
public void setCodGestion(int param){this.codGestion = param;}
public void setFechaTrabajo(Date param){this.fecTrabajo = param;}
public void setFecEnvio(Date param){this.fecEnvio = param;}
public void setMailsEnviados(int param){this.cantMailsEnviados = param;}
public void setFilaArchivo(int param){this.cantFilaArchivo = param;}
public void setCodTexto(int param){this.codTexto = param ;}
public void setCodEstado(int param){this.codEstado = param;}
public  void setDescEstado(String param ){this.descEstado = param;}
public void setArchivo(String param){this.archivo = param;}
public  void setCodError(int param){this.codError = param;}
public void setMensajeError  (String param ){this.strMensajeError  = param ;}
public void setTexto   (String param ){this.texto  = param ;}
public void setRemitente (String param ){this.remitente  = param ;}
public void setFirma   (String param ){this.firma  = param ;}
public void setTitulo  (String param ){this.titulo  = param ;}
public void setcco  (String param ){this.cco  = param ;}
public void setpassword  (String param ){this.password  = param ;}
public void setusermail  (String param ){this.usermail  = param ;}
public void settipoProceso  (String param ){this.tipoProceso  = param ;}
/*
|| Definicion de los metos getter
*/
public int    getCodGestion    () {return this.codGestion;}
public String getUsuario       (){return this.usuario ;   }
public String getArchivo       () {return this.archivo;   }
public Date   getFecTrabajo    () {return this.fecTrabajo;}        
public Date   getFecEnvio      () {return  this.fecEnvio; }        
public int    getCodEstado     () {return this.codEstado; }
public int    getMailsEnviados () {return this.cantMailsEnviados;}
public int    getFilaArchivo   () {return this.cantFilaArchivo;}   
public int    getCodTemplate   (){return this.codTemplate;     }
public String getHoraTrabajo   (){return this.horaTrabajo;     }
public String getHoraEnvio     (){return this.horaEnvio;       }
public int    getCodTexto      () {return this.codTexto;       }
public String getDescEstado    () {return this.descEstado;     }
public int    getCodError      () {return this.codError  ;     }	  
public String getMensajeError  () {return this.strMensajeError;}
public String getTexto         () {return this.texto;}
public String getremitente     () {return this.remitente;}
public String getfirma         () {return this.firma;}
public String gettitulo        () {return this.titulo;}
public String getcco           () {return this.cco;}
public LinkedList getDetalle   () {return this.lDetalle;}
public String getpassword      () {return this.password;}
public String getusermail      () {return this.usermail;}
public String gettipoProceso   () {return this.tipoProceso;}

public void getDB ( Connection dbCon) throws SurException {
    CallableStatement cons = null;
    ResultSet rs = null;
    boolean bExiste = false;
    int iCodGestion = 0;
    try {
        iCodGestion = this.getCodGestion();
        dbCon.setAutoCommit(false);
        cons = dbCon.prepareCall(db.getSettingCall("CO_GET_GESTION(?,?,?)"));
        cons.registerOutParameter(1, java.sql.Types.OTHER);
        cons.setInt     (2, this.getCodGestion());
        cons.setString  (3, this.getUsuario());
        cons.setInt     (4, this.getCodTemplate());
        cons.execute();
            
        rs = (ResultSet) cons.getObject(1);
        if (rs != null) {
            while (rs.next()) {
                bExiste     = true;
                this.setCodGestion   (rs.getInt("COD_GESTION") );
                this.setFechaTrabajo (rs.getDate("FECHA_TRABAJO"));
                this.setFecEnvio     (rs.getDate("FECHA_ENVIO") );
                this.setMailsEnviados(rs.getInt("CANT_MAIL_ENVIADOS"));
                this.setFilaArchivo (rs.getInt("CANT_FILAS_ARCHIVO"));
                this.setCodTexto    (rs.getInt("COD_TEXTO") );
                this.setCodEstado   (rs.getInt("COD_ESTADO") );
                this.setDescEstado  (rs.getString("DESC_ESTADO") );
                this.setArchivo     (rs.getString("ARCHIVO") );
                this.setUsuario     (rs.getString("USUARIO"));
                this.setCodTemplate (rs.getInt("COD_TEMPLATE"));
                this.setHoraTrabajo (rs.getString("HORA_TRABAJO"));
                this.setHoraEnvio   (rs.getString ("HORA_ENVIO"));
                this.setTexto       (rs.getString ("TEXTO"));
                this.setRemitente   (rs.getString ("REMITENTE"));
                this.setFirma       (rs.getString ("FIRMA"));
                this.setTitulo      (rs.getString ("TITULO"));
                this.setcco         (rs.getString ("CCO"));
                this.setpassword    (rs.getString ("PASSWORD"));
                this.setusermail    (rs.getString ("USER_MAIL"));
                this.settipoProceso (rs.getString ("TIPO_PROCESO"));
            }

            rs.close();
            if (iCodGestion > 0 ) {
                if (! bExiste) {
                       setCodError (-100);
                       setMensajeError ("NO EXISTE LA CABECERA GESTION");
                } else {
//                    if (this.getCodEstado() == 1 || this.getCodEstado() == 3 ) {
                        this.getDBErrores (dbCon);
                        if (this.getCodError() < 0) {
                            throw new SurException (this.getMensajeError());
                        }
  //                  }
                    setCodError(0);
                }
            }
        }
        cons.close();
        }catch (SQLException se) {
            setCodError (-1);
            setMensajeError (se.getMessage());
        }catch (Exception e) {
            setCodError (-1);
            setMensajeError (e.getMessage());
        }finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }   
    }

public void getDBErrores ( Connection dbCon) throws SurException {
    CallableStatement cons = null;
    ResultSet rs = null;

    try {
        cons = dbCon.prepareCall(db.getSettingCall("CO_GET_ALL_GESTION_DET (?)"));
        cons.registerOutParameter(1, java.sql.Types.OTHER);
        cons.setInt     (2, this.getCodGestion());
        cons.execute();

        rs = (ResultSet) cons.getObject(1);
        if (rs != null) {
            this.lDetalle = new LinkedList ();
            while (rs.next()) {
                if (rs.getInt("COD_ESTADO") == 1) {
                    GestionCabDetalle oDet = new GestionCabDetalle();
                    oDet.setCodProd     (rs.getInt("COD_PROD"));
                    oDet.setCodProdDc   (rs.getString ("COD_PROD_DC"));
                    oDet.setCodOrg      (rs.getInt("COD_ORG"));
                    oDet.setNumPoliza   (rs.getInt("NUM_POLIZA"));
                    oDet.setEndoso      (rs.getInt("ENDOSO"));
                    oDet.setCodRama     (rs.getInt("COD_RAMA"));
                    oDet.setCodSubRama  (rs.getInt("COD_SUB_RAMA"));
                    oDet.setAsegurado   (rs.getString("ASEGURADO"));
                    oDet.setFechaUltPago(rs.getDate("FECHA_ULT_PAGO"));
                    oDet.setFechaVenc   (rs.getDate("FECHA_VENC"));
                    oDet.setNumCuota    (rs.getInt("NUM_CUOTA"));
                    oDet.setCodMon      (rs.getInt("COD_MON"));
                    oDet.setsSignoMon   (rs.getString ("SIGNO_MONEDA"));
                    oDet.setImpCuotaMes (rs.getDouble("IMP_CUOTA_MES"));
                    oDet.setImpCuotaVenc(rs.getDouble("IMP_CUOTA_VENC"));
                    oDet.setImpNetoRendir(rs.getDouble("IMP_NETO_RENDIR"));
                    oDet.setTotalCuotas (rs.getInt("TOTAL_CUOTAS"));
                    oDet.setEmail       (rs.getString("EMAIL"));
                    oDet.setDesEstado   (rs.getString ("DESC_ESTADO"));
                    oDet.setzona        (rs.getInt ("ZONA"));
                    oDet.setdescProductor(rs.getString ("RAZON_SOCIAL"));
                    oDet.setFila        (rs.getInt ("FILA"));
                    this.lDetalle.add   (oDet);
                }
            }
            rs.close();
        }
        cons.close();
        }catch (SQLException se) {
            setCodError (-1);
            setMensajeError (se.getMessage());
        }catch (Exception e) {
            setCodError (-1);
            setMensajeError (e.getMessage());
        }finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }

public void setDB( Connection dbCon)
        throws SurException {
    CallableStatement cons = null;
    try {
    dbCon.setAutoCommit(true);
    cons = dbCon.prepareCall(db.getSettingCall("CO_SET_CAB_GESTION(?,?,?,?,?,?,?,?)"));
    cons.registerOutParameter(1, java.sql.Types.INTEGER);
    cons.setInt   (2, getCodGestion() );
    cons.setString(3, getUsuario());
    if (getArchivo() == null ) {
        cons.setNull (4, Types.VARCHAR );
    } else {
        cons.setString(4, getArchivo());
    }
    cons.setInt   (5, getCodEstado());
    cons.setInt   (6, getMailsEnviados ());
    cons.setInt   (7, getFilaArchivo());
    cons.setInt   (8, getCodTexto());
    cons.setString (9, gettipoProceso());

    cons.execute();

    this.setCodGestion(cons.getInt(1));
    this.setCodError(0);

    } catch (SQLException se) {
        setCodError (-1);
        setMensajeError ("CabeceraGestion[setDB]: " + se.getMessage());
    } catch (Exception e) {
        setCodError (-1);
        setMensajeError ("CabeceraGestion[setDB]: " + e.getMessage());
    } finally {
        try{
            if (cons != null) cons.close ();
        } catch (SQLException see) {
        throw new SurException (see.getMessage());
        }
    }
}
public void setDBResetDetalle( Connection dbCon)
        throws SurException {
    CallableStatement cons = null;
    try {
    dbCon.setAutoCommit(true);
    cons = dbCon.prepareCall(db.getSettingCall("CO_RESET_DET_GESTION(?)"));
    cons.registerOutParameter(1, java.sql.Types.INTEGER);
    cons.setInt   (2, getCodGestion() );

    cons.execute();
    this.setCodError(cons.getInt(1));

    } catch (SQLException se) {
        setCodError (-1);
        setMensajeError ("CabeceraGestion[setDBResetDetalle]: " + se.getMessage());
    } catch (Exception e) {
        setCodError (-1);
        setMensajeError ("CabeceraGestion[setDBResetDetalle]: " + e.getMessage());
    } finally {
        try{
            if (cons != null) cons.close ();
        } catch (SQLException see) {
        throw new SurException (see.getMessage());
        }
    }
}

public void setDBGestionAutomatica ( Connection dbCon)
        throws SurException {
    CallableStatement cons = null;
    try {
    dbCon.setAutoCommit(true);
    cons = dbCon.prepareCall(db.getSettingCall("CO_PROCESAR_GESTION_AUTOMATICA(?)"));
    cons.registerOutParameter(1, java.sql.Types.INTEGER);
    cons.setInt   (2, getCodGestion() );

    cons.execute();
    this.setCodError(cons.getInt(1));

    } catch (SQLException se) {
        setCodError (-1);
        setMensajeError ("CabeceraGestion [setDBGestionAutomatica]: " + se.getMessage());
    } catch (Exception e) {
        setCodError (-1);
        setMensajeError ("CabeceraGestion [setDBGestionAutomatica]: " + e.getMessage());
    } finally {
        try{
            if (cons != null) cons.close ();
        } catch (SQLException see) {
        throw new SurException (see.getMessage());
        }
    }
}

}                