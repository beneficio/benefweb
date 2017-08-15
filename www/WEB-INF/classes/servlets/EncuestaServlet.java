/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package servlets;
    
import java.io.IOException;

import javax.servlet.*;
import javax.servlet.http.*;


import com.business.util.*;
import com.business.db.*;
import com.business.beans.Encuesta;


import com.business.beans.EncuestaRespuesta;

import java.sql.Connection;
import java.util.Enumeration;
import java.util.LinkedList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import com.business.util.ControlEnvioMail;

/**
 *
 * @author silvio
 */
public class EncuestaServlet extends HttpServlet {


    /** Initializes the servlet.
     */
   // @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }

    /** Destroys the servlet.
     */
   // @Override
    public void destroy() {

    }
   
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
            if (op.equals("viewEncuesta")) {
               viewEncuesta (request, response);
            } else if (op.equals("grabarEncuesta")) {
               grabarEncuesta (request, response);
            }
        } catch (SurException se) {
            goToJSPError(request,response, se);
        } catch (Exception e) {
            goToJSPError(request,response, e);
        }        
    }
    
    protected void viewEncuesta (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        com.business.beans.Encuesta oEncuesta = new com.business.beans.Encuesta();
        ControlEnvioMail oCEM = new ControlEnvioMail();
        try {            
            if (Param.getRealPath () == null) {
                Param.realPath (getServletContext().getRealPath("/propiedades/config.xml"));
                db.realPath (getServletConfig().getServletContext ().getRealPath("/propiedades/config.xml"));
            } else {
                 //System.out.println(" Path != Null");
            }
            
            int numEncuestaReq =0;
            LinkedList lPregunta = new LinkedList();
            String checkMD5="";
            String token = request.getParameter("token");
            if ( token==null || token.equals("") ) {
                throw new SurException (" No se puede obtener datos de ingreso ."  );
            }            
            StringBuffer tokenStb = new StringBuffer(token);            
            int posSep = tokenStb.indexOf("@");
            if (posSep <0) {
                throw new SurException (" No se puede obtener datos de ingreso ."  );
            }            
            numEncuestaReq = Integer.parseInt(tokenStb.substring(0,posSep));
            checkMD5 =token.substring(posSep+1, tokenStb.length());
            if (numEncuestaReq==0){                
                throw new SurException (" No se puede obtener datos de ingreso .");
            }            
            dbCon = db.getConnection();          
            oCEM.setCodEnvio(numEncuestaReq);
            oCEM.setMD5(checkMD5);
            oCEM.setToken(token);
            oCEM.getDBbyEnvioAndMd5(dbCon);

            String msgVerifCtrlMail =this.verifControlEnvioMail(oCEM,checkMD5);
            if ( !msgVerifCtrlMail.equals("")){                
                throw new SurException ( msgVerifCtrlMail);
            }
            oEncuesta.setNumEncuesta(numEncuestaReq);
            oEncuesta.getDB(dbCon);
            if (oEncuesta.getiNumError()!=0) {
                throw new SurException ( oEncuesta.getsMensError() );
            }             
            if (!oEncuesta.getCodEstado().equals("S")) {
                throw new SurException ("La encuesta ya no esta publicada. Sepa disculpar las molestias."  );
            }
            oEncuesta.setLPregunta(oEncuesta.getDBPreguntas(dbCon));
            if (oEncuesta.getiNumError()!=0) {
                throw new SurException ( oEncuesta.getsMensError() );
            }            
        } catch (Exception e) {            
            oEncuesta.setNumEncuesta(0);
            oEncuesta.setiNumError(-1);
            oEncuesta.setsMensError( e.getMessage() );

        } finally {
            db.cerrar(dbCon);
            request.setAttribute("oCEM", oCEM );
            request.setAttribute("encuesta", oEncuesta );
            doForward (request, response, "/encuesta/formResponderEncuesta.jsp");
        }
    }

    protected void grabarEncuesta (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        com.business.beans.Encuesta oEncuesta = new com.business.beans.Encuesta();
        ControlEnvioMail oCEM = null;
        String usuario ="";
        String checkMD5="";
        String origen ="";
        try {
            int numEncuestaReq =0;
            
            String token = request.getParameter("token");
            if ( token==null || token.equals("") ) {
                throw new SurException (" No se puede obtener datos de ingreso ."  );
            }
            StringBuffer tokenStb = new StringBuffer(token);            
            int posSep = tokenStb.indexOf("@") ;
            if (posSep <0) {
                throw new SurException (" No se puede obtener datos de ingreso ."  );
            }
            numEncuestaReq = Integer.parseInt(tokenStb.substring(0, posSep));
            checkMD5 =token.substring(posSep+1, tokenStb.length());
            if (numEncuestaReq==0){
                throw new SurException (" No se puede obtener datos de ingreso .");
            }
            usuario = request.getParameter("enc_usu_destino");
            origen = request.getParameter("enc_mail_destino");

            String erCBX = "^CBX_ENC_\\d[0-9]*_PRE_\\d[0-9]*_OPC_\\d[0-9]*$";
            String erTXT = "^TXT_ENC_\\d[0-9]*_PRE_\\d[0-9]*_OPC_\\d[0-9]*$";
            String erRDO = "^RDO_ENC_\\d[0-9]*_PRE_\\d[0-9]*$";
            Pattern pattCBX = Pattern.compile(erCBX);
            Pattern pattTXT = Pattern.compile(erTXT);
            Pattern pattRDO = Pattern.compile(erRDO);

            Enumeration paramNames = request.getParameterNames();
            boolean match = false;
            String  type  ="";
            int     numEncuesta = 0;
            int     numPregunta = 0;
            int     numOpcion   = 0;
            String  valor    ="";            
            String  datoNavegador = "";
            dbCon = db.getConnection();
            oEncuesta.setNumEncuesta(numEncuestaReq);
            EncuestaRespuesta oRespEncuesta = new EncuestaRespuesta();
            oRespEncuesta.setNumEncuesta(numEncuestaReq);
            oRespEncuesta.setOrigen(origen);
            oRespEncuesta.setUserId(usuario);
            oRespEncuesta.delDBRespuestasByNumEncuesta(dbCon);
            

            datoNavegador = request.getParameter("datoNavegador");
            if (oEncuesta.getiNumError()!=0) {
                throw new SurException (" Error al borrar Respuesta Encuesta nro. : " + oEncuesta.getNumEncuesta()  );
            }  
            while(paramNames.hasMoreElements()) {
                String paramName = (String)paramNames.nextElement();
                match = false;
                Matcher matcherCBX = pattCBX.matcher(paramName);
                if (matcherCBX.matches()) {                    
                    match = true;
                    type = "CBX";
                } else {
                    Matcher matcherTXT = pattTXT.matcher(paramName);
                    if (matcherTXT.matches()) {                        
                        match = true;
                        type = "TXT";
                    } else {
                        Matcher matcherRDO = pattRDO.matcher(paramName);
                        if (matcherRDO.matches()) {
                            match = true;
                            type = "RDO";                            
                        }
                    }
                }
                if(match) {
                    numEncuesta = 0;
                    numPregunta = 0;
                    numOpcion   = 0;
                    valor    ="";
                    numEncuesta = getNroEncuesta(paramName);
                    numPregunta = getNroPregunta(paramName);
                    String[] paramValues = request.getParameterValues(paramName);
                    if (paramValues.length == 1) {
                        String paramValue = paramValues[0];
                        if (paramValue.length() != 0) {
                            valor  = (paramValue==null)?"":paramValue ;
                        }
                    }

                    boolean okGrabar = false;
                    if (type.equals("RDO")) {
                        numOpcion   = Integer.parseInt(valor);
                        if (numOpcion > 0) {
                            okGrabar = true;
                        }
                    } else if(type.equals("TXT") )  {
                        numOpcion   = getNroOpcion(paramName);
                        if (!valor.equals("") && numOpcion > 0) {
                            okGrabar = true;
                        }
                    } else {
                        numOpcion   = getNroOpcion(paramName);
                        if (numOpcion > 0) {
                            okGrabar = true;
                        }
                    }

                    if (okGrabar) {
                        EncuestaRespuesta er = new EncuestaRespuesta();
                        er.setNumEncuesta(numEncuesta);
                        er.setNumPregunta(numPregunta);
                        er.setNumOpcion(numOpcion);
                        if (type.equals("TXT") ) {
                            er.setCampoAbierto(valor);
                        }
                        er.setOrigen(origen);
                        er.setUserId(usuario);
                        er.setNavegador(datoNavegador);
                        er.setFechaTrabajo(new java.util.Date()) ;

                        if (numEncuestaReq == numEncuesta) {
                            int res = er.setDB(dbCon);
                            if (res!=0) {
                                throw new SurException (" Error Al grabar respuesta de la Encuesta nro. : " + er.getNumEncuesta()
                                                     + " Pregunta nro : " + er.getNumPregunta()
                                                     +  " Opcion nro   : " + er.getNumOpcion()   );
                            }
                        } else {
                            throw new SurException (" Error Diferente nro encuesta de la ENCUESTA ("+ numEncuestaReq + ") y EN LA OPCION ( " + numEncuesta + ") . Encuesta nro. : " + er.getNumEncuesta()
                                                 + " Pregunta nro : " + er.getNumPregunta()
                                                 +  " Opcion nro   : " + er.getNumOpcion() );
                        }
                    } //if (okGrabar)
                }                         
            }//while(paramNames.hasMoreElements()) {


            StringBuffer stbNavegador = new StringBuffer(datoNavegador);
            int posFirstIndex = stbNavegador.indexOf("|") ;
            int posLastIndex = stbNavegador.lastIndexOf("|") ;
            String browser = stbNavegador.substring(0,posFirstIndex);
            String version = stbNavegador.substring(posFirstIndex+1,posLastIndex);
            String os  = stbNavegador.substring(posLastIndex+1,stbNavegador.length());

            oCEM = new ControlEnvioMail();
            oCEM.setCodEnvio(oEncuesta.getNumEncuesta());
            oCEM.setMD5(checkMD5);
            oCEM.setUsuarioDestino(usuario);
            oCEM.setMailDestino(origen);
            oCEM.setMcaRespuesta("S");
            oCEM.setBrowser(browser);
            oCEM.setOS(version);
            oCEM.setVersion(os);
            oCEM.updateDB(dbCon);
            if (oCEM.getiNumError()!=0) {
                throw new SurException ( oCEM.getsMensError()  );
            }
            oEncuesta.setsMensError("La encuesta se grabo correctamente. Gracias por su colaboración.");
            oEncuesta.setNumEncuesta(0);
            oEncuesta.setiNumError(-1);            
        } catch (Exception e) {            
            oEncuesta.setNumEncuesta(0);
            oEncuesta.setiNumError(-1);
            oEncuesta.setsMensError( e.getMessage() );            
        } finally {
            db.cerrar(dbCon);
            request.setAttribute("oCEM", oCEM );
            request.setAttribute("encuesta", oEncuesta );
            doForward (request, response, "/encuesta/formResponderEncuesta.jsp");
        }
    }

    private int getNroEncuesta ( String pValor) throws SurException {
        try {
            String sepPRE ="_PRE_";
            StringBuffer encuesta = new StringBuffer(pValor);
            encuesta.delete(0, 8);            
            encuesta.delete(encuesta.indexOf(sepPRE) , encuesta.length() );
            return Integer.parseInt( encuesta.toString());
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        }
    }
    private int getNroPregunta ( String pValor) throws SurException {
        try {
            String sepPRE ="_PRE_";
            String sepOPC ="_OPC_";
            StringBuffer pregunta = new StringBuffer(pValor);
            pregunta.delete(0, 8);            
            pregunta.delete(0, pregunta.indexOf(sepPRE) + sepPRE.length());            
            if (pregunta.indexOf(sepOPC)!=-1) {               
                pregunta.delete(pregunta.indexOf(sepOPC) , pregunta.length());
            }
            return Integer.parseInt( pregunta.toString());
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        }
    }


    private int getNroOpcion ( String pValor) throws SurException {
        try {            
            String sepOPC ="_OPC_";
            StringBuffer opcion = new StringBuffer(pValor);            
            if (opcion.indexOf(sepOPC)!=-1) {                
                opcion.delete(0, opcion.indexOf(sepOPC)+sepOPC.length() ) ;
            } else {
                opcion.delete(0 , opcion.length() ).append("0") ;
            }
            return Integer.parseInt( opcion.toString());
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        }
    }

    private String verifControlEnvioMail (ControlEnvioMail oCem, String md5Input ) throws SurException {
        String msg= "";
        try {
            if ( oCem == null || oCem.getCodEnvio() ==0 || oCem.getiNumError()!=0  ) {
                throw new SurException (((oCem==null || oCem.getCodEnvio() ==0)?"Estimado colaborador no se puede verificar los datos, muchas gracias.":oCem.getsMensError()) );
            }
            if (!oCem.getMcaEnviado().equals("S") ) {
                throw new SurException ("Estimado colaborador, la encuesta no puede ser respondida ,muchas gracias");
            }
            if (!oCem.getMcaRespuesta().equals("N") ) {
                throw new SurException ("Estimado colaborador, usted ya ha completado la encuenta, muchas gracias.");
            }
            StringBuffer stb = new StringBuffer(oCem.getMailDestino());
            stb.append(oCem.getCodEnvio());
            String md5 = Criptografia.toMD5(stb.toString());

            if (!md5Input.equals(md5)) {
                throw new SurException ("Estimado colaborador, no se puede realizar la autorización de la encuesta, muchas gracias.");
            }


        } catch(Exception e) {
            msg =  e.getMessage();
        } finally {
            return msg;
        }
    }

    
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    //@Override
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
    //@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    //@Override
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

    } 


}
