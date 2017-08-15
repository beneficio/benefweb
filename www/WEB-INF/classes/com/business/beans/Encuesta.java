/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
      
package com.business.beans;

import java.util.Date;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import com.business.db.*;
import com.business.util.*;
import java.util.LinkedList;

public class Encuesta {

    private int    numEncuesta = 0;
    private String titulo = "";
    private String codEstado ="";
    private Date   fechaDesde=null;
    private Date   fechaHasta=null;
    private Date   fechaTrabajo=null;
    private Date   horaTrabajo= null;
    private int    cantPregunta =0;
    private String descripcion ="";
    int tipoUsuario = 0;
    private LinkedList lUsuariosAvisoMail   = null;
    private LinkedList lPregunta = null;
    private String nombreTemplate ="";
    private String template ="";
    private String linkTemplate ="";

    private String sMensError           = "";
    private int    iNumError              = 0;

    public Encuesta(){ }
 
    public int getCantPregunta() {
        return cantPregunta;
    }

    public void setCantPregunta(int cantPregnta) {
        this.cantPregunta = cantPregnta;
    }

    public String getCodEstado() {
        return codEstado;
    }

    public void setCodEstado(String codEstado) {
        this.codEstado = codEstado;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public Date getFechaDesde() {
        return fechaDesde;
    }

    public void setFechaDesde(Date fechaDesde) {
        this.fechaDesde = fechaDesde;
    }

    public Date getFechaHasta() {
        return fechaHasta;
    }

    public void setFechaHasta(Date fechaHasta) {
        this.fechaHasta = fechaHasta;
    }

    public Date getFechaTrabajo() {
        return fechaTrabajo;
    }

    public void setFechaTrabajo(Date fechaTrabajo) {
        this.fechaTrabajo = fechaTrabajo;
    }

    public Date getHoraTrabajo() {
        return horaTrabajo;
    }

    public void setHoraTrabajo(Date horaTrabajo) {
        this.horaTrabajo = horaTrabajo;
    }


    public int getTipoUsuario() {
        return tipoUsuario;
    }

    public void setTipoUsuario(int tipoUsuario) {
        this.tipoUsuario = tipoUsuario;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public int getNumEncuesta() {
        return numEncuesta;
    }

    public void setNumEncuesta(int numEncuesta) {
        this.numEncuesta = numEncuesta;
    }

    public LinkedList getLUsuariosAvisoMail() {
        return lUsuariosAvisoMail;
    }

    public void setLUsuariosAvisoMail(LinkedList lUsuariosAvisoMail) {
        this.lUsuariosAvisoMail = lUsuariosAvisoMail;
    }

    public LinkedList getLPregunta() {
        return lPregunta;
    }

    public void setLPregunta(LinkedList lPregunta) {
        this.lPregunta = lPregunta;
    }

    public String getLinkTemplate() {
        return linkTemplate;
    }

    public void setLinkTemplate(String linkTemplate) {
        this.linkTemplate = linkTemplate;
    }

    public String getNombreTemplate() {
        return nombreTemplate;
    }

    public void setNombreTemplate(String nombreTemplate) {
        this.nombreTemplate = nombreTemplate;
    }

    public String getTemplate() {
        return template;
    }

    public void setTemplate(String template) {
        this.template = template;
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

    public Encuesta getDB ( Connection dbCon ) throws SurException {
        ResultSet rs = null;
        CallableStatement cons = null;
        try {

            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("ENC_GET_ENCUESTA_BY_NUMERO (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt(2, this.getNumEncuesta());
            cons.execute();
            rs = (ResultSet) cons.getObject(1);
            int count = 0;
            if (rs != null ) {
                if (rs.next()) {
                    count++;
                    this.setNumEncuesta( rs.getInt ("NUM_ENCUESTA"));
                    this.setTitulo( rs.getString("TITULO"));
                    this.setCodEstado(rs.getString("COD_ESTADO"));
                    this.setFechaDesde(rs.getDate("FECHA_DESDE"));
                    this.setFechaHasta(rs.getDate("FECHA_HASTA"));
                    this.setFechaTrabajo(rs.getDate("FECHA_TRABAJO"));
                    this.setHoraTrabajo(rs.getDate("HORA_TRABAJO"));
                    this.setCantPregunta( rs.getInt ("CANT_PREGUNTA"));
                    this.setDescripcion(rs.getString("DESCRIPCION"));
                    this.setTipoUsuario( rs.getInt ("TIPO_USUARIO"));                    
                }
                rs.close();
            }
            if (count!=1) {
                this.setiNumError (-1);
                String msg =(count==0)?"No se pudo recuperar la Encuesta Num." : "Existe mas de una Encuesta con el Num.";
                this.setsMensError("Error Encuesta[getDb] " + msg + " : " + this.getNumEncuesta());
                this.setNumEncuesta(0);
            }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Encuesta [getDBbyProcessByNro]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		    throw new SurException("Error Encuesta [getDBbyProcessByNro]" + e.getMessage());
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


    public LinkedList getDBPreguntas ( Connection dbCon) throws SurException {
        LinkedList lPregunta = new LinkedList();
        ResultSet rs = null;
        CallableStatement cons = null;
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("ENC_GET_PREGUNTAS (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getNumEncuesta());
            cons.execute();

            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    EncuestaPregunta oEncPreg = new EncuestaPregunta();
                    oEncPreg.setNumEncuesta( rs.getInt("NUM_ENCUESTA"));
                    oEncPreg.setNumPregunta( rs.getInt("NUM_PREGUNTA"));
                    oEncPreg.setPregunta(rs.getString("PREGUNTA"));
                    oEncPreg.setMultipleChoise(rs.getString("MULT_CHOISE"));
                    oEncPreg.setCantOpcion(rs.getInt("CANT_OPC"));
                    oEncPreg.setFechaTrabajo(rs.getDate("FECHA_TRABAJO"));
                    oEncPreg.setUserId(rs.getString("USERID"));                   
                    oEncPreg.setLOpcion(oEncPreg.getDBOpciones(dbCon));                    
                    lPregunta.add(oEncPreg);
                }
                rs.close();
            }

        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Encuesta [getDBPreguntas]" + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error Encuesta [getDBPreguntas]" + e.getMessage());
        } finally {
            try{
                if (rs != null) { rs.close (); }
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return lPregunta;
        }
    }

    // -------------------------------------------------------------------------
    public static Encuesta getDBbyProcessDate ( Connection dbCon , java.util.Date pFechaProceso )
        throws SurException {
        return Encuesta.getDBbyProcessDate ( dbCon , "", pFechaProceso );
    }
    // Se usa en el main IntEnviarEncuesta
    public static Encuesta getDBbyProcessDate ( Connection dbCon , String _BASE , java.util.Date pFechaProceso )
        throws SurException {
        ResultSet rs = null;
        CallableStatement cons = null;
        Encuesta encuesta = null;
        int cantEncuesta = 0;
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("ENC_GET_ENCUESTA_A_PROCESAR (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setDate(2, Fecha.convertFecha(pFechaProceso));
            cons.execute();
            rs = (ResultSet) cons.getObject(1);
            encuesta = new Encuesta();
            if (rs != null) {
                while (rs.next()) {
                    cantEncuesta++;
                    encuesta.setNumEncuesta( rs.getInt ("NUM_ENCUESTA"));
                    encuesta.setTitulo( rs.getString("TITULO"));
                    encuesta.setCodEstado(rs.getString("COD_ESTADO"));
                    encuesta.setFechaDesde(rs.getDate("FECHA_DESDE"));
                    encuesta.setFechaHasta(rs.getDate("FECHA_HASTA"));
                    encuesta.setFechaTrabajo(rs.getDate("FECHA_TRABAJO"));
                    encuesta.setHoraTrabajo(rs.getDate("HORA_TRABAJO"));
                    encuesta.setCantPregunta( rs.getInt ("CANT_PREGUNTA"));
                    encuesta.setDescripcion(rs.getString("DESCRIPCION"));
                    encuesta.setTipoUsuario( rs.getInt ("TIPO_USUARIO"));
                    // Campos template
                    encuesta.setNombreTemplate(rs.getString("NOM_TEMPLATE"));
                    encuesta.setTemplate(rs.getString("TEMPLATE"));
                    encuesta.setLinkTemplate(rs.getString("LINK_TEMPLATE"));
                }
            }
            if (cantEncuesta!=1) {
                String msgError = (cantEncuesta==0?"No exite la encuesta":"Existe mas de una encuesta");
                encuesta.setiNumError (-1);
                encuesta.setsMensError (msgError);
                throw new SurException (msgError);
            }
        }  catch (SQLException se) {
                encuesta.setiNumError (-1);
                encuesta.setsMensError (se.getMessage());
                throw new SurException (se.getMessage());
        } catch (Exception e) {
                encuesta.setiNumError (-1);
                encuesta.setsMensError (e.getMessage());
                throw new SurException (e.getMessage());
        } finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return encuesta;
        }
    } //getDBbyProcessDate



    public  static void getDBUserSendMailList ( Connection dbCon ,Encuesta encuesta)
        throws SurException {
        Encuesta.getDBUserSendMailList ( dbCon ,"", encuesta);
    }
    // Se usa en el main IntEnviarEncuesta
    public  static void getDBUserSendMailList ( Connection dbCon ,String _BASE, Encuesta encuesta) throws SurException {
        ResultSet rs = null;
        CallableStatement cons = null;
        LinkedList lUsuario = new LinkedList();
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("ENC_GET_ALL_DESTINOS (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt(2, encuesta.getNumEncuesta());
            cons.execute();
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    Usuario usuario = new Usuario();
                    usuario.setUsuario( rs.getString("USUARIO"));
                    usuario.setiCodTipoUsuario( rs.getInt("TIPO_USUARIO"));
                    usuario.setRazonSoc(rs.getString("RAZON_SOCIAL"));
                    usuario.setEmail(rs.getString("EMAIL"));
                    lUsuario.add(usuario);
                }
            }
            // throw new SurException ("Error al obtener destino ...." );
        }  catch (SQLException se) {
                encuesta.setiNumError (-1);
                encuesta.setsMensError (se.getMessage());
                throw new SurException ("Error al obtener destino " + se.getMessage());
        } catch (Exception e) {
                encuesta.setiNumError (-1);
                encuesta.setsMensError (e.getMessage());
                throw new SurException (e.getMessage());
        } finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                encuesta.setiNumError (-1);
                encuesta.setsMensError (see.getMessage());
                throw new SurException (see.getMessage());
            }
            encuesta.setLUsuariosAvisoMail(lUsuario);
        }
    } //getDBUserSendMailList
    

}
