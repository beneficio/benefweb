/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.business.util;
    
import com.business.db.db;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

public class ControlEnvioMail {
    private int    codEnvio = 0;
    private String usuarioDestino ="";
    private String mailDestino ="";
    private String MD5 ="";
    private String mcaEnviado ="";
    private Date   fechaEnviado=null;
    private Date   horaEnviado=null;
    private String mcaRespuesta ="N";
    private Date fechaRespuesta=null;
    private Date horaRespuesta=null;
    private String browser ="";
    private String version ="";
    private String OS ="";
    private String token="";

    private String sMensError  = "";
    private int    iNumError   = 0;

    public ControlEnvioMail(){};

    public int getCodEnvio() {
        return codEnvio;
    }

    public void setCodEnvio(int codEnvio) {
        this.codEnvio = codEnvio;
    }

    public String getUsuarioDestino() {
        return usuarioDestino;
    }

    public void setUsuarioDestino(String usuarioDestino) {
        this.usuarioDestino = usuarioDestino;
    }

    public String getMailDestino() {
        return mailDestino;
    }

    public void setMailDestino(String mailDestino) {
        this.mailDestino = mailDestino;
    }

    public String getMD5() {
        return MD5;
    }

    public void setMD5(String MD5) {
        this.MD5 = MD5;
    }

    public String getMcaEnviado() {
        return mcaEnviado;
    }

    public void setMcaEnviado(String mcaEnviado) {
        this.mcaEnviado = mcaEnviado;
    }

    public Date getFechaEnviado() {
        return fechaEnviado;
    }

    public void setFechaEnviado(Date fechaEnviado) {
        this.fechaEnviado = fechaEnviado;
    }

    public Date getHoraEnviado() {
        return horaEnviado;
    }

    public void setHoraEnviado(Date horaEnviado) {
        this.horaEnviado = horaEnviado;
    }

    public String getMcaRespuesta() {
        return mcaRespuesta;
    }

    public void setMcaRespuesta(String mcaRespuesta) {
        this.mcaRespuesta = mcaRespuesta;
    }

    public Date getFechaRespuesta() {
        return fechaRespuesta;
    }

    public void setFechaRespuesta(Date fechaRespuesta) {
        this.fechaRespuesta = fechaRespuesta;
    }

    public Date getHoraRespuesta() {
        return horaRespuesta;
    }

    public void setHoraRespuesta(Date horaRespuesta) {
        this.horaRespuesta = horaRespuesta;
    }

    public String getBrowser() {
        return browser;
    }

