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
import java.util.LinkedList;
import java.sql.SQLException;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 *
 * @author Rolando Elisii
 */
public class BancoNacionServlet extends HttpServlet {
   
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

            if  (op.equals("generarReporte")) {
                procesarEnvio (request, response);
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
        ResultSet rs = null;
        int iNuevas = 0;
        int iModif  = 0;
        int cantFilas = 0;
        String sPath  = "/opt/tomcat/webapps/benef/files/trans/NACION_";
        LinkedList lError = new LinkedList ();
        File fArchivo = null;
        double importeTotal = 0;
        String sError  = "";
        try {
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));
            String fechaRendicion = (request.getParameter ("fecha_rendicion")==null)?"":
                                    request.getParameter ("fecha_rendicion");

            if (! fechaRendicion.equals("")) {
                Fecha.strToDate( fechaRendicion );
                String DATE_FORMAT = "yyyyMMdd";
                SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
                sPath = sPath + sdf.format(Fecha.strToDate( fechaRendicion )) + ".TXT";

                fArchivo = new File(sPath);
                if( !fArchivo.exists() && !fArchivo.isDirectory() ){
                    sError = "NO EXISTE EL ARCHIVO EN: " + sPath;
                }
            } else {
                sError = "FECHA DE RENDICION INVALIDA";
            }

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
                        String sTipoReg =  linea.substring(0, 1);

System.out.println (linea);

                        try {
                           dbCon.setAutoCommit(true);
                           cons = dbCon.prepareCall(db.getSettingCall( "BNC_GRABAR_REGISTRO (?,?,?,?)"));
                           cons.registerOutParameter(1, java.sql.Types.INTEGER);
                           cons.setDate     (2, Fecha.convertFecha(Fecha.strToDate( fechaRendicion )));
                           cons.setString   (3, sTipoReg);
                           cons.setString   (4, linea);
                           cons.setString   (5, oUser.getusuario());

                           cons.execute();

System.out.println ("resultado: " + cons.getInt (1));

                           if (cons.getInt (1) < 0 ) {
                                switch (cons.getInt (1))  {
                                    case -100 : sError = "NO EXISTE LA POLIZA: " + linea;
                                        break;
                                    case -300 : sError = "NO EXISTE LA CUENTA: " + linea;
                                        break;
                                    case -400 : sError = "CUENTA DIFERENTE   : " + linea;
                                        break;
                                    default   : sError = "ERROR INDEFINIDO   : " + linea;
                               }
                           } else {
                               if (sTipoReg.equals("3")) {
                                   cantFilas = cons.getInt(1);
                                   if (cantFilas == 0) {
                                       sError = "NO EXISTE EL REGISTRO DE TIPO 3: ";
                                       break;
                                   }

                                   importeTotal = Double.parseDouble(linea.substring(1, 16)) /100;
                                   System.out.println ("importeTotal" + importeTotal);
                               }
                           }
                        } catch (Exception e) {
                            throw new SurException( (e.getMessage()));
                        }

                    }
                    if (sError != null && ! sError.equals("")) {
                       lError.add(sError);
                        sError = "";
                    }
                    numFila += 1;
                } while ( true );
                di.close();

                try {
                       dbCon.setAutoCommit(false);

                       cons2 = dbCon.prepareCall(db.getSettingCall("BNC_GET_ALL_CUENTAS (?)"));
                       cons2.registerOutParameter(1, java.sql.Types.OTHER);
                       cons2.setDate             (2, Fecha.convertFecha(Fecha.strToDate( fechaRendicion )));

                       cons2.execute();

                       rs = (ResultSet) cons2.getObject(1);
                       if (rs != null) {
                            while (rs.next()) {
                                iNuevas = rs.getInt ("NUEVA");
                                iModif  = rs.getInt ("MODIFICACION");
                           }
                           rs.close();
                        }
                        cons2.close();
                } catch (Exception ee) {
                    throw new SurException( (ee.getMessage()));
                }

                if ( (iNuevas + iModif) != cantFilas ) {
                    sError = "NUEVAS + MODIFICADAS DIFERENTE A LA CANTIDAD DE REGISTRO DE TIPO 2";
                }
            }

            if (sError != null && ! sError.equals("") ) {
                lError.add(sError);
            }
            request.setAttribute("error", lError);
            request.setAttribute("nuevas", String.valueOf(iNuevas));
            request.setAttribute("modif", String.valueOf(iModif));
            request.setAttribute("importeTotal", Dbl.DbltoStr(importeTotal, 2));

            doForward(request, response, "/abm/bancoNacion/formBancoNacion.jsp");
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close();
                if (cons2 != null) cons2.close ();
                if (rs != null) rs.close ();
            } catch (SQLException se) {
                throw new SurException( (se.getMessage()));
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
