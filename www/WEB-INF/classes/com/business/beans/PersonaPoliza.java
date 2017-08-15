/*
 * Certificado.java
 *
 * Created on 9 de enero de 2005, 19:37
 */

package com.business.beans;
  
import java.util.Date;
import java.util.LinkedList;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;

import com.business.util.*;
import com.business.db.*;
import com.business.interfaces.*;
    
/**
 *
 * @author  Pino
 */
public class PersonaPoliza {
    
    private String codRama  = "";
    private int numPoliza      = 0;
    private String numDoc      = "";
    private String tipoDoc          = "";
    private String descTipoDoc      = "";
    private int numTomador          = 0;
    private int codCondicionIVA     = 0;
    private String razonSocial      = "";
    private String codPostal        = "";
    private String domicilio        = "";
    private String localidad        = "";    
    private String provincia        = "";    
    private String descProvincia    = "";
    private String descIVA          = "";
    private String cuit             = "";
    private String nombre           = "";
    private String apellido         = "";
    private String cargo            = "";
    /* Nuevo SUP */
    private String telefono ="";
    private String mail ="";
    private int    codProceso    = 0;
    private String codBoca       ="";
    private int    numPropuesta = 0;
    private NoGestionar noGestionar = null;
    private int  codLocalidad = 0;        
    /* ----*/
    
    private String sMensError       = new String();
    private int  iNumError          = 0;
    private CallableStatement cons  = null;
    
    /** Creates a new instance of Certificado */
    public PersonaPoliza() {
    }

    public void setcodRama      (String param) { this.codRama = param; }
    public void setnumPoliza    (int param) { this.numPoliza = param; }
    public void setnumTomador   (int param) { this.numTomador = param; }
    public void setcodCondicionIVA (int param) { this.codCondicionIVA = param; }
    public void setnumDoc       (String param) { this.numDoc = param; }
    public void settipoDoc      (String param) { this.tipoDoc = param; }
    public void setdescTipoDoc  (String param) { this.descTipoDoc = param; }
    public void setrazonSocial      (String param) { this.razonSocial = param; }
    public void setcodPostal        (String param) { this.codPostal = param; }
    public void setdomicilio        (String param) { this.domicilio = param; }
    public void setlocalidad        (String param) { this.localidad = param; }
    public void setprovincia        (String param) { this.provincia = param; }
    public void setdescProvincia    (String param) { this.descProvincia = param; }
    public void setdescIVA          (String param) { this.descIVA  = param; }    
    public void setcuit             (String param) { this.cuit     = param; }
    public void setnombre           (String param) { this.nombre   = param; }
    public void setapellido         (String param) { this.apellido = param; }
    public void setcargo            (String param) { this.cargo = param; }
    public void setnoGestionar      (NoGestionar param) { this.noGestionar  = param; }
    public void setcodLocalidad     (int param) { this.codLocalidad = param; }

    /* Nuevo SUP */
    public void settelefono         (String param) { this.telefono = param; }
    public void setmail             (String param) { this.mail = param; }
    public void setcodProceso       (int   param) { this.codProceso = param; }
    public void setcodBoca          (String param) { this.codBoca = param; }
    public void setnumPropuesta     (int   param) { this.numPropuesta = param; }
    /* ----*/
    
    
    public String getcodRama    () { return codRama; }
    public int getnumPoliza     () { return  this.numPoliza;}
    public int getnumTomador    () { return  this.numTomador;}
    public int getcodCondicionIVA () { return  this.codCondicionIVA;}
    public String getnumDoc     () { return this.numDoc;}
    public String gettipoDoc    () { return this.tipoDoc;}
    public String getdescTipoDoc() { return this.descTipoDoc;}
    public String getrazonSocial() { return this.razonSocial;}
    public String getcodPostal        () { return this.codPostal;}
    public String getdomicilio        () { return this.domicilio;}
    public String getlocalidad        () { return this.localidad;}
    public String getprovincia        () { return this.provincia;}
    public String getdescProvincia    () { return this.descProvincia;}    
    public String getdescIVA          () { return this.descIVA;}    
    public String getcuit             () { return this.cuit;}
    public String getnombre           () { return this.nombre;}
    public String getapellido         () { return this.apellido;}
    public String getcargo            () { return this.cargo;}
    public NoGestionar getnoGestionar () { return this.noGestionar;}
    public int getcodLocalidad () { return  this.codLocalidad;}

    /* Nuevo SUP */
    public String gettelefono          () { return this.telefono;}    
    public String getmail              () { return this.mail;}  
    
    public int getcodProceso () { return  this.codProceso;}
    public String getcodBoca              () { return this.codBoca;}  
    public int getnumPropuesta () { return  this.numPropuesta;}  
    
    /* ----*/    
    
    
    public void setsMensError  (String psMensError ) {
        this.sMensError  = psMensError ;
    }

    public int getiNumError  () {
        return this.iNumError ;
    }
    
    public void setiNumError  (int piNumError ) {
        this.iNumError  = piNumError;
    }

    public String getsMensError  () {
        return this.sMensError;
    }
   
