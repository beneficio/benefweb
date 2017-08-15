/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package servlets;
import java.io.*;
import java.text.SimpleDateFormat;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.CallableStatement;
import com.business.beans.*;
import com.business.util.*;
import com.business.db.*;
import java.sql.SQLException;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.Calendar;

/**
 *
 * @author Rolando Elisii
 */
public class BancoPatagoniaServlet extends HttpServlet {
   
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

            if  (op.equals("procesar")) {
                procesarEnvio (request, response);
            } else if  (op.equals("procesarRespuesta")) {
                procesarRespuesta (request, response);
            }
        } catch (SurException se) {
            goToJSPError(request,response, se);
        } catch (Exception e) {
            goToJSPError(request,response, e);
        }
    }

    protected void procesarEnvio (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        Connection dbCon = null;
        CallableStatement cons = null;
        CallableStatement cons2 = null;
        CallableStatement cons3 = null;
        ResultSet rs = null;
        int cantFilas = 0;
        String sPath  = "/opt/tomcat/webapps/benef/files/trans/";
        String sError = "";
        File fArchivo = null;
        int resultado      = -1;
        try {

            if ( System.getProperty("os.name" ).contains("Windows") ) {
                sPath = "C:\\benefweb\\www\\files\\trans\\";
            }

            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));
