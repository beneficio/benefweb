/*
 * Usuario.java
 *
 * Created on 30 de junio de 2003, 05:45 PM
 */
    
package com.business.beans;   
import java.sql.ResultSet;  
import java.sql.Connection;   
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.io.Serializable;
import java.util.Date;
import com.business.util.SurException;
import com.business.db.db;   

/**
 *
 * @author  surprogra
 */
public class Usuario  extends Persona implements  Serializable {
    
    private String usuario      = "";
    private String password     = "";
    private int iCodTipoUsuario = 0; // 0 = interno - <> 0 = externo
    private String sDescTipoUsuario = "";
    private int oficina         = 1;
    private String descOficina  = "";
    private String sHabilitado  = "";
    private int iNumSecuUsu     = 0;
    private String Gestor       = "";
    private int iPerfil         = 0;
    private String sObservacion = "";
    private int iCodProd        = 0;
    private int iNumTomador     = 0;
    private int organizador     = 0;
    private int zona            = 0;
    private Date fechaCambioClave = null;
    private String sAlerta      = null;
    private int menu            = 0;
    private String sCodProdDC   = null;
    private String sHabilitado2 = null;
    private String sCodVinculo  = null;
    private int    codProdAnt   = 0;
    private int    codOrgAnt    = 0;
    private int matricula       = 0;
    private String sSistGestion = null;
    private boolean cuitValido  = true; 
    private String facturaElectronica = null;


    /** Creates a new instance of Usuario */
    public void Usuario() { this.usuario = "";  }
    
    public void setusuario(java.lang.String pUsuario) {this.usuario = pUsuario;}
    public String getusuario() {return this.usuario;}
    public void setGestor (java.lang.String pGestor) { this.Gestor = pGestor;}
    public String getGestor () {
        return this.Gestor;    }
    public void setsHabilitado (java.lang.String param) {
        this.sHabilitado = param;    }
    public String getsHabilitado() {
        return this.sHabilitado;    }
    public void setpassword(java.lang.String ppassword) {
        this.password = ppassword;    }
    public String getpassword() {
        return this.password;    }
    public int getiCodTipoUsuario() {
        return this.iCodTipoUsuario;    }
    public void setiCodTipoUsuario(int param) {
        this.iCodTipoUsuario = param;    }
    public int getiCodProd () {
        return this.iCodProd;    }
    public int getmenu () {
        return this.menu;    }
    public void setiCodProd (int param) {
        this.iCodProd = param;    }
    public int getiNumTomador () {
        return this.iNumTomador;    }
    public void setiNumTomador (int param) {
        this.iNumTomador = param;    }
    public int getoficina () {
        return this.oficina;    }
    public void setoficina (int param) {
        this.oficina = param;    }
    public int getiPerfil () {
        return this.iPerfil;    }
    public void setiPerfil (int param) {
        this.iPerfil = param;    }
    public String getsDescTipoUsuario() {
        return this.sDescTipoUsuario;    }
    public void setsDescTipoUsuario( String param) {
        this.sDescTipoUsuario = param;    }
    public String getdescOficina() {
        return this.descOficina;    }

    public void setdescOficina ( String param) {
        this.descOficina = param;    }
    
    public String getsObservacion () {
        return this.sObservacion;    }

    public void setsObservacion ( String param) {
        this.sObservacion = param;    }

    public void setiNumSecuUsu (int param) {
        this.iNumSecuUsu = param;    }
    
    public int getiNumSecuUsu () {
        return this.iNumSecuUsu;    }

    public int getorganizador () {
        return this.organizador;    }

    public void setorganizador (int param) {
        this.organizador = param;    }
      
    public int getzona () {
        return this.zona;    }

    public void setzona (int param) {
        this.zona = param;    }
    
    public void setfechaCambioClave (Date param) {
        this.fechaCambioClave = param;    }
    
    public Date getfechaCambioClave () {
        return this.fechaCambioClave;    }

    public String getsAlerta () {
        return this.sAlerta;    }

    public void setsAlerta ( String param) {
        this.sAlerta = param;    }
    
    public void setmenu (int param) {
        this.menu = param;    }

    public void setsHabilitado2 (java.lang.String param) {
        this.sHabilitado2 = param;    }

    public String getsHabilitado2() {
        return this.sHabilitado2;    }
    public void setsCodProdDC (java.lang.String param) {
        this.sCodProdDC = param;    }