    public PersonaPoliza getDB ( Connection dbCon) throws SurException {
       ResultSet rs = null;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PZ_GET_TOMADOR (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getnumTomador());
            cons.execute();
           
           rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    this.setnumTomador (rs.getInt ("NUM_TOMADOR"));
                    this.settipoDoc     (rs.getString ("TIPO_DOC"));
                    this.setdescTipoDoc(rs.getString ("DESC_TIPO_DOC"));
                    this.setnumDoc      (rs.getString ("NUM_DOC"));
                    this.setrazonSocial (rs.getString ("RAZON_SOCIAL"));
                    this.setcuit        (rs.getString ("CUIT"));
                    this.setcodCondicionIVA  (rs.getInt ("COD_CONDICION_IVA"));
                    this.setdomicilio   (rs.getString ("DOMICILIO"));
                    this.setlocalidad   (rs.getString ("LOCALIDAD"));
                    this.setcodPostal   (rs.getString ("COD_POSTAL"));
                    this.setprovincia   (rs.getString ("PROVINCIA"));
                    this.setdescProvincia(rs.getString ("DESC_PROVINCIA"));
                    this.setdescIVA     (rs.getString  ("DESC_COND_IVA"));
                }
                rs.close();
            }
        }  catch (SQLException se) {
                setiNumError (-1);
                setsMensError (se.getMessage());
		throw new SurException("Error Sql al obtener el usuario: " + se.getMessage());
        } catch (Exception e) {
                setiNumError (-1);
                setsMensError (e.getMessage());
		throw new SurException("Error al obtener el usuario: " + e.getMessage());
        } finally {
            try{
                if (rs != null)  rs.close (); 
                if (cons != null)  cons.close (); 
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }
    
    
    
    public PersonaPoliza setDBTomadorPropuesta ( Connection dbCon) throws SurException {
        try {            
           dbCon.setAutoCommit(true);
           
           cons = dbCon.prepareCall(db.getSettingCall( "PRO_SET_TOMADO_PROPUESTA (?,?,?,?,?,?,?,?,?,?,?,?,?,?, ?, ?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);       
           cons.setInt              (2, this.getcodProceso());             
           cons.setString           (3, this.getcodBoca() );
           cons.setInt              (4, this.getnumPropuesta());             
           cons.setInt              (5, this.getnumTomador());             
           cons.setString           (6, this.gettipoDoc() );
           cons.setString           (7, this.getnumDoc()  );
           cons.setString           (8, this.getrazonSocial() );
           cons.setInt              (9, this.getcodCondicionIVA() );
           cons.setString           (10, this.getdomicilio() );
           cons.setString           (11, this.getlocalidad() );
           cons.setString           (12, this.getcodPostal() );
           cons.setString           (13, this.getmail() );
           cons.setString           (14, this.gettelefono() );
           cons.setString           (15, this.getprovincia() );
           cons.setString           (16, this.getapellido ());
           cons.setString           (17, this.getnombre());
//           cons.setString           (18, this.getcargo());
           
           cons.execute();

           if (cons.getInt (1) < 0 ) {
               this.setiNumError(cons.getInt (1));
           } else  {
               this.setnumTomador(cons.getInt (1));
           }
            
        }  catch (SQLException se) {
             this.setiNumError(-1);
             this.setsMensError(se.getMessage());
        } catch (Exception e) {
             this.setiNumError(-1);
             this.setsMensError(e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    }                
    public PersonaPoliza setDBTomadorCaucion ( Connection dbCon) throws SurException {
        try {
           dbCon.setAutoCommit(true);

           cons = dbCon.prepareCall(db.getSettingCall( "PRO_SET_TOMADOR_PROPUESTA (?,?,?,?,?,?,?,?,?,?,?,?,?,?, ?, ? ,?)"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt              (2, this.getcodProceso());
           cons.setString           (3, this.getcodBoca() );
           cons.setInt              (4, this.getnumPropuesta());
           cons.setInt              (5, this.getnumTomador());
           cons.setString           (6, this.gettipoDoc() );
           cons.setString           (7, this.getnumDoc()  );
           cons.setString           (8, this.getrazonSocial() );
           cons.setInt              (9, this.getcodCondicionIVA() );
           cons.setString           (10, this.getdomicilio() );
           cons.setString           (11, this.getlocalidad() );
           cons.setString           (12, this.getcodPostal() );
           cons.setString           (13, this.getmail() );
           cons.setString           (14, this.gettelefono() );
           cons.setString           (15, this.getprovincia() );
           cons.setString           (16, this.getapellido ());
           cons.setString           (17, this.getnombre());
           cons.setString           (18, this.getcargo());

           cons.execute();

           this.setnumTomador(cons.getInt (1));


        }  catch (SQLException se) {
            this.setiNumError(-1);
            this.setsMensError(se.getMessage());
        } catch (Exception e) {
            this.setiNumError(-1);
            this.setsMensError(e.getMessage());
        } finally {
            try{
                if (cons != null) { cons.close(); }
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    }
}