/*
 * Portal.java
 *
 * Created on 26 de noviembre de 2008, 21:25
 */

package com.business.beans;

import java.util.Date;
import java.util.LinkedList;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import com.business.util.*;
import com.business.db.*;

/**
 *
 * @author Rolando Elisii
 */
public class Portal {

    private int codRama     = 0;
    private int codPortal   = 0;
    private String titulo   = null;
    private String mcaPublica  = null;
    private Date fechaDesde = null;
    private Date fechaHasta = null;
    private String subtitulo  = null;
    private String userId   = null;
    private int nivel       = 0;
    private int subNivel    = 0;
    private String texto    = null;
    private String pdf      = null;
    private String imagen   = null;
    private String imagenMin = null;
    private String imagenSlider = null;
    private String sMensError = null;
    private int  iNumError    = 0;
    private LinkedList lTextos = null;
    private LinkedList lTabla  = null;
    private String descRama  = null;
    private String icoAMF     = null;
    private String icoRentaDiaria = null;
    private String icoSepelio =null;
    private String icoAmbito  = null;
    private String ico0800    = null;
    private String email      = null;
    private String mcaTabla   = null;
  
    public Portal () {
    }

    public int getcodRama () { return this.codRama; }
    public int getcodPortal () { return this.codPortal; }
    public String gettitulo () { return this.titulo; }
    public String getdescRama () { return this.descRama; }
    public Date getfechaDesde () { return this.fechaDesde; }
    public Date getfechaHasta () { return this.fechaHasta; }
    public String getsubtitulo () { return this.subtitulo; }
    public String getuserId () { return this.userId; }
    public int getnivel () { return this.nivel; }
    public int getsubNivel () { return this.subNivel; }
    public String gettexto () { return this.texto; }
    public String getmcaPublica () { return this.mcaPublica; }
    public String getsMensError () { return this.sMensError; }
    public int getiNumError     () { return this.iNumError; }
    public String getpdf () { return this.pdf; }
    public String getimagen () { return this.imagen; }
    public String getimagenMin () { return this.imagenMin; }
    public String getimagenSlider () { return this.imagenSlider; }
    public LinkedList getlTextos () { return this.lTextos; }
    public LinkedList getlTabla  () { return this.lTabla; }
    public String geticoAMF  () { return this.icoAMF; }
    public String geticoRentaDiaria  () { return this.icoRentaDiaria; }
    public String geticoSepelio  () { return this.icoSepelio; }
    public String geticoAmbito  () { return this.icoAmbito; }
    public String getico0800  () { return this.ico0800; }
    public String getemail  () { return this.email; }
    public String getmcaTabla  () { return this.mcaTabla; }

    public void setcodRama    (int param) { this.codRama   = param; }
    public void setcodPortal  (int param) { this.codPortal = param; }
    public void settitulo     (String param) { this.titulo = param; }
    public void setdescRama   (String param) { this.descRama = param; }
    public void setfechaDesde (Date param) { this.fechaDesde = param; }
    public void setfechaHasta (Date param) { this.fechaHasta = param; }
    public void setsubtitulo  (String param) { this.subtitulo = param; }
    public void setuserId     (String param) { this.userId = param; }
    public void setnivel      (int param) { this.nivel = param; }
    public void setsubNivel      (int param) { this.subNivel = param; }
    public void settexto      (String param) { this.texto = param; }
    public void setmcaPublica (String param) { this.mcaPublica = param; }    
    public void setsMensError (String param) { this.sMensError = param; }
    public void setiNumError  (int param) { this.iNumError = param; }
    public void setpdf        (String param) { this.pdf = param; }
    public void setimagen     (String param) { this.imagen = param; }
    public void setimageMin   (String param) { this.imagenMin = param; }
    public void setimagenSlider (String param) { this.imagenSlider = param; }
    public void seticoAMF  (String param) {  this.icoAMF= param;}
    public void seticoRentaDiaria  (String param) {  this.icoRentaDiaria= param;}
    public void seticoSepelio  (String param) {  this.icoSepelio= param;}
    public void seticoAmbito  (String param) {  this.icoAmbito= param;}
    public void setico0800  (String param) {  this.ico0800= param;}
    public void setemail    (String param) {  this.email= param;}
    public void setmcaTabla (String param) {  this.mcaTabla = param;}