//            String fechaRendicion = (request.getParameter ("fecha_rendicion")==null)?"":
//                                    request.getParameter ("fecha_rendicion");
            String sArchivo = request.getParameter ("archivo");

            String delims = "[.]";
            String [] aArchivo = sArchivo.split(delims);

            fArchivo = new File(sPath + sArchivo);
            if( !fArchivo.exists() && !fArchivo.isDirectory() ){
                sError = "NO EXISTE EL ARCHIVO " + sArchivo + " EN: " + sPath;
            }

            String sFechaRendicion = sArchivo.substring(3, 7);

            String sSecuencia      = sArchivo.substring(7,8);

            Calendar ahoraCal = Calendar.getInstance();
            String DATE_FORMAT = "ddMMyyyy";
            SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);

            java.util.Date dFechaRendicion = sdf.parse( sFechaRendicion + ahoraCal.get(Calendar.YEAR));

            if (sError.equals("")) {
                dbCon = db.getConnection();

                BufferedReader di = new BufferedReader(new FileReader(fArchivo));
                String linea;
                /***** Lee línea a línea el  archivo ... ****/

                int numFila = 0;
                do {
                    linea = di.readLine();
                    if (linea == null) {
                        break;
                    }  else {
                        numFila += 1;
                        String sTipoReg =  linea.substring(0, 1);

                        dbCon.setAutoCommit(true);
                        cons = dbCon.prepareCall(db.getSettingCall( "BPA_GRABAR_REGISTRO (?, ?, ?, ?, ?,?)"));
                        cons.registerOutParameter(1, java.sql.Types.INTEGER);
                        cons.setDate     (2, Fecha.convertFecha(dFechaRendicion) );
                        cons.setInt      (3, Integer.parseInt (sSecuencia));
                        cons.setString   (4, sTipoReg);
                        cons.setString   (5, linea);
                        cons.setInt      (6, numFila);
                        cons.setString   (7, oUser.getusuario());

                       cons.execute();

                       if (cons.getInt (1) < 0 ) {
                           sError = "ERROR EN PROCESAR EL REGISTRO: " + linea;
                           break;
                       } else {
                           if (sTipoReg.equals("T")) {
                               cantFilas = cons.getInt(1);
                               if (cantFilas == 0) {
                                   sError = "NO EXISTE EL REGISTRO DE TIPO 3: ";
                                   break;
                               }
                           }
                       }

                    }
                } while ( true );
                di.close();

                if (sError.equals("")) {

                   String sMesProceso = request.getParameter ("mes_proceso");
                   try {
                       cons3 = dbCon.prepareCall(db.getSettingCall("BPA_VALIDAR_ENVIO (?,?,?)"));
                       cons3.registerOutParameter(1, java.sql.Types.INTEGER);
                       cons3.setDate      (2, Fecha.convertFecha(dFechaRendicion));
                       cons3.setInt       (3, Integer.parseInt (sSecuencia));
                       cons3.setString    (4, sMesProceso);
                       cons3.execute();

                       resultado = cons3.getInt(1);

                    } catch (SQLException se ) {
                       throw new SurException( se.getMessage());
                    } finally {
                        cons3.close ();
                    }

                   dbCon.setAutoCommit(false);
                   cons2 = dbCon.prepareCall(db.getSettingCall("BPA_GET_ALL_CUENTAS (?, ?)"));
                   cons2.registerOutParameter(1, java.sql.Types.OTHER);
                   cons2.setDate     (2,  Fecha.convertFecha(dFechaRendicion));
                   cons2.setInt      (3, Integer.parseInt (sSecuencia));

                   cons2.execute();

                   rs = (ResultSet) cons2.getObject(1);

                   if (rs != null) {
                       FileOutputStream fos   = new FileOutputStream (sPath + aArchivo[0] + ".csv");
                       OutputStreamWriter osw = new OutputStreamWriter (fos); //, "8859_1");
                       BufferedWriter bw      = new BufferedWriter (osw);

                       FileOutputStream fos2   = new FileOutputStream (sPath + aArchivo[0] + ".780");
                       OutputStreamWriter osw2 = new OutputStreamWriter (fos2); //, "8859_1");
                       BufferedWriter bw2      = new BufferedWriter (osw2);

                        StringBuilder sbTit = new StringBuilder();
                        sbTit.append("F.RENDICION").append(";");
                        sbTit.append("SEC").append(";");
                        sbTit.append("F.VENC").append(";");
                        sbTit.append("F.ENVIO").append(";");
                        sbTit.append("RAMA").append(";");
                        sbTit.append("POLIZA").append(";");
                        sbTit.append("END").append(";");
                        sbTit.append("CUOTA").append(";");
                        sbTit.append("COD_PROD").append(";");
                        sbTit.append("PRODUCTOR").append(";");
                        sbTit.append("CBU").append(";");
                        sbTit.append("IMPORTE").append(";");
                        sbTit.append("DUPLICADO").append(";");
                        sbTit.append("DEUDA_TOTAL").append(";");
                        sbTit.append("COD_ERROR").append(";");
                        sbTit.append("OBSERVACIONES").append("\r\n");

                        bw.write(sbTit.toString());

                        while (rs.next()) {
                                bw2.write(rs.getString ("REGISTRO"));

                            if (rs.getString ("TIPO_REGISTRO").equals("D")) {
                                StringBuilder sb = new StringBuilder();
                                sb.append(Fecha.showFechaForm(rs.getDate ("FECHA_RENDICION"))).append(";");
                                sb.append(rs.getInt("SECUENCIA")).append(";");
                                sb.append(Fecha.showFechaForm(rs.getDate ("FECHA_VENC_ORIG"))).append(";");
                                sb.append(Fecha.showFechaForm(rs.getDate ("FECHA_VENCIMIENTO"))).append(";");
                                sb.append(rs.getInt("COD_RAMA")).append(";");
                                sb.append(rs.getInt("NUM_POLIZA")).append(";");
                                sb.append(rs.getInt("ENDOSO")).append(";");
                                sb.append(rs.getInt("NUM_CUOTA")).append(";");
                                sb.append(rs.getInt("COD_PROD")).append(";");
                                sb.append(rs.getString("PRODUCTOR")).append(";");
                                sb.append(rs.getString("NUM_CUENTA")).append(";");
                                sb.append(rs.getString("IMPORTE")).append(";");
                                sb.append(rs.getString("MCA_DUPLICADO")).append(";");
                                sb.append(rs.getString("IMP_DEUDA_END")).append(";");
                                sb.append(rs.getString("COD_ERROR")).append(";");
                                sb.append(rs.getString("OBSERVACIONES")).append("\r\n");

                                bw.write(sb.toString());
                            }

                       }
                        rs.close();
                        bw.flush();
                        bw.close();
                        osw.close();
                        fos.close();
                        bw2.flush();
                        bw2.close();
                        osw2.close();
                        fos2.close();
                    }
                    cons2.close();
                }
            }

            if (resultado != 0) {
                sError = "REVISAR ARCHIVO *.csv PORQUE HAY ERRORES EN EL PROCESO ";
            }
            request.setAttribute("error", sError);
            request.setAttribute("archivo_csv",  aArchivo[0] + ".csv");
            request.setAttribute("archivo_780",  aArchivo[0] + ".780");
            doForward(request, response, "/abm/bancoPatagonia/formPatagonia.jsp");
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void procesarRespuesta (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {

        Connection dbCon = null;
        CallableStatement cons = null;
        CallableStatement cons2 = null;
        ResultSet rs = null;
        String sPath  = "/opt/tomcat/webapps/benef/files/trans/";
        String sError = "OK";
        File fArchivo = null;
        try {

            if ( System.getProperty("os.name" ).contains("Windows") ) {
                sPath = "C:\\benefweb\\www\\files\\trans\\";
            }

            String sArchivo = request.getParameter ("file");

            fArchivo = new File(sPath + sArchivo);
            if( !fArchivo.exists() && !fArchivo.isDirectory() ){
                sError = "NO EXISTE EL ARCHIVO " + sArchivo + " EN: " + sPath;
            }
            java.util.Date dFechaRendicion = null;

            if (sError.equals("OK")) {
                dbCon = db.getConnection();

                BufferedReader di = new BufferedReader(new FileReader(fArchivo));
                String linea;
                /***** Lee línea a línea el  archivo ... ****/

                int numFila = 0;
                do {
                    linea = di.readLine();
                    if (linea == null) {
                        break;
                    }  else {
                        numFila += 1;
                        String sTipoReg =  linea.substring(0, 1);

                        if (sTipoReg.equals("H")) {
                            String DATE_FORMAT = "ddMMyyyy";
                            SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
                            dFechaRendicion = sdf.parse( linea.substring(25,33));

                        } else if (sTipoReg.equals("D")) {
                                dbCon.setAutoCommit(true);
                                cons = dbCon.prepareCall(db.getSettingCall( "BPA_GRABAR_RESPUESTA (?, ?, ?)"));
                                cons.registerOutParameter(1, java.sql.Types.INTEGER);
                                cons.setDate     (2, Fecha.convertFecha(dFechaRendicion) );
                                cons.setString   (3, sTipoReg );
                                cons.setString   (4, linea);

                                cons.execute();

                               if (cons.getInt (1) < 0 ) {
                                   sError = "ERROR EN PROCESAR EL REGISTRO: " + linea;
                                   break;
                               }
                        }
                    }
                } while ( true );
                di.close();

                   dbCon.setAutoCommit(false);
                   cons2 = dbCon.prepareCall(db.getSettingCall("BPA_GET_ALL_CUENTAS (?, ?)"));
                   cons2.registerOutParameter(1, java.sql.Types.OTHER);
                   cons2.setDate     (2,  Fecha.convertFecha(dFechaRendicion));
                   cons2.setInt      (3, 999);

                   cons2.execute();

                   rs = (ResultSet) cons2.getObject(1);

                   if (rs != null) {
                       FileOutputStream fos   = new FileOutputStream (sPath + sArchivo + ".csv");
                       OutputStreamWriter osw = new OutputStreamWriter (fos); //, "8859_1");
                       BufferedWriter bw      = new BufferedWriter (osw);

                        StringBuilder sbTit = new StringBuilder();
                        sbTit.append("F.RENDICION").append(";");
                        sbTit.append("SEC").append(";");
                        sbTit.append("F.VENC").append(";");
                        sbTit.append("F.ENVIO").append(";");
                        sbTit.append("RAMA").append(";");
                        sbTit.append("POLIZA").append(";");
                        sbTit.append("END").append(";");
                        sbTit.append("CUOTA").append(";");
                        sbTit.append("COD_PROD").append(";");
                        sbTit.append("PRODUCTOR").append(";");
                        sbTit.append("CBU").append(";");
                        sbTit.append("IMPORTE").append(";");
                        sbTit.append("DUPLICADO").append(";");
                        sbTit.append("DEUDA_TOTAL").append(";");
                        sbTit.append("COD_ERROR").append(";");
                        sbTit.append("OBSERVACIONES").append("\r\n");

                        bw.write(sbTit.toString());

                        while (rs.next()) {
                            if (rs.getString ("TIPO_REGISTRO").equals("D")) {
                                StringBuilder sb = new StringBuilder();
                                sb.append(Fecha.showFechaForm(rs.getDate ("FECHA_RENDICION"))).append(";");
                                sb.append(rs.getInt("SECUENCIA")).append(";");
                                sb.append(Fecha.showFechaForm(rs.getDate ("FECHA_VENC_ORIG"))).append(";");
                                sb.append(Fecha.showFechaForm(rs.getDate ("FECHA_VENCIMIENTO"))).append(";");
                                sb.append(rs.getInt("COD_RAMA")).append(";");
                                sb.append(rs.getInt("NUM_POLIZA")).append(";");
                                sb.append(rs.getInt("ENDOSO")).append(";");
                                sb.append(rs.getInt("NUM_CUOTA")).append(";");
                                sb.append(rs.getInt("COD_PROD")).append(";");
                                sb.append(rs.getString("PRODUCTOR")).append(";");
                                sb.append(rs.getString("NUM_CUENTA")).append(";");
                                sb.append(rs.getString("IMPORTE")).append(";");
                                sb.append(rs.getString("MCA_DUPLICADO")).append(";");
                                sb.append(rs.getString("IMP_DEUDA_END")).append(";");
                                sb.append(rs.getString("COD_ERROR")).append(";");
                                sb.append(rs.getString("OBSERVACIONES")).append("\r\n");
                                bw.write(sb.toString());
                            }

                       }
                        rs.close();
                        bw.flush();
                        bw.close();
                        osw.close();
                        fos.close();
                    }
                    cons2.close();
            }


            request.setAttribute("error", sError);
            request.setAttribute("archivo_csv",  sArchivo + ".csv");
            doForward(request, response, "/abm/bancoPatagonia/formPatagonia.jsp?pri=N");
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
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
