/*
 * ConsultaServlet.java
 *
 * Created on 12 de noviembre de 2005, 10:02
 */
  
package servlets;
     
import java.io.*;
import java.util.LinkedList;
import java.text.SimpleDateFormat;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.sql.ResultSetMetaData;
import com.business.beans.*;
import com.business.util.*;
import com.business.db.*;
//import com.ibm.as400.access.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.Date;

/**
 *
 * @author Rolando Elisii
 * @version
 */
public class ConsultaServlet extends HttpServlet {

String sFile    = "/opt/tomcat/webapps/benef/files/dc/";

    
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
            
            if (op.equals("getNomina")) {
                getNomina (request, response);
            } else  if (op.equals ("getPol")) {
//                getPrintEndoso (request, response);
                getPoliza (request, response);
            } else  if (op.equals ("getAllPol")) {
                getAllPolizas (request, response);
            } else  if (op.equals ("getAllPolXLS") || op.equals ("getAllEndXLS")) {
                getAllPolizasXLS (request, response);
            } else if (op.equals ("getAllEnd") || op.equals ("getAllCob") || op.equals ("getAllPremio")) {
                getAllEndosos (request, response);
            } else if (op.equals ("getCopia") || op.equals ("getCopiaPoliza")) {
                getCopiaPoliza (request, response);
            } else if (op.equals ("getPreLiq")) {
                getPreLiquidacion (request, response);
            } else if (op.equals ("getCtaCte")) {
                getCtaCteProd (request, response);
            } else if (op.equals ("getAllSegui")) {
                getAllSeguimiento (request, response);
            } else if (op.equals ("getCopiaLiq")) {
                getCopiaLiquidacion (request, response);
            } else if (op.equals ("getRenoPend")) {
                getRenovacionesPend (request, response);
            } else if (op.equals ("getComisiones")) {
                getComisiones (request, response);
            } else if (op.equals ("getCupon") || op.equals ("getCuponPoliza")) {
                getCuponActualizado (request, response);            
            } else if (op.equals ("getAseguradosAfip")) {
                getAseguradosAfip (request, response);
            } else if (op.equals ("getLibroEmision")) {
                getLibroEmision (request, response);
            }  else if (op.equals ("DelNoGestionar")) {
                delNoGestionar  (request, response);
            }  else if (op.equals ("AddNoGestionar")) {
                addNoGestionar  (request, response);
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

    protected void getNomina (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        
        Connection dbCon = null;
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            int codRama         = Integer.parseInt (request.getParameter ("cod_rama"));
            int numPoliza       = Integer.parseInt (request.getParameter ("num_poliza"));            
            String sFormato     = request.getParameter ("formato");
            
// setear el control de acceso
            dbCon = db.getConnection();
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, 4);
            db.cerrar(dbCon);
            
            Poliza oPol = new Poliza ();
            oPol.setcodRama     (codRama);
            oPol.setnumPoliza   (numPoliza);
            oPol.setuserId      (oUser.getusuario());
            
            if (sFormato.equals("PDF")) {
                this.getPrintNominaAcrobat (request, response, oPol);
            } else if (sFormato.equals("HTML")) {
                this.getPrintNominaHTML(request, response, oPol);
            } else {
                this.getPrintNominaXLS (request, response, oPol);
            }
                
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }


    
    /* SUP  06-05-2011 getAseguradosAfip >>>>>>>>> */
    protected void getAseguradosAfip (HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException, SurException {
        Connection dbCon = null;        
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            Diccionario oDicc   = (Diccionario) (request.getSession().getAttribute("Diccionario"));

            int iCodRama        = oDicc.getInt (request, "cod_rama");
            int iNumPoliza      = oDicc.getInt (request, "num_poliza");
            int iEndoso        = oDicc.getInt (request, "endoso");

            Poliza oPol = new Poliza ();
            oPol.setcodRama     (iCodRama);
            oPol.setnumPoliza   (iNumPoliza );
            oPol.setuserId      (oUser.getusuario());
            
            dbCon = db.getConnection();
            oPol.getDBEnd(dbCon);

            if (oPol.getiNumError() != 0) {
                throw new SurException (oPol.getsMensError());
            }

            request.setAttribute("poliza", oPol);
            request.setAttribute("asegurados", getAllNominaBenef ( dbCon , iCodRama, iNumPoliza, iEndoso ));
            request.setAttribute("aseguradosAfip", getAllAseguradosAfip ( dbCon , iCodRama, iNumPoliza, iEndoso ));
            doForward (request, response, "/consulta/report/nominaAfipHTML.jsp");

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }
    
    private LinkedList getAllAseguradosAfip ( Connection dbCon , int pCodRama, int pNumPoliza, int pEndoso ) throws SurException {
        LinkedList lAsegAfip = new LinkedList();
        ResultSet rs = null;
        CallableStatement cons = null;
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PZ_GET_ALL_ASEGURADO_AFIP(?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt     (2, pCodRama );
            cons.setInt     (3, pNumPoliza );
            cons.setInt     (4, pEndoso  );
            cons.execute();
            rs = (ResultSet) cons.getObject(1);

            if (rs != null) {
                while (rs.next()) {
                    Asegurado oAseguradoAfip = new Asegurado ();
                    oAseguradoAfip.setcodRama(rs.getInt("COD_RAMA"));
                    oAseguradoAfip.setnombre(rs.getString ("NOMBRE"));
                    oAseguradoAfip.setnumDoc(rs.getString ("CUIL"));
                    oAseguradoAfip.setmcaAfip(rs.getString ("MCA_AFIP"));
                    oAseguradoAfip.setexisteAfip(rs.getInt("EXISTE"));
                    lAsegAfip.add(oAseguradoAfip);
                }
                rs.close ();
            }
            cons.close();
            return lAsegAfip;
        }  catch (SQLException se) {
		    throw new SurException("Error ConsultaServlet [getAllAseguradosAfip]" + se.getMessage());
        } catch (Exception e) {
		    throw new SurException("Error ConsultaServlet [getAllAseguradosAfip]" + e.getMessage());
        } finally {
            try{
                if (rs != null ) rs.close ();
                if (cons != null) cons.close ();
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }

    private LinkedList getAllNominaBenef ( Connection dbCon , int pCodRama, int pNumPoliza, int pEndoso ) throws SurException {
        LinkedList lNominaBenef = new LinkedList();
        ResultSet rs = null;
        CallableStatement cons = null;
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("PZ_GET_ALL_NOMINA_BENEF(?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt     (2, pCodRama );
            cons.setInt     (3, pNumPoliza );
            cons.setInt     (4, pEndoso  );
            cons.execute();
            rs = (ResultSet) cons.getObject(1);

            if (rs != null) {
                while (rs.next()) {
                    Asegurado oNominaBenef = new Asegurado ();
                    oNominaBenef.setcodRama(rs.getInt("COD_RAMA"));
                    oNominaBenef.setnombre(rs.getString ("NOMBRE"));
                    oNominaBenef.setnumDoc(rs.getString ("NUM_DOC"));
                    oNominaBenef.setfechaAltaCob(rs.getDate("FECHA_ALTA_COB"));
                    oNominaBenef.setexisteAfip(rs.getInt("EXISTE"));
                    lNominaBenef.add(oNominaBenef);
                }
                rs.close ();
            }
            cons.close();
            return lNominaBenef;
        }  catch (SQLException se) {
		    throw new SurException("Error ConsultaServlet [getAllNominaBenef]" + se.getMessage());
        } catch (Exception e) {
		    throw new SurException("Error ConsultaServlet [getAllNominaBenef]" + e.getMessage());
        } finally {
            try{
                if (rs != null ) rs.close ();
                if (cons != null) cons.close ();
            } catch (SQLException see) {
                throw new SurException (see.getMessage());
            }
        }
    }
    /* SUP  06-05-2011 getAseguradosAfip <<<<<<<<< */

    protected void getAllPolizas (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        
        Connection dbCon = null;
        CallableStatement cons  = null;
        ResultSet rs = null;
        LinkedList lPolizas = new LinkedList ();
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            Diccionario oDicc   = (Diccionario) (request.getSession().getAttribute("Diccionario"));            
           
            int iCodProd        = oDicc.getInt (request, "F1cod_prod");
            int iNumTomador     = oDicc.getInt (request, "F1num_tomador");
            String sNombre      = oDicc.getString (request, "F1nombre");
            int iGrupo          = oDicc.getInt  (request, "F1grupo");
            int iNumPoliza      = oDicc.getInt (request, "F1num_poliza");
            int iNumPropuesta   = oDicc.getInt (request, "F1num_propuesta");
            int iCodRama        = oDicc.getInt (request, "F1cod_rama");
            Date dFechaDesde    = oDicc.getDate (request, "F1fecha_desde");
            Date dFechaHasta    = oDicc.getDate (request, "F1fecha_hasta");
            String sEstado      = oDicc.getString (request, "F1estado");


// setear el control de acceso
            dbCon = db.getConnection();
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, 5);

            dbCon.setAutoCommit(false);
            // Procedure call.
            cons = dbCon.prepareCall(db.getSettingCall("PZ_GET_ALL_POLIZAS (?,?,?,?,?,?,?, ?,?, ?, ?, ?)"));
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
            if (iNumTomador  == 0 ) {
                cons.setNull    (4, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (4, iNumTomador);
            }
            if ( iGrupo == 0 ) {
                cons.setNull    (5, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (5, iGrupo);
            }

            if ( iNumPoliza  == 0 ) {
                cons.setNull    (6, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (6, iNumPoliza );
            }

            if ( iNumPropuesta  == 0 ) {
                cons.setNull    (7, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (7, iNumPropuesta);
            }
            
            if ( iCodRama == 0 ) {
                cons.setNull    (8, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (8, iCodRama);
            }
            
            cons.setString (9, oUser.getusuario());

            cons.setString (10, "WEB");

            if (dFechaDesde == null ) {
                cons.setNull (11, java.sql.Types.DATE);
            } else {
                cons.setDate (11, Fecha.convertFecha(dFechaDesde));
            }
            if (dFechaHasta == null) {
                cons.setNull (12, java.sql.Types.DATE);
            } else {
                cons.setDate (12, Fecha.convertFecha(dFechaHasta));
            }

            cons.setString (13, sEstado); //TODOS, NO_VIGENTE, VIGENTE

            cons.execute();
            rs = (ResultSet) cons.getObject(1);

            if (rs != null) {
                while (rs.next()) {
                    Poliza oPol = new Poliza ();
                    oPol.setnumPoliza       (rs.getInt("NUM_POLIZA"));
                    oPol.setcodRama         (rs.getInt("COD_RAMA"));
                    oPol.setdescRama        (rs.getString ("RAMA"));
                    oPol.setnumEndoso       (rs.getInt ("ENDOSO"));
                    oPol.setrazonSocialTomador(rs.getString ("RAZON_SOCIAL"));
                    oPol.setcodSubRama      (rs.getInt("COD_SUB_RAMA"));
                    oPol.setdescSubRama     (rs.getString ("SUB_RAMA"));
                    oPol.setdescProductor   (rs.getString ("PRODUCTOR"));
                    oPol.setcodProd         (rs.getInt("COD_PROD"));
                    oPol.setnumTomador      (rs.getInt("NUM_TOMADOR"));
                    oPol.setfechaEmision    (rs.getDate("FECHA_EMISION_POL"));
                    oPol.setfechaInicioVigencia (rs.getDate("FECHA_INI_VIG_POL"));
                    oPol.setfechaFinVigencia(rs.getDate("FECHA_FIN_VIG_POL"));
                    oPol.setestado          (rs.getString ("COD_ESTADO"));
                    oPol.setCuic            (rs.getString ("CUIC"));
                    oPol.setiPolizaGrupo    (rs.getInt("POLIZA_GRUPO"));
                    oPol.setimpSaldoPoliza  (rs.getDouble ("SALDO_POLIZA"));
                    
                    lPolizas.add(oPol);
                }
                rs.close ();
            }
            cons.close();

            request.setAttribute("polizas", lPolizas);
            doForward(request, response, "/consulta/filtrarPolizas.jsp");
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

    protected void getAllPolizasXLS (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        Connection dbCon = null;
        CallableStatement cons  = null;
        ResultSet rs = null;
        LinkedList lPolizas = new LinkedList ();
        LinkedList lTit = new LinkedList ();
        xls oXls   = new xls ();
        boolean bExiste = false;

        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            Diccionario oDicc   = (Diccionario) (request.getSession().getAttribute("Diccionario"));

            int iCodProd        = oDicc.getInt (request, "F1cod_prod");
            int iNumTomador     = oDicc.getInt (request, "F1num_tomador");
            String sNombre      = oDicc.getString (request, "F1nombre");
            int iGrupo          = oDicc.getInt  (request, "F1grupo");
            int iNumPoliza      = oDicc.getInt (request, "F1num_poliza");
            int iNumPropuesta   = oDicc.getInt (request, "F1num_propuesta");
            int iCodRama        = oDicc.getInt (request, "F1cod_rama");
            Date dFechaDesde    = oDicc.getDate (request, "F1fecha_desde");
            Date dFechaHasta    = oDicc.getDate (request, "F1fecha_hasta");
            String sEstado      = oDicc.getString (request, "F1estado");


            oXls.setTitulo("Listado de pólizas");
            LinkedList lRow    = new LinkedList();
            lRow.add( "LISTADO DE POLIZAS" );
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
            lRow.add( "Propuesta: " + iNumPropuesta);
            oXls.setRows(lRow);

            lRow    = new LinkedList();
            lRow.add( "Grupo: " + iGrupo);
            oXls.setRows(lRow);

// setear el control de acceso
            dbCon = db.getConnection();
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, 5);

            dbCon.setAutoCommit(false);
            // Procedure call.
            cons = dbCon.prepareCall(db.getSettingCall("PZ_GET_ALL_POLIZAS_XLS (?,?, ?,?,?,?,?,?,?, ?,?,?)"));
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
            if (iNumTomador  == 0 ) {
                cons.setNull    (4, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (4, iNumTomador);
            }
            if ( iGrupo == 0 ) {
                cons.setNull    (5, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (5, iGrupo);
            }

            if ( iNumPoliza  == 0 ) {
                cons.setNull    (6, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (6, iNumPoliza );
            }

            if ( iNumPropuesta  == 0 ) {
                cons.setNull    (7, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (7, iNumPropuesta);
            }

            if ( iCodRama == 0 ) {
                cons.setNull    (8, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (8, iCodRama);
            }

            cons.setString (9, oUser.getusuario());

            cons.setString (10, (request.getParameter("opcion").equals ("getAllPolXLS") ? "XLS_POL" : "XLS_END"));

            if (dFechaDesde == null ) {
                cons.setNull (11, java.sql.Types.DATE);
            } else {
                cons.setDate (11, Fecha.convertFecha(dFechaDesde));
            }
            if (dFechaHasta == null) {
                cons.setNull (12, java.sql.Types.DATE);
            } else {
                cons.setDate (12, Fecha.convertFecha(dFechaHasta));
            }

            cons.setString   (13, sEstado );

            cons.execute();
            rs = (ResultSet) cons.getObject(1);

            if (rs != null) {
                ResultSetMetaData rsMetaData = rs.getMetaData();
                int numberOfColumns = rsMetaData.getColumnCount();

                for (int i = 1; i <= numberOfColumns; i++) {
                    lTit.add(rsMetaData.getColumnName(i));
                }
                oXls.setRows(lTit);

                while (rs.next()) {
                    bExiste = true;
                    LinkedList lCol = new LinkedList();
                    lCol.add (rs.getString ("COD_PROD"));
                    lCol.add (rs.getString ("PRODUCTOR"));
                    lCol.add (rs.getString ("COD_RAMA"));
                    lCol.add (rs.getString ("RAMA"));
                    lCol.add (rs.getString ("COD_SUB_RAMA"));
                    lCol.add (rs.getString ("SUB_RAMA"));
                    lCol.add (rs.getString ("NUM_POLIZA"));
                    lCol.add (rs.getString ("ENDOSO"));
                    lCol.add (rs.getString ("PERIODO_FACT"));     
                    lCol.add ( rs.getDate("FEC_EMISION") == null ? " " : Fecha.showFechaForm (rs.getDate("FEC_EMISION")));
                    lCol.add ( rs.getDate("FEC_INICIO_POL") == null ? " " : Fecha.showFechaForm (rs.getDate("FEC_INICIO_POL")));
                    lCol.add ( rs.getDate("FEC_FINAL_POL") == null ? " " : Fecha.showFechaForm (rs.getDate("FEC_FINAL_POL")));
                    lCol.add ( rs.getDate("FEC_INICIO_END") == null ? " " : Fecha.showFechaForm (rs.getDate("FEC_INICIO_END")));
                    lCol.add ( rs.getDate("FEC_FINAL_END") == null ? " " : Fecha.showFechaForm (rs.getDate("FEC_FINAL_END")));
                    lCol.add (rs.getString ("NUM_TOMADOR"));
                    lCol.add (rs.getString ("RAZON_SOCIAL"));
                    lCol.add ( rs.getString ("CANT_VIDAS"));
                    lCol.add ( rs.getString ("ESTADO"));
                    lCol.add ( rs.getDouble ("IMP_PREMIO"));
                    lCol.add ( rs.getDouble ("IMP_PRIMA"));
                    lCol.add ( rs.getDouble ("SALDO_ENDOSO"));
                    lCol.add ( rs.getDouble ("DEUDA_ENDOSO"));
                    lCol.add ( rs.getDouble("SUMA_ASEGURADA"));
                    lCol.add ( rs.getDate("FEC_ULT_PAGO") == null ? " " : Fecha.showFechaForm (rs.getDate("FEC_ULT_PAGO")));
                    lCol.add ( rs.getString ("CUIC"));
                    lCol.add (rs.getString    ("POLIZA_ANTERIOR"));
                    lCol.add (rs.getString    ("RENOVADA_POR"));
                    lCol.add (rs.getString ("TIPO_ENDOSO"));
                    lCol.add (rs.getString ("POLIZA_GRUPO"));
                    lCol.add (rs.getString ("DESC_GRUPO"));
                    lCol.add (rs.getString ("NUM_REFERENCIA"));

                    oXls.setRows(lCol);
                }
                rs.close ();
            }
            cons.close();

            if ( bExiste) {
                request.setAttribute("oReportXls", oXls);
                doForward( request, response, "/servlet/ReportXls");
            } else {

                request.setAttribute("polizas", lPolizas);
                doForward(request, response, "/consulta/filtrarPolizas.jsp");
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

    protected void getPoliza (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        
        Connection dbCon = null;
        Poliza oPol = new Poliza ();
        PersonaPoliza oPers = new PersonaPoliza ();
        UbicacionRiesgo oUbic = new UbicacionRiesgo ();
        LinkedList lTextos = new LinkedList ();
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            
// setear el control de acceso            
            dbCon = db.getConnection();
//            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
//            oControl.setearAcceso(dbCon, 6);
            
            oPol.setcodRama   (Integer.parseInt (request.getParameter ("F1cod_rama_sel")));
            oPol.setnumPoliza (Integer.parseInt (request.getParameter ("F1num_poliza_sel")));

            oPol.getDB(dbCon);
            
            if (oPol.getiNumError() != 0) {
                throw new SurException (oPol.getsMensError());
            }
            
            LinkedList lCuotas = oPol.getDBCuotasEnd(dbCon);
            
            if (oPol.getiNumError() != 0) {
                throw new SurException (oPol.getsMensError());
            }
            
            oPol.setCuotas(lCuotas);
            
            lTextos = oPol.getDBTextosVariable(dbCon);

            if (oPol.getiNumError() != 0) {
                throw new SurException (oPol.getsMensError());
            }
            
            oPers.setnumTomador(oPol.getnumTomador());
            oPers.getDB(dbCon);
            
            if (oPers.getiNumError() != 0) {
                throw new SurException (oPers.getsMensError());
            }

            oUbic.setcodRama   (oPol.getcodRama());
            oUbic.setnumPoliza (oPol.getnumPoliza());
            oUbic.setendoso    (oPol.getnumEndoso ());

            oUbic.getDB(dbCon);
            
            if (oUbic.getiNumError() != 0) {
                throw new SurException (oUbic.getsMensError());
            }

            if (oUser.getiCodTipoUsuario() == 0) {
    // agregado 20/5/2015 para no gestionar
                NoGestionar oNoGes = new NoGestionar ();
                oNoGes.setcodRama(oPol.getcodRama());
                oNoGes.setnumPoliza(oPol.getnumPoliza());
                oNoGes.setnumEndoso(oPol.getnumEndoso());
                oNoGes.setnumTomador(oPol.getnumTomador());
                oNoGes.setzona(0);
                oNoGes.setnivel(1); // busqueda a nivel de poliza

                oNoGes.getDB(dbCon);

                if (oNoGes.getiNumError() >= 0 ) {
                    oPol.setoNoGestionar(oNoGes);
                }

    // agregado 20/8/2015 para no gestionar
                NoGestionar oNoGesTom = new NoGestionar ();
                oNoGesTom.setcodRama(oPol.getcodRama());
                oNoGesTom.setnumPoliza(oPol.getnumPoliza());
                oNoGesTom.setnumEndoso(oPol.getnumEndoso());
                oNoGesTom.setnumTomador(oPol.getnumTomador());
                oNoGesTom.setzona(0);
                oNoGesTom.setnivel(4); // busqueda a nivel de tomador

                oNoGesTom.getDB(dbCon);

                if (oNoGesTom.getiNumError() >= 0 ) {
                    oPers.setnoGestionar(oNoGesTom);
                }
            }
            
            request.setAttribute("poliza", oPol);
            request.setAttribute("tomador", oPers);
            request.setAttribute("ubicacion", oUbic);            
            request.setAttribute("textos", lTextos);            
            doForward(request, response, "/consulta/consultaPoliza.jsp");

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void addNoGestionar  (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        Connection dbCon = null;
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));

// setear el control de acceso
            dbCon = db.getConnection();

            NoGestionar oNoGes = new NoGestionar ();
            oNoGes.setcodRama   (Integer.parseInt (request.getParameter ("F1cod_rama_sel")));
            oNoGes.setnumPoliza (Integer.parseInt (request.getParameter ("F1num_poliza_sel")));
            oNoGes.setnivel     (Integer.parseInt (request.getParameter ("nivel_exclusion")));
            oNoGes.setuserId    (oUser.getusuario());
            oNoGes.setzona(0);
            if (oNoGes.getnivel() == 1 || oNoGes.getnivel() == 2 ) {
                if (request.getParameter("fecha_hasta") == null || request.getParameter("fecha_hasta").equals ("") ) {
                    oNoGes.setfechaHasta(null);
                } else {
                    oNoGes.setfechaHasta(Fecha.convertFecha(Fecha.strToDate(request.getParameter("fecha_hasta"))));
                }
                oNoGes.setmotivo(request.getParameter ("motivo") == null ? "" : request.getParameter ("motivo"));
            } else if (oNoGes.getnivel() == 4) {
                if (request.getParameter("fecha_hasta_4") == null || request.getParameter("fecha_hasta_4").equals ("") ) {
                    oNoGes.setfechaHasta(null);
                } else {
                    oNoGes.setfechaHasta(Fecha.convertFecha(Fecha.strToDate(request.getParameter("fecha_hasta_4"))));
                }
                oNoGes.setmotivo(request.getParameter ("motivo_4") == null ? "" : request.getParameter ("motivo_4"));
            }

            if (oNoGes.getnivel() == 2 ) {
                oNoGes.setnumEndoso (Integer.parseInt (request.getParameter ("endoso")));
            } else if (oNoGes.getnivel() == 4 ) {
                oNoGes.setnumTomador (Integer.parseInt (request.getParameter ("num_tomador")));
            }

            oNoGes.setDB(dbCon);

            if (oNoGes.getiNumError() != 0) {
                throw new SurException (oNoGes.getsMensError());
            }

            if (request.getParameter("solapa").equals ("poliza")) {
                doForward(request, response, "/servlet/ConsultaServlet?opcion=getPol");
            } else if (request.getParameter ("solapa").equals ("endosos")) {
                doForward (request, response, "/servlet/ConsultaServlet?opcion=getAllEnd");
            } else doForward ( request, response, "/servlet/ConsultaServlet?opcion=getAllPol");

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void delNoGestionar  (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        Connection dbCon = null;
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));

// setear el control de acceso
            dbCon = db.getConnection();

            NoGestionar oNoGes = new NoGestionar ();
            oNoGes.setcodRama   (Integer.parseInt (request.getParameter ("F1cod_rama_sel")));
            oNoGes.setnumPoliza (Integer.parseInt (request.getParameter ("F1num_poliza_sel")));
            oNoGes.setnivel     (Integer.parseInt (request.getParameter ("nivel_exclusion")));
            oNoGes.setuserId    (oUser.getusuario());
            oNoGes.setzona(0);

            if (oNoGes.getnivel() == 2 ) {
                oNoGes.setnumEndoso (Integer.parseInt (request.getParameter ("endoso")));
            } else if (oNoGes.getnivel() == 4) {
                oNoGes.setnumTomador(Integer.parseInt (request.getParameter ("num_tomador")));
            }
   
            oNoGes.deleteDB(dbCon);

            if (oNoGes.getiNumError() != 0) {
                throw new SurException (oNoGes.getsMensError());
            }

            if (request.getParameter("solapa").equals ("poliza")) {
                doForward(request, response, "/servlet/ConsultaServlet?opcion=getPol");
            } else if (request.getParameter ("solapa").equals ("endosos")) {
                doForward (request, response, "/servlet/ConsultaServlet?opcion=getAllEnd");
            } else doForward ( request, response, "/servlet/ConsultaServlet?opcion=getAllPol");

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

  private static int getNumSecuInfo (Connection dbCon) throws SurException {
       CallableStatement cons  = null;
       int lote  = 0;
       try {

           dbCon.setAutoCommit(true);
           cons = dbCon.prepareCall(db.getSettingCall("GET_NUM_SECU_INFO ()"));
           cons.registerOutParameter(1, java.sql.Types.INTEGER);
           cons.execute();

           lote = cons.getInt(1);

       } catch (Exception e) {
            throw new SurException (e.getMessage());

        } finally {
            try {
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            return lote;
        }
    }

    private static String getProgramaDC (Connection dbCon, String sOperacion )
            throws SurException {
       CallableStatement cons  = null;

       try {
           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall(db.getSettingCall("GET_TABLAS_DESCRIPCION (?, ?)"));
           cons.registerOutParameter(1, java.sql.Types.VARCHAR);
           cons.setString (2, "PROGRAMA_DC");
           cons.setString (3, sOperacion);
           cons.execute();

           return cons.getString (1);
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
    }

    private static void CreateFile (Connection dbCon,
                                  String sOperacion,
                                  LinkedList lParams,
                                  String sFile )
            throws SurException {

/* Operaciones posibles:
"POLIZA"
"CUPON"
"PRELIQ"
"CTACTE"
"LIQUI"
"RENOPEN"
"COMIS"
*/
        FileOutputStream fos = null;
        OutputStreamWriter osw = null;
        BufferedWriter bw = null;

        try {
           fos = new FileOutputStream ( sFile );
           osw = new OutputStreamWriter (fos, "8859_1");
           bw = new BufferedWriter (osw);

           for (int i=0; i < lParams.size();i++) {
                bw.write( (String) lParams.get(i) + "\n");
           }

            bw.flush();
            bw.close();
            osw.close();
            fos.close();
        } catch (Exception e) {
            throw new SurException ("CreateFile:" + e.getMessage());
        } finally {
            try {
                bw.close();
                osw.close();
                fos.close();
            } catch (IOException ee) {
                throw new SurException (ee.getMessage());
            }
        }
    }

    protected void getCopiaPoliza (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        
        Connection dbCon = null;
        Poliza oPol      = new Poliza ();
        String sTipoMens  = "";
        String sTipoMens2 = "";
        String sMens      = "";
        String sMensa     = new String ();
        CallableStatement cons2 = null;
        double iNumLote = 0;
        try {
            Usuario oUser = ((Usuario) request.getSession().getAttribute("user"));
// setear el control de acceso            
            dbCon = db.getConnection();
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, 10);
            String rama = "";
            String numPoliza = "";
            String endoso = "";
            
            String nomina = (request.getParameter ("nomina") == null ? "S" : request.getParameter ("nomina") );

            if (request.getParameter("opcion").equals("getCopia")) {
                rama       = request.getParameter ("F1cod_rama_sel");
                numPoliza  = Formatos.formatearCeros(request.getParameter ("F1num_poliza_sel"),7);
                endoso     = Formatos.formatearCeros(request.getParameter ("endoso") == null ? "0" : request.getParameter ("endoso"),6);
            } else {
                rama       = request.getParameter ("cod_rama");
                numPoliza  = Formatos.formatearCeros(request.getParameter ("num_poliza"),7);
                endoso     = Formatos.formatearCeros(request.getParameter ("endoso"),6);
            }
            
            oPol.setcodRama   (Integer.parseInt (rama));
            oPol.setnumPoliza (Integer.parseInt (numPoliza));
            oPol.setnumEndoso (Integer.parseInt (endoso));


            oPol.setuserId    (oUser.getUsuario());     
                  
            int estado = 0;

            Parametro oParam = new Parametro ();
            oParam.setsCodigo("ESTADO_INFO_VIA_MAIL");
            oParam.getDBValor(dbCon);

            if (oParam.getsValor() != null && oParam.getsValor().equals("N") )  {
                estado = 4;
            } else {
                if ( oPol.getnumEndoso() > 0) {
                    oPol.getDBEnd(dbCon);
                    if (oPol.getiNumError() == -1) {
                        throw new SurException(oPol.getsMensError());
                    } else if (oPol.getiNumError() == -100 ) {
                        estado = 1;
                    }
                    if ( oPol.getcodRama() == 9 ) {
                        estado = 2;
                    }
                } else {
                    oPol.getDB(dbCon);
                    if (oPol.getiNumError() == -1) {
                        throw new SurException(oPol.getsMensError());
                    }
                    if (oPol.getiNumError() == -100 ) {
                        estado = 1;
                    } else if ( oPol.getcodRama() == 9 ) {
                        estado = 2;
                        }
                        else if ( oPol.getcodRama() == 21 && (oPol.getCuic() == null || (oPol.getCuic() != null && oPol.getCuic().equals("")))){
                        estado = 3;
                        }
                }
            }
            switch (estado) {
                case 1:
                    sMensa = "La póliza no existe en la web. verifique la información ingresada o comuniquese con su representante en Beneficio. Gracias. ";
                    break;
                    
                case 2:
                    sMensa = "Rama no habilitada para emisi&oacute;n de copia de p&oacute;liza v&acute;a web.";
                    break;
                case 3:
                    sMensa = "La póliza no tiene CUIC asignado. Puede ser que aún este pendiente o no haya sido aprobada por la SSN.";
                    break;
                case 4:
                    sMensa = "Operación inhabilitada por el momento. Vuelva a intentar más tarde.   ";
                    break;
                    
                default:
                    int iFecCorte = 20101129;
                    
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
                    int iFechaEmision =  Integer.parseInt(
                                       sdf.format(
                                        (oPol.getnumEndoso() == 0 ? oPol.getfechaEmision() :
                                                                    oPol.getfechaEmisionEnd())));

                   if ( iFechaEmision <= iFecCorte ) {
                        sTipoMens = "ER";
                        sMens     = "LA COPIA DE POLIZA SE TIENE QUE ENVIAR DESDE EL AS400 ";
                    } else {
                        try {
                            dbCon.setAutoCommit(true);
                            cons2 = dbCon.prepareCall(db.getSettingCall("MAIL_SET_COPIA_POLIZA (?,?,?,?,?,?,?)"));
                            cons2.registerOutParameter(1, java.sql.Types.DOUBLE );
                            cons2.setInt (2, Integer.parseInt (rama));
                            cons2.setInt (3, Integer.parseInt (numPoliza));
                            cons2.setInt (4, Integer.parseInt (endoso));
                            cons2.setDouble (5, 0 );
                            cons2.setString (6,"CP");
                            cons2.setString (7, oUser.getusuario());
                            cons2.setString (8, request.getParameter ("email").toUpperCase() );

                            cons2.execute();

                            iNumLote = cons2.getDouble(1);

                            cons2.close ();
                       } catch (SQLException se) {
                            throw new SurException("ERROR EN MAIL_SET_COPIA_POLIZA: " + se.getMessage());
                       }

                        try {
                            String sFileSec = sFile + "poliza." + getNumSecuInfo (dbCon);
                            LinkedList lParams = new LinkedList();

                            lParams.add ("PROGRAMA=" + getProgramaDC (dbCon, "POLIZA" ));
                            lParams.add ("COMPAN=16");
                            lParams.add ("SECION=" + rama);
                            lParams.add ("POLIZA=" + numPoliza);
                            lParams.add ("OPERAC=1");
                            lParams.add ("ENDOSO=" +  endoso);
                            lParams.add ("POLCUO=" + (nomina.equals("S") ? "CP" : "CS" ));
                            lParams.add ("EMAILS=" + request.getParameter ("email").toUpperCase());

                            CreateFile(dbCon, "POLIZA", lParams, sFileSec  );

                            oParam.setsCodigo("DC_CLIENT_COMANDO");
                            String sCommand = oParam.getDBValor(dbCon);
                            
                            oParam.setsCodigo("DC_CLIENT_SERVER");
                            String sServer = oParam.getDBValor(dbCon);
                            // Execute a command with an argument that contains a space
                            String[] commands = new String[]{sCommand , sFileSec, sServer };
                            Process child = Runtime.getRuntime().exec(commands);

                            // Se obtiene el stream de salida del programa
                            InputStream is = child.getInputStream();

                            /* Se prepara un bufferedReader para poder leer la salida más comodamente. */
                            BufferedReader br = new BufferedReader (new InputStreamReader (is));

                            // Se lee la primera linea
                            String aux = br.readLine();
                            sTipoMens =  aux.substring (0,2);
                            sTipoMens2 = aux.substring (0,8);
                            sMens     = aux.substring(3);
                        } catch (Exception e) {
                            sTipoMens = "ER";
                            sMens     = e.getMessage();
                        }

                        try {
                            dbCon.setAutoCommit(true);
                            cons2 = dbCon.prepareCall(db.getSettingCall("MAIL_UPD_COPIA_POLIZA (?,?,?,?,?,?,?)"));
                            cons2.registerOutParameter(1, java.sql.Types.DOUBLE );
                            cons2.setInt (2, Integer.parseInt (rama));
                            cons2.setInt (3, Integer.parseInt (numPoliza));
                            cons2.setInt (4, Integer.parseInt (endoso));
                            cons2.setDouble (5, iNumLote );
                            cons2.setString (6,"CP");
                            cons2.setString (7, oUser.getusuario());
                            if ( sTipoMens.equals("ER") || sTipoMens2.equals("MSGERROR") ){
                                cons2.setString (8, sMens );
                            } else {
                                cons2.setNull (8, java.sql.Types.VARCHAR);
                            }

                            cons2.execute();

                            iNumLote = cons2.getDouble(1);

                            cons2.close ();
                       } catch (SQLException se) {
                            throw new SurException("ERROR EN MAIL_UPD_COPIA_POLIZA: " + se.getMessage());
                       }

                    }  


                   if ( sTipoMens.equals("ER") || sTipoMens2.equals("MSGERROR") ){
                        StringBuilder sMensaje = new StringBuilder ();
                        sMensaje.append("INGRESO UNA NUEVA SOLICITUD DE COPIA DE POLIZA/ENDOSO.\n\n");
                        sMensaje.append("FECHA: ").append(Fecha.getFechaActual()).append("\n\n");
                        sMensaje.append("El usuario ");
                        sMensaje.append(oUser.getsDesPersona());
                        sMensaje.append(" ha solicitado la copia de la siguiente póliza/endoso: \n\n");
                        sMensaje.append("RAMA  : ").append(rama );
                        sMensaje.append("POLIZA: ").append(Formatos.showNumPoliza( Integer.parseInt (numPoliza))).append("\n");
                        sMensaje.append("ENDOSO: ").append(Formatos.showNumPoliza( Integer.parseInt (endoso))).append("\n\n");
                        sMensaje.append("La cuenta de correo destino debería ser: ").append(request.getParameter ("email"));
                        sMensaje.append("\n\nPOR EL SIGUIENTE MOTIVO LA SOLICITUD NO PUDO EFECTUARSE:\n");
                        sMensaje.append(sMens).append("\n\n");
                        sMensaje.append("Cualquier duda o consulta puede comunicarse por este medio a central@beneficiosa.com.ar\n");

                        Email oEmail = new Email ();
                        oEmail.setSubject("SOLICITUD DE COPIA DE POLIZA" );
                        oEmail.setContent(sMensaje.toString());

                        LinkedList lDest = oEmail.getDBDestinos(dbCon, oUser.getoficina(), "COPIA_POLIZA");

                        for (int i=0; i < lDest.size();i++) {
                            Persona oPers = (Persona) lDest.get(i);
                            oEmail.setDestination(oPers.getEmail());
                            // oEmail.sendMessage();
                            oEmail.sendMessageBatch();
                        }
                   }
                    if (request.getParameter ("opcion").equals ("getCopia")) {
                        if (request.getParameter("solapa").equals ("poliza")) {
                            doForward(request, response, "/servlet/ConsultaServlet?opcion=getPol");
                        } else if (request.getParameter ("solapa").equals ("endosos")) {
                            doForward (request, response, "/servlet/ConsultaServlet?opcion=getAllEnd");
                        } else doForward ( request, response, "/servlet/ConsultaServlet?opcion=getAllPol");
                    } else {
                        sMensa = "La solicitud de copia de póliza ha sido enviada exitosamente ! ";
                    }
            }

            if (sMensa != null ) {
                request.setAttribute ("mensaje", sMensa);
                request.setAttribute ("volver", "-1");
                doForward (request, response, "/include/MsjHtmlServidor.jsp");
            }
              
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void getCuponActualizado (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        
        Connection dbCon = null;
        Poliza oPol = new Poliza ();
        String sTipoMens = "";
        String sTipoMens2 = "";
        String sMens     = "";
        String sMensa     = "";
        try {
            Usuario oUser = ((Usuario) request.getSession().getAttribute("user"));
// setear el control de acceso            
            dbCon = db.getConnection();
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, 8);

            String rama = "";
            String numPoliza = "";
//            String endoso = Formatos.showParamAS400(request.getParameter ("endoso") == null ? "0" : request.getParameter("endoso"));
            String endoso = Formatos.formatearCeros(request.getParameter ("endoso") == null ? "0" :
                                                    request.getParameter("endoso"),6);
            
            if (request.getParameter("opcion").equals("getCupon")) {
                rama       = request.getParameter ("F1cod_rama_sel");
                numPoliza = Formatos.showParamAS400(request.getParameter ("F1num_poliza_sel"));
            } else {
                rama       = request.getParameter ("cod_rama");
                numPoliza = Formatos.showParamAS400(request.getParameter ("num_poliza"));
            }

             
            oPol.setcodRama   (Integer.parseInt (rama));
            oPol.setnumPoliza (Integer.parseInt (numPoliza));
            oPol.setnumEndoso (Integer.parseInt(endoso));
            oPol.setuserId    (oUser.getUsuario());
            
            int estado = 0;

            Parametro oParam = new Parametro ();
            oParam.setsCodigo("ESTADO_INFO_VIA_MAIL");
            oParam.getDBValor(dbCon);

            if (oParam.getsValor() != null && oParam.getsValor().equals("N") )  {
                estado = 4;
            } else {

                if ( oPol.getnumEndoso() > 0) {
                    oPol.getDBEnd(dbCon);
                    if (oPol.getiNumError() == -1) {
                        throw new SurException(oPol.getsMensError());
                    } else if (oPol.getiNumError() == -100 ) {
                        estado = 11;
                    }
                    if ( oPol.getcodRama() == 9 ) {
                        estado = 2;
                    }
                } else {
                    oPol.getDB(dbCon);
                    if (oPol.getiNumError() == -1) {
                        throw new SurException(oPol.getsMensError());
                    }
                    if (oPol.getiNumError() == -100 ) {
                        estado = 1;
                    } else if ( oPol.getcodRama() == 9 ) {
                        estado = 2;
                        }
                        else if ( oPol.getcodRama() == 21 && (oPol.getCuic() == null || (oPol.getCuic() != null && oPol.getCuic().equals("")))){
                        estado = 3;
                        }
                }
            }
            switch (estado) {
                case 1:
                    sMensa = "La póliza no existe en la web. verifique la información ingresada o comuniquese con su representante en Beneficio. Gracias. ";
                    break;
                case 11:
                    sMensa = "El endoso no existe en la web. verifique la información ingresada o comuniquese con su representante en Beneficio. Gracias. ";
                    break;

                case 2:
                    sMensa = "Rama no habilitada para emisi&oacute;n de copia de p&oacute;liza v&acute;a web.";
                    break;
                case 3:
                    sMensa = "La póliza no tiene CUIC asignado. Puede ser que aún este pendiente o no haya sido aprobada por la SSN.";
                    break;
                case 4:
                    sMensa = "Operación inhabilitada por el momento. Vuelva a intentar más tarde. ";
                    break;

                default:
                    int iFecCorte = 20101129;

                    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
                    int iFechaEmision =  Integer.parseInt(
                                       sdf.format(
                                        (oPol.getnumEndoso() == 0 ? oPol.getfechaEmision() :
                                                                    oPol.getfechaEmisionEnd())));

                   if ( iFechaEmision <= iFecCorte ) {
                        sTipoMens = "ER";
                        sMens     = "LA COPONERA DE POLIZA SE TIENE QUE ENVIAR DESDE EL AS400 ";
                    } else {
                        try {
                        String sFileSec = sFile + "cupon." + getNumSecuInfo (dbCon);
                        LinkedList lParams = new LinkedList();

                        lParams.add ("PROGRAMA=" + getProgramaDC (dbCon, "POLIZA" ));

                        lParams.add ("COMPAN=16");
                        lParams.add ("SECION=" + rama);
                        lParams.add ("POLIZA=" + numPoliza);
                        lParams.add ("OPERAC=1");
                        lParams.add ("ENDOSO=" +  endoso);
                        lParams.add ("POLCUP=CU");
                        lParams.add ("EMAILS=" + request.getParameter ("email").toUpperCase());

                        CreateFile(dbCon, "CUPON", lParams, sFileSec  );

                        oParam.setsCodigo("DC_CLIENT_COMANDO");
                        String sCommand = oParam.getDBValor(dbCon);

                        oParam.setsCodigo("DC_CLIENT_SERVER");
                        String sServer = oParam.getDBValor(dbCon);
                        
                        // Execute a command with an argument that contains a space
                        String[] commands = new String[]{sCommand , sFileSec, sServer };
                        Process child = Runtime.getRuntime().exec(commands);

                        // Se obtiene el stream de salida del programa
                        InputStream is = child.getInputStream();

                        /* Se prepara un bufferedReader para poder leer la salida más comodamente. */
                        BufferedReader br = new BufferedReader (new InputStreamReader (is));

                        // Se lee la primera linea
                        String aux = br.readLine();

                        sTipoMens =  aux.substring(0,2);
                        sTipoMens2 = aux.substring(0,8);
                        sMens     = aux.substring(3);

                     } catch (Exception e) {
                        sTipoMens = "ER";
                        sMens     = e.getMessage();
                     }
                  }

                   if ( sTipoMens.equals("ER") || sTipoMens2.equals("MSGERROR") ){
                        StringBuffer sMensaje = new StringBuffer();
                        sMensaje.append("INGRESO UNA NUEVA SOLICITUD DE CUPON DE DEUDA ACTUALIZADA.\n\n");
                        sMensaje.append("FECHA: " + Fecha.getFechaActual() + "\n\n");
                        sMensaje.append("El usuario ");
                        sMensaje.append(oUser.getsDesPersona());
                        sMensaje.append(" ha solicitado el cupón de deuda actualizada de la siguiente póliza/endoso: \n\n");
                        sMensaje.append("RAMA:   " + rama);
                        sMensaje.append("POLIZA: " + Formatos.showNumPoliza( Integer.parseInt (numPoliza)) + "\n");
                        sMensaje.append("ENDOSO: " + Formatos.showNumPoliza( Integer.parseInt (endoso)) + "\n\n");
                        sMensaje.append("La cuenta de correo destino deberia ser: " + request.getParameter ("email"));
                        sMensaje.append("\n\nPOR EL SIGUIENTE MOTIVO LA SOLICITUD NO PUDO EFECTUARSE:\n");
                        sMensaje.append(sMens + "\n\n");
                        sMensaje.append("Cualquier duda o consulta puede comunicarse por este medio a central@beneficiosa.com.ar\n");

                        Email oEmail = new Email ();
                        oEmail.setSubject("SOLICITUD DE CUPON ACTUALIZADO" );
                        oEmail.setContent(sMensaje.toString());

                        LinkedList lDest = oEmail.getDBDestinos(dbCon, oUser.getoficina(), "CUPON_ACTUALIZADO");

                        for (int i=0; i < lDest.size();i++) {
                            Persona oPers = (Persona) lDest.get(i);
                            oEmail.setDestination(oPers.getEmail());
                           // oEmail.sendMessage();
                            oEmail.sendMessageBatch();
                        }

                   }
                    if (request.getParameter ("opcion").equals ("getCupon")) {
                        if (request.getParameter("solapa").equals ("poliza")) {
                            doForward(request, response, "/servlet/ConsultaServlet?opcion=getPol");
                        } else if (request.getParameter ("solapa").equals ("cobranza")) {
                            doForward (request, response, "/servlet/ConsultaServlet?opcion=getAllCob");
                        } else doForward ( request, response, "/servlet/ConsultaServlet?opcion=getAllPol");
                    } else {
                        sMensa = "La solicitud de copia de cuponera ha sido enviada exitosamente ! ";
                    }
            }

            if (sMensa != null ) {
                request.setAttribute ("mensaje", sMensa);
                request.setAttribute ("volver", "-1");
                doForward (request, response, "/include/MsjHtmlServidor.jsp");
            }
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }
    
    protected void getPreLiquidacion (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        
        Connection dbCon = null;
        Poliza oPol = new Poliza ();
        String sTipoMens = new String ();
        String sTipoMens2 = new String ();
        String sMens     = new String ();
        String sMensError = "";
        try {
            Usuario oUser = ((Usuario) request.getSession().getAttribute("user"));
            
            String sCodProd = null;
            
            if (oUser.getiCodTipoUsuario() == 1 && oUser.getiCodProd() < 80000 ) {
                sCodProd = oUser.getsCodProdDC();
            } else {
                sCodProd = request.getParameter ("cod_prod");
            }
            
// setear el control de acceso            
            dbCon = db.getConnection();
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, 15);

//            String sComando = "PREL12CMD PRODUCTOR(" + String.valueOf (codProd) + ") INTNETA(" +
//            request.getParameter ("email").toUpperCase() + ")";
                        
 /*                   AS400 sys = null;

                    try {
                        sys = dbAS400.getConnection();

                        if ( dbAS400.commandCall(sys, sComando ) != true ) {
                            throw new SurException ("");
                        }
*/

                    Parametro oParam = new Parametro ();
                    oParam.setsCodigo("ESTADO_INFO_VIA_MAIL");
                    oParam.getDBValor(dbCon);

                    if (oParam.getsValor() != null && oParam.getsValor().equals("N") )  {
                        sMensError ="Operación inhabilitada por el momento. Vuelva a intentar más tarde. ";
                    } else {

                        try {

                            String sFileSec = sFile + "preliq." + getNumSecuInfo (dbCon);
                            LinkedList lParams = new LinkedList();

                            lParams.add ("PROGRAMA=" + getProgramaDC (dbCon, "PRELIQ" ));

                            lParams.add ("COMPAN=16");
                            lParams.add ("PRODUC=" + Formatos.formatearCeros(sCodProd, 10));
                            lParams.add ("EMAILS=" + request.getParameter ("email").toUpperCase());

                            CreateFile(dbCon, "PRELIQ", lParams, sFileSec  );

                            oParam.setsCodigo("DC_CLIENT_COMANDO");
                            String sCommand = oParam.getDBValor(dbCon);
                            
                            oParam.setsCodigo("DC_CLIENT_SERVER");
                            String sServer = oParam.getDBValor(dbCon);
                            
                            // Execute a command with an argument that contains a space
                            String[] commands = new String[]{sCommand , sFileSec, sServer };
                            Process child = Runtime.getRuntime().exec(commands);

                            // Se obtiene el stream de salida del programa
                            InputStream is = child.getInputStream();

                            /* Se prepara un bufferedReader para poder leer la salida más comodamente. */
                            BufferedReader br = new BufferedReader (new InputStreamReader (is));

                            // Se lee la primera linea
                            String aux = br.readLine();

                            sTipoMens =  aux.substring(0,2);
                            sTipoMens2 = aux.substring(0,8);
                            sMens     = aux.substring(3);

                        } catch (Exception e) {
                            sTipoMens = "ER";
                            sMens     = e.getMessage();
                       }

                       if ( sTipoMens.equals("ER") || sTipoMens2.equals("MSGERROR") ){
                            StringBuffer sMensaje = new StringBuffer();
                            sMensaje.append("INGRESO UNA NUEVA SOLICITUD DE PRE-LIQUIDACION.\n\n");
                            sMensaje.append("FECHA: " + Fecha.getFechaActual() + "\n\n");
                            sMensaje.append("El usuario ");
                            sMensaje.append(oUser.getsDesPersona());
                            sMensaje.append(" ha solicitado la pre-liquidación y por alguna razón el pedido no pudo realizarse en forma automática: \n\n");

                            sMensaje.append("COD. DE PRODUCTOR: " + sCodProd + "\n");
                            sMensaje.append("La cuenta de correo destino deberia ser: " + request.getParameter ("email"));
                            sMensaje.append("\n\nPOR EL SIGUIENTE MOTIVO LA SOLICITUD NO PUDO EFECTUARSE:\n");
                            sMensaje.append(sMens + "\n\n");
                            sMensaje.append("Cualquier duda o consulta puede comunicarse por este medio a central@beneficiosa.com.ar\n");

                            Email oEmail = new Email ();
                            oEmail.setSubject("SOLICITUD DE PRE-LIQUIDACION" );
                            oEmail.setContent(sMensaje.toString());

                            LinkedList lDest = oEmail.getDBDestinos(dbCon, oUser.getoficina(), "PRELIQUIDACION");

                            for (int i=0; i < lDest.size();i++) {
                                Persona oPers = (Persona) lDest.get(i);
                                oEmail.setDestination(oPers.getEmail());
                               // oEmail.sendMessage();
                                oEmail.sendMessageBatch();
                            }
                            sMensError = sMens + ". Por favor, ante cualquier duda contáctese con su representante comercial. Muchas gracias ";
                        } else {
                            sMensError = "La solicitud de Preliquidación ha sido enviada exitosamente ! ";
                        }
            }
           
            request.setAttribute ("mensaje", sMensError);
            request.setAttribute ("volver", "-1");
            doForward (request, response, "/include/MsjHtmlServidor.jsp");
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }
    
    protected void getCopiaLiquidacion (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        
        Connection dbCon = null;
        Poliza oPol = new Poliza ();
        String sTipoMens = new String ();
        String sTipoMens2 = new String ();
        String sMens     = new String ();
        String sMensError = "";
        try {
            Usuario oUser = ((Usuario) request.getSession().getAttribute("user"));
            
            String sCodProd = null;

            if (oUser.getiCodTipoUsuario() == 1 && oUser.getiCodProd() < 80000 ) {
                sCodProd = oUser.getsCodProdDC();
            } else {
                sCodProd = request.getParameter ("cod_prod");
            }
            SimpleDateFormat formato = new SimpleDateFormat("yyyyMMdd");
            String fechaHasta = formato.format(Fecha.strToDate(request.getParameter("fecha_hasta")));
            
            String liquidacion = Formatos.formatearCeros( request.getParameter ("liquidacion"), 10);
// setear el control de acceso            
            dbCon = db.getConnection();
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, 17);

            Parametro oParam = new Parametro ();
            oParam.setsCodigo("ESTADO_INFO_VIA_MAIL");
            oParam.getDBValor(dbCon);

            if (oParam.getsValor() != null && oParam.getsValor().equals("N") )  {
                sMensError ="Operación inhabilitada por el momento. Vuelva a intentar más tarde. ";
            } else {

                try {

                    String sFileSec = sFile + "copliq." + getNumSecuInfo (dbCon);
                    LinkedList lParams = new LinkedList();

                    lParams.add ("PROGRAMA=" + getProgramaDC (dbCon, "COPLIQ" ));

                    lParams.add ("COMPAN=16");
                    lParams.add ("FECHAS=" + fechaHasta);
                    lParams.add ("NROLIQ=" + liquidacion);
                    lParams.add ("PRODUC=" + sCodProd );
                    lParams.add ("EMAILS=" + request.getParameter ("email").toUpperCase());

                    CreateFile(dbCon, "COPLIQ", lParams, sFileSec  );

                    oParam.setsCodigo("DC_CLIENT_COMANDO");
                    String sCommand = oParam.getDBValor(dbCon);

                    oParam.setsCodigo("DC_CLIENT_SERVER");
                    String sServer = oParam.getDBValor(dbCon);
                    
                    // Execute a command with an argument that contains a space
                    String[] commands = new String[]{sCommand , sFileSec, sServer };
                    Process child = Runtime.getRuntime().exec(commands);
                    // Se obtiene el stream de salida del programa
                    InputStream is = child.getInputStream();

                    /* Se prepara un bufferedReader para poder leer la salida más comodamente. */
                    BufferedReader br = new BufferedReader (new InputStreamReader (is));

                    // Se lee la primera linea
                    String aux = br.readLine();

                    sTipoMens =  aux.substring(0,2);
                    sTipoMens2 = aux.substring(0,8);
                    sMens     = aux.substring(3);

                    // Mientras se haya leido alguna linea
    //                       while (aux!=null)
    //                       {
                        // Se escribe la linea en pantalla
    //                           System.out.println (aux);

                        // y se lee la siguiente.
    //                            aux = br.readLine();
    //                        }
                } catch (Exception e) {
                    sTipoMens = "ER";
                    sMens     = e.getMessage();
               }

                if ( sTipoMens.equals("ER") || sTipoMens2.equals("MSGERROR") ){
                    StringBuffer sMensaje = new StringBuffer();
                    sMensaje.append("INGRESO UNA NUEVA SOLICITUD DE COPIA DE LIQUIDACION.\n\n");
                    sMensaje.append("FECHA: " + Fecha.getFechaActual() + "\n\n");
                    sMensaje.append("El usuario ");
                    sMensaje.append(oUser.getsDesPersona());
                    sMensaje.append(" ha solicitado la Copia de Liquidación y por alguna razón el pedido no pudo realizarse en forma automática: \n\n");

                    sMensaje.append("COD. DE PRODUCTOR  : " + sCodProd + "\n");
                    sMensaje.append("NUM. DE LIQUIDACION: " + liquidacion + "\n");
                    sMensaje.append("La cuenta de correo destino deberia ser: " + request.getParameter ("email"));
                    sMensaje.append("\n\nPOR EL SIGUIENTE MOTIVO LA SOLICITUD NO PUDO EFECTUARSE:\n");
                    sMensaje.append(sMens + "\n\n");
                    sMensaje.append("Cualquier duda o consulta puede comunicarse por este medio a central@beneficiosa.com.ar\n");

                    Email oEmail = new Email ();
                    oEmail.setSubject("SOLICITUD DE COPIA DE LIQUIDACION" );
                    oEmail.setContent(sMensaje.toString());

                    LinkedList lDest = oEmail.getDBDestinos(dbCon, oUser.getoficina(), "PRELIQUIDACION");

                    for (int i=0; i < lDest.size();i++) {
                        Persona oPers = (Persona) lDest.get(i);
                        oEmail.setDestination(oPers.getEmail());
                       // oEmail.sendMessage();
                        oEmail.sendMessageBatch();
                    }
                    sMensError = sMens + ". Por favor, ante cualquier duda contáctese con su representante comercial. Muchas gracias ";
                } else {
                    sMensError = "La operación ha sido realizada con exito ! ";
                }
            }

            request.setAttribute ("mensaje", sMensError);
            request.setAttribute ("volver", "-1");
            doForward (request, response, "/include/MsjHtmlServidor.jsp");
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void getComisiones (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        Connection dbCon = null;
        Poliza oPol = new Poliza ();
        String sTipoMens = "";
        String sTipoMens2 = "";
        String sMens     = "";
        SimpleDateFormat formato = new SimpleDateFormat("yyyyMMdd");
        String fechaHasta        = "";
        String sMensError = "";
        try {
            Usuario oUser = ((Usuario) request.getSession().getAttribute("user"));

            String sCodProd = null;

            if (oUser.getiCodTipoUsuario() == 1 && oUser.getiCodProd() < 80000 ) {
                sCodProd = oUser.getsCodProdDC();
            } else {
                sCodProd = request.getParameter ("cod_prod");
            }

            fechaHasta = formato.format(Fecha.strToDate(request.getParameter("fecha_hasta")));


// setear el control de acceso
            dbCon = db.getConnection();
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, 18);

            Parametro oParam = new Parametro ();
            oParam.setsCodigo("ESTADO_INFO_VIA_MAIL");
            oParam.getDBValor(dbCon);

            if (oParam.getsValor() != null && oParam.getsValor().equals("N") )  {
                sMensError ="Operación inhabilitada por el momento. Vuelva a intentar más tarde. ";
            } else {

                try {

                    String sFileSec = sFile + "comision."+ getNumSecuInfo (dbCon);

                    LinkedList lParams = new LinkedList();

                    java.util.Date dMesActual = new java.util.Date ();
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
                    int iMes       = Integer.parseInt (sdf.format(dMesActual));

                    int iMesParam        = Integer.parseInt (sdf.format(Fecha.strToDate(request.getParameter("fecha_hasta"))));

                    if (iMesParam >= iMes ) {
                        sTipoMens = "ER";
                        sMens     = "La fecha que ha consultado año no esta cerrada, debería ingresar un mes anterior.<br>";
                    } else {
                        lParams.add ("PROGRAMA=" + getProgramaDC (dbCon, "COMISION" ));
                        lParams.add ("COMPAN=16");
                        lParams.add ("PRODUC=" + sCodProd);
                        lParams.add ("FECHAS=" + fechaHasta);
                        lParams.add ("EMAILS=" + request.getParameter ("email").toUpperCase());

                        CreateFile(dbCon, "COMISION", lParams, sFileSec  );

                        oParam.setsCodigo("DC_CLIENT_COMANDO");
                        String sCommand = oParam.getDBValor(dbCon);

                        oParam.setsCodigo("DC_CLIENT_SERVER");
                        String sServer = oParam.getDBValor(dbCon);
                        
                        String[] commands = new String[]{sCommand , sFileSec, sServer };
                        Process child = Runtime.getRuntime().exec(commands);

                        InputStream is = child.getInputStream();
                        BufferedReader br = new BufferedReader (new InputStreamReader (is));
                        String aux = br.readLine();

                        sTipoMens =  aux.substring(0,2);
                        sTipoMens2 = aux.substring(0,8);
                        sMens     = aux.substring(3);
                    }
                } catch (Exception e) {
                    sTipoMens = "ER";
                    sMens     = e.getMessage();
               }

              if ( sTipoMens.equals("ER") || sTipoMens2.equals("MSGERROR") ){
                    StringBuffer sMensaje = new StringBuffer();
                    sMensaje.append("INGRESO UNA NUEVA SOLICITUD DE RESUMEN DE COMISIONES MENSUALES.\n\n");
                    sMensaje.append("FECHA: " + Fecha.getFechaActual() + "\n\n");
                    sMensaje.append("El usuario ");
                    sMensaje.append(oUser.getsDesPersona());
                    sMensaje.append(" ha solicitado un resumen de Comisiones Mensuales  y por alguna razón el pedido no pudo realizarse en forma automï¿½tica: \n\n");

                    sMensaje.append("COD. DE PRODUCTOR : " + sCodProd + "\n");
                    sMensaje.append("PERIODO SOLICITADO: " + fechaHasta  + "\n");
                    sMensaje.append("La cuenta de correo destino deberia ser: " + request.getParameter ("email"));
                    sMensaje.append("\n\nPOR EL SIGUIENTE MOTIVO LA SOLICITUD NO PUDO EFECTUARSE:\n");
                    sMensaje.append(sMens + "\n\n");
                    sMensaje.append("Cualquier duda o consulta puede comunicarse por este medio a central@beneficiosa.com.ar\n");

                    Email oEmail = new Email ();
                    oEmail.setSubject("SOLICITUD DE RESUMEN DE COMISIONES MENSUALES" );
                    oEmail.setContent(sMensaje.toString());

                    LinkedList lDest = oEmail.getDBDestinos(dbCon, oUser.getoficina(), "PRELIQUIDACION");

                    for (int i=0; i < lDest.size();i++) {
                        Persona oPers = (Persona) lDest.get(i);
                        oEmail.setDestination(oPers.getEmail());
                      //  oEmail.sendMessage();
                        oEmail.sendMessageBatch();
                    }
                    sMensError = sMens + "<br>Por favor, ante cualquier duda contáctese con su representante comercial. Muchas gracias ";
                } else {
                    sMensError = "La operación ha sido realizada con exito ! ";
                }
            }

            request.setAttribute ("mensaje", sMensError);
            request.setAttribute ("volver", "-1");
            doForward (request, response, "/include/MsjHtmlServidor.jsp");
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }
    
    protected void getRenovacionesPend (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        
        Connection dbCon = null;
        Poliza oPol = new Poliza ();
        String sTipoMens = new String ();
        String sTipoMens2 = new String ();
        String sMens     = new String ();
        String sMensError = "";
        try {
            Usuario oUser = ((Usuario) request.getSession().getAttribute("user"));
            
            String codProd = null;
            
            if (oUser.getiCodTipoUsuario() == 1 && oUser.getiCodProd() < 80000 ) {
                codProd = oUser.getsCodProdDC();
            } else {
                codProd = request.getParameter ("cod_prod");
            }
            SimpleDateFormat formato = new SimpleDateFormat("yyMM");
            String fechaHasta = formato.format(Fecha.strToDate(request.getParameter("fecha_hasta")));

            
// setear el control de acceso            
            dbCon = db.getConnection();
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, 19);

//                String sComando = "RNV002CMD PRODUCTOR(" + String.valueOf (codProd) + ") INTNETA(" +
//            request.getParameter ("email").toUpperCase() + ")";
            
 /*                   AS400 sys = null;

                    try {
                        sys = dbAS400.getConnection();

                        if ( dbAS400.commandCall(sys, sComando ) != true ) {
                            throw new SurException ("");
                        }
*/

            Parametro oParam = new Parametro ();
            oParam.setsCodigo("ESTADO_INFO_VIA_MAIL");
            oParam.getDBValor(dbCon);

            if (oParam.getsValor() != null && oParam.getsValor().equals("N") )  {
                sMensError ="Operación inhabilitada por el momento. Vuelva a intentar más tarde. ";
            } else {
                try {

                    String sFileSec = sFile + "renopend." + getNumSecuInfo (dbCon);

                    LinkedList lParams = new LinkedList();

                    lParams.add ("PROGRAMA=" + getProgramaDC (dbCon, "RENOPEND" ));

                    lParams.add ("COMPAN=16");
                    lParams.add ("PRODUC=" + codProd);
                    lParams.add ("FECHAS=" + fechaHasta );
                    lParams.add ("EMAILS=" + request.getParameter ("email").toUpperCase());

                    CreateFile(dbCon, "RENOPEND", lParams, sFileSec  );

                    oParam.setsCodigo("DC_CLIENT_COMANDO");
                    String sCommand = oParam.getDBValor(dbCon);

                    oParam.setsCodigo("DC_CLIENT_SERVER");
                    String sServer = oParam.getDBValor(dbCon);
                    
                    // Execute a command with an argument that contains a space
                    String[] commands = new String[]{sCommand , sFileSec, sServer };
                    Process child = Runtime.getRuntime().exec(commands);

                        // Se obtiene el stream de salida del programa
                        InputStream is = child.getInputStream();

                        /* Se prepara un bufferedReader para poder leer la salida más comodamente. */
                        BufferedReader br = new BufferedReader (new InputStreamReader (is));

                        // Se lee la primera linea
                        String aux = br.readLine();

                        sTipoMens =  aux.substring(0,2);
                        sTipoMens2 = aux.substring(0,8);
                        sMens     = aux.substring(3);

                        // Mientras se haya leido alguna linea
        //                       while (aux!=null)
        //                       {
                            // Se escribe la linea en pantalla
        //                           System.out.println (aux);

                            // y se lee la siguiente.
        //                            aux = br.readLine();
        //                        }
                    } catch (Exception e) {
                        sTipoMens = "ER";
                        sMens     = e.getMessage();
                   }

                if ( sTipoMens.equals("ER") || sTipoMens2.equals("MSGERROR") ){
                    StringBuffer sMensaje = new StringBuffer();
                    sMensaje.append("INGRESO UNA NUEVA SOLICITUD DE RENOVACIONES PENDIENTES.\n\n");
                    sMensaje.append("FECHA: " + Fecha.getFechaActual() + "\n\n");
                    sMensaje.append("El usuario ");
                    sMensaje.append(oUser.getsDesPersona());
                    sMensaje.append(" ha solicitado el reporte de Renovaciones Pendientes y por alguna motivo el pedido no pudo realizarse en forma autom�tica: \n\n");

                    sMensaje.append("COD. DE PRODUCTOR: " + codProd + "\n");
                    sMensaje.append("La cuenta de correo destino deberia ser: " + request.getParameter ("email"));
                    sMensaje.append("\n\nPOR EL SIGUIENTE MOTIVO LA SOLICITUD NO PUDO EFECTUARSE:\n");
                    sMensaje.append(sMens + "\n\n");
                    sMensaje.append("Cualquier duda o consulta puede comunicarse por este medio a central@beneficiosa.com.ar\n");

                    Email oEmail = new Email ();
                    oEmail.setSubject("SOLICITUD DE RENOVACIONES PENDIENTES" );
                    oEmail.setContent(sMensaje.toString());

                    LinkedList lDest = oEmail.getDBDestinos(dbCon, oUser.getoficina(), "PRELIQUIDACION");

                    for (int i=0; i < lDest.size();i++) {
                        Persona oPers = (Persona) lDest.get(i);
                        oEmail.setDestination(oPers.getEmail());
                    //    oEmail.sendMessage();
                        oEmail.sendMessageBatch();
                    }
                    sMensError = sMens + ". Por favor, ante cualquier duda contáctese con su representante comercial. Muchas gracias ";
                } else {
                    sMensError = "La operación ha sido realizada con exito ! ";
                }
            }

            request.setAttribute ("mensaje", sMensError);
            request.setAttribute ("volver", "-1");
            doForward (request, response, "/include/MsjHtmlServidor.jsp");
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }
    
    protected void getCtaCteProd (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        Connection dbCon = null;
        Poliza oPol = new Poliza ();
        String sTipoMens = new String ();
        String sTipoMens2 = new String ();
        String sMens     = new String ();
        String sMensError = "";
        try {
            Usuario oUser = ((Usuario) request.getSession().getAttribute("user"));

            String codProd = null;

            if (oUser.getiCodTipoUsuario() == 1 && oUser.getiCodProd() < 80000 ) {
                codProd = oUser.getsCodProdDC();
            } else {
                codProd = request.getParameter ("cod_prod");
            }

            SimpleDateFormat formato = new SimpleDateFormat("yyyyMMdd");
            String fechaHasta = formato.format(Fecha.strToDate(request.getParameter("fecha_hasta")));


            // setear el control de acceso
            dbCon = db.getConnection();
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, 16);

            Parametro oParam = new Parametro ();
            oParam.setsCodigo("ESTADO_INFO_VIA_MAIL");
            oParam.getDBValor(dbCon);

            if (oParam.getsValor() != null && oParam.getsValor().equals("N") )  {
                sMensError ="Operación inhabilitada por el momento. Vuelva a intentar más tarde. ";
            } else {

            try {

                String sFileSec = sFile + "ctacte." + getNumSecuInfo (dbCon);

                LinkedList lParams = new LinkedList();

                java.util.Date dMesActual = new java.util.Date ();
                SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
                int iMesActual       = Integer.parseInt (sdf.format(dMesActual));

                int iMesParam        = Integer.parseInt (sdf.format(Fecha.strToDate(request.getParameter("fecha_hasta"))));

                if (iMesParam < iMesActual) {
                    lParams.add ("PROGRAMA=" + getProgramaDC (dbCon, "CTACTE" ));
                } else {
                    lParams.add ("PROGRAMA=" + getProgramaDC (dbCon, "CTACTEOL" ));
                }

                lParams.add ("COMPAN=16");
                lParams.add ("PRODUC=" + codProd);
                lParams.add ("FECHAS=" + fechaHasta);
                lParams.add ("EMAILS=" + request.getParameter ("email").toUpperCase());

                CreateFile(dbCon, "CTACTE", lParams, sFileSec  );

                oParam.setsCodigo("DC_CLIENT_COMANDO");
                String sCommand = oParam.getDBValor(dbCon);

                oParam.setsCodigo("DC_CLIENT_SERVER");
                String sServer = oParam.getDBValor(dbCon);
                
                // Execute a command with an argument that contains a space
                String[] commands = new String[]{sCommand , sFileSec, sServer };
                Process child = Runtime.getRuntime().exec(commands);

                            // Se obtiene el stream de salida del programa
                            InputStream is = child.getInputStream();

                            /* Se prepara un bufferedReader para poder leer la salida mÃ¡s comodamente. */
                            BufferedReader br = new BufferedReader (new InputStreamReader (is));

                            // Se lee la primera linea
                            String aux = br.readLine();

                            sTipoMens =  aux.substring(0,2);
                            sTipoMens2 = aux.substring(0,8);
                            sMens     = aux.substring(3);

                            // Mientras se haya leido alguna linea
     //                       while (aux!=null)
     //                       {
                                // Se escribe la linea en pantalla
     //                           System.out.println (aux);

                                // y se lee la siguiente.
    //                            aux = br.readLine();
    //                        }
                        } catch (Exception e) {
                            sTipoMens = "ER";
                            sMens     = e.getMessage();
                       }

                        if ( sTipoMens.equals("ER") || sTipoMens2.equals("MSGERROR") ){
                            StringBuffer sMensaje = new StringBuffer();
                            sMensaje.append("INGRESO UNA NUEVA SOLICITUD DE CTA. CTE.\n\n");
                            sMensaje.append("FECHA: " + Fecha.getFechaActual() + "\n\n");
                            sMensaje.append("El usuario ");
                            sMensaje.append(oUser.getsDesPersona());
                            sMensaje.append(" ha solicitado la cta. cte. y por alguna razón el pedido no pudo realizarse en forma automática: \n\n");

                            sMensaje.append("COD. PRODUCTOR: " + codProd + "\n");
                            sMensaje.append("PERIODO: " + request.getParameter ("fecha_desde") + " - " + request.getParameter ("fecha_hasta") + "\n\n");
                            sMensaje.append("La cuenta de correo destino deberia ser: " + request.getParameter ("email"));
                            sMensaje.append("\n\nPOR EL SIGUIENTE MOTIVO LA SOLICITUD NO PUDO EFECTUARSE:\n");
                            sMensaje.append(sMens + "\n\n");
                            sMensaje.append("Cualquier duda o consulta puede comunicarse por este medio a central@beneficiosa.com.ar\n");

                            Email oEmail = new Email ();
                            oEmail.setSubject("SOLICITUD DE CTA. CTE." );
                            oEmail.setContent(sMensaje.toString());

                            LinkedList lDest = oEmail.getDBDestinos(dbCon, oUser.getoficina(), "CUENTA_CORRIENTE");

                            for (int i=0; i < lDest.size();i++) {
                                Persona oPers = (Persona) lDest.get(i);
                                oEmail.setDestination(oPers.getEmail());
                           //     oEmail.sendMessage();
                                oEmail.sendMessageBatch();
                            }
                    sMensError = sMens + ". Por favor, ante cualquier duda contáctese con su representante comercial. Muchas gracias ";
                } else {
                    sMensError = "La operación ha sido realizada con exito ! ";
                }
            }

            request.setAttribute ("mensaje", sMensError);
            request.setAttribute ("volver", "-1");
            doForward (request, response, "/include/MsjHtmlServidor.jsp");
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void getAllEndosos (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        
        Connection dbCon = null;
        CallableStatement cons2  = null;
        ResultSet rs2 = null;
        LinkedList lEndosos = null;
        Poliza oPol = new Poliza ();
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            int iCodRamaSelec   = Integer.parseInt (request.getParameter ("F1cod_rama_sel"));
            int iNumPolizaSelec = Integer.parseInt (request.getParameter ("F1num_poliza_sel"));
            String sOpcion      = request.getParameter("opcion");
           dbCon = db.getConnection();

 /*          int iProcedencia    = 7;
             if (sOpcion.equals ("getAllPremio")) {
                iProcedencia = 8;
            } else if (sOpcion.equals("getAllCob")) {
                iProcedencia = 9;
            }
// setear el control de acceso            
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, iProcedencia);
*/
            oPol.setcodRama( iCodRamaSelec);
            oPol.setnumPoliza(iNumPolizaSelec);
            oPol.getDB(dbCon);
            
            if (oPol.getiNumError() != 0) {
                throw new SurException (oPol.getsMensError());
            }

            dbCon.setAutoCommit(false);
// Procedure call.  
            cons2 = dbCon.prepareCall(db.getSettingCall("PZ_GET_ALL_ENDOSOS (?, ?)"));
            cons2.registerOutParameter(1, java.sql.Types.OTHER);
            cons2.setInt     (2, iCodRamaSelec );
            cons2.setInt     (3, iNumPolizaSelec );
            cons2.execute();
            rs2 = (ResultSet) cons2.getObject(1);

            if (rs2 != null) {
                lEndosos = new LinkedList ();

                while (rs2.next()) {
                    Poliza oEnd = new Poliza();
                    oEnd.setcantVidas( rs2.getInt("CANT_VIDAS_AFIP") );
                    oEnd.setcodRama     ( rs2.getInt("COD_RAMA"));
                    oEnd.setnumPoliza   ( rs2.getInt("NUM_POLIZA"));
                    oEnd.setnumEndoso   ( rs2.getInt ("ENDOSO"));
                    oEnd.setfechaEmision( rs2.getDate("FECHA_EMISION_END"));
                    oEnd.setfechaInicioVigencia ( rs2.getDate("FECHA_INI_VIG_END"));
                    oEnd.setfechaFinVigencia    ( rs2.getDate ("FECHA_FIN_VIG_END"));
                    oEnd.setnumPropuesta(rs2.getInt ("NUM_PROPUESTA"));
                    oEnd.setboca                (rs2.getString ("BOCA"));
                    oEnd.setimpTotalFacturado   ( rs2.getDouble ("TOTAL_FACTURADO_END"));
                    oEnd.setimpSaldoPoliza      ( rs2.getDouble ("SALDO_POLIZA_END"));
                    oEnd.setimpDeuda            (rs2.getDouble ("IMP_DEUDA_END" ));
                    oEnd.setsDescTipoEndoso(rs2.getString ("TIPO_ENDOSO"));
                    Premio oPre = new Premio ();
                    
                    oPre.setimpPrima( rs2.getDouble ("IMP_PRIMA"));
                    oPre.setMpremio ( rs2.getDouble ("IMP_PREMIO"));
                    oPre.setimpRecFin   (rs2.getDouble ("IMP_RECARGO_FINANCIERO" ));
                    oPre.setimpRecAdm   (rs2.getDouble ("IMP_RECARGO_ADMINITRATIVO" ));
                    oPre.setimpDerEmi   (rs2.getDouble ("IMP_DERECHO_EMISION"));
                    oPre.setimpIVA      (rs2.getDouble ("IMP_IVA"));
                    oPre.setimpSellados (rs2.getDouble ("IMP_SELLADOS"));
                    oPre.setimpOtrosImpuestos(rs2.getDouble ("IMP_OTROS_IMPUESTOS"));
                    
                    oEnd.setPremio(oPre);
                
                    double impCobrado = Math.abs(oEnd.getPremio().getMpremio()) -
                                        Math.abs(oEnd.getimpSaldoPoliza());

                    if (sOpcion.equals ("getAllEnd")) {
                        LinkedList lAseg = oEnd.getDBAseguradosEnd(dbCon);
                        if (oEnd.getiNumError() < 0 ) {
                            throw new SurException (oEnd.getsMensError());
                        }
                        oEnd.setAsegurados(lAseg);
                        oEnd.setCuotas (oEnd.getDBCuotasEnd(dbCon));
                        // oEnd.setCobranza(oEnd.getDBPagosEnd(dbCon));
                        //oEnd.setlTextos(oEnd.getDBTextosVariable(dbCon));

                        if (oUser.getiCodTipoUsuario() == 0 ) {
                // agregado 20/5/2015 para no gestionar
                            NoGestionar oNoGes = new NoGestionar ();
                            oNoGes.setcodRama(oEnd.getcodRama());
                            oNoGes.setnumPoliza(oEnd.getnumPoliza());
                            oNoGes.setnumEndoso(oEnd.getnumEndoso());
                            oNoGes.setzona(0);
                            oNoGes.setnivel(2); // busqueda a nivel de poliza

                            oNoGes.getDB(dbCon);

                            if (oNoGes.getiNumError() >= 0 ) {
                                System.out.println ("encontro el objeto en NoGestionar del endoso" + oEnd.getnumEndoso());

                                oEnd.setoNoGestionar(oNoGes);
                            }
                //

                        }
                    }
                    
                    if (sOpcion.equals ("getAllCob")) {
                        oEnd.setCobranza(oEnd.getDBCobranzaEnd(dbCon)); 
                    }

                    lEndosos.add(oEnd);
                }
                rs2.close ();
            }

        request.setAttribute("endosos", lEndosos);
        request.setAttribute("poliza", oPol);

        String sNextPage = "/consulta/consultaEndosos.jsp";

        if (sOpcion.equals ("getAllPremio")) {
            sNextPage = "/consulta/consultaPremios.jsp";
        } else if (sOpcion.equals("getAllCob")) {
                sNextPage = "/consulta/consultaCobranza.jsp";
        }
        
        doForward(request, response, sNextPage);

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs2 != null) rs2.close();                
                if (cons2 != null) cons2.close ();
               
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }

    protected void getAllSeguimiento (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        
        Connection dbCon = null;
        CallableStatement cons2  = null;
        ResultSet rs2 = null;
        LinkedList lEndosos = null;
        Poliza oPol = new Poliza ();
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            int iCodRamaSelec   = Integer.parseInt (request.getParameter ("F1cod_rama_sel"));
            int iNumPolizaSelec = Integer.parseInt (request.getParameter ("F1num_poliza_sel"));
            String sOpcion      = request.getParameter("opcion");
            int iProcedencia    = 7;
            dbCon = db.getConnection();

            if (sOpcion.equals ("getAllPremio")) {
                iProcedencia = 8;
            } else if (sOpcion.equals("getAllCob")) {
                iProcedencia = 9;
            }
// setear el control de acceso            
//            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
//            oControl.setearAcceso(dbCon, iProcedencia);

            oPol.setcodRama( iCodRamaSelec);
            oPol.setnumPoliza(iNumPolizaSelec);
            oPol.getDB(dbCon);
            
            if (oPol.getiNumError() != 0) {
                throw new SurException (oPol.getsMensError());
            }

            dbCon.setAutoCommit(false);
            cons2 = dbCon.prepareCall(db.getSettingCall("PZ_GET_ALL_ENDOSOS (?, ?)"));
            cons2.registerOutParameter(1, java.sql.Types.OTHER);
            cons2.setInt     (2, iCodRamaSelec );
            cons2.setInt     (3, iNumPolizaSelec );
            cons2.execute();
            rs2 = (ResultSet) cons2.getObject(1);

            if (rs2 != null) {
                lEndosos = new LinkedList ();
                while (rs2.next()) {
                    Poliza oEnd = new Poliza();
                    oEnd.setcodRama     ( rs2.getInt("COD_RAMA"));
                    oEnd.setnumPoliza   ( rs2.getInt("NUM_POLIZA"));
                    oEnd.setnumEndoso   ( rs2.getInt ("ENDOSO"));
//                    oEnd.setnumPropuesta(rs2.getInt ("NUM_PROPUESTA"));
//                    oEnd.setboca        (rs2.getString ("BOCA"));
                    oEnd.setSeguimiento (oEnd.getDBSeguimientoEnd(dbCon)); 
                    lEndosos.add(oEnd);    
                }
                rs2.close ();
            }
        request.setAttribute("endosos", lEndosos);
        request.setAttribute("poliza", oPol);

        String sNextPage = "/consulta/consultaSeguimiento.jsp";
        doForward(request, response, sNextPage);

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (rs2 != null) rs2.close();                
                if (cons2 != null) cons2.close ();
               
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }
    
    protected void getPrintNominaAcrobat (HttpServletRequest request, HttpServletResponse response, Poliza oPol)
    throws ServletException, IOException, SurException {
        Connection dbCon        = null;
        try {
            Usuario user = (Usuario) (request.getSession().getAttribute("user"));
            dbCon = db.getConnection();
            oPol.getDB(dbCon);   
            
            if (oPol.getiNumError() != 0) {
                throw new SurException (oPol.getsMensError());
            }

            Report oReport = new Report ();
            oReport.setTitulo       ("Nómina actualizada de Asegurados");
            oReport.addlObj         ("subtitulo" , "Nómina actualizada de Asegurados");
            oReport.setUsuario      (user.getusuario());
            oReport.setFecha        (Fecha.toString(new java.util.Date ()));
            oReport.setFormulario   ("NOM001");
            oReport.setReportName   (getServletContext ().getRealPath("/consulta/report/nomina.xml"));
            oReport.setsContextPath ( request.getScheme() + "://" + request.getHeader("host"));
            oReport.addImage        ("logo", getServletContext ().getRealPath("/images/logos/logo_beneficio_new.jpg"));
            
// datos del certificado
            oReport.addlObj("C_NUM_POLIZA", Formatos.showNumPoliza(oPol.getnumPoliza()));
            oReport.addlObj("C_RAMA", oPol.getdescRama());           
 
            oReport.addlObj("C_SUB_RAMA", oPol.getdescSubRama ());
            oReport.addlObj("C_FECHA_FTP", (oPol.getfechaFTP() == null ? " " : Fecha.showFechaForm(oPol.getfechaFTP() ))); 
            
            LinkedList lAsegurados = oPol.getDBAsegurados(dbCon); 
            
            oReport.addIniTabla("TABLA_ASEGURADOS");                
            
            if (lAsegurados != null ) {

                String sStyle[] = {"ItemCobL", "ItemCob", "ItemCob", "ItemCob", "ItemCobR"};
                for (int i = 0; i< lAsegurados.size();i++) {
                    Asegurado oAseg = (Asegurado) lAsegurados.get(i);
                    StringBuilder oNom = new StringBuilder();
                    oNom.append(oAseg.getcertificado()).append( ".").append(oAseg.getsubCertificado());
                    oNom.append(" - ").append(oAseg.getnombre());
                    String sElem [] = { oNom.toString(), (oAseg.getdescTipoDoc() + " " + oAseg.getnumDoc()) ,
                                        (oAseg.getdFechaNac() == null ? " " : Fecha.showFechaForm(oAseg.getdFechaNac())),
                                        (oAseg.getfechaAltaCob() == null ? " " : Fecha.showFechaForm(oAseg.getfechaAltaCob())),
                                        String.valueOf(oAseg.getendosoAlta())};
                    oReport.addElementsTabla(sElem, sStyle); 
                }
            }
            oReport.addFinTabla();            
            
            request.setAttribute("oReport", oReport );
            doForward (request,response, "/servlet/ReportPdf");  

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void getPrintNominaHTML (HttpServletRequest request, HttpServletResponse response, Poliza oPol)
    throws ServletException, IOException, SurException {
        Connection dbCon        = null;
        LinkedList lAsegurados  = new LinkedList ();
        try {
            dbCon = db.getConnection();
           
            if (oPol.getDBExiste(dbCon)) {
                oPol.getDB(dbCon);
                
                if (oPol.getiNumError() != 0) {
                    throw new SurException (oPol.getsMensError());
                }
                lAsegurados = oPol.getDBAsegurados(dbCon);
                
                if (oPol.getiNumError() == -1) {
                    throw  new SurException(oPol.getsMensError());
                }
                
                request.setAttribute("poliza", oPol);
                request.setAttribute("asegurados", lAsegurados);

                doForward (request, response, "/consulta/report/nominaHTML.jsp");
                
            } else {
                
                request.setAttribute("mensaje", "La póliza no existe en el sistema.\n\n Puede ser que la rama y/o el número de póliza sea incorrecto, \n pruebe sin ingresar el digito verificador.");
                request.setAttribute("volver", "-1");
                doForward(request, response, "/include/MsjHtmlServidor.jsp");
            }
            

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }


    protected void getPrintNominaXLS (HttpServletRequest request, HttpServletResponse response, Poliza oPol)
    throws ServletException, IOException, SurException {
        Connection        dbCon = db.getConnection();
        xls               oXls  = new xls (); 
        java.util.Date dFechaFtp          = null;
        try {
            if (! oPol.getDBExiste(dbCon) ) {
                request.setAttribute("mensaje", "La p&oacute;liza no existe en el sistema. \nVerifique que haya ingresado correctamente el n&uacute;mero sin el digito verificador");
                request.setAttribute("volver", "-1");
                doForward(request, response, "/include/MsjHtmlServidor.jsp");
            } else {
                oPol.getDB(dbCon);
                if (oPol.getiNumError() != 0) {
                    throw new SurException (oPol.getsMensError());
                }

                LinkedList lAseg = oPol.getDBAsegurados(dbCon);
                oXls.setTitulo("Nomina Asegurados"); 
                LinkedList lRow    = new LinkedList();
                lRow.add(" ");
                lRow.add(" ");
                lRow.add( "NOMINA  DE ASEGURADOS" );            
                oXls.setRows(lRow);
                
                lRow   = new LinkedList();
                lRow.add(" ");
                oXls.setRows(lRow);                

                lRow    = new LinkedList();            
                lRow.add(" ");
                lRow.add(" ");
                lRow.add( "Poliza: " + Formatos.showNumPoliza(oPol.getnumPoliza()));                            
                oXls.setRows(lRow);                                                   

                lRow    = new LinkedList();
                lRow.add(" ");
                lRow.add(" ");
                lRow.add( "Ramo: " +  oPol.getdescRama());
                oXls.setRows(lRow);                                                              
                
                lRow    = new LinkedList();
                lRow.add(" ");
                lRow.add(" ");
                lRow.add( "Cobertura: " +  oPol.getdescSubRama());
                oXls.setRows(lRow);                                                              

                lRow   = new LinkedList();
                lRow.add(" ");
                oXls.setRows(lRow);                
                
                lRow    = new LinkedList();
                lRow.add("ITEM");
                lRow.add("SUB_ITEM");
                lRow.add("ASEGURADO"); 
                lRow.add("TIPO");                 
                lRow.add("DOCUMENTO");
                lRow.add("NACIMIENTO");
                lRow.add("FECHA ALTA"); 
                lRow.add("END. ALTA");
                oXls.setRows(lRow);                                                              

                int cantidad = 0;
                for (int i=0; i < lAseg.size(); i++) { 
                    Asegurado oAseg = (Asegurado) lAseg.get(i);
                    dFechaFtp = oAseg.getfechaFTP();
                    cantidad += 1;
                    lRow   = new LinkedList();
                    lRow.add  (String.valueOf(oAseg.getcertificado()));
                    lRow.add  (String.valueOf(oAseg.getsubCertificado()));
                    lRow.add  (oAseg.getnombre());
                    lRow.add  (oAseg.getdescTipoDoc());
                    lRow.add  (oAseg.getnumDoc());
                    lRow.add  (oAseg.getdFechaNac() == null ? " " : Fecha.showFechaForm(oAseg.getdFechaNac()));
                    lRow.add  (oAseg.getfechaAltaCob() == null ? " " : Fecha.showFechaForm(oAseg.getfechaAltaCob()));
                    lRow.add  (String.valueOf(oAseg.getendosoAlta()));                
                    oXls.setRows(lRow);
                }
                lRow   = new LinkedList();
                lRow.add(" ");
                oXls.setRows(lRow);                
                lRow   = new LinkedList();
                lRow.add(" ");
                lRow.add(" ");
                lRow.add("Cantidad de asegurados: " + cantidad);
                oXls.setRows(lRow);                

                lRow   = new LinkedList();
                lRow.add(" ");
                oXls.setRows(lRow);

                lRow   = new LinkedList();                
                lRow.add(" ");
                lRow.add(" ");
                if (dFechaFtp != null) { 
                    lRow.add("Ultima actualización: " + Fecha.showFechaForm(dFechaFtp));
                } else if (oPol.getfechaFTP() != null) {
                    lRow.add("Ultima actualización: " + Fecha.showFechaForm(oPol.getfechaFTP()));
                }
                oXls.setRows(lRow);                
                

                request.setAttribute("oReportXls", oXls);
                doForward( request, response, "/servlet/ReportXls");     
            }
            
        } catch (Exception se) {
            throw new SurException (se.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    } /* END -- exportarCarteraVigente */
    
    protected void getPrintEndoso (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon        = null;
        try {
            Usuario user = (Usuario) (request.getSession().getAttribute("user"));
            Poliza oPol =  new Poliza ();
            int iCodRama = Integer.parseInt (request.getParameter ("cod_rama"));
            int iNumPoliza = Integer.parseInt (request.getParameter ("num_poliza"));            
            int iEndoso  = Integer.parseInt (request.getParameter ("endoso"));                        
            
            dbCon = db.getConnection();
            oPol.getDB(dbCon);   
            
            if (oPol.getiNumError() != 0) {
                throw new SurException (oPol.getsMensError());
            }

            Report oReport = new Report ();
            oReport.setTitulo       ("Nómina actualizada de Asegurados");
            oReport.addlObj         ("subtitulo" , "Nómina actualizada de Asegurados");
            oReport.setUsuario      (user.getusuario());
            oReport.setFecha        (Fecha.toString(new java.util.Date ()));
            oReport.setFormulario   ("NOM001");
            oReport.setReportName   (getServletContext ().getRealPath("/consulta/report/nomina.xml"));
            oReport.setsContextPath ( request.getScheme() + "://" + request.getHeader("host"));
            oReport.addImage        ("logo", getServletContext ().getRealPath("/images/logos/logo_beneficio_new.jpg"));
            
// datos del certificado
            oReport.addlObj("C_NUM_POLIZA", Formatos.showNumPoliza(oPol.getnumPoliza()));
            oReport.addlObj("C_RAMA", oPol.getdescRama());           
 
            oReport.addlObj("C_SUB_RAMA", oPol.getdescSubRama ());
            oReport.addlObj("C_FECHA_FTP", (oPol.getfechaFTP() == null ? " " : Fecha.showFechaForm(oPol.getfechaFTP() ))); 
            
            LinkedList lAsegurados = oPol.getDBAsegurados(dbCon); 
            
            oReport.addIniTabla("TABLA_ASEGURADOS");                
            
            if (lAsegurados != null ) {

                String sStyle[] = {"ItemCobL", "ItemCob", "ItemCob", "ItemCobR"};                
                for (int i = 0; i< lAsegurados.size();i++) {
                    Asegurado oAseg = (Asegurado) lAsegurados.get(i);
                    StringBuilder oNom = new StringBuilder();
                    oNom.append(oAseg.getcertificado()).append(".").append(oAseg.getsubCertificado()).append(" - ").append(oAseg.getnombre());
                    String sElem [] = {oNom.toString() ,
                                    (oAseg.getdescTipoDoc() + " " + oAseg.getnumDoc()) ,
                                    (oAseg.getfechaAltaCob() == null ? " " : Fecha.showFechaForm(oAseg.getfechaAltaCob())),
                                    String.valueOf(oAseg.getendosoAlta())};
                    oReport.addElementsTabla(sElem, sStyle); 
                }
            }
            oReport.addFinTabla();            
            
            request.setAttribute("oReport", oReport );
            doForward (request,response, "/servlet/ReportPdf");  

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }
    
    protected void getLibroEmision (HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException , SurException{

      try {
            java.util.Date dFechaDesde = Fecha.strToDate(request.getParameter("fecha_desde"));
            java.util.Date dFechaHasta = Fecha.strToDate(request.getParameter("fecha_hasta"));
            int iCodProd               = Integer.parseInt (request.getParameter("cod_prod"));

            String pathFileAbs    = this.getServletConfig().getServletContext().getRealPath("/files/libros/") ;

            String nameFile       = "/libro_" + iCodProd + ".csv";

            this.generarArchivo (dFechaDesde, dFechaHasta , iCodProd, pathFileAbs + nameFile) ;

            request.setAttribute("nameFile" , nameFile);

            doForward (request, response,"/consulta/formSubdiario.jsp");

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        }
    } /* genArchivoCertifProp */

    private void generarArchivo (java.util.Date dFechaDesde,
                                 java.util.Date dFechaHasta , int iCodProd,
                                 String path) throws SurException {
        CallableStatement  cons = null;
        ResultSet          rs   = null;
        FileOutputStream   fos  = null;
        OutputStreamWriter osw  = null;
        BufferedWriter     bw   = null;
        boolean bPrimeraFila    = true;
        Connection dbCon = null;
        try {
            fos  = new FileOutputStream (path);
            osw  = new OutputStreamWriter (fos, "UTF-8");
            bw   = new BufferedWriter (osw);

            String  cabecera = "Rama\tPoliza\tEndoso\tF.Emision\tDniTomador\tCuitTomador\tTipoPersona\tTomador\tDomicilio\tUbicacion Riesgo\t" +
                               "Objeto Asegurado\tCobertura\tSuma Aseg.\tF.Desde\tF.Hasta\tObservacion\tPrima\tPremio\n" ;

            dbCon                 = db.getConnection();
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall (db.getSettingCall("LIB_GET_ALL_EMISION (?, ?, ?)"));
            cons.registerOutParameter( 1 , java.sql.Types.OTHER);
            cons.setDate    (2 , Fecha.convertFecha(dFechaDesde));
            cons.setDate    (3 , Fecha.convertFecha(dFechaHasta));
            cons.setInt     (4, iCodProd);
            cons.execute();

            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    if ( bPrimeraFila ) {
                        bw.write(cabecera);
                        bPrimeraFila = false;
                    }
//                   System.out.println (rs.getString ("CAMPO"));
                    bw.write (rs.getString ("CAMPO") + "\n");
                }
                rs.close();
            }

            bw.flush();
            bw.close();
            osw.close();
            fos.close();
            cons.close();

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (bw   != null) bw.close();
                if (osw  != null) osw.close();
                if (fos  != null) fos.close();
                if (rs   != null) rs.close();
                if (cons != null) cons.close();
                dbCon.close();
            } catch (Exception se) {
                throw new SurException (se.getMessage());
            }
        }
    } /* generarArchivo */

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