    public Portal getDB ( Connection dbCon) throws SurException {
        ResultSet rs = null;
        CallableStatement cons = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("POR_GET_PORTAL (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getcodPortal());
            cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    this.setcodRama   (rs.getInt ("COD_RAMA"));
                    this.setcodPortal   (rs.getInt    ("COD_PORTAL"));
                    this.setdescRama    (rs.getString ("DESC_RAMA"));
                    this.settitulo      (rs.getString ("TITULO"));
                    this.setsubtitulo   (rs.getString ("SUBTITULO"));
                    this.setimageMin    (rs.getString ("IMAGEN_MIN"));
                    this.settexto       (rs.getString ("TEXTO"));
                    this.setnivel       (rs.getInt    ("NIVEL"));
                    this.setsubNivel    (rs.getInt    ("SUB_NIVEL"));
                    this.setimagen      (rs.getString ("IMAGEN"));
                    this.setfechaDesde  (rs.getDate   ("FECHA_DESDE"));
                    this.setfechaHasta  (rs.getDate   ("FECHA_HASTA"));
                    this.setemail       (rs.getString ("EMAIL"));
                    this.setpdf           (rs.getString ("PDF"));
                    this.setmcaPublica    (rs.getString ("MCA_PUBLICA"));
                    this.seticoAMF        (rs.getString ("ICO_AMF"));
                    this.seticoRentaDiaria(rs.getString ("ICO_RENTA_DIARIA"));
                    this.seticoSepelio    (rs.getString ("ICO_SEPELIO"));
                    this.seticoAmbito     (rs.getString ("ICO_AMBITO"));
                    this.setico0800       (rs.getString ("ICO_0800_ASISTENCIA"));
                    this.setmcaTabla      (rs.getString ("MCA_TABLA"));
                    this.setimagenSlider  (rs.getString ("IMAGEN_SLIDER"));
                }
                rs.close();
            }
           cons.close();
        }  catch (SQLException se) {
		throw new SurException("Error Portal [getDB]" + se.getMessage());
        } catch (Exception e) {
		throw new SurException("Error Portal [getDB]" + e.getMessage());
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

public void getDBAllTextos ( Connection dbCon) throws SurException {
    CallableStatement cons = null;
    ResultSet rs = null;

    try {
        cons = dbCon.prepareCall(db.getSettingCall("POR_GET_ALL_TEXTOS (?)"));
        cons.registerOutParameter(1, java.sql.Types.OTHER);
        cons.setInt     (2, this.getcodPortal ());
        cons.execute();

        rs = (ResultSet) cons.getObject(1);
        if (rs != null) {
            lTextos = new LinkedList ();
            while (rs != null  && rs.next()) {
                PortalTexto pt = new PortalTexto();
                pt.setcodPortal (this.getcodPortal());
                pt.settitulo    (rs.getString ("TITULO"));
                pt.settexto     (rs.getString ("TEXTO"));
                lTextos.add(pt);
            }
            rs.close();
        }
        cons.close();
        }catch (SQLException se) {
            throw new SurException(se.getMessage());
        }catch (Exception e) {
            throw new SurException(e.getMessage());
        }finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }
public void getDBTabla ( Connection dbCon) throws SurException {
    CallableStatement cons = null;
    ResultSet rs = null;

    try {
        cons = dbCon.prepareCall(db.getSettingCall("POR_GET_TABLA (?)"));
        cons.registerOutParameter(1, java.sql.Types.OTHER);
        cons.setInt     (2, this.getcodPortal ());
        cons.execute();

        rs = (ResultSet) cons.getObject(1);
        if (rs != null) {
            lTabla = new LinkedList ();
            while (rs != null  && rs.next()) {
                PortalTabla pt = new PortalTabla();
                pt.setcodPortal (this.getcodPortal());
                pt.settexto     (rs.getString ("TEXTO"));
                pt.setancho     (rs.getInt ("ANCHO"));
                pt.setfila      (rs.getInt ("FILA"));
                pt.setcolumna   (rs.getInt ("COLUMNA"));
                lTabla.add(pt);
            }
            rs.close();
        }
        cons.close();
        }catch (SQLException se) {
            throw new SurException(se.getMessage());
        }catch (Exception e) {
            throw new SurException(e.getMessage());
        }finally {
            try{
                if (rs != null) rs.close ();
                if (cons != null) { cons.close (); }
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }

}
