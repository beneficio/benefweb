/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package servlets;

import com.business.beans.CtaCteHis;
import com.business.beans.CtaCteOL;
import com.business.beans.Generico;
import com.business.beans.Tablas;
import com.business.beans.Usuario;
import com.business.beans.CtaCteFac;
import com.business.db.db;
import com.business.util.Dbl;
import com.business.util.Diccionario;
import com.business.util.Fecha;
import com.business.util.Proceso;
import com.business.util.Report;
import com.business.util.SurException;
import com.business.util.xls;
import com.business.util.ControlDeUso;
import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.GregorianCalendar;
import java.util.Hashtable;
import java.util.LinkedList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class CtaCteServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {

            if ( request.getParameter ("procedencia") != null) {
                getServletConfig().getServletContext().getRequestDispatcher("/servlet/setAccess?opcion=ADDPROC").include(request,response);
            }
            String op =  request.getParameter("opcion");
            if (op.equals("selectCtaCte")) {
                selectCtaCte (request, response);            
            } else if (op.equals("getCtasCtesHIS")){                
                getCtasCtesHIS(request, response);
            } else if (op.equals("getCtasCtesOL")){
                getCtasCtesOL(request, response);                
            } else if (op.equals("printCtaCteHIS")){
                printCtaCteHIS(request, response);
            } else if (op.equals("getCtaCteFac")){
                getCtaCteFac(request, response);
            }
        } catch (SurException se) {            
            goToJSPError(request,response, se);
        } catch (Exception e) {            
            goToJSPError(request,response, e);
        }
    } 

    protected void selectCtaCte  (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        Proceso oProc = new Proceso ();
        String sUltFechaOL = "";
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));            
            oProc = new Proceso ();
            oProc.setsTabla("CC_CTACTE_OL");
            dbCon = db.getConnection();
            oProc.getDBUltimaInterfase(dbCon);
            if (oProc.getiNumError() != 0) {
                throw new SurException (oProc.getsMensError());
            }
            sUltFechaOL =
                    (oProc.getdFechaFTP() == null ? "no informado" : Fecha.showFechaForm(oProc.getdFechaFTP()));

            oProc.getDBUltimaCtaCte(dbCon, oUser.getiCodTipoUsuario());
   
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }        
        request.setAttribute("fechaMaxCtaCte", sUltFechaOL);
        request.setAttribute("fechaMaxCtaCteHis", oProc.getdFechaFTP());
        doForward(request, response, "/ctacte/formCtaCte.jsp");
    }

    protected void getCtasCtesHIS (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;  
        LinkedList lCtaCteHis = new LinkedList ();
        Proceso oProc = new Proceso ();
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            Diccionario oDicc   = (Diccionario) (request.getSession().getAttribute("Diccionario"));
            int iCodProd        = oDicc.getInt (request, "cc_cod_prod");
            int iFechaDesde     = oDicc.getInt (request, "cc_fecha_desde");
            int iFechaHasta     = oDicc.getInt (request, "cc_fecha_hasta");            
            
System.out.println ("en CtacteHist --> " + iCodProd + " - " + iFechaDesde + " - " + iFechaHasta);

            dbCon = db.getConnection();
            lCtaCteHis = getCtasCtesHistoricas (dbCon, iCodProd , iFechaDesde , iFechaHasta);

            // setear el control de acceso
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, 27);

           // fin de setear el control de acceso

            oProc.getDBUltimaCtaCte(dbCon, oUser.getiCodTipoUsuario());

            CtaCteFac oCC = new CtaCteFac();
            oCC.setCodProd(iCodProd);
            oCC.setFechaMov(oProc.getdFechaFTP());
            oCC.getDB(dbCon, oUser.getusuario());

            if (oCC.getiNumError() < 0 && oCC.getiNumError() != -100) {
                throw new SurException( oCC.getsMensError());
            }

            request.setAttribute("ctaCteFac", oCC);
            request.setAttribute("fechaMaxCtaCteHis", oProc.getdFechaFTP());
            request.setAttribute("ctasCtesHis", lCtaCteHis);
            doForward(request, response, "/ctacte/formResultCtaCteHis.jsp");
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {      
            db.cerrar(dbCon);
        }
    }

    protected void printCtaCteHIS (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection        dbCon = null;
        LinkedList        lCtaCteHis = new LinkedList();
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            Diccionario oDicc   = (Diccionario) (request.getSession().getAttribute("Diccionario"));
            int iCodProd        = oDicc.getInt (request, "cc_cod_prod");
            int iFechaDesde     = oDicc.getInt (request, "cc_fecha_desde");
            int iFechaHasta     = oDicc.getInt (request, "cc_fecha_hasta");
            String formato      = oDicc.getString(request,"formato");
            String sCodProdDesc = oDicc.getString (request, "cc_prod_desc");            
            dbCon = db.getConnection();
            lCtaCteHis = getCtasCtesHistoricas (dbCon, iCodProd , iFechaDesde , iFechaHasta);
            if (formato.equals ("EXCEL")) {
                getCtasCtesHisXls(lCtaCteHis,request, response);
            } else { // PDF
                getCtasCtesHisPdf (lCtaCteHis,request, response);
            }
        } catch (Exception se) {
            throw new SurException (se.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }    
    protected void getCtasCtesOL (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        LinkedList lCtaCteOL = new LinkedList ();
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            Diccionario oDicc   = (Diccionario) (request.getSession().getAttribute("Diccionario"));
            int iCodProd        = oDicc.getInt (request, "cc_cod_prod");
            int iFechaOL        = oDicc.getInt (request, "cc_fecha_ol_yyyymm");
            String sFechaOL     = oDicc.getString(request, "cc_fecha_ol");
            String sCodProdDesc = oDicc.getString (request, "cc_prod_desc");
            dbCon = db.getConnection();
            lCtaCteOL =  this.getCtasCtesOnLine(dbCon, iCodProd , iFechaOL);
            // setear el control de acceso
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, 28);
            
            System.out.println ("getCtactesOL" + iCodProd );

           // fin de setear el control de acceso    
              

            request.setAttribute("ctasCtesOL", lCtaCteOL);           
            doForward(request, response, "/ctacte/formResultCtaCteOL.jsp");
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    /* --------- */
    /*  PRIVATE  */
    /* --------- */
    private LinkedList getCtasCtesHistoricas (Connection dbCon, int pCodProd , int pFechaDesde , int pFechaHasta)
    throws ServletException, IOException, SurException {

        CallableStatement cons  = null;
        ResultSet rs = null;
        LinkedList lCtaCteHis = new LinkedList ();
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("CC_GET_ALL_CTACTE_HIS (?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            if ( pCodProd  == 0 ) {
                cons.setNull    (2, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (2, pCodProd );
            }
            if ( pFechaDesde  == 0 ) {
                cons.setNull    (3, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (3, pFechaDesde);
            }
            if ( pFechaHasta  == 0 ) {
                cons.setNull    (4, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (4, pFechaHasta);
            }
            cons.execute();
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    CtaCteHis oCtaCteHis = new CtaCteHis ();
                    oCtaCteHis.setAnioMes(rs.getInt("ANIO_MES")) ;
                    oCtaCteHis.setCodProddDc(rs.getString("COD_PROD_DC"));
                    oCtaCteHis.setFechaMov(rs.getDate("FECHA_MOV")) ;
                    oCtaCteHis.setMovimiento(rs.getString("MOVIMIENTO"));
                    oCtaCteHis.setConcepto(rs.getString("CONCEPTO"));
                    oCtaCteHis.setCodRama(rs.getInt("COD_RAMA"));
                    oCtaCteHis.setNumPoliza(rs.getInt("NUM_POLIZA"));
                    oCtaCteHis.setEndoso(rs.getInt("ENDOSO"));
                    oCtaCteHis.setComprobante(rs.getString("COMPROBANTE"));
                    oCtaCteHis.setTipoIngreso(rs.getString("TIPO_INGRESO")) ;
                    oCtaCteHis.setImpPrima(rs.getDouble("IMP_PRIMA"));
                    oCtaCteHis.setImpPremio(rs.getDouble("IMP_PREMIO"));
                    oCtaCteHis.setDebe(rs.getDouble("DEBE"));
                    oCtaCteHis.setHaber(rs.getDouble("HABER"));
                    oCtaCteHis.setOrdene(rs.getInt("ORDENE"));
                    oCtaCteHis.setSaldo(rs.getDouble("SALDO"));
                    oCtaCteHis.setComision(rs.getDouble("COMISION"));
                    lCtaCteHis.add(oCtaCteHis);                }
                rs.close ();
            }
            return lCtaCteHis;

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
    }
  
    private LinkedList getCtasCtesOnLine (Connection dbCon, int pCodProd , int pFechaOL)
    throws ServletException, IOException, SurException {

        CallableStatement cons  = null;
        ResultSet rs = null;
        LinkedList lCtaCteOL = new LinkedList ();
        try {
            dbCon.setAutoCommit(false);
                cons = dbCon.prepareCall(db.getSettingCall("CC_GET_ALL_CTACTE_OL (?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            if ( pCodProd  == 0 ) {
                cons.setNull    (2, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (2, pCodProd );
            }
            if ( pFechaOL  == 0 ) {
                cons.setNull    (3, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (3, pFechaOL);
            }
            cons.execute();
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    CtaCteOL oCtaCteOL  = new CtaCteOL();
                    oCtaCteOL.setFechaMov   (rs.getDate("FECHA_MOV"));
                    oCtaCteOL.setOrdene     (rs.getInt("ORDENE"));
                    oCtaCteOL.setMovimiento (rs.getString("MOVIMIENTO"));
                    oCtaCteOL.setComprobante(rs.getInt("COMPROBANTE"));
                    oCtaCteOL.setConcepto   (rs.getString("CONCEPTO"));
                    oCtaCteOL.setDebe       (rs.getDouble("DEBE"));
                    oCtaCteOL.setHaber      (rs.getDouble("HABER"));
                    oCtaCteOL.setImpSoc     (rs.getDouble("IMP_SOC"));
                    oCtaCteOL.setPring1     (rs.getInt("ING_BRUTO_1"));
                    oCtaCteOL.setPring2     (rs.getInt("ING_BRUTO_2"));
                    lCtaCteOL.add           (oCtaCteOL);
                }
                rs.close ();
            }
            return lCtaCteOL;
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
    }

    private void getCtasCtesHisXls (LinkedList lCtaCteHis,HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        xls oXls = new xls ();
        LinkedList        lRow  = null;
        try {

            Diccionario oDicc   = (Diccionario) (request.getSession().getAttribute("Diccionario"));
            String sCodProdDesc = oDicc.getString (request, "cc_prod_desc");

            int iSize        = (lCtaCteHis == null ? 0 : lCtaCteHis.size());
            String fechaDesde = "";
            String fechaHasta = "";
            if (iSize>1)  {
                CtaCteHis oCCHis = (CtaCteHis) lCtaCteHis.get(0);
                if (oCCHis.getOrdene() == 1) {
                    String _anioMes = String.valueOf( oCCHis.getAnioMes() );
                    String _anio    = _anioMes.substring(0,4);
                    String _mes     = _anioMes.substring(4,_anioMes.length());
                    fechaDesde =    "01/" + _mes + "/" + _anio;
                }
                int ultimo = iSize -1;
                oCCHis = (CtaCteHis) lCtaCteHis.get(ultimo);
                if (oCCHis.getOrdene() == 99) {
                    String _anioMes = String.valueOf( oCCHis.getAnioMes() );
                    String _anio    = _anioMes.substring(0,4);
                    String _mes     = _anioMes.substring(4,_anioMes.length());
                    GregorianCalendar gc = new GregorianCalendar();
                    gc.set(GregorianCalendar.YEAR, Integer.parseInt(_anio));
                    gc.set(GregorianCalendar.MONTH, Integer.parseInt(_mes)-1);
                    gc.set(GregorianCalendar.DATE, 1);
                    int _ultimoDia = gc.getActualMaximum( GregorianCalendar.DAY_OF_MONTH );
                    fechaHasta =  _ultimoDia + "/" + _mes + "/" + _anio;
                }
            }

            if (lCtaCteHis.size()>0) {
                oXls.setTitulo("CUENTAS CORRIENTES HISTORICAS");
                lRow   = new LinkedList();
                lRow.add(" ");
                lRow.add(" ");
                lRow.add(""); //rama
                lRow.add(""); //poliza
                lRow.add(""); //endoso
                lRow.add("Beneficio S.A. Compañia de Seguros");
                oXls.setRows(lRow);
                
                lRow   = new LinkedList();
                lRow.add("");
                oXls.setRows(lRow);

                lRow   = new LinkedList();
                lRow.add(" ");
                lRow.add(" ");
                lRow.add(""); //rama
                lRow.add(""); //poliza
                lRow.add(""); //endoso
                lRow.add("CUENTAS CORRIENTES PRODUCTORES AL  " );
                lRow.add(fechaHasta);
                oXls.setRows(lRow);

                lRow   = new LinkedList();
                lRow.add(" ");
                lRow.add(" ");
                lRow.add(""); //rama
                lRow.add(""); //poliza
                lRow.add(""); //endoso
                lRow.add("Productor: "+ sCodProdDesc);
                oXls.setRows(lRow);

                lRow   = new LinkedList();
                lRow.add(" ");
                lRow.add(" ");
                lRow.add(""); //rama
                lRow.add(""); //poliza
                lRow.add(""); //endoso
                lRow.add("Periodo:" + fechaDesde + " AL " + fechaHasta);
                oXls.setRows(lRow);

                lRow   = new LinkedList();
                lRow.add(" ");                
                oXls.setRows(lRow);

                lRow    = new LinkedList();
                lRow.add("Fecha");
                lRow.add("Tipo.mov");
                lRow.add("Rama");
                lRow.add("Poliza");
                lRow.add("Endoso");
                lRow.add("Concepto");
                lRow.add("Comprob");
                lRow.add("Forma.Pago");
                lRow.add("Prima");
                lRow.add("Premio");
                lRow.add("Debe");
                lRow.add("Haber");
                oXls.setRows(lRow);
                String impPrimaStr ="";
                String impPremioStr ="";
                String impSaldoStr ="";
                for (int i=0; i < lCtaCteHis.size(); i++)  {
                    CtaCteHis oCCHis = (CtaCteHis) lCtaCteHis.get(i);
                    lRow   = new LinkedList();
                    if (oCCHis.getOrdene() == 1  ||oCCHis.getOrdene() ==99 )
                    {
                        if (oCCHis.getOrdene() == 1) {
                            lRow.add("");
                            lRow.add("");
                            lRow.add(""); //rama
                            lRow.add(""); //poliza
                            lRow.add(""); //endoso
                            lRow.add("Saldo acumulado del Cod:" + oCCHis.getCodProddDc() + " al " +
                                    (oCCHis.getFechaMov() == null ? " " : Fecha.showFechaForm(oCCHis.getFechaMov())) +
                                    " ****** " +
                                    Dbl.DbltoStr(oCCHis.getSaldo(),2));
                        } else {
                            String _anioMes = String.valueOf( oCCHis.getAnioMes() );
                            String _anio    = _anioMes.substring(0,4);
                            String _mes     = _anioMes.substring(4,_anioMes.length());
                            GregorianCalendar gc = new GregorianCalendar();
                            gc.set(GregorianCalendar.YEAR, Integer.parseInt(_anio));
                            gc.set(GregorianCalendar.MONTH, Integer.parseInt(_mes)-1);
                            gc.set(GregorianCalendar.DATE, 1);
                            int _ultimoDia = gc.getActualMaximum( GregorianCalendar.DAY_OF_MONTH );
                            String _fechaSaldo = _ultimoDia + "/" + _mes + "/" + _anio;
                            lRow.add("");
                            lRow.add("");
                            lRow.add(""); //rama
                            lRow.add(""); //poliza
                            lRow.add(""); //endoso
                            lRow.add("Saldo final  al " + _fechaSaldo +" ****** "
                                     + String.valueOf(oCCHis.getSaldo()));
                            impPrimaStr  = String.valueOf(oCCHis.getImpPrima()) ;
                            impPremioStr = String.valueOf(oCCHis.getImpPremio()) ;
                            impSaldoStr  = String.valueOf(oCCHis.getSaldo()) ;
                        }     
                    } else {
                        lRow.add((oCCHis.getFechaMov() == null ? " " : Fecha.showFechaForm(oCCHis.getFechaMov())) );
                        lRow.add((oCCHis.getMovimiento() == null ? " " : oCCHis.getMovimiento()));
                        lRow.add( String.valueOf(oCCHis.getCodRama()));
                        lRow.add( String.valueOf(oCCHis.getNumPoliza()));
                        lRow.add( String.valueOf(oCCHis.getEndoso()));
//                        if (oCCHis.getCodRama()>0 && oCCHis.getNumPoliza()>0) {
//                            lRow.add( oCCHis.getCodRama() + "/" + oCCHis.getNumPoliza()+"/"+oCCHis.getEndoso()+"-"+oCCHis.getConcepto());
//                        } else {
                            lRow.add( oCCHis.getConcepto());
//                        }
                        lRow.add( oCCHis.getComprobante());
                        lRow.add( oCCHis.getTipoIngreso());
                        lRow.add( Double.valueOf(oCCHis.getImpPrima()));
                        lRow.add( Double.valueOf(oCCHis.getImpPremio()));
                        lRow.add( Double.valueOf(oCCHis.getDebe()));
                        lRow.add( Double.valueOf(oCCHis.getHaber()));
                    }
                    oXls.setRows(lRow);
                }   

                lRow   = new LinkedList();
                lRow.add(" ");
                oXls.setRows(lRow); 

                lRow   = new LinkedList();
                lRow.add(" ");
                lRow.add(" ");
                lRow.add(""); //rama
                lRow.add(""); //poliza
                lRow.add(""); //endoso
                lRow.add("TOTAL DE PRIMA: ");
                lRow.add( Double.valueOf(impPrimaStr));
                oXls.setRows(lRow);

                lRow   = new LinkedList();
                lRow.add(" ");
                lRow.add(" ");
                lRow.add(""); //rama
                lRow.add(""); //poliza
                lRow.add(""); //endoso
                lRow.add("TOTAL DE PREMIO: ");
                lRow.add( Double.valueOf(impPremioStr));
                oXls.setRows(lRow);

                lRow   = new LinkedList();
                lRow.add(" ");
                lRow.add(" ");
                lRow.add(""); //rama
                lRow.add(""); //poliza
                lRow.add(""); //endoso
                lRow.add("TOTAL DE SALDO: ");
                lRow.add( Double.valueOf(impSaldoStr));
                oXls.setRows(lRow);

                lRow   = new LinkedList();
                lRow.add(" ");
                oXls.setRows(lRow);

                lRow   = new LinkedList();
                lRow.add(" ");
                lRow.add(" ");
                lRow.add(""); //rama
                lRow.add(""); //poliza
                lRow.add(""); //endoso
                lRow.add("FORMAS DE PAGO : ");
                oXls.setRows(lRow);

               

                LinkedList lDescFormaPago = this.getDescFormasDePago();
                for (int index=0; index < lDescFormaPago.size(); index++) {
                    lRow   = new LinkedList();
                    String descFormaDePago = (String) lDescFormaPago.get(index);
                    lRow.add("");
                    lRow.add("");
                    lRow.add(""); //rama
                    lRow.add(""); //poliza
                    lRow.add(""); //endoso
                    lRow.add(descFormaDePago);
                    oXls.setRows(lRow);
                }
            }
            request.setAttribute("oReportXls", oXls);
            doForward( request, response, "/servlet/ReportXls");
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        }
    }
    private void getCtasCtesHisPdf (LinkedList lCtaCteHis,HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Report oReport = new Report();
        try {
            Diccionario oDicc   = (Diccionario) (request.getSession().getAttribute("Diccionario"));
            String sCodProdDesc = oDicc.getString (request, "cc_prod_desc");
            int iSize        = (lCtaCteHis == null ? 0 : lCtaCteHis.size());
            String fechaDesde = "";
            String fechaHasta = "";
            if (iSize>1)  {
                CtaCteHis oCCHis = (CtaCteHis) lCtaCteHis.get(0);
                if (oCCHis.getOrdene() == 1) {
                    String _anioMes = String.valueOf( oCCHis.getAnioMes() );
                    String _anio    = _anioMes.substring(0,4);
                    String _mes     = _anioMes.substring(4,_anioMes.length());
                    fechaDesde =    "01/" + _mes + "/" + _anio;
                }
                int ultimo = iSize -1;
                oCCHis = (CtaCteHis) lCtaCteHis.get(ultimo);
                if (oCCHis.getOrdene() == 99) {
                    String _anioMes = String.valueOf( oCCHis.getAnioMes() );
                    String _anio    = _anioMes.substring(0,4);
                    String _mes     = _anioMes.substring(4,_anioMes.length());
                    GregorianCalendar gc = new GregorianCalendar();
                    gc.set(GregorianCalendar.YEAR, Integer.parseInt(_anio));
                    gc.set(GregorianCalendar.MONTH, Integer.parseInt(_mes)-1);
                    gc.set(GregorianCalendar.DATE, 1);
                    int _ultimoDia = gc.getActualMaximum( GregorianCalendar.DAY_OF_MONTH );
                    fechaHasta =  _ultimoDia + "/" + _mes + "/" + _anio;
                }
            }

            

            oReport.setOrientacion("portrait");//// portrait = horizontal, landscape = vertical
            oReport.setTitulo       ("CUENTAS CORRIENTES HISTORICAS");
            oReport.addlObj         ("subtitulo" , "CUENTAS CORRIENTES HISTORICAS");
            oReport.setUsuario      (" ");
            oReport.setFecha        (Fecha.toString(new java.util.Date ()));
            oReport.setFormulario   ("NOM001");
            oReport.setReportName   (getServletContext ().getRealPath("/ctacte/report/ctactehis.xml"));
            oReport.setsContextPath ( request.getScheme() + "://" + request.getHeader("host"));
            oReport.addImage        ("logo", getServletContext ().getRealPath("/images/logos/logo_beneficio_new.jpg"));

            oReport.addlObj("COD_PROD_DESC", sCodProdDesc);
            oReport.addlObj("FEC_DESDE", fechaDesde);
            oReport.addlObj("FEC_HASTA", fechaHasta);


            oReport.addIniTabla("TABLA_CTA_CTE_HIS");
            if (lCtaCteHis != null ) {
                String sStyle[] = {"ItemCob", "ItemCobL", "ItemCobL", "ItemCobR","ItemCobL","ItemCobR","ItemCobR","ItemCobR","ItemCobR"  };
                //String sStyle[] = {"ItemCob", "ItemCobL", "ItemCobL", "ItemCobR","ItemCobR","ItemCobR","ItemCobR","ItemCobR"  };
                for (int i = 0; i< lCtaCteHis.size();i++) {                    
                    CtaCteHis oCtaCteHis = (CtaCteHis) lCtaCteHis.get(i);
                    if (oCtaCteHis.getOrdene() == 1  ||oCtaCteHis.getOrdene() ==99 )
                    {
                        if (oCtaCteHis.getOrdene() == 1) {
                            String sElem [] ={ "","" ,
                                               "Saldo Acumulado del Cod: "+ oCtaCteHis.getCodProddDc() + " al " +
                                               (oCtaCteHis.getFechaMov() == null ? " " : Fecha.showFechaForm(oCtaCteHis.getFechaMov())),
                                               "","","","","", String.valueOf(oCtaCteHis.getSaldo()) };
                            oReport.addElementsTabla(sElem, sStyle);

                        } else {
                            String _anioMes = String.valueOf( oCtaCteHis.getAnioMes() );
                            String _anio    = _anioMes.substring(0,4);
                            String _mes     = _anioMes.substring(4,_anioMes.length());
                            GregorianCalendar gc = new GregorianCalendar();
                            gc.set(GregorianCalendar.YEAR, Integer.parseInt(_anio));
                            gc.set(GregorianCalendar.MONTH, Integer.parseInt(_mes)-1);
                            gc.set(GregorianCalendar.DATE, 1);
                            int _ultimoDia = gc.getActualMaximum( GregorianCalendar.DAY_OF_MONTH );
                            String _fechaSaldo = _ultimoDia + "/" + _mes + "/" + _anio;                          
                            String sElem [] ={ "","" ,
                                               "Saldo final  al " +  _fechaSaldo +" ***** "+ String.valueOf(oCtaCteHis.getSaldo()),
                                               "","","","","","" };
                            oReport.addElementsTabla(sElem, sStyle);
                            oReport.addlObj("IMP_TOT_PRIMA", String.valueOf(oCtaCteHis.getImpPrima()));
                            oReport.addlObj("IMP_TOT_PREMIO", String.valueOf(oCtaCteHis.getImpPremio()));
                            oReport.addlObj("IMP_TOT_SALDO", String.valueOf(oCtaCteHis.getSaldo()));
                        }
                    } else {
                        String fecha =(oCtaCteHis.getFechaMov() == null ? " " : Fecha.showFechaForm(oCtaCteHis.getFechaMov())) ;
                        String movimiento = (oCtaCteHis.getMovimiento() == null ? " " : oCtaCteHis.getMovimiento());
                        String concepto = "";
                        if (oCtaCteHis.getCodRama()>0 && oCtaCteHis.getNumPoliza()>0) {
                            concepto =  oCtaCteHis.getCodRama() + "/" + oCtaCteHis.getNumPoliza()+"/"+oCtaCteHis.getEndoso()+"-"+
                                     (oCtaCteHis.getConcepto() == null ? " " : oCtaCteHis.getConcepto());
                        } else {
                            concepto =  (oCtaCteHis.getConcepto() == null ? " ":  oCtaCteHis.getConcepto());
                        }
                        String comprobante =  (oCtaCteHis.getComprobante()==null?"":oCtaCteHis.getComprobante());
                        String tipoComprobante =  (oCtaCteHis.getTipoIngreso()==null?"":oCtaCteHis.getTipoIngreso());

                        String sElem [] ={ 
                                       fecha, movimiento,concepto ,comprobante,tipoComprobante,
                                       String.valueOf(oCtaCteHis.getImpPrima()) ,
                                       String.valueOf(oCtaCteHis.getImpPremio()) ,
                                       String.valueOf(oCtaCteHis.getDebe()),
                                       String.valueOf(oCtaCteHis.getHaber())
                                     };
                        oReport.addElementsTabla(sElem, sStyle);
                    }
                }       
            }

            oReport.addFinTabla();

            oReport.addIniTabla("TABLA_FORMA_PAGO");
            
            LinkedList lDescFormaPago = this.getDescFormasDePago();

//System.out.println ("size forma de pago  " + lDescFormaPago.size() );

            String sStyle2[] = {"ItemFormaPago" };
            for (int index=0; index < lDescFormaPago.size(); index++) {
                String descFormaDePago = (String) lDescFormaPago.get(index);
                String sElem [] ={descFormaDePago };
                oReport.addElementsTabla(sElem, sStyle2);
            }            
            oReport.addFinTabla();

            
            request.setAttribute("oReport", oReport );
            request.setAttribute("nombre", "Beneficio_ctacte.pdf");
            doForward (request,response, "/servlet/ReportPdf");

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        }
    }
    private LinkedList getDescFormasDePago ()
    throws ServletException, IOException, SurException {
        LinkedList lFormaPago = new  LinkedList();
        try {
            Hashtable hFormaPagoDesCorta = new Hashtable();
            Tablas tablaFormaPagoDescCorta = new Tablas();
            LinkedList lFormaDePagoDescCorta = tablaFormaPagoDescCorta.getDatosOrderByDesc ("CTACTE_TIPOIN_CORTO");
            for (int index1=0; index1 < lFormaDePagoDescCorta.size(); index1++) {
                Generico oFormaDePagoDescCorta = (Generico) lFormaDePagoDescCorta.get(index1);
                hFormaPagoDesCorta.put(oFormaDePagoDescCorta.getsCodigo(), oFormaDePagoDescCorta.getDescripcion()) ;
            }
            Tablas tablaFormaPago = new Tablas();
            LinkedList lFormaDePago = tablaFormaPago.getDatosOrderByDesc ("CTACTE_TIPOIN_LARGO");
            for (int index=0; index < lFormaDePago.size(); index++) {
                Generico oFormaDePago = (Generico) lFormaDePago.get(index);
                lFormaPago.add(hFormaPagoDesCorta.get(oFormaDePago.getsCodigo())+" - "+ oFormaDePago.getDescripcion());
            }
            return lFormaPago;
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        }
    }

    protected void getCtaCteFac  (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        LinkedList lCtaCteFac = new LinkedList ();
        CallableStatement cons  = null;
        ResultSet rs = null;
        try {
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            int iCodProd  = (request.getParameter ("cod_prod") == null ? 
                            (oUser.getiCodTipoUsuario() == 1 && oUser.getsCodVinculo().equals("P") ? oUser.getiCodProd() : -1 ) :
                             Integer.parseInt(request.getParameter("cod_prod")));
            
            Usuario oProd = new Usuario ();
            
            if (iCodProd != -1) {
                dbCon = db.getConnection();
                oProd.setiCodProd(iCodProd);
                oProd.setusuario(oUser.getusuario());
                oProd.getDBProductor(dbCon);
                oProd.getDBValidarCuit(dbCon);

                dbCon.setAutoCommit(false);
                cons = dbCon.prepareCall(db.getSettingCall("CC_GET_ALL_CTACTE_FA (?,?)"));
                cons.registerOutParameter(1, java.sql.Types.OTHER);
                cons.setInt     (2, iCodProd );
                cons.setString  (3, oUser.getusuario());

                cons.execute();
                rs = (ResultSet) cons.getObject(1);
                if (rs != null) {
                    while (rs.next()) {
                        CtaCteFac oCtaCteFac = new CtaCteFac ();
                        oCtaCteFac.setCodProdDc(rs.getString("COD_PROD_DC"));
                        oCtaCteFac.setCodProd(rs.getInt("COD_PROD"));
                        oCtaCteFac.setCodOrg(rs.getInt("COD_ORG"));
                        oCtaCteFac.setbeneficiario(rs.getString("BENEFICIARIO"));
                        oCtaCteFac.setFechaMov(rs.getDate("FECHA"));
                        oCtaCteFac.setnumOrden(rs.getInt("NUM_ORDEN"));
                        oCtaCteFac.setOperacion(rs.getString("OPERACION"));
                        oCtaCteFac.setImporte(rs.getDouble("IMP_BASE"));
                        oCtaCteFac.setimpIva(rs.getDouble("IMP_IVA"));
                        oCtaCteFac.setimpTotal(rs.getDouble("IMP_TOTAL"));
                        oCtaCteFac.setimpFactura(rs.getDouble("IMP_FACTURA"));
                        oCtaCteFac.setestado(rs.getString("ESTADO"));
                        oCtaCteFac.settipoComprob(rs.getString("TIPO_COMP"));
                        oCtaCteFac.setnumComprob1(rs.getString("NUM_FACT1"));
                        oCtaCteFac.setnumComprob2(rs.getString("NUM_FACT2"));
                        oCtaCteFac.setnumSecuOp (rs.getInt ("NUM_SECU_OP"));
                        oCtaCteFac.setanioMes (rs.getInt ("ANIO_MES"));
                        oCtaCteFac.setcodEstadoOP(rs.getInt ("COD_ESTADO_OP"));
                        oCtaCteFac.setestadoPago(rs.getString ("ESTADO_PAGO"));
                        oCtaCteFac.setfechaFactura(rs.getDate("FECHA_FACTURA"));
                        oCtaCteFac.setbrutoFactura(rs.getDouble ("BRUTO_FACTURA"));
                        oCtaCteFac.setnetoAPAgar(rs.getDouble ("NETO_A_PAGAR"));
                        lCtaCteFac.add(oCtaCteFac);     
                    }
                    rs.close ();
                }

                cons.close();
                // setear el control de acceso
                ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
                oControl.setearAcceso(dbCon, 29);
               // fin de setear el control de acceso
            }

            request.setAttribute("productor",  oProd);
            request.setAttribute("ctactefac", lCtaCteFac);
            doForward(request, response, "/ctacte/formCtaCteFac.jsp?cod_prod=" + iCodProd + "&ce_origen=" + (request.getParameter("ce_origen") == null ? "-1" : request.getParameter("ce_origen") ));
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Short description";
    }

    public void doForward(HttpServletRequest request, HttpServletResponse response,
            String nextPage) throws  ServletException, IOException {
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
