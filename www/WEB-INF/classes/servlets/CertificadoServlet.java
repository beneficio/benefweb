/*
 * CertificadoServlet.java
 *
 * Created on 29 de enero de 2005, 13:46
 */
package servlets;
         
import java.io.IOException;
import java.util.LinkedList;
import java.util.Date;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import com.business.beans.*;
import com.business.util.*;
import com.business.db.db;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.BufferedWriter;

/**
 *
 * @author Rolando Elisii
 * @version
 */
public class CertificadoServlet extends HttpServlet {
    
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
            
            if (op.equals("addCertificado")) {
                addCertificado (request, response);
            
            } else if (op.equals("getAllCert")) {
                getAllCertificados (request, response);
                
            } else if (op.equals("getPrintCert")) {
                getPrintCertificado (request, response);
            
            } else if (op.equals("getCert")) {
                getCertificado (request, response);
                
            } else if (op.equals("addCertAseg")) {
                addCertificadoAsegurado (request, response);
            } else if (op.equals("addCertificadoProp")) {
                addCertificadoProp (request, response);    
            } else if (op.equals("genArchivoCertifProp")) {         
                genArchivoCertifProp(request, response);    
            } else if (op.equals("generarExcel")) {         
                generarListadoExcel(request, response);    
            } else if (op.equals("getAllCertIBSS")) {
                getAllCertificadosIBSS (request, response);
            } else if (op.equals("getCertificadoIBSS")) {
                getCertificadosIBSS (request, response);
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
    protected void addCertificado (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));
            int iEstado   = (request.getParameter ("estado") == null ? 0 : Integer.parseInt (request.getParameter ("estado")));
            String sTipo  = request.getParameter ("tipo_cert");
            
            Certificado oCert = new Certificado ();

            oCert.setnumCertificado(Integer.parseInt (request.getParameter ("numCertificado")));
            oCert.setestadoCertificado(iEstado);
            
            if (sTipo.equals("PR") || sTipo.equals("EN")) {
                oCert.settipoCertificado( sTipo );
                oCert.setnumPropuesta(request.getParameter ("num_propuesta") == null || 
                                      request.getParameter ("num_propuesta").equals ("") ? 0 : 
                                      Integer.parseInt (request.getParameter ("num_propuesta")));
            } else {
                oCert.settipoCertificado("PZ");
                oCert.setnumPoliza(request.getParameter ("num_poliza") == null || 
                                      request.getParameter ("num_poliza").equals ("") ? 0 : 
                                      Integer.parseInt (request.getParameter ("num_poliza")));
                oCert.setcodRama   (request.getParameter ("cod_rama") == null || 
                                      request.getParameter ("cod_rama").equals ("") ? 0 : 
                                      Integer.parseInt (request.getParameter ("cod_rama")));
                
                oCert.setmodoVisualizacion(Integer.parseInt(request.getParameter("modo_visual")));                                      
           }
            
           oCert.settipoEnvioOrig  (Integer.parseInt(request.getParameter("recibir_original")));
           oCert.setdescModoEnvio  (request.getParameter ("descEnvio"));
           oCert.setpresentar      (request.getParameter ("presentar")); 
           oCert.setuserId         (oUser.getusuario());
           oCert.setcodProd        (oUser.getiCodProd());

           String actualizaCla = request.getParameter ("actualiza_cla");           
           
           if (actualizaCla.equals("S")) {
                oCert.setclaNoRepeticion    (request.getParameter ("cla_no_repeticion") == null ? "N" : request.getParameter ("cla_no_repeticion"));
                oCert.setclaSubrogacion     (request.getParameter ("cla_subrogacion") == null ? "N" : request.getParameter ("cla_subrogacion") );
           } else {
                oCert.setclaNoRepeticion    ( null );
                oCert.setclaSubrogacion     ( null );
           }
           
           int iCantClausulas = (request.getParameter ("cant_max_clausulas") == null ? 0 : Integer.parseInt (request.getParameter ("cant_max_clausulas")));
 
           dbCon = db.getConnection();

           oCert.setDB (dbCon);
                      
           boolean bActualiza = false;
         
           if ( ( oCert.getcodRama() == 10 || oCert.getcodRama() == 22 ) && iCantClausulas > 0) {
           
                for (int ii= 1; ii <= iCantClausulas;ii++) {
                    if (request.getParameter ("CLA_DESCRIPCION_" + ii) != null && request.getParameter ("CLA_DESCRIPCION_" + ii).trim().length() > 0) {
                        bActualiza = true;
                    }

                }

               if ( bActualiza ) {
                    for (int i= 1; i <= iCantClausulas;i++) {
                        Clausula oCla =  new Clausula ();
                        oCla.settipoCertificado(oCert.gettipoCertificado());
                        oCla.setnumCertificado (oCert.getnumCertificado());
                        oCla.setnumItem (i);
                        oCla.setcuitEmpresa (request.getParameter ("CLA_CUIT_" + i));
                        oCla.setdescEmpresa (request.getParameter ("CLA_DESCRIPCION_" + i));

                        if (i == 1) {
                            oCla.delDBCertificado (dbCon);
                        }
                        if (oCla.getdescEmpresa() != null && oCla.getdescEmpresa().trim().length() > 0) {
                            try  {
                                oCla.setDBCertificado (dbCon);
                            } catch (Exception se ) {
                                throw new SurException((se.getMessage()));
                            }

                        }
                    }
               }
                
                oCert.setDBEndoso(dbCon);
           }

// setear el control de acceso
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, 2);
            
