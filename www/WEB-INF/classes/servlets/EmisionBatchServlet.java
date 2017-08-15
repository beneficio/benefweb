/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package servlets;

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
import com.business.beans.LoteEmision;
import com.business.beans.LoteEmisionDetalle;
import com.business.beans.Usuario;
import com.business.util.*;
import com.business.db.*;
import java.io.*;    
/**
 *
 * @author Rolando Elisii
 */
public class EmisionBatchServlet extends HttpServlet {
   
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

            if (op.equals ("agregarLote")) {
                AgregarLote (request, response);
            } else  if (op.equals ("getAllLotes")) {
                getAllLotes (null , request, response);
            } else if (op.equals ("validar")) {
                ValidarArchivo ( request, response);
            } else if (op.equals ("procesarLote")) {
                ProcesarLote ( request, response);
            } else  if (op.equals ("getAllDetalle") || op.equals ("ver")) {
                getAllDetalle ( request, response);
            } else  if (op.equals ("anular")) {
                anularLote ( request, response);
            } else  if (op.equals ("anularProp")) {
                anularPropuesta ( request, response);
            } else  if (op.equals ("enviarLote")) {
                enviarLote ( request, response);
            } else  if (op.equals ("emitirPropOnLine")) {
                emitirPropOnLine(request, response);
            } else  if (op.equals ("actualizarLog")) {
                actualizarLog(request, response);
            }

         } catch (SurException se) {
            goToJSPError(request,response, se);
        } catch (Exception e) {
            goToJSPError(request,response, e);
        }
    }  

    protected void AgregarLote (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons  = null;
        try {
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            Diccionario oDicc = (Diccionario) (request.getSession().getAttribute("Diccionario"));
            int iLote    = (request.getParameter("F3lote_sel") == null ? -1 :
                            Integer.parseInt (request.getParameter("F3lote_sel")));

System.out.println ("iLote 1 en AgregarLote" + iLote);

            if (iLote == -1 ) {
                iLote    = oDicc.getInt  (request, "F3lote_sel");
            }

            LoteEmision oLote = new LoteEmision ();
            LinkedList lDetalle = new LinkedList ();

            if (iLote > 0 ) {
                dbCon = db.getConnection();
                oLote.setnumLote(iLote);
                oLote.getDB(dbCon);

                if (oLote.getiNumError() < 0) {
                    throw new SurException(oLote.getsMensError());
                }

                lDetalle = oLote.getDBAllDetalle(dbCon);
            }

            oDicc.add("F3lote_sel", String.valueOf (oLote.getnumLote()));
            request.setAttribute("lote", oLote);
            request.setAttribute("detalle", lDetalle);
            doForward(request, response, "/emisionBatch/nuevoLote.jsp");

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

    protected void ProcesarLote (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons  = null;
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            int iLote    = Integer.parseInt (request.getParameter("F3lote_sel"));

            dbCon = db.getConnection();
            LoteEmision oLote = new LoteEmision ();
            oLote.setnumLote(iLote);
            oLote.setuserId(oUser.getusuario());
            oLote.getDB (dbCon);

            if (oLote.getiNumError() < 0) {
                throw new SurException(oLote.getsMensError());
            } else {
                if ( oLote.gettipoLote() != null && oLote.gettipoLote().equals("R")) {
                    oLote.setsPathAbsoluto(this.getServletContext().getRealPath("/files/trans/renovar/"));
                    oLote.setDBRenovar(dbCon);
                } else {
                    oLote.setDBEmitir(dbCon);
                }
                request.setAttribute("lote", oLote);
                request.setAttribute("estado", "procesado");
                doForward(request, response, "/emisionBatch/nuevoLote.jsp");
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

    protected void enviarLote (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons  = null;
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            int iLote           = Integer.parseInt (request.getParameter ("F3lote_sel"));

System.out.println ("En enviar Lote " + iLote);
            dbCon = db.getConnection();
            LoteEmision oLote = new LoteEmision ();
            oLote.setnumLote(iLote);
            oLote.getDB (dbCon);

System.out.println ("antes de enviar lote - cant errores: " + oLote.getcantErrores());

            if (oLote.getiNumError() < 0) {
                throw new SurException(oLote.getsMensError());
            } else {
                int cantErrores = oLote.setDBEnviarLote(dbCon);

                oLote.setcantErrores( oLote.getcantErrores() + cantErrores);

System.out.println ("despues de enviar lote - cant errores: " + oLote.getcantErrores());
  
                oLote.setDB(dbCon);

                if (cantErrores > 0 ) {
                    oLote.setsPathAbsoluto(this.getServletContext().getRealPath("/files/trans/renovar/"));
                    oLote.setActualizarLog(dbCon);
                }
                request.setAttribute("lote", oLote);
                request.setAttribute("estado", "procesado");
                doForward(request, response, "/emisionBatch/nuevoLote.jsp");
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

    protected void actualizarLog (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons  = null;
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            int iLote           = Integer.parseInt (request.getParameter ("F3lote_sel"));
            String sVolver      = (request.getParameter ("volver") == null ? "-1" :
                                   request.getParameter ("volver"));

System.out.println ("actualizarLog" + iLote);

            dbCon = db.getConnection();
            LoteEmision oLote = new LoteEmision ();
            oLote.setnumLote(iLote);
            oLote.setuserId(oUser.getusuario());
            oLote.getDB (dbCon);

            if (oLote.getiNumError() < 0) {
                throw new SurException(oLote.getsMensError());
            } else {

System.out.println ("antes de actualizar log");
                oLote.setsPathAbsoluto(this.getServletContext().getRealPath("/files/trans/renovar/"));
                oLote.setActualizarLog(dbCon);

                LinkedList lDetalle = oLote.getDBAllDetalle(dbCon);

System.out.println ("lDetlle " + lDetalle.size());

                request.setAttribute("lote", oLote);
                request.setAttribute("detalle", lDetalle);
                request.setAttribute("volver", sVolver);

                doForward(request, response, "/emisionBatch/LoteDetalle.jsp");
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

    protected void ValidarArchivo (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons  = null;
        FileReader fr       = null;
        BufferedReader br   = null;
        String  separador   = ";";
        String  _fileRenovar = "/opt/tomcat/webapps/benef/files/trans/renovar/";
        String  _fileEmitir  = "/opt/tomcat/webapps/benef/files/trans/emitir/emitir.csv";


        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            Diccionario oDicc   = (Diccionario) (request.getSession().getAttribute("Diccionario"));
            int iLote           = oDicc.getInt  (request, "F3lote_sel");

            System.out.println ("en validarLote  - lote:" + iLote);

            String sTitulo      = request.getParameter ("titulo");
            String tipoEmision  = request.getParameter ("tipo_emision");

            String osName = System.getProperty("os.name" );
            if ( osName.contains("Windows")) {
                _fileRenovar ="C:\\benefweb\\www\\files\\trans\\renovar\\";
                _fileEmitir  ="C:\\benefweb\\www\\files\\trans\\emitir\\emitir.csv";
            }

            if (iLote == 0) {
                _fileRenovar = _fileRenovar + "renovar_" + oUser.getusuario() + ".csv";
            } else {
                _fileRenovar = _fileRenovar + "renovar_" + iLote + ".csv";
            }

System.out.println ("_fileRenovar:" + _fileRenovar);

            LinkedList lDetalle = new LinkedList ();
            int cantLeidos      = 0;
            int cantErrores     = 0;

            dbCon = db.getConnection();
            LoteEmision oLote = new LoteEmision ();
            oLote.setnumLote(iLote);
            oLote.settitulo(sTitulo);
            oLote.settipoLote(tipoEmision);
            oLote.setuserId(oUser.getusuario());

            if (oLote.gettipoLote().equals("R")) {
               File fRenovar = new File(_fileRenovar );
               if( !fRenovar.isFile() || ! fRenovar.exists()){
                   oLote.setcodEstado (2);
                   oLote.setobservacion("Archivo inexistente");
                } else {
                    fr = new FileReader (fRenovar);
                    br = new BufferedReader(fr);
// Lectura del fichero
                    String linea;
                    while((linea=br.readLine())!=null) {
                        String [] datos = linea.split (";") ;
                        LoteEmisionDetalle oDet = new LoteEmisionDetalle ();

                        if ( ! ( datos[0].matches("[0-9]*") &&
                            datos[1].matches("[0-9]*") &&
                            datos[2].matches("[0-9]*") ) ) {
                            if ( cantLeidos == 0 ) {
                                continue;
                            } else {
                                oDet.setestadoProp(2);
                                oDet.setobservacion(linea + "--> RAMA;POLIZA;CANT_VIDAS  NO NUMERICO");
                                cantErrores = cantErrores + 1;
                            }
                        } else {
                            int iCodRama    = Integer.parseInt (datos[0]);
                            int iPolizaAnt  = Integer.parseInt (datos[1]);
                            int iCantVidas  = Integer.parseInt (datos[2]);

                            if ( ! (iCodRama == 10 || iCodRama == 18 || iCodRama == 21 || iCodRama == 22 || iCodRama == 23 || iCodRama == 24 || iCodRama == 25 ) ) {
                                oDet.setestadoProp(2);
                                oDet.setobservacion(linea + "--> RAMA INVALIDA");
                                cantErrores = cantErrores + 1;
                            }
                            if ( ! (iPolizaAnt >= 1 && iPolizaAnt <= 999999 )) {
                                oDet.setestadoProp(2);
                                oDet.setobservacion(linea + "--> POLIZA INVALIDA");
                                cantErrores = cantErrores + 1;
                            }
                            if ( iCantVidas == 0  ) {
                                oDet.setestadoProp(2);
                                oDet.setobservacion(linea + "--> CANTIDAD DE VIDAS CERO");
                                cantErrores = cantErrores + 1;
                            }
                            if ( iCantVidas >= 99999  ) {
                                oDet.setestadoProp(2);
                                oDet.setobservacion(linea + "--> CANTIDAD DE VIDAS MAYOR A 99999");
                                cantErrores = cantErrores + 1;
                            }

                        }
                        if ( oDet.getestadoProp() == 2) {
                            System.out.println (oDet.getobservacion());
                           
                            lDetalle.add(oDet);
                        }
                        cantLeidos = cantLeidos + 1;
                    }

                    if (cantErrores > 0 ) {
                        oLote.setcodEstado(2);
                    }
                    oLote.setcantErrores(cantErrores);
                    oLote.setcantRegistros(cantLeidos);
                }

               oLote.setDB(dbCon);

               if (iLote == 0 ) {
                   fRenovar.renameTo(new File (_fileRenovar.replace(oUser.getusuario(), String.valueOf(oLote.getnumLote()))));
               }
               
            } else {  
                if (oLote.gettipoLote().equals("P")) {

                    File fEmitir = new File(_fileEmitir );
                    if( !fEmitir.isFile() || ! fEmitir.exists()){
                        oLote.setcodEstado (2);
                        oLote.setobservacion("Archivo inexistente");
                     }
                    oLote.setDB(dbCon);
                    if (oLote.getiNumError() < 0 ) {
                        throw new SurException( oLote.getsMensError());
                    }
                    oLote.setDBValidarEmision(dbCon);
                    if (oLote.getiNumError() < 0 ) {
                         throw new SurException( (oLote.getsMensError()));
                    }
                    lDetalle = oLote.getDBAllDetalle(dbCon);
                } else {
                    System.out.println ("PROCESAR ENDOSOS DE CAMBIO DE CONDICIONES COMERCIALES");
                }
           }

            if (oLote.getiNumError() < 0 ) {
                request.setAttribute("mensaje",  oLote.getsMensError());
                request.setAttribute("volver", "-1");
                doForward (request, response, "/include/MsjHtmlServidor.jsp");
            } else {
                request.setAttribute("detalle",lDetalle);
                request.setAttribute("lote", oLote);
                doForward(request, response, "/emisionBatch/nuevoLote.jsp");
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

    protected void anularLote (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {

            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            int iLote           = Integer.parseInt (request.getParameter ("F3lote_sel"));

            dbCon = db.getConnection();
            LoteEmision oLote = new LoteEmision ();
            oLote.setnumLote(iLote);
            oLote.getDB(dbCon);

            oLote.setuserId(oUser.getusuario());
            oLote.setcodEstado(9);
            oLote.setDB(dbCon);

            if (oLote.getiNumError() < 0 ) {
                request.setAttribute("mensaje",  oLote.getsMensError());
                request.setAttribute("volver", "-1");
                doForward (request, response, "/include/MsjHtmlServidor.jsp");
            } else {
                doForward(request, response, "/servlet/EmisionBatchServlet?opcion=getAllLotes");
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void getAllDetalle (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons  = null;
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            Diccionario oDicc   = (Diccionario) (request.getSession().getAttribute("Diccionario"));
            int iLote           = oDicc.getInt  (request, "F3lote_sel");
            String sVolver      = (request.getParameter ("volver") == null ? "-1" : request.getParameter ("volver"));

            dbCon = db.getConnection();
            LoteEmision oLote = new LoteEmision ();
            oLote.setnumLote(iLote);
            oLote.getDB(dbCon);

            if (oLote.getiNumError() < 0) {
                throw new SurException(oLote.getsMensError());
            } else {
                LinkedList lDetalle = oLote.getDBAllDetalle(dbCon);
                
                request.setAttribute("lote", oLote);
                request.setAttribute("detalle", lDetalle);
                request.setAttribute("volver", sVolver);

                doForward(request, response, "/emisionBatch/LoteDetalle.jsp");
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

   protected void anularPropuesta (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons  = null;
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            Diccionario oDicc   = (Diccionario) (request.getSession().getAttribute("Diccionario"));
            int iLote           = oDicc.getInt  (request, "F3lote_sel");
            int iPropuesta      = Integer.parseInt (request.getParameter ("propuesta"));
            String sVolver      = (request.getParameter ("volver") == null ? "-1" : request.getParameter ("volver"));

            dbCon = db.getConnection();

            LoteEmisionDetalle oDet = new LoteEmisionDetalle ();
            oDet.setnumLote(iLote);
            oDet.setnumPropuesta(iPropuesta);
            oDet.setuserId(oUser.getusuario());
            oDet.setDBAnularProp(dbCon);
            if (oDet.getiNumError() < 0 ) {
                request.setAttribute("mensaje", oDet.getsMensError());
                request.setAttribute("volver",  Param.getAplicacion()+"servlet/EmisionBatchServlet?opcion=getAllDetalle&volver=" + sVolver);
                doForward (request, response, "/include/MsjHtmlServidor.jsp");
            } else {
                doForward(request, response, "/servlet/EmisionBatchServlet?opcion=getAllDetalle&volver=" + sVolver);
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

   protected void emitirPropOnLine  (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons  = null;
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            Diccionario oDicc   = (Diccionario) (request.getSession().getAttribute("Diccionario"));
            int iLote           = oDicc.getInt  (request, "F3lote_sel");
            int iPropuesta      = Integer.parseInt (request.getParameter ("propuesta"));
            String sVolver      = (request.getParameter ("volver") == null ? "-1" : request.getParameter ("volver"));

            dbCon = db.getConnection();

            LoteEmisionDetalle oDet = new LoteEmisionDetalle ();
            oDet.setnumLote(iLote);
            oDet.setnumPropuesta(iPropuesta);
            oDet.setuserId(oUser.getusuario());
            oDet.setDBEmitirPropOnLine (dbCon);
            if (oDet.getiNumError() < 0 ) {
                request.setAttribute("mensaje", oDet.getsMensError());
                request.setAttribute("volver",  Param.getAplicacion()+"servlet/EmisionBatchServlet?opcion=getAllDetalle&volver=" + sVolver);
                doForward (request, response, "/include/MsjHtmlServidor.jsp");
            } else {
                doForward(request, response, "/servlet/EmisionBatchServlet?opcion=getAllDetalle&volver=" + sVolver);
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

    protected void getAllLotes (Connection dbCon, HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        CallableStatement cons  = null;
        ResultSet rs = null;
        LinkedList lLotes = new LinkedList ();
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            Diccionario oDicc   = (Diccionario) (request.getSession().getAttribute("Diccionario"));

            String sTitulo      = oDicc.getString (request, "F3titulo");
            String sNumDocTom   = oDicc.getString (request, "F3num_doc_tom");
            int iLote           = oDicc.getInt  (request, "F3lote");
            int iPolizaAnterior = oDicc.getInt  (request, "F3poliza_anterior");
            int iNumPoliza      = oDicc.getInt (request, "F1num_poliza");
            int iNumPropuesta   = oDicc.getInt (request, "F3num_propuesta");
            int iCodRama        = oDicc.getInt (request, "F1cod_rama");
            Date dFechaDesde    = oDicc.getDate (request, "F3fecha_desde");
            Date dFechaHasta    = oDicc.getDate (request, "F3fecha_hasta");
            int iCurrentPage    = oDicc.getInt (request, "pager.offset");

            dbCon = db.getConnection();
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("EMI_BATCH_GET_ALL_LOTES (?,?,?,?,?,?,?,?, ?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            if ( iLote  == 0 ) {
                cons.setNull    (2, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (2, iLote );
            }
            if (sTitulo.equals ("") ) {
                cons.setNull    (3, java.sql.Types.VARCHAR);
            } else {
                cons.setString  (3, sTitulo);
            }
            if ( iNumPoliza  == 0 ) {
                cons.setNull    (4, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (4, iNumPoliza );
            }
            if ( iPolizaAnterior == 0 ) {
                cons.setNull    (5, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (5, iPolizaAnterior);
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
            if (sNumDocTom.equals ("") ) {
                cons.setNull    (9, java.sql.Types.VARCHAR);
            } else {
                cons.setString  (9, sNumDocTom);
            }
            cons.setString (10, oUser.getusuario());
            if ( iNumPropuesta == 0 ) {
                cons.setNull    (11, java.sql.Types.INTEGER);
            } else {
                cons.setInt     (11, iNumPropuesta);
            }

            cons.execute();
            rs = (ResultSet) cons.getObject(1);

            if (rs != null) {
                while (rs.next()) {
                    LoteEmision oLote = new LoteEmision ();
                    oLote.setnumLote        (rs.getInt("NUM_LOTE"));
                    oLote.setnumPolizaAnt   (rs.getInt("POLIZA_ANTERIOR"));
                    oLote.setminNumPolizaAnt(rs.getInt("MIN_POLIZA_ANTERIOR"));
                    oLote.setcodEstado      (rs.getInt("ESTADO"));
                    oLote.setnumPoliza      (rs.getInt("NUM_POLIZA"));
                    oLote.setminNumPoliza   (rs.getInt("MIN_NUM_POLIZA"));
                    oLote.setcodRama        (rs.getInt("COD_RAMA"));
                    oLote.setnumPropuesta   (rs.getInt ("NUM_PROPUESTA"));
                    oLote.setminNumPropuesta(rs.getInt ("MIN_NUM_PROPUESTA"));
                    oLote.setfechaTrabajo   (rs.getDate ("FECHA_TRABAJO"));
                    oLote.setobservacion    (rs.getString ("OBSERVACIONES"));
                    oLote.setnumDocTom      (rs.getString ("NUM_DOC_TOM"));
                    oLote.setminNumDocTom   (rs.getString ("MIN_NUM_DOC_TOM"));
                    oLote.settitulo         (rs.getString ("TITULO"));
                    oLote.setcantRegistros  (rs.getInt ("CANT_REGISTROS"));
                    oLote.setcantErrores    (rs.getInt ("CANT_ERRORES"));
                    oLote.setcantProcesados (rs.getInt ("CANT_PROCESADOS"));
                    oLote.setdescEstadoLote (rs.getString ("DESC_ESTADO"));
                    
                    lLotes.add    (oLote);
                }
                rs.close ();
            }
            cons.close();

            request.setAttribute("lotes", lLotes);
            doForward(request, response, "/emisionBatch/filtrarLote.jsp?pager.offset=" + iCurrentPage);
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
/*
    protected void getAllLotesXLS (Connection dbCon, HttpServletRequest request, HttpServletResponse response)
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
                this.getAllLotes(dbCon, request, response);
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
            request.setAttribute("volver",  Param.getAplicacion()+"servlet/RenuevaServlet?opcion=getAllLotes");
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
