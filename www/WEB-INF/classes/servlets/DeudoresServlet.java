/*
 * DeudoresServlet.java
 *
 * Created on 28 de abril de 2005, 21:35
 */

package servlets;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.util.LinkedList;
import java.util.Date;
import java.text.SimpleDateFormat;

import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;

import com.business.beans.Usuario;
import com.business.beans.Pago;
import com.business.util.*;
import com.business.db.*;
import com.business.interfaces.*;

import javax.servlet.*;
import javax.servlet.http.*;

/**
 *
 * @author Rolando Elisii
 * @version
 */
public class DeudoresServlet extends HttpServlet {
    
    /** Initializes the servlet.
     */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        
    }
    
    /** Destroys the servlet.
     */
    public void destroy() {
        
    }
    
    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            if ( request.getParameter ("procedencia") != null) {
                getServletConfig().getServletContext().getRequestDispatcher("/servlet/setAccess?opcion=ADDPROC").include(request,response);
            }

            String op =  request.getParameter("opcion");
            
            if (op.equals("getFormDeudores")) {
                getFormDeudores (request, response);
            } else if (op.equals ("getDeudores")) {
                getDeudores (request, response);
            } else if (op.equals ("getDeuMail")) {
                getDeudoresMail (request, response);
            }
            
         } catch (SurException se) {
            goToJSPError(request,response, se);
        } catch (Exception e) {
            goToJSPError(request,response, e);
        }
    } 
    
    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void getFormDeudores (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        LinkedList lProd = null;
        try {
        
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));

            dbCon = db.getConnection();

            request.setAttribute ("productores", lProd);
            doForward (request, response, "/deudores/formDeudores.jsp");

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

  protected void getDeudoresMail (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        LinkedList lProd = null;
        try {
        
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            dbCon = db.getConnection();

            request.setAttribute ("productores", lProd);
            doForward (request, response, "/deudores/formDeudoresMail.jsp");

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }    
    protected void getDeudores (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
       try {
            String sTomador =  (request.getParameter ("tomador") == null || request.getParameter ("tomador").equals ("") ? null : request.getParameter ("tomador"));                
            int numPoliza      = (request.getParameter ("num_poliza") == null || request.getParameter ("num_poliza").equals ("") ||
                                   request.getParameter ("num_poliza").equals ("0") ? 0 : Integer.parseInt (request.getParameter ("num_poliza")));

            Date fecha          = Fecha.strToDate(request.getParameter ("fecha").equals ("") ? Fecha.getFechaActual () : request.getParameter ("fecha"));
            String consolidado  = request.getParameter ("consolidado");
            String visual       = request.getParameter ("tipo");
            double minDeuda     = (request.getParameter ("min_deuda") == null || request.getParameter ("min_deuda").equals ("") ||
                                   request.getParameter ("min_deuda").equals ("0") ? 0 : Double.parseDouble(request.getParameter ("min_deuda")));
                                   
                                   
            if (visual.equals ("PDF")) 
                this.printDeudoresPDF ( sTomador, numPoliza, fecha,consolidado, minDeuda, request, response);
                else if ( visual.equals("HTML")) 
                    this.printDeudoresHTML ( sTomador, numPoliza, fecha,consolidado, minDeuda, request, response);
                else this.exportDeudoresXML ( sTomador, numPoliza, fecha,consolidado, minDeuda, request, response);

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } 
    }
 

    protected void printDeudoresPDF ( String sTomador, int numPoliza,Date fecha,String consolidado, double minDeuda,  HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        LinkedList lPagos = new LinkedList (); 
        ResultSet rs = null;
        CallableStatement cons = null;
        Connection dbCon = null;
        Usuario oProd    = null;
        String  sNextPage = "";
        try {
            dbCon = db.getConnection();    
// setear el control de acceso
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, 3);
                          
// fin de setear el control de acceso 

            Usuario oUser           = (Usuario) (request.getSession().getAttribute("user"));
            int codProd             = 0; 
            int numTomador          = 0;
            double impDeuda15       = 0;
            double impDeuda30       = 0; 
            double impDeuda60       = 0; 
            double impDeuda365      = 0; 
            double impTotalDeuda    = 0;
          
            if (oUser.getiCodTipoUsuario() == 0 || oUser.getiCodProd () >= 80000 ) {
                codProd    = Integer.parseInt (request.getParameter ("cod_prod"));
                numTomador = Integer.parseInt (request.getParameter ("num_tomador"));
                oProd      = new Usuario ();
                oProd.setiCodProd(codProd); 
                oProd.setiNumTomador(numTomador); 
                
                if (codProd != 0) {
                    oProd.getDBProductor(dbCon); 
                } else {
                    oProd.getDBUsuarioTomador (dbCon); 
                }

                if (oProd.getiNumError() != 0) { 
                    throw new SurException (oProd.getsMensError()); 
                }
            } else {
                oProd      = oUser;
                
            }
            
            Report oReport = new Report ();
            oReport.setTitulo       ("DEUDORES POR PREMIO");
            oReport.addlObj         ("subtitulo" , (oProd.getiCodProd () != 0 ? "Productor: " : "Cliente: ") + oProd.getsDesPersona() + " (" + (oProd.getiCodProd () != 0 ? oProd.getiCodProd() : oProd.getiNumTomador()) + ")"); 
            oReport.setUsuario      (oUser.getusuario());
            oReport.setFecha        (Fecha.toString(new java.util.Date ()));
            oReport.setFormulario   ("DEU001");
            oReport.setReportName   (getServletContext ().getRealPath(consolidado.equals ("N") ? "/deudores/report/deudores.xml" : "/deudores/report/deudoresCons.xml" ));
            oReport.setsContextPath ( request.getScheme() + "://" + request.getHeader("host"));
            oReport.addImage        ("logo", getServletContext ().getRealPath("/images/logos/logo_beneficiosa.jpg"));

// Datos de las interfases
            Proceso oProc = new Proceso ();
            
            oProc.setsTabla("P_MOVIMIENTOS");
            oProc.getDBUltimaInterfase(dbCon);
            
            if (oProc.getiNumError() != 0) {
                throw new SurException (oProc.getsMensError());
            }
            
            oReport.addlObj("FECHA_MOVIMIENTOS", (oProc.getdFechaFTP() == null ? "no informado" : Fecha.showFechaForm(oProc.getdFechaFTP())));

            oProc.setsTabla("P_PAGOS");
            oProc.getDBUltimaInterfase(dbCon);
            
            if (oProc.getiNumError() != 0) {
                throw new SurException (oProc.getsMensError());
            }
   
            oReport.addlObj("FECHA_PAGOS", (oProc.getdFechaFTP() == null ? "no informado" : Fecha.showFechaForm(oProc.getdFechaFTP())));
            
// datos del productor
            
            oReport.addlObj("FECHA", Fecha.showFechaForm(fecha));
// tabla de polizas 
            
            oReport.addIniTabla("TABLA_CUOTAS");                
            dbCon.setAutoCommit(false);
            
            if (consolidado.equals ("N")) {
                String sStyle      [] = {"ItemCob","ItemCobR", "ItemCobR","ItemCobL","ItemCob","ItemCob","ItemCob","ItemCobL","ItemCobR"};                
                String sStyleSaldo [] = {"","", "","ItemCobBold","ItemCobBold","","","ItemCobBold","ItemCobBold"};                
                
                cons = dbCon.prepareCall(db.getSettingCall("DEU_ALL_DEUDORES (?,?,?,?,?,?,? )"));
                cons.registerOutParameter(1, java.sql.Types.OTHER);
                if (oProd.getiCodProd ()  == 0 ) {
                    cons.setNull    (2, java.sql.Types.INTEGER);
                } else {
                    cons.setInt     (2, oProd.getiCodProd ());
                }
                if (sTomador == null ) {
                    cons.setNull    (3, java.sql.Types.VARCHAR);
                } else {
                    cons.setString  (3, sTomador);
                }
                cons.setDate        (4, Fecha.convertFecha(fecha));
                cons.setDouble      (5, minDeuda);
                cons.setString      (6, consolidado);
                cons.setInt         (7, numPoliza);
                if (oProd.getiNumTomador () == 0 ) {
                    cons.setNull    (8, java.sql.Types.INTEGER);
                } else {
                    cons.setInt     (8, oProd.getiNumTomador ());
                }

                cons.execute();
                
                rs = (ResultSet) cons.getObject(1);
                
                if (rs != null) {
                    int iCodRamaAnt = -1;
                    int iNumPolAnt  = -1;
                    int iEndosoAnt  = -1;
                    double saldoAnt = 0;
                    double deudaAnt = 0;
                    double totalDeudaPol = 0;
                    String sVencida = "NO";

                    while (rs.next()) {
                        if (rs.getInt  ("COD_RAMA") != iCodRamaAnt ||
                            rs.getInt  ("NUM_POLIZA") != iNumPolAnt ||   
                            rs.getInt  ("ENDOSO")    != iEndosoAnt) { 
                            
                            if (iCodRamaAnt != -1) {
                                String sElem [] = {"", "", "",(sVencida.equals ("SI") ?  "Vencido:" + Dbl.DbltoStr(deudaAnt,2) : " "), 
                                (sVencida.equals ("NO") ? "Atraso:" + Dbl.DbltoStr(deudaAnt,2) : " " ), " ", " ", "Saldo.....:", Dbl.DbltoStr(saldoAnt,2)}; // grabar los saldos 
                                oReport.addElementsTabla(sElem, sStyleSaldo); 
                                if (rs.getInt  ("COD_RAMA") != iCodRamaAnt ||
                                    rs.getInt  ("NUM_POLIZA") != iNumPolAnt) {

                                    String sElem2 [] = {"", "", "", "TOTAL POLIZA:" + Dbl.DbltoStr(totalDeudaPol,2) , "","","","","" }; // grabar los totales
                                    oReport.addElementsTabla(sElem2, sStyleSaldo); 
                                    totalDeudaPol = 0;
                                }
                            }

                            String sElem [] = {String.valueOf (rs.getInt  ("COD_RAMA")), 
                            Formatos.showNumPoliza(rs.getInt  ("NUM_POLIZA")),
                            Formatos.showNumPoliza(rs.getInt  ("ENDOSO")),
                            rs.getString ("ASEGURADO"),
                            (rs.getDate ("FECHA_INI_VIG_END") == null ? "" : Fecha.showFechaForm(rs.getDate ("FECHA_INI_VIG_END")))
                            + " " + (rs.getDate ("FECHA_FIN_VIG_END") == null ? "" : Fecha.showFechaForm(rs.getDate ("FECHA_FIN_VIG_END"))), 
                            String.valueOf (rs.getInt  ("CANT_CUOTAS")),
                            (rs.getDate ("FECHA_EMISION_END") == null ? "" : Fecha.showFechaForm(rs.getDate ("FECHA_EMISION_END"))),
                            (rs.getInt  ("ENDOSO") == 0 ? "Poliza" : "Endoso"),
                            Dbl.DbltoStr(rs.getDouble ("TOTAL_FACTURADO_END"),2)};
                            
                            oReport.addElementsTabla(sElem, sStyle); 

                            if (rs.getDouble ("IMP_PAGO") != 0) {
                                String sElem2 [] = {" ", " ", " ", " ", " "," ", (rs.getDate ("FECHA_PAGO") == null ? "" : Fecha.showFechaForm(rs.getDate ("FECHA_PAGO"))),
                                (rs.getString ("DESCRIPCION") == null ? " " :  (rs.getString ("DESCRIPCION").length () < 6 ? rs.getString ("DESCRIPCION") : rs.getString ("DESCRIPCION").substring(0, 5)))+
                                " " + (rs.getString ("NUM_COMPROBANTE") == null ? " " : (rs.getString ("NUM_COMPROBANTE").equals ("0") ? " " : rs.getString ("NUM_COMPROBANTE"))),
                                Dbl.DbltoStr(rs.getDouble ("IMP_PAGO"),2) };
                                oReport.addElementsTabla(sElem2, sStyle); 
                                
                            }
                            iCodRamaAnt = rs.getInt  ("COD_RAMA");
                            iNumPolAnt  = rs.getInt  ("NUM_POLIZA");
                            iEndosoAnt  = rs.getInt  ("ENDOSO");
                            saldoAnt    = rs.getDouble ("SALDO_POLIZA_END");
                            deudaAnt    = rs.getDouble ("IMP_DEUDA_END");
                            totalDeudaPol += rs.getDouble ("IMP_DEUDA_END");
                            sVencida    = rs.getString ("VENCIDA");
                        } else {
                            String sElem2 [] = {" ", " ", " ", " ", " "," ", (rs.getDate ("FECHA_PAGO") == null ? "" : Fecha.showFechaForm(rs.getDate ("FECHA_PAGO"))),
                            (rs.getString ("DESCRIPCION") == null ? " " :  (rs.getString ("DESCRIPCION").length () < 6 ? rs.getString ("DESCRIPCION"): rs.getString ("DESCRIPCION").substring(0, 5)))+ " " + (rs.getString ("NUM_COMPROBANTE") == null ? " " : (rs.getString ("NUM_COMPROBANTE").equals ("0") ? " " :rs.getString ("NUM_COMPROBANTE"))),
                            Dbl.DbltoStr(rs.getDouble ("IMP_PAGO"),2) };
                            oReport.addElementsTabla(sElem2, sStyle); 
                        }
                    }
                    if (iCodRamaAnt != -1) {
                        String sElem [] = {" ", " ", " ", 
                        (sVencida.equals ("SI") ? "Vencido:" + Dbl.DbltoStr(deudaAnt,2) : " "), 
                        (sVencida.equals ("NO") ? "Atraso:" + Dbl.DbltoStr(deudaAnt,2) : " "), " ", " ", 
                        "Saldo.....:", Dbl.DbltoStr(saldoAnt,2)}; // grabar los saldos 
                        oReport.addElementsTabla(sElem, sStyleSaldo); 
                                    String sElem2 [] = {"", "", "", "TOTAL POLIZA:" + Dbl.DbltoStr(totalDeudaPol,2) , "","","","","" }; // grabar los totales
                        oReport.addElementsTabla(sElem2, sStyleSaldo); 
                    }
                    
                } 
            } else {
                String sStyleCons  [] = {"ItemCob","ItemCobR", "ItemCobL",
                                         "ItemCob","ItemCob", "ItemCobBold",
                                         "ItemCobBold","ItemCobBold","ItemCobBold"};
                
                cons = dbCon.prepareCall(db.getSettingCall("DEU_ALL_DEUDORES_CONS (?,?,?,?,?,?,?)"));
                cons.registerOutParameter(1, java.sql.Types.OTHER);
                if (oProd.getiCodProd ()  == 0 ) {
                    cons.setNull    (2, java.sql.Types.INTEGER);
                } else {
                    cons.setInt     (2, oProd.getiCodProd ());
                }
                if (sTomador == null ) {
                    cons.setNull    (3, java.sql.Types.VARCHAR);
                } else {
                    cons.setString  (3, sTomador);
                }
                cons.setDate        (4, Fecha.convertFecha(fecha));
                cons.setDouble      (5, minDeuda);
                cons.setString      (6, consolidado);
                cons.setInt         (7, numPoliza);
                if (oProd.getiNumTomador () == 0 ) {
                    cons.setNull    (8, java.sql.Types.INTEGER);
                } else {
                    cons.setInt     (8, oProd.getiNumTomador ());
                }

                cons.execute();

                rs = (ResultSet) cons.getObject(1);
                if (rs != null) {
                    boolean bIsFirst   = true;                    
                    
                    while (rs.next()) {
                        impDeuda15  += rs.getDouble ("A_VENCER_15");
                        impDeuda30  += rs.getDouble ("A_VENCER_30");
                        impDeuda60  += rs.getDouble ("A_VENCER_60");
                        impDeuda365 += rs.getDouble ("A_VENCER_365");
                        impTotalDeuda += rs.getDouble ("IMP_DEUDA_END");
                        
                        String sElem [] = {String.valueOf(rs.getInt("COD_RAMA")),  Formatos.showNumPoliza(rs.getInt("NUM_POLIZA")),
                        rs.getString ("ASEGURADO"),
                        (rs.getDate ("FECHA_INI_VIG_POL") == null ? "" : Fecha.showFechaForm(rs.getDate ("FECHA_INI_VIG_POL"))) + " " +
                        (rs.getDate ("FECHA_FIN_VIG_POL") == null ? "" : Fecha.showFechaForm(rs.getDate ("FECHA_FIN_VIG_POL"))),
                        (rs.getDate ("FECHA_PAGO") == null ? "" : Fecha.showFechaForm (rs.getDate ("FECHA_PAGO"))),
                        Dbl.DbltoStr(rs.getDouble ("TOTAL_FACTURADO"),2),
        //                Dbl.DbltoStr(rs.getDouble ("TOTAL_REDUCCIONES"),2),
                        Dbl.DbltoStr(rs.getDouble ("TOTAL_PAGOS"),2),
                        Dbl.DbltoStr(rs.getDouble ("SALDO_POLIZA_END"),2),
                        Dbl.DbltoStr(rs.getDouble ("IMP_DEUDA_END"),2)};
                        
                        oReport.addElementsTabla(sElem, sStyleCons); 
                    }
                    String sElem[] = {"","","Total Productor : $ ","","","","","",  Dbl.DbltoStr(impTotalDeuda  ,2)};
                    oReport.addElementsTabla(sElem, sStyleCons); 
                } 
            }

            oReport.addFinTabla();
            
            if (consolidado.equals ("S")) {
                oReport.addIniTabla("TABLA_RESUMEN");
                String sStyleResumen [] = {"ItemCobL","ItemCobL", "ItemCobBold"};
                String sElem[] = { "Premios ATRASADOS: ", "",  Dbl.DbltoStr(impTotalDeuda,2) };
                oReport.addElementsTabla(sElem, sStyleResumen); 
                
 /*               sElem [0] = "Premios a Vencer ";
                sElem [1] = "1 - 15 dias ";
                sElem [2] = Dbl.DbltoStr(impDeuda15,2);
                oReport.addElementsTabla(sElem, sStyleResumen); 
                
                sElem [0] = " ";
                sElem [1] = "16 - 30 dias ";
                sElem [2] = Dbl.DbltoStr(impDeuda30,2);
                oReport.addElementsTabla(sElem, sStyleResumen); 
                
                sElem [0] = " ";
                sElem [1] = "31 - 60 dias ";
                sElem [2] = Dbl.DbltoStr(impDeuda60,2);
                oReport.addElementsTabla(sElem, sStyleResumen); 
                
                sElem [0] = " ";
                sElem [1] = "+ de 60 dias  ";
                sElem [2] = Dbl.DbltoStr(impDeuda365,2);
                oReport.addElementsTabla(sElem, sStyleResumen); 
*/
                oReport.addFinTabla();
            }
            
            request.setAttribute("oReport", oReport );
            doForward (request,response, "/servlet/ReportPdf");  
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null)  cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }
                    
    protected void printDeudoresHTML ( String sTomador, int numPoliza,Date fecha,String consolidado, double minDeuda,  HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        LinkedList lPagos = new LinkedList (); 
        ResultSet rs = null;
        CallableStatement cons = null;
        Connection dbCon = null;
        Usuario oProd    = null;
        String  sNextPage = "";
        try {
            dbCon = db.getConnection();        
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
// setear el control de acceso
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, 3);
                          
// fin de setear el control de acceso 
            
            int codProd     = 0; 
            int numTomador  = 0;
          
            
            if (oUser.getiCodTipoUsuario() == 0 || oUser.getiCodProd () >= 80000 ) {
                codProd    = Integer.parseInt (request.getParameter ("cod_prod"));
                numTomador = Integer.parseInt (request.getParameter ("num_tomador"));
                oProd      = new Usuario ();
                oProd.setiCodProd(codProd); 
                oProd.setiNumTomador(numTomador);

                if (codProd != 0) {
                    oProd.getDBProductor(dbCon); 
                } else {
                    oProd.getDBUsuarioTomador(dbCon);
                }
                if (oProd.getiNumError() != 0) { 
                    throw new SurException (oProd.getsMensError()); 
                }
                

            } else {
                oProd      = oUser;
                
            }
// Datos de las interfases
            Proceso oProc = new Proceso ();
            
            oProc.setsTabla("P_MOVIMIENTOS");
            oProc.getDBUltimaInterfase(dbCon);
            
            if (oProc.getiNumError() != 0) {
                throw new SurException (oProc.getsMensError());
            }

            request.setAttribute ("fechaMov", oProc.getdFechaFTP());
            
            oProc.setsTabla("P_PAGOS");
            oProc.getDBUltimaInterfase(dbCon);
            
            if (oProc.getiNumError() != 0) {
                throw new SurException (oProc.getsMensError());
            }

            request.setAttribute ("fechaPago", oProc.getdFechaFTP());
            
            dbCon.setAutoCommit(false);
            
            if (consolidado.equals ("N")) {
                cons = dbCon.prepareCall(db.getSettingCall("DEU_ALL_DEUDORES (?,?,?,?,?,?,?)"));
                cons.registerOutParameter(1, java.sql.Types.OTHER);
                if (oProd.getiCodProd ()  == 0 ) {
                    cons.setNull    (2, java.sql.Types.INTEGER);
                } else {
                    cons.setInt     (2, oProd.getiCodProd ());
                }
                if (sTomador == null ) {
                    cons.setNull    (3, java.sql.Types.VARCHAR);
                } else {
                    cons.setString  (3, sTomador);
                }
                cons.setDate        (4, Fecha.convertFecha(fecha));
                cons.setDouble      (5, minDeuda);
                cons.setString      (6, consolidado);
                cons.setInt         (7, numPoliza);
                if (oProd.getiNumTomador () == 0 ) {
                    cons.setNull    (8, java.sql.Types.INTEGER);
                } else {
                    cons.setInt     (8, oProd.getiNumTomador ());
                }

                cons.execute();

                rs = (ResultSet) cons.getObject(1);
                if (rs != null) {
                    while (rs.next()) {
                        Pago oPago = new Pago ();
                        oPago.setcodRama        (rs.getInt("COD_RAMA"));
                        oPago.setnumPoliza      (rs.getInt("NUM_POLIZA"));
                        oPago.setendoso         (rs.getInt ("ENDOSO"));
                        oPago.setasegurado      (rs.getString ("ASEGURADO"));
                        oPago.setFechaIniVig    (rs.getDate ("FECHA_INI_VIG_END"));
                        oPago.setFechaFinVig    (rs.getDate ("FECHA_FIN_VIG_END"));
                        oPago.setFechaEmision   (rs.getDate("FECHA_EMISION_END"));
                        oPago.setiNumCuota      (rs.getInt  ("CANT_CUOTAS"));
                        oPago.setFechaCobro     (rs.getDate ("FECHA_PAGO"));
                        oPago.setdescMovimiento (rs.getString ("DESCRIPCION"));
                        oPago.setcomprobante    (rs.getString ("NUM_COMPROBANTE"));
                        oPago.setiImporte       (rs.getDouble ("IMP_PAGO"));
                        oPago.setimpTotalFact   (rs.getDouble ("TOTAL_FACTURADO_END"));
                        oPago.setimpDeuda       (rs.getDouble ("IMP_DEUDA_END"));
                        oPago.setimpSaldo       (rs.getDouble ("SALDO_POLIZA_END"));
                        oPago.setsVencida       (rs.getString ("VENCIDA"));

                        lPagos.add (oPago);
                    }
                } 
                sNextPage = "/deudores/report/deudoresHTML.jsp";
            } else {
                cons = dbCon.prepareCall(db.getSettingCall("DEU_ALL_DEUDORES_CONS (?,?,?,?,?,?,?)"));
                cons.registerOutParameter(1, java.sql.Types.OTHER);
                if (oProd.getiCodProd ()  == 0 ) {
                    cons.setNull    (2, java.sql.Types.INTEGER);
                } else {
                    cons.setInt     (2, oProd.getiCodProd ());
                }
                if (sTomador == null ) {
                    cons.setNull    (3, java.sql.Types.VARCHAR);
                } else {
                    cons.setString  (3, sTomador);
                }
                cons.setDate        (4, Fecha.convertFecha(fecha));
                cons.setDouble      (5, minDeuda);
                cons.setString      (6, consolidado);
                cons.setInt         (7, numPoliza);
                if (oProd.getiNumTomador () == 0 ) {
                    cons.setNull    (8, java.sql.Types.INTEGER);
                } else {
                    cons.setInt     (8, oProd.getiNumTomador ());
                }

                cons.execute();

                rs = (ResultSet) cons.getObject(1);
                if (rs != null) {
                    while (rs.next()) {
                        Pago oPago = new Pago ();
                        oPago.setcodRama        (rs.getInt("COD_RAMA"));
                        oPago.setnumPoliza      (rs.getInt("NUM_POLIZA"));
                        oPago.setasegurado      (rs.getString ("ASEGURADO"));
                        oPago.setFechaIniVig    (rs.getDate ("FECHA_INI_VIG_POL"));
                        oPago.setFechaFinVig    (rs.getDate ("FECHA_FIN_VIG_POL"));
                        oPago.setFechaCobro     (rs.getDate ("FECHA_PAGO"));
//                        oPago.setimpTotalFactPol(rs.getDouble ("TOTAL_FACTURADO_POL"));
                        oPago.setimpTotalFact   (rs.getDouble ("TOTAL_FACTURADO"));
                        oPago.setimpDeuda       (rs.getDouble ("IMP_DEUDA_END"));
                        oPago.setimpSaldo       (rs.getDouble ("SALDO_POLIZA_END"));
                        oPago.setimpTotalPagos  (rs.getDouble ("TOTAL_PAGOS"));
                        oPago.setimpTotalReduc  (rs.getDouble ("TOTAL_REDUCCIONES"));                        
                        oPago.setimpDeuda15     (rs.getDouble ("A_VENCER_15"));
                        oPago.setimpDeuda30     (rs.getDouble ("A_VENCER_30"));
                        oPago.setimpDeuda60     (rs.getDouble ("A_VENCER_60"));
                        oPago.setimpDeuda365    (rs.getDouble ("A_VENCER_365"));                        
                        lPagos.add (oPago);
                    }
                } 
                
                sNextPage = "/deudores/report/deudoresConsHTML.jsp";
            }
        request.setAttribute("productor", oProd);
        request.setAttribute("pagos", lPagos);
        
        doForward (request, response, sNextPage);
        
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null)  cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }
    
    protected void exportDeudoresXML ( String sTomador, int numPoliza,Date fecha,String consolidado, double minDeuda,  HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        LinkedList lPagos = new LinkedList (); 
        ResultSet rs = null;
        CallableStatement cons = null;
        Connection dbCon = null;
        Usuario oProd    = null;
        try {
            dbCon = db.getConnection();    
// setear el control de acceso
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, 3);
                          
// fin de setear el control de acceso 
            
            Usuario oUser           = (Usuario) (request.getSession().getAttribute("user"));
            int codProd             = 0; 
            int numTomador          = 0;
            double impDeuda15       = 0;
            double impDeuda30       = 0; 
            double impDeuda60       = 0; 
            double impDeuda365      = 0; 
            double impTotalDeuda    = 0;
            xls               oXls  = new xls (); 
            
          
            if (oUser.getiCodTipoUsuario() == 0 || oUser.getiCodProd () >= 80000 ) {
                codProd    = Integer.parseInt (request.getParameter ("cod_prod"));
                numTomador = Integer.parseInt (request.getParameter ("num_tomador"));
                oProd      = new Usuario ();
                oProd.setiCodProd(codProd); 
                oProd.setiNumTomador(numTomador); 
                
                if (codProd != 0) {
                    oProd.getDBProductor(dbCon); 
                } else {
                    oProd.getDBUsuarioTomador (dbCon); 
                }

                if (oProd.getiNumError() != 0) { 
                    throw new SurException (oProd.getsMensError()); 
                }
            } else {
                oProd      = oUser;
                
            }
            Report oReport = new Report ();
            oXls.setTitulo("DEUDORES POR PREMIO"); 

            LinkedList lRow    = new LinkedList();
            if (consolidado.equals ("N")) {
                lRow.add("");lRow.add("");lRow.add("");
            } else {
                lRow.add("");lRow.add("");                
            }
            lRow.add("DEUDORES POR PREMIO");            
            oXls.setRows(lRow);

            lRow    = new LinkedList();
            lRow.add("");
            oXls.setRows(lRow);
            
            lRow = new LinkedList();
            if (consolidado.equals ("N")) {
                lRow.add("");lRow.add("");lRow.add("");
            } else {
                lRow.add("");lRow.add("");                
            }
            lRow.add((oProd.getiCodTipoUsuario() == 1 ? "Productor: " : "Cliente: ") + oProd.getsDesPersona() + " (" + (oProd.getiCodTipoUsuario() == 1 ? oProd.getiCodProd() : oProd.getiNumTomador()) + ")");
            oXls.setRows(lRow);                

            lRow    = new LinkedList();
            lRow.add("");
            oXls.setRows(lRow);
            
            lRow = new LinkedList();
            if (consolidado.equals ("N")) {
                lRow.add("");lRow.add("");lRow.add("");
            } else {
                lRow.add("");lRow.add("");                
            }
            lRow.add("Fecha de Análisis: " + Fecha.showFechaForm(fecha));
            oXls.setRows(lRow);                

            lRow    = new LinkedList();
            lRow.add("");
            oXls.setRows(lRow);
            
            dbCon.setAutoCommit(false);
            
            if (consolidado.equals ("N")) {
                cons = dbCon.prepareCall(db.getSettingCall("DEU_ALL_DEUDORES (?,?,?,?,?,?,? )"));
                cons.registerOutParameter(1, java.sql.Types.OTHER);
                if (oProd.getiCodProd ()  == 0 ) {
                    cons.setNull    (2, java.sql.Types.INTEGER);
                } else {
                    cons.setInt     (2, oProd.getiCodProd());
                }
                if (sTomador == null ) {
                    cons.setNull    (3, java.sql.Types.VARCHAR);
                } else {
                    cons.setString  (3, sTomador);
                }
                cons.setDate        (4, Fecha.convertFecha(fecha));
                cons.setDouble      (5, minDeuda);
                cons.setString      (6, consolidado);
                cons.setInt         (7, numPoliza);
                if ( oProd.getiNumTomador () == 0 ) {
                    cons.setNull    (8, java.sql.Types.INTEGER);
                } else {
                    cons.setInt     (8, oProd.getiNumTomador ());
                }

                cons.execute();

                rs = (ResultSet) cons.getObject(1);
                
                if (rs != null) {
                    int iCodRamaAnt = -1;
                    int iNumPolAnt  = -1;
                    int iEndosoAnt  = -1;
                    double saldoAnt = 0;
                    double deudaAnt = 0;
                    double totalDeudaPol = 0;
                    String sVencida = "NO";

// titulos
                    lRow = new LinkedList();
                    lRow.add("Rama");                    
                    lRow.add("Poliza");
                    lRow.add("Endoso");
                    lRow.add("Asegurado");
                    lRow.add("Vigencia"); 
                    lRow.add("Cuotas");                            
                    lRow.add("Fecha");
                    lRow.add("Movimiento");
                    lRow.add("Importe");    
                    oXls.setRows(lRow);                
                    
                    while (rs.next()) {
                        if (rs.getInt  ("COD_RAMA") != iCodRamaAnt ||
                            rs.getInt  ("NUM_POLIZA") != iNumPolAnt ||   
                            rs.getInt  ("ENDOSO")    != iEndosoAnt) { 
                            
                            if (iCodRamaAnt != -1) {
                                lRow = new LinkedList();
                                lRow.add("");
                                lRow.add("");
                                lRow.add("");
                                lRow.add((sVencida.equals ("SI") ?  "Vencido:" + Dbl.DbltoStr(deudaAnt,2) : " "));                                
                                lRow.add((sVencida.equals ("NO") ? "Atraso:" + Dbl.DbltoStr(deudaAnt,2) : " " ));                                
                                lRow.add("");
                                lRow.add("");
                                lRow.add("Saldo.....:"); 
                                
//                                lRow.add( Dbl.DbltoStr( saldoAnt,2) );                                
                                lRow.add( new Double (saldoAnt) );                                
                                
                                oXls.setRows(lRow);                
                                
                                if (rs.getInt  ("COD_RAMA") != iCodRamaAnt ||
                                    rs.getInt  ("NUM_POLIZA") != iNumPolAnt) {
                                    lRow = new LinkedList();
                                    lRow.add("");
                                    lRow.add("");
                                    lRow.add("");
                                    lRow.add("TOTAL POLIZA:" + Dbl.DbltoStr(totalDeudaPol,2));                                
                                    lRow.add(" ");                            
                                    lRow.add("");
                                    lRow.add("");
                                    lRow.add(" ");    
                                    lRow.add(" ");
                                    oXls.setRows(lRow);                

                                    totalDeudaPol = 0;
                                }
                            }

                                lRow = new LinkedList();
                                lRow.add (String.valueOf (rs.getInt  ("COD_RAMA")));
                                lRow.add (Formatos.showNumPoliza(rs.getInt  ("NUM_POLIZA")));
                                lRow.add (Formatos.showNumPoliza(rs.getInt  ("ENDOSO")));
                                lRow.add (rs.getString ("ASEGURADO"));
                                lRow.add ((rs.getDate ("FECHA_INI_VIG_END") == null ? "" : Fecha.showFechaForm(rs.getDate ("FECHA_INI_VIG_END"))) 
                                + " " + (rs.getDate ("FECHA_FIN_VIG_END") == null ? "" : Fecha.showFechaForm(rs.getDate ("FECHA_FIN_VIG_END"))));                            
                                lRow.add (rs.getDate ("FECHA_EMISION_END") == null ? "" : Fecha.showFechaForm(rs.getDate ("FECHA_EMISION_END")));                                
                                lRow.add (String.valueOf (rs.getInt  ("CANT_CUOTAS")));
                                lRow.add (rs.getInt  ("ENDOSO") == 0 ? "Poliza" : "Endoso");
                                lRow.add ( new Double  (rs.getDouble ("TOTAL_FACTURADO_END")));    
                                oXls.setRows(lRow);                
                            

                            if (rs.getDouble ("IMP_PAGO") != 0) {
                                lRow = new LinkedList();
                                lRow.add (String.valueOf (rs.getInt  ("COD_RAMA")));
                                lRow.add (Formatos.showNumPoliza(rs.getInt  ("NUM_POLIZA")));
                                lRow.add (Formatos.showNumPoliza(rs.getInt  ("ENDOSO")));
                                lRow.add (rs.getString ("ASEGURADO"));
                                lRow.add ((rs.getDate ("FECHA_INI_VIG_END") == null ? "" : Fecha.showFechaForm(rs.getDate ("FECHA_INI_VIG_END"))) 
                                + " " + (rs.getDate ("FECHA_FIN_VIG_END") == null ? "" : Fecha.showFechaForm(rs.getDate ("FECHA_FIN_VIG_END"))));                            
                                lRow.add ((rs.getDate ("FECHA_PAGO") == null ? "" : Fecha.showFechaForm(rs.getDate ("FECHA_PAGO"))));                                
                                lRow.add ((rs.getString ("DESCRIPCION") == null ? " " :  (rs.getString ("DESCRIPCION").length () < 6 ? rs.getString ("DESCRIPCION") : rs.getString ("DESCRIPCION").substring(0, 5)))+
                                " " + (rs.getString ("NUM_COMPROBANTE") == null ? " " : (rs.getString ("NUM_COMPROBANTE").equals ("0") ? " " : rs.getString ("NUM_COMPROBANTE"))));
                                lRow.add (rs.getInt  ("ENDOSO") == 0 ? "Poliza" : "Endoso");
                                
//                                lRow.add (Dbl.DbltoStr(rs.getDouble("IMP_PAGO"),2));    
                                lRow.add ( new Double (rs.getDouble("IMP_PAGO")));    
                                
                                oXls.setRows(lRow);                
                                
                            }
                            iCodRamaAnt = rs.getInt  ("COD_RAMA");
                            iNumPolAnt  = rs.getInt  ("NUM_POLIZA");
                            iEndosoAnt  = rs.getInt  ("ENDOSO");
                            saldoAnt    = rs.getDouble ("SALDO_POLIZA_END");
                            deudaAnt    = rs.getDouble ("IMP_DEUDA_END");
                            totalDeudaPol += rs.getDouble ("IMP_DEUDA_END");
                            sVencida    = rs.getString ("VENCIDA");
                        } else {
                                lRow = new LinkedList();
                                lRow.add (String.valueOf (rs.getInt  ("COD_RAMA")));
                                lRow.add (Formatos.showNumPoliza(rs.getInt  ("NUM_POLIZA")));
                                lRow.add (Formatos.showNumPoliza(rs.getInt  ("ENDOSO")));
                                lRow.add (rs.getString ("ASEGURADO"));
                                lRow.add ((rs.getDate ("FECHA_INI_VIG_END") == null ? "" : Fecha.showFechaForm(rs.getDate ("FECHA_INI_VIG_END"))) 
                                + " " + (rs.getDate ("FECHA_FIN_VIG_END") == null ? "" : Fecha.showFechaForm(rs.getDate ("FECHA_FIN_VIG_END"))));                            
                                lRow.add ((rs.getDate ("FECHA_PAGO") == null ? "" : Fecha.showFechaForm(rs.getDate ("FECHA_PAGO"))));                                
                                lRow.add ((rs.getString ("DESCRIPCION") == null ? " " :  (rs.getString ("DESCRIPCION").length () < 6 ? rs.getString ("DESCRIPCION") : rs.getString ("DESCRIPCION").substring(0, 5)))+
                                " " + (rs.getString ("NUM_COMPROBANTE") == null ? " " : (rs.getString ("NUM_COMPROBANTE").equals ("0") ? " " : rs.getString ("NUM_COMPROBANTE"))));
                                lRow.add (rs.getInt  ("ENDOSO") == 0 ? "Poliza" : "Endoso");
                                
//                                lRow.add (Dbl.DbltoStr(rs.getDouble ("IMP_PAGO"),2));    
                                lRow.add ( new Double (rs.getDouble ("IMP_PAGO")));                                    
                                
                                oXls.setRows(lRow);                
                           
                        }
                    }
                    if (iCodRamaAnt != -1) {
                        lRow = new LinkedList();
                        lRow.add("");
                        lRow.add("");
                        lRow.add("");
                        lRow.add((sVencida.equals ("SI") ?  "Vencido:" + Dbl.DbltoStr(deudaAnt,2) : " "));                                
                        lRow.add((sVencida.equals ("NO") ? "Atraso:" + Dbl.DbltoStr(deudaAnt,2) : " " ));                                
                        lRow.add("");
                        lRow.add("");
                        lRow.add("Saldo.....:");    
//                        lRow.add(Dbl.DbltoStr(saldoAnt,2));
                        lRow.add( new Double(saldoAnt));                        
                        oXls.setRows(lRow);                

                        lRow = new LinkedList();
                        lRow.add("");
                        lRow.add("");
                        lRow.add("");
                        lRow.add("TOTAL POLIZA:" + Dbl.DbltoStr(totalDeudaPol,2));                                
                        lRow.add(" ");                            
                        lRow.add("");
                        lRow.add("");
                        lRow.add(" ");    
                        lRow.add(" ");
                        oXls.setRows(lRow);                
                                
                    }
                    
                } 
            } else {
                cons = dbCon.prepareCall(db.getSettingCall("DEU_ALL_DEUDORES_CONS (?,?,?,?,?,?,?)"));
                cons.registerOutParameter(1, java.sql.Types.OTHER);
                if (oProd.getiCodProd ()  == 0 ) {
                    cons.setNull    (2, java.sql.Types.INTEGER);
                } else {
                    cons.setInt     (2, oProd.getiCodProd ());
                }
                if (sTomador == null ) {
                    cons.setNull    (3, java.sql.Types.VARCHAR);
                } else {
                    cons.setString  (3, sTomador);
                }
                cons.setDate        (4, Fecha.convertFecha(fecha));
                cons.setDouble      (5, minDeuda);
                cons.setString      (6, consolidado);
                cons.setInt         (7, numPoliza);
                if (oProd.getiNumTomador () == 0 ) {
                    cons.setNull    (8, java.sql.Types.INTEGER);
                } else {
                    cons.setInt     (8, oProd.getiNumTomador ());
                }

                cons.execute();

                rs = (ResultSet) cons.getObject(1);
                if (rs != null) {
                    boolean bIsFirst   = true;                    
// titulos
                    lRow = new LinkedList();
                    lRow.add("Rama");                    
                    lRow.add("Poliza");
                    lRow.add("Asegurado");
                    lRow.add("Vigencia"); 
                    lRow.add("Ult. Pago");                            
                    lRow.add("Premio total");
//                    lRow.add("Reducciones");
                    lRow.add("Pagos"); 
                    lRow.add("Saldo");    
                    lRow.add("Deuda");                        
                    
                    oXls.setRows(lRow);                
                    
                    while (rs.next()) {
                        impDeuda15  += rs.getDouble ("A_VENCER_15");
                        impDeuda30  += rs.getDouble ("A_VENCER_30");
                        impDeuda60  += rs.getDouble ("A_VENCER_60");
                        impDeuda365 += rs.getDouble ("A_VENCER_365");
                        impTotalDeuda += rs.getDouble ("IMP_DEUDA_END");

                        lRow = new LinkedList();
                        lRow.add (String.valueOf (rs.getInt  ("COD_RAMA")));
                        lRow.add (Formatos.showNumPoliza(rs.getInt  ("NUM_POLIZA")));
                        lRow.add (rs.getString ("ASEGURADO"));
                        lRow.add ((rs.getDate ("FECHA_INI_VIG_POL") == null ? "" : Fecha.showFechaForm(rs.getDate ("FECHA_INI_VIG_POL"))) 
                        + " " + (rs.getDate ("FECHA_FIN_VIG_POL") == null ? "" : Fecha.showFechaForm(rs.getDate ("FECHA_FIN_VIG_POL"))));                            
                        lRow.add ((rs.getDate ("FECHA_PAGO") == null ? "" : Fecha.showFechaForm(rs.getDate ("FECHA_PAGO"))));                                
//                        lRow.add (Dbl.DbltoStr(rs.getDouble ("TOTAL_FACTURADO"),2));
//                        lRow.add (Dbl.DbltoStr(rs.getDouble ("TOTAL_REDUCCIONES"),2));
//                        lRow.add (Dbl.DbltoStr(rs.getDouble ("TOTAL_PAGOS"),2));
//                        lRow.add (Dbl.DbltoStr(rs.getDouble ("SALDO_POLIZA_END"),2));
//                        lRow.add (Dbl.DbltoStr(rs.getDouble ("IMP_DEUDA_END"),2));

                        lRow.add ( new Double (rs.getDouble ("TOTAL_FACTURADO")));
//                        lRow.add ( new Double (rs.getDouble ("TOTAL_REDUCCIONES")));
                        lRow.add ( new Double (rs.getDouble ("TOTAL_PAGOS")));
                        lRow.add ( new Double (rs.getDouble ("SALDO_POLIZA_END")));
                        lRow.add ( new Double (rs.getDouble ("IMP_DEUDA_END")));
                        
                        oXls.setRows(lRow);                
                    }

                        lRow = new LinkedList();
                        lRow.add("");
                        lRow.add("");
                        lRow.add("Total del informe : $ ");
                        lRow.add(" ");                                
                        lRow.add(" ");                            
//                        lRow.add("");
                        lRow.add("");
                        lRow.add(" ");    
                        lRow.add(" ");
//                        lRow.add(Dbl.DbltoStr(impTotalDeuda,2));
                        lRow.add( new Double (impTotalDeuda));
                        oXls.setRows(lRow);                

                } 
            }

            if (consolidado.equals ("S")) {
                lRow = new LinkedList();
                lRow.add(" ");lRow.add(" ");
                lRow.add("Premios ATRASADOS: ");
//                lRow.add(Dbl.DbltoStr(impTotalDeuda,2));
                lRow.add( new Double (impTotalDeuda));
                
                oXls.setRows(lRow);                
                

                lRow = new LinkedList();
                lRow.add(" ");lRow.add(" ");                
                lRow.add("Premios a Vencer ");
                lRow.add("1 - 15 dias ");
//                lRow.add(Dbl.DbltoStr(impDeuda15,2));
                lRow.add( new Double (impDeuda15));
                
                oXls.setRows(lRow);                
                
                lRow = new LinkedList();
                lRow.add(" ");lRow.add(" ");lRow.add(" ");
                lRow.add("16 - 30 dias ");
//                lRow.add(Dbl.DbltoStr(impDeuda30,2));
                lRow.add( new Double (impDeuda30));
                                
                oXls.setRows(lRow);                

                lRow = new LinkedList();
                lRow.add(" ");lRow.add(" ");lRow.add(" ");
                lRow.add("31 - 60 dias ");
//                lRow.add(Dbl.DbltoStr(impDeuda60,2));
                lRow.add( new Double (impDeuda60));
                
                oXls.setRows(lRow);                

                lRow = new LinkedList();
                lRow.add(" ");lRow.add(" ");lRow.add(" ");
                lRow.add("+ de 60 dias ");
//                lRow.add(Dbl.DbltoStr(impDeuda365,2));
                lRow.add( new Double (impDeuda365 ));
                
                oXls.setRows(lRow);                
            }

/*            Proceso oProc = new Proceso ();
            
            oProc.setsTabla("P_MOVIMIENTOS");
            oProc.getDBUltimaInterfase(dbCon);
            
            if (oProc.getiNumError() != 0) {
                throw new SurException (oProc.getsMensError());
            }

            oReport.addlObj("FECHA_MOVIMIENTOS", Fecha.showFechaForm(oProc.getdFechaFTP()));


// *IMPORTANTE: La informaci�n de p�lizas de �ste sitio se encuentra actualizada al&nbsp;
//                <%= (fechaMov == null ? "" : Fecha.showFechaForm (fechaMov))%>. La informaci�n referida a pagos al&nbsp;
           
            oProc.setsTabla("P_PAGOS");
            oProc.getDBUltimaInterfase(dbCon);
            
            if (oProc.getiNumError() != 0) {
                throw new SurException (oProc.getsMensError());
            }

            oReport.addlObj("FECHA_PAGOS", Fecha.showFechaForm(oProc.getdFechaFTP()));
            
  */          
            request.setAttribute("oReportXls", oXls);
            doForward( request, response, "/servlet/ReportXls");     
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null)  cons.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }
    
    /** Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Short description";
    }
    
    public void doForward(HttpServletRequest request, HttpServletResponse response,
        String nextPage) throws ServletException, IOException {
	try {
      		getServletConfig().getServletContext().getRequestDispatcher(nextPage).forward(request,response);
	} catch (IOException ioe) {
                goToJSPError (request,response, ioe);
	} catch (ServletException se) {
                goToJSPError (request,response, se);
	} catch (Exception e) {
                goToJSPError (request,response, e);
	}  // try		

    } // doForward
    
    public void goToJSPError (HttpServletRequest request, HttpServletResponse response, Throwable t) 
     throws ServletException, IOException {
	try {
                request.setAttribute("javax.servlet.jsp.jspException", t);
		getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
	} catch (IOException ioe) {
		System.out.println("LoginServlet IOException Forwarding Request: " + ioe);
	} catch (ServletException se) {
		System.out.println("LoginServlet ServletException Forwarding Request: " + se);
	} // try		

    } // doForward

}
