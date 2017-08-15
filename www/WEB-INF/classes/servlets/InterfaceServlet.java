/*
 * setAccess.java
 *
 * Created on 14 de enero de 2005, 17:46
 */

package servlets;
    
import java.io.*;
import java.util.Hashtable;
import java.text.SimpleDateFormat;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;

import javax.servlet.*;
import javax.servlet.http.*;

import com.business.beans.Usuario;
import com.business.beans.IntPropuestas;
import com.business.util.*;
import com.business.db.*;
import sun.net.ftp.*;
import sun.net.*;
/**
 *
 * @author  surprogra
 * @version
 */
public class InterfaceServlet extends HttpServlet {
    
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
        String op =  request.getParameter ("opcion");
        
        if (op.equals ("runInterface")) {
    //       runInterface (request,response);
            new Exception ("Interface anulada");
        } else if (op.equals ("cambiarEstado")) {
           cambiarEstado (request,response);  
        } else if (op.equals ("interGestion")) {
           interfaceGestion (request,response);
        } else if (op.equals ("desbloquearCtaCte")) {
           desbloquearCtaCte (request,response);
        }
        
      } catch (SurException se) {
          goToJSPError (request,response, se);
      } catch (Exception e) {
          goToJSPError(request, response, e);
      }
    }


    public void interfaceGestion (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
       try {

           String sSistema = request.getParameter ("sistema");

           if (sSistema.equals("PRODIGAL")) {
               interfaceProdigal  (request, response);
           } else if (sSistema.equals("KIMN")) {
               interfaceKimn  (request, response);
           } else if (sSistema.equals("GS")) {
               interfaceSistemaGS  (request, response);
           }
        } catch (Exception e) {
            throw new SurException ("PINCHO EN InterfaceServlet[interfaceGestion]: " + e.getMessage());
        }
    }

    public void interfaceProdigal (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
       Connection dbCon = null;
       CallableStatement cons  = null;
       ResultSet rs = null;
       StringBuilder sPath = new StringBuilder();
       StringBuilder sPathDestino = new StringBuilder ();
       StringBuilder sArchivo = new StringBuilder();
       int iRegistros   = 0;
       try {

           String fechaDesde = (request.getParameter ("fecha_desde")==null)?"":
                                request.getParameter ("fecha_desde");
           String fechaHasta = (request.getParameter ("fecha_hasta")==null)?"":
                                request.getParameter ("fecha_hasta");

           int  codProd      = Integer.parseInt (request.getParameter("cod_prod"));

            if (! fechaHasta.equals("")) {
                Fecha.strToDate( fechaHasta );
                String DATE_FORMAT = "yyyyMMdd";
                SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
                sPath.append("/files/intGestion/"); 
                sArchivo.append("TRAN555-").append(codProd).append("-").append( sdf.format(Fecha.strToDate( fechaHasta )));
                sPath.append(sArchivo.toString());
                sPathDestino.append(sPath.toString());

                sPath.append(".txt");
            }

           FileOutputStream fos = new FileOutputStream (getServletContext().getRealPath(sPath.toString()));
           OutputStreamWriter osw = new OutputStreamWriter (fos); //, "8859_1");
           BufferedWriter bw = new BufferedWriter (osw);

           dbCon = db.getConnection();
           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall(db.getSettingCall("INT_KIMN_PRODIGAL (?, ?,?,?)"));
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setString   (2, "PRODIGAL");
           cons.setInt      (3, codProd);
           cons.setDate     (4, Fecha.convertFecha(Fecha.strToDate( fechaDesde )));
           cons.setDate     (5, Fecha.convertFecha(Fecha.strToDate( fechaHasta )));
           cons.execute();

           rs = (ResultSet) cons.getObject(1);
           if (rs != null) {
                while (rs.next()) {
                    bw.write(rs.getString ("CAMPO"));
                    iRegistros += 1;
                }
                rs.close();
            }
           cons.close();

           cons = dbCon.prepareCall(db.getSettingCall("INT_KIMN_PRODIGAL_TEXTOS (?, ?, ?, ?)"));
           cons.registerOutParameter(1, java.sql.Types.OTHER);
           cons.setString   (2, "PRODIGAL");
           cons.setInt      (3, codProd);
           cons.setDate     (4, Fecha.convertFecha(Fecha.strToDate( fechaDesde )));
           cons.setDate     (5, Fecha.convertFecha(Fecha.strToDate( fechaHasta )));
           cons.execute();

           rs = (ResultSet) cons.getObject(1);
           if (rs != null) {
                while (rs.next()) {
                    bw.write(rs.getString ("CAMPO"));
                    iRegistros += 1;
                }
                rs.close();
            }
           cons.close();

            bw.flush();
            bw.close();
            osw.close();
            fos.close();

            if (iRegistros > 0) {

               Comprimir.crearZip(getServletContext().getRealPath(sPath.toString()),
                              getServletContext().getRealPath(sPathDestino.toString()),
                              Comprimir.Extension.ZIP );
            }

            request.setAttribute("sistema", "PRODIGAL" );
            request.setAttribute("error", "ok" );
            request.setAttribute("archivo", sArchivo.append(".zip").toString() );
            doForward (request, response, "/usuarios/formInterfacesProd.jsp");

        } catch (Exception e) {
            throw new SurException ("PINCHO EN interfaceProdigal: " + e.getMessage());

        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
    }

    public void interfaceKimn (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
       Connection dbCon = null;
       CallableStatement cons  = null;
       ResultSet rs = null;
       StringBuilder sPath = new StringBuilder();
       StringBuilder sArchivoOperaciones = new StringBuilder();
       StringBuilder sArchivoItems      = new StringBuilder();
       StringBuilder sArchivoNomina     = new StringBuilder();
       StringBuilder sArchivoCobranza   = new StringBuilder();
       StringBuilder sArchivoCoberturas = new StringBuilder();
       StringBuilder sArchivoCuotas     = new StringBuilder();
       int iRegistrosEmi    = 0;
       int iRegistrosCob    = 0;
       int iLote             = 0;
       try {

           String fechaDesde = (request.getParameter ("fecha_desde")==null)?"":
                                request.getParameter ("fecha_desde");
           String fechaHasta = (request.getParameter ("fecha_hasta")==null)?"":
                                request.getParameter ("fecha_hasta");

           int  codProd      = Integer.parseInt (request.getParameter("cod_prod"));

           String sTipo      = request.getParameter ("tipo");


            if (! fechaHasta.equals("")) {
                Fecha.strToDate( fechaHasta );
                String DATE_FORMAT = "yyyyMMdd";
                SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);

                try {
                   dbCon = db.getConnection();
                   dbCon.setAutoCommit(false);
                   cons = dbCon.prepareCall(db.getSettingCall("INT_EXT_ARMAR_LOTE (?, ?,?,?, ?)"));
                   cons.registerOutParameter(1, java.sql.Types.INTEGER);
                   cons.setString   (2, "KIMN");
                   cons.setInt      (3, codProd);
                   cons.setDate     (4, Fecha.convertFecha(Fecha.strToDate( fechaDesde )));
                   cons.setDate     (5, Fecha.convertFecha(Fecha.strToDate( fechaHasta )));
                   cons.setString   (6, sTipo);

                   cons.execute();

                   iLote = cons.getInt (1);
                } catch (SQLException se) {
                    throw new SurException( "Pincho en INT_EXT_KIMN_ARMAR_LOTE: " + se.getMessage());
                }

                sPath.append("/files/intGestion/");
                if ( sTipo.equals("EMI") || sTipo.equals("ALL") ) { // SOLO EMISION O TODOS
                    sArchivoOperaciones.append(sPath).append("OPERACIONES-").append(iLote).append("-").append(codProd).append("-").append( sdf.format(Fecha.strToDate( fechaHasta ))).append(".TXT");
                    sArchivoItems.append(sPath).append("ITEMS-").append(iLote).append("-").append(codProd).append("-").append( sdf.format(Fecha.strToDate( fechaHasta ))).append(".TXT");
                    sArchivoNomina.append(sPath).append("NOMINA-").append(iLote).append("-").append(codProd).append("-").append( sdf.format(Fecha.strToDate( fechaHasta ))).append(".TXT");
                    sArchivoCoberturas.append(sPath).append("COBERTURAS-").append(iLote).append("-").append(codProd).append("-").append( sdf.format(Fecha.strToDate( fechaHasta ))).append(".TXT");
                    sArchivoCuotas.append(sPath).append("CUOTAS-").append(iLote).append("-").append(codProd).append("-").append( sdf.format(Fecha.strToDate( fechaHasta ))).append(".TXT");

                    try {
                        FileOutputStream fos1 = new FileOutputStream (getServletContext().getRealPath(sArchivoOperaciones.toString()));
                        OutputStreamWriter osw1 = new OutputStreamWriter (fos1); //, "8859_1");
                        BufferedWriter bw1 = new BufferedWriter (osw1);

                        dbCon.setAutoCommit(false);
                        cons = dbCon.prepareCall(db.getSettingCall("INT_EXT_KIMN_OPERACIONES (?)"));
                        cons.registerOutParameter(1, java.sql.Types.OTHER);
                        cons.setInt      (2, iLote);

                        cons.execute();

                        rs = (ResultSet) cons.getObject(1);
                        if (rs != null) {
                            while (rs.next()) {
                                bw1.write(rs.getString ("CAMPO"));
                                iRegistrosEmi += 1;
                            }
                            rs.close();
                        }
                        cons.close();

                        bw1.flush();
                        bw1.close();
                        osw1.close();
                        fos1.close();
                    } catch (Exception e1) {
                        throw new SurException( "Pincho en OPERACIONES: " + e1.getMessage());
                    }


                   if (iRegistrosEmi > 0 ) {
                       try {
                           FileOutputStream fos2 = new FileOutputStream (getServletContext().getRealPath(sArchivoItems.toString()));
                           OutputStreamWriter osw2 = new OutputStreamWriter (fos2); //, "8859_1");
                           BufferedWriter bw2 = new BufferedWriter (osw2);

                           dbCon.setAutoCommit(false);
                           cons = dbCon.prepareCall(db.getSettingCall("INT_EXT_KIMN_ITEMS (?)"));
                           cons.registerOutParameter(1, java.sql.Types.OTHER);
                           cons.setInt      (2, iLote);

                           cons.execute();

                           rs = (ResultSet) cons.getObject(1);
                           if (rs != null) {
                                while (rs.next()) {
                                    bw2.write(rs.getString ("CAMPO"));
                                }
                                rs.close();
                            }
                           cons.close();
                           bw2.flush();
                           bw2.close();
                           osw2.close();
                           fos2.close();
                        } catch (Exception e2) {
                            throw new SurException( "Pincho en ITEMS: " + e2.getMessage());
                        }

                       try {
                           FileOutputStream fos3 = new FileOutputStream (getServletContext().getRealPath(sArchivoNomina.toString()));
                           OutputStreamWriter osw3 = new OutputStreamWriter (fos3); //, "8859_1");
                           BufferedWriter bw3 = new BufferedWriter (osw3);

                           dbCon.setAutoCommit(false);
                           cons = dbCon.prepareCall(db.getSettingCall("INT_EXT_KIMN_NOMINA (?)"));
                           cons.registerOutParameter(1, java.sql.Types.OTHER);
                           cons.setInt      (2, iLote);

                           cons.execute();

                           rs = (ResultSet) cons.getObject(1);
                           if (rs != null) {
                                while (rs.next()) {
                                    bw3.write(rs.getString ("CAMPO"));
                                }
                                rs.close();
                            }
                           cons.close();
                           bw3.flush();
                           bw3.close();
                           osw3.close();
                           fos3.close();
                        } catch (Exception e3) {
                            throw new SurException( "Pincho en NOMINA: " + e3.getMessage());
                        }

                       try {
                           FileOutputStream fos4 = new FileOutputStream (getServletContext().getRealPath(sArchivoCoberturas.toString()));
                           OutputStreamWriter osw4 = new OutputStreamWriter (fos4); //, "8859_1");
                           BufferedWriter bw4 = new BufferedWriter (osw4);

                           dbCon.setAutoCommit(false);
                           cons = dbCon.prepareCall(db.getSettingCall("INT_EXT_KIMN_COBERTURAS (?)"));
                           cons.registerOutParameter(1, java.sql.Types.OTHER);
                           cons.setInt      (2, iLote);

                           cons.execute();

                           rs = (ResultSet) cons.getObject(1);
                           if (rs != null) {
                                while (rs.next()) {
                                    bw4.write(rs.getString ("CAMPO"));
                                }
                                rs.close();
                            }
                           cons.close();
                           bw4.flush();
                           bw4.close();
                           osw4.close();
                           fos4.close();
                        } catch (Exception e4) {
                            throw new SurException( "Pincho en COBERTURAS: " + e4.getMessage());
                        }

                       try {
                           FileOutputStream fos5 = new FileOutputStream (getServletContext().getRealPath(sArchivoCuotas.toString()));
                           OutputStreamWriter osw5 = new OutputStreamWriter (fos5); //, "8859_1");
                           BufferedWriter bw5 = new BufferedWriter (osw5);

                           dbCon.setAutoCommit(false);
                           cons = dbCon.prepareCall(db.getSettingCall("INT_EXT_KIMN_CUOTAS (?)"));
                           cons.registerOutParameter(1, java.sql.Types.OTHER);
                           cons.setInt      (2, iLote);

                           cons.execute();

                           rs = (ResultSet) cons.getObject(1);
                           if (rs != null) {
                                while (rs.next()) {
                                    bw5.write(rs.getString ("CAMPO"));
                                }
                                rs.close();
                            }
                           cons.close();
                           bw5.flush();
                           bw5.close();
                           osw5.close();
                           fos5.close();
                        } catch (Exception e5) {
                            throw new SurException( "Pincho en CUOTAS: " + e5.getMessage());
                        }
                    }

                }

                if (sTipo.equals ("COB") || sTipo.equals ("ALL")) {
                    try {
                       sArchivoCobranza.append(sPath).append("COBRANZA-").append(iLote).append("-").append(codProd).append("-").append( sdf.format(Fecha.strToDate( fechaHasta ))).append(".TXT");
                       FileOutputStream fos6 = new FileOutputStream (getServletContext().getRealPath(sArchivoCobranza.toString()));
                       OutputStreamWriter osw6 = new OutputStreamWriter (fos6); //, "8859_1");
                       BufferedWriter bw6 = new BufferedWriter (osw6);

                       dbCon.setAutoCommit(false);
                       cons = dbCon.prepareCall(db.getSettingCall("INT_EXT_KIMN_COBRANZA (?)"));
                       cons.registerOutParameter(1, java.sql.Types.OTHER);
                       cons.setInt      (2, iLote);

                       cons.execute();

                       rs = (ResultSet) cons.getObject(1);
                       if (rs != null) {
                            while (rs.next()) {
                                bw6.write(rs.getString ("CAMPO"));
                                iRegistrosCob += 1;
                            }
                            rs.close();
                        }
                       cons.close();
                       bw6.flush();
                       bw6.close();
                       osw6.close();
                       fos6.close();
                    } catch (Exception e6) {
                        throw new SurException( "Pincho en COBRANZA: " + e6.getMessage());
                    }

                }
            }

            request.setAttribute("registros_emi", Integer.valueOf(iRegistrosEmi) );
            request.setAttribute("registros_cob", Integer.valueOf(iRegistrosCob) );
            request.setAttribute("operaciones", sArchivoOperaciones.toString().replace(("/files/intGestion"), "") );
            request.setAttribute("items", sArchivoItems.toString().replace(("/files/intGestion"), "") );
            request.setAttribute("nomina", sArchivoNomina.toString().replace(("/files/intGestion"), "") );
            request.setAttribute("coberturas", sArchivoCoberturas.toString().replace(("/files/intGestion"), "") );
            request.setAttribute("cuotas", sArchivoCuotas.toString().replace(("/files/intGestion"), "") );
            request.setAttribute("cobranza", sArchivoCobranza.toString().replace(("/files/intGestion"), "") );
            doForward (request, response, "/usuarios/formInterfacesProd.jsp?sistema=KIMN&tipo=" + sTipo);

        } catch (Exception e) {
            throw new SurException ("PINCHO EN interfaceKimn: " + e.getMessage());

        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
    }

    public void interfaceSistemaGS (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
       Connection dbCon = null;
       CallableStatement cons  = null;
       ResultSet rs = null;
       StringBuilder sPath = new StringBuilder();
       StringBuilder sArchivoOperaciones = new StringBuilder();
       StringBuilder sArchivoNomina     = new StringBuilder();
       StringBuilder sArchivoCobranza   = new StringBuilder();
       StringBuilder sArchivoCoberturas = new StringBuilder();
       StringBuilder sArchivoCuotas     = new StringBuilder();
       int iRegistrosEmi    = 0;
       int iRegistrosCob    = 0;
       int iLote             = 0;
       try {

           String fechaDesde = (request.getParameter ("fecha_desde")==null)?"":
                                request.getParameter ("fecha_desde");
           String fechaHasta = (request.getParameter ("fecha_hasta")==null)?"":
                                request.getParameter ("fecha_hasta");

           int  codProd      = Integer.parseInt (request.getParameter("cod_prod"));

           String sTipo      = request.getParameter ("tipo");


            if (! fechaHasta.equals("")) {
                Fecha.strToDate( fechaHasta );
                String DATE_FORMAT = "yyyyMMdd";
                SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);

                try {
                   dbCon = db.getConnection();
                   dbCon.setAutoCommit(false);
                   cons = dbCon.prepareCall(db.getSettingCall("INT_EXT_ARMAR_LOTE (?, ?,?,?, ?)"));
                   cons.registerOutParameter(1, java.sql.Types.INTEGER);
                   cons.setString   (2, "GS");
                   cons.setInt      (3, codProd);
                   cons.setDate     (4, Fecha.convertFecha(Fecha.strToDate( fechaDesde )));
                   cons.setDate     (5, Fecha.convertFecha(Fecha.strToDate( fechaHasta )));
                   cons.setString   (6, sTipo);

                   cons.execute();

                   iLote = cons.getInt (1);
                } catch (SQLException se) {
                    throw new SurException( "Pincho en INT_EXT_ARMAR_LOTE: " + se.getMessage());
                }

                sPath.append("/files/intGestion/");
                if ( sTipo.equals("EMI") || sTipo.equals("ALL") ) { // SOLO EMISION O TODOS
                    sArchivoOperaciones.append(sPath).append("OPERACIONES-").append(iLote).append("-").append(codProd).append("-").append( sdf.format(Fecha.strToDate( fechaHasta ))).append(".TXT");
                    sArchivoNomina.append(sPath).append("NOMINA-").append(iLote).append("-").append(codProd).append("-").append( sdf.format(Fecha.strToDate( fechaHasta ))).append(".TXT");
                    sArchivoCoberturas.append(sPath).append("COBERTURAS-").append(iLote).append("-").append(codProd).append("-").append( sdf.format(Fecha.strToDate( fechaHasta ))).append(".TXT");
                    sArchivoCuotas.append(sPath).append("CUOTAS-").append(iLote).append("-").append(codProd).append("-").append( sdf.format(Fecha.strToDate( fechaHasta ))).append(".TXT");

                    try {
                        FileOutputStream fos1 = new FileOutputStream (getServletContext().getRealPath(sArchivoOperaciones.toString()));
                        OutputStreamWriter osw1 = new OutputStreamWriter (fos1); //, "8859_1");
                        BufferedWriter bw1 = new BufferedWriter (osw1);

                        dbCon.setAutoCommit(false);
                        cons = dbCon.prepareCall(db.getSettingCall("INT_EXT_GS_OPERACIONES (?)"));
                        cons.registerOutParameter(1, java.sql.Types.OTHER);
                        cons.setInt      (2, iLote);

                        cons.execute();

                        rs = (ResultSet) cons.getObject(1);
                        if (rs != null) {
                            while (rs.next()) {
                                bw1.write(rs.getString ("CAMPO"));
                                iRegistrosEmi += 1;
                            }
                            rs.close();
                        }
                        cons.close();

                        bw1.flush();
                        bw1.close();
                        osw1.close();
                        fos1.close();
                    } catch (Exception e1) {
                        throw new SurException( "Pincho en OPERACIONES: " + e1.getMessage());
                    }


                   if (iRegistrosEmi > 0 ) {
                       try {
                           FileOutputStream fos3 = new FileOutputStream (getServletContext().getRealPath(sArchivoNomina.toString()));
                           OutputStreamWriter osw3 = new OutputStreamWriter (fos3); //, "8859_1");
                           BufferedWriter bw3 = new BufferedWriter (osw3);

                           dbCon.setAutoCommit(false);
                           cons = dbCon.prepareCall(db.getSettingCall("INT_EXT_GS_NOMINA (?)"));
                           cons.registerOutParameter(1, java.sql.Types.OTHER);
                           cons.setInt      (2, iLote);

                           cons.execute();

                           rs = (ResultSet) cons.getObject(1);
                           if (rs != null) {
                                while (rs.next()) {
                                    bw3.write(rs.getString ("CAMPO"));
                                }
                                rs.close();
                            }
                           cons.close();
                           bw3.flush();
                           bw3.close();
                           osw3.close();
                           fos3.close();
                        } catch (Exception e3) {
                            throw new SurException( "Pincho en NOMINA: " + e3.getMessage());
                        }

                       try {
                           FileOutputStream fos4 = new FileOutputStream (getServletContext().getRealPath(sArchivoCoberturas.toString()));
                           OutputStreamWriter osw4 = new OutputStreamWriter (fos4); //, "8859_1");
                           BufferedWriter bw4 = new BufferedWriter (osw4);

                           dbCon.setAutoCommit(false);
                           cons = dbCon.prepareCall(db.getSettingCall("INT_EXT_GS_COBERTURAS (?)"));
                           cons.registerOutParameter(1, java.sql.Types.OTHER);
                           cons.setInt      (2, iLote);

                           cons.execute();

                           rs = (ResultSet) cons.getObject(1);
                           if (rs != null) {
                                while (rs.next()) {
                                    bw4.write(rs.getString ("CAMPO"));
                                }
                                rs.close();
                            }
                           cons.close();
                           bw4.flush();
                           bw4.close();
                           osw4.close();
                           fos4.close();
                        } catch (Exception e4) {
                            throw new SurException( "Pincho en COBERTURAS: " + e4.getMessage());
                        }

                       try {
                           FileOutputStream fos5 = new FileOutputStream (getServletContext().getRealPath(sArchivoCuotas.toString()));
                           OutputStreamWriter osw5 = new OutputStreamWriter (fos5); //, "8859_1");
                           BufferedWriter bw5 = new BufferedWriter (osw5);

                           dbCon.setAutoCommit(false);
                           cons = dbCon.prepareCall(db.getSettingCall("INT_EXT_GS_CUOTAS (?)"));
                           cons.registerOutParameter(1, java.sql.Types.OTHER);
                           cons.setInt      (2, iLote);

                           cons.execute();

                           rs = (ResultSet) cons.getObject(1);
                           if (rs != null) {
                                while (rs.next()) {
                                    bw5.write(rs.getString ("CAMPO"));
                                }
                                rs.close();
                            }
                           cons.close();
                           bw5.flush();
                           bw5.close();
                           osw5.close();
                           fos5.close();
                        } catch (Exception e5) {
                            throw new SurException( "Pincho en CUOTAS: " + e5.getMessage());
                        }
                    }

                }

                if (sTipo.equals ("COB") || sTipo.equals ("ALL")) {
                    try {
                       sArchivoCobranza.append(sPath).append("COBRANZA-").append(iLote).append("-").append(codProd).append("-").append( sdf.format(Fecha.strToDate( fechaHasta ))).append(".TXT");
                       FileOutputStream fos6 = new FileOutputStream (getServletContext().getRealPath(sArchivoCobranza.toString()));
                       OutputStreamWriter osw6 = new OutputStreamWriter (fos6); //, "8859_1");
                       BufferedWriter bw6 = new BufferedWriter (osw6);

                       dbCon.setAutoCommit(false);
                       cons = dbCon.prepareCall(db.getSettingCall("INT_EXT_GS_COBRANZA (?)"));
                       cons.registerOutParameter(1, java.sql.Types.OTHER);
                       cons.setInt      (2, iLote);

                       cons.execute();

                       rs = (ResultSet) cons.getObject(1);
                       if (rs != null) {
                            while (rs.next()) {
                                bw6.write(rs.getString ("CAMPO"));
                                iRegistrosCob += 1;
                            }
                            rs.close();
                        }
                       cons.close();
                       bw6.flush();
                       bw6.close();
                       osw6.close();
                       fos6.close();
                    } catch (Exception e6) {
                        throw new SurException( "Pincho en COBRANZA: " + e6.getMessage());
                    }

                }
            }

            request.setAttribute("registros_emi", Integer.valueOf(iRegistrosEmi) );
            request.setAttribute("registros_cob", Integer.valueOf(iRegistrosCob) );
            request.setAttribute("operaciones", sArchivoOperaciones.toString().replace(("/files/intGestion"), "") );
            request.setAttribute("nomina", sArchivoNomina.toString().replace(("/files/intGestion"), "") );
            request.setAttribute("coberturas", sArchivoCoberturas.toString().replace(("/files/intGestion"), "") );
            request.setAttribute("cuotas", sArchivoCuotas.toString().replace(("/files/intGestion"), "") );
            request.setAttribute("cobranza", sArchivoCobranza.toString().replace(("/files/intGestion"), "") );
            doForward (request, response, "/usuarios/formInterfacesProd.jsp?sistema=GS&tipo=" + sTipo);

        } catch (Exception e) {
            throw new SurException ("PINCHO EN interfacGS: " + e.getMessage());

        } finally {
            try {
                if (rs != null) rs.close();
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
        }
    }

/*
    public void runInterface (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        FtpClient ftpClient = null;
        Connection dbCon = null;
        ResultSet rs =  null;
        CallableStatement cons = null;        
        StringBuffer slog = new StringBuffer();
        String sCommand   = "/root/interDemanda.bat";
        String sFileSec  = null;

        try {
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            Hashtable hSelec = new Hashtable ();
            
            hSelec.put ("AS_WEB_POLIZAS",       request.getParameter ("interface_1") == null ? "N" : "S");
            hSelec.put ("AS_WEB_BASICA",        request.getParameter ("interface_2") == null ? "N" : "S");
            hSelec.put ("AS_WEB_PROPUESTAS",    request.getParameter ("interface_3") == null ? "N" : "S");
            hSelec.put ("AS_WEB_PRODUCTORES",   request.getParameter ("interface_4") == null ? "N" : "S");            
            hSelec.put ("WEB_AS_PROPUESTAS",    request.getParameter ("interface_5") == null ? "N" : "S");
            hSelec.put ("WEB_AS_ACTIVIDAD",     request.getParameter ("interface_6") == null ? "N" : "S");

            Parametro oParam = new Parametro ();
            oParam.setsCodigo("DC_CLIENT_COMANDO");
            String sCommand2 = oParam.getDBValor(dbCon);

            oParam.setsCodigo("DC_CLIENT_SERVER");
            String sServer = oParam.getDBValor(dbCon);
    
            if (((String) hSelec.get("AS_WEB_POLIZAS")).equals("S"))  {
                String[] commands3 = new String[]{sCommand2 , "/root/dactweb.txt", sServer };
                Process child2 = Runtime.getRuntime().exec(commands3);

                child2.waitFor();
                
                // Se obtiene el stream de salida del programa
                InputStream is2 = child2.getInputStream();

  
                BufferedReader br2 = new BufferedReader (new InputStreamReader (is2));

                // Se lee la primera linea
                String aux2 = br2.readLine();

                if (aux2 != null) {
                    slog.append ("Resultado del proceso: " + aux2);
                }
            }
            
           dbCon = db.getConnection();
           int lote = 0;
           
           if (((String) hSelec.get("WEB_AS_ACTIVIDAD")).equals("S") || 
               ((String) hSelec.get("WEB_AS_PROPUESTAS")).equals("S") ) {
            
                hSelec.put ("WEB_AS_ZFLAG", "S");
                   
                IntPropuestas intProp = new IntPropuestas ();                                  
                if (((String) hSelec.get("WEB_AS_ACTIVIDAD")).equals("S"))  {
                   lote  = intProp.intActividadManual (dbCon);
                }

                if ( ((String) hSelec.get("WEB_AS_PROPUESTAS")).equals("S") ) {
                   lote = intProp.intPropuestasManual (dbCon);               
                }
                
                intProp.intFinInterfaceManual(lote, dbCon);
                sFileSec = "/root/gpolpino.txt";
                
           } else {
                hSelec.put ("WEB_AS_ZFLAG", "N");               
           }

            dbCon.setAutoCommit(false);
            
            cons = dbCon.prepareCall(db.getSettingCall("INT_GET_ALL_INTERFASE_MANUAL()"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            
            cons.execute();
            
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {            
                
                try {
//                ftpClient = new FtpClient( "192.168.1.10");
                ftpClient = new FtpClient( "192.168.2.171");
                slog.append("ftp - Conexión con DC: ok.<br>");
                
                } catch (Exception e) {
                    throw new SurException ("No se pudo conectar a DC. Intente más tarde.<br>");
                }
                
//                ftpClient.login ("BENEWEB","BENEWEB");
                ftpClient.login ("ftppino","kevasduc");
                slog.append(ftpClient.welcomeMsg + ".<br>");
                                
                while (rs.next()) {
                    
                    String sNombreCompleto = rs.getString ("PATH_LOCAL") + rs.getString ("NOM_ARCHIVO");

           //         slog.append( rs.getString ("PATH_LOCAL")); // sacar
           //         slog.append( rs.getString ("NOM_ARCHIVO")); // sacar

                    if (hSelec.containsKey(rs.getString ("CODIGO")) && 
                        ((String) hSelec.get(rs.getString ("CODIGO"))).equals("S")  ) {                           
                        if (rs.getString ("EXT_ARCHIVO").equals("ASCII")) {
                            ftpClient.ascii();
                        } else {
                            ftpClient.binary();
                        }

                        if (rs.getString ("INSTRUCCION").equals("get")) {
                            InputStream is = ftpClient.get(rs.getString ("NOM_ARCHIVO"));

                            slog.append("ftp - get --> " + rs.getString ("NOM_ARCHIVO") + ": ok.<br>");

                            // sacar
                //            slog.append (" sNombreCompleto  en 1 " +  sNombreCompleto  );

                            BufferedInputStream bis = new BufferedInputStream(is); 
                            OutputStream os = new FileOutputStream( sNombreCompleto );
                            BufferedOutputStream bos = new BufferedOutputStream(os);

                            byte[] buffer = new byte[1024];
                            int readCount;
                            while( (readCount = bis.read(buffer)) > 0) {
                              bos.write(buffer, 0, readCount);
                            }
                            bos.close();

                        } else if (rs.getString ("INSTRUCCION").equals("put") || 
                                   rs.getString ("INSTRUCCION").equals("append")) {

                            sNombreCompleto = sNombreCompleto + lote;
                            // sacar
               //             slog.append (" sNombreCompleto  en 2 " +  sNombreCompleto  );

                            File file=new File( sNombreCompleto);

                            TelnetOutputStream salida = null;
                            String sIns      = "put";
                            if (rs.getString ("INSTRUCCION").equals("put")) {
                                salida = ftpClient.put (file.getName());
                            } else { 
                                salida = ftpClient.append (file.getName());
                                sIns = "append";
                            }

                            //Lo cojo y meto la informacion deseada en el: 

// slog.append("file " + file.getName());

                            InputStream in = new FileInputStream(file);
                            byte c[] = new byte[4096];
                            int read = 0;
                            int total = 0;
                            while ((read = in.read(c)) != -1 ) {
                                salida.write(c, 0, read);
                                total+=read;
                            }
                            in.close(); //close the io streams
                            salida.close();
                            slog.append("ftp - " + sIns + " --> " + sNombreCompleto + " : ok.<br>");
                        }
                    }
                }
                rs.close();
            }
            cons.close ();
            
            slog.append("ftp - system: " + ftpClient.system());
            
            ftpClient.closeServer();
            slog.append("ftp - finalizó el ftp: ok<br><br>");
            
            if (((String) hSelec.get("AS_WEB_POLIZAS")).equals("S"))  {
                procesarAS400_WEB (dbCon, "AS_WEB_POLIZAS");
            }
           
            if ( ((String) hSelec.get("AS_WEB_BASICA")).equals("S") ) {
               procesarAS400_WEB (dbCon, "AS_WEB_BASICA");               
            }
            
            if ( ((String) hSelec.get("AS_WEB_PROPUESTAS")).equals("S") ) {
               procesarAS400_WEB (dbCon, "AS_WEB_PROPUESTAS");               
            }
            if ( ((String) hSelec.get("AS_WEB_PRODUCTORES")).equals("S") ) {
               procesarAS400_WEB (dbCon, "AS_WEB_PRODUCTORES");               
            }
            
            if (sFileSec != null && sFileSec.equals ("gpolpino.txt") ) {
    
                Parametro oParam = new Parametro ();
                oParam.setsCodigo("DC_CLIENT_COMANDO");
                String sCommand2 = oParam.getDBValor(dbCon);

                oParam.setsCodigo("DC_CLIENT_SERVER");
                String sServer = oParam.getDBValor(dbCon);

                String[] commands = new String[]{sCommand2 , sFileSec, sServer };
                Process child = Runtime.getRuntime().exec(commands);

                child.waitFor();

                // Se obtiene el stream de salida del programa
                InputStream is = child.getInputStream();

                  BufferedReader br = new BufferedReader (new InputStreamReader (is));

                // Se lee la primera linea
                String aux = br.readLine();

                if (aux != null) {
                    slog.append ("Resultado del proceso: " + aux);
                }
            }

            //Creamos el proceso
            Process p=Runtime.getRuntime().exec( sCommand );

            //Esperamos a que acabe para ejecutar el siguiente
            p.waitFor();
            
            slog.append ("La interface fue ejecutada con exito !!! ");
            
            request.setAttribute("mensaje", slog.toString() );
            request.setAttribute("volver", Param.getAplicacion() + "index.jsp");             
            doForward (request, response, "/include/MsjHtmlServidor.jsp");                      
            
        } catch (Exception se) {
            slog.append(se.getMessage());
            throw new SurException (slog.toString());
        } finally {
             try {
                if (rs != null) rs.close (); 
                if (cons != null) cons.close ();
                if (ftpClient != null) ftpClient.closeServer();
              } catch (Exception ex) {
                  throw new SurException (ex.getMessage());
              }
            ftpClient = null;            
            db.cerrar(dbCon);
        }
    }
*/
   public void procesarAS400_WEB (Connection dbCon , String operacion)
    throws ServletException, IOException, SurException {

        CallableStatement cons = null;        
        try {
            dbCon.setAutoCommit(true);

            
            cons = dbCon.prepareCall(db.getSettingCall("INT_SET_INTERFASE_MANUAL (?)"));
            cons.registerOutParameter(1, java.sql.Types.INTEGER);
            cons.setString(2, operacion);

            cons.execute();
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

    public void cambiarEstado (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

    Connection dbCon = null;
    boolean bCambiar = false;
    try {
        Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
        String estado = request.getParameter("estado");
        String tipoEmision = request.getParameter ("tipo_emision");

        dbCon = db.getConnection();

        if (tipoEmision.equals("ESTADO_PRELIQ_ONLINE") ||
            tipoEmision.equals("ESTADO_INFO_VIA_MAIL")) {
            Parametro oParam = new Parametro ();
            oParam.setsCodigo(tipoEmision);
            bCambiar = ( oParam.getDBValor(dbCon).equals(estado) ? false : true );

            if (bCambiar) {
                oParam.setsCodigo(tipoEmision);
                oParam.setsValor(estado);
                oParam.setsUserid(oUser.getusuario());
                oParam.setDB(dbCon);
            }
        } else {
            IntPropuestas.cambiarEstado(dbCon, tipoEmision, estado, oUser.getusuario());
        }

        doForward (request, response, "/usuarios/formInterfaces.jsp");

    } catch (Exception e) {
        throw new SurException (e.getMessage());
    } finally {
        db.cerrar(dbCon);
    }
    }

    public void desbloquearCtaCte  (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

    Connection dbCon = null;
    try {
        Usuario usu = (Usuario) (request.getSession().getAttribute("user"));
        dbCon = db.getConnection();

        Proceso oProc = new Proceso ();
        oProc.getDBUltimaCtaCte(dbCon, 0); // ultima cuenta corriente para usuarios internos

System.out.println ("ultima interface prod " + oProc.getdFechaFTP() );

        String sFecha = new SimpleDateFormat("yyyy-MM-dd").format(oProc.getdFechaFTP());

System.out.println ("ultima interface prod  string " + sFecha  );        

        Parametro oParam = new Parametro ();

        oParam.setsCodigo("MAX_CIERRE_CTACTE_PROD");
        oParam.setsValor (sFecha);
        oParam.setsUserid (usu.getusuario());
        oParam.setDB (dbCon);

        doForward (request, response, "/usuarios/formInterfaces.jsp");

    } catch (Exception e) {
        throw new SurException (e.getMessage());
    } finally {
        db.cerrar(dbCon);
    }
    }
    
    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doGet (HttpServletRequest request, HttpServletResponse response)
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
    
    public void goToJSPError (HttpServletRequest request, HttpServletResponse response, Throwable t) throws ServletException, IOException {
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
