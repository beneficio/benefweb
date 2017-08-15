/*
 * Tablas.java
 *
 * Created on 3 de febrero de 2005, 10:29
 */
  
package com.business.beans;

import java.util.LinkedList;
import com.business.db.*;
import com.business.util.*;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
/**
 *
 * @author  surprogra
 */
public class Tablas {
    private String sTabla = "";
    
    /** Creates a new instance of Tablas */
    public Tablas() {
    }
    
    public void setsTabla (String tabla) {
        sTabla = tabla;
    }
    
    public LinkedList getDatos ()  throws SurException { 
        LinkedList lTabla = new LinkedList (); 
        CallableStatement cons = null;
        Connection dbCon = null;
        try {             
            dbCon           = db.getConnection();    
            cons = dbCon.prepareCall(db.getSettingCall("GET_TABLAS (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString (2, this.sTabla);

            cons.execute();
           
            ResultSet rs = (ResultSet) cons.getObject (1); 
            
            if (rs != null) {
                while (rs.next ()) {    
                    lTabla.add(new Generico (rs.getString(1), rs.getString(2)));
                }
                rs.close ();                
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage()); 
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }
    
    public LinkedList getDatos (String param )  throws SurException { 
        LinkedList lTabla = new LinkedList (); 
        CallableStatement cons = null;
        Connection dbCon = null;
        try {             
            dbCon           = db.getConnection();    
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_TABLAS (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString (2, param);

            cons.execute();
           
            ResultSet rs = (ResultSet) cons.getObject (1); 
            
            if (rs != null) {
                while (rs.next ()) {    
                    lTabla.add(new Generico (rs.getString(1), rs.getString(2)));
                }
                rs.close ();                
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage()); 
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }

    public LinkedList getDatosOrderByDesc (String param )  throws SurException { 
        LinkedList lTabla = new LinkedList (); 
        CallableStatement cons = null;
        Connection dbCon = null;
        try {             
            dbCon           = db.getConnection();    
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_TABLAS_ORDER_BY_DESC (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString (2, param);

            cons.execute();
           
            ResultSet rs = (ResultSet) cons.getObject (1); 
            
            if (rs != null) {
                while (rs.next ()) {    
                    lTabla.add(new Generico (rs.getString(1), rs.getString(2)));
                }
                rs.close ();                
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage()); 
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }
    
    
    public LinkedList getRamas ()  throws SurException { 
        LinkedList lTabla = new LinkedList (); 
        CallableStatement cons = null;
        Connection dbCon = null;
        ResultSet rs = null;
        try {             
            dbCon           = db.getConnection();    
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_RAMAS ()"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);

            cons.execute();
           
           rs = (ResultSet) cons.getObject (1); 
            
            if (rs != null) {
                while (rs.next ()) {    
                    lTabla.add(new Generico (rs.getInt(1), rs.getString(2)));
                }
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close ();
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage()); 
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }

    public LinkedList getRamasPlanes ()  throws SurException {
        LinkedList lTabla = new LinkedList ();
        CallableStatement cons = null;
        Connection dbCon = null;
        ResultSet rs = null;
        try {
            dbCon           = db.getConnection();
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_RAMAS_PLANES ()"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);

            cons.execute();

           rs = (ResultSet) cons.getObject (1);

            if (rs != null) {
                while (rs.next ()) {
                    lTabla.add(new Generico (rs.getInt(1), rs.getString(2)));
                }
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close ();
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }

    public LinkedList getSubRamas (int param )  throws SurException { 


        LinkedList lTabla = new LinkedList (); 
        CallableStatement cons = null;
        ResultSet rs =  null;
        Connection dbCon = null;
        try {             
            dbCon           = db.getConnection();    
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_SUB_RAMA (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, param);

            cons.execute();
           
            rs = (ResultSet) cons.getObject (1); 
            
            if (rs != null) {
                while (rs.next ()) {    
                    lTabla.add(new Generico (rs.getInt(1), rs.getString(2)));
                }
                rs.close ();                
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage()); 
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }    

    public LinkedList getSubRamasProductos (int param,String usu)  throws SurException {


        LinkedList lTabla = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs =  null;
        Connection dbCon = null;
        try {
            dbCon           = db.getConnection();
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_SUB_RAMA_PRODUCTOS (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt    (2, param);
            cons.setString (3, usu);

            cons.execute();

            rs = (ResultSet) cons.getObject (1);

            if (rs != null) {
                while (rs.next ()) {
                    lTabla.add(new Generico (rs.getInt(1), rs.getString(2)));
                }
                rs.close ();
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }

    public LinkedList getSubRamasProductos (int param,String usu, String operacion)  throws SurException {


        LinkedList lTabla = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs =  null;
        Connection dbCon = null;
        try {
            dbCon           = db.getConnection();
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_SUB_RAMA_PRODUCTOS (?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt    (2, param);
            cons.setString (3, usu);
            cons.setString (4, operacion);

            cons.execute();

            rs = (ResultSet) cons.getObject (1);

            if (rs != null) {
                while (rs.next ()) {
                    lTabla.add(new Generico (rs.getInt(1), rs.getString(2)));
                }
                rs.close ();
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }

    public LinkedList getSubRamasPlanes (int param, String usu )  throws SurException {


        LinkedList lTabla = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs =  null;
        Connection dbCon = null;
        try {
            dbCon           = db.getConnection();
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_SUB_RAMA_PLANES (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, param);
            cons.setString (3, usu);

            cons.execute();

            rs = (ResultSet) cons.getObject (1);

            if (rs != null) {
                while (rs.next ()) {
                    lTabla.add(new Generico (rs.getInt(1), rs.getString(2)));
                }
                rs.close ();
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }
    
    public LinkedList getActividades ()  throws SurException { 
        LinkedList lTabla = new LinkedList (); 
        CallableStatement cons = null;
        Connection dbCon = null;
        ResultSet rs =  null;
        try {             
            dbCon           = db.getConnection();    
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_ACTIVIDADES ()"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);

            cons.execute();
           
            rs = (ResultSet) cons.getObject (1); 
            
            if (rs != null) {
                while (rs.next ()) {    
                    lTabla.add(new Generico (rs.getInt(1), rs.getString(2)));
                }
                rs.close ();                
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage()); 
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }

    public LinkedList getActividades (String param)  throws SurException { 
        LinkedList lTabla = new LinkedList (); 
        CallableStatement cons = null;
        Connection dbCon = null;
        ResultSet rs =  null;
        try {             
            dbCon           = db.getConnection();    
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_ACTIVIDADES (?)"));
            cons.setString(2, param);
            cons.registerOutParameter(1, java.sql.Types.OTHER);

            cons.execute();
           
            rs = (ResultSet) cons.getObject (1); 
            
            if (rs != null) {
                while (rs.next ()) {    
                    lTabla.add(new Generico (rs.getInt(1), rs.getString(2)));
                }
                rs.close ();                
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage()); 
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }
    
    public LinkedList getActividadesCategorias ()  throws SurException { 
        LinkedList lTabla = new LinkedList (); 
        CallableStatement cons = null;
        Connection dbCon = null;
        try {             
            dbCon           = db.getConnection();    
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_ACTIVIDADES_CATEGORIAS ()"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);

            cons.execute();
           
            ResultSet rs = (ResultSet) cons.getObject (1); 
            
            if (rs != null) {
                while (rs.next ()) {    
                    lTabla.add(new Generico (rs.getString(1), rs.getString(2)));
                }
                rs.close ();                
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage()); 
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }

//--------------------------------------------------------------------------
/*
 * getBancos
 */
    public LinkedList getBancos()  throws SurException { 
        LinkedList lTabla = new LinkedList (); 
        CallableStatement cons = null;
        Connection dbCon = null;
        try {             
            dbCon           = db.getConnection();    
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_BANCOS ()"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);

            cons.execute();
           
            ResultSet rs = (ResultSet) cons.getObject (1); 
            
            if (rs != null) {
                while (rs.next ()) {    
                    lTabla.add(new Generico (rs.getInt(1), rs.getString(2)));
                }
                rs.close ();                
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage()); 
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }    

    public LinkedList getBancosConvenio (int codProd)  throws SurException {
        LinkedList lTabla = new LinkedList ();
        CallableStatement cons = null;
        Connection dbCon = null;
        ResultSet rs = null;
        try {
            dbCon           = db.getConnection();
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_BANCOS_CONVENIO (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, codProd);

            cons.execute();

            rs = (ResultSet) cons.getObject (1);

            if (rs != null) {
                while (rs.next ()) {
                    lTabla.add(new Generico (rs.getInt(1), rs.getString(2)));
                }
                rs.close ();
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close();
                if (rs != null) rs.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }

    public LinkedList getEntidadSobre (int codProd)  throws SurException {
        LinkedList lEntidad = new LinkedList ();
        CallableStatement cons = null;
        Connection dbCon = null;
        ResultSet rs = null;
        try {
            dbCon           = db.getConnection();
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_ENTIDAD_SOBRE (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, codProd);

            cons.execute();

            rs = (ResultSet) cons.getObject (1);

            if (rs != null) {
                while (rs.next ()) {
                    EntidadSobre oEnt = new EntidadSobre ();
                    oEnt.setcodigo      (rs.getInt ("CODIGO"));
                    oEnt.setdescripcion (rs.getString("DESCRIPCION"));
                    oEnt.setmcaBaja     (rs.getString("MCA_BAJA"));
                    oEnt.setmcaCuenta   (rs.getString("MCA_CUENTA"));
                    oEnt.setsizeCuenta  (rs.getInt("SIZE_CUENTA"));
                    oEnt.setmcaConvenio (rs.getString("MCA_CONVENIO"));
                    lEntidad.add(oEnt);
                }
                rs.close ();
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close();
                if (rs != null) rs.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
            return lEntidad;
        }
    }
    
    /*
     * getFormaPagos
     */ 
    public LinkedList getFormasPagos()  throws SurException { 
        LinkedList lTabla = new LinkedList (); 
        CallableStatement cons = null;
        Connection dbCon = null;
        try {             
            dbCon           = db.getConnection();    
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_FORMAS_PAGOS ()"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);

            cons.execute();
           
            ResultSet rs = (ResultSet) cons.getObject (1); 
            
            if (rs != null) {
                while (rs.next ()) {    
                    lTabla.add(new Generico (rs.getInt(1), rs.getString(2)));
                }
                rs.close ();                
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage()); 
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }        
    
    
    /*
     * getTarjetas
     */ 
    public LinkedList getTarjetas()  throws SurException { 
        LinkedList lTabla = new LinkedList (); 
        CallableStatement cons = null;
        Connection dbCon = null;
        try {             
            dbCon           = db.getConnection();    
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_TARJETAS ()"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);

            cons.execute();
           
            ResultSet rs = (ResultSet) cons.getObject (1); 
            
            if (rs != null) {
                while (rs.next ()) {    
                    lTabla.add(new Generico (rs.getInt(1), rs.getString(2)));
                }
                rs.close ();                
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage()); 
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }            
    // -------------------------------------------------------------------------
    public LinkedList getPlanes (int pRama, int pSubRama , int pCodProd, String user )  throws SurException { 


        LinkedList lTabla = new LinkedList (); 
        CallableStatement cons = null;
        ResultSet rs =  null;
        Connection dbCon = null;
        try {             
            dbCon           = db.getConnection();    
            dbCon.setAutoCommit(false);
            
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_PLANES (?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt    (2, pRama);
            cons.setInt    (3, pSubRama);
            cons.setInt    (4, pCodProd);
            cons.setString (5, user);
            
            cons.execute();
           
            rs = (ResultSet) cons.getObject (1); 
            
            if (rs != null) {
                while (rs.next ()) { 
                    Plan oPlan = new Plan ();
                     oPlan.setcodPlan       ( rs.getInt     ("COD_PLAN"));
                     oPlan.setcodRama       (rs.getInt      ("COD_RAMA"));
                     oPlan.setcodSubRama    (rs.getInt      ("COD_SUB_RAMA"));
                     oPlan.setdescripcion   (rs.getString   ("DESCRIPCION"));
                     oPlan.setcondiciones   (rs.getString   ("CONDICIONES"));
                     oPlan.setmedidaSeg     (rs.getString   ("MEDIDA_SEG"));
                     oPlan.setcodAmbito     (rs.getInt      ("COD_AMBITO"));
                     oPlan.setcodVigencia   (rs.getInt      ("COD_VIGENCIA"));
                     oPlan.setcantMaxCuotas (rs.getInt      ("CANT_MAX_CUOTAS"));
                     oPlan.setcodProducto   (rs.getInt      ("COD_PRODUCTO"));
                    
                     lTabla.add(oPlan);
                }
                rs.close ();                
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage()); 
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }        

    public LinkedList getOpcionesAjuste (int pRama, int pSubRama , int pCodProd, String tipoCot )  throws SurException { 
        LinkedList lTabla = new LinkedList (); 
        CallableStatement cons = null;
        ResultSet rs =  null;
        Connection dbCon = null;
        try {     
            dbCon  = db.getConnection();    
            dbCon.setAutoCommit(false);
            
            cons = dbCon.prepareCall(db.getSettingCall("OPC_GET_ALL_OPCION_AJUSTE (?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt    (2, pRama   );
            cons.setInt    (3, pSubRama);
            cons.setInt    (4, pCodProd);
            cons.setString (5, tipoCot );
            
            cons.execute();
           
            rs = (ResultSet) cons.getObject (1); 
            
            if (rs != null) {
                while (rs.next ()) { 
                    OpcionAjuste oOpc = new OpcionAjuste ();
                     oOpc.setcodOpcion     (rs.getInt     ("COD_OPCION"));
                     oOpc.setdescripcion   (rs.getString  ("DESCRIPCION"));
                     oOpc.setcodAmbito     (rs.getInt     ("COD_AMBITO"));
                     lTabla.add(oOpc);
                }
                rs.close ();                
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage()); 
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }

    public LinkedList getOpcionesAjuste (int pRama, int pSubRama , int pCodProd, String tipoCot, int iCodAmbito )  throws SurException {
        LinkedList lTabla = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs =  null;
        Connection dbCon = null;
        try {
            dbCon  = db.getConnection();
            dbCon.setAutoCommit(false);

            cons = dbCon.prepareCall(db.getSettingCall("OPC_GET_ALL_OPCION_AJUSTE (?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt    (2, pRama   );
            cons.setInt    (3, pSubRama);
            cons.setInt    (4, pCodProd);
            cons.setString (5, tipoCot );

            cons.execute();

            rs = (ResultSet) cons.getObject (1);

            if (rs != null) {
                while (rs.next ()) {
                    if (rs.getInt ("COD_AMBITO") == iCodAmbito) {
                        OpcionAjuste oOpc = new OpcionAjuste ();
                         oOpc.setcodOpcion     (rs.getInt     ("COD_OPCION"));
                         oOpc.setdescripcion   (rs.getString  ("DESCRIPCION"));
                         oOpc.setcodAmbito     (rs.getInt     ("COD_AMBITO"));
                         lTabla.add(oOpc);
                    }
                }
                rs.close ();
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }

    public LinkedList getProductos (int pRama, int pSubRama , int pCodProd, String usu )
            throws SurException {
        LinkedList lTabla = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs =  null;
        Connection dbCon = null;
        try {
            dbCon  = db.getConnection();
            dbCon.setAutoCommit(false);

            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_PRODUCTOS (?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt    (2, pRama   );
            cons.setInt    (3, pSubRama);
            cons.setInt    (4, pCodProd);
            cons.setString (5, usu);

            cons.execute();

            rs = (ResultSet) cons.getObject (1);

            if (rs != null) {
                while (rs.next ()) {
                    Producto oProd = new Producto ();
                    oProd.setcodProducto (rs.getInt     ("COD_PRODUCTO"));
                    oProd.setdescProducto(rs.getString  ("DESC_PRODUCTO"));
                    oProd.setnivelCob(rs.getString ("NIVEL_COB"));
                    oProd.settipoNomina(rs.getString ("TIPO_NOMINA"));
                    oProd.setexisteSubSeccion(rs.getString ("EXISTE_SUBSECCION"));
                    lTabla.add(oProd);
                }
                rs.close ();
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }

    public LinkedList getProductos (int pRama, int pSubRama , int pCodProd, String usu, String operacion )
            throws SurException {
        LinkedList lTabla = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs =  null;
        Connection dbCon = null;
        try {
            dbCon  = db.getConnection();
            dbCon.setAutoCommit(false);

            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_PRODUCTOS (?,?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt    (2, pRama   );
            cons.setInt    (3, pSubRama);
            cons.setInt    (4, pCodProd);
            cons.setString (5, usu);
            cons.setString (6, operacion); // 'C' = cotizador - 'E' emision

            cons.execute();

            rs = (ResultSet) cons.getObject (1);

            if (rs != null) {
                while (rs.next ()) {
                    Producto oProd = new Producto ();
                    oProd.setcodProducto (rs.getInt     ("COD_PRODUCTO"));
                    oProd.setdescProducto(rs.getString  ("DESC_PRODUCTO"));
                    oProd.setnivelCob(rs.getString ("NIVEL_COB"));
                    oProd.settipoNomina(rs.getString ("TIPO_NOMINA"));
                    oProd.setexisteSubSeccion(rs.getString ("EXISTE_SUBSECCION"));
                    lTabla.add(oProd);
                }
                rs.close ();
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }

    public LinkedList getProductosAbm (int pRama, int pSubRama, String usu )
            throws SurException {
        LinkedList lTabla = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs =  null;
        Connection dbCon = null;
        try {
            dbCon  = db.getConnection();
            dbCon.setAutoCommit(false);

            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_PRODUCTOS_ABM (?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt    (2, pRama   );
            cons.setInt    (3, pSubRama);
            cons.setString (4, usu);

            cons.execute();

            rs = (ResultSet) cons.getObject (1);

            if (rs != null) {
                while (rs.next ()) {
                    Producto oProd = new Producto ();
                    oProd.setcodProducto (rs.getInt     ("COD_PRODUCTO"));
                    oProd.setdescProducto(rs.getString  ("DESC_PRODUCTO"));
                    oProd.setnivelCob(rs.getString ("NIVEL_COB"));
                    oProd.settipoNomina(rs.getString ("TIPO_NOMINA"));
                    lTabla.add(oProd);
                }
                rs.close ();
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }
    
    public LinkedList getGrupos (String user )  throws SurException {


        LinkedList lTabla = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs =  null;
        Connection dbCon = null;
        try {
            dbCon           = db.getConnection();
            dbCon.setAutoCommit(false);

            cons = dbCon.prepareCall(db.getSettingCall("US_GET_ALL_GRUPOS (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString (2, user);

            cons.execute();

            rs = (ResultSet) cons.getObject (1);

            if (rs != null) {
                while (rs.next ()) {
                    Grupo oG = new Grupo ();
                    oG.setiCodGrupo    (rs.getInt ("COD_GRUPO"));
                    oG.setsDescripcion (rs.getString   ("DESCRIPCION"));
                    oG.setsCodProdDC   (rs.getString   ("COD_PROD_DC"));
                    oG.setiCodOrg      (rs.getInt      ("COD_ORG"));
                    oG.setiCodProd     (rs.getInt      ("COD_PROD"));
                    lTabla.add(oG);
                }
                rs.close ();
            }
            cons.close ();

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }
    
    public LinkedList getAllCoberturasOpcion (int codCobOpcion, 
                                              int pRama, 
                                              int pSubRama , 
                                              int pCodProducto, 
                                              int pCodProd, 
                                              String pParentesco, 
                                              String usu,
                                              int edad)
            throws SurException {
        LinkedList lTabla = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs =  null;
        Connection dbCon = null;
        try {
            dbCon  = db.getConnection();
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_COBERTURAS_OPCION (?,?,?,?,?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt    (2, codCobOpcion);
            cons.setInt    (3, pRama   );
            cons.setInt    (4, pSubRama);
            cons.setInt    (5, pCodProducto);
            cons.setString (6, pParentesco);
            cons.setInt    (7, pCodProd);
            cons.setString (8, usu);
            cons.setInt    (9, edad);

            cons.execute();

            rs = (ResultSet) cons.getObject (1);

            if (rs != null) {
                while (rs.next ()) {
                    CoberturaOpcion oCob = new  CoberturaOpcion();

                    oCob.setcodCobOpcion    (rs.getInt ("COD_COB_OPCION"));
                    oCob.setcodRama         (rs.getInt ("COD_RAMA"));
                    oCob.setcodSubRama      (rs.getInt ("COD_SUB_RAMA"));
                    oCob.setcodProducto     (rs.getInt ("COD_PRODUCTO"));
                    oCob.setcodAgrupCob     (rs.getInt ("COD_AGRUP_COB"));
                    oCob.setdescripcion     (rs.getString ("DESCRIPCION"));
                    oCob.setcategoria       (rs.getString ("CATEGORIA"));
                    oCob.setimpPremioAnual  (rs.getDouble("IMP_PREMIO_ANUAL"));
                    oCob.setimpPremioMensual(rs.getDouble("IMP_PREMIO_MENSUAL"));
                    oCob.setmcaHijos        (rs.getString ("MCA_HIJOS"));
                    oCob.setedadMin         (rs.getInt ("EDAD_MIN"));
                    oCob.setedadMax         (rs.getInt ("EDAD_MAX"));
                    oCob.setedadPermanencia (rs.getInt ("EDAD_PERMANENCIA"));
                    oCob.setmcaAdherente    (rs.getString ("MCA_ADHERENTE"));
                    oCob.setedadMinHi(rs.getInt("EDAD_MIN_HI"));
                    oCob.setedadMaxHi(rs.getInt("EDAD_MAX_HI"));
                    oCob.setedadPermanenciaHi (rs.getInt("EDAD_PERMANENCIA_HI"));
                    oCob.setedadMinAd(rs.getInt("EDAD_MIN_AD"));
                    oCob.setedadMaxAd(rs.getInt("EDAD_MAX_AD"));
                    oCob.setedadPermanenciaAd (rs.getInt("EDAD_PERMANENCIA_AD"));

                    lTabla.add(oCob);
                }
                rs.close ();
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }

    public LinkedList getActividades (int iCodRama, int iCodSubRama, int iCodProducto, int iCodRubro)  throws SurException {
        LinkedList lTabla = new LinkedList ();
        CallableStatement cons = null;
        Connection dbCon = null;
        ResultSet rs =  null;
        try {
            dbCon           = db.getConnection();
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("COT_GET_ALL_ACTIVIDADES (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, iCodRama);
            cons.setInt (3, iCodRubro);

            cons.execute();

            rs = (ResultSet) cons.getObject (1);

            if (rs != null) {
                while (rs.next ()) {
                    ActividadCategoria ac = new ActividadCategoria();
                    ac.setiCodRubro(rs.getInt ("COD_RUBRO"));
                    ac.setcodActividad(rs.getInt ("COD_ACTIVIDAD"));
                    ac.setcategoria(rs.getInt ("CATEGORIA"));
                    ac.setdescripcion(rs.getString ("DESCRIPCION"));
                    lTabla.add(ac);
                }
                rs.close ();
            }
            cons.close ();

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }
    
    public LinkedList getAllTiposEndoso (int pRama, int pSubRama , int iCodProducto, int pCodProd, String usuario )  throws SurException {
        LinkedList lTabla = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs =  null;
        Connection dbCon = null;
        boolean bExisteSubRama = false;
        boolean bExisteProducto = false;
        boolean bExisteProductor = false;
        boolean bExisteTipoUsuario = false;
        try {
            dbCon  = db.getConnection();
            dbCon.setAutoCommit(false);

            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_TIPOS_ENDOSO (?,?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt    (2, pRama   );
            cons.setInt    (3, pSubRama);
            cons.setInt    (4, iCodProducto);
            cons.setInt    (5, pCodProd);
            cons.setString (6, usuario);

            cons.execute();

            rs = (ResultSet) cons.getObject (1);

            boolean bGrabar;
            if (rs != null) {
                while (rs.next ()) {
                    bGrabar = true;
                    if ( rs.getInt ("COD_SUB_RAMA") == pSubRama ) {
                        bExisteSubRama = true;
                    }
                    if ( rs.getInt ("COD_PROD") == pCodProd ) {
                        bExisteProductor = true;
                    }
                    if ( rs.getInt ("COD_PRODUCTO") == iCodProducto ) {
                        bExisteProducto = true;
                    }

                    if ( rs.getInt ("COD_SUB_RAMA") == 99 &&  bExisteSubRama ) {
                        bGrabar = false;
                    }

                    if  ( rs.getInt ("COD_PRODUCTO") == 999 && bExisteProducto ) {
                        bGrabar = false;
                    }
                    if  ( rs.getInt ("COD_PROD") == 99999999 && bExisteProductor ) {
                        bGrabar = false;
                    }
                    if  ( rs.getString ("TIPO_USUARIO").equals("99") && bExisteTipoUsuario ) {
                        bGrabar = false;
                    }

                    if (bGrabar ) {

                        TipoEndoso oTP = new TipoEndoso (rs.getInt("CODIGO"), rs.getString  ("DESCRIPCION"));
                        oTP.setformulario(rs.getString ("FORMULARIO"));
                        oTP.setnivel(rs.getString ("NIVEL_ENDOSO"));
                        lTabla.add(oTP);
                    }
                }
                rs.close ();
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }   

    public LinkedList getAllDocumentos (int rama, int numPoliza , int numPropuesta, 
            int codProd, int numSini, int numTomador, int certificado, int subCertificado, 
            String usuario )  throws SurException {
        LinkedList <Documentacion> lTabla = null;
        CallableStatement cons = null;
        ResultSet rs =  null;
        Connection dbCon = null;
        try {
            dbCon  = db.getConnection();
            dbCon.setAutoCommit(false);

            cons = dbCon.prepareCall(db.getSettingCall("DOC_GET_ALL_DOCUMENTACION (?,?,?,?,?,?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            if (rama != 0) cons.setInt    (2, rama   ); 
            else cons.setNull (2, java.sql.Types.INTEGER);
            if (numPoliza != 0) cons.setInt    (3, numPoliza);
            else cons.setNull (3, java.sql.Types.INTEGER);
            if (numPropuesta != 0) cons.setInt    (4, numPropuesta);
            else cons.setNull (4, java.sql.Types.INTEGER);
            if (codProd != 0) cons.setInt    (5, codProd);
            else cons.setNull (5, java.sql.Types.INTEGER);
            if (numSini != 0) cons.setInt    (6, numSini);
            else cons.setNull (6, java.sql.Types.INTEGER);
            if (numTomador != 0) cons.setInt    (7, numTomador);
            else cons.setNull (7, java.sql.Types.INTEGER);
            if (certificado != 0) cons.setInt    (8, certificado);            
            else cons.setNull (8, java.sql.Types.INTEGER);
            cons.setInt    (9, subCertificado);                        
            cons.setString (10, usuario);

            cons.execute();

            rs = (ResultSet) cons.getObject (1);
            if (rs != null) {
                lTabla = new LinkedList ();
                while (rs.next ()) {
                    Documentacion oDoc = new Documentacion();
                    oDoc.setnumDocumento(rs.getInt ("NUM_DOCUMENTO"));
                    oDoc.setNumPropuesta(rs.getInt ("NUM_PROPUESTA"));
                    oDoc.setCodRama(rs.getInt ("COD_RAMA"));
                    oDoc.setNumPoliza(rs.getInt ("NUM_POLIZA"));
                    oDoc.setNumSiniestro(rs.getInt ("NUM_SINIESTRO"));
                    oDoc.setnomArchivo(rs.getString("NOM_ARCHIVO"));
                    oDoc.setmcaBaja(rs.getString ("MCA_BAJA"));
                    oDoc.setUserid(rs.getString ("USERID"));
                    oDoc.setFechaTrabajo(rs.getDate("FECHA_TRABAJO"));
                    oDoc.setHoraTrabajo(rs.getString ("HORA_TRABAJO"));
                    oDoc.setCodProd(rs.getInt ("COD_PROD"));
                    oDoc.setNumTomador(rs.getInt ("NUM_TOMADOR"));
                    oDoc.settipoDocumento(rs.getInt ("TIPO_DOCUMENTO"));
                    oDoc.setDescTipoDoc(rs.getString ("DESC_TIPO_DOC"));
                    oDoc.setcertificado(rs.getInt ("CERTIFICADO"));
                    oDoc.setsubCertificado(rs.getInt ("SUB_CERTIFICADO"));                    
                    lTabla.add(oDoc);
                }
                rs.close ();
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
            return lTabla;
        }
    }

}