    public String getsCodProdDC () {
        return this.sCodProdDC;    }

    public void setsCodVinculo (java.lang.String param) {
        this.sCodVinculo = param;    }

    public String getsCodVinculo () { return this.sCodVinculo;    }

    public int getcodProdAnt () { return this.codProdAnt;    }

    public void setcodProdAnt (int param) { this.codProdAnt= param;    }

    public int getcodOrgAnt () { return this.codOrgAnt; }

    public void setcodOrgAnt (int param) { this.codOrgAnt= param;}

    public int getmatricula () { return this.matricula; }

    public void setmatricula (int param) { this.matricula = param;}

    public String getsSistGestion () { return this.sSistGestion;    }

    public void setsSistGestion (String param) { this.sSistGestion = param;}
    
    public boolean getcuitValido () { return this.cuitValido; }

    public void setcuitValido (boolean param) { this.cuitValido = param;}
    
    public void setfacturaElectronica (String param) {this.facturaElectronica = param;}
    public String getfacturaElectronica () {return this.facturaElectronica;}

    public Usuario getDBExiste ( Connection dbCon) throws SurException {
        ResultSet rs = null;
       CallableStatement proc = null;

        try {
            dbCon.setAutoCommit(false);
            proc = dbCon.prepareCall(db.getSettingCall("US_GET_USUARIO_PASSWORD (?,?)"));
            proc.registerOutParameter(1, java.sql.Types.OTHER);
            proc.setString (2, this.getusuario());
            proc.setString (3, this.getpassword());
            proc.execute();
           
            rs = (ResultSet) proc.getObject(1);
            boolean bExiste       = false;
            boolean bHabilitado   = true; 
            boolean bCambiarClave = false;

            if (rs != null) {
                while (rs.next()) {
                    bExiste = true;
                    this.setDoc         (rs.getString ("DOCUMENTO"));
                    this.setTipoDoc     (rs.getString ("TIPO_DOCUMENTO"));
                    this.setusuario      (rs.getString ("USUARIO"));
                    this.setpassword     (rs.getString ("CLAVE"));
                    this.setiCodTipoUsuario (rs.getInt ("TIPO_USUARIO"));
                    this.setsHabilitado  (rs.getString ("HABILITADO"));
                    this.setFechaEquipo (rs.getDate   ("FECHA_TRABAJO"));
                    this.setUsuario     (rs.getString ("USERID"));
                    this.setiNumSecuUsu(rs.getInt  ("NUM_SECU_USU"));
                    this.setiCodProd    (rs.getInt ("COD_PROD"));
                    this.setsObservacion(rs.getString ("OBSERVACION"));
                    this.setNom         (rs.getString ("NOMBRE"));
                    this.setApellido    (rs.getString ("APELLIDO")); 
                    this.setCategoria   (rs.getString ("CATEGORIA_PERSONA"));
                    this.setRazonSoc    (rs.getString ("RAZON_SOCIAL"));
                    this.setCodCondIB   (rs.getInt    ("COD_CONDICION_IB"));
                    this.setCodCondIVA  (rs.getInt    ("COD_CONDICION_IVA"));
                    this.setNumIB       (rs.getString ("NUMERO_IB"));
                    this.setSexo        (rs.getString ("SEXO"));
                    this.setEmail       (rs.getString ("EMAIL"));
                    this.setFax         (rs.getString ("FAX"));
                    this.setFechaInicAct(rs.getDate   ("FECHA_INICIO_ACTIVIDAD"));
                    this.setFechaNac    (rs.getDate   ("FECHA_NACIMIENTO"));
                    this.setTel1        (rs.getString ("TELEFONO1"));
                    this.setTel2        (rs.getString ("TELEFONO2"));
                    this.setCalle       (rs.getString ("CALLE"));
                    this.setNumero      (rs.getString ("NUMERO"));
                    this.setPiso        (rs.getString ("PISO"));
                    this.setDepto       (rs.getString ("DEPARTAMENTO"));
                    this.setPais        (rs.getString ("COD_PAIS"));
                    this.setPcia        (rs.getString ("COD_PROVINCIA"));
                    this.setLocalidad   (rs.getString ("LOCALIDAD"));
                    this.setCodigoPostal(rs.getString ("CODIGO_POSTAL")); 
                    this.setsDesPersona(rs.getString ("DESCRIPCION"));
                    this.setoficina     (rs.getInt    ("OFICINA"));     
                    this.setiNumTomador (rs.getInt("NUM_TOMADOR"));
                    this.setorganizador (rs.getInt ("ORGANIZADOR"));
                    this.setzona        (rs.getInt ("ZONA"));
                    this.setfechaCambioClave(rs.getDate ("FECHA_CAMBIO_CLAVE"));
                    this.setmenu        (rs.getInt ("MENU"));
                    if (this.getsHabilitado().equals ("N")) bHabilitado = false;
                    if (this.getfechaCambioClave() == null) 
                        bCambiarClave = true;
                    else if (rs.getInt ("DIAS_EXPIRACION") > 240) 
                                bCambiarClave = true;
                    this.setsAlerta         (rs.getString ("ALERTA"));
                    this.setsCodProdDC      (rs.getString ("COD_PROD_DC"));
                    this.setsHabilitado2    (rs.getString ("HABILITADO_2"));
                    this.setsCodVinculo     (rs.getString ("COD_VINCULO"));
                    this.setcodProdAnt      (rs.getInt ("COD_PROD_ANT"));
                    this.setcodOrgAnt       (rs.getInt ("COD_ORG_ANT"));
                    this.setsSistGestion    (rs.getString ("SIST_GESTION"));
                    this.setmatricula       (rs.getInt ("MATRICULA"));
                }
                rs.close();
            }
            proc.close();

            if ( ! bExiste) {
                setiNumError  (100);
                setsMensError ("Usuario y/o password inválida");
            } else if (! bHabilitado ) {
                setiNumError  (200);
                setsMensError ("Usuario sin acceso, por favor comunicarse con el area comercial o complete el formulario haciendo click en Registrese para solictar el acceso. Gracias");
            } else if (bCambiarClave) {
                setiNumError  (300);
                setsMensError ("La Clave ha caducado, por favor ingrese la nueva clave ");
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
                if (rs != null) rs.close();
                if (proc != null) proc.close (); 
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }

    public Usuario getDBRecuperarAcceso ( Connection dbCon) throws SurException {
        ResultSet rs = null;
       CallableStatement proc = null;

        try {
            dbCon.setAutoCommit(false);
            proc = dbCon.prepareCall(db.getSettingCall("US_GET_RECUPERAR_ACCESO (?,?,?,?,?)"));
            proc.registerOutParameter(1, java.sql.Types.OTHER);
            proc.setString (2, this.getusuario());
            proc.setString (3, this.getTipoDoc());
            proc.setString (4, this.getDoc());
            proc.setInt    (5, this.getmatricula());
            proc.setString (6,this.getEmail() );
            proc.execute();

            rs = (ResultSet) proc.getObject(1);
            boolean bExiste       = false;
            boolean bHabilitado   = true;

            if (rs != null) {
                while (rs.next()) {
                    bExiste = true;
                    this.setDoc         (rs.getString ("DOCUMENTO"));
                    this.setTipoDoc     (rs.getString ("TIPO_DOCUMENTO"));
                    this.setusuario      (rs.getString ("USUARIO"));
                    this.setpassword     (rs.getString ("CLAVE"));
                    this.setsHabilitado  (rs.getString ("HABILITADO"));
                    this.setiCodProd    (rs.getInt ("COD_PROD"));
                    this.setNom         (rs.getString ("NOMBRE"));
                    this.setApellido    (rs.getString ("APELLIDO"));
                    this.setRazonSoc    (rs.getString ("RAZON_SOCIAL"));
                    this.setEmail       (rs.getString ("EMAIL"));
                    this.setsDesPersona(rs.getString ("DESCRIPCION"));
                    this.setfechaCambioClave(rs.getDate ("FECHA_CAMBIO_CLAVE"));
                    if (this.getsHabilitado().equals ("N")) bHabilitado = false;
                    this.setsCodProdDC(rs.getString ("COD_PROD_DC"));
                    this.setsHabilitado2(rs.getString ("HABILITADO_2"));
                 }
                rs.close();
            }
            proc.close();

            if ( ! bExiste) {
                setiNumError  (100);
                setsMensError ("Usuario/matricula/documento/email inexistente  en la base de datos");
            } else if (! bHabilitado ) {
                setiNumError  (200);
                setsMensError ("Usuario/matricula/documento/email encotrado pero inhabilitado.");
            } else { setiNumError(0); }
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
                if (rs != null) rs.close();
                if (proc != null) proc.close ();
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }

    public Usuario getDB ( Connection dbCon) throws SurException {
       CallableStatement proc = null;
       ResultSet rs           = null;

        try {
            dbCon.setAutoCommit(false);
            proc = dbCon.prepareCall(db.getSettingCall("US_GET_USUARIO (?)"));
            proc.registerOutParameter(1, java.sql.Types.OTHER);
            proc.setInt (2, this.getiNumSecuUsu());
            proc.execute();
           
            rs = (ResultSet) proc.getObject(1);
            boolean bExiste = false;

            if (rs != null) {
                while (rs.next()) {
                    bExiste = true;
                    this.setDoc         (rs.getString ("DOCUMENTO"));
                    this.setTipoDoc     (rs.getString ("TIPO_DOCUMENTO"));
                    this.setusuario      (rs.getString ("USUARIO"));
                    this.setpassword     (rs.getString ("CLAVE"));
                    this.setiCodTipoUsuario (rs.getInt ("TIPO_USUARIO"));
                    this.setsHabilitado  (rs.getString ("HABILITADO"));
                    this.setFechaEquipo (rs.getDate   ("FECHA_TRABAJO"));
                    this.setUsuario     (rs.getString ("USERID"));
                    this.setiNumSecuUsu(rs.getInt  ("NUM_SECU_USU"));
                    this.setiCodProd    (rs.getInt ("COD_PROD"));
                    this.setsObservacion(rs.getString ("OBSERVACION"));
                    this.setNom         (rs.getString ("NOMBRE"));
                    this.setApellido    (rs.getString ("APELLIDO")); 
                    this.setCategoria   (rs.getString ("CATEGORIA_PERSONA"));
                    this.setRazonSoc    (rs.getString ("RAZON_SOCIAL"));
                    this.setCodCondIB   (rs.getInt    ("COD_CONDICION_IB"));
                    this.setCodCondIVA  (rs.getInt    ("COD_CONDICION_IVA"));
                    this.setNumIB       (rs.getString ("NUMERO_IB"));
                    this.setSexo        (rs.getString ("SEXO"));
                    this.setEmail       (rs.getString ("EMAIL"));
                    this.setFax         (rs.getString ("FAX"));
                    this.setFechaInicAct(rs.getDate   ("FECHA_INICIO_ACTIVIDAD"));
                    this.setFechaNac    (rs.getDate   ("FECHA_NACIMIENTO"));
                    this.setTel1        (rs.getString ("TELEFONO1"));
                    this.setTel2        (rs.getString ("TELEFONO2"));
                    this.setsDesPersona (rs.getString ("DESCRIPCION"));
                    this.setCalle       (rs.getString ("CALLE"));
                    this.setNumero      (rs.getString ("NUMERO"));
                    this.setPiso        (rs.getString ("PISO"));
                    this.setDepto       (rs.getString ("DEPARTAMENTO"));
                    this.setPais        (rs.getString ("COD_PAIS"));
                    this.setPcia        (rs.getString ("COD_PROVINCIA"));
                    this.setLocalidad   (rs.getString ("LOCALIDAD"));
                    this.setCodigoPostal(rs.getString ("CODIGO_POSTAL")); 
                    this.setoficina     (rs.getInt    ("OFICINA"));
                    this.setiNumTomador (rs.getInt ("NUM_TOMADOR"));
                    this.setorganizador (rs.getInt ("ORGANIZADOR"));
                    this.setzona        (rs.getInt ("ZONA"));
                    this.setmenu        (rs.getInt ("MENU"));
                    this.setsCodProdDC(rs.getString ("COD_PROD_DC"));
                    this.setsHabilitado2(rs.getString ("HABILITADO_2"));
                    this.setsCodVinculo(rs.getString ("COD_VINCULO"));
                    this.setcodProdAnt(rs.getInt ("COD_PROD_ANT"));
                    this.setcodOrgAnt (rs.getInt("COD_ORG_ANT"));
                }
                rs.close();
            }
            
            if ( ! bExiste) {
                setiNumError(100);
                setsMensError(" Usuario inexistente o password incorrecta ");
            }
            proc.close();

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
                if (rs != null) rs.close();
                if (proc != null) proc.close (); 
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }

    public Usuario getDBUsuario ( Connection dbCon) throws SurException {
       CallableStatement proc = null;
       ResultSet rs           = null;

        try {
            dbCon.setAutoCommit(false);
            proc = dbCon.prepareCall(db.getSettingCall("US_GET_USUARIO (?)"));
            proc.registerOutParameter(1, java.sql.Types.OTHER);
            proc.setString (2, this.getusuario());
            proc.execute();

            rs = (ResultSet) proc.getObject(1);
            boolean bExiste = false;

            if (rs != null) {
                while (rs.next()) {
                    bExiste = true;
                    this.setDoc         (rs.getString ("DOCUMENTO"));
                    this.setTipoDoc     (rs.getString ("TIPO_DOCUMENTO"));
                    this.setusuario      (rs.getString ("USUARIO"));
                    this.setpassword     (rs.getString ("CLAVE"));
                    this.setiCodTipoUsuario (rs.getInt ("TIPO_USUARIO"));
                    this.setsHabilitado  (rs.getString ("HABILITADO"));
                    this.setFechaEquipo (rs.getDate   ("FECHA_TRABAJO"));
                    this.setUsuario     (rs.getString ("USERID"));
                    this.setiNumSecuUsu(rs.getInt  ("NUM_SECU_USU"));
                    this.setiCodProd    (rs.getInt ("COD_PROD"));
                    this.setsObservacion(rs.getString ("OBSERVACION"));
                    this.setNom         (rs.getString ("NOMBRE"));
                    this.setApellido    (rs.getString ("APELLIDO"));
                    this.setCategoria   (rs.getString ("CATEGORIA_PERSONA"));
                    this.setRazonSoc    (rs.getString ("RAZON_SOCIAL"));
                    this.setCodCondIB   (rs.getInt    ("COD_CONDICION_IB"));
                    this.setCodCondIVA  (rs.getInt    ("COD_CONDICION_IVA"));
                    this.setNumIB       (rs.getString ("NUMERO_IB"));
                    this.setSexo        (rs.getString ("SEXO"));
                    this.setEmail       (rs.getString ("EMAIL"));
                    this.setFax         (rs.getString ("FAX"));
                    this.setFechaInicAct(rs.getDate   ("FECHA_INICIO_ACTIVIDAD"));
                    this.setFechaNac    (rs.getDate   ("FECHA_NACIMIENTO"));
                    this.setTel1        (rs.getString ("TELEFONO1"));
                    this.setTel2        (rs.getString ("TELEFONO2"));
                    this.setsDesPersona (rs.getString ("DESCRIPCION"));
                    this.setCalle       (rs.getString ("CALLE"));
                    this.setNumero      (rs.getString ("NUMERO"));
                    this.setPiso        (rs.getString ("PISO"));
                    this.setDepto       (rs.getString ("DEPARTAMENTO"));
                    this.setPais        (rs.getString ("COD_PAIS"));
                    this.setPcia        (rs.getString ("COD_PROVINCIA"));
                    this.setLocalidad   (rs.getString ("LOCALIDAD"));
                    this.setCodigoPostal(rs.getString ("CODIGO_POSTAL"));
                    this.setoficina     (rs.getInt    ("OFICINA"));
                    this.setiNumTomador (rs.getInt ("NUM_TOMADOR"));
                    this.setorganizador (rs.getInt ("ORGANIZADOR"));
                    this.setzona        (rs.getInt ("ZONA"));
                    this.setmenu        (rs.getInt ("MENU"));
                    this.setsCodProdDC  (rs.getString ("COD_PROD_DC"));
                    this.setsHabilitado2(rs.getString ("HABILITADO_2"));
                    this.setsCodVinculo (rs.getString ("COD_VINCULO"));
                    this.setcodProdAnt  (rs.getInt ("COD_PROD_ANT"));
                    this.setcodOrgAnt   (rs.getInt ("COD_ORG_ANT"));
                    this.setsSistGestion(rs.getString ("SIST_GESTION"));

                }
                rs.close();
            }

            if ( ! bExiste) {
                setiNumError(100);
                setsMensError(" Usuario inexistente o password incorrecta ");
            }
            proc.close();

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
                if (rs != null) rs.close();
                if (proc != null) proc.close ();
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }

    public Usuario getDBProductor ( Connection dbCon) throws SurException {
       ResultSet rs    = null;
       CallableStatement proc = null;
       boolean bExiste = false;
       try {
            dbCon.setAutoCommit(false);
            proc = dbCon.prepareCall(db.getSettingCall("US_GET_USUARIO_PROD (?)"));
            proc.registerOutParameter(1, java.sql.Types.OTHER);
            proc.setInt (2, this.getiCodProd());
            proc.execute();
                    
            rs = (ResultSet) proc.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    bExiste    = true;
                    this.setDoc         (rs.getString ("DOCUMENTO"));
                    this.setTipoDoc     (rs.getString ("TIPO_DOCUMENTO"));
                    this.setusuario      (rs.getString ("USUARIO"));
                    this.setpassword     (rs.getString ("CLAVE"));
                    this.setiCodTipoUsuario (rs.getInt ("TIPO_USUARIO"));
                    this.setsHabilitado  (rs.getString ("HABILITADO"));
                    this.setFechaEquipo (rs.getDate   ("FECHA_TRABAJO"));
                    this.setUsuario     (rs.getString ("USERID"));
                    this.setiNumSecuUsu(rs.getInt  ("NUM_SECU_USU"));
                    this.setiCodProd    (rs.getInt ("COD_PROD"));
                    this.setsObservacion(rs.getString ("OBSERVACION"));
                    this.setNom         (rs.getString ("NOMBRE"));
                    this.setApellido    (rs.getString ("APELLIDO")); 
                    this.setCategoria   (rs.getString ("CATEGORIA_PERSONA"));
                    this.setRazonSoc    (rs.getString ("RAZON_SOCIAL"));
                    this.setCodCondIB   (rs.getInt    ("COD_CONDICION_IB"));
                    this.setCodCondIVA  (rs.getInt    ("COD_CONDICION_IVA"));
                    this.setNumIB       (rs.getString ("NUMERO_IB"));
                    this.setSexo        (rs.getString ("SEXO"));
                    this.setEmail       (rs.getString ("EMAIL"));
                    this.setFax         (rs.getString ("FAX"));
                    this.setFechaInicAct(rs.getDate   ("FECHA_INICIO_ACTIVIDAD"));
                    this.setFechaNac    (rs.getDate   ("FECHA_NACIMIENTO"));
                    this.setTel1        (rs.getString ("TELEFONO1"));
                    this.setTel2        (rs.getString ("TELEFONO2"));
                    this.setCalle       (rs.getString ("CALLE"));
                    this.setNumero      (rs.getString ("NUMERO"));
                    this.setPiso        (rs.getString ("PISO"));
                    this.setDepto       (rs.getString ("DEPARTAMENTO"));
                    this.setPais        (rs.getString ("COD_PAIS"));
                    this.setPcia        (rs.getString ("COD_PROVINCIA"));
                    this.setLocalidad   (rs.getString ("LOCALIDAD"));
                    this.setCodigoPostal(rs.getString ("CODIGO_POSTAL")); 
                    this.setoficina     (rs.getInt    ("OFICINA"));
                    this.setsDesPersona (rs.getString ("DESCRIPCION"));
                    this.setiNumTomador (rs.getInt ("NUM_TOMADOR"));
                    this.setsCodVinculo (rs.getString ("COD_VINCULO"));
                    this.setcodProdAnt  (rs.getInt ("COD_PROD_ANT"));
                    this.setcodOrgAnt   (rs.getInt ("COD_ORG_ANT"));
                    this.setmatricula   (rs.getInt ("MATRICULA"));
                    this.setorganizador (rs.getInt ("ORGANIZADOR"));
                    this.setsCodProdDC  (rs.getString ("COD_PROD_DC"));
                    this.setCuit        (rs.getString ("CUIT"));
                    this.setfacturaElectronica(rs.getString ("FACTURA_ELECTRONICA"));
                }
                rs.close();
            }
            proc.close();

            if ( ! bExiste ) {
                setiNumError (-100);
                setsMensError ("PRODUCTOR INEXISTENTE");
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
                if (rs != null) rs.close();
                if (proc != null) proc.close ();
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }

    public Usuario getDBUsuarioTomador ( Connection dbCon) throws SurException {
       ResultSet rs = null;
       CallableStatement proc = null;
       boolean bExiste = false;
       try {
            dbCon.setAutoCommit(false);
            proc = dbCon.prepareCall(db.getSettingCall("US_GET_USUARIO_TOMADOR (?)"));
            proc.registerOutParameter(1, java.sql.Types.OTHER);
            proc.setInt (2, this.getiNumTomador());
            proc.execute();
           
            rs = (ResultSet) proc.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    bExiste = true;
                    this.setDoc         (rs.getString ("DOCUMENTO"));
                    this.setTipoDoc     (rs.getString ("TIPO_DOCUMENTO"));
                    this.setusuario      (rs.getString ("USUARIO"));
                    this.setpassword     (rs.getString ("CLAVE"));
                    this.setiCodTipoUsuario (rs.getInt ("TIPO_USUARIO"));
                    this.setsHabilitado  (rs.getString ("HABILITADO"));
                    this.setFechaEquipo (rs.getDate   ("FECHA_TRABAJO"));
                    this.setUsuario     (rs.getString ("USERID"));
                    this.setiNumSecuUsu(rs.getInt  ("NUM_SECU_USU"));
                    this.setiCodProd    (rs.getInt ("COD_PROD"));
                    this.setsObservacion(rs.getString ("OBSERVACION"));
                    this.setNom         (rs.getString ("NOMBRE"));
                    this.setApellido    (rs.getString ("APELLIDO")); 
                    this.setCategoria   (rs.getString ("CATEGORIA_PERSONA"));
                    this.setRazonSoc    (rs.getString ("RAZON_SOCIAL"));
                    this.setCodCondIB   (rs.getInt    ("COD_CONDICION_IB"));
                    this.setCodCondIVA  (rs.getInt    ("COD_CONDICION_IVA"));
                    this.setNumIB       (rs.getString ("NUMERO_IB"));
                    this.setSexo        (rs.getString ("SEXO"));
                    this.setEmail       (rs.getString ("EMAIL"));
                    this.setFax         (rs.getString ("FAX"));
                    this.setFechaInicAct(rs.getDate   ("FECHA_INICIO_ACTIVIDAD"));
                    this.setFechaNac    (rs.getDate   ("FECHA_NACIMIENTO"));
                    this.setTel1        (rs.getString ("TELEFONO1"));
                    this.setTel2        (rs.getString ("TELEFONO2"));
                    this.setCalle       (rs.getString ("CALLE"));
                    this.setNumero      (rs.getString ("NUMERO"));
                    this.setPiso        (rs.getString ("PISO"));
                    this.setDepto       (rs.getString ("DEPARTAMENTO"));
                    this.setPais        (rs.getString ("COD_PAIS"));
                    this.setPcia        (rs.getString ("COD_PROVINCIA"));
                    this.setLocalidad   (rs.getString ("LOCALIDAD"));
                    this.setCodigoPostal(rs.getString ("CODIGO_POSTAL")); 
                    this.setoficina     (rs.getInt    ("OFICINA"));
                    this.setsDesPersona(rs.getString ("DESCRIPCION"));
                    this.setiNumTomador (rs.getInt ("NUM_TOMADOR"));
                }
                rs.close();  
            }
            proc.close();

            if ( ! bExiste ) {
                setiNumError (-100);
                setsMensError ("USUARIO INEXISTENTE");
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
                if (rs != null) rs.close();
                if (proc != null)proc.close (); 
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }

    public Usuario setDBCambiarEstado ( Connection dbCon) throws SurException {
       CallableStatement proc = null;

       try {
            dbCon.setAutoCommit(true);
            proc = dbCon.prepareCall(db.getSettingCall("US_CAMBIAR_ESTADO (?)"));
            proc.registerOutParameter   (1, java.sql.Types.VARCHAR);
            proc.setInt                 (2, this.getiNumSecuUsu());
            
            proc.execute();
            
            this.setsHabilitado( proc.getString (1) );     
            proc.close();

       }  catch (SQLException se) {
		throw new SurException("Error al cambiar el estado: " + se.getMessage());
        } catch (Exception e) {
		throw new SurException("Error al cambair el estado: " + e.getMessage());
        } finally {
            try{
                if (proc != null) proc.close (); 
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }
    
    public Usuario setDBCambiarClave ( Connection dbCon, String newClave) throws SurException {
        CallableStatement proc = null;

        try {
            dbCon.setAutoCommit(true);
            proc = dbCon.prepareCall(db.getSettingCall("US_SET_CLAVE (?, ?, ?, ?)"));
            proc.registerOutParameter   (1, java.sql.Types.INTEGER);
            proc.setString              (2, this.getusuario());
            proc.setString              (3, this.getpassword());
            proc.setString              (4, newClave);
            proc.setString              (5, this.getUsuario());
            
            proc.execute();
            
            this.setiNumError( proc.getInt (1) );     
            
            proc.close();

       }  catch (SQLException se) {
                this.setiNumError( -1);
                this.setsMensError("Error al cambair clave:" + se.getMessage());
        } catch (Exception e) {
                this.setiNumError( -1);
                this.setsMensError("Error al cambair clave:" + e.getMessage());
        } finally {
            try{
                if (proc != null) proc.close (); 
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }
    
    public Usuario setDB(Connection dbCon) throws SurException {
       CallableStatement proc = null;

        try {
            dbCon.setAutoCommit (true);
            proc = dbCon.prepareCall(db.getSettingCall("US_SET_USUARIO (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, ?)"));
            proc.registerOutParameter(1, java.sql.Types.INTEGER);
            proc.setString  (2, this.getTipoDoc());
            proc.setString  (3, this.getDoc());
            proc.setString  (4, this.getNom());
            proc.setString  (5, this.getApellido());
            proc.setInt     (6, this.getmenu());
            proc.setInt     (7, this.getzona ());
            proc.setString  (8, this.getTel1());
            proc.setString  (9, this.getTel2());
            proc.setString  (10, this.getFax());
            proc.setString  (11, this.getEmail());
            proc.setInt     (12, this.getCodCondIVA());
            proc.setInt     (13, this.getCodCondIB());
            proc.setString  (14, this.getNumIB());
            proc.setString  (15, this.getRazonSoc());
            proc.setString   (16, this.getUsuario());
            proc.setString   (17, this.getCategoria());
            proc.setString   (18, this.getsHabilitado());
            proc.setInt      (19, this.getiNumSecuUsu());
            proc.setString   (20, this.getusuario());
            proc.setInt      (21, this.getiCodTipoUsuario());
            proc.setString   (22, this.getpassword());  
            proc.setInt      (23, this.getiCodProd());
            proc.setString   (24, this.getsObservacion());
// datos del domicilio            
            proc.setString   (25, this.getCalle());      
            proc.setString   (26, this.getNumero());
            proc.setString   (27, this.getPiso());
            proc.setString   (28, this.getDepto());
            proc.setInt   (29, this.getiNumTomador());
            proc.setString   (30, this.getPcia());
            proc.setString   (31, this.getLocalidad());
            proc.setString   (32, this.getCodigoPostal());
            proc.setInt  (33, this.getoficina());
            proc.setInt  (34, this.getcodProdAnt());
            proc.setInt  (35, this.getcodOrgAnt());
            proc.setString (36, this.getsSistGestion());
            
            
            proc.execute();
            this.setiNumSecuUsu(proc.getInt (1));

            proc.close();
        }  catch (SQLException se) {
            throw new SurException("Error SQL al obtener el usuario: " + se.getMessage());
        } catch (Exception e) {
            throw new SurException("Error Java: " + e.getMessage());
        } finally {
            try{
                if (proc != null) proc.close(); 
            } catch (SQLException see) {
                throw new SurException(see.getMessage());
            }
            return this;
        }
    }
    public Usuario getDBValidarCuit ( Connection dbCon) throws SurException {
       CallableStatement proc = null;

       try {
            proc = dbCon.prepareCall(db.getSettingCall("AFIP_EXISTE_CUIT (?)"));
            proc.registerOutParameter   (1, java.sql.Types.INTEGER);
            proc.setString              (2, this.getCuit());
            
            proc.execute();
            
            this.setcuitValido( proc.getInt (1) > 0 ? true : false );
            
            proc.close();

       }  catch (SQLException se) {
		throw new SurException("Error al cambiar el estado: " + se.getMessage());
        } catch (Exception e) {
		throw new SurException("Error al cambair el estado: " + e.getMessage());
        } finally {
            try{
                if (proc != null) proc.close (); 
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
            return this;
        }
    }
    
}