    public void setBrowser(String browser) {
        this.browser = browser;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getOS() {
        return OS;
    }

    public void setOS(String OS) {
        this.OS = OS;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }    

    public String getsMensError() {
        return sMensError;
    }

    public void setsMensError(String sMensError) {
        this.sMensError = sMensError;
    }

    public int getiNumError() {
        return iNumError;
    }

    public void setiNumError(int iNumError) {
        this.iNumError = iNumError;
    }  

    public ControlEnvioMail getDBbyEnvioAndMd5 ( Connection dbCon ) throws SurException {
        ResultSet rs = null;
        CallableStatement cons = null;
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("MAIL_VALID_GET_ENVIO_AND_MD5 (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt(2, this.getCodEnvio());
            cons.setString(3,this.getMD5());
            cons.execute();
            rs = (ResultSet) cons.getObject(1);
            int count = 0;
            if (rs != null ) {
                while (rs.next()) {
                    count++;
                    this.setCodEnvio(rs.getInt("COD_ENVIO"));
                    this.setUsuarioDestino(rs.getString("USUARIO_DESTINO"));
                    this.setMailDestino(rs.getString("MAIL_DESTINO"));
                    this.setMD5(rs.getString("MD5"));
                    this.setMcaEnviado(rs.getString("MCA_ENVIADO"));
                    this.setFechaEnviado(rs.getDate("FECHA_ENVIADO"));
                    this.setHoraEnviado(rs.getDate("HORA_ENVIADO"));
                    this.setMcaRespuesta(rs.getString("MCA_RESPUESTA"));
                    this.setFechaRespuesta(rs.getDate("FECHA_RESPUESTA"));
                    this.setHoraRespuesta(rs.getDate("HORA_RESPUESTA"));
                    this.setBrowser(rs.getString("BROWSER"));
                    this.setVersion(rs.getString("VERSION"));
                    this.setOS(rs.getString("OS"));
                }
                rs.close();
            }
            if (count!=1) {
                this.setiNumError (-1);
                String msg =(count==0)?"No se pudo recuperar los datos." : "Existe mas de una dato recuperado.";
                this.setsMensError("Se detecto un problema en el control de datos : " + msg );
                
            }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
            throw new SurException("Se detecto un problema en el control de datos : " + se.getMessage());
        } catch (Exception e) {
            setiNumError (-1);
            setsMensError (e.getMessage());
		    throw new SurException("Se detecto un problema en el control de datos : " + e.getMessage());
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


    public ControlEnvioMail updateDB ( Connection dbCon) throws SurException {
       CallableStatement proc = null;
       try {
            dbCon.setAutoCommit(true);
            proc = dbCon.prepareCall(db.getSettingCall("MAIL_VALID_UPDATE (?,?,?,?,?,?)"));
            proc.registerOutParameter   (1, java.sql.Types.INTEGER);
            proc.setInt   (2, this.getCodEnvio());
            proc.setString(3, this.getMD5()) ;
            proc.setString(4, this.getMcaRespuesta()) ;
            proc.setString(5, this.getBrowser()) ;
            proc.setString(6, this.getVersion()) ;
            proc.setString(7, this.getOS()) ;
            proc.execute();

            this.setCodEnvio( proc.getInt(1));
            proc.close();

       }  catch (SQLException se) {
		throw new SurException("Se detecto un problema en la actualización del control de datos : "+ se.getMessage());
        } catch (Exception e) {
		throw new SurException("Se detecto un problema en la actualización del control de datos : " + e.getMessage());
        } finally {
            try{
                if (proc != null) proc.close ();
            } catch (SQLException see) {
                this.setiNumError(-1);
                this.setsMensError("Se detecto un problema en la actualización del control de datos : " + see.getMessage());
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }

    //
    // -------------------------------------------------------------------------
    public ControlEnvioMail insertDB ( Connection dbCon) throws SurException {
            return insertDB(dbCon,"");
    }

    public ControlEnvioMail insertDB ( Connection dbCon, String _BASE) throws SurException {
       CallableStatement proc = null;
       try {
            dbCon.setAutoCommit(true);
            if (_BASE.equals("")) {
                proc = dbCon.prepareCall(db.getSettingCall("MAIL_VALID_INSERT (?,?,?,?)"));
            } else {
                proc = dbCon.prepareCall ( "{ ? = call \"" + _BASE + "\".\"MAIL_VALID_INSERT\" (?,?,?,?)}");
            }
            proc.registerOutParameter   (1, java.sql.Types.INTEGER);
            proc.setInt   (2, this.getCodEnvio());
            proc.setString(3, this.getUsuarioDestino());
            proc.setString(4, this.getMailDestino());
            proc.setString(5, this.getMD5()) ;
            proc.execute();

            this.setCodEnvio( proc.getInt(1));
            proc.close();

       }  catch (SQLException se) {
           this.setiNumError(-1);
           this.setsMensError("Se detecto un problema al agregar control de datos : " + se.getMessage());
		   throw new SurException("Se detecto un problema al agregar control de datos : "+ se.getMessage());
        } catch (Exception e) {
           this.setiNumError(-1);
           this.setsMensError("Se detecto un problema al agregar control de datos : " + e.getMessage());

		    throw new SurException("Se detecto un problema al agregar control de datos : " + e.getMessage());
        } finally {
            try{
                if (proc != null) proc.close ();
            } catch (SQLException see) {
                this.setiNumError(-1);
                this.setsMensError("Se detecto un problema al agregar control de datos : " + see.getMessage());
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }


}