// fin de setear el control de acceso 
            
            if (oCert.getnumCertificado() > 0) {
               if ( oUser.getiCodProd() != 0 &&
                  ((oCert.gettipoEnvioOrig() >= 2 &&
                   oCert.gettipoEnvioOrig() <= 4 ) ||
                   oCert.gettipoCertificado().equals("PR"))) {

                    StringBuilder sMensaje = new StringBuilder ();
                    sMensaje.append("INGRESO UN NUEVO CERTIFICADO DE COBERTURA QUE DEBE PROCESAR.\n\n");
                    sMensaje.append("FECHA: ").append(Fecha.getFechaActual()).append("\n\n");
                    sMensaje.append("NUMERO DE CERTIFICADO: ").append(oCert.getnumCertificado()).append("\n\n");
                    
                    if (oCert.gettipoCertificado().equals ("PZ")) {
                        sMensaje.append("POLIZA: ").append(Formatos.showNumPoliza(oCert.getnumPoliza())).append("\n\n");
                    } else {
                        sMensaje.append("PROPUESTA: ").append(oCert.getnumPropuesta()).append("\n\n");
                    }
                    
                    sMensaje.append("El usuario ");
                    sMensaje.append(oUser.getsDesPersona()); 
                    sMensaje.append(" ha solicitado que le envien ");
                    sMensaje.append(oCert.getdescModoEnvio()); 
                    sMensaje.append(" el original del Certificado de Cobertura de "); 
                    if (oCert.gettipoCertificado().equals ("PZ")) {
                        sMensaje.append("POLIZA ingresado desde la página web.\n\n ");
                    } else {
                        sMensaje.append("PROPUESTA ingresado desde la página web.\n\n ");
                    }
                   
                    sMensaje.append("Este es un mensaje automático generado por BENEFICIO WEB.\n");
                    sMensaje.append("Cualquier duda o consulta puede comunicarse por este medio a webmaster@beneficiosa.com.ar\n");


                    Email oEmail = new Email ();
                    oEmail.setSubject("Beneficio Web - AVISO de Certificado de Cobertura N° " + oCert.getnumCertificado());
                    oEmail.setContent(sMensaje.toString());

                    LinkedList lDest = oEmail.getDBDestinos(dbCon, oUser.getoficina(), "CERTIFICADO");

                    for (int i=0; i < lDest.size();i++) {
                        Persona oPers = (Persona) lDest.get(i);
                        oEmail.setDestination(oPers.getEmail());
                    //    oEmail.sendMessage();
                        oEmail.sendMessageBatch();
                    }
                }
           
                if (oCert.gettipoCertificado().equals("PZ")) {

                    switch (oCert.getmodoVisualizacion()) {
                        case 1: // no desea visualizarlo
                            request.setAttribute("mensaje", "La solicitud de Certificado de Cobertura ha sido procesada exitosamente.</br>Número de Operación <b>" + oCert.getnumCertificado() + "</b>.<br><br> Muchas Gracias.");
                            request.setAttribute("volver", Param.getAplicacion() + "index.jsp");             
                            doForward (request, response, "/include/MsjHtmlServidor.jsp");                      
                            break;

                        case 2: // acrobat reader
                            response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
                            response.setHeader("Location", Param.getAplicacion() + "certificado/printCertificado.jsp?tipo_cert=PZ&numCert=" + oCert.getnumCertificado() + "&tipo=pdf");
                            break;

                        default: // normal html
                            response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
                            response.setHeader("Location",Param.getAplicacion() + "certificado/printCertificado.jsp?tipo_cert=PZ&numCert=" + oCert.getnumCertificado() + "&tipo=html");
                    }
                } else {
                    request.setAttribute("mensaje", "La solicitud de Certificado de Cobertura de Propuesta ha sido procesada exitosamente.</br>Número de Operación <b>" + oCert.getnumCertificado() + "</b>.<br><br> Muchas Gracias.");
                    request.setAttribute("volver", Param.getAplicacion() + "index.jsp");             
                    doForward (request, response, "/include/MsjHtmlServidor.jsp");                      
                }
            } else {
                
                String sMensaje = "";                
                switch (oCert.getnumCertificado()) {
                    case -100: // la poliza no existe
                        sMensaje = "La p&oacute;liza solicitada no existe o no se encuentra registrada en la web.<br> Por favor comiquese con su representante.</br></br>Muchas Gracias.";
                        break;

                    case -200: // ya existe un certificado el mismo dia
                        sMensaje = "Ya existe una solicitud de Certificado de Cobertura para la poliza ingresada en el d&iacute;a de la fecha.<br>Por favor ingrese por Certificado -> Mis Certificados.</br></br>Muchas Gracias.";
                        break;

                    case -300: // la poliza no esta vigente
                        sMensaje = "La p&oacute;liza no esta vigente.</br></br>Muchas Gracias.";
                        break;

                    case -400: // existe deuda
                        sMensaje = "La p&oacute;liza registra una deuda pendinte.<br> Ante cualquier duda por favor comiquese con su representante.</br></br>Muchas Gracias.";
                        break;

                    case -500: // LA PóLIZA esta anulada
                        sMensaje = "La p&oacute;liza esta anulada.";
                        break;
                    case -700: // LA PóLIZA esta anulada
                        sMensaje = "La p&oacute;liza aun no tiene CUIC asignado. Puede ser que a&uacute;n este pendiente o no haya sido aprobada por la SSN.";
                        break;

                    default: // normal html
                        sMensaje = "Hubo alg&uacute;n problema en el alta del Certificado de Cobertura solicitado. Por favor, comuniquese con su representante</br></br>Muchas Gracias.";

                        Email oEmail = new Email ();
                        oEmail.setSubject("Beneficio Web - Aviso de ERROR ");
                        oEmail.setContent(sMensaje);
                        LinkedList lDest = oEmail.getDBDestinos(dbCon, 0, "ERROR");

                        for (int i=0; i < lDest.size();i++) {
                            Persona oPers = (Persona) lDest.get(i);
                            oEmail.setDestination(oPers.getEmail());
                       //     oEmail.sendMessage();
                            oEmail.sendMessageBatch();
                        }                
                }
 
                request.setAttribute("mensaje", sMensaje);                
                request.setAttribute("volver", Param.getAplicacion() + "index.jsp");             
                doForward (request, response, "/include/MsjHtmlServidor.jsp");                      
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }
    
    protected void addCertificadoAsegurado (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        try {
            Usuario oUser = (Usuario)(request.getSession (true).getAttribute("user"));
            int iEstado   = 0;
            Certificado oCert = new Certificado ();

            oCert.setnumCertificado(0);
            oCert.setestadoCertificado(iEstado);
            
            oCert.settipoCertificado("PZ");
            oCert.setnumPoliza(request.getParameter ("num_poliza") == null || 
                                  request.getParameter ("num_poliza").equals ("") ? 0 : 
                                  Integer.parseInt (request.getParameter ("num_poliza")));
            oCert.setcodRama   (request.getParameter ("cod_rama") == null || 
                                  request.getParameter ("cod_rama").equals ("") ? 0 : 
                                  Integer.parseInt (request.getParameter ("cod_rama")));

            oCert.setmodoVisualizacion(Integer.parseInt(request.getParameter("modo_visual")));                                      
            
            oCert.settipoEnvioOrig  (1);
            oCert.setdescModoEnvio  ("No deseo recbirlo");
            oCert.setuserId         (oUser.getusuario());
            oCert.setcodProd        (oUser.getiCodProd());
            oCert.settipoDoc        (request.getParameter ("tipo_doc"));
            oCert.setnumDoc         (request.getParameter ("num_doc"));
            oCert.setitem           (request.getParameter("item") == null ? 0 : Integer.parseInt (request.getParameter("item")));

            oCert.setpresentar      (request.getParameter ("presentar") == null ? " " : request.getParameter ("presentar")) ;
            dbCon = db.getConnection();
            oCert.setDBAsegurado(dbCon);

// setear el control de acceso
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, 11);
                          
// fin de setear el control de acceso 
            
            if (oCert.getnumCertificado() > 0) {
                response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
                response.setHeader("Location",Param.getAplicacion() + "certificado/printCertificado.jsp?tipo_cert=PZ&numCert=" + oCert.getnumCertificado() + "&tipo=html&volver=-1");
            } else {
                String sMensaje = "";                
                switch (oCert.getnumCertificado()) {
                    case -100: // la poliza no existe
                        sMensaje = "La p&oacute;liza solicitada no existe o no se encuentra registrada en la web.<br> Por favor comiquese con su representante.</br></br>Muchas Gracias.";
                        break;

                    case -200: // ya existe un certificado el mismo dia
                        sMensaje = "Ya existe una solicitud de Certificado de Cobertura para la poliza ingresada en el d&iacute;a de la fecha.<br>Por favor ingrese por Certificado -> Mis Certificados.</br></br>Muchas Gracias.";
                        break;

                    case -300: // la poliza no esta vigente
                        sMensaje = "La p&oacute;liza no esta vigente.</br></br>Muchas Gracias.";
                        break;

                    case -400: // existe deuda
                        sMensaje = "La p&oacute;liza registra una deuda pendinte.<br> Ante cualquier duda por favor comiquese con su representante.</br></br>Muchas Gracias.";
                        break;

                    case -500: // LA PóLIZA esta anulada
                        sMensaje = "La p&oacute;liza esta anulada.";
                        break;

                    case -600: // El asegurado esta dado de baja
                        sMensaje = "Actualmente el asegurado esta dado de baja";
                        break;
                    case -700: // LA PóLIZA esta anulada
                        sMensaje = "La p&oacute;liza aun no tiene CUIC asignado. Puede ser que a&uacute;n este pendiente o no haya sido aprobada por la SSN.";
                        break;

                    default: // normal html
                        sMensaje = "Hubo alg&uacute;n problema en el alta del Certificado de Cobertura solicitado. Por favor, comuniquese con su representante</br></br>Muchas Gracias.";
                        Email oEmail = new Email ();
                        oEmail.setSubject("Beneficio Web - Aviso de ERROR ");
                        oEmail.setContent(sMensaje);
                        
                        LinkedList lDest = oEmail.getDBDestinos(dbCon, 0, "ERROR");

                        for (int i=0; i < lDest.size();i++) {
                            Persona oPers = (Persona) lDest.get(i);
                            oEmail.setDestination(oPers.getEmail());
                         //   oEmail.sendMessage();
                            oEmail.sendMessageBatch();
                        }
                        
                    }
                    request.setAttribute("mensaje", sMensaje);                
                    request.setAttribute("volver", "-1");             
                    doForward (request, response, "/include/MsjHtmlServidor.jsp");                      
                }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }
    

    protected void getAllCertificados (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        CallableStatement cons = null;
        LinkedList lCert = new LinkedList();
        try {
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
           
            dbCon = db.getConnection();
            dbCon.setAutoCommit(false);
            
            cons = dbCon.prepareCall(db.getSettingCall("CE_GET_ALL_CERTIFICADOS(?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString (2, oUser.getusuario());
            
            cons.execute();
            
            ResultSet rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    Certificado oCert = new Certificado ();
                    oCert.settipoCertificado    (rs.getString("TIPO_CERTIFICADO"));
                    oCert.setnumCertificado     (rs.getInt("NUM_CERTIFICADO"));
                    oCert.setfechaEmision       (rs.getDate("FECHA_EMISION"));
          //          oCert.setfechaInicioSuceso  (rs.getDate("FECHA_INI_SUCESO"));
         //           oCert.setfechaFinSuceso     (rs.getDate("FECHA_FIN_SUCESO"));
                    oCert.setfechaTrabajo       (rs.getDate("FECHA_TRABAJO"));
                    oCert.sethoraOperacion      (rs.getString("HORA_OPERACION"));
                    oCert.setcodRama            (rs.getInt("COD_RAMA"));
                    oCert.setcodSubRama         (rs.getInt("COD_SUB_RAMA"));
                    oCert.setcodCobFinal        (rs.getInt("COD_COB_FINAL"));
                    oCert.setcantDias           (rs.getInt("CANT_DIAS"));
                    oCert.setestadoCertificado  (rs.getInt("ESTADO"));
                    oCert.setimprSubdiario      (rs.getString("PRT_SUBDIARIO"));
                    oCert.setimprSumas          (rs.getString("PRT_SUMAS"));
                    oCert.setimprDocumento      (rs.getString("PRT_DOCUMENTO"));
                    oCert.setimprBenef          (rs.getString("PRT_BENEF"));
                    oCert.setimprReducido       (rs.getString("PRT_REDUCIDO"));
                    oCert.setuserId             (rs.getString("USUARIO"));
                    oCert.setnumPoliza          (rs.getInt("NUM_POLIZA"));
                    oCert.setnumPropuesta       (rs.getInt("NUM_PROPUESTA"));
                    oCert.setmodoVisualizacion  (rs.getInt("MODO_VISUALIZACION"));
                    oCert.settipoEnvioOrig      (rs.getInt("MODO_ENVIO"));
                    oCert.setcodProd            (rs.getInt("COD_PROD"));
                    oCert.setdescProd           (rs.getString ("DESC_PROD"));
                    
                    lCert.add(oCert);
                }
            }

            request.setAttribute("certificados", lCert);
            doForward (request, response, "/certificado/consCertificados.jsp");
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }

    protected void getPrintCertificado (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        LinkedList lCert = new LinkedList();
        try {
            int numCertificado = Integer.parseInt (request.getParameter ("numCert"));
            String tipoCert    = request.getParameter ("tipo_cert");
            boolean viewPDF    = (request.getParameter ("tipo") != null && request.getParameter ("tipo").equals ("pdf") ? true : false);
            
            Certificado oCert = new Certificado ();
            oCert.setnumCertificado (numCertificado);
            oCert.settipoCertificado(tipoCert);
            
            /**********************************/
            /* NUEVO Silvio 26-04-2008 INICIO*/    
            // System.out.println(" \n MODIF: getPrintCertificado"  );
            // System.out.println(" ingreso tipo " + tipoCert );
            
            if (viewPDF) {
                if (tipoCert.equals("PR") || tipoCert.equals("EN")) { 
                    this.getPrintPropAcrobat (request, response, oCert);
                } else {
                    this.getPrintAcrobat (request, response, oCert);
                }    
            } else {
                if (tipoCert.equals("PR") || tipoCert.equals("EN")) { 
                    this.getPrintPropHTML(request, response, oCert);
                } else {                    
                    this.getPrintHTML(request, response, oCert);
                }    
            }
            /* NUEVO Silvio 26-04-2008 FIN*/                                    
            /**********************************/            
         
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } 
    }

    protected void getCertificado (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        
        try {
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            int numCertificado = Integer.parseInt (request.getParameter ("numCert"));
            String tipoCert    = request.getParameter("tipo_cert");
            
            dbCon = db.getConnection();
            Certificado oCert = new Certificado ();
            oCert.setnumCertificado (numCertificado); 
            oCert.settipoCertificado(tipoCert);
            oCert.getDB(dbCon);
            
            request.setAttribute ("certificado", oCert);
            doForward (request, response, "/certificado/formCertificado.jsp");
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }
    
    protected void getPrintHTML (HttpServletRequest request, HttpServletResponse response, Certificado oCert)
    throws ServletException, IOException, SurException {
        Connection dbCon        = null;
        LinkedList lCoberturas  = null;
        try {
            
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            
            dbCon = db.getConnection();
            oCert.getDB(dbCon);
            
            if (oCert.getiNumError() != 0) {
                throw new SurException (oCert.getsMensError());
            }
            
            PersonaCertificado oTomador = new PersonaCertificado ();
            oTomador.settipoCertificado(oCert.gettipoCertificado());
            oTomador.setnumCertificado(oCert.getnumCertificado());
            oTomador.getDBTomador(dbCon);
            
            if (oCert.getiNumError() != 0) {
                throw new SurException (oCert.getsMensError());
            }
            
            LinkedList lAsegurados = oCert.getDBAllAsegurados(dbCon); 
            
            LinkedList lAseguradosAux = new LinkedList ();
            
            if (lAsegurados != null && lAsegurados.size() > 0 ) {
                for (int i = 0; i< lAsegurados.size();i++) {
                    PersonaCertificado oAseg = (PersonaCertificado) lAsegurados.get(i);
                    oAseg.setlCoberturas    (oAseg.getDBCoberturasAseg(dbCon));   
                    
                    if ( i == 0) {
                        lCoberturas = oAseg.getlCoberturas ();                                            
                    }
                    lAseguradosAux.add(oAseg);
                }
            }
            
            LinkedList lClausulas = new LinkedList ();
            
            if (oCert.getclaNoRepeticion().equals("S") || oCert.getclaSubrogacion().equals("S")) {
                lClausulas  = oCert.getDBAllEmpresasClausulas(dbCon);
            }
            
            LinkedList lTextoVar  = oCert.getDBAllTextoVariable(dbCon);

            request.setAttribute("certificado", oCert);
            request.setAttribute("tomador", oTomador);
            request.setAttribute("asegurados", lAseguradosAux);
            request.setAttribute("coberturas", lCoberturas);
            request.setAttribute("clausulas", lClausulas);
            request.setAttribute("textoVar", lTextoVar);
            
            doForward (request, response, "/certificado/report/certificadoHTML.jsp");

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void getPrintAcrobat (HttpServletRequest request, HttpServletResponse response, Certificado oCert)
    throws ServletException, IOException, SurException {
        Connection dbCon        = null;
        try {
            dbCon = db.getConnection();

            if (dbCon == null ) {
                db.realPath (getServletConfig().getServletContext ().getRealPath("/propiedades/config.xml"));
                if (Param.getAplicacion() == null) {
                    Param.realPath (getServletContext().getRealPath("/propiedades/config.xml"));
                }
            }
            oCert.getDB(dbCon);   

            if (oCert.getiNumError() != 0) {
                throw new SurException (oCert.getsMensError());
            }

            Usuario user =  null;

            if (oCert.getmodoVisualizacion() == 5 ) { // PORTAL WEB
                user = new Usuario();
                user.setusuario("WEB");
            } else {
                user =  (Usuario) (request.getSession().getAttribute("user"));
            }


            Report oReport = new Report ();

            oReport.setTitulo       ("Certificado Cobertura");
            oReport.addlObj         ("subtitulo" , "CERTIFICADO DE COBERTURA"); 
            oReport.setUsuario      (user.getusuario());
            oReport.setFecha        (Fecha.toString(new java.util.Date ()));
            oReport.setFormulario   ("CERT001");
            oReport.setReportName   (getServletContext ().getRealPath("/certificado/report/certificado.xml"));
            oReport.setsContextPath ( request.getScheme() + "://" + request.getHeader("host"));
            oReport.addImage        ("logo", getServletContext ().getRealPath("/images/logos/logo_beneficio_new.jpg"));
//            oReport.addImage        ("firma", getServletContext ().getRealPath("/images/firmaBenef.jpg"));
            oReport.addImage        ("firma", getServletContext ().getRealPath("/images/firmaAlfredo.jpg"));            
            
// datos del certificado
            oReport.addlObj("C_NUM_POLIZA", Formatos.showNumPoliza(oCert.getnumPoliza()));
            oReport.addlObj("C_RAMA", oCert.getdescRama());           
            oReport.addlObj("C_PRESENTAR", (oCert.getpresentar() == null ? " " : oCert.getpresentar()));
            oReport.addlObj("C_CLA_NO_REPETICION", (oCert.getclaNoRepeticion().equals ("N") ? " " : "NO REPETICION")  );
            oReport.addlObj("C_CLA_SUBROGACION", (oCert.getclaSubrogacion().equals ("N") ? " " : "SUBROGACION")  );

            if (oCert.getnivelCob().equals("P")) {
                oReport.addCondicion("NIVEL_COB_POLIZA", "true");
            } else {
                oReport.addCondicion("NIVEL_COB_POLIZA", "false");
            }
            if (oCert.getcodRama() == 21 && oCert.getcodProducto() == 1) {
                oReport.addCondicion("SVO", "true");
                oReport.addCondicion("NO_SVO", "false");
            } else {
                oReport.addCondicion("SVO", "false");
                oReport.addCondicion("NO_SVO", "true");                
            }

            StringBuffer sbMens = new StringBuffer();
            if (oCert.getfechaTrabajo().before(oCert.getfechaInicioSuceso()) ) {
                sbMens.append(" El presente certificado tiene vigencia a partir de la fecha de inicio de vigencia de la póliza.");
            } else {
                sbMens.append(" El presente certificado tiene vigencia a partir de su fecha de emisión.");
            }
            sbMens.append(" La fecha de inicio de cobertura se indica en la línea respectiva de cada asegurado.");
            oReport.addlObj("C_DIAS",sbMens.toString());
            
            PersonaCertificado oTomador = new PersonaCertificado ();
            oTomador.settipoCertificado(oCert.gettipoCertificado());
            oTomador.setnumCertificado(oCert.getnumCertificado());
            oTomador.getDBTomador(dbCon);

// datos del tomador
            oReport.addlObj("T_TOMADOR", oTomador.getrazonSocial());           
            oReport.addlObj("T_CUIT", oTomador.getcuit());
            oReport.addlObj("T_DOMICILIO", oTomador.getdomicilio());
            oReport.addlObj("T_LOCALIDAD", oTomador.getlocalidad() + " - (" + oTomador.getcodPostal() + ") - " + oTomador.getprovincia());
            
// datos generales del certificado
            oReport.addlObj("C_FECHA_VIG_DESDE", (oCert.getfechaInicioSuceso() == null ? " " : Fecha.showFechaForm(oCert.getfechaInicioSuceso())));
            oReport.addlObj("C_FECHA_VIG_HASTA", (oCert.getfechaFinSuceso() == null ? " sin fin de vigencia" : Fecha.showFechaForm(oCert.getfechaFinSuceso())));
            oReport.addlObj("C_SUB_RAMA", oCert.getdescSubRama ());
            oReport.addlObj("C_FECHA_TRABAJO", (oCert.getfechaTrabajo() == null ? " " : Fecha.showFechaForm(oCert.getfechaTrabajo()))); 
            
            LinkedList lAsegurados = oCert.getDBAllAsegurados(dbCon); 

            if (lAsegurados != null && lAsegurados.size() > 0 ) {
                oReport.addIniTabla("TABLA_ASEGURADOS");                
                String sStyle[] = {"ItemCobL", "ItemCobR", "ItemCobL", "ItemCobL"};
               
                for (int i = 0; i< lAsegurados.size();i++) {
                    PersonaCertificado oAseg = (PersonaCertificado) lAsegurados.get(i);
                    String sElem [] = { oAseg.getitem() + ") " + oAseg.getrazonSocial() , oAseg.getdescTipoDoc() , 
                                        oAseg.getnumDoc(),(oAseg.getfechaAlta() == null ? " " : ("Inicio cobertura: " +
                                            Fecha.showFechaForm(oAseg.getfechaAlta()) + " " + (oCert.getcodRama() == 10 ? "12:00 hs." : "00:00 hs." )  ))  };
                    oReport.addElementsTabla(sElem, sStyle); 
                    
                    if ( oCert.getnivelCob().equals("N")) {  
                        oAseg.setlCoberturas    (oAseg.getDBCoberturasAseg(dbCon));
                        if (oAseg.getiNumError() < 0) {
                            throw new SurException( oAseg.getsMensError() );
                        }
                        int itemAnt = 0;
                        for (int j=0; j < oAseg.getlCoberturas().size(); j++) {
                            AsegCobertura oCob = (AsegCobertura) oAseg.getlCoberturas().get(j);
                            if (itemAnt == oCob.getsubItem()) {
                            String sCob [] = { (".       " + oCob.getdescCob()) , (oCert.getsimboloMoneda() + "  " + Dbl.DbltoStr(oCob.getimpSumaRiesgo(),2)), " ", " "};
                            oReport.addElementsTabla(sCob, sStyle);
                            }  else {
                                itemAnt = oCob.getsubItem();
                                String sCob [] = { (" " + oCob.getitem()+ "." + oCob.getsubItem() + " - " + oCob.getnombre() + " (" +  oCob.getdescParentesco()+")" ) , "DNI: ", oCob.getnumDoc(),(oAseg.getfechaAlta() == null ? " " : ("Inicio cobertura: " +
                                            Fecha.showFechaForm(oAseg.getfechaAlta()) + " " + (oCert.getcodRama() == 10 ? "12:00 hs." : "00:00 hs." )  ))  };
                                oReport.addElementsTabla(sCob, sStyle);
                                String sCob2 [] = { (".       " + oCob.getdescCob()) , (oCert.getsimboloMoneda() + "  " + Dbl.DbltoStr(oCob.getimpSumaRiesgo(),2)), " ", " "};
                                oReport.addElementsTabla(sCob2, sStyle);
                            }
                        }

                        LinkedList lAsegBenef = oAseg.getDBBeneficiarios(dbCon);
                        if (lAsegBenef.size() > 0 ) {
                            StringBuilder sb = new StringBuilder();
                            sb.append("    Beneficiario/s: ");
                            for (int j=0; j < lAsegBenef.size(); j++) {
                                AsegBeneficiario oBenef = (AsegBeneficiario) lAsegBenef.get(j);
                                sb.append(oBenef.getrazonSocial());
                                sb.append(" ");
                            }
                            String sBenef [] = { sb.toString() , " ", " ", " "};
                            oReport.addElementsTabla(sBenef, sStyle);
                        }
                    }
                }
                oReport.addFinTabla();
            }

            if (oCert.getnivelCob().equals("P")) {
                oReport.addIniTabla("TABLA_COBERTURAS");                
                String sStyle[] = {"ItemCobL", "ItemCobR", "ItemCobL", "ItemCobL"};
                PersonaCertificado oAseg = (PersonaCertificado) lAsegurados.get(0);
                oAseg.setlCoberturas    (oAseg.getDBCoberturasAseg(dbCon));
                if (oAseg.getiNumError() < 0) {
                    throw new SurException( oAseg.getsMensError() );
                }
                int itemAnt = 0;
                for (int j=0; j < oAseg.getlCoberturas().size(); j++) {
                    AsegCobertura oCob = (AsegCobertura) oAseg.getlCoberturas().get(j);
                    if (itemAnt == oCob.getsubItem()) {
                    String sCob [] = { (".       " + oCob.getdescCob()) , (oCert.getsimboloMoneda() + "  " + Dbl.DbltoStr(oCob.getimpSumaRiesgo(),2)), " ", " "};
                    oReport.addElementsTabla(sCob, sStyle);
                    }  else {
                        itemAnt = oCob.getsubItem();
                        String sCob [] = { (" " + oCob.getitem()+ "." + oCob.getsubItem() + " - " + oCob.getnombre() + " (" +  oCob.getdescParentesco()+")" ) , "DNI: ", oCob.getnumDoc(),(oAseg.getfechaAlta() == null ? " " : ("Inicio cobertura: " +
                                    Fecha.showFechaForm(oAseg.getfechaAlta())))  };
                        oReport.addElementsTabla(sCob, sStyle);
                        String sCob2 [] = { (".       " + oCob.getdescCob()) , (oCert.getsimboloMoneda() + "  " + Dbl.DbltoStr(oCob.getimpSumaRiesgo(),2)), " ", " "};
                        oReport.addElementsTabla(sCob2, sStyle);
                    }
                }

                LinkedList lAsegBenef = oAseg.getDBBeneficiarios(dbCon);
                if (lAsegBenef.size() > 0 ) {
                    StringBuilder sb = new StringBuilder();
                    sb.append("    Beneficiario/s: ");
                    for (int j=0; j < lAsegBenef.size(); j++) {
                        AsegBeneficiario oBenef = (AsegBeneficiario) lAsegBenef.get(j);
                        sb.append(oBenef.getrazonSocial());
                        sb.append(" ");
                    }
                    String sBenef [] = { sb.toString() , " ", " ", " "};
                    oReport.addElementsTabla(sBenef, sStyle);
                }
                 oReport.addFinTabla();              
            }
            if (oCert.getclaNoRepeticion().equals("S") || oCert.getclaSubrogacion().equals("S")) {
                oReport.addCondicion("CLAUSULAS", "true");                
                LinkedList lClausulas  = oCert.getDBAllEmpresasClausulas(dbCon);

                oReport.addIniTabla("TABLA_CLAUSULAS");                
                String sStyle [] = {"ItemTextoVar"};                
                for (int i = 0; i< lClausulas.size();i++) {
                    Clausula oCla = (Clausula) lClausulas.get(i);

                    String sElem [] = {oCla.getdescEmpresa() + ( oCla.getcuitEmpresa() == null || oCla.getcuitEmpresa().equals ("") ? " " :  ( " - Cuit " + oCla.getcuitEmpresa() )) };

                    oReport.addElementsTabla(sElem, sStyle); 
                }
                oReport.addFinTabla();
            } else {
                oReport.addCondicion("CLAUSULAS", "false");                                
            }
            
            LinkedList lTextoVar  = oCert.getDBAllTextoVariable(dbCon);

            if (lTextoVar.size() > 1 ) {
                oReport.addCondicion("HAY_TEXTOS", "true");                                
                oReport.addCondicion("NO_TEXTOS", "false");                                            
            } else {
                oReport.addCondicion("HAY_TEXTOS", "false");                                
                oReport.addCondicion("NO_TEXTOS", "true");                                            
            }
            
            oReport.addIniTabla("TABLA_TEXTOS");                
            String sStyle2 [] = {"ItemTextoVar"};                
            for (int i = 0; i< lTextoVar.size();i++) {
                TextoCertificado oTexto = (TextoCertificado) lTextoVar.get(i);

                String sElem [] = {oTexto.gettexto()};

                oReport.addElementsTabla(sElem, sStyle2); 
            }
            oReport.addFinTabla();

            request.setAttribute("nombre", "certificado_" + oCert.getnumCertificado() + ".pdf");
            if (oCert.getmodoVisualizacion() == 5 ) { // PORTAL WEB
                request.setAttribute("oReport", oReport );
                doForward (request,response, "/servlet/ReportPdfWeb");
            } else {
                request.setAttribute("oReport", oReport );
                doForward (request,response, "/servlet/ReportPdf");
            }
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }
    
    
    
    /**************************************************************************/
    /* NUEVO Silvio 26-04-2008 INICIO*/
    
    
    protected void addCertificadoProp  (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        
        Connection dbCon = null;
        
        try {
        
            Usuario oUser  = (Usuario) (request.getSession().getAttribute("user"));
            String sVolver = (request.getParameter ("volver") == null ? "getAllCert" : request.getParameter ("volver")); 
            int iEstado        = 0;
            int iNumPoliza     = 0;
            int numPropuesta   = Integer.parseInt (request.getParameter ("num_propuesta"));
            int numCertificado = Integer.parseInt (request.getParameter ("numCert"));
            int codRama        = request.getParameter ("cod_rama") == null ||
                                 request.getParameter ("cod_rama").equals ("") ? 0 :
                                 Integer.parseInt (request.getParameter ("cod_rama"));            
                                 
            Integer.parseInt (request.getParameter ("cod_rama"));
            String presentar   = request.getParameter ("presentar");
            String tipoCert    = request.getParameter ("tipo_cert");           

            Certificado oCert = new Certificado ();
            oCert.setnumCertificado   (numCertificado); 
            oCert.setnumPropuesta     (numPropuesta);            
            oCert.settipoCertificado  (tipoCert);    
            oCert.setmodoVisualizacion(3);//html
            oCert.setcantDias         (15);
            oCert.setcodRama          (codRama);            
            oCert.setuserId           (oUser.getusuario());
            oCert.setpresentar        (presentar);
            
            oCert.setestadoCertificado(iEstado);
            oCert.setnumPoliza        (iNumPoliza);                                    
            oCert.settipoEnvioOrig    (1);  // consultar
            
            
            dbCon = db.getConnection();
            
            oCert.setDBPropuesta(dbCon);
            
            if (oCert.getiNumError() < 0) {
                throw new SurException (oCert.getsMensError());
            }
            
            // ---------------------------
            // setear el control de acceso
            ControlDeUso oControl = (ControlDeUso)(request.getSession (true).getAttribute("controlUso"));
            oControl.setearAcceso(dbCon, 21);
            // fin de setear el control de acceso
            // --------------------------
             
            if (oCert.getnumCertificado() > 0) {
                response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
                response.setHeader("Location",Param.getAplicacion() + "certificado/printCertificado.jsp?tipo_cert=" + oCert.gettipoCertificado() + "&numCert=" + oCert.getnumCertificado() + "&tipo=html&volver=" + sVolver );                
                
            } else {
                String sMensaje = "";
                /*
                -100; -- Tipo de certificado Incorrecto.-
                -101; -- El certificado ya existe.-
                -102; -- Problema al obtener la propuesta - No existe o estado de la misma invalido para generar certifiado.-
                -104; -- La propuesta informada ya tiene un certificado .-
                -105; -- La rama informada es incorrecta.-
                -106; -- La propuesta no esta vigente
                */
                switch (oCert.getnumCertificado()) {
                    case -100: 
                        sMensaje = "Tipo de certificado Incorrecto.-<br> Por favor comiquese con su representante.</br></br>Muchas Gracias.";
                        break;

                    case -101: 
                        sMensaje = "El certificado ya existe.-</br></br>Muchas Gracias.";
                        break;

                    case -102: 
                        sMensaje = "Problema al obtener la propuesta - No existe o estado de la misma invalido para generar certifiado.-</br></br>Muchas Gracias.";
                        break;
                    
                    case -104: 
                        sMensaje = "La propuesta informada ya tiene un certificado .-</br></br>Muchas Gracias.";
                        break;
                    
                    case -105: 
                        sMensaje = "La rama informada es incorrecta.-</br></br>Muchas Gracias.";
                        break;
                        
                    case -106: 
                        sMensaje = "La propuesta no esta vigente.-</br></br>Muchas Gracias.";
                        break; 
                        
                    default: 
                        sMensaje = "Hubo algún problema en el alta del Certificado de Cobertura solicitado. Por favor, comuniquese con su representante</br></br>Muchas Gracias.";

                        Email oEmail = new Email ();
                        oEmail.setSubject("Beneficio Web - Aviso de ERROR ");
                        oEmail.setContent(sMensaje);
                        
                        LinkedList lDest = oEmail.getDBDestinos(dbCon, 0, "ERROR");
                         
                        for (int i=0; i < lDest.size();i++) {
                            Persona oPers = (Persona) lDest.get(i);
                            oEmail.setDestination(oPers.getEmail());
                          //  oEmail.sendMessage();
                            oEmail.sendMessageBatch();
                        }
                    }
                request.setAttribute("mensaje", sMensaje);                
                request.setAttribute("volver", "-1");             
                doForward (request, response, "/include/MsjHtmlServidor.jsp");                      
            }                     
          
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }    
    

    
    protected void getPrintPropHTML (HttpServletRequest request, HttpServletResponse response, Certificado oCert)
    throws ServletException, IOException, SurException {
        Connection dbCon        = null;
        CallableStatement cons  = null;
        LinkedList lCoberturas  = null;
        try {
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));
            
            dbCon = db.getConnection();
            oCert.getDB(dbCon);
            
            if (oCert.getiNumError() != 0) {
                throw new SurException (oCert.getsMensError());
            }
            
            PersonaCertificado oTomador = new PersonaCertificado ();
            oTomador.settipoCertificado(oCert.gettipoCertificado());
            oTomador.setnumCertificado(oCert.getnumCertificado());
            oTomador.getDBTomador(dbCon);
            
            if (oCert.getiNumError() != 0) {
                throw new SurException (oCert.getsMensError());
            }
            
            LinkedList lAsegurados = oCert.getDBAllAsegurados(dbCon); 
            
            LinkedList lAseguradosAux = new LinkedList ();
            
            if (lAsegurados != null && lAsegurados.size() > 0 ) {
                for (int i = 0; i< lAsegurados.size();i++) {
                    PersonaCertificado oAseg = (PersonaCertificado) lAsegurados.get(i);                                       
                    oAseg.setlCoberturas    (oAseg.getDBCoberturasAseg(dbCon));   
                    
                    if ( i == 0) {
                        lCoberturas = oAseg.getlCoberturas ();                                            
                    }
                    lAseguradosAux.add(oAseg);
                }
            }          
            
            LinkedList lTextoVar  = oCert.getDBAllTextoVariable(dbCon);

            request.setAttribute("certificado", oCert);
            request.setAttribute("tomador"    , oTomador);
            request.setAttribute("asegurados" , lAseguradosAux);
            request.setAttribute("coberturas" , lCoberturas);
            request.setAttribute("textoVar"   , lTextoVar);
            
            doForward (request, response, "/certificado/propuesta/report/certificadoPropHTML.jsp");

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            try {
                if (cons != null) cons.close ();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            db.cerrar(dbCon);
        }
    }    

    protected void getPrintPropAcrobat (HttpServletRequest request, HttpServletResponse response, Certificado oCert)
    throws ServletException, IOException, SurException {
        Connection dbCon        = null;
        try {
            Usuario user = (Usuario) (request.getSession().getAttribute("user"));
            dbCon = db.getConnection();
            oCert.getDB(dbCon);   
            
            if (oCert.getiNumError() != 0) {
                throw new SurException (oCert.getsMensError());
            }

            Report oReport = new Report ();
            oReport.setTitulo       ("Certificado Cobertura");
            if (oCert.gettipoCertificado().equals ("PR")) {
                oReport.addlObj         ("subtitulo" , "Certificado de cobertura");
            } else {
                oReport.addlObj         ("subtitulo" , "Constancia de movimientos de asegurados");                
            }

            oReport.setUsuario      (user.getusuario());
            oReport.setFecha        (Fecha.toString(new java.util.Date ()));
            oReport.setFormulario   ("CERT001");
            oReport.setReportName   (getServletContext ().getRealPath("/certificado/propuesta/report/certificadoProp.xml"));
            oReport.setsContextPath ( request.getScheme() + "://" + request.getHeader("host"));
            oReport.addImage        ("logo", getServletContext ().getRealPath("/images/logos/logo_beneficio_new.jpg"));
            oReport.addImage        ("firma", getServletContext ().getRealPath("/images/firmaBenef.jpg"));
            oReport.addlObj("C_NUM_CERTIFICADO", String.valueOf(oCert.getnumCertificado()));            
            
            oReport.addlObj("C_RAMA", oCert.getdescRama());           
            oReport.addlObj("C_PRESENTAR", oCert.getpresentar());

            StringBuilder sDias = new StringBuilder();
            if (oCert.getcodProd() == 16381) {
                sDias.append("30 ");
            } else {
                sDias.append("15 ");
            }
            oReport.addlObj("C_DIAS", sDias.toString());
            
            PersonaCertificado oTomador = new PersonaCertificado ();
            oTomador.settipoCertificado(oCert.gettipoCertificado());
            oTomador.setnumCertificado(oCert.getnumCertificado());
            oTomador.getDBTomador(dbCon);

            // datos del tomador -- 26/02/2015
            oReport.addlObj("T_TOMADOR", oTomador.getrazonSocial());
            if ( oTomador.getcuit() != null && ! oTomador.getcuit().equals("00000000000")) {
                oReport.addlObj("T_CUIT", oTomador.getcuit());
            } else {
                oReport.addlObj("T_CUIT", oTomador.getnumDoc());
            }
            oReport.addlObj("T_DOMICILIO", oTomador.getdomicilio());
            oReport.addlObj("T_LOCALIDAD", oTomador.getlocalidad() + " - (" + oTomador.getcodPostal() + ") - " + oTomador.getprovincia());
            
            // datos generales del certificado 
            oReport.addlObj("C_FECHA_VIG_DESDE", (oCert.getfechaInicioSuceso() == null ? " " : Fecha.showFechaForm(oCert.getfechaInicioSuceso())));
            oReport.addlObj("C_FECHA_VIG_HASTA", (oCert.getfechaFinSuceso() == null ? " " : Fecha.showFechaForm(oCert.getfechaFinSuceso())));
            oReport.addlObj("C_SUB_RAMA", oCert.getdescSubRama ());
            oReport.addlObj("C_FECHA_TRABAJO", (oCert.getfechaTrabajo() == null ? " " : Fecha.showFechaForm(oCert.getfechaTrabajo()))); 
            
            LinkedList lAsegurados = oCert.getDBAllAsegurados(dbCon); 

            oReport.addCondicion("UNICO_ASEGURADO", "false");

/*            if (oCert.gettipoCertificado().equals ("PR") && lAsegurados != null && lAsegurados.size() == 1) {
                oReport.addCondicion("UNICO_ASEGURADO", "true");
                oReport.addIniTabla("TABLA_COBERTURAS");                
                String sStyle[] = {"ItemCobL", "ItemCobR"};                
                for (int i = 0; i< lAsegurados.size();i++) {   
                    PersonaCertificado oAseg = (PersonaCertificado) lAsegurados.get(i);
                    oAseg.setlCoberturas    (oAseg.getDBCoberturasAseg(dbCon));   
                    for (int j=0; j < oAseg.getlCoberturas().size(); j++) {
                        AsegCobertura oCob = (AsegCobertura) oAseg.getlCoberturas().get(j);                        
                        String sCob [] = {".   " + oCob.getdescCob() , (oCert.getsimboloMoneda() + "  " + Dbl.DbltoStr(oCob.getimpSumaRiesgo(),2))};
                        oReport.addElementsTabla(sCob, sStyle);
                    }
                }
                
                oReport.addFinTabla();
            } else {
                oReport.addCondicion("UNICO_ASEGURADO", "false");                
            }
*/
            
            if (lAsegurados != null && lAsegurados.size() > 0 ) {
                oReport.addIniTabla("TABLA_ASEGURADOS");                
                String sStyle[] = {"ItemCobL", "ItemCobR", "ItemCobL"}; 
                String sEstadoAnt = "";
                for (int i = 0; i< lAsegurados.size();i++) {
                    PersonaCertificado oAseg = (PersonaCertificado) lAsegurados.get(i);
                    if (oCert.gettipoCertificado().equals ("EN") 
                        && oAseg.getestado().equals ("A") 
                        &&  ! oAseg.getestado().equals (sEstadoAnt) ) {
                            sEstadoAnt = oAseg.getestado();
                            String sElem [] = {"Asegurados dados de Alta" , " " , " "};
                            oReport.addElementsTabla(sElem, sStyle);                     
                    }
                    
                    if (oCert.gettipoCertificado().equals ("EN") 
                        && oAseg.getestado().equals ("B") 
                        &&  ! oAseg.getestado().equals (sEstadoAnt) ) {
                            sEstadoAnt = oAseg.getestado();
                            String sElem [] = {"Asegurados dados de Baja" , " " , " "};
                            oReport.addElementsTabla(sElem, sStyle);                     
                    }
                    
                    String sElem [] = {oAseg.getitem() + " - " + oAseg.getrazonSocial() , oAseg.getdescTipoDoc() , oAseg.getnumDoc()};
                    oReport.addElementsTabla(sElem, sStyle); 
                    oAseg.setlCoberturas    (oAseg.getDBCoberturasAseg(dbCon));
                    if (oAseg.getiNumError() < 0) {
                        throw new SurException( oAseg.getsMensError() );
                    }
                    int itemAnt = 0;
                    for (int j=0; j < oAseg.getlCoberturas().size(); j++) {
                        AsegCobertura oCob = (AsegCobertura) oAseg.getlCoberturas().get(j);
                        if (itemAnt == oCob.getsubItem()) {
                        String sCob [] = { (".       " + oCob.getdescCob()) , (oCert.getsimboloMoneda() + "  " + Dbl.DbltoStr(oCob.getimpSumaRiesgo(),2)), " "};
                        oReport.addElementsTabla(sCob, sStyle);
                        }  else {
                            itemAnt = oCob.getsubItem();
                            String sCob [] = { (" " + oCob.getitem()+ "." + oCob.getsubItem() + " - " + oCob.getnombre() + " (" +  oCob.getdescParentesco()+")" ) , "DNI: ", oCob.getnumDoc()  };
                            oReport.addElementsTabla(sCob, sStyle);
                            String sCob2 [] = { (".       " + oCob.getdescCob()) , (oCert.getsimboloMoneda() + "  " + Dbl.DbltoStr(oCob.getimpSumaRiesgo(),2)), " "};
                            oReport.addElementsTabla(sCob2, sStyle);
                        }
                    }
                }
                oReport.addFinTabla();
            }
            
            
            LinkedList lTextoVar  = oCert.getDBAllTextoVariable(dbCon);
            
            oReport.addIniTabla("TABLA_TEXTOS");                
            String sStyle[] = {"ItemTextoVar"};
            if (lTextoVar.size() > 0) {
                for (int i = 0; i< lTextoVar.size();i++) {
                    TextoCertificado oTexto = (TextoCertificado) lTextoVar.get(i);

                    String sElem [] = {oTexto.gettexto()};

                    oReport.addElementsTabla(sElem, sStyle);
                }
            } else {
                    String sElem [] = {" "};
                    oReport.addElementsTabla(sElem, sStyle);
            }
            oReport.addFinTabla();

            request.setAttribute("nombre", "certificado_" + oCert.getnumCertificado() + ".pdf");
            request.setAttribute("oReport", oReport );
            doForward (request,response, "/servlet/ReportPdf");  
            
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }   
    
    
  
    
    private String getPathFile (Connection dbCon, String tabla) throws SurException {
       CallableStatement cons  = null;   
 
       try {
           dbCon.setAutoCommit(false);
           cons = dbCon.prepareCall ( "{ ? = call \"BENEF\".\"GET_TABLAS_DESCRIPCION\" (? , ?)}");
           cons.registerOutParameter(1, java.sql.Types.VARCHAR);
           cons.setString (2, "SUBDIARIO_CERT");
           cons.setString (3, tabla);
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
    } /* getPathFile */
    
    private void generarArchivo (Connection dbCon, Date dFechaDesde, Date dFechaHasta , String path) throws SurException {
        CallableStatement  cons = null;
        ResultSet          rs   = null;
        FileOutputStream   fos  = null;
        OutputStreamWriter osw  = null;
        BufferedWriter     bw   = null;
        try {
            
            fos  = new FileOutputStream (path);
            osw  = new OutputStreamWriter (fos); //, "8859_1");
            bw   = new BufferedWriter (osw);

            dbCon.setAutoCommit(false);            
             
            cons = dbCon.prepareCall(db.getSettingCall("COT_GET_VALOR_IMPUESTO (?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.DOUBLE);
            cons.setInt (2, 10);
            cons.setInt (3, 9999);             
            cons.setInt (4, 15);             
            cons.execute();
            
            double     cantLinea = ( cons.getDouble(1) == 0 ? 45 : cons.getDouble(1));          
            int     contador = 1;
            
            String titulo    =   "BENEFICIO S.A." ;
            for (int i=0; i<8;i++) {
                titulo = titulo + " ";                                              
            }            
            titulo = titulo + "Subdiario de Certificados de Cobertura";
           
            for (int i=0; i<8;i++) {
                titulo = titulo + " ";                                              
            }                        
                                     
            // titulo = titulo + Fecha.getFechaActual() + "\n" ;
            
            titulo = titulo +  "\n" ;                                        
            /*  12 = Certificado   10 +2  
                12 = Fecha         10 + 2
                32 = Rama + chr(9) 30 +2 
                30 = Sub Rama      30                       
                12 = Fecha INI (10-12) +2     
                12 = Fecha FIN (10-12) +2       
                50 = Tomador Estado   
                -------------------
                160 Total                                 
             */            
            String linea =   "";
            for (int i=0; i<160;i++) {
                linea = linea + "=";
            }
            linea = linea + "\n";           
                                  
            String  cabecera = "Certificado"  + "\t" +
                               "Fecha   "    + "\t" +
                               "     Rama      " + "\t" +
                               "             Cobertura " + "\t" +
                               "              V.Desde  " + "\t" +
                               "   V.Hasta "  + "\t" +
                               "        Tomador                  Estado"  + "\n" ;

            cons = dbCon.prepareCall ( db.getSettingCall( "CE_GENERAR_SUBDIARIO (?, ?)"));
            cons.registerOutParameter( 1 , java.sql.Types.OTHER);
            cons.setDate             ( 2 , Fecha.convertFecha(dFechaDesde));
            cons.setDate             ( 3 , Fecha.convertFecha(dFechaHasta));
            cons.execute();           
            
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {
                    
                    if ( contador > cantLinea) {
                        contador = 1;                        
                    }
                    if (contador == 1) {
                        bw.write(titulo);
                        bw.write(linea);
                        bw.write(cabecera);
                        bw.write(linea);
                    }
                    bw.write(rs.getString ("CAMPO"));
                    contador ++;
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
            } catch (Exception se) {
                throw new SurException (se.getMessage());
            }
        }
    } /* generarArchivo */
    
    
    protected void genArchivoCertifProp (HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException , SurException{
          
        Connection dbCon = null;
        try {                       
            dbCon                 = db.getConnection(); 

            Date dFechaDesde      = Fecha.strToDate(request.getParameter("fecha_desde"));
            Date dFechaHasta      = Fecha.strToDate(request.getParameter("fecha_hasta"));
                       
            String pathFileAbs    = this.getPathFile(dbCon,"PATH_FILE");
            String nameFile       = "Certificados.txt";

            this.generarArchivo (dbCon, dFechaDesde, dFechaHasta , pathFileAbs + nameFile) ;
            
            request.setAttribute("nameFile" ,  nameFile);
            
            doForward (request, response,"/certificado/propuesta/formSubdiario.jsp");
            
        } catch (Exception e) {

            throw new SurException (e.getMessage());
            
        } finally {
            db.cerrar(dbCon);
        }     
        
    } /* genArchivoCertifProp */       
    
    protected void generarListadoExcel (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection        dbCon = null;
        xls               oXls  = new xls (); 
        CallableStatement cons  = null;
        LinkedList lCert        = new LinkedList();
        try {
            Usuario oUser = (Usuario) (request.getSession().getAttribute("user"));

            Date dFechaDesde      = Fecha.strToDate(request.getParameter("fecha_desde"));
            Date dFechaHasta      = Fecha.strToDate(request.getParameter("fecha_hasta"));
            int iCodProd          = Integer.parseInt (request.getParameter ("cod_prod"));
      
            dbCon = db.getConnection();
            dbCon.setAutoCommit(false);
            
            cons = dbCon.prepareCall(db.getSettingCall("CE_GET_ALL_CERTIFICADOS_EXCEL(?,?,?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString (2, oUser.getusuario());
            if ( request.getParameter("fecha_desde").equals("")  ) {
                cons.setDate    (3, Fecha.convertFecha(Fecha.strToDate("01/01/2004") ));
            } else {
                cons.setDate    (3, Fecha.convertFecha(dFechaDesde));
            }
            
            if ( request.getParameter("fecha_hasta").equals("")  ) {
                cons.setDate    (4, Fecha.convertFecha(Fecha.strToDate( Fecha.getFechaActual() )));
            } else {
                cons.setDate    (4, Fecha.convertFecha(dFechaHasta));
            }
            cons.setInt     (5, iCodProd );
            
            cons.execute();
            
            ResultSet rs = (ResultSet) cons.getObject(1);
            if (rs != null) {                
                oXls.setTitulo("Certificados de Cobertura"); 

                LinkedList lRow    = new LinkedList();
                lRow.add( "CERTIFICADOS DE COBERTURA" );            
                oXls.setRows(lRow);

                lRow   = new LinkedList();
                lRow.add(" ");
                oXls.setRows(lRow);                

                lRow    = new LinkedList();            
                lRow.add( "F.Desde: " + (request.getParameter("fecha_desde").equals ("") ? "no informado" : request.getParameter("fecha_desde")));                            
                oXls.setRows(lRow);                                                   

                lRow   = new LinkedList();
                lRow.add(" ");
                oXls.setRows(lRow);                

                lRow    = new LinkedList();
                lRow.add( "F.Hasta: " + (request.getParameter("fecha_hasta").equals ("") ? "fecha actual" : request.getParameter("fecha_hasta")));                            
                oXls.setRows(lRow);                                                              

                lRow   = new LinkedList();
                lRow.add(" ");
                oXls.setRows(lRow);                

                lRow    = new LinkedList();
                lRow.add( "CodProd: " +  iCodProd);
                oXls.setRows(lRow);                                                              

                lRow   = new LinkedList();
                lRow.add(" ");
                oXls.setRows(lRow);                

                lRow    = new LinkedList();
                lRow.add("TIPO_CERTIFICADO");
                lRow.add("NUM_CERTIFICADO");
                lRow.add("COD_RAMA");
                lRow.add("RAMA");
                lRow.add("COD_SUB_RAMA");
                lRow.add("SUB_RAMA");
                lRow.add("NUM_POLIZA");
                lRow.add("NUM_PROPUESTA");
                lRow.add("FECHA_EMISION");
                lRow.add("USUARIO");
                lRow.add("DESC_USUARIO");
                lRow.add("FECHA_TRABAJO");
                lRow.add("HORA_OPERACION");
                lRow.add("COD_PROD");
                lRow.add("DESC_PROD");
                lRow.add("TD_TOMADOR");
                lRow.add("NU_TOMADOR");
                lRow.add("RZ_TOMADOR");
                lRow.add("LOCALIDAD");
                lRow.add("PROVINCIA");
                lRow.add("DEUDA");
                lRow.add("PAGOS");
  //              lRow.add("TD_ASEGURADO");
  //              lRow.add("NU_ASEGURADO");
  //              lRow.add("RZ_ASEGURADO");              

                oXls.setRows(lRow);                                                              

                while (rs.next()) {                    
                    lRow   = new LinkedList();  
                    lRow.add( rs.getString ("TIPO_CERTIFICADO"));
                    lRow.add( rs.getString ("NUM_CERTIFICADO"));
                    lRow.add( rs.getString ("COD_RAMA"));
                    lRow.add( rs.getString ("RAMA"));
                    lRow.add( rs.getString ("COD_SUB_RAMA"));
                    lRow.add( rs.getString ("SUB_RAMA"));
                    lRow.add( Formatos.showNumPoliza(rs.getInt ("NUM_POLIZA")));
                    lRow.add( rs.getString ("NUM_PROPUESTA"));
                    lRow.add( rs.getString ("FECHA_EMISION"));
                    lRow.add( rs.getString ("USUARIO"));
                    lRow.add( rs.getString ("DESC_USUARIO"));
                    lRow.add( rs.getString ("FECHA_TRABAJO"));
                    lRow.add( rs.getString ("HORA_OPERACION"));
                    lRow.add( rs.getString ("COD_PROD"));
                    lRow.add( rs.getString ("DESC_PROD"));
                    lRow.add( rs.getString ("TD_TOMADOR"));
                    lRow.add( rs.getString ("NU_TOMADOR"));
                    lRow.add( rs.getString ("RZ_TOMADOR"));
                    lRow.add( rs.getString ("LOCALIDAD"));
                    lRow.add( rs.getString ("PROVINCIA"));
                    lRow.add(rs.getDouble("IMP_DEUDA"));
                    lRow.add(rs.getString ("PAGOS"));
   //                 lRow.add( rs.getString ("TD_ASEGURADO"));
   //                 lRow.add( rs.getString ("NU_ASEGURADO"));
   //                 lRow.add( rs.getString ("RZ_ASEGURADO"));              
                    
                    oXls.setRows(lRow);
                }
            }
            
            request.setAttribute("oReportXls", oXls);
            doForward( request, response, "/servlet/ReportXls");     
        } catch (Exception se) {
            throw new SurException (se.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    } /* END -- exportarCarteraVigente */    

    // ---------------------------------------------------------------------->>>    
    protected void getAllCertificadosIBSS (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        LinkedList lCertificadoIBSS = new LinkedList ();
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            Diccionario oDicc   = (Diccionario) (request.getSession().getAttribute("Diccionario"));           
            int iCodProd        = oDicc.getInt (request, "ce_cod_prod");
            dbCon = db.getConnection();
            lCertificadoIBSS = getCertificadosIBSS (dbCon,iCodProd);
            request.setAttribute("certificadoIBSS", lCertificadoIBSS);
            doForward(request, response, "/certificado/filtrarCertificadoIBSS.jsp");
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }

    protected void getCertificadosIBSS (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Connection dbCon = null;
        //LinkedList lCertificadoIBSS = new LinkedList ();
        try {
            Usuario oUser       = (Usuario) (request.getSession().getAttribute("user"));
            //System.out.println("Servlet -->  opcion       :  " +  request.getParameter ("opcion"));
            //System.out.println("ce_origen    :  " +  request.getParameter ("ce_origen"));
            //System.out.println("ce_fecha_mov :  " +  request.getParameter ("ce_fecha_mov"));
            //System.out.println("ce_cod_prod  :   " +  request.getParameter ("ce_cod_prod"));
            //System.out.println("ce_num_certificado  :   " +  request.getParameter ("ce_num_certificado"));            //
            String origen = request.getParameter ("ce_origen");
            CertificadoIBSS cIBSS = new CertificadoIBSS();                        
            if (origen.equals("filtrarCertificadoIBSS")) {
                int    iNumCertificado = Integer.parseInt (request.getParameter("ce_num_certificado"));
                cIBSS.setTipoCertificado("RE");
                cIBSS.setNumCertificado(iNumCertificado);
                dbCon = db.getConnection();
                cIBSS.getDB(dbCon);
                if (cIBSS.getiNumError() != 0 ) {
                    throw new SurException( cIBSS.getsMensError());
                }
                cIBSS.getDBConceptos(dbCon);                
            } else if (origen.equals("formResultCtaCteHis")){
                String sCodProd = request.getParameter("ce_cod_prod");
                String sFechaMov = request.getParameter ("ce_fecha_mov");
                Date dFechaEmision = null;
                if (sFechaMov == null  || sFechaMov.equals("") ) {
                    throw new Exception (" Erro al recuperar la fecha de Emision " );
                }
                try {
                    /*
                    String _yyyy= sFechaMov.substring(0,4);
                    String _MM= sFechaMov.substring(5,7);
                    String _dd= sFechaMov.substring(8,10);
                    String _fechaForm = _dd + "/" + _MM + "/" + _yyyy;
                    dFechaEmision  = Fecha.strToDate(_fechaForm);
                     *
                    */
                    dFechaEmision  = Fecha.strToDate(sFechaMov);
                    //System.out.println(" sFechaMov " + sFechaMov + " fechaout" + dFechaEmision);
                } catch (Exception e ){
                    throw new Exception (" Erro al recuperar la fecha de Emision " );
                }
                dbCon = db.getConnection();
                cIBSS.getDB(dbCon, "RE", sCodProd, dFechaEmision);
                if (cIBSS.getiNumError() != 0 ) {
                     throw new SurException( cIBSS.getsMensError());
                }
                cIBSS.getDBConceptos(dbCon);
            }
            if (cIBSS.getiNumError() != 0 ) {
                throw new SurException( cIBSS.getsMensError());
            }
            getCertificadoIBSSPdf (cIBSS,request, response);
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            db.cerrar(dbCon);
        }
    }


    // Private 
    private LinkedList getCertificadosIBSS (Connection dbCon, int pCodProd)
    throws ServletException, IOException, SurException {
        CallableStatement cons  = null;
        ResultSet rs = null;
        LinkedList lCertificadoIBSS = new LinkedList ();
        try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("CE_GET_ALL_CERTIFICADO_IBSS(?,?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setString(2, "RE" );
            cons.setInt   (3, pCodProd );
            cons.execute();
            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next()) {                    
                    CertificadoIBSS oCertifIBSS = new CertificadoIBSS();
                    oCertifIBSS.setNumCertificado (rs.getInt("NUM_CERTIFICADO"));
                    oCertifIBSS.setRazonSocial(rs.getString ("RAZON_SOCIAL"));
                    oCertifIBSS.setCodProdDC(rs.getString ("COD_PROD_DC"));
                    oCertifIBSS.setCuit(rs.getString ("CUIT"));
                    oCertifIBSS.setDomicilioCompleto(rs.getString ("DOMICILIO_COMPLETO"));
                    oCertifIBSS.setFechaEmision(rs.getDate("FECHA_EMISION"));
                    oCertifIBSS.setPeriodo(rs.getString("PERIODO"));
                    lCertificadoIBSS.add(oCertifIBSS);
                    //System.out.println(" num : " +  oCertifIBSS.getNumCertificado());
                }
                rs.close ();
            }
            return lCertificadoIBSS;
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

    private void getCertificadoIBSSPdf (CertificadoIBSS certificadoIBSS , HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException {
        Report oReport = new Report();
        try {
            oReport.setOrientacion("landscape");//// portrait = horizontal, landscape = vertical
            oReport.setTitulo       ("");
            oReport.addlObj         ("subtitulo" , "");
            oReport.setUsuario      ("user.getusuario()");
            oReport.setFecha        (Fecha.toString(new java.util.Date ()));
            oReport.setFormulario   ("NOM001");
            oReport.setReportName   (getServletContext ().getRealPath("/certificado/IBSS/report/certificadoIBSS.xml"));
            oReport.setsContextPath ( request.getScheme() + "://" + request.getHeader("host"));
            oReport.addImage        ("logo", getServletContext ().getRealPath("/images/logos/logo_beneficio_new.jpg"));
            oReport.addImage        ("firma", getServletContext ().getRealPath("/images/firmaBenef.jpg"));

            oReport.addlObj("NUM_CERTIFICADO",String.valueOf( certificadoIBSS.getNumCertificado() ));
            oReport.addlObj("RAZON_SOCIAL"   ,(certificadoIBSS.getRazonSocial()==null)? "" :certificadoIBSS.getRazonSocial());
            oReport.addlObj("COD_PROD_DC"    , (certificadoIBSS.getCodProdDC()==null) ? "" :certificadoIBSS.getCodProdDC());
            oReport.addlObj("CUIT"           , (certificadoIBSS.getCuit()==null) ? "" :certificadoIBSS.getCuit());
            oReport.addlObj("DAT0_DOMICILIO" , (certificadoIBSS.getDomicilioCompleto()==null) ? "" :certificadoIBSS.getDomicilioCompleto());
            oReport.addlObj("PERIODO" , (certificadoIBSS.getPeriodo()==null) ? "" :certificadoIBSS.getPeriodo());
            request.setAttribute("oReport", oReport );

            if ( certificadoIBSS.getConceptosIBSS() != null &&
                 certificadoIBSS.getConceptosIBSS().size() !=0) {

                oReport.addIniTabla("TABLA_CONCEPTOS");
                String sStyle[] = {"ItemCob", "ItemCobL", "ItemCobR"};
                for (int i=0; i< certificadoIBSS.getConceptosIBSS().size();i++) {
                    Concepto oConcepto = (Concepto)certificadoIBSS.getConceptosIBSS().get(i);
                    //System.out.print(" orden " + oConcepto.getOrden());
                    //System.out.println(" texto " + oConcepto.getTexto());
                    String sElem [] ={oConcepto.getTexto()};
                    oReport.addElementsTabla(sElem, sStyle);
                }
                oReport.addFinTabla();
            }    
            request.setAttribute("oReport", oReport );
            doForward (request,response, "/servlet/ReportPdf");

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        }
    }   


    // -----------------------------------------------------------------------<<
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
