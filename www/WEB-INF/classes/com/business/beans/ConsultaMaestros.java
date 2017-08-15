/*
 * ConsultaMaestros.java
 *
 * Created on 7 de julio de 2003, 13:21 by Gisela Cabot
 *
 */    
  
package com.business.beans;
          
import java.util.LinkedList;
import com.business.db.*;    
import com.business.util.*;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;

public class ConsultaMaestros {
    
//    private static CallableStatement cons = null;
//    private static db conn  = null; 
    
    
    /** Creates a new instance of ConsultaMaestros */
    public  ConsultaMaestros() {
          
    }
    
    public static LinkedList getAllCondFacturacion (int iCodRama) throws SurException  {             
        LinkedList lf = new LinkedList (); 
        Connection dbCon = null;
        try {    
            dbCon = db.getConnection();
            
            lf = getAllCondFacturacion(dbCon, iCodRama);
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
            return lf;
        }
    }

    public static LinkedList getAllCondFacturacion (int iCodRama, int iCodSubRama) throws SurException  {
        LinkedList lf = new LinkedList ();
        Connection dbCon = null;
        try {
            dbCon = db.getConnection();

            lf = getAllCondFacturacion(dbCon, iCodRama, iCodSubRama);

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
            return lf;
        }
    }


    public static LinkedList getAllCondFacturacion (Connection dbCon, int iCodRama) throws SurException  {             
        LinkedList lf = new LinkedList (); 
        CallableStatement cons = null;
        ResultSet rs =   null;
        try {             
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_COND_FACTURACION (?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, iCodRama);

            cons.execute();
           
            rs = (ResultSet) cons.getObject (1); 
            
            if (rs != null) {
                while (rs.next ()) {
                    Facturacion of = new Facturacion ();
                    of.setcodRama     (rs.getInt ("COD_RAMA"));
                    of.setcantDesde   (rs.getInt ("CANT_DESDE"));
                    of.setcantHasta   (rs.getInt ("CANT_HASTA"));
                    of.setcodFacturacion(rs.getInt ("COD_FACTURACION"));
                    of.setcantCuotas  (rs.getInt ("MAX_CUOTAS"));
                    of.setcodVigencia (rs.getInt ("COD_VIGENCIA"));
                    of.setdescFacturacion(rs.getString ("DESC_FACT"));
                    
                    lf.add(of);
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
            return lf;
        }
    }

    public static LinkedList getAllCondFacturacion (Connection dbCon, int iCodRama, int iCodSubRama)
                throws SurException  {
        LinkedList lf = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs =   null;
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_COND_FACTURACION (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, iCodRama);
            cons.setInt (3, iCodSubRama);

            cons.execute();

            rs = (ResultSet) cons.getObject (1);

            if (rs != null) {
                while (rs.next ()) {
                    Facturacion of = new Facturacion ();
                    of.setcodRama     (rs.getInt ("COD_RAMA"));
                    of.setcantDesde   (rs.getInt ("CANT_DESDE"));
                    of.setcantHasta   (rs.getInt ("CANT_HASTA"));
                    of.setcodFacturacion(rs.getInt ("COD_FACTURACION"));
                    of.setcantCuotas  (rs.getInt ("MAX_CUOTAS"));
                    of.setcodVigencia (rs.getInt ("COD_VIGENCIA"));
                    of.setdescFacturacion(rs.getString ("DESC_FACT"));

                    lf.add(of);
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
            return lf;
        }
    }

    public static LinkedList getAllCondFacturacion (Connection dbCon, int iCodRama, int iCodSubRama, int codProducto, int codVigencia, int codPlan)
        throws SurException  {
        LinkedList lf = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs =   null;
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_COND_FACTURACION (?, ?, ?, ?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, iCodRama);
            cons.setInt (3, iCodSubRama);
            cons.setInt (4, codProducto);
            cons.setInt (5, codVigencia);
            cons.setInt (6, codPlan);

            cons.execute();
            rs = (ResultSet) cons.getObject (1);

            if (rs != null) {
                while (rs.next ()) {
                    Facturacion of = new Facturacion ();
                    of.setcodRama     (rs.getInt ("COD_RAMA"));
                    of.setcantDesde   (rs.getInt ("CANT_DESDE"));
                    of.setcantHasta   (rs.getInt ("CANT_HASTA"));
                    of.setcodFacturacion(rs.getInt ("COD_FACTURACION"));
                    of.setcantCuotas  (rs.getInt ("MAX_CUOTAS"));
                    of.setcodVigencia (rs.getInt ("COD_VIGENCIA"));
                    of.setdescFacturacion(rs.getString ("DESC_FACT"));
                    of.setcodSubRama(rs.getInt ("COD_SUB_RAMA"));
                    of.setcodProducto(rs.getInt ("COD_PRODUCTO"));
                    lf.add(of);
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
            return lf;
        }
    }

    public static LinkedList getAllCondFacturacion (Connection dbCon, int iCodRama, int iCodSubRama,
                                                    int codProducto, int codVigencia, int codPlan, int codProd)
        throws SurException  {
        LinkedList lf = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs =   null;
        boolean bExisteSubRama = false;
        boolean bExisteProducto = false;
        boolean bExisteProductor = false;
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_COND_FACTURACION (?, ?, ?, ?, ?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, iCodRama);
            cons.setInt (3, iCodSubRama);
            cons.setInt (4, codProducto);
            cons.setInt (5, codVigencia);
            cons.setInt (6, codPlan);
            cons.setInt (7, codProd);

            cons.execute();
            rs = (ResultSet) cons.getObject (1);
            boolean bGrabar;
            if (rs != null) {
                while (rs.next ()) {
                    bGrabar = true;
                    if ( rs.getInt ("COD_SUB_RAMA") == iCodSubRama ) {
                        bExisteSubRama = true;
                    }
                    if ( rs.getInt ("COD_PROD") == codProd ) {
                        bExisteProductor = true;
                    }
                    if ( rs.getInt ("COD_PRODUCTO") == codProducto ) {
                        bExisteProducto = true;
                    }

                    if ( rs.getInt ("COD_SUB_RAMA") == 999 &&  bExisteSubRama ) {
                        bGrabar = false;
                    }

                    if  ( rs.getInt ("COD_PRODUCTO") == 999 && bExisteProducto ) {
                        bGrabar = false;
                    }
                    if  ( rs.getInt ("COD_PROD") == 99999999 && bExisteProductor ) {
                        bGrabar = false;
                    }

                    if (bGrabar ) {
                        Facturacion of = new Facturacion ();
                        of.setcodRama       (rs.getInt ("COD_RAMA"));
                        of.setcantDesde     (rs.getInt ("CANT_DESDE"));
                        of.setcantHasta     (rs.getInt ("CANT_HASTA"));
                        of.setcodFacturacion(rs.getInt ("COD_FACTURACION"));
                        of.setcantCuotas    (rs.getInt ("MAX_CUOTAS"));
                        of.setcodVigencia   (rs.getInt ("COD_VIGENCIA"));
                        of.setdescFacturacion(rs.getString ("DESC_FACT"));
                        of.setcodSubRama    (rs.getInt ("COD_SUB_RAMA"));
                        of.setcodProducto   (rs.getInt ("COD_PRODUCTO"));

                        lf.add(of);
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
            return lf;
        }
    }

    public static LinkedList getAllCondFacturacion (Connection dbCon, int iCodRama, int iCodSubRama,
                                                    int codProducto, int codVigencia, int codPlan,
                                                    int codProd, int cantVidas)
        throws SurException  {
        LinkedList lf = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs =   null;
        boolean bExisteSubRama = false;
        boolean bExisteProducto = false;
        boolean bExisteProductor = false;
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_COND_FACTURACION (?, ?, ?, ?, ?, ?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, iCodRama);
            cons.setInt (3, iCodSubRama);
            cons.setInt (4, codProducto);
            cons.setInt (5, codVigencia);
            cons.setInt (6, codPlan);
            cons.setInt (7, codProd);
            cons.setInt (8, cantVidas);

            cons.execute();
            rs = (ResultSet) cons.getObject (1);
            boolean bGrabar;
            if (rs != null) {
                while (rs.next ()) {
                    bGrabar = true;
                    if ( rs.getInt ("COD_SUB_RAMA") == iCodSubRama ) {
                        bExisteSubRama = true;
                    }
                    if ( rs.getInt ("COD_PROD") == codProd ) {
                        bExisteProductor = true;
                    }
                    if ( rs.getInt ("COD_PRODUCTO") == codProducto ) {
                        bExisteProducto = true;
                    }

                    if ( rs.getInt ("COD_SUB_RAMA") == 999 &&  bExisteSubRama ) {
                        bGrabar = false;
                    }

                    if  ( rs.getInt ("COD_PRODUCTO") == 999 && bExisteProducto ) {
                        bGrabar = false;
                    }
                    if  ( rs.getInt ("COD_PROD") == 99999999 && bExisteProductor ) {
                        bGrabar = false;
                    }

                    if (bGrabar ) {
                        Facturacion of = new Facturacion ();
                        of.setcodRama       (rs.getInt ("COD_RAMA"));
                        of.setcantDesde     (rs.getInt ("CANT_DESDE"));
                        of.setcantHasta     (rs.getInt ("CANT_HASTA"));
                        of.setcodFacturacion(rs.getInt ("COD_FACTURACION"));
                        of.setcantCuotas    (rs.getInt ("MAX_CUOTAS"));
                        of.setcodVigencia   (rs.getInt ("COD_VIGENCIA"));
                        of.setdescFacturacion(rs.getString ("DESC_FACT"));
                        of.setcodSubRama    (rs.getInt ("COD_SUB_RAMA"));
                        of.setcodProducto   (rs.getInt ("COD_PRODUCTO"));

                        lf.add(of);
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
            return lf;
        }
    }

    public static LinkedList cotGetAllFacturacion (Connection dbCon, int codRama, int codSubRama, int numCotizacion)
        throws SurException  {
        LinkedList lf = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs =   null;
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("COT_GET_ALL_FACTURACION (?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, codRama); 
            cons.setInt (3, codSubRama); 
            cons.setInt (4, numCotizacion);

            cons.execute();
            rs = (ResultSet) cons.getObject (1);
            if (rs != null) {
                while (rs.next ()) {

                    Facturacion of = new Facturacion ();
                    of.setcodFacturacion(rs.getInt ("COD_FACTURACION"));
                    of.setcantCuotas    (rs.getInt ("MAX_CUOTAS"));
                    of.setdescFacturacion(rs.getString ("DESC_FACT"));
                    of.setimpCuota      (rs.getDouble ("IMP_CUOTA"));
                    of.setimpFacturacion(rs.getDouble ("IMP_FACTURACION"));

                    lf.add(of);
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
            return lf;
        }
    }
    

    public static LinkedList getAllFormaPago (Connection dbCon, int iCodRama, int iCodSubRama,
                                                    int codProducto, int codPlan,  int codProd)
        throws SurException  {
        LinkedList lf = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs =   null;
        boolean bExisteSubRama = false;
        boolean bExisteProducto = false;
        boolean bExisteProductor = false;
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_FORMA_PAGO (?, ?, ?, ?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, iCodRama);
            cons.setInt (3, iCodSubRama);
            cons.setInt (4, codProducto);
            cons.setInt (5, codPlan);
            cons.setInt (6, codProd);

            cons.execute();
            rs = (ResultSet) cons.getObject (1);
            boolean bGrabar;
            if (rs != null) {
                while (rs.next ()) {
                    bGrabar = true;
                    if ( rs.getInt ("COD_SUB_RAMA") == iCodSubRama ) {
                        bExisteSubRama = true;
                    }
                    if ( rs.getInt ("COD_PROD") == codProd ) {
                        bExisteProductor = true;
                    }
                    if ( rs.getInt ("COD_PRODUCTO") == codProducto ) {
                        bExisteProducto = true;
                    }

                    if ( rs.getInt ("COD_SUB_RAMA") == 999 &&  bExisteSubRama ) {
                        bGrabar = false;
                    }
                    
                    if  ( rs.getInt ("COD_PRODUCTO") == 999 && bExisteProducto ) {
                        bGrabar = false;
                    }
                    if  ( rs.getInt ("COD_PROD") == 99999999 && bExisteProductor ) {
                        bGrabar = false;
                    }

                    if (bGrabar ) {
                        FormaPago of = new FormaPago (rs.getInt ("COD_FORMA_PAGO"), rs.getString ("DESCRIPCION"), rs.getString("TRATAMIENTO"));
                        lf.add(of);
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
            return lf;
        }
    }

    public static LinkedList getAllVigencias (Connection dbCon, int iCodRama, int iCodSubRama)
                throws SurException  {
        LinkedList lf = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs =   null;
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_VIGENCIAS (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, iCodRama);
            cons.setInt (3, iCodSubRama);

            cons.execute();

            rs = (ResultSet) cons.getObject (1);

            if (rs != null) {
                while (rs.next ()) {
                    Vigencia vig = new Vigencia ();
                    vig.setcodRama     (rs.getInt ("COD_RAMA"));
                    vig.setcodRama     (rs.getInt ("COD_SUB_RAMA"));
                    vig.setcantCuotas  (rs.getInt ("CANT_CUOTAS"));
                    vig.setcantMeses   (rs.getInt ("CANT_MESES"));
                    vig.setcantDias    (rs.getInt ("CANT_DIAS"));
                    vig.setcodVigencia (rs.getInt ("COD_VIGENCIA"));
                    vig.setdescVigencia(rs.getString ("DESCRIPCION"));

                    lf.add(vig);
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
            return lf;
        }
    }

    public static LinkedList getAllVigencias (Connection dbCon, int iCodRama, int iCodSubRama, int codProducto, int codPlan)
       throws SurException  {
        LinkedList lf = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs =   null;
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_VIGENCIAS (?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, iCodRama);
            cons.setInt (3, iCodSubRama);
            cons.setInt (4, codProducto);
            cons.setInt (5, codPlan);
            cons.execute();

            rs = (ResultSet) cons.getObject (1);

            if (rs != null) {
                while (rs.next ()) {
                    Vigencia vig = new Vigencia ();
                    vig.setcodRama     (rs.getInt ("COD_RAMA"));
                    vig.setcodRama     (rs.getInt ("COD_SUB_RAMA"));
                    vig.setcantCuotas  (rs.getInt ("CANT_CUOTAS"));
                    vig.setcantMeses   (rs.getInt ("CANT_MESES"));
                    vig.setcantDias    (rs.getInt ("CANT_DIAS"));
                    vig.setcodVigencia (rs.getInt ("COD_VIGENCIA"));
                    vig.setdescVigencia(rs.getString ("DESCRIPCION"));

                    lf.add(vig);
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
            return lf;
        }
    }

    public static LinkedList getAllVigencias (int iCodRama, int iCodSubRama, int codProducto, int codPlan)
       throws SurException  {
        LinkedList lf = new LinkedList ();
        Connection dbCon = null;
        try {
            dbCon = db.getConnection();

            lf = getAllVigencias(dbCon, iCodRama, iCodSubRama, codProducto, codPlan);

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
            return lf;
        }
    }

    public static double getParametro (int iCodRama, int codParam) throws SurException  {             
        Connection dbCon = null;
        double retorno   = 0;
        try {             
            dbCon = db.getConnection();

            retorno = getParametro (dbCon, iCodRama, codParam);
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
            return retorno;
        }
    }
    
   public static double getPorcComisionProd (int codProd, int codRama ) throws SurException  {             
        Connection dbCon = null;
        double retorno   = 0;
        try {             
            dbCon           = db.getConnection();    
            
            retorno = getPorcComisionProd (dbCon, codProd, codRama );

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
            return retorno;   
        }
    }    
   
   public static double getPorcComisionOrg (int codProd, int codRama ) throws SurException  {             
        Connection dbCon = null;
        double retorno   = 0;
        try {             
            dbCon           = db.getConnection();    
            
            retorno = getPorcComisionOrg (dbCon, codProd, codRama );

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
            return retorno;   
        }
    }    

    public static double getParametro (Connection dbCon, int iCodRama, int codParam) throws SurException  {             
        CallableStatement cons = null;
        double retorno   = 0;
        try {             
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("COT_GET_VALOR_IMPUESTO (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.DOUBLE);
            cons.setInt (2, iCodRama);
            cons.setInt (3, codParam); 

            cons.execute();
           
            retorno = cons.getDouble(1); 
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage()); 
            }
            return retorno;
        }
    }
    
   public static double getPorcComisionProd (Connection dbCon, int codProd, int codRama ) throws SurException  {             
        CallableStatement cons = null;
        double retorno   = 0;
        try {             
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_PORC_COMISION_PROD ( ?, ? )"));
            cons.registerOutParameter(1, java.sql.Types.DOUBLE);
            cons.setInt (2, codProd);
            cons.setInt (3, codRama);

            cons.execute();
           
            retorno = cons.getDouble(1); 
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage()); 
            }
            return retorno;
        }
    }    
   
   public static double getPorcComisionOrg (Connection dbCon, int codProd, int codRama ) throws SurException  {             
        CallableStatement cons = null;
        double retorno   = 0;
        try {             
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_PORC_COMISION_ORG ( ?, ? )"));
            cons.registerOutParameter(1, java.sql.Types.DOUBLE);
            cons.setInt (2, codProd);
            cons.setInt (3, codRama);

            cons.execute();
           
            retorno = cons.getDouble(1); 
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage()); 
            }
            return retorno;   
        }
    }    
   public static int getCantMaximaCuotas (Connection dbCon, int codRama, int codSubRama, int codProd ) throws SurException  {             
        CallableStatement cons = null;
        int retorno   = 0;
        try {             
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_PROD_CANT_MAX_CUOTAS ( ?, ?, ? )"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setInt (2, codRama);
            cons.setInt (3, codSubRama);
            cons.setInt (4, codProd);

            cons.execute();
           
            retorno = cons.getInt (1); 
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage()); 
            }
            return retorno;
        }
    }    

    public static LinkedList getAllFormaPagoProducto (int iCodRama, int iCodSubRama,
                                                    int codProducto, int codVigencia, int codPlan, int codProd)
        throws SurException  {
        Connection dbCon = null;
        LinkedList lf = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs =   null;
        boolean bExisteSubRama = false;
        boolean bExisteProducto = false;
        boolean bExisteProductor = false;
        try {
            dbCon           = db.getConnection();

            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_PRODUCTOS_FORMA_PAGO (?, ?, ?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, iCodRama);
            cons.setInt (3, iCodSubRama);
            cons.setInt (4, codProducto);
            cons.setInt (5, codProd);

            cons.execute();
            rs = (ResultSet) cons.getObject (1);
            boolean bGrabar;
            if (rs != null) {
                while (rs.next ()) {
                    bGrabar = true;
                    if ( rs.getInt ("COD_SUB_RAMA") == iCodSubRama ) {
                        bExisteSubRama = true;
                    }
                    if ( rs.getInt ("COD_PROD") == codProd ) {
                        bExisteProductor = true;
                    }
                    if ( rs.getInt ("COD_PRODUCTO") == codProducto ) {
                        bExisteProducto = true;
                    }

                    if ( rs.getInt ("COD_SUB_RAMA") == 999 &&  bExisteSubRama ) {
                        bGrabar = false;
                    }

                    if  ( rs.getInt ("COD_PRODUCTO") == 999 && bExisteProducto ) {
                        bGrabar = false;
                    }
                    if  ( rs.getInt ("COD_PROD") == 99999999 && bExisteProductor ) {
                        bGrabar = false;
                    }

                    if (bGrabar ) {

                        Facturacion of = new Facturacion ();
                        of.setcodRama       (rs.getInt ("COD_RAMA"));
                        of.setcantDesde     (rs.getInt ("CANT_DESDE"));
                        of.setcantHasta     (rs.getInt ("CANT_HASTA"));
                        of.setcodFacturacion(rs.getInt ("COD_FACTURACION"));
                        of.setcantCuotas    (rs.getInt ("MAX_CUOTAS"));
                        of.setcodVigencia   (rs.getInt ("COD_VIGENCIA"));
                        of.setdescFacturacion(rs.getString ("DESC_FACT"));
                        of.setcodSubRama    (rs.getInt ("COD_SUB_RAMA"));
                        of.setcodProducto   (rs.getInt ("COD_PRODUCTO"));

                        lf.add(of);
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
            return lf;
        }
    }

    public static LinkedList getAllRubros (int iCodRama )
        throws SurException  {
        Connection dbCon = null;
        LinkedList lf = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs =   null;
        try {
            dbCon           = db.getConnection();

            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("COT_GET_ALL_RUBROS(?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, iCodRama);

            cons.execute();
            rs = (ResultSet) cons.getObject (1);
            if (rs != null) {
                while (rs.next ()) {
                    Rubro ru = new Rubro (rs.getInt ("COD_RUBRO"), rs.getString ("DESCRIPCION"));
                    lf.add(ru);
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
            return lf;
        }
    }

    public static LinkedList getAllActividadRubro (Connection dbCon, int iCodRama, int iCodRubro )
        throws SurException  {
        LinkedList lf = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs =   null;
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("COT_GET_ALL_ACTIVIDADES (?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, iCodRama);
            cons.setInt (3, iCodRubro);

            cons.execute();
            rs = (ResultSet) cons.getObject (1);
            if (rs != null) {
                while (rs.next ()) {
                    ActividadCategoria ac = new ActividadCategoria ();
                    ac.setcodRama(iCodRama);
                    ac.setiCodRubro(iCodRubro);
                    ac.setcodActividad(rs.getInt ("COD_ACTIVIDAD"));
                    ac.setcategoria(rs.getInt ("CATEGORIA"));
                    ac.setdescripcion(rs.getString ("DESCRIPCION"));

                    lf.add(ac);
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
            return lf;
        }
    }

    public static LinkedList getAllActividades ( int iCodRama)
        throws SurException  {
        LinkedList lf = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs =   null;
        Connection dbCon = null;
        try {
            dbCon = db.getConnection();
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("COT_GET_ALL_ACTIVIDADES (?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, iCodRama);
            cons.setInt (3, 0); // codigo de rubro inutilizado

            cons.execute();
            rs = (ResultSet) cons.getObject (1);
            if (rs != null) {
                while (rs.next ()) {
                    ActividadCategoria ac = new ActividadCategoria ();
                    ac.setcodRama(iCodRama);
                    ac.setiCodRubro(0);
                    ac.setcodActividad(rs.getInt ("COD_ACTIVIDAD"));
                    ac.setcategoria(rs.getInt ("CATEGORIA"));
                    ac.setdescripcion(rs.getString ("DESCRIPCION"));

                    lf.add(ac);
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
            return lf;
        }
    }

    public static LinkedList getAllActividadesCategorias ()  throws SurException {
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
                    ActividadCategoria oAC = new ActividadCategoria();
                    oAC.setcodRama      (rs.getInt ("COD_RAMA"));
                    oAC.setcodActividad (rs.getInt ("COD_ACTIVIDAD"));
                    oAC.setcategoria    (rs.getInt ("CATEGORIA"));
                    oAC.setdescripcion  (rs.getString ("DESCRIPCION"));
                    oAC.setmcaBaja      (rs.getString ("MCA_BAJA"));
                    oAC.setmcaCotizador (rs.getString ("MCA_COTIZADOR"));
                    oAC.setmcaPlanes    (rs.getString ("MCA_PLANES"));
                    oAC.setmcaNoRenovar (rs.getString ("MCA_NO_RENOVAR"));
                    oAC.setmca24Horas   (rs.getString ("MCA_24HORAS"));
                    oAC.setmcaItinere   (rs.getString ("MCA_ITINERE"));
                    oAC.setmcaLaboral   (rs.getString ("MCA_LABORAL"));
                    lTabla.add(oAC);
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

    public static LinkedList getEntidadSobre (Connection dbCon, int codProd)  throws SurException {
        LinkedList lEntidad = new LinkedList ();
        CallableStatement cons = null;
        ResultSet rs = null;
        try {
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
            return lEntidad;
        }
    }

       public static String  getdescError  (Connection dbCon, int codError, String procedencia ) throws SurException  {
        CallableStatement cons = null;
        String  retorno   = "";
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_DESC_ERROR ( ?, ? )"));
            cons.registerOutParameter(1, java.sql.Types.VARCHAR );
            cons.setInt (2, codError );
            cons.setString (3, procedencia);

            cons.execute();

            retorno = cons.getString  (1);

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            return retorno;
        }
    }

    public static LinkedList getAllProvincias ()  throws SurException {
        LinkedList lProv = new LinkedList ();
        CallableStatement cons = null;
        Connection dbCon = null;
        try {
            dbCon           = db.getConnection();
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("GET_ALL_PROVINCIAS ()"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);

            cons.execute();

            ResultSet rs = (ResultSet) cons.getObject (1);

            if (rs != null) {
                while (rs.next ()) {
                    Provincia oP = new Provincia (rs.getInt("COD_PROVINCIA"), rs.getString ("DESCRIPCION")); 
                    oP.setConvMultilateral(rs.getString ("CONVENIO"));
                    lProv.add(oP);
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
            return lProv;
        }
    }
       
}
