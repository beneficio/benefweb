/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package servlets;

import java.io.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.LinkedList;
import java.util.Date;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import com.business.beans.*;
import com.business.util.*;
import com.business.db.*;
/**
 *
 * @author Rolando Elisii
 */
public class RenuevaServlet extends HttpServlet {
   
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

            if (op.equals ("recotizar")) {
                Recotizar (request, response);
            } else  if (op.equals ("getAllPol")) {
                getAllPolizas (null , request, response);
            } else  if (op.equals ("getAllXLS")) {
                getAllPolizasCSV     (null , request, response);
            } else  if (op.equals ("renovar")) {
                Renovar (request, response);
            } else  if (op.equals ("getPropuesta")) {
                getPropuesta (request, response);
            } else if (op.equals("enviarMail")) {
                enviarMail (request, response);
            }
         } catch (SurException se) {
            goToJSPError(request,response, se);
        } catch (Exception e) {
            goToJSPError(request,response, e);
        }
    }

    protected void Recotizar (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons  = null;
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            int iCodRama        = (Integer.parseInt (request.getParameter ("F1cod_rama_sel")));
            int iNumPoliza      = (Integer.parseInt (request.getParameter ("F1num_poliza_sel")));
            int iCantVidas      = (Integer.parseInt (request.getParameter ("cant_vidas")));
            int iNumCotizacion  = (Integer.parseInt (request.getParameter ("num_cotizacion")));
            int iRetorno        = 0;
            boolean bError      = false;

            dbCon = db.getConnection();
            try {
                dbCon.setAutoCommit(true);
                cons = dbCon.prepareCall(db.getSettingCall("REN_RECOTIZAR (?,?,?,?,?)"));
                cons.registerOutParameter(1, java.sql.Types.INTEGER);
                cons.setInt (2, iCodRama);
                cons.setInt (3, iNumPoliza);
                cons.setInt (4, iCantVidas);
                cons.setInt (5, iNumCotizacion);
                cons.setString (6, oUser.getusuario());

                cons.execute();
                iRetorno = cons.getInt(1);
                cons.close();

            } catch (SQLException se){
                bError = true;
                request.setAttribute("mensaje",  se.getMessage());
                request.setAttribute("volver", "-1");
                doForward (request, response, "/include/MsjHtmlServidor.jsp");
            }

            if (!bError) {
                if (iRetorno < 0) {
                    String sError = ConsultaMaestros.getdescError(dbCon, iRetorno, "RENOVACIONES");
                    request.setAttribute ("mensaje", sError);
                    doForward(request, response,
                            "/renovacion/formMailRenueva.jsp?num_poliza=" + iNumPoliza + "&cod_rama=" + iCodRama + "&error=" + iRetorno + "&origen=" + request.getParameter("opcion"));
                } else {
                    if ( iCodRama == 10 ) {

// este parametro habilita o no el cotizador
                        Parametro oParam = new Parametro ();
                        oParam.setsCodigo( oUser.getiCodTipoUsuario() == 1 ? "HABILITA_REN_COTIZADOR_PROD" : "HABILITA_REN_COTIZADOR_INTERNO");
                        oParam.getDBValor(dbCon);

                        if (oParam.getiNumError() == 0 && oParam.getsValor() != null && oParam.getsValor().equals("S") )  {
                            Cotizacion oCot = new Cotizacion ();
                            oCot.setnumCotizacion(iRetorno);
                            oCot.getDB(dbCon);

                            if (oCot.getiNumError() < 0 ) {
                                throw new SurException (oCot.getsMensError());
                            } else {
                                if ( ( oCot.getcalculoProporcional () == null || oCot.getcalculoProporcional().equals("N")) &&
                                     ( oCot.getcodSubRama() == 1 || oCot.getcodSubRama() == 2) &&
                                     ( oCot.getcodProducto() == 1 || oCot.getcodProducto() == 2 || oCot.getcodProducto() == 3 )) {

                                    request.setAttribute ("cotizacion", oCot);
                                    doForward (request, response, "/cotizador/ap/cotizaAP_deta_sol2.jsp?volver=renovaciones");

                                } else {
                                    this.getAllPolizas(dbCon, request, response);
                                }
                            }
                        } else {
                            this.getAllPolizas(dbCon, request, response);
                        }
                    } else {
                        this.getAllPolizas(dbCon, request, response);
                    }
                }
            }
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null ) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }

    protected void Renovar (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons  = null;
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            int iCodRama        = (Integer.parseInt (request.getParameter ("F1cod_rama_sel")));
            int iNumPoliza      = (Integer.parseInt (request.getParameter ("F1num_poliza_sel")));
            int iCantVidas      = (Integer.parseInt (request.getParameter ("cant_vidas")));
            int iNumCotizacion  = (Integer.parseInt (request.getParameter ("num_cotizacion")));
            int iNumPropuesta   = 0;
            boolean bError      = false;
            dbCon = db.getConnection();

            try {
                dbCon.setAutoCommit(true);
                cons = dbCon.prepareCall(db.getSettingCall("REN_SET_RENOVACION  (?,?,?,?,?,?)"));
                cons.registerOutParameter(1, java.sql.Types.INTEGER);
                cons.setInt (2, iCodRama);
                cons.setInt (3, iNumPoliza);
                cons.setInt (4, iCantVidas);
                cons.setInt (5, iNumCotizacion);
                cons.setString (6, "OL");
                cons.setString (7, oUser.getusuario());

                cons.execute();
                iNumPropuesta = cons.getInt(1);

                cons.close();
            } catch (SQLException se){
                bError = true;
                request.setAttribute("mensaje",  se.getMessage());
                request.setAttribute("volver", "-1");
                doForward (request, response, "/include/MsjHtmlServidor.jsp");
            }

            if (!bError) {
                if (iNumPropuesta > 0) {
                    doForward(request, response, "/servlet/PropuestaServlet?opcion=getPropuestaBenef&numPropuesta=" + iNumPropuesta);
                } else {
                    String sError = ConsultaMaestros.getdescError(dbCon, iNumPropuesta, "RENOVACIONES");
                    request.setAttribute ("mensaje", sError);
                    doForward(request, response,
                            "/renovacion/formMailRenueva.jsp?num_poliza=" + iNumPoliza + "&cod_rama=" + iCodRama + "&error=" + iNumPropuesta + "&origen=" + request.getParameter("opcion"));
                }
            }
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null ) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }

    protected int getCantMeses ( int codVigencia) {
       int vRetorno = 0;

       switch ( codVigencia ) {
           case 1 : vRetorno = 1;
           break;
           case 2: vRetorno = 2;
           break;
           case 3: vRetorno = 3;
           break;
           case 4: vRetorno = 4;
           break;
           case 5: vRetorno = 6;
           break;
           default: vRetorno = 12;
       }
        return vRetorno;
    }

    protected void getAllPolizas (Connection dbCon, HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        CallableStatement cons  = null;
        ResultSet rs = null;
        LinkedList lPolizas = new LinkedList ();
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            Diccionario oDicc   = (Diccionario) (request.getSession().getAttribute("Diccionario"));

            int iCodProd        = oDicc.getInt (request, "F1cod_prod");
            String sNombre      = oDicc.getString (request, "F1nombre");
            int iGrupo          = oDicc.getInt  (request, "F1grupo");
            int iNumPoliza      = oDicc.getInt (request, "F1num_poliza");
            int iCodRama        = oDicc.getInt (request, "F1cod_rama");
            Date dFechaDesde    = oDicc.getDate (request, "F1fecha_desde");
            Date dFechaHasta    = oDicc.getDate (request, "F1fecha_hasta");
            String sRenovadas   = oDicc.getString (request, "F1renovadas", "N");
            int iCurrentPage    = oDicc.getInt (request, "pager.offset");

            if (dbCon == null) {
                dbCon = db.getConnection();
            }
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("REN_GET_ALL_POLIZAS (?,?,?,?,?,?,?,?, ?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            if ( iCodProd  == 0 ) {
                cons.setNull    (2, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (2, iCodProd );
            }
            if (sNombre.equals ("") ) {
                cons.setNull    (3, java.sql.Types.VARCHAR);
            } else {
                cons.setString  (3, sNombre);
            }
            if ( iGrupo == 0 ) {
                cons.setNull    (4, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (4, iGrupo);
            }
            if ( iNumPoliza  == 0 ) {
                cons.setNull    (5, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (5, iNumPoliza );
            }
            if ( iCodRama == 0 ) {
                cons.setNull    (6, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (6, iCodRama);
            }
            if (dFechaDesde == null ) {
                cons.setNull (7, java.sql.Types.DATE);
            } else {
                cons.setDate (7, Fecha.convertFecha(dFechaDesde));
            }
            if (dFechaHasta == null) {
                cons.setNull (8, java.sql.Types.DATE);
            } else {
                cons.setDate (8, Fecha.convertFecha(dFechaHasta));
            }
            cons.setString (9, oUser.getusuario());
            cons.setString (10, "ON_LINE");

            cons.execute();
            rs = (ResultSet) cons.getObject(1);

            if (rs != null) {
                while (rs.next()) {
                    if (sRenovadas.equals("S") || (sRenovadas.equals("N") && rs.getInt("RENOVADA_POR") == 0) ||
                                                  (sRenovadas.equals("") && rs.getInt("RENOVADA_POR") == 0)) {
                        Poliza oPol = new Poliza ();
                        oPol.setnumPoliza       (rs.getInt("NUM_POLIZA"));
                        oPol.setcodRama         (rs.getInt("COD_RAMA"));
                        oPol.setdescRama        (rs.getString ("RAMA"));
                        oPol.setrazonSocialTomador(rs.getString ("RAZON_SOCIAL"));
                        oPol.setcodSubRama      (rs.getInt("COD_SUB_RAMA"));
                        oPol.setdescSubRama     (rs.getString ("SUB_RAMA"));
                        oPol.setdescProductor   (rs.getString ("PRODUCTOR"));
                        oPol.setcodProd         (rs.getInt("COD_PROD"));
                        oPol.setfechaInicioVigencia (rs.getDate("FECHA_INI_VIG_POL"));
                        oPol.setfechaFinVigencia(rs.getDate("FECHA_FIN_VIG_POL"));
                        oPol.setcantVidas       (rs.getInt("CANT_VIDAS"));
                        oPol.setiPolizaGrupo    (rs.getInt("POLIZA_GRUPO"));
                        oPol.setrenovadaPor     (rs.getInt ("RENOVADA_POR"));
                        oPol.setnumCotizacion   (rs.getInt ("NUM_COTIZACION"));
                        oPol.setnumPropuesta    (rs.getInt ("NUM_PROPUESTA"));
                        oPol.setcodCobFinal     (rs.getInt ("MAIL_ENVIADOS"));
                        oPol.setestado(rs.getString ("ESTADO"));
                        Premio oPremio = new Premio ();
                        oPremio.setMpremio      (rs.getDouble ("IMP_PREMIO"));
                        oPremio.setimpPrima     (rs.getDouble("IMP_PRIMA"));
                        oPol.setPremio      (oPremio);
                        lPolizas.add    (oPol);
                    }
                }
                rs.close ();
            }
            cons.close();

            request.setAttribute("polizas", lPolizas);
            doForward(request, response, "/renovacion/filtrarRenovacion.jsp?pager.offset=" + iCurrentPage);
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }


    protected void getAllPolizasXLS (Connection dbCon, HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        CallableStatement cons  = null;
        ResultSet rs = null;
        LinkedList lPolizas = new LinkedList ();
        xls oXls   = new xls ();
        LinkedList lTit = new LinkedList ();
        boolean bExiste = false;

        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            Diccionario oDicc   = (Diccionario) (request.getSession().getAttribute("Diccionario"));

            int iCodProd        = oDicc.getInt (request, "F1cod_prod");
            String sNombre      = oDicc.getString (request, "F1nombre");
            int iGrupo          = oDicc.getInt  (request, "F1grupo");
            int iNumPoliza      = oDicc.getInt (request, "F1num_poliza");
            int iCodRama        = oDicc.getInt (request, "F1cod_rama");
            Date dFechaDesde    = oDicc.getDate (request, "F1fecha_desde");
            Date dFechaHasta    = oDicc.getDate (request, "F1fecha_hasta");
            String sRenovadas   = oDicc.getString (request, "F1renovadas", "N");
            int iCurrentPage    = oDicc.getInt (request, "pager.offset");

            oXls.setTitulo("Polizas a renovar");
            LinkedList lRow    = new LinkedList();
            lRow.add( "LISTADO DE POLIZAS A RENOVAR" );
            oXls.setRows(lRow);

            lRow   = new LinkedList();
            lRow.add("Parametros: ");
            oXls.setRows(lRow);

            lRow    = new LinkedList();
            lRow.add( "Productor: " + iCodProd);
            oXls.setRows(lRow);

            lRow    = new LinkedList();
            lRow.add( "Rama: " + iCodRama);
            oXls.setRows(lRow);

            lRow    = new LinkedList();
            lRow.add( "Poliza: " + iNumPoliza);
            oXls.setRows(lRow);

            lRow    = new LinkedList();
            lRow.add( "Tomador: " + sNombre);
            oXls.setRows(lRow);

            lRow    = new LinkedList();
            lRow.add( "Grupo: " + iGrupo);
            oXls.setRows(lRow);

            if (dbCon == null) {
                dbCon = db.getConnection();
            }
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("REN_GET_ALL_POLIZAS (?,?,?,?,?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            if ( iCodProd  == 0 ) {
                cons.setNull    (2, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (2, iCodProd );
            }
            if (sNombre.equals ("") ) {
                cons.setNull    (3, java.sql.Types.VARCHAR);
            } else {
                cons.setString  (3, sNombre);
            }
            if ( iGrupo == 0 ) {
                cons.setNull    (4, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (4, iGrupo);
            }
            if ( iNumPoliza  == 0 ) {
                cons.setNull    (5, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (5, iNumPoliza );
            }
            if ( iCodRama == 0 ) {
                cons.setNull    (6, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (6, iCodRama);
            }
            if (dFechaDesde == null ) {
                cons.setNull (7, java.sql.Types.DATE);
            } else {
                cons.setDate (7, Fecha.convertFecha(dFechaDesde));
            }
            if (dFechaHasta == null) {
                cons.setNull (8, java.sql.Types.DATE);
            } else {
                cons.setDate (8, Fecha.convertFecha(dFechaHasta));
            }
            cons.setString (9, oUser.getusuario());

            cons.execute();
            rs = (ResultSet) cons.getObject(1);

            if (rs != null) {
                lTit    = new LinkedList();
                lTit.add("COD_RAMA");
                lTit.add("NUM_POLIZA");
                lTit.add("CANT_VIDAS");
                lTit.add("NUM_COTIZACION");
                lTit.add("RAZON_SOCIAL");
                lTit.add("COD_SUB_RAMA");
                lTit.add("SUB_RAMA");
                lTit.add("PRODUCTOR");
                lTit.add("COD_PROD");
                lTit.add("FECHA_INI_VIG_POL");
                lTit.add("FECHA_FIN_VIG_POL");
                lTit.add("POLIZA_GRUPO");
                lTit.add("RENOVADA_POR");
                lTit.add("ESTADO");

                oXls.setRows(lTit);
                while (rs.next()) {
                    if (sRenovadas.equals("S") || (sRenovadas.equals("N") && rs.getInt("RENOVADA_POR") == 0) ||
                                                  (sRenovadas.equals("") && rs.getInt("RENOVADA_POR") == 0)) {
                        bExiste = true;
                        LinkedList lCol = new LinkedList();
                        lCol.add (rs.getString("COD_RAMA"));
                        lCol.add (rs.getString("NUM_POLIZA"));
                        lCol.add (rs.getString("CANT_VIDAS"));
                        lCol.add (rs.getString ("NUM_COTIZACION"));
                        lCol.add (rs.getString ("RAZON_SOCIAL"));
                        lCol.add (rs.getString("COD_SUB_RAMA"));
                        lCol.add (rs.getString ("SUB_RAMA"));
                        lCol.add (rs.getString ("PRODUCTOR"));
                        lCol.add (rs.getString("COD_PROD"));
                        lCol.add ( Fecha.showFechaForm (rs.getDate("FECHA_INI_VIG_POL")));
                        lCol.add ( Fecha.showFechaForm (rs.getDate("FECHA_FIN_VIG_POL")));
                        lCol.add (rs.getString("POLIZA_GRUPO"));
                        lCol.add (rs.getString ("RENOVADA_POR"));
                        lCol.add (rs.getString ("ESTADO"));
                        oXls.setRows(lCol);
                    }
                }
                rs.close ();
            }
            cons.close();

            if ( bExiste) {
                request.setAttribute("oReportXls", oXls);
                doForward( request, response, "/servlet/ReportXls");
            } else {
                this.getAllPolizas(dbCon, request, response);
            }
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }

    protected void getAllPolizasCSV (Connection dbCon, HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        CallableStatement cons  = null;
        ResultSet rs = null;
        String  _fileName    = "";
        boolean bExiste = false;
        StringBuilder sTitulo = new StringBuilder();
        double iPremioOrig  = 0;
        double iPrimaOrig   = 0;
        LinkedList lDatos   = null;

        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            Diccionario oDicc   = (Diccionario) (request.getSession().getAttribute("Diccionario"));

            _fileName           = "/renovar.csv";

            int iCodProd        = oDicc.getInt (request, "F1cod_prod");
            String sNombre      = oDicc.getString (request, "F1nombre");
            int iGrupo          = oDicc.getInt  (request, "F1grupo");
            int iNumPoliza      = oDicc.getInt (request, "F1num_poliza");
            int iCodRama        = oDicc.getInt (request, "F1cod_rama");
            Date dFechaDesde    = oDicc.getDate (request, "F1fecha_desde");
            Date dFechaHasta    = oDicc.getDate (request, "F1fecha_hasta");
            String sRenovadas   = oDicc.getString (request, "F1renovadas", "N");
            int iCurrentPage    = oDicc.getInt (request, "pager.offset");

            if (dbCon == null) {
                dbCon = db.getConnection();
            }
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("REN_GET_ALL_POLIZAS (?,?,?,?,?,?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            if ( iCodProd  == 0 ) {
                cons.setNull    (2, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (2, iCodProd );
            }
            if (sNombre.equals ("") ) {
                cons.setNull    (3, java.sql.Types.VARCHAR);
            } else {
                cons.setString  (3, sNombre);
            }
            if ( iGrupo == 0 ) {
                cons.setNull    (4, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (4, iGrupo);
            }
            if ( iNumPoliza  == 0 ) {
                cons.setNull    (5, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (5, iNumPoliza );
            }
            if ( iCodRama == 0 ) {
                cons.setNull    (6, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (6, iCodRama);
            }
            if (dFechaDesde == null ) {
                cons.setNull (7, java.sql.Types.DATE);
            } else {
                cons.setDate (7, Fecha.convertFecha(dFechaDesde));
            }
            if (dFechaHasta == null) {
                cons.setNull (8, java.sql.Types.DATE);
            } else {
                cons.setDate (8, Fecha.convertFecha(dFechaHasta));
            }
            cons.setString (9, oUser.getusuario());
            cons.setString (10, "CSV");

            cons.execute();
            rs = (ResultSet) cons.getObject(1);

            if (rs != null) {
                lDatos = new LinkedList ();

                sTitulo.append("COD_RAMA;NUM_POLIZA;CANT_VIDAS_ACTUAL;RAZON_SOCIAL;COD_SUB_RAMA;COD_PRODUCTO;PRODUCTOR;");
                sTitulo.append("COD_PROD;NUM_TOMADOR;FECHA_INI_VIG_POL;FECHA_FIN_VIG_POL;PROPUESTA_ORIG;IMP_PREMIO_ORIG;");
                sTitulo.append("IMP_PRIMA_ORIG;FACTURACION;VIGENCIA;CANT_CUOTAS_ORIG;CANT_VIDAS_ORIG;ESTADO\n");

                lDatos.add(sTitulo.toString());

                while (rs.next()) {
                    if (sRenovadas.equals("S") || (sRenovadas.equals("N") && rs.getInt("RENOVADA_POR") == 0) ||
                                                  (sRenovadas.equals("") && rs.getInt("RENOVADA_POR") == 0)) {
                        bExiste = true;
                        iPrimaOrig = 0;
                        iPremioOrig = 0;
                        StringBuilder sLinea = new StringBuilder();

                        sLinea.append(rs.getString("COD_RAMA")).append(";");
                        sLinea.append(rs.getString("NUM_POLIZA")).append(";");
                        sLinea.append(rs.getInt("CANT_VIDAS")).append(";");
                        sLinea.append(rs.getString("RAZON_SOCIAL")).append(";");
                        sLinea.append(rs.getString("COD_SUB_RAMA")).append(";");
                        sLinea.append(rs.getString("COD_PRODUCTO")).append(";");
                        sLinea.append(rs.getString("PRODUCTOR")).append(";");
                        sLinea.append(rs.getString("COD_PROD")).append(";");
                        sLinea.append(rs.getString("NUM_TOMADOR")).append(";");
                        sLinea.append(Fecha.showFechaForm (rs.getDate("FECHA_INI_VIG_POL"))).append(";");
                        sLinea.append(Fecha.showFechaForm (rs.getDate("FECHA_FIN_VIG_POL"))).append(";");
                        sLinea.append(rs.getInt("PROPUESTA_ORIG")).append(";");

                        iPrimaOrig = ( rs.getDouble("IMP_PRIMA_ORIG") / getCantMeses ( rs.getInt ("PERIODO_FACT"))) *
                                      getCantMeses ( rs.getInt ("COD_VIGENCIA"));
                        iPremioOrig = ( rs.getDouble("IMP_PREMIO_ORIG") / getCantMeses ( rs.getInt ("PERIODO_FACT"))) *
                                      getCantMeses ( rs.getInt ("COD_VIGENCIA"));

                        sLinea.append(Dbl.DbltoStr(iPremioOrig, 2)).append(";");
                        sLinea.append(Dbl.DbltoStr(iPrimaOrig, 2)).append(";");
                        sLinea.append(rs.getString("DESC_FACTURACION")).append(";");
                        sLinea.append(rs.getString("DESC_VIGENCIA")).append(";");
                        sLinea.append(rs.getInt("CANT_CUOTAS_ORIG")).append(";");
                        sLinea.append(rs.getInt("CANT_VIDAS_ORIG")).append(";");
                        sLinea.append(rs.getString("ESTADO")).append ("\n");

                        lDatos.add(sLinea.toString());
                    }
                }
                rs.close ();
            }
            cons.close();

            if ( bExiste ) {
                response.setContentType("text/csv");
                response.setHeader("Content-Disposition", "attachment; filename=\"" + _fileName.replaceFirst("/", "") + "\"");
                  try
                    {
                        OutputStream outputStream = response.getOutputStream();
                        for (int i=0; i< lDatos.size();i++) {
                            String linea = (String) lDatos.get(i);
                            outputStream.write( linea.getBytes());
                        }
                        outputStream.flush();
                        outputStream.close();
                    }
                    catch(Exception e)
                    {
                        System.out.println(e.toString());
                    }
            } else {
                this.getAllPolizas(dbCon, request, response);
            }
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }

    protected void getPropuesta (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons  = null;
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            int iNumPropuesta   = (Integer.parseInt (request.getParameter ("numPropuesta")));
            dbCon = db.getConnection();
            Propuesta oProp = new Propuesta();
            oProp.setNumPropuesta(iNumPropuesta);
            oProp.getDB(dbCon);

            if (oProp.getCodError() < 0 ) {
                throw new SurException(oProp.getDescError());
            }
        String sDestino = "";
        if ( oProp.getCodEstado() == 0 || oProp.getCodEstado() == 4 ) {
            sDestino = "/servlet/PropuestaServlet?opcion=getPropuestaBenef";
        } else  {
            sDestino = "/propuesta/printPropuesta.jsp?opcion=printPropuesta";
        }

        doForward(request, response, sDestino);

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null ) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }

    protected void enviarMail (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons  = null;
        StringBuilder  sMensaje = new StringBuilder ();
        try {
            Usuario oUser   = (Usuario) (request.getSession().getAttribute("user"));
            String sNumPoliza= request.getParameter ("num_poliza");
            String sCodRama =  request.getParameter ("cod_rama");
            String sEmail   = request.getParameter ("email");
            String sDesc    = request.getParameter ("DESCRIPCION");
            String sDescError = request.getParameter ("error");
            String sOrigen  = (request.getParameter("origen").equals("renovar") ? "RENOVACION" : "COTIZACION");


            sMensaje.append("AVISO DE SOLICITUD DE ").append(sOrigen).append(" - POLIZA Nº ").append(sCodRama).append("/").append(sNumPoliza).append("\n");
            sMensaje.append("---------------------------------------\n\n");
            sMensaje.append("El mail se envia debido a que la misma no pudo renovarse via web.\n");
            sMensaje.append("ENVIADA POR  : " ).append(oUser.getApellido()).append(" ").append(oUser.getNom()).append("\n");
            sMensaje.append("MOTIVO DEL ERROR: ").append(sDescError).append("\n");
            sMensaje.append("Observaciones del productor:\n");
            sMensaje.append(sDesc);
            sMensaje.append("Mail de contacto: ").append(sEmail).append("\n\n");

            dbCon = db.getConnection();

            Email oEmail = new Email ();

            oEmail.setSubject("SOLICITUD DE " + sOrigen + " - POLIZA Nº " + sCodRama + "/" + sNumPoliza);

            oEmail.setContent(sMensaje.toString());

            LinkedList lDest = oEmail.getDBDestinos(dbCon, oUser.getoficina(), "RENOVACION");

            for (int i=0; i < lDest.size();i++) {
                Persona oPers = (Persona) lDest.get(i);
                oEmail.setDestination(oPers.getEmail());
                    // oEmail.sendMessage();
                oEmail.sendMessageBatch();
            }


           dbCon.setAutoCommit(true);

           cons = dbCon.prepareCall(db.getSettingCall( "REN_SET_MAIL_RENUEVA(?,?,?,?,? )"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.setInt   (2, Integer.parseInt (sCodRama) );
           cons.setInt   (3, Integer.parseInt (sNumPoliza));
           cons.setString(4, sEmail);
           cons.setString(5, sDesc);
           cons.setString(6, oUser.getusuario());

           cons.execute();

            request.setAttribute("mensaje", "La solicitud de " + sOrigen + " ha sido enviada con exito !!!");
            request.setAttribute("volver",  Param.getAplicacion()+"servlet/RenuevaServlet?opcion=getAllPol");
            doForward (request, response, "/include/MsjHtmlServidor.jsp");
    
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null ) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }

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
